-- Wiek XID w bazach i procent do autovacuum
SELECT 
    datname,
    age(datfrozenxid) AS oldest_xid_age,
    round((age(datfrozenxid)::numeric / 200000000) * 100, 2) AS percent_of_max_age
FROM pg_database
ORDER BY percent_of_max_age DESC;

-- Wiek XID w tabelach (uwzględniając TOAST) i procent
SELECT 
    c.oid::regclass AS table_name,
    greatest(age(c.relfrozenxid), age(t.relfrozenxid)) AS oldest_xid_age,
    round((greatest(age(c.relfrozenxid), age(t.relfrozenxid))::numeric / 200000000) * 100, 2) AS percent_of_max_age
FROM pg_class c
LEFT JOIN pg_class t ON c.reltoastrelid = t.oid
WHERE c.relkind IN ('r','m')
ORDER BY percent_of_max_age DESC;
