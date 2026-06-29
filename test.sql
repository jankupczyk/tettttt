USE MIFIR;
SELECT i.name AS index_name, i.type_desc,
    STUFF((SELECT ', ' + c.name
        FROM sys.index_columns ic
        JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
        WHERE ic.object_id = i.object_id AND ic.index_id = i.index_id AND ic.is_included_column = 0
        ORDER BY ic.key_ordinal
        FOR XML PATH('')), 1, 2, '') AS key_columns
FROM sys.indexes i
WHERE i.object_id = OBJECT_ID('dbo.JobsSFTR');

SELECT 
    p.rows AS row_count,
    SUM(a.total_pages) * 8 / 1024 AS total_MB,
    ips.avg_fragmentation_in_percent
FROM sys.partitions p
JOIN sys.allocation_units a ON p.partition_id = a.container_id
JOIN sys.dm_db_index_physical_stats(DB_ID(), OBJECT_ID('dbo.JobsSFTR'), NULL, NULL, 'LIMITED') ips
    ON p.object_id = ips.object_id AND p.index_id = ips.index_id
WHERE p.object_id = OBJECT_ID('dbo.JobsSFTR')
GROUP BY p.rows, ips.avg_fragmentation_in_percent;

SELECT 
    migs.avg_total_user_cost * migs.avg_user_impact * (migs.user_seeks + migs.user_scans) AS improvement_measure,
    mid.equality_columns, mid.inequality_columns, mid.included_columns
FROM sys.dm_db_missing_index_groups mig
JOIN sys.dm_db_missing_index_group_stats migs ON migs.group_handle = mig.index_group_handle
JOIN sys.dm_db_missing_index_details mid ON mig.index_handle = mid.index_handle
WHERE mid.statement = '[MIFIR].[dbo].[JobsSFTR]'
ORDER BY improvement_measure DESC;

SELECT TOP 3
    qs.execution_count, qs.total_logical_reads,
    st.text AS full_query_text,
    qp.query_plan
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) st
CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) qp
WHERE st.text LIKE '%bEMailsSent%'
ORDER BY qs.total_logical_reads DESC;


USE MIFIR;
CREATE NONCLUSTERED INDEX IX_JobsSFTR_JobType_ExecuteDateTime
ON dbo.JobsSFTR (JobType, ExecuteDateTime)
INCLUDE (Id, bEMailsSent, FileModifiedOn, HashCode, ConnectionString,
         ErrorDescription, FileName, FinishedOn, FormatId, LinesCount,
         EntriesCount, InsertDate, ProcessCode, ProcessId, RequestedBy,
         StartedOn, Status, RecordsCount, SystemId, EntriesJobId)
WITH (MAXDOP = 4, SORT_IN_TEMPDB = ON);
