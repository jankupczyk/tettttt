SELECT DB_NAME() AS DB_NAME_LOGICAL;
Jeśli chcesz wszystkie bazy w AG:

SELECT name AS DB_NAME_LOGICAL
FROM sys.databases
WHERE database_id > 4;
2️⃣ CLUSTER_ID
🔹 AlwaysOn Availability Group
To jest idealny CLUSTER_ID – jeden, wspólny na wszystkie węzły.

SELECT name AS CLUSTER_ID
FROM sys.availability_groups;
Jeśli masz kilka AG → filtrujesz po DB_NAME_LOGICAL.

3️⃣ DB_ROLE
Rola tego węzła dla danej bazy:

SELECT
CASE
    WHEN rs.role_desc = 'PRIMARY' THEN 'PRIMARY'
    ELSE 'SECONDARY'
END AS DB_ROLE
FROM sys.dm_hadr_availability_replica_states rs
WHERE rs.is_local = 1;
4️⃣ DB_ACCESS_MODE
Najbezpieczniej nie zgadywać, tylko brać z roli:

SELECT
CASE
    WHEN rs.role_desc = 'PRIMARY' THEN 'read-write'
    ELSE 'RO'
END AS DB_ACCESS_MODE
FROM sys.dm_hadr_availability_replica_states rs
WHERE rs.is_local = 1;
🔗 Wszystko w JEDNYM zapytaniu (PROD-READY)
To jest to, co realnie bym wdrożył:

SELECT
    d.name                                   AS DB_NAME_LOGICAL,
    ag.name                                  AS CLUSTER_ID,
    CASE
        WHEN rs.role_desc = 'PRIMARY' THEN 'PRIMARY'
        ELSE 'SECONDARY'
    END                                      AS DB_ROLE,
    CASE
        WHEN rs.role_desc = 'PRIMARY' THEN 'read-write'
        ELSE 'RO'
    END                                      AS DB_ACCESS_MODE
FROM sys.databases d
JOIN sys.availability_databases_cluster adc
    ON d.name = adc.database_name
JOIN sys.availability_groups ag
    ON adc.group_id = ag.group_id
JOIN sys.dm_hadr_availability_replica_states rs
    ON ag.group_id = rs.group_id
WHERE rs.is_local = 1;
