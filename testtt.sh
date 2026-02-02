🔹 DB_ROLE (pewne 100%)
SELECT
CASE
  WHEN dbservername = primarysrv THEN 'PRIMARY'
  ELSE 'SECONDARY'
END AS db_role
FROM sysmaster:sysdual;

🔹 DB_ACCESS_MODE
SELECT
CASE
  WHEN dbservername = primarysrv THEN 'read-write'
  ELSE 'RO'
END AS db_access_mode
FROM sysmaster:sysdual;
