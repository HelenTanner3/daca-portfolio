# Nädal 8 — Python API-d ja automatiseeritud pipeline

## Eesmärk

Nädal 8 eesmärk oli ühendada andmete pärimine, töötlemine, visualiseerimine ja eksport üheks korduvkasutatavaks Python-pipeline'iks. Nädal 7 ühekordsest pandas-analüüsist liikus töö edasi API-põhise ja ühe käsuga käivitatava töövoo suunas.

## Minu roll

Minu ametlik roll oli **Roll D — Automation Script (automatiseerimise skript)**.

Minu ülesanne oli:
- ühendada Rollide A, B ja C funktsioonid `pipeline.py` abil õigesse järjekorda;
- anda kuupäevaparameeter edasi andmelaadimisele;
- lisada logimine, veakäsitlus ja täitmisaja mõõtmine;
- kontrollida, et A → B → C → D töövoog jõuab ühe käsuga andmete pärimisest väljundfailideni.

## Peamised tulemused

- Kuupäevapiiranguga valideeritud jooksus saadi API-st **10 086 müügirida** ning kõik `id` ja `sale_id` väärtused olid unikaalsed.
- Pärast puhastamist jäi **8 923 analüüsikõlblikku müügirida**.
- Valideeritud KPI-d olid **2 669 027,39 € kogukäivet**, **2 540 unikaalset klienti** ja **299,12 € keskmine ostusumma**.
- Integratsioonikontroll paljastas pagination'i vea: esialgses 10 086 reas oli ainult 10 026 unikaalset kirjet. Stabiilne järjestus `order("id")` kõrvaldas 60 duplikaadi ja 60 puuduva rea probleemi.

## Järeldus

Nädala peamine õppetund oli, et automatiseeritud töövoo edukas käivitumine ei tõenda veel tulemuse korrektsust. Pipeline'i tuleb valideerida ridade arvu, võtmete unikaalsuse, puhastamise mõju ja referents-KPI-de abil.

Praegune lahendus automatiseerib kogu A → B → C → D töövoo ühe käsu alla, kuid ei ole veel välise scheduler'iga automaatselt ajastatud.

## Kasutatud oskused ja tööriistad

Python, pandas, Supabase API, Plotly, funktsioonid ja moodulid, ETL-pipeline, pagination, logimine, `try/except`, käsureaparameetrid, andmekvaliteedi kontroll ja Git/GitHub.

## AI kasutamine

Kasutasin AI-d eeskätt veaotsingu, kontrollloogika ja testide koostamise abivahendina. AI pakutud hüpoteese kontrollisin reaalse pipeline'i käivitamise, ridade arvu, võtmete unikaalsuse, puhastamise mõju ja KPI-de võrdlemisega.

## Artefaktid

- [`pipeline.py`](pipeline.py) — minu ametliku Roll D põhiartefakt
- [`analysis.md`](analysis.md) — detailne tööprotsess, valideerimine, piirangud ja õppetunnid
- [`output/`](output/) — isikliku valideerimise väljundid
- [`group-project/`](group-project/) — lõpliku grupitöö koopia koos lähtecommit'i ja grupi originaalse README-ga
- [`additional-analysis/`](additional-analysis/) — diagnostiline A–B–C integratsioonitest ja hilisem RFM automatiseerimise edasiarendus