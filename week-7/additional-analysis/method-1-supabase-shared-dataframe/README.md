# Meetod 1 — Supabase + ühine DataFrame

## Eesmärk

See täiendav analüüs valmis **enne Nädal 7 grupitööd** ettevalmistava tervikläbimisena.

Minu ametlik roll grupitöös oli Roll C — RFM-kliendisegmenteerimine, kuid õppimise eesmärgil läbisin siin iseseisvalt kogu A → B → C → D töövoo:

```text
Supabase
→ andmete laadimine
→ DataFrame'ide kontroll
→ merge
→ puhastamine
→ RFM-arvutus
→ segmenteerimine
→ visualiseerimine
→ äriline tõlgendus
```

Eesmärk ei olnud asendada teiste grupiliikmete rolle, vaid mõista enne grupitööd, kuidas minu Roll C sisend tekib ja kuidas RFM-tulemus liigub edasi visualiseerimise ning äritõlgenduseni.

## Andmeallikas

Andmed laaditi UrbanStyle'i Supabase'i tabelitest:

| Tabel | Ridu |
|---|---:|
| `sales` | 10 118 |
| `customers` | 3 150 |
| `products` | 362 |

Suure `sales` tabeli täielikuks laadimiseks kasutati pagination'it, et ühe päringu 1000 rea piirangut ei tõlgendataks ekslikult kogu tabelina.

## Andmete kontroll ja puhastamine

Enne RFM-arvutust kontrollisin ridade arvu, võtmeid, puuduvaid väärtusi, kuupäevi ja müügisummasid.

Olulisemad kontrollväärtused:

| Kontroll | Tulemus |
|---|---:|
| Ühendatud müügiridu | 10 118 |
| Puuduva `customer_id`-ga ridu | 988 |
| Negatiivse müügisummaga ridu | 195 |
| Mitme välistamise põhjusega ridu | 15 |
| Välistatud unikaalseid ridu | 1 168 |
| RFM-i sobivaid tehinguid | 8 950 |
| RFM-kliente | 2 540 |

Kontrollarvutus:

```text
10 118 - 1 168 = 8 950
```

Negatiivsed ja puuduva klienditunnusega read jäid algse andmestiku kontekstis nähtavaks, kuid neid ei kasutatud RFM-arvutuses.

## RFM viitekuupäev

Koolitusjuhendi näites kasutatud viitekuupäev `2025-02-28` ei sobinud selle Supabase'i andmestiku täieliku ajavahemikuga, sest müügid ulatusid 2026. aastasse.

Seetõttu kasutasin selles ettevalmistavas analüüsis reprodutseeritavat dünaamilist viitekuupäeva:

```text
andmestiku viimane müügikuupäev + 1 päev
= 2026-06-29
```

See tagas, et kõik Recency väärtused olid mittenegatiivsed.

## RFM-metoodika

Kliendipõhiselt arvutati:

- **Recency** — päevade arv viimasest ostust viitekuupäevani;
- **Frequency** — ostutehingute arv;
- **Monetary** — positiivsete müügitehingute koguväärtus.

R-, F- ja M-skoorid määrati viiepunktilisel skaalal ning koondskoori alusel moodustati segmendid:

- VIP Champions;
- Loyal;
- Potential;
- At Risk;
- Lost.

Segmentide jaotus:

| Segment | Kliente |
|---|---:|
| Potential | 759 |
| Loyal | 679 |
| At Risk | 529 |
| VIP Champions | 455 |
| Lost | 118 |
| **Kokku** | **2 540** |

## Peamine tulemus ja õppetund

Selle töö suurim väärtus oli kogu andmevoo läbimine **enne grupitööd**. See aitas näha, et RFM ei alga `groupby()` käsust, vaid sõltub juba varasematest otsustest:

- kas kogu lähteandmestik laaditi;
- kas JOIN säilitas õige ridade arvu;
- millised read puhastamisel eemaldati;
- milline viitekuupäev sobib tegeliku analüüsiperioodiga.

Viitekuupäeva küsimus muutus hiljem oluliseks ka ametlikus grupitöös ja Nädal 7 järelkontrollis.

## Artefakt ja tõendus

Põhiartefakt:

- [`week7_method1_supabase_shared.ipynb`](week7_method1_supabase_shared.ipynb)

Notebook sisaldab:
- Supabase'i andmete laadimist;
- kontroll- ja puhastussamme;
- RFM arvutust;
- segmentatsiooni;
- visualiseeringuid;
- kontrollväärtusi;
- ärilisi järeldusi ja piiranguid.

See fail on säilitatud algse enne grupitööd tehtud terviklahendusena ega ole hilisema teadmise põhjal tagantjärele ümber kirjutatud.

Nädalaülene võrdlus ja õppimisprotsess on kirjeldatud [`../../analysis.md`](../../analysis.md) failis.
