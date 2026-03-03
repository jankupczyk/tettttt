Set-WebConfigurationProperty -Filter "system.webServer/security/requestFiltering" -PSPath IIS:\ -Name "removeServerHeader" -Value $true










Get-WebConfigurationProperty -Filter "system.webServer/security/requestFiltering/fileExtensions/add" -PSPath IIS:\ -Name "." | Select-Object fileExtension, allowed
