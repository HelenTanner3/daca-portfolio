# Nädal 4 detailne analüüs — turunduskanalite agregatsioon

## 1. Analüüsi eesmärk

Nädal 4 keskendus SQL-agregatsioonile. Minu ametlik põhiroll oli **Roll D — turunduskanalite efektiivsuse analüüs**.

Äriküsimus oli:

> Millised turunduskanalid seostuvad suurima kliendiarvu, tellimuste arvu ja käibega ning millistes kanalites on suurim keskmine tellimusväärtus ja müük kliendi kohta?

Tegeliku ROI arvutamine ei olnud võimalik, sest andmestikus puudusid kampaaniakulud. Seetõttu käsitletakse tulemusi kanalite müügimahu ja efektiivsusnäitajatena, mitte investeeringutasuvusena.

## 2. Juhendi nõuded ja täidetud väljund

Roll D juhend nõudis:

1. turunduskanalite koondandmeid `GROUP BY` abil;
2. kanali efektiivsuse arvutamist CTE ja `HAVING` abil;
3. kanalite kuiseid trende;
4. Kristile 3–5 koondnumbrit;
5. SQL-faili, tulemuste tõendusmaterjale ja lühikest ärilist kokkuvõtet.

Põhiartefakt `week4_role_d_marketing_aggregation.sql` sisaldab juhendi kolme päringut ning täiendavaid valideerimis- ja ristkontrollipäringuid.

## 3. Kasutatud andmed

| Tabel | Kasutus analüüsis |
|---|---|
| `sales` | müügitehingud, müügikuupäev, klient ja `total_price` |
| `customers` | kliendi põhiandmed ja ühendus müügiga |
| `web_logs` | veebikülastuse allikas, külastuse aeg ja kliendiseos |
| `web_logs_test` | kanalinimede puhastusloogika kontroll |
| `cleaning_log` | puhastamis- ja kontrollitoimingute dokumenteerimine |

Peamised referentsväärtused:

| Kontrollnäitaja | Tulemus |
|---|---:|
| `web_logs` ridu | 50 000 |
| `sales` ridu | 10 118 |
| Unikaalseid `sale_id` väärtusi | 10 118 |
| `sales` kogukäive | 2 909 177,98 € |

## 4. Kanaliandmete standardiseerimine

Algsel `source` väljal oli 19 väärtust. Sama sisuline kanal esines eri kirjapiltide ja lühenditena, näiteks:

- `Facebook` ja `FB`;
- `Facebook Ads`, `facebook_ads` ja `fb_ads`;
- `Google Organic`, `google organic` ja `google_organic`;
- `IG`, `instagram` ja `Instagram`.

Algset välja ei kirjutatud üle. Analüüsiks loodi `source_clean`, kuhu väärtused koondati kümneks standardiseeritud kanaliks.

Puhastus viidi läbi põhimõttel **Test → Verify → Log → Commit**:

1. loodi `web_logs_test`;
2. rakendati standardiseerimisloogika testtabelis;
3. kontrolliti ridade arvu ja vastendusi;
4. rakendati sama loogika `web_logs` tabelis;
5. toimingud logiti.

| Näitaja | Enne | Pärast |
|---|---:|---:|
| Erinevaid kanaliväärtusi | 19 | 10 |
| Tabeli ridu | 50 000 | 50 000 |
| `source_clean` NULL-väärtusi | – | 0 |

**Tõendusmaterjalid:**

- [Veebilogide struktuur](screenshots/additional_01_web_logs_structure.png)
- [Andmekvaliteedi ülevaade](screenshots/additional_02_web_logs_quality_summary.png)
- [Standardiseeritud kanalite liiklus](screenshots/additional_03_standardized_channel_traffic.png)

## 5. Veebilogide andmekvaliteet

| Näitaja | Tulemus |
|---|---:|
| Logisid kokku | 50 000 |
| Tuvastatud kliendiga logisid | 40 585 |
| Anonüümseid logisid | 9 415 |
| Anonüümsete logide osakaal | 18,83% |
| Standardiseeritud kanaleid | 10 |
| Esimene külastus | 17.01.2019 |
| Viimane külastus | 28.02.2025 |

Anonüümseid logisid ei saa `customer_id` abil müügiga siduda. Samuti võib ühel tuvastatud kliendil olla mitu logirida ja mitu kanalit.

**Tõendusmaterjal:**

- [Kliendi logiridade ja kanalite korduvus](screenshots/additional_04_customer_channel_multiplicity.png)

## 6. Juhendi päringute oluline piirang

Juhendi kolm põhipäringut ühendasid `sales`, `customers` ja `web_logs` tabelid kliendi kaudu. Need näitasid nõutud SQL-võtteid, kuid ühe kliendi mitu veebilogirida kordistasid sama müüki.

Seetõttu on juhendi päringute kuvatõmmised säilitatud ajaloolise töö ja õpiväljundi tõendina, kuid nende `SUM(total_price)` ja `AVG(total_price)` väärtusi ei kasutata lõplike juhtimisnumbritena.

**Ajaloolised juhendipäringud:**

- [Kanalite koondandmed — otsese JOIN-i tulemus](screenshots/query_01_channel_summary_unvalidated.png)
- [Kanali efektiivsus CTE-ga — otsese JOIN-i tulemus](screenshots/query_02_channel_efficiency_cte_unvalidated.png)
- [Kuised trendid — otsese JOIN-i tulemus](screenshots/query_03_monthly_trends_unvalidated.png)
- [Kuised trendid CSV](screenshots/query_03_monthly_trends_unvalidated.csv)

## 7. JOIN-i kardinaalsuse kontroll

Enne JOIN-i:

| Kontroll | Tulemus |
|---|---:|
| Müügiridu | 10 118 |
| Unikaalseid müüke | 10 118 |
| Kogukäive | 2 909 177,98 € |

Otsese `sales → customers → web_logs` ühendamise järel:

| Kontroll | Tulemus |
|---|---:|
| JOIN-i ridu | 121 131 |
| Säilinud unikaalseid müüke | 9 130 |
| Summeeritud käive | 34 527 628,19 € |

Mõju:

- ridade arv kasvas 11,97 korda;
- summeeritud käive kasvas 11,87 korda;
- `INNER JOIN customers` jättis välja 988 müüki;
- `COUNT(DISTINCT sale_id)` kaitses osaliselt tellimuste arvu, kuid `SUM` ja `AVG` jäid valeks.

**Tõendusmaterjalid:**

- [Müügitabeli referentsväärtused](screenshots/additional_05a_sales_reference_values.png)
- [Otsese JOIN-i kontroll](screenshots/additional_05b_direct_three_table_join_validation.png)

## 8. Valideeritud omistamisloogika

Kliendi veebilogid järjestati:

```sql
ROW_NUMBER() OVER (
    PARTITION BY customer_id
    ORDER BY visit_date DESC, log_id DESC
)
```

Igale kliendile jäeti üks viimane teadaolev standardiseeritud kanal. Müükidega ühendamisel kasutati `LEFT JOIN`-i, et säilitada ka kliendivasteta müügid grupis `unknown`.

Selle meetodi tugevus:

- üks klient saab ühe kanalirea;
- müügiread ei mitmekordistu;
- lõpptulemuse tellimuste arv ja käive ühtivad `sales` referentsväärtustega.

Piirang:

- kanal ei ole seotud konkreetse tehingu või sessiooniga;
- kliendi viimane veebiallikas võis olla hilisem kui osa tema oste;
- tulemus näitab seost, mitte tõendatud põhjuslikku mõju.

## 9. Hilisem standardiseeritud kogu perioodi koond

Praeguses põhi-SQL-is kasutatud `source_clean`-põhise kogu müügiperioodi koondi tulemused:

| Kanal | Kliente | Tellimusi | Käive | Keskmine tellimus | Müük kliendi kohta |
|---|---:|---:|---:|---:|---:|
| `google_organic` | 684 | 2 273 | 666 444,98 € | 293,20 € | 974,33 € |
| `facebook_ads` | 351 | 1 635 | 469 933,25 € | 287,42 € | 1 338,84 € |
| `direct` | 465 | 1 505 | 420 103,22 € | 279,14 € | 903,45 € |
| `unknown` | 90 | 1 338 | 383 127,19 € | 286,34 € | 4 256,97 €* |
| `email_campaign` | 275 | 1 024 | 300 296,85 € | 293,26 € | 1 091,99 € |
| `instagram` | 259 | 877 | 262 112,79 € | 298,87 € | 1 012,02 € |
| `google_ads` | 196 | 664 | 185 438,12 € | 279,27 € | 946,11 € |
| `tiktok` | 127 | 463 | 127 929,88 € | 276,31 € | 1 007,32 € |
| `google_unspecified` | 48 | 151 | 41 629,31 € | 275,69 € | 867,28 € |
| `facebook` | 32 | 117 | 32 797,10 € | 280,32 € | 1 024,91 € |
| `instagram_ads` | 24 | 71 | 19 365,29 € | 272,75 € | 806,89 € |
| **Kokku** | **2 551** | **10 118** | **2 909 177,98 €** | – | – |

\* `unknown` grupi müük kliendi kohta ei ole teiste kanalitega võrreldav, sest grupis sisaldub ka NULL-kliendiga müüke.

Põhitulemused:

- `google_organic` oli suurima käibe ja tellimuste arvuga tuvastatud kanal;
- `facebook_ads` oli tuvastatud kanalitest suurima müügiga kliendi kohta;
- `instagram` oli suurima keskmise tellimusväärtusega kanal;
- `google_organic`, `facebook_ads` ja `direct` moodustasid kokku 53,50% käibest ja tellimustest;
- `unknown` moodustas 13,17% käibest ning on oluline atribuutika- ja andmekvaliteedi risk.

**Tõendusmaterjalid:**

- [Valideeritud kanalite koond](screenshots/additional_06_validated_channel_summary.png)
- [Valideeritud kanali efektiivsus](screenshots/additional_07_validated_channel_efficiency_cte.png)

## 10. Ametlik individuaalne portfoolioversioon

Minu ametlik W4 individuaalne portfooliotöö on **pärast grupiesitlust valminud standardiseeritud analüüs**. Selles kasutati välja `source_clean`, kontrolliti JOIN-i kardinaalsust ning valideeriti lõpptulemus kogu `sales` tabeli referentsväärtustega.

Ametliku portfoolioversiooni `google_organic` tulemus:

| Näitaja | Ametliku portfoolioversiooni väärtus |
|---|---:|
| Kliente | 684 |
| Tellimusi | 2 273 |
| Käive | 666 444,98 € |
| Keskmine tellimus | 293,20 € |

Varasemas grupiesitluse etapis kasutati enne lõpliku standardiseeritud lahenduse valmimist teistsuguseid väärtusi:

| Näitaja | Varasema esitlusversiooni väärtus |
|---|---:|
| Kliente | 624 |
| Tellimusi | 1 994 |
| Käive | 582 912,57 € |
| Keskmine tellimus | 292,33 € |

Varasemaid esitlusarve käsitletakse ainult töö ajaloo osana. Need ei ole minu ametliku individuaalse portfooliotöö lõpptulemused ning neid ei segata hilisema standardiseeritud analüüsi arvudega.

Ametliku portfoolioversiooni valiku põhjused:

- see kasutab standardiseeritud kanalinimesid;
- see on põhi-SQL-is reprodutseeritav;
- tellimuste arv ja kogukäive ühtivad täielikult `sales` referentsväärtustega;
- see kajastab minu lõplikku kontrollitud Roll D analüüsi.

Varasema esitlusversiooni täpseid filtreid ja vahe-etappe ei rekonstrueerita oletuste põhjal, sest see ei ole ametliku individuaalse portfooliotöö lõpptulemus.

## 11. Kuised trendid

Täieliku `sales` koondi põhjal:

| Aasta | Tellimusi | Käive |
|---|---:|---:|
| 2023 | 4 274 | 1 234 758,90 € |
| 2024 | 5 137 | 1 470 358,02 € |
| 2025 | 691 | 199 968,69 € |
| 2026 | 16 | 4 092,37 € |

2024. aastal kasvas tellimuste arv **20,19%** ja käive **19,08%** võrreldes 2023. aastaga. 2024. aasta suurima käibega kuu oli detsember: **170 623,28 €**.

2025. ja 2026. aasta tulemusi ei käsitleta täieliku aastatrendina, sest perioodide andmekate on ebaühtlane.

Kanalipõhises ajalises analüüsis ilmnes 2024. aasta lõpus tugev kõikumine. Analüüsi esitlusversioonis kasvas `google_organic` käive novembrist detsembrini 142,7%.

**Tõendusmaterjalid:**

- [Valideeritud kuised trendid](screenshots/additional_08_validated_monthly_trends.png)
- [Valideeritud kuised trendid CSV](screenshots/additional_08_validated_monthly_trends.csv)
- [Kuust-kuusse käibe muutus](screenshots/additional_09_month_over_month_revenue_change.png)
- [Kuust-kuusse käibe muutus CSV](screenshots/additional_09_month_over_month_revenue_change.csv)
- [Müügikoondi kuine ristkontroll](screenshots/additional_10_role_a_sales_monthly_crosscheck.png)
- [Müügikoondi kuine ristkontroll CSV](screenshots/additional_10_role_a_sales_monthly_crosscheck.csv)

## 12. Kuise trendipäringu piirang

Kanalite kuise trendi päring kasutab tingimust:

```sql
HAVING COUNT(DISTINCT sale_id) >= 5
```

See jätab välja väikese mahuga kanali-kuu kombinatsioonid. Kontrolli järgi jäi trenditabelist välja **166 tellimust** ja **50 121,50 € käivet**.

Seetõttu ei tohi kuise kanalitabeli summat kasutada kogu ettevõtte käibe referentsväärtusena.

## 13. Andmeperioodide ebakõla

`web_logs` viimane kuupäev on 28.02.2025, kuid `sales` sisaldab ka hilisemaid kirjeid. Pärast veebilogide lõppu toimunud müükide kanaliseos põhineb kliendi varasemal viimasel logil, mitte sama perioodi veebikäitumisel.

See piirab eriti 2025. ja 2026. aasta kanalitulemuste tõlgendamist.

## 14. Juhtkonna koondvaade

Analüüsi viis peamist juhtimisnumbrit:

1. `web_logs` sisaldas **50 000 rida**, millest **18,83%** olid anonüümsed.
2. Kanali algväärtused standardiseeriti **19 väärtuselt 10 kanaliks**.
3. Otsene kolme tabeli JOIN andis **34,53 mln €**, kuigi `sales` referentskäive oli **2,91 mln €**.
4. `google_organic` oli suurima valideeritud müügimahuga tuvastatud kanal: **666 444,98 €** ja **2 273 tellimust**.
5. 2024. aasta käive kasvas 2023. aastaga võrreldes **19,08%**.

### Tulemuste korrektne tõlgendamine

Sobivad sõnastused:

- „suurima valideeritud käibega kanal”;
- „suurima müügiga kliendi kohta tuvastatud kanal”;
- „kanaliga seotud käive”;
- „viimane teadaolev kliendikanal”;
- „kanalite efektiivsus”.

Vältida tuleb järgmisi väiteid:

- „parim ROI”, sest kampaaniakulud puuduvad;
- „kanal põhjustas müügi”, sest põhjuslikku seost ei ole tõendatud;
- „konversioonimäär”, sest külastust ja tehingut ei seota sama sessiooni või kampaania alusel;
- `unknown` käsitlemine tegeliku turunduskanalina;
- otsese JOIN-i koondnumbrite kasutamine juhtimisinfona.

## 15. Soovitused

### Annale ja Kristile

1. Toetada `google_organic` kanalit SEO, sisuturunduse ja maandumislehtede kvaliteedi kaudu.
2. Võrrelda tasulisi kanaleid alles pärast kampaaniakulude ja võimaluse korral brutomarginaali lisamist.
3. Uurida `unknown` grupi **383 127,19 €** suurust käivet.
4. Hoida `source_clean` standardiseerimisreeglid püsiva andmetöötluse osana.
5. Siduda müük tulevikus sessiooni, kampaania ID, click ID või UTM-parameetritega.
6. Kontrollida iga JOIN-i järel ridade arvu, unikaalsete tehingute arvu ja kogukäivet.
7. Märkida raportites alati kasutatud periood, omistamisreegel ja `HAVING`-filter.

## 16. Peamine õppetund

Tehniliselt korrektne SQL ei taga sisuliselt õiget tulemust. Eri tabelite ühendamisel tuleb enne agregaatide usaldamist kontrollida:

- tabelite detailsusastet;
- JOIN-i kardinaalsust;
- ridade arvu;
- unikaalsete ärivõtmete arvu;
- referentskogusummasid;
- perioodide ja filtrite võrreldavust.

See õppetund oli Nädal 4 kõige olulisem tulemus.

## 17. Vabatahtlik lisaanalüüs

Lisaks ametlikule Roll D tööle tegin enesearengu eesmärgil läbi ka Roll B kliendisegmentatsiooni ülesande. Selle eesmärk oli harjutada kliendigruppide moodustamist, agregatsiooniloogikat ja tulemuste kontrollimist teise äriküsimuse puhul.

- [Roll B kliendisegmentatsiooni SQL](additional-analysis/week4_role_b_customer_segmentation.sql)
- [Kliendisegmendid](additional-analysis/01_customer_segments_by_spend.png)
- [Kliendisegmendid CSV](additional-analysis/01_customer_segments_by_spend.csv)
- [TOP korduvkliendid](additional-analysis/02_top_repeat_customers.png)
- [Segmentide koond ja TOP VIP-linn](additional-analysis/03_segment_summary_and_top_vip_city.png)

See lisaanalüüs ei ole minu ametliku Roll D põhiartefakti osa.

## 18. Ajaloolise töö säilitamine

Põhi-SQL ja kuvatõmmised kajastavad Nädal 4 töö tegemise aja päringuid ja tulemusi. Korrastamisel:

- SQL-i sisulist loogikat ei muudeta;
- juhendi otsese JOIN-i tulemused säilitatakse õpiväljundi tõendina;
- ebausaldusväärsed koondid märgistatakse failinimedes ja analüüsis;
- dokumentatsiooni täiendatakse hilisema valideerimise ja piirangutega;
- failinimed ja kaustad ühtlustatakse.

Varem eraldi failis olnud individuaalse presentatsiooni alus ja kõnepunktid ühendati sellesse detailanalüüsi. Eraldi presentatsioonimärkuste faili portfoolios ei säilitata.