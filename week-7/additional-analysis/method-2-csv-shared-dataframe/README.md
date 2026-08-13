# Meetod 2 — CSV + ühine DataFrame

## Eesmärk

See täiendav analüüs valmis **pärast Nädal 7 grupitööd** iseseisva järelkontrollina.

Eesmärk oli läbida kogu A → B → C → D töövoog veel kord, seekord CSV-lähteandmetega, ning kinnistada:

- pandas'e andmetöötluse tööjärjekorda;
- merge'i ja puhastamise kontrollimist;
- RFM-metoodikat;
- viitekuupäeva ja analüüsiperioodi omavahelist seost;
- kontrollväärtuste kasutamist.

Andmevoog:

```text
toor-CSV
→ df_sales + df_customers
→ merge
→ puhastamine
→ RFM
→ segmenteerimine
→ visualiseerimine
```

## Andmeallikas

Analüüs kasutab kohalikke puhastamata lähtefaile:

- `../data_raw/sales.csv`
- `../data_raw/customers.csv`

Koolituse CSV-varuplaan viitas puhastatud CSV-dele, kuid selles isiklikus õppekatses kasutati teadlikult **toor-CSV-sid**, et läbida iseseisvalt ka Roll B puhastamisloogika.

## Lähteandmete kontroll

| Kontroll | Tulemus |
|---|---:|
| `sales` ridu | 15 234 |
| `customers` ridu | 3 150 |
| korduvaid `invoice_id` väärtusi | 5 116 |
| puuduvaid `customer_id` väärtusi | 1 487 |

CSV-st laadimisel tuli `sale_date` tekstina ning `customer_id` float-tüübina, sest toorandmetes esines puuduvaid kliendi-ID väärtusi.

Kuupäevad teisendati `datetime` tüübiks, arvestades segavormingut. Pärast teisendamist ei jäänud vigaseid kuupäevaväärtusi.

## Viitekuupäeva järelkontroll

Selles analüüsis säilitati koolituse ametlik RFM viitekuupäev:

```text
2025-02-28
```

Erinevalt ametlikust grupitööst piirati aga ka analüüsi sisend sama kuupäevaga:

```python
sale_date <= 2025-02-28
```

Viitekuupäevast hilisemaid müügiridu oli **238** ja need eemaldati enne RFM-arvutust.

Selle tulemusel olid analüüsiperiood ja Recency viitekuupäev omavahel kooskõlas ning negatiivseid Recency väärtusi ei tekkinud.

## Puhastatud andmestik

| Kontroll | Tulemus |
|---|---:|
| RFM-i sobivaid müügiridu | 8 712 |
| unikaalseid kliente | 2 515 |
| kuupäevavahemik | 2023-01-01 kuni 2025-02-28 |
| negatiivseid Recency väärtusi | 0 |

## RFM tulemus

| Segment | Kliente | Osakaal |
|---|---:|---:|
| Potential | 740 | 29,42% |
| Loyal | 684 | 27,20% |
| At Risk | 512 | 20,36% |
| VIP Champions | 455 | 18,09% |
| Lost | 124 | 4,93% |
| **Kokku** | **2 515** | **100,00%** |

Tulemused ei pea olema identsed grupitöö või Meetod 1 tulemustega, sest lähteandmestik ja puhastusreeglid ei ole identsed.

## Peamine tulemus ja õppetund

Meetod 2 kinnitas, et sama RFM-loogika võib anda erineva tulemuse, kui muutuvad:

- andmeallikas;
- andmete seis;
- puhastusreeglid;
- analüüsiperiood.

Oluline järelkontroll oli viitekuupäeva probleem: negatiivse Recency vältimiseks peab viitekuupäev olema kooskõlas analüüsitavate tehingute perioodiga.

See töö ei ole Meetod 1 „parandatud versioon“, vaid hilisem iseseisev kontroll, mis näitab õppimisprotsessi järgmist etappi.

## Artefakt ja tõendus

Põhiartefakt:

- [`week7_method2_csv_shared.ipynb`](week7_method2_csv_shared.ipynb)

Notebook sisaldab:
- CSV andmete laadimist;
- merge'i kontrolli;
- andmetüüpide korrastamist;
- puhastamise mõju kontrolli;
- viitekuupäeva filtrit;
- RFM arvutust;
- segmentatsiooni;
- visualiseeringuid;
- TOP 10 kontrolli;
- lõppkontrolli.

Kasutatud toorandmed asuvad [`../data_raw/`](../data_raw/) kaustas.

Nädalaülene võrdlus ja õppimisprotsess on kirjeldatud [`../../analysis.md`](../../analysis.md) failis.
