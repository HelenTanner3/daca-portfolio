# Nädal 10: Portfoolio esitlus

## Eesmärk

Week 10 eesmärk oli koondada 10 nädala DACA töö professionaalseks tervikuks: korrastada portfoolio, valida tugevaimad tõendid ning valmistada ette 7-minutiline Operations Intelligence meeskonna lõppesitlus.

Selle nädala põhiartefakt on **lõppesitlus ja korrastatud portfoolio**. Eraldi `analysis.md` faili ma Week 10 jaoks ei loo — vajalik kontekst, minu panus, tõendid ja reflektsioon on koondatud siia README-sse.

## Minu panus

### Portfoolio korrastamine

Korrastasin oma DACA repo teemade kaupa, et portfoolio oleks kiiremini loetav ja tugevamad tööd lihtsamini leitavad:

- `00-setup`
- `01-sql`
- `02-power-bi`
- `03-python`
- `04-career`
- `05-portfolio-presentation`

Week 10 töö fookus ei olnud uue analüüsi loomisel, vaid olemasolevate tööde **valikul, valideerimisel, tõendamisel ja esitluslooks ühendamisel**.

### Andmepõhine leid — varude tasakaal

Lõppesitlusse valisin enda Week 3 süvendatud inventuurianalüüsist:

- **221** reorder-risk / juurdetellimise kontrollpositsiooni;
- **730** ebatavaliselt kõrge laoseisu kontrollpositsiooni.

Oluline piirang: 730 ei ole tõestatud ülevaru, sest `reorder_point` on juurdetellimise käivituspunkt, mitte maksimaalne optimaalne laotase.

**Äriline tähendus:** varu võib olla ebaühtlaselt jaotunud — ühes kohas tekib saadavusrisk, samal ajal kui mujal on laoseis ebaproportsionaalselt kõrge.

[CASE ↗ Week 3 — SQL / inventory](https://github.com/HelenTanner3/daca-portfolio/tree/main/01-sql/week-3)

### Strongest work — Tartu Power BI

Minu peamine visualiseerimise tõend lõppesitluses oli Week 6 Tartu Power BI dashboard.

2024 vs 2023:

- müügitulu ~**260 044 €**
- müügitulu **+13,4%**
- tellimuste arv **+16,5%**
- keskmine tellimuse väärtus (AOV) **−2,6%**

**Põhijäreldus:** Tartu kasv tuli suuremast tellimuste arvust, mitte suuremast keskmisest ostukorvist.

See oli minu jaoks hea näide sellest, miks kasvu kvaliteeti ei saa hinnata ainult kogukäibe järgi ning miks muutust ei tohi automaatselt käsitleda põhjusliku seosena.

[CASE ↗ Week 6 — Power BI](https://github.com/HelenTanner3/daca-portfolio/tree/main/02-power-bi/week-6)

## Panus ühisesse lõppesitlusse

Operations Intelligence lõppesitlus järgis ametlikku 7-minutilist struktuuri:

1. sissejuhatus;
2. andmete ülevaade;
3. visualiseeringud;
4. kolm juhtimissoovitust;
5. AI kasutamine.

Minu põhiroll oli:
- esitada varude tasakaalu leid;
- näidata ja tõlgendada Tartu Power BI dashboard'i;
- aidata kontrollida kasutatavate arvude, allikate, autorluse ja piirangute tõendatavust;
- valmistada ette Q&A tõendusmaterjali.

[Team repository ↗ DACA-group](https://github.com/Kolju3/DACA-group)

## Q&A tõendamine

Lõppesitluse juurde koostati lisaslaidid, mis võimaldavad küsimuse korral minna põhitulemusest kiiresti tagasi:
- metoodika;
- kontrollarvude;
- piirangute;
- GitHubi allika juurde.

Minu Week 7 RFM-analüüs jäi Q&A tõendusketti taustaks, et vajadusel selgitada segmentide moodustamist ja kliendiväärtuse kontsentratsiooni.

[CASE ↗ Week 7 — Python / RFM](https://github.com/HelenTanner3/daca-portfolio/tree/main/03-python/week-7)

## AI kasutamine

Kasutasin AI-d Week 10-s eelkõige:
- esitlusloo ja ajastuse struktureerimiseks;
- eri nädalate tulemuste ja tõendusallikate võrdlemiseks;
- numbrite, autorluse ja piirangute kontrollküsimuste sõnastamiseks;
- slaiditeksti ja Q&A materjali viimistlemiseks;
- erinevate esitluskujunduste katsetamiseks.

AI ei asendanud tulemuste valideerimist. Lõplikud numbrid, allikad, caveat'id ja ärilised järeldused kontrollisin olemasolevate analüüside ning GitHubi artefaktide vastu.

## Õpitu

Week 10 suurim väärtus oli kogu õpiteekonna vaatamine ühe tervikuna.

10 nädala jooksul liikus töö:

**keskkonna seadistamisest → SQL-analüüsini → Power BI visualiseerimiseni → Python/API töövoogudeni → tõendatava portfoolio ja juhtimistaseme esitluseni.**

Kõige olulisem õppetund oli, et professionaalne analüüs ei lõpe töötava päringu, notebook'i või dashboard'iga. Tulemus peab olema:
- kontrollitud;
- õigesti tõlgendatud;
- piirangutega aus;
- kiiresti tõendatav;
- otsustaja jaoks tähenduslik.

## Artefaktid

- Week 10 README — käesolev fail
- Operations Intelligence lõpuesitlus (`.pptx` / `.pdf`)
- Q&A tõendusslaidid lõppesitluse osana

