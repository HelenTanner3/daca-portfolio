-- ============================================================
-- DACA NÄDAL 4 — SQL AGREGATSIOON
-- ROLL D: TURUNDUSKANALITE EFEKTIIVSUS
-- Autor: Helen Tanner
-- Keskkond: Supabase / PostgreSQL
-- Tabelid: sales, customers, web_logs
-- ============================================================

/*
ÄRIKÜSIMUS: millised turunduskanalid toovad kõige rohkem kliente, tellimusi ja käivet ning millistes kanalites on suurim keskmine tellimusväärtus ja müük kliendi kohta?
MÕISTEPIIRANG: andmestik võimaldab hinnata kanalite efektiivsust, kuid tegelikku ROI-d ei saa arvutada, sest kampaaniate kulud puuduvad.
ANDMEKVALITEET: analüüsis kasutatakse puhastatud ja standardiseeritud välja web_logs.source_clean.
*/

-- ############################################################
-- I OSA — GRUPITÖÖ JUHENDI JÄRGNE STRUKTUUR
-- ############################################################

-- ============================================================
-- SAMM 0 — WEB_LOGS TABELI RIDADE ARVU KONTROLL
-- ============================================================

-- Kontrollib, et web_logs tabelis oleks 50 000 rida.
SELECT COUNT(*) AS web_logide_arv
FROM web_logs;

-- ============================================================
-- PÄRING 1 — TURUNDUSKANALITE KOONDANDMED
-- ============================================================

-- Näitab standardiseeritud kanali kaupa unikaalsete klientide, tellimuste, kogukäibe ja keskmise tellimuse.
-- Märkus: otsene JOIN võib web_logs korduvate kliendikirjete tõttu müügiridu mitmekordistada; tulemust kontrollitakse II osa päringutega.

SELECT COALESCE(w.source_clean, 'unknown') AS turunduskanal,
       COUNT(DISTINCT c.customer_id) AS kliente,
       COUNT(DISTINCT o.sale_id) AS tellimusi,
       ROUND(SUM(o.total_price), 2) AS kogukaive,
       ROUND(AVG(o.total_price), 2) AS keskmine_tellimus
FROM sales o
INNER JOIN customers c ON o.customer_id = c.customer_id
LEFT JOIN web_logs w ON c.customer_id = w.customer_id
GROUP BY COALESCE(w.source_clean, 'unknown')
ORDER BY kogukaive DESC;

-- ============================================================
-- PÄRING 2 — KANALI EFEKTIIVSUS CTE ABIL
-- ============================================================
-- Esimene CTE arvutab kanali müügi, teine klientide arvu ning lõpppäring müügi kliendi kohta.
-- HAVING jätab alles kanalid, millel on vähemalt 10 tellimust.

WITH kanali_kogumüük AS (
    SELECT COALESCE(w.source_clean, 'unknown') AS turunduskanal,
           COUNT(DISTINCT o.sale_id) AS tellimusi,
           ROUND(SUM(o.total_price), 2) AS kogukaive
    FROM sales o
    INNER JOIN customers c ON o.customer_id = c.customer_id
    LEFT JOIN web_logs w ON c.customer_id = w.customer_id
    GROUP BY COALESCE(w.source_clean, 'unknown')
    HAVING COUNT(DISTINCT o.sale_id) >= 10
),
kanali_kliendid AS (
    SELECT COALESCE(w.source_clean, 'unknown') AS turunduskanal,
           COUNT(DISTINCT c.customer_id) AS kliente
    FROM sales o
    INNER JOIN customers c ON o.customer_id = c.customer_id
    LEFT JOIN web_logs w ON c.customer_id = w.customer_id
    GROUP BY COALESCE(w.source_clean, 'unknown')
)
SELECT km.turunduskanal, kk.kliente, km.tellimusi, km.kogukaive,
       ROUND(km.kogukaive / NULLIF(kk.kliente, 0), 2) AS müük_kliendi_kohta
FROM kanali_kogumüük km
INNER JOIN kanali_kliendid kk ON km.turunduskanal = kk.turunduskanal
ORDER BY müük_kliendi_kohta DESC;

-- ============================================================
-- PÄRING 3 — TURUNDUSKANALITE KUISED TRENDID
-- ============================================================

-- Näitab kuu ja standardiseeritud kanali kaupa kliente, tellimusi ja kogukäivet.
-- HAVING jätab alles kanali ja kuu kombinatsioonid, millel on vähemalt viis tellimust.

SELECT DATE_TRUNC('month', o.sale_date) AS kuu,
       COALESCE(w.source_clean, 'unknown') AS turunduskanal,
       COUNT(DISTINCT o.customer_id) AS kliente,
       COUNT(DISTINCT o.sale_id) AS tellimusi,
       ROUND(SUM(o.total_price), 2) AS kogukaive
FROM sales o
INNER JOIN customers c ON o.customer_id = c.customer_id
LEFT JOIN web_logs w ON c.customer_id = w.customer_id
GROUP BY DATE_TRUNC('month', o.sale_date), COALESCE(w.source_clean, 'unknown')
HAVING COUNT(DISTINCT o.sale_id) >= 5
ORDER BY kuu, kogukaive DESC;

-- ============================================================
-- KRISTI ESITLUSE KOONDNUMBRID
-- ============================================================

/*
Koondnumbrid tuleb uuesti arvutada valideeritud lisapäringute 6, 7 ja 9 tulemuste põhjal.
Varasemad numbrid põhinesid standardiseerimata source väärtustel ja ei ole pärast source_clean kasutuselevõttu enam lõplikud.
Tegelikku ROI-d ei saa arvutada, sest andmestikus puuduvad turunduskampaaniate kulud.
Valideeritud lahendus omistab kliendile tema viimase teadaoleva standardiseeritud kanali, mitte iga müügitehingu tegelikku kampaaniat.
*/

-- ============================================================
-- JUHENDI OSA KVALITEEDIKONTROLL
-- ============================================================

/*
[x] web_logs tabelis on 50 000 rida.
[x] source väärtused on standardiseeritud source_clean veergu.
[x] 19 algset source väärtust on koondatud 10 standardiseeritud väärtuseks.
[x] Päring 1 kasutab GROUP BY-d ja agregaatfunktsioone.
[x] Päring 2 kasutab CTE-sid ja HAVING filtrit.
[x] Päring 3 näitab kanalite kuiseid trende.
[x] Otsese JOIN-i võimalik ridade kordistumine on kontrollitud.
[ ] Kristi koondnumbrid tuleb source_clean põhjal uuesti arvutada.
*/

-- ############################################################
-- II OSA — LISAPÄRINGUD JA VALIDEERIMINE
-- ############################################################

-- ============================================================
-- LISAPÄRING 1 — WEB_LOGS TABELI STRUKTUURI KONTROLL
-- ============================================================

-- Kuvab imporditud tabeli esimesed kümme rida ja kontrollib source_clean välja olemasolu.
SELECT *
FROM web_logs
ORDER BY log_id
LIMIT 10;

-- ============================================================
-- LISAPÄRING 2 — WEB_LOGS ANDMEKVALITEEDI ÜLEVAADE
-- ============================================================

-- Näitab logide koguarvu, anonüümsete logide osakaalu, standardiseeritud kanalite arvu ja ajavahemikku.
SELECT COUNT(*) AS logisid_kokku,
       COUNT(customer_id) AS tuvastatud_kliendiga_logisid,
       COUNT(*) - COUNT(customer_id) AS anonuumseid_logisid,
       ROUND((COUNT(*) - COUNT(customer_id))::NUMERIC / NULLIF(COUNT(*), 0) * 100, 2) AS anonuumsete_osakaal_protsent,
       COUNT(DISTINCT source_clean) AS standardiseeritud_kanaleid,
       MIN(visit_date) AS esimene_kulastus,
       MAX(visit_date) AS viimane_kulastus
FROM web_logs;

-- ============================================================
-- LISAPÄRING 3 — STANDARDISEERITUD KANALITE LIIKLUS
-- ============================================================

-- Näitab standardiseeritud kanali kaupa külastusi ja tuvastatud kliente.
SELECT COALESCE(source_clean, 'unknown') AS turunduskanal,
       COUNT(*) AS kulastusi,
       COUNT(DISTINCT customer_id) AS tuvastatud_kliente
FROM web_logs
GROUP BY COALESCE(source_clean, 'unknown')
ORDER BY kulastusi DESC;

-- ============================================================
-- LISAPÄRING 4 — MITU KANALIT ON ÜHEL KLIENDIL?
-- ============================================================

-- Näitab kliente, kellel esineb mitu logirida või mitu erinevat standardiseeritud kanalit.
SELECT customer_id,
       COUNT(*) AS logiridu,
       COUNT(DISTINCT source_clean) AS erinevaid_kanaleid
FROM web_logs
WHERE customer_id IS NOT NULL
GROUP BY customer_id
HAVING COUNT(*) > 1
ORDER BY logiridu DESC, customer_id
LIMIT 20;

-- ============================================================
-- LISAPÄRING 5A — SALES KONTROLLNUMBER ENNE JOIN-I
-- ============================================================

-- Annab müügitabeli kontrollväärtused otsese JOIN-i tulemusega võrdlemiseks.
SELECT COUNT(*) AS sales_ridu,
       COUNT(DISTINCT sale_id) AS unikaalseid_muuke,
       ROUND(SUM(total_price), 2) AS sales_kogukaive
FROM sales;

-- ============================================================
-- LISAPÄRING 5B — OTSESE KOLME TABELI JOIN-I KONTROLL
-- ============================================================

-- Kui JOIN-i ridade arv ja kogukäive kasvavad, on sama müük web_logs korduvate kirjete tõttu mitmekordistunud.
SELECT COUNT(*) AS joini_ridu,
       COUNT(DISTINCT o.sale_id) AS unikaalseid_muuke,
       ROUND(SUM(o.total_price), 2) AS joini_kogukaive
FROM sales o
INNER JOIN customers c ON o.customer_id = c.customer_id
LEFT JOIN web_logs w ON c.customer_id = w.customer_id;

-- ============================================================
-- LISAPÄRING 6 — VALIDEERITUD KANALITE KOOND
-- ============================================================

-- Igale kliendile omistatakse üks standardiseeritud kanal: tema kõige hilisem teadaolev kanal.
-- Tingimus source_clean <> 'unknown' säilitab varasema loogika ega vali puuduva source väärtusega logirida kliendi kanaliks.

WITH kliendi_kanalid AS (
    SELECT customer_id, source_clean,
           ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY visit_date DESC, log_id DESC) AS rea_number
    FROM web_logs
    WHERE customer_id IS NOT NULL AND source_clean IS NOT NULL AND source_clean <> 'unknown'
),
muuk_kanaliga AS (
    SELECT o.sale_id, o.customer_id, o.total_price,
           COALESCE(kk.source_clean, 'unknown') AS turunduskanal
    FROM sales o
    LEFT JOIN kliendi_kanalid kk ON o.customer_id = kk.customer_id AND kk.rea_number = 1
)
SELECT turunduskanal,
       COUNT(DISTINCT customer_id) AS kliente,
       COUNT(DISTINCT sale_id) AS tellimusi,
       ROUND(SUM(total_price), 2) AS kogukaive,
       ROUND(SUM(total_price) / NULLIF(COUNT(DISTINCT sale_id), 0), 2) AS keskmine_tellimus
FROM muuk_kanaliga
GROUP BY turunduskanal
ORDER BY kogukaive DESC;

-- ============================================================
-- LISAPÄRING 7 — VALIDEERITUD KANALI EFEKTIIVSUS CTE ABIL
-- ============================================================
-- Näitab valideeritud kanalite müüki kliendi kohta ja keskmist tellimust; alles jäävad vähemalt kümne tellimusega kanalid.
WITH kliendi_kanalid AS (
    SELECT customer_id, source_clean,
           ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY visit_date DESC, log_id DESC) AS rea_number
    FROM web_logs
    WHERE customer_id IS NOT NULL AND source_clean IS NOT NULL AND source_clean <> 'unknown'
),
muuk_kanaliga AS (
    SELECT o.sale_id, o.customer_id, o.total_price,
           COALESCE(kk.source_clean, 'unknown') AS turunduskanal
    FROM sales o
    LEFT JOIN kliendi_kanalid kk ON o.customer_id = kk.customer_id AND kk.rea_number = 1
),
kanali_kokkuvote AS (
    SELECT turunduskanal,
           COUNT(DISTINCT customer_id) AS kliente,
           COUNT(DISTINCT sale_id) AS tellimusi,
           ROUND(SUM(total_price), 2) AS kogukaive
    FROM muuk_kanaliga
    GROUP BY turunduskanal
    HAVING COUNT(DISTINCT sale_id) >= 10
)
SELECT turunduskanal, kliente, tellimusi, kogukaive,
       ROUND(kogukaive / NULLIF(kliente, 0), 2) AS müük_kliendi_kohta,
       ROUND(kogukaive / NULLIF(tellimusi, 0), 2) AS keskmine_tellimus
FROM kanali_kokkuvote
ORDER BY müük_kliendi_kohta DESC;

-- ============================================================
-- LISAPÄRING 8 — VALIDEERITUD KUISED TRENDID
-- ============================================================

-- Kanal määratakse enne kuu järgi agregeerimist ühe korra kliendi kohta.

WITH kliendi_kanalid AS (
    SELECT customer_id, source_clean,
           ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY visit_date DESC, log_id DESC) AS rea_number
    FROM web_logs
    WHERE customer_id IS NOT NULL AND source_clean IS NOT NULL AND source_clean <> 'unknown'
),
muuk_kanaliga AS (
    SELECT o.sale_id, o.sale_date, o.customer_id, o.total_price,
           COALESCE(kk.source_clean, 'unknown') AS turunduskanal
    FROM sales o
    LEFT JOIN kliendi_kanalid kk ON o.customer_id = kk.customer_id AND kk.rea_number = 1
)
SELECT DATE_TRUNC('month', sale_date) AS kuu,
       turunduskanal,
       COUNT(DISTINCT customer_id) AS kliente,
       COUNT(DISTINCT sale_id) AS tellimusi,
       ROUND(SUM(total_price), 2) AS kogukaive
FROM muuk_kanaliga
GROUP BY DATE_TRUNC('month', sale_date), turunduskanal
HAVING COUNT(DISTINCT sale_id) >= 5
ORDER BY kuu, kogukaive DESC;

-- ============================================================
-- LISAPÄRING 9 — KUIST KUISSE KÄIBE MUUTUS
-- ============================================================
-- LAG lisab eelmise kuu käibe ning võimaldab arvutada muutuse eurodes ja protsentides.
WITH kliendi_kanalid AS (
    SELECT customer_id, source_clean,
           ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY visit_date DESC, log_id DESC) AS rea_number
    FROM web_logs
    WHERE customer_id IS NOT NULL AND source_clean IS NOT NULL AND source_clean <> 'unknown'
),
muuk_kanaliga AS (
    SELECT o.sale_id, o.sale_date, o.customer_id, o.total_price,
           COALESCE(kk.source_clean, 'unknown') AS turunduskanal
    FROM sales o
    LEFT JOIN kliendi_kanalid kk ON o.customer_id = kk.customer_id AND kk.rea_number = 1
),
kuine_kanali_müük AS (
    SELECT DATE_TRUNC('month', sale_date) AS kuu,
           turunduskanal,
           COUNT(DISTINCT sale_id) AS tellimusi,
           ROUND(SUM(total_price), 2) AS kogukaive
    FROM muuk_kanaliga
    GROUP BY DATE_TRUNC('month', sale_date), turunduskanal
    HAVING COUNT(DISTINCT sale_id) >= 5
),
kuine_muutus AS (
    SELECT kuu, turunduskanal, tellimusi, kogukaive,
           LAG(kogukaive) OVER (PARTITION BY turunduskanal ORDER BY kuu) AS eelmise_kuu_kaive
    FROM kuine_kanali_müük
)
SELECT kuu, turunduskanal, tellimusi, kogukaive, eelmise_kuu_kaive,
       ROUND(kogukaive - eelmise_kuu_kaive, 2) AS muutus_eurodes,
       ROUND((kogukaive - eelmise_kuu_kaive) / NULLIF(eelmise_kuu_kaive, 0) * 100, 1) AS muutus_protsent
FROM kuine_muutus
ORDER BY turunduskanal, kuu;

-- ============================================================
-- LISAPÄRING 10 — ROLL A RISTKONTROLL KUUD KAUPA
-- ============================================================

-- Roll D kuude kogusummad peavad ühtima Roll A sales-tabeli koondiga, kui kasutatakse sama perioodi ja filtreid.
SELECT DATE_TRUNC('month', sale_date) AS kuu,
       COUNT(DISTINCT sale_id) AS tellimusi,
       ROUND(SUM(total_price), 2) AS kogukaive,
       ROUND(SUM(total_price) / NULLIF(COUNT(DISTINCT sale_id), 0), 2) AS keskmine_tellimus
FROM sales
GROUP BY DATE_TRUNC('month', sale_date)
ORDER BY kuu;
