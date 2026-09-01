# Networking and IoT Solutions Workbook

This workbook is the **front page** for the 10-11 day *IoT Networking* course taught at **Hochschule Bielefeld University of Applied Sciences and Arts (HSBI)**, Campus Gütersloh. The course is structured for regular delivery and over 10-11 days with 4 to 8 hours per meetup.


---

## Course Overview

- **Duration:** 10 weeks (one to two meetups per week, 4–8 hours).
- **Target Group:** Software Engineering and Digital Technologies students.
- **Workload:** 150 hours (5 ECTS).
- **Format:** Modular, self-driven learning with hands-on labs and project-based assessment.
- **Prerequisites:** Basic programming (C/Python), familiarity with Linux command line.
- **Software Stack:**
  - **MQTT Broker:** Mosquitto or EMQX
  - **IoT Devices:** ESP32 (Arduino framework), Raspberry Pi
  - **Networking Tools:** Wireshark, Tcpdump, MQTTX
  - **Version Control:** Git + GitHub/GitLab


---

## Learning Outcomes

By the end of this course, you will be able to:

1. **Use** TCP/IP and understand its role in IoT networks (without over-relying on the OSI model).
2. **Compare and contrast** wired vs. wireless communication technologies for IoT.
3. **Design and implement** IoT solutions using MQTT, HTTP, and explore alternative protocols like CoAP or raw sockets.
4. **Configure** IP networks, subnets, and routing for IoT devices.
5. **Measure and optimize** power efficiency and latency in IoT networks.
6. **Document and present** your IoT projects in a technical portfolio.

---

## Weekly Modules

Navigate the course using the links below. Each module includes:
- **Learning objectives** for the week.
- **Theory** (condensed reading + references).
- **Hands-on Labs** (practical exercises).
- **Reflection Questions** (for your portfolio).
- **Project Milestones** (if applicable).


### Core Modules

| **Week** | **Module Title**                          | **Focus Area**                                                                                     | **Pre-Class Video Resources**                                                                                                                                                     | **Key Activities**                                                                                     |
|----------|-------------------------------------------|---------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------|
| 1        | Introduction to IoT and Networking         | TCP/IP vs. OSI lenses, storytelling, portable repo setup, Node-RED warmup.                           | [Ed Harmoush: How data moves through the Internet (overview)](https://www.practicalnetworking.net/index/networking-fundamentals-how-data-moves-through-the-internet/) *(Guiding Qs: “Why do the first 3 videos matter?”)* | Lab: OSI friction exercise; Node-RED “hello-mqtt” dashboard.  |
| 2        | Networking from the Ground Up: **TCP/IP for IoT** | IP addressing, subnetting, VLANs, static IPs, port forwarding via OpenWRT gateway LuCI.            | [Ed Harmoush Subnetting Mastery playlist (videos 1–3)](https://www.practicalnetworking.net/stand-alone/subnetting-mastery/) | Lab: Reconfigure home router; measure ping latency `traceroute`.      |
| 3        | **MQTT and TCP in IoT**                   | Why MQTT rides TCP; latency debugging; MQTTX vs PubSubClient (Arduino/MQTT.js).                      | [MQTT for Beginners (2aHV2Fn0I60)](https://www.youtube.com/watch?v=2aHV2Fn0I60) *(guiding Q: “What’s pub/sub vs. HTTP?”)* + [Practical MQTT start (GhjYFJqJsmY)](https://www.youtube.com/watch?v=GhjYFJqJsmY) | Lab: Mosquitto broker + Node-RED mock swap.                  |
| 4        | **Wireless IoT Communication**            | WiFi, BLE, LoRaWAN trade-ffs (power, range, bandwidth).                                           | User playlist: [IoT playlist v2kV6pgJxuo (item 2)](https://www.youtube.com/watch?v=v2kV6pgJxuo&list=PLlppUpfgGsvkfAGJ38_mzQc1-_Z7bNOgq&index=2&pp=iAQB) + [jJaWMWz6RpE (item 3)](https://www.youtube.com/watch?v=jJaWMWz6RpE&list=PLlppUpfgGsvkfAGJ38_mzQc1-_Z7bNOgq&index=3&t=2s&pp=iAQB) | Lab: Profile WiFi vs LoRa; RSSI + power scatter CSV.              |
| 5        | **Protocol Exploration**                    | Compare MQTT vs. CoAP vs. HTTP vs. raw sockets – which fits which use case?                              | None; use RFCs or Week-3 MQTT intro videos.                                                                                                                                   | Lab: CoAP test in Node-RED.                                                                         |
| 6        | **Routing and Gateways**                    | IP routing, NAT, firewalls, OpenWRT gateway config (LuCI panel `http://192.168.8.1`).                | [Ed Harmoush “Everything Routers Do” vids 1–2](https://www.practicalnetworking.net/classes/network-fundamentals/) *(guiding Q: “Where does NAT lie in ISO-OSI?”)* | Lab: OpenWRT LuCI + NAT/Port forwarding; RTT `ping` tests.   |
| 7        | **(Optional) Industrial Protocols**        | OPC-UA vs. Modbus – bridging to legacy factory systems via gateway.                                    | None; docs: [python-opcua.readthedocs.io](https://python-opcua.readthedocs.io/), [pymodbus.readthedocs.io](https://pymodbus.readthedocs.io/en/latest/) | Lab: ESP32 OPC-UA client or Modbus sim.                    |
| 8        | **Power and Latency Optimization**          | Deep-sleep tuning, battery math, RTT profiling.                                                     | Watch [“WiFi vs LoRa” Paul Clark (Invensor)](https://www.youtube.com/watch?v=fFoRz2q2yqA) *(guiding Q: “How does latency determine protocol for coin-cell device?”)* | Lab: USB power meter CSV + sleep interval tuning.               |
| 9        | **Security in IoT Networks**                | TLS 1.3 for MQTT, cert pinning, auth.                                                               | Ed Harmoush [SSL/TLS overview video in course outline](https://classes.pracnet.net/courses/networking) *(free access)*                                              | Lab: Secure Mosquitto, Node-RED TLS + Node-RED chain.         |
| 10       | **Final Project Rehearsal**               | Dry-run demo, peer review rubric, portfolio finalization.                                            | None. Prepare your **3-min demo** and `.md` report.                                                                        | Lab: Peer feedback & video cut.                                                                     |

### Optional/Archival Modules

- [Module A – Historical Networking Protocols](./modules/A-historical-protocols.md) (e.g., X.25, Frame Relay)
- [Module B – Advanced IoT Topics](./modules/B-advanced-iot.md) (e.g., edge computing, NB-IoT)
- [Module Z – Extra Exercises](./modules/Z-extra-exercises.md) (e.g., challenges, quizzes)

---

## Assessment

Your final grade is based on:

| **Component**          | **Weight** | **Details**                                                                                     |
|------------------------|------------|-------------------------------------------------------------------------------------------------|
| **Weekly Reflections** | 25%        | Submit a 1–2 page reflection after each module (portfolio entries).                                |
| **Labs**              | 30%        | Complete hands-on labs (submit screenshots, logs, or code via GitHub).                           |
| **Final Project**      | 40%        | Build an IoT solution (e.g., a sensor node publishing to an MQTT broker) and present your work.   |
| **Participation**      | 5%         | Active participation in discussions, peer feedback, and Q&A sessions.                              |

---

## Workflow and Tools

### Step-by-Step Guide
1. **Read the module** and complete the **theory exercises** (if any).
2. **Work through the lab** (document your process!).
3. **Answer reflection questions** and add them to your portfolio.
4. **Push your code/lab reports** to your Git repository.
5. **Attend the meetup** to discuss questions and present progress.

### Project Guidelines
- **Scope:** Your project should utilize **MQTT** as the primary IoT protocol and optionally explore alternatives like CoAP or raw sockets. Include **one sensor/actor** (e.g., temperature sensor, LED).
- **Deliverables:**
  - GitHub repository with code.
  - 2-page project report (describe design choices, challenges, solutions).
  - 5-minute presentation (demo + Q&A).
- **Examples:**
  - A **smart farm monitor** (ESP32 + MQTT).
  - An **industrial sensor node** (OPC-UA + Modbus).
  - A **wearable BLE tracker** (ESP32 + smartphone app).

---

## Additional Resources

> **Naming note:** *IoTempire* is the organization behind all our IoT activities (courses, tools, community) — see [https://iotempire.net/](https://iotempire.net/). *IoTempower* is the specific open-source framework used elsewhere in our courses for device management, flashing, and integration — [https://iotempower.us](https://iotempower.us) (resolves to [github.com/iotempire/iotempower](https://github.com/iotempire/iotempower)). We still say "IoTempower" in the teaching context, but its GitHub repositories live under the `iotempire` organization.

### IoT Frameworks and Libraries
- [ESP-IDF (Espressif IoT Development Framework)](https://github.com/espressif/esp-idf)
- [MQTT-Client-Library for Arduino](https://github.com/knolleary/pubsubclient)
- [OPC-UA Client for Python](https://python-opcua.readthedocs.io/)

### Networking Tools
- [Wireshark](https://www.wireshark.org/) (packet analysis)
- [MQTTX](https://mqttx.app/) (MQTT client)
- [ESP32 Arduino Core](https://github.com/espressif/arduino-esp32)
- [Raspberry Pi OS](https://www.raspberrypi.com/software/)

### References
- **ISO-OSI Model:** [Wikipedia](https://en.wikipedia.org/wiki/OSI_model)
- **MQTT Protocol:** [MQTT Specification](http://docs.oasis-open.org/mqtt/mqtt/v5.0/mqtt-v5.0.html)
- **Industrial Protocols:** [OPC Foundation](https://opcfoundation.org/)
- **Wireless IoT:** [LoRaWAN Specification](https://lora-alliance.org/resource-hub/)


---

## Troubleshooting

### Common Issues
### FAQ
Find answers to common questions in [FAQs](./modules/Z-extra-exercises.md).

---


### Pre-Class Protocol Discovery
**For your portfolio:** Before the course starts, explore and compare at least 2 IoT protocols (e.g., MQTT, CoAP, HTTP, raw sockets). Document your findings in a short entry (1 page).
- How do they differ in power usage?
- What are their ideal use cases?
- Include a code snippet or diagram illustrating the protocol workflow.

---

## Template Files

**[Portfolio Template (Markdown)](./templates/portfolio-template.md)**
- [Lab Report Template (Markdown)](./templates/lab-report-template.md)
- [Project Report Template (Markdown)](./templates/project-report-template.md)

---

## License and Attribution

This workbook is licensed under [Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)](https://creativecommons.org/licenses/by-sa/4.0/).


---

**Start here:**
[Module 1 – Introduction to IoT and Networking](./modules/01-introduction.md)
