# Syllabus: Sensors and Actuators (Sensorik und Aktorik)

> Important: This syllabus is a living document and will evolve throughout the semester. Minor updates may apply based on class progress, hardware availability, and student feedback.
>
> **Canonical source:** [IoTempire Teaching repository — HSBI/GT Sensors and Actuators](https://github.com/iotempire/iotempire-teaching/tree/main/full-classes/hsbi-sensors-actuators-10d)

> [!NOTE]
> **Every module begins with its learning goals.** Those goals are the agreement between you and the instructor: you earn a module's points by *demonstrating the goals* — in a short checkpoint conversation and through your portfolio — not by ticking off every task. The goals are fixed; the way you reach them is yours.

> [!NOTE]
> **This class is a draft in motion.** It is a first-time offering in WS 2026/27. In every module a ***DRAFT BOUNDARY*** marks the part that is not settled yet; it moves down as we approve content together. Expect this syllabus to keep changing, and bring your own deep dives and stretchers — your input can shape the class.

## Class Times and Locations

- Schedule, location, and room: Published in the official HSBI timetable and course LMS before teaching begins.
- Official announcements and course contact: Course LMS.
- Languages of Instruction: English and German.
- Course Materials: English.

## Instructors & Teaching Team (HSBI Gütersloh)

| Role | Name | Contact / Status |
|---|---|---|
| Main Instructor | Prof. Dr. Ulrich Norbisrath (Ulno) | [ulno.net](https://ulno.net) |
| Teaching Support | Fabian Tilman Schmid-Michels *(if available)* | To be confirmed |

> [!NOTE]
> **Course information:** Ulno is the primary instructor for this HSBI offering. The course LMS is the authoritative source for local dates, rooms, contact details, and announcements. An optional Discord space or chat may be offered as an additional community channel; students and interested people are always welcome to join the main IoTempire community Discord (link maintained in the [repository README](../../README.md#references--resources)).

<a id="language-communication--course-material"></a>
## Language, Communication & Course Material

This class is taught in **English and German**. The shared workbook, code, documentation, and technical exercises are in **English**, so the material stays reusable and consistent.

Ulno is fully bilingual. You are welcome to speak with the teaching team and collaborate with your peers in German, English, or a mixture of both. Notes, portfolio documentation, reports, and presentations may likewise be submitted in German, English, or mixed language. Ask whenever technical vocabulary or a task formulation needs clarification in either language. Write plainly and precisely rather than perfectly: clear technical communication matters far more than flawless grammar.

**Für deutschsprachige Studierende:** Diese Lehrveranstaltung findet auf Englisch und Deutsch statt. Das gemeinsame Workbook, der Code, die Dokumentation und die Übungen bleiben auf Englisch, damit sie einheitlich genutzt werden können. Ulno ist zweisprachig; Sie können mit dem Lehrteam und untereinander auf Deutsch, Englisch oder in einer Mischung aus beiden Sprachen sprechen und arbeiten. Notizen, Portfolio-Dokumentation und Präsentationen dürfen ebenfalls auf Deutsch, Englisch oder gemischt verfasst werden. Fragen Sie jederzeit nach, wenn Fachbegriffe oder Aufgabenstellungen geklärt werden sollen.

## Course Description & Philosophy

### Sensors and Actuators — From Measurement Fundamentals to Buildable Systems

> **One question runs through the whole course:** *How does a physical quantity become a trustworthy number — and how does that number move the world?*

A sensor is not a number, and an actuator is not a pin that goes high. This course keeps the classical foundations that the module handbook requires — measurement technique, error and uncertainty, the digital signal chain, sensor characterization, and the principles of mechanical, thermal, optical, and unconventional actuators — but teaches them the way they are actually used: by measuring, wiring, calibrating, and building.

Instead of memorizing a catalogue of principles, you will:

- **Understand the bus before the device.** Most modern sensors hang on I²C, and the first real skill is understanding *addresses*, register maps, pull-ups, and how several devices share one pair of wires. We go to the bus early — a scanner is more educational than a library.
- **Characterize what you measure.** You will determine real transfer functions, linearity, hysteresis, resolution, and uncertainty for sensors you can hold, and you will calibrate and filter them.
- **Build real sensor and actuator systems.** Distance and motion sensing (ToF, ultrasonic, IMU), current sensing (Hall), environment sensing, and modern actuators: servo and other motors, relays, and above all LEDs and LED animation — from a single PWM fade to an interactive, sound-reactive installation.
- **Connect it to a system.** Your sensor/actuator node publishes directly over MQTT to a Mosquitto broker running anywhere on the local network, with an optional Node-RED dashboard and a closed control loop. IoTempower is available as an optional declarative path to explore.
- **Prove every claim.** A number without units, conditions, and uncertainty is not a measurement. A demonstration without a characterization is not engineering.

This gives you both: the measurement competence that a sensor engineer needs, and the practical, documented system-building habits of modern IoT work. You will measure with a multimeter and a data sheet *and* flash, deploy, and animate.

> [!IMPORTANT]
> Local-first, buildable, documented. The course is designed around hardware you actually have: M5Stack nodes with Grove modules for the fast path, and raw ESP32/ESP8266 plus breadboard parts when physics matters. Cloud services are optional; everything core runs on the local network.

### How We Teach — Challenge- and Project-Based, In Person, and Always in Flux

This course is deliberately taught as Challenge-Based and Project-Based Learning (CBL/PBL): you learn by investigating an authentic challenge and building a real solution, not by reproducing a lecture. We begin from stories — a real problem that matters to you and the people it touches — because you learn best what connects to something meaningful for your own life, studies, or community. Your instructors genuinely care that you find that connection.

It also matters that we do this in person, together — a university class is at its best where we actually meet. You will learn a great deal from direct interaction with your peers: explaining a measurement, questioning a wiring choice, debugging a bus, and demoing to one another, while your instructors learn alongside you.

And this class is always in flux — that is a feature, not a bug. No course is ever finished: every offering is adjusted while it runs, and each class teaches us as much as it teaches you. Expect the plan, the tasks, and even this syllabus to move as we discover together what works best; your questions, ideas, and feedback are part of the design.

> Want to read more? Challenge-Based Learning — [en.wikipedia.org/wiki/Challenge-based_learning](https://en.wikipedia.org/wiki/Challenge-based_learning) · Project-Based Learning — [pblworks.org/what-is-pbl](https://www.pblworks.org/what-is-pbl) · Why active, interactive learning beats passive lectures — [Harvard Gazette, 2019](https://news.harvard.edu/gazette/story/2019/09/study-shows-that-students-learn-more-when-taking-part-in-classrooms-that-employ-active-learning-strategies)

## Learning Objectives

By the end of this course, you will be able to (mapped to the module-handbook competence goals):

1. **Explain measurement fundamentals**: true value, measurement error, uncertainty, accuracy vs. precision, resolution, range, and sensitivity.
2. **Analyze the digital signal chain**: transducer, signal conditioning, ADC, sampling theorem, quantization, and coding — and estimate the resulting uncertainty.
3. **Explain sensor principles** for position, distance (triangulation, ToF, ultrasonic), motion/rotation (gyroscope, accelerometer), force/torque (strain gauge), magnetic field (Hall), and environment (temperature, humidity, pressure).
4. **Describe actuator principles** — mechanical, thermal, optical, and unconventional — and compare which actuator fits which application scenario.
5. **Characterize and calibrate sensors**: determine the transfer function, assess linearity, hysteresis, repeatability, and resolution, apply calibration and filtering, and state the measurement uncertainty.
6. **Use buses competently**: wire, scan, and debug an I²C bus, handle device addresses and register maps, and distinguish I²C from SPI, UART, OneWire, and direct GPIO/PWM.
7. **Drive actuators safely**: implement PWM brightness and LED animation (RGB, addressable WS2812), control servos, DC motors, and steppers with suitable drivers, respecting voltage, current, and thermal limits.
8. **Build and evaluate sensor/actuator systems**: design an embedded node that senses and acts, integrate it via MQTT and optionally Node-RED (with IoTempower as an optional declarative alternative), and document performance (resolution, latency, power, robustness).

## Course Load & Credits

- Format: 10 working days / 12 sessions (4 hours each) across the semester; 48 contact hours.
- Target Audience: Bachelor students in *Digitale Technologien* (6th semester, Campus Gütersloh).
- Module Number: 3350 (*Sensorik und Aktorik*), 5 ECTS.
- Total Workload: 150 hours.
  - In-person lab and seminar contact: 48 hours.
  - Independent preparation and pre-study (Module 0): the compulsory core is a few hours; the syllabus allocates room for deeper preparation.
  - Guided self-study, portfolio documentation, and final project: the remaining balance.

> [!NOTE]
> **Where the 150 hours come from.** The module handbook specifies 150 h (5 ECTS). The delivered format is 12 four-hour sessions plus portfolio work, characterization, and the final project. Treat the session count as fixed (12) and the *hours per session* as ~4.

### Prerequisites & Relationship to Other Modules

- **Formal:** none beyond course registration.
- **Content:** mathematical and technical fundamentals (basic algebra, physical units, basic electronics) help; ability to work with Git, a terminal, and a markup language is expected, as in the other IoT courses.
- **Standalone elective:** *Sensorik und Aktorik* is a 6th-semester elective (Wahlmodul) that stands on its own — it neither requires nor continues a specific earlier module. It concentrates on the *physical* side of IoT — what a sensor really measures and how an actuator really moves — and introduces the small amount of local-first infrastructure it uses (a node, a local MQTT broker, Node-RED) within the course itself.
- **Building on an earlier project (optional, by agreement):** the final project is self-contained by default. If you would like to continue an earlier project of your own, that is very welcome — just talk to the instructor, and we will agree on the scope and on how the sensors/actuators part is deepened.

<a id="assessment-kombinationsprüfung-20-base-points--bonus"></a>
## Assessment: Kombinationsprüfung (20 Base Points + Bonus)

Assessment is a **Kombinationsprüfung** combining continuous portfolio documentation, laboratory and measurement work, reflection logbook entries, and a final project. The formal form is fixed by the module handbook; where the handbook version constrains the mix, the instructor will announce the binding variant in the LMS. Everything below is the working agreement for this offering.

You build and maintain one personal **GitHub portfolio**. The small tasks in each module are how you **prove that module's learning goals**, personalized through your **reflections**, and short **checkpoints** give you feedback on whether those goals have been achieved — while also giving the instructor a sense of your performance. In the **last session you present your final project to the instructor and to each other**.

> [!IMPORTANT]
> **Module 0 and Modules 1–8 are worth 11 of the 20 base points.** You earn them by demonstrating the modules' learning goals in short checkpoints — not by completing every task. Module 0 is normally completed before Day 1; in a cohort that needs more setup time, it can be run as the first in-class module instead (same 1 point, same evidence).

### Points Breakdown

| Component | Points | Details |
|---|---|---|
| Module 0 (Pre-Study) | 1 point | Portfolio setup from the template, Wokwi simulation, datasheet reading, and answers to the guiding questions. |
| Modules 1–8 (Learning goals) | 10 points | Earned through short checkpoint presentations that prove the module learning goals from your portfolio: measurement and signal chain, I²C scan and register reads, sensor characterization, distance/motion/environment labs, LED and animation labs, motor control, and MQTT system integration. |
| Reflection points | 4 points | One logbook entry for each teaching block (four blocks: Days 1–3, 4–6, 7–8, and 9–10), captured in your personal logbook. |
| Final meaningful project | 5 points | 25% of the base score. A documented sensor/actuator system with real characterization, an actuator demonstration, and an integration layer, built in a **Project Team** of 4–6. |
| **Base total** | **20 points** | 100% base score. |
| Extra / bonus points | up to +3 | Outstanding benchmarking/characterization, accepted open-source pull requests to IoTempower or class repositories, or verified peer debugging and mentoring. |

- **Score cap:** The final score is capped at 20 points, even if bonus points are earned. Bonus points compensate for minor weaknesses in regular deliverables, but all compulsory components must still be attempted.
- **Passing threshold:** Minimum **14 out of 20 points** (~70%) to pass (*bestanden*).

<a id="how-module-points-are-earned-checkpoint-presentations"></a>
### How module points are earned: checkpoint presentations

You do not submit and grade every task. Instead, you earn a module's points in a short checkpoint presentation — **10–12 minutes, including questions and feedback** — with the instructor, based on your portfolio and reflection logbook. Checkpoints are done **with your Task Pod, in person**, and cover a few modules at a time:

- **Checkpoint 1 — start of Day 4 (Modules 1–3).** For a larger cohort this runs as a **30-minute 2-pod practice round**: two pods pair up; each pod presents from its existing portfolios, and the other pod gives free-style feedback and questions checking how well the goals were proven. The instructor assesses from the presentations and the portfolios. In a small cohort, use the same slot for individual pod checkpoints.
- **Checkpoint 2 — start of Day 8 (Modules 4–6).**
- **Checkpoint 3 — start of Day 9 project studio (Modules 7–8)**, or folded into the final defense by agreement with the instructor.

Dates and slots are confirmed through the LMS.

**Task Pods, and how checkpoints scale.** We work in **Task Pods** — small crews of **two or three** (three by default for a large cohort, roughly >40 students; a few **two-person pods** are welcome precisely because they reduce the instructor's checkpoint load; a fourth podmate is only by arrangement). The point is *small*, not rigid.

> **Why “Task Pod”?** In container orchestration (Kubernetes), a **pod** is the *smallest deployable unit* — one or a few tightly-coupled containers that are scheduled, run, and retired together. A **Task Pod** is the same idea for people: your tight little crew of two or three that owns one task end-to-end. Your **Project Team** is the larger unit — the alliance of two pods that ships the whole system.

**These Task Pods are for the labs and checkpoints; the final project merges two pods into a Project Team of 4–6** (see [Final Project Requirements](#final-project-requirements-5-points)).

In a checkpoint, you:

1. **Show your evidence** — portfolio entries, measurement tables, plots, code, diagrams, I²C scans, and reflections for the modules being checked.
2. **Prove the learning goals** — the goals listed at the top of each module. Walk the instructor through how your work shows you reached them, and answer questions about them (expect to explain a measurement, justify a wiring choice, or read a register or datasheet live).

**Because assessment targets the learning goals — not task completion — the tasks are negotiable.** You are free to skip tasks, fail at tasks, or add your own, and for tasks below a module's draft boundary to **modify or replace them entirely, as long as you reach the same learning goals**. An honest, documented failure counts as exploration, not as a loss, and a convincing demonstration of deep understanding or analysis is rewarded generously.

Practical notes:

- Bring your portfolio (and your device or demo) to the checkpoint.
- Expect to explain a measurement, justify a design choice, or read a register or datasheet live.
- For a 2-pod practice round, bring your portfolio ready to present, and expect to give — and take — free-style feedback.
- If you **cannot attend in person**, talk to the instructor early and submit a **7–10 minute video** plus a **3–5 page explained excerpt** from your portfolio for review. You get less feedback than in an in-person checkpoint; a missed in-person checkpoint without such a submission is handled like a missed deadline.

### Task tiers: ★ Core and ◇ Stretcher

Tasks are marked **★ Core** or **◇ Stretcher**. A **★ Core** task is one we consider *core* to the module — the straightforward way to reach its learning goals. It is not a hard requirement, but note the asymmetry: for an ordinary task you can argue “this was not needed to reach the goals” and we will usually accept it; for a **★ Core** task that argument is harder, so skipping one means convincing us you reached the same goals another way. A **◇ Stretcher** is optional — an extension, a deeper dive, or bonus material, and the natural trim point when time is short. **Have a better task idea?** Propose it; if it reaches the same learning goal, we can swap it into the module — student-designed tasks are explicitly welcome.

### Reflection format

For each teaching block, write one logbook entry in `Reflections/refNN.md`, using the [reflection template](https://github.com/iotempire/iot-portfolio-template/blob/main/Reflections/TEMPLATE.md). The template includes the **AI-verification** question.

### Grade Scale

| Points (0–20) | German Grade | Status |
|---|---|---|
| 0–13 | Nicht bestanden (5.0) | Fail |
| 14–15 | Ausreichend (4.0) | Passed |
| 16–17 | Befriedigend (3.0) | Satisfactory |
| 18–19 | Gut (2.0) | Good |
| 20 | Sehr gut (1.0) | Very Good |

## Tools & Environment

| Layer | Tool | Notes |
|---|---|---|
| Editor | **VS Code** or **Zed** | Use the **integrated terminal** and the Git UI; keep the workbook open beside your code. |
| Terminal | **bash** (Git Bash on Windows) | The labs use heredocs, `<` redirects, and `mkdir -p`; Git Bash ships with Git for Windows. |
| Version control | **Git + GitHub** | Your portfolio is the evidence artifact. Create it from the template with **“Use this template”**, not a fork. |
| Firmware | **Arduino IDE v2** or **PlatformIO** | ESP32/ESP8266 cores; pick one and stay consistent. |
| Declarative deployment (optional) | **IoTempower** | Optional exploration of drivers, filters, and OTA deployment. |
| System layer | **Mosquitto + optional Node-RED** | Mosquitto broker on any host in the network; direct MQTT from the node (`PubSubClient` / `paho-mqtt`); optional Python glue. |
| Python (optional) | **`uv`** | If you write integration scripts, pin Python and libraries with `uv`; commit `pyproject.toml` and `uv.lock`, never `.venv/`. |
| AI co-pilots | **ChatGPT / Claude / DeepSeek / local models** | Used to *draft* and explain, never to decide. Verification is the graded skill. |

> [!NOTE]
> **Hands-on first, AI second.** You learn this subject by wiring, measuring, and breaking things safely. Use AI to draft explanations, code, or hypotheses — but only after you have touched the hardware. Verify every generated circuit and register value against the datasheet and a measurement, and respect voltage, current, and polarity limits.

> [!WARNING]
> **No secrets, binaries, or build output in Git.** Never commit credentials, API keys, personal data, `.venv/`, compiled binaries, or large measurement dumps you can regenerate. Commit the scripts, configuration, and notebooks that rebuild your evidence. The [resource bank](./modules/Z-resources-bank.md#git--github-primer-template-editor-markdown-conflicts) has the template workflow and the `.gitignore` guidance.

## Hardware Kit & Laboratory Equipment

The kit is deliberately two-layered, so you can move fast and still meet real physics:

- **Fast path — M5Stack nodes and Grove modules:**
  - M5StickC Plus2 and/or M5Atom Matrix / Lite (ESP32-based, built-in display, button, IMU, Grove port).
  - Grove sensors (I²C and analog): environment (T/RH/P), ToF distance, PIR, light/gesture.
  - Grove actuators: RGB LED, buzzer, servo, relay.
- **Physics path — raw microcontrollers and discrete parts:**
  - ESP32 DevKits, ESP32 Ethernet mini kits, and ESP8266 / Wemos D1 Mini boards, breadboards, jumper wires, resistors, capacitors, diodes.
  - Discrete sensors: NTC 10 kΩ, LDR, Hall-effect (analog + digital latch), DS18B20 (OneWire), MPU6050 (I²C), ultrasonic, light barrier (photo-interrupter).
  - Actuators: SG90 servo, small DC motor, 28BYJ-48 stepper with ULN2003, H-bridge driver (TB6612 / L298N), 5 V relay, piezo buzzer, high-brightness RGB LEDs, WS2812 / NeoPixel strip.
- **Instruments:** digital multimeter, USB power meter, thermometer for reference measurements; optional USB logic analyzer (I²C/PWM/WS2812 traces), oscilloscope if available.
- **Broker & infrastructure:** a Mosquitto MQTT broker running on any host in the network — a local OpenWrt travel router, a small Linux/Raspberry Pi host, or a laptop — plus laptops, USB power supplies, and hubs. Node-RED is optional; IoTempower is an optional declarative tool.

> [!WARNING]
> **Electrical safety.** All microcontrollers here are 3.3 V logic. Never power motors, relays, strips, or locks directly from a GPIO pin. Always share a common ground between logic and load supplies, and never connect 5 V or 12 V to a 3.3 V pin. Disconnect power before rewiring.

## 10-Day Course Schedule

The 10 days correspond to the 12 four-hour sessions across the semester. Modules 1–8 deliver the technical foundations; the final-project arc (Modules 9–10) spans the remaining studio sessions so there is genuine build, characterization, and rehearsal time.

> Indicative plan. The day-by-day mapping below is a planning draft and may shift — including during the semester — as we refine this class together. The learning objectives and the final project matter more than the exact day a topic lands on.

| Day | Session(s) | Module / Topic | Core Hands-on Focus |
|:---:|:---:|---|---|
| 0 | — | [Pre-Study](./pre-study.md) | Measurement basics, datasheet reading, Wokwi mini-exercise, project scenario abstract. |
| 1 | 1 | [Module 1 — Foundations: Electronics, Arduino & Measurement](./modules/01-foundations-measurement-and-sensor-chain.md) | Basic electronics (LED actor, button with pull-up/pull-down, debouncing), Arduino serial console and plotting, metrology and error, digital signal chain, ADC precision dance, LDR and first filtering. |
| 2 | 2 | [Module 2 — I²C & Sensor Addressing](./modules/02-i2c-and-sensor-addressing.md) | Wiring and scanning an I²C bus, 7-bit addresses, register maps, two devices on one bus, address conflicts. |
| 3 | 3 | [Module 3 — Sensor Characterization, Calibration & Data Quality](./modules/03-sensor-characterization-and-calibration.md) | Transfer function, linearity, hysteresis, calibration, filtering, uncertainty of an NTC/LDR. |
| 4 | 4 | [Module 4 — Distance, Motion & Environment Sensors](./modules/04-distance-motion-and-environment-sensors.md) **+ Checkpoint 1** | *2-pod practice round (larger cohorts) or pod checkpoints first (Modules 1–3), then:* ToF and ultrasonic distance, person counting, IMU tilt/rotation, Hall-effect current sensing. |
| 5 | 5 | [Module 5 — LEDs & Light as Output](./modules/05-leds-and-light-output.md) | LED current limiting, PWM and gamma, RGB mixing, first addressable strip and power budget. |
| 6 | 6 | [Module 6 — LED Animation, Sound & Interactive Installations](./modules/06-led-animation-sound-and-installations.md) | Non-blocking animation patterns, palettes, sensor-triggered and sound-reactive installations. |
| 7 | 7 | [Module 7 — Motors & Motion Actuators](./modules/07-motors-and-motion-actuators.md) | Servo control, DC motor speed/direction with an H-bridge, stepper stepping, current measurement. |
| 8 | 8 | [Module 8 — From Sensor to System: MQTT & Integration](./modules/08-sensor-to-system-and-integration.md) **+ Checkpoint 2** | *Checkpoint 2 first (Modules 4–6), then:* MQTT publishing and commands, filtering in firmware, Node-RED dashboard, a closed control loop, fault injection; optional IoTempower comparison. |
| 9 | 9–10 | [Module 9 — Final Project Studio](./modules/09-final-project-studio.md) | Project kickoff and story, requirement mapping, building and integrating the sensor/actuator system; checkpoint 3 (Modules 7–8). |
| 10 | 11 | [Module 9 — Final Project Studio (continued)](./modules/09-final-project-studio.md) | Characterization and evaluation, fault injection, documentation, peer review dry run. |
| 10 | 12 | [Module 10 — Demonstration & Portfolio Defense](./modules/10-demonstration-and-defense.md) | Live sensor/actuator demonstration, technical defense, portfolio presentation, retrospective. |

> [!TIP]
> **Buffer and pacing:** Days 9–10 provide four studio sessions. At least one is deliberately loose and can absorb spill-over from earlier labs, be released as flexible/wiggle time, or be used for stretcher tasks and peer mentoring. Announce the concrete use of each studio session in the LMS as the course progresses.

<a id="final-project-requirements-5-points"></a>
## Final Project Requirements (5 Points)

The final project is a sensor/actuator system built by **Project Teams of 4–6 students** — the project merges two Task Pods from Modules 1–8, so you keep your pod and gain one or two more. Project Teams form and pitch a stakeholder story during the project kickoff (Module 9), then map their requirements onto the criteria below. A Project Team may, by agreement with the instructor, continue an earlier project of their own instead of starting fresh — this is a possibility, not a requirement; the default is a self-contained sensor/actuator project.

### Must-Have System Criteria:

1. **Sensing with real characterization:** At least two sensors, including at least one I²C device, with the transfer function or calibration of at least one sensor determined from your own measurements, plus a stated uncertainty and resolution.
2. **Actuation:** At least one actuator that physically acts — a motor/servo/stepper, or an addressable LED installation — demonstrated under program control.
3. **The bus is understood, not hidden:** Evidence that you scanned/identified your I²C device(s), can name the address(es), and read or reasoned about at least one register/raw value.
4. **Embedded integration:** The node publishes sensor values and subscribes to actuator commands over MQTT, with documented topics and at least one filter for processing. Deploying via IoTempower is welcome as an optional alternative but is not required.
5. **System layer:** A Node-RED dashboard, plain MQTT subscriber/CLI, or Python service that displays the measured data and can control at least one actuator, including one closed-loop or rule-based behavior (e.g. threshold control, on/off control, animation tied to a sensor).
6. **Evaluation:** Documented measurement and performance evidence — e.g. resolution, latency, sampling rate, current consumption, or robustness to noise/interference.
7. **Reliability:** The system recovers gracefully from a sensor disconnect, an I²C device that fails to answer, an actuator stall, or a broker restart (tested during the demo).

### Assessment Criteria:

- **System functionality & measurement quality (2 points):** Meets specifications; the characterization is credible and the actuator demonstration is reliable.
- **Architecture, documentation & evaluation (1.5 points):** Clear wiring/system diagram, bus and addressing documentation, transfer-function/calibration evidence, a concise project report, and clean Git history.
- **Live demonstration & individual defense (1.5 points):** A clear **10-minute** Project Team demo — 5 minutes of live measurement and actuation plus a 5-minute individual defense — showing the measured quantity, the actuation, and the reasoning behind your sensor/actuator choices.

#### Detailed rubric

| Criterion | Points | Excellent (full) | Sufficient (partial) | Weak / missing |
|---|---:|---|---|---|
| **System functionality & measurement quality** | 2.0 | Meets all must-haves; two sensors (≥1 I²C, addresses documented), one actuator demonstrated under control, credible transfer function/calibration with resolution and uncertainty, and correct addressing/register handling. | Meets most must-haves; one gap (e.g. weak characterization or an undocumented address). | Server/hand-loaded data, no measured characterization, missing integrity, or non-reproducible build. |
| **Architecture, documentation & evaluation** | 1.5 | Clear wiring/system diagram; bus and address documentation; firmware implementation plus at least one filter (or an optional IoTempower node + filter); MQTT topics; actuator performance and at least one system metric; concise report with real evidence; clean Git history. | Documentation present and mostly complete; evidence thin in one section. | Missing diagram, report over/under length, or no evidence. |
| **Live demonstration & individual defense** | 1.5 | End-to-end live demo runs; each member defends their decisions and trade-offs fluently; handles an injected fault. | Demo runs but is partly slide-based, or defense is uneven across members. | Demo fails without explanation, or members cannot defend their parts. |

See the full [final project specification](./modules/10-demonstration-and-defense.md) for the demo script and portfolio evidence checklist.

## Portfolio & Documentation Standards

All assessments are based on your personal GitHub Portfolio, created from the [iot-portfolio-template](https://github.com/iotempire/iot-portfolio-template) with **“Use this template”**, then made your own; the [Git & GitHub primer](./modules/Z-resources-bank.md#git--github-primer-template-editor-markdown-conflicts) covers the template workflow, your editor, Markdown, and resolving conflicts.

Each module lists **suggested portfolio evidence** — suggestions, not a checklist. You may prove the same learning goals another way; if you do, say so in the module entry.

- Maintain a clean Git log with descriptive commit messages.
- For each module, include:
  - Circuit diagrams and photos of your wiring (hand-drawn or EDA-tool schematics are both fine).
  - Firmware/configuration (Arduino sketches, PlatformIO projects; optional IoTempower `setup.cpp` and node definitions).
  - Measurement tables, plots (transfer function, hysteresis, animation/power traces), and calibration notes.
  - Screenshots of serial plots, I²C scans, Node-RED dashboards, and terminal output.
  - Reflection logbook entries in `Reflections/`, using the template.
- Where you did not work entirely alone, **link your pod mates and your sources**.
- In sensor work, documented calibration and honest uncertainty beat a single lucky reading. Showing how you discovered a noisy channel, an off-by-one register, or a wrong address is worth more than a superficial "it worked" report.

## Classroom Policies & Success Strategies

1. **Active participation:** Labs require hands-on physical work with breadboards, sensors, motors, and strips. Bring your laptop with Arduino IDE or PlatformIO installed.
2. **Electrical hygiene:** Always disconnect power before rewiring. Check voltage levels and polarity before connecting. Never power actuators from GPIO pins; share ground properly.
3. **Collaborate within your pod:** Two sets of eyes on a floating SDA line or a hot motor driver save the afternoon. Split tasks, audit each other, and change roles often.
4. **Measurement mindset:** Write down what you measured, with what, and how uncertain it is. A number without units, conditions, or uncertainty is not a measurement.
5. **AI with responsibility:** Use AI co-pilots enthusiastically — and verify relentlessly. You are accountable for every circuit and every line you ship, whether you or a model wrote it.
6. **Open-source mindset:** Share discoveries and help other pods (and, later, other Project Teams). Accepted pull requests to IoTempower, this course repository, or open-source tools qualify for bonus points.

## Contacts & Support

- Primary Communication Channel: Course LMS. Check regularly for updates and announcements.
- Main Instructor: Prof. Dr. Ulrich Norbisrath (Ulno) — [ulno.net](https://ulno.net/)
- IoTempire Community: [iotempire.net](https://iotempire.net/)
- IoTempower Framework (optional): [https://iotempower.us](https://iotempower.us) / [GitHub](https://github.com/iotempire/iotempower)
- MQTT baseline: [mqtt.org](https://mqtt.org/) / [Mosquitto documentation](https://mosquitto.org/documentation/)
