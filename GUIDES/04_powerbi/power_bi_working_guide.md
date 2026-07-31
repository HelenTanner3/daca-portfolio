# Power BI praktiline tööjuhend

See juhend koondab DACA koolituse Nädal 5–6 Power BI teemad ning minu UrbanStyle’i CEO ja Tartu kaupluse dashboard’ide tegemisel tekkinud praktilised õppetunnid.

Juhendi eesmärk ei ole kirjeldada kõiki Power BI võimalusi. See annab korduvkasutatava töövoo, mille järgi saan edaspidi:

- sõnastada dashboard’i äriküsimuse;
- ühendada ja kontrollida andmeid;
- luua toimiva andmemudeli;
- koostada DAX-mõõdikuid;
- valida sobivad visuaalid;
- seadistada filtrid ja interaktsioonid;
- kujundada loetava ja ligipääsetava juhtimisvaate;
- lisada andmeloo, annotatsioonid ja viitejooned;
- kontrollida tulemusi;
- salvestada, avaldada ja dokumenteerida artefakti.

> Juhend kirjeldab koolitusel kasutatud Power BI Desktopi töövoogu Windowsis. Power BI menüüde nimetused võivad versiooniuuendustega veidi muutuda.

---

## 1. Power BI töö põhimõte

Power BI töö koosneb viiest omavahel seotud osast:

```text
äriküsimus
    ↓
andmed ja andmemudel
    ↓
DAX-mõõdikud
    ↓
visuaalid ja interaktiivsus
    ↓
kontrollitud juhtimisjäreldus
```

Hea dashboard ei alga diagrammist. See algab küsimusest, millele konkreetne kasutaja vajab vastust.

Koolituse näited:

| Kasutaja | Põhiküsimus | Sobiv vaade |
|---|---|---|
| CEO | Kas ettevõte kasvab? | Kõrgtaseme KPI-d ja trend |
| Turundusjuht | Kas turundus töötab? | Kanalid, kliendihankimine ja kampaaniad |
| Operatsioonide juht | Kas meil on piisavalt kaupa? | Inventuur, tarneaeg ja laojaotus |
| Kaupluse juht | Mis toimub minu kaupluses? | Asukohapõhised KPI-d, trendid ja tooted |
| Investor | Kas ettevõte on investeerimisväärne? | Koondvaade, kasv, riskid ja tegevussoovitus |

Üks dashboard ei pea näitama kõike. See peab aitama valitud kasutajal otsustada.

---

## 2. Enne Power BI avamist

Enne visuaalide loomist vasta kirjalikult viiele küsimusele:

1. Kes dashboard’i kasutab?
2. Millisele põhiküsimusele peab ta vastuse saama?
3. Milliseid otsuseid selle vaate põhjal tehakse?
4. Millised mõõdikud vastavad päriselt sellele küsimusele?
5. Milline võrdlus annab numbrile konteksti?

Näide:

```text
Kasutaja: Tartu kaupluse juht
Põhiküsimus: kuidas muutus tulemus võrreldes eelmise aastaga?
Mõõdikud: müügitulu, tellimuste arv, keskmine tellimus
Võrdlus: 2024 vs 2023
Detailid: kuud, tooted, kategooriad ja kliendigrupid
Tegevus: tuvastada languskuud ja korratavad kasvutegurid
```

### „Ja mis siis?” test

Iga mõõdik ja diagramm peab vastama küsimusele:

> Mida see tulemus tähendab ja mida peaks juht selle põhjal edasi tegema?

Nõrk:

```text
Müügitulu oli 260 044 eurot.
```

Tugevam:

```text
Müügitulu kasvas 13,4%, kuid keskmine tellimus vähenes 2,6%.
Kasv tuli seega suuremast tellimuste arvust, mitte suuremast ostukorvist.
```

---

## 3. Power BI põhivaated

Power BI Desktopis kasutatakse peamiselt kolme vaadet.

### Report view

Siin lood:

- KPI-kaardid;
- diagrammid;
- slicer’id;
- tekstikastid;
- annotatsioonid;
- raportilehe kujunduse.

### Data view

Siin kontrollid:

- veerge ja väärtusi;
- arvutuslikke veerge;
- andmetüüpe;
- tühje väärtusi;
- kuupäevade kuju;
- mõõdikute kontrolltabeleid.

### Model view

Siin kontrollid:

- tabelite seoseid;
- seose suunda;
- kardinaalsust;
- aktiivseid ja mitteaktiivseid seoseid;
- dimensiooni- ja faktitabelite loogikat.

---

## 4. Andmete ühendamine ja import

Koolitusel kasutasime Power BI-d Supabase’i PostgreSQL andmetega. Vajaduse korral sai kasutada ka puhastatud CSV-faile.

### Enne ühendamist kontrolli

- andmeallika server ja andmebaas;
- kasutajanimi ja parool;
- kas kasutatakse Supabase Session Pooler ühendust;
- kas vajalikud tabelid on olemas;
- kas kuupäeva- ja numbriväljade andmetüübid on õiged;
- kas Power BI ja Supabase’i ühendus on enne grupitööd testitud.

### Supabase’i sertifikaadi viga

Tüüpiline veateade:

```text
The remote certificate is invalid according to the validation procedure
```

Koolituse lahendus oli Supabase’i juursertifikaadi paigaldamine Windowsi usaldusväärsete juursertifikaatide hulka ja Power BI täielik taaskäivitamine.

Oluline:

- ära lülita SSL-i või krüpteerimist juhuslikult välja;
- sertifikaadiprobleem ei tähenda automaatselt, et parool on vale;
- kui ühendus ei tööta ja ülesande aeg on piiratud, kasuta kokkulepitud puhast CSV-varuvarianti.

### Pärast importi

Kontrolli Power BI-s:

- tabelite ridade arvu;
- võtmevälju;
- kuupäevade vahemikku;
- tühje väärtusi;
- ootamatuid kategooriaid;
- numbriveergude andmetüüpe.

Ära alusta visuaalide tegemist enne, kui põhilised kontrollväärtused on teada.

---

## 5. Andmemudel

Hea andmemudel vähendab valesid tulemusi ja lihtsustab DAX-i.

### Faktitabel

Faktitabel sisaldab sündmusi või tehinguid.

UrbanStyle’i näide:

```text
public sales
```

Olulised väljad:

- `sale_date`;
- `customer_id`;
- `product_id`;
- `invoice_id`;
- `store_location`;
- `quantity`;
- `total_price`.

### Dimensioonitabelid

Dimensioonid kirjeldavad tehinguid.

Näited:

```text
public customers
public products
Calendar
```

### Põhiseosed

```text
public customers[customer_id]  1 ─── *  public sales[customer_id]

public products[product_id]    1 ─── *  public sales[product_id]

Calendar[Date]                 1 ─── *  public sales[sale_date]
```

Üldpõhimõte:

```text
dimensioon 1 → * faktitabel
```

### Enne mõõdikute loomist kontrolli

- kas seos kasutab õigeid võtmeid;
- kas võtmete andmetüübid ühtivad;
- kas aktiivne seos on õige;
- kas filtrisuund on põhjendatud;
- kas mudelis on mitmetähenduslikke filtreerimisteid;
- kas sama kuupäevatabel teenindab kõiki ajapõhiseid visuaale.

### Aktiivne ja mitteaktiivne kuupäevaseos

Müügitulu analüüsis oli aktiivne seos:

```text
Calendar[Date] → public sales[sale_date]
```

Kliendi esimese ostu analüüsis kasutati lisaks mitteaktiivset seost:

```text
Calendar[Date] → public customers[Esimese ostu päev]
```

Mitteaktiivne seos aktiveeritakse vajalikus mõõdikus funktsiooniga `USERELATIONSHIP`.

See võimaldab kasutada ühte `Calendar`-tabelit eri kuupäevaloogikate jaoks ilma, et mõlemad seosed oleksid korraga aktiivsed.

---

## 6. Calendar-tabel

Ajaanalüüsi jaoks kasuta eraldi kalendritabelit, mitte ainult Power BI automaatset kuupäevahierarhiat.

Kalendritabel võimaldab:

- aastaid võrrelda;
- kuud kronoloogiliselt sortida;
- luua aasta-kuu ja aasta-kvartali välju;
- kasutada sama ajafiltrit mitmes mõõdikus;
- hallata aktiivseid ja mitteaktiivseid kuupäevaseoseid.

### Korduvkasutatav näide

Järgmine näide on koostatud meie kasutatud väljade põhjal. Kohanda algus- ja lõppkuupäeva oma andmestikule.

```DAX
Calendar =
ADDCOLUMNS(
    CALENDAR(
        DATE(2023, 1, 1),
        DATE(2024, 12, 31)
    ),
    "Aasta", YEAR([Date]),
    "Kuu nr", MONTH([Date]),
    "Kuu", FORMAT([Date], "mmmm"),
    "Kuu lühike", FORMAT([Date], "mmm"),
    "Aasta-kuu", FORMAT([Date], "yyyy-MM"),
    "Aasta-kuu sort", YEAR([Date]) * 100 + MONTH([Date]),
    "Kvartal", "Q" & FORMAT([Date], "Q"),
    "Aasta-kvartal",
        FORMAT([Date], "yyyy") & " Q" & FORMAT([Date], "Q"),
    "Aasta-kvartal sort",
        YEAR([Date]) * 10 + VALUE(FORMAT([Date], "Q"))
)
```

### Kuude sortimine

Kui kuud kuvatakse tähestikulises järjekorras:

```text
aprill, august, detsember...
```

vali kuunime veerg ja määra:

```text
Column tools → Sort by column → Kuu nr
```

### Aasta-kuu sortimine

```text
Aasta-kuu
Sort by column → Aasta-kuu sort
```

### Aasta-kvartali sortimine

```text
Aasta-kvartal
Sort by column → Aasta-kvartal sort
```

Aja telgedel eelista `Calendar`-tabeli välju.

---

## 7. DAX põhimõtted

### Mõõdik või arvutuslik veerg?

**Mõõdik** arvutatakse filtrikontekstis ja sobib KPI-de, diagrammide ja dünaamiliste võrdluste jaoks.

**Arvutuslik veerg** arvutatakse tabeli iga rea kohta ja sobib püsiva reaomaduse loomiseks.

Meie dashboard’ide peamised KPI-d olid mõõdikud.

### Müügitulu

```DAX
Müügitulu =
SUM('public sales'[total_price])
```

### Aastapõhine müügitulu

```DAX
Müügitulu 2023 =
CALCULATE(
    [Müügitulu],
    'public sales'[sale_date] >= DATE(2023, 1, 1),
    'public sales'[sale_date] < DATE(2024, 1, 1)
)
```

```DAX
Müügitulu 2024 =
CALCULATE(
    [Müügitulu],
    'public sales'[sale_date] >= DATE(2024, 1, 1),
    'public sales'[sale_date] < DATE(2025, 1, 1)
)
```

### Aastane muutus

```DAX
Käibe kasv 2024 vs 2023 =
DIVIDE(
    [Müügitulu 2024] - [Müügitulu 2023],
    [Müügitulu 2023]
)
```

Kasuta jagamisel `DIVIDE`, mitte ainult `/`, sest `DIVIDE` käsitleb nulliga jagamist turvalisemalt.

### Tellimuste arv

```DAX
Tellimused 2024 =
CALCULATE(
    DISTINCTCOUNT('public sales'[invoice_id]),
    Calendar[Aasta] = 2024
)
```

```DAX
Tellimused 2023 =
CALCULATE(
    DISTINCTCOUNT('public sales'[invoice_id]),
    Calendar[Aasta] = 2023
)
```

### Tellimuste muutus

```DAX
Tellimuste muutus 2024 vs 2023 =
DIVIDE(
    [Tellimused 2024] - [Tellimused 2023],
    [Tellimused 2023]
)
```

### Keskmine tellimus

```DAX
Keskmine tellimus 2024 =
DIVIDE(
    [Müügitulu 2024],
    [Tellimused 2024]
)
```

```DAX
Keskmine tellimus 2023 =
DIVIDE(
    [Müügitulu 2023],
    [Tellimused 2023]
)
```

### Keskmise tellimuse muutus

```DAX
Keskmise tellimuse muutus 2024 vs 2023 =
DIVIDE(
    [Keskmine tellimus 2024] - [Keskmine tellimus 2023],
    [Keskmine tellimus 2023]
)
```

### Ostnud kliendid

```DAX
Ostnud kliendid =
CALCULATE(
    DISTINCTCOUNT('public sales'[customer_id]),
    'public sales'[customer_id] <> BLANK()
)
```

### Esimese ostu põhine mõõdik

```DAX
Uued ostnud kliendid =
CALCULATE(
    DISTINCTCOUNT('public customers'[customer_id]),
    USERELATIONSHIP(
        'Calendar'[Date],
        'public customers'[Esimese ostu päev]
    ),
    KEEPFILTERS(
        'public customers'[Esimese ostu päev] <> BLANK()
    )
)
```

Tõlgenduspiirang:

> „Uus klient” tähendab esimest ostu olemasolevas andmestikus. Kui varasemad ostud jäävad andmestiku algusest väljapoole, ei saa neid selle mudeliga tuvastada.

---

## 8. Filtrikontekst

Power BI mõõdiku tulemus sõltub filtrikontekstist.

Sama mõõdik võib anda erineva tulemuse, kui kasutaja valib:

- teise aasta;
- teise kaupluse;
- teise kategooria;
- teise kliendigrupi;
- diagrammi ühe tulba või punkti.

Seetõttu ei piisa ainult sellest, et mõõdik annab kogu andmestiku kohta õige numbri. Seda tuleb testida ka erinevate filtrivalikutega.

### Kontrollküsimused

- Kas KPI reageerib kaupluse slicer’ile?
- Kas võrdlusaasta jääb soovitud filtrites alles?
- Kas diagrammil klõpsamine peab mõjutama KPI-d?
- Kas staatiline narratiiv vastab pärast filtrivalikut endiselt vaatele?
- Kas Top N pingerida arvutatakse uuesti valitud filtrikontekstis?

---

## 9. Diagrammitüübi valik

Koolituse kiirreegel:

| Küsimus | Sobiv visuaal |
|---|---|
| Kuidas väärtus ajas muutub? | Joondiagramm |
| Kuidas kategooriaid võrrelda? | Tulp- või ribadiagramm |
| Kui suur on üks põhinäitaja? | KPI/Card |
| Kuidas jaguneb tervik? | Sektor- või rõngasdiagramm |
| Milline on kahe tunnuse seos? | Hajuvusdiagramm |

### Joondiagramm

Kasuta trendi jaoks:

- kuud x-teljel;
- müügitulu või muu mõõdik y-teljel;
- aasta legendis või eraldi seeriana.

Ära kuva kõigi punktide andmesilte, kui need muudavad diagrammi kirjuks. Kasuta vajaduse korral tooltip’i ja annotatsioone.

### Tulp- või ribadiagramm

Kasuta kategooriate ja toodete võrdluseks.

Pikkade tootenimede korral on horisontaalne ribadiagramm tavaliselt loetavam.

### Sektordiagramm

Kasuta ainult siis, kui:

- eesmärk on näidata osa tervikust;
- kategooriaid on vähe;
- osad on selgelt eristatavad.

Koolituse soovitus: maksimaalselt umbes viis sektorit. Ülejäänud võib koondada kategooriasse „Muu”.

### KPI-kaart

Kasuta ühe otsustamiseks vajaliku numbri jaoks:

- müügitulu;
- kasvuprotsent;
- tellimuste arv;
- keskmine tellimus;
- klientide arv.

Kaardi pealkiri peab ütlema:

- mida mõõdetakse;
- mis perioodi kohta;
- millise võrdlusega.

---

## 10. Dashboard’i visuaalne hierarhia

Koolitusel kasutatud põhistruktuur:

```text
pealkiri ja peamine filter
KPI-d
peamine trend
tugivisuaalid
detailfiltrid ja narratiiv
```

### Ühe ekraani reegel

Põhiinfo peab mahtuma ühele ekraanile ilma vertikaalse kerimiseta.

Kui dashboard ei mahu:

- vähenda visuaalide arvu;
- eemalda korduvad mõõdikud;
- vähenda dekoratiivseid elemente;
- kasuta detailvaate jaoks teist lehte;
- kasuta kokkupandavat filtriplokki või bookmark’e;
- jäta põhivaatesse ainult otsustamiseks vajalik.

### Data-ink ratio

Eemalda:

- 3D-efektid;
- liiga tugevad ruudustikujooned;
- dekoratiivsed kujundid, mis ei kanna infot;
- tarbetud äärised;
- korduvad legendid;
- liigsed andmesildid;
- liiga palju erinevaid värve.

---

## 11. Värvid ja ligipääsetavus

Koolituse UrbanStyle’i värvid:

```text
teal  #009B8D
navy  #1A1A2E
```

Koolituse soovitus oli kasutada korraga piiratud arvu värve, ligikaudu 5–7.

### Praktiline võrdlusaastate lahendus

Juhendaja tagasiside põhjal võiks:

- uuem aasta olla visuaalselt rõhutatud;
- varasem võrdlusaasta olla neutraalsem hall;
- võrdlusseeria mitte konkureerida põhitulemusega.

Näide:

```text
2024 põhiseeria: teal või muu selge aktsentvärv
2023 võrdlusseeria: hall
pealkirjad: navy
viitejooned: neutraalne hall
```

### Värv ei tohi olla ainus tähenduse kandja

Kasuta lisaks:

- `↑`, `↓` ja `–`;
- erinevaid markerikujusid;
- joone stiile;
- otseseid silte;
- selget legendi;
- pluss- ja miinusmärki.

Värvipimedatele sobiv semantiline näide:

```text
positiivne  #009E73
negatiivne  #D55E00
neutraalne  #4B5563
```

---

## 12. KPI-kaardi tingimuslik värvimine

Eesmärk: kasv, langus ja nullmuutus peavad olema arusaadavad nii värvi kui märgi järgi.

### Põhimõõdik

```DAX
Käibe kasv 2024 vs 2023 =
DIVIDE(
    [Müügitulu 2024] - [Müügitulu 2023],
    [Müügitulu 2023]
)
```

### Värvi tagastav mõõdik

```DAX
Käibe kasvu värv =
SWITCH(
    TRUE(),
    [Käibe kasv 2024 vs 2023] > 0, "#009E73",
    [Käibe kasv 2024 vs 2023] < 0, "#D55E00",
    "#4B5563"
)
```

### Card-visuaali seadistus

1. Vali Card.
2. Ava `Format visual`.
3. Ava `Visual → Callout`.
4. Vali `Apply settings to` alt õige põhimeasure.
5. Ava `Value`.
6. Leia `Color`.
7. Vajuta `fx`.
8. Vali `Format style: Field value`.
9. Vali värvi aluseks `Käibe kasvu värv`.
10. Kinnita.

### Kontroll

Testi vähemalt:

- positiivse tulemusega filtrit;
- negatiivse tulemusega filtrit;
- võimaluse korral nulltulemust.

Kui värvub vale väärtus, kontrolli `Apply settings to` valikut.

---

## 13. Slicer’id ja filtrid

### Peamised filtritüübid

- asukoht;
- ajaperiood;
- tootekategooria;
- alamkategooria;
- kliendigrupp või lojaalsustase.

Koolituse järgi muudavad filtrid ühe dashboard’i mitmeks dünaamiliseks vaateks.

### Filtrite arv

Põhivaates hoia nähtaval ainult kõige olulisemad filtrid.

Praktiline lahendus:

- peamine juhtimisfilter, näiteks kauplus, lehe ülaosas;
- detailfiltrid kategooria, alamkategooria ja kliendigrupi jaoks eraldi detailalas;
- suurema filtrite arvu korral kasuta kokkupandavat filtriplokki, bookmark’i või teist vaadet.

Juhendaja tagasiside kohaselt võiksid olulised filtrid olla ülaosas või avatavas „akordioni” tüüpi paneelis. Seda lahendust võib edaspidi õppida bookmark’ide, Selection pane’i ja nuppude abil.

### Dropdown ja Single select

Kui korraga peab olema valitud üks kauplus:

```text
Slicer settings → Style: Dropdown
Selection → Single select: On
Select all: Off
```

### Vaikevalik

Enne faili salvestamist vali soovitud vaikeolek, näiteks `Tartu`.

Kontrolli, et vaikevalik vastab ka staatilisele narratiivile.

---

## 14. Interaktsioonide haldamine

Power BI cross-filtering tähendab, et ühe visuaali valik mõjutab teisi visuaale.

See ei pea alati olema kõigi visuaalide puhul ühesugune.

### Edit interactions

1. Vali slicer või visuaal.
2. Ava `Format → Edit interactions`.
3. Iga teise visuaali juures vali:
   - `Filter`;
   - `Highlight`;
   - `None`.

### Praktilised otsused

Näide:

- kaupluse slicer filtreerib kõiki KPI-sid ja diagramme;
- Top 5 toote valik võib filtreerida trendi;
- Top 5 toote valik ei pea muutma kogu kaupluse kõrgtaseme KPI-sid;
- staatiline Tartu narratiiv ei tohi jätta muljet, et see muutus teise kaupluse valimisel dünaamiliselt.

### Interaktsioonide test

Vali järjest:

- Tallinn;
- Tartu;
- Pärnu;
- Online;
- üks kategooria;
- üks kliendigrupp.

Kontrolli iga kord:

- KPI-d;
- trendid;
- Top N;
- annotatsioonid;
- narratiiv;
- viitejooned;
- visuaalide pealkirjad.

---

## 15. Drill-down ja hierarhiad

Drill-down võimaldab liikuda üldisemalt tasemelt detaili.

Tooteanalüüsi loogiline hierarhia:

```text
kategooria
    ↓
alamkategooria
    ↓
toode
```

Kui raport on salvestatud toote tasemel, saab kasutaja drill-up funktsiooniga liikuda tagasi alamkategooria ja kategooria tasemele.

Hierarhia kasutamisel kontrolli:

- kas väljade järjekord on loogiline;
- kas drillimise ikoonid on nähtavad;
- kas pealkiri selgitab parasjagu kuvatavat taset;
- kas Top 5 tähendab tooteid või valitud kõrgema taseme gruppe.

Oluline piirang:

> Toote Top 5 diagrammi drill-up ei tähenda automaatselt, et kuvatakse kogu andmestiku Top 5 kategooriat. Tulemuse tähendus sõltub visuaali filtrikontekstist ja hierarhiast.

---

## 16. Top N visuaal

Top 5 toodete loomiseks:

1. Lisa ribadiagramm.
2. Paiguta kategooriaväljaks toode.
3. Paiguta väärtuseks müügitulu mõõdik.
4. Ava visuaali filtrid.
5. Vali tootevälja filtritüübiks `Top N`.
6. Sisesta `5`.
7. `By value` väljale lisa soovitud müügitulu mõõdik.
8. Rakenda filter.
9. Sordi tulemus kahanevalt.

Kontrolli, kas Top 5 arvutatakse:

- kogu ettevõtte;
- valitud kaupluse;
- valitud aasta;
- valitud kategooria põhjal.

Pealkiri peab seda konteksti selgitama.

---

## 17. Annotatsioonid

Annotatsioon suunab tähelepanu olulisele andmepunktile.

Power BI-s:

```text
Insert → Text box
```

Vajaduse korral lisa:

```text
Insert → Shapes → Arrow
```

Hea annotatsioon sisaldab:

- perioodi või kategooriat;
- mõõdetavat muutust;
- tähendust;
- võimaluse korral tegevusvajadust.

Näide:

```text
Mai +96,9% — aasta tugevaim kasv
```

```text
Aprill −30,9% — aasta suurim langus
```

### Ära mõtle põhjust välja

Kui dashboard ei sisalda kampaania-, konkurendi-, tööjõu- või külastusandmeid, ära kirjuta:

```text
Mai kasv tuli kampaaniast.
```

Kirjuta:

```text
Mai kasv vajab toote-, kategooria- ja kliendisegmendi põhist analüüsi.
```

Annotatsioon peab eristama:

- mida andmed kinnitavad;
- mida tuleb veel uurida.

---

## 18. Viitejooned

Viitejoon annab numbrile konteksti.

Power BI-s:

1. Vali diagramm.
2. Ava Analytics paneel.
3. Lisa sobiv joon:
   - Constant line;
   - Average line;
   - muu visuaali toetatud viitejoon.
4. Määra väärtus, nimi, stiil ja silt.

Kasutatud näited:

- 0% joon aastase muutuse diagrammil;
- keskmise taseme joon kuisel müügil;
- ettevõtte target;
- valdkonna keskmine, kui kontrollitud väärtus on olemas.

Viitejoon peab olema visuaalselt tagasihoidlikum kui põhiseeria.

Ära lisa väljamõeldud targetit või valdkonna keskmist.

---

## 19. Andmelugu

Koolituse andmeloo raamistik:

1. **Ülesseade** – mis vaadet ja konteksti analüüsime?
2. **Konflikt** – milline küsimus või probleem vajas vastust?
3. **Andmed** – mida dashboard näitab?
4. **Lahendus** – mida tulemusest järeldame?
5. **Tegevus** – mida tuleks edasi teha?

Tartu näide:

```text
Tulemus: Tartu müügitulu kasvas 2024. aastal 13,4%.

Kõikumine: suurim langus oli aprillis −30,9% ja tugevaim kasv mais +96,9%.

Tegevus: analüüsida aprilli ja mai toote-, kategooria- ning kliendisegmendi struktuuri, et tuvastada korratavad kasvutegurid.
```

Hea juhtimisnarratiiv:

- on lühike;
- kasutab kontrollitud numbreid;
- ei korda kõiki diagrammi silte;
- ei väida teadmata põhjust;
- lõpeb tegevuse või järgmise analüüsiküsimusega.

---

## 20. Staatiline ja dünaamiline narratiiv

Tekstikastiga kirjutatud narratiiv on tavaliselt staatiline.

Kui kasutaja muudab kauplust, võib:

- KPI muutuda;
- diagramm muutuda;
- Top 5 muutuda;
- tekst jääda endiselt Tartu kohta.

Lahendused:

1. hoia Tartu salvestatud vaikevalikuna;
2. lisa märkus, et narratiiv kirjeldab Tartut;
3. väldi teiste kaupluste valimist esitluse põhivaates;
4. loo edaspidi dünaamilised tekstimõõdikud;
5. kasuta bookmark’e eri asukohavaadete jaoks.

Enne jagamist testi, et staatiline tekst ei eksitaks kasutajat.

---

## 21. Andmete valideerimine

Dashboard ei ole valmis enne, kui numbrid on kontrollitud.

### Kontrolltabelid Power BI-s

Loo ajutised tabelivisuaalid, mis sisaldavad:

- aastat;
- kuud;
- kauplust;
- mõõdikut;
- kontrollsummat.

Kontrolli vähemalt:

- 2023 ja 2024 aastasummasid;
- kuusummade kokkulangevust aastasummaga;
- kasvuprotsendi arvutust;
- `DISTINCTCOUNT` tulemusi;
- keskmise tellimuse seost müügitulu ja tellimuste arvuga;
- Top 5 järjestust;
- tühjade väärtuste mõju;
- filtrite mõju kõigile visuaalidele.

### Referentsväärtus

Ära usalda mõõdikut ainult seetõttu, et sama valem töötas eelmises raportis.

Leia kontrollväärtus:

- SQL-päringust;
- Power BI tabelivisuaalist;
- teadaolevast aastasummast;
- käsitsi arvutatud valimist;
- teise mõõdiku kaudu tehtud ristkontrollist.

### Tühjad väärtused

Ära filtreeri tühje väärtusi automaatselt välja.

Näiteks tühja linnaga müük võib moodustada olulise osa kogukäibest. Selle äriline tähendus tuleb eraldi kontrollida, mitte oletada, et see on Online.

---

## 22. Pealkirjad ja sildid

Iga visuaal vajab selget pealkirja.

Nõrk:

```text
Müügitulu
```

Tugevam:

```text
Müügitulu kuude lõikes: 2023 vs 2024
```

Veel täpsem:

```text
Tartu müügitulu kuude lõikes: 2023 vs 2024
```

Pealkiri peaks võimaluse korral selgitama:

- mõõdikut;
- perioodi;
- võrdlust;
- asukohta või segmenti.

Telgede nimetused peavad olema loetavad ja ühikud järjepidevad.

---

## 23. Andmesildid ja tooltip’id

Andmesildid aitavad ainult siis, kui need ei tekita müra.

Kasuta andmesilte:

- KPI-kaartidel;
- Top N ribadel;
- üksikutel olulistel punktidel;
- väheste väärtustega võrdlusel.

Vähenda või eemalda sildid:

- tihedal kuutrendil;
- mitme joone ja paljude punktidega diagrammil;
- kui sildid kattuvad;
- kui tooltip annab sama info paremini.

Kontrolli `Display units` seadistust:

```text
None
Thousands
Millions
Auto
```

Vale `Display units` võib muuta numbri eksitavaks või arusaamatuks.

---

## 24. Filtrite paigutuse otsus

Meie Tartu dashboard’is kasutati:

- kaupluse valikut ülaosas peamise filtrina;
- kategooria, alamkategooria ja kliendigrupi filtreid alumises detailalas.

Selle otsuse eesmärk oli:

- hoida juhtimisvaade rahulik;
- mitte anda kõigile filtritele sama visuaalset kaalu;
- võimaldada detailihuvilisel analüüsi süvendada.

Juhendaja tagasiside:

- detailfiltrid võiksid olla samuti ülaosas;
- suurema filtrite arvu korral võiks kasutada avatavat filtriplokki;
- accordion-tüüpi lahendust tasub eraldi uurida.

Edasine Power BI lahendus võib kasutada:

- Selection pane’i;
- bookmark’e;
- nuppe;
- avatud ja suletud filtrivaateid.

---

## 25. Salvestamine ja varundamine

PBIX on binaarfail. Git ei näita selle sisulist erinevust ridade kaupa.

### Salvesta teadlikult

Kasuta selgeid failinimesid:

```text
urbanstyle_week5_dashboard_helen.pbix
urbanstyle_week6_tartu_dashboard_helen.pbix
```

### Versioonide eristamine

Vajaduse korral hoia eraldi:

```text
esitatud versioon
edasiarendatud õppeversioon
varukoopia
```

Ära kasuta lõpliku versioonina juhuslikku taastamisfaili enne, kui oled selle terviklikkust kontrollinud.

### Pärast Power BI kokkujooksmist

1. Ära kirjuta töötavat PBIX-i kohe üle.
2. Tee olemasolevast failist koopia.
3. Kontrolli taastamisfaili kuupäeva ja suurust.
4. Ava fail Power BI-s.
5. Kontrolli lehti, mudelit, mõõdikuid ja visuaale.
6. Salvesta kinnitatud versioon uue selge nimega.
7. Asenda repo fail alles pärast kontrolli.

---

## 26. Avaldamine Power BI Service’isse

Koolituse Nädal 6 juhend käsitles Power BI Service’isse avaldamist.

Põhivoo loogika:

1. Logi Power BI Desktopis sisse.
2. Ava valmis PBIX.
3. Vali `Home → Publish`.
4. Vali sobiv workspace.
5. Ava avaldatud raport brauseris.
6. Kontrolli filtreid, visuaale ja mobiilivaadet.
7. Seadista jagamine.
8. Testi linki teise kasutaja vaates või incognito-aknas.

### Konto piirang

Koolituse juhendi järgi võib Power BI Service nõuda töö- või koolikontot. Konto- ja litsentsipiirangute tõttu ei pruugi avalik või organisatsiooniväline jagamine alati olla saadaval.

### Publish to Web

`Publish to web` muudab raporti avalikuks kogu internetile.

Ära kasuta seda:

- päris klientide andmetega;
- töötajate andmetega;
- konfidentsiaalsete finantsandmetega;
- isikuandmetega;
- piiratud ligipääsuga projektides.

UrbanStyle’i simulatsiooniandmete puhul võib avalik jagamine olla võimalik, kuid link tuleb enne portfooliosse lisamist kontrollida.

Ära kirjuta README-sse LIVE URL-i, mida sa ei ole ise avanud ja testinud.

---

## 27. Mobiilivaade

Koolituse lõppjuhend käsitles ka mobiilivaadet.

Mobiilivaate eesmärk:

- KPI-d on telefonis kohe nähtavad;
- oluline trend on loetav;
- kasutaja ei pea elemente horisontaalselt otsima;
- filtrid on kasutatavad;
- tekst ei ole liiga väike.

Kui mobiilivaadet ei ole tegelikult loodud ja kontrollitud, ära esita seda portfoolios tehtud funktsioonina.

---

## 28. Eksport ja portfoolio

### Kuvatõmmis

Enne kuvatõmmist:

- vali ametlik vaikefilter;
- eemalda juhuslikud valikud;
- kontrolli annotatsioone;
- kontrolli pealkirju ja kirjavigu;
- veendu, et kõik elemendid mahuvad pildile;
- kontrolli, et kuvatõmmis vastab PBIX-i viimasele versioonile.

Windowsis:

```text
Win + Shift + S
```

### PDF

Power BI Desktopis:

```text
File → Export to PDF
```

PDF on kasulik varuvariant, kuid ekspordis tuleb kontrollida:

- lehekülgede paigutust;
- kärbitud teksti;
- filtreid;
- annotatsioonide loetavust.

### GitHubi artefaktid

Soovituslik kaust:

```text
week-6/
├── README.md
├── analysis.md
├── urbanstyle_week6_tartu_dashboard_helen.pbix
└── screenshots/
    └── w6_role_b_tartu_kaupluse_dashboard.png
```

README jääb lühikeseks.

`analysis.md` sisaldab:

- äriküsimust;
- andmeid ja mudelit;
- mõõdikute loogikat;
- kontrollväärtusi;
- tõlgendust;
- disainiotsuseid;
- piiranguid;
- tagasisidet;
- edasisi arendusi.

---

## 29. Levinumad probleemid ja lahendused

### Probleem: kuud on tähestikulises järjekorras

Lahendus:

```text
Kuu lühike
Sort by column → Kuu nr
```

### Probleem: kvartalid on vales järjekorras

Lahendus:

```text
Aasta-kvartal
Sort by column → Aasta-kvartal sort
```

### Probleem: KPI ei muutu slicer’i järgi

Kontrolli:

- kas slicer kasutab õiget dimensioonivälja;
- kas tabelite vahel on aktiivne seos;
- kas `Edit interactions` on `Filter`;
- kas mõõdik eemaldab filtrit `ALL` või muu funktsiooniga;
- kas slicer ja mõõdik kasutavad sama kuupäevaloogikat.

### Probleem: võrdlusaasta kaob perioodifiltriga

Põhjus võib olla, et slicer filtreerib mõlemad aastamõõdikud samasse perioodi.

Lahendus sõltub mõõdiku loogikast:

- kasuta selgelt fikseeritud aastamõõdikuid;
- kontrolli `CALCULATE` filtreid;
- testi, kas valitud slicer peab üldse võrdluskaarti mõjutama;
- vajaduse korral seadista interaktsioon `None`.

### Probleem: värvub vale Card-väärtus

Kontrolli:

```text
Format visual
→ Visual
→ Callout
→ Apply settings to
```

Vali õige põhimeasure.

### Probleem: `fx` nuppu ei ole

Kontrolli, et:

- Card on valitud;
- avatud on õige vormindusjaotis;
- muudad `Callout → Value → Color` seadistust;
- kasutatav Card-versioon toetab seda seadistust.

### Probleem: värv ei muutu filtri järgi

Kontrolli, et värvimeasure kasutab sama põhimeasure’it ja reageerib samale filtrikontekstile.

### Probleem: diagramm on liiga kirju

Vähenda:

- seeriate arvu;
- värvide arvu;
- andmesilte;
- ruudustikujooni;
- dekoratiivseid elemente.

Rõhuta ainult põhiseeriat.

### Probleem: võrdlusaasta tõmbab liiga palju tähelepanu

Kasuta varasema aasta jaoks neutraalset halli ning uuema aasta jaoks aktsentvärvi.

### Probleem: Top 5 tootenimed on kärbitud

Võimalused:

- kasuta horisontaalset ribadiagrammi;
- suurenda visuaali;
- vähenda fondi mõõdukalt;
- kasuta tooltip’i;
- dokumentatsioonis ära kirjuta kärbitud nime oletuse põhjal täielikuks.

### Probleem: Top 5 muutub drill-up järel ebaselgeks

Täpsusta pealkirjas kuvatav tase ning kontrolli Top N filtrikonteksti.

### Probleem: staatiline narratiiv ei muutu filtriga

See on tekstikasti tavapärane piirang.

Lahendus:

- märgi narratiivi ulatus;
- salvesta sobiv vaikefilter;
- kasuta dünaamilist tekstimõõdikut;
- kasuta bookmark’e eri vaadete jaoks.

### Probleem: slicer filtreerib vale visuaali

Kasuta:

```text
Format → Edit interactions
```

Määra iga visuaali jaoks `Filter`, `Highlight` või `None`.

### Probleem: väärtused ei ühti SQL-iga

Kontrolli:

- filtreid;
- suhteid;
- kuupäevavahemikku;
- `COUNT` vs `DISTINCTCOUNT`;
- tühje väärtusi;
- duplikaate;
- kasutatud mõõdiku filtrikonteksti;
- kas võrdled sama küsimuse vastuseid.

Õige number võib olla küsimuse kontekstis vale, kui SQL ja Power BI mõõdavad eri asja.

### Probleem: linn puudub või on tühi

Ära filtreeri seda automaatselt välja. Mõõda mõju ja dokumenteeri andmekvaliteedi piirang.

### Probleem: PBIX ei avane VS Code’is

See on normaalne. PBIX on binaarfail ja tuleb avada Power BI Desktopis.

### Probleem: Power BI jooksis kokku

Kasuta varukoopiat või kontrollitud taastamisfaili. Ära kirjuta viimast töötavat faili kontrollimata taastamisversiooniga üle.

### Probleem: avalik link ei tööta

Kontrolli:

- kas raport on avaldatud;
- kas workspace ja õigused on õiged;
- kas link nõuab organisatsioonikontot;
- kas testisid incognito-aknas;
- kas `Publish to web` on organisatsioonis lubatud.

Ära lisa portfooliosse kontrollimata linki.

### Probleem: punased õigekirjajooned on kuvatõmmisel

Need on Windowsi või rakenduse õigekirjakontrolli märgid, mitte Power BI andmeviga.

Enne kuvatõmmist eemalda või lülita õigekirja esiletõstmine välja ning kontrolli pilt uuesti.

---

## 30. Kvaliteedikontroll enne salvestamist

### Äriküsimus

- [ ] Kas dashboard vastab ühele selgele põhiküsimusele?
- [ ] Kas sihtrühm on teada?
- [ ] Kas iga visuaal toetab otsust?

### Andmed ja mudel

- [ ] Andmetüübid on õiged.
- [ ] Võtmeväljad ja seosed on kontrollitud.
- [ ] Calendar-tabel on seotud õige kuupäevaga.
- [ ] Kuud ja kvartalid on õigesti sorditud.
- [ ] Tühjade väärtuste mõju on teada.

### Mõõdikud

- [ ] Aastasummad on kontrollitud.
- [ ] Kasvuprotsendid ühtivad kontrollarvutusega.
- [ ] `COUNT` ja `DISTINCTCOUNT` valik on põhjendatud.
- [ ] Keskmised lepivad kokku lugeja ja nimetajaga.
- [ ] Mõõdikuid on testitud filtrikontekstis.

### Visuaalid

- [ ] Diagrammitüüp sobib küsimusega.
- [ ] Pealkirjad on selged.
- [ ] Põhiseeria on rõhutatud.
- [ ] Võrdlusseeria on neutraalsem.
- [ ] Värv ei ole ainus eristusviis.
- [ ] Dashboard mahub ühele ekraanile.
- [ ] Andmesildid ei tekita müra.

### Interaktiivsus

- [ ] Slicer’id mõjutavad õigeid visuaale.
- [ ] `Edit interactions` on testitud.
- [ ] Top N muutub ootuspäraselt.
- [ ] Drill-down ja drill-up toimivad.
- [ ] Staatiline narratiiv ei eksita filtrivaliku järel.

### Andmelugu

- [ ] Annotatsioonid põhinevad kontrollitud andmetel.
- [ ] Viitejooned kasutavad tegelikku võrdlusväärtust.
- [ ] Narratiiv vastab „Ja mis siis?” küsimusele.
- [ ] Põhjuseid ei ole välja mõeldud.
- [ ] Tegevussoovitus on andmetest loogiliselt tuletatud.

### Portfoolio

- [ ] PBIX on viimase kontrollitud versiooniga.
- [ ] Kuvatõmmis vastab PBIX-ile.
- [ ] README on lühike.
- [ ] Detailne analüüs on `analysis.md` failis.
- [ ] Individuaalne ja grupitöö on eristatud.
- [ ] AI kasutamine on kirjeldatud.
- [ ] Avalik link on kontrollitud või ausalt märgitud puuduvaks.

---

## 31. Kiirmeelespea

```text
1. Sõnasta kasutaja ja äriküsimus.
2. Kontrolli andmed enne visuaale.
3. Loo selge mudel ja Calendar-tabel.
4. Koosta mõõdikud, mitte ainult arvutuslikud veerud.
5. Kontrolli tulemusi tabelivaates.
6. Vali diagramm küsimuse, mitte välimuse järgi.
7. Hoia KPI-d üleval ja põhitrend keskmes.
8. Kasuta 3–4 olulist filtrit, ülejäänud peida detailvaatesse.
9. Testi Edit interactions, Top N ja drill-down.
10. Kasuta värvi koos markerite, noolte ja siltidega.
11. Lisa annotatsioonid ainult kontrollitud faktidele.
12. Kirjuta lühike „Tulemus – Kõikumine – Tegevus” narratiiv.
13. Salvesta varukoopia ja kontrolli PBIX enne repo faili asendamist.
14. Uuenda kuvatõmmis, README ja analysis.md.
15. Ära avalda tundlikke andmeid ega kontrollimata linki.
```

---

## 32. Juhendi alus

Juhend on koostatud järgmiste koolitusmaterjalide ja praktiliste tööde põhjal:

- DACA Nädal 5 „Visualiseerimise disain”;
- DACA Nädal 5 Power BI ja Supabase’i seadistusmaterjalid;
- DACA Nädal 6 „Visualiseerimise andmed”;
- „Power BI viimistlemine ja avaldamine — professionaalne dashboard”;
- Card-visuaali tingimusliku värvimise praktiline juhend;
- UrbanStyle Week 5 CEO dashboard’i detailanalüüs;
- UrbanStyle Week 6 Tartu kaupluse dashboard’i detailanalüüs;
- juhendaja tagasiside filtrite paigutuse ja võrdlusaasta visuaalse hierarhia kohta.

Juhendi näited kasutavad koolitusel ja minu dashboard’ides tegelikult rakendatud välju, mõõdikuid, probleeme ja lahendusi. Power BI versiooni- või litsentsipõhised menüüerinevused tuleb vajaduse korral kontrollida kasutatavas rakenduses.

