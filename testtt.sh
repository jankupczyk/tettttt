-- c.data_test BETWEEN pierwszy i ostatni dzień poprzedniego miesiąca
WHERE c.data_test BETWEEN
    FIRST_DAY(MONTH(CURRENT - INTERVAL(1) MONTH) TO MONTH)
    AND
    LAST_DAY(MONTH(CURRENT - INTERVAL(1) MONTH) TO MONTH)
