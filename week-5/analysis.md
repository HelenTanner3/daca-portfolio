# Nädal 5: CEO müügidashboard — detailne analüüs

## 1. Analüüsi eesmärk

Analüüsi eesmärk oli vastata UrbanStyle’i tegevjuhi põhiküsimusele:

> **Kas UrbanStyle kasvab?**

Selleks koostasin Power BI Desktopis ühe ekraani juhtimisvaate, mis ühendab kolm kõrgtaseme KPI-d ja 2023.–2024. aasta kuise müügitulu võrdluse.

## 2. Kasutatud andmed

Power BI-sse laadisin Supabase’i PostgreSQL andmebaasist tabelid:

- `public sales`
- `public customers`

Tabelid seoti välja `customer_id` kaudu suhtes:

```text
public customers[customer_id]  1 ─── *  public sales[customer_id]
```

Peamised kasutatud väljad:

| Tabel | Väli | Kasutus |
|---|---|---|
| `public sales` | `sale_date` | aasta ja kuu |
| `public sales` | `total_price` | müügitulu |
| `public sales` | `customer_id` | ostnud klientide arv |
| `public customers` | `city` | linnapõhine filter ja kontrollanalüüs |

## 3. Mõõdikute definitsioonid

### Müügitulu

```DAX
Müügitulu =
SUM('public sales'[total_price])
```

### 2023. aasta müügitulu

```DAX
Müügitulu 2023 =
CALCULATE(
    [Müügitulu],
    'public sales'[sale_date] >= DATE(2023, 1, 1),
    'public sales'[sale_date] < DATE(2024, 1, 1)
)
```

### 2024. aasta müügitulu

```DAX
Müügitulu 2024 =
CALCULATE(
    [Müügitulu],
    'public sales'[sale_date] >= DATE(2024, 1, 1),
    'public sales'[sale_date] < DATE(2025, 1, 1)
)
```

### Käibe kasv 2024 vs 2023

```DAX
Käibe kasv 2024 vs 2023 =
DIVIDE(
    [Müügitulu 2024] - [Müügitulu 2023],
    [Müügitulu 2023]
)
```

### Ostnud kliendid 2024

```DAX
Ostnud kliendid 2024 =
CALCULATE(
    DISTINCTCOUNT('public sales'[customer_id]),
    'public sales'[sale_date] >= DATE(2024, 1, 1),
    'public sales'[sale_date] < DATE(2025, 1, 1),
    'public sales'[customer_id] <> BLANK()
)
```

Näitajaga mõõdetakse 2024. aastal vähemalt ühe ostuga seotud unikaalseid kliente, mitte kõiki kliendibaasi registreeritud kliente.

## 4. Põhitulemused

| Näitaja | Tulemus |
|---|---:|
| Müügitulu 2023 | 1 234 758,90 € |
| Müügitulu 2024 | 1 470 358,02 € |
| Müügitulu suurenemine | 235 599,12 € |
| Käibe kasv 2024 vs 2023 | 19,1% |
| Ostnud kliendid 2024 | 2 113 |

UrbanStyle’i 2024. aasta müügitulu kasvas 2023. aastaga võrreldes 235 599,12 euro võrra. Aastane kasv oli 19,1%.

## 5. Müügitulu kuude lõikes

| Kuu | Müügitulu 2023 | Müügitulu 2024 | Kasv |
|---|---:|---:|---:|
| Jaanuar | 79 735,03 € | 85 618,65 € | 7,4% |
| Veebruar | 80 345,68 € | 90 181,83 € | 12,2% |
| Märts | 91 499,55 € | 109 559,98 € | 19,7% |
| Aprill | 99 914,07 € | 113 838,38 € | 13,9% |
| Mai | 95 316,25 € | 116 843,02 € | 22,6% |
| Juuni | 125 537,50 € | 144 558,18 € | 15,2% |
| Juuli | 122 685,53 € | 146 800,80 € | 19,7% |
| August | 120 330,64 € | 144 870,17 € | 20,4% |
| September | 96 388,48 € | 109 267,47 € | 13,4% |
| Oktoober | 94 805,06 € | 127 622,32 € | 34,6% |
| November | 99 096,52 € | 110 573,94 € | 11,6% |
| Detsember | 129 104,59 € | 170 623,28 € | 32,2% |
| **Kokku** | **1 234 758,90 €** | **1 470 358,02 €** | **19,1%** |

2024. aasta müügitulu ületas 2023. aasta taset kõigil kuudel. Suurim protsentuaalne erinevus oli oktoobris ja detsembris, kuid CEO vaate põhijäreldus põhineb kogu aasta kasvul, mitte üksikul kuul.

## 6. Linnade aastavõrdlus

| Linn | Müügitulu 2023 | Müügitulu 2024 | Kasv |
|---|---:|---:|---:|
| Tallinn | 434 603,49 € | 499 652,62 € | 15,0% |
| Tartu | 230 786,33 € | 262 593,48 € | 13,8% |
| Pärnu | 147 997,14 € | 196 675,23 € | 32,9% |
| Linn määramata | 118 903,92 € | 149 556,78 € | 25,8% |
| Narva | 54 767,47 € | 60 026,30 € | 9,6% |
| Viljandi | 41 975,32 € | 51 761,90 € | 23,3% |
| Rakvere | 40 359,33 € | 45 512,61 € | 12,8% |
| Jõhvi | 33 159,21 € | 39 437,19 € | 18,9% |
| Haapsalu | 27 167,39 € | 38 735,76 € | 42,6% |
| Kuressaare | 34 567,44 € | 36 999,11 € | 7,0% |
| Võru | 20 271,86 € | 33 736,62 € | 66,4% |
| Valga | 28 715,67 € | 28 140,10 € | -2,0% |
| Paide | 21 484,33 € | 27 530,32 € | 28,1% |

Enamik linnu kasvas. Aasta kokkuvõttes jäi ainult Valga 2023. aasta tasemele veidi alla.

### Määramata linnaga müük

Tühja linnaväärtust ei filtreeritud analüüsist välja, sest selle eemaldamisel kaoks oluline osa müügitulust.

- 2024\. aasta määramata linnaga müügitulu: **149 556,78 eurot**
- osakaal 2024. aasta kogukäibest: ligikaudu **10,2%**
- kasv võrreldes 2023. aastaga: **25,8%**

Seda väärtust ei tõlgendatud automaatselt online-müügina, sest tühja linna täpne äriline tähendus vajab eraldi andmekvaliteedi kontrolli.

## 7. Dashboard’i disainiotsused

Dashboard’i ülesehitus järgib visuaalset hierarhiat:

1. KPI-kaardid ülemises reas;
2. suur joondiagramm peamise visuaalina;
3. lühike aasta põhisõnum diagrammi all;
4. kompaktne linnafilter paremas ülanurgas.

Olulisemad disainiotsused:

- 2024\. aasta joon kasutab UrbanStyle’i teal-värvi `#009B8D`;
- 2023\. aasta on neutraalne hall võrdlusbaas;
- legend asendati joonte lõpus olevate otsesiltidega;
- eemaldati üleliigsed dekoratiivsed elemendid;
- kogu vaade mahub ühele ekraanile;
- värv ei ole ainus eristusviis, sest aastad on ka tekstina tähistatud.

## 8. Interaktiivsus

Linna slicer võimaldab valida ühe linna ning filtreerib:

- 2024\. aasta müügitulu KPI-d;
- ostnud klientide arvu;
- käibekasvu;
- mõlema aasta kuist trendi.

Dashboard’i all olev **„Aasta põhisõnum”** kirjeldab kogu ettevõtte tulemust ja on staatiline tekst. See ei muutu automaatselt linnavaliku järgi.

## 9. Kontrollid

Töö käigus kontrollisin:

- 2023\. ja 2024. aasta kogusummade vastavust kuude summale;
- kasvuprotsendi arvutusloogikat;
- kuude kronoloogilist järjestust;
- 2025\. ja 2026. aasta välistamist põhivõrdlusest, sest need ei ole võrreldavad täisaastad;
- linnasliceri mõju KPI-dele ja joondiagrammile;
- tühja linnaväärtuse mõju kogukäibele.

## 10. Piirangud

- Ligikaudu 10,2% 2024. aasta müügitulust on seotud määramata linnaga.
- Dashboard näitab, et käive kasvas, kuid ei selgita täielikult, kas kasvu vedas klientide arvu, ostusageduse või keskmise ostukorvi muutus.
- Ostnud klientide arv on esitatud ainult 2024. aasta kohta; kliendibaasi aastase kasvu hindamiseks tuleks võrrelda ka 2023. aasta näitajat.
- Staatiline aasta põhisõnum ei muutu koos linnasliceriga.
- 2025\. ja 2026. aasta osalisi perioode ei kasutatud täisaastate võrdluses.

## 11. Järeldus

UrbanStyle’i 2024. aasta müügitulu kasvas 2023. aastaga võrreldes **19,1%** ning kasv oli positiivne kõigil kuudel. Linnade tulemused olid valdavalt positiivsed, kuid Valga jäi aasta kokkuvõttes veidi eelmise aasta tasemele alla.

CEO vaates kinnitab dashboard ettevõtte selget kasvusuunda. Edasise analüüsi prioriteedid on määramata linnaga müügi põhjuse selgitamine ning käibekasvu allikate eristamine: klientide arv, ostusagedus ja keskmine ostukorv.
