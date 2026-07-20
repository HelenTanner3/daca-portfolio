# Nädal 1: SQL põhitõed — müügiandmete uurimine

## Eesmärk

UrbanStyle.ltd IT-juht vajas enne edasist analüüsi ülevaadet `sales` tabeli mahust, struktuurist ja peamistest andmekvaliteedi riskidest.

## Minu roll

**Roll A — müügiandmete uurija** meeskonnas Operations Intelligence.

Uurisin SQL-i abil müügitehingute arvu ja struktuuri, suurimaid ja väikseimaid tehinguid, puuduvaid `customer_id` väärtusi ning tuleviku kuupäevaga kirjeid.

## Peamised tulemused

- `sales` tabelis oli **15 234 müügirida**.
- **305 tehingut** olid negatiivse summaga; nende koguväärtus oli **−88 632,61 eurot**.
- **1 487 tehingul** ehk ligikaudu **9,8%-l** puudus `customer_id`.
- Leiti **2 tuleviku kuupäevaga tehingut**.

## Järeldus

Andmestik sobib esmaseks uurimiseks, kuid enne käibe-, perioodi- ja kliendianalüüsi kasutamist tuleb määratleda negatiivsete tehingute käsitlus, kontrollida tuleviku kuupäevad ning arvestada puuduvate kliendiseoste mõjuga.

## Kasutatud oskused ja tööriistad

`SELECT`, `WHERE`, `ORDER BY`, `LIMIT`, `COUNT`, `SUM` ja täiendavas koondpäringus `CASE WHEN`; PostgreSQL / Supabase, VS Code ning GitHub.

## AI kasutamine

AI-d kasutasin nädala jooksul õppematerjalide mõtestamisel, SQL-päringute loogika ja võimalike vigade kontrollimisel ning artefakti ja dokumentatsiooni vormistamisel.

## Artefaktid

- [SQL-päringud](week1_role_a_sales_exploration.sql)
- [Detailne analüüs](analysis.md)
- [Tulemuste kuvatõmmised](screenshots/)
- [Meeskonna ühine Nädal 1 töö](https://github.com/Kolju3/DACA-group/tree/main/week-1/group)

> **Märkus.** Kuvatõmmistel nähtav SQL-päringu algne nimi erineb GitHubis kasutatavast failinimest, sest failid nimetasin portfoolio korrastamisel ümber. Päringute sisu ja ajaloolisi tulemusi ei muudetud.