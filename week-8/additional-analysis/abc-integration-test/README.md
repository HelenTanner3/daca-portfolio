# A–B–C integratsioonitest

## Eesmärk

See täiendav töö valmis **enne Nädal 8 lõpliku grupiversiooni kinnitamist**.

Minu ametlik roll oli Roll D — automatiseerimise skript ja tervikpipeline'i orkestreerimine. Enne lõpliku A → B → C → D pipeline'i kinnitamist koondasin Rollide A, B ja C tööversioonid eraldi diagnostilisse keskkonda, et kontrollida:

- kas moodulite sisendid ja väljundid sobivad omavahel;
- kas andmed säilivad rollide vahel ootuspäraselt;
- kas puhastamise mõju on kontrollitav;
- kas KPI-d vastavad referentsväärtustele;
- kas probleem tekib üksikus rollis või rollide integratsioonis.

Tegemist ei ole grupitöö asendusega, vaid Roll D integratsiooni ettevalmistava kvaliteedikontrolliga.

## Töövoog

```text
Roll A — data_fetcher.py
→ Roll B — transform.py
→ Roll C — visualize_export.py
→ diagnostiline pipeline.py
→ kontrollväärtused + väljundid
```

Diagnostilisse pipeline'i lisati rohkem kontrollpunkte kui lõplikus grupiversioonis vaja oli.

## Kontrollitud andmekvaliteet

Kontrolliti muu hulgas:

- `id` unikaalsust;
- `sale_id` unikaalsust;
- `invoice_id` duplikaate;
- kriitilisi NULL-väärtusi;
- `total_price <= 0` ridu;
- probleemsete tingimuste kattuvust;
- merge'i mõju ridade arvule;
- puhastamisel eemaldatud ridu;
- KPI-de kooskõla.

## Täisandmestiku valideerimine

| Kontroll | Tulemus |
|---|---:|
| `sales` ridu | 10 118 |
| `customers` ridu | 3 150 |
| ühendatud ridu | 10 118 |
| unikaalseid `id` väärtusi | 10 118 |
| unikaalseid `sale_id` väärtusi | 10 118 |
| `invoice_id` duplikaate | 0 |
| `customer_id` NULL | 988 |
| `sale_date` NULL | 0 |
| `total_price` NULL | 0 |
| `total_price <= 0` | 195 |
| NULL `customer_id` ja mittepositiivse summa kattuvus | 15 |
| välistatud unikaalseid ridu | 1 168 |
| puhastatud ridu | 8 950 |

Kontrollarvutus:

```text
988 + 195 - 15 = 1 168
10 118 - 1 168 = 8 950
```

## KPI kontroll

| KPI | Tulemus |
|---|---:|
| Kogukäive | 2 676 850,54 € |
| Unikaalseid kliente | 2 540 |
| Keskmine ostusumma | 299,09 € |
| Nädalaid | 131 |

Need väärtused toimisid referentsina järgmiste integratsioonikatsete ja lõpliku pipeline'i valideerimisel.

## Pagination'i probleemi avastamine

Kuupäevafiltriga jooks näitas esialgu:

```text
rows: 10086
id unique: 10026
sale_id unique: 10026
duplicate id: 60
duplicate sale_id: 60
```

Ridade koguarv oli näiliselt õige, kuid 60 rida olid dubleeritud ja 60 tegelikku kirjet jäid puudu.

See oli oluline Roll D kontroll: **õige ridade koguarv ei tähenda automaatselt õiget andmestikku**.

Probleem lokaliseeriti API offset-pagination'i ebastabiilsesse järjestusse. Lõplikus grupiversioonis kasutati stabiilset järjestust:

```python
.order("id")
```

Pärast parandust:

```text
rows: 10086
id unique: 10086
sale_id unique: 10086
duplicate id: 0
duplicate sale_id: 0
```

## Peamine tulemus ja õppetund

Integratsioonitest näitas, miks Roll D töö ei ole ainult olemasolevate funktsioonide järjestikku käivitamine.

Integratsiooni kvaliteedi tõendamiseks oli vaja:
- kontrollida vahetulemusi;
- võrrelda ridade arvu;
- kontrollida võtmete unikaalsust;
- arvutada puhastamise mõju;
- kasutada referents-KPI-sid;
- eristada tehnilist käivitumist andmete korrektsusest.

Kõige olulisem põhimõte:

> Töötav pipeline ei ole veel tõend õigest tulemusest.

## Artefaktid ja tõendus

Kaust sisaldab integratsioonitestiks kasutatud:
- `data_fetcher.py`;
- `transform.py`;
- `visualize_export.py`;
- `pipeline.py`;
- `output/` kausta genereeritud väljundeid.

Need failid säilitavad diagnostilise tööversiooni, mille abil lõpliku grupipipeline'i integratsiooni kontrolliti.

Nädalaülene protsess, lõplik grupijooks ja pagination'i probleemi seos on kirjeldatud [`../../analysis.md`](../../analysis.md) failis.
