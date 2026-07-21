# Nädal 5 — CEO dashboard'i detailanalüüs

## 1. Eesmärk ja stakeholder

**Stakeholder:** Kristi Tamm, CEO  
**Roll:** Roll A — CEO dashboard  
**Põhiküsimus:** „Kas UrbanStyle kasvab?”

Dashboard'i eesmärk on anda Kristile ühe pilguga ülevaade müügitulust, klientide arvust ja kasvutrendist.

## 2. Kasutatud andmed

| Andmeallikas | Kasutatud väljad | Eesmärk |
|---|---|---|
| `sales` | [TÄIDA] | müügitulu, tehingud, perioodid |
| `customers` | [TÄIDA] | klientide arv ja vajaduse korral kliendiseos |

**Analüüsiperiood:** [TÄIDA]  
**Andmebaasi/tabeli versioon:** [TÄIDA]  
**Andmete laadimise kuupäev:** [TÄIDA]

## 3. Andmete ettevalmistamine

Kirjelda lühidalt:

- kuidas andmed Power BI-sse jõudsid;
- kas kasutasid Supabase'i otseühendust või eksporti;
- milliseid andmetüüpe või välju tuli korrigeerida;
- millised filtrid rakendasid;
- kas negatiivsed tehingud või puuduvad `customer_id` väärtused jäid sisse;
- millist perioodi dashboard kuvab.

**Kasutatud SQL:** [week5_role_a_ceo_dashboard_queries.sql](supporting/week5_role_a_ceo_dashboard_queries.sql)

## 4. Kontrollväärtused

Täida enne visualiseerimist SQL-i või muu sõltumatu kontrolliga.

| Kontroll | Tulemus | Märkus |
|---|---:|---|
| müügiridade arv | [TÄIDA] | |
| unikaalsete tehingute arv | [TÄIDA] | |
| kogukäive | [TÄIDA] | |
| esimene müügikuupäev | [TÄIDA] | |
| viimane müügikuupäev | [TÄIDA] | |
| kliendiga seostatud müügiread | [TÄIDA] | |
| kliendita müügiread | [TÄIDA] | |

## 5. KPI-de definitsioonid

| KPI | Definitsioon | Periood / filter |
|---|---|---|
| kogukäive | `SUM(total_price)` | [TÄIDA] |
| unikaalsed kliendid | `COUNT(DISTINCT customer_id)` | [TÄIDA] |
| keskmine tellimuse väärtus | kogukäive / unikaalsed tehingud | [TÄIDA] |
| käibe kasv | [TÄIDA: näiteks 2024 vs 2023] | [TÄIDA] |

Oluline on kuvada kasvuprotsendi juures alati võrdlusperiood.

## 6. Dashboard'i ülesehitus

Kirjelda lõplikku paigutust.

### Ülemine rida — KPI-kaardid

- [TÄIDA KPI 1]
- [TÄIDA KPI 2]
- [TÄIDA KPI 3]
- [TÄIDA KPI 4, kui kasutad]

### Peamine visualiseering

**Diagramm:** [TÄIDA]  
**Küsimus:** [TÄIDA]  
**X-telg:** [TÄIDA]  
**Y-telg:** [TÄIDA]

### Teine visualiseering

**Diagramm:** [TÄIDA]  
**Küsimus:** [TÄIDA]  
**Valiku põhjendus:** [TÄIDA]

## 7. Visualiseering 1 — müügitulu trend

**Mida diagramm näitab:**  
[TÄIDA 1–2 lauset]

**Äriline tähendus:**  
[TÄIDA 1–2 lauset]

**Tõendusmaterjal:**  
Lisa pärast faili loomist link `screenshots/01_ceo_dashboard_overview.png` või eraldi detailkuvatõmmisele.

## 8. Visualiseering 2 — KPI-kaardid või aastavõrdlus

**Mida visualiseering näitab:**  
[TÄIDA 1–2 lauset]

**Äriline tähendus:**  
[TÄIDA 1–2 lauset]

## 9. Disainiotsused

Dokumenteeri ainult tegelikult kasutatud lahendused.

- UrbanStyle'i põhivärv: `#009B8D`;
- KPI-d paiknevad vaate ülaosas;
- peamine trend on visuaalselt keskne;
- üleliigsed ruudustikud, raamid ja dekoratsioonid eemaldati;
- pealkirjad sõnastati järeldusena, mitte ainult diagrammi teemana;
- eurod ja protsendid vormistati loetavalt;
- [TÄIDA: filter, annotatsioon või tingimusvorming, kui kasutasid];
- [TÄIDA: ligipääsetavuse ja värvivaliku otsused].

## 10. Peamised tulemused

> Täida ainult valideeritud arvudega.

1. **[TÄIDA KPI või trend]**
2. **[TÄIDA KPI või trend]**
3. **[TÄIDA KPI või trend]**

## 11. Äritõlgendus Kristile

**Peamine järeldus:**  
[TÄIDA ÜHE LAUSEGA]

**Milline otsus võiks selle põhjal muutuda:**  
[TÄIDA ÜHE LAUSEGA]

**Suurim üllatus:**  
[TÄIDA ÜHE LAUSEGA]

## 12. Piirangud

Kirjelda ainult piiranguid, mis võivad juhtimisotsust muuta.

- [TÄIDA: mittetäielik periood]
- [TÄIDA: puuduvad või seostamata kliendid]
- [TÄIDA: tagastuste või kampaaniainfo puudumine]
- [TÄIDA: muu oluline piirang]

## 13. Soovitus

[TÄIDA KONKREETSE JUHTIMISSOOVITUSEGA]

## 14. Kvaliteedikontroll

- [ ] Dashboard sisaldab vähemalt kahte sobivat visualiseeringut.
- [ ] Pealkirjad ja sildid on selged.
- [ ] Kristi saab 10 sekundiga aru, kas ettevõte kasvab.
- [ ] KPI-d sisaldavad perioodi ja konteksti.
- [ ] Dashboard mahub ühele ekraanile.
- [ ] Power BI numbrid vastavad kontrollpäringute tulemustele.
- [ ] README ja `analysis.md` sisaldavad ainult kontrollitud tulemusi.
- [ ] Dashboard'i fail ja ekraanipilt on GitHubis olemas.