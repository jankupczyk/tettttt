WITH params AS (
    SELECT 200000000::numeric AS max_age
)

-- Wiek XID w bazach i procent do autovacuum
SELECT 
    d.datname,
    age(d.datfrozenxid) AS oldest_xid_age,
    round((age(d.datfrozenxid)::numeric / p.max_age) * 100, 2) AS percent_of_max_age
FROM pg_database d
CROSS JOIN params p
ORDER BY percent_of_max_age DESC;

-- Wiek XID w tabelach (uwzględniając TOAST) i procent
SELECT 
    c.oid::regclass AS table_name,
    greatest(age(c.relfrozenxid), age(t.relfrozenxid)) AS oldest_xid_age,
    round((greatest(age(c.relfrozenxid), age(t.relfrozenxid))::numeric / p.max_age) * 100, 2) AS percent_of_max_age
FROM pg_class c
LEFT JOIN pg_class t ON c.reltoastrelid = t.oid
CROSS JOIN params p
WHERE c.relkind IN ('r','m')
ORDER BY percent_of_max_age DESC;
