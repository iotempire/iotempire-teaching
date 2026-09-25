# Syllabus: Sensors and Actuators (Sensorik und Aktorik)

> **Important**: This syllabus is a living document and will evolve throughout the semester. Minor updates may apply based on class progress, hardware availability, and student feedback.
>
> **Canonical source:** [IoTempire Teaching repository — HSBI/GT Sensors and Actuators](https://github.com/iotempire/iotempire-teaching/tree/main/full-classes/hsbi-sensors-actuators-10d)

> [!NOTE]
> **Work in progress — new class, first taught in WS 2026/27.** Expect this syllabus to keep changing before and during the semester, and **please come back to check it often**. **Large parts are still a draft**: in each module a *DRAFT BOUNDARY* marks the content that is not settled yet, and it moves down as we approve sections together. Your input is valued and appreciated — I am glad to adapt this class to your program, and your suggestions can change the plan, the tasks, and even this syllabus. If something does not fit, say so early.

---

## Class Times and Locations

- **Schedule, location, and room:** Published in the official HSBI timetable and course LMS before teaching begins.
- **Official announcements and course contact:** Course LMS.
- **Languages of Instruction:** English and German.
- **Course Materials:** English.

---

## Instructors & Teaching Team (HSBI Gütersloh)

| **Role** | **Name** | **Contact / Status** |
|---|---|---|
| Main Instructor | Prof. Dr. Ulrich Norbisrath (**Ulno**) | [ulno.net](https://ulno.net) |
| Teaching Support | Fabian Tilman Schmid-Michels *(if available)* | To be confirmed |

> [!NOTE]
> **Course information:** Ulno is the primary instructor for this HSBI offering. The course LMS is the authoritative source for local dates, rooms, contact details, and announcements. An optional Discord space or chat may be offered as an additional community channel; students and interested people are always welcome to join the main **IoTempire community Discord** (link maintained in the [repository README](../../README.md#references--resources)).

---

## Language, Communication & Course Material

This class is taught in **English and German**. The shared workbook, slides, code, documentation, and technical exercises are in English to ensure reusability and align with modern engineering practice.

Ulno is fully bilingual. You are welcome to speak with the teaching team and collaborate with your peers in **German, English, or a mixture of both**. Notes, portfolio documentation, reports, and presentations may likewise be submitted in German, English, or mixed language. Ask whenever technical vocabulary or a task formulation needs clarification in either language.

**Für deutschsprachige Studierende:** Diese Lehrveranstaltung findet auf Englisch und Deutsch statt. Das gemeinsame Workbook, die Folien, der Code, die Dokumentation und die Übungen bleiben auf Englisch, damit sie einheitlich genutzt werden können. Ulno ist zweisprachig; Sie können mit dem Lehrteam und untereinander auf Deutsch, Englisch oder in einer Mischung aus beiden Sprachen sprechen und arbeiten. Notizen, Portfolio-Dokumentation und Präsentationen dürfen ebenfalls auf Deutsch, Englisch oder gemischt verfasst werden. Fragen Sie jederzeit nach, wenn Fachbegriffe oder Aufgabenstellungen geklärt werden sollen.

---

## Course Description & Philosophy

### Sensors and Actuators — From Measurement Fundamentals to Buildable Systems

A sensor is not a number, and an actuator is not a pin that goes high. This course keeps the classical foundations that the module handbook requires — **measurement technique**, **error and uncertainty**, the **digital signal chain**, **sensor characterization**, and the principles of **mechanical, thermal, optical, and unconventional actuators** — but teaches them the way they are actually used: by measuring, wiring, calibrating, and building.

Instead of memorizing a catalogue of principles, you will:

- **Understand the bus before the device.** Most modern sensors hang on **I²C**, and the first real skill is understanding *addresses*, register maps, pull-ups, and how several devices share one pair of wires. We go to the bus early — a scanner is more educational than a library.
- **Characterize what you measure.** You will determine real **transfer functions**, **linearity**, **hysteresis**, **resolution**, and **uncertainty** for sensors you can hold, and you will calibrate and filter them.
- **Build real sensor and actuator systems.** Distance and motion sensing (ToF, ultrasonic, IMU), current and flow sensing (Hall, light barriers), and modern actuators: **servo and other motors**, relays, and above all **LEDs and LED animation** — from a single PWM fade to an interactive, sound-reactive installation.
- **Connect it to a system.** Your sensor/actuator node becomes part of a local-first **IoTempower**-managed, MQTT-connected system with a Node-RED dashboard and a closed control loop.

This gives you both: the measurement competence that a sensor engineer needs, and the practical, documented system-building habits of modern IoT work. You will measure with a multimeter and a data sheet *and* flash, deploy, and animate.

> [!IMPORTANT]
> **Local-first, buildable, documented.** The course is designed around hardware you actually have: M5Stack nodes with Grove modules for the fast path, and raw ESP32/ESP8266 plus breadboard parts when physics matters. Cloud services are optional; everything core runs on the local network.

---

### How We Teach — Challenge- and Project-Based, In Person, and Always in Flux

This course is deliberately taught as **Challenge-Based** and **Project-Based Learning** (CBL/PBL): you learn by investigating an authentic challenge and building a real solution, not by reproducing a lecture. We begin from **stories** — a real problem that matters to you and the people it touches — because you learn best what connects to something meaningful for your own life, studies, or community. Your instructors genuinely care that you find that connection.

It also matters that we do this **in person, together** — a university class is at its best where we actually meet. You will learn a great deal from direct interaction with your peers: explaining, questioning, debugging, and demoing to one another, while your instructors learn alongside you.

And this class is **always in flux — that is a feature, not a bug**. No course is ever finished: every offering is adjusted while it runs, and each class teaches us as much as it teaches you. Expect the plan, the tasks, and even this syllabus to move as we discover together what works best; your questions, ideas, and feedback are part of the design.

> **Want to read more?** Challenge-Based Learning — [en.wikipedia.org/wiki/Challenge-based_learning](https://en.wikipedia.org/wiki/Challenge-based_learning) · Project-Based Learning — [pblworks.org/what-is-pbl](https://www.pblworks.org/what-is-pbl) · Why active, interactive learning beats passive lectures — [Harvard Gazette, 2019](https://news.harvard.edu/gazette/story/2019/09/study-shows-that-students-learn-more-when-taking-part-in-classrooms-that-employ-active-learning-strategies)

---

## Learning Objectives

By the end of this course, you will be able to:

1. **Explain measurement fundamentals:** true value, measurement error, uncertainty, accuracy vs. precision, resolution, range, and sensitivity.
2. **Analyze the digital signal chain:** transducer, signal conditioning, ADC, sampling theorem, quantization, and coding — and estimate the resulting uncertainty.
3. **Explain sensor principles** for position, distance (triangulation, ToF, ultrasonic), motion/rotation (gyroscope, accelerometer), force/torque (strain gauge), magnetic field (Hall), and environment (temperature, humidity, pressure).
4. **Describe actuator principles** — mechanical, thermal, optical, and unconventional — and compare which actuator fits which application scenario.
5. **Characterize and calibrate sensors:** determine the transfer function, assess linearity, hysteresis, repeatability, and resolution, apply calibration and filtering, and state the measurement uncertainty.
6. **Use buses competently:** wire, scan, and debug an **I²C** bus, handle device addresses and register maps, and distinguish I²C from SPI, UART, OneWire, and direct GPIO/PWM.
7. **Drive actuators safely:** implement PWM brightness and LED animation (RGB, addressable WS2812), control servos, DC motors, and steppers with suitable drivers, respecting voltage, current, and thermal limits.
8. **Build and evaluate sensor/actuator systems:** design an embedded node that senses and acts, integrate it via IoTempower, MQTT, and Node-RED, and document performance (resolution, latency, power, robustness).

---

## Course Load & Credits

- **Format:** 10 working days / 12 sessions (4 hours each) across the semester; 48 contact hours.
- **Target Audience:** Bachelor students in *Digitale Technologien* (6th semester, Campus Gütersloh).
- **Module Number:** 3350 (*Sensorik und Aktorik*).
- **Total Workload:** 150 hours (5 ECTS credits).
  - In-person lab and seminar contact: 48 hours.
  - Independent preparation and pre-study (Module 0): approx. 30 hours allocated (3–6 hours for the compulsory core).
  - Guided self-study, portfolio documentation, and final project: approx. 72 hours.

### Prerequisites & Relationship to Other Modules

- **Formal:** none beyond course registration.
- **Content:** mathematical and technical fundamentals (basic algebra, physical units, basic electronics help); ability to work with Git, a terminal, and a markup language is expected, as in the other IoT courses.
- **Standalone elective:** *Sensorik und Aktorik* is a **6th-semester elective (Wahlmodul)** that stands on its own — it neither requires nor continues a specific earlier module. It concentrates on the *physical* side of IoT — what a sensor really measures and how an actuator really moves — and introduces the small amount of local-first infrastructure it uses (a node, a local MQTT broker, Node-RED) within the course itself.
- **Building on an earlier project (optional, by agreement):** the final project is **self-contained by default**. If you would like to continue an earlier project of your own, that is very welcome — **just talk to the instructor**, and we will agree on the scope and on how the sensors/actuators part is deepened (each module is graded separately).

---

## Assessment: Kombinationsprüfung (20 Base Points + Bonus)

Assessment is conducted as a **Kombinationsprüfung** combining continuous portfolio documentation, laboratory and measurement work, working-day reflections, and a final project.

> [!IMPORTANT]
> **Module 0 is required and worth 1 module point.** Before the first session, set up your personal GitHub portfolio using the course template and complete the pre-study tasks outlined in [pre-study.md](./pre-study.md), including the Wokwi mini-exercise. Module 0 is assessed during the second session.

### Points Breakdown

| Component | Points | Details |
|---|---|---|
| **Module 0 (Pre-Study)** | **1 point** | Portfolio setup, Wokwi simulation, datasheet reading, and answers to guiding questions. |
| **Modules 1–8 (Learning goals)** | **10 points** | Earned through **checkpoint presentations** (~10 min each, covering 2–3 modules) that prove the module learning goals from your portfolio and reflections — not by completing every task. Lab evidence: measurement, I²C scan and register reads, sensor characterization, distance/motion labs, LED and animation labs, motor control, IoTempower integration. |
| **Working-Day Reflections** | **4 points** | Individual reflections submitted for each working day/session documenting measurements, failed attempts, and conceptual takeaways. |
| **Final Project** | **5 points** | 25% of the base score. A documented sensor/actuator system with real characterization, an actuator demonstration, and an integration layer. |
| **Base Total** | **20 points** | **100% base score.** |
| **Extra / Bonus Points** | **Up to 3 points** | Awarded for outstanding contributions, peer mentoring, advanced stretcher tasks, or accepted upstream pull requests to IoTempower or this curriculum repository. |

- **Score cap:** The final score is capped at **20 points**, even if bonus points are earned. Bonus points compensate for minor weaknesses in regular deliverables, but all compulsory components must still be attempted.
- **Passing threshold:** Minimum 14 out of 20 points (~70%) to pass (*bestanden*).

### How module points are earned: checkpoint presentations

You do **not** submit and grade every task. Instead, you earn a module's points in a short, **personal checkpoint presentation** (about **10 minutes**) with the instructor, based on your **portfolio and working-day reflections**. Checkpoints happen in class and cover **2–3 modules at a time**; the schedule is announced through the LMS.

In a checkpoint, you:
1. **Show your evidence** — portfolio entries, measurements, code, diagrams, and reflections for the modules being checked.
2. **Prove the learning goals** — the goals listed at the top of each module. Walk the instructor through how your work shows you reached them, and answer questions about them.

Because assessment targets the **learning goals, not task completion**, you are free to **skip tasks, fail at tasks, or add your own**. An honest, documented failure counts as **exploration**, not as a loss, and a convincing demonstration of **deep understanding or analysis** is rewarded generously. If a topic excites you, go deep — that is exactly what this format is meant to encourage.

Practical notes:
- Bring your portfolio (and any device or demo) to the checkpoint.
- Expect to explain a measurement, justify a design choice, or read a register or datasheet live.
- If you cannot attend a checkpoint, talk to the instructor early; a missed checkpoint is handled like a missed deadline.

### Grade Scale

| **Points (0–20)** | **German Grade** | **Status** |
|---|---|---|
| 0–13 | Nicht bestanden (5.0) | Fail |
| 14–15 | Ausreichend (4.0) | Passed |
| 16–17 | Befriedigend (3.0) | Satisfactory |
| 18–19 | Gut (2.0) | Good |
| 20 | Sehr gut (1.0) | Very Good |

---

## Hardware Kit & Laboratory Equipment

The kit is deliberately **two-layered**, so you can move fast and still meet real physics:

- **Fast path — M5Stack nodes and Grove modules:**
  - M5StickC Plus2 and/or M5Atom Matrix / Lite (ESP32-based, built-in display, button, IMU, Grove port).
  - Grove sensors (I²C and analog): environment (T/RH/P), ToF distance, PIR, light/gesture.
  - Grove actuators: RGB LED, buzzer, servo, relay.
- **Physics path — raw microcontrollers and discrete parts:**
  - ESP32 DevKits, **ESP32 Ethernet mini kits**, and ESP8266 / Wemos D1 Mini boards, breadboards, jumper wires, resistors, capacitors, diodes.
  - Discrete sensors: NTC 10 kΩ, LDR, Hall-effect (analog + digital latch), DS18B20 (OneWire), MPU6050 (I²C), ultrasonic, light barrier (photo-interrupter).
  - Actuators: SG90 servo, small DC motor, 28BYJ-48 stepper with ULN2003, H-bridge driver (TB6612 / L298N), 5 V relay, piezo buzzer, high-brightness RGB LEDs, WS2812 / NeoPixel strip.
- **Instruments:**
  - Digital multimeter, USB power meter, thermometer for reference measurements.
  - Optional: USB logic analyzer (for I²C/PWM/WS2812 traces), oscilloscope if available.
- **Gateway & infrastructure (local-first):**
  - A local OpenWrt travel router or a small Linux/Raspberry Pi host running Mosquitto and Node-RED; laptops; USB power supplies and hubs.
- **Software:** Arduino IDE v2 or PlatformIO, IoTempower, Node-RED, Mosquitto, `i2c-tools`, FastLED, Wokwi (browser).

> [!WARNING]
> **Electrical safety.** All microcontrollers here are 3.3 V logic. Never power motors, relays, strips, or locks directly from a GPIO pin. Always share a common ground between logic and load supplies, and never connect 5 V or 12 V to a 3.3 V pin.

---

## 10-Day Course Schedule

The 10 days correspond to the 12 4-hour sessions across the semester. Modules 1–8 deliver the technical foundations; the final project arc (Modules 9–10) spans the remaining studio sessions so there is genuine build, characterization, and rehearsal time.

> **Indicative plan.** The day-by-day mapping below is a planning draft and may shift — including during the semester — as we refine this class together. The learning objectives and the final project matter more than the exact day a topic lands on.

| Day | Session(s) | Module / Topic | Core Hands-on Focus |
|:---:|:---:|---|---|
| **0** | — | **[Pre-Study](./pre-study.md)** | Measurement basics, datasheet reading, Wokwi mini-exercise, project scenario abstract. |
| **1** | 1 | **[Module 1 — Foundations: Measurement, Signals & the Sensor–Actuator Chain](./modules/01-foundations-measurement-and-sensor-chain.md)** | Metrology and error, the digital signal chain, ADC precision dance, Master Class sensor node. |
| **2** | 2 | **[Module 2 — I²C & Sensor Addressing](./modules/02-i2c-and-sensor-addressing.md)** | Wiring and scanning an I²C bus, 7-bit addresses, register maps, two devices on one bus, address conflicts. |
| **3** | 3 | **[Module 3 — Sensor Characterization, Calibration & Data Quality](./modules/03-sensor-characterization-and-calibration.md)** | Transfer function, linearity, hysteresis, calibration, filtering, uncertainty of an NTC/LDR. |
| **4** | 4 | **[Module 4 — Distance, Motion & Environment Sensors](./modules/04-distance-motion-and-environment-sensors.md)** | ToF and ultrasonic distance, person counting, IMU tilt/rotation, Hall-effect current sensing. |
| **5** | 5 | **[Module 5 — LEDs & Light as Output](./modules/05-leds-and-light-output.md)** | LED current limiting, PWM and gamma, RGB mixing, first addressable strip and power budget. |
| **6** | 6 | **[Module 6 — LED Animation, Sound & Interactive Installations](./modules/06-led-animation-sound-and-installations.md)** | Non-blocking animation patterns, palettes, sensor-triggered and sound-reactive installations. |
| **7** | 7 | **[Module 7 — Motors & Motion Actuators](./modules/07-motors-and-motion-actuators.md)** | Servo control, DC motor speed/direction with an H-bridge, stepper stepping, current measurement. |
| **8** | 8 | **[Module 8 — From Sensor to System: IoTempower & Integration](./modules/08-sensor-to-system-and-integration.md)** | Declarative drivers and filters, MQTT topics, Node-RED dashboard, a closed control loop. |
| **9** | 9–10 | **[Module 9 — Final Project Studio](./modules/09-final-project-studio.md)** | Project kickoff and story, requirement mapping, building and integrating the sensor/actuator system. |
| **10** | 11 | **[Module 9 — Final Project Studio (continued)](./modules/09-final-project-studio.md)** | Characterization and evaluation, fault injection, documentation, peer review dry run. |
| **10** | 12 | **[Module 10 — Demonstration & Portfolio Defense](./modules/10-demonstration-and-defense.md)** | Live sensor/actuator demonstration, technical defense, portfolio presentation, retrospective. |

> [!TIP]
> **Buffer and pacing:** Days 9–10 provide four studio sessions. At least one is deliberately loose and can absorb spill-over from earlier labs, be released as flexible/wiggle time, or be used for stretcher tasks and peer mentoring. Announce the concrete use of each studio session in the LMS as the course progresses.

---

## Final Project Requirements (5 Points)

The final project is a **sensor/actuator system** built by teams of 2–4 students. Teams form and pitch a stakeholder **story** during the project kickoff (Module 9), then map their requirements onto the criteria below. A team may, **by agreement with the instructor**, continue an earlier project of their own instead of starting fresh — this is a possibility, not a requirement; the default is a self-contained sensor/actuator project.

### Must-Have System Criteria:
1. **Sensing with real characterization:** At least **two sensors**, including **at least one I²C device**, with the **transfer function or calibration** of at least one sensor determined from your own measurements, plus a stated uncertainty and resolution.
2. **Actuation:** At least **one actuator that physically acts** — a motor/servo/stepper, or an addressable LED installation — demonstrated under program control.
3. **The bus is understood, not hidden:** Evidence that you scanned/identified your I²C device(s), can name the address(es), and read or reasoned about at least one register/raw value.
4. **Embedded integration:** The node is deployed via **IoTempower** (declarative device definition, at least one filter for processing) with documented MQTT topics.
5. **System layer:** A **Node-RED dashboard** (or Python service) that displays the measured data and can control at least one actuator, including one **closed-loop or rule-based behavior** (e.g. threshold control, on/off control, animation tied to a sensor).
6. **Evaluation:** Documented measurement and performance evidence — e.g. resolution, latency, sampling rate, current consumption, or robustness to noise/interference.
7. **Reliability:** The system recovers gracefully from a sensor disconnect, an I²C device that fails to answer, an actuator stall, or a broker restart (tested during the demo).

### Assessment Criteria:
- **System Functionality & Measurement Quality (2 points):** Meets specifications; the characterization is credible and the actuator demonstration is reliable.
- **Architecture, Documentation & Evaluation (1.5 points):** Clear wiring/system diagram, bus and addressing documentation, transfer-function/calibration evidence and evaluation in the portfolio.
- **Live Demonstration & Presentation (1.5 points):** Clear 5-minute technical demo showing the measured quantity, the actuation, and explanation of the underlying sensor/actuator principles.

---

## Portfolio & Documentation Standards

All assessments are based on your personal **GitHub Portfolio** (forked from [iot-portfolio-template](https://github.com/iotempire/iot-portfolio-template)):

- Maintain a clean Git log with descriptive commit messages.
- For each module, include:
  - Circuit diagrams and photos of your wiring (hand-drawn or EDA-tool schematics are both fine).
  - Firmware/configuration (Arduino sketches, PlatformIO projects, IoTempower `setup.cpp` and node definitions).
  - Measurement tables, plots (transfer function, hysteresis, animation/power traces), and calibration notes.
  - Screenshots of serial plots, I²C scans, Node-RED dashboards, and terminal output.
  - Working-day reflections (what worked, what failed, what you learned, open questions).
- In sensor work, **documented calibration and honest uncertainty beat a single lucky reading**. Showing how you discovered a noisy channel, an off-by-one register, or a wrong address is worth more than a superficial "it worked" report.

---

## Classroom Policies & Success Strategies

1. **Active Participation:** Labs require hands-on physical work with breadboards, sensors, motors, and strips. Bring your laptop (Arduino IDE or PlatformIO installed).
2. **Electrical Hygiene:** Always disconnect power before rewiring. Check voltage levels and polarity before connecting. Never power actuators from GPIO pins; share ground properly.
3. **Pair & Collaborate:** Work in pairs during wiring labs. Two pairs of eyes on a floating SDA line or a hot motor driver save the afternoon.
4. **Measurement Mindset:** Write down what you measured, with what, and how uncertain it is. A number without units, conditions, or uncertainty is not a measurement.
5. **Open Source Mindset:** Share discoveries and help peer teams. Accepted pull requests to IoTempower, the course repository, or open-source tools qualify for extra credit.

---

## Contacts & Support

- **Primary Communication Channel:** Course LMS (ILIAS). Check regularly for updates and announcements.
- **Main Instructor:** Prof. Dr. Ulrich Norbisrath (**Ulno**) — [ulno.net](https://ulno.net/)
- **IoTempire Community:** [iotempire.net](https://iotempire.net/)
- **IoTempower Framework:** [https://iotempower.us](https://iotempower.us) / [GitHub](https://github.com/iotempire/iotempower)
