# C:\Windows\System32\inetsrv\backup\IIS_Compliance_2026-03-02
Stworzyc backup
cd C:\Windows\System32\inetsrv

.\appcmd add backup "IIS_Compliance_2026-03-02"



# restore
cd C:\Windows\System32\inetsrv

.\appcmd restore backup "IIS_Compliance_2026-03-02"

iisreset


##########################################################################################################

# 
Set-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -filter "system.applicationHost/sites/siteDefaults/logFile" -name logFormat -value "W3C"

Set-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -filter "system.applicationHost/sites/siteDefaults/logFile" -name enabled -value True

Set-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -filter "system.applicationHost/sites/siteDefaults/logFile" -name logExtFileFlags -value "Date,Time,ClientIP,UserName,SiteName,ComputerName,ServerIP,Method,UriStem,UriQuery,HttpStatus,Win32Status,BytesSent,BytesRecv,TimeTaken,ServerPort,UserAgent,HttpSubStatus,Referer,Host,Cookie"



Set-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -filter "system.web/httpCookies" -name httpOnlyCookies -value True



$newLogPath = "D:\IISLogs"
Import-Module WebAdministration
$sites = Get-ChildItem IIS:\Sites

foreach ($site in $sites) {

    Set-ItemProperty "IIS:\Sites\$($site.Name)" -Name logFile.directory -Value $newLogPath
    Write-Host "Zmieniono folder logów dla strony '$($site.Name)' na $newLogPath"

    Set-WebConfigurationProperty -Filter "system.webServer/security/requestFiltering" -PSPath "IIS:\Sites\$($site.Name)" -Name "allowHighBitCharacters" -Value $false
    Write-Host "Ustawiono allowHighBitCharacters = False dla strony '$($site.Name)'"

    Set-WebConfigurationProperty -Filter "system.webServer/security/authentication/anonymousAuthentication" -PSPath "IIS:\Sites\$($site.Name)" -Name "enabled" -Value $false
    Write-Host "Ustawiono anonymousAuthentication = False dla strony '$($site.Name)'"
}


Set-WebConfigurationProperty -Filter "system.applicationHost/sites/siteDefaults/logFile" -PSPath IIS:\ -Name "logExtFileFlags" -Value "Date,Time,ClientIP,Method,UriStem,UserAgent"
Write-Host "Zmieniono siteDefaults logFieldName na: Date,Time,ClientIP,Method,UriStem,UserAgent"
