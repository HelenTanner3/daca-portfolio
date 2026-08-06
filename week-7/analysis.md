# Nädal 7 — RFM-kliendisegmenteerimise detailanalüüs

## 1. Töö kontekst

Nädal 7 keskendus Pythonile, pandas'ele ja Supabase'i andmete kasutamisele kliendipõhise RFM-analüüsi koostamisel.

Grupitöö järjestus oli:

```text
Roll A — andmete laadimine
Roll B — andmete puhastamine
Roll C — RFM-analüüs
Roll D — visualiseerimine ja äritõlgendus
```

Minu ametlik roll oli **Roll C — RFM-analüüs**.

Isiklikus portfoolios on kaks eraldi notebook'i:

1. `week7_role_c_rfm_analysis.ipynb` — ametliku Roll C kood, mis eeldab Roll B loodud puhastatud DataFrame'i `df`;
2. `week7_UrbanStyle.ltd_Python Pandas_RFM (Recency, Frequency, Monetary) Helen (roll a,b,c,d).ipynb` — iseseisvalt käivitatav õppimisnotebook, kus läbisin tervikliku A–D töövoo.

Ametliku Roll C notebook'i kood vastab grupi koondnotebook'i Roll C osale. Terviklik notebook on täiendav isiklik õppimis- ja portfoolioartefakt, mitte teiste grupiliikmete töö omistamine endale.

## 2. Äriküsimus

UrbanStyle'i tootejuht vajab kliendipõhist vaadet, mis aitaks eristada:

- kõige väärtuslikumaid ja lojaalsemaid kliente;
- kasvatatava potentsiaaliga kliente;
- ostuaktiivsuse langusega kliente;
- väga madala aktiivsuse ja väärtusega kliente.

Analüüsi eesmärk oli luua kontrollitav RFM-segmenteerimine ning tõlkida tehnilised skoorid tegevussoovitusteks.

## 3. Kasutatud andmed

Terviklik isiklik notebook laadib grupi Supabase'ist:

| Tabel | Ridade arv | Kasutus |
|---|---:|---|
| `sales` | 10 118 | kuupäevad, tehingud ja müügisummad |
| `customers` | 3 150 | kliendi tunnused ja kontaktandmed |
| `products` | 362 | toodete kontroll ja täiendav tõlgendus |

RFM-arvutuse põhiväljad olid:

- `customer_id`;
- `sale_date`;
- `sale_id`;
- `total_price`.

Supabase'i andmed laaditi korduvkasutatava `get_data()` funktsiooniga 1000 rea kaupa. See väldib olukorda, kus ühe päringuga jõuab DataFrame'i ainult esimene 1000 rida.

Ühendamisel kasutati `customer_id` ja `product_id` võtmeid. Müügitabeli 10 118 rida säilisid ka pärast ühendamist, mistõttu JOIN-id ei tekitanud ridade paljunemist.

## 4. Andmekvaliteedi kontroll ja puhastamine

### 4.1. Peamised tähelepanekud

- `customer_id` puudus 988 müügireal;
- negatiivse `total_price` väärtusega ridu oli 195;
- 15 real esines korraga rohkem kui üks välistamise põhjus;
- `sale_date` ja `total_price` kriitilisi puuduvaid väärtusi ei olnud;
- puuduv `store_location` esines ainult veebikanali müükidel ja seda ei käsitletud automaatselt veana;
- täielikult korduvaid kliendi- ja tooteridu ei leitud;
- kõik olemasolevad kliendi- ja toote-ID-d leidsid vastavast tabelist vaste.

Puuduva `customer_id`-ga ridu ei saanud kliendipõhises RFM-analüüsis kasutada. Negatiivsed müügisummad jäeti koolituse RFM-metoodika järgi Monetary arvutusest välja.

### 4.2. Puhastamise tulemus

| Kontrollväärtus | Tulemus |
|---|---:|
| ühendatud müügiridu | 10 118 |
| puuduv `customer_id` | 988 |
| negatiivse müügisummaga ridu | 195 |
| kattuvate probleemidega ridu | 15 |
| eemaldatud unikaalseid ridu | 1 168 |
| RFM-kõlblikke tehinguid | 8 950 |
| unikaalseid kliente | 2 540 |

Lõplikus RFM-alusandmestikus:

- puuduvad kriitilised väärtused;
- kõik müügisummad on positiivsed;
- kõik `sale_id` väärtused on unikaalsed;
- iga klient on RFM-tabelis ühe reaga.

## 5. RFM-metoodika

### 5.1. Recency

Recency näitab päevade arvu kliendi viimase ostu ja analüüsi viitekuupäeva vahel. Väiksem väärtus tähendab hiljutisemat ostu.

### 5.2. Frequency

Frequency põhineb unikaalsete `sale_id` väärtuste arvul kliendi kohta. Suurem väärtus näitab suuremat ostuaktiivsust.

### 5.3. Monetary

Monetary on kliendi positiivsete `total_price` väärtuste summa. See väljendab müügitulu, mitte kasumit või kliendi marginaali.

### 5.4. Skoorid

R-, F- ja M-skoorid määrati `pd.qcut()` abil viide kvintiili.

- Recency puhul sai väiksem päevade arv kõrgema skoori.
- Frequency ja Monetary puhul said suuremad väärtused kõrgema skoori.
- Koondskoor oli kolme osaskoori summa vahemikus 3–15.

Segmendid:

| RFM-koondskoor | Segment |
|---:|---|
| 13–15 | VIP Champions |
| 10–12 | Loyal |
| 7–9 | Potential |
| 4–6 | At Risk |
| 3 | Lost |

## 6. Viitekuupäeva käsitlus

Kahe notebook'i viitekuupäevad on teadlikult erinevad.

### Ametlik Roll C notebook

Kasutab koolituse juhendis ette antud kuupäeva:

```python
today = pd.to_datetime("2025-02-28")
```

Sama kood on grupi koondnotebook'i Roll C osas. Kuna grupi andmestikus on ka sellest hilisemaid tehinguid, tekivad osale klientidele negatiivsed Recency väärtused. See on juhendi fikseeritud kuupäeva ja andmestiku kuupäevavahemiku vastuolu, mitte Roll C koodiviga.

### Terviklik isiklik notebook

Kasutab andmestiku viimasele müügikuupäevale järgnevat päeva:

```text
2026-06-29
```

Selle lahenduse eesmärk oli muuta iseseisev analüüs ajaliselt loogiliseks ja tagada, et kõik Recency väärtused oleksid positiivsed.

Kvintiilipõhine skoorimine sõltub klientide järjestusest. Kõigile klientidele sama päevade arvu lisamine või lahutamine ei muuda järjestust, mistõttu segmentide arvud võivad jääda samaks. See ei tähenda, et Recency absoluutne tõlgendus oleks sama.

## 7. Peamised tulemused

Analüüsitud Monetary koguväärtus oli **2 676 850,54 eurot**.

| Segment | Kliente | Klientide osakaal | Monetary kokku, € | Monetary osakaal |
|---|---:|---:|---:|---:|
| VIP Champions | 455 | 17,91% | 1 146 295,15 | 42,82% |
| Loyal | 679 | 26,73% | 796 357,18 | 29,75% |
| Potential | 759 | 29,88% | 521 792,88 | 19,49% |
| At Risk | 529 | 20,83% | 192 170,22 | 7,18% |
| Lost | 118 | 4,65% | 20 235,11 | 0,76% |

### Segmentide profiil isiklikus terviklikus notebook'is

| Segment | Keskmine Recency | Keskmine Frequency | Keskmine Monetary, € |
|---|---:|---:|---:|
| VIP Champions | 534,66 | 7,68 | 2 519,33 |
| Loyal | 631,29 | 3,84 | 1 172,84 |
| Potential | 693,49 | 2,49 | 687,47 |
| At Risk | 795,57 | 1,59 | 363,27 |
| Lost | 1 002,88 | 1,01 | 171,48 |

Segmentide keskmised näitajad liikusid loogilises suunas:

- Recency suurenes VIP-ist Lost-segmendi suunas;
- Frequency vähenes;
- Monetary vähenes.

## 8. Analüütilised leiud

### 8.1. Väärtus koondub väiksemasse kliendirühma

VIP Champions ja Loyal hõlmasid:

- 1 134 klienti;
- 44,65% analüüsitud klientidest;
- 72,57% kogu Monetary väärtusest.

See näitab, et kliendi hoidmise tegevustel tuleks esmajärjekorras keskenduda nendele segmentidele.

### 8.2. Potential on suurim kasvurühm

Potential oli 759 kliendiga suurim segment. Selle Monetary osakaal oli 19,49%.

See rühm sobib järgmise ostu stimuleerimiseks, personaalseks ristmüügiks ja lojaalsusprogrammi aktiveerimiseks.

### 8.3. Kõik riskikliendid ei ole võrdselt väärtuslikud

At Risk ja Lost hõlmasid kokku:

- 647 klienti;
- 25,47% klientidest;
- 7,93% Monetary väärtusest.

Kõigile sama kuluka taasaktiveerimiskampaania tegemine ei pruugi olla efektiivne. Esmalt tuleks valida suurema varasema Monetary väärtusega kliendid.

### 8.4. Suhteline Recency vajab ettevaatlikku tõlgendamist

Isiklikus notebook'is oli Recency mediaan 646,5 päeva. Kõrgeima `R_score = 5` saanud klientide Recency jäi vahemikku 1–545 päeva.

See tähendab, et kvintiilipõhine kõrge R-skoor kirjeldab klienti ülejäänud kliendibaasi suhtes, mitte tingimata ettevõtte jaoks sobiva absoluutse aktiivsuspiiri järgi.

TOP 10 klienti said kõik RFM-koondskoori 15, kuid mitme viimase ostu kuupäev jäi enam kui aasta tagusesse aega. Seetõttu tuleb päris kampaaniates lisaks segmendile kasutada ettevõtte ostutsükliga sobivaid aktiivsus- ja kadumispiire.

## 9. Tegevussoovitused

| Segment | Soovitatud tegevus |
|---|---|
| VIP Champions | hoida kliendisuhet, pakkuda personaalseid hüvesid ja varajast ligipääsu; kontrollida eraldi tegelikku Recency väärtust |
| Loyal | toetada kordusoste, lojaalsusprogrammi ja sobivate toodete ristmüüki |
| Potential | kasutada järgmise ostu stiimuleid ja ajastatud personaalseid soovitusi |
| At Risk | rakendada sihitud taasaktiveerimist, eelistades suurema varasema väärtusega kliente |
| Lost | kasutada madala kuluga testkampaaniat või jätta aktiivsest turundusest välja, kui reageerimist ei toimu |

## 10. Visualiseeringud

Terviklikus isiklikus notebook'is loodi:

- klientide arv segmentide kaupa;
- segmentide osakaal kogu Monetary väärtusest;
- keskmine Recency segmentide kaupa;
- keskmine Frequency segmentide kaupa;
- keskmine Monetary segmentide kaupa.

Visualiseeringute eesmärk oli kontrollida, kas segmentide järjestus ja äriline profiil on kooskõlalised.

## 11. Piirangud

- RFM põhineb ajaloolisel ostukäitumisel ega näita, miks klient ei ole ostnud.
- Monetary ei arvesta omahinda, marginaali, tagastuste tegelikku mõju ega kliendi kasumlikkust.
- Analüüs ei arvesta kampaaniaid, toodete kategooriaid, kanaleid ega hooajalisust.
- E-post puudus 380 kliendil.
- Korduva e-posti aadressiga gruppides oli 258 kliendirida.
- `loyalty_tier` puudus 1 260 kliendil.
- Kontaktandmete puudused ei mõjutanud `customer_id` põhist RFM-arvutust, kuid piiravad segmentide kasutamist turunduses.
- Segmendipiire ei ole valideeritud hilisema tegeliku ostukäitumise või kampaaniate tulemustega.
- Ametliku ja isikliku notebook'i Recency absoluutseid väärtusi ei tohi erineva viitekuupäeva tõttu omavahel otse võrrelda.

## 12. Õppetunnid ja refleksioon

Töö käigus kinnistus:

- Supabase'i andmete lehekülgede kaupa laadimine;
- pandas DataFrame'ide kontrollimine ja ühendamine;
- puhastamise põhjuste kattuvuse arvestamine;
- kliendipõhine koondamine `groupby()` abil;
- kvintiilide kasutamine `pd.qcut()` abil;
- tehnilise skoori tõlkimine äriliseks segmendiks;
- kontrollväärtuste kasutamine enne tulemuste usaldamist;
- arusaam, et töötav kood ei taga automaatselt korrektset analüütilist tõlgendust.

Kõige olulisem metoodiline õppetund oli eristada koolituse juhendi põhivoogu ja isiklikku analüütilist täiendust. Juhendi kuupäeva ei tohi vaikimisi asendada, kuid iseseisvas uurivas analüüsis tuleb samal ajal dokumenteerida, miks alternatiivne viitekuupäev võib olla äriliselt loogilisem.

## 13. Seotud artefaktid

- [Ametlik Roll C notebook](week7_role_c_rfm_analysis.ipynb)
- [Terviklik isiklik A–D õppimisnotebook](<week7_UrbanStyle.ltd_Python Pandas_RFM (Recency, Frequency, Monetary) Helen (roll a,b,c,d).ipynb>)
- [Grupi koondnotebook](https://github.com/Kolju3/DACA-group/blob/main/week-7/group/urbanstyle_operatsioonid_week7_(a_b_c_d).ipynb)
- [Minu Roll C töö grupirepos](https://github.com/Kolju3/DACA-group/tree/main/week-7/individual/helen)
