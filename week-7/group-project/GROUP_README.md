# UrbanStyle — Week 7: RFM kliendisegmenteerimine

## Eesmärk

Nädala 7 grupitöö eesmärk oli kasutada **Pythonit ja pandas't**, et muuta UrbanStyle'i tehinguandmed kliendipõhiseks RFM-vaateks ning anda Markole alus sihitud klienditegevusteks.

RFM mõõdab:

- **Recency** — kui kaua on möödunud kliendi viimasest ostust;
- **Frequency** — mitu ostu / müügikirjet on kliendil;
- **Monetary** — kui suur on kliendi analüüsitud kogukulutus.

## Rollid

| Roll | Vastutus | Tegija |
|---|---|---|
| **A — Data Loading** | Supabase'i ühendus, andmete täielik laadimine ja tabelite ühendamine | Natalia |
| **B — Data Cleaning** | NULL-väärtused, duplikaadid, kuupäevatüüp ja analüüsiks sobivate ridade valik | Olga |
| **C — RFM Analysis** | RFM-näitajad, skoorid, kliendisegmendid ja CSV eksport | Helen |
| **D — Visualization** | Plotly visualiseeringud ja äritõlgendus | Kalju |

## Töövoog ja kontrollväärtused

```text
Supabase
  ↓
sales 10 118 rida + customers 3 150 rida
  ↓
LEFT merge customer_id alusel → 10 118 × 20
  ↓
andmete puhastamine → 8 950 tehingurida
  ↓
2 540 unikaalset klienti
  ↓
Recency + Frequency + Monetary
  ↓
RFM-skoorid 1–5 → kliendisegmendid
  ↓
Plotly visualiseeringud + rfm_segments.csv
```

Roll A-s kasutatakse Supabase'i 1000 rea piirangu tõttu lehekülgede kaupa laadimist. Kui Supabase ei ole kättesaadav, on notebook'is olemas CSV-varuvariant. Ühendamisel kasutatakse `LEFT` merge'i, et säilitada müügiread.

Roll B eemaldab RFM-i jaoks kasutuskõlbmatud read: puuduva `customer_id`, `sale_date` või `total_price` väärtusega read ning mittepositiivse `total_price` väärtusega read. `sale_date` teisendatakse kuupäevatüübiks.

## RFM-tulemused

| Segment | Kliente | Klientide osakaal | Analüüsitud Monetary osakaal |
|---|---:|---:|---:|
| **VIP Champions** | 455 | 17,91% | 42,82% |
| **Loyal** | 679 | 26,73% | 29,75% |
| **Potential** | 759 | 29,88% | 19,49% |
| **At Risk** | 529 | 20,83% | 7,18% |
| **Lost** | 118 | 4,65% | 0,76% |

**VIP + Loyal** moodustavad kokku **44,65% klientidest**, kuid **72,57% analüüsitud Monetary väärtusest**. See näitab, et suur osa kliendiväärtusest on koondunud suhteliselt väiksemasse kliendirühma.

Roll D arvutus näitas lisaks, et **10 suurima Monetary väärtusega VIP Champion klienti moodustavad 8,64% RFM-analüüsi kaasatud käibest**. Analüüsitud Monetary kogusumma on ligikaudu **2,677 mln €**.

## Visualiseeringud

Roll D lisas kolm interaktiivset Plotly graafikut:

1. **Klientide jaotus segmentide kaupa** — näitab segmentide osakaalu ja klientide arvu.
2. **Aeg viimasest ostust vs kliendi kogukulutus** — Recency–Monetary hajuvusdiagramm logaritmilisel Y-teljel; värv näitab segmenti ja punkti suurus ostusagedust.
3. **Top 10 VIP Champions osakaal** — võrdleb 10 suurima Monetary väärtusega VIP-kliendi osakaalu ülejäänud RFM-klientidega.

## Äritõlgendus Markole

- **VIP Champions** — hoida ja tunnustada: personaalsed pakkumised, varajane ligipääs, VIP-teenused. Väärtuslikke kliente ei ole põhjust automaatselt allahindlustega sihtida.
- **Loyal** — kasvatada VIP-suunas: lojaalsuse tugevdamine, lisamüük ja personaalsed soovitused.
- **Potential** — suurim kliendigrupp; sobib lojaalsuse kasvatamise ja järgmise ostu stimuleerimise testideks.
- **At Risk** — prioriseerida eelkõige kõrgema Monetary väärtusega riskikliendid ning testida sihitud win-back tegevusi, mitte teha kogu segmendile automaatselt sama kulukat kampaaniat.
- **Lost** — madala Monetary osakaalu tõttu sobib pigem madala kuluga reaktivatsioon või testkampaania.

RFM **ei näita otseselt hinnatundlikkust**. Selle väitmiseks oleks vaja täiendavaid andmeid, näiteks kampaaniareaktsiooni, hinna- või allahindluse kasutust. Seetõttu ei käsitleta `Potential` ja `At Risk` kliente automaatselt hinnatundlikena.

## Piirangud ja kvaliteedikontroll

- Roll C kasutab koolituse juhendis ette antud RFM-viitekuupäeva **2025-02-28**, kuid puhastatud müügiandmed ulatuvad **2026-06-28**-ni. Seetõttu tekib **25 kliendil negatiivne Recency**. See on viitekuupäeva ja andmevahemiku vastuolu, mitte RFM-koodi arvutusviga.
- `Monetary` tähendab selles analüüsis kliendi **kogukulutust / müügitulu**, mitte kasumit ega marginaali.
- `Frequency` põhineb `sale_id` kirjete arvul. Kui üks tellimus koosneks mitmest müügireast, tuleks ostusageduse definitsioon eraldi üle vaadata.
- Roll B duplikaadikontroll kasutab `invoice_id` välja; täielikult identsete ridade kontroll on sellest eraldi küsimus.
- Roll D põhivaated kasutavad baastaseme veergu `Segment`. Notebook'is olev `Weighted_RFM_Score` ja `Advanced_Segment` on vabatahtlik edasijõudnute osa ning neid ei segata põhisegmentatsiooniga.
- Top 10 VIP graafiku puhul on täpsem kasutada sõnastust **„osakaal RFM-analüüsi kaasatud käibest“**, mitte kogu ettevõtte müügikäibest, sest RFM-i sisendist on eemaldatud analüüsiks sobimatud read.

## AI kasutamine

AI-d kasutati pandas- ja Supabase'i koodi kontrollimisel, veaotsingul, RFM-loogika ja visualiseerimiskoodi lahtimõtestamisel ning dokumentatsiooni struktureerimisel. Kõik lõpptulemused kontrolliti notebook'i väljundite ja referentsväärtustega.

## Failid

- [`urbanstyle_operatsioonid_week7_(a_b_c_d).ipynb`](urbanstyle_operatsioonid_week7_(a_b_c_d).ipynb) — grupi koondnotebook
- [`rfm_segments.csv`](rfm_segments.csv) — RFM kliendisegmendid


