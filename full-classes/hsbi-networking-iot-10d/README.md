# HSBI/GT Networking and IoT Solutions — 10-Week Edition

## Contents

| Start here | What it contains |
|---|---|
| [Pre-study guide](./pre-study.md) | Essential networking preparation and first MQTT exploration (Module 0) |
| [Syllabus](./syllabus.md) | Course schedule, learning objectives, assessment rules, and hardware kit |
| [Module 1 — Foundations & Master Class](./modules/01-foundations-and-masterclass.md) | The IoT continuum, OSI vs. TCP/IP critique, Master Class live integration |
| [Module 2 — Local Networking & OpenWrt Gateways](./modules/02-local-networking-and-gateways.md) | IPv4 subnetting, DHCP, DNS, NAT, routing, OpenWrt, Wireshark & `tcpdump` |
| [Module 3 — Mesh & Overlay Networks](./modules/03-overlay-and-mesh-networks.md) | Nebula overlay, Yggdrasil IPv6 mesh, optional B.A.T.M.A.N. mesh stretcher |
| [Module 4 — MQTT Deep Dive & Integration](./modules/04-mqtt-and-integration.md) | Pub/Sub, QoS, Retain, LWT, Node-RED flows, Python `paho-mqtt` & IoTknit |
| [Module 5 — Wireless Technologies & ESP-NOW](./modules/05-wireless-technologies-and-espnow.md) | Spectrum, ISM bands, Wi-Fi vs BLE vs LoRa, ESP-NOW action frames & gateway bridge |
| [Module 6 — Industrial Protocols & Edge Bridging](./modules/06-industrial-protocols-and-bridging.md) | Modbus/OPC-UA/RS-485 overview, TSN context; optional simulated edge bridge |
| [Module 7 — Fleet Management & IoTempower](./modules/07-fleet-management-and-iotempower.md) | Declarative node configuration, Over-The-Air (OTA) flashing, M5Stack fleet scaling |
| [Module 8 — Final Project Studio](./modules/08-final-project-studio.md) | Project kickoff & story, multi-node integration, resilience testing, peer review rehearsal |
| [Module 9 — Final Project Demonstrations & Defense](./modules/09-demonstrations-and-defense.md) | Live multi-node demonstration, network fault-injection test, portfolio defense |
| [Resource Prompts](./modules/Y-resources-prompt-bank.md) | Portfolio prompts and quick references |
| [Resource Bank](./modules/Z-resources-bank.md) | Extra resources, cheat sheets, and troubleshooting |

This README is the course workbook and front page for the **Networking and IoT Solutions (Vernetzung und IoT-Lösungen)** course taught at **Hochschule Bielefeld University of Applied Sciences and Arts (HSBI)**, Campus Gütersloh. It is delivered over **10 working days / 12 sessions** (4 hours each) across the semester. The official timetable, room, and announcements are published through the course LMS (ILIAS).

> [!NOTE]
> This is a **new class, first taught in WS 2026/27**, and a living document: expect adaptations before and during the semester. **Large parts are still a draft** — each module marks unsettled content with a moving *DRAFT BOUNDARY* that we raise as we approve it together, and your feedback is explicitly welcome and can shape the class.

---

## Course Overview

- **Duration:** 10 working days / 12 sessions (4 hours each).
- **Target Group:** Bachelor students in *Digitale Technologien* and *Software Engineering* (3rd semester).
- **Workload:** 150 hours (5 ECTS credits).
- **Format:** Practical, laboratory-driven course combining edge networking, routing infrastructure, visual and programmatic integration, and declarative fleet management.
- **Hardware Kit:**
  - **OpenWrt Edge Routers** (1 router per 2 students): Primarily the **Cudy TR1200** flashed to pure upstream OpenWrt, with **GL.iNet GL-MT300N-V2 "Mango"** and **GL-AR300M "Shadow"** as partner/fallback options — for local subnetting, routing, NAT, and (optionally) wireless mesh (`batman-adv`).
  - **M5Stack Modular Nodes** (M5StickC Plus, M5Atom Matrix/Lite) with Grove sensors and actuators—minimizing breadboard wiring to maximize focus on protocols and integration.
- **Software Stack:**
  - **Networking & Routing:** OpenWrt, LuCI, `tcpdump`, Wireshark, Nebula overlay, Yggdrasil IPv6 mesh; optional B.A.T.M.A.N. advanced + `batctl`.
  - **Application Messaging:** Mosquitto MQTT broker, MQTT Explorer, `mosquitto_sub`/`pub`.
  - **Integration & Code:** Node-RED, Python 3 (`paho-mqtt`, IoTknit; optional `pymodbus`/`asyncua` for the industrial stretch).
  - **Fleet Orchestration:** [IoTempower](https://github.com/iotempire/iotempower) for declarative node definition and Over-The-Air (OTA) updates.

> [!NOTE]
> **Instructor note (router sourcing):** we deliberately deploy only routers running **pure upstream OpenWrt**. Avoid vendor forks such as the **GL-SFT1200 ("Opal")** — an outdated, proprietary 2018 fork with closed drivers that blocks bridging, access-point mode, and modern mesh packages. Mention this when handing out the routers; *why* upstream OpenWrt beats a pseudo-OpenWrt vendor fork is a good real-world case study in edge-infrastructure selection.

For the complete language arrangement, teaching team, learning objectives, assessment rules, and policies, read the [syllabus](./syllabus.md).

---

## Assessment: Kombinationsprüfung (20 Points Base + Bonus)

Your final grade is assessed continuously through your personal **GitHub Portfolio** and the final project:

- **Module 0 (Pre-Study):** 1 point (compulsory preparation before the first session; see [pre-study guide](./pre-study.md)).
- **Modules 2–7 (Learning goals):** 10 points, earned through **checkpoint presentations** (~10 min each, covering 2–3 modules) that prove the module learning goals from your portfolio and reflections — not by completing every task. You may skip tasks, fail at some, or add your own. See the [syllabus](./syllabus.md#how-module-points-are-earned-checkpoint-presentations).
- **Working-Day Reflections:** 4 points (one reflection for each working day documenting discoveries, struggles, and solutions).
- **Final Project:** 5 points (25% of base score; multi-node, multi-protocol networked system with live failover demo).
- **Bonus / Extra Points:** Up to 3 points for outstanding work, peer mentoring, advanced stretcher tasks, or accepted upstream pull requests to IoTempower or this curriculum repository.
- **Passing Mark:** 14 / 20 points (~70%).

---

## Portfolio & Hardware

Maintain a personal GitHub portfolio with network diagrams, configuration files, Wireshark packet captures, Node-RED flows, Python integration scripts, serial logs, and working-day reflections. Start from the [portfolio template](https://github.com/iotempire/iot-portfolio-template).

**Module 0 is required:** before the first session, fork your portfolio and complete the pre-study tasks in [pre-study.md](./pre-study.md). In networking and IoT, **documented struggles and debugging traces are valued highly**—capturing a failed route and showing how you resolved it using `tcpdump` is an essential engineering skill.

---

## Navigation & Resources

- [Module index](./modules/00-index.md) — compact navigation
- [Pre-study guide](./pre-study.md) — start here before Day 1
- [Syllabus](./syllabus.md) — official course rules and policies
- [IoTempower](https://github.com/iotempire/iotempower) — declarative fleet management framework ([iotempower.us](https://iotempower.us))
- [IoTempire](https://iotempire.net/) — organization, teaching tools, and community

### LMS PDF Exports

Generate dated, upload-ready PDFs from the syllabus and pre-study guide using LibreOffice (default), Chromium, or LaTeX:

```sh
./generate-lms-pdfs.sh 2026-27
```

---

## Contacts & Support

- **Questions, schedule, and technical support:** Use the course LMS (ILIAS), the authoritative communication channel.
- **Main Instructor:** Prof. Dr. Ulrich Norbisrath (**Ulno**) — [ulno.net](https://ulno.net/)
- **Teaching Support:** Fabian Tilman Schmid-Michels *(if available)*
- **Community:** [IoTempire](https://iotempire.net/)
