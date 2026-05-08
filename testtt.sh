Where-Object {

    $_.PSObject.Properties['DisplayName'] -and
    $_.PSObject.Properties['DisplayVersion'] -and
    $null -ne $_.DisplayName -and
    $null -ne $_.DisplayVersion
}


function Convert-ToVersion {

    param([string]$Version)

    try {

        $cleanVersion = (
            $Version -split '[^0-9\.]'
        )[0]

        return [System.Version]$cleanVersion
    }
    catch {

        return [System.Version]'0.0.0.0'
    }
}


#requires -version 5.1

[CmdletBinding(SupportsShouldProcess)]
param(
    [switch]$WhatIf,
    [switch]$VerboseLogging
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$ConfigPath = "C:\ProgramData\EnterpriseAppUpdater\Config\applications.json"
$LockFile = "C:\ProgramData\EnterpriseAppUpdater\updater.lock"

$config = Get-Content $ConfigPath -Raw | ConvertFrom-Json

$InstallerShare = $config.Global.InstallerShare
$LogPath = $config.Global.LogPath
$RollbackPath = $config.Global.RollbackPath

function Write-Log {

    param(
        [string]$Message,
        [string]$Level = "INFO",
        [string]$AppId = "SYSTEM"
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    $line = "$timestamp [$Level] [$AppId] $Message"

    Add-Content -Path $LogPath -Value $line

    if ($VerboseLogging) {
        Write-Host $line
    }
}

if (Test-Path $LockFile) {
    Write-Log "Another instance already running." "WARN"
    exit 1
}

New-Item -ItemType File -Path $LockFile -Force | Out-Null

try {

if (!(Test-Path $InstallerShare)) {
    throw "Installer share unavailable."
}

Write-Log "Installer share available."

function Get-InstalledApplications {

    $paths = @(
        'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*',
        'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'
    )

    foreach ($path in $paths) {

        Get-ItemProperty $path -ErrorAction SilentlyContinue |
        Where-Object {
            $_.DisplayName -and $_.DisplayVersion
        } |
        Select-Object `
            DisplayName,
            DisplayVersion,
            Publisher,
            UninstallString
    }
}

$InstalledApps = Get-InstalledApplications

function Convert-ToVersion {

    param([string]$Version)

    try {
        return [System.Version]($Version -replace '[^0-9\.]', '')
    }
    catch {
        return [System.Version]'0.0.0.0'
    }
}

function Get-InstallerVersion {

    param([string]$Path)

    try {
        return (Get-Item $Path).VersionInfo.ProductVersion
    }
    catch {
        return $null
    }
}

function Test-InstallerChecksum {

    param([string]$InstallerPath)

    $checksumFile = "$InstallerPath.sha256"

    if (!(Test-Path $checksumFile)) {
        throw "Checksum file missing."
    }

    $expectedHash = (Get-Content $checksumFile).Trim()

    $actualHash = (
        Get-FileHash `
            -Path $InstallerPath `
            -Algorithm SHA256
    ).Hash

    return ($expectedHash -eq $actualHash)
}

function Test-InstallerSignature {

    param([string]$InstallerPath)

    $signature = Get-AuthenticodeSignature $InstallerPath

    return ($signature.Status -eq 'Valid')
}

function Save-RollbackMetadata {

    param(
        [string]$AppId,
        [object]$InstalledApp
    )

    $appRollback = Join-Path $RollbackPath $AppId

    if (!(Test-Path $appRollback)) {
        New-Item -ItemType Directory `
            -Path $appRollback `
            -Force | Out-Null
    }

    $metadata = @{
        DisplayName = $InstalledApp.DisplayName
        Version = $InstalledApp.DisplayVersion
        UninstallString = $InstalledApp.UninstallString
        Timestamp = Get-Date
    }

    $metadata | ConvertTo-Json |
        Set-Content "$appRollback\rollback.json"
}

function Invoke-Installer {

    param(
        [string]$InstallerPath,
        [string]$Arguments,
        [string]$InstallerType,
        [string]$AppId
    )

    Write-Log "Starting installer: $InstallerPath" "INFO" $AppId

    if ($WhatIf) {
        Write-Log "WHATIF enabled. Skipping installation." "INFO" $AppId
        return
    }

    if ($InstallerType -eq 'MSI') {

        $arguments = "/i `"$InstallerPath`" $Arguments"

        $process = Start-Process `
            -FilePath "msiexec.exe" `
            -ArgumentList $arguments `
            -Wait `
            -PassThru `
            -WindowStyle Hidden
    }
    else {

        $process = Start-Process `
            -FilePath $InstallerPath `
            -ArgumentList $Arguments `
            -Wait `
            -PassThru `
            -WindowStyle Hidden
    }

    if ($process.ExitCode -ne 0) {
        throw "Installer failed. ExitCode=$($process.ExitCode)"
    }

    Write-Log "Installation completed successfully." "INFO" $AppId
}

function Process-Application {

    param($AppConfig)

    try {

        $AppId = $AppConfig.AppId

        Write-Log "Processing application." "INFO" $AppId

        $installedApp = $InstalledApps |
            Where-Object {

                $match = $false

                foreach ($pattern in $AppConfig.DisplayNamePatterns) {

                    if ($_.DisplayName -like "*$pattern*") {
                        $match = $true
                    }
                }

                $match
            } |
            Select-Object -First 1

        if (-not $installedApp) {

            Write-Log "Application not installed." "WARN" $AppId
            return
        }

        $localVersion = Convert-ToVersion $installedApp.DisplayVersion

        $liveFolder = Join-Path `
            $InstallerShare `
            "$($AppConfig.Folder)\Live"

        if (!(Test-Path $liveFolder)) {

            Write-Log "Live folder missing." "WARN" $AppId
            return
        }

        $installer = Get-ChildItem `
            -Path $liveFolder `
            -Filter $AppConfig.SearchPattern `
            -File |
            Sort-Object LastWriteTime -Descending |
            Select-Object -First 1

        if (-not $installer) {

            Write-Log "Installer not found." "WARN" $AppId
            return
        }

        if ($config.Global.EnableChecksumValidation) {

            if (!(Test-InstallerChecksum $installer.FullName)) {

                throw "Checksum validation failed."
            }

            Write-Log "Checksum validation successful." "INFO" $AppId
        }

        if ($config.Global.EnableSignatureValidation) {

            if (!(Test-InstallerSignature $installer.FullName)) {

                throw "Digital signature validation failed."
            }

            Write-Log "Digital signature validation successful." "INFO" $AppId
        }

        $remoteVersionRaw = Get-InstallerVersion $installer.FullName

        if (-not $remoteVersionRaw) {

            Write-Log "Unable to detect installer version." "WARN" $AppId
            return
        }

        $remoteVersion = Convert-ToVersion $remoteVersionRaw

        Write-Log "Installed version: $localVersion" "INFO" $AppId
        Write-Log "Available version: $remoteVersion" "INFO" $AppId

        if ($remoteVersion -le $localVersion) {

            Write-Log "Already up to date." "INFO" $AppId
            return
        }

        if ($AppConfig.EnableRollback) {

            Save-RollbackMetadata `
                -AppId $AppId `
                -InstalledApp $installedApp
        }

        Invoke-Installer `
            -InstallerPath $installer.FullName `
            -Arguments $AppConfig.SilentArgs `
            -InstallerType $AppConfig.InstallerType `
            -AppId $AppId

        Start-Sleep -Seconds 5

        $updatedApps = Get-InstalledApplications

        $updatedApp = $updatedApps |
            Where-Object {
                $_.DisplayName -like "*$($AppConfig.DisplayNamePatterns[0])*"
            } |
            Select-Object -First 1

        if (-not $updatedApp) {

            throw "Post-install validation failed."
        }

        $newVersion = Convert-ToVersion $updatedApp.DisplayVersion

        if ($newVersion -le $localVersion) {

            throw "Version verification failed."
        }

        Write-Log "Update successful: $localVersion -> $newVersion" "INFO" $AppId
    }
    catch {

        Write-Log "$_" "ERROR" $AppId
    }
}

foreach ($app in $config.Applications) {

    if (-not $app.Enabled) {
        continue
    }

    Process-Application $app
}

Write-Log "Update cycle completed."

}
catch {

    Write-Log "$_" "ERROR"
}
finally {

    if (Test-Path $LockFile) {
        Remove-Item $LockFile -Force -ErrorAction SilentlyContinue
    }
}
