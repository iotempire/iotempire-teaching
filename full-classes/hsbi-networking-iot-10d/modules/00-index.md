# Networking and IoT Solutions — Module Index & Roadmap

[← Course workbook](../README.md) | [Pre-study guide](../pre-study.md) | [Syllabus](../syllabus.md)

## Session roadmap (10 days, one module per day)

| Module | Day | Modern studio | Hands-on focus |
|:---:|:---:|---|---|
| [Module 0 — Pre-study](../pre-study.md) | Before Day 1 | Portfolio, network mental model, MQTT discovery | Packet journey, IP/subnet exploration, first MQTT publish/subscribe. |
| [Module 1](./01-foundations-and-masterclass.md) | Day 1 | Foundations & Master Class: The IoT Computing Continuum | OSI vs. TCP/IP critique, packet-overhead measurement, Master Class integration (M5Stack + MQTT + Node-RED). |
| [Module 2](./02-local-networking-and-gateways.md) | Day 2 | Local Networking, TCP/IP & OpenWrt Gateways | IPv4 subnetting, DHCP, DNS, NAT, routing tables, OpenWrt LuCI/SSH, Wireshark & `tcpdump`. |
| [Module 3](./03-overlay-and-mesh-networks.md) | Day 3 | Mesh & Overlay Networks: Nebula, Yggdrasil & B.A.T.M.A.N. | Nebula overlay remote access, Yggdrasil IPv6 mesh, optional B.A.T.M.A.N. Layer-2 mesh stretcher. |
| [Module 4](./04-mqtt-and-integration.md) | Day 4 | MQTT Deep Dive & Integration **+ Checkpoint 1** | Topic hierarchy, QoS 0/1/2, Retain, Last Will, Node-RED flows, Python `paho-mqtt` / IoTknit. |
| [Module 5](./05-wireless-technologies-and-espnow.md) | Day 5 | Wireless Technologies & ESP-NOW Micro-Networking | Radio spectrum, ISM bands, Wi-Fi vs. BLE vs. LoRaWAN, ESP-NOW action frames and gateway bridge. |
| [Module 6](./06-industrial-protocols-and-bridging.md) | Day 6 | Industrial Protocols & Edge Bridging | Modbus/OPC-UA/RS-485 overview, TSN context; optional simulated edge bridge. |
| [Module 7](./07-fleet-management-and-iotempower.md) | Day 7 | Fleet Management & Scaling with IoTempower | Declarative node configuration, Over-The-Air (OTA) flashing, M5Stack fleet scaling. |
| [Module 8](./08-final-project-studio.md) | Days 8–9 | Final Project Studio **+ Checkpoint 2** | Project kickoff and story, multi-node integration, resilience testing, peer review rehearsal. |
| [Module 9](./09-project-presentation-and-portfolio.md) | Day 10 | Project Presentation & Portfolio Submission | Short project presentation of the final portfolio-report section, live multi-node demonstration, network fault-injection test, report hand-in. |
| [Prompt bank](./Y-resources-prompt-bank.md) | — | Supplementary | Reflection prompts, LLM-verification drills, quick references. |
| [Resource bank](./Z-resources-bank.md) | — | Supplementary | RFCs, cheat sheets, Git/GitHub primer, story canon, troubleshooting, instructor hints. |

## What changed, and why

| Legacy emphasis | This course's emphasis | Reason |
|---|---|---|
| The seven-layer OSI model as the organizing principle | TCP/IP in practice, with OSI as a reference dictionary | Real IoT systems optimize across layers; the model helps you name a problem, not design a product. |
| Packet-header arithmetic on paper | Capture, measure, and explain real traffic | A packet capture is evidence; a memorized header diagram is not. |
| A single router and a flat subnet | Edge routing, NAT, overlays, and mesh | Devices live behind CGNAT, campus firewalls, and changing WAN addresses. |
| Request/response HTTP for everything | Publish/subscribe with MQTT, QoS, Retain, and LWT | Decoupling producers from consumers is what makes IoT systems scale. |
| Wi-Fi as the default radio | A deliberate choice among Wi-Fi, BLE, LoRaWAN, and ESP-NOW | Range, latency, power, and payload are trade-offs you measure. |
| Manual, one-off firmware updates | Declarative fleet management with IoTempower and OTA | A fleet is not a pile of one-off prototypes. |
| A fixed, lecture-scripted syllabus | A moving bar with fixed learning goals and ★/◇ task tiers | The class is new; goals stay stable while tasks move with the cohort. |
| An exam that rewards recall | A portfolio and checkpoints that prove the goals | Evidence over task-completion: students prove goals, not tick boxes. |
| AI as an oracle | AI as a drafting tool that must be verified | Verification against a capture, a routing table, or a live test is the skill. |

> **Sources for these shifts.** The engineering-first stance is documented in the [resource bank](./Z-resources-bank.md#extended-reading), together with the RFCs and the [story canon](./Z-resources-bank.md#story-canon-the-recurring-cast).

## Assessment

Assessment — how the points are earned, the checkpoints, the reflection format, the task tiers, and the grade scale — is defined **only** in the [syllabus](../syllabus.md#assessment-large-homework-20-base-points--bonus).
