Import-Module WebAdministration

$logDefaults = Get-WebConfiguration -Filter "system.applicationHost/sites/siteDefaults/logFile" -PSPath IIS:\

$currentFields = $logDefaults.logExtFileFlags

if ($currentFields -notmatch "X-Forwarded-For") {
    $newFields = $currentFields + ",X-Forwarded-For"
    Set-WebConfigurationProperty -Filter "system.applicationHost/sites/siteDefaults/logFile" -PSPath IIS:\ -Name "logExtFileFlags" -Value $newFields
    Write-Host "INFOO:: Added X-Forwarded-For in the siteDefaults logFieldName: $newFields"
} else {
    Write-Host "WARN:: X-Forwarded-For already exists in the siteDefaults logFieldName"
}
