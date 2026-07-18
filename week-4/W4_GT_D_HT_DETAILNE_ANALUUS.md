# Nädal 4 — turunduskanalite efektiivsuse detailne analüüs

## 1. Juhtkokkuvõte

Analüüsi eesmärk oli hinnata, millised UrbanStyle.ltd turunduskanalid seostuvad suurema kliendiarvu, tellimuste arvu ja käibega. Enne kanalite tulemuslikkuse hindamist tuli lahendada kaks andmekvaliteedi probleemi:

1. sama kanal oli `source` väljal esitatud mitme erineva kirjapildi ja lühendina;
2. `web_logs` sisaldas ühe kliendi kohta mitut logirida, mistõttu otsene ühendamine `sales` tabeliga mitmekordistas müügitehinguid.

`source` väärtused standardiseeriti uude `source_clean` veergu. Seejärel loodi valideeritud kanaliloogika, milles igale kliendile jäeti üks viimane teadaolev kanal. Valideeritud tulemuste summa ühtis täielikult `sales` tabeli kontrollväärtustega: 10 118 müüki ja 2 909 177,98 eurot käivet.

Suurima käibega tuvastatud kanal oli `google_organic`, suurima müügiga kliendi kohta `facebook_ads` ning suurima keskmise tellimusega `instagram`. Tegelikku ROI-d ei olnud võimalik arvutada, sest kampaaniate kulud puudusid.

## 2. Lähteandmed ja kontrollväärtused

| Tabel | Roll analüüsis |
|---|---|
| `sales` | müügitehingud, müügikuupäev ja tehingu väärtus |
| `customers` | kliendi põhiandmed ja kliendiseos |
| `web_logs` | veebikülastused, kanal, külastuse aeg ja kliendiseos |
| `web_logs_test` | puhastusloogika kontrollimiseks loodud testkoopia |
| `cleaning_log` | tehtud andmepuhastuse ja kontrollide logi |

| Kontrollnäitaja | Tulemus |
|---|---:|
| `web_logs` ridu | 50 000 |
| `sales` ridu | 10 118 |
| Unikaalseid `sale_id` väärtusi | 10 118 |
| `sales` kogukäive | 2 909 177,98 € |

## 3. `source` välja puhastamine

Algsel `source` väljal oli 19 väärtust. Osa neist tähistas sama kanalit, näiteks `Facebook` ja `FB`, `Facebook Ads` ja `fb_ads`, `Google Organic` ja `google_organic`.

Algset `source` veergu ei muudetud. Standardväärtus lisati uude `source_clean` veergu. Tasuline reklaam ja orgaaniline või täpsustamata liiklus jäeti eraldi.

Puhastus viidi läbi metoodikaga **Test → Verify → Log → Commit**:

1. loodi `web_logs_test`;
2. standardiseeriti testtabel;
3. kontrolliti ridade arvu ja väärtuste vastendust;
4. rakendati sama loogika `web_logs` tabelis;
5. tegevused dokumenteeriti `cleaning_log` tabelis.

| Näitaja | Enne | Pärast |
|---|---:|---:|
| Erinevaid kanaliväärtusi | 19 | 10 |
| Tabeli ridade arv | 50 000 | 50 000 |
| `source_clean` NULL väärtusi | – | 0 |

## 4. Veebilogide andmekvaliteet

| Näitaja | Tulemus |
|---|---:|
| Logisid kokku | 50 000 |
| Tuvastatud kliendiga logisid | 40 585 |
| Anonüümseid logisid | 9 415 |
| Anonüümsete logide osakaal | 18,83% |
| Standardiseeritud kanaleid | 10 |
| Esimene külastus | 17.01.2019 |
| Viimane külastus | 28.02.2025 |

Ligi viiendik logidest on anonüümsed ja neid ei saa `customer_id` abil müügiga siduda.

## 5. Standardiseeritud kanalite liiklus

| Kanal | Külastusi | Tuvastatud kliente |
|---|---:|---:|
| `google_organic` | 14 094 | 1 884 |
| `direct` | 9 522 | 1 373 |
| `facebook_ads` | 7 240 | 1 186 |
| `instagram` | 5 577 | 958 |
| `email_campaign` | 5 073 | 878 |
| `google_ads` | 3 768 | 693 |
| `tiktok` | 2 573 | 460 |
| `google_unspecified` | 1 159 | 692 |
| `facebook` | 579 | 371 |
| `instagram_ads` | 415 | 271 |

`google_organic` on nii külastuste kui ka tuvastatud klientide arvu järgi suurim kanal. Liikluse maht ei ole siiski konversioonimäär, sest külastusi ja müüke ei seota sama sessiooni või kampaania alusel.

## 6. Otsese JOIN-i probleem

Enne JOIN-i oli `sales` tabelis 10 118 müüki ja 2 909 177,98 eurot käivet.

Otsene ühendamine `sales → customers → web_logs` andis:

- 121 131 JOIN-i rida;
- 9 130 unikaalset müüki;
- 34 527 628,19 eurot summeeritud käivet.

| Näitaja | Algne `sales` | Otsene JOIN | Mõju |
|---|---:|---:|---:|
| Ridu | 10 118 | 121 131 | 11,97 korda rohkem |
| Unikaalseid müüke | 10 118 | 9 130 | 988 müüki vähem |
| Käive | 2 909 177,98 € | 34 527 628,19 € | 11,87 korda suurem |

Moonutusel oli kaks põhjust:

1. `INNER JOIN customers` eemaldas müügid, millel ei olnud sobivat kliendikirjet;
2. `LEFT JOIN web_logs` kordas iga säilinud müüki vastavalt kliendi logiridade arvule.

`COUNT(DISTINCT sale_id)` võib tellimuste arvu osaliselt kaitsta, kuid `SUM(total_price)` ja `AVG(total_price)` jäävad valeks.

## 7. Valideeritud omistamisloogika

Kliendi logiread järjestati:

```sql
ROW_NUMBER() OVER (
    PARTITION BY customer_id
    ORDER BY visit_date DESC, log_id DESC
)
```

Analüüsi jäeti iga kliendi kohta `rea_number = 1`. Kõik kliendi müügid seoti tema viimase teadaoleva standardiseeritud kanaliga.

Tugevus:

- üks klient saab ühe kanalirea;
- müügiread ei mitmekordistu;
- lõpptulemuse tellimuste arv ja kogukäive ühtivad `sales` kontrollväärtusega.

Piirang:

- kanal ei ole seotud konkreetse tehingu ega sessiooniga;
- viimane logi võib olla toimunud pärast kliendi varasemaid oste;
- tulemus näitab seost, mitte tõendatud põhjuslikku mõju.

## 8. Valideeritud kanalitulemused

| Kanal | Kliente | Tellimusi | Käive | Käibe osakaal | Keskmine tellimus | Müük kliendi kohta |
|---|---:|---:|---:|---:|---:|---:|
| `google_organic` | 684 | 2 273 | 666 444,98 € | 22,91% | 293,20 € | 974,33 € |
| `facebook_ads` | 351 | 1 635 | 469 933,25 € | 16,15% | 287,42 € | 1 338,84 € |
| `direct` | 465 | 1 505 | 420 103,22 € | 14,44% | 279,14 € | 903,45 € |
| `unknown` | 90 | 1 338 | 383 127,19 € | 13,17% | 286,34 € | 4 256,97 €* |
| `email_campaign` | 275 | 1 024 | 300 296,85 € | 10,32% | 293,26 € | 1 091,99 € |
| `instagram` | 259 | 877 | 262 112,79 € | 9,01% | 298,87 € | 1 012,02 € |
| `google_ads` | 196 | 664 | 185 438,12 € | 6,37% | 279,27 € | 946,11 € |
| `tiktok` | 127 | 463 | 127 929,88 € | 4,40% | 276,31 € | 1 007,32 € |
| `google_unspecified` | 48 | 151 | 41 629,31 € | 1,43% | 275,69 € | 867,28 € |
| `facebook` | 32 | 117 | 32 797,10 € | 1,13% | 280,32 € | 1 024,91 € |
| `instagram_ads` | 24 | 71 | 19 365,29 € | 0,67% | 272,75 € | 806,89 € |
| **Kokku** | **2 551** | **10 118** | **2 909 177,98 €** | **100,00%** | – | – |

\* `unknown` grupi müük kliendi kohta ei ole teiste kanalitega võrreldav. `COUNT(DISTINCT customer_id)` ei loenda NULL väärtusi, kuid nende müükide käive sisaldub grupi kogukäibes.

## 9. KPI-de tõlgendus

### Suurim maht

`google_organic`:

- 684 klienti;
- 2 273 tellimust;
- 666 444,98 eurot käivet;
- 22,91% kogu käibest;
- 22,46% kõigist tellimustest.

See on tugevaim kanal mahu järgi, mitte tõendatult parim ROI-kanal.

### Suurim müük kliendi kohta

Tuvastatud kanalitest oli suurim tulemus `facebook_ads` kanalil:

- 1 338,84 eurot kliendi kohta;
- 4,66 tellimust kliendi kohta;
- 469 933,25 eurot käivet.

### Suurim keskmine tellimus

`instagram` keskmine tellimus oli 298,87 eurot. Järgnesid `email_campaign` 293,26 euroga ja `google_organic` 293,20 euroga.

### Kanalite kontsentratsioon

`google_organic`, `facebook_ads` ja `direct` moodustasid kokku 53,50% käibest ning 53,50% tellimustest.

`unknown` moodustas veel 13,17% käibest. See on oluline atribuutika- ja andmekvaliteedi risk.

## 10. Ajaline areng

Täieliku `sales` koondi põhjal:

| Aasta | Tellimusi | Käive |
|---|---:|---:|
| 2023 | 4 274 | 1 234 758,90 € |
| 2024 | 5 137 | 1 470 358,02 € |
| 2025 | 691 | 199 968,69 € |
| 2026 | 16 | 4 092,37 € |

2024 võrreldes 2023. aastaga:

- tellimusi lisandus 863 ehk 20,19%;
- käive kasvas 235 599,12 eurot ehk 19,08%.

Suurimad kuud:

| Kuu | Tellimusi | Käive | Keskmine tellimus |
|---|---:|---:|---:|
| 12.2024 | 550 | 170 623,28 € | 310,22 € |
| 07.2024 | 510 | 146 800,80 € | 287,84 € |
| 08.2024 | 511 | 144 870,17 € | 283,50 € |
| 06.2024 | 509 | 144 558,18 € | 284,00 € |
| 12.2023 | 458 | 129 104,59 € | 281,89 € |

Kanalite kuised tipud:

- `google_organic` suurim kuine käive oli 2024. aasta oktoobris: 38 158,24 €;
- `google_organic` käive kasvas 2024. aasta detsembris 100,1%;
- `facebook_ads` käive kasvas 2024. aasta detsembris 103,7%;
- `instagram` käive kasvas 2024. aasta detsembris 125,9%;
- `google_organic` suurim langus oli 2024. aasta novembris: −51,6%.

Tulemused viitavad tugevale hooajalisusele, eriti aasta lõpus.

## 11. Kuise trendipäringu piirang

Kuise päringu tingimus:

```sql
HAVING COUNT(DISTINCT sale_id) >= 5
```

jätab välja kanali-kuu kombinatsioonid, kus on alla viie tellimuse.

Seetõttu sisaldab kuine kanalitabel:

- 9 952 tellimust;
- 2 859 056,48 eurot käivet.

Täielikust müügist jääb välja:

- 166 tellimust;
- 50 121,50 eurot käivet.

Kuine kanalipäring sobib põhikanalite trendide vaatamiseks, kuid selle summat ei tohi kasutada ettevõtte täieliku käibe kontrollväärtusena.

## 12. Andmeperioodi ebakõla

`web_logs` viimane kuupäev on 28.02.2025. `sales` tabel sisaldab müüke ka 2025. aasta detsembris ja 2026. aasta jaanuarist juunini.

Pärast 2025. aasta veebruari on 32 müüki kogukäibega 8 865,94 eurot. Nende kanaliseos põhineb kliendi varasemal viimasel logil, mitte samal perioodil toimunud veebikäitumisel.

Lisaks puuduvad `sales` koondis müügid 2025. aasta märtsist novembrini. Seda tuleb käsitleda võimaliku andmekatte või testandmete anomaaliana.

## 13. Soovitused

1. Siduda müük sessiooni, kampaania ID, click ID või UTM parameetritega.
2. Lisada kampaaniakulud ja võimalusel brutomarginaal, et arvutada ROI või ROAS.
3. Uurida `unknown` grupi 383 127,19 euro suurust käivet.
4. Muuta `source_clean` standardiseerimisreeglid püsivaks andmetöötluse osaks.
5. Kontrollida iga JOIN-i alati ridade arvu, unikaalsete tehingute ja kogukäibe referentsväärtustega.
6. Hoida kuise trendi `HAVING` filter nähtava metoodilise piiranguna.
7. Kontrollida müügi- ja veebilogide ajaperioodide kattuvust.

## 14. Lõppjäreldus

Standardiseerimata `source` väärtused oleksid jaganud sama kanali mitmeks grupiks. Otsene JOIN oleks suurendanud käibe 2,91 miljonilt eurolt 34,53 miljonile eurole ning jätnud samal ajal 988 müüki välja.

Valideeritud tulemuste järgi on:

- suurima müügimahuga kanal `google_organic`;
- suurima müügiga kliendi kohta tuvastatud kanal `facebook_ads`;
- suurima keskmise tellimusega kanal `instagram`;
- suurim andmekvaliteedi risk kanalita grupp `unknown`;
- müügimaht oli ligikaudu viiendiku võrra suurem 2024. aastal võrreldes 2023. aastaga.

Neid tulemusi tuleb käsitleda kanalite efektiivsuse, mitte tegeliku ROI hinnanguna.
