# Nädal 4 — presentatsiooni alus

## Teema

**Turunduskanalite efektiivsus: kuidas vältida vale käivet ja jõuda valideeritud juhtimisinfoni**

Roll D: turunduskanalite analüüs  
Autor: Helen Tanner  
Keskkond: Supabase / PostgreSQL

---

## Slaid 1 — Äriküsimus ja andmed

### Pealkiri

**Millised turunduskanalid toovad müüki?**

### Slaidile

- 50 000 veebilogirida
- 10 118 müügitehingut
- 2,91 mln € müügitulu
- 10 standardiseeritud kanalit
- KPI-d: kliendid, tellimused, käive, keskmine tellimus ja müük kliendi kohta

### Kõnealus

Analüüsi eesmärk oli hinnata, millised turunduskanalid seostuvad suurima kliendiarvu, tellimuste ja käibega. Tegelikku ROI-d ei saanud arvutada, sest kampaaniate kulud puudusid. Seetõttu räägin kanalite efektiivsusest, mitte investeeringu tasuvusest.

### Visuaal

Neli KPI-kaarti: **50 000 logi**, **10 118 tehingut**, **2,91 mln €**, **10 kanalit**.

---

## Slaid 2 — Andmekvaliteedi probleem

### Pealkiri

**Enne analüüsi tuli kanalid puhastada**

### Slaidile

- 19 erinevat `source` väärtust
- pärast standardiseerimist 10 kanalit
- sama kanal esines eri kirjapiltide ja lühenditena
- algne `source` säilitati, analüüsiks loodi `source_clean`

| Enne | Pärast |
|---|---|
| `Facebook`, `FB` | `facebook` |
| `Facebook Ads`, `facebook_ads`, `fb_ads` | `facebook_ads` |
| `Google Organic`, `google organic`, `google_organic` | `google_organic` |
| `IG`, `instagram`, `Instagram` | `instagram` |

### Kõnealus

Ilma puhastamiseta oleks sama kanal olnud aruandes mitme eraldi reana. Tasuline ja orgaaniline või täpsustamata liiklus jäeti teadlikult eraldi. Puhastus kontrolliti esmalt testtabelis ja alles siis production-tabelis.

### Visuaal

`19 algväärtust → source_clean → 10 standardkanalit`

---

## Slaid 3 — Kõige olulisem valideerimine

### Pealkiri

**Otsene JOIN andis 34,53 miljonit eurot — tegelik käive oli 2,91 miljonit**

### Slaidile

| Kontroll | Algne `sales` | Otsene JOIN |
|---|---:|---:|
| Ridu | 10 118 | 121 131 |
| Unikaalseid müüke | 10 118 | 9 130 |
| Käive | 2,91 mln € | 34,53 mln € |

- käive 11,87 korda üle hinnatud
- 988 müüki jäi JOIN-ist välja
- korduvad veebilogid mitmekordistasid säilinud müüke

### Kõnealus

Päring töötas tehniliselt, kuid tulemus oli vale. Ühel kliendil oli mitu veebilogirida, mistõttu sama müük kordus. Samal ajal eemaldas `INNER JOIN customers` müügid, millel puudus sobiv kliendikirje. See näitab, miks tuleb alati võrrelda tulemust teadaoleva referentsväärtusega.

### Visuaal

Kõrvuti **2,91 mln € — kontrollväärtus** ja **34,53 mln € — vale JOIN-i tulemus**.

---

## Slaid 4 — Valideeritud kanalitulemused

### Pealkiri

**Suurima müügimahuga kanal oli google_organic**

### Slaidile

| Kanal | Käive | Tellimusi | Põhinäitaja |
|---|---:|---:|---|
| `google_organic` | 666 444,98 € | 2 273 | 22,91% kogukäibest |
| `facebook_ads` | 469 933,25 € | 1 635 | 1 338,84 € kliendi kohta |
| `direct` | 420 103,22 € | 1 505 | 14,44% kogukäibest |
| `email_campaign` | 300 296,85 € | 1 024 | AOV 293,26 € |
| `instagram` | 262 112,79 € | 877 | suurim AOV 298,87 € |

- kolm suurimat kanalit andsid 53,5% käibest;
- `unknown` moodustas 13,17% käibest ja vajab eraldi uurimist.

### Kõnealus

Google organic oli suurima mahu kanal nii tellimuste kui ka käibe järgi. Facebook Ads oli tuvastatud kanalitest suurima müügiga kliendi kohta. Instagrami keskmine tellimus oli kõige suurem. Neid ei saa nimetada parima ROI-ga kanaliteks, sest kulusid ei ole.

### Visuaal

Horisontaalne tulpdiagramm valideeritud käibest. `unknown` kuvada eraldi hoiatusgrupina.

---

## Slaid 5 — Trend, piirang ja soovitus

### Pealkiri

**2024 kasvas, kuid järgmine samm on tehingupõhine atribuutika**

### Slaidile

- 2024 käive vs 2023: **+19,08%**
- 2024 tellimused vs 2023: **+20,19%**
- tippkuu: **12.2024 — 170 623,28 €**
- `web_logs` lõpeb 28.02.2025
- praegune reegel: kliendi viimane teadaolev kanal
- kampaaniakulud puuduvad

### Soovitused

1. siduda müük sessiooni või kampaania ID-ga;
2. lisada kampaaniakulud ja marginaal;
3. uurida `unknown` grupi 383 127,19 euro suurust käivet;
4. säilitada `source_clean` standardiseerimisreeglid;
5. kontrollida JOIN-i alati müügi kontrollsummaga.

### Kõnealus

2024 oli 2023. aastast ligikaudu viiendiku võrra suurem nii tellimuste kui ka käibe järgi. Analüüsi suurim piirang on see, et kanal omistati kliendi viimase teadaoleva veebikanali järgi. Järgmine samm on siduda kanal konkreetse tellimusega ning lisada kampaaniakulud, et arvutada tegelik ROI või ROAS.

---

## Juhtkonna viis põhinumbrit

1. **50 000** veebilogirida, millest **18,83%** on anonüümsed.
2. **19 → 10**: algsed kanaliväärtused standardiseeriti kümneks kanaliks.
3. Otsene JOIN andis **34,53 mln €**, kuigi tegelik käive oli **2,91 mln €**.
4. `google_organic`: **666 444,98 € käivet**, **2 273 tellimust**, **22,91% kogukäibest**.
5. 2024. aasta käive kasvas 2023. aastaga võrreldes **19,08%**.

## Sõnastus, mida kasutada

- „suurima valideeritud käibega kanal”
- „suurima müügiga kliendi kohta tuvastatud kanal”
- „kanaliga seotud käive”
- „viimane teadaolev kliendikanal”
- „kanalite efektiivsus”

## Sõnastus, mida vältida

- „parim ROI”, sest kulud puuduvad
- „kanal põhjustas müügi”, sest põhjuslikku seost ei ole tõendatud
- „konversioonimäär”, sest külastusi ja tehinguid ei seota sama sessiooni või kampaania alusel
- `unknown` käsitlemine päris turunduskanalina
- otsese JOIN-i koondnumbrite kasutamine juhtimisinfona

## Küsimustele vastamise tugi

**Miks ei kasutatud otsese JOIN-i tulemust?**  
Ühel kliendil oli mitu veebilogirida. Seetõttu kordus sama müük iga sobiva logirea kohta ja kogukäive mitmekordistus.

**Miks kasutati `ROW_NUMBER()` funktsiooni?**  
See võimaldas valida iga kliendi kohta ühe viimase teadaoleva kanalirea ning vältida müükide kordistumist.

**Kas `facebook_ads` oli parim kanal?**  
See oli tuvastatud kanalitest suurima müügiga kliendi kohta, kuid parimat ROI-d ei saa ilma kampaaniakuludeta määrata.

**Miks on `unknown` grupi müük kliendi kohta väga suur?**  
Selles grupis sisaldub ka müüke, mille `customer_id` on NULL. Käive läheb lugejasse, kuid NULL kliendid ei lähe `COUNT(DISTINCT customer_id)` nimetajasse.

**Kas kuiste kanalite summa võrdub kogu müügiga?**  
Mitte täielikult. `HAVING` piir jättis trenditabelist välja 166 tellimust ja 50 121,50 eurot käivet.

## Soovitatavad kuvatõmmised

1. `LISAPÄRING 2 — WEB_LOGS ANDMEKVALITEEDI ÜLEVAADE.png`
2. `LISAPÄRING 3 — STANDARDISEERITUD KANALITE LIIKLUS.png`
3. `LISAPÄRING 5A — SALES KONTROLLNUMBER ENNE JOIN-I.png`
4. `LISAPÄRING 5B — OTSESE KOLME TABELI JOIN-I KONTROLL.png`
5. `LISAPÄRING 6 — VALIDEERITUD KANALITE KOOND.png`
6. `LISAPÄRING 7 — VALIDEERITUD KANALI EFEKTIIVSUS CTE ABIL.png`
7. `LISAPÄRING 8 — VALIDEERITUD KUISED TRENDID.csv`
8. `LISAPÄRING 10 — ROLL A RISTKONTROLL KUUD KAUPA.csv`

## Ühe lause lõppjäreldus

**Usaldusväärse turundusanalüüsi eelduseks ei olnud ainult agregaatide arvutamine, vaid kanalite standardiseerimine ja JOIN-i kontrollimine müügi referentsväärtuste vastu.**
