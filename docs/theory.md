# 1. Uvod

Razvoj računalnih mreža i interneta omogućio je brzu i učinkovitu razmjenu podataka, ali je istovremeno povećao broj i složenost sigurnosnih prijetnji. Napadači danas koriste različite tehnike za neovlašteni pristup sustavima, prikupljanje podataka i ometanje rada mrežnih servisa. Među tim tehnikama posebno se ističu TCP ljuske i botneti, koji omogućuju udaljeno upravljanje kompromitiranim sustavima.

TCP ljuske omogućuju napadaču izravno izvršavanje naredbi na udaljenom sustavu, dok botneti omogućuju koordinirano djelovanje velikog broja zaraženih uređaja. Botneti se često koriste za izvođenje distribuiranih napada uskraćivanja usluge (DDoS), krađu podataka ili širenje zlonamjernog softvera.

Cilj ovog rada je teorijski objasniti principe rada TCP ljuski, botneta i DDoS napada te prikazati alate koji se koriste za njihovu simulaciju i analizu u kontroliranom, edukativnom okruženju.

# 2. Teorijski pregled

## 2.1 TCP ljuske (TCP Shells)
TCP ljuska omogućuje udaljeno izvođenje naredbi putem TCP mrežne veze. Postoje dvije osnovne vrste TCP ljuski:

- **Bind shell** – ciljni sustav sluša dolazne veze
- **Reverse shell** – ciljni sustav inicira vezu prema napadaču

Reverse TCP ljuske su češće korištene jer lakše prolaze kroz vatrozide i NAT uređaje.

**Edukativna svrha:**  
Analiza TCP ljuski omogućuje razumijevanje načina na koji napadači ostvaruju udaljeni pristup sustavima te kako se takva komunikacija može detektirati i spriječiti.

**Konceptualni primjer reverse TCP ljuske:**

Ciljni sustav → uspostavlja TCP vezu → Napadački sustav
Naredbe se razmjenjuju unutar aktivne TCP sesije
### 2.1.1 Definicija i princip rada

TCP ljuska je mehanizam koji omogućuje udaljeni pristup naredbenoj ljusci operacijskog sustava putem TCP mrežne veze. Nakon uspostave veze, jedna strana (najčešće napadač) može slati naredbe, dok druga strana (ciljni sustav) te naredbe izvršava i vraća izlazne rezultate.

Princip rada TCP ljuske temelji se na standardnoj TCP komunikaciji, što znači da se promet često ne razlikuje značajno od legitimnog mrežnog prometa. Upravo zbog toga TCP ljuske mogu biti teško uočljive bez detaljne analize mrežnog prometa.

U edukativnom kontekstu TCP ljuske se koriste kako bi se razumjelo na koji način napadači ostvaruju udaljeni pristup sustavima te kako takav pristup izgleda na mrežnoj razini.

### 2.1.2 Vrste TCP ljuski

Postoje dvije osnovne vrste TCP ljuski koje se razlikuju prema načinu uspostave mrežne veze:

bind TCP ljuske

reverse TCP ljuske

Obje vrste omogućuju isti krajnji cilj – udaljeni pristup sustavu – ali koriste različite mrežne mehanizme.

### 2.1.3 Bind shell vs Reverse shell

Kod bind TCP ljuske ciljni sustav otvara određeni TCP port i sluša dolazne veze. Napadač se zatim spaja na taj port kako bi dobio pristup ljusci. Nedostatak ovog pristupa je što otvoreni port može biti blokiran vatrozidom ili lako uočen mrežnim skeniranjem.

Reverse TCP ljuska funkcionira tako da ciljni sustav sam inicira izlaznu TCP vezu prema napadaču. Budući da većina mreža dopušta izlazni promet, reverse ljuske su u praksi znatno uspješnije i češće korištene. Zbog toga su one i češći predmet analize u sigurnosnim istraživanjima i edukaciji.

## 2.2 Botneti

Botnet je mreža računala (zajedničkim imenom botova) kojima najčešće upravlja jedan poslužitelj (server) koji tim računalima zapovijeda te ih kontrolira. Botneti se najčešće koriste za koordinirane napade (DDoS)

**Osnovne komponente botneta:**

    - Bot (zaraženo računalo kontrolirano od poslužitelja)
    - C2 (Command and Control) poslužitelj
    - Komunikacijski kanal

Važnost botneta najviše se ističe kod proučavanja velikih mreža te napada na takve velike mreže, provjeravanje i kontrolu internetskog prometa između računala te pronalaženje metoda obrane protiv DDoS i sličnih napada na mrežu.

### 2.2.1 Definicija i arhitektura botneta

Botnet predstavlja mrežu kompromitiranih računala ili uređaja koji su pod kontrolom jednog napadača ili skupine napadača. Svaki kompromitirani sustav naziva se bot, a svi botovi (sva računala) zajedno čine botnet.

Arhitektura botneta obično se sastoji od:

    - botova koji izvršavaju naredbe

    - sustava za zapovijedanje i kontrolu (C2)

    - komunikacijskog kanala između botova i C2 poslužitelja

U jednostavnijim botnetima C2 poslužitelj je centraliziran, dok moderniji botneti mogu koristiti distribuirane ili peer-to-peer arhitekture kako bi se otežala detekcija i gašenje.

### 2.2.2 Command and Control (C2) komunikacija

C2 komunikacija omogućuje napadaču slanje naredbi botovima i prikupljanje informacija s kompromitiranih sustava. Ta komunikacija može uključivati naredbe za pokretanje napada, ažuriranje zlonamjernog softvera ili prikupljanje podataka.

Najčešće se koristi TCP protokol zbog pouzdanosti, ali se komunikacija često skriva korištenjem enkripcije, standardnih portova ili legitmnih protokola poput HTTP-a kako bi se izbjegla detekcija.

Kako C2 napadi funkioniraju?

1. Point of Entry (mjesto ulaza u sustav) - napadač šalje napad kako bi probio ciljanu mrežu unosom malware-a. To su najčešće phishing mailovi, popratna preuzimanja s web stranica, neovlašten ulaz u sustav s kompromitiranim korisničkim podacima, eksploatacija ranjivosti sustava itd.
2. Uspostavljanje C2 povezanosti - nakon što se dođe do pristupa sustavu, napdadač koristi C2 kanale kako bi kontrolirao i upravljao unesenim botovima na mreži
3. Lateralna kretnja kroz mrežu - nakon što se dobije pristup mreži, napadač kompromitira sve više računala kako bi dobio sve više korisničkih podataka za pristup većim ovlastima te na taj način sam sebi omogućio veći pristup i veće ovlasti u sustavu kako bi bio u većoj kontroli nad mrežom i računalima na njoj
4. Otkrivanje podataka - napadač dolazi do otkrića lokacije servera i sustava koji u sebi sadrže podatke koji su napadaču korisni.
5. Eksfiltracija podataka - nakon dolazaka do podataka, napadač podatke šalje na internalni server gdje se ti podaci kompresiraju i najčešće enkriptiraju te se šalju na vanjsku lokaciju

### 2.2.3 Metode infekcije i širenja

    - iskorištavanje poznatih ranjivosti
    - Social Engeneering i phishing
    - zlonamjerni emailovi
    - kompromitirane web stranice

## 2.3 DDoS napadi
### 2.3.1 Definicija i tipovi DDoS napada

Distribuirani napad uskraćivanja usluge (DDoS) ima za cilj onemogućiti normalan rad sustava ili mrežnog servisa. To se postiže slanjem velikog broja zahtjeva koji iscrpljuju resurse ciljnog sustava.

Najčešći tipovi DDoS napada su:
volumetrijski napadi, koji preopterećuju mrežnu propusnost
protokolski napadi, koji iskorištavaju slabosti mrežnih protokola
aplikacijski napadi, koji ciljaju specifične aplikacijske servise

### 2.3.2 Uloga botneta u DDoS napadima

Botneti omogućuju izvođenje DDoS napada s velikog broja distribuiranih izvora, čime se značajno povećava učinkovitost napada. Budući da promet dolazi s mnogih IP adresa, otežano je razlikovanje zlonamjernog i legitimnog prometa.

## 2.4 Pregled postojećih alata i istraživanja

Razvoj i analiza TCP ljuski, botneta i DDoS napada zahtijevaju korištenje specijaliziranih alata koji omogućuju simulaciju napadačkih scenarija, mrežno izviđanje i analizu prometa. U ovom poglavlju opisuju se najvažniji alati korišteni u projektu te njihova uloga u edukativnom kontekstu.

### 2.4.1 Metasploit Framework

Metasploit Framework je jedan od najpoznatijih i najčešće korištenih alata za penetracijsko testiranje. Riječ je o okviru (eng. framework) otvorenog koda koji omogućuje simulaciju stvarnih napada u kontroliranom okruženju. Metasploit se sastoji od velikog broja modula koji pokrivaju različite faze napada, uključujući izviđanje, iskorištavanje ranjivosti i post-eksploataciju.
U kontekstu TCP ljuski, Metasploit omogućuje generiranje i korištenje različitih payloadova koji uspostavljaju TCP vezu između napadačkog i ciljanog sustava. Također se može koristiti za simulaciju jednostavnih botnet scenarija, gdje kompromitirani sustavi komuniciraju s centralnim kontrolnim sustavom.

### 2.4.2 Netcat
### 2.4.3 Wireshark

# 3. Zaključak

# 4. Literatura
