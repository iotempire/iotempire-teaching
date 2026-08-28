# Syllabus: Microcontroller Programming (MCP)

> **Important**: This syllabus is a living document and will evolve throughout the semester. Smaller updates may apply based on class progress and feedback.


---

## Class Times and Locations

- **Day:** Tuesday
- **Location & Room:** Delta 1022 (IoT Lab / Mechatronics Workshop)
- **Time:** 10:15–13:45
- **Language of Instruction:** English

---

## Instructors & Teaching Team (local placeholders)

| **Role**               | **Name / Placeholder**             | **Contact (placeholder)**       | **Discord**         | **GitHub**       |
|------------------------|-----------------------------------|--------------------------------|---------------------|--------------------
| Module Lead            | <Instructor 1>                  | <email>                      | <discord-handle>    | <github>           |
| Instructor             | <Instructor 2>                  | <email>                      | <discord-handle>    | <github>           |
| Teaching Assistant     | <TA 1>                           | <email>                      | <discord-handle>    | <github>           |
| Teaching Assistant     | <TA 2>                           | <email>                      | <discord-handle>    | <github>           |

**Course Discord Invite:**
Add your course Discord invite once available.

---

## Course Load & Credits

- **Contact Hours (in-class):** 15 × 2h = **30 hours** (5 ECTS)
- **Self-study:** 120 hours
- **Total workload:** 150 hours / 5 ECTS (≈10 hours outside of class per contact hour)

- **ECTS Credits:** 5

- **Grading Breakdown:**
  - **Module Points:** 11 (±1 per week) — labs, participation, progress checks
  - **Reflection Log:** 4 points (~0.25 per week; rounded up)
  - **Final Project:** 5 points (minimum 2 required to pass)
  - **Extra Points:** Up to 3 — outstanding contributions, help, extra projects

- **Minimum Passing Grade:** 14/20 points (≈70 %)

---

## Course Description & Goal


### Microcontroller Programming — what is it?


Embedded systems are the **hidden brains** behind dishwashers, cars, pacemakers, and smart-home hubs. Microcontrollers (MCUs) like ESP32, Arduino, or ARM-based boards are the central building blocks of modern automation: they read sensors, control actuators, communicate machine-to-machine (M2M), and optimize resources such as energy, memory, and compute power.


In this course you **won’t merely study theory** — you will design, build, and debug real embedded systems: low-level circuits on breadboards, firmware in C/C++ using Arduino/PlatformIO, and system integration for automation and monitoring tasks. You’ll bring hardware **to live**, implement algorithms in real time, and document results in comprehensive protocols.


---

## Learning Objectives — aligned with module handbook


By the end of this course, you will be able to:

- **understand embedded systems fundamentals**: architecture, resource constraints (memory, energy, real-time capability), and trade-offs
- **select and program microcontroller platforms** (ESP32 and ESP8266) and optimize performance and power usage
- **read sensors and control actuators** using basic digital/analog I/O, extend into advanced perhipherals (AD/DA converters, counters, watchdogs, low-power modes)
- **use bus systems and M2M communication** (I²C, SPI, UART, MQTT, REST/HTTP) to connect systems and devices robustly
- **design and implement customer/user requirements** into modular microcontroller-based products, making reasoned trade-offs between performance, deployment cost, and maintainability
- **plan, prototype, test, and document** embedded solutions in a complete engineering notebook (portfolio)


---

## Prerequisites & Tools

### Formal
None beyond course registration.

### Recommended Starting Points
- basics in programming (helpful but not required; C/C++ basics will be scaffolded)
- Linux basics (terminal, package management)
- version control with Git/GitHub
- English B1/B2 (documentation, discussions, IDE menus), but feel free to use AI tools to translate anythign of the current workbook into your native language

### Tools & Hardware Kit
- **Development Environment**:
  – Arduino IDE v2 or PlatformIO (VSCode)
- **Networking & MQTT**: mosquitto_sub/pub (CLI), MQTT Explorer, Node-RED for dashboards
- **IoTempower Framework:** Over-the-Air updates & fleet deployment across ESP boards

- **Laboratory Hardware Kit** (issued during classes):
  – Breadboards and jumper wires
  – Wemos D1 Mini / ESP32 & ESP8266 boards
  – Sensors: Temperature/DHT22, Ultrasonic/PIR, BME280, RFID/MFRC522, OLED displays
  – Actuators: LEDs, RGB-LEDs, relays, motors (ULN kit), buzzer, stepper (on-demand)
  – Interface kits: I²C & SPI test boards, basic GPIO tools
  – Tools: USB cables, multimeters

All items are detailed in **Module 2 – Hardware & Electronics** of your workbook.

---

## Projects & Assessment

### Weekly Module Labs (11 pts + 4 pts)

Your semester is structured in problem-based learning cycles: weekly labs and mini-projects build toward your capstone. Teams of 1–2 contribute to shared hardware logbooks captured in your GitHub portfolio.

- **Week 1–3:** Tooling, git, first blink, timing loops, reset behavior (≈4–5 module points)
- **Week 4–6:** Peripheral buses (I²C or SPI), UART sessions, interrupts, watchdog, low-power tricks (≈3–4 module points)
- **Week 7–9:** M2M (MQTT), gateway setup, discovery, network robustness, data integrity (≈4 module points)
- **Week 10–12:** Node-RED orchestration + HVAC or Access Control demos, modular assessment (≈3–4 module points)
- **Week 13–15:** Final project planning, prototyping, validation, documentation (≈5 final project points lead-in)

### Portfolio as Primary Artifact
**All course deliverables are captured in your GitHub Portfolio:**
– Datasheets & schematics (hand-drawn or Fritzing)
– firmware source & binaries
– screenshots: serial console, dashboard values, logic analyzers
– measured performance graphs (energy, timing, memory footprint)
– **reflections** captured after each session (usually weekly): what worked, what failed, how you debugged and improved

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
- **Reflection Points:** 4 (rounded up)
- **Project Points:** 5
- **Extra Points / Bonus:** Up to 3

---

## Course Materials & Resources (Workbook-based)

Your working environment is the **local microcontroller workbook** provided for this course:

- **Primary Workbook:** [./README.md](README.md) and modular weekly modules under [./modules/](./modules)
- **Portfolio Starter Templates:** [https://github.com/iotempower/iotempower-portfolio-template](https://github.com/iotempower/iotempower-portfolio-template)
- **IoTempower Framework:** [https://github.com/iotempower/iotempower](https://github.com/iotempower/iotempower)
- **Useful Libraries:** ESP8266/ESP32 Arduino Cores, Adafruit (DHT22, BME280), PubSubClient (MQTT), OneWire, MFRC522 (RFID), U8g2 (OLED), FastLED (RGB)
- **Hardware Kit:** Supplied at course start; see [Module 2 – Hardware Overview](./modules/02-hardware.md) module for details

All artifacts (code, logs, schematics) must be published under permissive or open licenses (MIT, CC-BY-SA) to enable reuse and learning.

---

## Module Overview – Weekly Plan

| Week | Weekly Topic / Module                         | Core Activities & Skills Acquired                             |
|------|---------------------------------------------|-------------------------------------------------------------|
| 1    | Module 1 – Course Launch & Tooling            | git, basic IDEs, first "Hello Embedded" light-up           |
| 2    | Module 1 – Timing & First Prototypes       | loop timings, timing-sensitive debug, reset behavior         |
| 3    | Module 2 – Hardware Basics (refresh)        | breadboard prototyping, LEDs, resistors, noise reduction     |
| 4    | Module 2 – Buses I²C/SPI                   | bus sniffing, multiple-sensor wiring, basic protocols        |
| 5    | Module 2 – UART & Serial Puzzles            | serial I/O, string parsing, logic & timing                  |
| 6    | Module 3 – Networking & Gateways              | LAN, Wi-Fi, MQTT broker setup, client discovery           |
| 7    | Module 3 – MQTT Deep Dive                    | wildcards, topic planning, Clients & broker debugging      |
| 8    | Module 4 – Debugging & Watchdogs            | hard faults, runtime exceptions, watchdog setup              |
| 9    | Module 4 – OTA Flashing & Fleet Tools        | wireless uploads, versioning, multi-device management      |
|10    | Module 4 – MQTT-to-Serial Bridges           | hardware isolation, remote upgrades, inter-node chat       |
|11    | Module 5 – Integration: HVAC Styles         | environmental sensing, threshold logic, Node-RED dashboards|
|12    | Module 5 – Access Control Systems            | RFID readers, motion sensors, secure UI flows in Node-RED  |
|13    | Module 6 – System Architecture & Efficiency| performance modelling, low-power deep sleep measurements  |
|14    | Capstone – Project Planning                  | user stories, block diagrams, risk register, schematics   |
|15    | Capstone – Build & Test                     | HW bring-up, logging, error margin tuning                  |
|16    | Capstone – Live Demo & Submission           | 10 min showcase, portfolio archiving                      |

> Small shifts possible; keep track of git commits and weekly module releases.

---

## Expectations & Classroom Policies

- **In-class Presence:** Active participation in hands-on lab work is mandatory. Unexcused absences may affect module points.

- **Teamwork:** Form teams of 1–2 students in the beginning and 4-6 for the capstone project. Document roles and tasks in your portfolio to ensure transparent contribution tracking.

- **Ethics & Respect:** Handle kit, peers, and data respectfully. Build **safe prototypes**, document **failure modes**, and consider **stakeholders** in your scenarios.

- **Open by Default:** Publish all project code, logs, and schematics under permissive open licenses.

---

## Success Strategies – Lab-Tested Tips

1. **Repo housekeeping every session.** Run `git status`, write concise commit messages, link issues to commits. Use branches for experiments.
2. **Reflect continuously.** Summarize each lab session: what succeeded, what failed, what’s next. A one-paragraph log keeps memory alive.
3. **Fail early, fail often.** Hardware burnout is part of the journey; fall back to serial logs, schematic inspection, and power-pin sanity checks. Report to us if things break, if you are unsure, talk to us.
4. **Portfolio is your lifeline.** Weekly reflections account for 20 % of grade; treat hardware builds and documentation equally important.
5. **Collaborate generously.** Review teammate PRs, attend pair-debug sessions, and share exploration artifacts openly.
6. **Capstone timebox.** Start architecture documentation early; leave two full weeks for stabilization, polish, and video recording for assessment evidence.

---

## Contacts & Questions

- **Technical Issues:** Report via GitHub issues in your personal portfolio repo
- **Course Feedback:** Mid- and end-semester evaluation forms
- **Academic Integrity:** Cite sources, ask instructors for clarification before doubt arises

- **Local Course Contacts:** <replace>
- **Discord Server:** <replace> (course invite URL)

---

> ###### 
Document Version: 1.0 (HSBI-to-local Workbook Edition)  
Last Updated: August 2026  
Sources adapted from Mechatronics Module Handbook & HSBI 2026 course material
