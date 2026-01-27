@echo off
set DATE=%DATE:~-4%-%DATE:~3,2%-%DATE:~0,2%
set BACKUP_DIR=C:\backup
set DB_USER=root
set MYSQLDUMP_PATH=D:\xampp\mysql\bin\mysqldump.exe

if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%"


"%MYSQLDUMP_PATH%" -u %DB_USER% --all-databases --port=3306 > "%BACKUP_DIR%\all_databases_%DATE%.sql"

powershell -Command ^
$source = "%BACKUP_DIR%\all_databases_%DATE%.sql"; ^
$dest = "%BACKUP_DIR%\all_databases_%DATE%.zip"; ^
$zip = [System.IO.Compression.ZipFile]::Open($dest,'Update'); ^
[System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip,$source,[System.IO.Path]::GetFileName($source),[System.IO.Compression.CompressionLevel]::Optimal); ^
$zip.Dispose();

del "%BACKUP_DIR%\all_databases_%DATE%.sql"

echo INFO:: BACKUP COMPLETED %BACKUP_DIR%\all_databases_%DATE%.zip
pause
