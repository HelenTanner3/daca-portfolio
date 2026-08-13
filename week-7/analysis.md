# Nädal 7 — RFM-kliendisegmenteerimise detailanalüüs

## 1. Töö kontekst

Nädal 7 keskendus Pythonile, pandas'ele ja RFM-kliendisegmenteerimisele.

Grupitöö töövoog oli:

- A — andmete laadimine
- B — andmete puhastamine
- C — RFM-analüüs
- D — visualiseerimine ja äritõlgendus

Minu ametlik roll oli **Roll C — RFM-analüüs**.

Lisaks ametlikule rollile läbisin kogu A → B → C → D töövoo iseseisvalt kahel korral:

1. enne grupitööd Supabase'i andmetega, et valmistuda grupitööks ja kontrollida tervikloogikat;
2. pärast grupitööd CSV-andmetega, et kinnistada pandas'e töövoogu ja kontrollida metoodikat teise andmeallikaga.

Grupi lõplik integreeritud töö on portfoolios eraldi `group-project/` kaustas. Täiendavad iseseisvad tööd asuvad `additional-analysis/` kaustas.

---

## 2. Äriküsimus

UrbanStyle'i tootejuht vajab kliendipõhist vaadet, mis aitaks eristada:

- kõige väärtuslikumaid ja lojaalsemaid kliente;
- kasvatatava potentsiaaliga kliente;
- ostuaktiivsuse langusega kliente;
- väga madala aktiivsuse ja väärtusega kliente.

RFM-analüüsi eesmärk oli muuta tehinguandmed kliendisegmentideks, mille põhjal saab teha erinevaid turundus- ja kliendihoidmise otsuseid.

---

## 3. Ametlik Roll C — RFM-analüüs

Roll C sisendiks oli Roll B puhastatud pandas DataFrame `df`.

RFM-arvutuseks kasutati välju:

- `customer_id`;
- `sale_date`;
- `sale_id`;
- `total_price`.

Roll C ei laadinud ega puhastanud lähteandmeid, vaid koondas puhastatud tehingud kliendipõhiseks RFM-tabeliks.

### Kontrollitud sisend

| Näitaja | Tulemus |
|---|---:|
| puhastatud müügiridu | 8 950 |
| unikaalseid kliente | 2 540 |
| andmete kuupäevavahemik | 2023-01-01 kuni 2026-06-28 |

---

## 4. RFM-metoodika

### Recency

Recency näitab päevade arvu kliendi viimase ostu ja analüüsi viitekuupäeva vahel.

Väiksem Recency tähendab hiljutisemat ostu.

### Frequency

Frequency arvutati kliendi `sale_id` väärtuste arvuna.

Suurem Frequency tähendab suuremat ostuaktiivsust.

### Monetary

Monetary arvutati kliendi `total_price` väärtuste summana.

See väljendab kliendi analüüsitud kogukulutust, mitte kasumit ega marginaali.

### RFM-skoorid

Iga mõõdik jaotati `pd.qcut()` abil viide ligikaudu võrdsesse rühma.

- Recency: väiksem väärtus = kõrgem skoor;
- Frequency: suurem väärtus = kõrgem skoor;
- Monetary: suurem väärtus = kõrgem skoor.

Skooride vahemik oli 1–5.

Koondskoor:

`RFM_Score = R_score + F_score + M_score`

Segmentide loogika:

| RFM-skoor | Segment |
|---:|---|
| 13–15 | VIP Champions |
| 10–12 | Loyal |
| 7–9 | Potential |
| 4–6 | At Risk |
| 3 | Lost |

See vastab Nädal 7 grupitöö juhendis kasutatud metoodikale.

---

## 5. Ametliku grupitöö tulemused

Analüüsitud Monetary koguväärtus oli **2 676 850,54 eurot**.

| Segment | Kliente | Klientide osakaal | Monetary kokku, € | Monetary osakaal |
|---|---:|---:|---:|---:|
| VIP Champions | 455 | 17,91% | 1 146 295,15 | 42,82% |
| Loyal | 679 | 26,73% | 796 357,18 | 29,75% |
| Potential | 759 | 29,88% | 521 792,88 | 19,49% |
| At Risk | 529 | 20,83% | 192 170,22 | 7,18% |
| Lost | 118 | 4,65% | 20 235,11 | 0,76% |

VIP Champions ja Loyal moodustasid kokku:

- **1 134 klienti**;
- **44,65% klientidest**;
- **72,57% Monetary väärtusest**.

Potential oli **759 kliendiga suurim segment**.

---

## 6. Ametliku analüüsi viitekuupäeva piirang

Grupitöö juhendis kasutati fikseeritud viitekuupäeva:

`2025-02-28`

Grupi andmestik ulatus aga kuupäevani:

`2026-06-28`

Seetõttu tekkis ametlikus RFM-tulemuses **25 negatiivse Recency väärtusega klienti**.

See ei tulenenud Roll C arvutusveast, vaid juhendis määratud viitekuupäeva ja tegeliku andmestiku kuupäevavahemiku vastuolust.

Koolituse ametlikus töös säilitati juhendi kuupäev. Täiendavates iseseisvates analüüsides kontrollisin, kuidas saab seda metoodilist probleemi vältida.

---

## 7. Täiendav analüüs 1 — Supabase + shared DataFrame

`additional-analysis/method-1-supabase-shared-dataframe/`

See tervikläbimine valmis **enne grupitööd**.

Eesmärk oli enne oma Roll C ülesande täitmist iseseisvalt läbi teha kogu töövoog:

Supabase → pandas DataFrame → ühendamine → puhastamine → RFM → segmenteerimine → visualiseerimine.

### Andmeallikas

Supabase'ist laaditi:

| Tabel | Ridu |
|---|---:|
| sales | 10 118 |
| customers | 3 150 |
| products | 362 |

Andmeid laaditi lehekülgede kaupa, et vältida ainult esimese 1000 rea kasutamist.

Pärast ühendamist säilis 10 118 müügirida ning JOIN-id ei tekitanud ridade paljunemist.

### Puhastamise kontrollväärtused

- puuduv `customer_id`: 988 rida;
- negatiivne `total_price`: 195 rida;
- kattuva probleemiga: 15 rida;
- eemaldatud unikaalseid ridu: 1 168;
- RFM-kõlblikke tehinguid: 8 950;
- RFM-kliente: 2 540.

### Viitekuupäev

Selles ettevalmistavas analüüsis kasutati andmestiku viimasele müügikuupäevale järgnevat päeva:

`2026-06-29`

Selle eesmärk oli kontrollida RFM-loogikat ilma negatiivsete Recency väärtusteta.

Kvintiilipõhise skoorimise järjestus ei muutunud, mistõttu segmentide jaotus jäi ametliku grupitöö tulemusega samaks. Recency absoluutne päevade arv oli siiski erinev.

See töö oli ettevalmistav õppimis- ja kontrollanalüüs, mitte grupikaaslaste rollide enda tööna esitamine.

---

## 8. Grupitöö

Tegelikus grupitöös täitis iga meeskonnaliige oma rolli ning väljund ühendati üheks terviklikuks notebook'iks.

Minu vastutus oli Roll C:

- Recency, Frequency ja Monetary arvutamine;
- R-, F- ja M-skooride määramine;
- RFM-koondskoori arvutamine;
- kliendisegmentide loomine;
- tulemuste kontroll;
- RFM-tabeli üleandmine Roll D-le.

Lõplik grupitöö koos RFM CSV ja visualiseeringutega on säilitatud portfoolio `group-project/` kaustas.

---

## 9. Täiendav analüüs 2 — CSV + shared DataFrame

`additional-analysis/method-2-csv-shared-dataframe/`

See analüüs valmis **pärast grupitööd** iseseisva järelkontrollina.

Eesmärk oli läbida sama töövoog uuesti CSV-andmetega ning keskenduda pandas'e töötlusloogikale, andmete kontrollimisele ja RFM-metoodikale.

### CSV sisend

| Kontroll | Tulemus |
|---|---:|
| sales ridu | 15 234 |
| customers ridu | 3 150 |
| korduvaid `invoice_id` väärtusi | 5 116 |
| algseid puuduvaid `customer_id` väärtusi | 1 487 |

Kuupäevad teisendati ühtsesse vormingusse ja pärast teisendamist ei jäänud vigaseid kuupäevaväärtusi.

### Täiendav kuupäevakontroll

Erinevalt ametlikust grupitööst eemaldati enne RFM-arvutust tehingud, mille:

`sale_date > 2025-02-28`

Selliseid ridu oli **238**.

See võimaldas kasutada koolituse ametlikku RFM-viitekuupäeva `2025-02-28` ilma negatiivsete Recency väärtusteta.

### Puhastatud andmestik

| Kontroll | Tulemus |
|---|---:|
| RFM-kõlblikke müügiridu | 8 712 |
| unikaalseid kliente | 2 515 |
| kuupäevavahemik | 2023-01-01 kuni 2025-02-28 |
| negatiivseid Recency väärtusi | 0 |

### Segmentide tulemus

| Segment | Kliente | Osakaal |
|---|---:|---:|
| VIP Champions | 455 | 18,09% |
| Loyal | 684 | 27,20% |
| Potential | 740 | 29,42% |
| At Risk | 512 | 20,36% |
| Lost | 124 | 4,93% |
| **Kokku** | **2 515** | **100,00%** |

Need tulemused ei pea olema identsed grupitööga, sest analüüsi sisend ei ole identne. CSV-versioon kasutab teistsugust lähteandmestikku ning eemaldab lisaks viitekuupäevast hilisemad müügid.

---

## 10. Mida kahe täiendava analüüsi võrdlus õpetas

Method 1 ja Method 2 ei ole kaks konkureerivat lõpptulemust.

Nende eesmärk oli erinev.

### Method 1

- valmis enne grupitööd;
- kasutas Supabase'i;
- aitas mõista kogu A → B → C → D töövoogu;
- võimaldas oma Roll C osa enne grupitööd tervikkontekstis läbi kontrollida.

### Method 2

- valmis pärast grupitööd;
- kasutas CSV-faile;
- võimaldas sama pandas-loogika uuesti iseseisvalt läbi teha;
- kontrollis teadlikult viitekuupäeva probleemi;
- näitas, kuidas sisendi ja puhastusreegli muutus mõjutab lõplikku RFM-tulemust.

Oluline õppetund oli, et **sama analüüsikood ei taga sama tulemust, kui andmeallikas, andmete seis või puhastusreeglid erinevad**.

---

## 11. Ärilised leiud

### VIP ja Loyal koondavad suurema osa väärtusest

Grupianalüüsis moodustasid VIP Champions ja Loyal kokku 44,65% klientidest, kuid 72,57% kogu Monetary väärtusest.

Nende hoidmisel on seetõttu suur äriline mõju.

### Potential on suurim kasvurühm

Potential oli grupitöös 759 kliendiga suurim segment.

See sobib järgmise ostu stimuleerimiseks, ristmüügiks ja lojaalsuse kasvatamiseks.

### At Risk kliente tuleks prioriseerida väärtuse järgi

At Risk segment oli arvukas, kuid selle rahaline osakaal oli oluliselt väiksem kui VIP- ja Loyal-segmentidel.

Kõigile riskiklientidele sama kuluka taasaktiveerimiskampaania tegemise asemel tuleks esmalt keskenduda suurema varasema Monetary väärtusega klientidele.

### RFM on suhteline mudel

Kvintiilipõhine RFM hindab klienti teiste klientide suhtes.

Kõrge R-skoor ei tähenda automaatselt, et klient ostis äriliselt hiljuti. Kampaaniaotsuses tuleb vaadata koos:

- segmenti;
- tegelikku Recency päevade arvu;
- ettevõtte normaalset ostutsüklit;
- kliendi varasemat väärtust.

---

## 12. Soovitatud tegevused

| Segment | Soovitatud tegevus |
|---|---|
| VIP Champions | hoida kliendisuhet, pakkuda personaalseid hüvesid ja varajast ligipääsu |
| Loyal | toetada kordusoste ja kasvatada klienti VIP-tasemele |
| Potential | stimuleerida järgmist ostu ja lojaalsust |
| At Risk | rakendada sihitud taasaktiveerimist, eelistades suurema varasema väärtusega kliente |
| Lost | kasutada madalama kuluga testkampaaniat või jätta aktiivsest turundusest välja, kui reageerimist ei toimu |

---

## 13. Peamised kontrolli- ja metoodilised õppetunnid

Nädal 7 töö käigus kinnistus:

- andmeid tuleb kontrollida kohe pärast laadimist;
- DataFrame'i ridade arv tuleb kontrollida enne ja pärast `merge()` operatsiooni;
- puhastusreeglite mõju tuleb mõõta, mitte ainult kood käivitada;
- RFM-i viitekuupäev peab olema kooskõlas analüüsi perioodiga;
- `pd.qcut()` loob suhtelised, mitte absoluutsed kliendiklassid;
- erinevate andmeallikate tulemusi ei tohi automaatselt võrdsustada;
- töötav notebook ei tõesta veel analüüsi korrektsust;
- usaldusväärse tulemuse jaoks on vaja kontrollväärtusi ja vahetulemuste võrdlemist.

Kõige olulisem metoodiline õppetund oli eristada:

- **koolituse juhendi järgi tehtud ametlikku lahendust**;
- **ettevalmistavat iseseisvat analüüsi**;
- **hilisemat metoodilist järelkontrolli**.

---

## 14. AI kasutamine

AI-d kasutasin õppematerjalide ja nõuete tõlgendamisel, pandas- ja RFM-loogika kontrollimisel, veateadete analüüsimisel ning dokumentatsiooni struktureerimisel.

AI pakutud lahendusi ei käsitletud kontrollväärtusena. Kood käivitati kohalikus töökeskkonnas ning tulemusi kontrolliti DataFrame'ide, ridade arvu, kuupäevade, võtmete, segmentide ja teiste vahetulemuste põhjal.

---

## 15. Seotud artefaktid

- [Ametlik Roll C notebook](week7_role_c_rfm_analysis.ipynb)
- [Grupitöö lõppversioon](group-project/)
- [Täiendavad iseseisvad analüüsid](additional-analysis/)
- [Method 1 — Supabase + shared DataFrame](additional-analysis/method-1-supabase-shared-dataframe/)
- [Method 2 — CSV + shared DataFrame](additional-analysis/method-2-csv-shared-dataframe/)
