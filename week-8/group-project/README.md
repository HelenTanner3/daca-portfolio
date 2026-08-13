# Nädal 8 grupitöö lõppversioon

See kaust säilitab Nädal 8 lõpliku grupitöö koopiana minu isiklikus portfoolios.

## Meeskonna rollid

- **Roll A - Kalju:** API andmete laadimine
- **Roll B - Natalia:** andmete töötlemine ja puhastamine
- **Roll C - Olga:** visualiseerimine ja eksport
- **Roll D - Helen:** pipeline'i integratsioon ja tervikvoo valideerimine

## Allikas

Algne grupirepo: https://github.com/Kolju3/DACA-group
Lähtecommit: 65519d0008b1c229555384531350b6aff10be648

Grupi algne README on säilitatud failina GROUP_README.md.

## Põhifailid

- data_fetcher.py - Supabase API andmete laadimine
- transform.py - andmete ühendamine, puhastamine, koondamine ja KPI-de arvutamine
- visualize_export.py - visualiseerimine ja tulemuste eksport
- pipeline.py - kogu töövoo ühendamine üheks pipeline'iks

## Valideerimine

Tervikpipeline valideeriti käsuga:

python pipeline.py --date 2025-03-01

![Pipeline execution validation](output/pipeline_execution_validation.png)

Snapshot on lisatud isiklikku portfooliosse, et säilitada lõplik grupitöö sõltumatult algsest grupirepost.
