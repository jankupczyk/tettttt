DECLARE @TableName NVARCHAR(255)
DECLARE @ColumnName NVARCHAR(255)
DECLARE @SearchStr NVARCHAR(100)
DECLARE @SQL NVARCHAR(MAX)

SET @SearchStr = 'error'  -- to, czego szukasz
SET @SQL = ''


SELECT t.name AS TableName, c.name AS ColumnName
INTO #ToSearch
FROM sys.tables t
JOIN sys.columns c ON t.object_id = c.object_id
JOIN sys.types y ON c.user_type_id = y.user_type_id
WHERE y.name IN ('char', 'nchar', 'varchar', 'nvarchar', 'text', 'ntext')


DECLARE cur CURSOR FOR SELECT TableName, ColumnName FROM #ToSearch
OPEN cur
FETCH NEXT FROM cur INTO @TableName, @ColumnName

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @SQL = @SQL + 
        'IF EXISTS (SELECT 1 FROM [' + @TableName + '] WHERE [' + @ColumnName + '] LIKE ''%' + @SearchStr + '%'') 
         PRINT ''Found in table: ' + @TableName + ', column: ' + @ColumnName + ''';' + CHAR(13)
    FETCH NEXT FROM cur INTO @TableName, @ColumnName
END

CLOSE cur
DEALLOCATE cur
DROP TABLE #ToSearch


EXEC sp_executesql @SQL
