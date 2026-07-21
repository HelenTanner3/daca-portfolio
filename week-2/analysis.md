# Nädal 2 — kliendiandmete puhastamise detailanalüüs

## 1. Eesmärk

Nädal 2 keskendus andmekvaliteedi kontrollile ja puhastamisele. Minu ametlik roll oli **Roll B — kliendiandmete puhastaja** ning analüüsi objekt oli UrbanStyle’i `customers` tabel.

Töö põhimõte oli:

> Test → Verify → Log → Commit

Kõigepealt tuli luua testkoopia, seejärel tuvastada probleemid, kontrollida tulemusi, teha valideeritud puhastustoimingud ja säilitada auditijälg.

## 2. Kasutatud andmed ja artefaktid

- lähtetabel: `customers`;
- testtabel: `customers_test`;
- analüüsitud kliendikirjeid: **3 150**;
- põhiartefakt: [Roll B SQL-puhastamisskript](week2_role_b_customer_cleaning.sql);
- auditijälg: [puhastustoimingute logi](week2_cleaning_log.md);
- päringute väljundid: [screenshots/](screenshots/).

Ajaloolist SQL-faili ega kuvatõmmiste sisu portfoolio korrastamisel ei muudeta. Korrastatakse dokumentatsioon, failinimed, kaustad ja suhtelised lingid.

## 3. Testtabeli loomine

Analüüs algas `customers_test` tabeli loomisega:

```sql
CREATE TABLE customers_test AS
SELECT *
FROM customers;
```

Seejärel võrreldi `customers_test` ja `customers` tabelite ridade arvu. Mõlemas tabelis oli **3 150 rida**, mistõttu testkoopia loomine loeti õnnestunuks.

**Tõendusmaterjal:**

- [Testtabeli loomine ja ridade kontroll](screenshots/01_test_table_created.png)

## 4. Duplikaatsete e-posti aadresside kontroll

Korduvad e-posti aadressid otsiti `GROUP BY` ja `HAVING` abil.

Tulemuse selgem tõlgendus:

- **126** e-posti aadressi esines kaks korda;
- **2** e-posti aadressi esines kolm korda;
- korduvates gruppides oli kokku **258 kliendirida**;
- ühe kirje säilitamisel iga mittekasutamata e-posti aadressi kohta jääks **130 üleliigset kirjet**.

Seega ei tähenda „130 duplikaati” 130 erinevat korduvat e-posti aadressi. Tegemist on korduvate gruppide üleliigsete ridade arvuga.

**Tõendusmaterjal:**

- [Duplikaatsed e-posti aadressid](screenshots/02_duplicate_emails.png)

### Kontrollipiirang

Ajaloolises SQL-päringus puudub enne grupeerimist tingimus, mis välistaks `NULL`-i ja tühjad e-posti aadressid. PostgreSQL koondab kõik `NULL`-väärtused ühte gruppi, mistõttu tuleb puuduvad e-posti aadressid tegelikest duplikaatidest eraldi käsitleda.

Korrektse tõlgenduse jaoks tuleb mittekasutamata aadresside duplikaate hinnata eraldi puuduvate kontaktandmete kontrollist. Ajaloolist SQL-faili selle portfoolio korrastamise käigus tagantjärele ei muudeta; piirang dokumenteeritakse siin.

## 5. Puuduvate nimede kontroll

Kontrolliti nii `NULL`-väärtusi kui ka tühje stringe.

Tulemus:

- puuduvad eesnimed: **0**;
- puuduvad perenimed: **0**.

Nimede täielikkus oli seega kontrollitud andmestikus hea.

**Tõendusmaterjal:**

- [Puuduvate nimede kontroll](screenshots/03_missing_names.png)

## 6. Linnanimede kvaliteet

### 6.1. Algsete nimekujude ülevaade

Linnavälja algne grupeerimine andis **54 erinevat kirjapilti**. Sama linna käsitleti erineva väärtusena näiteks algus- või lõputühiku ning suur- ja väiketähtede erinevuse tõttu.

**Tõendusmaterjal:**

- [Linnanimede algsed variandid](screenshots/04a_city_name_variants.png)

### 6.2. Standardiseerimise kaardistus

Linnanimede standardiseerimise alus oli:

```sql
INITCAP(TRIM(city))
```

- `TRIM()` eemaldab nime algusest ja lõpust tühikud;
- `INITCAP()` ühtlustab suur- ja väiketähtede kasutuse.

Kaardistamise tulemus:

- algseid kirjapilte: **54**;
- standardiseeritud linnanimesid: **12**;
- liigseid kirjapilte: **42**;
- parandamist vajavaid kliendiridu: **252**, ligikaudu **8%** tabelist.

**Tõendusmaterjalid:**

- [Linnanimede standardiseerimise kaardistus](screenshots/04b_city_name_mapping.png)

## 7. Kontaktandmete täielikkus

Kontrolliti puuduvaid telefoni- ja e-posti väärtusi.

Tulemus:

- puuduvad telefoninumbrid: **0**;
- puuduvad e-posti aadressid: **380**, ligikaudu **12%** klientidest.

Puuduv e-posti aadress ei ole sama probleem mis korduv e-posti aadress. Need näitajad tuleb raportis eraldi hoida.

**Tõendusmaterjal:**

- [Puuduvate kontaktandmete kontroll](screenshots/05_missing_contact_details.png)

## 8. Puhastamisraport

SQL-is koostati `UNION ALL` abil koondvaade, mis tõi andmekvaliteedi probleemid ühte tabelisse ja järjestas need prioriteedi järgi.

**Tõendusmaterjal:**

- [Puhastamisraport](screenshots/06_cleaning_report.png)

### Koondtulemuse tõlgendamise piirang

Varasemas README-s liideti:

- 130 üleliigset duplikaatkirjet;
- 252 ebastandardse linnanimega rida;
- 380 puuduva e-postiga rida.

Nende summa on **762 probleemjuhtumit**, kuid seda ei tohi nimetada 762 unikaalseks probleemseks kliendiks ega kindlalt 24,2%-ks kliendibaasist. Sama kliendirida võib kuuluda mitmesse probleemikategooriasse.

Portfoolio põhikokkuvõttes esitatakse kategooriad seetõttu eraldi.

## 9. Edasijõudnute puhastamine ja W3 ettevalmistus

Nädala juhendi edasijõudnute osa nägi ette puhastustoimingute tegemise testtabelis. Enne W3 JOIN-analüüsi tuli valideeritud puhastus viia ka põhitabelisse.

[Puhastustoimingute auditilogi](week2_cleaning_log.md) dokumenteerib muu hulgas:

- varukoopiate loomise;
- `customers_test` tabeli loomise ja kontrolli;
- linnanimede probleemi kaardistamise;
- linnanimede standardiseerimise `customers_test` tabelis;
- tulemuse kontrolli: **12 standardiseeritud linnanime**;
- linnanimede standardiseerimise `customers` põhitabelis;
- põhitabeli järelkontrolli: **12 standardiseeritud linnanime**.

Auditilogi sisaldab lisaks kliendiandmetele ka W3 eel tehtud müügiandmete puhastustoiminguid. See säilitatakse eraldi nädala artefaktina, sest see tõendab puhastamise järjestust ja kontrollimist, mitte ainult Roll B lõppjäreldusi.

### Auditilogi mõõdikute täpsustus

Linnanimede kontroll tuvastas **252 parandamist vajavat kliendirida**, kuid auditilogi `rows_affected` väljal on standardiseerimise toimingu juures väärtus **42**. Logikirje detail seostab selle 42 liigse linnanime kirjapildiga. Kuna `rows_affected` veeru nimetus ja detailkirjeldus ei kasuta sama mõõdikut, säilitatakse ajalooline logi muutmata ning erinevus dokumenteeritakse siin.

Usaldusväärne järelkontroll on see, et standardiseerimise järel jäi alles **12 linnanime**.

## 10. Äriline mõju

### Puuduvad e-posti aadressid

380 klienti ei ole tavapäraselt e-turunduse kaudu kättesaadavad. Enne andmete täiendamist tuleb eristada, kas e-post puudub lubatud äriloogika tõttu või sisestus- ja migratsioonivea tõttu.

### Korduvad e-posti aadressid

Korduvad aadressid võivad:

- suurendada näilist kliendiarvu;
- jagada ühe kliendi ostuajaloo mitme `customer_id` vahel;
- moonutada lojaalsus- ja korduvostuanalüüsi;
- põhjustada dubleerivat kliendisuhtlust.

Kirjeid ei tohi ühendada ainult e-posti aadressi põhjal ilma säilitatava kliendikirje reegli ja täiendava kontrollita.

### Linnanimede ebajärjekindlus

Linnanimede erinevad kirjapildid jagavad sama piirkonna tulemused mitme kategooria vahel. See mõjutab linnade ja piirkondade kaupa tehtavat müügi-, kliendi- ja turundusanalüüsi.

## 11. Soovitused

1. Hoida linnanimede standardiseerimine püsiva andmetöötlusreeglina.
2. Kontrollida pärast iga puhastustoimingut ridade arvu ja standardiseeritud väärtuste arvu.
3. Eristada duplikaatide kontrollis puuduvad e-posti aadressid mittetühjadest korduvatest aadressidest.
4. Määrata enne kliendikirjete ühendamist selge säilitamisreegel.
5. Käsitleda puuduvaid e-posti aadresse eraldi äriprotsessi ja andmekvaliteedi küsimusena.
6. Säilitada puhastustoimingute auditilogi koos enne- ja pärast-kontrollidega.

## 12. Peamine õppetund

Andmete puhastamine ei tähenda ainult `UPDATE` või `DELETE` käsu käivitamist. Usaldusväärne protsess nõuab:

- testkoopiat;
- referentsväärtust enne muudatust;
- kontrollitavat puhastusreeglit;
- järelkontrolli;
- auditijälge;
- mõõdikute täpset defineerimist.

W2 kõige olulisem tulemus oli arusaam, et tehniliselt töötav puhastuspäring ei ole piisav, kui pole selgelt teada, mida loetakse probleemiks, mitut unikaalset kirjet see puudutab ja kuidas tulemust kontrolliti.