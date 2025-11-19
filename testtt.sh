$fullname = ""

net user /domain | ForEach-Object {
    $u = $_.Trim()
    if ($u -and $u -notmatch "User.*accounts" -and $u -notmatch "---") {
        $details = net user "$u" /domain 2>$null
        if ($details -match "Pełna nazwa\s*:\s*(.*)") {
            $full = $matches[1].Trim()
            if ($full -eq $fullname) {
                Write-Host "$fullname -> $u"
            }
        }
    }
}
