# 🚀 Portfoolio seadistamise juhend

**Kes teeb:** Helen (Windows, VS Code)  
**Aeg:** ~10 minutit  

---

## Eeltingimused

Enne alustamist kontrolli:
- ✅ VS Code on installitud
- ✅ Git on olemas (sul on juba kinnitatud ✅)
- ✅ GitHub konto: [@HelenTanner3](https://github.com/HelenTanner3)
- ✅ Juurdepääs repo-le: https://github.com/Kolju3/DACA-group

---

## Samm 1 — Ava VS Code terminal

1. Ava VS Code
2. Vajuta ülaribalt: **Terminal → New Terminal**
3. Terminal avaneb ekraani allosas
4. Vaata terminali paremas nurgas — peab olema kirjas **Git Bash**

> ⚠️ Kui näed `powershell` või `cmd`:  
> Kliki terminali paremas nurgas **noole peale** (+ kõrval) → vali **Git Bash**

---

## Samm 2 — Klooni repo oma arvutisse

Kirjuta terminali täpselt nii:

```bash
git clone https://github.com/Kolju3/DACA-group.git
```

Vajuta **Enter**. Git laeb repo alla sinu arvutisse.

---

## Samm 3 — Mine repo kausta

```bash
cd DACA-group
```

Kontrolli, et oled õiges kohas:

```bash
ls
```

Peaksid nägema `setup_portfolio_v4.sh` ja `JUHEND.md` failide nimekirjas.

> ⚠️ Kui faile ei näe, kopeeri mõlemad failid käsitsi `DACA-group` kausta

---

## Samm 4 — Käivita skript

```bash
bash setup_portfolio_v4.sh
```

Terminalis peaksid nägema:

```
🚀 Loon portfoolio struktuuri...
  ✅ week-0 loodud
  ✅ week-1 loodud
  ...
  ✅ week-10 loodud
📝 Loon pea-README...

✅ Kõik valmis! Struktuur loodud (week-0 kuni week-10).
```

---

## Samm 5 — Kontrolli tulemust

```bash
ls
```

Peaksid nägema:

```
week-0/  week-1/  week-2/ ... week-10/  README.md
```

---

## Samm 6 — Laadi kõik GitHubi üles

```bash
git add .
git commit -m "Initial portfolio structure with team charter"
git push
```

> ⚠️ Kui Git küsib kasutajanime ja parooli, sisesta oma GitHub andmed

---

## Samm 7 — Kontrolli GitHubis

1. Ava brauser
2. Mine: https://github.com/Kolju3/DACA-group
3. Peaksid nägema kaustu `week-0` kuni `week-10` ja `README.md`

---

## Samm 8 — Teavita meeskonda

Kirjuta Google Workspace Chatis:

> "Repo on seadistatud! Klonige endale:  
> `git clone https://github.com/Kolju3/DACA-group.git`  
> Olga — palun lisa oma GitHub kasutajanimi mulle, uuendan README-s ära."

---

## ⚠️ Pärast Olga kasutajanime saamist

Ava `README.md` ja leia see rida:

```markdown
| Olga Leisbblous | Windows | Roll C – NotebookLM Seadistaja | _lisatakse hiljem_ |
```

Muuda see:

```markdown
| Olga Leisbblous | Windows | Roll C – NotebookLM Seadistaja | [@OlgaKasutajanimi](https://github.com/OlgaKasutajanimi) |
```

Siis:

```bash
git add README.md
git commit -m "Add Olga GitHub username"
git push
```

---

## 🆘 Kui midagi läheb valesti

| Viga | Lahendus |
|------|----------|
| `bash: command not found` | Vali terminalis Git Bash (vt Samm 1) |
| `Permission denied` | Kontrolli, et Kalju on sind lisanud repo collaborator-iks |
| Skripti ei näe (`ls`-ga) | Kopeeri `setup_portfolio_v4.sh` käsitsi DACA-group kausta |
| `git push` küsib parooli | Sisesta GitHub kasutajanimi ja parool |
