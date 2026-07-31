# PowerShelli põhikäsud ja praktiline kasutamine

See juhend käsitleb PowerShelli kasutamist Windowsis ja VS Code’i terminalis.

PowerShell on terminal, milles saab:

- liikuda kaustade vahel;
- kontrollida failide olemasolu ja suurust;
- avada või ümber nimetada faile;
- käivitada Giti käske;
- aktiveerida Pythoni virtuaalkeskkonda.

Git ja PowerShell ei ole sama asi. PowerShell on keskkond, kuhu käsud kirjutatakse. `git status`, `git pull` ja muud `git` käsud kuuluvad Gitile, kuid neid käivitatakse PowerShellis.

## 1. Terminali avamine VS Code’is

VS Code’i menüüst:

```text
Terminal → New Terminal
```

Terminali rea alguses võib olla näiteks:

```text
(venv) PS C:\Users\Helen\data-analysis-course>
```

Tähendused:

- `(venv)` – Pythoni virtuaalkeskkond on aktiveeritud;
- `PS` – kasutusel on PowerShell;
- ülejäänud osa näitab praegust kausta.

## 2. Kaustades liikumine

### Praeguse asukoha kontroll

```powershell
Get-Location
```

### Liikumine isiklikku portfoolioreposse

```powershell
cd "C:\Users\Helen\data-analysis-course\daca-portfolio"
```

### Liikumine grupireposse

```powershell
cd "C:\Users\Helen\data-analysis-course\daca-group"
```

### Ühe taseme võrra üles

```powershell
cd ..
```

Lubatud on ka:

```powershell
cd..
```

Selgem ja tavapärasem on siiski kasutada tühikuga kuju `cd ..`.

### Liikumine alamkausta

```powershell
cd ".\week-6"
```

### Miks kasutada jutumärke?

Jutumärgid on vajalikud, kui failitees on tühikuid:

```powershell
cd "C:\Users\Helen\My Documents"
```

Jutumärke võib ohutult kasutada ka siis, kui tühikuid ei ole.

## 3. Kausta sisu vaatamine

### Praeguse kausta failid

```powershell
Get-ChildItem
```

Lühivorm:

```powershell
dir
```

### Kõik alamkaustade failid

```powershell
Get-ChildItem -Recurse
```

### Ainult valitud kausta sisu

```powershell
Get-ChildItem ".\week-6"
```

### Failide täisteed

```powershell
Get-ChildItem ".\week-6" -Recurse |
    Select-Object FullName
```

## 4. Faili olemasolu kontrollimine

```powershell
Test-Path ".\week-6\analysis.md"
```

Vastus:

```text
True
```

tähendab, et fail on olemas.

Vastus:

```text
False
```

tähendab, et failiteel ei ole sellist faili.

## 5. Faili andmete ja suuruse kontroll

```powershell
Get-Item ".\week-6\urbanstyle_week6_tartu_dashboard_helen.pbix"
```

Faili suurus megabaitides:

```powershell
Get-Item ".\week-6\urbanstyle_week6_tartu_dashboard_helen.pbix" |
    Select-Object Name, @{Name="SizeMB"; Expression={[math]::Round($_.Length / 1MB, 2)}}
```

## 6. Faili avamine VS Code’is

```powershell
code ".\week-6\analysis.md"
```

Kausta avamine eraldi VS Code’i aknas:

```powershell
code ".\week-6"
```

PBIX-fail on binaarfail. Seda ei avata tekstina VS Code’is, vaid Power BI Desktopis.

## 7. Faili või kausta loomine

### Uus kaust

```powershell
New-Item -ItemType Directory -Path ".\GUIDES\06_markdown_documentation"
```

### Uus tühi fail

```powershell
New-Item -ItemType File -Path ".\GUIDES\06_markdown_documentation\markdown_working_guide.md"
```

VS Code loob faili automaatselt ka siis, kui salvestad uue dokumendi soovitud asukohta.

## 8. Faili ümber nimetamine või liigutamine

```powershell
Move-Item `
    ".\week-6\vana_nimi.pbix" `
    ".\week-6\urbanstyle_week6_tartu_dashboard_helen.pbix"
```

`Move-Item` sobib nii ümber nimetamiseks kui ka teise kausta liigutamiseks.

Pärast Gitiga jälgitava faili ümbernimetamist kasuta:

```powershell
git add -A -- ".\week-6"
```

See aitab Gitil tuvastada vana nime eemaldamise ja uue nime lisamise.

## 9. Faili kopeerimine

```powershell
Copy-Item `
    ".\week-6\analysis.md" `
    ".\backup\analysis.md"
```

Kausta kopeerimisel võib vaja minna `-Recurse` valikut:

```powershell
Copy-Item ".\week-6" ".\backup\week-6" -Recurse
```

## 10. Faili kustutamine

```powershell
Remove-Item ".\ajutine_fail.txt"
```

Kustutamisel ole ettevaatlik. PowerShelli `Remove-Item` ei käitu alati nagu Windows Exploreri prügikast.

Enne kustutamist kontrolli faili:

```powershell
Test-Path ".\ajutine_fail.txt"
```

Gitiga jälgitava faili eemaldamisel kontrolli pärast:

```powershell
git status --short
```

## 11. Käsuajaloo kasutamine

### Eelmine käsk

Vajuta klaviatuuril:

```text
↑
```

### Järgmine käsk ajaloos

```text
↓
```

### Varasema käsu otsimine

```text
Ctrl + R
```

Kirjuta osa käsust, mida otsid.

### Faili- või kaustanime automaatne lõpetamine

Kirjuta nime algus ja vajuta:

```text
Tab
```

See vähendab kirjavigu pikkades failiteedes.

## 12. Mitmerealised käsud

PowerShellis saab pika käsu jagada mitmele reale, kasutades rea lõpus tagurpidi ülakoma:

```powershell
git add -- `
    ".\week-6\README.md" `
    ".\week-6\analysis.md"
```

Tagurpidi ülakoma on see märk:

```text
`
```

Pärast seda kuvab PowerShell järgmise rea alguses:

```text
>>
```

See tähendab, et PowerShell ootab käsu jätku.

### Kui `>>` jäi kogemata ette

Katkesta pooleliolev käsk:

```text
Ctrl + C
```

Seejärel sisesta käsk uuesti.

## 13. Käskude ühendamine

Käske võib käivitada ükshaaval. Alguses on see selgem ja turvalisem.

Ühele reale saab käsud ühendada semikooloniga:

```powershell
git status; git branch --show-current
```

Gitiga töötades eelistan olulised käsud käivitada eraldi, sest siis on iga käsu tulemus kohe nähtav.

## 14. Virtuaalkeskkonna aktiveerimine

Näiteks:

```powershell
& "C:\Users\Helen\data-analysis-course\venv\Scripts\Activate.ps1"
```

Kui PowerShell blokeerib skripti käivitamise, võib ainult praeguseks terminaliseansiks kasutada:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned
```

Seejärel aktiveeri virtuaalkeskkond uuesti.

`-Scope Process` tähendab, et muudatus kehtib ainult avatud PowerShelli aknas.

## 15. Ohutu kontrollplokk

Need käsud ei muuda faile:

```powershell
Get-Location
Get-ChildItem
git branch --show-current
git status --short
git status -sb
git log -3 --oneline
```

## 16. Levinumad probleemid ja lahendused

### Probleem: `Cannot find path`

Näiteks:

```text
Cannot find path ... because it does not exist
```

Põhjused:

- failinimi on vale;
- fail on teises kaustas;
- oled vales repos;
- faili on ümber nimetatud.

Kontroll:

```powershell
Get-Location
Get-ChildItem ".\week-6"
```

### Probleem: terminal näitab `>>`

PowerShell ootab käsu jätku.

Lahendus:

```text
Ctrl + C
```

Sisesta käsk uuesti ning kontrolli tagurpidi ülakomasid ja jutumärke.

### Probleem: `git` või muu käsk ei ole tuntud

Näiteks:

```text
git is not recognized
```

Võimalikud põhjused:

- Git ei ole paigaldatud;
- VS Code’i terminal avati enne Giti paigaldamist;
- süsteemi PATH ei ole värskendunud.

Kontroll:

```powershell
git --version
```

Vajaduse korral sulge ja ava VS Code uuesti.

### Probleem: `code` ei tööta

Kontrolli:

```powershell
code --version
```

VS Code’is võib olla vaja lisada `code` käsk PATH-i või avada fail Exploreri kaudu.

### Probleem: fail ei ilmu VS Code’i Explorerisse

Kontrolli kettal:

```powershell
Test-Path ".\week-6\analysis.md"
```

Kui vastus on `True`, vajuta VS Code’i Exploreris **Refresh** või kasuta:

```text
Ctrl + Shift + P
Developer: Reload Window
```

### Probleem: PBIX-faili ei näidata tekstina

See on normaalne. PBIX on Power BI binaarfail ja tuleb avada Power BI Desktopis.

## Kiirmeelespea

```powershell
Get-Location
Get-ChildItem
cd "C:\vajalik\kaust"
Test-Path ".\fail.md"
Get-Item ".\fail.md"
code ".\fail.md"
```

Kõige tähtsam põhimõte:

```text
Kontrolli enne faili muutmist või Git-käsu käivitamist, millises kaustas sa asud.
```

