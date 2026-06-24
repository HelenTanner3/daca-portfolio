# Nädal 0 – Helen Tanner – Individuaalne töö

**Meeskond:** Operations Intelligence  
**Roll nädal 0:** D – Team Charter Koostaja  
**Kuupäev:** 17.06.2026  

---

## Ülesanded ja staatus

| Ülesanne | Staatus |
|----------|---------|
| Roll D – Team Charter koostamine | ✅ Valmis |
| Charter andmed Supabase'i sisestamine | ✅ Valmis |
| `charter.md` commit'imine GitHubi | ✅ Valmis |
| Roll E – Portfoolio struktuur | ✅ Valmis |
| Supabase + VS Code ühendamine | ✅ Valmis (lahendatud nädala lõpuks) |
| Iseseisva töö materjalid läbi töötatud | ✅ Valmis |

---

## Mida tegin

### Roll D – Team Charter Koostaja
- Koostasin meeskonna Team Charter koos kõigi liikmete andmete, 
  kokkulepete ja rollide rotatsiooniga
- Sisestasin charter andmed Supabase'i (`team_charter` tabel)
- Commit'isin `charter.md` GitHubi

### Roll E – Portfoolio Struktuur + Dokumentatsioon osaliselt
- Lõin meeskonna portfoolio kataloogistruktuuri GitHubis 
  (`week-0` kuni `week-10`)
- Automatiseerisin struktuuri loomise bash skriptiga 
  (`setup_portfolio_final.sh`) — käsitsi tegemise asemel
- Koostasin pea-README kõigi meeskonna linkide ja juurdepääsudega

---

## Väljakutsed ja lahendused

### VS Code + Supabase ühendamine
**Probleem:** SQLTools ühendus Supabase'iga ei õnnestunud kohe —  
SSL sertifikaadi ja ühenduse seadete vigade tõttu.  
**Lahendus:** Lahendatud nädala lõpuks, kasutades Session pooler  
andmeid ja õigeid SSL seadeid.

### Ajaline väljakutse
**Probleem:** Olin nädala esimeses pooles reisil, mistõttu  
ei jõudnud kõiki materjale õigeaegselt läbi töötada.  
**Lahendus:** Tegin kõik ülesanded nädala lõpuks valmis —  
ajaplaneerimise kogemus järgmisteks nädalateks.

---

## Peamised õppetunnid

1. **Automatiseerimine säästab aega** — bash skript lõi 78 kausta  
   sekunditega, käsitsi oleks see võtnud tunde
2. **Git käsud terminalis** — `cp`, `rm -rf`, `git add`, `git commit`,  
   `git push` on nüüd tuttavad
3. **Veateated on õpetajad** — SSL vead Supabase ühendamisel  
   õpetasid, kuidas ühenduse seaded õigesti seadistada
4. **Küsi abi õigel ajal** — AI abi kasutamine automatiseerimiseks  
   oli tõhusam kui käsitsi tegemine

---

## Lingid

- 🔗 [Meeskonna repo](https://github.com/Kolju3/DACA-group)
- 🔗 [Team Charter](https://github.com/Kolju3/DACA-group/blob/main/charter.md)
- 🔗 [Portfoolio struktuur](https://github.com/Kolju3/DACA-group/tree/main/week-0)
