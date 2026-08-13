# Nädal 8 grupitöö lõppversioon

See kaust säilitab Nädal 8 lõpliku grupitöö koopiana minu isiklikus portfoolios.

## Grupitöö

Nädal 8 grupitöö eesmärk oli ühendada neli eraldi moodulit üheks API-põhiseks automatiseeritud pipeline'iks:

```text
Roll A — andmete pärimine
→ Roll B — andmete töötlemine
→ Roll C — visualiseerimine ja eksport
→ Roll D — tervikpipeline'i orkestreerimine
```

## Meeskonna rollid

- **Roll A — Kalju:** API andmete laadimine (`data_fetcher.py`)
- **Roll B — Natalia:** andmete töötlemine ja puhastamine (`transform.py`)
- **Roll C — Olga:** visualiseerimine ja eksport (`visualize_export.py`)
- **Roll D — Helen:** pipeline'i integratsioon ja tervikvoo valideerimine (`pipeline.py`)

## Allikas

Algne grupirepo: https://github.com/Kolju3/DACA-group
Lähtecommit: `65519d0008b1c229555384531350b6aff10be648`

Grupi algne README on säilitatud failina [`GROUP_README.md`](GROUP_README.md).

## Põhifailid

- [`data_fetcher.py`](data_fetcher.py) — Supabase API andmete laadimine
- [`transform.py`](transform.py) — andmete ühendamine, puhastamine, koondamine ja KPI-de arvutamine
- [`visualize_export.py`](visualize_export.py) — visualiseerimine ja tulemuste eksport
- [`pipeline.py`](pipeline.py) — kogu töövoo ühendamine üheks pipeline'iks
- [`output/`](output/) — lõpliku valideeritud grupitöö väljundid

## Valideerimine

Lõplik tervikpipeline valideeriti käsuga:

```powershell
python pipeline.py --date 2025-03-01
```

Valideeritud kontrolljoon:

```text
10 086 API-rida
→ 8 923 puhastatud rida
→ KPI-d + nädalane trend + CSV
```

![Pipeline'i käivitamise valideerimine](output/pipeline_execution_validation.png)

Koopia on lisatud isiklikku portfooliosse, et säilitada lõplik grupitöö sõltumatult algsest grupirepost.