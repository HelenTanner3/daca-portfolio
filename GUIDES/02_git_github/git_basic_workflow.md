# Git ja GitHub: lihtne töövoog

See juhend sobib kasutamiseks nii isiklikus `daca-portfolio` repos kui ka grupi `DACA-group` repos.

Põhitöövoog on mõlemas repos sama:

```text
kontrolli → too GitHubi muudatused alla → muuda faile → lisa → commit → push → kontrolli
```

Kui samm puudutab ainult grupirepot, on see märgitud:

> **AINULT GRUPIREPO**

Kõiki käske ei pea pähe õppima. Oluline on osata kontrollida:

1. millises repos oled;
2. millises harus oled;
3. kas sul on kohalikke muudatusi;
4. kas GitHubis on uuemaid muudatusi.

## 1. Põhimõisted

- **Git** jälgib sinu arvutis failide muudatusi.
- **GitHub** hoiab repo kaugversiooni internetis.
- **Repo** on projektikaust, mida Git jälgib.
- **Branch ehk haru** on eraldi tööliin.
- **Commit** on salvestatud muudatuste pakett koos kirjeldusega.
- **Push** saadab commit’i GitHubi.
- **Pull** toob GitHubi uuemad commit’id arvutisse.
- **Pull request ehk PR** on ettepanek ühendada tööharu `main` harusse.
- **Staging** on vaheaste, kuhu valid järgmisse commit’i minevad failid.

## 2. Repode asukohad

### Isiklik portfoolio

```powershell
cd "C:\Users\Helen\data-analysis-course\daca-portfolio"
```

### Grupirepo

```powershell
cd "C:\Users\Helen\data-analysis-course\daca-group"
```

### Kontroll

```powershell
Get-Location
git branch --show-current
git status
```

## 3. Miks grupirepos kasutatakse haru?

> **AINULT GRUPIREPO**

Grupirepos ei tehta muudatusi tavaliselt otse `main` harusse. Selle asemel luuakse oma tööharu.

Näiteks:

```powershell
git switch -c week-6-helen-dashboard-update
```

Haru kasutamise eelised:

- sinu töö on teiste liikmete tööst eraldi;
- saad teha muudatusi ilma `main` haru kohe mõjutamata;
- GitHubis saab enne ühendamist kontrollida kõiki muudetud faile;
- pull request võimaldab töö üle vaadata;
- võimaliku vea saab parandada tööharus;
- GitHubi ajalukku jääb selge ülevaade muudatuse ühendamisest.

Lihtne loogika:

```text
main = kinnitatud ühine versioon
tööharu = sinu pooleliolev või ülevaatamist ootav töö
pull request = ettepanek ühendada töö main harusse
```

Isiklikus repos võib väiksemad muudatused teha otse `main` harusse, sest seal ei ole teisi meeskonnaliikmeid, kelle tööd võiks kogemata mõjutada.

## 4. Töö alustamine

Kontrolli repo seisu:

```powershell
git status
git branch --show-current
```

Too GitHubi uuemad muudatused alla:

```powershell
git pull --ff-only
```

`--ff-only` lubab pull’i ainult siis, kui kohalik haru saab turvaliselt edasi liikuda. Kui kohalik ja GitHubi ajalugu on lahknenud, käsk peatub ega tee automaatset merge’i või rebase’i.

## 5. Kui muutsid faili otse GitHubis

Näiteks parandasid GitHubis `README.md` faili.

Siis tee kohalikus repos:

```powershell
git status
git pull --ff-only
```

Reegel:

```text
Muutsin GitHubis → git pull --ff-only
Muutsin arvutis → git add, git commit, git push
```

Kui `git status` näitab kohalikke muudatusi, vaata need enne pull’i üle.

## 6. Isikliku repo töövoog

Liigu reposse:

```powershell
cd "C:\Users\Helen\data-analysis-course\daca-portfolio"
```

Kontrolli ja uuenda:

```powershell
git status
git pull --ff-only
```

Muuda faile VS Code’is.

Kontrolli muudatusi:

```powershell
git status --short
```

Lisa vajalik kaust:

```powershell
git add -- ".\week-6"
```

Või ainult valitud failid:

```powershell
git add -- `
    ".\week-6\README.md" `
    ".\week-6\analysis.md"
```

Kontrolli stagingut:

```powershell
git status --short
git diff --cached --stat
```

Tee commit:

```powershell
git commit -m "Update week 6 documentation"
```

Saada GitHubi:

```powershell
git push
```

Lõppkontroll:

```powershell
git status
git log -1 --oneline
```

Oodatav tulemus:

```text
nothing to commit, working tree clean
```

## 7. Grupirepo töövoog

> **AINULT GRUPIREPO**

Liigu grupireposse:

```powershell
cd "C:\Users\Helen\data-analysis-course\daca-group"
```

Mine `main` harusse ja uuenda see:

```powershell
git switch main
git pull --ff-only
```

Loo uus tööharu:

```powershell
git switch -c week-6-helen-dashboard-update
```

Muuda faile VS Code’is.

Kontrolli:

```powershell
git status --short
```

Lisa ainult enda töö failid:

```powershell
git add -- ".\week-6\individual\helen"
```

Kontrolli stagingut:

```powershell
git status --short
git diff --cached --stat
```

Tee commit:

```powershell
git commit -m "Update Helen week 6 dashboard"
```

Saada tööharu GitHubi:

```powershell
git push -u origin week-6-helen-dashboard-update
```

GitHubis loo pull request:

```text
base: main
compare: week-6-helen-dashboard-update
```

Kontrolli PR-is:

- kas muutunud on ainult õiged failid;
- kas pealkiri kirjeldab muudatust;
- kas kirjeldus selgitab, mida tegid;
- kas konflikte ei ole.

Pärast PR-i ühendamist:

```powershell
git switch main
git pull --ff-only
git branch -d week-6-helen-dashboard-update
git fetch --prune
```

Kui GitHubi remote-haru jäi alles:

```powershell
git push origin --delete week-6-helen-dashboard-update
git fetch --prune
```

## 8. `git status --short` märkide tähendus

Näiteks:

```text
 M week-2/README.md
M  week-6/README.md
A  week-6/analysis.md
?? week-7/
```

Tähendused:

| Märk | Tähendus |
|---|---|
| ` M` | Faili on muudetud, kuid see ei ole stagingus. |
| `M ` | Muudatus on stagingus ja läheb järgmisse commit’i. |
| `A ` | Uus fail on stagingus. |
| `??` | Git ei jälgi faili veel. |
| `D ` | Fail on stagingus kustutamiseks. |

Esimene veerg näitab stagingu seisu. Teine veerg näitab töökausta seisu.

## 9. Mida enne commit’i kontrollida?

```powershell
git status --short
git diff --cached --stat
```

Markdown- ja SQL-failide sisu kontroll:

```powershell
git diff --cached
```

Üksikute failide kontroll:

```powershell
git diff --cached -- ".\week-6\README.md" ".\week-6\analysis.md"
```

PBIX- ja PNG-failid on binaarfailid. Git näitab nende muutumist, kuid mitte loetavat sisudiffi.

## 10. Vale commit’imata muudatuse tühistamine

Kui fail on valesti muudetud ja muudatust ei ole vaja säilitada:

```powershell
git restore -- ".\week-2\README.md"
```

See taastab viimati commit’itud versiooni.

Kontroll:

```powershell
git status --short
```

## 11. Kogemata stagingusse lisatud faili eemaldamine

```powershell
git restore --staged ".\week-2\README.md"
```

Faili muudatus jääb alles, kuid ei lähe järgmisse commit’i.

## 12. Harude kontroll

```powershell
git branch -a
```

Aktiivne haru:

```powershell
git branch --show-current
```

Detailsem vaade:

```powershell
git branch -vv
```

GitHubis kustutatud harude aegunud viidete eemaldamine:

```powershell
git fetch --prune
```

## 13. Levinumad olukorrad

### `nothing to commit, working tree clean`

Kõik muudatused on commit’itud ja töökaust on puhas.

### `Untracked files`

Git näeb uusi faile, mida ei ole stagingusse lisatud.

Kontrolli:

```powershell
git status --short
```

Lisa ainult vajalik fail või kaust:

```powershell
git add -- ".\vajalik-kaust"
```

### `behind 2`

GitHubi harus on kaks uuemat commit’i.

```powershell
git pull --ff-only
```

### `ahead 1`

Sul on kohalik commit, mida ei ole veel GitHubi saadetud.

```powershell
git push
```

### `ahead 1, behind 1`

Kohalik ja GitHubi ajalugu on lahknenud. Ära tee juhuslikke paranduskäske. Kontrolli:

```powershell
git status
git log --oneline --all --graph --decorate -10
```

### `fetch first`

GitHubis on muudatusi, mida sinu arvutis ei ole.

Kontrolli esmalt:

```powershell
git status
git fetch origin
git status -sb
```

Kui tööpuu on puhas ja haru on ainult `behind`, kasuta:

```powershell
git pull --ff-only
```

### LF ja CRLF hoiatus

Näiteks:

```text
LF will be replaced by CRLF
```

See on Windowsis tavapärane reavahetuste hoiatus. See ei takista tavaliselt commit’i.

## 14. Kiirmeelespea

### Mõlema repo algus

```powershell
git status
git pull --ff-only
```

### Isiklik repo

```powershell
git status --short
git add -- ".\vajalik-kaust"
git commit -m "Muudatuse kirjeldus"
git push
git status
```

### Grupirepo

> **AINULT GRUPIREPO**

```powershell
git switch main
git pull --ff-only
git switch -c uus-haru
git add -- ".\enda-töö-kaust"
git commit -m "Muudatuse kirjeldus"
git push -u origin uus-haru
```

Pärast PR-i merge’i:

```powershell
git switch main
git pull --ff-only
git branch -d uus-haru
git fetch --prune
```

## 15. Kui ei ole kindel, mida edasi teha

Need käsud ainult näitavad seisu:

```powershell
Get-Location
git branch --show-current
git status --short
git status -sb
git log -3 --oneline
```

Kõige tähtsam reegel:

```text
Kontrolli enne käsu käivitamist repo asukohta, aktiivset haru ja git status tulemust.
```
