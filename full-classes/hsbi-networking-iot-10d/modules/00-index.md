# Networking and IoT Solutions — Module Index & Roadmap

[← Course workbook](../README.md) | [Pre-study guide](../pre-study.md) | [Syllabus](../syllabus.md)

## Roadmap — 48 school hours

A normal teaching date is two 90-minute slots = **4 school hours**; Dec 14 is three slots = **8 school hours**. The [syllabus explains the school-hour count](../syllabus.md#course-load--credits).

| Module | Date | Hands-on focus |
|:---:|---|---|
| [Module 0 — Pre-study](../pre-study.md) | before Fri 2026-11-06 | Portfolio, network mental model, MQTT discovery: packet journey, IP/subnet exploration, first MQTT publish/subscribe. |
| [Module 1](./01-foundations-and-masterclass.md) | Fri 2026-11-06 | Foundations & Master Class: class opening, OSI vs. TCP/IP critique, packet-overhead measurement, Master Class integration (M5StickC + MQTT + Node-RED + dashboard), story pitch. |
| [Module 2](./02-local-networking-and-gateways.md) | Fri 2026-11-13 | Local Networking, TCP/IP & OpenWrt: IPv4 subnetting, DHCP, DNS, NAT, routing tables, OpenWrt flash and extroot, LuCI/SSH, 2.4 GHz pod LAN, local Mosquitto, `tcpdump` at the choke point. |
| [Module 3](./03-overlay-and-mesh-networks.md) | Fri 2026-11-20 | Overlay Networks: Nebula bundle, cross-NAT proof, router gateway, Node-RED on the Optiplex cluster, MQTT through the overlay. |
| [Module 4](./04-mqtt-and-integration.md) | Fri 2026-11-27 | MQTT Deep Dive & Integration: topic hierarchy, QoS 0/1/2, Retain, Last Will, MQTT vs CoAP/HTTP, Node-RED, Python `paho-mqtt` / IoTknit and MicroPython on the router. |
| [Module 5](./05-wireless-technologies-and-espnow.md) | Fri 2026-12-04 | Wireless Technologies & ESP-NOW: radio spectrum, ISM bands, Wi-Fi vs. BLE vs. LoRaWAN, ESP-NOW action frames and gateway bridge. |
| [Module 6](./06-industrial-protocols-and-bridging.md) | Fri 2026-12-11, first slot | Industrial Protocols & Edge Bridging: short fieldbus briefing, Modbus/OPC-UA/RS-485 overview, ISO/OSI mapping and bus comparison, RS-485/Modbus demo, EtherCAT guest slot; optional Python wrapper. |
| [Module 7](./07-fleet-management-and-iotempower.md) | Mon 2026-12-14, P slot | Fleet clinic: declarative node configuration, one OTA deployment, one recovery; topic/canary work moves into the project. |
| [Module 8](./08-final-project-studio.md) | Dec 11 second slot; Dec 14 BS slots; Dec 15, 18, 21 | Final Project Studio: kickoff and story, multi-node integration, resilience testing, peer review rehearsal. |
| [Module 9](./09-project-presentation-and-portfolio.md) | Tue 2026-12-22 | Project Presentation & Technical Report Submission: short presentation, live multi-node demo, network fault-injection test, report hand-in. |
| [Prompt bank](./Y-resources-prompt-bank.md) | — | Supplementary: reflection prompts, LLM-verification drills, quick references. |
| [Resource bank](./Z-resources-bank.md) | — | Supplementary: RFCs, cheat sheets, Git/GitHub primer, story canon, troubleshooting, instructor hints. |

## What changed, and why

| Legacy emphasis | This course's emphasis | Reason |
|---|---|---|
| The seven-layer OSI model as the organizing principle | TCP/IP in practice, with OSI as a reference dictionary | Real IoT systems optimize across layers; the model helps you name a problem, not design a product. |
| Packet-header arithmetic on paper | Capture, measure, and explain real traffic | A packet capture is evidence; a memorized header diagram is not. |
| A single router and a flat subnet | Edge routing, NAT, and the Nebula overlay | Devices live behind CGNAT, campus firewalls, and changing WAN addresses. |
| Request/response HTTP for everything | Publish/subscribe with MQTT, QoS, Retain, and LWT | Decoupling producers from consumers is what makes IoT systems scale. |
| Wi-Fi as the default radio | A deliberate choice among Wi-Fi, BLE, LoRaWAN, and ESP-NOW | Range, latency, power, and payload are trade-offs you measure. |
| Manual, one-off firmware updates | Declarative fleet management with IoTempower and OTA | A fleet is not a pile of one-off prototypes. |
| A fixed, lecture-scripted syllabus | A moving bar with fixed learning goals and ★/◇ task tiers | The class is new; goals stay stable while tasks move with the cohort. |
| An exam that rewards recall | A portfolio and checkpoints that prove the goals | Evidence over task-completion: students prove goals, not tick boxes. |
| AI as an oracle | AI as a drafting tool that must be verified | Verification against a capture, a routing table, or a live test is the skill. |

> **Sources for these shifts.** The engineering-first stance is documented in the [resource bank](./Z-resources-bank.md#extended-reading), together with the RFCs and the [story canon](./Z-resources-bank.md#story-canon-the-recurring-cast).

## Assessment

Assessment — how the points are earned, the checkpoints, the reflection format, the task tiers, and the grade scale — is defined **only** in the [syllabus](../syllabus.md#assessment-hausarbeit-20-points).
