SELECT
    st.tabname   AS child_table,
    sc.constrname,
    sc.constrtype
FROM sysconstraints sc
JOIN systables st ON sc.tabid = st.tabid
WHERE sc.constrtype = 'R'
AND sc.primary = (
    SELECT constrid
    FROM sysconstraints
    WHERE constrtype = 'P'
    AND tabid = (
        SELECT tabid FROM systables WHERE tabname = 'temp_mail'
    )
);
