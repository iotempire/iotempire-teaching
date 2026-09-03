# Pre-Study Guide

Welcome to **Microcontroller Programming (MCP) – 10-Weeks (10-Days/12 4h Sessions) Edition**! You will progress from a blinking LED to a real IoT system: ESP32/ESP8266 nodes read sensors and control actuators; a local Wi-Fi network and MQTT broker connect them; Node-RED integrates the parts and provides a dashboard; IoTempower helps manage deployments. See the [syllabus](./syllabus.md) for the complete journey.

You do **not** need to arrive as an embedded developer or network engineer. This short guide lets you make a first thing now, then provides the minimum background that will make the early lab sessions more hands-on and less vocabulary-heavy.

> [!NOTE]
> **Language:** This course is taught in English and German, while its shared materials are kept in English. Use German, English, or a mixture of both in class and in your work; see the [syllabus language guidance](./syllabus.md#language-communication--course-material) for the full arrangement.
>
> **For German speakers / Für deutschsprachige Studierende:** Diese Lehrveranstaltung wird auf Englisch und Deutsch unterrichtet; die gemeinsamen Materialien bleiben auf Englisch. Sie/Du können/kannst im Unterricht und für Ihre/deine Arbeiten Deutsch, Englisch oder eine Mischung aus beidem verwenden. Die vollständige Sprachregelung finden Sie / findest du in den [Hinweisen zur Sprache im Syllabus](./syllabus.md#language-communication--course-material).

> [!IMPORTANT]
> **Planned assessment update — before the in-person course begins:** We will most likely recognise documented pre-study in your personal portfolio as **Module 0**, worth **one module point**. To keep the assessment balanced, the points assigned to the later modules will most likely be adjusted slightly. This is a planned change, not yet the final allocation: the criteria and final point table will be confirmed in the [syllabus](./syllabus.md) before the ten in-person teaching weeks start. Keep useful evidence of your pre-study—such as your Wokwi circuit/code, architecture sketch, and a short reflection.

## 1. IoT Systems — The Big Picture

A useful first model is:

```text
physical world → sensor / actuator → microcontroller node → local Wi-Fi + MQTT broker
                                                          ↕
                                               Node-RED integration + dashboard
                                                          ↕
                                         optional database, remote service, or cloud
```

This is the shape of the Day 1 Master Class and Modules 3, 5, and 6. It is deliberately broader than a single microcontroller sketch: a useful IoT product is a system of devices, communication, integration logic, and a human-facing result.

> [!IMPORTANT]
> **This course is local-first, not cloud-first.** In Module 3, each team creates a stand-alone LAN using an OpenWRT travel router, Wi-Fi, and a Mosquitto MQTT broker. The system must still work when there is no public internet connection. Cloud services are useful in some real projects and may be explored later, but no cloud account or AWS knowledge is required here.

### Start now: find an IoT story and make a tiny interaction (45–60 minutes)

Do not only read or watch—begin your personal portfolio record, find a problem worth solving, and make the first link in an IoT system before class:

1. Watch the **[IoTempower inspiration video](https://video.iotempower.us)**. Note what inspires you and record one or more stories, local needs, or problems that you might be able to address with the things you learn here. These notes will be useful again when you develop your final project.
2. Watch the first six minutes of the TIA Channel’s **[The Internet of Things: Connecting it All](https://youtu.be/jJaWMWz6RpE?list=PLlppUpfgGsvkfAGJ38_mzQc1-_Z7bNOgq)**. Its opening overview is enough to begin; watch the full documentary if it catches your interest. Start the evolving IoT observation list in the guiding questions below.
3. Open **[Wokwi](https://wokwi.com/)** and create a new **ESP32** project. Add an LED, a current-limiting resistor, and a pushbutton. Write a sketch in which the LED follows the button; as a bonus, make each press toggle the LED. You have now made the sensor/input → microcontroller → actuator part of an IoT system.
4. Watch the course’s **[Blink on a Wemos D1 Mini](https://youtu.be/2nN_ZVyWLzg)** video. Identify the roles of `setup()`, `loop()`, `pinMode()`, and `digitalWrite()`—you will use these on real hardware in Module 2.

Keep your inspiration notes and a screenshot of your Wokwi circuit and code. Together, they are useful first portfolio artefacts and give you something concrete to improve when the hardware kit arrives.

### Choose one perspective before going deeper

* **[IoT Intro Videos playlist](https://www.youtube.com/playlist?list=PLlppUpfgGsvkfAGJ38_mzQc1-_Z7bNOgq)** — the course’s curated collection, including the TIA material, short Bosch videos, and course-specific demonstrations. Pick one additional video rather than trying to watch the entire list.
* **TIA Channel – [The Cloud: Building in Mid-Air](https://youtu.be/MDTRQ0dbcRE?list=PLlppUpfgGsvkfAGJ38_mzQc1-_Z7bNOgq)** — an optional historical cloud primer. It is a starting point, not a current design recommendation: as you watch, ask what it assumes about connectivity, centralisation, data growth, energy, ownership, and failure modes.
* **Bosch Global – [The Internet of Things presents – #LikeABosch](https://youtu.be/v2kV6pgJxuo?list=PLlppUpfgGsvkfAGJ38_mzQc1-_Z7bNOgq)** — a short application-oriented product vision. Consider both the user experience it promises and the technical constraints it omits.
* **Simplilearn – [*What is IoT?* on the Simplilearn channel](https://www.youtube.com/@SimplilearnOfficial/search?query=what%20is%20iot)** — a second beginner-friendly explanation for comparing how different educators frame devices, data, connectivity, and action.

Course-specific MQTT and Node-RED videos appear with the relevant preparation below. The [IoTempower documentation](https://github.com/iotempire/iotempower) becomes useful after you have the system picture; Module 6 returns to it in detail. For independent hands-on inspiration, Andreas Spiess’s [YouTube channel](https://www.youtube.com/@AndreasSpiess) is an excellent optional complement, although it may use different boards, libraries, and infrastructure.

### Guiding questions and your evolving IoT observation list

1. Keep an evolving list in your personal portfolio while watching the videos. Start with **three IoT domains**, **two commonly used data protocols**, **two typical devices or appliances**, **two benefits**, and **two challenges**. Add at least one new domain, device, protocol, benefit, challenge, or noteworthy detail from each additional video. Also add one **cloud/architecture observation**: where do you think sensing, local control, gateway/edge work, and optional cloud services belong—and why?
2. What inspired you in the [IoTempower inspiration video](https://video.iotempower.us)? Which story, personal interest, local need, or problem could you imagine exploring with the technologies in this course?
3. In a typical IoT deployment, what are the roles of the **device**, **gateway/broker**, **integrator**, and **dashboard**?
4. Why does the course use a broker between devices and a dashboard instead of wiring every node directly to every other node?
5. What can still work on a local network after the public internet fails? Which features would require a remote or cloud service?
6. Why is an IoT system more than “an Arduino connected to Wi-Fi”?

## 2. Architecture Studio — Map, Place, and Question the Computing Continuum

> [!TIP]
> **This is the most valuable optional pre-study task (30–45 minutes).** Keep a photo or scan of the result for your portfolio. It is not a test with one correct diagram; the point is to make placement decisions visible and explainable.

The cloud is neither magic nor a distant icon on a diagram: it is physical infrastructure—servers, storage, networks, power, cooling, maintenance work, and organisations. Equally, “local” is not automatically greener or better. A distributed system can reduce unnecessary data transfer and keep working offline, but it also introduces more hardware, maintenance, security responsibilities, and potential e-waste. Good engineering makes the trade-offs explicit.

### 1. Draw two versions of one IoT system

Pick a scenario from the course, such as the Module 3 first-aid station, a home/hostel automation system, or your own idea. Draw:

1. **Local-only / outage mode:** the public internet is unavailable, but the LAN, router, MQTT broker, Node-RED, ESP nodes, and a phone or laptop may still work.
2. **Hybrid mode:** add only the remote components that genuinely add value—for example, selectively synchronised history, fleet-wide analysis, remote maintenance, or a public dashboard.

In both diagrams, show separate **data** and **control** paths with arrows. Mark what happens when the public internet fails, who operates each part, and which component must have power. A gateway may run several roles at once in this course: router, Wi-Fi access point, MQTT-broker host, and edge/fog computer.

Place and connect these terms where they make sense for *your* system: **cloud, internet, device, node, appliance, router, gateway, fog, swarm, edge, server, mobile phone, laptop/desktop computer**. A term can appear in more than one place if its role changes.

| Term | Useful working meaning—not a rigid hierarchy |
|---|---|
| **Device / appliance** | A physical thing used for a purpose; it may contain one or more computing nodes. |
| **Node** | A participating networked computing endpoint: an ESP, phone, laptop, gateway, or server can all be nodes. |
| **Edge** | Compute/storage/control placed near where data is produced or used; it can be on a device, phone, router, or local server. |
| **Fog** | An intermediate, distributed layer between end devices and central cloud/data centres. The term overlaps with edge and is used inconsistently; use it only after stating what role you mean. |
| **Router / gateway** | A router forwards traffic between networks. A gateway may additionally translate protocols, aggregate nodes, host services, buffer data, or coordinate local control. One box can be both. |
| **Server** | A role that provides a service (for example MQTT, Node-RED, a database, or a dashboard), not necessarily a distant machine. |
| **Cloud** | An operating model for pooled, remotely accessed compute/storage/services; physically it still runs on servers, networks, power, cooling, and human labour. |
| **Swarm** | A decentralised group of peers coordinating without one permanent central controller. It is an optional design idea here, not a requirement of the course. |

### 2. Make and defend placement decisions

For each important function—sensor filtering, emergency alarm, MQTT broker, dashboard, long-term history, firmware updates, analytics/AI—write **where** it runs in the local and hybrid versions, plus one reason. Evaluate these questions rather than assuming that one architecture wins:

- **Latency and safety:** must the action happen immediately, even when the internet is down?
- **Bandwidth and data minimisation:** should raw data travel, or only events/aggregates?
- **Privacy, ownership, and sovereignty:** who can access the data and control the service?
- **Resilience:** what fails with Wi-Fi, the router, a cloud provider, or power loss?
- **Energy and materials:** how do data transmission, always-on local equipment, data-centre utilisation, cooling, device lifetime, repairability, and e-waste change the picture?
- **Maintainability:** who will update, secure, repair, and eventually retire each component?

### 3. Add a short time-and-self reflection

Make a small timeline with three points: **five years ago**, **today**, and **five years from now**. For each point, rate the personal importance (0–3) of local devices, mobile devices, home/organisation servers, public cloud services, and AI services. Then write 5–8 sentences:

- Which parts of your daily life already depend on remote services, and which work locally?
- Which resource changed most in importance for you—data, network bandwidth, compute, memory, electrical power, repairable hardware, or control of your own data—and why?
- In your scenario, where would you *refuse* to depend on a cloud connection? Where is a remote service worth the dependency?
- What evidence would you still need before claiming that your local, cloud, or hybrid design is more sustainable?

### Architecture and critical-reading resources

* **NIST – [Fog Computing Conceptual Model (SP 500-325)](https://doi.org/10.6028/NIST.SP.500-325)**
  A public technical reference for fog/mist terminology and its relationship to cloud-based IoT. It is best used to sharpen vocabulary and challenge simplistic three-layer diagrams, not as a product tutorial.
* **Steven Gonzalez Monserrate (MIT) – [*The Cloud Is Material*](https://mit-serc.pubpub.org/pub/the-cloud-is-material)**
  An open, interdisciplinary case study on the environmental and social infrastructure behind cloud computing: electricity, cooling, water, e-waste, labour, and local communities. Read the abstract, introduction, and one later section that interests you; it provides questions rather than a simplistic anti-cloud conclusion.
* **European Commission – [Cloud computing](https://digital-strategy.ec.europa.eu/en/policies/cloud-computing)**
  A current European policy perspective that explicitly describes cloud and edge as a **computing continuum** and connects placement with data protection, resilience, efficiency, and digital sovereignty. It is policy material, not neutral technical documentation—identify its priorities as you read.
* **International Energy Agency – [Data centres & networks](https://www.iea.org/energy-system/buildings/data-centres-and-data-transmission-networks)** *(current context)*
  Use this as a source for investigating current energy demand around data centres, transmission networks, and AI. It frames the scale of the question; it does not tell you where every IoT function should run.

### Guiding questions

7. Why is “cloud vs. local” usually a false choice? Give one well-justified hybrid split for the first-aid-station scenario.
8. What would you measure or investigate before calling an architecture more sustainable?

---

## 3. Local Networking, Gateways, and MQTT

Module 3 asks each team to configure a 2.4 GHz Wi-Fi LAN, receive IPv4 addresses through DHCP, run a Mosquitto broker on an OpenWRT router, and exchange MQTT messages between phones, computers, and ESP nodes. The goal is not abstract networking theory: it is to understand the network you will actually operate.

* **MDN – [How does the Internet work?](https://developer.mozilla.org/en-US/docs/Learn_web_development/Howto/Web_mechanics/How_does_the_Internet_work)**
  The best concise primer here. Focus on local networks, routers, IP addresses, DNS, and the distinction between the Internet and the Web.
* **HiveMQ – [MQTT Essentials](https://www.hivemq.com/mqtt-essentials/)**
  Read the introductory MQTT articles for a clear explanation of broker, client, topic, publish/subscribe, retained messages, and quality of service. We mainly need the first four concepts at the beginning.
* **OpenWrt – [User Guide](https://openwrt.org/docs/guide-user/start)** *(reference, not required reading)*
  Keep this available for Module 3. It provides terminology for the router's LuCI interface, LAN/WAN interfaces, Wi-Fi, DHCP, and package management.
* **Course video – [MQTT with IoTempower Shell Tools](https://youtu.be/RxrCS5Fi2LY)**
  A course-aligned introduction to observing and sending MQTT traffic with command-line tools. It makes more sense after you have seen the basic publish/subscribe model.

### Guiding questions

9. What is the difference between a **MAC address**, an **IP address**, a **hostname**, and a **domain name**?
10. When an ESP joins your Wi-Fi, what jobs does the access point/router perform, and what does DHCP provide?
11. What is a gateway in this course's network? Which parts are routing, service hosting, and protocol/message brokering?
12. In MQTT, how do a **broker**, **client**, and **topic** differ? What does `station/alert/#` mean?
13. Why is a local broker useful for the earthquake/first-aid-station scenario in Module 3?

> [!TIP]
> A device connected to your local Wi-Fi is **not** automatically reachable from the public internet. That separation is desirable: do not expose an MQTT broker or ESP web server to the internet casually. Authentication, encryption, firewall rules, and updates matter whenever a system crosses the local-network boundary.

---

## 4. Arduino, GPIO, and Basic Electronics

Day 2 starts with breadboards, LEDs, buttons, Wemos D1 Mini boards, and safe prototyping practice. You will later extend this to PWM, relays, sensors, I²C, SPI, UART, OneWire, and RFID.

* **Course video – [Breadboard and Prototyping IoT Intro](https://youtu.be/yXirMBP3x4U)**
  The direct preparation for Module 2: breadboard rails, LED polarity, resistor use, and a button circuit.

* **Arduino Documentation – [Blink](https://docs.arduino.cc/built-in-examples/basics/Blink/)**
  A concise reference for sketch structure and a simple digital output. Remember that the course's Wemos pin labels such as `D6` are board labels; always check the board pinout before copying a GPIO number from another tutorial.
* **Random Nerd Tutorials – [Getting Started with ESP32](https://randomnerdtutorials.com/getting-started-with-esp32/)** *(optional companion)*
  Useful if you want a text-based ESP32 introduction. The course uses both ESP8266/Wemos D1 Mini and ESP32 hardware, so do not assume their pinouts or voltage details are interchangeable.

### Pre-study task: read a Blink sketch

Without needing hardware, be able to identify these elements in a Blink sketch:

```cpp
void setup() {
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  digitalWrite(LED_BUILTIN, HIGH);
  delay(500);
  digitalWrite(LED_BUILTIN, LOW);
  delay(500);
}
```

Then explain what you would change to use an **external LED connected through a resistor** to a chosen GPIO. Do not copy a pin number blindly: the correct label and safe voltage depend on the board and circuit.

### Guiding questions

14. What is the difference between `setup()` and `loop()`? Where does Arduino-framework startup happen before these functions run?
15. What does `pinMode(pin, OUTPUT)` mean electrically and in software?
16. Why must an LED normally have a current-limiting resistor?
17. Why should a Wemos/ESP GPIO never directly power a relay, solenoid lock, or 12 V load?
18. What problem does a pull-up or pull-down resistor solve for a pushbutton input?

---

## 5. HTTP, MQTT, and System Integration

The course uses MQTT most often because devices and services must both report events and receive commands. It also covers REST/HTTP as an important contrasting pattern and for integrations such as APIs. Module 5 then turns separate nodes into an HVAC simulation and an access-control system.

* **Random Nerd Tutorials – [ESP32 HTTP GET and HTTP POST with Arduino IDE](https://randomnerdtutorials.com/esp32-http-get-post-arduino/)**
  Read the request/response flow and inspect the code; running it before the course is optional. Notice where a URL, headers, body, and response appear.
* **HiveMQ – [MQTT Essentials](https://www.hivemq.com/mqtt-essentials/)**
  Revisit the introduction with this question in mind: why is publish/subscribe convenient when a sensor, a dashboard, and several actuators all need the same data?
* **Node-RED – [Getting Started](https://nodered.org/docs/getting-started/)**
  A short official orientation to flows, nodes, and messages. Our class uses Node-RED locally through IoTempower rather than requiring a hosted platform.
* **Course video – [Hello Node-RED](https://youtu.be/ycTVafrn3Pw)**
  The most relevant preview of the visual, message-flow approach that appears on Day 1 and throughout Modules 4–6.

### Guiding questions

19. In an HTTP `GET`, where does request data commonly appear? What can a `POST` add?
20. In HTTP request/response, who initiates each interaction? How does this contrast with MQTT publish/subscribe?
21. A temperature node publishes once, while a dashboard and an alarm node both subscribe. What needs to know about the other components?
22. What is an **integrator** in the Module 5 HVAC task, and why is it useful to keep it separate from the sensor and actuator?

---

## 6. ESP32 Simulation — Extend What You Already Built

The Wokwi task in [Section 1](#1-iot-systems-the-big-picture) is your first simulation. Use the browser-based ESP32/Arduino simulator to try changes quickly before the hardware kit arrives on Day 2: alter the blink rate, add another input or output, or deliberately break and repair a connection. Simulation supports program-flow and wiring practice; it never replaces hardware testing.

A real Wemos/ESP setup adds the things engineers must learn to handle: board-specific pin labels, voltage limits, loose wires, noisy or inaccurate sensors, Wi-Fi coverage, power supply limits, timing, and library/device differences.

### Guiding questions

23. How can simulation shorten the early design-debug cycle?
24. Which measurements or failures can only be discovered with real hardware and a real local network?

---

## 7. Prepare Like an Engineer

The final project asks you to build a multi-node system with sensors, actuators, MQTT, an integration layer, a dashboard, documentation, and a clear user scenario. You do not need to choose your project now, but get used to looking at examples critically.

When you watch any IoT video—course material, Bosch, TIA, Andreas Spiess, Simplilearn, or something else—make a tiny engineering note:

- **Problem and user:** Who needs what, and why?
- **Physical side:** What is sensed or controlled?
- **System boundary:** Which parts remain local? Which, if any, are remote/cloud-based?
- **Data path:** Device → topic/API → integration → dashboard/actuator.
- **Trade-offs and failure modes:** What happens if Wi-Fi, the broker, power, or a sensor fails?

This habit will directly support your portfolio, the Module 5 simulations, Module 6 system scaling discussions, and the architecture of the final project.

---

## Ready for Day 1?

You are ready if you can explain the first chain you built—**button → ESP firmware → LED**—and can imagine how Wi-Fi, a local MQTT broker, Node-RED, and another actuator extend it into a system. The lab supplies the hardware, local infrastructure, examples, and support; your job is to build, test, document, and improve it.

See you in the MCU Programming Lab!
