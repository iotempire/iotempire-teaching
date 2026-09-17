# Module 1 – Foundations & The Master Class: The IoT Computing Continuum

[← Back to front page](../README.md) | [Quick module index](./00-index.md) | [Next: Module 2 →](./02-local-networking-and-gateways.md)

---

## 📌 Module Outcomes
By the end of this session, you will:
1. Understand the **course philosophy, workflow, and portfolio-based assessment**.
2. Critically analyze the **ISO/OSI 7-layer model vs. real-world TCP/IP** in IoT systems (referencing RFC 3439 and RFC 1958).
3. Complete the **Master Class hands-on integration**: connect an M5Stack edge node to a local MQTT broker and visualize live data on a Node-RED dashboard.
4. Craft an **IoT system story** with clear stakeholder needs and interfaces across the computing continuum.

---

## 📖 Context & Concepts

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
- **Header Overhead ("Tax"):** If an edge sensor only publishes a 4-byte floating-point temperature, wrapping it in JSON (Presentation), MQTT (Application/Session), TLS (Presentation), TCP (Transport), IPv6 (Network), and Wi-Fi 802.11 (Data Link) inflates the packet by hundreds of bytes. On battery-powered nodes, radio transmission accounts for >90% of energy consumption!
- **Cross-Layer Optimization:** IoT protocols frequently bypass traditional layers. For instance, **ESP-NOW** injects vendor-specific action frames directly into IEEE 802.11 Layer 2 without IP or TCP; **CoAP** integrates reliability directly over UDP; and **B.A.T.M.A.N. advanced** handles multi-hop routing at Layer 2.
- **The End-to-End Principle (RFC 1958 & RFC 3439 "Layering Considered Harmful"):** Reliability and intelligence belong at the communication endpoints, not inside intermediate network nodes.

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

---

## 🛠️ In-Class Lab & Master Class

### Hardware Issued Today:
- **1× OpenWrt Travel Router** (e.g. GL.iNet) per 2 students (pre-configured with Mosquitto broker and Node-RED on `192.168.8.1`).
- **1× M5Stack Node** (e.g. M5StickC Plus or M5Atom Matrix) per student with Grove environmental sensor or onboard IMU.
- USB-C cable.

---

### Task 1: The Master Class Integration Sprint (45 min)
The goal of Day 1 is to experience the complete end-to-end loop immediately without low-level breadboard debugging.

1. **Power Up the Gateway:**
   - Plug the OpenWrt router into USB power.
   - Connect your laptop to the router's Wi-Fi network (e.g. `IoTempire-Lab` or `GL-iNet-xxxx`) or via Ethernet.
   - Open your browser and navigate to the OpenWrt dashboard: `http://192.168.8.1`.
2. **Access Node-RED:**
   - Navigate to `http://192.168.8.1:1880`.
   - Import the starter flow: [`01-hello-mqtt.json`](./flows/01-hello-mqtt.json).
   - Notice the MQTT input node subscribed to `iot/+/env`.
3. **Power On the M5Stack Node:**
   - Turn on your M5StickC/M5Atom node (pre-flashed with starter firmware).
   - Verify on the device display (or serial console at 115200 baud) that it connects to Wi-Fi and begins publishing to `iot/<node_id>/env`.
4. **Live Visualization:**
   - Watch the debug tab and dashboard (`http://192.168.8.1:1880/ui`) update with live sensor telemetry!
   - *Portfolio Evidence:* Take a screenshot of the Node-RED flow receiving live packets from your M5Stack node.

---

### Task 2: The Layering & Overhead Friction Challenge (30 min)
*Work in pairs with Wireshark.*

1. Start Wireshark on your laptop listening on the Wi-Fi/Ethernet interface.
2. Filter for `mqtt` or `tcp.port == 1883`.
3. Capture at least 5 telemetry packets published by your M5Stack node.
4. **Analyze the Packet Breakdown:**
   - Frame (Layer 1/2 total wire length)
   - Ethernet / 802.11 Header
   - IPv4 Header (20 bytes)
   - TCP Header (20–32 bytes)
   - MQTT Header + Topic string + Payload
5. **Calculate the Overhead Ratio:**
   $$\text{Overhead Ratio} = \frac{\text{Total Frame Size} - \text{Payload Size}}{\text{Payload Size}}$$
6. Discuss with your partner: If this node is powered by a 100 mAh coin cell and publishes every 5 seconds, how much energy is spent transmitting protocol metadata vs. actual sensor data?

---

### Task 3: System Storytelling & Architecture Sketch (30 min)
Craft a 2-minute system story for a multi-node IoT deployment:
- **The Persona & Problem:** Who needs this information? (e.g. cold-chain food transporter, hospital ward, smart greenhouse).
- **The Devices:** What physical M5Stack nodes gather data, where is the OpenWrt router placed, and where does the integrator run?
- **Draw the Continuum:** Draw a simple block diagram showing:
  `Sensor Node -> Wi-Fi/ESP-NOW -> Router Gateway (MQTT Broker) -> Node-RED -> Dashboard / Alerting`.

---

## 📝 Working-Day Reflection & Portfolio Tasks

In your personal GitHub portfolio, commit an entry under `modules/01-foundations/`:
1. **Node-RED & Packet Proof:** Screenshot of your working Node-RED dashboard and your Wireshark packet capture showing the MQTT publish payload.
2. **Overhead Calculation:** Your calculation of header overhead vs. sensor payload.
3. **OSI Critique Reflection:** Write 1–2 paragraphs explaining why rigid 7-layer OSI models struggle in IoT systems, referencing RFC 3439.
4. **System Story:** Your 2-minute project concept and architectural block diagram.
