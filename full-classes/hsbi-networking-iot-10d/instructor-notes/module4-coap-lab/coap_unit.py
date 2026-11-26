#!/usr/bin/env python3
"""Reference for Module 4 Task 5 — the AC unit with two doors.

One process, one temperature, two protocols:

  MQTT   publishes  <BASE>/env        {"temp": 24.3, "hvac": "OFF"}
         subscribes <BASE>/set        {"power": "ON" | "OFF"}
         will       <BASE>/status     "offline" (retained)

  CoAP   GET  /warehouse/temp         -> the same JSON
         POST /warehouse/set          {"power": "ON" | "OFF"} -> 2.04 Changed

The point of the exercise is that both doors read and write the *same*
`state` dict. Nothing is synchronised by copying messages; there is one
source of truth and two ways in.

Threading: paho's `loop_start()` runs the MQTT network loop in its own
thread; asyncio owns the main thread for the CoAP server. Do not block the
main thread with a `while True` — that is what the asyncio task below is for.

Run
---
    uv add "paho-mqtt>=2,<3" aiocoap
    BROKER=192.168.14.1 BASE=pod14/cold/ac python coap_unit.py

BROKER defaults to the pod router; BASE must match the topic tree from Task 1.
Environment variables are read once at import, so a typo means an empty tree
rather than an error — print them if nothing arrives.
"""

import asyncio
import json
import os
import random

import aiocoap
import aiocoap.resource as resource
import paho.mqtt.client as mqtt
from aiocoap.numbers.codes import Code

BROKER = os.environ.get("BROKER", "192.168.14.1")
BASE = os.environ.get("BASE", "pod14/cold/ac")
COAP_PORT = int(os.environ.get("COAP_PORT", "5683"))

# The single source of truth. Both doors touch only this.
state = {"temp": 26.0, "hvac": "OFF"}


# --------------------------------------------------------------------------
# Door 1: MQTT
# --------------------------------------------------------------------------
def on_connect(client, userdata, flags, reason_code, properties):
    if reason_code.is_failure:
        print("broker refused:", reason_code)
        return
    print("MQTT connected to", BROKER)
    client.subscribe(f"{BASE}/set", qos=1)
    client.publish(f"{BASE}/status", "online", qos=1, retain=True)


def on_message(client, userdata, msg):
    try:
        power = json.loads(msg.payload).get("power")
    except (ValueError, AttributeError):
        print("ignoring bad command:", msg.payload)
        return
    if power in ("ON", "OFF"):
        state["hvac"] = power
        print(f"MQTT command -> {power}")


mqttc = mqtt.Client(
    mqtt.CallbackAPIVersion.VERSION2,
    # derive the id from the topic base: two students running the reference
    # under the same client_id kick each other off the broker, which looks
    # like a flaky network and is not.
    client_id="ac-dual-" + BASE.replace("/", "-"),
)
mqttc.will_set(f"{BASE}/status", "offline", qos=1, retain=True)
mqttc.on_connect = on_connect
mqttc.on_message = on_message


async def telemetry():
    """Drift the temperature and publish it, exactly like the MQTT-only unit."""
    while True:
        step = -0.6 if state["hvac"] == "ON" else 0.3
        state["temp"] = max(16.0, min(32.0, state["temp"] + step + random.uniform(-0.2, 0.2)))
        mqttc.publish(
            f"{BASE}/env",
            json.dumps({"temp": round(state["temp"], 1), "hvac": state["hvac"]}),
            qos=1,
        )
        await asyncio.sleep(2)


# --------------------------------------------------------------------------
# Door 2: CoAP
# --------------------------------------------------------------------------
def snapshot() -> bytes:
    return json.dumps({"temp": round(state["temp"], 1), "hvac": state["hvac"]}).encode()


class Temp(resource.Resource):
    """GET /warehouse/temp — the current reading, no side effects."""

    async def render_get(self, request):
        return aiocoap.Message(code=Code.CONTENT, payload=snapshot())


class Set(resource.Resource):
    """POST /warehouse/set — flip the HVAC. 2.04 on success, 4.00 on nonsense."""

    async def render_post(self, request):
        try:
            power = json.loads(request.payload).get("power")
        except (ValueError, AttributeError):
            return aiocoap.Message(code=Code.BAD_REQUEST, payload=b"expected JSON")
        if power not in ("ON", "OFF"):
            return aiocoap.Message(code=Code.BAD_REQUEST, payload=b'{"power": "ON"|"OFF"}')
        state["hvac"] = power
        print(f"CoAP command -> {power}")
        # No re-publish: the next telemetry tick carries the new state to MQTT
        # subscribers, which is enough and keeps the two doors from quoting
        # each other. Say this out loud in the task.
        return aiocoap.Message(code=Code.CHANGED, payload=b"ok")


async def coap_server():
    root = resource.Site()
    root.add_resource(["warehouse", "temp"], Temp())
    root.add_resource(["warehouse", "set"], Set())
    root.add_resource(
        [".well-known", "core"], resource.WKCResource(root.get_resources_as_linkheader)
    )
    await aiocoap.Context.create_server_context(root, bind=("0.0.0.0", COAP_PORT))
    print(f"CoAP listening on coap://<this host>:{COAP_PORT}/warehouse/temp")
    asyncio.create_task(telemetry())
    await asyncio.get_running_loop().create_future()  # run until Ctrl+C


def main():
    mqttc.connect(BROKER, 1883, 10)
    mqttc.loop_start()
    try:
        asyncio.run(coap_server())
    except KeyboardInterrupt:
        pass
    finally:
        mqttc.loop_stop()
        mqttc.disconnect()


if __name__ == "__main__":
    main()
