# Meetod 1 — Supabase + ühine DataFrame

## Eesmärk

See analüüs valmis **enne Nädal 7 grupitööd**. Kuigi minu ametlik roll grupitöös oli Roll C — RFM-kliendisegmenteerimine, läbisin siin õppimise eesmärgil iseseisvalt kogu A → B → C → D töövoo.

Eesmärk oli mõista, kuidas RFM-i sisend tekib ning kuidas andmete laadimise, ühendamise ja puhastamise otsused mõjutavad lõpptulemust.

## Olulisemad tulemused

- Supabase'i `sales` tabelist laaditi **10 118 rida**.
- Pärast RFM-i jaoks sobimatute ridade eemaldamist jäi **8 950 tehingut**.
- RFM-analüüsi jõudis **2 540 klienti**.
- Andmete viimane müügikuupäev oli 2026-06-28, mistõttu kasutati viitekuupäevana **2026-06-29**.
- Negatiivseid Recency väärtusi ei tekkinud.

## Artefakt

- [`week7_method1_supabase_shared.ipynb`](week7_method1_supabase_shared.ipynb)

Notebook sisaldab kogu tervikläbimist alates Supabase'i andmete laadimisest kuni RFM-segmentatsiooni, visualiseerimise ja kontrollideni.

See fail on säilitatud algse enne grupitööd tehtud versioonina ega ole hilisema teadmise põhjal tagantjärele ümber kirjutatud.

Detailne metoodika, kontrollid ja seos teiste Nädal 7 tööetappidega on kirjeldatud [`../../analysis.md`](../../analysis.md) failis.
