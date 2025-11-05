SELECT
    i.idxname,
    i.tabname,
    DECODE(i.idxtype, 'U', 'UNIQUE', 'D', 'NON-UNIQUE', i.idxtype) AS index_type,
    LIST(c.colname) AS columns
FROM sysindexes i
JOIN syscolumns c
  ON c.tabid = i.tabid
 AND c.colno IN (i.part1, i.part2, i.part3, i.part4)
WHERE i.tabname = 'test'
GROUP BY 1,2,3
ORDER BY 1;


SELECT constrname, constrtype
FROM sysconstraints
WHERE tabid = (SELECT tabid FROM systables WHERE tabname = 'test');
