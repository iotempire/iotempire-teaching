# Module 4 – Application Messaging: MQTT Deep Dive & Integration

[← Back to Module 3](./03-overlay-and-mesh-networks.md) | [Quick module index](./00-index.md) | [Next: Module 5 →](./05-wireless-technologies-and-espnow.md)

**Course placement:** Fri 2026-11-27 — the messaging and integration day. There is no pre-work task: five minutes with the [protocol and port table](./Z-resources-bank.md#protocol-port-table) is enough, and the session starts with the pod check-in and the warehouse.

## 🎯 Learning Goals

This module gives you the opportunity to explore decoupled messaging and system integration and achieve competency in **MQTT mechanics (topics, QoS, retained messages, LWT), Node-RED flows, and Python integration services**. You also place MQTT against CoAP and HTTP, so the protocol choice becomes a decision rather than a habit.

By the end of this module, you can:

1. Explain the MQTT mechanisms — topic hierarchy, QoS levels, retained messages, and the Last Will and Testament — and place MQTT against CoAP and HTTP **on the wire**: what each costs in transport, latency, and security posture. The layer model itself is [Module 1's](./01-foundations-and-masterclass.md) job, not a second lecture here.
2. Build a command-and-dashboard flow on **your pod's Node-RED on the class cluster**.
3. Write an event-driven **integration service in Python or Micropython** on your own machine or on the router.
4. **Simulate a device before it exists** — an AC unit mock-up with a temperature and an on/off HVAC — and then swap the simulation for another publisher without changing a line downstream.

**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 📖 The Challenge — The Warehouse Where Every Sensor Called Every Screen

**Frachtflow** is a logistics startup building a small warehouse control system. Lead developer **Nils Bergmann** started with HTTP: every temperature sensor calls every dashboard directly. With three sensors and one screen it works. With thirty sensors, four dashboards, a Python logger, and an alarm service it becomes a mesh of point-to-point connections, duplicated parsing code, and a dashboard that keeps polling a sensor that has been offline for a day.

Operations lead **Rosa Klein** asks the question that changes the architecture: *"Why does the sensor need to know who is listening?"*

**Your challenge.** Decouple the warehouse with MQTT and prove the decoupling works. You are done when you can show:

1. A topic hierarchy for the warehouse with wildcards, QoS, retained state, and LWT — and one sentence for each choice.
2. A retain-and-LWT experiment that shows the broker publishing the will when a client dies without a `DISCONNECT`, with the detection time measured.
3. A **simulated cooling unit** in Python — a temperature that drifts, an HVAC that answers commands — plus an integrator that closes the loop.
4. A Node-RED flow on your pod's instance that renders the warehouse and sends a command, and a dashboard that keeps working when the integrator is stopped.
5. One paragraph on MQTT vs CoAP vs HTTP for this warehouse — transport, cost, and security posture.

**The cooling unit is the trick that makes the day possible.** Nobody waits for hardware: the AC is a Python script with a fake temperature and a fake compressor, and it behaves like a device — it publishes, it listens for commands, it dies when you kill it. When a real node appears (an M5StickC, if your pod has one), you swap the publisher and nothing downstream changes. That is the abstraction, and today you can see it work twice.

**This story is unfinished on purpose.** The hooks below are starting points, not a script. Pick the ones that match what you actually saw and add a line of your own — *"and the dashboard showed 21.4 °C for a day because the retained value never expired"* is worth more than a perfect diagram. Collect those lines under `## Story seeds`.

### Your portfolio entry — sections in `Module04/README.md`

Split something into its own file only when a section outgrows the page.

- `## Topic plan` — the hierarchy, wildcards, QoS/retain/LWT decisions, the command/state split.
- `## Study log` — the theory you actually needed, the commands that surprised you, the LLM answers you checked. One pod member keeps it; the others link to it and add one sentence.
- `## Discussion log` — one line per exchange: who listened, what they asked, what you changed. This is personal.
- `## MQTT experiments` — the retained value, the will, the detection time, the QoS observations.
- `## Simulated warehouse` — the AC unit, the HVAC, the integrator, and the swap.
- `## Node-RED flow` — the exported flow JSON and the dashboard/command proof (plus the bridge, if you built it).
- `## CoAP experiment` — optional: the second door, the forwarded port, and the sentence on what UDP cost.
- `## Story seeds` — optional: the odd bits worth turning into a story later.

### Three rules that keep this clean

- **Stay inside the pod LAN or the overlay.** The broker is anonymous and has **no TLS in this lab** (port `1883` only; TLS is a later topic, not a task today). Do not expose it to the WAN except in the controlled port-forward test from Module 2. The posture of every other protocol on the day — which port is plaintext, which is not — is in the [protocol and port table](./Z-resources-bank.md#protocol-port-table).
- **No secrets on the broker.** No credentials, no personal data, no other pod's traffic. Topic names are not a security boundary.
- **One owner for the topic tree.** Agree the `pod<NN>/...` prefix and the command/state split before anyone publishes. A second tree is how dashboards lie.

## 🧭 How this works

There is no separate study phase: each task gives you the theory when the task makes you want it. End every task by showing the artefact to **one person at another pod** and asking the discussion question — a brag, not a quiz — then write one line in `## Discussion log`. Take a study break when a task raises a question you cannot answer; explaining it to someone is the test. **The order is a suggestion**: if Node-RED is not up yet, do the simulation first and come back.

The day opens with a pod check-in: one artefact from Modules 1–3, one open question on the board, and the roles — one drives the broker and the CLI, one drives Node-RED, one keeps the topic tree and the notes. Swap after every task; everybody should publish, subscribe, and see one will fire.

| # | Task | You produce | Proves | Exchange question |
|---|---|---|---|---|
| 1 | **Design the topic tree** | The hierarchy and the QoS/retain/LWT reasons | G1, G4 | "Why does the sensor not need to know who is listening?" |
| 2 | **Prove retain and LWT** | The retained will, the timing, the QoS notes | G1 | "What happens when the client dies without `DISCONNECT`?" |
| 3 | **Simulate the warehouse** | An AC unit, an HVAC, an integrator, and the swap | G3, G4 | "What changed downstream when the mock became real?" |
| 4 | **Build the Node-RED flow** | The exported flow and the dashboard/command proof | G2 | "Where does the logic live, and what if Node-RED dies?" |
| ◇ | **Give the warehouse a CoAP door** | A second door on the same unit, plus one forwarded UDP port | G1, G4 | "Which would you put on a battery-powered sensor, and why?" |
| ◇ | **The threshold service on the router** | A MicroPython service on the router | G3 | "Why is this a service, not Node-RED?" |
| ◇ | **Bridge the warehouse into the chat** | A Node-RED flow across two of the four doors, either direction | G3, G4 | "Which side should retry when the chat is down?" |

*Hardware per pod:* the Module 2 router with Mosquitto, your laptops (Python 3, no admin rights needed), your pod's Node-RED on the cluster — address and port on the board — and, if your pod has one, an M5StickC as an optional extra publisher for the swap.

## The Build — **Challenging**


### ★ Task 1 — Design the topic tree

**Proves:** Goals 1 and 4 · **Produces:** `## Topic plan` with the hierarchy, the wildcards, and one line each for QoS, retain and LWT.

Design before you publish. Write the pod prefix, the zones, the device branches, the command/state split and the wildcard the dashboard will use. **Every later task uses this tree** — if you change it mid-day, change it everywhere.

```text
pod<NN>/cold/ac/env          telemetry      {"temp": 24.3, "hvac": "OFF"}
pod<NN>/cold/ac/set          command        {"power": "ON"}      or "OFF"
pod<NN>/cold/ac/status       presence       "online" / "offline"   (retained + will)
pod<NN>/+/+/env              dashboard wildcard: every device, every zone
```

**Theory you need.** HTTP is request/response: the client must know the server, both must be online, and ten consumers mean ten requests. MQTT decouples in three dimensions: **space** (publishers and subscribers know only the broker), **time** (retained messages and sessions let a late subscriber catch up), and **synchronisation** (publishing is non-blocking and asynchronous).

- **Wildcards.** `+` matches exactly one level (`pod07/+/ac/env`); `#` matches the rest (`pod07/#`) and must be last.
- **QoS.** 0 = at most once (fire and forget), 1 = at least once (`PUBACK`, duplicates possible), 2 = exactly once (four-way handshake, most overhead). Telemetry rarely needs 2; commands and the will are worth 1.
- **Retain.** The broker keeps the last retained message per topic; a new subscriber gets it immediately. That is how a dashboard catches up — and how a stale value lies if the publisher stops.
- **LWT.** On connect the client hands the broker a will: topic, payload, retain. If the connection dies without a `DISCONNECT`, the broker publishes it.

```text
[Publisher: simulated AC unit] --PUBLISH pod07/cold/ac/env [QoS 1]--> [Mosquitto on the pod router]
                                                                         |
                                          +------------------------------+------------------------------+
                                          v                                                             v
                              [Subscriber: Node-RED dashboard]                        [Subscriber: integrator / logger]
```

| | MQTT | CoAP | HTTP |
|---|---|---|---|
| Model | pub/sub through a broker | request/response (with observe) | request/response |
| Transport | TCP | UDP | TCP |
| Coupling | decoupled by broker and topic | client addresses a resource URI | client addresses a resource URI |
| Typical fit | telemetry, many subscribers, dashboards | constrained devices, local resources | APIs, browsers, humans |
| Reliability | QoS 0/1/2 | confirmable messages, retries | TCP |
| Security | TLS (8883) — **not used today** | DTLS/OSCORE | TLS |

**Do.** Agree the tree in the pod and write the `## Topic plan`: the hierarchy, the wildcard, and one sentence each for the QoS, the retained topic, and the will.

> **Optional depth — a chat room is a topic.** The class chat runs on Chatto (address on the board). A chat room and an MQTT topic are both "publish to a name, subscribers get it"; chat adds identity, history, and permissions. Look at a channel you are in and write two sentences in `## Study log` on what Chatto gives you that the broker does not.

> **Story hook.** *The topic tree is the warehouse floor plan.* If every pod invents its own names the dashboard cannot aggregate, and the broker will not fix a bad naming decision.

> **Show and ask.** Show your tree. *"Why does the sensor not need to know who is listening?"*

### ★ Task 2 — Prove retain and LWT

**Proves:** Goal 1 · **Produces:** the retained will, the measured detection time, and three QoS notes.

Everything here runs **on the router**, so no laptop tool is needed. If the client tools are missing: `apk update && apk add mosquitto-client-nossl` (the feed may name it `mosquitto-client-ssl`; `apk search mosquitto` shows what you have).

1. **Retain.** Publish a retained value, then start a *new* subscriber and watch it arrive instantly:
   ```sh
   ssh root@192.168.14.1
   mosquitto_pub -t 'pod07/cold/ac/status' -m 'online' -q 1 -r
   mosquitto_sub -t 'pod07/cold/ac/status' -v -C 1     # returns immediately, no publisher running
   ```
2. **The will.** In one SSH session start an observer; in a second start a client that registers a will and then dies without a `DISCONNECT`:
   ```sh
   # session A — observer
   mosquitto_sub -t 'pod07/cold/ac/status' -v

   # session B — the doomed client, keepalive 10 s
   mosquitto_sub -i node07 -t 'pod07/nothing' -k 10 \
     --will-topic 'pod07/cold/ac/status' --will-payload 'offline' --will-retain
   # then, in session B, kill it hard:  kill -9 <pid>
   #   find the pid with:  ps w | grep '[m]osquitto_sub -i node07'
   ```
   **Do not press Ctrl+C** — that is a clean `DISCONNECT` and the broker correctly says nothing. Expect `offline` after roughly **1.5 × keepalive ≈ 15 s**; write down what you measured.
3. **QoS.** Publish the same message at `-q 0`, `-q 1`, `-q 2` and note what the broker had to acknowledge. Duplicates are rare on a working LAN — explain *when* QoS 1 duplicates rather than waiting for one.

**Theory you need.** The broker notices a dead client only when the TCP connection or the keepalive fails; the will is published then, not at the moment of power loss — which is why a short keepalive makes the test fast and a long one makes it look broken. A retained will means a dashboard connecting later still learns the node is gone.

> **Optional:** MQTT Explorer (desktop app, no admin rights needed) draws the same tree live. It is a convenience, not the evidence.

> **Story hook.** *The node that went silent.* Nils's dashboard polled a sensor that had been offline for a day. The will is the broker's answer: the last state can tell you it is stale.

> **Show and ask.** Show the transition and the timing. *"What happens when the client dies without `DISCONNECT`?"*

### ★ Task 3 — Simulate the warehouse

**Proves:** Goals 3 and 4 · **Produces:** `## Simulated warehouse` — three small scripts, the loop running, and the swap.

Nobody waits for hardware today. Build the cooling unit as software: a **fake temperature** that drifts, an **HVAC** that switches on and off when commanded, and an **integrator** that decides. Python 3 on your own machine is enough; use the pinned `uv` environment from the [resource bank](./Z-resources-bank.md#python-environment-with-uv-optional).

```sh
uv add "paho-mqtt>=2,<3"           # pin major 2: the callback API changed in 2.0
```

**1. The AC unit** (`ac_unit.py`) — publishes telemetry, listens for the command, registers a will:

```python
import json, random, time
import paho.mqtt.client as mqtt

BROKER, BASE = "192.168.14.1", "pod07/cold/ac"   # or the router's overlay address
temp, hvac = 26.0, "OFF"

def on_connect(c, u, flags, rc, props):
    if rc.is_failure:
        print("broker refused:", rc); return
    c.subscribe(f"{BASE}/set", qos=1)

def on_message(c, u, msg):
    global hvac
    hvac = json.loads(msg.payload).get("power", hvac)
    print(f"HVAC -> {hvac}")

c = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2, client_id="ac-07")
c.will_set(f"{BASE}/status", "offline", qos=1, retain=True)
c.on_connect, c.on_message = on_connect, on_message
c.connect(BROKER, 1883, 10)          # keepalive 10 s keeps failure detection short
c.loop_start()
c.publish(f"{BASE}/status", "online", qos=1, retain=True)

while True:
    temp += (-0.6 if hvac == "ON" else 0.3) + random.uniform(-0.2, 0.2)
    temp = max(16.0, min(32.0, temp))
    c.publish(f"{BASE}/env", json.dumps({"temp": round(temp, 1), "hvac": hvac}), qos=1)
    time.sleep(2)
```

**2. The integrator** (`integrator.py`) — the same loop, decided in code, with hysteresis so it does not flap:

```python
import json
import paho.mqtt.client as mqtt

BROKER, BASE = "192.168.14.1", "pod07/cold/ac"   # same broker as the AC unit

def on_connect(c, u, flags, rc, props):
    if rc.is_failure:
        print("broker refused:", rc); return
    c.subscribe(f"{BASE}/env", qos=1)

def on_message(c, u, msg):
    d = json.loads(msg.payload)
    if d["temp"] > 27.0 and d["hvac"] == "OFF":
        c.publish(f"{BASE}/set", json.dumps({"power": "ON"}), qos=1)
    elif d["temp"] < 25.0 and d["hvac"] == "ON":
        c.publish(f"{BASE}/set", json.dumps({"power": "OFF"}), qos=1)

c = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2, client_id="integrator-07")
c.on_connect, c.on_message = on_connect, on_message
c.connect(BROKER, 1883, 10)
c.loop_forever()
```

Watch with `mosquitto_sub -h 192.168.14.1 -v -t 'pod07/#'` (run it on the router if your laptop has no client tools). The temperature should rise, the integrator should switch the HVAC on above 27 °C, the temperature should fall, and the HVAC should switch off below 25 °C.

**3. The swap.** Kill the AC unit (`Ctrl+C` is fine here: a clean exit, no will) and restart it as a **different publisher** — a one-line `mosquitto_pub` loop, a second script on another laptop, or the M5StickC if your pod has one. Nothing downstream changes: not the integrator, not Node-RED, not a single line of code. Write one sentence on why.

**Theory you need.** `on_connect` runs when the broker accepts the client; `on_message` runs for each subscribed message; `loop_start()` keeps the network loop in a thread, `loop_forever()` blocks the main one. Those callbacks are the service's contract. A mock and a real node are interchangeable only because they publish the same topic and the same payload shape — the abstraction is the contract, not the hardware. Hysteresis is the same trick you know from control: two thresholds, one for switching on and one for switching off.

> **Story hook.** *The mock that became real.* Nils tests the alarm before the hardware exists and swaps in the real unit without touching the dashboard. Rosa cares because the warehouse can be commissioned before every sensor arrives.

> **Show and ask.** Show the loop and the swap. *"What changed downstream when the mock became real?"*

### ★ Task 4 — Build the Node-RED flow

**Proves:** Goal 2 · **Produces:** the exported flow JSON and the dashboard plus a command on the wire.

1. Open **your pod's Node-RED** on the class cluster — URL and port are on the board — and log in with the class credentials. Never install Node-RED on the router, and no laptop install is needed. (A laptop install is the fallback if the cluster is down: `http://localhost:1880`.)
2. An `mqtt in` node on `pod<NN>/+/+/env`, a `json` node, a `gauge` and a `text` for the temperature and the HVAC state. Broker: the **router's overlay address**, port `1883` — the flow runs on the cluster, so it cannot use the pod's LAN address.
3. Two `ui_button` nodes publishing `pod<NN>/cold/ac/set` with `{"power":"ON"}` and `{"power":"OFF"}`. This is the **operator override**; the automation stays in your integrator.
4. Watch both: the gauge follows the simulated unit, and the buttons move the HVAC.
5. Export the flow and save it as `flow.json` in `## Node-RED flow`.

**Theory you need.** A flow is nodes connected by messages: `mqtt in` subscribes, `function` transforms, `mqtt out` publishes, dashboard nodes render. The point of this task is the **split of responsibility**: Node-RED is the human surface, the integrator is the logic, the broker is the meeting point. If Node-RED dies the devices keep publishing and the retained state stays — but the dashboard and the override stop. Stop your Node-RED container or close the tab and say what still works.

> **Story hook.** *The dashboard that kept polling a dead sensor.* A gauge cannot invent the truth; the retained will is what tells the operator the reading is stale.

> **Show and ask.** Show the gauge and the override, then stop the flow. *"Where does the logic live, and what if Node-RED dies?"*

### ◇ Task 5 (Stretcher) — Give the warehouse a CoAP door

**Proves:** Goals 1 and 4 · **Produces:** a CoAP endpoint on the same simulated unit, one forwarded UDP port, and one sentence on what the transport bought and cost.

The unit from Task 3 already speaks MQTT. Give it a second door without changing what it knows.

1. In the same `uv` environment: `uv add aiocoap`. Add a small server to `ac_unit.py`: a `Resource` whose `render_get` returns `{"temp": …, "hvac": …}`, and a `render_post` on `warehouse/set` that flips the HVAC. **Both doors must share the same two variables** — that is the whole exercise. The MQTT loop blocks, so run the CoAP context in a background thread (`threading.Thread(target=asyncio.run, args=(main_coap,), daemon=True)`) and let the resources read the module-level `temp` and `hvac`.
2. **Prove it inside the pod first.** From a second laptop (or a second terminal): `aiocoap-client coap://<laptop LAN IP>:5683/warehouse/temp`. Same subnet, no rule, no router — CoAP between two peers is just UDP.
3. **Now cross the subnet boundary.** Node-RED is not in your LAN, so it needs a door: on the router, a port forward **UDP `5683` → your laptop** (Network → Firewall → Port Forwards). You did the TCP version in Module 2; UDP is the same screen and a different NAT problem. **One forward per server** — two laptops serving CoAP means `5683` → A and `5684` → B, because there is no broker to multiplex them. Quick check from the router: `nc -u -w 1 <laptop LAN IP> 5683`; silence is not proof, but a refusal is a fast answer.
4. In Node-RED, install `node-red-contrib-coap` and add a `coap request` node next to the `mqtt in` node from Task 4, polling `coap://<router overlay address>:5683/warehouse/temp`. Both feed the same gauge.
5. Break one door at a time: stop the MQTT publisher, read the gauge; stop the CoAP server, read it again. Note how differently the two failures look.
6. Log one sentence: **what did UDP buy, and what did it cost?**

> **Count the rules — this is the comparison the module is after.**
>
> | | What must be reachable | Rules to keep correct | A laptop with a new IP |
> |---|---|---|---|
> | MQTT | one broker, on the router | **none** — every client dials out | nothing breaks |
> | CoAP, others pull | every server | **one forward per server** | that device, silently |
> | CoAP, device pushes | one collector | one rule, set up once | nothing breaks |
> | HTTP, others poll | every server | one forward per server | that device, silently |
>
> Three clients and one server need no rule at all; three servers and one client need three. That is why a warehouse with twenty sensors and four dashboards talks MQTT: the broker is a **rendezvous point**, so reachability is configured once instead of once per pair. CoAP is not worse — it is the honest peer-to-peer bill, which is exactly what you want on a constrained device that only ever talks to one neighbour. And note the third row: push into a single collector gives CoAP MQTT-like economics, which is precisely the idea MQTT turned into a protocol.

**Theory you need.** The layer tells you what a protocol can assume; the transport tells you what it costs. CoAP is HTTP's method model over UDP — confirmable messages with retransmission instead of a stream, `observe` instead of polling, `5683` instead of `80`. The price is that anything unreliable in the path becomes your application's problem.

> **Direction matters more than the protocol.** The cluster cannot reach a laptop on the pod LAN: only the router stands in both worlds, so reaching *in* from the cluster needs the forward above. Invert the direction and you need no router rule at all — a `coap in` node in your pod's Node-RED becomes the server and your laptop POSTs to `coap://<Node-RED host>:<port>/…` — but that costs a UDP port mapped into the container plus one overlay rule on the cluster host, and it turns the device back into a client that must know its collector. A third way is the [Module 3 laptop-join stretcher](./03-overlay-and-mesh-networks.md#the-build--challenging): with a Nebula client the laptop has its own overlay address, so **both** directions work with no forward at all — at the price of a client, a bundle, and an inbound UDP rule in that laptop's own policy. One door either way; the pull direction teaches the most about reachability.

> **Show and ask.** Show the same reading arriving twice, over two protocols. *"Which would you put on a battery-powered sensor, and why?"*

### ◇ Task 6 (Stretcher) — The threshold service on the router

**Proves:** Goal 3 · **Produces:** a MicroPython service on the router that acts on the warehouse telemetry.

In [Module 3](./03-overlay-and-mesh-networks.md#the-build--challenging) you made the router publish and subscribe with `umqtt.simple`. Now give it a rule: subscribe to `pod<NN>/+/+/env`, compare the temperature against two thresholds, and publish an alarm to `pod<NN>/cold/alarm` (retained, QoS 1) when the HVAC should be on but the reading keeps rising. Run it next to the Python integrator — two integrators, one broker — and explain which one you would keep and why.

**Theory you need.** MicroPython has no Node-RED runtime and very little RAM; `umqtt` is a small client with the same pub/sub model. The router is already the broker and the gateway, so a rule there removes a laptop from the loop — and makes the router a single point of failure for both. `paho-mqtt` does **not** belong on the router: it is CPython, and it stays the laptop client.

> **Story hook.** *The rule that never sleeps.* The laptop closes at the end of the day; the router in the basement does not.

> **Show and ask.** Show the alarm firing. *"Why is this a service, not Node-RED?"*

### ◇ Task 7 (Stretcher) — Bridge the warehouse into the chat

**Proves:** Goals 1, 3 and 4 · **Produces:** a Node-RED flow that carries one event across a boundary in **either or both** directions, between two of the four doors the warehouse now has: MQTT, CoAP, a chat webhook, Telegram or Discord.

*The chain below is an **example, not a recipe**.* Any bridge that survives the discussion question counts, and the reverse direction is often the more interesting one.

1. **One example, a topic → chat:** `mqtt in` (or a `coap request`) → `function` → `http request` POST to a room's incoming webhook (room settings → integrations; the address is on the board). One alarm in, one message out.
2. **The other direction:** let an incoming message *act* on something in your own router network — a command topic the router or an ESP obeys, a lamp, a relay. A human writes prose, a machine needs a typed command; your bridge is where the translation happens.
3. **Mix the doors.** MQTT in and CoAP out, a chat message that moves a CoAP resource, a Telegram alert from a topic. Two protocols are enough to make the point — the interesting pairs are the ones that disagree about reliability.
4. **Do not forward every reading.** Rate is the design question: alarm, state change, or periodic digest. Say which, and why, in one sentence.
5. Save the flow as `bridge.json` and screenshot both ends. **One direction proved is enough; both is better.**

> **Exposure question.** Which of these doors would you put on the internet, and which only inside the overlay? The webhook is an **outbound** door with a secret URL, your CoAP forward is an **inbound** door into the pod LAN, and Discord or Telegram is somebody else's server. Say which you would leave open after the class, and who holds the credential.

**Theory you need.** A bridge is an **adapter, not a new protocol**: it maps one address space onto another and decides what *not* to carry. A topic is chosen by the publisher and carries a typed payload plus the last value; a room is joined by people and carries prose plus history. The HTTP call is the easy part. The design questions are rate, direction and failure: what happens to an alarm raised while the chat is unreachable — retry, drop, or buffer?

> **Show and ask.** Show one event crossing, then stop the bridge. *"What did MQTT lose, what did the chat lose, and which side should retry?"*

> **Certificate note.** The class chat is HTTPS with a self-signed certificate, so an `http request` node rejects it. Set `msg.rejectUnauthorized = false` for that node, and write one sentence in your log on why that is acceptable *only* inside the overlay.

## Ask an LLM — then verify

Treat every answer as a **claim to test**, not a fact, and run it against your own broker.

- "Compare QoS 0, 1, and 2 in terms of packet exchange, latency, and duplicate risk. When is QoS 0 acceptable in sensor telemetry?"
- "Explain retained messages and Last Will and Testament with a concrete offline-detection example. What does the broker publish, and when?"
- "Design an MQTT topic hierarchy for a warehouse with several zones, sensors, and actuators. Justify the levels and the command/state split."
- "My Python subscriber misses messages when it restarts. Which MQTT features fix this, and what are their limits?"
- "Compare MQTT over TCP with CoAP over UDP for a battery-powered sensor that reports every ten minutes. When does `observe` beat polling, and what does each cost when the link drops packets?"

Record where the model is wrong, vague, or over-confident in `## Study log`.

## 🔁 Curiosities — the harvest ritual is gone

We dropped the formal harvest. Keep collecting anyway: note the odd bits in `## Study log` and share them — in a reflection, on the class chat, or by telling someone at another pod when you take a break. A retained value that looked live, a will that fired late, a duplicate after a QoS 1 retry, a topic nobody subscribed to, a dashboard showing yesterday's number: these are the questions worth carrying forward, and two pods hitting the same one is worth a line in the class channel.

## ✅ Suggested evidence

A suggestion, not a checklist — the learning goals are the contract, and an artefact of your own that proves them is worth more than a ticked list.

1. **Topic plan (goals 1 and 4):** the hierarchy, the wildcard, the command/state split, and one line each for QoS, retain and LWT.
2. **Retain and LWT (goal 1):** the `online` → `offline` transition, the measured detection time, and one paragraph on why a graceful disconnect stays silent.
3. **Simulated warehouse (goals 3 and 4):** the AC unit, the integrator, the loop in the terminal, and the swap — with the one sentence on why nothing downstream changed.
4. **Node-RED flow (goal 2):** the exported `flow.json`, the gauge, the override command, and the observation of what still works with the flow stopped.
5. **Protocol choice (goal 1):** one paragraph on MQTT vs CoAP vs HTTP — transport, cost, and what you would put on a battery-powered sensor.
6. **The log and the exchanges:** `## Study log` and `## Discussion log`.
7. **Optional:** the CoAP door — the endpoint, the forwarded port, the two readings, and the sentence on what UDP cost.
8. **Optional:** the MicroPython threshold service on the router, and the two-integrator comparison.
9. **Optional:** the bridge — `bridge.json`, whichever direction(s) and doors you used, and the one sentence on rate and failure.

> [!IMPORTANT]
> Never commit secrets, credentials, private keys, or a broker configuration with passwords. Where you did not work alone, link your pod mates and your sources.

## 📚 Resources

- [MQTT 5.0 specification](https://docs.oasis-open.org/mqtt/mqtt/v5.0/mqtt-v5.0.html) and [mqtt.org](https://mqtt.org/) — the protocol reference.
- [HiveMQ: MQTT essentials](https://www.hivemq.com/mqtt-essentials/) — the readable guide to topics, QoS, retain, and LWT.
- [Node-RED documentation](https://nodered.org/docs/) — flows, context, and dashboards.
- [`paho-mqtt` documentation](https://eclipse.dev/paho/files/paho.mqtt.python/html/index.html) — the Python client, including the 2.x callback API.
- [CoAP (RFC 7252)](https://www.rfc-editor.org/rfc/rfc7252) and [coap.technology](https://coap.technology/) — the constrained-device alternative.
- [`aiocoap`](https://aiocoap.readthedocs.io/) — the Python CoAP library in Task 5: client, server and `ObservableResource`.
- [`node-red-contrib-coap`](https://flows.nodered.org/node/node-red-contrib-coap) — the `coap request`, `coap in` and `coap response` nodes.
- [MicroPython `umqtt`](https://github.com/micropython/micropython-lib/tree/master/micropython/umqtt.simple) — the small MQTT client for the router path.
- [Chatto](https://github.com/chattocorp/chatto) — the self-hosted chat the class uses; compare a room with a topic. Its [self-hosting docs](https://docs.chatto.run/) cover the HTTP API and incoming webhooks that Task 7 talks to.
- The [resource bank](./Z-resources-bank.md) — the [protocol/port table](./Z-resources-bank.md#protocol-port-table), the [`uv` environment](./Z-resources-bank.md#python-environment-with-uv-optional), and the [MQTT command cheat sheet](./Z-resources-bank.md#mqtt-command-cheat-sheet).

---

[← Previous: Module 3](./03-overlay-and-mesh-networks.md) | [Back to front page](../README.md) | [Quick module index](./00-index.md) | [Next: Module 5 — Wireless Technologies & ESP-NOW →](./05-wireless-technologies-and-espnow.md)
