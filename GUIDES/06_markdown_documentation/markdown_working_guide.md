# Markdowni praktiline tööjuhend

See juhend koondab Markdowni kasutamise viisid, mida olen kasutanud GitHubi portfoolio `README.md`, `analysis.md` ja tehniliste juhendite koostamisel.

Eesmärk on, et dokument:

- oleks GitHubis hästi loetav;
- kasutaks toimivaid suhtelisi linke;
- eristaks lühikest README-d ja põhjalikku analüüsi;
- ei sisaldaks kohalikke failiteid ega ajutisi märkusi;
- kirjeldaks tegelikult tehtud tööd ja kontrollitud tulemusi.

## 1. Markdowni faili vaatamine VS Code’is

Markdowni faililaiend on:

```text
.md
```

Näited:

```text
README.md
analysis.md
git_basic_workflow.md
```

VS Code’is eelvaate avamine:

```text
Ctrl + Shift + V
```

Eelvaate avamine kõrval:

```text
Ctrl + K, seejärel V
```

GitHub kuvab `README.md` faili kausta esilehel automaatselt.

## 2. Pealkirjad

```markdown
# Pealkiri 1

## Pealkiri 2

### Pealkiri 3
```

Soovitus:

- kasuta failis ainult ühte `#` taseme põhipealkirja;
- põhijaotised märgi `##`;
- alajaotised märgi `###`;
- ära jäta pealkirjatasemeid põhjuseta vahele.

Näide:

```markdown
# Week 6 — Tartu kaupluse dashboard

## Eesmärk

## Dashboard

### KPI-d

### Filtrid
```

## 3. Lõigud ja reavahed

Uue lõigu jaoks jäta ridade vahele tühi rida.

Õige:

```markdown
Esimene lõik.

Teine lõik.
```

Kui kirjutad read kohe üksteise alla, võib GitHub need samasse lõiku ühendada.

Loendi, pealkirja, tabeli ja koodiploki ette ning järele on üldjuhul mõistlik jätta tühi rida.

## 4. Rasvane ja kaldkiri

```markdown
**rasvane tekst**

*kaldkiri*

***rasvane kaldkiri***
```

Kasuta rasvast kirja mõõdukalt:

```markdown
**Tulemus:** müügitulu kasvas 13,4%.
```

Ära muuda tervet pikka lõiku rasvaseks.

## 5. Inline-kood

Üksikud failinimed, väljad ja käsud märgitakse tagurpidi ülakomade vahele:

```markdown
Fail `analysis.md` sisaldab põhjalikku analüüsi.
```

Näide:

> Fail `analysis.md` sisaldab põhjalikku analüüsi.

Sobib järgmistele elementidele:

- failinimed;
- kaustanimed;
- SQL väljad;
- DAX mõõdikud;
- lühikesed käsud;
- Git-harude nimed.

## 6. Koodiplokid

Kolm tagurpidi ülakoma avavad ja sulgevad koodiploki.

````markdown
```powershell
git status
git pull --ff-only
```
````

SQL:

````markdown
```sql
SELECT *
FROM public.sales;
```
````

Tekstiväljund:

````markdown
```text
nothing to commit, working tree clean
```
````

Oluline: sulge koodiplokk alati kolme tagurpidi ülakomaga.

## 7. Täpploend

```markdown
- esimene punkt;
- teine punkt;
- kolmas punkt.
```

Tulemus:

- esimene punkt;
- teine punkt;
- kolmas punkt.

Kasuta sama loendi sees ühtset kirjavahemärkide stiili.

## 8. Nummerdatud loend

```markdown
1. Kontrolli repo seisu.
2. Too muudatused alla.
3. Tee commit.
```

Markdown võib nummerduse automaatselt korrastada. Selguse huvides kirjuta failis siiski õiged järjekorranumbrid.

## 9. Aasta rea alguses muutub Rooma numbriks või loendiks

Probleemne kuju:

```markdown
2024. aasta müügitulu kasvas.
```

Markdown võib tõlgendada seda nummerdatud loendina.

Lahendus 1 – paomärk punkti ees:

```markdown
2024\. aasta müügitulu kasvas.
```

Lahendus 2 – tee aasta koos sõnaga rasvaseks:

```markdown
**2024. aasta** müügitulu kasvas.
```

Teine lahendus on tavaliselt paremini loetav.

## 10. Lingid

### Link samas kaustas olevale failile

```markdown
[Vaata põhjalikku analüüsi](analysis.md)
```

### Link alamkaustas olevale pildile

```markdown
[Dashboard’i kuvatõmmis](screenshots/w6_role_b_tartu_kaupluse_dashboard.png)
```

### Link PBIX-failile

```markdown
[Power BI fail](urbanstyle_week6_tartu_dashboard_helen.pbix)
```

### Link välisele veebilehele

```markdown
[Grupitöö kaust GitHubis](https://github.com/Kolju3/DACA-group/tree/main/week-6/individual/helen)
```

## 11. Suhtelised ja absoluutsed lingid

### Suhteline link

```markdown
[Analüüs](analysis.md)
```

Eelised:

- töötab repo sees;
- ei sõltu kasutajanimest ega haru URL-ist;
- säilib ka siis, kui repo kloonitakse arvutisse.

### Absoluutne link

```markdown
[Grupirepo töö](https://github.com/Kolju3/DACA-group/tree/main/week-6/individual/helen)
```

Kasuta absoluutset linki siis, kui viitad teisele repole või välisele veebilehele.

Sama repo enda failide puhul eelista suhtelisi linke.

## 12. Failiteed Markdownis

Markdowni linkides kasuta kaldkriipsu `/`, mitte Windowsi tagurpidi kaldkriipsu `\`.

Õige:

```markdown
[screenshot](screenshots/dashboard.png)
```

Vale:

```markdown
[screenshot](screenshots\dashboard.png)
```

Windowsi kohalik tee:

```text
C:\Users\Helen\data-analysis-course\daca-portfolio\week-6
```

ei sobi GitHubi lingiks. See töötab ainult sinu arvutis.

## 13. Pildi kuvamine

```markdown
![Tartu kaupluse dashboard](screenshots/w6_role_b_tartu_kaupluse_dashboard.png)
```

Nurksulgudes olev tekst on pildi alternatiivtekst.

Soovituslik README osa:

```markdown
## Dashboard

![Tartu kaupluse dashboard](screenshots/w6_role_b_tartu_kaupluse_dashboard.png)
```

Kontrolli, et failinimi, laiend ja tähekuju vastavad tegelikule failile.

## 14. Tabelid

```markdown
| Mõõdik | 2023 | 2024 | Muutus |
|---|---:|---:|---:|
| Müügitulu | 229 319 € | 260 044 € | 13,4% |
| Tellimused | 777 | 905 | 16,5% |
```

Joondus:

```markdown
| Vasakule | Keskele | Paremale |
|:---|:---:|---:|
| Tekst | Tekst | 123 |
```

Pikad tekstid on tabelis sageli raskesti loetavad. Ärijäreldused kirjuta pigem lõigu või loendina.

## 15. Horisontaaljoon

```markdown
---
```

Kasuta seda mõõdukalt suuremate osade eristamiseks. Pealkirjadest piisab sageli ilma lisajooneta.

## 16. Märkus või tsitaat

```markdown
> Märkus: narratiiv kirjeldab Tartu kauplust.
```

Tulemus:

> Märkus: narratiiv kirjeldab Tartu kauplust.

Sobib piirangu, hoiatuse või olulise täpsustuse jaoks.

## 17. README ja analysis.md erinev roll

### README.md

README peab olema lühike ja ülevaatlik.

Soovituslik sisu:

- töö eesmärk;
- kasutatud tööriistad;
- dashboard’i või analüüsi lühikirjeldus;
- kuvatõmmis;
- lingid PBIX-, SQL- ja `analysis.md` failile;
- lühike eristus individuaalse ja grupitöö vahel.

### analysis.md

`analysis.md` sisaldab detailsemat infot:

- äriküsimus ja analüüsi ulatus;
- andmed ja mudel;
- mõõdikud;
- kontrollväärtused;
- tulemuste tõlgendus;
- disaini- ja arendusotsused;
- filtrid ja interaktiivsus;
- piirangud;
- saadud tagasiside;
- võimalikud edasised arendused.

README ei pea kordama kogu analüüsi.

## 18. Individuaalse ja grupitöö eristamine

Näide:

```markdown
## Minu panus

Koostasin Week 6 Roll B individuaalse Tartu kaupluse dashboard’i.

## Seos grupitööga

Individuaalne lahendus valmis grupitöö sisendiks ja seda kasutati ühise esitluse koostamisel.
```

Ära jäta muljet, et kogu grupitöö oli sinu individuaalne töö.

## 19. Failinimed

Soovitus:

- kasuta väiketähti;
- kasuta sõnade vahel sidekriipsu või alakriipsu;
- väldi tühikuid;
- kasuta selgeid ja püsivaid nimesid.

Näited:

```text
analysis.md
w6_role_b_tartu_kaupluse_dashboard.png
urbanstyle_week6_tartu_dashboard_helen.pbix
```

Failinime muutmisel uuenda kõik dokumendis olevad lingid.

## 20. GitHubis otse tehtud Markdowni muudatus

Kui parandad Markdowni faili otse GitHubis, tuleb muudatus hiljem kohalikku reposse tuua:

```powershell
git status
git pull --ff-only
```

VS Code’is võib olla vaja faili uuesti avada või Explorerit värskendada.

## 21. Levinumad vead ja lahendused

### Viga: aasta kuvatakse Rooma numbrina või loendina

Põhjus:

```markdown
2024. aasta...
```

Lahendus:

```markdown
2024\. aasta...
```

või:

```markdown
**2024. aasta** ...
```

### Viga: pilt ei ilmu

Kontrolli:

1. kas pilt on repos olemas;
2. kas failinimi on täpselt õige;
3. kas laiend on õige;
4. kas link kasutab `/` märki;
5. kas suur- ja väiketähed vastavad;
6. kas suhteline tee algab Markdowni faili asukohast.

Kontroll käsurealt:

```powershell
Test-Path ".\week-6\screenshots\w6_role_b_tartu_kaupluse_dashboard.png"
```

### Viga: link avab 404 lehe

Tavapärased põhjused:

- fail on ümber nimetatud;
- link viitab vanale harule;
- kasutatud on kohalikku Windowsi failiteed;
- tee algab valest kaustast;
- teises repos oleva faili puhul on kasutatud suhtelist linki.

Sama repo failile kasuta suhtelist linki. Teise repo puhul kasuta täielikku GitHubi URL-i.

### Viga: koodiplokk muudab kogu ülejäänud dokumendi koodiks

Põhjus: sulgevad kolm tagurpidi ülakoma puuduvad.

Kontrolli:

````markdown
```powershell
git status
```
````

### Viga: loend ei renderdu

Jäta loendi ette tühi rida:

```markdown
Sissejuhatav lause.

- esimene punkt;
- teine punkt.
```

### Viga: tabel ei renderdu

Tabeli päisereale peab järgnema eraldusrida:

```markdown
| Veerg 1 | Veerg 2 |
|---|---|
| A | B |
```

### Viga: tekst jookseb üheks lõiguks

Jäta lõikude vahele tühi rida.

### Viga: README on liiga pikk

Tõsta detailne analüüs faili `analysis.md` ja jäta README-sse link:

```markdown
[Vaata põhjalikku analüüsi](analysis.md)
```

### Viga: README ja analysis kordavad sama teksti

Jäta README-sse kokkuvõte ning dokumente ja kuvatõmmist avavad lingid. Hoia meetod, kontrollväärtused, piirangud ja põhjalikud järeldused analüüsifailis.

### Viga: GitHubi link on dokumendis üleliigne või tekitab ringviite

Sama kausta enda GitHubi URL-i ei ole sageli vaja README-sse lisada, sest kasutaja asub juba selles kaustas. Kasuta pigem suhtelisi linke konkreetsetele failidele.

### Viga: dokument sisaldab väljamõeldud tulemust

Kirjuta ainult:

- dashboard’il nähtavad väärtused;
- kontrollitud arvutused;
- tegelikult kasutatud filtrid ja visuaalid;
- selgelt märgitud piirangud;
- saadud tagasiside.

Kui põhjuslikku seost ei ole analüüsitud, ära esita seda faktina.

### Viga: kohalik failitee on README-s lingina

Vale:

```markdown
[C:\Users\Helen\data-analysis-course\daca-portfolio\week-6\analysis.md]
```

Õige:

```markdown
[Analüüs](analysis.md)
```

### Viga: PBIX-fail avaneb GitHubis ainult allalaadimisena

See on normaalne. PBIX on binaarfail. GitHub ei kuva selle sisu nagu Markdowni või SQL-faili.

### Viga: VS Code näitab Markdowni lähtekoodi, mitte valmis vaadet

Ava eelvaade:

```text
Ctrl + Shift + V
```

## 22. Enne commit’i kontrollnimekiri

- [ ] Pealkirjatasemed on loogilised.
- [ ] README on lühike.
- [ ] Põhjalik analüüs on eraldi failis.
- [ ] Kõik suhtelised lingid kasutavad `/` märki.
- [ ] Piltide ja failide nimed vastavad tegelikele nimedele.
- [ ] Ühtegi kohalikku `C:\...` teed ei ole kasutatud GitHubi lingina.
- [ ] Koodiplokid on suletud.
- [ ] Tabelitel on päis ja eraldusrida.
- [ ] Aasta rea alguses ei muutu loendinumbriks.
- [ ] Individuaalne ja grupitöö on eristatud.
- [ ] Tulemused on kontrollitud ega ole välja mõeldud.
- [ ] Ajutised märkused ja õigekirjavead on eemaldatud.

## 23. Kiirspikker

```markdown
# Põhipealkiri

## Jaotis

**Rõhutatud tekst**

`failinimi.md`

[Link](analysis.md)

![Pilt](screenshots/dashboard.png)

- loendipunkt

1. nummerdatud punkt

> Märkus

```powershell
git status
```
```

Aasta rea alguses:

```markdown
**2024. aasta** müügitulu kasvas.
```

