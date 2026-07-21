-- 1. Wybierz "młodszy" rekord z każdej pary duplikatów (do przenumerowania)
CREATE TABLE tmp_do_przenumerowania (
  old_id INTEGER,
  rowid_val INTEGER,  -- albo unikalny identyfikator fizycznego wiersza
  new_id INTEGER
);

-- 2. Wstaw kandydatów do przenumerowania z numeracją sekwencyjną
INSERT INTO tmp_do_przenumerowania (old_id, rowid_val)
SELECT id_wyc_trans, rowid
FROM wyc_trans t
WHERE id_wyc_trans IN (SELECT id_wyc_trans FROM wyc_trans GROUP BY id_wyc_trans HAVING COUNT(*) > 1)
AND data_wal = (SELECT MAX(data_wal) FROM wyc_trans t2 WHERE t2.id_wyc_trans = t.id_wyc_trans); 
-- ^ bierze "młodszy" wiersz z pary po dacie - dostosuj kryterium do ustalonej zasady

-- 3. Nadaj nowe ID sekwencyjnie zaczynając od bezpiecznego punktu
UPDATE tmp_do_przenumerowania 
SET new_id = 85000001 + (SELECT COUNT(*) FROM tmp_do_przenumerowania t2 WHERE t2.rowid_val <= tmp_do_przenumerowania.rowid_val) - 1;
-- to może być wolne przy 12 mln - lepiej zrobić przez unload/load z numeracją w skrypcie zewnętrznym (perl/python/awk)

-- 4. Wykonaj UPDATE hurtowo używając rowid jako klucza fizycznego
UPDATE wyc_trans 
SET id_wyc_trans = (SELECT new_id FROM tmp_do_przenumerowania WHERE rowid_val = wyc_trans.rowid)
WHERE rowid IN (SELECT rowid_val FROM tmp_do_przenumerowania);
