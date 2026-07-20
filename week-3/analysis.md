# Nädal 3 detailne analüüs — tooted ja inventuur

## 1. Analüüsi eesmärk

Nädal 3 keskendus SQL JOIN-idele. Minu ametlik põhiroll oli **Roll C — tooted ja inventuur**.

Analüüsi eesmärk oli ühendada UrbanStyle’i tootekataloog müügi- ja inventuuriandmetega, et vastata järgmistele äriküsimustele:

1. Millised tooted on kataloogis, kuid ei ole müügitabelis kordagi esinenud?
2. Millised tooted ja kategooriad annavad tugevama müügitulemuse?
3. Millised laoseisud vajavad täiendavat kontrolli?
4. Kas andmetes on võimalikule ülevarule viitavaid juhtumeid?

## 2. Kasutatud andmed ja eeldused

| Tabel | Kasutus analüüsis |
|---|---|
| `products` | toote nimi, kategooria, alamkategooria ja jaehind |
| `sales` | toote seos müügitehingute, koguste ja müügisummadega |
| `inventory` | toote-asukoha laoseis ja tellimispunkt |

W3 juhend eeldas puhastatud andmeid. SQL-failis kontrolliti enne JOIN-analüüsi müügitabeli ridade arvu ja kliendilinnade arvu.

Inventuuri tulemused on **toote-asukoha tasemel**. Seetõttu ei tähenda 1 412 inventuuririda 1 412 erinevat toodet.

## 3. Kasutatud SQL-loogika

- `LEFT JOIN` — kõikide toodete säilitamiseks, sõltumata müügi- või inventuurivaste olemasolust;
- `LEFT JOIN ... WHERE s.sale_id IS NULL` — müümata toodete leidmiseks;
- `INNER JOIN` — ainult tegelikult müügitabelis esinevate toodete analüüsimiseks;
- mitme tabeli JOIN — toodete, müügi ja inventuuri ühendamiseks;
- `COUNT`, `COUNT(DISTINCT ...)`, `SUM`, `AVG` ja `GROUP BY` — koondtulemuste arvutamiseks;
- `CASE WHEN` — inventuuri staatuste eristamiseks;
- `NULLIF` — nulliga jagamise vältimiseks võimaliku ülevaru kordaja arvutamisel;
- `ORDER BY` ja `LIMIT` — olulisemate tulemuste esiletoomiseks.

## 4. Tulemused

### 4.1. Peamised kontrolltulemused

| Kontroll | Tulemus | Märkus |
|---|---:|---|
| Müümata tooted | 12 | `products LEFT JOIN sales`, kus `s.sale_id IS NULL` |
| Inventuuri ridu kokku | 1 412 | toote-asukoha taseme read |
| `TELLI JUURDE` | 221 | laoseis on tellimispunktist madalam või sellega võrdne |
| `KONTROLLI LAOSEISU` | 10 | negatiivne laoseis |
| `INVENTUUR PUUDUB` | 12 | tootel puudub inventuurivaste |
| `VÕIMALIK ÜLEVARU` | 730 | laoseis vähemalt kolm korda üle tellimispunkti |
| `OK` | 439 | ei kuulu eelnevatesse tähelepanu vajavatesse gruppidesse |

### 4.2. Müümata tooted

`products LEFT JOIN sales` ja tingimus `WHERE s.sale_id IS NULL` andsid tulemuseks **12 toodet**, millel puudus müügitabelis vaste.

Tulemus näitab ainult seda, et vastavaid tooteid müügitabelis ei leitud. Selle põhjal ei saa automaatselt järeldada, et need on vead või fantoomtooted. Võimalikud põhjused on näiteks:

- toode ei ole veel aktiivsesse müüki jõudnud;
- toode on lõpetatud või hooajaline;
- müügiajalugu puudub;
- toote või müügi seos on andmetes vigane;
- tegemist võib olla test- või impordikirjega.

**Tõendusmaterjalid:**

- [Müümata toodete loend](screenshots/01_unsold_products.png)
- [Müümata toodete arv](screenshots/02_unsold_products_count.png)

### 4.3. Müügianalüüs kategooriate kaupa

| Kategooria | Tooteid | Müügiridu | Kogumüük |
|---|---:|---:|---:|
| `jalanõusid` | 73 | 2 031 | 774 034,75 |
| `meeste_riided` | 82 | 2 266 | 749 798,72 |
| `naiste_riided` | 70 | 2 022 | 686 464,24 |
| `aksessuaarid` | 67 | 1 772 | 393 035,82 |
| `laste_riided` | 70 | 2 027 | 305 844,45 |

Suurima kogumüügi andis `jalanõusid`, kuid kõige rohkem müügiridu oli kategoorias `meeste_riided`. Seega ei kirjelda müügikordade arv ja müügiväärtus sama nähtust ning neid tuleb otsuste tegemisel eraldi vaadata.

**Tõendusmaterjalid:**

- [Kategooriate müügikoond A](screenshots/04a_category_sales_summary.png)
- [Kategooriate müügikoond B](screenshots/04b_category_sales_summary.png)

### 4.4. TOP 10 toodet kogumüügi järgi

| Koht | Toode | Kategooria | Alamkategooria | Müüdud kordi | Kogumüük |
|---:|---|---|---|---:|---:|
| 1 | Õhuline sünteetiline sporditossud | `jalanõusid` | tossud | 35 | 27 347,04 |
| 2 | Trendikas goretex oxfordid | `jalanõusid` | kingad | 32 | 23 376,15 |
| 3 | Praktiline viskoosne jakk | `naiste_riided` | jakid | 35 | 22 188,80 |
| 4 | Praktiline džersii seelik | `naiste_riided` | seelikud | 37 | 22 039,98 |
| 5 | Boheemlaslik puuvillane tuulejope | `naiste_riided` | jakid | 30 | 21 309,96 |
| 6 | Õhuline sünteetiline kõrge kontsaga kingad | `jalanõusid` | kontsad | 38 | 21 295,56 |
| 7 | Praktiline kangast kõrge kontsaga kingad | `jalanõusid` | kontsad | 37 | 21 118,68 |
| 8 | Luksuslik villane pahkluu saapad | `jalanõusid` | botased | 28 | 19 704,87 |
| 9 | Praktiline merino villane parka | `meeste_riided` | jakid | 30 | 19 620,45 |
| 10 | Õhuline linane jakk | `naiste_riided` | jakid | 41 | 19 393,29 |

TOP-toodete seas esines palju jalanõusid ja naiste riideid. Tulemuse tõlgendamisel tuleb arvestada, et kogumüük sõltub nii müügikordadest kui ka toote hinnast.

**Tõendusmaterjal:**

- [TOP-tooted kogumüügi järgi](screenshots/03_top_products_by_revenue.png)

### 4.5. Inventuuri esmane kontroll

Juhendi esmane loogika jagas inventuuriread kaheks:

- `TELLI JUURDE`, kui `quantity_available <= reorder_point`;
- `OK` kõigil muudel juhtudel.

See kontroll sobib madala laoseisu leidmiseks, kuid liigitab ka negatiivsed laoseisud tavaliseks tellimisvajaduseks ega erista inventuurivasteta tooteid.

**Tõendusmaterjalid:**

- [Esmase inventuurikontrolli tulemus](screenshots/05_inventory_status_initial.png)
- [Esmase inventuurikontrolli detailtabel](screenshots/05_inventory_status_initial.md)

### 4.6. Inventuuri täpsustatud kontroll

Täpsustatud loogika eristas järgmised seisundid:

| Staatus | Tähendus |
|---|---|
| `INVENTUUR PUUDUB` | tootel puudub inventuuritabelis vaste |
| `KONTROLLI LAOSEISU` | laoseis on negatiivne |
| `TELLI JUURDE` | laoseis on tellimispunktist madalam või sellega võrdne |
| `VÕIMALIK ÜLEVARU` | laoseis on vähemalt kolm korda suurem kui tellimispunkt |
| `OK` | rida ei kuulu eelnevatesse kontrolligruppidesse |

Inventuuri staatused kategooriate kaupa:

| Kategooria | Inventuur puudub | Kontrolli laoseisu | OK | Telli juurde | Võimalik ülevaru | Kokku |
|---|---:|---:|---:|---:|---:|---:|
| `meeste_riided` | 1 | 2 | 102 | 56 | 164 | 325 |
| `jalanõusid` | 2 | 0 | 90 | 48 | 146 | 286 |
| `laste_riided` | 2 | 2 | 77 | 46 | 147 | 274 |
| `naiste_riided` | 2 | 4 | 86 | 31 | 151 | 274 |
| `aksessuaarid` | 5 | 2 | 84 | 40 | 122 | 253 |
| **Kokku** | **12** | **10** | **439** | **221** | **730** | **1 412** |

**Tõendusmaterjalid:**

- [Täpsustatud inventuurikontroll](screenshots/06_inventory_status_refined.png)
- [Täpsustatud inventuurikontrolli detailtabel](screenshots/06_inventory_status_refined.md)

### 4.7. Võimaliku ülevaru kontroll

Võimaliku ülevaru analüütiliseks kontrollpiiriks valiti:

```text
quantity_available >= reorder_point * 3
```

Ülevaru kontrolli koond:

| Näitaja | Tulemus |
|---|---:|
| Võimaliku ülevaru ridu | 730 |
| Erinevaid tootenimesid | 331 |
| Ridu kordajaga vähemalt 5x | 455 |
| Ridu kordajaga vähemalt 10x | 214 |
| Ridu kordajaga vähemalt 20x | 79 |
| Ridu kordajaga vähemalt 100x | 31 |
| Suurim kordaja | 628,60x |

Võimalik ülevaru kategooriate kaupa:

| Kategooria | Võimaliku ülevaru ridu | Erinevaid tootenimesid | Laoseis kokku | Üle tellimispunkti kokku | Suurim kordaja |
|---|---:|---:|---:|---:|---:|
| `meeste_riided` | 164 | 78 | 93 102 | 89 092 | 527,53 |
| `naiste_riided` | 151 | 66 | 57 519 | 53 838 | 448,59 |
| `laste_riided` | 147 | 64 | 68 641 | 64 950 | 237,81 |
| `jalanõusid` | 146 | 65 | 78 921 | 75 397 | 628,60 |
| `aksessuaarid` | 122 | 58 | 43 984 | 40 869 | 231,53 |

TOP 10 kõige suurema kordajaga toote-asukoha rida:

| Koht | Toode | Kategooria | Asukoht | Laoseis | Tellimispunkt | Üle tellimispunkti | Kordaja |
|---:|---|---|---|---:|---:|---:|---:|
| 1 | Minimalistlik sünteetiline saapad | `jalanõusid` | ladu | 9 429 | 15 | 9 414 | 628,60 |
| 2 | Õhuline sünteetiline rannasandaalid | `jalanõusid` | tartu | 9 479 | 17 | 9 462 | 557,59 |
| 3 | Trendikas džersii slim-fit püksid | `meeste_riided` | ladu | 8 968 | 17 | 8 951 | 527,53 |
| 4 | Stiilne džersii püksid | `meeste_riided` | ladu | 5 321 | 11 | 5 310 | 483,73 |
| 5 | Soe satiinne pluus | `naiste_riided` | ladu | 7 626 | 17 | 7 609 | 448,59 |
| 6 | Mugav tweed kardigan | `meeste_riided` | ladu | 7 029 | 16 | 7 013 | 439,31 |
| 7 | Boheemlaslik goretex kingad | `jalanõusid` | pärnu | 7 588 | 21 | 7 567 | 361,33 |
| 8 | Kerge satiinne jakk | `naiste_riided` | tartu | 9 985 | 39 | 9 946 | 256,03 |
| 9 | Õhuline sünteetiline kõrge kontsaga kingad | `jalanõusid` | tallinn | 6 821 | 27 | 6 794 | 252,63 |
| 10 | Luksuslik villane bleiser | `laste_riided` | pärnu | 7 372 | 31 | 7 341 | 237,81 |

Seda tulemust tuleb käsitleda kontrollnimekirjana, mitte lõpliku ülevaru tõendina. `reorder_point` on tellimispunkt, mitte maksimaalne laotase. Lõpliku hinnangu jaoks oleks vaja vähemalt müügikiirust, hooajalisust, tarneaega, ostutellimusi ning miinimum- ja maksimumvaru poliitikat.

**Tõendusmaterjal:**

- [Võimaliku ülevaru detailtabel](screenshots/07_possible_overstock.md)

## 5. Piirangud ja tõlgendusriskid

### Müümata toode ei võrdu automaatselt fantoomtootega

SQL-faili ajaloolises kommentaaris nimetatakse 12 müümata toodet fantoomtoodeteks. JOIN-tulemus ise seda põhjust ei tõenda. Dokumentatsioonis käsitletakse neid seetõttu müümata või müügivasteta toodetena, mille äriline staatus vajab kontrolli.

### Jaehinnaga arvutatud laoväärtus ei ole tegelik seotud kapital

SQL-is kasutatud `retail_price * quantity_available` kirjeldab laoseisu võimalikku jaemüügiväärtust. Tegeliku varudesse seotud kapitali hindamiseks tuleks kasutada omahinda või soetusmaksumust.

### Tellimispunkt ei ole maksimumvaru

Kolmekordne tellimispunkt on analüütiline kontrollpiir, mitte kinnitatud ettevõtte laopoliitika. Märgis `VÕIMALIK ÜLEVARU` ei tähenda, et kogu vastav kogus tuleb automaatselt vähendada.

### Ajaloolise SQL-faili eripära

Eelduskontrolli osas loetakse kliendiridu tabelist `customers_test`, kuigi W3 põhianalüüs kasutab originaaltabeleid. Seda ajaloolist SQL-faili portfoolio korrastamisel tagantjärele ei muudeta; piirang dokumenteeritakse siin.

## 6. Soovitused

### Toomasele

- kontrollida negatiivse laoseisuga read eraldi andmekvaliteedi töövoos;
- selgitada inventuurivasteta toodete põhjus;
- määratleda ametlikud miinimum- ja maksimumvaru reeglid;
- eristada süsteemis tellimispunkt, ohutusvaru ja soovituslik maksimumvaru.

### Annale ja tootevaliku eest vastutajale

- kontrollida 12 müümata toote aktiivsust ja hooajalisust;
- võrrelda kategooriate müügiväärtust, müügikordi ja müüdud kogust eraldi;
- hinnata suure laoseisuga toodete müügikiirust enne kampaania- või allahindlusotsust;
- vältida toodete eemaldamist ainult müügivaste puudumise põhjal.

## 7. Täiendamiseks vajalikud andmed

Analüüsi täpsustamiseks oleks vaja:

- toote aktiivsuse, lõpetamise, hooajalisuse või testtoote staatust;
- toote kataloogi lisamise kuupäeva;
- ostutellimusi ja juba teel olevaid koguseid;
- toote omahinda ja tegelikku marginaali;
- müügikiirust ja viimase müügi kuupäeva;
- laoliikumiste ajalugu;
- tarnijat ja tarneaega;
- miinimum- ja maksimumvaru poliitikat;
- kampaaniate ja allahindluste infot.

## 8. Vabatahtlikud lisaanalüüsid

Lisaks ametlikule Roll C tööle tegin enesearengu eesmärgil teiste rollide JOIN-harjutused:

- [Roll A — müügi ja klientide ühendamine](additional-analysis/week3_role_a_sales_customers.sql)
- [Roll B — kliendid ilma ostudeta](additional-analysis/week3_role_b_customers_without_sales.sql)
- [Roll D — müügikanalite analüüs](additional-analysis/week3_role_d_sales_channels.sql)

Need failid ei ole minu ametliku Roll C põhiartefakti osa.

## 9. Ajaloolise töö ja failinimede märkus

SQL-päringud ja kuvatõmmised pärinevad töö tegemise ning tulemuste esitlemise ajast. Portfoolio failid ja kaustad nimetati hiljem ühtse struktuuri järgi ümber. Analüüsi sisu ja tulemusi korrastamise käigus tagantjärele ei muudetud.