🔹 DB_ROLE
SELECT
CASE
  WHEN pg_is_in_recovery() = false THEN 'PRIMARY'
  ELSE 'SECONDARY'
END AS db_role;

🔹 DB_ACCESS_MODE
SELECT
CASE
  WHEN pg_is_in_recovery() = false THEN 'read-write'
  ELSE 'RO'
END AS db_access_mode;
