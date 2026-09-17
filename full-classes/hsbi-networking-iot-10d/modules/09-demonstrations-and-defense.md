# Module 9 – Capstone Demonstrations & Portfolio Defense

[← Back to Module 8](./08-capstone-project-studio.md) | [Quick module index](./00-index.md)

---

## 📌 Module Outcomes
By the end of this session, you will:
1. Deliver a compelling **5-minute live demonstration** of your end-to-end networked IoT capstone system.
2. Defend your architectural choices, protocol trade-offs, and resilience mechanisms before instructors and peers.
3. Complete the **portfolio evaluation and assessment defense**.
4. Reflect on your learning journey from abstract textbook layering to real-world edge networking and fleet management.

---

## 🛠️ In-Class Demo & Defense Procedure

*Format: 5-minute presentation + 3-minute live interaction / fault injection + 2-minute Q&A per team.*

---

### Demonstration Script Guidelines (5 min)

1. **System Story & Problem Context (1 min):**
   - Who uses this system? What real-world problem does it solve?
2. **Network Topology & Architectural Defense (2 min):**
   - Walk through the physical and virtual topology: M5Stack nodes, OpenWrt router, optional B.A.T.M.A.N. mesh, Nebula/Yggdrasil overlay, and MQTT broker.
   - Justify your protocol choices: Why ESP-NOW instead of Wi-Fi for node X? Why MQTT instead of HTTP? How does the overlay provide remote access?
3. **Live Demonstration (2 min):**
   - Demonstrate real physical sensor input propagating across the network to triggers, actuators, and dashboards.
   - Demonstrate an Over-The-Air (OTA) update or declarative reconfiguration using IoTempower.
4. **Live Fault Injection (Instructor Challenge):**
   - The instructor or a peer will test the resilience of your system (e.g. pulling power on an intermediate mesh router or disconnecting a Wi-Fi link).
   - Show how the system degrades gracefully, re-routes, or recovers automatically.

---

## 📋 Capstone Assessment Rubric (5 Points)

| Criteria | Max Points | Expectations |
|---|:---:|---|
| **System Functionality & Resilience** | **2.0 pts** | System fulfills all must-haves: 4+ nodes, 2+ network layers, MQTT pub/sub, integration engine (Node-RED/Python), and IoTempower OTA. Graceful recovery under fault injection. |
| **Architecture & Engineering Metrics** | **1.5 pts** | Clear network diagram, IP/topic documentation, Wireshark packet captures, latency/overhead analysis, and clean Git commits in portfolio. |
| **Live Presentation & Technical Defense** | **1.5 pts** | Clear, fluent demonstration; confident explanation of networking trade-offs; thoughtful answers to technical questions. |

---

## 📝 Final Portfolio Submission Checklist

Ensure your personal GitHub portfolio includes all required evidence before final submission:
- [ ] **Module 0:** Pre-study notes, initial network exploration, and answers to guiding questions.
- [ ] **Module 1:** Node-RED hello-world screenshot, Wireshark packet capture, and OSI critique reflection.
- [ ] **Module 2:** OpenWrt setup, network topology diagram, DHCP/ARP captures, and NAT/port forwarding test.
- [ ] **Module 3:** Nebula overlay setup, cross-NAT ping/SSH proof, Yggdrasil comparison, plus OpenWrt B.A.T.M.A.N. advanced configuration, `batctl` originator tables, and mesh failover report.
- [ ] **Module 4:** MQTT QoS, Retain, LWT analysis, Node-RED flows (`.json`), and Python/IoTknit integration scripts.
- [ ] **Module 5:** Wireless comparison table, ESP-NOW peer-to-peer code, and ESP-NOW to MQTT gateway bridge proof.
- [ ] **Module 6:** Industrial protocol analysis, simulated Modbus/OPC-UA server, and edge bridge implementation.
- [ ] **Module 7:** IoTempower declarative node configuration (`setup.cpp`), OTA deployment logs, and fleet integration.
- [ ] **Modules 8 & 9:** Capstone architecture diagrams, fault-injection test logs, presentation slides/script, and final course retrospective.
- [ ] **Working-Day Reflections:** Complete entries for every working day.

---

## 🎓 Course Retrospective & What's Next

Congratulations on completing **Networking and IoT Solutions**!

You have developed a deep, practical mastery of:
- **Network Reality over Dogma:** Moving from rigid 7-layer diagrams to pragmatic TCP/IP, Layer-2 action frames (ESP-NOW), and kernel mesh routing (`batman-adv`).
- **Software-Defined Edge Networking:** Deploying modern overlays (Nebula, Yggdrasil) that make devices accessible anywhere without fragile port forwarding.
- **Robust Asynchronous Systems:** Decoupled messaging with MQTT, resilient integrations with Node-RED and Python, and industrial interoperability with OPC-UA and Modbus.
- **Fleet-Scale Thinking:** Managing hardware fleets declaratively with IoTempower.

### Next Steps:
- Continue exploring the IoTempire ecosystem: [iotempire.net](https://iotempire.net/) and [github.com/iotempire/iotempower](https://github.com/iotempire/iotempower).
- In the companion course **Sensorik und Aktorik**, you will dive deeper into analog and digital sensor physics, signal conditioning, error calculations, and building custom sensing hardware.
