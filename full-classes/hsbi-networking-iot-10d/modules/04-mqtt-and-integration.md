# Module 4 – Application Messaging: MQTT Deep Dive & Integration

[← Back to Module 3](./03-overlay-and-mesh-networks.md) | [Quick module index](./00-index.md) | [Next: Module 5 →](./05-wireless-technologies-and-espnow.md)

**Course placement:** Day 4 — the messaging and integration challenge. The studio starts with a pod check-in, then the warehouse.

## 🎯 Learning Goals

This module gives you the opportunity to explore decoupled messaging and system integration and achieve competency in **MQTT mechanics (topics, QoS, retain, LWT), Node-RED flows, and Python (`paho-mqtt` / IoTknit) services**. You also place MQTT against CoAP and HTTP, so the protocol choice is a decision rather than a habit.

By the end of this module, you can:
1. Deeply understand the MQTT protocol mechanisms: topic hierarchies, QoS levels, retained messages, and Last Will and Testament (LWT) — and place MQTT against CoAP and HTTP.
2. Build data pipelines, state machines, and dashboards in **your own Node-RED** on the class host or your laptop.
3. Develop event-driven programmatic integration services in **Python using `paho-mqtt` and IoTknit** on a laptop, or in **MicroPython on the router** where the service fits.
4. Experience the power of pub/sub abstraction by swapping simulated/mock devices with physical M5Stack nodes with zero downstream code changes.

**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 🎬 Opening the Challenge

**The day starts with the warehouse, not a slide.** Module 3 gave you a network that crosses NAT; today you decouple what runs on it. The opening runs in five quick beats:

1. **Pod check-in, then the challenge.** Show one artefact from Modules 1–3 — the router baseline, the cross-NAT proof, or the tool matrix — and name one question you still have. Park the questions on the board.
2. **Confirm the pod and the roles.** Rotate: one drives the broker/CLI, one drives Node-RED, one keeps the topic tree and the notes. Swap after each round.
3. **Collect the hardware.** One M5Stack node per pod, a laptop with the broker reachable at `192.168.14.1:1883` (or its Nebula IP), and **your own Node-RED** on the class host or your laptop. The Day-1 `classroom-nodered.sh` fleet is over.
4. **Draw the flow before you build it.** Sensor → broker → Node-RED and Python consumer; mark every topic, the command topic, and where the logic lives. You will correct it all day.
5. **Skim the studio, do not start.** Read the challenge and the round table, then skim the theory boxes and the evidence list. Find **where the mock becomes real** and **where the LWT fires**. Then start Round 1.

Before you touch the broker, answer these three in one sentence each — they are the questions the day will answer:

- Why does the sensor need to know who is listening?
- What does the broker add that a direct HTTP call does not?
- Where should the logic live: in the node, in Node-RED, or in a Python service?

### Your portfolio entry for today — sections, not files

Everything from today goes into **`Module04/README.md`** as sections. Split something into its own file only when a section outgrows the page.

- `## Topic plan` — the topic hierarchy, wildcards, QoS/retain/LWT decisions, and the command/state split.
- `## Study log` — the running log: the theory you actually needed, the commands that surprised you, and the LLM answers you checked. Not an essay, and not a separate study phase.
- `## Discussion log` — one line per discussion: who listened, what they asked, what you changed. This is personal.
- `## MQTT experiments` — MQTT Explorer evidence, the LWT timing, and the QoS observations.
- `## Node-RED flow` — the exported flow JSON and the dashboard/command proof.
- `## Python service` — the `paho-mqtt` script and the mock-to-physical swap.
- `## Story seeds` — optional: the odd bits worth turning into a story later.

*One pod member keeps the shared `## Study log`; the others link to it from their own `Module04/README.md` and add one sentence on what they took from it. The `## Discussion log` is yours alone.*

### The broker contract

The broker is shared infrastructure, and the class broker is deliberately open inside the pod LAN. Agree before you start:

- **Stay inside the pod LAN.** The broker is anonymous and has no TLS; it is a lab default, not a production service. Do not expose it to WAN except in the controlled Module 2 port-forward test.
- **No secrets on the broker.** Do not publish credentials, personal data, or another pod's traffic. Topic names are not a security boundary.
- **One owner for the topic tree.** Agree on the `pod<NN>/...` prefix and the command/state split before you publish; a second tree is how dashboards lie.

## 📖 The Challenge — The Warehouse Where Every Sensor Called Every Screen

**Frachtflow** is a logistics startup building a small warehouse control system. Lead developer **Nils Bergmann** started with HTTP: every temperature sensor calls every dashboard directly. With three sensors and one screen it works. With thirty sensors, four dashboards, a Python logger, and an alarm service, it becomes a mesh of point-to-point connections, duplicated parsing code, and a dashboard that keeps polling a sensor that has been offline for a day.

Operations lead **Rosa Klein** asks the question that changes the architecture: *"Why does the sensor need to know who is listening?"*

**Your challenge.** Decouple the warehouse with MQTT and prove the decoupling works. You are done when you can show:

1. A protocol map that places MQTT, CoAP, HTTP, SSH, Telnet, and the legacy mail/file protocols in OSI and TCP/IP, with the transport and security posture.
2. A topic hierarchy for the warehouse with wildcards, QoS, retained state, and LWT — and a one-sentence reason for each choice.
3. A hard-disconnect experiment that shows the broker firing the LWT when the node dies without a `DISCONNECT`.
4. A Node-RED flow that reacts to `devices/+/temp`, commands a cooler, and renders a dashboard — in **your own** Node-RED, not on the router.
5. A Python `paho-mqtt` service (or the MicroPython router path) that does the same logic, and a mock-to-physical swap with no downstream code change.
6. A one-paragraph protocol choice: MQTT vs CoAP vs HTTP for this warehouse.

**Constraints.** The broker runs on the pod router; Node-RED runs on the class host or your laptop, never on the router; no admin rights on a company laptop means the class host. No cloud dependency, no secrets on the broker, no time estimates. The router path is a small MicroPython service, not a Node-RED replacement.

**This story is unfinished on purpose.** The hooks below are starting points, not a script. Pick the ones that match what you actually saw, and add a line of your own — *"and the dashboard showed 21.4 °C for a day because the retained value never expired"* is worth more than a perfect diagram. Collect those lines under `## Story seeds` and use them in a discussion or the harvest.

## 🧭 How this studio works now

**The study is folded into the practice.** There is no separate pod-study phase and no scheduled hand-off to another pod. Each round gives you a small thing to do, a short **Theory you need** box you read only when the task makes you want it, and a **discussion** at the end. Keep your notes in `Module04/README.md` under `## Study log` — a running log, not an essay.

**First: skim, do not start.** Read the challenge and the round table, then skim the theory boxes and the evidence list. You are looking for two things: **where the mock becomes real** and **where the LWT fires**. Then start Round 1.

**Every round ends with a discussion — one person is enough.** Ask someone at the nearest pod if they have a moment; show them the round's artefact and ask the discussion question. If they want, let them show you theirs and ask you one question back. **This is a brag, not a quiz.** Write one line in `## Discussion log`: who listened, what they asked, what you changed. If nobody is free, ask someone else or come back later — do not wait.

**Take a study break when a box is not enough.** Read the linked source, then explain it to one person. Explaining is the test, not reading. You do not need permission; take the break when the task makes you want it.

The table is the discussion map: the **[Goal](#-learning-goals) · theory box** column names what each discussion checks. The question tests understanding, not task completion.

| # | Round | You produce | [Goal](#-learning-goals) · theory box | Discussion question for one person |
|---|---|---|---|---|
| 1 | **Place the protocols** | A marked protocol map and the expose/why answers | G1 · Place the protocols | "Which would you expose, and why?" |
| 2 | **Design the topic tree** | A hierarchy and the QoS/retain/LWT decisions | G1 + G4 · Design the topic tree | "Why does the sensor not need to know who is listening?" |
| 3 | **Prove QoS, retain, and LWT** | MQTT Explorer evidence and the LWT timing | G1 · QoS, retain, LWT | "What happens when the node dies without `DISCONNECT`?" |
| 4 | **Build the Node-RED flow** | The exported flow and the dashboard/command proof | G2 · Node-RED flow | "Where does the logic live, and what if Node-RED dies?" |
| 5 | **Write the Python service** | A `paho-mqtt` service and the mock-to-physical swap | G3 + G4 · Python service | "What changed downstream when the mock became real?" |
| ◇ | **MicroPython on the router** | A small service on the router | G3 · MicroPython on the router | "Why is this a service, not Node-RED?" |

**The order is a suggestion.** The rounds are a path, not a timetable. If Node-RED is not installed yet, use the class host and come back; if you finish early, take the MicroPython stretch. **The instructor demos one LWT kill and one Node-RED flow live on the beamer** — ask for the demo you need. Rotate roles after each round; everybody should publish, subscribe, and see one LWT at least once. The question you should always be able to answer is *"what did you choose, and what did it cost you?"*

## 🛠️ The Studio: Building the Integration Engine — **Challenging**

### ★ Round 1: Place the protocols

Fill the map and mark which protocols you would expose to the internet without a wrapper. Then answer the three questions below.

The OSI model is the reference dictionary; TCP/IP is what the operating system actually implements. Layers 5–7 of OSI collapse into the TCP/IP **Application** layer.

| OSI layer | TCP/IP layer | What lives there | Examples |
|---|---|---|---|
| 7 — Application | Application | Protocols that do useful work | DNS, DHCP, NTP, HTTP, SSH, Telnet, SMTP, POP3, FTP, MQTT, CoAP, OPC-UA, Modbus TCP |
| 6 — Presentation | Application | Encoding, encryption, compression | TLS, JSON, CBOR, Protobuf |
| 5 — Session | Application | Session setup, teardown, resumption | SSH session, TLS session, MQTT session |
| 4 — Transport | Transport | Process-to-process delivery | TCP, UDP, QUIC |
| 3 — Network | Internet | Addressing and routing | IPv4, IPv6, ICMP |
| 2 — Data link | Link | Frames on the local medium | Ethernet, Wi-Fi, ARP |
| 1 — Physical | Link | Bits on the wire or in the air | Twisted pair, fiber, 2.4/5 GHz radio |

All of these are TCP/IP **Application**-layer protocols; the port/transport column shows what they sit on.

| Protocol | Port / transport | OSI | Security / note |
|---|---|---|---|
| DNS | 53 UDP/TCP | 7 | Plaintext; DoT/DoH encrypt it |
| DHCP | 67/68 UDP | 7 | Plaintext; LAN only |
| NTP | 123 UDP | 7 | Plaintext; NTS exists |
| HTTP | 80 TCP | 7 | Plaintext |
| HTTPS | 443 TCP | 7 | TLS |
| SSH | 22 TCP | 7 (5/6 via encryption) | Encrypted; also your tunnel tool (Module 2) |
| Telnet | 23 TCP | 7 | Plaintext — do not use |
| SMTP | 25/587 TCP | 7 | STARTTLS/TLS; legacy mail |
| POP3 | 110 TCP | 7 | STARTTLS/TLS; legacy mail |
| FTP | 20/21 TCP | 7 | Plaintext; SFTP/FTPS are the alternatives |
| MQTT | 1883 TCP / 8883 TLS | 7 | TLS optional; broker |
| CoAP | 5683 UDP / 5684 DTLS | 7 | DTLS/OSCORE |
| OPC-UA | 4840 TCP | 7 | Security built in |
| Modbus TCP | 502 TCP | 7 | No security |
| SNMP | 161/162 UDP | 7 | v3 adds security |
| TFTP | 69 UDP | 7 | No security; trivial file transfer |

The legacy mail and file protocols are here because the module handbook names them; they are not part of the lab. The point is the layer and the security posture, not the product.

**Theory you need.** The layer tells you what the protocol can assume; the transport tells you what it costs. DNS, DHCP, and NTP use UDP because a lost answer is cheaper than a connection; MQTT and HTTP use TCP because the stream must arrive in order. CoAP is the interesting middle: HTTP-like methods over UDP, with confirmable messages and observe. Security is a separate decision: a protocol being "application layer" says nothing about whether it is encrypted. *Go deeper: the RFCs and cheat sheets in the resource bank.*

**Do.** Answer in your pod:
1. Which of these would you expose to the internet without a wrapper, and why?
2. Why do CoAP, DHCP, and NTP use UDP while MQTT and HTTP use TCP?
3. Where would SSH or Telnet help you troubleshoot, and why is Telnet still in the table?

> **Discussion — show one person.** Show your marked map and ask: *"Which would you expose, and why?"* Write one line in `## Discussion log`.

> **Story hook.** *Rosa's question.* The sensor should not need to know who is listening. The protocol map is how you decide *where* that decoupling belongs.

*Portfolio evidence:* the marked protocol map and your three answers.

### ★ Round 2: Design the topic tree

Design the warehouse hierarchy before you publish anything. Write the `pod<NN>/...` prefix, the zones, the sensor and actuator branches, the command/state split, and the wildcard you will use on the dashboard. Then decide QoS, retain, and LWT for each branch.

**Theory you need.** HTTP is request/response: the client must know the server, both must be online, and ten consumers mean ten requests. MQTT decouples in three dimensions:

- **Space:** publishers and subscribers do not know each other; they know the broker.
- **Time:** retained messages and persistent sessions let a late subscriber catch up.
- **Synchronization:** publish is non-blocking and asynchronous.

```text
[Publisher: M5Stack temp node]
       |
       |  PUBLISH "home/livingroom/temp" (21.4 °C) [QoS 1, retain]
       v
[Mosquitto broker on OpenWrt]
       |
       +----------------------------+
       |                            |
       v                            v
[Subscriber: Node-RED]     [Subscriber: Python logger / IoTknit]
```

**Topics and wildcards.** `/` separates levels; `+` matches one level (`factory/+/press/temp`); `#` matches the rest (`factory/hall1/#`).

**QoS.** 0 = at most once (fire and forget); 1 = at least once (`PUBACK`, duplicates possible); 2 = exactly once (four-way handshake, highest overhead). Sensor telemetry rarely needs 2.

**Retain.** The broker stores the last retained message per topic; a new subscriber gets it immediately. That is how a dashboard catches up, and how a stale value can lie if the publisher stops.

**LWT.** On connect, the client gives the broker a will (topic, payload, retain). If the connection dies without a `DISCONNECT`, the broker publishes the will. That is how the warehouse knows a node is offline.

**CoAP** is the other IoT standard: HTTP-like methods over UDP, with observe and block-wise transfer, common in constrained/6LoWPAN/Thread networks.

| | MQTT | CoAP | HTTP |
|---|---|---|---|
| Model | Publish/subscribe via a broker | Request/response (with observe) over UDP | Request/response over TCP |
| Transport | TCP (or WebSocket) | UDP (or DTLS) | TCP (or TLS) |
| Coupling | Decoupled by broker and topic | Client addresses a resource URI | Client addresses a resource URI |
| Typical fit | Telemetry, many subscribers, dashboards | Constrained devices, local resource access | APIs, browsers, humans |
| Reliability | QoS 0/1/2 | Confirmable messages, retries | TCP |
| Security | TLS | DTLS/OSCORE | TLS |

*Go deeper: MQTT 5.0, HiveMQ MQTT essentials, RFC 7252, and the resource bank's MQTT cheat sheet.*

> **Discussion — show one person.** Show your topic tree and ask: *"Why does the sensor not need to know who is listening?"* Write one line in `## Discussion log`.

> **Story hook.** *The topic tree is the warehouse floor plan.* If every pod invents its own names, the dashboard cannot aggregate; the broker does not fix a bad naming decision.

*Portfolio evidence:* the `## Topic plan` with the hierarchy, wildcards, and one line each for QoS, retain, and LWT.

### ★ Round 3: Prove QoS, retain, and LWT with MQTT Explorer

1. Open MQTT Explorer or `mosquitto_sub` on your laptop, connecting to your OpenWrt broker (`192.168.14.1:1883` or via your Nebula IP).
2. Connect an M5Stack node configured with an LWT topic:
   ```text
   Status Topic: devices/m5node-01/status
   Connect payload: "online" (retained)
   LWT payload: "offline" (retained)
   ```
3. Watch the topic tree in MQTT Explorer.
4. The Hard Disconnect Test: unplug the M5Stack node from power (do not send a graceful disconnect).
5. Watch how long it takes before the broker detects the missing TCP keep-alive (`PINGREQ`) and automatically fires the LWT `offline` payload.

**Theory you need.** The broker notices a dead client only when the TCP connection or the keep-alive fails; the LWT is published then, not at the moment of power loss. With a retained will, a dashboard that connects later still sees `offline`. QoS 1 can duplicate a message if the `PUBACK` is lost; QoS 2 removes that risk at the cost of a four-way handshake. *Go deeper: MQTT 5.0 and HiveMQ's LWT chapter.*

> **Discussion — show one person.** Show the retained `offline` and ask: *"What happens when the node dies without `DISCONNECT`?"* Write one line in `## Discussion log`.

> **Story hook.** *The node that went silent.* Nils's dashboard kept polling a sensor that had been offline for a day. The LWT is the broker's answer: the last state can tell you it is stale.

*Portfolio evidence:* a screenshot of `online` → `offline`, the time it took, and one sentence on why retain matters here.

### ★ Round 4: Build the Node-RED flow

1. Open **your own** Node-RED — installed by you on the class host (Optiplex cluster) or your laptop, **not the router**. The Day-1 `classroom-nodered.sh` fleet is over; this is your instance. The address is on the board; a local install is `http://localhost:1880`.

   > **No admin rights?** Use the class host. Do not install Node-RED on a company laptop, and never install it on the router.

2. Build an intelligent thermostat/alarm flow:
   - Input: MQTT subscriber on `devices/+/temp`.
   - Function Node: Parse the JSON payload `{"temp": float, "battery": int}`. If `temp > 28.0`, trigger an alarm state.
   - Output 1: Publish an actuator command to `devices/cooler/set` with payload `{"power": "ON"}`.
   - Output 2: Node-RED Dashboard Gauge and Alert notification banner.
3. Test the flow by publishing simulated values via terminal:
   ```bash
   mosquitto_pub -h 192.168.14.1 -t "devices/sensor1/temp" -m '{"temp": 29.5, "battery": 92}'
   ```
4. Verify the dashboard triggers and the control topic receives the command.

**Theory you need.** A Node-RED flow is a set of nodes connected by messages: an `mqtt in` node subscribes, a `function` node transforms, an `mqtt out` node publishes, and dashboard nodes render. The logic lives in the flow, not in the sensor; that is the decoupling. If Node-RED dies, the sensor keeps publishing and the broker keeps the retained state — but the dashboard and the command stop. That failure mode is the point of the next round. *Go deeper: the Node-RED docs.*

> **Discussion — show one person.** Show the flow and the dashboard and ask: *"Where does the logic live, and what if Node-RED dies?"* Write one line in `## Discussion log`.

> **Story hook.** *The dashboard that kept polling a dead sensor.* The flow can show a gauge, but it cannot invent the truth; the retained LWT is what tells the operator the reading is stale.

*Portfolio evidence:* the exported flow JSON and a screenshot of the gauge plus the command on `devices/cooler/set`.

### ★ Round 5: Write the Python service

Instead of putting all logic in Node-RED, modern production systems often use lightweight Python background services or IoTknit to bridge systems, write to databases, or handle custom business logic. The **laptop path** uses the pinned `uv` environment with `uv add paho-mqtt` (see the [resource bank](./Z-resources-bank.md#python-environment-with-uv-optional)); run scripts with `uv run python <script>.py`.

1. Create a Python script `iot_bridge.py`:

   ```python
   import json
   import paho.mqtt.client as mqtt

   BROKER = "192.168.14.1"  # Or your Nebula IP
   PORT = 1883

   def on_connect(client, userdata, flags, rc):
       print(f"Connected to broker with result code {rc}")
       # Subscribe to all sensor telemetry
       client.subscribe("devices/+/env")

   def on_message(client, userdata, msg):
       try:
           payload = json.loads(msg.payload.decode())
           topic_parts = msg.topic.split('/')
           device_id = topic_parts[1]

           temp = payload.get("temp")
           humidity = payload.get("humidity")
           print(f"[{device_id}] Temp: {temp}°C, Humidity: {humidity}%")

           # Compute Heat Index or business logic
           if temp is not None and temp > 27.0:
               alert_payload = json.dumps({"device": device_id, "alert": "HIGH_TEMP", "val": temp})
               client.publish("alerts/temperature", alert_payload, qos=1)
               print(f"--> Triggered alert for {device_id}")
       except Exception as e:
           print(f"Error parsing message: {e}")

   client = mqtt.Client()
   client.on_connect = on_connect
   client.on_message = on_message

   client.connect(BROKER, PORT, 60)
   client.loop_forever()
   ```

2. Run the script and observe it process messages in real time.
3. Zero-Friction Hardware Swap:
   - Create a second script `mock_sensor.py` that publishes simulated sensor values every 2 seconds.
   - Run it. Observe Node-RED and your Python bridge processing the mock data.
   - Turn on your physical M5Stack node publishing to the same topic structure.
   - Notice how neither Node-RED nor the Python bridge care whether the message originated from a mock script or a real M5Stack device.

**Theory you need.** `on_connect` runs when the broker accepts the client; `on_message` runs for every subscribed message; `loop_forever()` keeps the network loop alive. The callbacks are the service's contract. Mock and physical nodes are interchangeable because both publish the same topic/payload shape — that is the abstraction, not the hardware. *Go deeper: the `paho-mqtt` docs and the IoTknit repository.*

> **Discussion — show one person.** Show the service processing mock and real data and ask: *"What changed downstream when the mock became real?"* Write one line in `## Discussion log`.

> **Story hook.** *The mock that became real.* Nils can test the alarm before the hardware exists, and swap in the real node without touching the dashboard. Rosa cares because the warehouse can be commissioned before every sensor arrives.

*Portfolio evidence:* the script, the terminal output for mock and real data, and one sentence on why no downstream code changed.

### ◇ Stretch: MicroPython on the router

The router is a good place for a small integration service: it already runs the broker and sits on the pod LAN. Use MicroPython with `umqtt.simple`/`umqtt.robust`; a MicroPython port of IoTknit is planned but not yet a supported path. The service can subscribe to `devices/+/env`, apply a threshold, and publish `alerts/temperature` without a laptop. Keep it small: the Cudy has 128 MB RAM and 16 MB flash (extroot), so this is a service, not a Node-RED replacement.

**Theory you need.** MicroPython has no Node-RED runtime and very little RAM; `umqtt` is a small MQTT client with the same pub/sub model. The router is already the broker and the gateway, so a threshold service there removes a laptop from the loop — but it also makes the router a single point of failure. Say which trade you chose. *Go deeper: the MicroPython `umqtt` docs.*

> **Discussion — show one person.** Show the service on the router and ask: *"Why is this a service, not Node-RED?"* Write one line in `## Discussion log`.

*Portfolio evidence:* the MicroPython service, the topic it subscribes to, and the alert it publishes.

## 🤖 Ask an LLM — then verify

Use these when a theory box is not enough. Treat every answer as a **claim to test**, not a fact, and run it against your own broker.

- "Compare QoS 0, 1, and 2 in terms of packet exchange, latency, and duplicate risk. When is QoS 0 acceptable in sensor telemetry?"
- "Explain retained messages and Last Will and Testament with a concrete offline-detection example. What does the broker publish, and when?"
- "Design an MQTT topic hierarchy for a warehouse with several zones, sensors, and actuators. Justify the levels and the command/state split."
- "Why is a pub/sub broker more maintainable than direct HTTP connections between sensors and dashboards? Give the failure modes of each."
- "My Python subscriber misses messages when it restarts. Which MQTT features fix this, and what are their limits?"
- "Compare MQTT and CoAP for a battery-powered sensor behind a lossy link. Which would you choose, and what changes if the dashboard needs the last value on connect?"

Record where the model is wrong, vague, or over-confident in `## Study log`.

## 🔁 Optional: the harvest — collect curiosities, swap lists

> **Optional and ungraded.** The full ritual is in [Module 1](./01-foundations-and-masterclass.md#harvest); run the short version here.

As you work, mark the odd bits: a retained value that looked live, an LWT that fired late, a duplicate after a QoS 1 retry, a topic that nobody subscribed to, a dashboard that showed yesterday's number. Put a `?` in the margin or a line under `## Story seeds`. At the break and at the end, swap lists with one person at another pod: briefly, no explaining, every entry gets a source. Anything two pods collected, or that nobody can place, goes to the course channel. The list is the artefact; the conversation is the point.

## ✅ Suggested portfolio evidence (proofs of the learning goals)

This is a **suggestion, not a checklist** — the learning goals are the contract. A convincing subset, or a better artefact you design yourself, is worth more than a ticked list.

1. **Protocol map (goal 1):** the marked OSI/TCP-IP map, the port/transport table, and your expose/why answers.
2. **Topic plan (goals 1 and 4):** the hierarchy, wildcards, QoS/retain/LWT decisions, and the command/state split.
3. **QoS and LWT evidence (goal 1):** the `online` → `offline` retained screenshot, the detection time, and one paragraph on what happens without a `DISCONNECT`.
4. **Node-RED flow (goal 2):** the exported flow JSON and a screenshot of the gauge plus `devices/cooler/set`.
5. **Python service (goal 3):** the `paho-mqtt` script and the mock-to-physical swap output.
6. **The running log and discussions:** your `## Study log` with the theory you actually needed, plus `## Discussion log` — one line per discussion.
7. **Protocol choice (goal 1):** one paragraph comparing MQTT, CoAP, and HTTP for the warehouse.
8. **Optional MicroPython (goal 3):** the router service and the trade-off you chose.

> [!IMPORTANT]
> Never commit secrets, credentials, private keys, or broker configuration containing passwords. Where you did not work entirely alone, link your pod mates and sources.

## 📚 If you want to go deeper

- [MQTT 5.0 specification](https://docs.oasis-open.org/mqtt/mqtt/v5.0/mqtt-v5.0.html) and [mqtt.org](https://mqtt.org/) — the protocol reference.
- [HiveMQ: MQTT essentials](https://www.hivemq.com/mqtt-essentials/) — the readable guide to topics, QoS, retain, and LWT.
- [Node-RED documentation](https://nodered.org/docs/) — flows, context, and dashboards.
- [`paho-mqtt` documentation](https://eclipse.dev/paho/files/paho.mqtt.python/html/index.html) — the Python client.
- [CoAP (RFC 7252)](https://www.rfc-editor.org/rfc/rfc7252) and [coap.technology](https://coap.technology/) — the constrained-device alternative.
- [IoTknit](https://github.com/iotempire/iotknit) — the IoTempire integration helper used in the lab.
- [MicroPython `umqtt`](https://github.com/micropython/micropython-lib/tree/master/micropython/umqtt.simple) — the small MQTT client for the router path.
- The [resource bank's MQTT cheat sheet](./Z-resources-bank.md#mqtt-command-cheat-sheet).

---

[← Previous: Module 3](./03-overlay-and-mesh-networks.md) | [Back to front page](../README.md) | [Quick module index](./00-index.md) | [Next: Module 5 — Wireless Technologies & ESP-NOW →](./05-wireless-technologies-and-espnow.md)
