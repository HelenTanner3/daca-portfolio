# Nädal 6 detailanalüüs — Tartu kaupluse dashboard

## 1. Töö kontekst ja roll

Nädal 6 jätkas Nädal 5 Power BI dashboard'i prototüübi arendamist. Grupitöö eesmärk oli muuta üldine visuaal asukohapõhiseks juhtimisvaateks, lisades konteksti, annotatsioonid, viitejooned, interaktiivsuse ja andmeloo.

Minu ametlik roll oli **Roll B — Tartu kaupluse dashboard ja narratiiv**. Individuaalne artefakt on Tartu kaupluse juhtimisvaade Power BI-s. Meeskonna reposse lisatud PBIX, kuvatõmmis ja dokumentatsioon olid grupitöö sisendid; käesolev `analysis.md` kirjeldab minu individuaalset lahendust, tulemusi ja arendusotsuseid.

## 2. Äriküsimus

Dashboard vastab kolmele põhiküsimusele:

1. Kuidas muutus Tartu kaupluse 2024. aasta müügitulu võrreldes 2023. aastaga?
2. Kas muutus tulenes eelkõige tellimuste arvust või keskmise tellimuse väärtusest?
3. Millised kuud, tooted ja segmendid vajavad juhtimisotsuse seisukohalt tähelepanu?

Juhendi rollikirjelduses kasutatud Tartu langustrend oli näitlik lähtekoht. Tegelik andmestik näitas 2024. aastal kasvu, mistõttu koostasin narratiivi kontrollitud tulemuste, mitte juhendi näite põhjal.

## 3. Kasutatud andmed ja andmemudel

Dashboard kasutab järgmisi Power BI mudeli osi:

- `public sales` — müügitulu, tellimused, kuupäev, kauplus ja toode;
- `Calendar` — aasta, kuu ja kuude korrektne järjestus;
- `public products` — tootenimi, kategooria ja alamkategooria;
- `public customers` — kliendigrupp (`loyalty_tier`) detailfiltriks.

PBIX-mudelis on lisaks inventuuri tabelid, kuid selle lehe analüüs keskendub müügi-, aja-, toote- ja kliendisegmendi andmetele.

Võrdlusperiood on **2023 vs 2024**, sest need on dashboard'is kasutatud täielikud võrreldavad aastad. Hilisemate aastate andmeid selles narratiivis ei kasutatud.

## 4. Dashboard'i struktuur

Dashboard sisaldab:

- kolme KPI-kaarti: 2024 müügitulu, 2023 müügitulu ja aastane muutus;
- tellimuste arvu võrdlust 2023 vs 2024;
- keskmise tellimuse võrdlust 2023 vs 2024;
- kuist müügitulu võrdlevat joondiagrammi;
- kuist aastakasvu diagrammi;
- TOP 5 toodete 2024 müügitulu tulpdiagrammi;
- toote–alamkategooria–kategooria hierarhiat TOP 5 diagrammil;
- kaupluse valiku slicer'it, mille vaikeseis on Tartu;
- kategooria, alamkategooria ja kliendigrupi detailfiltreid lehe alaosas;
- kahte annotatsiooni ja juhtimisnarratiivi.

TOP 5 diagrammi hierarhia ei reasta eraldi TOP 5 kategooriat või alamkategooriat. Selle eesmärk on näidata, millistesse alamkategooriatesse ja kategooriatesse valitud TOP 5 tooted kuuluvad.

Värvikasutus on järjepidev: 2024 on tähistatud tumeda navy-tooniga, 2023 teal-tooniga, positiivne tähelepanek rohelise ja negatiivne oranži tooniga. Joondiagrammidel kasutatakse lisaks markerite kuju, et seeriad ei eristuks ainult värvi põhjal.

## 5. Mõõdikute loogika

Peamised mõõdikud põhinevad järgmisel loogikal:

- **müügitulu** — müügiridade `total_price` summa filtreeritud perioodis ja kaupluses;
- **tellimuste arv** — unikaalsete `invoice_id` väärtuste arv;
- **keskmine tellimus** — müügitulu jagatud tellimuste arvuga;
- **aastane muutus** — 2024 ja 2023 müügitulu vahe jagatud 2023 müügituluga;
- **kuine muutus** — iga 2024. aasta kuu võrdlus 2023. aasta sama kuuga.

Tartu tulemused on dashboard'i vaikeseis ja analüüsi ametlik alus. Täiendavad slicer'id võimaldavad vaadata sobivaid visuaale kategooria, alamkategooria ja kliendigrupi filtrikontekstis.

## 6. Kontrollväärtused

### 6.1. Aasta koondnäitajad

| Näitaja | 2023 | 2024 | Muutus |
|---|---:|---:|---:|
| Müügitulu | 229 316,99 € | 260 044,23 € | +13,4% |
| Tellimuste arv | 777 | 905 | +16,5% |
| Keskmine tellimus | 295,13 € | 287,34 € | −2,6% |

Kontroll näitab, et müügitulu suurenes 30 727,24 euro võrra. Tellimuste arvu kasv oli müügitulu kasvust kiirem, samal ajal kui keskmine tellimus vähenes. Seega oli aastakasv eelkõige mahupõhine.

### 6.2. Kuine müügitulu

| Kuu | 2023 | 2024 | Muutus |
|---|---:|---:|---:|
| jaanuar | 13 154,39 € | 16 081,07 € | +22,2% |
| veebruar | 14 397,12 € | 13 887,47 € | −3,5% |
| märts | 15 644,23 € | 19 769,70 € | +26,4% |
| aprill | 24 567,45 € | 16 976,30 € | −30,9% |
| mai | 13 595,53 € | 26 773,47 € | +96,9% |
| juuni | 26 053,48 € | 25 792,17 € | −1,0% |
| juuli | 18 717,98 € | 25 040,01 € | +33,8% |
| august | 24 832,09 € | 27 473,51 € | +10,6% |
| september | 16 960,68 € | 17 506,16 € | +3,2% |
| oktoober | 17 424,39 € | 18 247,17 € | +4,7% |
| november | 19 099,86 € | 19 450,60 € | +1,8% |
| detsember | 24 869,79 € | 33 046,60 € | +32,9% |
| **Kokku** | **229 316,99 €** | **260 044,23 €** | **+13,4%** |

Kuude summad ühtivad KPI-kaartidel kuvatud aastasummadega.

### 6.3. TOP 5 tooted

TOP 5 toodete 2024 müügitulu jääb ligikaudu 3,2–3,7 tuhande euro vahele. Väärtused on omavahel suhteliselt lähedased, mistõttu ei näita dashboard ühe selgelt domineeriva toote kontsentratsiooniriski.

Diagrammile lisatud hierarhia võimaldab liikuda toodete tasemelt alamkategooria ja kategooria tasemele. See aitab mõista, millisesse sortimendistruktuuri TOP 5 tooted kuuluvad, kuid ei asenda eraldi kategooriate müügiedetabelit.

## 7. Tulemuste tõlgendus

### 7.1. Kasv tuli tellimuste mahust

Tartu müügitulu kasvas 13,4%, kuid keskmine tellimus vähenes 2,6%. Tellimuste arv suurenes 16,5%, mis tähendab, et kasv saavutati suurema tehingumahu, mitte suurema ostukorvi abil.

See on positiivne nõudluse signaal, kuid keskmise tellimuse langus vajab jälgimist. Kui ostukorvi väärtus jätkab vähenemist, võib müügitulu kasv sõltuda järjest suuremast tellimuste arvust.

### 7.2. Aasta sees oli oluline kõikumine

Müügitulu kasvas üheksal kuul kaheteistkümnest. Kõige selgem kõrvalekalle oli aprillis, mil tulemus jäi 2023. aasta aprillile 30,9% alla. Järgnenud mais oli kasv 96,9%, mis tasandas aprilli langust ja moodustas aasta tugevaima positiivse kõrvalekalde.

Dashboard ei sisalda kampaania-, konkurendi-, tööjõu- ega kauplusekülastuse andmeid. Seetõttu ei saa aprilli languse või mai kasvu põhjust nimetada kinnitatud faktina. Need kuud on edasise analüüsi prioriteedid.

### 7.3. Tootemüük on TOP 5 sees jaotunud

TOP 5 toodete müügitulud on suhteliselt lähedased. See vähendab riski, et Tartu tulemus sõltub ainult ühest bestsellerist, kuid täpsema sortimendiotsuse jaoks on vaja võrrelda müüdud koguseid, marginaali, laoseisu ning kategooriate kogutulemusi.

## 8. Andmelugu ja juhtimissoovitus

Dashboard'i narratiiv on:

> **Tulemus:** Tartu müügitulu kasvas 2024. aastal 13,4%.  
> **Kõikumine:** suurim langus oli aprillis −30,9% ja tugevaim kasv mais +96,9%.  
> **Tegevus:** analüüsida aprilli ja mai toote-, kategooria- ning kliendisegmendi struktuuri, et tuvastada korratavad kasvutegurid.

Soovitus ei eelda, et mai kasvu põhjus on juba teada. Esmalt tuleb võrrelda kahe kuu:

- toodete, alamkategooriate ja kategooriate osakaalu;
- tellimuste arvu ja keskmist tellimust;
- kliendigruppe ning korduvostjaid;
- kampaaniaid ja võimalikke operatiivseid muutusi, kui need andmed on kättesaadavad.

## 9. Interaktiivsus ja kujundusotsused

Kaupluse valik on paigutatud dashboard'i ülaossa, sest see määrab kogu juhtimisvaate põhikonteksti. Tartu on salvestatud vaikevalikuna.

Kategooria, alamkategooria ja kliendigrupi filtrid on paigutatud lehe alaossa. Valiku eesmärk oli hoida esmane juhtimisvaade rahulikuna: üleval on peamine kauplusefilter ning detailsemad analüüsivõimalused on eraldatud kasutajale, kes soovib andmetesse sügavamalt minna.

TOP 5 toodete diagrammil on toote, alamkategooria ja kategooria tasemed. Kasutaja saab drillimise abil vaadata TOP 5 toodete kuuluvust sortimendihierarhias.

Narratiiv ja aprilli/mai annotatsioonid on staatilised ning kirjeldavad ainult Tartut. Teise kaupluse või detailfiltri valimisel tuleb tõlgendada dünaamilisi KPI-sid ja diagramme, mitte Tartu kohta kirjutatud staatilist teksti.

Enne avalikku jagamist tuleb kontrollida `Edit interactions` vaates, et kaupluse-, kategooria-, alamkategooria- ja kliendigrupi filtrid mõjutavad ainult soovitud KPI-sid ja diagramme.

## 10. Valideerimine ja kvaliteedikontroll

Tehtud kontrollid:

- 2023 ja 2024 kuusummad ühtivad aastaste KPI-dega;
- 13,4% muutus vastab aastasummade suhtelisele erinevusele;
- tellimuste ja keskmise tellimuse väärtused lepivad kokku müügituluga;
- kuine narratiiv vastab visualiseeritud andmetele;
- juhendis toodud näitlikku −5% langust ei kasutatud tegeliku tulemusena;
- võimalikke ärilisi põhjuseid ei esitatud kinnitatud faktidena ilma täiendavate andmeteta;
- uuendatud PBIX sisaldab TOP 5 toodete hierarhiat ning kategooria, alamkategooria ja kliendigrupi slicer'eid.

## 11. Juhendaja tagasiside ja refleksioon

Juhendaja tõi välja kaks võimalikku kujundusparandust:

1. Detailfiltrid võiksid olla dashboard'i ülaosas ning avaneda kokkupandava ehk akordioni-tüüpi filtriplokina.
2. Aastate võrdluses võiks uuem aasta olla visuaalselt heledam ning võrdlusaasta hallikam ja vähem domineeriv.

Neid muudatusi sellesse lõppversiooni ei viidud. Praegune paigutus jätab ülaossa ainult peamise kauplusevaliku ning koondab detailfiltrid lehe alaossa, et esimene vaade ei muutuks liiga tihedaks. Värvilahendus säilitati varasema dashboard'i järjepidevuse tõttu.

Tagasiside on siiski sisuline arenduspunkt. Edaspidi uurin Power BI-s kokkupandava filtriploki lahendusi ning võrdlusaasta teadlikumat visuaalset taandamist.

## 12. Piirangud ja edasised arendused

- Kaupluse- ja detailfiltrid muudavad visuaale, kuid staatiline narratiiv ei muutu valikuga kaasa.
- Interaktsioonid tuleb kõikide slicer'ite ja visuaalide lõikes uuesti testida.
- TOP 5 hierarhia kirjeldab valitud toodete kategooriakuuluvust, mitte kategooriate TOP 5 järjestust.
- Dashboard ei sisalda marginaali, kampaaniate, konkurentide, külastuste ega tööjõuandmeid.
- TOP 5 toodete võrdlus põhineb müügitulul, mitte kasumlikkusel või laoseisul.
- Analüüs võrdleb 2023. ja 2024. aasta tulemusi ega tee prognoosi.
- Avalikku Power BI Service'i linki ega mobiilivaadet ei ole selle portfoolioversiooni tõendusmaterjalina kontrollitud.

Edasised arendused võiksid hõlmata:

- kokkupandavat filtriplokki, mis jätab detailfiltrid kättesaadavaks, kuid säästab ekraaniruumi;
- uuema ja võrdlusaasta visuaalse hierarhia täpsustamist;
- dünaamilist narratiivi, mis muutub koos filtritega;
- kategooriate eraldi müügiedetabelit;
- müügitulemuse sidumist varu- ja marginaaliandmetega.

## 13. Individuaalse ja grupitöö eristus

### Individuaalne töö

- Tartu kaupluse Power BI dashboard;
- Tartu andmetel põhinevad KPI-d, trendid, TOP 5 tooted ja narratiiv;
- TOP 5 toodete drill-hierarhia;
- kategooria, alamkategooria ja kliendigrupi detailfiltrid;
- käesolev detailanalüüs ja kuvatõmmis.

### Grupitöö

Minu individuaalne PBIX, kuvatõmmis ja dokumentatsioon lisati meeskonna W6 reposse. Grupi repo materjal on eraldi meeskonnatöö väljund ega asenda isikliku portfoolio dokumentatsiooni.

- [Minu W6 väljund grupirepos](https://github.com/Kolju3/DACA-group/tree/main/week-6/individual/helen)

## 14. Artefaktid

- [Power BI dashboard](urbanstyle_week6_tartu_dashboard_helen.pbix)
- [Dashboard'i kuvatõmmis](screenshots/w6_role_b_tartu_kaupluse_dashboard.png)
- [Lühike portfooliovaade](README.md)
