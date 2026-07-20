SELECT MIN(a.id_wyc_trans + 1) 
FROM wyc_trans a 
WHERE NOT EXISTS (SELECT 1 FROM wyc_trans b WHERE b.id_wyc_trans = a.id_wyc_trans + 1)
AND a.id_wyc_trans < 81128992;
