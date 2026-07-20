# Nädal 1 detailne analüüs: müügiandmete uurimine

## 1. Analüüsi eesmärk

Analüüsi eesmärk oli saada esmane ülevaade UrbanStyle.ltd `sales` tabelist ja hinnata, millised andmekvaliteedi riskid vajavad tähelepanu enne andmete kasutamist ärianalüüsis ja aruandluses.

Fookuses olid järgmised küsimused:

- kui suur on müügiandmestik ja milliseid välju see sisaldab;
- millised on suurimad ja väikseimad tehingud;
- kas müügisummades esineb negatiivseid, null- või puuduvaid väärtusi;
- kui paljudel tehingutel puudub kliendiseos;
- kas andmetes leidub tuleviku kuupäevaga tehinguid.

## 2. Andmed ja töövahendid

- **Andmebaas:** Supabase / PostgreSQL
- **Tabel:** `sales`
- **Analüüsitud ridu:** 15 234
- **Põhiartefakt:** [`week1_role_a_sales_exploration.sql`](week1_role_a_sales_exploration.sql)

Tabelis olid muu hulgas väljad `id`, `sale_id`, `invoice_id`, `sale_date`, `customer_id`, `product_id`, `quantity`, `unit_price`, `total_price`, `channel`, `store_location` ja `payment_method`.

SQL-päringud ja kuvatõmmised pärinevad töö tegemise ajast. Portfoolio korrastamisel muudeti failide nimesid ja dokumentatsiooni struktuuri, kuid analüüsi tulemusi tagantjärele ei arvutatud ümber.

## 3. Analüüsi käik

Analüüs koosnes kaheksast etapist:

1. tabeli ridade arvu kontroll;
2. tabeli struktuuri ja näidisridade vaatamine;
3. kogu andmestiku kümne suurima tehingu leidmine;
4. Tallinna kaupluse kümne suurima tehingu leidmine;
5. negatiivsete, null- ja puuduva summaga tehingute kontroll;
6. puuduva `customer_id` väärtusega tehingute loendamine;
7. tuleviku kuupäevaga tehingute kontroll;
8. peamiste kvaliteedinäitajate koondamine üheks päringuks.

## 4. Tulemused

### 4.1. Tabeli maht ja struktuur

`sales` tabelis oli **15 234 rida**. Näidisridade kontroll kinnitas, et tabel sisaldab tehingu, kliendi, toote, summa, kuupäeva, müügikanali, kaupluse ja makseviisi välju.

Tabeli maht võimaldab teha esmaseid analüüse, kuid ridade arv üksi ei näita, kas kõik kirjed on unikaalsed ja äriliselt korrektsed.

**Tõendusmaterjal:**

- [01 — tabeli ridade arv](screenshots/01_sales_row_count.png)
- [02 — tabeli struktuur](screenshots/02_sales_table_structure.png)

### 4.2. Suurimad tehingud

Kogu andmestiku kümne suurima tehingu summad jäid vahemikku **1 858,95–2 170,40 eurot**. Nende väärtuste põhjal ei ilmnenud üksnes summat vaadates selgelt ebarealistlikku äärmusväärtust.

Tallinna kaupluse kümne suurima tehingu summad jäid kuvatõmmise järgi vahemikku **1 544,20–1 872,70 eurot**. Tallinna suurim tehing oli seega väiksem kui kogu andmestiku suurim tehing.

**Kontrollmärkus:** SQL-faili Tallinna päringu tulemuse kommentaaris on ekslikult korratud kogu andmestiku vahemikku **1 858,95–2 170,40 eurot**. Päring ise filtreerib Tallinna tehingud korrektselt ning käesolev analüüs lähtub kuvatõmmisel nähtavast tulemusest. Ajaloolist SQL-faili dokumentatsiooni korrastamisel ei muudeta.

**Tõendusmaterjal:**

- [03 — kogu andmestiku suurimad tehingud](screenshots/03_largest_sales_transactions.png)
- [04 — Tallinna kaupluse suurimad tehingud](screenshots/04_largest_tallinn_store_transactions.png)

### 4.3. Negatiivsed, null- ja puuduvad müügisummad

Kontrollpäring leidis **305 negatiivse summaga tehingut**, mis moodustasid ligikaudu **2,0%** kõigist müügiridadest.

- negatiivsete summade vahemik: **−1 405,32 kuni −16,37 eurot**;
- negatiivsete tehingute koguväärtus: **−88 632,61 eurot**;
- nullsummaga tehinguid ei leitud;
- puuduva `total_price` väärtusega tehinguid ei leitud.

Negatiivseid summasid ei saa ilma ärireeglite ja tehinguliigi infota automaatselt vigadeks lugeda. Need võivad tähistada tagastusi, kreeditarveid või paranduskandeid, kuid võivad olla ka sisestusvead. Nende tähendus tuleb enne käibearuandlust määratleda.

**Tõendusmaterjal:**

- [05 — mittepositiivsete summade detail](screenshots/05_non_positive_transactions.png)
- [06 — negatiivsete tehingute koond](screenshots/06_negative_transactions_summary.png)

### 4.4. Puuduvad kliendiseosed

**1 487 tehingul** puudus `customer_id`. See moodustas ligikaudu **9,8%** kõigist müügiridadest.

Puuduv kliendiseos ei välista tehingu summa kasutamist üldises müügianalüüsis, kuid vähendab kliendipõhise analüüsi täielikkust. Sellised read võivad jääda välja klientide segmentatsioonist, kordusostude analüüsist ja kliendi eluea väärtuse arvutusest.

**Tõendusmaterjal:**

- [07 — puuduvad kliendi ID-d](screenshots/07_missing_customer_ids.png)

### 4.5. Tuleviku kuupäevaga tehingud

Analüüsi tegemise ajal leiti **2 tehingut**, mille `sale_date` oli suurem kui päringu käivitamise kuupäev.

Tuleviku kuupäevaga müük võib moonutada perioodipõhiseid aruandeid ja trende. Kirjed vajavad algallika või sisestusloogika kontrolli.

**Tõendusmaterjal:**

- [08 — tuleviku kuupäevaga tehingud](screenshots/08_future_dated_transactions.png)

### 4.6. Koondülevaade

Koondpäringu tulemus oli järgmine:

| Näitaja | Tulemus |
|---|---:|
| Müügiridu kokku | 15 234 |
| Puuduva `customer_id` väärtusega ridu | 1 487 |
| Negatiivse summaga ridu | 305 |
| Tuleviku kuupäevaga ridu | 2 |
| Väikseim `total_price` | −1 405,32 € |
| Suurim `total_price` | 2 170,40 € |
| `total_price` toorsumma | 4 374 231,27 € |

`total_price` summa kirjeldab töötlemata tabeli ridade koguväärtust. Seda ei tohiks esitada kontrollitud käibena enne võimalike duplikaatide ja negatiivsete tehingute ärilise käsitluse täpsustamist.

**Tõendusmaterjal:**

- [09 — andmekvaliteedi koondülevaade](screenshots/09_sales_quality_summary.png)

## 5. Peamised andmekvaliteedi riskid

| Risk | Täheldatud tulemus | Võimalik mõju |
|---|---:|---|
| Negatiivsed tehingud | 305 rida; −88 632,61 € | Käibe ja keskmiste näitajate tõlgendus sõltub tehingute sisust |
| Puuduv `customer_id` | 1 487 rida; ~9,8% | Kliendipõhised analüüsid jäävad osaliselt puudulikuks |
| Tuleviku kuupäevad | 2 rida | Perioodiaruanded ja trendid võivad olla moonutatud |
| Võimalikud korduvad tehingud | eraldi duplikaadikontrolli ei tehtud | Toorsummad ja tehingute arv võivad olla üle hinnatud |

## 6. Piirangud ja eeldused

- Analüüs tehti puhastamata `sales` tabelil.
- Nädal 1 Roll A töö ei sisaldanud eraldi duplikaatide kvantifitseerimist ega eemaldamist.
- Negatiivsete tehingute liik ei olnud andmetes üheselt määratletud.
- Päring `sale_date > CURRENT_DATE` sõltub käivitamise kuupäevast. Käesolevas dokumendis on säilitatud töö tegemise ajal saadud tulemus.
- Analüüs ei kasutanud JOIN-päringuid ega kontrollinud kliendi- ja tootevõtmete vasteid teistes tabelites.
- Tulemused kirjeldavad toorandmestikku ega ole veel lõplikud juhtimisaruandluse KPI-d.

## 7. Järeldus ja soovitused

`sales` tabel annab piisava aluse andmestiku esmaseks uurimiseks, kuid enne usaldusväärsete juhtimisnäitajate koostamist on vaja:

1. määratleda, kas negatiivsed tehingud on tagastused, kreeditarved või vead;
2. kontrollida ja vajaduse korral parandada tuleviku kuupäevaga kirjed;
3. hinnata puuduva `customer_id` mõju kliendianalüüsidele;
4. kontrollida tehingute unikaalsust kokkulepitud ärivõtme, näiteks `sale_id` või `invoice_id`, alusel;
5. eristada toorandmete koguväärtus kontrollitud käibenäitajast.

Analüüsi peamine õppetund oli, et tehniliselt töötav päring ei muuda tulemust automaatselt äriliselt usaldusväärseks. Enne järelduste tegemist tuleb mõista väljade tähendust, kontrollida andmekvaliteeti ja määratleda arvutusreeglid.