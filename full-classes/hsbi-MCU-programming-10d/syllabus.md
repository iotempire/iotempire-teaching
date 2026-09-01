# Syllabus: Microcontroller Programming (MCP) – 10-Day Extended Edition

> **Important**: This syllabus is a living document and will evolve throughout the semester. Smaller updates may apply based on class progress and feedback.

---

## Class Times and Locations

- **Day:** Tuesday
- **Location & Room:** Delta 1022 (IoT Lab / Mechatronics Workshop)
- **Time:** 10:15–13:45
- **Language of Instruction:** English

---

## Instructors & Teaching Team (HSBI Gütersloh)

| **Role**               | **Name / Placeholder**             | **Contact (placeholder)**       | **Discord**         | **GitHub**       |
|------------------------|-----------------------------------|--------------------------------|---------------------|--------------------|
| Module Lead            | <Instructor 1>                  | <email>                      | <discord-handle>    | <github>           |
| Instructor             | <Instructor 2>                  | <email>                      | <discord-handle>    | <github>           |
| Teaching Assistant     | <TA 1>                           | <email>                      | <discord-handle>    | <github>           |
| Teaching Assistant     | <TA 2>                           | <email>                      | <discord-handle>    | <github>           |

**Course Discord Invite:**
Add your course Discord invite once available.

---

## Course Load & Credits

- **Contact Hours (in-class):** 12 sessions × 4h = **48 hours** (5 ECTS)
  - Delivered over **10 weeks**, roughly **one session per week**
  - **Days 3 and 4** each reserve optional **stretcher time** in case a module needs longer
  - **Day 10** is kept flexible as a buffer for final-project work if the group needs it
- **unsupervised self-study and homework:** 102 hours
- **Total workload:** 150 hours / 5 ECTS

- **ECTS Credits:** 5

---

## Grading Breakdown

- **Module Points:** 11 — earned across Days 1–6 (see day-by-day plan below)
- **Reflection Points:** 4 — same standard reflection format (see portfolio template) after Day 1, and one per final-project day (Days 7–9)
- **Final Project:** 5 points (minimum 2 required to pass)
- **Extra Points:** Up to 3 — outstanding contributions, help, extra projects, completed stretcher tasks

- **Minimum Passing Grade:** 14/20 points (≈70 %)

---

## Course Description & Goal

### Microcontroller Programming — what is it?

Embedded systems are the **hidden brains** behind dishwashers, cars, pacemakers, and smart-home hubs. Microcontrollers (MCUs) like ESP32, Arduino, or ARM-based boards are the central building blocks of modern automation: they read sensors, control actuators, communicate machine-to-machine (M2M), and optimize resources such as energy, memory, and compute power.

In this course you **won't merely study theory** — you will design, build, and debug real embedded systems: low-level circuits on breadboards, firmware in C/C++ using Arduino/PlatformIO, and system integration for automation and monitoring tasks. You'll bring hardware **to life**, implement algorithms in real time, and document results in comprehensive protocols.

---

## Learning Objectives

By the end of this course, you will be able to:

- **Understand embedded systems fundamentals**: architecture, resource constraints (memory, energy, real-time capability), and trade-offs
- **Select and program microcontroller platforms** (ESP32 and ESP8266) and optimize performance and power usage
- **Read sensors and control actuators** using basic digital/analog I/O, extend into advanced peripherals (AD/DA converters, counters, watchdogs, low-power modes)
- **Use bus systems and M2M communication** (I²C, SPI, UART, MQTT, REST/HTTP) to connect systems and devices robustly
- **Design and implement customer/user requirements** into modular microcontroller-based products, making reasoned trade-offs between performance, deployment cost, and maintainability
- **Plan, prototype, test, and document** embedded solutions in a complete engineering notebook (portfolio)

---

## Prerequisites & Tools

### Formal
None beyond course registration.

### Recommended Starting Points
- Basics in programming (helpful but not required; C/C++ basics will be scaffolded)
- Linux/CLI basics (terminal, package management)
- Version control with Git/GitHub
- English B1/B2 (documentation, discussions, IDE menus), but feel free to use AI tools to translate any content of the current workbook into your native language

### Tools & Hardware Kit
- **Development Environment**: Arduino IDE v2 or PlatformIO (VSCode)
- **Networking & MQTT**: mosquitto_sub/pub (CLI), MQTT Explorer, Node-RED for dashboards
- **IoTempower Framework:** Over-the-Air updates & fleet deployment across ESP boards
- **Laboratory Hardware Kit** (issued during classes):
  – Breadboards and jumper wires
  – Wemos D1 Mini / ESP32 & ESP8266 boards, plus M5StickC for the Day 1 Master class
  – Sensors: Temperature/DHT22, Ultrasonic/PIR, BME280, RFID/MFRC522, OLED displays
  – Actuators: LEDs, RGB-LEDs, relays, motors (ULN kit), buzzer, stepper (on-demand)
  – Interface kits: I²C & SPI test boards, basic GPIO tools
  – Tools: USB cables, multimeters

---

## Day-by-Day Plan & Assessment

The course reuses the modules of the original HSBI blocked 4-day workshop, paced like the extended University of Tartu course — roughly **one module per day** instead of cramming several modules into a single block day. **Some flexibility is built in**: fast groups can use stretcher time for bonus material, slower groups can use it to finish the core module.

| Day | Module / Focus                                                        | Points |
|-----|------------------------------------------------------------------------|--------|
| 1   | **Module 1** – Introduction + **Master Class** (M5StickC + Node-RED mini-workshop) | 1 module pt + 1 reflection pt |
| 2   | **Module 2** – Hardware and Basic Electronics                          | 2 module pts |
| 3   | **Module 3** – Infrastructure and Gateway Setup *(+ stretcher time if needed)* | 2 module pts |
| 4   | **Module 4** – Embedded Programming and Deploying Nodes *(+ stretcher time if needed, else bonus)* | 2 module pts |
| 5   | **Module 5** – Integration and Simulations                             | 2 module pts |
| 6   | **Module 6** – IoT Systems                                              | 2 module pts |
| 7–9 | **Module 7** – Final Project: ideation → prototyping → build → live demo | 5 project pts |
| 10  | *Flexible buffer* — extra final-project time if the group needs it     | — |

- **Module points total:** 1 + 2 + 2 + 2 + 2 + 2 = **11**
- **Reflection points total:** 10 days, 2 can be skipped, so 0.5 points each **4**
- **Final project points:** **5**

All labs and reflections are captured in your GitHub portfolio.

### Portfolio as Primary Artifact
**All course deliverables are captured in your GitHub Portfolio:**
- Datasheets & schematics (hand-drawn or Fritzing)
- Firmware source & binaries
- Screenshots: serial console, dashboard values, logic analyzers
- Measured performance graphs (energy, timing, memory footprint)
- Reflections: same standard reflection format (see [reflection guidance in the portfolio template](https://github.com/iotempire/iot-portfolio-template/blob/main/Reflections/README.md)) after Day 1, and one per final-project day. Note: the Day 1 Master Class itself is documented as a normal portfolio work report (pictures, process notes, peer collaboration), not as a special reflection topic.

Your logbook should mirror an engineering notebook — continuous, scannable, and explicit.

### Final Capstone Project (5 pts; ≥30 % grade weight)
- **Goal**: implement a **complete embedded microcontroller system** with sensors and MQTT/REST integration. Example stories:
  – Patient-monitoring device mock-up (temperature, BME280 data via MQTT)
  – Smart access-control turnstile with RFID badge reader and Node-RED dashboard
  – Autonomous follow-me robot car (ultrasonic ranging, motor H-bridge, MQTT bridge to PC)
  – IoTempower multi-node fleet + monitoring dashboard
- **Must-Haves**: ≥3 microcontrollers, MQTT, sensors & actors, OTA ready, permissive license (MIT/CC-BY-SA)
- **Assessment Criteria** (out of 5):
  – **Functionality & Robustness** (2) [system meets spec & handles errors]
  – **Documentation & Architecture** (1) [README, block diagrams, timing charts]
  – **Performance & Efficiency** (1) [resource usage, responsiveness, low-power behavior]
  – **Presentation & Peer Review** (1) [10 min live demo + 5 min feedback]
- **Pass Condition:** Minimum 2/5 points required to pass.

---

## Grade Scale (German terms, English labels)

| **Points (0–20)** | **Grade (German)**       |
|---------------------|---------------------------|
| 0–13               | Fail / nicht bestanden      |
| 14–15              | Passed / bestanden         |
| 16–17              | Satisfactory / befriedigend |
| 18–19              | Good / gut                 |
| 20                 | Very Good / sehr gut       |

- **Modul Points:** 11
- **Reflection Points:** 4
- **Project Points:** 5
- **Extra Points / Bonus:** Up to 3

---

## Course Materials & Resources (Workbook-based)

Your working environment is the **local microcontroller workbook provided for this course**:

- **Primary Workbook:** [./README.md](./README.md) and modular files under [./modules/](./modules)
- **Master Class Material:** [Mastering IoT Solutions mini-workshop](../../workshops/mastering-iot-solutions/README.md)
- **Portfolio Starter Templates:** [https://github.com/iotempire/iot-portfolio-template](https://github.com/iotempire/iot-portfolio-template)
- **IoTempower Framework:** [https://github.com/iotempire/iotempower](https://github.com/iotempire/iotempower) (vanity URL [https://iotempower.us](https://iotempower.us))
- **IoTempire Organization** (behind all our IoT teaching, tools, and community efforts): [https://iotempire.net/](https://iotempire.net/)
- **Useful Libraries:** ESP8266/ESP32 Arduino Cores, Adafruit (DHT22, BME280), PubSubClient (MQTT), OneWire, MFRC522 (RFID), U8g2 (OLED), FastLED (RGB)
- **Hardware Kit:** Supplied at course start; see Module 2 – Hardware & Electronics for details

All artifacts (code, logs, schematics) must be published under permissive or open licenses (MIT, CC-BY-SA) to enable reuse and learning.

---

## Expectations & Classroom Policies

- **In-class Presence:** Active participation in hands-on lab work is mandatory. Unexcused absences may affect module points.
- **Teamwork:** Form teams of 1–2 students for early labs and 4–6 for the capstone project. Document roles and tasks in your portfolio to ensure transparent contribution tracking.
- **Ethics & Respect:** Handle kit, peers, and data respectfully. Build **safe prototypes**, document **failure modes**, and consider **stakeholders** in your scenarios.
- **Open by Default:** Publish all project code, logs, and schematics under permissive open licenses.

---

## Success Strategies – Lab-Tested Tips

1. **Repo housekeeping every session.** Run `git status`, write concise commit messages, link issues to commits. Use branches for experiments.
2. **Reflect continuously.** Use the same standard reflection format after Day 1 and each final-project day — see the [reflection guidance in the portfolio template](https://github.com/iotempire/iot-portfolio-template/blob/main/Reflections/README.md). The Day 1 Master Class itself gets a normal work report (pictures, notes), not a special reflection.
3. **Fail early, fail often.** Hardware burnout is part of the journey; fall back to serial logs, schematic inspection, and power-pin sanity checks. Report to us if things break, if you are unsure, talk to us.
4. **Portfolio is your lifeline.** Reflections and hardware builds are both graded; treat documentation as seriously as the build.
5. **Collaborate generously.** Review teammate PRs, attend pair-debug sessions, and share exploration artifacts openly.
6. **Use stretcher time wisely.** Days 3 and 4 have built-in buffer time — use it to catch up, or to tackle bonus tasks if you're ahead.

---

## Contacts & Questions

- **Technical Issues:** Report via GitHub issues in your personal portfolio repo
- **Course Feedback:** Mid- and end-semester evaluation forms
- **Academic Integrity:** Cite sources, ask instructors for clarification before doubt arises

- **Local Course Contacts:** <replace>
- **Discord Server:** <replace> (course invite URL)

---

> ###### 
Document Version: 4.0 (HSBI Campus Gütersloh 10-Day Edition)  
Last Updated: August 2026
