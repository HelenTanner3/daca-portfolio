# Nädal 4 — SQL agregatsioon ja turunduskanalite efektiivsus

## Ülevaade

Selles portfooliotöös analüüsisin UrbanStyle.ltd turunduskanalite efektiivsust, kasutades Supabase/PostgreSQL keskkonnas tabeleid `sales`, `customers` ja `web_logs`.

**Äriküsimus:** millised turunduskanalid toovad kõige rohkem kliente, tellimusi ja käivet ning millistes kanalites on suurim keskmine tellimusväärtus ja müük kliendi kohta?

Tegelikku turunduse ROI-d ei olnud võimalik arvutada, sest andmestikus puudusid kampaaniate kulud. Seetõttu hinnati kanalite tulemuslikkust käibe, tellimuste, klientide, keskmise tellimuse ja müügi kliendi kohta alusel.

## Tehtud töö

1. Kontrollisin `web_logs` tabeli struktuuri ja mahtu.
2. Tuvastasin `source` väljal sama kanali erinevad kirjapildid ja lühendid.
3. Lõin standardiseeritud välja `source_clean`.
4. Koondasin 19 algset `source` väärtust 10 standardiseeritud kanaliks.
5. Kontrollisin puhastusloogikat esmalt `web_logs_test` tabelis ja rakendasin selle seejärel production-tabelis `web_logs`.
6. Logisin tehtud toimingud tabelisse `cleaning_log`.
7. Analüüsisin kanalite liiklust, kliente, tellimusi, käivet ja kuiseid trende.
8. Kontrollisin otsese JOIN-i mõju ning tuvastasin müügiridade mitmekordistumise.
9. Koostasin valideeritud lahenduse, milles igale kliendile omistati üks viimane teadaolev standardiseeritud kanal.

## Põhiandmed

| Näitaja | Tulemus |
|---|---:|
| `web_logs` ridu | 50 000 |
| Tuvastatud kliendiga logisid | 40 585 |
| Anonüümseid logisid | 9 415 |
| Anonüümsete logide osakaal | 18,83% |
| Algseid `source` väärtusi | 19 |
| Standardiseeritud kanaleid | 10 |
| Müügitehinguid `sales` tabelis | 10 118 |
| Müügitulu kokku | 2 909 177,98 € |

## Standardiseeritud kanalid

| Algväärtused | Standardväärtus |
|---|---|
| `Facebook`, `FB` | `facebook` |
| `Facebook Ads`, `facebook_ads`, `fb_ads` | `facebook_ads` |
| `google`, `Google` | `google_unspecified` |
| `google organic`, `Google Organic`, `google_organic` | `google_organic` |
| `google_ads` | `google_ads` |
| `IG`, `instagram`, `Instagram` | `instagram` |
| `ig_ads`, `instagram_ads` | `instagram_ads` |
| `direct` | `direct` |
| `email_campaign` | `email_campaign` |
| `tiktok` | `tiktok` |

Tasuline reklaam ja orgaaniline või täpsustamata liiklus jäeti eraldi, sest neid ei saa ilma täiendava alusinfota käsitleda sama kanalina.

## Olulisemad valideeritud tulemused

| Kanal | Kliente | Tellimusi | Käive | Keskmine tellimus |
|---|---:|---:|---:|---:|
| `google_organic` | 684 | 2 273 | 666 444,98 € | 293,20 € |
| `facebook_ads` | 351 | 1 635 | 469 933,25 € | 287,42 € |
| `direct` | 465 | 1 505 | 420 103,22 € | 279,14 € |
| `unknown` | 90 | 1 338 | 383 127,19 € | 286,34 € |
| `email_campaign` | 275 | 1 024 | 300 296,85 € | 293,26 € |
| `instagram` | 259 | 877 | 262 112,79 € | 298,87 € |

Peamised järeldused:

- `google_organic` oli suurima käibe ja tellimuste arvuga tuvastatud kanal: 666 444,98 € ja 2 273 tellimust.
- `google_organic` andis 22,91% kogu käibest.
- `facebook_ads` oli tuvastatud kanalitest suurima müügiga kliendi kohta: 1 338,84 €.
- `instagram` oli suurima keskmise tellimusväärtusega kanal: 298,87 €.
- `google_organic`, `facebook_ads` ja `direct` moodustasid kokku ligikaudu 53,5% käibest ja tellimustest.
- Grupp `unknown` ei ole turunduskanal ning selle müüki kliendi kohta ei saa teiste kanalitega võrrelda.

## Oluline JOIN-i kontroll

Otsene ühendamine `sales → customers → web_logs` andis:

| Kontroll | Tulemus |
|---|---:|
| Algne `sales` ridade arv | 10 118 |
| Otsese JOIN-i ridade arv | 121 131 |
| Algne kogukäive | 2 909 177,98 € |
| Otsese JOIN-i kogukäive | 34 527 628,19 € |
| JOIN-is säilinud unikaalseid müüke | 9 130 |

Ühel kliendil võis olla `web_logs` tabelis mitu logirida. Sama müük kordus iga sobiva logirea kohta. Lisaks eemaldas `INNER JOIN customers` müügid, millel ei olnud sobivat kliendikirjet.

Lõplike juhtimisnumbrite jaoks kasutati valideeritud lahendust:

```sql
ROW_NUMBER() OVER (
    PARTITION BY customer_id
    ORDER BY visit_date DESC, log_id DESC
)
```

Igale kliendile jäeti üks viimane teadaolev standardiseeritud kanal. See kõrvaldas JOIN-ist tekkinud müügiridade mitmekordistumise.

## Ajaline areng

Täieliku `sales` koondi põhjal:

| Aasta | Tellimusi | Käive |
|---|---:|---:|
| 2023 | 4 274 | 1 234 758,90 € |
| 2024 | 5 137 | 1 470 358,02 € |
| 2025 | 691 | 199 968,69 € |
| 2026 | 16 | 4 092,37 € |

2024. aastal kasvas tellimuste arv 20,19% ja käive 19,08% võrreldes 2023. aastaga. Suurim kuine kogukäive oli 2024. aasta detsembris: 170 623,28 €.

## Failid

- `W4_GT_D_HT_Turunduskampaaniate efektiivsus.sql` — põhianalüüs, kontrollpäringud ja valideeritud kanaliloogika.
- `W4_GT_D_HT_web_log_table cleaning.sql` — `source` väärtuste standardiseerimine test- ja production-tabelis.
- `kuvatõmmised/` — SQL-päringute tulemused PNG- ja CSV-vormingus.
- `W4_GT_D_HT_DETAILNE_ANALUUS.md` — tulemuste põhjalik analüütiline tõlgendus.
- `W4_GT_D_HT_PRESENTATSIOONI_ALUS.md` — juhtimispresentatsiooni struktuur ja kõnealus.

## Kasutatud SQL-vahendid

`COUNT`, `SUM`, `AVG`, `MIN`, `MAX`, `COUNT(DISTINCT ...)`, `GROUP BY`, `HAVING`, `INNER JOIN`, `LEFT JOIN`, CTE-d, `CASE`, `COALESCE`, `NULLIF`, `DATE_TRUNC`, `ROW_NUMBER` ja `LAG`.

## Tulemuste piirangud

- Kampaaniate kulud puuduvad, mistõttu tegelikku ROI-d ei saa arvutada.
- Kanal seotakse kliendi, mitte konkreetse müügitehinguga.
- Kasutatud atribuutika on „viimane teadaolev kanal kliendi kohta”, mitte turunduslik põhjuslik omistamine.
- `unknown` sisaldab müüke, millele ei olnud võimalik usaldusväärset kanalit määrata.
- `web_logs` andmed lõpevad 28.02.2025, kuid `sales` tabelis on ka hilisemaid kirjeid.
- Kuistes kanalipäringutes kasutatud `HAVING` piir jätab väikese mahuga kanali-kuu kombinatsioonid välja.

## Peamine õppetund

Tehniliselt korrektne SQL-päring ei taga sisuliselt õiget tulemust. Enne agregaatide kasutamist tuleb kontrollida tabelite detailsusastet, JOIN-i kardinaalsust ja referentsväärtusi.

