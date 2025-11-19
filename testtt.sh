$targetFullName = "Jan Kowalski"

$logins = net user /domain | ForEach-Object { $_.Trim() } | Where-Object { $_ -and $_ -notmatch "User.*accounts|---" }

foreach ($login in $logins) {
    $details = net user $login /domain 2>$null
    foreach ($line in $details) {
        if ($line -match "^Pełna nazwa\s*:\s*(.*)$") {
            $full = $matches[1].Trim()
            if ($full -eq $targetFullName) {
                Write-Host "$login : $targetFullName"
            }
        }
    }
}
