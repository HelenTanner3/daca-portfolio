# Nädal 3: Tooted + inventuur — LEFT JOIN analüüs

**Roll:** C — Tooted + Inventuur  
**Fookus:** `products`, `sales`, `inventory`  
**Teema:** SQL JOIN-id, toote- ja laoseisuandmete äriline kontroll

## Projekti kontekst

UrbanStyle’i näidisandmestikus analüüsisin toodete, müügi ja inventuuri seoseid. Peamine eesmärk oli kontrollida, kas tootekataloogis olevad tooted on tegelikult müüki tekitanud ning kas laoseis toetab ärilisi otsuseid.

Analüüs vastab kolmele põhiküsimusele:

1. Millised tooted on kataloogis olemas, kuid ei ole müügitabelis kordagi esinenud?
2. Millised tooted ja kategooriad annavad suurima müügitulemuse?
3. Millised inventuuriandmed vajavad tähelepanu: madal laoseis, negatiivne laoseis, puuduv inventuurivaste või võimalik ülevaru?

## Kasutatud tabelid

| Tabel | Roll analüüsis |
|---|---|
| `products` | Tootekataloog: tootenimi, kategooria, alamkategooria, jaehind |
| `sales` | Müügitehingud: müügi ID, toote ID, kogus, müügisumma |
| `inventory` | Laoseis: asukoht, saadaolev kogus, tellimispunkt |

## Kasutatud SQL-loogika

Analüüsis kasutasin järgmisi SQL-võtteid:

- `LEFT JOIN` — toodete säilitamiseks ka siis, kui müügi- või inventuurivastet ei ole;
- `INNER JOIN` — ainult tegelikult müüdud toodete müügitulemuse vaatamiseks;
- `COUNT`, `COUNT(DISTINCT ...)`, `SUM`, `AVG` — mahtude ja müügitulemuste koondamiseks;
- `GROUP BY` — tulemuste koondamiseks toote ja kategooria tasemel;
- `CASE WHEN` — inventuuri staatuse määramiseks;
- `NULLIF` — jagamisel nulliga seotud vea vältimiseks ülevaru kordaja arvutamisel;
- `ORDER BY` ja `LIMIT` — olulisemate tulemuste esiletoomiseks.

## Peamised leiud

| Leid | Tulemus |
|---|---:|
| Müümata tooteid | 12 |
| Suurima kogumüügiga kategooria | `jalanõusid` |
| Kõige rohkem müügiridu | `meeste_riided` |
| Inventuuri ridu kokku | 1 412 |
| `TELLI JUURDE` ridu | 221 |
| Negatiivse laoseisuga ridu | 10 |
| Inventuurivasteta ridu | 12 |
| Võimaliku ülevaru ridu | 730 |

Peamine äriline järeldus on, et inventuuri probleem ei ole ainult puudujääkides. Andmetes esineb korraga madalat laoseisu, negatiivset laoseisu, inventuurivasteta tooteid ja väga suuri laoseise võrreldes tellimispunktiga.

## Müümata tooted

`LEFT JOIN` abil tuvastasin **12 toodet**, millel puudub vaste müügitabelis. Need tooted võivad olla aktiivseks müügiks avamata, lõpetatud, testandmed või andmeimpordi käigus tekkinud fantoomkirjed.

Neid tooteid ei tohiks automaatselt kustutada. Enne tuleks kontrollida toote ärilist staatust ja seda, kas toode peaks üldse olema aktiivses kataloogis.

## Müügitulemused

TOP 10 müüdud toodete analüüs näitas, et suurima müügitulemusega toodete seas domineerivad **jalanõud** ja **naiste riided**. Kategooriate lõikes oli suurima kogumüügiga kategooria `jalanõusid`, samas kui `meeste_riided` andis kõige rohkem müügiridu.

See tähendab, et sortimendi hindamisel ei piisa ainult müügikordade vaatamisest. Eraldi tuleb vaadata ka müügiväärtust ja kategooriate panust kogukäibesse.

## Inventuuri täpsustatud kontroll

Algne inventuuriloogika `TELLI JUURDE / OK` oli esmane kontroll, kuid sellest ei piisanud kõigi äriliste olukordade eristamiseks. Täpsustatud loogikas eristasin järgmised seisundid:

| Staatus | Tähendus |
|---|---|
| `INVENTUUR PUUDUB` | Tootel puudub inventuuritabelis vaste |
| `KONTROLLI LAOSEISU` | Laoseis on negatiivne ja vajab andmekvaliteedi kontrolli |
| `TELLI JUURDE` | Laoseis on tellimispunktist madalam või sellega võrdne |
| `VÕIMALIK ÜLEVARU` | Laoseis on vähemalt 3 korda üle tellimispunkti |
| `OK` | Laoseis ei kuulu eelnevatesse tähelepanu vajavatesse gruppidesse |

`reorder_point` ei tähenda maksimaalset lubatud laoseisu, vaid tellimispunkti. Seetõttu on `VÕIMALIK ÜLEVARU` analüütiline riskimärgis, mitte lõplik tõend ülevaru kohta.

## Suurim üllatus

Suurim üllatus oli see, et inventuuriandmed näitasid kahesuunalist probleemi. Osa toodetest vajab juurde tellimist või andmekvaliteedi kontrolli, kuid samal ajal on suur hulk ridu võimaliku ülevaru tunnustega. See tähendab, et UrbanStyle’i risk ei ole ainult müügikaotus liiga väikese laoseisu tõttu, vaid ka kapitali sidumine liiga suurtes varudes.

## Soovitus Toomasele ja Annale

**Toomasele:** enne automaatsete tellimisotsuste tegemist tuleks inventuuriandmed jagada eraldi töövoogudeks: negatiivsed laoseisud, puuduvad inventuurivasted, juurde tellimist vajavad read ja võimalik ülevaru.

**Annale:** sortimendi juhtimisel tuleks eraldi vaadata müümata tooteid, tugeva müügiga kategooriaid ja neid tooteid, millel on suur laoseis, kuid mille müügipanus vajab täiendavat kontrolli.

## Puuduvad andmed

Analüüsi täpsustamiseks oleks vaja järgmisi andmeid:

- kas toode on aktiivne, lõpetatud, hooajaline või testtoode;
- toote kataloogi lisamise kuupäev;
- ostutellimused ja juba teel olevad kogused;
- toote omahind ja tegelik marginaal;
- toote müügikiirus ja viimase müügi kuupäev;
- laoliikumiste ajalugu;
- tarnija ja tarneaeg;
- miinimum- ja maksimumvaru poliitika;
- kampaaniate või allahindluste info.

## Failid

Allolevad lingid viitavad minu isikliku portfoolio `week-3` kaustale:

| Fail | Sisu |
|---|---|
| [W3_GT_C_HT_Tooted + Inventuur (LEFT JOIN).sql](https://github.com/HelenTanner3/daca-portfolio/blob/main/week-3/W3_GT_C_HT_Tooted%20%2B%20Inventuur%20%28LEFT%20JOIN%29.sql) | SQL-päringud toodete, müügi ja inventuuri analüüsiks |
| [W3_GT_C_HT_Kokkuvõte_Presentatsioon.md](https://github.com/HelenTanner3/daca-portfolio/blob/main/week-3/W3_GT_C_HT_Kokkuv%C3%B5te_Presentatsioon.md) | Lühike presentatsiooni alusfail |
| [W3_GT_C_HT_Tulemuste_koond.md](https://github.com/HelenTanner3/daca-portfolio/blob/main/week-3/W3_GT_C_HT_Tulemuste_koond.md) | Koondtabelid ja detailsemad tulemused |
| [kuvatõmmised/](https://github.com/HelenTanner3/daca-portfolio/tree/main/week-3/kuvat%C3%B5mmised) | SQL-päringute tulemuste kuvatõmmised ja detailtabelid |

## Kokkuvõte

Toote- ja inventuuriandmete ühendamine näitas, et UrbanStyle’il on korraga sortimendi-, andmekvaliteedi- ja varude planeerimise küsimused. Müügianalüüs tõi esile tugevad kategooriad, eriti jalanõud ja meeste riided. Inventuurianalüüs näitas aga, et lisaks juurde tellimist vajavatele toodetele tuleb kontrollida ka negatiivseid laoseise, inventuurivasteta tooteid ja võimalikku ülevaru.
