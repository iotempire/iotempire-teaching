# Module 4 – Application Messaging: MQTT Deep Dive & Integration

[← Back to Module 3](./03-overlay-and-mesh-networks.md) | [Quick module index](./00-index.md) | [Next: Module 5 →](./05-wireless-technologies-and-espnow.md)

**Course placement:** Day 4 — the messaging and integration studio, after Checkpoint 1 (Modules 1–3).

## 🎯 Learning Goals

This module gives you the opportunity to explore decoupled messaging and system integration and achieve competency in **MQTT mechanics (topics, QoS, retain, LWT), Node-RED flows, and Python (`paho-mqtt` / IoTknit) services**. You also place MQTT against CoAP and HTTP, so the protocol choice is a decision rather than a habit.

By the end of this module, you can:
1. Deeply understand the MQTT protocol mechanisms: topic hierarchies, QoS levels, retained messages, and Last Will and Testament (LWT) — and place MQTT against CoAP and HTTP.
2. Build data pipelines, state machines, and dashboards in Node-RED on the class integration host or your own laptop.
3. Develop event-driven programmatic integration services in **Python using `paho-mqtt` and IoTknit** on a laptop, or in **MicroPython on the router** where the service fits.
4. Experience the power of pub/sub abstraction by swapping simulated/mock devices with physical M5Stack nodes with zero downstream code changes.


**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 📖 Story — The Warehouse Where Every Sensor Called Every Screen

**Frachtflow** is a logistics startup building a small warehouse control system. Lead developer **Nils Bergmann** started with HTTP: every temperature sensor calls every dashboard directly. With three sensors and one screen it works. With thirty sensors, four dashboards, a Python logger, and an alarm service, it becomes a mesh of point-to-point connections, duplicated parsing code, and a dashboard that keeps polling a sensor that has been offline for a day.

Operations lead **Rosa Klein** asks the question that changes the architecture: *"Why does the sensor need to know who is listening?"* Today you decouple producers from consumers with MQTT — topic hierarchies, QoS, retained state, Last Will and Testament — and build the integration layer in Node-RED and Python.

## 📖 Pod Study: The Architecture of Decoupled Messaging

This is **self/pod study, not a lecture.** Work through the concepts below with your Task Pod, look things up, ask an LLM, and keep notes — the goal is a shared mental model you can defend in the checkpoint.

### Why MQTT Over Request/Response (HTTP)?
Traditional web architectures rely on client-server request/response over HTTP:
- The client must know the server's IP address and port.
- Both client and server must be online simultaneously.
- If 10 components need the temperature, the sensor must send 10 separate HTTP requests.

MQTT (Message Queuing Telemetry Transport) decouples producers and consumers:
1. Space Decoupling: Publishers and subscribers do not know each other’s IP addresses; they only know the broker.
2. Time Decoupling: With retained messages and persistent sessions, subscribers can receive the latest state even if they were offline when it was published.
3. Synchronization Decoupling: Operations are non-blocking and asynchronous.

```text
[Publisher: M5Stack Temp Node]
       |
       |  PUBLISH "home/livingroom/temp" (21.4°C) [QoS 1, Retain]
       v
[Mosquitto MQTT Broker on OpenWrt]
       |
       +----------------------------+
       |                            |
       v                            v
[Subscriber: Node-RED]     [Subscriber: Python Logger / IoTknit]
```

### Essential MQTT Mechanics:
- Topic Hierarchies: `/` separated strings (e.g. `factory/hall1/press/temp`).
  - `+` Single-level wildcard (e.g. `factory/+/press/temp`).
  - `#` Multi-level wildcard (e.g. `factory/hall1/#`).
- Quality of Service (QoS):
  - QoS 0 (At most once): "Fire and forget". Fastest, lowest energy, no guarantee.
  - QoS 1 (At least once): Broker acknowledges with `PUBACK`. Guarantees delivery, but duplicate packets can occur if an ACK is lost.
  - QoS 2 (Exactly once): 4-way handshake (`PUBLISH` $\rightarrow$ `PUBREC` $\rightarrow$ `PUBREL` $\rightarrow$ `PUBCOMP`). Highest overhead; rarely needed in typical sensor telemetry.
- Retained Messages: The broker stores the last message published with `retain=true`. When a new dashboard or node subscribes, it immediately receives the current state instead of waiting minutes for the next publish.
- Last Will and Testament (LWT): When a client connects, it gives the broker a "will" message (e.g. topic `devices/m5stick1/status`, payload `offline`, retain `true`). If the device suddenly loses power or drops Wi-Fi, the broker automatically publishes this message.

### The Other IoT Standard: CoAP

MQTT is not the only answer. **CoAP** (Constrained Application Protocol, [RFC 7252](https://www.rfc-editor.org/rfc/rfc7252)) is a UDP-based request/response protocol for constrained devices. It keeps HTTP-like methods (`GET`, `POST`, `PUT`, `DELETE`) but runs over UDP, supports **observe** (server-push) and block-wise transfer, and is common in constrained devices and 6LoWPAN/Thread networks.

| | MQTT | CoAP | HTTP |
|---|---|---|---|
| Model | Publish/subscribe via a broker | Request/response (with observe) over UDP | Request/response over TCP |
| Transport | TCP (or WebSocket) | UDP (or DTLS) | TCP (or TLS) |
| Coupling | Decoupled by broker and topic | Client addresses a resource URI | Client addresses a resource URI |
| Typical fit | Telemetry, many subscribers, dashboards | Constrained devices, local resource access | APIs, browsers, humans |
| Reliability | QoS 0/1/2 | Confirmable messages, retries | TCP |
| Security | TLS | DTLS/OSCORE | TLS |

**Why this matters for the course.** Your M5Stack node could speak CoAP directly to a local resource, but the class system uses MQTT because the broker decouples the dashboard, the Python service, and the node. The comparison is the skill: choose the protocol for the topology, not the fashion.

### Pointers (start here, then keep looking)

- MQTT — [mqtt.org](https://mqtt.org/), [MQTT 5.0 specification](https://docs.oasis-open.org/mqtt/mqtt/v5.0/mqtt-v5.0.html)
- CoAP — [RFC 7252](https://www.rfc-editor.org/rfc/rfc7252), [coap.technology](https://coap.technology/)
- A practical guide — [HiveMQ: MQTT essentials](https://www.hivemq.com/mqtt-essentials/)
- Node-RED — [Node-RED documentation](https://nodered.org/docs/)
- Python — [`paho-mqtt` documentation](https://eclipse.dev/paho/files/paho.mqtt.python/html/index.html)
- The [resource bank's MQTT cheat sheet](./Z-resources-bank.md#mqtt-command-cheat-sheet)

### Questions to ask an LLM (then verify against your broker)

Ask your co-pilot — but treat every answer as a **claim to test**, not a fact. Good starting prompts:

- "Compare QoS 0, 1, and 2 in terms of packet exchange, latency, and duplicate risk. When is QoS 0 acceptable in sensor telemetry?"
- "Explain retained messages and Last Will and Testament with a concrete offline-detection example. What does the broker publish, and when?"
- "Design an MQTT topic hierarchy for a warehouse with several zones, sensors, and actuators. Justify the levels and the command/state split."
- "Why is a pub/sub broker more maintainable than direct HTTP connections between sensors and dashboards? Give the failure modes of each."
- "My Python subscriber misses messages when it restarts. Which MQTT features fix this, and what are their limits?"
- "Compare MQTT and CoAP for a battery-powered sensor behind a lossy link. Which would you choose, and what changes if the dashboard needs the last value on connect?"

> Run each prompt against your own broker and clients, and record where the model is wrong, vague, or over-confident.

### ★ Task A: Study in your pod

Work through the concepts above with your Task Pod and write it up under `## Study log` in `Module04/README.md` — a section, not a file, unless it outgrows the page. **One pod member keeps the shared log; the others link to that section from their own module README and add one sentence on what they took from it.**

1. **The references you used** — the source and the one concept you understood best from it.
2. **Things you googled** — the term, what you found, and the source (URL). One line each.
3. **Remarkable things** — surprises, "aha"s, and counterexamples from your own broker.
4. **LLM Q&A** — for each prompt: the prompt, a 2–3 line summary, and **how you verified it** (and where it was wrong).
5. **Your two best found MQTT diagrams or topic hierarchies** — compile down to the best two, with source and what they taught you.

*Portfolio evidence:* the `## Study log` section (yours, or a link to your pod's shared one).

### ★ Task B: Explain & share with another pod

Pair with a **neighbouring pod**:

1. **Explain to each other** — each pod walks the other through its topic hierarchy and its LWT/QoS evidence; ask questions and fill each other's gaps.
2. Agree on the **3–5 most noteworthy points** and the **learning you jointly stand behind** (e.g. *"retained state is how a late subscriber catches up"*).
3. **Clean up your documentation** — update the `## Study log` with what you learned from the other pod.
4. Agree on **one shared artefact** — the best topic tree, a Node-RED flow, or a new architecture sketch the two pods make together — and **post it in the course Discord**, with a one-sentence note on why you chose it.
5. Each member adds a short **“Agreed learning (pod discussion)”** note — in the shared log, or in your own module README with a link to it.

*Portfolio evidence:* the cleaned-up `## Study log` (with the **“Agreed learning (pod discussion)”** note) and your pod-pair's shared artefact.

## 🛠️ In-Class Lab: Building the Integration Engine — **Challenging**

### ★ Task 1: Exploring QoS, Retain & LWT with MQTT Explorer
1. Open MQTT Explorer or `mosquitto_sub` on your laptop, connecting to your OpenWrt broker (`192.168.14.1:1883` or via your Nebula IP).
2. Connect an M5Stack node configured with an LWT topic:
   ```text
   Status Topic: devices/m5node-01/status
   Connect payload: "online" (retained)
   LWT payload: "offline" (retained)
   ```
3. Watch the topic tree in MQTT Explorer.
4. The Hard Disconnect Test: Unplug the M5Stack node from power (do not send a graceful disconnect).
5. Watch how many seconds pass before the broker detects the missing TCP keep-alive (PINGREQ) and automatically fires the LWT `offline` payload!

### ★ Task 2: Visual Integration with Node-RED
1. Open your Node-RED — the class integration host (Optiplex cluster) or your own laptop, **not the router**. The address is on the board; a local install is `http://localhost:1880`.

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

### ★ Task 3: Programmatic Integration with Python & `paho-mqtt` / IoTknit
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
   - Notice how neither Node-RED nor the Python bridge care whether the message originated from a mock script or a real M5Stack device!

**Router path — MicroPython.** The router is a good place for a small integration service: it already runs the broker and sits on the pod LAN. Use MicroPython with `umqtt.simple`/`umqtt.robust`; a MicroPython port of IoTknit is planned but not yet a supported path. The service can subscribe to `devices/+/env`, apply a threshold, and publish `alerts/temperature` without a laptop. Keep it small: the Cudy has 128 MB RAM and 16 MB flash (extroot), so this is a service, not a Node-RED replacement.

## ✅ Suggested portfolio evidence (proofs of the learning goals)

1. MQTT Architecture Diagram: Diagram your pub/sub flow showing the M5Stack node, OpenWrt broker, Node-RED flow (class host/laptop), and Python or MicroPython bridge.
2. QoS and LWT Protocol Analysis: In your own words, describe what happens at the network packet level when an MQTT client with LWT drops off the network without sending a `DISCONNECT` packet.
3. Integration Code & Flow: Commit your Python script and export your Node-RED flow JSON into your portfolio repository. If you took the router path, include the MicroPython service instead.
4. Deeper question: Why is decoupling publishers from subscribers essential for scaling an IoT deployment across multiple teams and microservices?
5. Protocol choice: one paragraph comparing MQTT, CoAP, and HTTP for your system — and why the broker wins here.


> [!IMPORTANT]
> Never commit secrets, credentials, private keys, or broker configuration containing passwords. Where you did not work entirely alone, link your pod mates and sources.

## 📚 If you want to go deeper

- [MQTT 5.0 specification](https://docs.oasis-open.org/mqtt/mqtt/v5.0/mqtt-v5.0.html) — the definitive protocol reference.
- [HiveMQ: MQTT essentials](https://www.hivemq.com/mqtt-essentials/) — the readable guide to topics, QoS, retain, and LWT.
- [Node-RED documentation](https://nodered.org/docs/) — flows, context, and dashboards.
- [`paho-mqtt` documentation](https://eclipse.dev/paho/files/paho.mqtt.python/html/index.html) — the Python client.
- [CoAP (RFC 7252)](https://www.rfc-editor.org/rfc/rfc7252) — the constrained-device alternative to MQTT.
- [IoTknit](https://github.com/iotempire/iotknit) — the IoTempire integration helper used in the lab.
- [MicroPython `umqtt`](https://github.com/micropython/micropython-lib/tree/master/micropython/umqtt.simple) — the small MQTT client for the router path.

---

[← Previous: Module 3](./03-overlay-and-mesh-networks.md) | [Back to front page](../README.md) | [Quick module index](./00-index.md) | [Next: Module 5 — Wireless Technologies & ESP-NOW →](./05-wireless-technologies-and-espnow.md)
