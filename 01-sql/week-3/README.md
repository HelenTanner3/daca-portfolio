# Nädal 3: SQL JOIN-id — tooted ja inventuur

## Eesmärk

Ühendada UrbanStyle’i `products`, `sales` ja `inventory` tabelid, et leida müümata tooted, võrrelda toodete ja kategooriate müügitulemusi ning tuvastada tähelepanu vajavad laoseisud.

## Minu roll

**Roll C — tooted ja inventuur.**

Kasutasin põhirollis eelkõige `LEFT JOIN`-i, et säilitada analüüsis kõik tooted ka siis, kui neile ei leitud müügi- või inventuurivastet. Täiendavalt kasutasin `INNER JOIN`-i müüdud toodete tulemuste võrdlemiseks.

## Peamised tulemused

- Leidsin **12 toodet**, millel puudus müügitabelis vaste.
- Suurima kogumüügiga kategooria oli **`jalanõusid`**, kuid kõige rohkem müügiridu oli kategoorias **`meeste_riided`**.
- Inventuuriandmetes oli **221** juurde tellimise kontrolli vajavat, **10** negatiivse laoseisuga ja **12** inventuurivasteta rida.
- Valitud kontrollpiiri järgi oli **730 toote-asukoha real** laoseis vähemalt kolm korda suurem kui tellimispunkt. See on riskimärgis, mitte lõplik tõend ülevaru kohta.

## Järeldus

Suurim tähelepanek oli võimaliku ülevaru kontrolli ulatus: valitud kontrollpiiri järgi oli 730 toote-asukoha real laoseis vähemalt kolm korda suurem kui tellimispunkt. Kuna `reorder_point` tähistab tellimispunkti, mitte maksimaalset laotaset, on see kontrollnimekiri, mitte lõplik tõend ülevaru kohta.

Soovitan esmalt kontrollida 10 negatiivse laoseisuga rida, 12 inventuurivasteta toodet ja 12 müügivasteta toodet. Seejärel tuleks võimaliku ülevaru märgisega ridu võrrelda müügikiiruse, hooajalisuse ja tarneajaga, enne kui tehakse tellimis-, kampaania- või sortimendiotsuseid.

## Kasutatud oskused ja tööriistad

`INNER JOIN`, `LEFT JOIN`, `WHERE ... IS NULL`, mitme tabeli JOIN, `COUNT`, `SUM`, `AVG`, `GROUP BY`, `CASE WHEN`, `NULLIF`, PostgreSQL / Supabase, VS Code ja GitHub.

## AI kasutamine

AI-d kasutasin nädala jooksul õppematerjalide mõtestamisel, SQL-päringute loogika ja võimalike vigade kontrollimisel ning artefakti ja dokumentatsiooni vormistamisel.

## Artefaktid

- [SQL-päringud](week3_role_c_products_inventory.sql)
- [Detailne analüüs](analysis.md)
- [Tulemuste tõendusmaterjalid](screenshots/)
- [Vabatahtlikud lisaanalüüsid](additional-analysis/)
- [Meeskonna ühine Nädal 3 töö](https://github.com/Kolju3/DACA-group/tree/main/week-3/group)