# Module 1 – Foundations & The Master Class: The IoT Computing Continuum

[← Back to front page](../README.md) | [Quick module index](./00-index.md) | [Next: Module 2 →](./02-local-networking-and-gateways.md)

**Course placement:** Day 1 — the opening studio. We introduce the class and the way it works, build the mental model for the week, and then run the **[Master Class](../../../workshops/mastering-iot-solutions/README.md)** end-to-end integration in the same session.

## 🎯 Learning Goals

This module gives you the opportunity to explore IoT systems and networking foundations and achieve competency in the computing continuum, the OSI-vs-TCP/IP debate, and a first end-to-end sensor-to-dashboard integration.

By the end of this module, you can:
1. Explain how this class works — learning goals as the contract, negotiable tasks, evidence in a portfolio — and start your own portfolio with a note on what you already know, what you expect, and who your pod is.
2. Explain publish/subscribe with an MQTT broker: the star topology, hierarchical topics, wildcards, and why decoupling producers from consumers is what makes an IoT system maintainable.
3. Build Node-RED flows that subscribe and publish, turn a physical button into a remote actuator action, and render live telemetry as a gauge, a chart, and a wildcard aggregation.
4. Wire a digital 1-wire sensor, read its value over MQTT, and explain the declarative OTA loop (one line in `setup.cpp` → a fleet-wide deployment) and what it changes for a real fleet.
5. Critically analyze the ISO/OSI 7-layer model against real TCP/IP in IoT systems (referencing RFC 3439 and RFC 1958), and quantify header overhead from a capture taken at the edge — the router, an ESP32 tap, or a provided dump — stating every assumption.
6. Craft a system story that is concrete enough to pitch, spanning the computing continuum with named stakeholders, devices, and interfaces — and name the weakest link in it.


## 🎬 Opening the Class (plain-Markdown slides)

**The session opens from the deck** — [`slides/01-introduction.md`](../slides/01-introduction.md). It reads in any Markdown viewer (Zed, VS Code, GitHub) and renders to a **16:9 PDF** with [`slides/render-slides.sh`](../slides/render-slides.sh) (pandoc + Typst), presented fullscreen in Okular. Slides are `---`-separated Markdown, so the deck diffs and adapts like the rest of the workbook.

The opening runs in six beats — the deck carries the words, this is the map:

1. **whoami** — who is teaching, and why this subject ([me.ulno.net](https://me.ulno.net)).
2. **Who are U?** — a hand-count that becomes your first portfolio section.
3. **This is an experiment** — the deal: goals are the contract, tasks are negotiable, AI drafts and you verify, hands-on first.
4. **Logistics and the workbook** — where everything lives; the [syllabus](../syllabus.md) is the single source of truth.
5. **Form your Task Pod** — two or three, complementary rather than identical.
6. **Pre-study check-in** — one artefact, one insight, one open question.

The deck also carries **today's path** and the **first story slides**, so the class does not stall if the projector is still on the introduction when the lab starts.

### Form your Task Pod — who do you build with?

You do the labs and the checkpoints in a **Task Pod** of **two or three** (three by default in a large cohort; pairs are welcome); for the final project, two pods merge into a **Project Team** of 4–6. On a note, write your skills and your expectations, find one or two **complementary** people (not clones of yourself), exchange contacts with a first idea, and agree on a channel and on roles — you will rotate those roles in the Master Class anyway.

### Your portfolio entry for today — sections, not files

You did Module 0 at home, so Module 1 is an **addition**: leave `PreStudy/` exactly as it is.

**No repository yet?** [Create it in one click](https://github.com/new?template_name=iot-portfolio-template&template_owner=iotempire), name it exactly `net-iot-hsbi-2026-portfolio`, and invite `ulno` under *Settings → Access → Add people* (role *Write*). Two minutes — and nothing else in this module can be checked without it. The [primer](./Z-resources-bank.md#git--github-primer-template-editor-markdown-conflicts) has the step-by-step and the three-line `gh` variant.

Everything from today goes into **`Module01/README.md`** as sections — easier to read than a pile of tiny files. Split something into its own file only when a section outgrows the page; the portfolio template's `ModuleNN.md` shows that shape if you prefer it.

- `## Who I am` — your *Who are U?* answers and what you expect from the class.
- `## My pod` — names, skills, first idea; link your pod mates where you did not work entirely alone.
- `## Pre-study artefact` — one artefact from Module 0 (packet-path sketch, `traceroute`, first MQTT screenshot) and one sentence on what it shows.
- `## Study log` — the pod study below (Task 1) and your *Agreed learning* note (Task 2).
- `## Story seeds` — optional: the odd things worth turning into a story later.

What matters is not the filename but that a reader can find the proof without asking you where it is. Small commits, clear messages.

### Pre-study check-in

In your pod, two minutes each (it is also on the slides, so nobody has to remember it):

1. Show **one artefact** from Module 0 — your packet-path sketch, the `traceroute` with the private→public transition marked, or your first MQTT screenshot.
2. Explain **one thing you understood only after doing it**.
3. Name **one question you still have** — we park them on the board and pick them up during the day.

## 📖 Story — The Dashboard That Needed a Cloud

**Stadtwerke Gütersloh** operates district-heating substations across the city. Network operations lead **Petra Sommer** wants a simple dashboard: the temperature and pressure of each substation, updated every few seconds, visible in the control room and on a technician's phone. A vendor, **Cirrus Cloud Systems**, proposes the usual stack — a cloud broker, a managed database, a monthly fee, and a firmware update for every controller.

Petra asks the question the vendor cannot answer cheaply: *"The data is produced in the basement of a building we own, and the person who reads it is standing in the same building. Why does it need a round trip through the internet?"* Field engineer **Malik Yilmaz** adds the practical version: *"And when the uplink is down, what does my dashboard show me?"*

Today you build that loop end to end — and measure what the “layers” cost in bytes. The story runs alongside the Master Class; each task below carries a **story hook** so the system you build has a name, a user, and something at stake.

**This story is unfinished on purpose.** The hooks are starting points, not a script: pick the ones that match what you actually saw, and add a line of your own. *“And then the LED stayed dark because pod 07 had closed its laptop”* is worth more than a perfect diagram — it is the sentence Petra would actually say. Collect those lines as you work (there is a `## Story seeds` section for them) and use them in the pitch at the end of the day.

## 📖 Pod Study: The IoT Computing Continuum

This is **self/pod study, not a lecture.** Work through the concepts below with your Task Pod, look things up, ask an LLM, and keep notes — the goal is a shared mental model you can defend in the checkpoint.

### Warm-up (with your pod)

Before reading on, answer these in one sentence each:

- Name three devices in this room that are on a network. What does each one need before it can talk to another?
- Why might a sensor's data take a round trip through the internet when the person reading it is in the same building?
- What is the difference between a **layer** and a **protocol**?

### 1. The ISO/OSI Reference Model vs. The TCP/IP Reality

Traditional curricula introduce networking via the 7-layer ISO/OSI stack:

1. Physical (Bitübertragung)
2. Data Link (Sicherung)
3. Network (Vermittlung)
4. Transport
5. Session (Sitzung)
6. Presentation (Darstellung)
7. Application (Anwendung)

In modern IoT, rigid adherence to these 7 layers creates friction:

- **Header overhead (“tax”).** If an edge sensor publishes a 4-byte temperature, wrapping it in JSON (presentation), MQTT (application), TLS (presentation again), TCP (transport), IPv6 (network), and Wi-Fi 802.11 (data link) inflates the frame by hundreds of bytes. On a battery-powered node the radio usually dominates the energy budget — *how much* is exactly what you will measure in Module 5, so treat any percentage you read (including this one) as a claim to check.
- **Cross-layer optimization.** IoT protocols frequently bypass traditional layers: ESP-NOW injects vendor-specific action frames directly into IEEE 802.11 Layer 2 without IP or TCP; CoAP puts its own reliability on top of UDP; B.A.T.M.A.N. advanced does multi-hop routing at Layer 2.
- **The end-to-end principle** (RFC 1958, and RFC 3439 §3 “Layering Considered Harmful”): reliability and intelligence belong at the communication endpoints, not inside intermediate network nodes.

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

### 2. The layer you will actually touch today

The Master Class sits almost entirely in the top of that stack: a **publish/subscribe** system. A **broker** (Mosquitto) is a star hub; nodes **publish** to a **topic** and **subscribe** to topics. Nobody connects to anybody directly, which is why a dashboard can be replaced without touching the firmware.

- Topics are hierarchical and case-sensitive: `<id>/home`, `<id>/led/set`, `<id>/temp`.
- `+` matches exactly one level (`+/temp` = every node's temperature); `#` matches all remaining levels (`01/#` = everything node `01` says).
- A publisher does not know, and does not care, who is listening. That is the **decoupling** — and it is also why nobody notices when the last subscriber leaves.

You will use exactly this in the next section, so keep the topic table of the workshop handy rather than memorizing it.

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
- "My M5StickC publishes to `<id>/temp` and a Node-RED flow shows it. Draw the path and name every device and protocol hop between the sensor and the dashboard."
- "Why is a local MQTT broker more resilient than a cloud-only broker for a building control system? Give the failure modes of each."
- "Give me three failure modes for a classroom MQTT dashboard — broker restart, Wi-Fi drop, wrong topic. For each: what does the dashboard show, and what *should* it show?"

> Run each prompt against your own capture or running system, and record where the model is wrong, vague, or over-confident.

### ★ Task 1: Study in your pod

Work through the concepts above with your Task Pod and write it up under `## Study log` in `Module01/README.md` — a section, not a file, unless it outgrows the page. **One pod member keeps the shared log; the others link to that section from their own module README and add one sentence on what they took from it.**

1. **The references you used** — the source and the one concept you understood best from it.
2. **Things you googled** — the term, what you found, and the source (URL). One line each.
3. **Remarkable things** — surprises, “aha”s, and counterexamples from your capture.
4. **LLM Q&A** — for each prompt: the prompt, a 2–3 line summary, and **how you verified it** (and where it was wrong).
5. **Your two best found packet/architecture diagrams** — compile down to the best two, with source and what they taught you.

*Portfolio evidence:* your `## Study log` section.

### ★ Task 2: Explain & share with another pod

Pair with a **neighbouring pod**:

1. **Explain to each other** — each pod walks the other through its packet breakdown and its continuum sketch; ask questions and fill each other's gaps.
2. Agree on the **3–5 most noteworthy points** and the **learning you jointly stand behind** (e.g. *“the header tax is real, but the local-first loop is what makes the system survive”*).
3. **Clean up your documentation** — update your `## Study log` section with what you learned from the other pod.
4. Agree on **one shared artefact** — the best packet diagram, overhead table, or a new continuum sketch the two pods make together — and **post it in the course Discord**, with a one-sentence note on why you chose it.
5. Each member adds a short **“Agreed learning (pod discussion)”** note to *their own* `## Study log` section.

*Portfolio evidence:* your cleaned-up `## Study log` (with the **“Agreed learning (pod discussion)”** note) and your pod-pair's shared artefact.

## 🛠️ The Master Class — **Challenging**

The hands-on part of today is the **[Mastering IoT Solutions](../../../workshops/mastering-iot-solutions/README.md)** workshop, which has its own workbook with the exact, click-by-click steps. **That workbook is the authoritative procedure** — follow it in order (Phases 1–5, then the open-ended explorations). This module does not repeat the steps; it gives you the story, the learning goal each phase proves, and the evidence to keep.

> **The order is a suggestion.** The phases are a path, not a timetable. Take a different route if your pod can still prove the goals: stuck on wiring? do a flow task first. Finished the dashboard early? go back and measure the overhead. **When the class host is ready, the instructor can demo pieces live in Node-RED** — ask for the demo you need; if it is not available, the workbook and the sample flows are enough. Write down what you changed and why. The checkpoint question is always *“what did you choose, and what did it cost you?”*

**Hardware, per pod:** 1× M5StickC (Plus/Plus2), 1× USB-C cable for power, and 1× Dallas DS18B20 sensor — either the pre-soldered Grove protoboard (default, no wiring) or a bare module with three jumper wires. Optional for fast pods: a Sensirion SCD4x (CO₂).

> **Who owns the machine?** For the Master Class, your Node-RED is one of the pre-provisioned containers from `classroom-nodered.sh` on the class host. It is today's fast path — not your project environment. By Module 4 you will install and use **your own** Node-RED on the class host or your laptop. It does **not** run on the router: the router is the gateway and broker, not an application server. Keep the shared-host failure mode in mind for Task 10.

| What | Where to find it |
|---|---|
| Room Wi-Fi | `iotempire-b1300-5g` for your laptop, `iotempire-b1300` (2.4 GHz) for the sticks — password `iotempire` |
| Your Node-RED | the Master Class fleet on the class host — exact address and pod port on the board (`http://<class-host>:18nn/`) |
| Login | the credentials on the board; the containers use the class password |
| Broker | `broker.internal` → `192.168.114.1:1883` (classroom router), already configured |
| Your node | the M5StickC labeled with your pod's two-digit ID — that ID is the first level of every topic |

> **Rotate roles.** One of you drives the laptop, one reads the workbook aloud, one keeps notes and photos. Swap every phase; everybody should have published to a topic and wired a jumper at least once.

### ★ Task 3: First contact — hello, Node-RED

Work through **Phase 1 of the [workshop workbook](../../../workshops/mastering-iot-solutions/README.md#phase-1-first-contact--hello-world-in-node-red)** (connect to the room Wi-Fi, open your pod's Node-RED from the Master Class fleet, inject → debug, “Hello IoT!”).

> **No admin rights, or a locked-down company laptop?** The Master Class container fleet handles this; for your own Node-RED later, use the class host. Never install Node-RED on the router.

> **Story hook.** *The lamp test.* Before Petra trusts any dashboard, she wants one lamp in the control room to light when somebody presses a button in a basement. Cirrus Cloud Systems quoted four weeks and a service contract for exactly this.

**Aim:** a message you sent arrives in a debug sidebar, and you can point at the broker that carried it.

*Portfolio evidence:* a screenshot of inject → debug with the arriving payload, and one sentence naming publisher, broker, and subscriber.

### ★ Task 4: Your stick answers — buttons, LED, screen

Work through **Phase 2** (listen to `<id>/home`, toggle the onboard LED via `<id>/led/set`, print to the screen via `<id>/console/set`).

> **Story hook.** *Malik's “I am here” button.* The field engineer presses it when he walks into a substation, and the light outside tells the control room the door is open. He has been asking for this since 2019. It is four nodes of Node-RED and one line of firmware.

**Aim:** a physical press on your desk causes a physical reaction on your desk — no USB cable involved after power.

*Portfolio evidence:* screenshot of the flow, and a two-sentence explanation of why the LED reacts although the button and the LED are on the same tiny board: where did the message actually travel?

### ★ Task 5: The domino chain — the room becomes a network

Build **Phase 3**: your button press toggles your **neighbour's** LED (`<neighbour-id>/led/set` — the pod sitting next to you; the last pod wraps around to the first). Then pull the chain once with the whole room.

If the class host is ready, the instructor may bring **one link of the chain up live on the beamer** first, so you can see what “working” looks like before you build it; otherwise build it from the workbook. Then the shape is yours: a single chain, a ring, or two chains racing each other. A different shape is a different lesson — document what you chose and what it changed.

> **Story hook.** *The alarm relay chain.* When one substation overheats it rings the next one, and the last one rings the first — a ring built out of a star, because nobody wanted to buy a ring. Petra's question afterwards is the important one: *“What happens when pod 07 goes for coffee?”*

**Aim:** the chain works, and you can name what makes it stop working. (It is not the sticks. Look at the shape of the network, not the nodes.)

*Portfolio evidence:* your exported flow (`.json`), a photo or short screen recording of the chain, and three sentences: what the chain proves about pub/sub, what its single point of failure is, and what you would change.

### ★ Task 6: A real sensor, and an OTA deploy

Connect the **Dallas DS18B20** and run **Phase 4**. If your pod has the pre-soldered Grove protoboard, plug it into the Grove port — the sensor is on **GPIO32**, and the instructor uncomments `ds18b20(temp, 32);`. If you only have the bare sensor, wire DATA to `G26` and the instructor uses `ds18b20(temp, 26);`. Either way the deploy goes **over the air**. Subscribe to `<id>/temp`.

If the class host and deployment are ready, the instructor may **deploy one stick on the beamer** so the room sees the reboot before anyone waits for their own; otherwise follow the workbook. If you are stuck at the wiring, swap to another task and come back — the deploy can wait, and half the room is usually ahead of you anyway.

> **Story hook.** *Somebody leaned on the pipe.* Pinch the sensor between your fingers and watch the control room believe there is a burst pipe. Then pull the data jumper: the reading becomes `-127`. The sensor is not lying — the wire is. Malik has learned to ask *which* link failed: the physics, the wiring, the firmware, or the dashboard.

**Aim:** live temperature on your topic, and a working explanation of why no USB cable was involved.

> [!TIP]
> `-127` and `85` are the classic DS18B20 error values (disconnected bus; power-on default). Write down which one you saw and what you did — that is exactly the kind of evidence that makes a checkpoint easy. With the protoboard, the usual cause is that it is not fully seated in the Grove port; with a bare sensor, check the `G26` jumper and `GND`.

*Portfolio evidence:* photo of your wired stick, screenshot of `<id>/temp` arriving, and two sentences on what changed in `setup.cpp` and why the update did not need a cable.

### ★ Task 7: The control-room dashboard

Build **Phase 5**: a gauge and a chart from `<id>/temp`, then a **wildcard** subscription `+/temp` that turns the whole room into one multi-line chart. Pinch your sensor and find yourself in the crowd.

If the class host is ready, the instructor may show a **gauge and the `+/temp` chart live** and then hand the canvas over; otherwise build them from the workbook. Your dashboard does not have to look like the demo: a traffic light, a table, or one very large number are all valid, as long as a stranger can read them without you talking.

> **Story hook.** *The room is the district.* Every stick is a substation; the wildcard chart is Petra's control room; and the coldest corner is the one nobody has visited. She does not need a cloud for this. She needs the topics to be named consistently — which is a decision you just made, whether you noticed or not.

**Aim:** a dashboard a stranger could read without you talking, plus one aggregation that only works because every pod followed the same topic convention.

*Portfolio evidence:* screenshot of the gauge, the chart, and the `+/temp` heatmap; plus one sentence on what would break if each pod had invented its own topic names.

### ★ Task 8: What the layers cost — read a real capture

This one is yours, not the workshop's. Theory is in the pod study; now measure. **It is about the arithmetic, not about owning a sniffer** — nobody in the room has a second Wi-Fi adapter or monitor mode, so you cannot watch the air from your laptop.

1. **Get a dump from a point the traffic crosses.** The class default is the router: `tcpdump` on `br-lan`, filtered to `tcp port 1883`, then copy the file over. An ESP32 tap or the instructor's `Module01` capture work just as well — that is exactly what the [capture recipes](./Z-resources-bank.md#packet-capture-without-a-second-wifi-card) are for. If you cannot capture anything on your machine today, **use the provided dump**: the analysis is the skill, the tapping is plumbing.
2. **Open it** in Wireshark if you have it; otherwise `tshark -r module01.pcap -Y mqtt -V`, or `tcpdump -r module01.pcap -A 'tcp port 1883'`. Filter for `mqtt` or `tcp.port == 1883` and find one PUBLISH.
3. **Break it down:** frame length on the wire; 802.11 or Ethernet header; IPv4 header; TCP header; MQTT fixed header + topic string + payload.
4. **Compute** `overhead ratio = (frame bytes − payload bytes) / payload bytes`, and the share of the frame that is actual sensor data.
5. **Scale it, with stated assumptions:** one reading every *N* seconds; the transmit current from the ESP32 datasheet; the capacity of the coin cell you would really use (look it up — do not trust a remembered number). How many days does the arithmetic give? Write the assumptions next to the result; an estimate without assumptions is a guess.
6. **Ask an LLM for the header sizes first, then check each one in the dump.** Record where it was wrong.

> **Story hook.** *Petra's accountant.* He wants to know what the monthly cloud fee actually buys. You have twenty bytes of temperature and a frame that is mostly paperwork. Show him the invoice.

*Portfolio evidence:* your overhead table (frame, headers, topic, payload), the ratio, your stated assumptions, and one sentence on whether the measurement matched the LLM's explanation.

### ◇ Task 9 (optional): Cross the room, cross the internet

Stretcher work — pick one or two. The workshop's **[open-ended explorations](../../../workshops/mastering-iot-solutions/README.md#open-ended-explorations)** (CO₂ traffic light, IMU digital level, screen art, Telegram/webhook alert, IoTempower tour) are the first menu.

Additional suggestions for this class:

- **The outside bridge.** In the pre-study you talked to the public test broker `broker.hivemq.com`. Now go the other way: bridge *one* topic from the class system out to `hsbi/<your-random-id>/room/temp`, then subscribe to it **from your phone on mobile data**. Answer: who can see it, what would it take to reach the *class* broker from outside instead, and why is a hard-to-guess topic name not a security boundary? *(No personal data, no names, no credentials on a public broker; stop the bridge when you are done. Module 3 shows the proper way to reach a private network, Module 4 covers what is missing here.)*
- **Fake it until you measure it.** Write a small Python `paho-mqtt` publisher that emits a plausible pressure reading for a substation, and put it on your dashboard next to the real temperature. Note the danger: the dashboard cannot tell you which series is real. That seam is what Module 4 is about.
- **Make it fail, gently.** Disconnect your laptop from Wi-Fi and watch the dashboard. Does it show a stale value with no warning? Then the dashboard is lying — write down what it *should* have shown. (Broker restarts and Last Will belong to Module 4; you are only collecting the symptom today.)
- **Teach one thing back.** Explain the topic hierarchy to another pod in ninety seconds without notes. If they get it, you understood it.

*Portfolio evidence:* what you tried, what surprised you, and the one question you could not answer yet.

### ★ Task 10: Pitch the system you just built

The day closes with the story — because tomorrow's system will be built from stories like this one. In your pod, **two minutes, standing, no slides**.

1. **A person and a moment of pain.** Use the canon (Petra Sommer, Malik Yilmaz, Mara Voss, Nils Bergmann, Dr. Elif Kaya, Hendrik Brinkmann — see the [story canon](./Z-resources-bank.md#story-canon-the-recurring-cast)) or invent someone with a name. Not “a factory”: *Hendrik Brinkmann, 6:40 on a Monday, the mill has been running cold since Saturday.*
2. **What is at stake** — money, safety, a night shift, a batch, a reputation.
3. **Draw the continuum** with the devices you actually touched: stick → access point → broker → Node-RED → dashboard or phone. Mark every hop and name the protocol on it. Keep it to one screen or one whiteboard.
4. **Name the weakest link** and say what happens when it dies. (The honest answer today is usually the broker, the Wi-Fi, or the person who owns the PC running Node-RED.)
5. **One sentence for the report** that a non-engineer would understand.

The room votes for the pitch that would survive Petra's first question. Post the sketch in the course channel so the class has a shared collection of continuums.

*Portfolio evidence:* the sketch (photo or image), five lines of text, and the weakest-link sentence.

<a id="harvest"></a>
## 🔁 Optional: the harvest — collect curiosities, swap lists

> **Optional.** Try it for a session or two. If the room is short on time, skip it; it is ungraded.

Nothing here is graded, and **you are not explaining anything**. You are **collecting curiosities**: a route that looked wrong, an ARP entry that surprised you, a capture with an unexpected retransmission, a topic hierarchy that felt off, a `-127` from a loose jumper, a dashboard that kept showing yesterday's number. Scan the material as you work — including the pre-study — and **mark** it: a `?` in the margin, a line under `## Story seeds`, a screenshot. Marking takes seconds, and it is what makes the swap interesting.

**Keep a second list next to it: story seeds.** The odd bits are where the next story comes from — *the sensor that was right*, *the dashboard that lied*, *the pod that went for coffee*. One line each is enough; you will need them in Modules 8 and 9.

**If you try it, swap twice:** at the break, and again at the end. Five minutes each.

1. **One minute each, no explaining.** Read your list out: *“I collected these — which did you find?”* Pointing at the thing is enough; you do not have to know what it does yet.
2. **Give every entry a source** — module and line, a link, a screenshot, or a capture — so it can be found again.
3. **“I don't know what this does” is a first-class entry.** It is usually the best one on the list.
4. **Anything two pods collected, or that nobody could place, goes to the course channel** with the module number. The next session opens with two of them.

That is the whole ritual. The list is the artefact; the conversation is the point — and a good `## Study log` section is exactly the kind of concise evidence that makes a checkpoint easy.

Why bother: network faults hide in the odd bits — a stale ARP entry, a route that only works one way, a topic that nobody subscribes to. Marking the odd bits instead of skimming past them is how that becomes a habit.

## ✅ Suggested portfolio evidence (proofs of the learning goals)

1. **Orientation (goal 1):** `## Who I am` and `## My pod` in `Module01/README.md`, plus your pre-study artefact under `## Pre-study artefact`.
2. **Decoupling (goal 2):** two or three sentences — in your own words — on what the broker does that direct connections would not, using your own topic names as the example.
3. **Flows (goal 3):** screenshots of inject → debug, the button/LED flow, the gauge and chart, the `+/temp` heatmap; the exported domino flow as `.json`.
4. **Sensor and OTA (goal 4):** photo of the wired stick, screenshot of `<id>/temp`, and what changed in `setup.cpp` plus why no cable was needed.
5. **Layering and overhead (goal 5):** the overhead table with frame/header/payload sizes, the ratio, your assumptions, and one paragraph on why rigid layering struggles in IoT, referencing RFC 3439.
6. **Story (goal 6):** the continuum sketch, the two-minute pitch in five lines, and the sentence naming the weakest link.
7. **Optional:** your harvest and story-seed list, or the notes from Task 9.

> [!IMPORTANT]
> Never commit secrets or credentials you were given for infrastructure you do not own, and never commit captures containing other people's traffic. Where you did not work entirely alone, link your pod mates and sources.

**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 📚 If you want to go deeper

- [RFC 1958](https://www.rfc-editor.org/rfc/rfc1958) — the architectural principles of the Internet.
- [RFC 3439 §3](https://www.rfc-editor.org/rfc/rfc3439#section-3) — “Layering Considered Harmful.”
- [Practical Networking: How Data Moves Through the Internet](https://www.practicalnetworking.net/index/networking-fundamentals-how-data-moves-through-the-internet/) — the packet journey from the pre-study.
- [Wireshark User's Guide](https://www.wireshark.org/docs/wsug_html_chunked/) — how to read the capture you took.
- [HiveMQ: MQTT essentials](https://www.hivemq.com/mqtt-essentials/) — the messaging layer you will use all course.
- [Node-RED documentation](https://nodered.org/docs/) — the flow editor, for when the workshop's click-path is not enough.
- [IoTempower](https://iotempower.us) — the declarative node framework behind today's OTA deploy; Module 7 takes it apart.

---

[← Course workbook](../README.md) | [Quick module index](./00-index.md) | [Next: Module 2 — Local Networking & OpenWrt Gateways →](./02-local-networking-and-gateways.md)
