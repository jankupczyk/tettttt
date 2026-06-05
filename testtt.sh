SELECT 
    DB_NAME(database_id) AS baza,
    OBJECT_NAME(object_id) AS procedura
FROM sys.objects  -- to nie zadziała cross-db, użyj poniższego


EXEC sp_MSforeachdb '
USE [?];
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = ''REP_P_run'' AND type = ''P'')
    SELECT ''?'' AS baza, name FROM sys.objects WHERE name = ''REP_P_run''
'


SELECT step_name, database_name, command
FROM msdb.dbo.sysjobsteps
WHERE job_id = 'DE1CCBCA-6A80-453D-B0CD-3BA1F63A03DF'
