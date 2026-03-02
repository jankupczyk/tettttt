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
}
