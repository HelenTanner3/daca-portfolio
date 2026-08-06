# Jupyter / pandas vs Supabase SQL — Week 7 käskude kontrolltabel

## Kuidas tabelit lugeda?

Week 7 töövoos on kolm eri kihti:

| Kiht | Mida see tähendab? |
|---|---|
| **Jupyter Notebook** | keskkond, kus Python-koodi käivitatakse |
| **pandas** | töötleb arvuti mälus olevaid DataFrame'e |
| **Supabase Python client** | toob andmed Supabase'i API kaudu Pythonisse |
| **Supabase SQL Editor** | käivitab PostgreSQL SQL-i otse andmebaasis |

Jupyter ise ei ole andmetöötluskeel. Notebook'is kasutatud käsud on peamiselt Python, pandas ja Supabase'i Pythoni klient.

Kõigil pandas'e käskudel ei ole üks-ühele SQL-vastet ning kõigil SQL-i võimalustel ei ole lihtsat pandas'e vastet. Tabelis on toodud ainult Week 7 töös kasutatud või vahetult sama ülesannet lahendavad käsud.

---

# 1. Ühendus ja andmete laadimine

| Eesmärk | Jupyter / Python / pandas | Supabase Python client | Supabase SQL Editor | Märkus |
|---|---|---|---|---|
| `.env` laadimine | `load_dotenv(find_dotenv())` | — | — | SQL Editor on juba Supabase'i projektiga ühendatud |
| keskkonnamuutuja lugemine | `os.getenv("SUPABASE_URL")` | — | — | ühenduse seadistus, mitte andmepäring |
| kliendi loomine | `create_client(url, key)` | sama käsk | — | SQL Editoris pole eraldi klienti vaja |
| tabeli valimine | — | `.table("sales")` | `FROM sales` | sama tabel, erinev süntaks |
| kõik veerud | — | `.select("*")` | `SELECT *` | |
| päringu käivitamine | — | `.execute()` | SQL käivitatakse nupuga Run | |
| 1000 rea vahemik | — | `.range(0, 999)` | `LIMIT 1000 OFFSET 0` | järgmine leht: offset 1000 |
| vastuse teisendamine tabeliks | `pd.DataFrame(response.data)` | `response.data` | tulemus kuvatakse tabelina | SQL tulemust pole vaja DataFrame'iks muuta enne Pythonisse eksportimist |
| CSV laadimine | `pd.read_csv("sales.csv")` | — | otsest sama SQL-käsku pole | Supabase'i CSV import on eraldi andmete laadimise toiming |
| vea käsitlemine | `try: ... except Exception as e:` | API-koodi ümber | — | SQL Editor näitab päringu veateadet |

## Lihtsam variant

Kui tabelis on kindlasti alla 1000 rea:

```python
response = (
    supabase
    .table("customers")
    .select("*")
    .execute()
)

df_customers = pd.DataFrame(response.data)
```

See on lühem, kuid suure `sales` tabeli jaoks ei ole piisav.

---

# 2. Andmete vaatamine ja struktuuri kontroll

| Eesmärk | Jupyter / pandas | Supabase SQL | Miks kasutatakse? |
|---|---|---|---|
| ridade ja veergude arv | `df.shape` | `SELECT COUNT(*) FROM sales;` | SQL-i lihtne vaste annab ainult ridade arvu |
| esimesed 5 rida | `df.head()` | `SELECT * FROM sales LIMIT 5;` | kiire sisu kontroll |
| esimesed N rida | `df.head(N)` | `LIMIT N` | |
| veerunimed | `df.columns` | vaata tabeli skeemi või `information_schema.columns` | |
| andmetüübid | `df.dtypes` | `information_schema.columns` | tüübi kontroll |
| üldinfo | `df.info()` | mitu eraldi SQL-kontrolli | pandas koondab tüübid ja NULL-arvud ühte väljundisse |
| kõik veerud nähtavaks | `pd.set_option("display.max_columns", None)` | — | ainult notebook'i kuvaseadistus |
| tabeli kuvamine | `display(df.head())` | SQL tulemusruudustik | ainult esitlusviis |

## SQL-tüübi kontroll

```sql
SELECT
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_name = 'sales'
ORDER BY ordinal_position;
```

---

# 3. Tabelite ühendamine

| Eesmärk | Jupyter / pandas | Supabase SQL |
|---|---|---|
| vasakühendus | `pd.merge(df_sales, df_customers, on="customer_id", how="left")` | `LEFT JOIN customers USING (customer_id)` |
| lühem pandas kuju | `df_sales.merge(df_customers, on="customer_id", how="left")` | sama SQL |
| sisemine ühendus | `.merge(..., how="inner")` | `INNER JOIN` |
| ühendatud ridade kontroll | `df.shape` | `SELECT COUNT(*) FROM ... LEFT JOIN ...` |

## SQL-võrdlus

```sql
SELECT
    s.*,
    c.first_name,
    c.last_name,
    c.email,
    c.phone,
    c.city,
    c.loyalty_tier
FROM sales AS s
LEFT JOIN customers AS c
    ON s.customer_id = c.customer_id;
```

### Oluline erinevus

pandas teeb ühenduse arvuti mälus pärast andmete allalaadimist. SQL teeb ühenduse andmebaasis enne tulemuse tagastamist.

---

# 4. Duplikaadid

| Eesmärk | Jupyter / pandas | Supabase SQL | Märkus |
|---|---|---|---|
| korduvate `invoice_id` väärtuste arv | `df.duplicated(subset=["invoice_id"]).sum()` | `GROUP BY invoice_id HAVING COUNT(*) > 1` | SQL näitab tavaliselt gruppe, mitte ühe numbrina korduvate ridade koguarvu |
| korduvate väärtuste eemaldamine | `df.drop_duplicates(subset=["invoice_id"], keep="first")` | `DISTINCT ON (invoice_id)` või `ROW_NUMBER()` | PostgreSQL-spetsiifiline |
| täisrea duplikaadid | `df.duplicated().sum()` | `GROUP BY` kõigi veergude alusel | praeguses grupikoodis ei kasutatud |

## SQL-kontroll

```sql
SELECT
    invoice_id,
    COUNT(*) AS rows_per_invoice
FROM sales
GROUP BY invoice_id
HAVING COUNT(*) > 1
ORDER BY rows_per_invoice DESC;
```

## SQL-i ajutine deduplikatsioon

```sql
SELECT DISTINCT ON (invoice_id)
    *
FROM sales
ORDER BY invoice_id, id;
```

See ei kustuta tabelist ridu. See tagastab päringu tulemuses iga `invoice_id` kohta esimese rea.

---

# 5. Puuduvad väärtused

| Eesmärk | Jupyter / pandas | Supabase SQL |
|---|---|---|
| kõikide veergude NULL-arvud | `df.isnull().sum()` | eraldi `COUNT(*) FILTER` iga veeru jaoks |
| sama pandas alternatiiv | `df.isna().sum()` | sama SQL |
| kriitiliste NULL-ridade eemaldamine | `df.dropna(subset=[...])` | `WHERE ... IS NOT NULL` |
| ühe veeru NULL-filter | `df[df["customer_id"].notna()]` | `WHERE customer_id IS NOT NULL` |
| NULL-ridade arv | `df["customer_id"].isna().sum()` | `COUNT(*) FILTER (WHERE customer_id IS NULL)` |

## SQL-kontroll

```sql
SELECT
    COUNT(*) FILTER (
        WHERE customer_id IS NULL
    ) AS missing_customer_id,

    COUNT(*) FILTER (
        WHERE sale_date IS NULL
    ) AS missing_sale_date,

    COUNT(*) FILTER (
        WHERE total_price IS NULL
    ) AS missing_total_price
FROM sales;
```

## SQL-puhastusfilter

```sql
WHERE customer_id IS NOT NULL
  AND sale_date IS NOT NULL
  AND total_price IS NOT NULL
```

---

# 6. Andmetüübid ja filtrid

| Eesmärk | Jupyter / pandas | Supabase SQL |
|---|---|---|
| kuupäevaks teisendamine | `pd.to_datetime(df["sale_date"])` | `sale_date::date` või `CAST(sale_date AS date)` |
| ainult positiivsed summad | `df[df["total_price"] > 0]` | `WHERE total_price > 0` |
| võrdne väärtus | `df[df["Segment"] == "VIP Champions"]` | `WHERE segment = 'VIP Champions'` |
| mitu tingimust | `(tingimus1) & (tingimus2)` | `WHERE tingimus1 AND tingimus2` |
| tüübi muutmine täisarvuks | `.astype(int)` | `CAST(value AS integer)` |

## Kompaktne pandas filter

```python
df = (
    df
    .dropna(
        subset=[
            "customer_id",
            "sale_date",
            "total_price"
        ]
    )
    .query("total_price > 0")
)
```

`query()` on kompaktne alternatiiv, kuid grupitöös kasutati otsest nurksulgudega filtrit.

---

# 7. Lihtsad koondnäitajad

| Eesmärk | Jupyter / pandas | Supabase SQL |
|---|---|---|
| unikaalsete klientide arv | `df["customer_id"].nunique()` | `COUNT(DISTINCT customer_id)` |
| minimaalne kuupäev | `df["sale_date"].min()` | `MIN(sale_date)` |
| maksimaalne kuupäev | `df["sale_date"].max()` | `MAX(sale_date)` |
| väärtuste summa | `df["total_price"].sum()` | `SUM(total_price)` |
| ridade arv | `len(df)` või `df.shape[0]` | `COUNT(*)` |

## SQL-kontroll

```sql
SELECT
    COUNT(*) AS rows,
    COUNT(DISTINCT customer_id) AS customers,
    MIN(sale_date) AS first_sale,
    MAX(sale_date) AS last_sale,
    SUM(total_price) AS revenue
FROM sales
WHERE customer_id IS NOT NULL
  AND sale_date IS NOT NULL
  AND total_price > 0;
```

---

# 8. `groupby()` ja RFM-alusnäitajad

| Eesmärk | Jupyter / pandas | Supabase SQL |
|---|---|---|
| kliendi viimane ost | `groupby("customer_id")["sale_date"].max()` | `MAX(sale_date) GROUP BY customer_id` |
| kliendi ostude arv | `groupby("customer_id")["sale_id"].count()` | `COUNT(sale_id) GROUP BY customer_id` |
| kliendi kogukulutus | `groupby("customer_id")["total_price"].sum()` | `SUM(total_price) GROUP BY customer_id` |
| indeks tagasi veeruks | `.reset_index()` | SQL tulemus on juba tabelikujuline |
| veeru ümbernimetamine | `df.columns = [...]` | `AS alias` |

## Pandas — grupitöös kasutatud eraldi arvutused

```python
recency = (
    df.groupby("customer_id")["sale_date"]
    .max()
    .reset_index()
)

frequency = (
    df.groupby("customer_id")["sale_id"]
    .count()
    .reset_index()
)

monetary = (
    df.groupby("customer_id")["total_price"]
    .sum()
    .reset_index()
)
```

## Kompaktsem pandas lahendus

```python
rfm = (
    df.groupby("customer_id")
    .agg(
        last_purchase_date=(
            "sale_date",
            "max"
        ),
        frequency=(
            "sale_id",
            "count"
        ),
        monetary_value=(
            "total_price",
            "sum"
        )
    )
    .reset_index()
)

rfm["recency_days"] = (
    today - rfm["last_purchase_date"]
).dt.days
```

See annab samad kolm põhinäitajat ühe `groupby()` abil.

## Kompaktne SQL-lahendus

```sql
SELECT
    customer_id,
    DATE '2025-02-28'
        - MAX(sale_date::date)
        AS recency_days,

    COUNT(sale_id)
        AS frequency,

    SUM(total_price)
        AS monetary_value

FROM sales

WHERE customer_id IS NOT NULL
  AND sale_date IS NOT NULL
  AND total_price > 0

GROUP BY customer_id;
```

See SQL teeb puhastusfiltri ja RFM-i kolm põhikoondit ühe päringuga.

---

# 9. Kuupäevade vahe

| Eesmärk | Jupyter / pandas | Supabase SQL |
|---|---|---|
| kuupäevakonstant | `pd.to_datetime("2025-02-28")` | `DATE '2025-02-28'` |
| kuupäevade lahutamine | `today - last_purchase_date` | `DATE '2025-02-28' - last_purchase_date::date` |
| päevade arv | `.dt.days` | PostgreSQL kuupäevade lahutamine annab päevade arvu |

Näide:

```sql
SELECT
    customer_id,
    DATE '2025-02-28'
        - MAX(sale_date::date)
        AS recency_days
FROM sales
GROUP BY customer_id;
```

---

# 10. Kvintiilid ja järjestamine

| Eesmärk | Jupyter / pandas | Supabase SQL | Täpsustus |
|---|---|---|---|
| viis võrdset rühma | `pd.qcut(..., 5)` | `NTILE(5) OVER (ORDER BY ...)` | tulemused võivad võrdsete väärtuste korral erineda |
| Frequency tehniline järjestus | `.rank(method="first")` | `ROW_NUMBER() OVER (...)` | vaja deterministlikku lisajärjestust |
| väiksem Recency = parem skoor | `labels=[5,4,3,2,1]` | `6 - NTILE(5) ...` | |
| suurem väärtus = parem skoor | `labels=[1,2,3,4,5]` | `NTILE(5) ...` | |

## SQL-i põhimõte

```sql
NTILE(5) OVER (
    ORDER BY monetary_value
) AS m_score
```

Recency puhul:

```sql
6 - NTILE(5) OVER (
    ORDER BY recency_days
) AS r_score
```

### Oluline piirang

`qcut()` ja `NTILE()` ei ole igas olukorras täpselt sama tulemusega. Võrdsete väärtuste korral sõltub tulemus järjestamise reeglist.

---

# 11. Skoorid ja segmendid

| Eesmärk | Jupyter / pandas | Supabase SQL |
|---|---|---|
| skooride summa | `R_score + F_score + M_score` | `r_score + f_score + m_score` |
| tingimuslik segment | funktsioon + `apply(axis=1)` | `CASE WHEN ... THEN ... END` |
| kaalutud skoor | `R + F + 2 * M` | `r_score + f_score + 2 * m_score` |

## Pandas

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
    return "Lost"
```

## SQL

```sql
CASE
    WHEN rfm_score >= 13
        THEN 'VIP Champions'
    WHEN rfm_score >= 10
        THEN 'Loyal'
    WHEN rfm_score >= 7
        THEN 'Potential'
    WHEN rfm_score >= 4
        THEN 'At Risk'
    ELSE 'Lost'
END AS segment
```

---

# 12. Segmentide kokkuvõte

| Eesmärk | Jupyter / pandas | Supabase SQL |
|---|---|---|
| väärtuste arv | `.value_counts()` | `GROUP BY segment` + `COUNT(*)` |
| veeru nimi | `.rename_axis()` | `AS` |
| indeks veeruks | `.reset_index()` | SQL tulemus on juba tabel |
| osakaal | `customers / len(rfm) * 100` | `COUNT(*) * 100.0 / SUM(COUNT(*)) OVER ()` |
| ümardamine | `.round(2)` | `ROUND(value, 2)` |
| min/max kontroll | `.agg(["min", "max"])` | `MIN()` ja `MAX()` |

## SQL-kokkuvõtte põhimõte

```sql
SELECT
    segment,
    COUNT(*) AS customers,
    ROUND(
        COUNT(*) * 100.0
        / SUM(COUNT(*)) OVER (),
        2
    ) AS customer_share_pct
FROM rfm_result
GROUP BY segment
ORDER BY customers DESC;
```

`rfm_result` tähistab siin varasema RFM-päringu tulemust või vaadet.

## Lihtsam pandas protsendivaade

```python
rfm["Segment"].value_counts(
    normalize=True
).mul(100).round(2)
```

See annab ainult osakaalud. Kui vaja on nii arvu kui protsenti ühes tabelis, on grupitöö pikem lahendus selgem.

---

# 13. Eksport

| Eesmärk | Jupyter / pandas | Supabase SQL |
|---|---|---|
| CSV salvestamine | `rfm.to_csv("rfm_segments.csv", index=False)` | SQL Editoris puudub sama pandas-käsk |
| andmete allalaadimine | fail luuakse arvutisse | päringutulemus eksporditakse Supabase'i kasutajaliidesest |
| indeksi välistamine | `index=False` | SQL tulemusel pandas'e indeksit pole |

### Millal Python on mugavam?

Python on mugavam, kui pärast arvutust on vaja:

- luua kohalik CSV;
- teha Plotly visualiseering;
- kasutada sama tulemust järgmistes notebook'i lahtrites;
- lisada äriloogika ja tekstiline analüüs.

---

# 14. Visualiseerimine

Praeguses kinnitatud grupinotebook'is ei ole Roll D koodi veel lisatud.

| Eesmärk | Jupyter / Python | Supabase SQL |
|---|---|---|
| tulpdiagramm | Plotly / pandas plot | otsest vastet pole |
| hajuvusdiagramm | Plotly Express | otsest vastet pole |
| interaktiivne tooltip | Plotly | otsest vastet pole |
| TOP 10 andmed | `sort_values()` + `head(10)` | `ORDER BY ... DESC LIMIT 10` |
| tulemuste tabel | DataFrame | SQL tulemusruudustik |

SQL valmistab ette andmed. Python või BI-tööriist loob visuaali.

---

# 15. Millal kasutada pandas't ja millal SQL-i?

| Olukord | Sobivam valik | Põhjus |
|---|---|---|
| andmed on juba notebook'is | pandas | kiire iteratsioon |
| väga suur tabel | SQL | arvutus toimub andmebaasis |
| mitu tabelit tuleb enne allalaadimist ühendada | SQL | vähem andmeid liigub võrgu kaudu |
| interaktiivsed graafikud | Python / Plotly | SQL ei ole visualiseerimistööriist |
| korduv puhastuspäring andmebaasis | SQL view | üks keskne loogika |
| uuriv analüüs ja vaheväljundid | Jupyter / pandas | tulemusi saab sammhaaval vaadata |
| CSV väljund | pandas | `to_csv()` on otsene |
| andmekvaliteedi referentskontroll | SQL + pandas | sõltumatu võrdlus suurendab usaldust |

---

# 16. Kiirkontroll: sama mõte eri süntaksis

| Mõte | pandas | SQL |
|---|---|---|
| vali kõik | `df` | `SELECT * FROM table` |
| vali veerud | `df[["a", "b"]]` | `SELECT a, b` |
| filter | `df[df["x"] > 0]` | `WHERE x > 0` |
| sorteeri | `df.sort_values("x")` | `ORDER BY x` |
| TOP 5 | `.nlargest(5, "x")` | `ORDER BY x DESC LIMIT 5` |
| grupp | `.groupby("customer_id")` | `GROUP BY customer_id` |
| summa | `.sum()` | `SUM()` |
| loendus | `.count()` | `COUNT()` |
| unikaalne loendus | `.nunique()` | `COUNT(DISTINCT ...)` |
| miinimum | `.min()` | `MIN()` |
| maksimum | `.max()` | `MAX()` |
| vasakühendus | `.merge(..., how="left")` | `LEFT JOIN` |
| puuduv | `.isna()` | `IS NULL` |
| eemalda puuduv | `.dropna()` | `IS NOT NULL` |
| tingimus | `if / elif / else` | `CASE WHEN` |
| segmentide arv | `.value_counts()` | `GROUP BY + COUNT(*)` |
| kuupäeva tüüp | `pd.to_datetime()` | `CAST(... AS date)` |
| ekspordi CSV | `.to_csv()` | ekspordi päringutulemus |

---

# 17. Kõige olulisem erinevus

```text
SQL küsib ja arvutab andmeid andmebaasis.
pandas töötleb Pythonisse juba laaditud andmeid.
Jupyter näitab koodi, vahetulemusi ja selgitusi ühes failis.
```

Hea töövoog ei vali alati ainult ühte.

Praktiline kombinatsioon:

```text
Supabase SQL või API
    ↓
kontrollitud sisend
    ↓
pandas analüüs
    ↓
RFM-tabel
    ↓
Plotly visualiseerimine
    ↓
CSV või raport
```
