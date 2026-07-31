# Git käskude referents

See fail on käsureferents. Igapäevase samm-sammulise töövoo jaoks kasuta faili [git_basic_workflow.md](git_basic_workflow.md).

Käsud on kohandatud Windows PowerShelli, VS Code’i, isikliku `daca-portfolio` repo ja grupi `DACA-group` repo jaoks.

## 1. Repo ja ühenduse kontroll

| Käsk | Selgitus |
|---|---|
| `git status` | Näitab töökausta, stagingu ja haru seisu. |
| `git status --short` | Näitab muudatusi lühivormis. |
| `git status -sb` | Näitab haru ning kohaliku ja remote’i võrdlust. |
| `git remote -v` | Näitab, millise GitHubi repoga kohalik repo seotud on. |
| `git branch --show-current` | Näitab aktiivset haru. |
| `git branch -vv` | Näitab kohalikke harusid ja nende remote-seoseid. |
| `git fetch origin` | Uuendab infot GitHubi harude ja commit’ide kohta, kuid ei muuda tööfaile. |
| `git fetch --prune origin` | Uuendab remote-infot ja eemaldab aegunud remote-harude viited. |

Isikliku repo remote:

```text
https://github.com/HelenTanner3/daca-portfolio.git
```

Grupirepo remote:

```text
https://github.com/Kolju3/DACA-group.git
```

Kontroll:

```powershell
git remote -v
```

## 2. GitHubi muudatuste allatoomine

| Käsk | Selgitus |
|---|---|
| `git pull --ff-only` | Toob muudatused alla ainult siis, kui haru saab turvaliselt edasi nihutada. |
| `git fetch origin` | Uuendab remote-infot ilma tööfaile muutmata. |
| `git diff --name-status HEAD..origin/main` | Näitab GitHubi `main` harus olevaid failimuudatusi, mida kohalikus `HEAD`-is veel ei ole. |
| `git ls-tree -r --name-only origin/main` | Näitab GitHubi `main` haru failide nimekirja. |

Kui muutsid faili otse GitHubis:

```powershell
git status
git pull --ff-only
```

## 3. Muudatuste vaatamine

| Käsk | Selgitus |
|---|---|
| `git diff` | Näitab stagingusse lisamata muudatusi. |
| `git diff -- ".\fail.md"` | Näitab ühe faili stagingusse lisamata muudatusi. |
| `git diff --cached` | Näitab stagingusse lisatud muudatusi. |
| `git diff --cached --stat` | Näitab stagingu failide ja muudatuste mahu kokkuvõtet. |
| `git diff --cached --name-status` | Näitab stagingus olevate failide nimed ja muutuse liigi. |
| `git diff --check` | Kontrollib muu hulgas üleliigseid tühikuid ja mõningaid vormistusprobleeme. |
| `git log -3 --oneline` | Näitab kolme viimast commit’i. |
| `git log --oneline --all --graph --decorate -10` | Näitab harude ja commit’ide seoseid graafilises lühivaates. |

Diff-vaatest väljumiseks vajuta:

```text
q
```

## 4. Failide lisamine stagingusse

| Käsk | Selgitus |
|---|---|
| `git add -- ".\fail.md"` | Lisab ühe faili stagingusse. |
| `git add -- ".\kaust"` | Lisab ühe kausta muudatused stagingusse. |
| `git add -A -- ".\kaust"` | Lisab kaustas uued, muudetud, eemaldatud ja ümber nimetatud failid. |
| `git add .` | Lisab kogu repo kõik muudatused. Kasuta ainult siis, kui oled `git status --short` tulemuse üle kontrollinud. |

Soovitus: eelista konkreetse faili või kausta lisamist.

## 5. Commit ja push

| Käsk | Selgitus |
|---|---|
| `git commit -m "Message"` | Loob stagingus olevatest muudatustest commit’i. |
| `git push` | Saadab kohaliku haru commit’id selle seotud remote-harusse. |
| `git push -u origin <haru>` | Saadab uue tööharu GitHubi ja loob jälgimisseose. |
| `git push origin --delete <haru>` | Kustutab remote-haru GitHubist. |

Hea commit’i sõnum kirjeldab, mida muudeti:

```powershell
git commit -m "Update week 6 dashboard interactivity"
```

Väldi liiga üldisi sõnumeid:

```text
update
changes
test
```

## 6. Harude haldamine

| Käsk | Selgitus |
|---|---|
| `git branch` | Näitab kohalikke harusid. |
| `git branch -a` | Näitab kohalikke ja remote-harusid. |
| `git branch --merged main` | Näitab kohalikke harusid, mis on `main` harusse ühendatud. |
| `git branch --no-merged main` | Näitab kohalikke harusid, mis ei ole `main` harusse ühendatud. |
| `git switch main` | Liigub `main` harusse. |
| `git switch -c <haru>` | Loob uue haru ja liigub sinna. |
| `git branch -d <haru>` | Kustutab ühendatud kohaliku haru. |
| `git branch -D <haru>` | Sunnib kohaliku haru kustutamise. Kasuta ainult siis, kui oled kindel, et ühendamata töö ei ole vajalik. |

Grupirepo tavapärane algus:

```powershell
git switch main
git pull --ff-only
git switch -c week-6-helen-dashboard-update
```

Pärast PR-i merge’i:

```powershell
git switch main
git pull --ff-only
git branch -d week-6-helen-dashboard-update
git fetch --prune
```

## 7. Muudatuste tühistamine

| Käsk | Selgitus |
|---|---|
| `git restore -- ".\fail.md"` | Tühistab faili commit’imata muudatused. Muudatused kaovad. |
| `git restore --staged ".\fail.md"` | Eemaldab faili stagingust, kuid jätab muudatused töökausta alles. |
| `git revert <commit>` | Loob uue commit’i, mis tühistab varasema commit’i. Sobib jagatud ajaloos. |
| `git reset --soft HEAD~1` | Võtab viimase kohaliku commit’i tagasi ja jätab muudatused stagingusse. Kasuta ainult enne push’i ja teadliku otsusena. |

### Vale commit’imata muudatus

```powershell
git diff -- ".\week-2\README.md"
git restore -- ".\week-2\README.md"
git status --short
```

### Vale fail stagingus

```powershell
git restore --staged ".\week-2\README.md"
git status --short
```

### GitHubi saadetud commit’i tühistamine

Kasuta jagatud ajaloos üldjuhul:

```powershell
git revert <commit-hash>
git push
```

Ära kirjuta avaliku või grupirepo ajalugu ümber juhusliku `reset --hard` ja force-push kombinatsiooniga.

## 8. Failide olemasolu ja nimede kontroll

Need on PowerShelli käsud, mitte Git-käsud.

| Käsk | Selgitus |
|---|---|
| `Get-Location` | Näitab praegust kausta. |
| `Get-ChildItem` | Näitab kausta sisu. |
| `Get-ChildItem ".\kaust" -Recurse` | Näitab kausta ja alamkaustade sisu. |
| `Test-Path ".\fail.md"` | Kontrollib, kas fail on olemas. |
| `Get-Item ".\fail.pbix"` | Näitab faili andmeid. |
| `Move-Item "vana" "uus"` | Nimetab faili ümber või liigutab selle. |

Pärast jälgitava faili ümbernimetamist:

```powershell
git add -A -- ".\vajalik-kaust"
```

## 9. Levinumad veateated

### `nothing to commit, working tree clean`

Kõik muudatused on commit’itud.

### `Untracked files`

Git näeb uusi faile. Lisa ainult vajalik fail või kaust:

```powershell
git add -- ".\vajalik-kaust"
```

### `behind 4`

Kohalik haru on GitHubist nelja commit’i võrra maas:

```powershell
git pull --ff-only
```

### `ahead 1`

Sul on üks GitHubi saatmata kohalik commit:

```powershell
git push
```

### `fetch first`

GitHubis on uuemaid muudatusi:

```powershell
git fetch origin
git status -sb
```

Kui tööpuu on puhas ja haru on ainult `behind`:

```powershell
git pull --ff-only
```

### `fatal: not a git repository`

Oled vales kaustas.

```powershell
Get-Location
cd "C:\Users\Helen\data-analysis-course\daca-portfolio"
```

### `Repository not found`

Kontrolli remote’i ja ligipääsu:

```powershell
git remote -v
```

### `Cannot delete branch ... not fully merged`

Haru ei ole Giti arvates ühendatud. Kontrolli:

```powershell
git branch --no-merged main
git log --oneline --all --graph --decorate -10
```

Ära kasuta `-D` valikut enne, kui oled veendunud, et ühendamata töö pole vajalik.

## 10. Kiirspikker

| Olukord | Käsk |
|---|---|
| Kontrollin seisu | `git status` |
| Kontrollin haru | `git branch --show-current` |
| Uuendan remote-infot | `git fetch --prune origin` |
| Toon GitHubi muudatused alla | `git pull --ff-only` |
| Vaatan kohalikke muudatusi | `git diff` |
| Lisan ühe kausta | `git add -- ".\kaust"` |
| Kontrollin stagingut | `git diff --cached --stat` |
| Teen commit’i | `git commit -m "Message"` |
| Saadan commit’i GitHubi | `git push` |
| Loon grupirepo tööharu | `git switch -c <haru>` |
| Saadan uue haru GitHubi | `git push -u origin <haru>` |
| Eemaldan faili stagingust | `git restore --staged ".\fail"` |
| Tühistan commit’imata muudatuse | `git restore -- ".\fail"` |
| Puhastan remote-harude viited | `git fetch --prune origin` |

## 11. Ohutu kontroll enne järgmist sammu

```powershell
Get-Location
git branch --show-current
git status --short
git status -sb
git log -3 --oneline
```

Need käsud näitavad seisu ega muuda faile.
