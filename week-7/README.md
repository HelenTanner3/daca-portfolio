# Nädal 7 — Python ja pandas: RFM-kliendisegmenteerimine

## Eesmärk

Analüüsida UrbanStyle'i klientide ostukäitumist RFM-meetodiga ning jagada kliendid Recency, Frequency ja Monetary näitajate põhjal äriliselt kasutatavatesse segmentidesse.

RFM-meetod vastab kolmele küsimusele:

- **Recency** — kui hiljuti klient viimati ostis;
- **Frequency** — kui sageli klient ostab;
- **Monetary** — kui suur on kliendi kogukulutus.

## Minu roll ja töö ulatus

Minu ametlik vastutus grupitöös oli **Roll C — RFM-analüüs**. Arvutasin Roll B puhastatud andmestikust kliendipõhised RFM-mõõdikud, määrasin R-, F- ja M-skoorid, moodustasin kliendisegmendid ning kontrollisin tulemuste loogikat.

Isikliku õppimise eesmärgil läbisin eraldi notebook'is ka kogu töövoo:

1. andmete laadimine Supabase'ist;
2. andmete uurimine ja tabelite ühendamine;
3. andmekvaliteedi kontroll ja puhastamine;
4. RFM-mõõdikute ja segmentide arvutamine;
5. visualiseerimine;
6. äriliste järelduste ja piirangute sõnastamine.

Ametlik Roll C notebook ja terviklik õppimisnotebook on eraldi artefaktid. Neid ei käsitleta ühe ja sama tööversioonina.

## Andmeallikas ja tööriistad

Analüüs kasutas UrbanStyle'i koolitusandmeid grupi Supabase'ist.

Kasutatud tööriistad ja võtted:

- Python ja pandas;
- Jupyter Notebook;
- Supabase ja `python-dotenv`;
- `groupby`, `merge`, `pd.qcut`, `apply` ja `value_counts`;
- Plotly visualiseeringud;
- Git ja GitHub.

Supabase'i ühendusandmed loetakse lokaalsest `.env` failist. Tegelikke ühendusandmeid reposse ei lisata.

## Peamised tulemused

Terviklikus isiklikus töövoos:

- laaditi **10 118 müügirida**, **3 150 kliendirida** ja **362 tooterida**;
- RFM-analüüsiks jäi pärast puhastamist **8 950 tehingut**;
- analüüs hõlmas **2 540 klienti**;
- analüüsitud Monetary koguväärtus oli **2 676 850,54 eurot**.

| Segment | Kliente | Klientide osakaal | Monetary osakaal |
|---|---:|---:|---:|
| VIP Champions | 455 | 17,91% | 42,82% |
| Loyal | 679 | 26,73% | 29,75% |
| Potential | 759 | 29,88% | 19,49% |
| At Risk | 529 | 20,83% | 7,18% |
| Lost | 118 | 4,65% | 0,76% |

VIP Champions ja Loyal moodustasid kokku **44,65% klientidest**, kuid **72,57% kogu Monetary väärtusest**.

## Järeldus

Kõige suurem äriline mõju on väärtuslike klientide hoidmisel ning Loyal- ja Potential-segmentide kasvatamisel. At Risk ja Lost moodustasid kokku 25,47% klientidest, kuid ainult 7,93% Monetary väärtusest, mistõttu tuleks taasaktiveerimistegevused seada prioriteeti kliendi varasema väärtuse järgi.

RFM-skoorid on suhtelised. Kõrge R-skoor ei tähenda automaatselt, et klient on kalendriliselt hiljuti ostnud. Turundusotsustes tuleb vaadata koos segmenti, Recency tegelikku päevade arvu ja kliendi kontaktandmete olemasolu.

## Kahe notebook'i metoodiline erinevus

- Ametlik Roll C notebook järgib koolituse juhendit ja kasutab viitekuupäeva **2025-02-28**.
- Terviklik isiklik õppimisnotebook kasutab andmestiku viimasele müügikuupäevale järgnevat kuupäeva **2026-06-29**, et vältida negatiivseid Recency väärtusi.

Segmentide arvud jäid samaks, sest kvintiilipõhine skoorimine sõltub klientide suhtelisest järjestusest. Recency absoluutne päevade arv ja selle äriline tõlgendus on siiski erinevad.

## AI kasutamine

AI-d kasutati õppematerjalide tõlgendamisel, pandas- ja Supabase'i koodi kontrollimisel, vigade analüüsimisel ning dokumentatsiooni struktureerimisel. Kood käivitati kohalikus töökeskkonnas ning tulemusi kontrolliti notebook'i väljundite, kontrollväärtuste ja grupitöö andmestiku põhjal.

## Artefaktid

- [Ametlik Roll C notebook](week7_role_c_rfm_analysis.ipynb)
- [Terviklik isiklik A–D õppimisnotebook](additional-analysis/week7_full_rfm_analysis.ipynb)
- [Detailne analüüs](analysis.md)
- [Grupi koondnotebook](https://github.com/Kolju3/DACA-group/blob/main/week-7/group/urbanstyle_operatsioonid_week7_(a_b_c_d).ipynb)
- [Minu Roll C töö grupirepos](https://github.com/Kolju3/DACA-group/tree/main/week-7/individual/helen)