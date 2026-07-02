-- ============================================================
-- DACA Nädal 1 — UrbanStyle.ltd
-- Roll A: Müügiandmete uurija

-- Autor:      Helen Tanner
-- Kuupäev:    25.06.2026
-- Andmebaas:  Supabase / PostgreSQL
-- Tabel:      sales

-- Eesmärk:
-- Kontrollida müügiandmete kvaliteeti enne nende kasutamist ärianalüüsis ja aruandluses.

-- Kontekst:
-- IT-juht Toomas Kask kahtlustab, et andmestikus võib esineda kvaliteediprobleeme. 
-- Käesolev analüüs kontrollib peamisi riske ja dokumenteerib leitud probleemid.
-- ============================================================

-- ============================================================
-- 1. TABELI MAHT
-- Mitu müügitehingut on sales tabelis?
-- ============================================================
-- Annab ettekujutuse andmestiku suurusest ja võimaldab hiljem
-- võrrelda, kui suur osa ridadest läbib erinevaid filtreid.

SELECT COUNT(*) AS müügitehingute_arv
FROM sales;

-- Tulemus:
-- 15 234 müügitehingut

-- Järeldus:
-- Andmestik on piisava mahuga esmaseks analüüsiks.

-- ============================================================
-- 2. TABELI STRUKTUUR
-- Millised veerud ja näidisandmed on müügitabelis?
-- ============================================================
-- Enne mis tahes analüüsi on mõistlik vaadata, milliste
-- andmetega üldse tegemist on. LIMIT 10 hoiab päringu kiirena.

SELECT *
FROM sales
LIMIT 10;

-- Veerud: id, sale_id, invoice_id, sale_date, customer_id, product_id,
-- quantity, unit_price, total_price, channel, store_location, payment_method

-- Järeldus:
-- Tabel sisaldab nii müügitehingu väärtust, kliendiinfot kui ka müügikanali andmeid.

-- ============================================================
-- 3. SUURIMAD TEHINGUD — KOGU ANDMESTIK
-- Millised on 10 suurimat müügitehingut?
-- ============================================================
-- Suurimad tehingud mõjutavad kõige rohkem käibe- ja müügistatistikat ning 
-- võivad aidata avastada võimalikke erindlikke kirjeid.

SELECT sale_id,
       customer_id,
       sale_date,
       total_price
FROM sales
ORDER BY total_price DESC
LIMIT 10;

-- Tulemus: Suurimad tehingud jäävad vahemikku  1 858,95 kuni 2 170,40 EUR.
-- Järeldus: Esialgsel vaatlusel ei paista suurimate tehingute seas ebarealistlikke väärtusi.

-- ============================================================
-- 4. SUURIMAD TEHINGUD — TALLINNA KAUPLUS
-- Millised on 10 suurimat müüki Tallinna kaupluses?
-- ============================================================
-- Kontrollib, kas Tallinna tehingud on ootuspärases vahemikus võrreldes kogu andmestikuga.
-- WHERE store_location = 'Tallinn' filtreerib ainult poemüügid.

SELECT sale_id,
       customer_id,
       sale_date,
       total_price
FROM sales
WHERE store_location = 'Tallinn'
ORDER BY total_price DESC
LIMIT 10;

-- Tulemus: Suurimad tehingud jäävad vahemikku 1 858,95 kuni 2 170,40 EUR.
-- Järeldus: Esialgsel vaatlusel ei paista suurimate tehingute seas ebarealistlikke väärtusi.

-- ============================================================
-- 5. VÄIKSEIMAD TEHINGUD — ANDMEKVALITEEDI KONTROLL
-- Kas leidub negatiivseid, null- või kahtlasi summasid?
-- ============================================================
-- Üks olulisemaid andmekvaliteedi kontrolle.
-- Negatiivsed summad viitavad kas tagastustele, mis on sisestatud müügina, või andmevigetele.

SELECT sale_id,                     -- müügitehingu ID
       customer_id,                 -- kliendi ID
       sale_date,                   -- müügi kuupäev
       total_price                  -- tehingu kogusumma
FROM sales
WHERE total_price <=0               -- filtreerib 0 ning negatiivse väärtusega andmed aruandesse
OR total_price IS NULL              -- kaasab ka tehingud, kus müügisumma puudub (NULL väärtus)
ORDER BY total_price ASC;           -- Sorteerib kasvavalt, et kõige negatiivsemad summad oleksid tulemuse alguses

-- Järeldus: Päring kuvab kõik negatiivsed, null- või puuduvad summad.

--Täpsustus: 
-- Mitu tehingut on negatiivse summaga ja milline on kogusumma?
-- kui laiaulatuslik on negatiivse summa probleem?
-- Aitab otsustada, kas tegemist on üksikute vigadega või süsteemsema probleemiga (nt tagastused)
SELECT 
COUNT(*) AS neg_tehing_tk,           -- negatiivsete tehingute arv
SUM(total_price) AS neg_tehing_sum   -- negatiivsete tehingute kogusumma
FROM sales        
WHERE total_price < 0;               -- filtreerib ainult negatiivsed tehingud

-- Tulemus:
-- Negatiivsete summade vahemik: -1 405,32 kuni -16,37
-- NULL-väärtuseid ei leitud
-- 0-väärtuseid ei leitud
-- Negatiivseid tehinguid 305
-- Negatiivsete tehingute kogusumma -88 632,61

-- Järeldus:
-- Negatiivsed summad vajavad täiendavat uurimist.
-- Võimalikud põhjused:
--   • toodete tagastused
--   • kreeditarved
--   • andmesisestuse vead

-- Finantsvaade:
-- Kuigi negatiivseid tehinguid on ainult umbes 2% kogu andmestikust, on nende mõju käibele märkimisväärne.
-- Enne ärianalüüsi kasutamist tuleb nende olemus selgitada.

-- ============================================================
-- 6. PUUDUVAD KLIENDIANDMED
-- Mitmel tehingul puudub customer_id?
-- ============================================================
-- COUNT(*) loeb kõiki ridu, COUNT(customer_id) jätab NULL vahele.
-- Vahe = tehingud, kus klient on teadmata.
-- Toomas: "Ma ei usalda andmeid" — see kontrollib olulist aspekti.

SELECT COUNT(*)                    AS tehinguid_kokku,
       COUNT(customer_id)          AS tehinguid_kliendiga,
       COUNT(*) - COUNT(customer_id) AS puuduvad_kliendid
FROM sales;

-- Tulemus: 1 487 tehingul puudub customer_id (~9,8% kõigist).

-- Järeldus:
-- Müügitulu analüüsi see otseselt ei mõjuta, kuid vähendab kliendikäitumise analüüsi kvaliteeti.
-- Küsimus Roll D-le: Kas puuduvad kliendid esinevad pigem e-poes või füüsilistes kauplustes?

-- ============================================================
-- 7. TULEVIKU KUUPÄEVADEGA TEHINGUD
-- Kas leidub müüke, mis toimuvad tulevikus?
-- ============================================================

SELECT sale_id,
       sale_date,
       total_price,
       customer_id
FROM sales
WHERE sale_date > CURRENT_DATE
ORDER BY sale_date ASC;

-- Tulemus:
-- Leiti 2 tuleviku kuupäevaga tehingut.

-- Järeldus:
-- Müügitehing ei saa tavapäraselt toimuda tulevikus.
-- Tõenäoliselt on tegemist andmesisestuse veaga.

-- Mõju:
-- Probleem on väikesemahuline, kuid võib moonutada perioodipõhiseid aruandeid.

-- ============================================================
-- 8. KOONDÜLEVAADE
-- Kõik olulisemad kvaliteedinäitajad ühes päringus
-- ============================================================

-- Lisaanalüüs:
-- Kasutab CASE WHEN konstruktsiooni, mida uurisin iseseisvalt väljaspool nädala kohustuslikku materjali.

SELECT COUNT(*)                          AS tehinguid_kokku,
       COUNT(*) - COUNT(customer_id)     AS puuduvad_kliendid,
       COUNT(CASE WHEN total_price < 0
                  THEN 1 END)            AS negatiivsed_summad,
       COUNT(CASE WHEN sale_date > CURRENT_DATE
                  THEN 1 END)            AS tuleviku_kirjed,
       MIN(total_price)                  AS väikseim_summa,
       MAX(total_price)                  AS suurim_summa,
       SUM(Total_price)                  AS tehingute_koguväärtus
FROM sales;
                                       
-- Järeldus:
-- Päring koondab peamised andmekvaliteedi näitajad ühte vaatesse ning võimaldab kiiret juhtimisülevaadet.

-- ============================================================
-- KOKKUVÕTE TOOMASELE
-- ============================================================

-- Analüüsitud müügitehinguid: 15 234
--
-- Peamised leiud:
-- • 1 487 tehingul (~9,8%) puudub customer_id
-- • 305 tehingut (~2,0%) sisaldavad negatiivset summat
-- • Negatiivsete tehingute koguväärtus on -88 632,61 EUR
-- • 2 tehingul esineb tuleviku kuupäev
-- • NULL- või 0-väärtusega müügisummasid ei leitud
--
-- Üldhinnang:
-- Andmestik on valdavalt kasutuskõlblik ning suuri struktuurseid probleeme ei tuvastatud.
--
-- Enne andmete kasutamist ärianalüüsis soovitan:
-- • selgitada negatiivsete tehingute olemus
-- • kontrollida tuleviku kuupäevade põhjuseid
-- • hinnata puuduva customer_id mõju kliendianalüüsile
--
-- Suurim võimalik mõju ärianalüüsi kvaliteedile tuleneb negatiivsetest tehingutest, mille koguväärtus on -88 632,61 EUR.
--
-- ============================================================