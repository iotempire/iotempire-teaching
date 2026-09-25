# Syllabus: Networking and IoT Solutions (Vernetzung und IoT-Lösungen)

> **Important**: This syllabus is a living document and will evolve throughout the semester. Minor updates may apply based on class progress, hardware availability, and student feedback.
>
> **Canonical source:** [IoTempire Teaching repository — HSBI/GT Networking and IoT Solutions](https://github.com/iotempire/iotempire-teaching/tree/main/full-classes/hsbi-networking-iot-10d)

> [!NOTE]
> **Work in progress — new class, first taught in WS 2026/27.** Expect this syllabus to keep changing before and during the semester, and **please come back to check it often**. **Large parts are still a draft**: in each module a *DRAFT BOUNDARY* marks the content that is not settled yet, and it moves down as we approve sections together. Your input is valued and appreciated — I am glad to adapt this class to your program, and your suggestions can change the plan, the tasks, and even this syllabus. If something does not fit, say so early.

---

## Class Times and Locations

- **Schedule, location, and room:** Published in the official HSBI timetable and course LMS before teaching begins.
- **Official announcements and course contact:** Course LMS.
- **Languages of Instruction:** English and German.
- **Course Materials:** English.

---

## Instructors & Teaching Team (HSBI Gütersloh)

| **Role** | **Name** | **Contact / Status** |
|---|---|---|
| Main Instructor | Prof. Dr. Ulrich Norbisrath (**Ulno**) | [ulno.net](https://ulno.net) |
| Teaching Support | Fabian Tilman Schmid-Michels *(if available)* | To be confirmed |

> [!NOTE]
> **Course information:** Ulno is the primary instructor for this HSBI offering. The course LMS is the authoritative source for local dates, rooms, contact details, and announcements. An optional Discord space or chat may be offered as an additional community channel; students and interested people are always welcome to join the main **IoTempire community Discord** (link maintained in the [repository README](../../README.md#references--resources)).

---

## Language, Communication & Course Material

This class is taught in **English and German**. The shared workbook, slides, code, documentation, and technical exercises are in English to ensure reusability and align with modern engineering practice.

Ulno is fully bilingual. You are welcome to speak with the teaching team and collaborate with your peers in **German, English, or a mixture of both**. Notes, portfolio documentation, reports, and presentations may likewise be submitted in German, English, or mixed language. Ask whenever technical vocabulary or a task formulation needs clarification in either language.

**Für deutschsprachige Studierende:** Diese Lehrveranstaltung findet auf Englisch und Deutsch statt. Das gemeinsame Workbook, die Folien, der Code, die Dokumentation und die Übungen bleiben auf Englisch, damit sie einheitlich genutzt werden können. Ulno ist zweisprachig; Sie können mit dem Lehrteam und untereinander auf Deutsch, Englisch oder in einer Mischung aus beiden Sprachen sprechen und arbeiten. Notizen, Portfolio-Dokumentation und Präsentationen dürfen ebenfalls auf Deutsch, Englisch oder gemischt verfasst werden. Fragen Sie jederzeit nach, wenn Fachbegriffe oder Aufgabenstellungen geklärt werden sollen.

---

## Course Description & Philosophy

### Networking and IoT Solutions — Moving Beyond the Rigid 7-Layer OSI Model

In classical computer science education, networking is often introduced through the 7-layer ISO/OSI reference model and abstract calculations of packet headers and Hamming codes. While the OSI model remains a useful historical dictionary and conceptual reference, **modern Internet of Things (IoT) systems demand an engineering-first, practical approach centered on TCP/IP, overlay networks, and distributed integration.**

Modern IoT is not merely "an Arduino connected to Wi-Fi." It is a heterogeneous computing continuum spanning:
- **Low-power edge nodes:** M5Stack microcontrollers (ESP32-based) communicating locally via Wi-Fi or connectionless **ESP-NOW**.
- **Edge gateways and local routers:** OpenWrt travel routers (one router per two students) hosting local services, managing subnets, performing NAT, and routing traffic.
- **Mesh and overlay networks:** **Nebula** and **Yggdrasil** providing secure, zero-friction remote access across campus firewalls and home networks without complex port forwarding; plus an **optional** B.A.T.M.A.N. (batman-adv) stretch for self-healing Layer-2 wireless router meshes.
- **Application messaging & integration:** **MQTT** as the central decoupling broker, complemented by visual integration via **Node-RED** and programmatic event flows in **Python** (`paho-mqtt` / **IoTknit**).
- **Industrial interoperability (overview):** How legacy field buses (**Modbus**, **RS-485**) and industrial standards (**OPC-UA**, real-time Ethernet) would bridge into an open IoT fabric — taught mostly conceptually, since industrial hardware is usually unavailable in the lab.
- **Fleet orchestration:** **IoTempower** for declarative configuration, fleet management, and Over-The-Air (OTA) deployment across dozens of devices.

In this course, you will do **less raw microcontroller breadboard wiring** (which is emphasized in *Microcontroller Programming* and *Sensorik & Aktorik*) and significantly **more networking, system integration, edge routing, and fleet deployment**.

---

### How We Teach — Challenge- and Project-Based, In Person, and Always in Flux

This course is deliberately taught as **Challenge-Based** and **Project-Based Learning** (CBL/PBL): you learn by investigating an authentic challenge and building a real solution, not by reproducing a lecture. We begin from **stories** — a real problem that matters to you and the people it touches — because you learn best what connects to something meaningful for your own life, studies, or community. Your instructors genuinely care that you find that connection.

It also matters that we do this **in person, together** — a university class is at its best where we actually meet. You will learn a great deal from direct interaction with your peers: explaining, questioning, debugging, and demoing to one another, while your instructors learn alongside you.

And this class is **always in flux — that is a feature, not a bug**. No course is ever finished: every offering is adjusted while it runs, and each class teaches us as much as it teaches you. Expect the plan, the tasks, and even this syllabus to move as we discover together what works best; your questions, ideas, and feedback are part of the design.

> **Want to read more?** Challenge-Based Learning — [en.wikipedia.org/wiki/Challenge-based_learning](https://en.wikipedia.org/wiki/Challenge-based_learning) · Project-Based Learning — [pblworks.org/what-is-pbl](https://www.pblworks.org/what-is-pbl) · Why active, interactive learning beats passive lectures — [Harvard Gazette, 2019](https://news.harvard.edu/gazette/story/2019/09/study-shows-that-students-learn-more-when-taking-part-in-classrooms-that-employ-active-learning-strategies)

---

## Learning Objectives

By the end of this course, you will be able to:

1. **Apply TCP/IP and Network Fundamentals:** Configure and debug IPv4 addressing, CIDR subnetting, DHCP, DNS, NAT, and basic IPv6 in real IoT edge topologies.
2. **Critically Assess Network Models:** Use the ISO/OSI model as an architectural reference while recognizing its real-world limitations in IoT (referencing RFC 3439 *"Layering Considered Harmful"* and RFC 1958).
3. **Deploy Edge Gateways & Routers:** Configure OpenWrt routers via CLI and LuCI; analyze live packet captures using Wireshark and `tcpdump`.
4. **Build Overlay and Mesh Networks:** Deploy **Nebula** peer-to-peer overlay tunnels and **Yggdrasil** encrypted IPv6 mesh routing to securely connect distributed IoT nodes from home or behind firewalls; and *(optionally)* configure **B.A.T.M.A.N. advanced** for ad-hoc, self-healing wireless mesh routing between edge routers.
5. **Architect Publish/Subscribe Systems:** Design robust topic structures and message flows with **MQTT** (QoS levels, Retain, Last Will and Testament, TLS).
6. **Understand Multi-Protocol Integration:** Explain how sensor nodes, actuators, and industrial protocols (**OPC-UA**, **Modbus**, **RS-485**) fit together, and — if hardware or a simulator is available — *(optionally)* bridge them using **Node-RED** and **Python**.
7. **Leverage Local Wireless Standards:** Evaluate trade-offs between Wi-Fi, BLE, LoRaWAN, and connectionless **ESP-NOW** for latency, range, power, and payload constraints.
8. **Manage IoT Fleets Declaratively:** Use **IoTempower** to manage, configure, and update multiple M5Stack nodes over-the-air.
9. **Engineer a Resilient IoT Network:** Design, build, troubleshoot, and document a complete multi-node IoT solution with automated failover and verifiable engineering metrics.

---

## Course Load & Credits

- **Format:** 10 working days / 12 sessions (4 hours each) across the semester. The final project arc occupies several of these sessions (see the schedule below).
- **Target Audience:** Bachelor students in *Digitale Technologien* and *Software Engineering* (3rd semester, Campus Gütersloh).
- **Module Number:** 3264 (*Vernetzung und IoT-Lösungen*).
- **Total Workload:** 150 hours (5 ECTS credits).
  - In-person lab and seminar contact: 48 hours.
  - Independent preparation and pre-study (Module 0): approx. 40 hours allocated (3–6 hours for the compulsory core).
  - Guided self-study, portfolio documentation, and capstone project: approx. 62 hours.

---

## Assessment: Kombinationsprüfung (20 Base Points + Bonus)

Assessment is conducted as a **Kombinationsprüfung** combining continuous portfolio documentation, laboratory work, working-day reflections, and a final capstone project.

> [!IMPORTANT]
> **Module 0 is required and worth 1 module point.** Before the first session, set up your personal GitHub portfolio using the course template and complete the pre-study tasks outlined in [pre-study.md](./pre-study.md). Module 0 is assessed during the second session.

### Points Breakdown

| Component | Points | Details |
|---|---|---|
| **Module 0 (Pre-Study)** | **1 point** | Portfolio repository setup, inspiration notes, network exploration, and answers to guiding questions. |
| **Modules 2–7 (Learning goals)** | **10 points** | Earned through **checkpoint presentations** (~10 min each, covering 2–3 modules) that prove the module learning goals from your portfolio and reflections — not by completing every task. Lab evidence: OpenWrt config, Wireshark captures, Nebula/Yggdrasil overlays, MQTT flows, ESP-NOW, IoTempower fleet; optional stretchers include the B.A.T.M.A.N. mesh and a simulated industrial (Modbus/OPC-UA) bridge. |
| **Working-Day Reflections** | **4 points** | Individual reflections submitted for each working day/session documenting technical discoveries, failed attempts, and conceptual takeaways. |
| **Final Capstone Project** | **5 points** | 25% of the base score. Multi-node, multi-protocol IoT network build, live demo, failover test, and documentation. |
| **Base Total** | **20 points** | **100% base score.** |
| **Extra / Bonus Points** | **Up to 3 points** | Awarded for outstanding contributions, peer mentoring, advanced stretcher tasks, or accepted upstream pull requests to IoTempower or this curriculum repository. |

- **Score cap:** The final score is capped at **20 points**, even if bonus points are earned. Bonus points compensate for minor weaknesses in regular deliverables, but all compulsory components must still be attempted.
- **Passing threshold:** Minimum 14 out of 20 points (~70%) to pass (*bestanden*).

### How module points are earned: checkpoint presentations

You do **not** submit and grade every task. Instead, you earn a module's points in a short, **personal checkpoint presentation** (about **10 minutes**) with the instructor, based on your **portfolio and working-day reflections**. Checkpoints happen in class and cover **2–3 modules at a time**; the schedule is announced through the LMS.

In a checkpoint, you:
1. **Show your evidence** — portfolio entries, measurements, code, diagrams, and reflections for the modules being checked.
2. **Prove the learning goals** — the goals listed at the top of each module. Walk the instructor through how your work shows you reached them, and answer questions about them.

Because assessment targets the **learning goals, not task completion**, you are free to **skip tasks, fail at tasks, or add your own**. An honest, documented failure counts as **exploration**, not as a loss, and a convincing demonstration of **deep understanding or analysis** is rewarded generously. If a topic excites you, go deep — that is exactly what this format is meant to encourage.

Practical notes:
- Bring your portfolio (and any device or demo) to the checkpoint.
- Expect to explain a measurement, justify a design choice, or read a register or datasheet live.
- If you cannot attend a checkpoint, talk to the instructor early; a missed checkpoint is handled like a missed deadline.

### Grade Scale

| **Points (0–20)** | **German Grade** | **Status** |
|---|---|---|
| 0–13 | Nicht bestanden (5.0) | Fail |
| 14–15 | Ausreichend (4.0) | Passed |
| 16–17 | Befriedigend (3.0) | Satisfactory |
| 18–19 | Gut (2.0) | Good |
| 20 | Sehr gut (1.0) | Very Good |

---

## Hardware Kit & Laboratory Equipment

Unlike pure microcontroller classes, our hardware focuses on **modular, ready-to-network hardware and real routing infrastructure**:

- **Edge Routers (1 router per 2 students):**
  - Primarily the **Cudy TR1200** flashed to pure upstream OpenWrt.
  - Partner and fallback models: **GL.iNet GL-MT300N-V2 ("Mango")** (used by colleagues in Tartu and Regensburg) and **GL-AR300M ("Shadow")** (to fill gaps).
  - All routers run **upstream OpenWrt** with LuCI, Mosquitto MQTT broker, `tcpdump`, and `iperf3`; optional `kmod-batman-adv` and mesh tools for the B.A.T.M.A.N. stretcher.
- **Modular Edge Nodes (M5Stack Ecosystem):**
  - **M5StickC Plus / Plus2** and/or **M5Atom Matrix / Lite / S3**: ESP32-based devices with built-in displays, buttons, IMU, and Grove I²C/GPIO ports.
  - Eliminates fragile breadboard wiring so lab time is spent on protocols, integration, and packet flow.
- **Plug-and-Play Grove Sensors & Actuators:**
  - Environmental sensors (temperature/humidity/pressure e.g., ENV IV / SHT30 / BMP280).
  - Actuators: RGB LEDs, buzzer, relays, servo/motor modules.
- **Cables & Networking Gear:**
  - USB-C data cables, Ethernet patch cables, USB power hubs.
  - Dedicated lab switches and access points for isolated mesh/subnet testing.

---

## 10-Day Course Schedule

The 10 days correspond to the 12 4-hour sessions across the semester. Modules 1–7 deliver the technical foundations; the final project arc (Module 8) spans the remaining studio sessions so that there is genuine build, hardening, and rehearsal time — not just a single rushed studio.

> **Indicative plan.** The day-by-day mapping below is a planning draft and may shift — including during the semester — as we refine this class together. The learning objectives and the capstone matter more than the exact day a topic lands on.

| Day | Session(s) | Module / Topic | Core Hands-on Focus |
|:---:|:---:|---|---|
| **0** | — | **[Pre-Study](./pre-study.md)** | Portfolio setup, inspiration video, network mental model, IP exploration. |
| **1** | 1 | **[Module 1 — Foundations & Master Class](./modules/01-foundations-and-masterclass.md)** | The IoT computing continuum, OSI vs. TCP/IP friction, Master Class live integration (M5Stack + MQTT + Node-RED). |
| **2** | 2 | **[Module 2 — Local Networking & OpenWrt Gateways](./modules/02-local-networking-and-gateways.md)** | IPv4 subnetting, DHCP, DNS, NAT, routing tables, OpenWrt LuCI/SSH, Wireshark & `tcpdump` packet capture. |
| **3** | 3 | **[Module 3 — Mesh & Overlay Networks](./modules/03-overlay-and-mesh-networks.md)** | Nebula overlay remote access and Yggdrasil IPv6 mesh; optional B.A.T.M.A.N. Layer-2 mesh stretcher (`batctl`, failover). |
| **4** | 4 | **[Module 4 — MQTT Deep Dive & Integration](./modules/04-mqtt-and-integration.md)** | Topic hierarchy, QoS 0/1/2, Retain, Last Will, MQTT Explorer, Node-RED flows, Python `paho-mqtt` / IoTknit integration. |
| **5** | 5 | **[Module 5 — Wireless Technologies & ESP-NOW](./modules/05-wireless-technologies-and-espnow.md)** | Radio spectrum, ISM bands, Wi-Fi vs BLE vs LoRaWAN trade-offs, ESP-NOW connectionless peer-to-peer micro-mesh and gateway bridge. |
| **6** | 6 | **[Module 6 — Industrial Protocols & Edge Bridging](./modules/06-industrial-protocols-and-bridging.md)** | Conceptual tour: Modbus RTU/TCP, OPC-UA, RS-485, TSN context; optional simulated Python/Node-RED bridge to MQTT. |
| **7** | 7 | **[Module 7 — Fleet Management & Scaling with IoTempower](./modules/07-fleet-management-and-iotempower.md)** | Declarative IoT architecture, multi-node configuration, Over-The-Air (OTA) deployment across M5Stack fleet, topic standardisation. |
| **8** | 8–9 | **[Module 8 — Capstone Project Studio](./modules/08-capstone-project-studio.md)** | Project kickoff & story, team and requirement mapping, system integration across nodes and network layers. |
| **9** | 10–11 | **[Module 8 — Capstone Project Studio (continued)](./modules/08-capstone-project-studio.md)** | Integration hardening, fault-injection & resilience testing, architecture documentation, peer review dry run. |
| **10** | 12 | **[Module 9 — Capstone Demonstrations & Portfolio Defense](./modules/09-demonstrations-and-defense.md)** | Live multi-node demonstration, network fault-injection test, portfolio presentation, retrospective. |

> [!TIP]
> **Buffer and pacing:** Days 8–9 provide four studio sessions. At least one of them is deliberately loose and can absorb spill-over from earlier labs, be released as flexible/wiggle time, or be used for stretcher tasks and peer mentoring. Announce the concrete use of each studio session in the LMS as the course progresses.

---

## Capstone Project Requirements (5 Points)

The capstone project is an end-to-end networked system built by teams of 2–4 students. Teams form and pitch a stakeholder **story** during the project kickoff (Module 8), then map their requirements onto the criteria below.

### Must-Have System Criteria:
1. **Multi-Node Networked Architecture:** At least **4 independent physical nodes** (e.g., 2 M5Stack nodes, 1 OpenWrt router, 1 edge gateway/laptop server).
2. **Diverse Network Technologies:** Combine at least **two distinct networking or communication layers** (e.g., ESP-NOW local micro-network bridged to Wi-Fi/Ethernet; a B.A.T.M.A.N. Layer-2 mesh; or a Nebula/Yggdrasil overlay for remote access).
3. **Robust Application Messaging:** Well-structured MQTT topic hierarchy with explicit QoS, state retention, and Last Will and Testament for offline detection.
4. **System Integration Layer:** Automated event routing, data processing, and user interface implemented via **Node-RED** and/or custom **Python** (`paho-mqtt` / **IoTknit**).
5. **External or Industrial Interoperability (choose one):** a functional bridge to an **external service/API** (for example an HTTP/JSON API or public data source); or, if hardware or a simulator is available, to an **industrial protocol** such as Modbus or OPC-UA.
6. **Fleet / IoTempower Deployment:** At least part of the node fleet configured and deployed declaratively via **IoTempower** with documented OTA update capability.
7. **Resilience & Fault Tolerance:** The system must demonstrate graceful recovery when a network link drops or a node restarts (tested during the live demo).

### Assessment Criteria:
- **System Functionality & Resilience (2 points):** Meets specifications, handles disconnections cleanly, valid packet flows.
- **Architecture, Documentation & Metrics (1.5 points):** Clear network topology diagram, routing explanation, Wireshark/throughput/latency measurements in portfolio.
- **Live Demonstration & Presentation (1.5 points):** Clear 5-minute technical demo showing live sensor data, control actions, and intentional fault injection (e.g., unplugging an intermediate router).

---

## Portfolio & Documentation Standards

All assessments are based on your personal **GitHub Portfolio** (forked from [iot-portfolio-template](https://github.com/iotempire/iot-portfolio-template)):

- Maintain a clean Git log with descriptive commit messages.
- For each module, include:
  - Configuration files (OpenWrt network configs, Node-RED flows `.json`, Python scripts, IoTempower `setup.cpp` or node definitions).
  - Screenshots of dashboards, packet captures (Wireshark), and terminal routing outputs (`ip route`, `traceroute`, `batctl`).
  - Working-day reflections (what worked, what failed, what you learned, open questions).
- In hardware and networking, **documented failure is rewarded**: showing how you identified a broken route or a misconfigured subnet using `tcpdump` is worth more than a superficial "it worked" report.

---

## Classroom Policies & Success Strategies

1. **Active Participation:** Labs require hands-on physical collaboration with routers and hardware. Bring your laptop (Linux, macOS, or Windows with WSL2/virtual machine).
2. **Network Hygiene:** You will be configuring DHCP servers, routing protocols, and ad-hoc Wi-Fi networks. Never plug rogue DHCP servers into the campus network infrastructure; always work within our isolated lab router networks!
3. **Pair & Collaborate:** Work in pairs during router and mesh labs. Debugging packet flow is twice as fast when one student monitors the sender and the other runs `tcpdump` on the receiver.
4. **Open Source Mindset:** Share discoveries and help peer teams. Accepted pull requests to IoTempower, the course repository, or open-source tools qualify for extra credit.

---

## Contacts & Support

- **Primary Communication Channel:** Course LMS (ILIAS). Check regularly for updates and announcements.
- **Main Instructor:** Prof. Dr. Ulrich Norbisrath (**Ulno**) — [ulno.net](https://ulno.net/)
- **IoTempire Community:** [iotempire.net](https://iotempire.net/)
- **IoTempower Framework:** [https://iotempower.us](https://iotempower.us) / [GitHub](https://github.com/iotempire/iotempower)
