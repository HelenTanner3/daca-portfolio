# Git Commands Reference

See juhend koondab põhilised Git käsud, mida kasutan andmeanalüüsi õpingute ja GitHubi portfoolio haldamisel.

Märkus: juhendi esialgne struktuur põhineb õpingukaaslase koostatud Git käskude koondil. Sisu on kohandatud minu enda töövoo, Windowsi PowerShelli ja `daca-portfolio` repo jaoks.

---

## Table of Contents

1. [Repository Setup](#repository-setup)
2. [Basic Workflow](#basic-workflow)
3. [Remote Repositories](#remote-repositories)
4. [Viewing History and Status](#viewing-history-and-status)
5. [Undoing Changes](#undoing-changes)
6. [Branching](#branching)
7. [Troubleshooting](#troubleshooting)
8. [Quick Cheat Sheet](#quick-cheat-sheet)

---

# Repository Setup

Käsud repo loomiseks, kloonimiseks ja ühenduse kontrollimiseks.

| Command                                            | Explanation                                                 |
| -------------------------------------------------- | ----------------------------------------------------------- |
| `git init`                                         | Loob praegusesse kausta uue Git repo.                       |
| `git clone <url>`                                  | Laeb GitHubi repo arvutisse.                                |
| `git remote -v`                                    | Näitab, millise GitHubi aadressiga lokaalne repo seotud on. |
| `git remote set-url origin <url>`                  | Muudab olemasoleva remote aadressi õigeks.                  |
| `git config --global user.name "Your Name"`        | Määrab Git kasutajanime.                                    |
| `git config --global user.email "you@example.com"` | Määrab Git e-posti aadressi.                                |
| `git config --list`                                | Näitab Git seadistusi.                                      |

Minu isikliku repo õige remote:

```powershell
git remote set-url origin https://github.com/HelenTanner3/daca-portfolio.git
```

Kontroll:

```powershell
git remote -v
```

Oodatav tulemus:

```text
origin  https://github.com/HelenTanner3/daca-portfolio.git (fetch)
origin  https://github.com/HelenTanner3/daca-portfolio.git (push)
```

---

# Basic Workflow

Igapäevane Git töövoog.

| Command                         | Explanation                                                          |
| ------------------------------- | -------------------------------------------------------------------- |
| `git status`                    | Näitab, mis seisus töökaust on.                                      |
| `git add <file>`                | Lisab konkreetse faili commit’i jaoks valmis.                        |
| `git add .`                     | Lisab kõik muudatused commit’i jaoks valmis.                         |
| `git commit -m "message"`       | Loob commit’i koos lühikese kirjeldusega.                            |
| `git push`                      | Saadab commit’id GitHubi.                                            |
| `git pull --rebase origin main` | Toob GitHubi muudatused alla ja paigutab sinu commit’id nende peale. |

Minu tavaline töövoog:

```powershell
git status
git pull --rebase origin main
git add .
git commit -m "Kirjeldav commit message"
git pull --rebase origin main
git push
git status
```

---

# Remote Repositories

Käsud GitHubi ühenduse haldamiseks.

| Command                         | Explanation                                                         |
| ------------------------------- | ------------------------------------------------------------------- |
| `git remote -v`                 | Näitab remote repo aadressi.                                        |
| `git pull`                      | Toob GitHubi muudatused alla ja teeb merge’i.                       |
| `git pull --rebase origin main` | Toob GitHubi muudatused alla rebase töövooga.                       |
| `git push`                      | Saadab kohalikud commit’id GitHubi.                                 |
| `git push -u origin main`       | Seob kohaliku branch’i GitHubi branch’iga ja saadab commit’id üles. |

Kui `git push` annab vea `fetch first`, siis kasutan:

```powershell
git pull --rebase origin main
git push
```

---

# Viewing History and Status

Käsud ajaloo ja muudatuste vaatamiseks.

| Command                           | Explanation                                        |
| --------------------------------- | -------------------------------------------------- |
| `git status`                      | Kõige olulisem kontrollkäsk. Näitab hetkeolukorda. |
| `git log --oneline`               | Näitab commit ajalugu lühidalt.                    |
| `git log --oneline --max-count=5` | Näitab viimased 5 commit’i.                        |
| `git diff`                        | Näitab muudatusi, mida ei ole veel staged.         |
| `git diff --staged`               | Näitab muudatusi, mis on juba staged.              |

Näide:

```powershell
git log --oneline --max-count=5
```

---

# Undoing Changes

Käsud vigade parandamiseks.

| Command                       | Explanation                                                                          |
| ----------------------------- | ------------------------------------------------------------------------------------ |
| `git restore <file>`          | Võtab failist tagasi salvestamata muudatused. Ettevaatlik: muudatused kaovad.        |
| `git restore --staged <file>` | Eemaldab faili staging alast, aga jätab muudatused alles.                            |
| `git reset --soft HEAD~1`     | Võtab viimase commit’i tagasi, aga jätab muudatused alles staged kujul.              |
| `git revert <commit-hash>`    | Loob uue commit’i, mis tühistab varasema commit’i muudatused. Sobib jagatud ajaloos. |

Kui lisasin kogemata faili staging alasse:

```powershell
git restore --staged <file>
```

Kui tahan vaadata seisu:

```powershell
git status
```

---

# Branching

Branch’e kasutan siis, kui tahan teha suuremaid muudatusi ilma `main` haru kohe mõjutamata.

| Command                       | Explanation                            |
| ----------------------------- | -------------------------------------- |
| `git branch`                  | Näitab olemasolevaid branch’e.         |
| `git switch -c <branch-name>` | Loob uue branch’i ja liigub sinna.     |
| `git switch main`             | Liigub tagasi main branch’i.           |
| `git merge <branch-name>`     | Ühendab branch’i praegusesse branch’i. |

Näide:

```powershell
git switch -c update-guides
```

Tagasi main branch’i:

```powershell
git switch main
```

---

# Troubleshooting

## Probleem: `Repository not found`

Võimalikud põhjused:

* remote aadress on vale;
* GitHubi repo on ümber nimetatud;
* repo on privaatne ja sisselogimine ei tööta;
* oled lokaalselt vales kaustas.

Kontroll:

```powershell
git remote -v
```

Parandus minu isikliku repo puhul:

```powershell
git remote set-url origin https://github.com/HelenTanner3/daca-portfolio.git
```

---

## Probleem: `fetch first`

See tähendab, et GitHubis on muudatusi, mida minu arvutis veel ei ole.

Lahendus:

```powershell
git pull --rebase origin main
git push
```

---

## Probleem: `Untracked files`

See tähendab, et Git näeb uusi faile, aga neid ei ole veel commit’i lisatud.

Lahendus:

```powershell
git add .
git commit -m "Add new files"
```

---

## Probleem: olen vales kaustas

Kontrollin terminali real olevat asukohta.

Õige isiklik repo:

```text
C:\Users\Helen\data-analysis-course\daca-portfolio
```

Grupirepo:

```text
C:\Users\Helen\data-analysis-course\DACA-group
```

Kui olen vales kohas, liigun õigesse kausta:

```powershell
cd C:\Users\Helen\data-analysis-course\daca-portfolio
```

---

# Quick Cheat Sheet

Kõige sagedamini kasutatavad käsud.

| Situation                    | Command                           |
| ---------------------------- | --------------------------------- |
| Kontrollin seisu             | `git status`                      |
| Tõmban viimased muudatused   | `git pull --rebase origin main`   |
| Lisan kõik muudatused        | `git add .`                       |
| Teen commit’i                | `git commit -m "Message"`         |
| Saadan GitHubi               | `git push`                        |
| Vaatan remote aadressi       | `git remote -v`                   |
| Vaatan viimaseid commit’e    | `git log --oneline --max-count=5` |
| Eemaldan faili staging alast | `git restore --staged <file>`     |
| Parandan remote aadressi     | `git remote set-url origin <url>` |

---

# Minu soovitatud Git tööharjumus

1. Alustan alati käsuga:

```powershell
git status
```

2. Enne tööd või enne push’i kasutan:

```powershell
git pull --rebase origin main
```

3. Commit message kirjeldab sisuliselt, mida muutsin.

4. Enne `push` käsku kontrollin, et olen õiges repos.

5. Kui Git annab vea, ei tee juhuslikke käske, vaid loen veateate läbi ja kontrollin esmalt:

```powershell
git status
git remote -v
```
