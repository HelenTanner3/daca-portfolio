-- ============================================================
-- DACA Nädal 3 — SQL JOINs
-- Roll C: Tooted + Inventuur (LEFT JOIN)
-- Fail: week3_roll_c_tooted_inventuur.sql
-- Eesmärk: leida müümata tooted, enim müüdud tooted ja laoseis.
-- Tabelid: products, sales, inventory
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

SELECT COUNT(*) AS products_ridu
FROM products;

SELECT COUNT(*) AS inventory_ridu
FROM inventory;

-- ------------------------------------------------------------
-- 1. LEFT JOIN: tooted, mida pole kunagi müüdud
-- Küsimus Annalt: millised tooted on kataloogis, aga pole müüki tekitanud?
-- Loogika:
--   products on vasak tabel, sest tahame näha kõiki tooteid.
--   Kui tootel pole sales tabelis vastet, on s.sale_id NULL.
-- ------------------------------------------------------------
SELECT
    p.product_id,
    p.product_name,
    p.category,
    p.subcategory,
    p.retail_price,
    s.sale_id
FROM products p
LEFT JOIN sales s
    ON p.product_id = s.product_id
WHERE s.sale_id IS NULL
ORDER BY p.category, p.retail_price DESC;

-- ------------------------------------------------------------
-- 2. Müümata toodete arv
-- Küsimus Annalt/Toomaselt: kui suur on müümata toodete probleem?
-- ------------------------------------------------------------
SELECT COUNT(*) AS muumata_tooteid
FROM products p
LEFT JOIN sales s
    ON p.product_id = s.product_id
WHERE s.sale_id IS NULL;

-- ------------------------------------------------------------
-- 3. TOP 10 enim müüdud toodet kogumüügi järgi
-- Küsimus Annalt: millised tooted tegelikult müüvad?
-- Kommentaar tulemuse lugemiseks: esimene rida on suurima kogumüügiga toode.
-- ------------------------------------------------------------
SELECT
    p.product_id,
    p.product_name,
    p.category,
    p.subcategory,
    COUNT(DISTINCT s.sale_id) AS muudud_kordi,
    SUM(s.quantity) AS muudud_kogus,
    ROUND(SUM(s.total_price), 2) AS kogumuuk,
    ROUND(AVG(s.total_price), 2) AS keskmine_ost
FROM products p
INNER JOIN sales s
    ON p.product_id = s.product_id
GROUP BY
    p.product_id,
    p.product_name,
    p.category,
    p.subcategory
ORDER BY kogumuuk DESC
LIMIT 10;

-- ------------------------------------------------------------
-- 4. Müük kategooriate kaupa
-- Küsimus Annalt: millised kategooriad on kõige edukamad?
-- LEFT JOIN säilitab ka kategooriad/tooted, millel müük puudub.
-- ------------------------------------------------------------
SELECT
    p.category,
    COUNT(DISTINCT p.product_id) AS tooteid,
    COUNT(DISTINCT s.sale_id) AS muuke,
    ROUND(COALESCE(SUM(s.total_price), 0), 2) AS kogumuuk,
    ROUND(AVG(p.retail_price), 2) AS keskmine_jaehind
FROM products p
LEFT JOIN sales s
    ON p.product_id = s.product_id
GROUP BY p.category
ORDER BY kogumuuk DESC;

-- ------------------------------------------------------------
-- 5. Inventuur: millised tooted on laos ja kas kogus vajab tähelepanu?
-- GT juhendi loogika: kui quantity_available <= reorder_point, märgi 'TELLI JUURDE'.
-- Kui teie inventory tabelis reorder_point puudub, eemalda i.reorder_point ja CASE plokk.
-- ------------------------------------------------------------
SELECT
    p.product_id,
    p.product_name,
    p.category,
    i.location,
    i.quantity_available,
    i.reorder_point,
    CASE
        WHEN i.quantity_available <= i.reorder_point THEN 'TELLI JUURDE'
        ELSE 'OK'
    END AS staatus
FROM products p
LEFT JOIN inventory i
    ON p.product_id = i.product_id
ORDER BY i.quantity_available ASC NULLS LAST;

-- ------------------------------------------------------------
-- 6. Edasijõudnute päring: tooted, mis on laos, aga pole kunagi müüdud
-- Ärikeel: need tooted seovad raha, kuid ei tekita müügitulu.
-- ------------------------------------------------------------
SELECT
    p.product_id,
    p.product_name,
    p.category,
    p.retail_price,
    i.location,
    i.quantity_available,
    ROUND((p.retail_price * i.quantity_available), 2) AS kinni_olev_raha
FROM products p
LEFT JOIN sales s
    ON p.product_id = s.product_id
LEFT JOIN inventory i
    ON p.product_id = i.product_id
WHERE s.sale_id IS NULL
  AND i.quantity_available > 0
ORDER BY kinni_olev_raha DESC;

-- ------------------------------------------------------------
-- 7. Koond: kinni olev raha müümata toodetes kategooriate kaupa
-- Kasulik demo jaoks, kui soovid Roll C leiu ühe numbrina kokku võtta.
-- ------------------------------------------------------------
SELECT
    p.category,
    COUNT(DISTINCT p.product_id) AS muumata_tooteid,
    SUM(i.quantity_available) AS laoseis_kokku,
    ROUND(SUM(p.retail_price * i.quantity_available), 2) AS kinni_olev_raha
FROM products p
LEFT JOIN sales s
    ON p.product_id = s.product_id
LEFT JOIN inventory i
    ON p.product_id = i.product_id
WHERE s.sale_id IS NULL
  AND i.quantity_available > 0
GROUP BY p.category
ORDER BY kinni_olev_raha DESC;
