# Portfolio Prompts Bank – Networking and IoT Solutions

*Use these prompts to guide your reflections and portfolio entries. You may choose any 3–5 prompts per module (mixing technical, project context, and process reflections). Write 1–2 paragraphs per answer; include screenshots, packet logs, or code snippets where relevant.*

[← Back to Module Index](./00-index.md) | [Back to Resources Bank](./Z-resources-bank.md)

## 📌 Module 1 – Foundations & The Master Class
*Focus: OSI vs. TCP/IP reality, overhead tax, system storytelling, Master Class integration.*

1. Technical: *How did the packet trace challenge your view of the OSI 7-layer model?* Where did real-world protocols (like Wi-Fi, TLS, or MQTT) clash with rigid textbook boundaries? Share a Wireshark screenshot illustrating the overlap.
2. Technical: *Calculate the overhead tax:* What was the ratio of headers and protocol metadata to actual sensor payload in your capture? What does this mean for battery-powered nodes?
3. Project Context: *Grandma-Level System Story:* Explain your final project idea in one jargon-free paragraph. Who uses it, what problem does it solve, and why does it need a network?
4. Process: *Master Class First Impressions:* What was the smoothest part of getting the M5Stack node talking to Node-RED on Day 1? Where did you or your peer get stuck?

## 📌 Module 2 – Local Networking & OpenWrt Gateways
*Focus: IPv4 subnetting, DHCP DORA, ARP, NAT masquerading, tcpdump on OpenWrt.*

1. Technical: *Dissecting DORA:* Show a Wireshark capture of a DHCP exchange. What information is conveyed in each step, and what happens if two DHCP servers respond on the same subnet?
2. Technical: *NAT and Port Forwarding:* Why can a client behind the OpenWrt router reach the Internet, but an outside computer cannot initiate a connection to an internal M5Stack node without port forwarding?
3. Process: *Router Debugging via CLI:* What was your most useful discovery when administering OpenWrt over SSH (`uci`, `ip route`, `brctl`, or `tcpdump`)?
4. Project Context: *Edge vs. Cloud:* Why run the Mosquitto broker and DHCP locally on the OpenWrt router instead of pointing every sensor directly to a public cloud broker?

## 📌 Module 3 – Mesh & Overlay Networks (Nebula, Yggdrasil & B.A.T.M.A.N.)
*Focus: NAT traversal, Nebula lighthouse, UDP hole punching, Yggdrasil encrypted IPv6, and the concepts of Layer-2 mesh routing and failover (B.A.T.M.A.N. prompts 5–8 are optional stretchers).*

1. Technical: *Nebula vs. Port Forwarding:* How does Nebula’s lighthouse enable two nodes behind restrictive firewalls or Carrier-Grade NAT (CGNAT) to establish a direct, encrypted tunnel?
2. Technical: *Decentralized Routing with Yggdrasil:* What makes Yggdrasil's cryptographic IPv6 addressing and tree routing fundamentally different from classical IP routing?
3. Project Context: *Work-From-Home Workflow:* How did deploying Nebula or Yggdrasil change how you access and debug your lab gateway outside the classroom?
4. Process: *Certificate and Key Management:* What security risks arise if an overlay node certificate or private key is leaked? How does Nebula isolate compromise?
5. Technical: *Layer-2 vs. Layer-3 Mesh:* Why does `batman-adv` emulate a virtual Ethernet switch (`bat0`) rather than running an IP routing protocol like OSPF? What are the benefits and broadcast risks?
6. Technical: *OGMs and Link Quality:* How does B.A.T.M.A.N. measure Transmit Quality (TQ) using Originator Messages, and how does it select the best next-hop neighbor?
7. Hybrid: *The Link-Drop Experiment:* Document what happened to live traffic when an intermediate router was powered down. How many seconds did convergence take?
8. Project Context: *Autonomous Infrastructure:* How could an ad-hoc router mesh be deployed in disaster response, agriculture, or temporary construction sites without internet access?

## 📌 Module 4 – Application Messaging: MQTT Deep Dive & Integration
*Focus: Pub/Sub decoupling, QoS levels, retained states, LWT, Node-RED flows, Python integration.*

1. Technical: *LWT Detection:* What happens at the TCP socket and broker level when an M5Stack node is unplugged? How long did it take for the broker to publish the Last Will message?
2. Technical: *QoS Trade-offs:* Compare QoS 0, 1, and 2 in terms of packet exchange overhead, latency, and duplicate message risk. When is QoS 0 acceptable, and when is QoS 1 essential?
3. Hybrid: *Mocking vs. Reality:* Compare your mock Python publisher with the real M5Stack node. Did Node-RED or your downstream subscriber need any code changes to handle the swap?
4. Process: *Integration Architecture:* When do you choose Node-RED for visual orchestration vs. writing a custom Python service (`paho-mqtt` / IoTknit)?

## 📌 Module 5 – Wireless Technologies & ESP-NOW Micro-Networking
*Focus: Radio spectrum, 2.4 GHz vs Sub-GHz, connectionless action frames, gateway bridging.*

1. Technical: *The ESP-NOW Speed Advantage:* Why does an ESP-NOW packet transmit in <3 ms while standard Wi-Fi takes several seconds to associate and authenticate?
2. Technical: *Dual-Mode Bridging:* How does an M5Stack node receive raw ESP-NOW action frames on Channel 6 and simultaneously publish them over standard Wi-Fi to Mosquitto?
3. Project Context: *Spectrum Selection:* In what scenario would you choose Sub-GHz LoRaWAN over 2.4 GHz Wi-Fi/ESP-NOW? Consider range, payload limits, and duty-cycle regulations.
4. Process: *Interference and RSSI:* How did moving across the room or encountering Wi-Fi channel congestion affect packet delivery and signal strength?

## 📌 Module 6 – Industrial Protocols & Edge Bridging
*Focus: Modbus RTU/TCP, OPC-UA information model, TSN context, edge translation (mostly conceptual; hands-on optional).*

1. Technical: *Translating Semantic Worlds:* Contrast Modbus 16-bit register addresses with OPC-UA structured object nodes and MQTT JSON topics. What are the key friction points when bridging between them?
2. Technical: *Real-Time Constraints:* Why is standard Ethernet non-deterministic, and how does Time-Sensitive Networking (TSN) guarantee microsecond latency for factory motion control?
3. Hybrid: *Edge Bridge Design:* Walk through your Python or Node-RED bridge script. How does it handle polling intervals, timeouts, and register-to-JSON formatting?
4. Project Context: *Brownfield Integration:* If a factory manager forbids touching their certified PLC code, how does an external edge bridge allow non-invasive IoT monitoring?

## 📌 Module 7 – Fleet Management & Scaling with IoTempower
*Focus: Declarative configuration, `setup.cpp`, Over-The-Air (OTA) updates, M5Stack fleet scaling.*

1. Technical: *Declarative vs. Imperative:* Contrast writing a raw Arduino C++ sketch with declaring sensors and actuators in IoTempower's `setup.cpp`. What boilerplate code disappears?
2. Technical: *OTA Mechanics:* How does IoTempower discover devices on the network and flash new firmware wirelessly? What safety checks prevent bricking a remote node?
3. Project Context: *Fleet Namespace Standardisation:* Why is a standardized topic convention (e.g. `<node>/<device>/set` and `<node>/<device>`) critical when scaling to dozens of nodes?
4. Process: *Deployment Ergonomics:* How did OTA flashing improve your iteration speed compared to plugging and unplugging USB-C cables?

## 📌 Module 8 – Final Project Studio
*Focus: Multi-node architecture, fault injection, stress testing, peer review rehearsal.*

1. Technical: *Failure Mode Analysis:* Document your three fault-injection tests (Link Drop, Node Power Loss, Broker Restart). Did the system fail gracefully, and what did you refactor?
2. Project Context: *Architecture Defense:* Defend your end-to-end continuum: Why is each node, router, mesh link, and overlay tunnel positioned where it is?
3. Process: *Peer Review Value:* What blind spot in your project did your peer review team identify during the dry run, and how did you address it before the final defense?

## 📌 Module 9 – Final Project Demonstrations & Portfolio Defense
*Focus: Live demonstration, technical defense, retrospective.*

1. Technical: *The Live Demo:* Summarize how your system performed during the live demonstration and fault-injection challenge before the class.
2. Personal Retrospective: *The Biggest "Aha!" Moment:* Across the entire 10-day journey from OSI critique to overlay mesh and IoTempower fleet management, what was your single most valuable technical realization?
3. Looking Ahead: How will you apply the networking and integration principles learned here in future projects or in the elective *Sensorik und Aktorik*?
