# Nädal 2: SQL Puhastamine — Kliendiandmete Tervendamine

## Projektikontekst
UrbanStyle.ltd on Eesti moeettevõte, mis on viimase kahe aastaga kasvanud **150%**. See kiire laienemine on tekitanud andmekaose, kus kolm eraldiseisvat süsteemi (e-pood, kassasüsteem ja varude haldus) ei räägi omavahel.

IT-direktor Toomas Kask on hoiatanud, et praeguseid numbreid ei saa usaldada. Minu roll teisel nädalal oli läbi viia andmete puhastamise "kirurgia", järgides ranget protsessi: 
**Test → Verify → Log → Commit**.

## Minu roll: Kliendiandmete puhastaja (Roll B)
**Meeskond:** Operations Intelligence

Minu fookuses oli `customers` tabeli auditeerimine ja ettevalmistamine puhastamiseks. Kuna andmete kustutamine on iseseisva töö faasis keelatud, tegutsesin esmalt "detektiivina" — tuvastasin vigade ulatuse ilma midagi muutmata.

See nädal õpetas mulle, et andmete puhastamine nõuab palju täpsust ja kannatlikkust — iga samm tuleb dokumenteerida ja kontrollida enne järgmise juurde liikumist.

## Kasutatud tööriistad
- **SQL / PostgreSQL** — andmepäringud ja puhastamine
- **Supabase** — andmebaas pilves
- **VS Code** — päringute kirjutamine ja salvestamine
- **GitHub** — koodi versioonihaldus ja portfoolio

## Kasutatud SQL tehnikad
- `GROUP BY` & `HAVING` — duplikaatide leidmiseks
- `IS NULL` & `FILTER (WHERE ...)` — puuduvate väärtuste 
  tingimuspõhiseks loendamiseks
- `INITCAP()` & `TRIM()` — tekstiväljade ühtlustamiseks
- `COUNT(DISTINCT ...)` — unikaalsete kirjaviiside loendamiseks
- `STRING_AGG()` — erinevate kirjaviiside koondamiseks
- `CASE WHEN` — tunnuste lisamiseks vigaste ridade tuvastamisel
- `UNION ALL` — koondülevaate koostamiseks
- `CREATE TABLE AS` — turvalise testkeskkonna loomiseks

## Tehtud analüüs

1. **Test-koopia loomine** — `customers_test` tabel algandmete kaitsmiseks, kontrollisin et ridade arv ühtib originaaliga (3 150 rida) [Link](https://github.com/HelenTanner3/daca-portfolio/blob/main/week-2/kuvat%C3%B5mmised/1%20Testkoopia%20loomine.png)
2. **Duplikaatsete e-mailide tuvastamine** — leidsin kliendid, kes on süsteemi sisestatud mitu korda [Link](https://github.com/HelenTanner3/daca-portfolio/blob/main/week-2/kuvat%C3%B5mmised/2%20duplikaatsed%20e-mailid.png)
3. **Puuduvate nimede kontrollimine** — NULL ja tühjade stringide tuvastamine kriitilistes väljades [Link](https://github.com/HelenTanner3/daca-portfolio/blob/main/week-2/kuvat%C3%B5mmised/3%20puuduvad%20nimed.png)
4. **Linnanimede kaardistamine kahes etapis:**
   - RAW vaade — linnanimede täpne seis andmebaasis [Link 1](https://github.com/HelenTanner3/daca-portfolio/blob/main/week-2/kuvat%C3%B5mmised/4A%20linnade%20nimekujud%20(54rida).png), [Link_2](https://github.com/HelenTanner3/daca-portfolio/blob/main/week-2/kuvat%C3%B5mmised/4B%20linnade%20nimekujud%20kaardistus%20(12rida).png)
   - Probleemide kaardistamine — vigaste ridade loendamine ja eksportimine ecxel [Link](https://github.com/HelenTanner3/daca-portfolio/blob/main/week-2/kuvat%C3%B5mmised/W2_GT_B_HT_Customers_Cleaning_Linnanimed.xlsx)
5. **Kontaktandmete terviklikkus** — telefoni ja e-maili puudumise kontroll [Link](https://github.com/HelenTanner3/daca-portfolio/blob/main/week-2/kuvat%C3%B5mmised/5%20puuduvad%20kontaktandmed.png)
6. **Puhastusraport** — kõik leiud prioriteedi järgi koondatud ühte vaatesse [Link](https://github.com/HelenTanner3/daca-portfolio/blob/main/week-2/kuvat%C3%B5mmised/6%20puhastamisraport.png)

## Peamised leiud

| Näitaja | Leitud probleemid | Prioriteet | Äriline mõju |
|---------|-------------------|------------|--------------|
| Puuduvad e-mailid | **380** (~12%) | **Kriitiline** | Turunduskampaaniad ei jõua nende klientideni |
| Duplikaatsed e-mailid | **130** | **Kõrge** | Moonutab klientide koguarvu ja lojaalsusstatistikat |
| Linnanimede ebakõlad | 42 liigset kirjaviisi, **252** rida (~8%) vajab parandust  | **Kõrge** | Piirkondlik müügianalüüs on ebausaldusvääre |
| Puuduvad nimed | 0 | Puudub | Kõik kirjed on korras |
| Puuduvad telefonid | 0 | Puudub | Kõik kirjed on korras |
|**Kokku probleeme:**| **762 kirjet**| |**~24,2% kõigist klientidest**

## Detailsemad leiud

**Duplikaatsed e-mailid:**
- 126 e-maili aadressi esineb 2 korda
- 2 e-maili aadressi esineb 3 korda
- Kokku 130 duplikaatset kirjet

**Linnanimede probleem:**
- SQL-i loogika järgi on andmestikus **54 erinevat linna**
- Tegelikult on unikaalseid linnanimesid ainult **12**
- **42 "linna"** on tegelikult kordused tühikute ja suur/väiketähtede erinevustest (nt `' Tallinn'`, `'Tallinn '`, `'tallinn'`, `'TALLINN'`)
- **252 kliendirida (~8%)** vajavad linnanimede parandamist

## Olulisemad õppetunnid
- **Andmete puhastamine on 80% tööajast** — puhtad andmed on usaldusväärse analüüsi alus
- **SQL loogika vs inimloogika** — SQL-i jaoks on `'Tallinn'` ja `'tallinn'` täiesti erinevad objektid
- **Test enne muutmist** — `CREATE TABLE AS` on lihtne viis algandmete kaitsmiseks
- **UNION ALL vajab ORDER BY puhul veeru numbrit** — PostgreSQL ei luba `CASE WHEN` avaldist `UNION ALL` päringute `ORDER BY` osas, lahenduseks on lisada igasse `SELECT` lausesse eraldi sorteerimisnumber

## Soovitatav puhastamise järjekord
 - **Linnanimede ühtlustamine** `INITCAP(TRIM())` abil       → kiire ja ohutu, mõjutab kohe aruandlust
 - **Duplikaatide eemaldamine** `ROW_NUMBER()` meetodiga     → nõuab ettevaatlikkust, Nädal 3 teema                                     → `Valmis`  06.juuli seisuga
 - **Puuduvate e-mailide strateegia**                         →  äriline otsus: kas koguda aktiivselt või märkida "puudub" staatusesse

## Failid
- [week2_customers_cleaning.sql](https://github.com/HelenTanner3/daca-portfolio/blob/main/week-2/W2_GT_B_HT_Customers_Cleaning.sql) — kõik SQL päringud koos kommentaaride, leidude ja järeldustega
- [W2_Cleaning_log](https://github.com/HelenTanner3/daca-portfolio/blob/main/week-2/W2_Cleaning_log) - SQL puhastamine - logi sissekanded 
- [W2 Daca-Group-UrbanStyle.ltd](https://github.com/Kolju3/DACA-group/tree/main/week-2/group) - Operatsioonide osakond - Nädal 2: Andmekvaliteedi audit ja SQL puhastamine - Presentatsioon & Readme 

## Järgmised sammud
Nädal 3-s õpime SQL JOIN-e — saame ühendada `customers`, `sales` ja `products` tabelid ning hakata vastama keerukamatele äriküsimustele. Lisaks rakendame 
`ROW_NUMBER()` funktsiooni duplikaatide eemaldamiseks.

---
*See projekt on osa DACA (Data Analyst Career Accelerator) programmist. Ettevõte UrbanStyle.ltd on fiktsioonalne, loodud õppeeesmärkidel.*
