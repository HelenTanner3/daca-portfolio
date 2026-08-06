# Week 7 RFM grupitöö — analüütiline õppejuhend

## Juhendi eesmärk

See fail selgitab UrbanStyle'i nädala 7 grupitöö terviklikku töövoogu:

```text
Roll A — andmete laadimine ja ühendamine
Roll B — andmete puhastamine
Roll C — RFM-arvutused ja kliendisegmendid
Roll D — visualiseerimine ja äritõlgendus
```

Juhendi keskne küsimus ei ole ainult **mida kood teeb**, vaid ka:

- miks konkreetset käsku kasutati;
- millise sisendi see vajab;
- millise väljundi see loob;
- kuidas järgmine roll seda väljundit kasutab;
- millised kontrollid kinnitavad, et tulemus on usaldusväärne;
- millised kohad vajavad veel parandamist või selgitamist.

## Aluseks olev grupifail

Juhend põhineb grupireposse kinnitatud failil:

```text
week-7/group/urbanstyle_operatsioonid_week7_(a_b_c_d).ipynb
```

Praeguses kinnitatud versioonis:

- Roll A on rakendatud ja käivitatud;
- Roll B on rakendatud ja käivitatud;
- Roll C on rakendatud ja käivitatud;
- Roll D jaoks on lisatud tööstruktuur, kuid visualiseerimise koodi veel ei ole.

Seetõttu käsitleb see juhend Roll D osa kui **planeeritud järgmist sammu**, mitte valmis tulemust.

---

# 1. Terviklik andmevoog

```text
Supabase
   ↓
sales + customers
   ↓
pandas DataFrame'id
   ↓
LEFT merge customer_id alusel
   ↓
puhastatud df
   ↓
Recency + Frequency + Monetary
   ↓
RFM-skoorid
   ↓
kliendisegmendid
   ↓
rfm DataFrame + rfm_segments.csv
   ↓
visualiseeringud ja soovitused
```

## Rollide omavaheline sõltuvus

| Roll | Sisend | Põhitegevus | Väljund | Kes kasutab edasi? |
|---|---|---|---|---|
| A | Supabase või CSV | laadimine, kontroll, `merge` | `df_sales`, `df_customers`, ühendatud `df` | Roll B |
| B | Roll A `df` | duplikaadid, NULL-id, tüübid, hinnad | puhastatud `df` | Roll C |
| C | Roll B `df` | RFM, skoorid, segmendid | `rfm`, `rfm_segments.csv` | Roll D |
| D | Roll C `rfm` | diagrammid, KPI-d, tõlgendus | visuaalid ja tegevussoovitused | Marko / turundus |

Kõige olulisem tehniline põhimõte on, et sama muutujanimi `df` liigub Roll A-st Roll B-sse ja Roll B-st Roll C-sse. Kui eelmine roll muudab nime või veerge, ei tööta järgmine osa automaatselt.

---

# 2. Roll A — andmete laadimine ja ühendamine

**Vastutaja: Natalia**

## 2.1. Roll A eesmärk

Roll A loob ühenduse grupi Supabase'iga, laadib vajalikud tabelid pandas DataFrame'idesse ning ühendab müügi- ja kliendiandmed.

Roll A väljund peab vastama küsimustele:

1. Kas ühendus töötab?
2. Kas kõik read laeti?
3. Kas tabelites on vajalikud veerud?
4. Kas `customer_id` alusel ühendamine säilitas müügiread?
5. Kas Roll B saab kasutada ühte ühendatud DataFrame'i nimega `df`?

## 2.2. Teekide import

```python
import os
import pandas as pd
from dotenv import load_dotenv, find_dotenv
from supabase import create_client
```

| Käsk | Miks seda kasutatakse? |
|---|---|
| `import os` | loeb keskkonnamuutujaid |
| `import pandas as pd` | loob ja töötleb DataFrame'e |
| `load_dotenv`, `find_dotenv` | leiavad ning laadivad lokaalse `.env` faili |
| `create_client` | loob Supabase'i Pythoni kliendi |

## 2.3. `.env` laadimine

```python
load_dotenv(find_dotenv())

url = os.getenv("SUPABASE_URL")
key = os.getenv("SUPABASE_KEY")
```

### Miks?

Supabase'i URL-i ja võtit ei kirjutata notebook'i sisse. Need jäävad lokaalsesse `.env` faili ega lähe GitHubi.

### Tulemus

Muutujad `url` ja `key` sisaldavad ühenduse loomiseks vajalikke väärtusi.

### Kontroll

Turvaline kontroll:

```python
print("URL olemas:", bool(url))
print("KEY olemas:", bool(key))
```

Tegelikku võtit ei tohi välja printida.

## 2.4. `get_data()` funktsioon

```python
def get_data(tabel_name):
    data = []
    page_size = 1000
    page = 0

    while True:
        response = (
            supabase
            .table(tabel_name)
            .select("*")
            .range(
                page * page_size,
                (page + 1) * page_size - 1
            )
            .execute()
        )

        data.extend(response.data)

        if len(response.data) < page_size:
            break

        page += 1

    return pd.DataFrame(data)
```

### Miks funktsiooni vaja on?

Supabase'i API tagastab selles töövoos ühe päringuga kuni 1000 rida. UrbanStyle'i `sales` tabelis on üle 10 000 rea. Üks lihtne päring annaks ainult esimese osa andmetest.

Funktsioon:

1. küsib read 1000 kaupa;
2. lisab need ühisesse loendisse;
3. lõpetab, kui viimane päring tagastab alla 1000 rea;
4. muudab kogutud read DataFrame'iks.

### Olulised käsud

| Käsk | Otstarve |
|---|---|
| `.table(tabel_name)` | valib Supabase'i tabeli |
| `.select("*")` | küsib kõik veerud |
| `.range(0, 999)` | määrab laaditavate ridade vahemiku |
| `.execute()` | käivitab päringu |
| `data.extend(...)` | lisab uued read eelmistele |
| `break` | lõpetab tsükli |
| `pd.DataFrame(data)` | loob pandas DataFrame'i |

## 2.5. `try` ja `except`

```python
try:
    supabase = create_client(url, key)
    df_sales = get_data("sales")
    df_customers = get_data("customers")

except Exception as e:
    df_sales = pd.read_csv("sales.csv")
    df_customers = pd.read_csv("customers.csv")
```

### Miks?

`try` proovib ametlikust andmeallikast laadida. `except` võimaldab analüüsi jätkata CSV-failidega, kui Supabase ei tööta.

### Risk

`except Exception` püüab kinni kõik vead, mitte ainult ühendusvea. See võib peita näiteks:

- vale tabelinime;
- puuduva veeru;
- vigase `.env` faili;
- programmeerimisvea.

Samuti töötab CSV-varuvariant ainult siis, kui `sales.csv` ja `customers.csv` asuvad notebook'i aktiivses töökataloogis.

### Õppejäreldus

Fallback on kasulik õppimise jätkamiseks, kuid vea põhjus tuleb alati välja lugeda muutujast `e`. Ametlikus grupitöös peab olema dokumenteeritud, millisest allikast lõpptulemus tegelikult saadi.

## 2.6. Laadimine

```python
df_sales = get_data("sales")
df_customers = get_data("customers")
```

Funktsioon defineeritakse üks kord ja käivitatakse iga tabeli jaoks eraldi.

## 2.7. Kontrollid

```python
print(df_sales.shape)
print(df_sales.head())

print(df_customers.shape)
print(df_customers.head())
```

### Miks?

- `shape` kontrollib ridade ja veergude arvu;
- `head()` näitab, kas väljad ja väärtused näevad mõistlikud välja.

Kontrollitud tulemused:

| Tabel | Ridu | Veerge |
|---|---:|---:|
| `sales` | 10 118 | 12 |
| `customers` | 3 150 | 9 |

## 2.8. Tabelite ühendamine

```python
df = pd.merge(
    df_sales,
    df_customers,
    on="customer_id",
    how="left"
)
```

### Miks kasutatakse `left` merge'i?

Müügitabel on põhialus. Kõik müügiread tuleb säilitada ka siis, kui mõnel müügil puudub kliendi ID või klienditabelis pole vastet.

Seos SQL-iga:

```text
pandas merge(..., how="left")
=
SQL LEFT JOIN
```

### Tulemus

```text
df shape: (10118, 20)
```

Müügiridade arv jäi samaks. See kinnitab, et ühendamine ei kaotanud ega paljundanud ridu.

## 2.9. Ühendatud DataFrame'i kontroll

```python
print(df.dtypes)
print(df.head())
df.info()
```

| Käsk | Mida kontrollib? |
|---|---|
| `dtypes` | iga veeru andmetüüp |
| `head()` | esimesed read |
| `info()` | ridade arv, veerud, tüübid ja mitte-NULL väärtused |
| `pd.set_option(...)` | kuvab notebook'is rohkem veerge |

### Roll A väljund

Roll A annab Roll B-le:

```python
df
```

See sisaldab 10 118 müügirida ja 20 veergu.

---

# 3. Roll B — andmete puhastamine

**Vastutaja: Olga**

## 3.1. Roll B eesmärk

Roll B eemaldab või parandab read, mida ei saa kliendipõhises RFM-analüüsis kasutada.

RFM vajab vähemalt:

- `customer_id`;
- `sale_date`;
- `sale_id`;
- `total_price`.

## 3.2. Algmahu kontroll

```python
print(df.shape)
```

Algmaht:

```text
(10118, 20)
```

See on Roll A ja Roll B vaheline kontrollväärtus.

## 3.3. Duplikaatide kontroll

```python
df.duplicated(subset=["invoice_id"]).sum()
```

### Miks?

Kontrollitakse, kas sama arve ID esineb mitu korda.

Tulemus:

```text
0
```

Seetõttu ei eemaldatud praeguses andmestikus duplikaatide tõttu ridu.

### Metoodiline märkus

See kontrollib korduvat `invoice_id`, mitte täielikult identseid ridu.

Täisrea kontroll oleks:

```python
df.duplicated().sum()
```

Need kaks küsimust ei ole samad:

- kas sama arve ID kordub;
- kas kogu rida on täpselt dubleeritud.

## 3.4. Duplikaatide eemaldamine

```python
df = df.drop_duplicates(
    subset=["invoice_id"],
    keep="first"
)
```

### Miks?

Kui sama `invoice_id` korduks, säilitataks esimene rida.

### Risk

Kui üks arve võib sisaldada mitut täiesti korrektset tooterida, võib ainult `invoice_id` järgi eemaldamine kustutada päris müügiread. Selle andmestiku puhul leiti 0 korduvat arve ID-d, seega käsk tulemust ei muutnud.

## 3.5. Puuduvate väärtuste kontroll

```python
df.isnull().sum()
```

### Miks?

Näitab iga veeru kohta, mitu väärtust puudub.

RFM seisukohalt on kriitilised:

- puuduv `customer_id` — tehingut ei saa kliendiga siduda;
- puuduv `sale_date` — Recency't ei saa arvutada;
- puuduv `total_price` — Monetary't ei saa arvutada.

## 3.6. Kriitiliste NULL-ridade eemaldamine

```python
df = df.dropna(
    subset=[
        "customer_id",
        "sale_date",
        "total_price"
    ]
)
```

### Miks?

Need read ei ole RFM-i jaoks arvutatavad.

## 3.7. Kuupäeva teisendamine

```python
df["sale_date"] = pd.to_datetime(
    df["sale_date"]
)
```

### Miks?

Supabase'ist võib kuupäev saabuda tekstina. Recency arvutamiseks peab `sale_date` olema kuupäeva- või ajatüüp.

## 3.8. Positiivsete müükide jätmine

```python
df = df[
    df["total_price"] > 0
]
```

### Miks?

RFM-i Monetary osa peab selles juhendipõhises töövoos kirjeldama positiivset ostuväärtust. Negatiivsed summad võivad tähendada tagastusi või paranduskandeid ning vajaksid eraldi äriloogikat.

## 3.9. Puhastusraport

```python
print(df.shape)
print(df["customer_id"].nunique())
print(df["sale_date"].min())
print(df["sale_date"].max())
```

Kontrollitud väljund:

| Näitaja | Tulemus |
|---|---:|
| puhastatud ridu | 8 950 |
| unikaalseid kliente | 2 540 |
| minimaalne kuupäev | 2023-01-01 |
| maksimaalne kuupäev | 2026-06-28 |

## 3.10. Roll B väljund

Roll B annab Roll C-le edasi sama nimega, kuid puhastatud DataFrame'i:

```python
df
```

Oluline on mõista, et Roll B kirjutab Roll A `df` muutuja üle. Pärast puhastamist tähendab `df` juba 8 950 reaga andmestikku.

## 3.11. Praeguse Roll B osa arengukohad

1. `print(df.shape)` esineb eraldi ja seejärel puhastusraportis uuesti.
2. `head()`, `dtypes` ja `info()` kontrollid korduvad.
3. Lahter `1 + 1` on tehniline test ega kuulu analüütilisse töövoogu.
4. Duplikaatide küsimus vajab ärilist definitsiooni: arve, müügirida või täisrida.
5. Puhastusraportis võiks eraldi näidata, mitu rida eemaldati iga põhjuse tõttu.

---

# 4. Roll C — RFM-analüüs

**Vastutaja: Helen**

## 4.1. Roll C eesmärk

Roll C muudab tehinguread kliendipõhiseks tabeliks.

Iga kliendi kohta arvutatakse:

- **Recency** — mitu päeva on möödunud viimasest ostust;
- **Frequency** — mitu ostu on klient teinud;
- **Monetary** — kui suur on kliendi kogukulutus.

## 4.2. Sisendi kontroll

```python
df.head()
```

See kinnitab, et Roll B `df` on olemas.

Vajalikud veerud:

```text
customer_id
sale_date
sale_id
total_price
```

## 4.3. Viitekuupäev

```python
today = pd.to_datetime("2025-02-28")
```

### Miks?

See kuupäev on Week 7 juhendis ette antud ja seetõttu kasutati seda ametlikus Roll C töövoos.

### Piirang

Andmed ulatuvad 2026-06-28-ni. Seetõttu on 25 kliendil negatiivne `recency_days`.

See ei ole koodiviga, vaid juhendis fikseeritud kuupäeva ja tegeliku andmevahemiku vastuolu. Põhivoo kuupäeva ei tohiks vaikimisi muuta; alternatiivne viitekuupäev oleks eraldi tundlikkusanalüüs.

## 4.4. Recency

```python
recency = (
    df.groupby("customer_id")["sale_date"]
    .max()
    .reset_index()
)
```

### Miks?

- `groupby("customer_id")` moodustab iga kliendi jaoks grupi;
- `max()` leiab kliendi viimase ostukuupäeva;
- `reset_index()` muudab tulemuse tavaliseks DataFrame'iks.

```python
recency["recency_days"] = (
    today - recency["last_purchase_date"]
).dt.days
```

Kuupäevade vahe teisendatakse päevade arvuks.

## 4.5. Frequency

```python
frequency = (
    df.groupby("customer_id")["sale_id"]
    .count()
    .reset_index()
)
```

### Miks?

Loendatakse kliendi müügiridade arv.

### Metoodiline piirang

Praeguse koodi järgi tähendab Frequency `sale_id` ridade arvu. Kui üks tellimus sisaldaks tulevikus mitut müügirida, tuleks otsustada, kas kasutada:

```python
.count()
```

või unikaalsete arvete/tellimuste arvu.

## 4.6. Monetary

```python
monetary = (
    df.groupby("customer_id")["total_price"]
    .sum()
    .reset_index()
)
```

### Miks?

Liidetakse kliendi kõik positiivsed ostusummad.

Monetary kirjeldab müügitulu, mitte:

- kasumit;
- marginaali;
- kliendi teeninduskulu;
- kampaania tasuvust.

## 4.7. RFM-tabeli ühendamine

```python
rfm = (
    recency[["customer_id", "recency_days"]]
    .merge(frequency, on="customer_id")
    .merge(monetary, on="customer_id")
)
```

### Miks?

Kolm kliendipõhist arvutust koondatakse üheks tabeliks.

Tulemus:

```text
2 540 klienti
```

Iga klient esineb ühe reaga.

## 4.8. Kvintiilid ja skoorid

```python
rfm["R_score"] = pd.qcut(
    rfm["recency_days"],
    5,
    labels=[5, 4, 3, 2, 1]
)
```

### Miks on Recency sildid vastupidises järjekorras?

Väiksem Recency on parem. Hiljuti ostnud klient peab saama suurema skoori.

```python
rfm["F_score"] = pd.qcut(
    rfm["frequency"].rank(method="first"),
    5,
    labels=[1, 2, 3, 4, 5]
)
```

### Miks kasutatakse enne Frequency't `rank()`?

Paljudel klientidel võib olla sama ostude arv. `qcut()` võib võrdsete väärtuste tõttu ebaõnnestuda või moodustada ebaühtlased piirid. `rank(method="first")` annab sama väärtusega klientidele tehnilise järjestuse.

```python
rfm["M_score"] = pd.qcut(
    rfm["monetary_value"],
    5,
    labels=[1, 2, 3, 4, 5]
)
```

Suurem Monetary saab suurema skoori.

## 4.9. Tüübi teisendamine

```python
rfm["R_score"] = rfm["R_score"].astype(int)
```

Sama tehakse F- ja M-skooriga.

### Miks?

`qcut()` tagastab kategooriatüübi. Arvutamiseks muudetakse skoorid täisarvuks.

## 4.10. Koondskoor

```python
rfm["RFM_Score"] = (
    rfm["R_score"]
    + rfm["F_score"]
    + rfm["M_score"]
)
```

Skoori võimalik vahemik:

```text
3–15
```

## 4.11. Baassegmendid

```python
def segment_customer(row):
    if row["RFM_Score"] >= 13:
        return "VIP Champions"
    elif row["RFM_Score"] >= 10:
        return "Loyal"
    elif row["RFM_Score"] >= 7:
        return "Potential"
    elif row["RFM_Score"] >= 4:
        return "At Risk"
    else:
        return "Lost"
```

```python
rfm["Segment"] = rfm.apply(
    segment_customer,
    axis=1
)
```

### Miks?

Funktsioon tõlgib tehnilise summa äriliseks kliendirühmaks.

`axis=1` tähendab, et funktsioon töötab ühe rea ehk ühe kliendi kaupa.

## 4.12. Segmentide kokkuvõte

```python
segment_summary = (
    rfm["Segment"]
    .value_counts()
    .rename_axis("Segment")
    .reset_index(name="customers")
)
```

### Miks?

Loendatakse, mitu klienti kuulub igasse segmenti.

Protsent:

```python
segment_summary["customer_share_pct"] = (
    segment_summary["customers"]
    / len(rfm)
    * 100
).round(2)
```

## 4.13. Kvaliteedikontroll

```python
print(len(rfm))
print(rfm["Segment"].isna().sum())
print(rfm[["R_score", "F_score", "M_score"]].agg(["min", "max"]))
print(segment_summary["customer_share_pct"].sum())
```

Kontroll kinnitas:

| Kontroll | Tulemus |
|---|---:|
| kliente | 2 540 |
| segmendita kliente | 0 |
| skooride minimaalne väärtus | 1 |
| skooride maksimaalne väärtus | 5 |
| osakaalude summa | 100% |

## 4.14. Baastaseme tulemused

| Segment | Kliente | Klientide osakaal | Monetary osakaal |
|---|---:|---:|---:|
| VIP Champions | 455 | 17,91% | 42,82% |
| Loyal | 679 | 26,73% | 29,75% |
| Potential | 759 | 29,88% | 19,49% |
| At Risk | 529 | 20,83% | 7,18% |
| Lost | 118 | 4,65% | 0,76% |

Peamine tulemus:

```text
VIP + Loyal
= 44,65% klientidest
= 72,57% Monetary väärtusest
```

## 4.15. Kaalutud skoor

```python
rfm["Weighted_RFM_Score"] = (
    rfm["R_score"]
    + rfm["F_score"]
    + 2 * rfm["M_score"]
)
```

### Miks?

Monetary saab kahekordse kaalu, sest Marko küsimus rõhutab väärtuslikke kliente.

### Praeguse koodi oluline piirang

`Weighted_RFM_Score` arvutatakse, kuid `Advanced_Segment` määratakse endiselt tavalise `RFM_Score` järgi.

Seega kaalutud skoor:

- on tabelis olemas;
- ei muuda praegu segmendi nime;
- vajab eraldi analüüsi või teistsugust segmenteerimisreeglit, et selle mõju nähtavaks muutuks.

## 4.16. Detailsemad segmendid

```python
def assign_advanced_segment(row):
    ...
```

See jagab kliendid kuude rühma:

- VIP Champions;
- Loyal Customers;
- Regular Customers;
- New Customers;
- At Risk;
- Lost.

### Metoodiline märkus

Segment `New Customers` määratakse praegu ainult RFM-koondskoori järgi. Kood ei kontrolli otseselt, kas klient on tegelikult uus. Nimetust tuleb seetõttu tõlgendada kui juhendi segmenti, mitte kinnitatud kliendistaatust.

## 4.17. CSV eksport

```python
rfm.to_csv(
    "rfm_segments.csv",
    index=False
)
```

### Miks?

Roll D ja turundusmeeskond saavad kasutada kliendipõhist tulemust ilma kogu notebook'i uuesti käivitamata.

`index=False` väldib pandas'e tehnilise reaindeksi lisamist CSV-sse.

## 4.18. Roll C väljund

```text
rfm
rfm_segments.csv
```

Põhiveerud:

- `customer_id`;
- `recency_days`;
- `frequency`;
- `monetary_value`;
- `R_score`, `F_score`, `M_score`;
- `RFM_Score`;
- `Segment`;
- `Weighted_RFM_Score`;
- `Advanced_Segment`.

---

# 5. Roll D — visualiseerimine ja äritõlgendus

**Vastutaja: Kalju**

## 5.1. Praegune seis

Kinnitatud koondnotebook sisaldab Roll D jaoks ainult Markdown-struktuuri. Visualiseerimise kood ja lõplikud diagrammid ei ole praeguses failis veel olemas.

## 5.2. Planeeritud väljundid

### Segmentide jaotus

Eesmärk:

- näidata klientide arvu segmentide kaupa;
- tuvastada suurimad kliendirühmad.

Sisend:

```text
Segment
customer_id
```

### Recency–Monetary hajuvusdiagramm

Eesmärk:

- eristada hiljutisi ja kõrge väärtusega kliente;
- leida suure väärtusega riskikliente.

Soovitatud väljad:

```text
X = recency_days
Y = monetary_value
värv = Segment
suurus = frequency
```

### TOP 10 VIP-klienti

Eesmärk:

- leida kliendid, kelle hoidmine on rahaliselt kõige olulisem.

Filter:

```text
Segment == "VIP Champions"
```

Järjestus:

```text
monetary_value kahanevalt
```

### KPI-d

Roll D saab kasutada:

| KPI | Väärtus |
|---|---:|
| kliente kokku | 2 540 |
| VIP-kliente | 455 |
| VIP osakaal | 17,91% |
| VIP Monetary kokku | 1 146 295,15 € |
| VIP Monetary osakaal | 42,82% |
| At Risk kliente | 529 |

## 5.3. Äritõlgendus

Tulemuste põhjal:

- VIP-klientide hoidmine on esimene prioriteet;
- Loyal-kliente saab kasvatada VIP-suunas;
- Potential on suurim kasvurühm;
- At Risk on arvukas, kuid madalama Monetary osakaaluga;
- kõigile riskiklientidele sama kuluka kampaania tegemine ei ole põhjendatud;
- Lost on väikese Monetary osakaaluga ja sobib pigem odavaks testkampaaniaks.

## 5.4. Roll D kontroll enne visualiseerimist

1. Kas kasutatakse `Segment` või `Advanced_Segment` veergu?
2. Kas negatiivsed Recency väärtused on selgitatud?
3. Kas TOP 10 järjestatakse Monetary järgi?
4. Kas staatiline tekst vastab filtritud visuaalile?
5. Kas soovitused põhinevad mõõdetud tulemustel, mitte oletusel?

---

# 6. Rollidevahelised kontrollväärtused

| Etapp | Kontrollväärtus |
|---|---:|
| `sales` pärast laadimist | 10 118 rida |
| `customers` pärast laadimist | 3 150 rida |
| ühendatud `df` | 10 118 rida, 20 veergu |
| puhastatud `df` | 8 950 rida |
| unikaalseid kliente | 2 540 |
| RFM-tabel | 2 540 rida |
| segmendita kliente | 0 |
| klientide osakaalude summa | 100% |
| eksporditud CSV | 2 540 rida, 11 veergu |

Need väärtused aitavad tuvastada, millises rollis tulemus muutus.

---

# 7. Praeguse grupifaili tugevused

1. Rollid A–D on selgelt eristatud.
2. Supabase'i ühendusandmeid ei kirjutata koodi sisse.
3. Tabelid laaditakse täielikult, mitte ainult esimese 1000 rea ulatuses.
4. Roll A ja Roll B vaheline `df` töötab.
5. Roll C kood on loogilises järjekorras ja annab reprodutseeritava RFM-tabeli.
6. Segmentide kontrollid kinnitavad ridade arvu, skooride vahemikke ja osakaalude summat.
7. CSV annab Roll D-le eraldi kasutatava väljundi.
8. Äriline väärtus on selge: erinevatele segmentidele saab teha erinevaid tegevusi.

---

# 8. Praeguse grupifaili arengukohad

## Roll A

- `except Exception` võib varjata tegelikku vea põhjust.
- CSV-failide asukoht ei ole määratud.
- Pagination võiks kasutada stabiilset järjestust, et suurte ja muutuvate tabelite laadimine oleks deterministlik.
- Kasutatud andmeallikas tuleks lõpptulemuses selgelt logida.

## Roll B

- duplikaate kontrollitakse ainult `invoice_id` järgi;
- `1 + 1` testlahter ei kuulu lõppnotebook'i;
- osa kontrollväljundeid kordub;
- eemaldatud ridade arv põhjuse kaupa võiks olla eraldi raportis.

## Roll C

- juhendi viitekuupäev tekitab 25 negatiivset Recency väärtust;
- Frequency definitsioon on müügiridade arv, mitte tingimata tellimuste arv;
- kaalutud skoor ei mõjuta `Advanced_Segment` väärtust;
- `New Customers` nimetus ei põhine otseselt kliendi vanusel;
- `customer_id` on CSV-s ujukomaarvuna ja võiks lõppväljundis olla täisarv või tekst.

## Roll D

- kood ja visualiseeringud on kinnitatud notebook'is veel puudu;
- lõplik äriline süntees ei ole veel notebook'is;
- graafikud peavad kasutama ühte selgelt valitud segmentatsiooniloogikat.

---

# 9. Kõige olulisemad analüütilised õppetunnid

## 9.1. Töötav ühendus ei tähenda täielikke andmeid

Üks `.select("*").execute()` päring võib töötada ilma veata, kuid tagastada ainult 1000 rida. Seetõttu peab alati kontrollima `shape`.

## 9.2. Puhastamine peab lähtuma analüüsi eesmärgist

Puuduv kliendi ID on RFM-i jaoks kriitiline, kuid võib mõnes teises analüüsis olla kasutatav anonüümse müügina.

## 9.3. Töötav kood ei taga korrektset tõlgendust

Negatiivne Recency on tehniliselt arvutatav, kuid äriliselt vajab selgitust.

## 9.4. Segment on signaal, mitte lõplik tõde

`At Risk` ei tõenda, et klient on lahkunud. See näitab, et kliendi ostukäitumine on teiste klientidega võrreldes nõrgem.

## 9.5. Suur kliendirühm ei pruugi olla suur rahaline prioriteet

At Risk moodustab 20,83% klientidest, kuid ainult 7,18% Monetary väärtusest.

## 9.6. Kontrollväärtus on sama tähtis kui päring

Iga roll peab teadma:

- mitu rida sai sisendiks;
- mitu rida andis väljundiks;
- miks arv muutus;
- kas muutus vastab oodatule.

---

# 10. Lõppkontrolli nimekiri

## Roll A

- [ ] `.env` laaditakse.
- [ ] võtme väärtust ei kuvata.
- [ ] `sales` sisaldab 10 118 rida või dokumenteeritud uut referentsväärtust.
- [ ] `customers` sisaldab 3 150 rida või dokumenteeritud uut referentsväärtust.
- [ ] ühendatud `df` säilitab müügiridade arvu.

## Roll B

- [ ] duplikaadi definitsioon on selge.
- [ ] kriitilised NULL-id eemaldatakse.
- [ ] `sale_date` on datetime.
- [ ] `total_price > 0`.
- [ ] puhastatud ridade arv on põhjendatud.

## Roll C

- [ ] `rfm` sisaldab 2 540 klienti.
- [ ] segmendita kliente ei ole.
- [ ] skoorid jäävad vahemikku 1–5.
- [ ] osakaalud annavad kokku 100%.
- [ ] viitekuupäeva piirang on dokumenteeritud.
- [ ] CSV loodi õige andmestiku põhjal.

## Roll D

- [ ] põhisegmentatsiooni veerg on valitud.
- [ ] graafikud kasutavad õigeid veerge.
- [ ] negatiivne Recency on selgitatud.
- [ ] KPI-d vastavad CSV-le.
- [ ] soovitused on seotud segmentide tegeliku väärtusega.

## Notebook tervikuna

- [ ] `Restart Kernel → Run All` töötab.
- [ ] ükski lahter ei sõltu vanast kerneli mälust.
- [ ] väljundid vastavad kasutatud andmeallikale.
- [ ] `.env` ja võtmed ei ole GitHubis.
- [ ] Roll D on kas valmis või selgelt märgitud pooleliolevaks.
