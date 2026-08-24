-- ============================================================
-- DACA Nädal 3 — SQL JOINs
-- Roll D: Müügikanalid + Kliendid + Tooted
-- Fail: week3_roll_d_muugikanalid.sql
-- Eesmärk: võrrelda müügikanalite efektiivsust klientide,
--          linnade ja tootekategooriate lõikes.
-- Tabelid: sales, customers, products
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
-- 1. Müügikanalite väärtused sales tabelis
-- Küsimus Annalt: millised müügikanalid on andmetes olemas?
-- ------------------------------------------------------------
SELECT DISTINCT channel
FROM sales
ORDER BY channel;

-- ------------------------------------------------------------
-- 2. Kanalite põhiülevaade
-- Küsimus Annalt: milline kanal toob enim müüke ja kliente?
-- Kommentaar tulemuse lugemiseks: kogumuuk DESC näitab suurima müügiga kanali esimesena.
-- ------------------------------------------------------------
SELECT
    s.channel AS muugikanal,
    COUNT(DISTINCT s.customer_id) AS kliente,
    COUNT(DISTINCT s.sale_id) AS oste,
    ROUND(SUM(s.total_price), 2) AS kogumuuk,
    ROUND(AVG(s.total_price), 2) AS keskmine_ost
FROM sales s
GROUP BY s.channel
ORDER BY kogumuuk DESC;

-- ------------------------------------------------------------
-- 3. Müügikanal + kliendi linn
-- Küsimus Annalt: millistest linnadest kliendid milliseid kanaleid kasutavad?
-- INNER JOIN lisab sales tabelile kliendi linna customers tabelist.
-- ------------------------------------------------------------
SELECT
    s.channel AS muugikanal,
    c.city AS linn,
    COUNT(DISTINCT c.customer_id) AS kliente,
    COUNT(DISTINCT s.sale_id) AS oste,
    ROUND(SUM(s.total_price), 2) AS kogumuuk,
    ROUND(AVG(s.total_price), 2) AS keskmine_ost
FROM sales s
INNER JOIN customers c
    ON s.customer_id = c.customer_id
GROUP BY
    s.channel,
    c.city
ORDER BY
    muugikanal,
    kogumuuk DESC;

-- ------------------------------------------------------------
-- 4. Kolme tabeli JOIN: kanal + tootekategooria
-- Küsimus Annalt: millised tootekategooriad müüvad millises kanalis?
-- Tabelite roll:
--   sales    = kanal, müük, customer_id, product_id
--   customers = kliendi linn / klientide arv
--   products  = tootekategooria
-- ------------------------------------------------------------
SELECT
    s.channel AS muugikanal,
    p.category AS tootekategooria,
    COUNT(DISTINCT c.customer_id) AS kliente,
    COUNT(DISTINCT s.sale_id) AS oste,
    ROUND(SUM(s.total_price), 2) AS kogumuuk,
    ROUND(AVG(s.total_price), 2) AS keskmine_ost
FROM sales s
INNER JOIN customers c
    ON s.customer_id = c.customer_id
INNER JOIN products p
    ON s.product_id = p.product_id
GROUP BY
    s.channel,
    p.category
ORDER BY
    muugikanal,
    kogumuuk DESC;

-- ------------------------------------------------------------
-- 5. Kanali efektiivsus: müük per klient
-- Küsimus Annalt: milline kanal annab ühe kliendi kohta suurima müügi?
-- NB: see ei tõesta veel, et kanal on parem; vaja oleks ka kampaaniakulu ja ROI infot.
-- ------------------------------------------------------------
SELECT
    s.channel AS muugikanal,
    COUNT(DISTINCT s.customer_id) AS kliente,
    COUNT(DISTINCT s.sale_id) AS oste,
    ROUND(SUM(s.total_price), 2) AS kogumuuk,
    ROUND(SUM(s.total_price) / NULLIF(COUNT(DISTINCT s.customer_id), 0), 2) AS muuk_per_klient,
    ROUND(SUM(s.total_price) / NULLIF(COUNT(DISTINCT s.sale_id), 0), 2) AS muuk_per_ost
FROM sales s
GROUP BY s.channel
ORDER BY muuk_per_klient DESC;

-- ------------------------------------------------------------
-- 6. Kaupluste võrdlus: store_location + channel
-- Küsimus Annalt: kas Tallinn, Tartu ja Pärnu käituvad erinevalt?
-- Kommentaar: online müükidel võib store_location olla NULL; see on ootuspärane.
-- ------------------------------------------------------------
SELECT
    COALESCE(s.store_location, 'online / puudub poe asukoht') AS kauplus,
    s.channel AS muugikanal,
    COUNT(DISTINCT s.sale_id) AS oste,
    COUNT(DISTINCT s.customer_id) AS kliente,
    ROUND(SUM(s.total_price), 2) AS kogumuuk,
    ROUND(AVG(s.total_price), 2) AS keskmine_ost
FROM sales s
GROUP BY
    COALESCE(s.store_location, 'online / puudub poe asukoht'),
    s.channel
ORDER BY
    kauplus,
    kogumuuk DESC;

-- ------------------------------------------------------------
-- 7. Edasijõudnute päring: linn + kanal + kategooria
-- Ärikeel: aitab Annal otsustada, kas kampaaniasõnum peab erinema linna ja kanali järgi.
-- ------------------------------------------------------------
SELECT
    c.city AS linn,
    s.channel AS muugikanal,
    p.category AS tootekategooria,
    COUNT(DISTINCT c.customer_id) AS kliente,
    COUNT(DISTINCT s.sale_id) AS oste,
    ROUND(SUM(s.total_price), 2) AS kogumuuk
FROM sales s
INNER JOIN customers c
    ON s.customer_id = c.customer_id
INNER JOIN products p
    ON s.product_id = p.product_id
GROUP BY
    c.city,
    s.channel,
    p.category
ORDER BY kogumuuk DESC;
