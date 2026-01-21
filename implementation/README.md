# Botnet Lab - Metasploit Exploitation Guide

## Usage

### Start the lab
```bash
./scripts/setup.sh
```

### Exploit the bots and deploy payloads
```bash
./scripts/run_attack.sh
```

`exit -y` to leave msf6 and return back to the console.

### Set simple command (whoami)
```bash
./scripts/command_whoami.sh
```

Polls C2 and sets the `whoami` command. Bots will execute it on their next poll (within 5 seconds).

Check the result in a bot's log:
```bash
docker exec bot1 tail -f /tmp/bot.log
```

### Set DDoS command
```bash
./scripts/command_ddos.sh
```

Sets a command that makes all bots flood the victim with HTTP requests. Verify the attack:
```bash
docker exec attacker curl -sS http://172.18.0.2:9000/cmd
```

### Capture traffic on victim
```bash
./scripts/capture.sh
```

Runs tcpdump on the victim and copies the `.pcap` file to the host. Open the `.pcap` in Wireshark to analyze traffic during the DDoS attack.

### Inspect victim connections
```bash
./scripts/inspect_victim.sh
```

Displays live SYN packets (port 80) on the victim. Run this while the DDoS is active to see incoming connections:
```bash
watch -n 1 'docker exec victim netstat -ant | grep ESTABLISHED | wc -l'
```

### Clean up the lab
```bash
./scripts/cleanup.sh
```

Removes all containers and the Docker network.

