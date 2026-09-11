# Syllabus: Microcontroller Programming (MCP) – 10-Week Edition

> **Important**: This syllabus is a living document and will evolve throughout the semester. Smaller updates may apply based on class progress and feedback.

---

## Class Times and Locations

- **Schedule, location, and room:** Published in the official HSBI timetable and course LMS before teaching begins
- **Official announcements and course contact:** Course LMS
- **Languages of Instruction:** English and German
- **Course Materials:** English

---

## Instructors & Teaching Team (HSBI Gütersloh)

| **Role** | **Name** | **Contact / Status** |
|---|---|---|
| Main Instructor | Ulrich Norbisrath (**Ulno**) | [ulno.net](https://ulno.net) |
| Possible teaching support | Fabian Tilman Schmid-Michels | To be confirmed |

> [!NOTE]
> **Course information:** Ulno is the primary instructor for this HSBI offering. The course LMS is the authoritative source for local dates, rooms, contact details, and announcements. A Discord space may be offered as an additional community channel.

<!-- Instructor reuse note: For younger audiences, adapt the German form of address and translate all material as appropriate for the local teaching context. -->

---

## Language, Communication & Course Material

This class is taught in **English and German**. The shared workbook, slides, code, documentation, and most existing teaching material are in English, so English will be the common written language and often the main spoken language in class. This keeps the materials reusable across both German- and English-taught offerings.

Ulno is bilingual. You are welcome to speak with the teaching team and collaborate in **German, English, or a mixture of both**. Notes, portfolio documentation, and presentations may likewise be in German, English, or mixed language. Ask whenever technical vocabulary or a task formulation needs clarification in either language. A mixed-language discussion is normal here—switching the instructor’s language at an inconvenient moment is an unofficial side quest.

**Für deutschsprachige Studierende:** Diese Lehrveranstaltung findet auf Englisch und Deutsch statt. Das gemeinsame Workbook, die Folien, der Code, die Dokumentation und die meisten bestehenden Unterrichtsmaterialien bleiben auf Englisch, damit sie in englisch- und deutschsprachigen Kursen einheitlich genutzt werden können. Ulno ist zweisprachig; Sie können mit dem Lehrteam auf Deutsch, Englisch oder in einer Mischung aus beiden Sprachen sprechen und zusammenarbeiten. Notizen, Portfolio-Dokumentation und Präsentationen dürfen ebenfalls auf Deutsch, Englisch oder gemischt erstellt werden. Fragen Sie jederzeit nach, wenn Fachbegriffe oder Aufgabenstellungen in einer der beiden Sprachen geklärt werden sollen.

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

## Course Load & Credits

- **In-person delivery:** **8–12 sessions/days** across the semester. The exact timetable and contact hours are published through the official HSBI timetable and course LMS.
  - Module pacing is flexible: a session may provide stretcher time, begin the next module, or support groups progressing at different speeds.
- **Independent study and homework:** **102 hours** across the course.
  - Before the first session, students are expected to invest approximately **40 hours** in independent preparation. The required Module 0 core is a realistic **4–8-hour** starting point; optional resources support deeper preparation.
- **Total workload:** 150 hours / 5 ECTS
- **ECTS Credits:** 5

---

## Grading Breakdown

Assessment is conducted as a **Kombinationsprüfung**: portfolio evidence, reflections, and a final project.

> [!IMPORTANT]
> **Module 0 is required and worth one point.** Before the first session, create your personal portfolio from the course Git template and add a first entry based on the pre-study guide. Include notes responding to Guiding Questions 1–6, at least one architecture drawing, and at least two screenshots from Wokwi—including the completed simulation artifact. Module 0 is assessed in the second session. This point replaces the former separate assessment point for the introductory session; the Day 1 Master Class remains required portfolio practice.

- **Module 0 and module points:** 11 points total — 1 point for the required pre-study and 10 points across the later module work
- **Reflection points:** 4 points total — one reflection is required for each working day; the exact number of working days, reflection format, and deadlines are announced with the timetable
- **Final project:** 5 points (**25% of the 20 base points**)
- **Extra points:** Up to 3 — outstanding contributions, help, extra projects, completed stretcher tasks, or accepted contributions to IoTempower or this teaching repository
- **Score cap:** The final score is capped at **20**, even if extra points are earned. Extra points can compensate for weaker compulsory components, but all required deliverables must still be attempted and supported by convincing portfolio evidence.
- **Minimum passing score:** 14/20 points (≈70%)

---


## Prerequisites & Tools

### Formal
None beyond course registration.

### Recommended Starting Points
- Basics in programming (helpful but not required; C/C++ basics will be scaffolded)
- Linux/CLI basics (terminal, package management)
- Version control with Git/GitHub
- English at roughly B1/B2 is helpful for documentation and IDE menus; it is not a barrier to participation—see [Language, Communication & Course Material](#language-communication--course-material) for the bilingual course approach and feel free to use AI tools to translate workbook material when useful

### Tools & Hardware Kit
- **Development Environment**: Arduino IDE v2 or PlatformIO (VSCode)
- **Networking & MQTT**: mosquitto_sub/pub (CLI), MQTT Explorer, Node-RED for dashboards
- **IoTempower Framework:** Over-the-Air updates & fleet deployment across ESP boards
- **Laboratory Hardware Kit** (issued during classes):
  – Breadboards and jumper wires
  – Wemos D1 Mini / ESP32 & ESP8266 boards, plus M5StickC for the Day 1 Master class
  – Sensors: Temperature/DHT22, Ultrasonic/PIR, RFID/MFRC522, OLED displays, and additional I²C sensors (for example BME280/BMP280 or a color sensor, depending on availability)
  – Actuators: LEDs, RGB-LEDs, relays, motors (ULN kit), buzzer, stepper (on-demand)
  – Interface kits: I²C & SPI test boards, basic GPIO tools
  – Tools: USB cables, multimeters

---

## Indicative Progression & Assessment

The course reuses and extends modules from the HSBI block workshop. It is delivered over **8–12 sessions/days**, depending on the official timetable, group progress, and available lab time. Some sessions may provide stretcher time; the instructor may also begin the next module during a session, and groups may progress at slightly different speeds.

| Indicative phase | Module / focus | Assessment |
|---|---|---|
| Before the first session | **Module 0** – portfolio setup and pre-study | **1 module point**; assessed in the second session |
| Opening session | **Module 1** – introduction and Master Class (M5StickC + Node-RED mini-workshop) | Required portfolio practice; no separate module point |
| Early lab sessions | **Modules 2–6** – electronics, infrastructure, embedded programming, integration, and IoT systems | **10 module points** total |
| Remaining sessions | **Module 7** – final project: ideation → prototyping → build → live demonstration or video presentation, as agreed during the course | **5 project points** |

Every session combines a short introduction, hands-on lab work, and portfolio documentation. Every working day requires a reflection; together, reflections are worth **4 points**. The LMS will publish the final session plan, reflection details, and deadlines.

- **Module-related points total:** Module 0 (1) + Modules 2–6 (10) = **11**
- **Reflection points total:** **4**
- **Final-project points:** **5**

All labs and reflections are captured in your personal portfolio.

### Portfolio as Primary Artifact
**All course deliverables are captured in your GitHub Portfolio:**
- Pictures, Datasheets, and/or schematics (hand-drawn or Wokwi/Fritzing)
- Firmware source & binaries
- Screenshots: serial console, dashboard values, logic analyzers
- Measured performance graphs (energy, timing, memory footprint)
- Reflections: one reflection for each working day, using the standard format announced through the course LMS. Together, reflections are worth 4 points. The Day 1 Master Class is documented as a normal portfolio work report (pictures, process notes, and peer collaboration), not as a separate reflection topic.

Your logbook should mirror an engineering notebook — continuous, scannable, and explicit.

### Final Capstone Project (5 pts; 25% of base score)
- **Goal**: implement a **complete embedded microcontroller system** with sensors and MQTT/REST integration. Example stories:
  – Patient-monitoring device mock-up (temperature, BME280 data via MQTT)
  – Smart access-control turnstile with RFID badge reader and Node-RED dashboard
  – Autonomous follow-me robot car (ultrasonic ranging, motor H-bridge, MQTT bridge to PC)
  – IoTempower multi-node fleet + monitoring dashboard
- **Must-Haves**: a multi-node system with at least **6 nodes or mobile/wireless devices**; at least **two sensor types and one actuator across three nodes**; a gateway with MQTT; an integration layer (for example Node-RED); a dashboard; and documented architecture. Simulated components and cloud connections are optional. Use IoTempower where appropriate; OTA capability should be demonstrated or documented where feasible.
- **Assessment Criteria** (out of 5):
  – **Functionality & Robustness** (2) [system meets specification and handles errors]
  – **Documentation, Architecture, Performance, Efficiency** (1) [README, diagrams, resource usage, responsiveness, low-power behavior]
  – **Presentation** (2) [story-driven live demonstration or video presentation, as agreed during the course, plus feedback/reflection]
- **Peer review:** The course may introduce peer-review activities; their format and assessment role will be announced before use.

---

## Grade Scale (German terms, English labels)

| **Points (0–20)** | **Grade (German)**       |
|---------------------|---------------------------|
| 0–13               | Fail / nicht bestanden      |
| 14–15              | Passed / bestanden         |
| 16–17              | Satisfactory / befriedigend |
| 18–19              | Good / gut                 |
| 20                 | Very Good / sehr gut       |

- **Module 0 and module points:** 11
- **Reflection points:** 4
- **Project points:** 5
- **Extra points / bonus:** Up to 3; the final score remains capped at 20

---

## Course Materials & Resources (Workbook-based)

Your working environment is the **local microcontroller workbook provided for this course**:

- **Primary Workbook:** [Course front page](./README.md) and [module index](./modules/00-index.md)
- **Master Class Material:** [Mastering IoT Solutions mini-workshop](../../workshops/mastering-iot-solutions/README.md)
- **Portfolio Starter Templates:** [https://github.com/iotempire/iot-portfolio-template](https://github.com/iotempire/iot-portfolio-template)
- **IoTempower Framework:** [https://github.com/iotempire/iotempower](https://github.com/iotempire/iotempower) (vanity URL [https://iotempower.us](https://iotempower.us))
- **IoTempire Organization** (behind all our IoT teaching, tools, and community efforts): [https://iotempire.net/](https://iotempire.net/)
- **Useful Libraries:** ESP8266/ESP32 Arduino Cores, Adafruit (DHT22, BME280), PubSubClient (MQTT), OneWire, MFRC522 (RFID), U8g2 (OLED), FastLED (RGB)
- **Hardware Kit:** Supplied at course start; see Module 2 – Hardware & Electronics for details

Your portfolio must provide the instructor with the evidence needed for assessment. Public sharing of code, logs, schematics, and learning materials is encouraged but **not required**. If you publish, use a suitable licence: for example, MIT for code and CC BY-SA for documentation or media. Accepted pull requests to IoTempower or this teaching repository follow their existing licensing and are an easy route to extra points.

---

## Expectations & Classroom Policies

- **In-class presence:** Active participation in hands-on hardware work is expected and strongly recommended. Students may complete work outside class by agreement with their teammate(s), provided their portfolio convincingly demonstrates skillful completion of the tasks, independent exploration—including failures—and understanding beyond blindly following AI-generated instructions. Students who cannot demonstrate this proficiency and evidence may not receive the relevant module points.
- **Teamwork:** Form teams of 1–2 students for early labs and 4–6 for the capstone project. Document individual roles, tasks, and contributions in your personal portfolio for transparent assessment.
- **Ethics & respect:** Handle kit, peers, and data respectfully. Build **safe prototypes**, document **failure modes**, and consider **stakeholders** in your scenarios.
- **Open by default:** Public sharing is welcome but optional; see the licensing and portfolio guidance above.

---

## Success Strategies – Lab-Tested Tips

1. **Repo housekeeping every session.** Run `git status`, write concise commit messages, link issues to commits. Use branches for experiments.
2. **Reflect continuously.** Use the same standard reflection format after Day 1 and each final-project day — see the [reflection guidance in the portfolio template](https://github.com/iotempire/iot-portfolio-template/blob/main/Reflections/README.md). Complete one reflection for every working day using the deadlines announced through the LMS. Use the same standard reflection format after Day 1 and each final-project day — see the [reflection guidance in the portfolio template](https://github.com/iotempire/iot-portfolio-template/blob/main/Reflections/README.md). 
3. **Fail early, fail often.** Hardware burnout is part of the journey; fall back to serial logs, schematic inspection, and power-pin sanity checks. Report to us if things break, if you are unsure, talk to us.
4. **Portfolio is your lifeline.** Reflections and hardware builds are both graded; treat documentation as seriously as the build. Problems and struggle (when documented) are features and looked upon positively. No problems are worse than documented struggle.
5. **Collaborate generously.** Review teammate's work/PRs or audit or help out with work in another team, attend pair-debug sessions, and share exploration artifacts openly.

---

## Contacts & Questions

- **Questions, schedule, and technical support:** Use the course LMS; the LMS is the authoritative communication channel before and during the course
- **Technical issues:** Report portfolio-repository issues through the agreed course channel
- **Course feedback:** Mid- and end-semester evaluation forms
- **Academic integrity:** Cite sources and ask instructors for clarification before doubt arises

- **Main instructor:** Ulrich Norbisrath (**Ulno**) — [ulno.net](https://ulno.net/)
- **Teaching support:** Fabian Tilman Schmid-Michels *(if available)*
- **Optional community channel:** Announced through the LMS, if offered
