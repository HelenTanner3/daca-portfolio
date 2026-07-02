# Nädal 2: SQL Puhastamine — Kliendiandmete puhastamine

## Projektikontekst
UrbanStyle.ltd on Eesti moeettevõte, mis on viimase kahe aastaga kasvanud **150%**. See kiire laienemine on tekitanud andmekaose, kus kolm eraldiseisvat süsteemi (e-pood, sularaha ja varude haldus) ei räägi omavahel.

IT-direktor Toomas Kask on hoiatanud, et praeguseid numbreid ei saa usaldada. Minu roll teisel nädalal oli läbi viia andmete puhastamise "kirurgia", järgides ranget protsessi: **Test → Verify → Log → Commit**.

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
- `IS NULL` & `COALESCE()` — puuduvate väärtuste haldamiseks
- `INITCAP()` & `TRIM()` — tekstiväljade ühtlustamiseks
- `FILTER (WHERE ...)` — tingimuspõhine loendamine
- `STRING_AGG()` — erinevate kirjaviiside koondamiseks
- `CREATE TABLE AS` — turvalise testkeskkonna loomiseks
- `UNION ALL` — koondülevaate koostamiseks

## Tehtud analüüs

1. **Test-koopia loomine** — `customers_test` tabel algandmete kaitsmiseks [Link]()
2. **Duplikaatsete e-mailide tuvastamine** — leidsin kliendid, kes on süsteemi sisestatud mitu korda [Link]()
3. **Puuduvate nimede kontrollimine** — NULL ja tühjade stringide tuvastamine kriitilistes väljades [Link]()
4. **Linnanimede kaardistamine** — ebajärjekindlate kirjaviiside tuvastamine kahes etapis [Link_1](), [Link_2]()
5. **Kontaktandmete terviklikkus** — telefoni ja e-maili puudumise kontroll [Link]()
6. **Puhastusraport** — kõik leiud prioriteedi järgi koondatud ühte vaatesse [Link]()

## Peamised leiud

| Näitaja | Leitud probleemid | Prioriteet | Äriline mõju |
|---------|-------------------|------------|--------------|
| Puuduvad e-mailid | 380 (~12%) | **Kriitiline** | Turunduskampaaniad ei jõua nende klientideni |
| Duplikaatsed e-mailid | 128 | **Kõrge** | Moonutab klientide koguarvu ja lojaalsusstatistikat |
| Linnanimede ebakõlad | 42 liigset kirjaviisi | **Kõrge** | Piirkondlik müügianalüüs on ebausaldusvääre |
| Puuduvad nimed | 0 | Puudub | Kõik kirjed on korras |
| Puuduvad telefonid | 0 | Puudub | Kõik kirjed on korras |

## Detailsemad leiud

**Linnanimede probleem** on eriti huvitav näide sellest, kuidas tehniline detail mõjutab ärilist otsust:
- SQL-i loogika järgi on andmestikus **54 erinevat linna**
- Tegelikult on unikaalseid linnanimesid ainult **12**
- **42 "linna"** on tegelikult kordused tühikute ja suur/väiketähtede erinevustest (nt "tallinn", " Tallinn", "TALLINN", "Tallinn ")
- Liis Koppel (operatsioonijuht) ei saa teha kauplustepõhiseid otsuseid enne, kui see on parandatud

## Olulisemad õppetunnid
- **Andmete puhastamine on 80% tööajast** — puhtad andmed on usaldusväärse analüüsi alus
- **SQL loogika vs inimloogika** — SQL-i jaoks on "Tallinn" ja "tallinn" täiesti erinevad objektid
- **Test enne muutmist** — `CREATE TABLE AS` on lihtne viis algandmete kaitsmiseks
- **Dokumentatsioon on kohustuslik** — iga muudatus peab olema logitud, et saaks vajadusel tagasi pöörduda

## Soovitatav puhastamise järjekord
    1. **Linnanimede ühtlustamine** `INITCAP(TRIM())` abil       → kiire ja ohutu, mõjutab kohe aruandlust
    2. **Duplikaatide eemaldamine** `ROW_NUMBER()` meetodiga     → nõuab ettevaatlikkust, Nädal 3 teema
    3. **Puuduvate e-mailide strateegia**                         → äriline otsus, kas koguda aktiivselt või märkida eraldi

## Failid
[week2_customers_cleaning.sql](https://github.com/HelenTanner3/daca-portfolio/blob/main/week-2/W2_GT_B_HT_Customers_Cleaning.sql) — kõik SQL päringud koos kommentaaride, leidude ja järeldustega

## Järgmised sammud
Nädal 3-s õpime SQL JOIN-e — saame ühendada `customers`, `sales` ja `products` tabelid ning hakata vastama keerukamatele äriküsimustele.

---
*See projekt on osa DACA (Data Analyst Career Accelerator) programmist. Ettevõte UrbanStyle.ltd on fiktsioonalne, loodud õppeeesmärkidel.*
