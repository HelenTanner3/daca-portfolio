# Nädal 7 — Python ja pandas: RFM-kliendisegmenteerimine

## Eesmärk

Analüüsida UrbanStyle'i klientide ostukäitumist RFM-meetodiga ning jagada kliendid Recency, Frequency ja Monetary näitajate põhjal äriliselt kasutatavatesse segmentidesse.

## Minu roll

**Roll C — RFM-analüüs.**

Arvutasin Roll B puhastatud andmestikust kliendipõhised RFM-mõõdikud, määrasin R-, F- ja M-skoorid ning moodustasin kliendisegmendid.

## Peamised tulemused

- RFM-analüüs hõlmas **2 540 klienti**.
- VIP Champions segmenti kuulus **455** ja Loyal segmenti **679** klienti.
- VIP Champions ja Loyal moodustasid kokku **44,65% klientidest**, kuid **72,57% analüüsitud Monetary väärtusest**.
- Potential oli **759 kliendiga** suurim segment.

## Järeldus

Kõige suurem äriline mõju on väärtuslike klientide hoidmisel ning Loyal- ja Potential-segmentide kasvatamisel. At Risk klientide taasaktiveerimisel tasub eelistada suurema varasema väärtusega kliente.

## Kasutatud oskused ja tööriistad

Python, pandas, Jupyter Notebook, Supabase, Plotly, groupby, merge, pd.qcut, andmekvaliteedi kontroll ja RFM-segmenteerimine.

## AI kasutamine

Kasutasin AI-d pandas- ja RFM-loogika kontrollimisel, vigade analüüsimisel ning dokumentatsiooni struktureerimisel. Koodi ja tulemusi kontrollisin reaalselt käivitatud notebook'ide ning kontrollväärtuste põhjal.

## Artefaktid

- [Ametlik Roll C notebook](week7_role_c_rfm_analysis.ipynb)
- [Detailne analüüs](analysis.md)
- [Grupitöö lõppversioon](group-project/)
- [Täiendavad iseseisvad analüüsid](additional-analysis/)
