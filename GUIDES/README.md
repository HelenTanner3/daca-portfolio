# Guides

See kaust sisaldab minu andmeanalüüsi õpingute tehnilisi juhendeid, töövoomärkmeid ja korduvkasutatavaid malle.

Juhendid on mõeldud selleks, et hoida GitHubi, SQL-i, Supabase’i, Power BI ja projekti dokumenteerimisega seotud teadmised ühes kohas ning lihtsasti leitavana.

## Kaustade struktuur

```text
GUIDES/
├── README.md
├── 01_environment_setup/
├── 02_git_github/
├── 03_sql_supabase/
├── 04_powerbi/
└── 05_templates/
```

## 01 Environment Setup

Õpikeskkonna ja töövahendite seadistamise juhendid.

Tulevased juhendid:

* VS Code seadistus
* Python virtuaalkeskkonna kasutamine
* Git paigalduse kontroll
* PowerShelli põhilised käsud
* Arenduskeskkonna kontrollnimekiri

## 02 Git & GitHub

GitHubi ja Git töövoo juhendid.

Olemasolevad juhendid:

* [Git basic workflow](02_git_github/git_basic_workflow.md)
* [Git commands reference](02_git_github/git_commands_reference.md)

Tulevased juhendid:

* Pull rebase töövoog
* Merge konfliktide lahendamine
* README linkide vormistamine
* Failide lisamine, muutmine ja kustutamine GitHubis

## 03 SQL & Supabase

SQL-i ja Supabase’i kasutamise juhendid.

Tulevased juhendid:

* SQL põhikäsud
* SELECT, WHERE, ORDER BY ja LIMIT
* COUNT ja COUNT DISTINCT
* NULL väärtuste kontroll
* Duplikaatide otsimine
* Andmekvaliteedi kontrollid
* Supabase tabelite kasutamine

## 04 Power BI

Power BI märkmed ja juhendid.

Tulevased juhendid:

* Andmete import
* Andmemudeli põhimõtted
* Visuaalide valik
* Lihtsamad DAX mõõdikud
* Raporti esitluskõlblik vormistamine

## 05 Templates

Korduvkasutatavad mallid.

Tulevased mallid:

* Nädala README mall
* Analüüsi kokkuvõtte mall
* Esitluse kokkuvõtte mall
* NotebookLM RAG faili mall
* GitHubi commit’i kontrollnimekiri

## Kasutamise põhimõtted

1. Hoian siin ainult korrastatud ja taaskasutatavaid juhendeid.
2. Isiklikud mustandid ja pooleliolevad mõtted jäävad pigem Notioni või lokaalsesse märkmesse.
3. Avalikku reposse ei lisa paroole, API võtmeid, privaatseid linke ega tundlikku infot.
4. Iga juhend peab olema piisavalt selge, et seda saaks hiljem uuesti kasutada ilma kogu vestlust või konteksti meelde tuletamata.
5. Kui juhend põhineb kellegi teise materjalil, lisan märkuse või viite allikale.

## Minu tavapärane GitHubi töövoog

```bash
git status
git pull --rebase origin main
git add .
git commit -m "Kirjeldav commit message"
git push
git status
```

## Märkus

See juhendite kaust asub minu isiklikus portfooliorepos. Grupireposse `DACA-group` ma isiklikke juhendeid ei lisa.
