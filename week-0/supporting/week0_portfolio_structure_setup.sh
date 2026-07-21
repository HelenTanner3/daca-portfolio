#!/bin/bash

# ================================================
# DACA Operations Intelligence – Portfolio Setup
# Versioon 4 – kõigi liikmete andmetega
# Käivita üks kord, repo juurkaustas
# ================================================

TEAM_NAME="Operations Intelligence"
MEMBERS=("kalju" "natalia" "olga" "helen")
WEEKS=10

echo "🚀 Loon portfoolio struktuuri..."

for i in $(seq 0 $WEEKS); do
  WEEK="week-$i"
  
  mkdir -p "$WEEK/group"
  cat > "$WEEK/group/README.md" << INNER
# Nädal $i – Ühine töö

**Meeskond:** $TEAM_NAME  
**Nädal:** $i  

## Ülesanne
_Täienda sessiooni järel_

## Peamised leiud
- _Lisa siia_

## Failid
| Fail | Kirjeldus |
|------|-----------|
| _tulemas_ | |
INNER

  for MEMBER in "${MEMBERS[@]}"; do
    mkdir -p "$WEEK/individual/$MEMBER"
    cat > "$WEEK/individual/$MEMBER/README.md" << INNER
# Nädal $i – $MEMBER individuaalne töö

## Ülesanne
_Täienda ise_

## Mida tegin
- _Lisa siia_

## SQL päringud / failid
_Lisa lingid_
INNER
  done

  echo "  ✅ $WEEK loodud"
done

echo "📝 Loon pea-README..."

cat > README.md << 'README'
# 📊 Operations Intelligence – DACA Portfoolio

**Meeskond:** Operations Intelligence – UrbanStyle Operatsioonid  
**Programm:** DACA – Data Analytics Career Accelerator  
**Ettevõte:** UrbanStyle.ltd (simulatsioon)  
**Kokku lepitud:** 17.06.2026

---

## 👥 Meeskonnaliikmed

| Nimi | OS | Nädal 0 roll | GitHub |
|------|----|--------------|--------|
| Kalju Tamm | Linux | Roll A – GitHub Repo Seadistaja | [@Kolju3](https://github.com/Kolju3) |
| Natalia Krassilnikova | Mac | Roll B – Supabase Seadistaja | [@Nata376](https://github.com/Nata376) |
| Olga Leisbblous | Windows | Roll C – NotebookLM Seadistaja | _lisatakse hiljem_ |
| Helen Tanner | Windows | Roll D – Team Charter Koostaja | [@HelenTanner3](https://github.com/HelenTanner3) |

---

## 🔗 Ühised tööriistad

| Tööriist | Link |
|----------|------|
| 💬 Google Workspace Chat | [DACA Operatsioonid](https://chat.google.com/room/AAQAnNsGNdA?cls=7) |
| 🐙 GitHub Repo | [Kolju3/DACA-group](https://github.com/Kolju3/DACA-group) |
| 🗄️ Supabase | [Projekt](https://supabase.com/dashboard/project/xwmwqxqorsiauliaynkk) |
| 📓 NotebookLM | [Notebook](https://notebooklm.google.com/notebook/6ede243b-41c5-49c4-a598-2cd6b49c64e5) |

---

## 🔄 Rollide rotatsioon

| Nädal | Roll A | Roll B | Roll C | Roll D |
|-------|--------|--------|--------|--------|
| Nädal 0 | Kalju | Natalia | Olga | Helen |
| Nädal 1 | Helen | Kalju | Natalia | Olga |
| Nädal 2 | Olga | Helen | Kalju | Natalia |
| Nädal 3 | Natalia | Olga | Helen | Kalju |
| Nädal 4 | Kalju | Natalia | Olga | Helen |
| Nädal 5 | Helen | Kalju | Natalia | Olga |
| Nädal 6 | Olga | Helen | Kalju | Natalia |
| Nädal 7 | Natalia | Olga | Helen | Kalju |
| Nädal 8 | Kalju | Natalia | Olga | Helen |
| Nädal 9 | Helen | Kalju | Natalia | Olga |
| Nädal 10 | Olga | Helen | Kalju | Natalia |

---

## 🤝 Kokkulepped

1. **Abi küsimine:** Kirjutame Google Workspace Chati gruppi ning aitame üksteist esimesel võimalusel nõuannete, näidete või ekraanijagamisega.
2. **Lisakohtumised:** Vajadusel lepime aja kokku Chatis. Regulaarseid lisakohtumisi pole planeeritud.
3. **Grupitöö aeg:** Alates kell 16:00, kui kõigile sobib.
4. **Failide jagamine:** GitHub projektifailide jaoks, Google Drive dokumentide ja õppematerjalide jaoks.

---

## 📁 Repo struktuur

```
DACA-group/
├── README.md
├── JUHEND.md
├── setup_portfolio_v4.sh
├── week-0/
│   ├── group/
│   └── individual/
│       ├── kalju/
│       ├── natalia/
│       ├── olga/
│       └── helen/
├── week-1/
│   └── ...
└── week-10/
```

---

## 🗓️ Projektid nädalate kaupa

| Nädal | Teema | Ühine töö | Staatus |
|-------|-------|-----------|---------|
| Nädal 0 | Töökeskkonna seadistamine | [group →](./week-0/group/) | ✅ Valmis |
| Nädal 1 | SQL põhitõed – sales tabeli uurimine | [group →](./week-1/group/) | ⏳ |
| Nädal 2 | Andmete puhastamine | [group →](./week-2/group/) | ⏳ |
| Nädal 3 | SQL JOIN-id | [group →](./week-3/group/) | ⏳ |
| Nädal 4 | GROUP BY ja agregatsioonid | [group →](./week-4/group/) | ⏳ |
| Nädal 5 | Klientide segmenteerimine | [group →](./week-5/group/) | ⏳ |
| Nädal 6 | Visualiseerimine | [group →](./week-6/group/) | ⏳ |
| Nädal 7 | Varud ja operatsioonid | [group →](./week-7/group/) | ⏳ |
| Nädal 8 | Python ja pandas | [group →](./week-8/group/) | ⏳ |
| Nädal 9 | Dashboardid | [group →](./week-9/group/) | ⏳ |
| Nädal 10 | Lõpuprojekt | [group →](./week-10/group/) | ⏳ |

---

## 💡 Meeskonna peamised leiud

_Täiendatakse iga nädal_

---

## 🛠️ Tööriistad

- **SQL** – PostgreSQL (Supabase)
- **Python** – pandas, plotly
- **Visualiseerimine** – Power BI
- **Versioonihaldus** – GitHub
README

echo ""
echo "✅ Kõik valmis! Struktuur loodud (week-0 kuni week-10)."
echo ""
echo "Järgmised sammud:"
echo "  1. git add ."
echo "  2. git commit -m 'Initial portfolio structure with team charter'"
echo "  3. git push"
echo ""
echo "⚠️  Muuda hiljem README-s Olga GitHubi kasutajanimi, kui see selgub."
