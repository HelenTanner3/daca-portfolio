# Nädal 2 — SQL-andmete puhastamine

## Eesmärk ja roll

UrbanStyle’i teise nädala ülesanne oli kontrollida andmekvaliteeti turvalises testtabelis, dokumenteerida leiud ning valmistada andmed ette järgmise nädala JOIN-analüüsiks.

Minu ametlik roll oli **Roll B — kliendiandmete puhastaja**. Töötasin `customers` tabeliga ja kasutasin töövoogu **Test → Verify → Log → Commit**.

## Peamised tulemused

- `customers_test` loodi **3 150** reaga ja selle maht vastas algtabelile.
- Leidsin **130 üleliigset kliendikirjet** korduvate mittetühjade e-posti aadresside põhjal.
- Ees- ja perenimedes puuduvad väärtused puudusid.
- Linnaväljal esines **54 algset kirjapilti**, mis koondusid **12 standardiseeritud linnanimeks**; **252 kliendirida** vajas vormingu parandamist.
- E-posti aadress puudus **380 kliendil**, telefoninumber ei puudunud ühelgi kliendil.
- Linnanimede standardiseerimine tehti esmalt testtabelis ja seejärel põhitabelis ning kontrolliti auditilogis.

## Järeldus

Kõige otsesem aruandlusrisk oli linnanimede ebajärjekindlus, sest sama linn jagunes mitme kirjapildi vahel. Kõige suurema ärilise mõjuga andmelünk oli 380 puuduva e-posti aadressiga klienti, sest neid ei saa digikanalites tavapäraselt kaasata.

Duplikaatsete e-posti aadresside käsitlemisel tuleb eristada puuduvat e-posti aadressi tegelikust korduvast aadressist ning otsustada enne kirjete ühendamist, milline kliendikirje säilitada.

## Kasutatud oskused

- `CREATE TABLE AS`
- `GROUP BY` ja `HAVING`
- `FILTER (WHERE ...)`
- `TRIM()` ja `INITCAP()`
- `COUNT(DISTINCT ...)` ja `STRING_AGG()`
- `CASE WHEN` ja `UNION ALL`
- puhastustoimingute kontrollimine ja logimine

## AI kasutamine

AI-d kasutasin koondraporti SQL-i vormistamise ja päringute kontrollimise abivahendina. Tulemused kontrollisin SQL-i väljundite, referentsväärtuste ja puhastustoimingute auditilogi abil.

## Artefaktid

- [Roll B SQL-puhastamisskript](week2_role_b_customer_cleaning.sql)
- [Detailne analüüs](analysis.md)
- [Puhastustoimingute auditilogi](week2_cleaning_log.md)
- [Päringute tõendusmaterjalid](screenshots/)
- [Meeskonna ühine Nädal 2 töö](https://github.com/Kolju3/DACA-group/tree/main/week-2/group)