-- Pierwszy dzień poprzedniego miesiąca
DATE(MDY(
    MONTH(CURRENT) - 1, 1, YEAR(CURRENT)
)) AS first_day_prev_month

-- Ostatni dzień poprzedniego miesiąca
DATE(MDY(
    MONTH(CURRENT), 0, YEAR(CURRENT)
)) AS last_day_prev_month
