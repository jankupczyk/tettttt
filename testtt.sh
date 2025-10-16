-- Wiek najstarszych wierszy w bazie
SELECT datname, age(datfrozenxid) AS oldest_xid_age FROM pg_database;

-- Wiek najstarszych wierszy w tabeli
SELECT c.oid::regclass AS table_name,
       greatest(age(c.relfrozenxid), age(t.relfrozenxid)) AS oldest_xid_age
FROM pg_class c
LEFT JOIN pg_class t ON c.reltoastrelid = t.oid
WHERE c.relkind IN ('r','m');


VACUUM (FREEZE) big_table;
