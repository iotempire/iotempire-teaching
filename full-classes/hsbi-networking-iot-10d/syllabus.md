# Syllabus: Networking and IoT Solutions (Vernetzung und IoT-Lösungen)

> Important: This syllabus is a living document and will evolve throughout the semester. Minor updates may apply based on class progress, hardware availability, and student feedback.
>
> **Canonical source:** [IoTempire Teaching repository — HSBI/GT Networking and IoT Solutions](https://github.com/iotempire/iotempire-teaching/tree/main/full-classes/hsbi-networking-iot-10d)

> [!NOTE]
> **Every module begins with its learning goals.** Those goals are the agreement between you and the instructor: you earn a module's points by *demonstrating the goals* — in a short checkpoint conversation and through your portfolio — not by ticking off every task. The goals are fixed; the way you reach them is yours.

> [!NOTE]
> **This class is a draft in motion.** It is a first-time offering in WS 2026/27. In every module a ***DRAFT BOUNDARY*** marks the part that is not settled yet; it moves down as we approve content together. Expect this syllabus to keep changing, and bring your own deep dives and stretchers — your input can shape the class.

## Class Times and Locations

- Schedule, location, and room: Published in the official HSBI timetable and course LMS before teaching begins.
- Official announcements and course contact: Course LMS.
- Languages of Instruction: English and German.
- Course Materials: English.

## Instructors & Teaching Team (HSBI Gütersloh)

| Role | Name | Contact / Status |
|---|---|---|
| Main Instructor | Prof. Dr. Ulrich Norbisrath (Ulno) | [ulno.net](https://ulno.net) |
| Teaching Support | Fabian Tilman Schmid-Michels *(if available)* | To be confirmed |

> [!NOTE]
> **Course information:** Ulno is the primary instructor for this HSBI offering. The course LMS is the authoritative source for local dates, rooms, contact details, and announcements. An optional Discord space or chat may be offered as an additional community channel; students and interested people are always welcome to join the main IoTempire community Discord (link maintained in the [repository README](../../README.md#references--resources)).

<a id="language-communication--course-material"></a>
## Language, Communication & Course Material

This class is taught in **English and German**. The shared workbook, code, documentation, and technical exercises are in **English**, so the material stays reusable and consistent.

Ulno is fully bilingual. You are welcome to speak with the teaching team and collaborate with your peers in German, English, or a mixture of both. Notes, portfolio documentation, reports, and presentations may likewise be submitted in German, English, or mixed language. Ask whenever technical vocabulary or a task formulation needs clarification in either language. Write plainly and precisely rather than perfectly: clear technical communication matters far more than flawless grammar.

**Für deutschsprachige Studierende:** Diese Lehrveranstaltung findet auf Englisch und Deutsch statt. Das gemeinsame Workbook, der Code, die Dokumentation und die Übungen bleiben auf Englisch, damit sie einheitlich genutzt werden können. Ulno ist zweisprachig; Sie können mit dem Lehrteam und untereinander auf Deutsch, Englisch oder in einer Mischung aus beiden Sprachen sprechen und arbeiten. Notizen, Portfolio-Dokumentation und Präsentationen dürfen ebenfalls auf Deutsch, Englisch oder gemischt verfasst werden. Fragen Sie jederzeit nach, wenn Fachbegriffe oder Aufgabenstellungen geklärt werden sollen.

## Course Description & Philosophy

### Networking and IoT Solutions — Moving Beyond the Rigid 7-Layer OSI Model

> **One question runs through the whole course:** *How do I connect devices that do not share a network, a provider, or a trust domain — and keep the system working when a link dies?*

In classical computer science education, networking is often introduced through the 7-layer ISO/OSI reference model and abstract calculations of packet headers and Hamming codes. While the OSI model remains a useful historical dictionary and conceptual reference, modern Internet of Things (IoT) systems demand an engineering-first, practical approach centered on TCP/IP, overlay networks, and distributed integration.

Modern IoT is not merely "an Arduino connected to Wi-Fi." It is a heterogeneous computing continuum spanning:

- **Low-power edge nodes:** M5Stack microcontrollers (ESP32-based) communicating locally via Wi-Fi or connectionless ESP-NOW.
- **Edge gateways and local routers:** OpenWrt travel routers (one router per two students) hosting local services, managing subnets, performing NAT, and routing traffic.
- **Mesh and overlay networks:** Nebula and Yggdrasil providing secure, zero-friction remote access across campus firewalls and home networks without complex port forwarding; plus an optional B.A.T.M.A.N. (batman-adv) stretch for self-healing Layer-2 wireless router meshes.
- **Application messaging & integration:** MQTT as the central decoupling broker, complemented by visual integration via Node-RED and programmatic event flows in Python (`paho-mqtt` / IoTknit).
- **Industrial interoperability (overview):** How legacy field buses (Modbus, RS-485) and industrial standards (OPC-UA, real-time Ethernet) would bridge into an open IoT fabric — taught mostly conceptually, since industrial hardware is usually unavailable in the lab.
- **Fleet orchestration:** IoTempower for declarative configuration, fleet management, and Over-The-Air (OTA) deployment across dozens of devices.

In this course, you will do less raw microcontroller breadboard wiring (which is emphasized in *Microcontroller Programming* and *Sensorik & Aktorik*) and significantly more networking, system integration, edge routing, and fleet deployment.

### How We Teach — Challenge- and Project-Based, In Person, and Always in Flux

This course is deliberately taught as Challenge-Based and Project-Based Learning (CBL/PBL): you learn by investigating an authentic challenge and building a real solution, not by reproducing a lecture. We begin from stories — a real problem that matters to you and the people it touches — because you learn best what connects to something meaningful for your own life, studies, or community. Your instructors genuinely care that you find that connection.

It also matters that we do this in person, together — a university class is at its best where we actually meet. You will learn a great deal from direct interaction with your peers: explaining a route, questioning a topic hierarchy, debugging a packet flow, and demoing to one another, while your instructors learn alongside you.

And this class is always in flux — that is a feature, not a bug. No course is ever finished: every offering is adjusted while it runs, and each class teaches us as much as it teaches you. Expect the plan, the tasks, and even this syllabus to move as we discover together what works best; your questions, ideas, and feedback are part of the design.

> Want to read more? Challenge-Based Learning — [en.wikipedia.org/wiki/Challenge-based_learning](https://en.wikipedia.org/wiki/Challenge-based_learning) · Project-Based Learning — [pblworks.org/what-is-pbl](https://www.pblworks.org/what-is-pbl) · Why active, interactive learning beats passive lectures — [Harvard Gazette, 2019](https://news.harvard.edu/gazette/story/2019/09/study-shows-that-students-learn-more-when-taking-part-in-classrooms-that-employ-active-learning-strategies)

## Learning Objectives

By the end of this course, you will be able to:

1. **Apply TCP/IP and network fundamentals:** Configure and debug IPv4 addressing, CIDR subnetting, DHCP, DNS, NAT, and basic IPv6 in real IoT edge topologies.
2. **Critically assess network models:** Use the ISO/OSI model as an architectural reference while recognizing its real-world limitations in IoT (referencing RFC 3439 *"Layering Considered Harmful"* and RFC 1958).
3. **Deploy edge gateways & routers:** Configure OpenWrt routers via CLI and LuCI; analyze live packet captures using Wireshark and `tcpdump`.
4. **Build overlay and mesh networks:** Deploy Nebula peer-to-peer overlay tunnels and Yggdrasil encrypted IPv6 mesh routing to securely connect distributed IoT nodes from home or behind firewalls; and *(optionally)* configure B.A.T.M.A.N. advanced for ad-hoc, self-healing wireless mesh routing between edge routers.
5. **Architect publish/subscribe systems:** Design robust topic structures and message flows with MQTT (QoS levels, Retain, Last Will and Testament, TLS).
6. **Understand multi-protocol integration:** Explain how sensor nodes, actuators, and industrial protocols (OPC-UA, Modbus, RS-485) fit together, and — if hardware or a simulator is available — *(optionally)* bridge them using Node-RED and Python.
7. **Leverage local wireless standards:** Evaluate trade-offs between Wi-Fi, BLE, LoRaWAN, and connectionless ESP-NOW for latency, range, power, and payload constraints.
8. **Manage IoT fleets declaratively:** Use IoTempower to manage, configure, and update multiple M5Stack nodes over-the-air.
9. **Engineer a resilient IoT network:** Design, build, troubleshoot, and document a complete multi-node IoT solution with automated failover and verifiable engineering metrics.

## Course Load & Credits

- Format: 10 working days / 12 sessions (4 hours each) across the semester. The final-project arc occupies several of these sessions (see the schedule below).
- Target Audience: Bachelor students in *Digitale Technologien* and *Software Engineering* (3rd semester, Campus Gütersloh).
- Module Number: 3264 (*Vernetzung und IoT-Lösungen*), 5 ECTS.
- Total Workload: 150 hours.
  - In-person lab and seminar contact: 48 hours.
  - Independent preparation and pre-study (Module 0): the compulsory core is a few hours; the syllabus allocates room for deeper preparation.
  - Guided self-study, portfolio documentation, and final project: the remaining balance.

> [!NOTE]
> **Where the 150 hours come from.** The module handbook specifies 150 h (5 ECTS). The delivered format is 12 four-hour sessions plus portfolio work, network experiments, and the final project. Treat the session count as fixed (12) and the *hours per session* as ~4.

### Prerequisites & Relationship to Other Modules

- **Formal:** none beyond course registration.
- **Content:** basic computer literacy and comfort with a terminal help; ability to work with Git, a shell, and a markup language is expected, as in the other IoT courses. Basic Python is useful for the integration labs and is scaffolded in Module 4.
- **Relationship to other modules:** *Vernetzung und IoT-Lösungen* is a 3rd-semester module. It pairs naturally with *Microcontroller Programming* and *Sensorik & Aktorik*: those courses produce the edge devices and measurements; this course connects them into a system. There is no required prior course.

<a id="assessment-kombinationsprüfung-20-base-points--bonus"></a>
## Assessment: Kombinationsprüfung (20 Base Points + Bonus)

Assessment is a **Kombinationsprüfung** combining continuous portfolio documentation, laboratory work, reflection logbook entries, and a final project. The formal form is fixed by the module handbook; where the handbook version constrains the mix, the instructor will announce the binding variant in the LMS. Everything below is the working agreement for this offering.

You build and maintain one personal **GitHub portfolio**. The small tasks in each module are how you **prove that module's learning goals**, personalized through your **reflections**, and short **checkpoints** give you feedback on whether those goals have been achieved — while also giving the instructor a sense of your performance. In the **last session you present your final project to the instructor and to each other**.

> [!IMPORTANT]
> **Module 0 and Modules 1–7 are worth 11 of the 20 base points.** You earn them by demonstrating the modules' learning goals in short checkpoints — not by completing every task. Module 0 is normally completed before Day 1; in a cohort that needs more setup time, it can be run as the first in-class module instead (same 1 point, same evidence).

### Points Breakdown

| Component | Points | Details |
|---|---|---|
| Module 0 (Pre-Study) | 1 point | Portfolio repository setup from the template, inspiration notes, network exploration, and answers to the guiding questions. |
| Modules 1–7 (Learning goals) | 10 points | Earned through short checkpoint presentations that prove the module learning goals from your portfolio: OSI critique and packet overhead, OpenWrt configuration and captures, Nebula/Yggdrasil overlays, MQTT flows, ESP-NOW, optional industrial bridge, and IoTempower fleet deployment. |
| Reflection points | 4 points | One logbook entry for each teaching block (four blocks: Days 1–3, 4–6, 7–8, and 9–10), captured in your personal logbook. |
| Final meaningful project | 5 points | 25% of the base score. A multi-node, multi-protocol IoT network with a live demo, failover test, short documentation, and individual defense, built in a **Project Team** of 4–6. |
| **Base total** | **20 points** | 100% base score. |
| Extra / bonus points | up to +3 | Outstanding benchmarking/measurement, accepted open-source pull requests to IoTempower or class repositories, or verified peer debugging and mentoring. |

- **Score cap:** The final score is capped at 20 points, even if bonus points are earned. Bonus points compensate for minor weaknesses in regular deliverables, but all compulsory components must still be attempted.
- **Passing threshold:** Minimum **14 out of 20 points** (~70%) to pass (*bestanden*).

<a id="how-module-points-are-earned-checkpoint-presentations"></a>
### How module points are earned: checkpoint presentations

You do not submit and grade every task. Instead, you earn a module's points in a short checkpoint presentation — **10–12 minutes, including questions and feedback** — with the instructor, based on your portfolio and reflection logbook. Checkpoints are done **with your Task Pod, in person**, and cover a few modules at a time:

- **Checkpoint 1 — start of Day 4 (Modules 1–3).** For a larger cohort this runs as a **30-minute 2-pod practice round**: two pods pair up; each pod presents from its existing portfolios, and the other pod gives free-style feedback and questions checking how well the goals were proven. The instructor assesses from the presentations and the portfolios. In a small cohort, use the same slot for individual pod checkpoints.
- **Checkpoint 2 — start of Day 8 (Modules 4–7).**

Dates and slots are confirmed through the LMS. The goals of Module 8 (final project studio) are demonstrated in the final project and defense.

**Task Pods, and how checkpoints scale.** We work in **Task Pods** — small crews of **two or three** (three by default for a large cohort, roughly >40 students; a few **two-person pods** are welcome precisely because they reduce the instructor's checkpoint load; a fourth podmate is only by arrangement). The point is *small*, not rigid.

> **Why “Task Pod”?** In container orchestration (Kubernetes), a **pod** is the *smallest deployable unit* — one or a few tightly-coupled containers that are scheduled, run, and retired together. A **Task Pod** is the same idea for people: your tight little crew of two or three that owns one task end-to-end. Your **Project Team** is the larger unit — the alliance of two pods that ships the whole system.

**These Task Pods are for the labs and checkpoints; the final project merges two pods into a Project Team of 4–6** (see [Final Project Requirements](#final-project-requirements-5-points)).

In a checkpoint, you:

1. **Show your evidence** — portfolio entries, network diagrams, configuration files, packet captures, code, measurements, and reflections for the modules being checked.
2. **Prove the learning goals** — the goals listed at the top of each module. Walk the instructor through how your work shows you reached them, and answer questions about them (expect to read a routing table, explain a capture, or debug a topic live).

**Because assessment targets the learning goals — not task completion — the tasks are negotiable.** You are free to skip tasks, fail at tasks, or add your own, and for tasks below a module's draft boundary to **modify or replace them entirely, as long as you reach the same learning goals**. An honest, documented failure counts as exploration, not as a loss, and a convincing demonstration of deep understanding or analysis is rewarded generously.

Practical notes:

- Bring your portfolio (and your laptop with the router, broker, or capture open) to the checkpoint.
- Expect to explain a routing choice, justify a topic hierarchy, or interpret a packet capture live.
- For a 2-pod practice round, bring your portfolio ready to present, and expect to give — and take — free-style feedback.
- If you **cannot attend in person**, talk to the instructor early and submit a **7–10 minute video** plus a **3–5 page explained excerpt** from your portfolio for review. You get less feedback than in an in-person checkpoint; a missed in-person checkpoint without such a submission is handled like a missed deadline.

### Task tiers: ★ Core and ◇ Stretcher

Tasks are marked **★ Core** or **◇ Stretcher**. A **★ Core** task is one we consider *core* to the module — the straightforward way to reach its learning goals. It is not a hard requirement, but note the asymmetry: for an ordinary task you can argue “this was not needed to reach the goals” and we will usually accept it; for a **★ Core** task that argument is harder, so skipping one means convincing us you reached the same goals another way. A **◇ Stretcher** is optional — an extension, a deeper dive, or bonus material, and the natural trim point when time is short. **Have a better task idea?** Propose it; if it reaches the same learning goal, we can swap it into the module — student-designed tasks are explicitly welcome.

### Reflection format

For each teaching block, write one logbook entry in `Reflections/refNN.md`, using the reflection template in the portfolio template. The template includes the **AI-verification** question.

### Grade Scale

| Points (0–20) | German Grade | Status |
|---|---|---|
| 0–13 | Nicht bestanden (5.0) | Fail |
| 14–15 | Ausreichend (4.0) | Passed |
| 16–17 | Befriedigend (3.0) | Satisfactory |
| 18–19 | Gut (2.0) | Good |
| 20 | Sehr gut (1.0) | Very Good |

## Tools & Environment

| Layer | Tool | Notes |
|---|---|---|
| Editor | **VS Code** or **Zed** | Use the **integrated terminal** and the Git UI; keep the workbook open beside your terminal. |
| Terminal | **bash** (Git Bash on Windows) | The labs use heredocs, pipes, and `<` redirects; Git Bash ships with Git for Windows. WSL is also fine. |
| Version control | **Git + GitHub** | Your portfolio is the evidence artifact. Create it from the template with **“Use this template”**, not a fork. |
| Routing & capture | **OpenWrt + LuCI**, `tcpdump`, **Wireshark**, `iperf3` | One router per two students; capture at the edge, not only on the laptop. |
| Overlays & mesh | **Nebula**, **Yggdrasil**, optional **B.A.T.M.A.N. advanced** | Certificates and peers provided or generated in class. |
| Messaging & integration | **Mosquitto**, **MQTT Explorer**, **Node-RED**, **Python 3** (`paho-mqtt`, IoTknit; optional `pymodbus`, `asyncua`) | Local-first broker; Python as the programmatic glue. |
| Python environment | **`uv`** | Pin Python and libraries with `uv`; commit `pyproject.toml` and `uv.lock`, never `.venv/`. Avoid bare `pip install` in the normal path. |
| Fleet | **IoTempower** | Declarative node definition and OTA deployment. |
| AI co-pilots | **ChatGPT / Claude / DeepSeek / local models** | Used to *draft* and explain, never to decide. Verification is the graded skill. |

> [!NOTE]
> **Hands-on first, AI second.** You learn this subject by building networks, breaking links, and reading captures. Use AI to draft explanations, configuration, or hypotheses — but only after you have observed the system. Verify every generated command against a capture, a routing table, or a live test.

> [!WARNING]
> **No secrets, captures with personal data, or binaries in Git.** Never commit credentials, private keys, `.venv/`, or packet captures containing personal traffic. Commit the configuration and the script that reproduces an experiment. The [resource bank](./modules/Z-resources-bank.md#git--github-primer-template-editor-markdown-conflicts) has the template workflow and the `.gitignore` guidance.

## Hardware Kit & Laboratory Equipment

Unlike pure microcontroller classes, our hardware focuses on modular, ready-to-network hardware and real routing infrastructure:

- **Edge routers (1 router per 2 students):**
  - Primarily the Cudy TR1200 flashed to pure upstream OpenWrt.
  - Partner and fallback models: GL.iNet GL-MT300N-V2 ("Mango") (used by colleagues in Tartu and Regensburg) and GL-AR300M ("Shadow") (to fill gaps).
  - All routers run upstream OpenWrt with LuCI, Mosquitto MQTT broker, `tcpdump`, and `iperf3`; optional `kmod-batman-adv` and mesh tools for the B.A.T.M.A.N. stretcher.
- **Modular edge nodes (M5Stack ecosystem):**
  - M5StickC Plus / Plus2 and/or M5Atom Matrix / Lite / S3: ESP32-based devices with built-in displays, buttons, IMU, and Grove I²C/GPIO ports.
  - Eliminates fragile breadboard wiring so lab time is spent on protocols, integration, and packet flow.
- **Plug-and-play Grove sensors & actuators:**
  - Environmental sensors (temperature/humidity/pressure e.g., ENV IV / SHT30 / BMP280).
  - Actuators: RGB LEDs, buzzer, relays, servo/motor modules.
- **Cables & networking gear:**
  - USB-C data cables, Ethernet patch cables, USB power hubs.
  - Dedicated lab switches and access points for isolated mesh/subnet testing.

> [!WARNING]
> **Network hygiene.** You will configure DHCP servers, routing, and ad-hoc Wi-Fi networks. Never plug a rogue DHCP server into the campus network; always work inside the isolated lab router network. Disconnect power before rewiring, and never connect a 5 V or 12 V supply to a 3.3 V logic pin.

## 10-Day Course Schedule

The 10 days correspond to the 12 four-hour sessions across the semester. Modules 1–7 deliver the technical foundations; the final-project arc (Modules 8–9) spans the remaining studio sessions so that there is genuine build, hardening, and rehearsal time — not just a single rushed studio.

> Indicative plan. The day-by-day mapping below is a planning draft and may shift — including during the semester — as we refine this class together. The learning objectives and the final project matter more than the exact day a topic lands on.

| Day | Session(s) | Module / Topic | Core Hands-on Focus |
|:---:|:---:|---|---|
| 0 | — | [Pre-Study](./pre-study.md) | Portfolio setup, inspiration video, network mental model, IP and MQTT exploration. |
| 1 | 1 | [Module 1 — Foundations & Master Class](./modules/01-foundations-and-masterclass.md) | The IoT computing continuum, OSI vs. TCP/IP friction, Master Class live integration (M5Stack + MQTT + Node-RED). |
| 2 | 2 | [Module 2 — Local Networking & OpenWrt Gateways](./modules/02-local-networking-and-gateways.md) | IPv4 subnetting, DHCP, DNS, NAT, routing tables, OpenWrt LuCI/SSH, Wireshark & `tcpdump` packet capture. |
| 3 | 3 | [Module 3 — Mesh & Overlay Networks](./modules/03-overlay-and-mesh-networks.md) | Nebula overlay remote access and Yggdrasil IPv6 mesh; optional B.A.T.M.A.N. Layer-2 mesh stretcher (`batctl`, failover). |
| 4 | 4 | [Module 4 — MQTT Deep Dive & Integration](./modules/04-mqtt-and-integration.md) **+ Checkpoint 1** | *2-pod practice round (larger cohorts) or pod checkpoints first (Modules 1–3), then:* Topic hierarchy, QoS 0/1/2, Retain, Last Will, MQTT Explorer, Node-RED flows, Python `paho-mqtt` / IoTknit integration. |
| 5 | 5 | [Module 5 — Wireless Technologies & ESP-NOW](./modules/05-wireless-technologies-and-espnow.md) | Radio spectrum, ISM bands, Wi-Fi vs BLE vs LoRaWAN trade-offs, ESP-NOW connectionless peer-to-peer micro-mesh and gateway bridge. |
| 6 | 6 | [Module 6 — Industrial Protocols & Edge Bridging](./modules/06-industrial-protocols-and-bridging.md) | Conceptual tour: Modbus RTU/TCP, OPC-UA, RS-485, TSN context; optional simulated Python/Node-RED bridge to MQTT. |
| 7 | 7 | [Module 7 — Fleet Management & Scaling with IoTempower](./modules/07-fleet-management-and-iotempower.md) | Declarative IoT architecture, multi-node configuration, Over-The-Air (OTA) deployment across M5Stack fleet, topic standardisation. |
| 8 | 8–9 | [Module 8 — Final Project Studio](./modules/08-final-project-studio.md) **+ Checkpoint 2** | *Checkpoint 2 first (Modules 4–7), then:* Project kickoff & story, team and requirement mapping, system integration across nodes and network layers. |
| 9 | 10–11 | [Module 8 — Final Project Studio (continued)](./modules/08-final-project-studio.md) | Integration hardening, fault-injection & resilience testing, architecture documentation, peer review dry run. |
| 10 | 12 | [Module 9 — Final Project Demonstrations & Portfolio Defense](./modules/09-demonstrations-and-defense.md) | Live multi-node demonstration, network fault-injection test, portfolio presentation, retrospective. |

> [!TIP]
> **Buffer and pacing:** Days 8–9 provide four studio sessions. At least one of them is deliberately loose and can absorb spill-over from earlier labs, be released as flexible/wiggle time, or be used for stretcher tasks and peer mentoring. Announce the concrete use of each studio session in the LMS as the course progresses.

<a id="final-project-requirements-5-points"></a>
## Final Project Requirements (5 Points)

The final project is an end-to-end networked system built by **Project Teams of 4–6 students** — the project merges two Task Pods from Modules 1–7, so you keep your pod and gain one or two more. Project Teams form and pitch a stakeholder story during the project kickoff (Module 8), then map their requirements onto the criteria below.

### Must-Have System Criteria:

1. **Multi-node networked architecture:** At least 4 independent physical nodes (e.g., 2 M5Stack nodes, 1 OpenWrt router, 1 edge gateway/laptop server).
2. **Diverse network technologies:** Combine at least two distinct networking or communication layers (e.g., ESP-NOW local micro-network bridged to Wi-Fi/Ethernet; a B.A.T.M.A.N. Layer-2 mesh; or a Nebula/Yggdrasil overlay for remote access).
3. **Robust application messaging:** Well-structured MQTT topic hierarchy with explicit QoS, state retention, and Last Will and Testament for offline detection.
4. **System integration layer:** Automated event routing, data processing, and user interface implemented via Node-RED and/or custom Python (`paho-mqtt` / IoTknit).
5. **External or industrial interoperability (choose one):** A functional bridge to an external service/API (for example an HTTP/JSON API or public data source); or, if hardware or a simulator is available, to an industrial protocol such as Modbus or OPC-UA.
6. **Fleet / IoTempower deployment:** At least part of the node fleet configured and deployed declaratively via IoTempower with documented OTA update capability.
7. **Resilience & fault tolerance:** The system must demonstrate graceful recovery when a network link drops or a node restarts (tested during the live demo).

### Assessment Criteria:

- **System functionality & resilience (2 points):** Meets specifications, handles disconnections cleanly, and shows valid packet flows.
- **Architecture, documentation & metrics (1.5 points):** Clear network topology diagram, routing explanation, Wireshark/throughput/latency measurements, a concise project report, and clean Git history.
- **Live demonstration & individual defense (1.5 points):** A clear **10-minute** Project Team demo — 5 minutes of live system demonstration including intentional fault injection, plus a 5-minute individual defense on the design decisions you own.

#### Detailed rubric

| Criterion | Points | Excellent (full) | Sufficient (partial) | Weak / missing |
|---|---:|---|---|---|
| **System functionality & resilience** | 2.0 | Fulfills all must-haves: 4+ nodes, 2+ network layers, MQTT pub/sub, integration engine (Node-RED/Python), and IoTempower OTA. Graceful recovery under fault injection. | Meets most must-haves; one gap (e.g. weak resilience evidence). | Server/hand-built topology without a reproducible setup, no measured resilience, or missing integration. |
| **Architecture, documentation & metrics** | 1.5 | Clear network diagram, IP/topic documentation, Wireshark captures, latency/overhead/recovery measurements, concise report, and clean Git history. | Documentation present and mostly complete; evidence thin in one section. | Missing diagram, report over/under length, or no measurements. |
| **Live demonstration & individual defense** | 1.5 | End-to-end live demo runs; each member defends their architecture and protocol trade-offs fluently; handles an injected fault. | Demo runs but is partly slide-based, or defense is uneven across members. | Demo fails without explanation, or members cannot defend their parts. |

See the full [final project specification](./modules/09-demonstrations-and-defense.md) for the demo script and portfolio evidence checklist.

## Portfolio & Documentation Standards

All assessments are based on your personal GitHub Portfolio, created from the [iot-portfolio-template](https://github.com/iotempire/iot-portfolio-template) with **“Use this template”**, then made your own; the [Git & GitHub primer](./modules/Z-resources-bank.md#git--github-primer-template-editor-markdown-conflicts) covers the template workflow, your editor, Markdown, and resolving conflicts.

Each module lists **suggested portfolio evidence** — suggestions, not a checklist. You may prove the same learning goals another way; if you do, say so in the module entry.

- Maintain a clean Git log with descriptive commit messages.
- For each module, include:
  - Configuration files (OpenWrt network configs, Node-RED flows `.json`, Python scripts, IoTempower `setup.cpp` or node definitions).
  - Network diagrams showing physical links, subnets, overlay addresses, and data flows.
  - Screenshots of dashboards, packet captures (Wireshark), and terminal routing outputs (`ip route`, `traceroute`, `batctl`).
  - Measurement evidence: ping/RTT, throughput, latency, packet loss, or recovery time.
  - Reflection logbook entries in `Reflections/`, using the template.
- Where you did not work entirely alone, **link your pod mates and your sources**.
- In hardware and networking, documented failure is rewarded: showing how you identified a broken route or a misconfigured subnet using `tcpdump` is worth more than a superficial "it worked" report.

## Classroom Policies & Success Strategies

1. **Active participation:** Labs require hands-on physical collaboration with routers and hardware. Bring your laptop (Linux, macOS, or Windows with WSL2/Git Bash).
2. **Network hygiene:** You will be configuring DHCP servers, routing protocols, and ad-hoc Wi-Fi networks. Never plug rogue DHCP servers into the campus network infrastructure; always work within our isolated lab router networks.
3. **Collaborate within your pod:** Debugging packet flow is twice as fast when one student monitors the sender and the other runs `tcpdump` on the receiver. Split tasks, audit each other, and change roles often.
4. **Measurement mindset:** A resilience claim without a recovery time, a packet capture, or a throughput number is an opinion. Write down *what* you measured, *with what*, and *under what conditions*.
5. **AI with responsibility:** Use AI co-pilots enthusiastically — and verify relentlessly. You are accountable for every configuration and every line you ship, whether you or a model wrote it.
6. **Open-source mindset:** Share discoveries and help other pods (and, later, other Project Teams). Accepted pull requests to IoTempower, this course repository, or open-source tools qualify for bonus points.

## Contacts & Support

- Primary Communication Channel: Course LMS. Check regularly for updates and announcements.
- Main Instructor: Prof. Dr. Ulrich Norbisrath (Ulno) — [ulno.net](https://ulno.net/)
- IoTempire Community: [iotempire.net](https://iotempire.net/)
- IoTempower Framework: [https://iotempower.us](https://iotempower.us) / [GitHub](https://github.com/iotempire/iotempower)
