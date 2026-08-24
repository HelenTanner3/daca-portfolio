# Nädal 5: Power BI dashboard’id — detailne analüüs

## 1. Töö ulatus

Nädala ametlik individuaalne ülesanne oli **Roll A — CEO Dashboard**, mille eesmärk oli vastata UrbanStyle’i tegevjuhi põhiküsimusele:

> **Kas UrbanStyle kasvab?**

Pärast ametliku töö valmimist läbitöötasin enesearendusena ka **Roll B — Marketing Dashboardi**. Täienduse eesmärk oli harjutada kuupäevamudelit, kliendihankimise mõõtmist, filtrikonteksti ja eri juhtimistasemele sobivate vaadete eristamist.

Grupi reposse jääb esialgne Roll A lahendus. Isiklikus portfoolios olev PBIX sisaldab uuendatud Roll A vaadet ning täiendavat Roll B analüüsi.

## 2. Kasutatud andmed ja mudel

Power BI-s kasutati Supabase’i PostgreSQL andmebaasist imporditud tabeleid, sealhulgas:

- `public sales`
- `public customers`
- `public products`
- `public inventory`
- `public inventory_movements`
- `public web_logs`

Roll A põhianalüüs kasutab peamiselt müügi- ja klienditabelit.

Põhiseos:

```text
public customers[customer_id]  1 ─── *  public sales[customer_id]
```

Ajapõhise analüüsi jaoks lisasin eraldi `Calendar`-tabeli.

Kuupäevaseosed:

```text
Calendar[Date]  1 ─── *  public sales[sale_date]
```

See seos on aktiivne ja seda kasutatakse müügitulu ajaliseks filtreerimiseks.

```text
Calendar[Date]  1 - - *  public customers[Esimese ostu päev]
```

See seos on mitteaktiivne ning aktiveeritakse uute ostnud klientide mõõdikus funktsiooniga `USERELATIONSHIP`.

## 3. Olulisemad DAX-mõõdikud

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

### Ostnud kliendid

```DAX
Ostnud kliendid =
CALCULATE(
    DISTINCTCOUNT('public sales'[customer_id]),
    'public sales'[customer_id] <> BLANK()
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

### Müügitulu ostnud kliendi kohta

```DAX
Müügitulu ostnud kliendi kohta =
DIVIDE(
    [Müügitulu],
    [Ostnud kliendid]
)
```

## 4. Esimese ostu ja uute klientide loogika

Kliendi esimese ostu kuupäev arvutatakse klienditabelis seotud müügitehingute põhjal.

### Esimese ostu kuupäev

```DAX
Esimese ostu kuupäev =
MINX(
    RELATEDTABLE('public sales'),
    'public sales'[sale_date]
)
```

### Esimese ostu päev

```DAX
Esimese ostu päev =
VAR EsimeneOst =
    'public customers'[Esimese ostu kuupäev]
RETURN
    IF(
        NOT ISBLANK(EsimeneOst),
        DATE(
            YEAR(EsimeneOst),
            MONTH(EsimeneOst),
            DAY(EsimeneOst)
        )
    )
```

### Uued ostnud kliendid

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

Mõõdik välistab kliendid, kellel ost puudub. Tõlgendamisel tuleb arvestada, et „uus klient” tähendab esimest ostu olemasolevas andmestikus. Kui klient ostis enne andmestiku alguskuupäeva, ei ole seda võimalik selle mudeli põhjal tuvastada.

## 5. Roll A — CEO Dashboard

### Põhitulemused

| Näitaja | Tulemus |
|---|---:|
| Müügitulu 2023 | 1 234 758,90 € |
| Müügitulu 2024 | 1 470 358,02 € |
| Müügitulu suurenemine | 235 599,12 € |
| Käibe kasv 2024 vs 2023 | 19,1% |
| Ostnud kliendid 2024 | 2 113 |

UrbanStyle’i 2024. aasta müügitulu kasvas 2023. aastaga võrreldes 235 599,12 euro võrra. Müügitulu oli 2024. aastal kõrgem kõigil kuudel.

### Linnade võrdlus

Enamik linnu kasvas. Aasta kokkuvõttes jäi ainult Valga veidi 2023. aasta tasemele alla.

Tühja linnaväärtust ei filtreeritud välja, sest sellega seotud müük moodustas olulise osa kogukäibest. Seda ei tõlgendatud automaatselt online-müügina, kuna tühja väärtuse äriline tähendus vajab eraldi andmekvaliteedi kontrolli.

### Disainiotsused

- KPI-kaardid paiknevad vaate ülaosas.
- Peamine visuaal võrdleb 2023. ja 2024. aasta müügitulu kuude lõikes.
- 2024\. aasta on rõhutatud teal-tooniga ning 2023. aasta on neutraalne võrdlusbaas.
- Telgede ja joonte skaalad on seadistatud nii, et trendi ei võimendataks eksitavalt.
- Värv ei ole ainus eristusviis: aastad on tähistatud ka teksti, joone stiili või legendiga.
- Linnaslicer võimaldab kontrollida piirkondlikke erinevusi.

## 6. Roll B — Marketing Dashboard

Roll B põhivaade vastab kahele küsimusele:

1. milline müügikanal annab rohkem müügitulu;
2. kuidas muutub uute ostnud klientide arv ajas.

Põhivaates kasutatakse:

- müügitulu kanalite lõikes;
- uusi ostnud kliente kvartalite lõikes;
- KPI-kaarte;
- perioodi, linna ja lojaalsustaseme filtreid.

Eraldi detailvaates võrreldakse kvartalite lõikes ostnud klientide arvu ja müügitulu. See aitab hinnata, kas müügitulu muutus seostub eelkõige klientide arvu või ühe kliendi kohta teenitud tuluga.

### Kanalite tõlgendamise piirang

`web_logs[source_clean]` ei sobi müügitulu otseseks jaotamiseks turundusallika järgi, sest veebilogide ja müügitehingute vahel puudub üheselt määratud seansi- või tehingupõhine omistamise võti. Sama kliendi müügitulu sidumine mitme allikaga põhjustaks topeltarvestuse.

Seetõttu kasutatakse müügitulu kanalivaates müügitabeli `channel` välja. Tegelikku turunduse efektiivsust või ROI-d ei saa hinnata ilma kampaaniakulude ja kokkulepitud omistamisloogikata.

## 7. Kalender ja sortimine

`Calendar`-tabel sisaldab muu hulgas:

- aastat;
- kvartalit;
- kuud;
- aasta-kuud;
- aasta-kvartalit;
- numbrilisi sortimisvälju.

Kvartalite kronoloogilise järjestuse tagamiseks kasutatakse:

```text
Calendar[Aasta-kvartal]
Sort by column → Calendar[Aasta-kvartal sort]
```

Kuude puhul kasutatakse:

```text
Calendar[Kuu lühike]
Sort by column → Calendar[Kuu nr]
```

Aja telgedel kasutatakse `Calendar`-tabeli välju, mitte Power BI automaatset `sale_date` kuupäevahierarhiat.

## 8. Interaktiivsus ja kontroll

Dashboard’ide filtrid võimaldavad analüüsida tulemusi:

- aasta ja kvartali;
- linna;
- lojaalsustaseme järgi.

Kontrollisin mõõdikuid Power BI tabelivaadetes ja võrdlesin neid teadaolevate koondväärtustega. Eraldi kontrollisin:

- 2023\. ja 2024. aasta müügitulu;
- ostnud klientide arvu;
- määramata linnaga müüki;
- uute ostnud klientide välistamist ostuta klientidest;
- kvartalite ja kuude sortimist;
- filtrite mõju KPI-dele ja diagrammidele.

## 9. Õppimiskohad

Täiendava Roll B läbitöötamise peamised õppimiskohad olid:

- ühise kuupäevatabeli loomine;
- aktiivse ja mitteaktiivse kuupäevaseose erinevus;
- `USERELATIONSHIP` kasutamine;
- esimese ostu põhise kliendihankimise mõõdiku loomine;
- ajaväljade õige sortimine;
- filtrikonteksti mõju eri mõõdikutele;
- juhtimisvaate ja detailvaate eristamine;
- vigase taastamisfaili asemel viimase tervikliku PBIX-i kasutamine.

Power BI kokkujooksmise järel selgus ka varundamise praktiline tähtsus. Tööversioonid eraldati ajalooliseks esitatud versiooniks, edasiarendatud õppeversiooniks ja varukoopiaks.

## 10. AI kasutamine

Kasutasin AI-d:

- DAX-mõõdikute koostamise ja kontrollimise toetamiseks;
- andmemudeli ning kuupäevaseoste veaotsinguks;
- visuaalide paigutuse ja värvikasutuse hindamiseks;
- taastamisfailide võrdlemise ja töö taastamise kavandamiseks;
- analüüsi ning äritõlgenduste sõnastamiseks.

Kõik lõplikud mõõdikud, filtrid, visuaalid ja järeldused kontrollisin Power BI-s.
