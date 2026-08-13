# Nädal 8 detailne analüüs — Python API-d ja automatiseeritud pipeline

## 1. Analüüsi eesmärk

Nädal 8 eesmärk oli muuta varasem käsitsi tehtav töövoog korduvkasutatavaks automatiseeritud pipeline'iks. Pipeline pidi ühendama andmete hankimise, puhastamise, koondamise, visualiseerimise ja ekspordi üheks järjestikuseks protsessiks.

Minu ametlik roll oli **Roll D — Automation Script**. Minu ülesanne oli importida Rollide A, B ja C funktsioonid, siduda etapid `run_pipeline()` funktsioonis õigesse järjekorda, lisada logimine ja veakäsitlus, mõõta täitmisaega ning kontrollida, et kogu A → B → C → D töövoog käivitub ühe käsuga.

Lõplik isiklik artefakt on [`pipeline.py`](./pipeline.py). See eeldab grupi A/B/C mooduleid; terviklahendus on grupirepos.

## 2. Pipeline'i töövoog

```text
Supabase / data_fetcher.py
        ↓
sales + customers
        ↓
merge_datasets()
        ↓
clean_data()
        ↓
calculate_weekly_aggregates()
calculate_kpis()
        ↓
create_weekly_chart()
create_kpi_summary()
export_results()
        ↓
output/
```

Roll D ei dubleeri teiste moodulite äriloogikat, vaid orkestreerib nende käivitamise, logib etapid ja annab tulemused edasi järgmisele sammule.

## 3. Kuupäevaparameeter

Pipeline'i täiendati nii, et seda saab käivitada ka kuupäevapiiranguga:

```powershell
python pipeline.py --date 2025-03-01
```

`--date` väärtus antakse edasi `fetch_sales()` funktsioonile lõppkuupäevana. Kasutatud loogika on `sale_date < 2025-03-01`, seega kuuluvad analüüsi müügid kuni 28.02.2025.

Ilma `--date` parameetrita käivitub pipeline kogu saadaoleva andmestikuga.

## 4. Diagnostiline integratsioonitest

Enne lõpliku grupiversiooni kinnitamist lõin eraldi diagnostilise integratsiooniversiooni:

[`additional-analysis/abc-integration-test/`](./additional-analysis/abc-integration-test/)

Selles olid koos A, B ja C tööversioonid ning minu diagnostiline `pipeline.py`. Pipeline'i lisasin kontrollid `id` ja `sale_id` unikaalsuse, `invoice_id` duplikaatide, NULL-väärtuste, mittepositiivsete müügisummade ning puhastamisel eemaldatud ridade kontrollimiseks.

Täisandmestiku diagnostiline jooks:

| Kontroll | Tulemus |
|---|---:|
| `sales` | 10 118 |
| `customers` | 3 150 |
| Ühendatud andmestik | 10 118 × 20 |
| `id` unikaalseid | 10 118 |
| `sale_id` unikaalseid | 10 118 |
| `invoice_id` duplikaate | 0 |
| `customer_id` NULL | 988 |
| `sale_date` NULL | 0 |
| `total_price` NULL | 0 |
| `total_price <= 0` | 195 |
| NULL `customer_id` ja `total_price <= 0` kattuvus | 15 |
| Vigaseid ridu puhastusreeglite järgi | 1 168 |
| Puhastatud ridu | 8 950 |

Kontrollarvutus:

```text
988 + 195 - 15 = 1 168
10 118 - 1 168 = 8 950
```

Täisandmestiku KPI-d:

| KPI | Tulemus |
|---|---:|
| Kogukäive | 2 676 850,54 € |
| Unikaalseid kliente | 2 540 |
| Keskmine ostusumma | 299,09 € |
| Nädalaid | 131 |

## 5. Pagination'i vea avastamine

Kuupäevafiltriga API päringu esialgne tulemus oli:

```text
rows: 10086
id unique: 10026
sale_id unique: 10026
duplicate id: 60
duplicate sale_id: 60
```

Ridade koguarv tundus õige, kuid 60 rida kordusid ning sama palju erinevaid ridu jäi tulemusest välja.

Kui offset-pagination'ile lisati stabiilne järjestus:

```python
.order("id")
```

saadi:

```text
rows: 10086
id unique: 10086
sale_id unique: 10086
duplicate id: 0
duplicate sale_id: 0
```

See kinnitas, et offset-pagination vajab stabiilset järjestust. Oluline õppetund oli, et **õnnestunud HTTP vastus ja õige ridade koguarv ei tähenda veel, et päringu tulemus on korrektne**.

## 6. Lõplik valideeritud jooks

Pärast pagination'i ja kuupäevafiltri kontrollimist käivitati:

```powershell
python pipeline.py --date 2025-03-01
```

| Kontroll | Tulemus |
|---|---:|
| Müügiridu pärast API filtrit | 10 086 |
| Unikaalseid `id` väärtusi | 10 086 |
| Unikaalseid `sale_id` väärtusi | 10 086 |
| Duplikaate | 0 |
| Kliendiridu | 3 150 |
| Unikaalseid `customer_id` väärtusi | 3 150 |
| Ühendatud ridu | 10 086 |
| Puhastatud ridu | 8 923 |
| Eemaldatud ridu | 1 163 |
| Nädalaid | 114 |
| Kogukäive | 2 669 027,39 € |
| Unikaalseid kliente | 2 540 |
| Keskmine ostusumma | 299,12 € |

Pipeline jõudis lõpuni ilma veata ja tekitas nõutud väljundid.

## 7. Väljundid

Põhikausta [`output/`](./output/) sisaldab lõpliku valideeritud jooksu artefakte:

- `results_20260812.csv` — nädalased koondandmed;
- `weekly_revenue.html` — interaktiivne nädalase käibe Plotly graafik;
- `kpi_summary.html` — interaktiivne KPI kokkuvõte.

Diagnostilise õppimisversiooni väljundid on eraldi `additional-analysis/abc-integration-test/output/` kaustas ja tähistatud kontrollkäivituse kuupäevaga.

## 8. CSV fallback

Grupiversioonis testiti olukorda, kus Supabase päring sunniti ebaõnnestuma. Pipeline leidis kohalikud CSV-failid, laadis `sales` ja `customers` andmed ning jõudis A → B → C → D töövooga edukalt lõpuni.

Täisandmestiku fallback-test andis sama põhitulemuse:

```text
sales 10118
→ cleaned 8950
→ revenue 2676850.54
→ unique customers 2540
→ AOV 299.09
```

Piirang: testitud fallback-versioonis ei rakendunud `--date` piirang CSV-le samal viisil nagu Supabase päringule. Seetõttu käsitlen CSV fallback'i kuupäevafiltrit eraldi edasiarenduspunktina.

## 9. Mida õppisin

API võimaldab hankida värskemaid andmeid ja rakendada filtreid juba päringu tasemel. CSV fallback on kasulik töökindluse suurendamiseks, kuid sama äriloogika peab toimima mõlema sisendi korral.

Kõige keerulisem integratsioonikoht ei olnud funktsioonide importimine, vaid sisendi korrektsuse kontroll. Pagination'i viga näitas, et pipeline võib tehniliselt töötada, kuid siiski anda vale tulemuse.

`try/except` ja logimine muudavad pipeline'i kasutatavamaks, sest vea korral jääb alles arusaadav teade selle kohta, millises etapis probleem tekkis. Tootmisvalmiduse järgmine samm oleks retry-loogika, automaatne ajastamine ja teavitused.

## 10. AI kasutamine

Kasutasin AI-d veaotsingu, testide koostamise ja kontrollloogika sõnastamise abivahendina. AI pakutud hüpoteese ei käsitlenud lõpptulemusena: pagination'i, kuupäevafiltri ja puhastuse tulemused kinnitasin eraldi käivituste, unikaalsuskontrollide ja KPI-de võrdlemisega.

Kõige olulisem õppetund: **töötav kood ei ole veel tõend õigest tulemusest — vaja on referentsväärtusi ja ristkontrolle.**

## RFM automatiseerimise t�iendus

P�rast Week 8 grupit�� esitlust lisasin t�iendava anal��sina Week 7 RFM-segmentatsiooni olemasolevasse API-pipeline'i.

Sama --date v��rtus juhib nii API l�ppkuup�eva kui ka RFM viitekuup�eva. Valideeritud jooksus oli 8 923 puhastatud m��girida, 2 540 RFM klienti ja 0 negatiivset Recency v��rtust.

T�ienduse detailid ja v�ljundid: additional-analysis/rfm-automation/.
