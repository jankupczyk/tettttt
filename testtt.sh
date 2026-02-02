Najprościej i najuczciwiej:
SELECT DBINFO('dbname') AS DB_NAME_LOGICAL FROM systables WHERE tabid = 1;


(alternatywa, jeśli DBINFO zablokowane):

SELECT FIRST 1 name AS DB_NAME_LOGICAL FROM systables;

2️⃣ DB_ROLE

Nie ma HDR → z definicji PRIMARY

SELECT 'PRIMARY' AS DB_ROLE FROM systables WHERE tabid = 1;


Nie ma żadnego DMV ani system table, która zwróci coś innego — bo nie może.

3️⃣ DB_ACCESS_MODE

W Informix standalone:

baza zawsze RW, chyba że admin ją ręcznie ustawił jako read-only (rzadkość)

Wariant logiczny (rekomendowany):
SELECT 'read-write' AS DB_ACCESS_MODE FROM systables WHERE tabid = 1;

Wariant defensywny (techniczny):
SELECT
CASE
    WHEN DBINFO('isreadonly') = 1 THEN 'RO'
    ELSE 'read-write'
END AS DB_ACCESS_MODE
FROM systables
WHERE tabid = 1;

4️⃣ CLUSTER_ID (LOGICZNY)

Tak samo jak w MSSQL:

➡ nie istnieje technicznie
➡ tworzysz logiczny identyfikator

Rekomendacja:
INF_<INFORMIXSERVER>

SELECT 'INF_' || DBINFO('servername') AS CLUSTER_ID
FROM systables
WHERE tabid = 1;

🔗 WSZYSTKO W JEDNYM ZAPYTANIU (FINAL – STANDALONE)

To jest docelowy wzorzec, który możesz oddać jako standard:

SELECT
    DBINFO('dbname')        AS DB_NAME_LOGICAL,
    'INF_' || DBINFO('servername') AS CLUSTER_ID,
    'PRIMARY'               AS DB_ROLE,
    CASE
        WHEN DBINFO('isreadonly') = 1 THEN 'RO'
        ELSE 'read-write'
    END                     AS DB_ACCESS_MODE
FROM systables
WHERE tabid = 1;
