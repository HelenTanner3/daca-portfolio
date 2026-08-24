# Nädal 4: SQL agregatsioon — turunduskanalite efektiivsus

## Eesmärk

Analüüsida UrbanStyle’i turunduskanalitega seotud kliente, tellimusi, käivet ja kuiseid trende ning kontrollida, kas mitme tabeli ühendamisel saadud koondnumbrid on juhtimisotsusteks usaldusväärsed.

## Minu roll

**Roll D — turunduskanalite agregatsioon ja efektiivsuse analüüs.**

Kasutasin `sales`, `customers` ja `web_logs` tabeleid. Lisaks juhendi kolmele agregatsioonipäringule kontrollisin kanalite nimetuste kvaliteeti, JOIN-i kardinaalsust ja koondtulemuste vastavust müügitabeli referentsväärtustele.

## Peamised tulemused

- `web_logs` tabelis oli **50 000 rida**, millest **9 415 ehk 18,83%** olid anonüümsed.
- Kanali `source` väljal oli **19 algväärtust**, mis standardiseeriti analüüsiks **10 kanaliks**.
- Otsene `sales`–`customers`–`web_logs` JOIN kasvatas **10 118 müügirea** põhjal saadud käibe **2 909 177,98 eurolt 34 527 628,19 eurole**, mistõttu selle `SUM`- ja `AVG`-tulemusi ei saanud kasutada.
- Hilisemas `source_clean`-põhises kogu müügiperioodi koondis oli `google_organic` suurima käibega tuvastatud kanal: **666 444,98 €**, **2 273 tellimust** ja **684 klienti**.

## Järeldus

Suurim üllatus oli see, et tehniliselt töötav JOIN andis äriliselt vale tulemuse: müügiread kordistusid ja käive kasvas ligi kaheteistkümnekordseks. Usaldusväärsema koondi saamiseks määrasin igale kliendile `ROW_NUMBER()` abil ühe viimase teadaoleva standardiseeritud kanali ja kontrollisin lõpptulemust müügitabeli referentsväärtustega.

`google_organic` oli analüüsi eri versioonides suurima valideeritud müügimahuga kanal, kuid seda ei saa nimetada parima ROI-ga kanaliks. Enne kanalite lõplikku tasuvusvõrdlust tuleb lisada kampaaniakulud ja tehingupõhine omistamisloogika.

## Kasutatud oskused ja tööriistad

`GROUP BY`, `HAVING`, `COUNT(DISTINCT ...)`, `SUM`, `AVG`, CTE-d, `ROW_NUMBER`, `LAG`, `CASE`, `COALESCE`, `NULLIF`, `DATE_TRUNC`, JOIN-ide kardinaalsuse kontroll, PostgreSQL / Supabase, VS Code ja GitHub.

## AI kasutamine

AI-d kasutasin õppematerjalide mõtestamisel, SQL-päringute ja JOIN-i kardinaalsuse kontrollimisel ning analüüsi ja dokumentatsiooni vormistamisel. Võtmenumbrid kontrollisin SQL-i referentsväärtuste ja ristkontrollidega.

## Artefaktid

- [Põhi-SQL](week4_role_d_marketing_aggregation.sql)
- [Detailne analüüs](analysis.md)
- [Tulemuste tõendusmaterjalid](screenshots/)
- [Veebilogide puhastamisskript](supporting/week4_web_logs_cleaning.sql)
- [Vabatahtlik Roll B lisaanalüüs](additional-analysis/)
- [Meeskonna ühine Nädal 4 töö](https://github.com/Kolju3/DACA-group/tree/main/week-4/group)