# A–B–C integratsioonitest

## Eesmärk

See diagnostiline töö valmis **enne Nädal 8 lõpliku grupipipeline'i kinnitamist**.

Minu Roll D ülesanne oli ühendada Rollide A, B ja C moodulid üheks tervikuks. Enne lõplikku integratsiooni kontrollisin eraldi keskkonnas, kas moodulite sisendid, väljundid ja andmed sobivad omavahel ning kas vahetulemused vastavad referentsväärtustele.

## Olulisemad kontrollid ja tulemused

Täisandmestiku testis:

- `sales`: **10 118 rida**;
- `customers`: **3 150 rida**;
- pärast puhastamist: **8 950 rida**;
- kogukäive: **2 676 850,54 €**;
- unikaalseid kliente: **2 540**;
- keskmine ostusumma: **299,09 €**.

Kuupäevafiltriga test paljastas pagination'i vea: 10 086 rea hulgas oli ainult 10 026 unikaalset kirjet ehk **60 duplikaati ja 60 puuduvat rida**. Lõplikus grupiversioonis lahendati probleem stabiilse järjestusega `order("id")`.

## Artefaktid

Kaust sisaldab diagnostilises testis kasutatud:
- `data_fetcher.py`;
- `transform.py`;
- `visualize_export.py`;
- `pipeline.py`;
- `output/`.

Tegemist on kvaliteedikontrolli tööversiooniga, mitte lõpliku grupitöö asendusega.

Detailne kontrollloogika, pagination'i analüüs ja lõpliku grupijooksu võrdlus on kirjeldatud [`../../analysis.md`](../../analysis.md) failis.
