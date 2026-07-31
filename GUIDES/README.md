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
├── 05_templates/
└── 06_markdown_documentation/
    └── markdown_working_guide.md
```

Kaustad `03_sql_supabase`, `04_powerbi` ja `05_templates` võivad alguses sisaldada ainult tulevaste juhendite struktuuri või lisanduda hiljem.

## 01 Environment Setup

Õpikeskkonna ja töövahendite seadistamise juhendid.

- [PowerShelli põhikäsud ja praktiline kasutamine](01_environment_setup/powershell_basics.md)

Juhend käsitleb kaustades liikumist, failide kontrollimist, käsuajaloo kasutamist, mitmerealisi käske ning levinumaid PowerShelli probleeme.

## 02 Git & GitHub

GitHubi ja Giti töövoo juhendid.

- [Git ja GitHub: lihtne töövoog](02_git_github/git_basic_workflow.md)  
  Igapäevane töövoog isiklikus ja grupirepos. Grupirepo erisammud on eraldi märgitud.

- [Git käskude referents](02_git_github/git_commands_reference.md)  
  Käskude koond staatuse kontrollimiseks, muudatuste lisamiseks, harude haldamiseks ja vigade parandamiseks.

## 03 SQL & Supabase

SQL-i ja Supabase’i kasutamise juhendid.

Planeeritud teemad:

- SQL põhikäsud;
- `SELECT`, `WHERE`, `ORDER BY` ja `LIMIT`;
- `COUNT` ja `COUNT DISTINCT`;
- `NULL` väärtuste kontroll;
- duplikaatide otsimine;
- andmekvaliteedi kontrollid;
- Supabase’i tabelite kasutamine.

## 04 Power BI

Power BI märkmed ja juhendid.

Planeeritud teemad:

- andmete import;
- andmemudeli põhimõtted;
- visuaalide valik;
- DAX mõõdikud;
- filtrid ja interaktsioonid;
- raporti esitluskõlblik vormistamine;
- värvipimedatele sobiv kujundus;
- dashboard’i dokumenteerimine.

## 05 Templates

Korduvkasutatavad mallid.

Planeeritud mallid:

- nädala lühikese README mall;
- eraldi `analysis.md` mall;
- esitluse kokkuvõtte mall;
- NotebookLM RAG faili mall;
- GitHubi commit’i kontrollnimekiri.

## 06 Markdown & Documentation

Markdowni ja GitHubi dokumentatsiooni juhendid.

- [Markdowni praktiline tööjuhend](06_markdown_documentation/markdown_working_guide.md)

Juhend käsitleb pealkirju, loendeid, linke, pilte, tabeleid, koodiplokke, suhtelisi failiteid, README ja analüüsi eristamist ning levinumate vormistusvigade lahendamist.

## Soovitatav kasutamise järjekord

1. Alusta [PowerShelli põhijuhendist](01_environment_setup/powershell_basics.md), kui terminali kasutamine ei ole veel kindel.
2. Kasuta igapäevases töös [Giti lihtsat töövoogu](02_git_github/git_basic_workflow.md).
3. Ava [Git käskude referents](02_git_github/git_commands_reference.md), kui vajad harvem kasutatavat käsku.
4. Kontrolli dokumentatsiooni vormistamist [Markdowni juhendist](06_markdown_documentation/markdown_working_guide.md).

## Kasutamise põhimõtted

1. Hoian siin ainult korrastatud ja taaskasutatavaid juhendeid.
2. Isiklikud mustandid ja pooleliolevad märkmed jäävad Notioni või lokaalsesse märkmesse.
3. Avalikku reposse ei lisa paroole, API võtmeid, privaatseid linke ega tundlikku infot.
4. Iga juhend peab olema piisavalt selge, et seda saaks hiljem kasutada ilma varasema vestluse abita.
5. Juhend peab eristama tavapärast töövoogu, grupirepo erisamme ja riskantsemaid paranduskäske.
6. README jääb lühikeseks; põhjalikum analüüs paigutatakse eraldi `analysis.md` faili.
7. Dokumentatsioon peab kirjeldama tegelikult tehtud tööd ja kontrollitud tulemusi.

## Minu tavapärane GitHubi töövoog

### Isiklik repo

```powershell
git status
git pull --ff-only
git status --short
git add -- ".\vajalik-kaust"
git commit -m "Kirjeldav commit message"
git push
git status
```

### Grupirepo

Grupirepos kasutatakse eraldi tööharu ja pull request’i.

```powershell
git switch main
git pull --ff-only
git switch -c uus-tööharu
git add -- ".\enda-töö-kaust"
git commit -m "Kirjeldav commit message"
git push -u origin uus-tööharu
```

Pärast pull request’i ühendamist:

```powershell
git switch main
git pull --ff-only
git branch -d uus-tööharu
git fetch --prune
```

## Märkus

Juhendite kaust asub minu isiklikus portfooliorepos. Grupireposse `DACA-group` ma isiklikke üldjuhendeid ei lisa.
