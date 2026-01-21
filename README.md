# TCP Shells And Botnets – Tim 22

## Opis projekta

Ovaj projekt obrađuje koncept TCP ljuski i botneta kao modernih oblika kibernetičkih napada. Kroz teorijski dio objašnjeni su mehanizmi eksploatacije ranjivosti, remote code execution, C2 komunikacija i DDoS napada. U praktičnom dijelu implementiran je funkcionalni botnet laboratorij korištenjem Docker okruženja, Metasploit Framework-a i Python Flask servera, te je implementirana simulacija DDoS napada.

## Članovi tima

- Leonard Inkret
- Oton Lulić
- Nikola Polonijo
- Matej Bunić

## Korišteni alati

- **Docker** – orkestracija kontejnera i izolacija komponenti
- **Metasploit Framework** – automatizirana eksploatacija i post-eksploatacija
- **Nmap** – skeniranje i identifikacija servisa
- **Python Flask** – Command & Control (C2) HTTP server
- **tcpdump & Wireshark** – hvatanje i analiza mrežnog prometa
- **Bash** – scripting i automatizacija laboratorija

## Struktura projekta

- `docs/` – teorijski dio (theory.md), plan rada (plan.md) i izvještaj (report.md)
- `implementation/` – praktična implementacija (Docker Dockerfiles, Python C2, Bash skripte)
- `results/` – screenshotovi, logovi, pcap datoteke
