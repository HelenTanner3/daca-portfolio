# Täiendavad analüüsid

See kaust sisaldab kahte Nädal 8 ametlikku Roll D tööd toetavat, kuid sellest eraldi säilitatud tööprotsessi. Need tekkisid eri etappides ja täidavad erinevat eesmärki.

```text
abc-integration-test/
→ enne lõpliku grupiversiooni kinnitamist
→ integratsiooni ja andmekvaliteedi diagnostika

rfm-automation/
→ pärast grupitöö valmimist ja esitlusel saadud tagasisidet
→ Nädal 7 RFM-analüüsi muutmine Nädal 8 API-pipeline'i osaks
```

Detailne protsess, kontrollväärtused ja õppetunnid on kirjeldatud Nädal 8 põhikausta failis [`analysis.md`](../analysis.md).

## 1. A–B–C integratsioonitest

Kaust: [`abc-integration-test/`](abc-integration-test/)

### Eesmärk

Enne lõpliku grupiversiooni kinnitamist koondasin Rollide A, B ja C tööversioonid diagnostilisse keskkonda, et kontrollida nende omavahelist sobivust ja valmistada ette Roll D integratsioon.

Diagnostiline `pipeline.py` kontrollis lisaks tavapärasele töövoole:
- `id` ja `sale_id` unikaalsust;
- `invoice_id` duplikaate;
- kriitilisi NULL-väärtusi;
- mittepositiivseid müügisummasid;
- puhastamisel eemaldatud ridade arvu;
- vahetulemuste ja KPI-de kooskõla.

### Täisandmestiku kontroll

| Kontroll | Tulemus |
|---|---:|
| Müügiridu | 10 118 |
| Kliendiridu | 3 150 |
| Puhastatud ridu | 8 950 |
| Kogukäive | 2 676 850,54 € |
| Unikaalseid kliente | 2 540 |
| Keskmine ostusumma | 299,09 € |

Kontrollide käigus selgus ka, et kuupäevafiltriga offset-pagination võis tagastada õige ridade koguarvu, kuid siiski sisaldada duplikaate ja jätta osa kirjeid vahele. See leid viis stabiilse järjestuse kontrollini ja lõplikus grupiversioonis kasutati pagination'i juures `order("id")`.

### Sisu

Kaust sisaldab diagnostilises testis kasutatud A, B ja C tööversioone, Roll D integratsiooniskripti ning testi väljundeid. Tegemist on õppimis- ja kvaliteedikontrolli versiooniga, mitte lõpliku grupitöö asendusega.

---

## 2. RFM automatiseerimine

Kaust: [`rfm-automation/`](rfm-automation/)

### Eesmärk

Pärast Nädal 8 grupitöö valmimist ja esitlusel saadud tagasisidet laiendasin olemasolevat API-pipeline'i nii, et see automatiseeriks ka Nädal 7 RFM-kliendisegmenteerimise.

Aluseks võtsin lõpliku Nädal 8 grupipipeline'i. Olemasolev A → B → C → D töövoog jäi alles ning RFM lisati eraldi täiendusena, mitte varasema koodi ümberkirjutamisena.

### Lisatud loogika

`transform.py`:
- RFM mõõdikute arvutamine;
- R-, F- ja M-skoorid;
- RFM koondskoor;
- segmendid `VIP Champions`, `Loyal`, `Potential`, `At Risk` ja `Lost`.

`visualize_export.py`:
- RFM segmentide visualiseering;
- RFM tulemuste CSV eksport.

`pipeline.py`:
- RFM arvutus lisati olemasolevasse töövoogu;
- sama `--date` väärtus juhib nii API lõppkuupäeva kui ka RFM viitekuupäeva;
- logitakse RFM tabeli suurus ja negatiivsete Recency väärtuste kontroll.

### Käivitamine

```powershell
python pipeline.py --date 2025-03-01
```

### Valideeritud tulemus

| Kontroll | Tulemus |
|---|---:|
| Puhastatud müügiridu | 8 923 |
| RFM kliente | 2 540 |
| Negatiivseid Recency väärtusi | 0 |
| Frequency summa | 8 923 |
| Monetary summa | 2 669 027,39 € |

Segmentide jaotus:

| Segment | Kliente |
|---|---:|
| Potential | 768 |
| Loyal | 678 |
| At Risk | 524 |
| VIP Champions | 453 |
| Lost | 117 |
| **Kokku** | **2 540** |

### Väljundid

`rfm-automation/output/` sisaldab muu hulgas:
- `results_20260813.csv`;
- `rfm_segments_20260813.csv`;
- `rfm_segments.html`;
- `rfm_segments.png`;
- `weekly_revenue.html`;
- `weekly_revenue.png`;
- `kpi_summary.html`;
- `kpi_summary.png`;
- `pipeline_with_rfm_execution_validation.png`.

RFM automatiseerimine on täiendav edasiarendus, mitte Nädal 8 ametliku Roll D põhiartefakti asendus.
