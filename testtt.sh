Set-WebConfigurationProperty -Filter "system.web/hosting/deployment" -PSPath IIS:\ -Name "retail" -Value $true
Write-Host "Ustawiono deployment retail=true"
