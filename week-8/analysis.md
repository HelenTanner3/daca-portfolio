# Nädal 8 detailanalüüs — Python API-d ja automatiseeritud pipeline

## 1. Töö kontekst ja eesmärk

Nädal 8 viis varasema pandas-põhise analüüsi edasi automatiseeritud töövoo suunas. Koolituse eesmärk oli ühendada andmete pärimine, töötlemine, visualiseerimine ja eksport mooduliteks ning käivitada need ühe pipeline'ina.

Minu ametlik roll oli **Roll D — Automation Script (automatiseerimise skript)**.

Minu põhiülesanne oli:
- importida Rollide A, B ja C funktsioonid;
- siduda need `run_pipeline()` funktsioonis õigesse järjekorda;
- anda kuupäevaparameeter edasi Roll A andmepäringule;
- lisada logimine, veakäsitlus ja täitmisaja mõõtmine;
- kontrollida, et A → B → C → D töövoog jõuab ühe käsuga andmete pärimisest väljundfailideni.

Nädala jooksul tekkis lisaks ametlikule Roll D tööle kaks eraldi täiendavat protsessi:
1. **A–B–C diagnostiline integratsioonitest** enne lõpliku grupiversiooni kinnitamist;
2. **RFM automatiseerimise edasiarendus** pärast grupitöö valmimist ja esitlusel saadud tagasisidet.

Need on säilitatud eraldi `additional-analysis/` kaustas, sest nende eesmärk ja ajastus olid erinevad.

---

## 2. Ametlik grupitöö arhitektuur

Neljaliikmelise meeskonna töö jaotus oli:

| Roll | Vastutus | Põhifail |
|---|---|---|
| Roll A | API andmete pärimine | `data_fetcher.py` |
| Roll B | andmete töötlemine ja puhastamine | `transform.py` |
| Roll C | visualiseerimine ja eksport | `visualize_export.py` |
| Roll D | moodulite orkestreerimine | `pipeline.py` |

Tervikvoog:

```text
Supabase API
    ↓
fetch_sales() + fetch_customers()
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

Roll D ei kirjuta A, B ega C äriloogikat uuesti. Roll D ülesanne on tagada, et moodulid töötavad koos õigete sisendite, väljundite ja parameetritega.

Lõpliku grupitöö koopia on säilitatud [`group-project/`](group-project/) kaustas koos algse grupi README, väljundite ja lähtecommit'iga.

---

## 3. Kuupäevaparameeter

Pipeline'i saab käivitada kogu saadaoleva andmestikuga:

```powershell
python pipeline.py
```

või kuupäevapiiranguga:

```powershell
python pipeline.py --date 2025-03-01
```

Kasutatud loogikas antakse `--date` edasi Roll A `fetch_sales()` funktsioonile lõppkuupäevana ning API filter kasutab tingimust:

```text
sale_date < 2025-03-01
```

Seega kuuluvad analüüsi müügid kuni 28.02.2025.

---

## 4. Täiendav protsess 1 — A–B–C diagnostiline integratsioonitest

Enne lõpliku grupiversiooni kinnitamist lõin eraldi diagnostilise integratsioonikeskkonna:

[`additional-analysis/abc-integration-test/`](additional-analysis/abc-integration-test/)

Selle eesmärk oli kontrollida, kuidas A, B ja C tööversioonid päriselt kokku sobivad enne lõpliku Roll D pipeline'i kinnitamist.

Diagnostilisse pipeline'i lisasin kontrollid:
- `id` ja `sale_id` unikaalsusele;
- `invoice_id` duplikaatidele;
- kriitilistele NULL-väärtustele;
- mittepositiivsetele müügisummadele;
- puhastamisel eemaldatud ridade arvule;
- vahetulemuste ja KPI-de kooskõlale.

### Täisandmestiku diagnostiline jooks

| Kontroll | Tulemus |
|---|---:|
| `sales` | 10 118 |
| `customers` | 3 150 |
| Ühendatud andmestik | 10 118 |
| `id` unikaalseid | 10 118 |
| `sale_id` unikaalseid | 10 118 |
| `invoice_id` duplikaate | 0 |
| `customer_id` NULL | 988 |
| `sale_date` NULL | 0 |
| `total_price` NULL | 0 |
| `total_price <= 0` | 195 |
| NULL `customer_id` ja `total_price <= 0` kattuvus | 15 |
| Välistatud unikaalseid ridu | 1 168 |
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

See test ei asendanud grupitööd. Selle eesmärk oli teha rollidevahelised eeldused ja andmekvaliteet nähtavaks enne lõpliku pipeline'i kinnitamist.

---

## 5. Pagination'i vea avastamine ja kontroll

Kuupäevafiltriga API päringu esialgne tulemus oli:

```text
rows: 10086
id unique: 10026
sale_id unique: 10026
duplicate id: 60
duplicate sale_id: 60
```

Ridade koguarv 10 086 tundus esmapilgul õige, kuid ainult 10 026 rida olid unikaalsed. See tähendas, et:
- 60 rida esinesid kaks korda;
- 60 tegelikku rida jäid päringu tulemusest välja.

Probleem oli seotud offset-pagination'i ebastabiilse järjestusega. Pärast stabiilse järjestuse lisamist:

```python
.order("id")
```

oli tulemus:

```text
rows: 10086
id unique: 10086
sale_id unique: 10086
duplicate id: 0
duplicate sale_id: 0
```

Oluline õppetund oli, et edukas API vastus ja isegi õige ridade koguarv ei tõenda veel andmestiku korrektsust. Pagination'i puhul tuleb kontrollida ka võtmete unikaalsust ja vajaduse korral võrrelda puuduvaid kirjeid referentsandmestikuga.

---

## 6. Lõplik valideeritud Roll D jooks

Pärast pagination'i ja kuupäevafiltri kontrollimist käivitati lõplik pipeline:

```powershell
python pipeline.py --date 2025-03-01
```

| Kontroll | Tulemus |
|---|---:|
| Müügiridu pärast API filtrit | 10 086 |
| Unikaalseid `id` väärtusi | 10 086 |
| Unikaalseid `sale_id` väärtusi | 10 086 |
| Duplikaate `id` / `sale_id` järgi | 0 |
| Kliendiridu | 3 150 |
| Unikaalseid `customer_id` väärtusi | 3 150 |
| Ühendatud ridu | 10 086 |
| Puhastatud ridu | 8 923 |
| Eemaldatud ridu | 1 163 |
| Nädalaid | 114 |
| Kogukäive | 2 669 027,39 € |
| Unikaalseid kliente | 2 540 |
| Keskmine ostusumma | 299,12 € |

Pipeline jõudis lõpuni ilma veata ning lõppväljundid tekkisid.

Valideerimise tõendusmaterjal:

![Pipeline'i käivitamise valideerimine](output/pipeline_execution_validation.png)

---

## 7. Lõplikud väljundid

Nädal 8 põhiartefakti väljundid on `output/` kaustas. Lõpliku grupitöö koopia koos samade põhiväljunditega on säilitatud ka `group-project/output/` kaustas.

Grupitöö lõppversiooni väljundid hõlmavad:
- `results_20260812.csv` — nädalane koondandmestik;
- `weekly_revenue.html` ja `weekly_revenue.png` — nädalase käibe trend;
- `kpi_summary.html` ja `kpi_summary.png` — KPI-vaade;
- `pipeline_execution_validation.png` — lõpliku terminalikäivituse valideerimine.

HTML-väljundid säilitavad Plotly interaktiivsuse, PNG-failid sobivad GitHubi ja esitlusse ning CSV annab koondandmed edasiseks kasutamiseks.

---

## 8. CSV fallback ja selle piirang

Grupiversioonis testiti olukorda, kus Supabase päring sunniti ebaõnnestuma. Pipeline leidis kohalikud CSV-failid, laadis `sales` ja `customers` andmed ning läbis A → B → C → D töövoo edukalt.

Täisandmestiku fallback-test andis:

```text
sales 10118
→ cleaned 8950
→ revenue 2676850.54
→ unique customers 2540
→ AOV 299.09
```

Oluline piirang: testitud CSV fallback ei rakendanud `--date` piirangut täpselt samal viisil nagu Supabase päring. Seetõttu ei tohi API ja CSV kuupäevafiltriga tulemusi käsitleda automaatselt võrdväärsena.

Tootmisvalmis variandis peaks API ja fallback kasutama sama perioodi-, puhastus- ja valideerimisloogikat.

---

## 9. Grupitöö lõppversiooni säilitamine

Pärast grupitöö valmimist säilitasin lõpliku meeskonnatöö isiklikus portfoolios eraldi koopiana:

[`group-project/`](group-project/)

See sisaldab:
- lõplikke A, B, C ja D mooduleid;
- grupi algset README-d;
- isiklikku lühikest README-d koopia konteksti ja lähtecommit'iga;
- lõpliku valideeritud jooksu väljundeid.

Koopia ei asenda algset grupirepot. Selle eesmärk on säilitada minu portfoolios täpselt see tervikversioon, mille kontekstis minu Roll D töö valmis.

---

## 10. Täiendav protsess 2 — RFM automatiseerimine

Pärast Nädal 8 grupitöö valmimist ja esitlusel saadud tagasisidet lisasin eraldi edasiarendusena Nädal 7 RFM-kliendisegmenteerimise Nädal 8 API-pipeline'i.

Kaust:

[`additional-analysis/rfm-automation/`](additional-analysis/rfm-automation/)

### Miks see töö eraldi säilitati?

A–B–C integratsioonitest ja RFM automatiseerimine ei ole sama töö kaks versiooni.

- `abc-integration-test/` tekkis **enne lõpliku grupiversiooni kinnitamist** ning selle eesmärk oli integratsiooni ja andmekvaliteedi diagnostika.
- `rfm-automation/` tekkis **pärast grupitöö valmimist** ning selle eesmärk oli olemasoleva pipeline'i funktsionaalsust edasi arendada.

Seetõttu on mõlemad `additional-analysis/` all, kuid nad dokumenteerivad õppimisprotsessi eri etappe.

### Kuidas RFM lisati?

Aluseks võtsin lõpliku Nädal 8 grupipipeline'i. Olemasolevat põhikoodi ei asendatud, vaid sellele lisati RFM-funktsionaalsus.

`transform.py` täiendati:
- RFM mõõdikute arvutamisega;
- R-, F- ja M-skooridega;
- RFM koondskooriga;
- segmenteerimisega.

`visualize_export.py` täiendati:
- RFM segmentide graafikuga;
- RFM CSV ekspordiga.

`pipeline.py` täiendati:
- RFM arvutuse käivitamisega;
- sama `--date` väärtuse kasutamisega API lõppkuupäeva ja RFM viitekuupäevana;
- RFM tabeli suuruse ja negatiivse Recency kontrolli logimisega.

### Valideeritud RFM tulemus

Käivitamine:

```powershell
python pipeline.py --date 2025-03-01
```

| Kontroll | Tulemus |
|---|---:|
| Puhastatud müügiridu | 8 923 |
| RFM kliente | 2 540 |
| Negatiivseid Recency väärtusi | 0 |
| R/F/M skooride vahemik | 1–5 |
| Frequency summa | 8 923 |
| Monetary summa | 2 669 027,39 € |

Segmentide jaotus:

| Segment | Kliente |
|---|---:|
| Potential | 768 |
| Loyal | 678 |
| At Risk | 524 |
| VIP Champions | 453 |
| Lost | 117 |
| **Kokku** | **2 540** |

Sama kuupäevaparameetri kasutamine nii API filtris kui RFM viitekuupäevana väldib olukorda, kus analüüs sisaldab viitekuupäevast hilisemaid oste ja Recency muutub negatiivseks.

### RFM väljundid

`additional-analysis/rfm-automation/output/` sisaldab:
- `results_20260813.csv`;
- `rfm_segments_20260813.csv`;
- `rfm_segments.html`;
- `rfm_segments.png`;
- `weekly_revenue.html`;
- `weekly_revenue.png`;
- `kpi_summary.html`;
- `kpi_summary.png`;
- `pipeline_with_rfm_execution_validation.png`.

---

## 11. Mida õppisin

Nädal 8 suurim tehniline õppetund ei olnud ainult API kasutamine, vaid automatiseeritud tulemuse tõendamine.

Olulisemad õppetunnid:
- API päringu õnnestumine ei tõenda, et kõik vajalikud read saabusid korrektselt;
- pagination vajab stabiilset järjestust ja unikaalsuskontrolli;
- moodulite eraldamine teeb vea lokaliseerimise lihtsamaks;
- rollidevahelised sisendi- ja väljundilepingud on integratsioonis sama olulised kui üksikute funktsioonide kood;
- `try/except` ja logimine muudavad vea nähtavaks, kuid ei asenda andmekvaliteedi kontrolli;
- API ja fallback peavad kasutama samu ärireegleid, kui nende tulemusi soovitakse võrrelda;
- ühe käsuga käivitatav pipeline ei ole veel sama mis ajastatud tootmisteenus;
- varasema analüüsi automatiseerimisel tuleb säilitada ka selle metoodilised eeldused, näiteks RFM viitekuupäeva loogika.

Kõige olulisem põhimõte:

> Töötav kood ei ole veel tõend õigest tulemusest — vaja on referentsväärtusi, vahetulemuste kontrolli ja ristkontrolle.

---

## 12. Piirangud ja järgmised sammud

Praegune lahendus:
- käivitab kogu töövoo ühe käsuga;
- logib etapid ja vead;
- võimaldab API-põhist kuupäevafiltrit;
- loob automaatselt analüüsi- ja visualiseerimisväljundid.

Praegune lahendus ei ole veel täielikult tootmisvalmis:
- väline scheduler puudub;
- automaatne õnnestumise/ebaõnnestumise teavitus puudub;
- retry-loogika puudub;
- CSV fallback'i kuupäevafiltri loogika ei ole API-ga täielikult võrdväärne;
- kvaliteedikontrollid võiks tulevikus muuta automaatseteks kvaliteediväravateks.

Järgmine loogiline areng oleks:

```text
scheduler
→ pipeline
→ quality checks
→ output
→ success/error notification
```

---

## 13. AI kasutamine

Kasutasin AI-d veaotsingu, integratsioonitestide, kontrollküsimuste ja dokumentatsiooni struktureerimise abivahendina.

AI pakutud hüpoteese ei käsitlenud kontrollväärtusena. Pagination'i, kuupäevafiltri, puhastamise, KPI-de ja RFM tulemused kinnitasin reaalse käivitamise, ridade arvu, võtmete unikaalsuse, DataFrame'ide vahetulemuste ning referentsväärtuste võrdlemisega.

---

## 14. Seotud artefaktid

- [`pipeline.py`](pipeline.py) — ametlik Roll D põhiartefakt
- [`output/`](output/) — isikliku valideerimise väljundid
- [`group-project/`](group-project/) — lõpliku grupitöö koopia
- [`additional-analysis/`](additional-analysis/) — täiendavate tööprotsesside dokumentatsioon
- [`additional-analysis/abc-integration-test/`](additional-analysis/abc-integration-test/) — diagnostiline integratsioonitest
- [`additional-analysis/rfm-automation/`](additional-analysis/rfm-automation/) — RFM automatiseerimise edasiarendus