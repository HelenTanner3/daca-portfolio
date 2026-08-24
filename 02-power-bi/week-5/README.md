# Nädal 5: visualiseerimise disain — CEO müügidashboard

## Eesmärk

Koostada Power BI Desktopis UrbanStyle’i tegevjuhile selge ühe ekraani juhtimisvaade, mis vastab küsimusele: **kas ettevõte kasvab?**

Ametlik nädalatöö on **Roll A — CEO Dashboard**. Portfoolio PBIX sisaldab lisaks iseseisva enesearendusena läbitöötatud **Roll B — Marketing Dashboardi**.

## Roll A — CEO Dashboard

Juhtimisvaade koondab:

- 2024\. aasta müügitulu;
- ostnud klientide arvu;
- käibekasvu võrreldes 2023. aastaga;
- 2023\. ja 2024. aasta müügitulu kuise võrdluse;
- linnapõhise filtreerimise.

### Peamised tulemused

- 2024\. aasta müügitulu oli **1 470 358,02 eurot**.
- Käive kasvas 2023. aastaga võrreldes **19,1%**.
- 2024\. aastal tegi ostu **2 113 unikaalset klienti**.
- 2024\. aasta müügitulu ületas 2023. aasta taset kõigil kuudel.
- Linnade tulemused olid valdavalt positiivsed, kuid Valga aastane käive jäi veidi 2023. aasta tasemele alla.

## Roll B — täiendav enesearendus

Turundusvaade lisab:

- müügitulu võrdluse müügikanalite lõikes;
- uute ostnud klientide arengu kvartalite lõikes;
- müügitulu ostnud kliendi kohta;
- detailvaate klientide arvu ja müügitulu koosvaatamiseks;
- perioodi, linna ja lojaalsustaseme filtrid.

Roll B käigus lisasin ühise `Calendar`-tabeli, esimese ostu kuupäeva loogika ning aktiivse ja mitteaktiivse kuupäevaseose kasutamise.

## Järeldus

UrbanStyle kasvas 2024. aastal selgelt nii aasta koondtulemuse kui ka kuise müügitulu võrdluse põhjal. Kasv ei olnud piirkondlikult täiesti ühtlane ning määramata linnaga müük moodustas olulise osa kogukäibest.

Täiendav turundusvaade aitab eristada müügikanalite tulemust ja kliendihankimise trendi. Uute klientide analüüsi tõlgendamisel tuleb arvestada, et esimene ost tähendab esimest ostu olemasolevas andmestikus, mitte tingimata kliendi absoluutset esimest ostu enne andmestiku algust.

## Kasutatud oskused ja tööriistad

- Power BI Desktop
- Supabase / PostgreSQL
- DAX-mõõdikud ja arvutatud veerud
- `Calendar`-tabel ja kuupäevaseosed
- `USERELATIONSHIP`
- KPI-kaardid, joondiagrammid ja kombodiagramm
- slicer’id ja filtrikontekst
- visuaalne hierarhia
- värvipimeda-sõbralik värvikasutus
- tulemuste kontroll tabelivaadetes

## AI kasutamine

Kasutasin AI-d DAX-loogika kontrollimiseks, dashboard’ide paigutuse ja disaini hindamiseks, veaotsingu toetamiseks ning äritõlgenduste sõnastamiseks. Kõik mõõdikud, filtrite mõju ja järeldused kontrollisin Power BI-s tegelike tulemuste vastu.

## Artefaktid

- [Power BI tööfail](urbanstyle_week5_dashboard_helen.pbix)
- [Detailne analüüs](analysis.md)
- [Roll A algne dashboard](screenshots/urbanstyle_week5_dashboard_helen.png)
- [Roll A algsed kontrolltabelid](screenshots/urbanstyle_week5_dashboard_helen_validation_tables.png)
- [Roll A uuendatud dashboard](screenshots/v2_urbanstyle_week5_dashboard_helen.png)
- [Roll A uuendatud kontrolltabelid](screenshots/v2_urbanstyle_week5_dashboard_helen_validation_tables.png)
- [Roll B marketing dashboard](screenshots/v2_urbanstyle_week5_dashboard_helen_roll_b.png)
- [Roll B detailvaade](screenshots/v2_urbanstyle_week5_marketing_details_helen_roll_b.png)

## Meeskonna ühine töö

- [UrbanStyle’i nädala 5 meeskonnatöö](https://github.com/Kolju3/DACA-group/tree/main/week-5)
