# Nädal 0 – Onboarding ja meeskonna töökeskkonna seadistamine

**Osaleja:** Helen Tanner  
**Meeskond:** Operations Intelligence  
**Põhiroll:** Roll D – Team Charteri koostaja  
**Kuupäev:** 17.06.2026  

---

## Nädala eesmärk

Nädala 0 eesmärk oli seadistada DACA programmis kasutatavad töövahendid, luua toimiv meeskonnatöö keskkond ning leppida kokku meeskonna töökorraldus.

Meeskonnaliikmed jagasid omavahel GitHubi, Supabase’i, NotebookLM-i ja Team Charteri seadistamisega seotud vastutused.

---

## Minu põhiroll – Team Charteri koostaja

Minu põhiülesanne oli koostada Operations Intelligence’i meeskonna Team Charter.

Töö käigus:git diff -- ".\week-0\README.md"

- koondasin meeskonna töökorralduse ja koostööpõhimõtted;
- dokumenteerisin suhtluskanalid ja kokkulepped;
- lisasin rollide rotatsiooni nädalate lõikes;
- sisestasin kokkulepped Supabase’i `team_charter` tabelisse;
- lisasin Team Charteri meeskonna GitHubi reposse.

Team Charter lõi ühise aluse sellele, kuidas meeskond järgmistel nädalatel ülesandeid jagab, tulemusi kontrollib ja ühiseid väljundeid koostab.

---

## Täiendav panus – GitHubi portfooliostruktuur

Lisaks põhirollile aitasin ette valmistada meeskonna GitHubi portfooliostruktuuri.

Selle töö käigus:

- kavandasin nädalate 0–10 kaustastruktuuri;
- koostasin struktuuri loomise ja kasutamise juhendi;
- kasutasin Bash-skripti kaustade ja lähtefailide automatiseeritud loomiseks;
- kontrollisin loodud struktuuri VS Code’is ja GitHubis;
- aitasin koondada meeskonna põhilised lingid ja juurdepääsud repo README-faili.

Juhend ja skript on lisatud isiklikku portfooliosse täiendava meeskondliku panuse näidetena.

---

## Tehniline seadistus

Nädala jooksul ühendasin VS Code’i SQLToolsi kaudu Supabase’i PostgreSQL-andmebaasiga.

Esialgu takistasid ühendamist SSL-i ja ühenduse parameetrite seadistused. Ühendus hakkas tööle pärast õigete Session Pooleri andmete ja SSL-seadete kasutamist.

See andis praktilise kogemuse andmebaasiühenduse seadistamisest ning ühendusvigade süstemaatilisest kontrollimisest.

---

## Peamised õppetunnid

- Automatiseerimine vähendab korduvat käsitööd ja aitab vältida ebaühtlast kaustastruktuuri.
- GitHubi repo vajab selget ülesehitust, järjepidevaid failinimesid ja arusaadavat dokumentatsiooni.
- Tehniliste probleemide lahendamisel tuleb kontrollida veateadet, ühenduse parameetreid ja tööriista seadistusi sammhaaval.
- Git ja GitHub on lisaks failide salvestamisele olulised muudatuste jälgimise ja meeskonnatöö vahendid.
- AI abil loodud skript või juhend tuleb enne kasutamist ise üle vaadata ja testida.

---

## Kasutatud tööriistad

- GitHub
- Git ja Git Bash
- VS Code
- SQLTools
- Supabase
- PostgreSQL
- Markdown
- Bash
- AI-tööriistad skripti ja dokumentatsiooni koostamise toetamiseks

---

## Failid

### Põhiartefakt

- [Team Charter](week0_role_d_team_charter.md)

### Täiendavat panust toetavad failid

- [GitHubi portfooliostruktuuri juhend](supporting/week0_portfolio_structure_guide.md)
- [Portfooliostruktuuri loomise Bash-skript](supporting/week0_portfolio_structure_setup.sh)

### Meeskonna ühine töö

- [Operations Intelligence’i grupirepo](https://github.com/Kolju3/DACA-group)
- [Meeskonna Team Charter grupirepos](https://github.com/Kolju3/DACA-group/blob/main/charter.md)

---

## AI kasutamine

Kasutasin AI-d GitHubi kaustastruktuuri loomise Bash-skripti ja selle kasutusjuhendi koostamise toetamiseks. Vaatasin loodud lahenduse üle, kohandasin seda vajaduse järgi ning käivitasin ja kontrollisin skripti ise Git Bashis.