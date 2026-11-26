# Module 4 CoAP reference — the unit with two doors

Tracked instructor material for [Module 4 Task 3](../../modules/04-mqtt-and-integration.md#-task-3--a-little-bit-of-coap).
Students may read it as a worked example; it is not an answer key to hide.

`coap_unit.py` is the sender from Task 1 with a **second door**: the same
`state` dict exposed over CoAP next to the MQTT topics of Task 2. It exists
because the Python server side is the one piece of the day nobody has run end to
end yet.

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

   Both doors must agree: the MQTT gauge in another terminal changes on the next
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
- **One state, two doors.** The CoAP POST does *not* re-publish to MQTT; the next
  telemetry tick carries the change. Ask what would break if it did re-publish
  (the two doors quoting each other, and a command loop under a bad integrator).
- **The failure modes differ.** Kill the MQTT publisher: the gauge freezes on the
  last retained value but CoAP keeps answering. Kill the CoAP server: the MQTT
  side does not notice at all.

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

The bridge does not care which door the value came from. If a pod wants a CoAP
source in the bridge, point the `coap request` node at the same resource and let
the `http request` node post to the room's webhook. Nothing in this file changes.
