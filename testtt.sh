SQL:
SELECT name AS DB_NAME_LOGICAL
FROM sysdatabases
WHERE is_default = 't';


Jeśli nie używacie default:

SELECT name AS DB_NAME_LOGICAL
FROM sysdatabases
WHERE name NOT IN ('sysmaster','sysutils','sysadmin');

2️⃣ DB_ROLE (PRIMARY / SECONDARY / STANDBY)
ŹRÓDŁO PRAWDY: sysmaster
SELECT
CASE
    WHEN dbservername = primarysrv THEN 'PRIMARY'
    WHEN dbservername = sds_primary THEN 'SECONDARY'
    ELSE 'STANDBY'
END AS DB_ROLE
FROM sysmaster:sysdual;

Co to oznacza:

PRIMARY → HDR primary

SECONDARY → SDS (read-only, hot)

STANDBY → RSS (cold / delayed)

3️⃣ DB_ACCESS_MODE

Tu Informix jest najuczciwszy ze wszystkich DB:

SELECT
CASE
    WHEN dbservername = primarysrv THEN 'read-write'
    ELSE 'RO'
END AS DB_ACCESS_MODE
FROM sysmaster:sysdual;


PRIMARY → RW

SDS / RSS → RO

4️⃣ CLUSTER_ID

Informix nie ma technicznego cluster_id, więc robimy to jak profesjonaliści.

Najlepsza praktyka:
CLUSTER_ID = HDR_<PRIMARY_SERVERNAME>

SQL:
SELECT
'HDR_' || primarysrv AS CLUSTER_ID
FROM sysmaster:sysdual;


Ten sam wynik:

na primary

na SDS

na RSS

✔️ jednoznaczny
✔️ stały
✔️ audytowo poprawny

🔗 WSZYSTKO W JEDNYM ZAPYTANIU (FINAL)

To jest docelowy wzorzec:

SELECT
    (SELECT name
     FROM sysdatabases
     WHERE is_default = 't')            AS DB_NAME_LOGICAL,

    'HDR_' || primarysrv                AS CLUSTER_ID,

    CASE
        WHEN dbservername = primarysrv THEN 'PRIMARY'
        WHEN dbservername = sds_primary THEN 'SECONDARY'
        ELSE 'STANDBY'
    END                                 AS DB_ROLE,

    CASE
        WHEN dbservername = primarysrv THEN 'read-write'
        ELSE 'RO'
    END                                 AS DB_ACCESS_MODE
FROM sysmaster:sysdual;
