# 1. Uvod

# 2. Teorijski pregled

## 2.1 TCP ljuske (TCP Shells)

TCP ljuska omogućuje udaljeno izvođenje naredbi putem TCP mrežne veze. Postoje dvije osnovne vrste TCP ljuski:

- **Bind shell** – ciljni sustav sluša dolazne veze
- **Reverse shell** – ciljni sustav inicira vezu prema napadaču

Reverse TCP ljuske su češće korištene jer lakše prolaze kroz vatrozide i NAT uređaje.

**Edukativna svrha:**  
Analiza TCP ljuski omogućuje razumijevanje načina na koji napadači ostvaruju udaljeni pristup sustavima te kako se takva komunikacija može detektirati i spriječiti.

**Konceptualni primjer reverse TCP ljuske:**
```text
Ciljni sustav → uspostavlja TCP vezu → Napadački sustav
Naredbe se razmjenjuju unutar aktivne TCP sesije

### 2.1.1 Definicija i princip rada
### 2.1.2 Vrste TCP ljuski
### 2.1.3 Bind shell vs Reverse shell

## 2.2 Botneti

Botnet je mreža računala (zajedničkim imenom botova) kojima najčešće upravlja jedan poslužitelj (server) koji tim računalima zapovijeda te ih kontrolira. Botneti se najčešće koriste za koordinirane napade (DDoS)

**Osnovne komponente botneta:**

    - Bot (zaraženo računalo kontrolirano od poslužitelja)
    - C2 (Command and Control) poslužitelj
    - Komunikacijski kanal

Važnost botneta najviše se ističe kod proučavanja velikih mreža te napada na takve velike mreže, provjeravanje i kontrolu internetskog prometa između računala te pronalaženje metoda obrane protiv DDoS i sličnih napada na mrežu.

**Primjer**

Poslužitelj -> slanje naredbe botovima (računalima) -> botovi -> istovremena reakcija i napad

### 2.2.1 Definicija i arhitektura botneta
### 2.2.2 Command and Control (C2) komunikacija
### 2.2.3 Metode infekcije i širenja

## 2.3 DDoS napadi
### 2.3.1 Definicija i tipovi DDoS napada
### 2.3.2 Uloga botneta u DDoS napadima

## 2.4 Pregled postojećih alata i istraživanja
### 2.4.1 Metasploit Framework
### 2.4.2 Netcat
### 2.4.3 Wireshark

# 3. Zaključak

# 4. Literatura
