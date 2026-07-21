-- ============================================================
-- DACA Nädal 5 — Roll A: CEO dashboard
-- Autor: Helen Tanner
-- Andmebaas: Supabase / PostgreSQL
-- Eesmärk: dashboard'i lähteandmed ja referentskontrollid
-- ============================================================

-- OLULINE
-- 1. Kontrolli enne kasutamist, milline sales tabeliversioon on õige.
-- 2. Dokumenteeri analüüsiperiood.
-- 3. Otsusta ja dokumenteeri, kuidas käsitleda negatiivseid tehinguid.
-- 4. Ära kasuta JOIN-i järel SUM() väärtusi enne kardinaalsuse kontrolli.


-- 1. SALES REFERENTSVÄÄRTUSED

SELECT
    COUNT(*) AS sales_rows,
    COUNT(DISTINCT sale_id) AS unique_sales,
    SUM(total_price) AS total_revenue,
    MIN(sale_date) AS first_sale_date,
    MAX(sale_date) AS last_sale_date,
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS rows_without_customer,
    COUNT(*) FILTER (WHERE customer_id IS NOT NULL) AS rows_with_customer
FROM sales;


-- 2. UNIKAALSED KLIENDID

SELECT
    COUNT(DISTINCT customer_id)
        FILTER (WHERE customer_id IS NOT NULL) AS unique_customers
FROM sales;


-- 3. MÜÜGITULU KUUD LÕIKES

SELECT
    DATE_TRUNC('month', sale_date)::date AS month,
    COUNT(DISTINCT sale_id) AS orders,
    SUM(total_price) AS revenue
FROM sales
GROUP BY DATE_TRUNC('month', sale_date)::date
ORDER BY month;


-- 4. MÜÜGITULU AASTATE LÕIKES

SELECT
    EXTRACT(YEAR FROM sale_date)::int AS year,
    COUNT(DISTINCT sale_id) AS orders,
    COUNT(DISTINCT customer_id)
        FILTER (WHERE customer_id IS NOT NULL) AS unique_customers,
    SUM(total_price) AS revenue
FROM sales
GROUP BY EXTRACT(YEAR FROM sale_date)::int
ORDER BY year;


-- 5. AASTANE KÄIBEKASV

WITH yearly_revenue AS (
    SELECT
        EXTRACT(YEAR FROM sale_date)::int AS year,
        SUM(total_price) AS revenue
    FROM sales
    GROUP BY EXTRACT(YEAR FROM sale_date)::int
),
yearly_comparison AS (
    SELECT
        year,
        revenue,
        LAG(revenue) OVER (ORDER BY year) AS previous_year_revenue
    FROM yearly_revenue
)
SELECT
    year,
    revenue,
    previous_year_revenue,
    ROUND(
        100.0 * (revenue - previous_year_revenue)
        / NULLIF(previous_year_revenue, 0),
        2
    ) AS revenue_growth_pct
FROM yearly_comparison
ORDER BY year;


-- 6. KESKMINE TELLIMUSE VÄÄRTUS

SELECT
    SUM(total_price)
        / NULLIF(COUNT(DISTINCT sale_id), 0) AS average_order_value
FROM sales;


-- 7. POWER BI KOONTABEL

SELECT
    DATE_TRUNC('month', sale_date)::date AS month,
    COUNT(DISTINCT sale_id) AS orders,
    COUNT(DISTINCT customer_id)
        FILTER (WHERE customer_id IS NOT NULL) AS unique_customers,
    SUM(total_price) AS revenue,
    SUM(total_price)
        / NULLIF(COUNT(DISTINCT sale_id), 0) AS average_order_value
FROM sales
GROUP BY DATE_TRUNC('month', sale_date)::date
ORDER BY month;


-- 8. LÕPPKONTROLL

-- TODO: kontrollpäring 1
-- TODO: kontrollpäring 2