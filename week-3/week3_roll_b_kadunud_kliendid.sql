-- ============================================================
-- DACA Nädal 3 — SQL JOINs
-- Roll B: Kliendid ilma ostudeta (LEFT JOIN + WHERE IS NULL)
-- Fail: week3_roll_b_kadunud_kliendid.sql
-- Eesmärk: leida registreerunud kliendid, kellel pole ühtegi ostu.
-- Tabelid: customers, sales
-- Supabase / PostgreSQL
-- ============================================================

-- ------------------------------------------------------------
-- 0. EELDUSKONTROLL
-- W3 JOINid eeldavad, et W2 puhastus on originaaltabelitesse viidud.
-- GT juhendi kontrollväärtused:
--   sales ridu peaks olema ligikaudu 10 118
--   customers.city unikaalseid väärtusi peaks olema 12
-- ------------------------------------------------------------
SELECT COUNT(*) AS sales_ridu
FROM sales;

SELECT COUNT(DISTINCT city) AS linnu
FROM customers;

-- ------------------------------------------------------------
-- 1. LEFT JOIN: kliendid, kellel pole ühtegi ostu
-- Küsimus Annalt: kes registreerus, aga pole kunagi midagi ostnud?
-- Loogika:
--   LEFT JOIN säilitab kõik customers tabeli read.
--   Kui kliendil pole sales tabelis vastet, on s.sale_id NULL.
--   WHERE s.sale_id IS NULL jätab alles ainult ostuta kliendid.
-- ------------------------------------------------------------
SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name AS klient,
    c.email,
    c.city,
    c.registration_date,
    c.loyalty_tier
FROM customers c
LEFT JOIN sales s
    ON c.customer_id = s.customer_id
WHERE s.sale_id IS NULL
ORDER BY c.registration_date DESC;

-- ------------------------------------------------------------
-- 2. Kadunud klientide arv
-- GT materjalis on AI-vihje näitena mainitud 47 kadunud klienti.
-- Kontrolli oma Supabase tulemuse põhjal; arv võib erineda, kui puhastus ei ole sama seisuga.
-- ------------------------------------------------------------
SELECT COUNT(*) AS kadunud_kliente
FROM customers c
LEFT JOIN sales s
    ON c.customer_id = s.customer_id
WHERE s.sale_id IS NULL;

-- ------------------------------------------------------------
-- 3. Kadunud kliendid linnade kaupa
-- Küsimus Annalt: millistes linnades on enim ostuta registreerunud kliente?
-- Kommentaar tulemuse lugemiseks: esimene rida näitab suurimat tagasivõitmise potentsiaali linna järgi.
-- ------------------------------------------------------------
SELECT
    c.city AS linn,
    COUNT(*) AS kadunud_kliente
FROM customers c
LEFT JOIN sales s
    ON c.customer_id = s.customer_id
WHERE s.sale_id IS NULL
GROUP BY c.city
ORDER BY kadunud_kliente DESC;

-- ------------------------------------------------------------
-- 4. Kadunud kliendid registreerimise kuupäeva järgi
-- Küsimus Annalt: kas need kliendid registreerusid hiljuti või on nad ammu passiivsed?
-- Ärikeel: hiljutistele sobib tervituskampaania; vanematele taasaktiveerimise kampaania.
-- ------------------------------------------------------------
SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name AS klient,
    c.registration_date,
    c.city,
    c.loyalty_tier,
    c.email
FROM customers c
LEFT JOIN sales s
    ON c.customer_id = s.customer_id
WHERE s.sale_id IS NULL
ORDER BY c.registration_date DESC;

-- ------------------------------------------------------------
-- 5. Kadunud vs aktiivsed kliendid
-- Küsimus Annalt: kui suur osa kliendibaasist on ostnud vs pole ostnud?
-- NB: COUNT(DISTINCT c.customer_id) hoiab ära aktiivsete klientide mitmekordse lugemise.
-- ------------------------------------------------------------
SELECT
    CASE
        WHEN s.sale_id IS NULL THEN 'Kadunud (pole ostnud)'
        ELSE 'Aktiivne (on ostnud)'
    END AS staatus,
    COUNT(DISTINCT c.customer_id) AS kliente
FROM customers c
LEFT JOIN sales s
    ON c.customer_id = s.customer_id
GROUP BY
    CASE
        WHEN s.sale_id IS NULL THEN 'Kadunud (pole ostnud)'
        ELSE 'Aktiivne (on ostnud)'
    END
ORDER BY kliente DESC;

-- ------------------------------------------------------------
-- 6. Edasijõudnute päring: kadunud kliendid registreerimiskuu kaupa
-- Ärikeel: kui mõnel kuul registreerus palju ostuta kliente,
-- võib see viidata kampaaniale, mis tõi registreerumisi, kuid mitte oste.
-- ------------------------------------------------------------
SELECT
    DATE_TRUNC('month', c.registration_date) AS registreerimis_kuu,
    COUNT(*) AS kadunud_kliente
FROM customers c
LEFT JOIN sales s
    ON c.customer_id = s.customer_id
WHERE s.sale_id IS NULL
GROUP BY DATE_TRUNC('month', c.registration_date)
ORDER BY registreerimis_kuu;
