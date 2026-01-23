#!/bin/ksh
SEARCH="TESTOWY123"
DBNAME="moja_baza"

dbaccess $DBNAME <<SQL | awk '{print $1,$2}' > columns.txt
SELECT t.tabname, c.colname
FROM systables t
JOIN syscolumns c ON t.tabid = c.tabid
WHERE c.coltype IN (0,13,17) -- CHAR, LVARCHAR, TEXT
AND t.tabid >= 100;
SQL

# sprawdz każdą kolumnę
while read table col
do
  echo "Sprawdzam $table.$col ..."
  dbaccess $DBNAME <<SQL
    SELECT "$table.$col" AS found_in
    FROM $table
    WHERE $col LIKE '%$SEARCH%'
    FIRST 1;
SQL
done
