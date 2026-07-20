-- KROK 1: Zrzucenie 2 najnowszych rekordów sprzed 5 dni do pamięci tymczasowej (zabezpieczenie danych)
SELECT * FROM "drogal".wyc_trans WHERE id_wyc_trans = 2147483647 INTO TEMP bufor_trans;

-- KROK 2: Usunięcie zablokowanych punktów o maksymalnym ID z tabeli głównej
DELETE FROM "drogal".wyc_trans WHERE id_wyc_trans = 2147483647;

-- KROK 3: Przestawienie licznika SERIAL na czystą, zweryfikowaną pozycję 85 milionów
ALTER TABLE "drogal".wyc_trans MODIFY (id_wyc_trans SERIAL(85000000));

-- KROK 4: Wstawienie danych z powrotem na stałe do tabeli "drogal".wyc_trans.
-- Wartość '0' sprawi, że baza automatycznie nada im unikalne ID: 85000000 i 85000001
INSERT INTO "drogal".wyc_trans (id_wyc_trans, id_wyc, id_match_inst, l_s, refer1, refer2, refer3, d_c, kwota, data_wal, typ, data_ks, status_trans)
SELECT 0, id_wyc, id_match_inst, l_s, refer1, refer2, refer3, d_c, kwota, data_wal, typ, data_ks, status_trans 
FROM bufor_trans;
