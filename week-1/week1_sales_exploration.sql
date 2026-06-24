-- ============================================================
-- DACA Nädal 1 — UrbanStyle.ltd Müügiandmete Analüüs
-- Autor:      Helen Tanner
-- Kuupäev:    24.06.2026
-- Andmebaas:  Supabase / PostgreSQL
-- Tabel:      sales (15 234 rida)
--
-- Kontekst: IT-juht Toomas Kask avastas, et UrbanStyle'i
-- müügiandmetes võib esineda kvaliteediprobleeme. Ta palus
-- andmeanalüütikul uurida nelja konkreetset küsimust enne,
-- kui andmeid ärianalüüsis kasutatakse.
-- ============================================================
 
 
-- ============================================================
-- KOKKUVÕTE — TULEMUSED TOOMASELE
-- ============================================================
--
-- Küsimus 1 — Duplikaatide arv:
--   Tabelis on 15 234 rida, millest 5 116 on duplikaadid.
--   Unikaalseid müügikirjeid on tegelikult 10 118.
--   → Müüginumbrid on praegu ~50% ülepaisutatud.
--
-- Küsimus 2 — Millised read on duplikaadid:
--   Duplikaadid on read, kus sale_id esineb rohkem kui üks kord.
--   → Täpne tuvastamine toimub Nädal 2-s (GROUP BY + HAVING).
--
-- Küsimus 3 — NULL väärtused:
--   1 487 tellimusel puudub customer_id (9,7% kõigist ridadest).
--   0- ja NULL-väärtusega total_price kirjeid ei esine.
--   → Puuduvad kliendid võivad viidata süsteemivigadele
--     või anonüümsetele ostudele.
--
-- Küsimus 4 — Suurimad ja väiksemad müügid:
--   Suurim tehing:   2 170,40 eurot
--   Väikseim tehing: -1 405,32 eurot (negatiivne = kahtlane)
--   Negatiivseid kirjeid on kokku 305 — vajavad kontrolli.
--   → Negatiivne summa võib tähendada tagastust või
--     andmesisestuse viga.
-- ============================================================
 
 
-- ============================================================
-- PÄRING 1 — DUPLIKAATIDE ARV
-- Meetod: võrdle ridade koguarvu unikaalsete sale_id-de arvuga.
-- Vahe = duplikaatide arv.
-- ============================================================
 
SELECT
    COUNT(*) AS ridu_kokku,       -- kõik read
    COUNT(DISTINCT sale_id) AS unikaalseid,       -- unikaalsed kirjed
    COUNT(*) - COUNT(DISTINCT sale_id) AS duplikaate         -- vahe = duplikaadid
FROM sales;
 
-- Tulemus: 15 234 rida | 10 118 unikaalset | 5 116 duplikaati
-- Järeldus: Ligi kolmandik andmetest on duplikaadid.
--           Enne ärianalüüsi on duplikaadid vaja eemaldada.
 
 
-- ============================================================
-- PÄRING 2 — NULL VÄÄRTUSED (puuduvad kliendi ID-d)
-- Meetod: IS NULL filtreerib read, kus customer_id puudub.
-- NB! = NULL ei tööta SQL-is — NULL tähendab "teadmata",
--     mitte tühja stringi.
-- ============================================================
 
SELECT COUNT(*) AS puuduv_klient
FROM sales
WHERE customer_id IS NULL;
 
-- Tulemus: 1 487 tellimust ilma kliendi ID-ta
-- Järeldus: 9,7% kirjetest on seostamata kliendiga.
--           Võimalikud põhjused: anonüümsed ostud,
--           süsteemiviga importimisel või kassatehingud.
 
 
-- ============================================================
-- PÄRING 3 — SUURIMAD MÜÜGID (TOP 10)
-- Meetod: ORDER BY DESC sorteerib suurimast väikseimani,
--         LIMIT 10 piirab väljundit.
-- ============================================================
 
SELECT
    sale_id,
    customer_id,
    total_price
FROM sales
ORDER BY total_price DESC
LIMIT 10;
 
-- Tulemus: Suurimad tehingud vahemikus 1 858,95 – 2 170,40 eurot
-- Järeldus: Kõrgeimad summad tunduvad realistlikud jaemüügi
--           kontekstis. Erandlikku anomaaliat TOP 10-s ei esine.
 
 
-- ============================================================
-- PÄRING 4 — VÄIKSEMAD MÜÜGID JA KAHTLASED READ
-- Meetod: WHERE total_price <= 0 filtreerib nullid ja
--         negatiivsed väärtused. OR total_price IS NULL
--         lisab ka täiesti puuduvad summad.
-- ============================================================
 
SELECT
    sale_id,
    customer_id,
    total_price
FROM sales
WHERE total_price <= 0
   OR total_price IS NULL
ORDER BY total_price ASC
LIMIT 10;
 
-- Tulemus: 305 negatiivset kirjet | 0 null-väärtusega kirjet
--          Väikseim tehing: -1 405,32 eurot
--          TOP 10 negatiivne vahemik: -1 405,32 kuni -875,16
-- Järeldus: Negatiivsed summad võivad tähendada tagastusi
--           (return) või andmesisestuse vigu. Vajavad
--           eraldi kontrolli ärimeeskonnaga.
 
 
-- ============================================================
-- LISAANALÜÜS — KANALITE VÕRDLUS
-- Eesmärk: mitu tellimust ja unikaalset klienti igas kanalis?
-- Märkus: GROUP BY tuleb Nädal 4. Praegu eraldi päringud
--         iga kanali kohta.
-- ============================================================
 
-- Samm 1: vaata, millised kanalid üldse eksisteerivad
SELECT DISTINCT channel
FROM sales
ORDER BY channel;
-- Tulemus: 2 kanalit — 'online' ja 'pood'
 
-- Samm 2: online kanali statistika
SELECT
    COUNT(*)                    AS online_tellimused,
    COUNT(DISTINCT customer_id) AS online_unikaalsed_kliendid
FROM sales
WHERE channel = 'online';
 
-- Samm 3: poe kanali statistika
SELECT
    COUNT(*)                    AS pood_tellimused,
    COUNT(DISTINCT customer_id) AS pood_unikaalsed_kliendid
FROM sales
WHERE channel = 'pood';
 
-- Märkus: Nädal 4-s asendab üks GROUP BY päring mõlemad
--         kanalipäringud korraga — palju elegantsemal viisil.
 
 
-- ============================================================
-- FAILI LÕPP
-- Helen Tanner | DACA Nädal 1 | 24.06.2026
-- ============================================================