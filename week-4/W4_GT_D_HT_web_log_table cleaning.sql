-- ============================================================
-- DACA Nädal 4 — UrbanStyle.ltd
-- Organisatsioon: Operatsioonid
-- Roll D: web_logs tabeli puhastaja
-- Autor: Helen Tanner
-- Kuupäev: 18.07.2026
-- Andmebaas: Supabase / PostgreSQL
-- Tabel: web_logs
-- ============================================================

/*
KONTEKST: web_logs tabeli source väljal esineb sama turunduskanali kohta erinevaid kirjapilte ja lühendeid.
EESMÄRK: säilitada algne source ning lisada standardiseeritud väärtused uude source_clean veergu.
METOODIKA: Test → Verify → Log → Commit.
Kõik muudatused tehakse esmalt web_logs_test tabelis ja alles pärast kontrollimist production-tabelis web_logs.
*/

-- ============================================================
-- SAMM 0 — TESTTABELI LOOMINE
-- ============================================================

-- Kustutab varasema testtabeli ja loob web_logs tabelist uue testkoopia.
DROP TABLE IF EXISTS web_logs_test;

CREATE TABLE web_logs_test AS
SELECT * FROM web_logs;

-- Kontrollib, et test- ja production-tabeli ridade arv oleks sama.
SELECT 'web_logs' AS tabel, COUNT(*) AS ridade_arv
FROM web_logs
UNION ALL
SELECT 'web_logs_test' AS tabel, COUNT(*) AS ridade_arv
FROM web_logs_test;

-- Kuvab testtabeli esimesed kümme rida veergude ja andmete esmaseks kontrollimiseks.
SELECT *
FROM web_logs_test
ORDER BY log_id
LIMIT 10;

-- Logib testtabeli loomise; 
-- Logikirje on juba cleaning_log tabelisse lisatud. Uuesti käivitamisel tekiks duplikaat.
INSERT INTO cleaning_log (table_name, action, rows_affected, details)
SELECT 'web_logs_test', 'Testtabeli loomine web_logs tabeli põhjal', COUNT(*), 'Loodi värske testkoopia source väärtuste standardiseerimise kontrollimiseks.'
FROM web_logs_test;


-- ============================================================
-- SAMM 1 — SOURCE VÄÄRTUSTE ÜLEVAADE ENNE PUHASTAMIST
-- ============================================================

-- Näitab algseid source väärtusi ja nende esinemiste arvu.
SELECT source AS algne_source, COUNT(*) AS logiridade_arv
FROM web_logs_test
GROUP BY source
ORDER BY logiridade_arv DESC, algne_source;

/*
LEID: source väljal esineb 19 erinevat väärtust ning sama kanal on kirjutatud eri kujul.
Tasuline reklaam ja orgaaniline või täpsustamata liiklus jäetakse standardiseerimisel eraldi.
*/

-- ============================================================
-- SAMM 2 — SOURCE VÄÄRTUSTE STANDARDISEERIMINE TESTTABELIS
-- ============================================================

-- 2.1. Lisab testtabelisse uue standardiseeritud väärtuste välja.
ALTER TABLE web_logs_test
ADD COLUMN IF NOT EXISTS source_clean TEXT;

-- 2.2. Täidab source_clean välja algse source väärtuse põhjal.
UPDATE web_logs_test
SET source_clean =
    CASE
        WHEN source IS NULL OR TRIM(source) = '' THEN 'unknown'                                         -- puuduv või tühi allikas
        WHEN LOWER(TRIM(source)) IN ('facebook', 'fb') THEN 'facebook'                                  -- Facebook: orgaaniline või täpsustamata
        WHEN LOWER(TRIM(source)) IN ('facebook ads', 'facebook_ads', 'fb_ads') THEN 'facebook_ads'       -- Facebook: tasuline reklaam
        WHEN LOWER(TRIM(source)) = 'google' THEN 'google_unspecified'                                    -- Google: täpsustamata liiklus
        WHEN LOWER(TRIM(source)) IN ('google organic', 'google_organic') THEN 'google_organic'           -- Google: orgaaniline liiklus
        WHEN LOWER(TRIM(source)) IN ('google ads', 'google_ads') THEN 'google_ads'                        -- Google: tasuline reklaam
        WHEN LOWER(TRIM(source)) IN ('instagram', 'ig') THEN 'instagram'                                 -- Instagram: orgaaniline või täpsustamata
        WHEN LOWER(TRIM(source)) IN ('instagram ads', 'instagram_ads', 'ig_ads') THEN 'instagram_ads'    -- Instagram: tasuline reklaam
        WHEN LOWER(TRIM(source)) = 'direct' THEN 'direct'                                                -- otsene liiklus
        WHEN LOWER(TRIM(source)) = 'email_campaign' THEN 'email_campaign'                                -- e-posti kampaania
        WHEN LOWER(TRIM(source)) = 'tiktok' THEN 'tiktok'                                                -- TikToki liiklus
        ELSE LOWER(TRIM(source))                                                                         -- muu väärtus säilitatakse ühtlustatud kujul
    END;

-- 2.3. Näitab algse ja standardiseeritud source väärtuse vastendust.
SELECT source AS algne_source, source_clean AS standardiseeritud_source, COUNT(*) AS logiridade_arv
FROM web_logs_test
GROUP BY source, source_clean
ORDER BY source_clean, source;

-- 2.4. Võrdleb source väärtuste arvu enne ja pärast standardiseerimist.
SELECT COUNT(DISTINCT source) AS algseid_source_vaartusi, COUNT(DISTINCT source_clean) AS standardiseeritud_source_vaartusi
FROM web_logs_test;

-- 2.5. Näitab standardiseeritud kanalite koondit; source_arv summa peab olema 50 000.
SELECT source_clean AS turunduskanal, COUNT(*) AS source_arv
FROM web_logs_test
GROUP BY source_clean
ORDER BY source_arv DESC;

-- 2.6. Kontrollib, et source_clean väljal ei oleks NULL väärtusi; oodatav tulemus on 0.
SELECT COUNT(*) AS puuduvad_source_clean_vaartused
FROM web_logs_test
WHERE source_clean IS NULL;

-- 2.7. Kontrollib, kas CASE-loogikast jäi välja kaardistamata väärtusi; oodatav tulemus on 0 rida.
SELECT source AS algne_source, source_clean, COUNT(*) AS logiridade_arv
FROM web_logs_test
WHERE source_clean NOT IN ('unknown', 'facebook', 'facebook_ads', 'google_unspecified', 'google_organic', 'google_ads', 'instagram', 'instagram_ads', 'direct', 'email_campaign', 'tiktok')
GROUP BY source, source_clean
ORDER BY logiridade_arv DESC;

-- 2.8. Logib testtabelis tehtud source väärtuste standardiseerimise.
-- Logikirje on juba cleaning_log tabelisse lisatud. Uuesti käivitamisel tekiks duplikaat.
INSERT INTO cleaning_log (table_name, action, rows_affected, details)
SELECT 'web_logs_test', 'source väärtuste standardiseerimine source_clean veergu', COUNT(*), 'Algne source säilitati; kirjapildid ja lühendid ühtlustati ning tasuline ja täpsustamata liiklus jäeti eraldi.'
FROM web_logs_test;

/*
TESTTULEMUSE KONTROLL:
[ ] web_logs_test sisaldab 50 000 rida.
[ ] Algseid source väärtusi on 19.
[ ] Standardiseeritud väärtusi on 10 või unknown väärtust ei esine.
[ ] source_clean IS NULL kontroll annab tulemuseks 0.
[ ] Kaardistamata väärtuste kontroll annab 0 rida.
[ ] Standardiseeritud kanalite source_arv summa on 50 000.
*/

-- ============================================================
-- SAMM 3 — SOURCE VÄÄRTUSTE STANDARDISEERIMINE PRODUCTION-TABELIS
-- ============================================================

-- 3.1. Lisab production-tabelisse standardiseeritud väärtuste välja.
ALTER TABLE web_logs
ADD COLUMN IF NOT EXISTS source_clean TEXT;

-- 3.2. Rakendab testtabelis kontrollitud standardiseerimisloogika production-tabelis.
UPDATE web_logs
SET source_clean =
    CASE
        WHEN source IS NULL OR TRIM(source) = '' THEN 'unknown'                                         -- puuduv või tühi allikas
        WHEN LOWER(TRIM(source)) IN ('facebook', 'fb') THEN 'facebook'                                  -- Facebook: orgaaniline või täpsustamata
        WHEN LOWER(TRIM(source)) IN ('facebook ads', 'facebook_ads', 'fb_ads') THEN 'facebook_ads'       -- Facebook: tasuline reklaam
        WHEN LOWER(TRIM(source)) = 'google' THEN 'google_unspecified'                                    -- Google: täpsustamata liiklus
        WHEN LOWER(TRIM(source)) IN ('google organic', 'google_organic') THEN 'google_organic'           -- Google: orgaaniline liiklus
        WHEN LOWER(TRIM(source)) IN ('google ads', 'google_ads') THEN 'google_ads'                        -- Google: tasuline reklaam
        WHEN LOWER(TRIM(source)) IN ('instagram', 'ig') THEN 'instagram'                                 -- Instagram: orgaaniline või täpsustamata
        WHEN LOWER(TRIM(source)) IN ('instagram ads', 'instagram_ads', 'ig_ads') THEN 'instagram_ads'    -- Instagram: tasuline reklaam
        WHEN LOWER(TRIM(source)) = 'direct' THEN 'direct'                                                -- otsene liiklus
        WHEN LOWER(TRIM(source)) = 'email_campaign' THEN 'email_campaign'                                -- e-posti kampaania
        WHEN LOWER(TRIM(source)) = 'tiktok' THEN 'tiktok'                                                -- TikToki liiklus
        ELSE LOWER(TRIM(source))                                                                         -- muu väärtus säilitatakse ühtlustatud kujul
    END;

-- 3.3. Kontrollib, et production-tabeli ridade arv oleks endiselt 50 000.
SELECT COUNT(*) AS web_logs_ridade_arv
FROM web_logs;

-- 3.4. Näitab production-tabelis algse ja standardiseeritud väärtuse vastendust.
SELECT source AS algne_source, source_clean AS standardiseeritud_source, COUNT(*) AS logiridade_arv
FROM web_logs
GROUP BY source, source_clean
ORDER BY source_clean, source;

-- 3.5. Näitab production-tabeli standardiseeritud kanalite koondit.
SELECT source_clean AS turunduskanal, COUNT(*) AS source_arv
FROM web_logs
GROUP BY source_clean
ORDER BY source_arv DESC;

-- 3.6. Võrdleb test- ja production-tabeli standardiseeritud kanalite ridade arvu.
WITH test_koond AS (
    SELECT source_clean, COUNT(*) AS test_ridu
    FROM web_logs_test
    GROUP BY source_clean
),
production_koond AS (
    SELECT source_clean, COUNT(*) AS production_ridu
    FROM web_logs
    GROUP BY source_clean
)
SELECT t.source_clean AS turunduskanal, t.test_ridu, p.production_ridu, p.production_ridu - t.test_ridu AS erinevus
FROM test_koond t
INNER JOIN production_koond p ON t.source_clean = p.source_clean
ORDER BY t.source_clean;

-- 3.7. Kontrollib production-tabelis puuduvaid source_clean väärtusi; oodatav tulemus on 0.
SELECT COUNT(*) AS puuduvad_source_clean_vaartused
FROM web_logs
WHERE source_clean IS NULL;

-- 3.8. Logib production-tabelis tehtud source väärtuste standardiseerimise.
-- Logikirje on juba cleaning_log tabelisse lisatud. Uuesti käivitamisel tekiks duplikaat.
INSERT INTO cleaning_log (table_name, action, rows_affected, details)
SELECT 'web_logs', 'source väärtuste standardiseerimine source_clean veergu', COUNT(*), 'Testtabelis kontrollitud puhastusloogika rakendati production-tabelis; algne source säilitati.'
FROM web_logs;


-- Kuvab web_logs ja web_logs_test puhastamise logikirjed ajalises järjekorras.
SELECT log_timestamp, table_name, action, rows_affected, details
FROM cleaning_log
WHERE table_name IN ('web_logs', 'web_logs_test')
ORDER BY log_timestamp;


/*
LÕPPKONTROLL:
[x] Algne source veerg on säilinud.
[x] source_clean veerg on loodud.
[x] Test- ja production-tabelis on 50 000 rida.
[x] Test- ja production-tabeli koondtulemuste erinevus on 0.
[x] Tegevused on cleaning_log tabelisse logitud.
Edasistes analüüsipäringutes kasutatakse web_logs.source_clean välja.
*/
