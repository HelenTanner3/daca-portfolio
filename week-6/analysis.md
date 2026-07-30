# Nädal 6 detailanalüüs — Tartu kaupluse dashboard

## 1. Töö kontekst ja roll

Nädal 6 jätkas Nädal 5 Power BI dashboard'i prototüübi arendamist. Grupitöö eesmärk oli muuta üldine visuaal asukohapõhiseks juhtimisvaateks, lisades konteksti, annotatsioonid, viitejooned ja andmeloo.

Minu ametlik roll oli **Roll B — Tartu kaupluse dashboard ja narratiiv**. Individuaalne artefakt on Tartu kaupluse juhtimisvaade Power BI-s. Meeskonna reposse lisatud PBIX, kuvatõmmis ja lühike README olid grupitöö sisendid; käesolev `analysis.md` kirjeldab ainult minu individuaalset tööd ja selle tulemusi.

## 2. Äriküsimus

Dashboard vastab kolmele põhiküsimusele:

1. Kuidas muutus Tartu kaupluse 2024. aasta müügitulu võrreldes 2023. aastaga?
2. Kas muutus tulenes eelkõige tellimuste arvust või keskmise tellimuse väärtusest?
3. Millised kuud ja tooted vajavad juhtimisotsuse seisukohalt tähelepanu?

Juhendi rollikirjelduses kasutatud Tartu langustrend oli näitlik lähtekoht. Tegelik andmestik näitas 2024. aastal kasvu, mistõttu koostasin narratiivi kontrollitud tulemuste, mitte juhendi näite põhjal.

## 3. Kasutatud andmed ja andmemudel

Dashboard kasutab järgmisi Power BI mudeli osi:

- `public sales` — müügitulu, tellimused, kuupäev, kauplus ja toode;
- `Calendar` — aasta, kuu ja kuude korrektne järjestus;
- `public products` — tootenimed TOP 5 toodete võrdluseks.

PBIX-mudelis on lisaks klientide ja inventuuri tabelid, kuid selle lehe kuvatud analüüs keskendub müügi-, aja- ja tooteandmetele.

Võrdlusperiood on **2023 vs 2024**, sest need on dashboard'is kasutatud täielikud võrreldavad aastad. Hilisemate aastate andmeid selles narratiivis ei kasutatud.

## 4. Dashboard'i struktuur

Dashboard sisaldab:

- kolme KPI-kaarti: 2024 müügitulu, 2023 müügitulu ja aastane muutus;
- tellimuste arvu võrdlust 2023 vs 2024;
- keskmise tellimuse võrdlust 2023 vs 2024;
- kuist müügitulu võrdlevat joondiagrammi;
- kuist aastakasvu diagrammi;
- TOP 5 toodete 2024 müügitulu tulpdiagrammi;
- kaupluse valiku slicer'it, mille vaikeseis on Tartu;
- kahte annotatsiooni ja juhtimisnarratiivi.

Värvikasutus on järjepidev: 2024 on tähistatud tumeda navy-tooniga, 2023 teal-tooniga, positiivne tähelepanek rohelise ja negatiivne oranži tooniga. Joondiagrammidel kasutatakse lisaks markerite kuju, et seeriad ei eristuks ainult värvi põhjal.

## 5. Mõõdikute loogika

Peamised mõõdikud põhinevad järgmisel loogikal:

- **müügitulu** — müügiridade `total_price` summa filtreeritud perioodis ja kaupluses;
- **tellimuste arv** — unikaalsete `invoice_id` väärtuste arv;
- **keskmine tellimus** — müügitulu jagatud tellimuste arvuga;
- **aastane muutus** — 2024 ja 2023 müügitulu vahe jagatud 2023 müügituluga;
- **kuine muutus** — iga 2024. aasta kuu võrdlus 2023. aasta sama kuuga.

Kõik KPI-d reageerivad Power BI filtrikontekstile. Tartu tulemused on dashboard'i vaikeseis ja analüüsi ametlik alus.

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

TOP 5 toodete 2024 müügitulu jääb ligikaudu 3,2–3,7 tuhande euro vahele. Väärtused on omavahel suhteliselt lähedased, mistõttu ei näita dashboard ühe selgelt domineeriva toote kontsentratsiooniriski. Täielikud tootenimed on PBIX-failis nähtavad visuaali ja tooltip'ide kaudu; kuvatõmmisel on pikemad nimetused ruumipiirangu tõttu kärbitud.

## 7. Tulemuste tõlgendus

### 7.1. Kasv tuli tellimuste mahust

Tartu müügitulu kasvas 13,4%, kuid keskmine tellimus vähenes 2,6%. Tellimuste arv suurenes 16,5%, mis tähendab, et kasv saavutati suurema tehingumahu, mitte suurema ostukorvi abil.

See on positiivne nõudluse signaal, kuid keskmise tellimuse langus vajab jälgimist. Kui ostukorvi väärtus jätkab vähenemist, võib müügitulu kasv sõltuda järjest suuremast tellimuste arvust.

### 7.2. Aasta sees oli oluline kõikumine

Müügitulu kasvas üheksal kuul kaheteistkümnest. Kõige selgem kõrvalekalle oli aprillis, mil tulemus jäi 2023. aasta aprillile 30,9% alla. Järgnenud mais oli kasv 96,9%, mis tasandas aprilli langust ja moodustas aasta tugevaima positiivse kõrvalekalde.

Dashboard ei sisalda kampaania-, konkurendi-, tööjõu- ega kauplusekülastuse andmeid. Seetõttu ei saa aprilli languse või mai kasvu põhjust nimetada kinnitatud faktina. Need kuud on edasise analüüsi prioriteedid.

### 7.3. Tootemüük on TOP 5 sees jaotunud

TOP 5 toodete müügitulud on suhteliselt lähedased. See vähendab riski, et Tartu tulemus sõltub ainult ühest bestsellerist, kuid täpsema sortimendiotsuse jaoks on vaja võrrelda müüdud koguseid, marginaali, laoseisu ja tootekategooriaid.

## 8. Andmelugu ja juhtimissoovitus

Dashboard'i narratiiv on:

> **Tulemus:** Tartu müügitulu kasvas 2024. aastal 13,4%.  
> **Kõikumine:** suurim langus oli aprillis −30,9% ja tugevaim kasv mais +96,9%.  
> **Tegevus:** analüüsida aprilli ja mai toote-, kategooria- ning kliendisegmendi struktuuri, et tuvastada korratavad kasvutegurid.

Soovitus ei eelda, et mai kasvu põhjus on juba teada. Esmalt tuleb võrrelda kahe kuu:

- toodete ja kategooriate osakaalu;
- tellimuste arvu ja keskmist tellimust;
- kliendisegmente ning korduvostjaid;
- kampaaniaid ja võimalikke operatiivseid muutusi, kui need andmed on kättesaadavad.

## 9. Interaktiivsus

Dashboard sisaldab `Kauplus` slicer'it ja Tartu on salvestatud vaikevalikuna. Visuaalid on loodud filtrikontekstile reageerima, et sama lehe struktuuri saaks kasutada ka teiste füüsiliste kaupluste kontrollimiseks.

Narratiiv ja aprilli/mai annotatsioonid on siiski staatilised ning kirjeldavad ainult Tartut. See piirang on märgitud ka dashboard'il. Teise kaupluse valimisel tuleb tõlgendada dünaamilisi KPI-sid ja diagramme, mitte Tartu kohta kirjutatud staatilist teksti.

Dokumentatsiooni koostamise ajal ei tehtud eraldi täielikku `Edit interactions` maatriksi kordustesti. Seetõttu tuleb enne võimalikku avalikku jagamist kontrollida, et kaupluse slicer filtreerib kõiki KPI-sid ja diagramme soovitud viisil.

## 10. Valideerimine ja kvaliteedikontroll

Tehtud kontrollid:

- 2023 ja 2024 kuusummad ühtivad aastaste KPI-dega;
- 13,4% muutus vastab aastasummade suhtelisele erinevusele;
- tellimuste ja keskmise tellimuse väärtused lepivad kokku müügituluga;
- kuine narratiiv vastab visualiseeritud andmetele;
- juhendis toodud näitlikku −5% langust ei kasutatud tegeliku tulemusena;
- võimalikke ärilisi põhjuseid ei esitatud kinnitatud faktidena ilma täiendavate andmeteta.

## 11. Piirangud ja edasised arendused

- Kauplusefilter muudab visuaale, kuid staatiline narratiiv ei muutu valikuga kaasa.
- Interaktsioonid tuleb enne avaldamist kõikide visuaalide lõikes uuesti testida.
- Dashboard ei sisalda marginaali, kampaaniate, konkurentide, külastuste ega tööjõuandmeid.
- TOP 5 toodete võrdlus põhineb müügitulul, mitte kasumlikkusel või laoseisul.
- Analüüs võrdleb 2023. ja 2024. aasta tulemusi ega tee prognoosi.
- Avalikku Power BI Service'i linki ega mobiilivaadet ei ole selle portfoolioversiooni tõendusmaterjalina kontrollitud.

Edasine arendus võiks muuta narratiivi dünaamiliseks, lisada tootekategooria ja kliendisegmendi drill-down'i ning siduda müügitulemuse varu- ja marginaaliandmetega.

## 12. Individuaalse ja grupitöö eristus

### Individuaalne töö

- Tartu kaupluse Power BI dashboard;
- Tartu andmetel põhinevad KPI-d, trendid, TOP 5 tooted ja narratiiv;
- käesolev detailanalüüs ja kuvatõmmis.

### Grupitöö

Minu individuaalne PBIX, kuvatõmmis ja lühike kirjeldus lisati meeskonna W6 reposse ning ühendati `main` harusse PR-iga **“Add week 6 Helen role B dashboard”**. Grupi repo commit on `6a1e5c6`. Grupi repo materjal on eraldi meeskonnatöö väljund ega asenda isikliku portfoolio dokumentatsiooni.

- [Minu W6 väljund grupirepos](https://github.com/Kolju3/DACA-group/tree/main/week-6/individual/helen)

## 13. Artefaktid

- [Power BI dashboard](urbanstyle_week6_tartu_dashboard_helen.pbix)
- [Dashboard'i kuvatõmmis](screenshots/w6_role_b_tartu_kaupluse_dashboard.png)
- [Lühike portfooliovaade](README.md)
