-- 1. Parametry
-- Sprawdź swoją wartość w postgresql.conf
SHOW autovacuum_freeze_max_age;

-- Załóżmy wynik np. 200000000
\set max_age 200000000

-- 2. Wiek XID w bazach i procent wykorzystania
SELECT 
    datname,
    age(datfrozenxid) AS oldest_xid_age,
    round((age(datfrozenxid)::numeric / :max_age) * 100, 2) AS percent_of_max_age
FROM pg_database
ORDER BY percent_of_max_age DESC;

-- 3. Wiek XID w tabelach (uwzględniając TOAST) i procent
SELECT 
    c.oid::regclass AS table_name,
    greatest(age(c.relfrozenxid), age(t.relfrozenxid)) AS oldest_xid_age,
    round((greatest(age(c.relfrozenxid), age(t.relfrozenxid))::numeric / :max_age) * 100, 2) AS percent_of_max_age
FROM pg_class c
LEFT JOIN pg_class t ON c.reltoastrelid = t.oid
WHERE c.relkind IN ('r','m')
ORDER BY percent_of_max_age DESC;
