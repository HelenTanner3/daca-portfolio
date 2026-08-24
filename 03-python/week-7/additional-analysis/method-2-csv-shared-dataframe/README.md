# Meetod 2 — CSV + ühine DataFrame

## Eesmärk

See analüüs valmis **pärast Nädal 7 grupitööd** iseseisva järelkontrollina.

Eesmärk oli läbida kogu A → B → C → D töövoog uuesti CSV-lähteandmetega ning kontrollida, kuidas RFM-tulemust mõjutavad andmeallikas, puhastamine ja viitekuupäeva kasutamine.

## Olulisemad tulemused

- Toorandmetes oli **15 234 müügirida** ja **3 150 klienti**.
- Viitekuupäevaks säilitati koolituse kuupäev **2025-02-28**.
- Enne RFM-arvutust eemaldati **238 viitekuupäevast hilisemat müügirida**.
- Pärast puhastamist jäi **8 712 RFM-i sobivat tehingut** ja **2 515 klienti**.
- Negatiivseid Recency väärtusi oli **0**.

RFM segmentide jaotus:

| Segment | Kliente | Osakaal |
|---|---:|---:|
| Potential | 740 | 29,42% |
| Loyal | 684 | 27,20% |
| At Risk | 512 | 20,36% |
| VIP Champions | 455 | 18,09% |
| Lost | 124 | 4,93% |

## Artefaktid

- [`week7_method2_csv_shared.ipynb`](week7_method2_csv_shared.ipynb)
- [`../data_raw/`](../data_raw/) — kasutatud toor-CSV failid

See töö on Meetod 1-st eraldi hilisem kontroll, mitte selle ümberkirjutatud versioon.

Detailne võrdlus, metoodika ja õppetunnid on kirjeldatud [`../../analysis.md`](../../analysis.md) failis.
