# Presentatsiooni alusfail — Nädal 3, Roll C: Tooted + inventuur

## 1. Ühe lausega kokkuvõte

Toote-, müügi- ja inventuuriandmete ühendamine näitas, et UrbanStyle’i varude juhtimise probleem on kahesuunaline: osa tooteid vajab juurde tellimist või andmekvaliteedi kontrolli, kuid osa laoseise on võrreldes tellimispunktiga ebaproportsionaalselt suured.

## 2. Analüüsi eesmärk

Minu roll oli kasutada `LEFT JOIN` loogikat, et siduda tootekataloog müügi- ja inventuuriandmetega. Eesmärk oli leida:

- tooted, mida ei ole kunagi müüdud;
- kõige tugevamad tooted ja kategooriad;
- inventuuri read, mis vajavad tähelepanu;
- võimalikud ülevaru juhtumid.

## 3. Peamised arvud

| Näitaja | Tulemus |
|---|---:|
| Müümata tooteid | 12 |
| Inventuuri ridu kokku | 1 412 |
| `TELLI JUURDE` ridu | 221 |
| Negatiivse laoseisuga ridu | 10 |
| Inventuurivasteta ridu | 12 |
| Võimaliku ülevaru ridu | 730 |
| Vähemalt 10x üle tellimispunkti | 214 |
| Vähemalt 100x üle tellimispunkti | 31 |
| Suurim ülevaru kordaja | 628.60x |

## 4. Müügitulemuste koond

| Kategooria | Tooteid | Müüke | Kogumüük |
|---|---:|---:|---:|
| jalanõusid | 73 | 2 031 | 774 034.75 |
| meeste_riided | 82 | 2 266 | 749 798.72 |
| naiste_riided | 70 | 2 022 | 686 464.24 |
| aksessuaarid | 67 | 1 772 | 393 035.82 |
| laste_riided | 70 | 2 027 | 305 844.45 |

**Järeldus:** suurima kogumüügi annab `jalanõusid`, kuid enim müügiridu on kategoorias `meeste_riided`. See eristus on oluline, sest tehingute arv ja müügiväärtus ei näita alati sama pilti.

## 5. Inventuuri staatused

| Staatus | Ridu | Tõlgendus |
|---|---:|---|
| `VÕIMALIK ÜLEVARU` | 730 | Laoseis on vähemalt 3 korda suurem kui tellimispunkt |
| `OK` | 439 | Laoseis ei ole madal, negatiivne, puuduv ega ülevaru kontrolli järgi ekstreemne |
| `TELLI JUURDE` | 221 | Laoseis on tellimispunktist madalam või sellega võrdne |
| `INVENTUUR PUUDUB` | 12 | Tootel puudub inventuurivaste |
| `KONTROLLI LAOSEISU` | 10 | Laoseis on negatiivne |
| **Kokku** | **1 412** | Toote-asukoha taseme inventuuriandmed |

**Järeldus:** inventuuri ei tohiks vaadata ainult `TELLI JUURDE / OK` loogikas. Negatiivsed laoseisud, inventuurivasteta tooted ja võimalik ülevaru vajavad eraldi käsitlemist.

## 6. Võimalik ülevaru kategooriate kaupa

| Kategooria | Võimaliku ülevaru ridu | Erinevaid tootenimesid | Laoseis kokku | Üle tellimispunkti kokku | Suurim kordaja |
|---|---:|---:|---:|---:|---:|
| meeste_riided | 164 | 78 | 93 102 | 89 092 | 527.53 |
| naiste_riided | 151 | 66 | 57 519 | 53 838 | 448.59 |
| laste_riided | 147 | 64 | 68 641 | 64 950 | 237.81 |
| jalanõusid | 146 | 65 | 78 921 | 75 397 | 628.60 |
| aksessuaarid | 122 | 58 | 43 984 | 40 869 | 231.53 |

**Järeldus:** ülevaru risk ei paikne ainult ühes kategoorias. Kõigis põhikategooriates on ridu, kus laoseis on tellimispunktiga võrreldes väga suur.

## 7. Suurim üllatus

Suurim üllatus oli ülevaru ulatus. Enne inventuuri täpsustatud kontrolli oleks võinud arvata, et põhiküsimus on juurde tellimises. Tegelikult näitas analüüs, et andmetes on ka väga suuri laoseise, mis võivad siduda kapitali ja viidata aeglasele käibele, hooajalisusele või andmeprobleemile.

## 8. Soovitus Toomasele

Toomas peaks jagama inventuuri kontrolli neljaks eraldi töövooguks:

1. **Andmekvaliteet:** negatiivsed laoseisud ja inventuurivasteta tooted.
2. **Puudujääk:** `TELLI JUURDE` read, eriti tugeva müügiga kategooriates.
3. **Ülevaru:** read, kus laoseis on vähemalt 3 korda üle tellimispunkti, eraldi kontrolliga 10x ja 100x juhtumitele.
4. **Sortiment:** müümata tooted ja võimalikud fantoomtooted.

## 9. Soovitus Annale

Anna peaks sortimendi juhtimisel eristama:

- müümata tooted, mida ei tohiks enne ärilist kontrolli kustutada;
- tugeva müügiga kategooriad, eriti `jalanõusid` ja `meeste_riided`;
- kõrge laoseisuga tooted, mille müügikiirus ja hooajalisus vajavad kontrolli.

## 10. Lühike kõnetekst esitluseks

Minu analüüs ühendas tooted müügi- ja inventuuriandmetega. `LEFT JOIN` abil leidsin 12 toodet, mida müügitabelis ei esine. Müügi poolelt andsid suurima kogumüügi jalanõud, samas kui meeste riietel oli kõige rohkem müügiridu.

Inventuuri poolelt oli kõige olulisem leid see, et probleem ei ole ainult juurde tellimises. Lisaks 221 `TELLI JUURDE` reale tuli välja 10 negatiivset laoseisu, 12 inventuurivasteta rida ja 730 võimalikku ülevaru rida. See tähendab, et UrbanStyle peaks enne automaatseid tellimisotsuseid kontrollima nii andmekvaliteeti kui ka võimalikke ülevaru juhtumeid.


## Demo jaoks üks lause

Inventuurianalüüs näitas, et UrbanStyle’i varude probleem on kahesuunaline: osa tooteid vajab juurde tellimist või andmekvaliteedi kontrolli, kuid samal ajal on suur osa laoseise tellimispunktiga võrreldes ebaproportsionaalselt kõrged.
