DECLARE @search NVARCHAR(100) = '%German%'
DECLARE @sql NVARCHAR(MAX) = ''

SELECT @sql += 'SELECT ''' + t.TABLE_SCHEMA + '.' + t.TABLE_NAME + '.' + c.COLUMN_NAME + ''' AS lokalizacja, CAST(' + QUOTENAME(c.COLUMN_NAME) + ' AS NVARCHAR(MAX)) AS wartosc FROM ' + QUOTENAME(t.TABLE_SCHEMA) + '.' + QUOTENAME(t.TABLE_NAME) + ' WHERE ' + QUOTENAME(c.COLUMN_NAME) + ' LIKE ' + '''' + @search + '''' + ' UNION ALL '
FROM INFORMATION_SCHEMA.TABLES t
JOIN INFORMATION_SCHEMA.COLUMNS c ON t.TABLE_NAME = c.TABLE_NAME AND t.TABLE_SCHEMA = c.TABLE_SCHEMA
WHERE t.TABLE_TYPE = 'BASE TABLE'
AND c.DATA_TYPE IN ('char','nchar','varchar','nvarchar','text','ntext')

-- Usuń ostatnie UNION ALL
SET @sql = LEFT(@sql, LEN(@sql) - 10)

EXEC sp_executesql @sql
