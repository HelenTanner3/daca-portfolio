# Nädal 8 — Python API-d ja automatiseeritud pipeline

## Eesmärk

Nädal 8 keskendus varasema käsitsi tehtava andmetöötluse ühendamisele üheks automatiseeritud pipeline'iks: andmete laadimine → puhastamine ja koondamine → visualiseerimine → eksport.

Minu roll oli **Roll D — Automation Script**. Ülesanne oli ühendada Rollide A, B ja C moodulid `pipeline.py` abil üheks järjestikuseks töövooks, lisada logimine ja veakäsitlus ning kontrollida, et kogu protsess töötab ühe käsuga.

## Minu artefakt

- [`pipeline.py`](./pipeline.py) — Roll D lõplik orkestreeriv skript
- [`analysis.md`](./analysis.md) — detailsem töö- ja valideerimiskokkuvõte
- [`output/`](./output/) — valideeritud lõppväljundid
- [`additional-analysis/abc-integration-test/`](./additional-analysis/abc-integration-test/) — õppimise käigus loodud diagnostiline A→B→C→D integratsioonitest

Tervikpipeline kasutab grupi mooduleid `data_fetcher.py`, `transform.py` ja `visualize_export.py`.

[Grupi Week 8 töö](https://github.com/Kolju3/DACA-group/tree/main/week-8/group)

## Käivitamine

Kogu andmestik:

```powershell
python pipeline.py
```

Kuupäevapiiranguga:

```powershell
python pipeline.py --date 2025-03-01
```

Kasutatud loogikas tähendab `--date 2025-03-01`, et müügid võetakse **enne 01.03.2025**, s.t kuni 28.02.2025.

## Valideeritud tulemus

| Kontroll | Tulemus |
|---|---:|
| Müügiridu pärast API filtrit | 10 086 |
| Unikaalseid `id` väärtusi | 10 086 |
| Unikaalseid `sale_id` väärtusi | 10 086 |
| Duplikaate `id` / `sale_id` järgi | 0 |
| Puhastatud ridu | 8 923 |
| Nädalaid | 114 |
| Kogukäive | 2 669 027,39 € |
| Unikaalseid kliente | 2 540 |
| Keskmine ostusumma | 299,12 € |

Pipeline tekitas CSV-väljundi ning kaks interaktiivset Plotly HTML-visualiseeringut.

## Oluline kvaliteedikontroll

Integratsioonitestis selgus, et ainult edukast API vastusest ei piisa. Kuupäevafiltriga päring tagastas algselt küll 10 086 rida, kuid neist ainult 10 026 olid unikaalsed. Stabiilse järjestuse lisamine offset-pagination'ile (`order("id")`) kõrvaldas 60 duplikaati ja 60 puuduoleva rea probleemi.

See kinnitas praktiliselt põhimõtet: **pipeline'i väljundit tuleb valideerida referentsväärtuste ja unikaalsuskontrollidega, mitte ainult selle järgi, kas kood jookseb veata.**

## AI kasutamine

Kasutasin AI-d eeskätt veaotsingu, kontrollküsimuste ja testide koostamise abivahendina. Tehnilised järeldused kinnitasin reaalse pipeline'i käivitamise, ridade arvu, unikaalsete võtmete ja KPI-de võrdlemisega.
