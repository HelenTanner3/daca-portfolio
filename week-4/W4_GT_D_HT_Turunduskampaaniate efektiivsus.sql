-- ============================================================
-- DACA NÄDAL 4 — SQL AGREGATSIOON
-- ROLL D: TURUNDUSKAMPAANIATE EFEKTIIVSUS
-- Autor: Helen Tanner
-- Keskkond: Supabase / PostgreSQL
-- Tabelid: sales, customers, web_logs
-- ============================================================
--
-- ÄRIKÜSIMUS
-- Millised turunduskanalid toovad kõige rohkem kliente, tellimusi ja käivet ning millistes kanalites on suurim keskmine tellimusväärtus ja müük kliendi kohta?
--
-- MÕISTEPIIRANG
-- Andmestik võimaldab hinnata kanalite efektiivsust.
-- Tegelikku ROI-d ei saa arvutada, sest kampaaniate kulud andmestikus puuduvad.


-- ############################################################
-- I OSA. GRUPITÖÖ JUHENDI JÄRGNE STRUKTUUR
-- ############################################################


-- ============================================================
-- SAMM 0 — WEB_LOGS CSV IMPORT JA JUHENDI KONTROLL -- OK, TULEMUS ON 50 000
-- ============================================================
-- CSV import tehakse Supabase Table Editoris.
-- Juhendi järgi peaks web_logs tabelis olema ligikaudu
-- 50 000 rida.

SELECT
    COUNT(*) AS web_logide_arv
FROM web_logs;


-- ============================================================
-- PÄRING 1 — TURUNDUSKANALITE KOONDANDMED
-- ============================================================
-- Juhendi ülesanne: ühenda sales, customers ja web_logs ning näita kanali kaupa:
-- 1) unikaalsete klientide arv;
-- 2) tellimuste arv;
-- 3) kogukäive;
-- 4) keskmine tellimusväärtus.
--
-- Märkus:
-- see päring järgib grupitöö juhendis antud Shu-malli.
-- Tulemuse tehniline valideerimine on II osa lisapäringutes.

SELECT
    COALESCE(w.source, 'Tundmatu / kanal puudub')      -- COALESCE tagastab esimese mitte-NULL väärtuse. Kui w.source on NULL, kuvatakse selle asemel 'Tundmatu / kanal puudub'.
    AS turunduskanal,                                  -- AS turunduskanal annab tulemuse veerule aliase.                                                                
    COUNT(DISTINCT c.customer_id) AS kliente,          -- COUNT(DISTINCT ...) loendab unikaalsed mitte-NULL customer_id väärtused.
    COUNT(DISTINCT o.sale_id) AS tellimusi,            -- COUNT(DISTINCT ...) loendab unikaalsed mitte-NULL sale_id väärtused.
    ROUND(SUM(o.total_price), 2) AS kogukaive,         -- SUM liidab total_price väärtused kokku ja seejärel ROUND ümardab saadud kogukäibe kahe komakohani.
    ROUND(AVG(o.total_price), 2) AS keskmine_tellimus  -- AVG arvutab total_price väärtuste aritmeetilise keskmise ja seejärel ROUND ümardab saadud keskmise kahe komakohani
FROM sales o                                           -- Sales on päringu lähtetabel; o on tabeli alias.
JOIN customers c                                       -- JOIN tähendab siin INNER JOIN-i. Customers tabelile antakse alias c.
    ON o.customer_id = c.customer_id                   -- Sales ja customers ühendatakse customer_id alusel. Tulemusse jäävad ainult read, mille customer_id leidub mõlemas tabelis.
LEFT JOIN web_logs w                                   -- LEFT JOIN säilitab kõik o ja c ühenduse tulemusread. Web_logs tabelist lisatakse vastavad read, vaste puudumisel on tabelis neil ridadel NULL.d
    ON c.customer_id = w.customer_id                   -- Customers ja web_logs ühendatakse customer_id alusel.
GROUP BY COALESCE(w.source, 'Tundmatu / kanal puudub') -- Tulemused grupeeritakse turunduskanali järgi. NULL source väärtused moodustavad grupi 'Tundmatu / kanal puudub'
ORDER BY kogukaive DESC;                               -- Tulemused sorteeritakse kogukäibe järgi kahanevalt.


-- ============================================================
-- PÄRING 2 — KANALI EFEKTIIVSUS CTE ABIL
-- ============================================================
-- CTE 1 arvutab kanali kogumüügi; CTE 2 arvutab kanali unikaalsete klientide arvu; lõpppäring arvutab müügi kliendi kohta.
-- HAVING piir: vähemalt 10 tellimust kanali kohta (Piir vähendab väga väikese valimiga kanalite mõju)

WITH kanali_kogumüük AS (
    SELECT
        COALESCE(w.source, 'Tundmatu / kanal puudub') AS turunduskanal,
        ROUND(SUM(o.total_price), 2) AS kogukaive
    FROM sales o
    INNER JOIN customers c      
     ON o.customer_id = c.customer_id
    LEFT JOIN web_logs w        
     ON c.customer_id = w.customer_id
    GROUP BY COALESCE(w.source, 'Tundmatu / kanal puudub')
    HAVING COUNT(DISTINCT o.sale_id) >= 10
),
kanali_kliendid AS (
    SELECT
        COALESCE(w.source, 'Tundmatu / kanal puudub') AS turunduskanal,
        COUNT(DISTINCT c.customer_id) AS kliente
    FROM sales o
    INNER JOIN customers c     
     ON o.customer_id = c.customer_id
    LEFT JOIN web_logs w       
     ON c.customer_id = w.customer_id
    GROUP BY COALESCE(w.source, 'Tundmatu / kanal puudub')
)
SELECT
    km.turunduskanal, kk.kliente, km.tellimusi, km.kogukaive,
    ROUND (km.kogukäive / NULLIF(kk.kliente, 0), 2 ) AS müük_kliendi_kohta
FROM kanali_kogumüük km
INNER JOIN kanali_kliendid kk   
 ON km.turunduskanal = kk.turunduskanal
ORDER BY müük_kliendi_kohta DESC;


-- ============================================================
-- PÄRING 3 — KAMPAANIATE KUISED TRENDID
-- ============================================================
-- grupeeri tulemused kanali ja kuu järgi; näita kogukäivet, unikaalseid kliente ja tellimusi; kasuta HAVING filtrit; sorteeri kuu ja kogukäibe järgi.
-- HAVING piir: vähemalt 5 tellimust kanali ja kuu kohta.

SELECT
    DATE_TRUNC('month', o.sale_date) AS kuu,
    COALESCE(w.source, 'Tundmatu / kanal puudub') AS turunduskanal,
    COUNT(DISTINCT o.customer_id) AS kliente,
    COUNT(DISTINCT o.sale_id) AS tellimusi,
    ROUND(SUM(o.total_price), 2) AS kogukaive
FROM sales o
INNER JOIN customers c
    ON o.customer_id = c.customer_id
LEFT JOIN web_logs w
    ON c.customer_id = w.customer_id
GROUP BY
    DATE_TRUNC('month', o.sale_date),
    COALESCE(w.source, 'Tundmatu / kanal puudub')
HAVING COUNT(DISTINCT o.sale_id) >= 5
ORDER BY kuu, kogukaive DESC;


-- ============================================================
-- KRISTI ESITLUSE KOONDNUMBRID
-- ============================================================
-- Koondnumbrid põhinevad valideeritud lisapäringutel 6, 7 ja 9.
-- Juhendi otsese kolme tabeli JOIN-i tulemusi ei kasutatud, sest web_logs tabeli korduvad kliendikirjed mitmekordistasid müügiridu ja kogukäivet.
--
-- 1. Suurima kogukäibega kanal:
--    google_organic tõi 582 912,57 eurot käivet ja  1 994 tellimust.
--
-- 2. Suurima müügiga kliendi kohta kanal:
--    Kõrgeim tulemus oli grupis "Tundmatu / kanal puudub":   4 256,97 eurot kliendi kohta.
--    Kuna tegemist ei ole tuvastatud turunduskanaliga,  ei sobi seda kasutada kanali efektiivsuse järeldusena.
--
--    Tuvastatud kanalitest oli kõrgeim tulemus eraldi  source-väärtusel "Google Organic":
--    1 700,21 eurot kliendi kohta.
--    Tulemus on esialgne, sest sama kanal esineb andmetes  erinevate kirjapiltidega.
--
-- 3. Suurima keskmise tellimusväärtusega kanal:
--    Eraldi source-väärtusel "google organic" oli suurim keskmine tellimusväärtus: 311,37 eurot.
--    Kuna sama kanal esineb mitme kirjapildiga, tuleb source-väärtused enne lõplikku juhtkonna võrdlust standardiseerida.
--
-- 4. Olulisim kuine trend:
--    Põhikanali google_organic käive kasvas 2024. aasta novembrist detsembrini  13 834,38 eurolt 33 572,86 euroni.
--    Kasv oli 19 738,48 eurot ehk 142,7%.
--
-- 5. Andmete piirangud:
--    Kanalite efektiivsust saab hinnata käibe, tellimuste, klientide, müügi kliendi kohta ja keskmise tellimuse kaudu, kuid tegeliku ROI arvutamiseks puuduvad kampaaniate kulud.
--    Lisaks esinevad source-väljal samade kanalite erinevad kirjapildid, näiteks google_organic, Google Organic ja  google organic. Kanalid tuleb enne lõplikku juhtkonna võrdlust ühtlustada.
--    Valideeritud lisapäring omistab kliendile tema viimase teadaoleva turunduskanali. Tegemist ei ole tehingupõhise turundusliku omistamise mudeliga.


-- ============================================================
-- JUHENDI OSA KVALITEEDIKONTROLL
-- ============================================================
-- [x] web_logs tabelis on 50 000 rida.
-- [x] Päring 1 kasutab GROUP BY-d ja agregaatfunktsioone.
-- [x] Päring 2 kasutab CTE-sid ja HAVING filtrit.
-- [x] Päring 3 näitab kanali kuiseid trende.
-- [x] Kristi jaoks on sõnastatud 3–5 numbrilist leidu.
-- [x] Järeldustes on eristatud kanali efektiivsus ja tegelik ROI.
-- [x] Otsese JOIN-i võimalik ridade kordistumine on kontrollitud.
-- [x] Lõplikud koondnumbrid põhinevad kontrollitud päringutel.
-- [ ] Turunduskanalite erinevad kirjapildid tuleb enne lõplikku juhtkonna esitlust standardiseerida.


-- ############################################################
-- II OSA. LISAPÄRINGUD JA NENDE SELGITUSED
-- ############################################################
-- Need kasutavad ainult seni õpitud SQL-vahendeid: SELECT, JOIN, GROUP BY, HAVING, CTE ja window functions.
--
-- Lisapäringute eesmärk on:
-- 1) kontrollida imporditud tabeli struktuuri;
-- 2) hinnata andmekvaliteeti;
-- 3) tuvastada JOIN-ist tekkiv võimalik ridade kordistumine;
-- 4) pakkuda vajaduse korral kontrollitud alternatiivset kanalite koondloogikat;
-- 5) ristkontrollida tulemusi Roll A numbritega.

-- ============================================================
-- LISAPÄRING 1 — WEB_LOGS TABELI STRUKTUURI KONTROLL
-- ============================================================
-- Põhjendus: SELECT * on siin sobiv, sest impordi järel on vaja näha tegelikke veerunimesid ja esimesi andmeridu.

SELECT *
FROM web_logs
ORDER BY log_id
LIMIT 10;


-- ============================================================
-- LISAPÄRING 2 — WEB_LOGS ANDMEKVALITEEDI ÜLEVAADE
-- ============================================================
-- Põhjendus:
-- customer_id võib anonüümsetel külastajatel puududa.
-- Päring näitab anonüümsete logide arvu ja osakaalu, kanalite arvu ning logide ajavahemikku.

SELECT
    COUNT(*) AS logisid_kokku,
    COUNT(customer_id) AS tuvastatud_kliendiga_logisid,
    COUNT(*) - COUNT(customer_id) AS anonuumseid_logisid,
    ROUND(
        (COUNT(*) - COUNT(customer_id))::NUMERIC
        / NULLIF(COUNT(*), 0) * 100,
        2
    ) AS anonuumsete_osakaal_protsent,
    COUNT(DISTINCT source) AS turunduskanaleid,
    MIN(visit_date) AS esimene_kulastus,
    MAX(visit_date) AS viimane_kulastus
FROM web_logs;


-- ============================================================
-- LISAPÄRING 3 — KANALITE LIIKLUS
-- ============================================================
-- Põhjendus:
-- enne HAVING piiri lõplikku kinnitamist tuleb vaadata, kui palju külastusi ja tuvastatud kliente igas kanalis on.

SELECT
    COALESCE(source, 'Tundmatu / allikas puudub') AS turunduskanal,
    COUNT(*) AS kulastusi,
    COUNT(DISTINCT customer_id) AS tuvastatud_kliente
FROM web_logs
GROUP BY COALESCE(source, 'Tundmatu / allikas puudub')
ORDER BY kulastusi DESC;


-- ============================================================
-- LISAPÄRING 4 — KAS ÜHEL KLIENDIL ON MITU KANALIT?
-- ============================================================
-- Põhjendus:
-- kui üks klient esineb web_logs tabelis mitme logirea või mitme kanaliga, võib otsene JOIN customer_id alusel korrata sama müüki mitu korda.

SELECT
    customer_id,
    COUNT(*) AS logiridu,
    COUNT(DISTINCT source) AS erinevaid_kanaleid
FROM web_logs
WHERE customer_id IS NOT NULL
GROUP BY customer_id
HAVING COUNT(*) > 1
ORDER BY logiridu DESC, customer_id
LIMIT 20;


-- ============================================================
-- LISAPÄRING 5A — SALES KONTROLLNUMBER ENNE JOIN-I
-- ============================================================
-- Põhjendus:
-- salvesta sales tabeli unikaalsete müükide arv ja kogukäive.
-- Neid kasutatakse järgmise päringu tulemusega võrdlemiseks.

SELECT
    COUNT(*) AS sales_ridu,
    COUNT(DISTINCT sale_id) AS unikaalseid_muuke,
    ROUND(SUM(total_price), 2) AS sales_kogukaive
FROM sales;


-- ============================================================
-- LISAPÄRING 5B — OTSESE KOLME TABELI JOIN-I KONTROLL
-- ============================================================
-- Põhjendus:
-- võrdle joini_ridu ja joini_kogukaivet eelmise päringu sales_ridu ja sales_kogukaibega.
--
-- Kui JOIN-i ridade arv ja kogukäive kasvavad oluliselt, on sama müük web_logs korduvate kirjete tõttu mitmekordistunud.
-- Sellisel juhul ei tohi juhendi otsese JOIN-i SUM-i ja AVG-d kasutada lõpliku juhtimisnumbrina.

SELECT
    COUNT(*) AS joini_ridu,
    COUNT(DISTINCT o.sale_id) AS unikaalseid_muuke,
    ROUND(SUM(o.total_price), 2) AS joini_kogukaive
FROM sales o
INNER JOIN customers c
    ON o.customer_id = c.customer_id
LEFT JOIN web_logs w
    ON c.customer_id = w.customer_id;


-- ============================================================
-- LISAPÄRING 6 — KONTROLLITUD KANALITE KOOND
-- ============================================================
-- Põhjendus: kui lisapäring 5B näitab ridade kordistumist, määrab see alternatiivne päring igale tuvastatud kliendile ühe kanali.
-- Kasutatud lihtsustatud reegel: kliendile omistatakse tema kõige hilisem teadaolev kanal. ROW_NUMBER() on Nädal 4 õpiväljundis käsitletud window function.
-- Piirang: see ei ole tehingupõhine kampaania omistamine. Kõik kliendi müügid seotakse tema viimase teadaoleva kanaliga.
WITH kliendi_kanalid AS (
    SELECT
        customer_id, source,
         ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY visit_date DESC, log_id DESC
        ) AS rea_number
    FROM web_logs
    WHERE customer_id IS NOT NULL
      AND source IS NOT NULL
),
muuk_kanaliga AS (
    SELECT
        o.sale_id, o.customer_id, o.total_price,
        COALESCE(kk.source, 'Tundmatu / kanal puudub')
            AS turunduskanal
    FROM sales o
    LEFT JOIN customers c
        ON o.customer_id = c.customer_id
    LEFT JOIN kliendi_kanalid kk
        ON o.customer_id = kk.customer_id
       AND kk.rea_number = 1
)
SELECT
    turunduskanal,
    COUNT(DISTINCT customer_id) AS kliente,
    COUNT(DISTINCT sale_id) AS tellimusi,
    ROUND(SUM(total_price), 2) AS kogukaive,
    ROUND(
        SUM(total_price)
        / NULLIF(COUNT(DISTINCT sale_id), 0),
        2
    ) AS keskmine_tellimus
FROM muuk_kanaliga
GROUP BY turunduskanal
ORDER BY kogukaive DESC;

-- ============================================================
-- LISAPÄRING 7 — KONTROLLITUD KANALI EFEKTIIVSUS CTE ABIL
-- ============================================================
-- Põhjendus: see on päringu 2 kontrollitud alternatiiv juhuks, kui otsene JOIN kordistab müüke. HAVING jätab alles kanalid, millel on vähemalt 10 tellimust.
WITH kliendi_kanalid AS (
    SELECT
        customer_id, source,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY visit_date DESC, log_id DESC
        ) AS rea_number
    FROM web_logs
    WHERE customer_id IS NOT NULL AND source IS NOT NULL
),
muuk_kanaliga AS (
    SELECT
        o.sale_id, o.customer_id, o.total_price,
        COALESCE(kk.source, 'Tundmatu / kanal puudub')
            AS turunduskanal
    FROM sales o
    LEFT JOIN kliendi_kanalid kk
        ON o.customer_id = kk.customer_id
       AND kk.rea_number = 1
),
kanali_kokkuvote AS (
    SELECT
        turunduskanal,
        COUNT(DISTINCT customer_id) AS kliente,
        COUNT(DISTINCT sale_id) AS tellimusi,
        ROUND(SUM(total_price), 2) AS kogukaive
    FROM muuk_kanaliga
    GROUP BY turunduskanal
    HAVING COUNT(DISTINCT sale_id) >= 10
)
SELECT
    turunduskanal, kliente, tellimusi, kogukaive,
    ROUND(kogukaive / NULLIF(kliente, 0), 2) AS myyk_kliendi_kohta,
    ROUND(kogukaive / NULLIF(tellimusi, 0), 2) AS keskmine_tellimus
FROM kanali_kokkuvote
ORDER BY myyk_kliendi_kohta DESC;


-- ============================================================
-- LISAPÄRING 8 — KONTROLLITUD KUISED TRENDID
-- ============================================================
-- Põhjendus: see on päringu 3 kontrollitud alternatiiv juhuks, kui otsene JOIN kordistab müüke.
-- Kanal määratakse enne kuupõhist agregeerimist ühe korra kliendi kohta.

WITH kliendi_kanalid AS (
    SELECT
        customer_id, source,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY visit_date DESC, log_id DESC
        ) AS rea_number
    FROM web_logs
    WHERE customer_id IS NOT NULL
      AND source IS NOT NULL
),
muuk_kanaliga AS (
    SELECT
        o.sale_id,  o.sale_date,   o.customer_id,  o.total_price,
        COALESCE(kk.source, 'Tundmatu / kanal puudub')  AS turunduskanal
    FROM sales o
    LEFT JOIN kliendi_kanalid kk
        ON o.customer_id = kk.customer_id
       AND kk.rea_number = 1
)
SELECT
    DATE_TRUNC('month', sale_date) AS kuu,
    turunduskanal,
    COUNT(DISTINCT customer_id) AS kliente,
    COUNT(DISTINCT sale_id) AS tellimusi,
    ROUND(SUM(total_price), 2) AS kogukaive
FROM muuk_kanaliga
GROUP BY
    DATE_TRUNC('month', sale_date),
    turunduskanal
HAVING COUNT(DISTINCT sale_id) >= 5
ORDER BY kuu, kogukaive DESC;


-- ============================================================
-- LISAPÄRING 9 — KUIST-KUUSSE KÄIBE MUUTUS
-- ============================================================
-- Põhjendus: LAG() lisab trendile eelmise kuu käibe ning võimaldab arvutada muutuse eurodes ja protsentides.
-- See vastab Nädal 4 edasijõudnute tasemele.

WITH kliendi_kanalid AS (
    SELECT
        customer_id,  source, ROW_NUMBER() OVER ( PARTITION BY customer_id  ORDER BY visit_date DESC, log_id DESC) AS rea_number
    FROM web_logs
    WHERE customer_id IS NOT NULL AND source IS NOT NULL
),
muuk_kanaliga AS (
    SELECT
        o.sale_id,  o.sale_date,  o.customer_id,  o.total_price,
        COALESCE(kk.source, 'Tundmatu / kanal puudub')  AS turunduskanal
    FROM sales o
    LEFT JOIN kliendi_kanalid kk
        ON o.customer_id = kk.customer_id
       AND kk.rea_number = 1
),
kuine_kanali_myyk AS (
    SELECT
        DATE_TRUNC('month', sale_date) AS kuu,  turunduskanal,  COUNT(DISTINCT sale_id) AS tellimusi, ROUND(SUM(total_price), 2) AS kogukaive
    FROM muuk_kanaliga
    GROUP BY
        DATE_TRUNC('month', sale_date),
        turunduskanal
    HAVING COUNT(DISTINCT sale_id) >= 5
)
SELECT
    kuu, turunduskanal, tellimusi, kogukaive, LAG(kogukaive) OVER ( PARTITION BY turunduskanal  ORDER BY kuu ) AS eelmise_kuu_kaive,
    ROUND( kogukaive - LAG(kogukaive) OVER (PARTITION BY turunduskanal ORDER BY kuu),  2) AS muutus_eurodes,
    ROUND(( kogukaive - LAG(kogukaive) OVER (PARTITION BY turunduskanal ORDER BY kuu))/ NULLIF(LAG(kogukaive) OVER (PARTITION BY turunduskanal ORDER BY kuu ),  0) * 100, 1 ) AS muutus_protsent
FROM kuine_kanali_myyk
ORDER BY turunduskanal, kuu;


-- ============================================================
-- LISAPÄRING 10 — ROLL A RISTKONTROLL KUUD KAUPA
-- ============================================================
-- Põhjendus: Roll D kuude kogusummad peavad olema kooskõlas Roll A müügikoondiga, kui mõlemad kasutavad sama sales tabelit ja sama ajaperioodi.
-- Kui Roll A kasutab kuupäevafiltrit, lisa täpselt sama WHERE tingimus ka Roll D põhi- ja kontrollpäringutesse.

SELECT
    DATE_TRUNC('month', sale_date) AS kuu,
    COUNT(DISTINCT sale_id) AS tellimusi,
    ROUND(SUM(total_price), 2) AS kogukaive,
    ROUND(
        SUM(total_price)
        / NULLIF(COUNT(DISTINCT sale_id), 0),
        2
    ) AS keskmine_tellimus
FROM sales
GROUP BY DATE_TRUNC('month', sale_date)
ORDER BY kuu;