# Täiendavad analüüsid

See kaust sisaldab Nädal 7 täiendavaid iseseisvaid tervikläbimisi, mis ei kuulunud kohustusliku individuaalse Roll C ülesande hulka.

Eesmärk oli kontrollida ja kinnistada kogu A → B → C → D töövoogu erinevates õppimise etappides.

## Sisu

### Method 1 — Supabase + shared DataFrame

method-1-supabase-shared-dataframe/

Enne grupitööd tehtud ettevalmistav terviktest. Andmed laaditi Supabase'ist ning sama DataFrame liikus järjest läbi laadimise, puhastamise, RFM-analüüsi ja visualiseerimise etappide.

### Method 2 — CSV + shared DataFrame

method-2-csv-shared-dataframe/

Pärast grupitööd tehtud iseseisev tervikläbimine. CSV-andmeallikas võimaldas keskenduda pandas'e töövoole, andmete kontrollimisele ja RFM-analüüsi loogikale.

## Andmed

`data_raw/` sisaldab Method 2 analüüsis kasutatud puhastamata CSV-lähteandmeid (`sales.csv` ja `customers.csv`).

Täpsemad tulemused, kontrollid ja õppetunnid on kirjeldatud Nädal 7 põhikausta failis analysis.md.
