# Module 9 – Project Presentation & Portfolio Submission

[← Back to Module 8](./08-final-project-studio.md) | [Quick module index](./00-index.md)

**Course placement:** Day 10 — the final session. You present the last part of your **portfolio report** — the final project — and submit the complete report.

## 🎯 Learning Goals

This module gives you the opportunity to explore engineering communication and portfolio synthesis and achieve competency in presenting a networked system, explaining technical choices, and submitting a coherent report.

By the end of this module, you can:
1. Present the final project section of your portfolio report to instructors and peers.
2. Explain and justify your architectural choices, protocol trade-offs, and resilience mechanisms.
3. Submit a complete portfolio report that connects the module evidence, measurements, and reflections into one coherent document.
4. Reflect on your learning journey from abstract textbook layering to real-world edge networking and fleet management.

**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 📖 Story — The Night the Network Has to Hold

It is 3 a.m. in the operations centre. **Petra Sommer** is watching the dashboard; **Malik Yilmaz** is on the phone from a substation; the control room screen shows the last known state of every node. One router is down. The system has to say so clearly, keep the local loops running, and recover when the link returns.

Your final presentation is that night in miniature. You have a short slot: first show a multi-node system measuring, messaging, and acting, including one fault you inject on purpose; then explain the architecture and the trade-offs you own. The story gives you the *why*; the portfolio report, the packet captures, recovery times, and fault-injection log give you the *how do you know?*

## 🛠️ In-Class Presentation & Discussion Procedure

*The format, timing, and submission rules are set in the [syllabus](../syllabus.md#final-project-requirements-5-points); this page is the working script.*

### Presentation Script Guidelines

1. **System Story & Problem Context:** Who uses this system? What real-world problem does it solve?
2. **Network Topology & Architecture:** Walk through the physical and virtual topology — M5Stack nodes, OpenWrt router, optional B.A.T.M.A.N. mesh, Nebula/Yggdrasil overlay, and MQTT broker. Justify your protocol choices: Why ESP-NOW instead of Wi-Fi for node X? Why MQTT instead of HTTP? How does the overlay provide remote access?
3. **Live Demonstration:** Show real physical sensor input propagating across the network to triggers, actuators, and dashboards. Demonstrate an Over-The-Air (OTA) update or declarative reconfiguration using IoTempower.
4. **Live Fault Injection (Instructor Challenge):** The instructor or a peer tests the resilience of your system (e.g. pulling power on an intermediate mesh router or disconnecting a Wi-Fi link). Show how the system degrades gracefully, re-routes, or recovers automatically.
5. **Portfolio Report Walkthrough:** Open the last section of your report and show where the evidence lives — topology, captures, metrics, fault-injection results, and the reflection that ties the project together. Say what you would do next with another week.

## 📋 Where the Rubric Lives

The final project is assessed according to the [syllabus](../syllabus.md#final-project-requirements-5-points), and the rubric lives **only** there. This page is the working presentation script and evidence checklist; if the two ever disagree, the syllabus wins.

## ✅ Suggested portfolio evidence (proofs of the learning goals)

- [ ] Module 0: Pre-study notes, initial network exploration, and answers to guiding questions.
- [ ] Module 1: Node-RED hello-world screenshot, Wireshark packet capture, and OSI critique note.
- [ ] Module 2: OpenWrt setup, network topology diagram, DHCP/ARP captures, and NAT/port forwarding test.
- [ ] Module 3: Nebula overlay setup, cross-NAT ping/SSH proof, and Yggdrasil comparison (optional: B.A.T.M.A.N. `batctl` tables and mesh failover report).
- [ ] Module 4: MQTT QoS, Retain, LWT analysis, Node-RED flows (`.json`), and Python/IoTknit integration scripts.
- [ ] Module 5: Wireless comparison table, ESP-NOW peer-to-peer code, and ESP-NOW to MQTT gateway bridge proof.
- [ ] Module 6: Industrial protocol analysis (recommended); optional simulated Modbus/OPC-UA server and bridge.
- [ ] Module 7: IoTempower declarative node configuration (`setup.cpp`), OTA deployment logs, and fleet integration.
- [ ] Modules 8 & 9: The final project section of the portfolio report, architecture diagrams, fault-injection test logs, presentation slides/script, and final course retrospective.
- [ ] Reflection logbook entries for the teaching blocks, using the [reflection template](https://github.com/iotempire/iot-portfolio-template/blob/main/Reflections/TEMPLATE.md) in `Reflections/`.
- [ ] Where you did not work entirely alone: links to pod mates, sources, and borrowed configuration.

> [!IMPORTANT]
> Never commit secrets, credentials, private keys, `.venv/`, or packet captures containing personal traffic. Commit the configuration and the script that rebuilds your evidence.

## 🎓 Course Retrospective & What's Next

Congratulations on completing Networking and IoT Solutions!

You have developed a deep, practical mastery of:
- Network Reality over Dogma: Moving from rigid 7-layer diagrams to pragmatic TCP/IP, Layer-2 action frames (ESP-NOW), and kernel mesh routing (`batman-adv`).
- Software-Defined Edge Networking: Deploying modern overlays (Nebula, Yggdrasil) that make devices accessible anywhere without fragile port forwarding.
- Robust Asynchronous Systems: Decoupled messaging with MQTT, resilient integrations with Node-RED and Python, and an awareness of industrial interoperability (OPC-UA, Modbus).
- Fleet-Scale Thinking: Managing hardware fleets declaratively with IoTempower.

### Next Steps:
- Continue exploring the IoTempire ecosystem: [iotempire.net](https://iotempire.net/) and [github.com/iotempire/iotempower](https://github.com/iotempire/iotempower).
- If you are interested in the physical side, the elective Sensorik und Aktorik goes deeper into analog and digital sensor physics, signal conditioning, error calculations, and building custom sensing hardware.

## 📚 If you want to go deeper

- [Wikipedia: Story-driven modeling](https://en.wikipedia.org/wiki/Story-driven_modeling) — the method behind the project stories.
- [Wikipedia: Fault injection](https://en.wikipedia.org/wiki/Fault_injection) — the resilience test you will face live.
- [Wikipedia: Technical presentation](https://en.wikipedia.org/wiki/Technical_presentation) — structure, evidence, and time discipline.
- The [resource bank's instructor hints](./Z-resources-bank.md#instructor-hints) — how the presentation and discussion are run.

---

[← Previous: Module 8](./08-final-project-studio.md) | [Back to front page](../README.md) | [Quick module index](./00-index.md)
