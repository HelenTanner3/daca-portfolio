-- ============================================================
-- DACA Nädal 2 — UrbanStyle.ltd
-- Organisatsioon: Operatsioonid
-- Roll B: Kliendiandmete puhastaja (Customer Data Cleaner)

-- Autor:      Helen Tanner
-- Kuupäev:    02.07.2026
-- Andmebaas:  Supabase / PostgreSQL
-- Tabel:      customers (Supabase)

/* 
KONTEKST:
IT-juht Toomas Kask on tuvastanud kliendiandmetes olulisi puudujääke: 
duplikaatsed e-mailid, puuduvad kontaktandmed ja ebakorrektsed linnanimed.
Minu ülesanne on need vead tuvastada, dokumenteerida ja luua puhastusplaan.

METOODIKA: Test → Verify → Log → Commit
Kõik muudatused tehakse esmalt test-koopias (customers_test),
et algandmed jääksid puutumatuks.
*/


-- ============================================================
-- SAMM 1: TEST-KOOPIA LOOMINE
-- ============================================================
-- Toomase raudne reegel: ära kunagi muuda algandmeid ilma testita.
-- CREATE TABLE AS kopeerib tabeli struktuuri JA kõik andmed.
-- Tulemus: customers_test on täpne koopia customers tabelist.

CREATE TABLE customers_test AS SELECT * FROM customers;


-- Kontrollin, et koopia õnnestus — ridade arv peab ühtima algandmetega.
-- LEID: 3 150 rida — võrdne customers põhitabeliga. Koopia õnnestus.
SELECT 
'customers_test' AS tabel,
COUNT(*) AS ridade_arv 
FROM customers_test

UNION ALL

SELECT
'customers' AS tabel,
COUNT(*) AS ridade_arv FROM customers;


-- ============================================================
-- SAMM 2: DUPLIKAATSETE E-MAILIDE TUVASTAMINE
-- ============================================================
-- Duplikaadid tekivad, kui sama klient on süsteemi sisestatud mitu korda (nt e-poe ja sularaha andmed on ühildunud valesti).
-- GROUP BY koondab read e-maili järgi.
-- HAVING COUNT(*) > 1 filtreerib välja ainult need e-mailid, mis esinevad rohkem kui üks kord..
SELECT 
    email,                      -- e-posti aadress
    COUNT(*) AS koopiate_arv    -- mitu korda see e-mail esineb
FROM customers_test
GROUP BY email
HAVING COUNT(*) > 1             -- näitame ainult duplikaate
ORDER BY koopiate_arv DESC;     -- kõige rohkem korduvad e-mailid esimesena

/* 
LEID: 
- 130 korduvat e-maili on kokku (126+2*2) = 126 e-maili aadressi esineb andmestikus 2- kordselt ning 2 e-maili aadressi esineb 3- kordselt 
- Need viitavad klientidele, kes on süsteemi sisestatud mitu korda erinevate customer_id väärtustega

ÄRILINE MÕJU:
- Klientide koguarv on tegelikust suurem
- Lojaalsusstatistika on moonutatud, kuna ühe kliendi ostud on jagatud mitme kirje vahel
- Turunduskampaaniad võivad saata samale kliendile mitu sõnumit

JÄRGMINE SAMM: 
- Nädal 3-s kasutame ROW_NUMBER() funktsiooni, et tuvastada, millise duplikaatkirje jätame alles
*/


-- ============================================================
-- SAMM 3: PUUDUVATE NIMEDE (NULL) KONTROLLIMINE
-- ============================================================
-- FILTER (WHERE ...) on PostgreSQL-i laiendus COUNT-ile: loeb ainult need read, kus tingimus on tõene.
-- Kontrollime nii NULL-väärtusi kui ka tühje stringe (''), sest mõlemad tähendavad sisuliselt puuduvat nime.

SELECT
    COUNT(*) FILTER (WHERE first_name IS NULL OR first_name = '') AS null_eesnimi,   -- puuduvad eesnimed
    COUNT(*) FILTER (WHERE last_name IS NULL OR last_name = '') AS null_perenimi     -- puuduvad perenimed
FROM customers_test;

/* 
LEID: 
- Puuduvaid eesnimesid: 0
- Puuduvaid perenimesid: 0

JÄRELDUS:
Nimede kvaliteet on hea — kõigil kliendikirjetel on nii ees- kui perenimi olemas.
See on oluline klienditeenindusliku personaliseerimise seisukohalt.
*/


-- ============================================================
-- SAMM 4A: LINNANIMEDE ÜLEVAADE (RAW)
-- ============================================================
-- Esimene päring näitab linnanimesid täpselt nii, nagu need andmebaasis on — ilma ühtegi muudatuseta.
-- Eesmärk: saada ülevaade, millised erinevad kirjaviisid esinevad.

SELECT 
    city,                       -- linnanimi täpselt nii nagu andmebaasis
    COUNT(*) AS klientide_arv   -- mitu klienti selle kirjaviisiga linnas
FROM customers_test
GROUP BY city
ORDER BY city;                  -- tähestikuline järjestus probleemide nägemiseks

/* 
LEID:
SQL loeb ' Tallinn, 'Tallinn ' 'tallinn', 'Tallinn' ja 'TALLINN' viie erinevana.
Sellest tuleneb moonutus kõigis linnakesksetetes aruannetes.
*/


-- ============================================================
-- SAMM 4B: LINNANIMEDE PROBLEEMIDE KAARDISTAMINE
-- ============================================================
-- INITCAP(TRIM(city)) teeb kaks asja korraga:
--   TRIM()    — eemaldab tühikud nime algusest ja lõpust
--   INITCAP() — muudab esimese tähe suureks, ülejäänud väikeseks

SELECT 
    INITCAP(TRIM(city))             AS puhas_linn,          -- ühtlustatud nimekuju
    COUNT(*)                        AS kliente_kokku,       -- klientide koguarv selles linnas
    COUNT(DISTINCT city)            AS erinevaid_kujusid,   -- COUNT(DISTINCT city) loeb, mitu erinevat kirjaviisi ühe linna kohta esineb.
    STRING_AGG(DISTINCT city, ', ') AS kujud                -- STRING_AGG koondab kõik erinevad kirjaviisid ühte lahtrisse loetelu kujul.
FROM customers_test
WHERE city IS NOT NULL                                      -- jätame NULL-linnad välja
GROUP BY INITCAP(TRIM(city))
HAVING COUNT(DISTINCT city) > 1                             -- filtreerib ainult probleemse linnad.
ORDER BY kliente_kokku DESC;                                -- suuremad linnad esimesena


-- Vigaste ridade kokkuvõte
SELECT 
    COUNT(*) AS ridu_kokku,
    COUNT(*) FILTER (WHERE city != INITCAP(TRIM(city))) AS vigaseid_ridu,
    ROUND(100.0 * COUNT(*) FILTER (WHERE city != INITCAP(TRIM(city))) / COUNT(*), 2) AS vea_protsent
FROM customers_test
WHERE city IS NOT NULL;

--Vigaste linnanimede muutmise vajaduse kaardistamine (detailid exelisse)
SELECT
    customer_id,
    city AS algne_nimi,
    INITCAP(TRIM(city)) AS puhas_nimi,
    -- Lisame tunnuse: kui algne ja puhas nimi ei kattu, siis 'Jah'
    CASE 
        WHEN city = INITCAP(TRIM(city)) THEN '0'
        ELSE '1'
    END AS vaja_muuta
FROM customers_test
WHERE city IS NOT NULL
ORDER BY city;

/* LEID:
- SQL-i loogika järgi on andmestikus 54 erinevat "linna"
- Tegelikult on unikaalseid linnanimesid 12
- Seega 42 "linna" on tegelikult kordused (nt ' Tallinn, 'Tallinn ' 'tallinn', 'Tallinn' ja 'TALLINN)
- Klienditabel sisaldab kokku 3150 rida, neist 252 rida (8%) on vigaste linnanimedega ning vajavad parandamist 

ÄRILINE MÕJU:
- Piirkondlik müügianalüüs on praegu täiesti ebausaldusvääne
- Tallinna müüginumbrid on hajutatud mitme kirje vahel

LAHENDUS (Nädal 3):
UPDATE customers_test SET city = INITCAP(TRIM(city));*/


-- ============================================================
-- SAMM 5: KONTAKTANDMETE TERVIKLIKKUSE KONTROLL
-- ============================================================
-- Kontrollime kahte kriitilist kontaktvälja: telefon ja e-mail.
-- Turunduse ja müügi seisukohalt on e-mail eriti oluline,
-- kuna võimaldab digitaalset suhtlust ja kampaaniaid.

SELECT
    COUNT(*) FILTER (WHERE phone IS NULL OR phone = '') AS null_telefon,    -- puuduvad telefoninumbrid
    COUNT(*) FILTER (WHERE email IS NULL OR email = '') AS null_email       -- puuduvad e-mailid
FROM customers_test;

/* LEID:
- Puuduvaid telefoninumbreid: 0 — hea uudis müügiosakonnale
- Puuduvaid e-maile: 380 (~12% kõigist klientidest)

ÄRILINE MÕJU:
- 380 klienti on UrbanStyle'i jaoks "digitaalselt nähtamatud"
- Nad ei saa uudiskirju, kampaaniapakkumisi ega järelteenindust
- Anna Mets (turundus) ei saa neid kliente e-turundusega kaasata

VÕIMALIKUD PÕHJUSED:
- Klient ostis poest ilma end registreerimata
- E-mail jäi kassas sisestamata
- Andmete migreerimisel läks e-mail kaduma

SOOVITUS:
Järgmises analüüsisammus kontrollida, kas e-mailita kliendid on pigem poemüügid (kus registreerimine on vabatahtlik) või e-poe kliendid (kus e-mail peaks olema kohustuslik).*/


-- ============================================================
--Samm 6. Koostan puhastamisraporti:
-- ============================================================
--Kategooria	                Leitud probleeme	        Kirjeldus
--Duplikaatsed e-mailid	?	           130                  Sama e-mail mitmel kliendil
--NULL eesnimi	?	                   0                    Puuduv kliendi eesnimi
--NULL perenimi	?	                   0                    Puuduv kliendi perenimi
--Ebajärjekindlad linnanimed?          252                  252 rida vajavad linnanimede parandamist tulenevalt erinevatest nimekujudest (nt tallinn vs Tallinn)
--                                                          -  42 liigset linnanime (tegelikult 12 linna)
--NULL telefon/e-mail?	               380                  Puuduvad e-mailid, telefoninumbrid on kõigil klientidel süsteemis olemas
--KOKKU Kliente andmebaasis:         3 150 
--KOKKU probleeme?	                   762 /24,2%

--Lisa soovitus: milline probleem mõjutab igapäevast tööd kõige rohkem?

-- ============================================================
-- SAMM 6A: PUHASTUSRAPORT — KOONDÜLEVAADE - Claude kaasabil
-- ============================================================
-- Koondab kõik leitud probleemid ühte tabelisse. Võimaldab Toomasel ühel pilgul näha andmekvaliteedi seisu.
SELECT 
    'Duplikaatsed e-mailid'         AS probleem,
    130                             AS leitud_kogus,
    'Sama e-mail mitmel kliendil'   AS kirjeldus,
    'Kõrge'                         AS prioriteet,
    2                               AS sort_order        -- sorteerimiseks, 2=Kõrge
UNION ALL SELECT 'Puuduv eesnimi', 0, 'Kõik kirjed on korras', 'Puudub', 3     -- 3=Puudub ehk madalaim prioriteet                  
UNION ALL SELECT 'Puuduv perenimi', 0, 'Kõik kirjed on korras','Puudub', 3     -- 3=Puudub                       
UNION ALL SELECT 'Ebajärjekindlad linnanimed', 42, '42 korduvat kirjaviisi 12 tegeliku linna kohta','Kõrge', 2    -- 2=Kõrge                         
UNION ALL SELECT 'Puuduv e-mail', 380, '~12% klientidest pole digitaalselt kättesaadavad', 'Kriitiline', 1        -- 1=Kriitiline ehk kõrgeim prioriteet                   
UNION ALL SELECT 'Puuduv telefon', 0,  'Kõik kirjed on korras', 'Puudub', 3              -- 3=Puudub                        
ORDER BY 5;     -- sorteerime viienda veeru (sort_order) järgi, -- tulemus: Kriitiline (1) → Kõrge (2) → Puudub (3)             
/*KOKKUVÕTE TOOMASELE:
Analüüsitud kliendikirjeid: 3 150
Peamised leiud prioriteedi järgi:
  1. [KRIITILINE] 380 klienti (~12%) puudub e-mail          → digitaalne turundus nende klientideni ei jõua
  2. [KÕRGE] 130 duplikaat-e-maili                          → klientide koguarv ja lojaalsusstatistika on moonutatud
  3. [KÕRGE] 42 liigset linnanime (tegelikult 12 linna)     → piirkondlik müügianalüüs ei ole praegu usaldusväärne
            252 klienti (~ 8%) linnanimi vaja parandada
Positiivne:
  • Kõigil kirjetel on ees- ja perenimi olemas
  • Telefoninumbrid on täielikud
Soovituslik puhastamise järjekord:
  1. Linnanimede ühtlustamine — INITCAP(TRIM())             → kiire ja ohutu, mõjutab kohe aruandlust
  2. Duplikaatide eemaldamine — ROW_NUMBER() meetod         → nõuab ettevaatlikkust, Nädal 3 teema
  3. Puuduvate e-mailide strateegia                         → äriline otsus, kas koguda aktiivselt või jätta "puudub" staatusesse*/