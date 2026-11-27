# Module 4 – Application Messaging: MQTT Deep Dive & Integration

[← Back to Module 3](./03-overlay-and-mesh-networks.md) | [Quick module index](./00-index.md) | [Next: Module 5 →](./05-wireless-technologies-and-espnow.md)

**Course placement:** Fri 2026-11-27 — the messaging and integration day.

**Attention:** This day is experimental. Therefore, tasks below say what you are after, not every keystroke. Some things will break — a bridge, a port, a library, the chat — and a broken thing you can explain is worth more than a copied flow that happens to work. When something fails: read the error, change one variable, tell another pod, then ask us. Keep a list of what broke and enjoy the exploration.

## 🎯 Learning Goals

This module gives you the opportunity to explore decoupled messaging and system integration and achieve competency in **MQTT mechanics (topics, QoS, retained messages, LWT), Node-RED flows, and Python integration services**. You also place MQTT against CoAP and HTTP, so the protocol choice becomes a decision rather than a habit.

By the end of this module, you can:

1. Explain the MQTT mechanisms — topic hierarchy, QoS levels, retained messages, and the Last Will and Testament — and place MQTT against CoAP and HTTP **on the wire**: what each costs in transport, latency, and security posture. The layer model itself is [Module 1's](./01-foundations-and-masterclass.md) job, not a second lecture here.
2. Build a command-and-dashboard flow on **your pod's Node-RED on the class cluster**.
3. Write an event-driven **integration service in Python** on your own machine with `paho-mqtt`, and a small one in **MicroPython on the router** where the service fits.
4. **Simulate a device before it exists** — a fake AC unit with a temperature and an on/off HVAC — and then swap the simulation for another publisher without changing a line downstream.

**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 📖 The Challenge — The Warehouse Where Every Sensor Called Every Screen

**Frachtflow** is a logistics startup building a small warehouse control system. Lead developer **Nils Bergmann** started with HTTP: every temperature sensor calls every dashboard directly. With three sensors and one screen it works. With thirty sensors, four dashboards, a Python logger, and an alarm service it becomes a mesh of point-to-point connections, duplicated parsing code, and a dashboard that keeps polling a sensor that has been offline for a day.

Operations lead **Rosa Klein** asks the question that changes the architecture: *"Why does the sensor need to know who is listening?"*

**Your challenge.** Follow the warehouse from one-to-one to decoupled, and know when to stop. You are done when you can show:

1. An **HTTP endpoint** on your Node-RED that takes a reading from your laptop and shows it — plus one sentence on what the sender had to know.
2. A **topic tree** with the QoS and retain decisions written down, and the will behaviour you measured.
3. A **CoAP interface** on the same data, reached from another machine.
4. **Three bridges** that move an event between different systems, at least one of them in the reverse direction.
5. One paragraph on MQTT vs CoAP vs HTTP — transport, cost, and security posture.

**The cooling unit is the trick that makes the day possible.** Nobody waits for hardware: the AC is a Python script with a fake temperature and a fake compressor, and it behaves like a device — it sends, it listens for commands, it dies when you kill it. You build it in Task 1 as an HTTP client and keep it all day. When a real node appears (an M5StickC, if your pod has one), you swap the sender and nothing downstream changes.

**This story is unfinished on purpose.** The hooks below are starting points, not a script. Pick the ones that match what you actually saw and add a line of your own — *"and the dashboard showed 21.4 °C for a day because the retained value never expired"* is worth more than a perfect diagram. Collect those lines under `## Story seeds`.

### Your portfolio entry — sections in `Module04/README.md`

Split something into its own file only when a section outgrows the page.

- `## The sender` — your Python temperature source, and the swap to a different publisher.
- `## HTTP endpoint` — the Node-RED endpoint, the curl and Python calls, and what the sender had to know.
- `## Topic plan` — the hierarchy, the wildcard, and one line each for QoS, retain and the will.
- `## MQTT experiments` — QoS 0/1/2, the retained value, the will, the detection time.
- `## CoAP experiment` — the second interface, the forward, and the sentence on what UDP cost.
- `## Bridges` — the three flows, what crossed, what broke.
- `## Hardware experiment` — optional: what you built, the payload comparison, and what the mock had decided for you.
- `## Study log` — the theory you actually needed, the commands that surprised you, the LLM answers you checked. One pod member keeps it; the others link to it and add one sentence.
- `## Discussion log` — one line per exchange: who listened, what they asked, what you changed. This is personal.
- `## Story seeds` — optional: the odd bits worth turning into a story later.

### Three rules that keep this clean

- **Stay inside the pod LAN or the overlay.** The broker is anonymous and has **no TLS in this lab** (port `1883` only; TLS is a later topic, not a task today). Do not expose it to the WAN except in the controlled forward from Task 3. The posture of every other protocol on the day is in the [protocol and port table](./Z-resources-bank.md#protocol-port-table).
- **No secrets on the broker.** No credentials, no personal data, no other pod's traffic.
- **A topic name is not a permission.** Agree the tree in the pod before anyone publishes; a second tree is how dashboards "lie".

## 🧭 How today works

As usual, there is no separate study phase: each task gives you the theory when the task makes you want it. End every task by showing the artefact to **one person at another pod** and asking the discussion question — a brag, not a quiz — then write one line into your portfolio, for example into `## Discussion log`. Take a study break when a task raises a question you cannot answer; explaining it to someone is the test.

**The following order is a suggestion**, and Task 4 is the reason for the day. If a bridge fires early, chase it and come back — but leave time for it.

| # | Task | You produce | Proves | Exchange question |
|---|---|---|---|---|
| 1 | **Reach the warehouse over HTTP** | An endpoint, two clients, a reading on the dashboard | G1, G2 | "Who had to know whom?" |
| 2 | **MQTT deep dive** | The tree and the QoS/retain/will measurements | G1 | "What does the broker take off your hands?" |
| 3 | **A little bit of CoAP** | A second interface on the same data, plus one forwarded port | G1 | "Which would you put on a battery-powered sensor?" |
| 4 | **Bridges — build at least three** | Three flows crossing systems, one of them reverse | G2, G3, G4 | "Which side should retry?" |
| ◇ | **Take it onto real hardware** (optional, open-ended) | One device of your choice publishing into your tree | G3, G4 | "What did the mock hide from you?" |

*Hardware per pod:* the Module 2 router with Mosquitto, your laptops (Python 3, no admin rights needed), your pod's Node-RED on the cluster — address and port on the board — and, if your pod has one, an M5StickC as an optional extra publisher. For the hardware stretcher your instructor brings **ESP32/M5Stack boards and a box of sensors on request**.

## The Build — **Challenging**

### ★ Task 1 — Reach the warehouse over HTTP

**Proves:** Goals 1 and 2 · **Produces:** an HTTP endpoint on your Node-RED, two clients that feed it, and a dashboard that shows what arrived.

Start with the thing MQTT replaces. Frachtflow's first version is one endpoint and one caller, and it works fine — until there are two callers.

1. In your pod's Node-RED, build an `http in` node (`POST`, a path such as `/warehouse/temp`), parse the JSON, and put the value on the dashboard. Deploy it. The address is your Node-RED's own host and port, on the board (the class already opens those ports per pod, so if a call hangs you have the wrong address, not a firewall problem - but still don't hesitate to ask questions if something "hangs").
2. Call it from your laptop with `curl`, through the router. Watch the dashboard change. Ask your favorite llm for some examples how to use curl to do http requests and try to connect it to Node-RED.
3. Now write the caller in Python: a small loop that POSTs a drifting temperature every two seconds. Use the [`uv` environment](./Z-resources-bank.md#python-environment-with-uv-optional) from the resource bank — `uv add requests` now, and `uv add "paho-mqtt>=2,<3"` when Task 2 needs it (the 2.x callback API is a different signature). This is your sender for the rest of the day; keep it, you will swap it later without touching the reader.
4. Break it on purpose. Restart the sender while the reader runs; then stop/disable the flow in Node-RED. Write down what each failure looks like from the sender's side.
5. Answer: what did your sender have to know? What would you have to change for a second consumer — and who would have to change it (in the story)?

**A bit of theory:** HTTP is request/response: the client must know the server, both must be online, and ten consumers mean ten requests with ten copies of the parsing code. A sensor that posts to a dashboard is coupled to that dashboard's address and its life. The reverse direction is worse — for the dashboard to call the sensor, the sensor needs a forwarded port or a client on the laptop, which is the same wall you hit in Task 3.

> **Story hook.** *Nils's first version.* One sensor, one screen, one afternoon. Then Rosa hires a second analyst.

> **Share/brag about your results** to neigboring pods - help them to get to your point, share curiosities.

### ★ Task 2 — MQTT deep dive

**Proves:** Goal 1 · **Produces:** `## Topic plan` and `## MQTT experiments` — the tree, the decisions, and what you measured.

Now take the same reading through the MQTT broker (your Mosquitto on the router) and see what changes for the sender.

**Where you run it matters.** The broker lives on the router, and `mosquitto_pub` / `mosquitto_sub` on the router are fine for a quick look (`apk add mosquitto-client-nossl` if they are missing). Anything that should behave like a *device* — a will, a reconnection, a shutdown — runs on your laptop, because a client that shares a machine with its broker cannot lose the network between them.

1. **Design the tree.** Your pod owns a broker, so a short tree is enough — `cold/ac/env`, `cold/ac/set`, `cold/ac/status`. Write down the command/state split and the one wildcard you will actually use. Then answer in one sentence: *what would you have to change if all fifteen pods shared one broker?*
2. **Send your reading through it.** Your Python sender from Task 1 publishes to the tree instead of posting (same `uv` environment, now with `paho-mqtt` 2.x); Node-RED subscribes. The dashboard should not care which interface the value came through. That is the whole point.
3. **Retain.** Publish a state value retained, then start a *new* subscriber and watch it arrive without a publisher running.
4. **The will — three ways to end a client, and only one of them is the story.** Run this on **your laptop**, with the broker on the router. In Python, because the shutdown path is the thing you are testing and the library will not decide it for you:

   ```python
   import paho.mqtt.client as mqtt

   BROKER, BASE = "192.168.14.1", "cold/ac"      # the router's address, from Task 1

   c = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2, client_id="will-test")
   c.will_set(f"{BASE}/status", "offline", qos=1, retain=True)
   c.connect(BROKER, 1883, 10)                    # keepalive 10 s
   c.publish(f"{BASE}/status", "online", qos=1, retain=True)
   try:
       c.loop_forever()
   except KeyboardInterrupt:
       c.disconnect()                             # comment this line out for case 2
   ```

   Watch `mosquitto_sub -v -t 'cold/ac/status'` from a second terminal and try all three:

   - **Polite:** `Ctrl+C` with the `disconnect()` in place — the broker stays silent. A goodbye needs no announcement.
   - **Hard:** delete the `disconnect()` line and `Ctrl+C` again. The process dies, the socket closes, and the will fires **at once** — measured 0.4 s, not 15. `kill -9 <pid>` (Windows: `taskkill /F /PID <pid>`) does the same. **The will is not the library's job; it is your shutdown path** — which is exactly why a real service needs one.
   - **Silent:** turn the Wi-Fi off. Nothing is sent, the socket stays half-open, and the broker notices only when the keepalive expires — `1.5 × keepalive ≈ 15 s`. That is Nils's dead sensor, and the reason the keepalive is a design decision rather than a default.

   > The CLI one-liner is the same experiment with less control — and it is what you use all day when you only want to *look*:
   > ```sh
   > mosquitto_sub -i node-you -k 10 -t 'nothing/here' \
   >   --will-topic 'cold/ac/status' --will-payload 'offline' --will-retain
   > ```
   > Its `Ctrl+C` sends a proper `DISCONNECT` (measured: nothing appeared for 28 s), so the polite case is free — but that behaviour belongs to the tool, not to MQTT, and on Windows the same CLI installs no `Ctrl+C` handler, so there `Ctrl+C` *is* the hard case. Two tools, two answers: that is the lesson.

5. **QoS.** Publish the same message at `-q 0`, `-q 1`, `-q 2` and note what the broker acknowledged. Duplicates are rare on a working LAN — explain *when* QoS 1 duplicates instead of waiting for one.

| | MQTT | CoAP | HTTP |
|---|---|---|---|
| Model | pub/sub through a broker | request/response (with observe) | request/response |
| Transport | TCP | UDP | TCP |
| Coupling | decoupled by broker and topic | client addresses a resource URI | client addresses a resource URI |
| Typical fit | telemetry, many subscribers, dashboards | constrained devices, local resources | APIs, browsers, humans |
| Reliability | QoS 0/1/2 | confirmable messages, retries | TCP |
| Security | TLS (8883) — **not used today** | DTLS/OSCORE | TLS |

**CoAP appears in this table before you have met it.** Treat that column as a promissory note: [Task 3](#-task-3--a-little-bit-of-coap) is where it stops being a comparison and becomes something you can actually call — and where the missing broker sends its bill.

**Theory you need.** MQTT decouples in three dimensions: **space** (publishers and subscribers know only the broker), **time** (retained messages and sessions let a late subscriber catch up), and **synchronisation** (publishing is non-blocking). The broker notices a dead client in one of two ways, and the difference matters: a **closed connection** is detected at once, a **silent** one only when the keepalive expires. A graceful `DISCONNECT` is a third case again — the client says goodbye, so the will stays unpublished and the retained state keeps the last true value.

> **You are not done with theory until you answer this:** the broker in this lab is `1883`, plaintext, and anyone on the overlay can read and write everything. What would a real warehouse need, and what does the protocol already give you to build it on? One paragraph in `## Study log`.

> **Story hook.** *The node that went silent.* The dashboard polled a sensor that had been offline for a day. The will is the broker's answer: the last state can tell you it is stale.

> **Show and ask.** Show the transition and the timing. *"What does the broker take off your hands?"*

### ★ Task 3 — A little bit of CoAP

**Proves:** Goal 1 · **Produces:** a CoAP resource on the same data, reached from another machine, and one sentence on what UDP cost.

MQTT needs a broker; CoAP does not. Find out what that trades.

1. **Prove it inside the pod first.** Expose the same reading over CoAP on your laptop and read it from the second laptop. Same subnet, no rule, no router — CoAP between two peers is just UDP. Say why that needed no configuration at all.
2. **Then cross a boundary.** Node-RED is not on your LAN, so it needs a way in: one **UDP port forward** on the router (`5683` → your laptop). That is [Module 2's *Round 7 — One door*](./02-local-networking-and-gateways.md) again, now for UDP: same screen, different NAT problem.
3. Read it from Node-RED with a `coap request` node next to your `mqtt in` node. Same gauge, two protocols, one source of truth.
4. Break one interface at a time and compare the two failures.
5. One sentence: **what did UDP buy, and what did it cost?**

A worked server (`coap_unit.py`, MQTT and CoAP on one state) is in the [Task 3 reference lab](../instructor-notes/module4-coap-lab/README.md) — try yours first, then compare. The library for the Python side is [`aiocoap`](https://aiocoap.readthedocs.io/), the Node-RED side is [`node-red-contrib-coap`](https://flows.nodered.org/node/node-red-contrib-coap).

**Theory you need.** CoAP is HTTP's method model over UDP: GET and POST instead of a stream, confirmable messages with retransmission, `observe` instead of polling, `5683` instead of `80`. The price is that anything unreliable in the path becomes your application's problem. **And count the rules:** the broker needed none, every CoAP server that others must reach needs one — which is exactly the bill a broker pays for you.

> **Show and ask.** Show the same reading arriving twice. *"Which would you put on a battery-powered sensor, and why?"*

### ★ Task 4 — Bridges: build at least three

**Proves:** Goals 2, 3 and 4 · **Produces:** three Node-RED flows that move an event between different systems, and a log of what broke.

This is the day's real work. A bridge is where two worlds meet, and each one you build teaches you something the others do not.

1. **Pick three** from the interfaces you now have: HTTP, MQTT, CoAP, the class chat's incoming webhook, Telegram or Discord, and the router itself (a command topic it obeys). Node-RED is your workbench for all of them.
2. **At least one must run the other way:** something arriving from *outside* your pod makes something happen *inside* it — a message that flips a CoAP resource, a chat line that switches the HVAC, a button on the router.
3. **Rate is a design decision.** A bridge at one message per reading is a flood. Send the alarm, the state change, or a digest, and say why in one sentence.
4. **The chat is the most experimental thing on the board.** It may refuse a certificate, hang, or lose its session. That is part of the day, not a reason to stop: capture the error, try once more, and use a Telegram or Discord webhook if it stays broken — each is one URL.
5. Save each flow as JSON under `## Bridges`, with one line per bridge: what crossed, what broke, what you would change.

**Theory you need.** A bridge is an **adapter, not a new protocol**: it maps one address space onto another and decides what *not* to carry. A topic carries a typed payload and the last value; a room carries prose and history; a CoAP resource is a document you can POST to. The HTTP call is the easy part — the design questions are rate, direction, and failure. What happens to an alarm raised while the chat is down: retry, drop, or buffer?

> **Certificate note.** The class chat is HTTPS with a self-signed certificate, so an `http request` node rejects it. Set `msg.rejectUnauthorized = false` for that node, and write one sentence on why that is acceptable *only* inside the overlay.

> **Exposure question.** Which of these would you put on the internet, and which only inside the overlay? The webhook is an **outbound** connection whose secret URL works from anywhere; the CoAP forward is an **inbound** opening you punched into the pod LAN's NAT; and Discord or Telegram is somebody else's server. Say which you would leave open after the class, and who holds the credential.

> **Story hook.** *The warehouse that talks to the city.* Rosa wants an alarm in the chat before anyone opens a dashboard. Nils builds it in an afternoon and learns that the hard part is not the message.

> **Show and ask.** Show one event crossing, then stop the bridge. *"Which side should retry?"*

### ◇ Task 5 (Stretcher) — Take it onto real hardware

**Proves:** Goals 3 and 4 · **Produces:** one device of your own choosing, publishing into your own tree, and a short note on what surprised you.

Completely optional, and open-ended on purpose. Do it when the bridges work — or when you are stuck and want a different kind of stuck. Your instructor brings **ESP32 and M5Stack hardware** and a box of **sensors on demand**: ask before you take one, and hand it back working.

**Choose an experiment:**

- **A button.** The smallest useful device: one topic, one payload, no dashboard. If you do one thing here, do this.
- **A sensor.** Temperature, light, distance — whatever is in the box. Publish on an interval and compare the payload with your simulated unit. If the shape matches, you can swap it in and no consumer notices: that is Goal 4 on real silicon.
- **CoAP on the device.** The same reading, no broker. Which is easier to reach from Node-RED, and why is the answer different from MQTT?
- **IoTempower**, the fleet path: [IoTempower](https://iotempower.us) flashes and configures nodes from your laptop with a `node.conf`, the tool Module 1 touched in its [open-ended explorations](../../../workshops/mastering-iot-solutions/README.md#open-ended-explorations). Longest path, closest to a real deployment.
- **Something none of us thought of.** Explicitly allowed. Say what you tried and what it taught you.

> **IoTempower needs a real Linux (or macOS) command line.** A router shell is not enough — it wants bash, a package manager, git and USB access to the board. If you already use Ubuntu, Debian or Fedora — directly, in a VM, or under WSL 2 on Windows — go ahead: it installs cleanly and pulls in what this class needs for networks and microcontrollers. If you have never worked in a terminal like that, pick a different experiment today; that is a separate afternoon, not a step in this task.

> **A shortcut that usually works.** Install PlatformIO in a throwaway environment with `uv tool install platformio`, then hand an agent the fixed facts — the board, your pod's Wi-Fi name and password, the broker's address, the topic and the payload shape — and ask it for a minimal sketch that publishes when you press the button. That is often enough to have a device talking in one sitting. Read what comes back before you flash it: board definitions and pin numbers are exactly where agents guess, and credentials belong in a file the sketch reads, not in the prompt or the repository. Your instructor still prefers **[IoTempower](https://iotempower.us)** for anything you want to keep: it is reproducible from a `node.conf`, it deploys over the air, and it does not depend on a conversation you cannot repeat.

**Theory you need.** A device is a client with a power budget and a flaky radio. Wi-Fi join time, keepalive against battery life, a broker that may be unreachable at boot, and credentials that must not be committed — your simulation quietly decided every one of those for you.

> **Show and ask.** Show the device in `mosquitto_sub` or on the dashboard, then unplug it. *"What did the mock hide from you?"*

## Ask an LLM — then verify

Treat every answer as a **claim to test**, not a fact, and run it against your own broker.

- "Compare QoS 0, 1, and 2 in terms of packet exchange, latency, and duplicate risk. When is QoS 0 acceptable in sensor telemetry?"
- "Explain retained messages and Last Will and Testament with a concrete offline-detection example. What does the broker publish, and when?"
- "Design an MQTT topic hierarchy for a warehouse with several zones, sensors, and actuators. Justify the levels and the command/state split."
- "My Python subscriber misses messages when it restarts. Which MQTT features fix this, and what are their limits?"
- "Compare MQTT over TCP with CoAP over UDP for a battery-powered sensor that reports every ten minutes. When does `observe` beat polling, and what does each cost when the link drops packets?"

Record where the model is wrong, vague, or over-confident in `## Study log`.

## 🔁 Curiosities — the harvest ritual is gone

We dropped the formal harvest. Keep collecting anyway: note the odd bits in `## Study log` and share them — in a reflection, on the class chat, or by telling someone at another pod when you take a break. A retained value that looked live, a will that fired late, a duplicate after a QoS 1 retry, a topic nobody subscribed to, a dashboard showing yesterday's number, a bridge that worked once: these are the questions worth carrying forward, and two pods hitting the same one is worth a line in the class channel.

## ✅ Suggested evidence

A suggestion, not a checklist — the learning goals are the contract, and an artefact of your own that proves them is worth more than a ticked list.

1. **HTTP baseline (goals 1 and 2):** the endpoint, the curl call, the Python sender, the reading on the dashboard, and the answer to "who had to know whom?".
2. **Topic plan (goals 1 and 4):** the hierarchy, the wildcard, the command/state split, and one line each for QoS, retain and the will.
3. **MQTT experiments (goal 1):** the retained value, the will and the measured detection time, the QoS 0/1/2 observations, and the security paragraph.
4. **The sender and the swap (goals 3 and 4):** the Python service, and the one sentence on why nothing downstream changed when the publisher changed.
5. **CoAP interface (goal 1):** the resource, the forward, the two readings, and the sentence on what UDP cost.
6. **Bridges (goals 2 and 3):** the three flow JSONs, one of them reverse, and the line per bridge on rate, direction and failure.
7. **The log and the exchanges:** `## Study log`, `## Discussion log`, and the list of what broke.
8. **Protocol choice (goal 1):** one paragraph on MQTT vs CoAP vs HTTP — transport, cost, and what you would put on a battery-powered sensor.
9. **Optional — hardware (goals 3 and 4):** the device, the topic it publishes to, and one sentence on what the simulation had quietly decided for you.

> [!IMPORTANT]
> Never commit secrets, credentials, private keys, a webhook URL, or a broker configuration with passwords. Where you did not work alone, link your pod mates and your sources.

## 📚 Resources

- [MQTT 5.0 specification](https://docs.oasis-open.org/mqtt/mqtt/v5.0/mqtt-v5.0.html) and [mqtt.org](https://mqtt.org/) — the protocol reference.
- [HiveMQ: MQTT essentials](https://www.hivemq.com/mqtt-essentials/) — the readable guide to topics, QoS, retain, and LWT.
- [Node-RED documentation](https://nodered.org/docs/) — flows, context, and dashboards.
- [`paho-mqtt` documentation](https://eclipse.dev/paho/files/paho.mqtt.python/html/index.html) — the Python client, including the 2.x callback API.
- [`requests`](https://requests.readthedocs.io/) and [`curl`](https://curl.se/docs/manpage.html) — the two HTTP clients in Task 1.
- [CoAP (RFC 7252)](https://www.rfc-editor.org/rfc/rfc7252) and [coap.technology](https://coap.technology/) — the constrained-device alternative.
- [`aiocoap`](https://aiocoap.readthedocs.io/) — the Python CoAP library in Task 3: client, server and `ObservableResource`.
- [`node-red-contrib-coap`](https://flows.nodered.org/node/node-red-contrib-coap) — the `coap request`, `coap in` and `coap response` nodes.
- [MicroPython `umqtt`](https://github.com/micropython/micropython-lib/tree/master/micropython/umqtt.simple) — the small MQTT client for the router path.
- [M5Stack documentation](https://docs.m5stack.com/) — the boards and sticks the instructor brings; their Arduino examples are the shortest path to a first publish.
- [PubSubClient](https://pubsubclient.knolleary.net/) — the usual small MQTT client for Arduino/PlatformIO boards.
- [IoTempower](https://iotempower.us) — declarative node setup and OTA deploy; Module 7 takes it apart.
- [Chatto](https://github.com/chattocorp/chatto) — the self-hosted chat the class uses; compare a room with a topic. Its [self-hosting docs](https://docs.chatto.run/) cover the HTTP API and incoming webhooks that Task 4 talks to.
- The [resource bank](./Z-resources-bank.md) — the [protocol/port table](./Z-resources-bank.md#protocol-port-table), the [`uv` environment](./Z-resources-bank.md#python-environment-with-uv-optional), and the [MQTT command cheat sheet](./Z-resources-bank.md#mqtt-command-cheat-sheet).

---
