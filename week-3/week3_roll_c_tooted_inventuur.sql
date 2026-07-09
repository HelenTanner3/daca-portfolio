-- ============================================================
-- DACA Nädal 3 — SQL JOINs
-- Roll C: Tooted + Inventuur (LEFT JOIN)
-- Eesmärk: leida müümata tooted, enim müüdud tooted ja inventuuri soovitused Annale ja Toomasele..
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

SELECT COUNT(DISTINCT city) AS linnu
FROM customers;

SELECT COUNT(*) AS products_ridu
FROM products;

SELECT COUNT(*) AS customers_ridu
FROM customers_test;



-- ------------------------------------------------------------
-- 1. LEFT JOIN: tooted, mida pole kunagi müüdud
-- Küsimus Annalt: millised tooted on kataloogis, aga pole müüki tekitanud?
-- Loogika:
--   products on vasak tabel, sest tahame näha kõiki tooteid.
--   Kui tootel pole sales tabelis vastet, on s.sale_id NULL.
-- ------------------------------------------------------------
SELECT
    p.product_name,
    p.category,
    p.subcategory,
    p.retail_price,
    s.sale_id
FROM products p
LEFT JOIN sales s
    ON p.product_id = s.product_id
WHERE s.sale_id IS NULL;

-- ------------------------------------------------------------
-- 2. Müümata toodete arv
-- Küsimus Annalt/Toomaselt: kui suur on müümata toodete probleem? 12 toodet mis on meil varasemast teada fantoom tooted
-- ------------------------------------------------------------
SELECT COUNT(*) AS müümata_tooteid
FROM products p
LEFT JOIN sales s
    ON p.product_id = s.product_id
WHERE s.sale_id IS NULL;

-- ------------------------------------------------------------
-- 3. TOP 10 enim müüdud toodet kogumüügi järgi
-- Küsimus Annalt: millised tooted tegelikult müüvad?
-- Kommentaar tulemuse lugemiseks: esimene rida on suurima kogumüügiga toode.
-- ------------------------------------------------------------
--3.1 Leia enim müüdud tooted:
SELECT       
    p.product_name, p.category, p.subcategory,        
    COUNT(s.sale_id) AS müüdud_kordi,        
    SUM(s.total_price) AS kogumüük    
FROM products p
    INNER JOIN sales s
     ON p.product_id = s.product_id
GROUP BY
    p.product_id, p.product_name, p.category, p.subcategory
ORDER BY kogumüük DESC
LIMIT 10;    

--3.2. Enim müüdud toodete müügikorrad ning müügikogused eraldi
SELECT
    p.product_name,
    p.category,
    p.subcategory,
    COUNT(DISTINCT s.sale_id) AS müüdud_kordi,
    SUM(s.quantity) AS müüdud_kogus,
    ROUND(SUM(s.total_price), 2) AS kogumüük,
    ROUND(AVG(s.total_price), 2) AS keskmine_ost
FROM products p
INNER JOIN sales s
    ON p.product_id = s.product_id
GROUP BY
    p.product_name,
    p.category,
    p.subcategory
ORDER BY kogumüük DESC
LIMIT 10;

-- ------------------------------------------------------------
-- 4. Müügianalüüs kategooriate kaupa
-- Küsimus Annalt: millised kategooriad on kõige edukamad?
-- LEFT JOIN säilitab ka kategooriad/tooted, millel müük puudub.
-- ------------------------------------------------------------
SELECT
         p.category,
         COUNT(DISTINCT p.product_id) AS tooteid, 
         COUNT(s.sale_id) AS müüke,        
         SUM(s.total_price) AS kogumüük    
FROM products p   
 LEFT JOIN sales s 
    ON p.product_id = s.product_id   
GROUP BY p.category   
ORDER BY kogumüük DESC;    

-- Alternatiivne päring koos AVG retail_price-ga
SELECT
    p.category,
    COUNT(DISTINCT p.product_id) AS tooteid,
    COUNT(DISTINCT s.sale_id) AS müüke,
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
-- ------------------------------------------------------------
-- Inventuur: millised tooted on laos ja kas kogus vajab tähelepanu?
5.1. Esmane
SELECT
    p.product_name, p.category, i.location, i.quantity_available, i.reorder_point,
    CASE
        WHEN i.quantity_available <= i.reorder_point THEN 'TELLI JUURDE'
        ELSE 'OK'
    END AS staatus
FROM products p
LEFT JOIN inventory i
    ON p.product_id = i.product_id
ORDER BY i.quantity_available ASC;

5.2 Täpsustatud loogika:
SELECT
    p.product_name, p.category, i.location, i.quantity_available, i.reorder_point,CASE
    WHEN i.product_id IS NULL THEN 'INVENTUUR PUUDUB'
    WHEN i.quantity_available < 0 THEN 'KONTROLLI LAOSEISU'
    WHEN i.quantity_available <= i.reorder_point THEN 'TELLI JUURDE'
    ELSE 'OK'
END AS staatus
FROM products p
LEFT JOIN inventory i
    ON p.product_id = i.product_id
ORDER BY i.quantity_available ASC;

-- ------------------------------------------------------------
-- 6. Edasijõudnute päring: Ühenda kolm tabelit - leia tooted, mis on laos, aga pole kunagi müüdud — topelt kahju (laoseis + müümata)
-- Ärikeel: need tooted seovad raha, kuid ei tekita müügitulu.
-- ------------------------------------------------------------
SELECT
    p.product_name, p.category, p.retail_price, i.quantity_available,
    (p.retail_price * i.quantity_available) AS kinni_olev_raha
FROM products p
LEFT JOIN sales s
    ON p.product_id = s.product_id
LEFT JOIN inventory i
    ON p.product_id = i.product_id
WHERE s.sale_id IS NULL
  AND i.quantity_available > 0
ORDER BY kinni_olev_raha DESC;


--Lisapäring - kontrollimaks müüke
SELECT 
    p.product_id,
    p.product_name,
    p.category,
    s.sale_id,      -- Kui siin on number, on toodet müüdud
    s.sale_date,
    i.location,     -- Kus poodides toode asub
    i.quantity_available
FROM products p
LEFT JOIN sales s ON p.product_id = s.product_id
LEFT JOIN inventory i ON p.product_id = i.product_id
ORDER BY p.product_id
LIMIT 100;

--	Äriline järeldus: kui palju raha on kinni müümata toodetes, mis laos seisavad? Mida UrbanStyle peaks nendega tegema (allahindlus? likvideerimine?)?
-- ------------------------------------------------------------
-- 6A. Ülevaru kontroll: millistel toodetel on laoseis oluliselt üle tellimispunkti?
-- Loogika:
-- reorder_point ei ole maksimaalne lubatud laoseis, vaid tellimispunkt.
-- Kui quantity_available on mitu korda suurem kui reorder_point,
-- võib see viidata ülevarule või aeglasele käibele.
-- ------------------------------------------------------------

SELECT
    p.product_name,
    p.category,
    i.location,
    i.quantity_available,
    i.reorder_point,
    i.quantity_available - i.reorder_point AS ule_tellimispunkti,
    ROUND(i.quantity_available::numeric / NULLIF(i.reorder_point, 0), 2) AS kordaja
FROM products p
INNER JOIN inventory i
    ON p.product_id = i.product_id
WHERE i.reorder_point > 0
  AND i.quantity_available >= i.reorder_point * 3
ORDER BY kordaja DESC, ule_tellimispunkti DESC;

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