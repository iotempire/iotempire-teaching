# Pre-Study Guide: Networking and IoT Solutions

Welcome to **Networking and IoT Solutions (Vernetzung und IoT-Lösungen)! 

In this course, we move beyond isolated microcontrollers and rigid textbook abstractions to build **real, resilient, interconnected IoT networks**:
- M5Stack edge nodes communicating locally via Wi-Fi and **ESP-NOW**.
- Dedicated OpenWrt travel routers running local DHCP, DNS, routing, and **B.A.T.M.A.N.** Layer-2 meshes.
- Zero-friction overlay networks with **Nebula** and **Yggdrasil** allowing you to access your devices seamlessly across campus firewalls or from home.
- Message routing and fleet integration with **MQTT**, **Node-RED**, **Python** (`paho-mqtt` / **IoTknit**), and **IoTempower**.
- Industrial bridges connecting **OPC-UA** and **Modbus** into the modern IoT fabric.

See the [syllabus](./syllabus.md) for the complete course schedule and policies.

> **Canonical source:** [IoTempire Teaching repository — HSBI/GT Networking and IoT Solutions](https://github.com/iotempire/iotempire-teaching/tree/main/full-classes/hsbi-networking-iot-10d)

> [!NOTE]
> **Language:** This course is taught in English and German; the written materials are in English. You may freely use German, English, or a mixture in class and in your portfolio documentation.
>
> **Für deutschsprachige Studierende:** Diese Lehrveranstaltung wird auf Englisch und Deutsch unterrichtet; die gemeinsamen Materialien bleiben auf Englisch. Sie können im Unterricht und für Ihr Portfolio Deutsch, Englisch oder eine Mischung aus beidem verwenden.

> [!IMPORTANT]
> **Required Module 0 — 1 Module Point:** Before the first session, create your personal portfolio from the [course Git template](https://github.com/iotempire/iot-portfolio-template) and add a first pre-study entry. Include notes responding to Guiding Questions 1–5 and terminal/browser evidence from the hands-on discovery. Module 0 is assessed during the second session.
>
> **Preparation time:** Plan approximately **3 to 6 hours** for this guide. You need no special hardware—only your laptop and an internet connection.

> [!NOTE]
> **This is the first time we run this**, so please keep your eyes open. The **main class is still in flux** and may even change based on what you experience here. Take notes as you go: anything that felt **strange**, tasks that seem **unnecessary for the main class**, or anything you found **missing**. Please share those notes with me — they directly shape the class.

---

## 1. IoT Systems & Networking — The Big Picture

In classical networking, the focus is often on client-server connections (a browser downloading a web page). In modern IoT, systems are distributed, decentralized, and asynchronous:

```text
[M5Stack Edge Nodes]  --(ESP-NOW / Wi-Fi)-->  [OpenWrt Router / Gateway]
         |                                                 |
         |                                      (Local Mosquitto MQTT Broker)
         |                                                 |
         +-------(Nebula / Yggdrasil Overlay)--------------+
                                |
                   [Node-RED / Python Integrator]
                                |
             [Dashboards / Industrial OPC-UA / Cloud]
```

Key architectural concepts to grasp early:
- **Local-First Architecture:** Devices talk to a local gateway. The system must continue operating even if the external internet connection drops.
- **Decoupling via Pub/Sub:** Sensors do not make direct TCP connections to every subscriber; they publish lightweight messages to an MQTT broker, which fans them out.
- **Overlays over Firewalls:** Instead of tedious port forwarding or risky public IPs, modern mesh overlays (**Nebula**, **Yggdrasil**) create secure, flat, end-to-end encrypted networks across any firewall or NAT.

---

## 2. Required Preparation: Watch & Explore

Complete these steps and document your findings in your portfolio:

### Step A: Inspiration (10 min)
1. Watch **["Teaching the IoTempower Way"](https://video.iotempower.us)** (the IoTempower inspiration video, about 1–2 minutes, dense and fast-paced).
2. Note what excites you. What kind of distributed system, smart environment, or networked automation would you love to build?

### Step B: The Journey of a Packet (≈40 min)
1. Watch the first module of **[How Data Moves Through the Internet](https://www.practicalnetworking.net/index/networking-fundamentals-how-data-moves-through-the-internet/)** by Ed Harmoush (short lessons, numbered `1a`, `1b`, `2a`, …). For this pre-study, watch **at least these three**:
   - **Lesson 1a — Network Devices: Hosts, IP Addresses, Networks**
   - **Lesson 1b — Network Devices: Repeaters, Hubs, Bridges, Switches, Routers**
   - **Lesson 2a — OSI Model: Layers 1, 2, 3**

   If you want the complete picture (recommended, roughly 30 min more), continue with **Lesson 2b — OSI Model: Layers 4 and 5/6/7, Encapsulation/De-Encapsulation**, and then **Lessons 3a and 3b — what hosts do when speaking to hosts on the *same* vs. a *foreign* network**. Lessons 3a/3b are the actual "journey of a packet" and the best preparation for Day 1. (A similar concise review of IP routing and encapsulation is fine too if you prefer another source.)
2. Note why practical network engineers usually work with the **TCP/IP 4-layer model** rather than the theoretical 7-layer OSI model.

### Step C: Hands-on Network Discovery on Your Laptop (30 min)
Open your terminal (Linux/macOS terminal, or WSL/PowerShell on Windows) and inspect your current network stack:

1. **Find your local IP and Default Gateway:**
   - Linux: `ip addr` and `ip route`
   - macOS: `ifconfig` and `netstat -nr`
   - Windows: `ipconfig /all` and `route print`
   - *Question:* What is your IP address? What is the subnet mask (or CIDR notation)? What is the IP of your home router (the default gateway)?
2. **Trace the Path:**
   - Run `traceroute 1.1.1.1` (or `tracert 1.1.1.1` on Windows).
   - How many router hops does your packet take before reaching Cloudflare's DNS? Notice where private IP addresses (RFC 1918, e.g. `192.168.x.x` or `10.x.x.x`) transition to public IPs.
3. **Inspect MQTT in Action (15 min):**
   - You do not need to install a broker yet. Use an MQTT client like **MQTTX** (download from [mqttx.app](https://mqttx.app)), `mosquitto_sub`/`mosquitto_pub` via CLI, or an online web client (e.g. [HiveMQ Web Client](https://www.hivemq.com/demos/websocket-client/)).
   - Connect to the public test broker `broker.hivemq.com` (port 1883, or port 8000 for WebSockets).
   - Choose a short **pseudonym or random ID** — do **not** use your real name; this broker is public. Subscribe to a unique topic such as `hsbi/student/<pseudonym-or-random-id>/test`.
   - Publish a message like `{"status": "online", "message": "Hello Vernetzung!"}` to that topic and verify that your subscriber receives it immediately.
   - Take a screenshot of the received message for your portfolio!

---

## 3. Guiding Questions for Your Portfolio

Answer these questions in your portfolio under `pre-study/README.md` (or `00-pre-study.md`):

1. **The Core Story:** Based on the IoTempower inspiration video, describe one IoT scenario you find compelling. Who uses it, and what devices need to communicate?
2. **Addressing & Subnetting:** Explain in your own words what an IP address and a subnet mask are. Why can't two devices on the same local subnet have the same IP?
3. **OSI vs. TCP/IP Reality:** The ISO/OSI model specifies 7 layers, while TCP/IP uses 4. In real-world IoT systems, why do rigid layer boundaries often break down or cause unnecessary overhead? (Hint: consider tiny sensor packets vs. large headers).
4. **Decoupling with Pub/Sub:** In a smart home with 10 temperature sensors and 3 displays, why is an MQTT broker more maintainable than each sensor opening direct HTTP connections to every display?
5. **Network Boundary Reflection:** When you work from home, can your laptop directly ping a device on a classmate's home Wi-Fi? Why or why not? What does a mesh overlay network like Nebula or Yggdrasil change about this?

---

## Ready for Day 1? Checklist

Before walking into the first lab session:
- [ ] You have created your personal GitHub portfolio from [iot-portfolio-template](https://github.com/iotempire/iot-portfolio-template).
- [ ] You have committed your pre-study notes, answers to the 5 guiding questions, and your MQTT screenshot.
- [ ] You have your laptop ready with Wi-Fi, an SSH client, and optionally Wireshark and MQTTX installed.
- [ ] You are ready to receive your OpenWrt router and M5Stack hardware kit!
