-- ============================================================
-- DACA Nädal 3 — SQL JOINs
-- Roll A: Müük + Kliendid (INNER JOIN)
-- Eesmärk: leida ostnud kliendid, TOP kliendid kogumüügi järgi,
--          linnade ja lojaalsustasemete müügitulemus.
-- Tabelid: sales, customers
-- Supabase / PostgreSQL
-- ============================================================

-- ------------------------------------------------------------
-- 0. EELDUSKONTROLL
-- W3 JOINid eeldavad, et W2 puhastus on originaaltabelitesse viidud.
-- GT juhendi kontrollväärtused:
--   sales ridu peaks olema ligikaudu 10 118 - OK
--   customers.city unikaalseid väärtusi peaks olema 12 - OK
-- Kui tulemused erinevad oluliselt, kontrolli enne JOIN-analüüsi W2 puhastust.
-- ------------------------------------------------------------
SELECT COUNT(*) AS sales_ridu
FROM sales;

SELECT COUNT(DISTINCT city) AS linnu
FROM customers;

-- ------------------------------------------------------------
-- 1. LIHTNE INNER JOIN: kliendid, kes on ostnud
-- Küsimus Annalt: kes on ostnud ja millised müügiread nendega seotud on?
-- INNER JOIN näitab ainult neid müügiridu, mille customer_id leiab vaste customers tabelist.
-- ------------------------------------------------------------
SELECT
    c.first_name,
    c.last_name,
    c.email,
    c.city,
    s.sale_id,
    s.sale_date,
    s.total_price
FROM sales s
INNER JOIN customers c
    ON s.customer_id = c.customer_id
ORDER BY s.total_price DESC;
LIMIT 20;

-- ------------------------------------------------------------
-- 2. TOP 10 klienti kogumüügi järgi
-- Küsimus Annalt: kes on UrbanStyle'i parimad kliendid?
-- Vastus tekib päringu tulemuses: esimene rida on kõrgeima kogumüügiga klient.
-- ------------------------------------------------------------
SELECT
    c.first_name || ' ' || c.last_name AS klient,
    c.city,
    COUNT(DISTINCT s.sale_id) AS ostude_arv,
    SUM(s.total_price) AS kogumuuk
   FROM sales s
INNER JOIN customers c
    ON s.customer_id = c.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name,
    c.city
ORDER BY kogumuuk DESC
LIMIT 10;

-- ------------------------------------------------------------
-- 3. Müügianalüüs linnade kaupa
-- Küsimus Annalt: millisest linnast tuleb enim müüke?
-- Kommentaar tulemuse lugemiseks: ORDER BY kogumuuk DESC toob suurima müügiga linna esimeseks.
-- ------------------------------------------------------------
SELECT
    c.city AS linn,
    COUNT(DISTINCT c.customer_id) AS kliente,
    COUNT(DISTINCT s.sale_id) AS oste,
    SUM(s.total_price) AS kogumuuk
FROM sales s
INNER JOIN customers c
    ON s.customer_id = c.customer_id
GROUP BY c.city
ORDER BY kogumuuk DESC;

-- ------------------------------------------------------------
-- 4. Müük lojaalsustasemete kaupa
-- Küsimus Annalt: milline loyalty_tier on kõige väärtuslikum?
-- Kommentaar tulemuse lugemiseks: kõrgeim kogumuuk näitab suurima tuluga lojaalsusgruppi.
-- ------------------------------------------------------------
SELECT
    c.loyalty_tier,
    COUNT(DISTINCT c.customer_id) AS kliente,
    SUM(s.total_price) AS kogumüük
FROM sales s
INNER JOIN customers c
    ON s.customer_id = c.customer_id
GROUP BY c.loyalty_tier
ORDER BY kogumüük DESC;

-- ------------------------------------------------------------
-- 5. Lisakontroll: kui palju sales ridu jäi INNER JOINist välja?
-- Kui vahe on suur, võib sales tabelis olla müüke ilma kehtiva customer_id vasteta.
-- See ei ole Roll A põhiküsimus, aga aitab Toomasele andmekvaliteeti selgitada.
-- ------------------------------------------------------------
SELECT
    (SELECT COUNT(*) FROM sales) AS sales_ridu_kokku,
    (SELECT COUNT(*)
     FROM sales s
     INNER JOIN customers c ON s.customer_id = c.customer_id) AS inner_join_ridu,
    (SELECT COUNT(*) FROM sales)
    -
    (SELECT COUNT(*)
     FROM sales s
     INNER JOIN customers c ON s.customer_id = c.customer_id) AS joinist_valja_jaanud_ridu;

-- ------------------------------------------------------------
-- 6. Edasijõudnute päring: kliendid, kelle kogumüük on üle keskmise kliendimüügi
-- Kasuta ainult siis, kui baasülesanded on tehtud.
-- Ärikeel: need kliendid võivad olla VIP/lojaalsuskampaania sihtrühm.
-- ------------------------------------------------------------
SELECT
    c.first_name || ' ' || c.last_name AS klient, c.city,
    SUM(s.total_price) AS kogumüük
FROM sales s
INNER JOIN customers c
    ON s.customer_id = c.customer_id
GROUP BY
    c.customer_id, c.first_name, c.last_name, c.city
HAVING SUM(s.total_price) > (
    SELECT AVG(kliendi_müük)
    FROM (
        SELECT
            customer_id,
            SUM(total_price) AS kliendi_müük
        FROM sales
        WHERE customer_id IS NOT NULL
        GROUP BY customer_id
    ) AS keskmised
)
ORDER BY kogumüük DESC;
