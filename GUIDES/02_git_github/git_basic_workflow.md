# Git Basic Workflow

See juhend kirjeldab minu igapäevast Git ja GitHubi töövoogu andmeanalüüsi õpingute ajal.

Juhend on mõeldud olukorraks, kus töötan oma isiklikus repos:

```text
C:\Users\Helen\data-analysis-course\daca-portfolio
```

Grupirepo asub eraldi kaustas:

```text
C:\Users\Helen\data-analysis-course\DACA-group
```

Grupirepos teen muudatusi ainult siis, kui see on seotud grupitööga.

---

## 1. Liigun õigesse kausta

```powershell
cd C:\Users\Helen\data-analysis-course\daca-portfolio
```

Kontrollin, et olen õiges repos:

```powershell
git remote -v
```

Õige tulemus minu isikliku repo puhul:

```text
origin  https://github.com/HelenTanner3/daca-portfolio.git (fetch)
origin  https://github.com/HelenTanner3/daca-portfolio.git (push)
```

---

## 2. Kontrollin töökausta seisu

```powershell
git status
```

Kui kõik on korras, näen näiteks:

```text
On branch main
Your branch is up to date with 'origin/main'.

nothing to commit, working tree clean
```

See tähendab, et lokaalses repos ei ole hetkel salvestamata Git muudatusi.

---

## 3. Tõmban GitHubist viimased muudatused

Enne uute muudatuste tegemist või enne push’i on mõistlik käivitada:

```powershell
git pull --rebase origin main
```

See toob GitHubist viimased muudatused alla ja paigutab minu kohalikud commit’id nende peale.

Kasutan seda eelistatult tavalise `git pull` asemel, sest see aitab hoida Git ajalugu puhtamana.

---

## 4. Teen failides muudatused

Näiteks:

* lisan uue juhendi;
* täiendan README faili;
* muudan SQL faili;
* korrastan kaustastruktuuri;
* parandan dokumentatsiooni.

Pärast muudatusi kontrollin uuesti:

```powershell
git status
```

---

## 5. Lisan muudatused staging alasse

Kõigi muudatuste lisamiseks:

```powershell
git add .
```

Ainult ühe kausta lisamiseks:

```powershell
git add GUIDES
```

Ainult ühe faili lisamiseks:

```powershell
git add GUIDES/README.md
```

---

## 6. Teen commit’i

Commit on salvestuspunkt Git ajaloos.

```powershell
git commit -m "Add initial guide content"
```

Hea commit message on lühike, aga sisuline.

Näited:

```powershell
git commit -m "Add guides folder"
git commit -m "Update Git workflow guide"
git commit -m "Add SQL data quality notes"
git commit -m "Fix README links"
```

Vähem head commit message’id:

```powershell
git commit -m "update"
git commit -m "changes"
git commit -m "test"
```

---

## 7. Tõmban enne push’i veel kord viimased muudatused

Kui commit on tehtud, aga enne GitHubi saatmist, teen:

```powershell
git pull --rebase origin main
```

See aitab vältida olukorda:

```text
! [rejected] main -> main (fetch first)
```

See viga tähendab, et GitHubis on midagi, mida minu arvutis veel ei ole.

---

## 8. Saadan muudatused GitHubi

```powershell
git push
```

Kui push õnnestub, näen lõpus midagi sellist:

```text
main -> main
```

See tähendab, et muudatused jõudsid GitHubi.

---

## 9. Kontrollin lõppseisu

```powershell
git status
```

Soovitud lõpptulemus:

```text
On branch main
Your branch is up to date with 'origin/main'.

nothing to commit, working tree clean
```

---

# Minu tavapärane täistöövoog

Kui töötan üksi oma isiklikus repos:

```powershell
cd C:\Users\Helen\data-analysis-course\daca-portfolio
git status
git pull --rebase origin main
git add .
git commit -m "Kirjeldav commit message"
git pull --rebase origin main
git push
git status
```

---

# Levinud olukorrad

## Git ütleb: `nothing to commit, working tree clean`

See tähendab, et Git ei näe ühtegi uut või muudetud faili, mida commit’ida.

## Git ütleb: `Untracked files`

See tähendab, et kaustas on uusi faile, mida Git veel ei jälgi.

Lahendus:

```powershell
git add .
git commit -m "Add new files"
```

## Git ütleb: `fetch first`

See tähendab, et GitHubis on uuemad muudatused kui minu arvutis.

Lahendus:

```powershell
git pull --rebase origin main
git push
```

## Git ütleb: `Repository not found`

See tähendab tavaliselt, et remote aadress on vale või puudub ligipääs GitHubi reposse.

Kontrollin:

```powershell
git remote -v
```

Kui aadress on vale, muudan seda:

```powershell
git remote set-url origin https://github.com/HelenTanner3/daca-portfolio.git
```

---

# Ohutu kontrollnimekiri enne push’i

Enne `git push` käsku kontrollin:

1. Kas olen õiges kaustas?
2. Kas `git remote -v` näitab õiget GitHubi repot?
3. Kas `git status` näitab oodatud muudatusi?
4. Kas commit message on arusaadav?
5. Kas olen enne push’i teinud `git pull --rebase origin main`?

---

# Kiirspikker

```powershell
git status
git pull --rebase origin main
git add .
git commit -m "Message"
git push
```
