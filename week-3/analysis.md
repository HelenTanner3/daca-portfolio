# Tulemuste koond — Nädal 3, Roll C: Tooted + inventuur

See fail koondab detailsemad tabelid, mida README-s ei ole mõistlik pikalt dubleerida. Faili saab kasutada grupi koondmaterjalis ja presentatsiooni ettevalmistamisel.

## 1. Peamised kontrolltulemused

| Kontroll | Tulemus | Märkus |
|---|---:|---|
| Müümata tooted | 12 | `products LEFT JOIN sales`, kus `s.sale_id IS NULL` |
| Inventuuri ridu kokku | 1 412 | Toote-asukoha taseme read |
| `TELLI JUURDE` | 221 | Laoseis on tellimispunktist madalam või sellega võrdne |
| `KONTROLLI LAOSEISU` | 10 | Negatiivne laoseis |
| `INVENTUUR PUUDUB` | 12 | Tootel puudub inventuurivaste |
| `VÕIMALIK ÜLEVARU` | 730 | Laoseis vähemalt 3 korda üle tellimispunkti |
| `OK` | 439 | Ei kuulu eelnevatesse tähelepanu vajavatesse gruppidesse |

## 2. Müügianalüüs kategooriate kaupa

| Kategooria | Tooteid | Müüke | Kogumüük |
|---|---:|---:|---:|
| jalanõusid | 73 | 2 031 | 774 034.75 |
| meeste_riided | 82 | 2 266 | 749 798.72 |
| naiste_riided | 70 | 2 022 | 686 464.24 |
| aksessuaarid | 67 | 1 772 | 393 035.82 |
| laste_riided | 70 | 2 027 | 305 844.45 |

## 3. TOP 10 toodet kogumüügi järgi

| Koht | Toode | Kategooria | Alamkategooria | Müüdud kordi | Kogumüük |
|---:|---|---|---|---:|---:|
| 1 | Õhuline sünteetiline sporditossud | jalanõusid | tossud | 35 | 27 347.04 |
| 2 | Trendikas goretex oxfordid | jalanõusid | kingad | 32 | 23 376.15 |
| 3 | Praktiline viskoosne jakk | naiste_riided | jakid | 35 | 22 188.80 |
| 4 | Praktiline džersii seelik | naiste_riided | seelikud | 37 | 22 039.98 |
| 5 | Boheemlaslik puuvillane tuulejope | naiste_riided | jakid | 30 | 21 309.96 |
| 6 | Õhuline sünteetiline kõrge kontsaga kingad | jalanõusid | kontsad | 38 | 21 295.56 |
| 7 | Praktiline kangast kõrge kontsaga kingad | jalanõusid | kontsad | 37 | 21 118.68 |
| 8 | Luksuslik villane pahkluu saapad | jalanõusid | botased | 28 | 19 704.87 |
| 9 | Praktiline merino villane parka | meeste_riided | jakid | 30 | 19 620.45 |
| 10 | Õhuline linane jakk | naiste_riided | jakid | 41 | 19 393.29 |

## 4. Inventuuri staatused kategooriate kaupa

| Kategooria | Inventuur puudub | Kontrolli laoseisu | OK | Telli juurde | Võimalik ülevaru | Kokku |
|---|---:|---:|---:|---:|---:|---:|
| meeste_riided | 1 | 2 | 102 | 56 | 164 | 325 |
| jalanõusid | 2 | 0 | 90 | 48 | 146 | 286 |
| laste_riided | 2 | 2 | 77 | 46 | 147 | 274 |
| naiste_riided | 2 | 4 | 86 | 31 | 151 | 274 |
| aksessuaarid | 5 | 2 | 84 | 40 | 122 | 253 |
| **Kokku** | **12** | **10** | **439** | **221** | **730** | **1 412** |

## 5. Ülevaru kontrolli koond

| Näitaja | Tulemus |
|---|---:|
| Võimaliku ülevaru ridu | 730 |
| Erinevaid tootenimesid | 331 |
| Ridu kordajaga vähemalt 5x | 455 |
| Ridu kordajaga vähemalt 10x | 214 |
| Ridu kordajaga vähemalt 20x | 79 |
| Ridu kordajaga vähemalt 100x | 31 |
| Suurim kordaja | 628.60x |

## 6. Võimalik ülevaru kategooriate kaupa

| Kategooria | Võimaliku ülevaru ridu | Erinevaid tootenimesid | Laoseis kokku | Üle tellimispunkti kokku | Suurim kordaja |
|---|---:|---:|---:|---:|---:|
| meeste_riided | 164 | 78 | 93 102 | 89 092 | 527.53 |
| naiste_riided | 151 | 66 | 57 519 | 53 838 | 448.59 |
| laste_riided | 147 | 64 | 68 641 | 64 950 | 237.81 |
| jalanõusid | 146 | 65 | 78 921 | 75 397 | 628.60 |
| aksessuaarid | 122 | 58 | 43 984 | 40 869 | 231.53 |

## 7. TOP 10 kõige suurema ülevaru kordajaga rida

| Koht | Toode | Kategooria | Asukoht | Laoseis | Tellimispunkt | Üle tellimispunkti | Kordaja |
|---:|---|---|---|---:|---:|---:|---:|
| 1 | Minimalistlik sünteetiline saapad | jalanõusid | ladu | 9 429 | 15 | 9 414 | 628.60 |
| 2 | Õhuline sünteetiline rannasandaalid | jalanõusid | tartu | 9 479 | 17 | 9 462 | 557.59 |
| 3 | Trendikas džersii slim-fit püksid | meeste_riided | ladu | 8 968 | 17 | 8 951 | 527.53 |
| 4 | Stiilne džersii püksid | meeste_riided | ladu | 5 321 | 11 | 5 310 | 483.73 |
| 5 | Soe satiinne pluus | naiste_riided | ladu | 7 626 | 17 | 7 609 | 448.59 |
| 6 | Mugav tweed kardigan | meeste_riided | ladu | 7 029 | 16 | 7 013 | 439.31 |
| 7 | Boheemlaslik goretex kingad | jalanõusid | pärnu | 7 588 | 21 | 7 567 | 361.33 |
| 8 | Kerge satiinne jakk | naiste_riided | tartu | 9 985 | 39 | 9 946 | 256.03 |
| 9 | Õhuline sünteetiline kõrge kontsaga kingad | jalanõusid | tallinn | 6 821 | 27 | 6 794 | 252.63 |
| 10 | Luksuslik villane bleiser | laste_riided | pärnu | 7 372 | 31 | 7 341 | 237.81 |

## 8. Tõlgendus

Inventuuri tulemust ei tohiks tõlgendada automaatse tellimisnimekirjana. Enne otsuseid tuleb eraldi kontrollida:

- negatiivsed laoseisud;
- inventuurivasteta tooted;
- madala laoseisuga read;
- võimaliku ülevaru read;
- toote aktiivsus, hooajalisus ja müügikiirus.

