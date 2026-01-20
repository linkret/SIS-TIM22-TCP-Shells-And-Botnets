#!/bin/bash
set -e

# Create network with fixed subnet
docker network inspect botnet_lab >/dev/null 2>&1 || \
docker network create --subnet 172.18.0.0/24 botnet_lab

docker build -t bot ./bots
docker build -t c2 ./c2
docker build -t attacker ./attacker

# C2 server at 172.18.0.2
docker rm -f c2 2>/dev/null || true
docker run -d --net botnet_lab --ip 172.18.0.2 --name c2 c2

# Bots at 172.18.0.3 - 172.18.0.7
for i in 1 2 3 4 5; do
  docker rm -f bot$i 2>/dev/null || true
  docker run -d --net botnet_lab --ip 172.18.0.$((i+2)) --name bot$i bot
done

# Attacker at 172.18.0.100
docker rm -f attacker 2>/dev/null || true
docker run -d --net botnet_lab --ip 172.18.0.100 --name attacker attacker tail -f /dev/null

echo "To exploit the bots, run:"
echo "  ./scripts/run_attack.sh"
echo ""
echo "Or manually:"
echo "  docker exec -it attacker msfconsole -r /attack/infect.rc"

# Attacker at 172.18.0.100
