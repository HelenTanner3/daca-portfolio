# Guides

See kaust sisaldab minu andmeanalüüsi õpingute tehnilisi juhendeid, töövoomärkmeid ja korduvkasutatavaid malle.

Juhendid on mõeldud selleks, et GitHubi, PowerShelli, SQL-i, Supabase’i, Power BI ja projekti dokumenteerimisega seotud teadmised oleksid ühes kohas ning hiljem uuesti kasutatavad ilma varasema vestluse konteksti taastamata.

## Kaustade struktuur

```text
GUIDES/
├── README.md
├── 01_environment_setup/
│   └── powershell_basics.md
├── 02_git_github/
│   ├── git_basic_workflow.md
│   └── git_commands_reference.md
├── 03_sql_supabase/
├── 04_powerbi/
│   └── power_bi_working_guide.md
├── 05_templates/
└── 06_markdown_documentation/
    └── markdown_working_guide.md
```

## 01 Environment Setup

- [PowerShelli põhikäsud ja praktiline kasutamine](01_environment_setup/powershell_basics.md)

## 02 Git & GitHub

- [Git ja GitHub: lihtne töövoog](02_git_github/git_basic_workflow.md)  
  Igapäevane töövoog isiklikus ja grupirepos.

- [Git käskude referents](02_git_github/git_commands_reference.md)  
  Harvem kasutatavad käsud, harude haldamine ja vigade parandamine.

## 03 SQL & Supabase

Siia koondan SQL-i ja Supabase’i juhendid.

Planeeritud teemad:

- SQL põhikäsud;
- andmete puhastamine;
- JOIN-id;
- agregatsioon;
- andmekvaliteedi kontrollid;
- Supabase’i ühendus ja töövoog.

## 04 Power BI

- [Power BI praktiline tööjuhend](04_powerbi/power_bi_working_guide.md)

Juhend põhineb DACA Nädal 5–6 koolitusel ning UrbanStyle’i CEO ja Tartu kaupluse dashboard’ide tegemisel. See hõlmab andmeühendust, mudelit, Calendar-tabelit, DAX-i, visuaale, filtreid, interaktsioone, annotatsioone, andmelugu, valideerimist, avaldamist ja tõrkeotsingut.

## 05 Templates

Siia koondan korduvkasutatavad mallid.

Planeeritud mallid:

- nädala lühikese README mall;
- `analysis.md` mall;
- esitluse kokkuvõtte mall;
- NotebookLM RAG faili mall;
- GitHubi commit’i kontrollnimekiri.

## 06 Markdown & Documentation

- [Markdowni praktiline tööjuhend](06_markdown_documentation/markdown_working_guide.md)

## Soovitatav kasutamise järjekord

1. [PowerShelli põhijuhend](01_environment_setup/powershell_basics.md)
2. [Giti lihtne töövoog](02_git_github/git_basic_workflow.md)
3. [Git käskude referents](02_git_github/git_commands_reference.md)
4. [Power BI praktiline tööjuhend](04_powerbi/power_bi_working_guide.md)
5. [Markdowni tööjuhend](06_markdown_documentation/markdown_working_guide.md)

## Kasutamise põhimõtted

1. Hoian siin korrastatud ja taaskasutatavaid juhendeid.
2. Avalikku reposse ei lisa paroole, API võtmeid, privaatseid linke ega tundlikku infot.
3. Juhend peab olema kasutatav ilma varasema vestluse konteksti taastamata.
4. README jääb lühikeseks; põhjalikum analüüs paigutatakse eraldi `analysis.md` faili.
5. Dokumentatsioon kirjeldab tegelikult tehtud tööd ja kontrollitud tulemusi.
6. Kontrollimata Power BI LIVE URL-i või funktsiooni ei esitata valmis lahendusena.

