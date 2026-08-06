# Supabase → Python → pandas: ühendus, andmete laadimine ja esmane kontroll

## Juhendi eesmärk

See juhend kirjeldab DACA nädala 7 töövoogu, millega:

1. valmistatakse ette Python ja vajalikud teegid;
2. hoitakse Supabase’i ühendusandmeid lokaalses `.env` failis;
3. luuakse Pythonist ühendus Supabase’iga;
4. laaditakse `sales`, `customers` ja `products` tabelid pandas DataFrame’idesse;
5. ühendatakse tabelid koolitaja näite järgi;
6. tehakse esmased kontrollid enne puhastamist ja RFM-analüüsi;
7. välditakse `.env` faili sattumist GitHubi.

Juhendi põhikood järgib koolitaja tunnis kasutatud näidet. Täiendavad kontrollid on eraldi tähistatud ning ei asenda koolitaja põhivoogu.

---


## Juhendi asukoht juhendite puus

See juhend kuulub plokki **03 Data Access → Connections**.

Põhjus: juhendi keskne teema ei ole SQL-päringute kirjutamine ega Python/Jupyteri paigaldamine, vaid:

- turvalise andmeühenduse seadistamine `.env` kaudu;
- Supabase'i Pythoni kliendi loomine;
- tabelite laadimine pandas DataFrame'idesse;
- lehekülgede kaupa andmete toomine;
- laaditud andmete ühendamine ja kontrollimine.

Jupyter Notebook on siin koodi käivitamise keskkond ning SQL `LEFT JOIN`-iga sarnanev `pd.merge()` on pandas'e toiming.

---

## 1. Aluseks olev töövoog

```text
Supabase
   ↓
Python + Supabase klient
   ↓
pandas DataFrame’id
   ↓
Jupyter Notebook
   ↓
Roll A: laadimine ja ühendamine
   ↓
Roll B: puhastamine
   ↓
Roll C: RFM-analüüs
   ↓
Roll D: visualiseerimine
```

Oluline eristus:

- **Supabase** on andmeallikas.
- **Python** käivitab käsud.
- **pandas** töötleb andmeid DataFrame’idena.
- **Jupyter Notebook** ühendab koodi, selgitused ja tulemused.
- **GitHub** säilitab tööfailid ja muudatuste ajaloo.

Pandas DataFrame ei ole Supabase’i uus tabel. See on notebook’i käivitamisel arvuti mällu loodud tabelikujuline objekt.

---

## 2. Koolituse põhiallikad

Juhend on koostatud järgmiste DACA materjalide ja näidete järgi:

- `N0_0_0_P_SJ_Installimise_pohimotted_v2.9.docx`;
- `N0_0_4_P_SJ_VSCode_Python_v2.9.docx`;
- `N0_0_7_P_SJ_Versioonid_v2.9.docx`;
- `N7_0_1_P_IT_Python_Pandas_v2.9.docx`;
- `N7_1_1_P_SL_Python_Pandas_v2.9.pdf`;
- `N7_2_1_P_GT_Python_Pandas_v2.9.docx`;
- `7_0_R1_python_pandas_concepts-rag.md`;
- `7_0_R2_python_pandas_urbanstyle_application-rag.md`;
- koolitaja tunnis kasutatud Python-kood.

Kui mõni üldine tehniline soovitus erineb koolitaja näitest, kasutatakse põhivoos koolitaja koodi. Muu lahendus lisatakse ainult põhjendatud täiendusena.

---

## 3. Töökeskkonna eeldused

### 3.1. Koolituse soovitatud keskkond

DACA versioonijuhendi järgi kasutatakse selles kohordis:

- Python `3.13.12`;
- VS Code’i uusimat stabiilset versiooni;
- Microsofti Python, Jupyter ja Pylance laiendusi;
- projekti virtuaalkeskkonda.

Python tuleb installida ametlikult `python.org` lehelt. Koolituse juhend hoiatab Python 3.14 kasutamise eest, sest osa teeke ei pruugi sellega ühilduda.

### 3.2. Virtuaalkeskkonna aktiveerimine

Windows PowerShellis:

```powershell
venv\Scripts\Activate.ps1
```

Terminalirea alguses peab olema:

```text
(venv)
```

VS Code’is kontrolli ka valitud interpreterit:

```text
Ctrl+Shift+P → Python: Select Interpreter
```

Vali projekti virtuaalkeskkonna Python, näiteks:

```text
...\venv\Scripts\python.exe
```

### 3.3. Vajalikud teegid

Koolitaja näitekood kasutab järgmisi pakette:

```powershell
pip install pandas supabase python-dotenv plotly ipykernel jupyter
```

Kontroll:

```powershell
python --version
pip --version
pip list
```

> Koolitusmaterjalides võib Supabase’i paketi kohta esineda nii nimetus `supabase` kui ka `supabase-py`. Selle projekti tegelik import ja kasutatud pakett on `supabase`:
>
> ```python
> from supabase import create_client
> ```

---

## 4. Projekti kaustastruktuur

### 4.1. Isiklik repo

```text
daca-portfolio/
├── .env
├── .env.example
├── .gitignore
├── venv/
├── week-7/
│   └── week7_rfm_role_c.ipynb
└── GUIDES/
    └── 03_data_access/
        └── connections/
            └── supabase_python_pandas_connection.md
```

### 4.2. Grupi repo

```text
DACA-group/
├── .env
├── .env.example
├── .gitignore
└── week-7/
    └── week7_rfm_team.ipynb
```

### Projekti kokkulepe

- `.env` asub lokaalselt repo juurkaustas.
- Igal meeskonnaliikmel on oma arvutis eraldi `.env` fail.
- `.env` faili ei jagata GitHubi kaudu.
- Kõigil kasutatakse samu muutujanimesid: `SUPABASE_URL` ja `SUPABASE_KEY`.
- Ühine notebook peab kasutama samu muutujanimesid, et see töötaks eri arvutites sama loogikaga.

---

## 5. `.env` faili loomine

Loo repo juurkausta fail nimega täpselt:

```text
.env
```

Faili sisu:

```dotenv
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_KEY=your-anon-public-key
```

Supabase’i väärtused saad projekti vaates:

```text
Connect → API Keys
```

Kopeeri:

- Project URL;
- anon/public key, mida kasutatakse koolitaja näites `SUPABASE_KEY` väärtusena.

### Tähtsad kontrollid

- ära lisa väärtuste ümber jutumärke;
- ära jäta võrdusmärgi ümber liigseid tühikuid;
- kontrolli, et URL lõpeks õigesti, näiteks `.co`;
- ära kuva võtme tegelikku väärtust notebook’i väljundis ega kuvatõmmistel.

Jupyter Notebook jääb `.ipynb` failiks. `.env` on sellest eraldi seadistusfail.

---

## 6. `.gitignore`

Repo juurkausta `.gitignore` failis peavad olema vähemalt:

```gitignore
.env
.env.*
!.env.example
venv/
.venv/
__pycache__/
*.py[cod]
.ipynb_checkpoints/
```

Tähendus:

- `.env` — päris ühendusandmeid ei lisata GitHubi;
- `.env.*` — välistatakse muud lokaalsed `.env` variandid;
- `!.env.example` — näidisfail võib minna GitHubi;
- `venv/` ja `.venv/` — virtuaalkeskkonda ei lisata reposse;
- `.ipynb_checkpoints/` — Jupyteri automaatsed vahefailid jäetakse välja.

### `.env.example` — põhjendatud portfooliotäiendus

Koolitaja põhikood ei vaja `.env.example` faili, kuid meeskonnatöös ja avalikus portfoolios on see kasulik. See näitab vajalikke muutujanimesid ilma tegelikke väärtusi avaldamata.

```dotenv
SUPABASE_URL=
SUPABASE_KEY=
```

---

## 7. Koolitaja põhikood

Alljärgnev kood säilitab koolitaja kasutatud tööjärjekorra ja muutujanimed.

```python
import os
import pandas as pd
from supabase import create_client
from dotenv import load_dotenv
import plotly.express as px

load_dotenv()

supabase = create_client(
    os.getenv('SUPABASE_URL'),
    os.getenv('SUPABASE_KEY')
)


def get_data(tabel_name):
    data = []
    page_size = 1000
    page = 0

    while True:
        response = (
            supabase
            .table(tabel_name)
            .select('*')
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


# response = supabase.table('sales').select('*').execute()
# df = pd.DataFrame(response.data)


df_sales = get_data('sales')
df_customers = get_data('customers')
df_products = get_data('products')


df = pd.merge(
    df_sales,
    df_customers,
    on='customer_id',
    how='left'
)


df = pd.merge(
    df,
    df_products,
    on='product_id',
    how='left'
)


print(df.shape)


city_revenue = df.groupby('store_location')['total_price'].sum()
print("Revenue by City:")
print(city_revenue)


print("Number of Customers:", df['customer_id'].nunique())


# 1. Leia TOP 5 toodet kogukäibe järgi
top_products = (
    df.groupby('product_name')['total_price']
    .sum()
    .nlargest(5)
)
print(top_products)


# 2. Leia klient suurima kogukulutusega
top_customer = (
    df.groupby('customer_id')['total_price']
    .sum()
    .idxmax()
)
print("Top customer:", top_customer)


df['sale_date'] = pd.to_datetime(df['sale_date'])


sales_over_time = (
    df.groupby('sale_date')['total_price']
    .sum()
    .reset_index()
)
sales_over_time.columns = ['Müügikuupäev', 'Müük']


fig_line = px.line(
    sales_over_time,
    x='Müügikuupäev',
    y='Müük',
    title='Müük läbi aegade',
    markers=True
)


fig_line.update_layout(
    xaxis_title='Kuupäev',
    yaxis_title='Müük (€)'
)


fig_line.show()
```

---

## 8. Põhikoodi samm-sammuline selgitus

### 8.1. Teekide import

```python
import os
import pandas as pd
from supabase import create_client
from dotenv import load_dotenv
import plotly.express as px
```

| Import | Otstarve |
|---|---|
| `os` | loeb keskkonnamuutujaid |
| `pandas as pd` | loob ja töötleb DataFrame’e |
| `create_client` | loob Supabase’i kliendi |
| `load_dotenv` | laadib `.env` faili väärtused |
| `plotly.express as px` | loob interaktiivseid diagramme |

### 8.2. `.env` laadimine

```python
load_dotenv()
```

See teeb `.env` failis olevad väärtused Pythonile kättesaadavaks.

### 8.3. Supabase’i kliendi loomine

```python
supabase = create_client(
    os.getenv('SUPABASE_URL'),
    os.getenv('SUPABASE_KEY')
)
```

- `os.getenv('SUPABASE_URL')` loeb URL-i;
- `os.getenv('SUPABASE_KEY')` loeb võtme;
- `create_client()` loob ühenduse objekti, mille kaudu tehakse tabelipäringuid.

See kood ei laadi veel ühtegi tabelit. See loob kliendi, mida järgmistes sammudes kasutatakse.

### 8.4. `get_data()` funktsioon

```python
def get_data(tabel_name):
```

Funktsioon defineeritakse üks kord. Sulgudes olev `tabel_name` määrab, milline Supabase’i tabel laaditakse.

```python
data = []
page_size = 1000
page = 0
```

- `data` kogub kõik laaditud read;
- `page_size = 1000` määrab ühe päringu suuruse;
- `page = 0` alustab esimesest leheküljest.

```python
while True:
```

Tsükkel jätkab päringuid seni, kuni viimane lehekülg on kätte saadud.

```python
.range(
    page * page_size,
    (page + 1) * page_size - 1
)
```

Esimese päringu vahemik on 0–999, järgmine 1000–1999 jne.

```python
data.extend(response.data)
```

Iga päringu tulemused lisatakse ühisesse loendisse.

```python
if len(response.data) < page_size:
    break
```

Kui viimane päring tagastab vähem kui 1000 rida, on tabeli lõpp saavutatud.

```python
return pd.DataFrame(data)
```

Kõik kogutud read teisendatakse pandas DataFrame’iks.

### 8.5. Miks kommenteeritud lihtsat päringut põhilaadimiseks ei kasutata?

Koolitaja koodis on näitena:

```python
# response = supabase.table('sales').select('*').execute()
# df = pd.DataFrame(response.data)
```

See näitab ühe päringu põhimõtet. UrbanStyle’i suuremate tabelite täielikuks laadimiseks kasutatakse aga `get_data()` funktsiooni, mis loeb read 1000 kaupa.

### 8.6. Tabelite laadimine

```python
df_sales = get_data('sales')
df_customers = get_data('customers')
df_products = get_data('products')
```

Funktsioon käivitatakse kolm korda, kuid seda ei defineerita uuesti.

| Supabase’i tabel | Pandas DataFrame |
|---|---|
| `sales` | `df_sales` |
| `customers` | `df_customers` |
| `products` | `df_products` |

### 8.7. Tabelite ühendamine

Esimene ühendamine:

```python
df = pd.merge(
    df_sales,
    df_customers,
    on='customer_id',
    how='left'
)
```

Teine ühendamine:

```python
df = pd.merge(
    df,
    df_products,
    on='product_id',
    how='left'
)
```

`how='left'` tähendab, et põhialuseks jäävad vasakpoolse DataFrame’i read. Koolitaja töövoos säilitatakse müügiread ning neile lisatakse võimaluse korral kliendi- ja tooteandmed.

Seos varasema SQL-iga:

```text
SQL LEFT JOIN  ↔  pandas merge(..., how='left')
```

### 8.8. Esmane kontroll

```python
print(df.shape)
```

`shape` tagastab:

```text
(ridade arv, veergude arv)
```

Pärast seda kasutatakse:

- `groupby()` — SQL `GROUP BY` analoog;
- `sum()` — väärtuste liitmine;
- `nunique()` — unikaalsete klientide arv;
- `nlargest(5)` — viis suurimat tulemust;
- `idxmax()` — suurima väärtusega grupi indeks;
- `pd.to_datetime()` — kuupäevavälja teisendamine;
- Plotlyt — ajatrendi visualiseerimiseks.

---

## 9. Koolituse põhivoogu toetavad kontrollid

Need kontrollid ei muuda koolitaja koodi loogikat. Need aitavad enne Roll B ja Roll C tööd veenduda, et sisend on korrektne.

### 9.1. Laaditud tabelite mahu kontroll

```python
print("sales:", df_sales.shape)
print("customers:", df_customers.shape)
print("products:", df_products.shape)
```

UrbanStyle’i praeguse kontrollitud andmestiku väärtused olid:

```text
sales: (10118, 12)
customers: (3150, 9)
products: (362, 9)
```

Need on selle andmestiku referentsväärtused, mitte universaalsed püsiväärtused. Kui andmebaasi sisu muutub, võivad ka arvud muutuda.

### 9.2. Veergude ja andmetüüpide kontroll

```python
print(df_sales.columns.tolist())
print(df_sales.dtypes)
print(df_sales.head())
```

Koolituse järgi on andmete uurimise põhikäsud:

```python
df.head()
df.shape
df.dtypes
df.info()
df.describe()
```

### 9.3. Merge’i mahu kontroll

Enne ühendamist:

```python
print("Enne merge’i:", df_sales.shape)
```

Pärast ühendamist:

```python
print("Pärast merge’i:", df.shape)
```

`LEFT JOIN` peaks säilitama müügiread. Kui ridade arv suureneb ootamatult, tuleb kontrollida, kas `customer_id` või `product_id` on parempoolses tabelis korduv.

### 9.4. Võtmete olemasolu kontroll väärtusi kuvamata

```python
print("SUPABASE_URL olemas:", bool(os.getenv('SUPABASE_URL')))
print("SUPABASE_KEY olemas:", bool(os.getenv('SUPABASE_KEY')))
```

See kontroll näitab ainult, kas väärtus on olemas. Tegelikku võtit ei prindita.

---

## 10. RLS ja null rea probleem

Võimalik olukord:

- `create_client()` töötab;
- veateadet ei tule;
- tabelipäring tagastab siiski 0 rida.

See võib tähendada, et Supabase’i ühendus töötab, kuid tabeli **Row Level Security** ehk RLS ei luba kasutataval rollil ridu lugeda.

Eristus:

| Olukord | Tõenäoline kontrollkoht |
|---|---|
| `.env` väärtus puudub | `.env` asukoht ja muutujanimi |
| `Invalid API key` | URL või võti |
| tabelit ei leitud | tabeli nimi |
| ühendus töötab, 0 rida | tabeli sisu või RLS-poliitika |
| ainult osa ridu | kas kasutati lehekülgede kaupa laadimist |

RLS-i probleemi ei lahendata notebook’i koodi ümberkirjutamisega ega kõrgema õigusega võtme jagamisega. Vajalik lugemisõigus tuleb korraldada Supabase’i projektis kokkulepitud poliitikatega.

---

## 11. Giti kontrollid — põhjendatud portfooliotäiendus

Koolituse põhivoog nõuab artefakti lisamist GitHubi. Kuna `.env` ei tohi sinna sattuda, tehakse enne commit’i kontroll.

### 11.1. Tavakontroll

```powershell
git status --short
```

`.env` ei tohi väljundis olla.

### 11.2. Kontrolli ignoreerimise reeglit

```powershell
git check-ignore -v .env
```

Kui kõik on korras, näitab Git, milline `.gitignore` reegel faili välistab.

### 11.3. Kontrolli, ega Git faili juba ei jälgi

```powershell
git ls-files .env
```

Oodatav tulemus: käsk ei väljasta midagi.

### 11.4. Kui `.env` oli juba Gitile lisatud

```powershell
git rm --cached .env
git commit -m "Stop tracking .env file"
git push
```

`--cached` eemaldab faili Giti jälgimisest, kuid jätab lokaalse `.env` faili arvutisse alles.

> Kui ühendusandmed olid juba avalikus commit’is, ei piisa ainult faili eemaldamisest viimasest versioonist. Ligipääsuandmed ja õigused tuleb eraldi üle vaadata.

---

## 12. Notebook’i lõppkontroll

Nädala 7 grupitöö väljund peab olema üks terviklik notebook, mis töötab algusest lõpuni ilma veata.

VS Code’i või Jupyteri menüüs:

```text
Kernel → Restart & Run All
```

Kontrolli, et:

- `.env` laaditakse pärast kerneli taaskäivitamist;
- Supabase’i klient luuakse uuesti;
- kõik kolm tabelit laaditakse;
- merge’id töötavad;
- ükski lahter ei sõltu vanast mälus olevast vahetulemusest;
- väljundid tekivad õiges järjekorras;
- võtme tegelikku väärtust ei kuvata.

---

## 13. Meeskonnatöö kokkulepe

Grupifaili toimimiseks eri arvutites:

1. iga liige kloonib või uuendab sama grupirepo;
2. iga liige loob oma lokaalse `.env` faili repo juurkausta;
3. kõik kasutavad muutujaid `SUPABASE_URL` ja `SUPABASE_KEY`;
4. `.env` ei liigu Giti kaudu;
5. notebook’is kasutatakse koolitaja `load_dotenv()` ja `get_data()` põhikoodi;
6. enne Roll B ja Roll C tööd kontrollitakse tabelite `shape` väärtusi;
7. enne koondfaili kinnitamist tehakse `Restart & Run All`;
8. enne push’i kontrollitakse `git status --short`.

---

## 14. README jaoks sobiv lühikirjeldus

```markdown
## Andmete laadimine

Analüüs laadib UrbanStyle’i `sales`, `customers` ja `products` tabelid otse Supabase’ist. Ühendusandmed loetakse lokaalsest `.env` failist muutujate `SUPABASE_URL` ja `SUPABASE_KEY` kaudu. `.env` faili ei lisata GitHubi.

Tabelid laaditakse Supabase’ist 1000 rea kaupa, teisendatakse pandas DataFrame’ideks ning ühendatakse `customer_id` ja `product_id` alusel `left` merge’idega. Enne edasist analüüsi kontrollitakse DataFrame’ide mahtu, veerge ja andmetüüpe.
```

---

## 15. Kontrollnimekiri

### Keskkond

- [ ] Kasutan koolituse soovitatud Python 3.13.x versiooni.
- [ ] Virtuaalkeskkond on aktiveeritud.
- [ ] VS Code’is on valitud õige interpreter.
- [ ] `pandas`, `supabase`, `python-dotenv`, `plotly`, `ipykernel` ja `jupyter` on olemas.

### `.env` ja Git

- [ ] `.env` asub repo juurkaustas.
- [ ] `.env` sisaldab `SUPABASE_URL` ja `SUPABASE_KEY` väärtusi.
- [ ] `.gitignore` välistab `.env`, `venv/` ja `.ipynb_checkpoints/`.
- [ ] `.env.example` ei sisalda päris väärtusi.
- [ ] `git status --short` ei kuva `.env` faili.
- [ ] `git ls-files .env` ei tagasta midagi.

### Andmete laadimine

- [ ] Supabase’i klient luuakse koolitaja koodi järgi.
- [ ] `get_data()` laadib andmed 1000 rea kaupa.
- [ ] `sales`, `customers` ja `products` laaditakse eraldi DataFrame’idesse.
- [ ] Iga tabeli `shape` on kontrollitud.
- [ ] Tabelid ühendatakse `left` merge’idega.
- [ ] Ühendatud `df.shape` on kontrollitud.

### Notebook

- [ ] Kuupäev teisendatakse `pd.to_datetime()` abil.
- [ ] Analüüsi põhikäsud töötavad.
- [ ] Plotly diagramm avaneb.
- [ ] `Kernel → Restart & Run All` töötab veata.
- [ ] Notebook’i väljund ei kuva Supabase’i võtit.

---

## Kokkuvõte

Koolituse põhivoog on:

```text
.env
  ↓
load_dotenv()
  ↓
os.getenv()
  ↓
create_client()
  ↓
get_data() — 1000 rida korraga
  ↓
df_sales + df_customers + df_products
  ↓
pd.merge(..., how='left')
  ↓
shape ja andmetüüpide kontroll
  ↓
Roll B puhastamine
  ↓
Roll C RFM-analüüs
```

GitHubi lähevad notebook, README, analüüs, `.gitignore` ja vajaduse korral `.env.example`. Lokaalne `.env` fail ning selle tegelikud väärtused GitHubi ei lähe.

