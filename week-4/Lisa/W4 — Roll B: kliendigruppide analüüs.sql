-- ============================================================
-- DACA Nädal 4 — Roll B: kliendigruppide analüüs
-- Autor: Helen Tanner | Supabase / PostgreSQL
-- Eesmärk: segmenteerida ostnud kliendid, leida TOP kliendid ning võrrelda segmentide suurust ja väärtust.
-- ============================================================

-- 1. KLIENDID KULUTUSE JÄRGI SEGMENTIDESSE
-- Eesmärk: arvutada kliendi ostukäitumine ja määrata segment.
-- Piirid: VIP >= 2000 € | Regular 500–1999,99 € | Uus < 500 €
-- RANK() on W4 juhendi edasijõudnute osa: koht oma linna sees.
WITH kliendid AS (
    SELECT c.customer_id, c.first_name || ' ' || c.last_name AS nimi,
           c.city, c.loyalty_tier, COUNT(s.sale_id) AS tellimuste_arv,
           ROUND(SUM(s.total_price), 2) AS kogukaive,
           ROUND(AVG(s.total_price), 2) AS keskmine_tellimus,
           MIN(s.sale_date) AS esimene_ost, MAX(s.sale_date) AS viimane_ost
    FROM customers c JOIN sales s ON c.customer_id = s.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name, c.city, c.loyalty_tier
), segmendid AS (
    SELECT *, CASE WHEN kogukaive >= 2000 THEN 'VIP'
                   WHEN kogukaive >= 500 THEN 'Regular'
                   ELSE 'Uus' END AS segment
    FROM kliendid
)
SELECT *, RANK() OVER (PARTITION BY city ORDER BY kogukaive DESC) AS koht_linnas
FROM segmendid
ORDER BY kogukaive DESC;


-- 2. TOP 10 KORDUVKLIENTI
-- Eesmärk: leida vähemalt kaks ostu teinud suurima käibega kliendid.
-- HAVING filtreerib kliendigrupid pärast GROUP BY-d.
SELECT c.customer_id, c.first_name || ' ' || c.last_name AS nimi,
       c.city, COUNT(s.sale_id) AS tellimuste_arv,
       ROUND(SUM(s.total_price), 2) AS kogukaive,
       ROUND(AVG(s.total_price), 2) AS keskmine_tellimus
FROM customers c JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.city
HAVING COUNT(s.sale_id) >= 2
ORDER BY kogukaive DESC
LIMIT 10;


-- 3. SEGMENTIDE KOONDSTATISTIKA JA TOP VIP-LINN
-- Eesmärk: võrrelda segmentide mahtu, käivet ja ostusagedust.
-- Piirid: VIP >= 2000 € | Regular 500–1999,99 € | Uus < 500 €
-- ChatGPT-ga koostöös lisatud: TOP VIP-linn kuvatakse samas koondis.
WITH kliendid AS (
    SELECT c.customer_id, c.city, COUNT(s.sale_id) AS tellimuste_arv,
           SUM(s.total_price) AS kogukaive
    FROM customers c JOIN sales s ON c.customer_id = s.customer_id
    GROUP BY c.customer_id, c.city
), segmendid AS (
    SELECT *, CASE WHEN kogukaive >= 2000 THEN 'VIP'
                   WHEN kogukaive >= 500 THEN 'Regular'
                   ELSE 'Uus' END AS segment
    FROM kliendid
), vip_linn AS (
    SELECT city, COUNT(*) AS vip_kliente FROM segmendid
    WHERE segment = 'VIP' GROUP BY city
    ORDER BY vip_kliente DESC, city LIMIT 1
)
SELECT segment, COUNT(*) AS kliente,
       ROUND(SUM(kogukaive), 2) AS segmendi_kaive,
       ROUND(AVG(kogukaive), 2) AS keskmine_kliendikaive,
       ROUND(AVG(tellimuste_arv), 2) AS keskmine_ostude_arv,
       CASE WHEN segment = 'VIP' THEN (SELECT city FROM vip_linn) END AS top_vip_linn,
       CASE WHEN segment = 'VIP' THEN (SELECT vip_kliente FROM vip_linn) END AS vip_kliente_linnas
FROM segmendid
GROUP BY segment
ORDER BY CASE segment WHEN 'VIP' THEN 1 WHEN 'Regular' THEN 2 ELSE 3 END;


-- ============================================================
-- LEIUD TESTITUD VÄLJUNDI PÕHJAL (n = 2551)
-- VIP:     206 klienti (8,1%), 31,3% käibest, keskmine 3978,87 €.
-- Regular: 1516 klienti (59,4%), 60,6% käibest, keskmine 1048,34 €.
-- Uus:     829 klienti (32,5%), 8,2% käibest, keskmine 257,90 €.
-- Tallinnas on enim VIP-kliente: 71.
-- Järeldus: VIP vajab hoidmist, Regular on peamine kasvupotentsiaal
-- ning Uus vajab tervitus- ja kordusostuteekonda.
-- ============================================================
-- PIIRANGUD
-- INNER JOIN hõlmab ainult ostu teinud ja customers tabeliga seotud kliente.
-- „Uus” tähendab siin väikese kogukäibega, mitte ajaliselt uut klienti.
-- Käibest ei ole eemaldatud negatiivseid tehinguid; neid oli väljundis 30.
-- Seetõttu tuleb tagastuste/paranduskannete mõju eraldi kontrollida.
-- ============================================================
