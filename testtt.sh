@echo off
set DATE=%DATE:~-4%-%DATE:~3,2%-%DATE:~0,2%
set BACKUP_DIR=C:\backup
set DB_USER=root
set MYSQLDUMP_PATH=C:\xampp\mysql\bin\mysqldump.exe

if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%"

"%MYSQLDUMP_PATH%" -u %DB_USER% --all-databases --port=3306 > "%BACKUP_DIR%\all_databases_%DATE%.sql"

powershell Compress-Archive "%BACKUP_DIR%\all_databases_%DATE%.sql" "%BACKUP_DIR%\all_databases_%DATE%.zip" -Force

del "%BACKUP_DIR%\all_databases_%DATE%.sql"
pause
