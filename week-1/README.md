# Nädal 1: SQL Põhitõed — Müügiandmete Kvaliteedikontroll

## Kontekst
IT-juht Toomas Kask kahtlustab, et UrbanStyle.ltd müügiandmetes 
esineb kvaliteediprobleeme. Enne ärianalüüsi kasutamist tuli 
kontrollida andmestiku usaldusväärsust.

## Roll grupitöös
**Roll A: Müügiandmete uurija** — meeskond Operations Intelligence

Uurisin `sales` tabelit müügitehingute mahu, struktuuri ja 
andmekvaliteedi vaatenurgast (summad, kuupäevad, kogused).

## Kasutatud tööriistad
- **SQL / PostgreSQL** — andmepäringud 
- **Supabase** — andmebaas pilves
- **VS Code** — päringute kirjutamine ja salvestamine
- **GitHub** — koodi versioonihaldus ja portfoolio

## Tehtud analüüs
Kirjutasin 8 SQL päringut, mis kontrollisid:

1. **Tabeli maht** — mitu tehingut on andmestikus   [Link](https://github.com/Kolju3/DACA-group/blob/main/week-1/individual/helen/pildid/1_TABELI%20MAHT.png)
2. **Tabeli struktuur** — millised veerud ja andmed on olemas   [Link](https://github.com/Kolju3/DACA-group/blob/main/week-1/individual/helen/pildid/2._TABELI%20STRUKTUUR.png)
3. **Suurimad tehingud** — kogu andmestik (ebarealistlike väärtuste kontroll)  [Link](https://github.com/Kolju3/DACA-group/blob/main/week-1/individual/helen/pildid/3_SUURIMAD%20TEHINGUD_KOGU%20ANDMESTIK.png)
4. **Suurimad tehingud** — Tallinna kauplus eraldi  [Link](https://github.com/Kolju3/DACA-group/blob/main/week-1/individual/helen/pildid/4_SUURIMAD%20TEHINGUD-TALLINNA%20KAUPLUS.png)
5. **Väikseimad tehingud** — negatiivsete ja NULL-summade kontroll  [Link1](https://github.com/Kolju3/DACA-group/blob/main/week-1/individual/helen/pildid/5_V%C3%84IKSEIMAD%20TEHINGUD%20(osa1).png),  [Link2](https://github.com/Kolju3/DACA-group/blob/main/week-1/individual/helen/pildid/5_V%C3%84IKSEIMAD%20TEHINGUD%20(osa2).png)
6. **Puuduvad kliendiandmed** — mitu tehingut on ilma `customer_id`-ta  [Link](https://github.com/Kolju3/DACA-group/blob/main/week-1/individual/helen/pildid/6_PUUDUVAD_KLIENDIANDMED.png)
7. **Tuleviku kuupäevad** — kas esineb andmesisestuse vigu  [Link](https://github.com/Kolju3/DACA-group/blob/main/week-1/individual/helen/pildid/7_TULEVIKU_KUUP%C3%84EVADEGA_TEHINGUD.png)
8. **Koondülevaade** — kõik kvaliteedinäitajad ühes päringus  [Link](https://github.com/Kolju3/DACA-group/blob/main/week-1/individual/helen/pildid/8_KOOND%C3%9CLEVAADE.png) 
(kasutasin `CASE WHEN` konstruktsiooni, mida uurisin iseseisvalt väljaspool kohustuslikku materjali)

## Peamised leiud

| Näitaja | Tulemus |
|---------|---------|
| Tehinguid kokku | 15 234 |
| Puuduvad `customer_id` väärtused | 1 487 (~9,8%) |
| Negatiivsed summad | 305 tehingut (~2,0%) |
| Negatiivsete tehingute koguväärtus | -88 632,61 EUR |
| Tuleviku kuupäevaga tehingud | 2 |
| NULL- või 0-summaga tehingud | 0 |
| Suurim tehing | 2 170,40 EUR |

## Järeldused
Andmestik on valdavalt kasutuskõlblik — suuri struktuurseid 
probleeme ei tuvastatud.

Enne ärianalüüsi kasutamist soovitan:
- selgitada **negatiivsete tehingute** olemus 
  (tagastused, kreeditarved või andmevead?)
- kontrollida **2 tuleviku kuupäevaga** tehingu põhjuseid
- hinnata **puuduva `customer_id`** mõju kliendianalüüsile

Suurim risk ärianalüüsi kvaliteedile on negatiivsete tehingute 
koguväärtus **-88 632,61 EUR**, mille olemus vajab selgitamist.

## Failid
- [`week1_GT_A_HT_Sales_Data_Explorer- LINK Supabase`](https://supabase.com/dashboard/project/xwmwqxqorsiauliaynkk/sql/58cc5d93-1d3c-4025-81a8-ceb093a8d149)
- [`week1_GT_A_HT_Sales_Data_Explorer.sql`](https://github.com/Kolju3/DACA-group/blob/main/week-1/individual/helen/week1_GT_A_HT_Sales_Data_Explorer.sql)
- (kõik SQL päringud koos kommentaaride ja tulemustega)

## Järgmised sammud
Nädal 2-s õpime andmete puhastamist — seal saame 
negatiivsete tehingute ja puuduvate kliendiandmetega 
edasi tegeleda.
