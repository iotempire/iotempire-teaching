# Module 4 CoAP reference — one state, two interfaces

Tracked instructor material for [Module 4 Task 3](../../modules/04-mqtt-and-integration.md#-task-3--a-little-bit-of-coap).
Students may read it as a worked example; it is not an answer key to hide.

`coap_unit.py` is the sender from Task 1 with a **second interface**: the same
`state` dict exposed over CoAP next to the MQTT topics of Task 2. It was smoke-tested
on the class host (see *Validated* below), because the Python server side is where
pods get stuck, not the MQTT half they already know.

## Run it

```bash
uv add "paho-mqtt>=2,<3" aiocoap
BROKER=192.168.14.1 BASE=cold/ac python coap_unit.py
```

Expect:

```
MQTT connected to 192.168.14.1
CoAP listening on coap://<this host>:5683/warehouse/temp
```

## Test it in three steps, cheapest first

1. **Inside the pod LAN — no rules, no router.** From a second terminal (or the
   second laptop):

   ```bash
   aiocoap-client coap://192.168.14.5:5683/warehouse/temp
   aiocoap-client coap://192.168.14.5:5683/warehouse/set --method POST --payload '{"power":"ON"}'
   ```

   Both interfaces must agree: the MQTT gauge in another terminal changes on the next
   tick after the CoAP POST.

2. **Across the subnet boundary.** Add the port forward on the router
   (Network → Firewall → Port Forwards, UDP `5683` → laptop), then from the router:

   ```sh
   nc -u -w 1 192.168.14.5 5683      # silence is not success, a refusal is a fast failure
   ```

   The real proof is step 3; this only tells you the packet left.

3. **From the cluster.** In Node-RED a `coap request` node, method `GET`,
   `coap://<router overlay address>:5683/warehouse/temp`, next to the `mqtt in`
   node. Same gauge, two sources.

## What to say while it runs

- **Count the rules.** MQTT needed none; CoAP needed one per reachable server.
  That is the comparison the module is after, not "which protocol is better".
- **One state, two interfaces.** The CoAP POST does *not* re-publish to MQTT; the next
  telemetry tick carries the change. Ask what would break if it did re-publish
  (the two interfaces quoting each other, and a command loop under a bad integrator).
- **The failure modes differ.** Kill the MQTT publisher: the gauge freezes on the
  last retained value but CoAP keeps answering. Kill the CoAP server: the MQTT
  side does not notice at all.

## Validated

Run on `ulno-oldplex01`, 2026-11-25, against a local Mosquitto — Python 3.13.5,
`aiocoap` 0.4.17, `paho-mqtt` 2.2.0, both from PyPI:

- `GET /warehouse/temp` → `{"temp": 26.8, "hvac": "OFF"}`
- `POST /warehouse/set {"power":"ON"}` → `2.04 Changed`, and the next `GET` reports
  `"hvac": "ON"` — the two interfaces really do share one state
- `POST` with the payload `nonsense` → `4.00 Bad Request`
- MQTT `cold/ac/env` arrives every tick; `cold/ac/status` reads `online`, then
  `offline` about 10–18 s after a `kill -9`, so the will is registered correctly

Not tested there: a real pod router, the LuCI forward, and `node-red-contrib-coap` —
those need the classroom hardware.

## Traps

- **IPv4 only.** The bind is `("0.0.0.0", 5683)` on purpose; the default `::`
  confuses a pod LAN in a hurry.
- **Ports `5683` and `5684`.** Standard CoAP is UDP `5683`; `5684` is DTLS, which
  this lab does not do. Two servers on one router need two forward entries.
- **aiocoap API.** Written against the 0.4.x layout (`aiocoap.numbers.codes.Code`,
  `Context.create_server_context(root, bind=…)`). If a newer release moves these,
  fix the imports first — the logic is four methods.
- **Do not run the telemetry loop as a `while True`.** It blocks the asyncio
  thread and the CoAP server goes silent while MQTT keeps working, which looks
  like a network fault and is not.
- **`BASE` is silent if wrong.** A typo publishes into a tree nobody subscribes
  to; there is no error. Print `BASE` at start-up when debugging.
- **paho 2.x.** `CallbackAPIVersion.VERSION2` and `reason_code.is_failure`; the
  1.x callback signature fails in a way that blames the broker.

## Extending it for Task 4

The bridge does not care which interface the value came from. If a pod wants a CoAP
source in the bridge, point the `coap request` node at the same resource and let
the `http request` node post to the room's webhook. Nothing in this file changes.
