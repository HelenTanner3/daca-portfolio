# Nädal 9 — karjääri ettevalmistuse analüüs

## 1. Eesmärk

Nädal 9 erines varasematest tehnilistest nädalatest: keskmes ei olnud uue SQL-, Python- või Power BI lahenduse ehitamine, vaid juba omandatud oskuste tõendamine ja esitamine tööandjale arusaadavas vormis.

Töö jagunes kaheks:
1. individuaalsed karjäärimaterjalid — CV, LinkedIn ja portfoolio;
2. grupitöö — UrbanStyle'i värbamisjuhend tööandja vaatepunktist.

Minu eesmärk oli hoida need kaks vaadet omavahel kooskõlas: CV ja LinkedIn peavad näitama samu omadusi, mida me ise tööandja rollis tugevaks kandidaadiks pidasime.

## 2. Individuaalne CV

Koostasin Nädal 9 jaoks ühe lehekülje ingliskeelse ja ATS-sõbraliku CV versiooni. Selle eesmärk ei olnud asendada kõiki tulevasi kandideerimis-CV-sid, vaid luua kursuse artefakt, mis seob varasema professionaalse kogemuse uute andmeanalüüsi oskustega.

CV-s kasutasin DACA projekte tõenditena, mitte lihtsalt oskuste loeteluna. Näiteks:
- RFM-analüüs näitab Pythoni/pandas'e, segmentatsiooni ja tulemuste tõlgendamise oskust;
- Power BI dashboard näitab KPI-analüüsi, visualiseerimist ja juhtimisinfo esitamist;
- Python/API töövoog näitab andmete laadimise, pipeline'i ja kontrollpunktide mõistmist.

Kvantifitseeritud tulemused pärinevad varasemate nädalate kontrollitud artefaktidest. Detailsemad tõendid on vastavates nädala kaustades:
- [Nädal 6 — Power BI](../week-6/)
- [Nädal 7 — RFM analüüs](../week-7/)
- [Nädal 8 — Python ja API](../week-8/)

## 3. LinkedIn ja projektide valik

LinkedIni puhul oli oluline eristada kogu portfooliot ja esiletõstetud projekte.

Järeldus oli, et Featured-sektsiooni ei ole vaja koondada kõiki tehtud töid. Projekt tuleks valida selle järgi, **millist kompetentsi soovin tõendada**:

- SQL ja andmekvaliteet → SQL/JOIN või puhastamise projekt;
- Python ja kliendianalüüs → RFM;
- Power BI ja juhtimisinfo → Tartu dashboard;
- API ja automatiseerimine → Nädal 8 pipeline.

See muudab profiili tööandja jaoks kiiremini loetavaks ning loob selgema seose oskuse ja tõendi vahel.

## 4. Grupitöö — Meeskond 3, peatükk 3

Grupitöö teemaks oli **„Kuidas lugeda DA CV-d ja LinkedIn profiili“**.

Minu ametlik roll oli **Roll A — Palkamisjuhi vaade (HR / Hiring Manager)**. Minu osa keskendus sellele:
- mida palkamisjuht CV-s esimesena vaatab;
- mis teeb DA CV tugevaks;
- millised LinkedIni projektid on esiletõstmist väärt;
- millised on 3 rohelist ja 2 punast lippu;
- mida esmase sõelumise ajal mitte üle tähtsustada.

Põhiartefakt:
- [week9_role_a_cv_linkedin_screening.md](week9_role_a_cv_linkedin_screening.md)

Grupirepo:
- [minu individuaalne töö](https://github.com/Kolju3/DACA-group/tree/main/week-9/individual/helen)
- [meeskonna ühine töö](https://github.com/Kolju3/DACA-group/tree/main/week-9/group)

## 5. DACA kogemuse mõju hindamiskriteeriumidele

Esimese kaheksa nädala praktiline töö muutis tööandja vaate konkreetsemaks.

### Töötav lahendus ei tähenda veel õiget tulemust

SQL-i, JOIN-ide ja Python/API töödes tuli korduvalt kontrollida ridade arvu, võtmeid, filtreid, ühendamise mõju ja vahetulemusi. Sellest kujunes hindamiskriteerium: tugev kandidaat ei näita ainult tulemust, vaid ka seda, **kuidas tulemust kontrolliti**.

### Andmekvaliteet vajab ärikonteksti

Andmete puhastamisel ei olnud iga anomaalia automaatselt viga. Mõnel juhul oli vaja mõista ärireeglit või saada protsessiomaniku kinnitus. Seetõttu on tugev märk oskus eristada tehnilist anomaaliat ja ärilist erandit.

### Analüüs peab vastama küsimusele „ja mis siis?“

Power BI ja RFM töödes oli oluline mitte piirduda numbritega. Analüütik peab suutma selgitada, mida tulemus tähendab ja millist otsust või järgmist tegevust see toetab.

### Piirangute aus kirjeldamine on tugevus

RFM-analüüs näitas, et segment või mõõdik on meetodi ja eelduste tulemus. Hea analüütik ei esita mudeli väljundit absoluutse tõena, vaid oskab kirjeldada ka piiranguid.

### Meeskonnatöö peab olema nähtav

Rollipõhistes grupitöödes sõltus järgmine etapp eelneva rolli väljundist. Seetõttu on oluline, et kandidaat oskaks kirjeldada:
- enda vastutust;
- meeskonna ühist tulemust;
- sisendit ja väljundit;
- kontrollpunkte;
- probleemi eskaleerimist või abi küsimist.

## 6. Peamised õppetunnid

Nädal 9 aitas vaadata varasemaid tehnilisi töid uue nurga alt. Tööandja jaoks on tugevamad projektid need, kus on korraga nähtavad:

**äriküsimus → kasutatud oskus → tõend → kontroll → tulemus → äriline tähendus**

See tähendab ka, et portfoolios ei ole vaja näidata kõike võrdselt. Olulisem on valida iga rolli või kandideerimise jaoks need projektid, mis tõendavad kõige paremini vajalikke kompetentse.

## 7. Piirangud ja järgmised sammud

- CV on Nädal 9 kursuseartefakt ja seda tuleb konkreetse töökoha puhul kohandada.
- LinkedIn on elav väline profiil ning võib pärast Nädal 9 lõppu edasi muutuda.
- Grupirepo ühine peatükk võib veel sessiooni järel täieneda; README-s olev link viitab püsivale meeskonna kaustale.
- Nädal 10 portfoolio esitlusel saab kasutada siinse analüüsi põhisõnumit ja valitud projekte.

## 8. AI kasutamine

Kasutasin AI-d abivahendina, et oma mõtteid struktureerida, võrrelda neid Nädal 9 juhendi nõuetega ning sõnastada kriteeriumid selgelt ja kompaktselt.
