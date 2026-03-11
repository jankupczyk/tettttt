SELECT i.idxname, d.dbsname
FROM sysindexes i
JOIN systables t ON i.tabid = t.tabid
JOIN sysdbspaces d ON i.dbsnum = d.dbsnum
WHERE t.tabname = 'transaction'
AND t.owner = 'powi';



######################################################

SELECT t.tabname, d.dbsname
FROM systables t
JOIN sysdbspaces d ON t.dbsnum = d.dbsnum
WHERE t.tabname = 'transaction'
AND t.owner = 'powi';
