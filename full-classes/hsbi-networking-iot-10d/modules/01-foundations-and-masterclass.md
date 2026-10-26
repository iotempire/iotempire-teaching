# Module 1 – Foundations & The Master Class: The IoT Computing Continuum

[← Back to front page](../README.md) | [Quick module index](./00-index.md) | [Next: Module 2 →](./02-local-networking-and-gateways.md)

**Course placement:** Day 1 — the opening studio. We set the mental model, then run the Master Class end-to-end integration in the same session.

## 🎯 Learning Goals

This module gives you the opportunity to explore IoT systems and networking foundations and achieve competency in the computing continuum, the OSI-vs-TCP/IP debate, and a first end-to-end sensor-to-dashboard integration.

By the end of this module, you can:
1. Explain the course philosophy, workflow, and portfolio-based evidence of learning.
2. Critically analyze the ISO/OSI 7-layer model vs. real-world TCP/IP in IoT systems (referencing RFC 3439 and RFC 1958).
3. Complete the Master Class hands-on integration: connect an M5Stack edge node to a local MQTT broker and visualize live data on a Node-RED dashboard.
4. Craft an IoT system story with clear stakeholder needs and interfaces across the computing continuum.


**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 📖 Story — The Dashboard That Needed a Cloud

**Stadtwerke Gütersloh** operates district-heating substations across the city. Network operations lead **Petra Sommer** wants a simple dashboard: the temperature and pressure of each substation, updated every few seconds, visible in the control room and on a technician's phone. A vendor, **Cirrus Cloud Systems**, proposes the usual stack — a cloud broker, a managed database, a monthly fee, and a firmware update for every controller.

Petra asks the question the vendor cannot answer cheaply: *"The data is produced in the basement of a building we own, and the person who reads it is standing in the same building. Why does it need a round trip through the internet?"* The answer is the local-first IoT continuum: a node, a local broker, a dashboard, and an overlay only when someone is actually remote. Today you build that loop end to end — and measure what the “layers” cost in bytes.

## 📖 Pod Study: The IoT Computing Continuum

This is **self/pod study, not a lecture.** Work through the concepts below with your Task Pod, look things up, ask an LLM, and keep notes — the goal is a shared mental model you can defend in the checkpoint.

### Warm-up (in your pod)

Before reading on, answer these in one sentence each:

- Name three devices in this room that are on a network. What does each one need before it can talk to another?
- Why might a sensor's data take a round trip through the internet when the person reading it is in the same building?
- What is the difference between a **layer** and a **protocol**?

### ★ Task 0: Form your Task Pod — who do you build with?

You will do the labs and checkpoints in a **Task Pod** of two or three (three by default for a large cohort; pairs are welcome). For the final project, two pods merge into a **Project Team** of 4–6.

1. On a note, write down **your skills** (networking, Linux, Python, hardware, documentation, design, …) and **your expectations / what you want to build**.
2. No pod yet? Find **one or two other unpaired people** (three-person pods are the default in a large cohort; pairs are welcome). Compare notes, and check whether you **complement** each other — not merely whether you are alike.
3. Exchange contacts and a first idea today. If you already have a pod, share your notes so the room knows who can help with what.
4. Agree on how you will keep in touch and how you will split roles (who drives the router, who captures packets, who documents).

*Portfolio evidence:* your pod's names, skills, and one line on what you want to build.

### 1. The ISO/OSI Reference Model vs. The TCP/IP Reality
Traditional curricula introduce networking via the 7-layer ISO/OSI stack:
1. Physical (Bitübertragung)
2. Data Link (Sicherung)
3. Network (Vermittlung)
4. Transport
5. Session (Sitzung)
6. Presentation (Darstellung)
7. Application (Anwendung)

In modern IoT, rigid adherence to these 7 layers creates immense friction:
- Header Overhead ("Tax"): If an edge sensor only publishes a 4-byte floating-point temperature, wrapping it in JSON (Presentation), MQTT (Application/Session), TLS (Presentation), TCP (Transport), IPv6 (Network), and Wi-Fi 802.11 (Data Link) inflates the packet by hundreds of bytes. On battery-powered nodes, radio transmission accounts for >90% of energy consumption!
- Cross-Layer Optimization: IoT protocols frequently bypass traditional layers. For instance, ESP-NOW injects vendor-specific action frames directly into IEEE 802.11 Layer 2 without IP or TCP; CoAP integrates reliability directly over UDP; and B.A.T.M.A.N. advanced handles multi-hop routing at Layer 2.
- The End-to-End Principle (RFC 1958 & RFC 3439 "Layering Considered Harmful"): Reliability and intelligence belong at the communication endpoints, not inside intermediate network nodes.

```text
  [Traditional OSI 7-Layer]             [Practical IoT Continuum]
  Layer 7: Application           -->     MQTT / CoAP / HTTP / OPC-UA
  Layer 6: Presentation          -->     JSON / CBOR / Protobuf / TLS
  Layer 5: Session               -->     MQTT Session / TLS Session
  Layer 4: Transport             -->     TCP / UDP
  Layer 3: Network               -->     IPv4 / IPv6 / Nebula / Yggdrasil
  Layer 2: Data Link             -->     Wi-Fi (802.11) / ESP-NOW / B.A.T.M.A.N. / Ethernet
  Layer 1: Physical              -->     2.4 GHz / Sub-GHz Radio / Twisted Pair
```

### Pointers (start here, then keep looking)

- The end-to-end principle — [RFC 1958](https://www.rfc-editor.org/rfc/rfc1958), [RFC 3439 §3 “Layering Considered Harmful”](https://www.rfc-editor.org/rfc/rfc3439#section-3)
- The practical packet journey — [Practical Networking: How Data Moves Through the Internet](https://www.practicalnetworking.net/index/networking-fundamentals-how-data-moves-through-the-internet/)
- The OSI model as a reference — [Wikipedia: OSI model](https://en.wikipedia.org/wiki/OSI_model)
- Wireshark — [Wireshark User's Guide](https://www.wireshark.org/docs/wsug_html_chunked/)
- MQTT — [mqtt.org](https://mqtt.org/) and [HiveMQ: MQTT essentials](https://www.hivemq.com/mqtt-essentials/)
- The [resource bank's RFC list](./Z-resources-bank.md#rfcs--standards-every-student-should-glance-once)

### Questions to ask an LLM (then verify against your capture)

Ask your co-pilot — but treat every answer as a **claim to test**, not a fact. Good starting prompts:

- "Explain why practical network engineers work with the TCP/IP four-layer model rather than the seven-layer OSI model. Give one concrete IoT example where rigid layering hurts."
- "A sensor publishes 20 bytes of payload over MQTT/TCP/IPv4/Wi-Fi. Walk me through the headers and estimate the overhead ratio. Where does the number change if I use ESP-NOW?"
- "What does RFC 3439 mean by 'layering considered harmful'? Summarize the argument in three sentences and give a counterargument."
- "My M5Stack node connects to a local broker but the dashboard is remote. Draw the path and name every device and protocol hop."
- "Why is a local MQTT broker more resilient than a cloud-only broker for a building control system? Give the failure modes of each."

> Run each prompt against your own capture, and record where the model is wrong, vague, or over-confident.

### ★ Task A: Study in your pod

Work through the concepts above with your Task Pod and fill in `Module01/study-log.md`:

1. **The references you used** — the source and the one concept you understood best from it.
2. **Things you googled** — the term, what you found, and the source (URL). One line each.
3. **Remarkable things** — surprises, "aha"s, and counterexamples from your capture.
4. **LLM Q&A** — for each prompt: the prompt, a 2–3 line summary, and **how you verified it** (and where it was wrong).
5. **Your two best found packet/architecture diagrams** — compile down to the best two, with source and what they taught you.

*Portfolio evidence:* `Module01/study-log.md`.

### ★ Task B: Explain & share with another pod

Pair with a **neighbouring pod**:

1. **Explain to each other** — each pod walks the other through its packet breakdown and its continuum sketch; ask questions and fill each other's gaps.
2. Agree on the **3–5 most noteworthy points** and the **learning you jointly stand behind** (e.g. *"the header tax is real, but the local-first loop is what makes the system survive"*).
3. **Clean up your documentation** — update your `study-log.md` with what you learned from the other pod.
4. Agree on **one shared artefact** — the best packet diagram, overhead table, or a new continuum sketch the two pods make together — and **post it in the course Discord**, with a one-sentence note on why you chose it.
5. Each member adds a short **“Agreed learning (pod discussion)”** section to *their own* `study-log.md`.

*Portfolio evidence:* your cleaned-up `study-log.md` (with the **“Agreed learning (pod discussion)”** section) and your pod-pair's shared artefact.

## 🛠️ In-Class Lab & Master Class — **Challenging**

### Hardware Issued Today:
- 1× OpenWrt Travel Router (e.g. GL.iNet) per 2 students (pre-configured with Mosquitto broker and Node-RED on `192.168.8.1`).
- 1× M5Stack Node (e.g. M5StickC Plus or M5Atom Matrix) per student with Grove environmental sensor or onboard IMU.
- USB-C cable.

### ★ Task 1: The Master Class Integration Sprint
The goal of Day 1 is to experience the complete end-to-end loop immediately without low-level breadboard debugging.

1. Power Up the Gateway:
   - Plug the OpenWrt router into USB power.
   - Connect your laptop to the router's Wi-Fi network (e.g. `IoTempire-Lab` or `GL-iNet-xxxx`) or via Ethernet.
   - Open your browser and navigate to the OpenWrt dashboard: `http://192.168.8.1`.
2. Access Node-RED:
   - Navigate to `http://192.168.8.1:1880`.
   - Import the starter flow: [`01-hello-mqtt.json`](./flows/01-hello-mqtt.json).
   - Notice the MQTT input node subscribed to `iot/+/env`.
3. Power On the M5Stack Node:
   - Turn on your M5StickC/M5Atom node (pre-flashed with starter firmware).
   - Verify on the device display (or serial console at 115200 baud) that it connects to Wi-Fi and begins publishing to `iot/<node_id>/env`.
4. Live Visualization:
   - Watch the debug tab and dashboard (`http://192.168.8.1:1880/ui`) update with live sensor telemetry!
   - *Portfolio Evidence:* Take a screenshot of the Node-RED flow receiving live packets from your M5Stack node.

### ★ Task 2: The Layering & Overhead Friction Challenge
*Work in pairs with Wireshark.*

1. Start Wireshark on your laptop listening on the Wi-Fi/Ethernet interface.
2. Filter for `mqtt` or `tcp.port == 1883`.
3. Capture at least 5 telemetry packets published by your M5Stack node.
4. Analyze the Packet Breakdown:
   - Frame (Layer 1/2 total wire length)
   - Ethernet / 802.11 Header
   - IPv4 Header (20 bytes)
   - TCP Header (20–32 bytes)
   - MQTT Header + Topic string + Payload
5. Calculate the Overhead Ratio:
   $$\text{Overhead Ratio} = \frac{\text{Total Frame Size} - \text{Payload Size}}{\text{Payload Size}}$$
6. Discuss with your partner: If this node is powered by a 100 mAh coin cell and publishes every 5 seconds, how much energy is spent transmitting protocol metadata vs. actual sensor data?

### ★ Task 3: System Storytelling & Architecture Sketch
Craft a short system story for a multi-node IoT deployment:
- The Persona & Problem: Who needs this information? (e.g. cold-chain food transporter, hospital ward, smart greenhouse).
- The Devices: What physical M5Stack nodes gather data, where is the OpenWrt router placed, and where does the integrator run?
- Draw the Continuum: Draw a simple block diagram showing:
  `Sensor Node -> Wi-Fi/ESP-NOW -> Router Gateway (MQTT Broker) -> Node-RED -> Dashboard / Alerting`.

<a id="harvest"></a>
## 🔁 Optional: the harvest — collect curiosities, swap lists

> **Optional.** Try it for a session or two. If the room is short on time, skip it; it is ungraded.

Nothing here is graded, and **you are not explaining anything**. You are **collecting curiosities**: a route that looked wrong, an ARP entry that surprised you, a capture with an unexpected retransmission, a topic hierarchy that felt off, a firmware or OTA bug, a dashboard annoyance. Scan the material as you work — including the pre-study — and **mark** it: a `?` in the margin, a line in `Module01/study-log.md`, a screenshot. Marking takes seconds, and it is what makes the swap interesting.

**If you try it, swap twice:** at the break, and again at the end. Five minutes each.

1. **One minute each, no explaining.** Read your list out: *"I collected these — which did you find?"* Pointing at the thing is enough; you do not have to know what it does yet.
2. **Give every entry a source** — module and line, a link, a screenshot, or a capture — so it can be found again.
3. **"I don't know what this does" is a first-class entry.** It is usually the best one on the list.
4. **Anything two pods collected, or that nobody could place, goes to the course channel** with the module number. The next session opens with two of them.

That is the whole ritual. The list is the artefact; the conversation is the point — and a good `study-log.md` is exactly the kind of concise evidence that makes a checkpoint easy.

Why bother: network faults hide in the odd bits — a stale ARP entry, a route that only works one way, a QoS setting that silently changes delivery. Marking the odd bits instead of skimming past them is how that becomes a habit.

## ✅ Suggested portfolio evidence (proofs of the learning goals)

1. Pod formation: names, skills, and one line on what you want to build.
2. Node-RED & Packet Proof: Screenshot of your working Node-RED dashboard and your Wireshark packet capture showing the MQTT publish payload.
3. Overhead Calculation: Your calculation of header overhead vs. sensor payload.
4. OSI Critique Question: Write 1–2 paragraphs explaining why rigid 7-layer OSI models struggle in IoT systems, referencing RFC 3439.
5. System Story: Your project concept and architectural block diagram.
6. Harvest list: your marked curiosities in `Module01/study-log.md`, with sources and the questions you posted.


> [!IMPORTANT]
> Never commit secrets, credentials, private keys, or personal data. Where you did not work entirely alone, link your pod mates and sources.

## 📚 If you want to go deeper

- [RFC 1958](https://www.rfc-editor.org/rfc/rfc1958) — the architectural principles of the Internet.
- [RFC 3439 §3](https://www.rfc-editor.org/rfc/rfc3439#section-3) — “Layering Considered Harmful.”
- [Practical Networking: How Data Moves Through the Internet](https://www.practicalnetworking.net/index/networking-fundamentals-how-data-moves-through-the-internet/) — the packet journey from the pre-study.
- [Wireshark User's Guide](https://www.wireshark.org/docs/wsug_html_chunked/) — how to read the capture you took.
- [HiveMQ: MQTT essentials](https://www.hivemq.com/mqtt-essentials/) — the messaging layer you will use all course.

---

[← Course workbook](../README.md) | [Quick module index](./00-index.md) | [Next: Module 2 — Local Networking & OpenWrt Gateways →](./02-local-networking-and-gateways.md)
