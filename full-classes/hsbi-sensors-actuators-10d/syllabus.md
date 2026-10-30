# Syllabus: Sensors and Actuators (Sensorik und Aktorik)

> Important: This syllabus is a living document and will evolve throughout the semester. Minor updates may apply based on class progress, hardware availability, and student feedback.
>
> **Canonical source:** [IoTempire Teaching repository — HSBI/GT Sensors and Actuators](https://github.com/iotempire/iotempire-teaching/tree/main/full-classes/hsbi-sensors-actuators-10d)

> [!NOTE]
> **Every module begins with its learning goals.** Those goals are the agreement between you and the instructor: you earn a module's points through the **written portfolio evidence** that proves the goals — not by ticking off every task. Checkpoints are short **feedback** conversations, not separate examinations. The goals are fixed; the way you reach them is yours.

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

**Optional studio ritual — the harvest.** If you and your pod want to try it, take five minutes at the break and again at the end to collect the curious bits you noticed while working — a datasheet line that made no sense, a register that would not answer, a wiring surprise, a noisy plot, a library bug, a UX annoyance — and swap lists. Nobody explains anything; *"I collected these — which did you find?"* is the whole conversation, and "I don't know what this does" is a perfectly good entry. It is ungraded and entirely optional: if it does not fit the room or the day, skip it. Groups that try it usually find that the odd bits get a second look while they are still cheap to ask about, and that the next session can open with two of the questions they actually have. The full ritual lives in [Module 1](./modules/01-foundations-measurement-and-sensor-chain.md#harvest).

And this class is always in flux — that is a feature, not a bug. No course is ever finished: every offering is adjusted while it runs, and each class teaches us as much as it teaches you. Expect the plan, the tasks, and even this syllabus to move as we discover together what works best; your questions, ideas, and feedback are part of the design.

> Want to read more? Challenge-Based Learning — [en.wikipedia.org/wiki/Challenge-based_learning](https://en.wikipedia.org/wiki/Challenge-based_learning) · Project-Based Learning — [pblworks.org/what-is-pbl](https://www.pblworks.org/what-is-pbl) · Why active, interactive learning beats passive lectures — [Harvard Gazette, 2019](https://news.harvard.edu/gazette/story/2019/09/study-shows-that-students-learn-more-when-taking-part-in-classrooms-that-employ-active-learning-strategies)

## Learning Objectives

By the end of this course, you will be able to (mapped to the module-handbook competence goals):

1. **Explain measurement fundamentals**: true value, measurement error, uncertainty, accuracy vs. precision, resolution, range, and sensitivity.
2. **Analyze the digital signal chain**: transducer, signal conditioning, ADC, sampling theorem, quantization, and coding — and estimate the resulting uncertainty.
3. **Explain sensor principles** for position, distance (triangulation, ToF, ultrasonic), motion/rotation (gyroscope, accelerometer), force/torque (strain gauge), magnetic field (Hall), and environment (temperature, humidity, pressure).
4. **Describe actuator principles** — mechanical, thermal, optical, and unconventional — and compare which actuator fits which application scenario.
5. **Characterize and calibrate sensors**: determine the transfer function, assess linearity, hysteresis, repeatability, and resolution, apply calibration and filtering, and state the measurement uncertainty.
6. **Use buses competently**: wire, scan, and debug an I²C bus, handle device addresses and register maps, distinguish I²C from SPI, UART, OneWire, and direct GPIO/PWM, and select/use a low-cost ESP32 scope or logic analyzer to observe those signals.
7. **Drive actuators safely**: implement PWM brightness and LED animation (RGB, addressable WS2812), control servos, DC motors, and steppers with suitable drivers, respecting voltage, current, and thermal limits.
8. **Build and evaluate sensor/actuator systems**: design an embedded node that senses and acts, integrate it via MQTT and optionally Node-RED (with IoTempower as an optional declarative alternative), and document performance (resolution, latency, power, robustness).

## Course Load & Credits

- Format: 10 working days, **one module per day**, **48 contact hours** (45-minute class hours). Sessions are typically 2 × 45 min (90 min); most modules use two sessions, Module 3 uses three, and Modules 7–9 and Day 10 run longer.
- Target Audience: Bachelor students in *Digitale Technologien* (6th semester, Campus Gütersloh).
- Module Number: 3350 (*Sensorik und Aktorik*), **5 ECTS**.
- Total Workload: **150 hours**.
  - In-person lab and seminar contact: **48 hours**.
  - Module 0 preparation: plan for about **10 hours** (the compulsory core is a few hours; a deep dive can grow toward 40 hours).
  - Self-study, portfolio documentation, reflection, and final project: the remaining **~60–90 hours**, depending on how much preparation you bring.
- **Weekly rhythm:** outside the studio, plan for **at least 6 hours per week** — roughly 2–3 hours right after each session to finish and document the lab, 2 hours of reading/datasheet/AI verification, and 2–3 hours of portfolio, reflection, or project work.

> [!NOTE]
> **Where the 150 hours come from.** 5 ECTS means a 150-hour workload. The 48 in-person hours are the studio — the place where we start, discuss, debug, and demo. The rest is deliberate self-study: finishing labs, reading datasheets, verifying AI suggestions, writing portfolio evidence and reflections, and building the final project. That is roughly **6–9 hours per week** across the semester. It is normal for a 5-ECTS course, not a sign that you are behind.

### Self-study, homework, and when tasks run longer

**The tasks are studio starters, not a race.** Some tasks will take longer than the session — especially the first time you wire a new sensor, read a register map, or calibrate a measurement. That is expected. Finish the work in self-study, and bring the specific blocker to the next session or to the LMS/community channel. The learning goals are the contract; the task list is a guide.

A practical weekly rhythm:

| When | What to do | Time |
|---|---|---|
| Right after the studio | Finish the wiring/code, take photos, save logs, and commit the first evidence | 2–3 h |
| Before the next session | Read the next datasheet/section, answer the study-log prompts, and verify one AI answer against the hardware | ~2 h |
| Once per week | One deeper piece: an optional subtask, a stretcher, a better characterization, or project work | 2–3 h |

> [!NOTE]
> **Reflection ritual — outside the studio.** Reserve about **10 minutes after the meeting** — right after class, in the evening, or first thing next morning — for your reflection log. It does **not** need to happen inside the session. Writing a little later, in a different associative state, often helps the learning settle. These entries are what earn the reflection points.

- **If you finish early:** deepen the work — choose a stretcher, repeat a measurement with better conditions, or try an optional filter experiment. Share what you learned.
- **If you run out of time:** carry the task into self-study, document where you stopped, and ask a precise question next time. An honest, documented partial result is much better than a rushed “done”.
- **Keep a parking lot:** note questions, surprising observations, and ideas for a deeper dive. These become excellent portfolio and reflection material — and often the best project ideas.

Self-study is also where the course becomes yours: follow a datasheet further than the task asks, test a different filter, improve a calibration, or start shaping your final-project story.

### Prerequisites & Relationship to Other Modules

- **Formal:** none beyond course registration.
- **Content:** mathematical and technical fundamentals (basic algebra, physical units, basic electronics) help; ability to work with Git, a terminal, and a markup language is expected, as in the other IoT courses.
- **Standalone elective:** *Sensorik und Aktorik* is a 6th-semester elective (Wahlmodul) that stands on its own — it neither requires nor continues a specific earlier module. It concentrates on the *physical* side of IoT — what a sensor really measures and how an actuator really moves — and introduces the small amount of local-first infrastructure it uses (a node, a local MQTT broker, Node-RED) within the course itself.
- **Building on an earlier project (optional, by agreement):** the final project is self-contained by default. If you would like to continue an earlier project of your own, that is very welcome — just talk to the instructor, and we will agree on the scope and on how the sensors/actuators part is deepened.

<a id="assessment-kombinationsprüfung-20-points"></a>
## Assessment: Kombinationsprüfung (20 Points)

Assessment is a **Kombinationsprüfung** in two formally separate parts: **Part 1** is the written portfolio documentation; **Part 2** is the project documentation and presentation materials. The formal form is fixed by the module handbook; where the handbook version constrains the mix, the instructor announces the binding variant in the LMS.

You build and maintain one personal **GitHub portfolio**. The small tasks in each module are how you **prove that module's learning goals**, personalized through your **reflections**; short **checkpoints** give you feedback on whether those goals have been achieved.

### Part 1 — Written Portfolio Documentation (75% / 15 points)

| Component | Points | Details |
|---|---|---|
| Module 0 + Modules 1–8 — core technologies and lab challenges | 11 points | Portfolio setup, the technical labs, code, measurements, wiring, characterization, and functional artifacts that prove each module's learning goals. Module 0 is normally completed before Day 1; in a cohort that needs more setup time it can run as the first in-class module (same 1 point, same evidence). |
| Individual reflection and engineering decision log | 4 points | One logbook entry for each teaching block (Days 1–3, 4–6, 7–8, 9–10): what you tried, what broke, how your mental model shifted, how you verified AI suggestions, and a short self-assessment against the module learning goals. |
| **Part 1 total** | **15 points** | **75% of the assessment.** |

### Part 2 — Project Documentation & Presentation Materials (25% / 5 points)

| Component | Points | Details |
|---|---|---|
| Code and system documentation | 3 points | Working sensor/actuator system, characterization and uncertainty, architecture and wiring, bus/address documentation, reproducible build, and clean Git history. |
| Slide deck / demo artifacts | 2 points | The submitted slide deck and demo artifacts: story, architecture, measurement evidence, fault-injection evidence, and the artifact walkthrough. |
| **Part 2 total** | **5 points** | **25% of the assessment.** |

> [!IMPORTANT]
> **The presentation is artifact-based, not an oral examination.** Part 2 is assessed from the **submitted project documentation, code/system artifacts, slide deck, and demo artifacts**. The final session is a presentation of those submitted artifacts — not a separate oral examination (*mündliche Prüfung*) — so no co-examiner (*Beisitzer*) or minutes are required.

> [!IMPORTANT]
> **Total = 15 + 5 = 20 points.** Pass at **14 / 20** (~70%). There are no additional point categories outside the fixed 20-point scale.

### Excellence Stretcher

All deliverables are evaluated on the fixed 20-point scale. If you are tracking below mastery in a core competence area, contact the instructor **before the final deadline** to agree an **Excellence Stretcher**: an advanced challenge or deep-dive task that lets you demonstrate full mastery of the targeted learning objective, or a documented didactic contribution such as outstanding peer teaching, teaching material, or a tool that improves the class. An approved Stretcher is assessed against the same learning goals and counts within the 20-point scale; it never raises the maximum above 20.

<a id="how-module-points-are-earned-feedback-checkpoints"></a>
### How module points are earned: feedback checkpoints

You do not submit and grade every task. Module points are earned through the **written portfolio evidence** that proves the learning goals. A short **feedback checkpoint** — **10–12 minutes, including questions and feedback** — tells you whether that evidence is convincing before the portfolio is submitted. Checkpoints are **formative**, not a separate examination; the graded artefact for Part 1 is the written portfolio documentation. Checkpoints are done **with your Task Pod, in person**, and cover a few modules at a time:

- **Checkpoint 1 — start of Day 4 (Modules 1–3).** For a larger cohort this runs as a **30-minute 2-pod practice round**: two pods pair up; each pod walks the other through its portfolio evidence, and the other pod gives free-style feedback and questions checking how well the goals are documented. The instructor joins the feedback and notes where the written evidence still needs work. In a small cohort, use the same slot for individual pod checkpoints.
- **Checkpoint 2 — start of Day 8 (Modules 4–6).**
- **Checkpoint 3 — start of Day 9 project studio (Modules 7–8)**, or folded into the final project presentation by agreement with the instructor.

Dates and slots are confirmed through the LMS.

**Task Pods, and how checkpoints scale.** We work in **Task Pods** — small crews of **two or three**. Use **two** by default; switch to **three** when the cohort is large (roughly >40 students), because larger pods reduce the instructor's checkpoint load. A fourth podmate is only by arrangement. The point is *small*, not rigid.

> **Why “Task Pod”?** In container orchestration (Kubernetes), a **pod** is the *smallest deployable unit* — one or a few tightly-coupled containers that are scheduled, run, and retired together. A **Task Pod** is the same idea for people: your tight little crew of two or three that owns one task end-to-end. Your **Project Team** is the larger unit — the alliance of two pods that ships the whole system.

**These Task Pods are for the labs and checkpoints; the final project merges two pods into a Project Team of 4–6** (see [Final Project Requirements](#final-project-requirements-5-points)).

In a checkpoint, you:

1. **Show your evidence** — portfolio entries, measurement tables, plots, code, diagrams, I²C scans, and reflections for the modules being checked.
2. **Explain the learning goals from your evidence** — the goals listed at the top of each module. Walk the instructor through how your portfolio shows you reached them, and answer questions about them (expect to explain a measurement, justify a wiring choice, or read a register or datasheet live).

**Because assessment targets the learning goals — not task completion — the tasks are negotiable.** You are free to skip tasks, fail at tasks, or add your own, and for tasks below a module's draft boundary to **modify or replace them entirely, as long as you reach the same learning goals**. An honest, documented failure counts as exploration, not as a loss, and a convincing demonstration of deep understanding or analysis is rewarded generously.

Practical notes:

- Bring your portfolio (and your device or demo) to the checkpoint.
- Expect to explain a measurement, justify a design choice, or read a register or datasheet live.
- For a 2-pod practice round, bring your portfolio ready to present, and expect to give — and take — free-style feedback.
- If you **cannot attend in person**, talk to the instructor early and submit a **7–10 minute video** plus a **3–5 page explained excerpt** from your portfolio for review. You get less feedback than in an in-person checkpoint; a missed in-person checkpoint without such a submission is handled like a missed deadline.

### Task tiers: ★ Core and ◇ Stretcher

Tasks are marked **★ Core** or **◇ Stretcher**. A **★ Core** task is one we consider *core* to the module — the straightforward way to reach its learning goals. It is not a hard requirement, but note the asymmetry: for an ordinary task you can argue “this was not needed to reach the goals” and we will usually accept it; for a **★ Core** task that argument is harder, so skipping one means convincing us you reached the same goals another way. A **◇ Stretcher** is optional — an extension, a deeper dive, or additional practice, and the natural trim point when time is short. **Have a better task idea?** Propose it; if it reaches the same learning goal, we can swap it into the module — student-designed tasks are explicitly welcome.

### Reflection format

For each teaching block, write one logbook entry in `Reflections/refNN.md`, using the [reflection template](https://github.com/iotempire/iot-portfolio-template/blob/main/Reflections/TEMPLATE.md). The template includes the **AI-verification** question. The log is an **engineering decision log**: what you tried, what broke, how your mental model shifted, how you verified AI suggestions, and a short self-assessment against the module learning goals.

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
| Addressable LEDs | **Adafruit NeoPixel / NeoPixelBus** | Simple bring-up vs. robust/multi-strip; FastLED only as a reference. |
| Instrumentation | **ESP32 scope/logic analyzer + PulseView** | Built/selected in Module 2; one shared multimeter; 3.3 V inputs only. |
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
- **Instruments:** **one shared digital multimeter**, USB power meter, thermometer for reference measurements; **no benchtop oscilloscope** — Module 2 builds/selects an ESP32-based scope/logic analyzer (with PulseView/sigrok) that the class uses for the rest of the course.
- **Broker & infrastructure:** a Mosquitto MQTT broker running on any host in the network — a local OpenWrt travel router, a small Linux/Raspberry Pi host, or a laptop — plus laptops, USB power supplies, and hubs. Node-RED is optional; IoTempower is an optional declarative tool.

> [!WARNING]
> **Electrical safety.** All microcontrollers here are 3.3 V logic. Never power motors, relays, strips, or locks directly from a GPIO pin. Always share a common ground between logic and load supplies, and never connect 5 V or 12 V to a 3.3 V pin. Disconnect power before rewiring.

## 10-Day Course Schedule

The 10 days correspond to 48 contact hours, with **one module per day**. Session lengths vary slightly: most modules use two sessions of 2 × 45 min, Module 3 uses three, and some days run longer. Modules 1–8 deliver the technical foundations; the final-project arc (Modules 9–10) spans the remaining studio sessions so there is genuine build, characterization, and rehearsal time.

> Indicative plan. The day-by-day mapping below is a planning draft and may shift — including during the semester — as we refine this class together. The learning objectives and the final project matter more than the exact day a topic lands on.

| Day | Module / Topic | Core Hands-on Focus |
|:---:|---|---|
| 0 | [Pre-Study](./pre-study.md) | Measurement basics, datasheet reading, Wokwi mini-exercise, project scenario abstract. |
| 1 | [Module 1 — Foundations: Electronics, Arduino & Measurement](./modules/01-foundations-measurement-and-sensor-chain.md) | Basic electronics (LED actor, button with pull-up/pull-down, debouncing), Arduino serial console and plotting, metrology and error, digital signal chain, ADC precision dance, LDR and first filtering. |
| 2 | [Module 2 — Buses & I²C: From Simple Pins to One Bus, Many Devices](./modules/02-i2c-and-sensor-addressing.md) | *Two 90-minute sessions with a break; the instrument sprint can continue into self-study:* simple pins/PWM/voltage divider (optional UART detour), bus survey (RS-232/RS-485/Modbus/CAN/I²C/SPI/OneWire), I²C wiring/scan/register, address conflicts, scope/analyzer sprint. |
| 3 | [Module 3 — Sensor Characterization, Calibration & Data Quality](./modules/03-sensor-characterization-and-calibration.md) | Transfer function, linearity, hysteresis, calibration, filtering, uncertainty of an NTC/LDR. |
| 4 | [Module 4 — Distance, Motion & Environment Sensors](./modules/04-distance-motion-and-environment-sensors.md) **+ Checkpoint 1** | *2-pod practice round (larger cohorts) or pod checkpoints first (Modules 1–3), then:* ToF and ultrasonic distance, person counting, IMU tilt/rotation, Hall-effect current sensing. |
| 5 | [Module 5 — LEDs & Light as Output](./modules/05-leds-and-light-output.md) | LED current limiting, PWM and gamma, RGB mixing, first addressable strip and power budget. |
| 6 | [Module 6 — LED Animation, Sound & Interactive Installations](./modules/06-led-animation-sound-and-installations.md) | Non-blocking animation patterns, palettes, sensor-triggered and sound-reactive installations. |
| 7 | [Module 7 — Motors & Motion Actuators](./modules/07-motors-and-motion-actuators.md) | Servo control, DC motor speed/direction with an H-bridge, stepper stepping, current measurement. |
| 8 | [Module 8 — From Sensor to System: MQTT & Integration](./modules/08-sensor-to-system-and-integration.md) **+ Checkpoint 2** | *Checkpoint 2 first (Modules 4–6), then:* MQTT publishing and commands, filtering in firmware, Node-RED dashboard, a closed control loop, fault injection; optional IoTempower comparison. |
| 9 | [Module 9 — Final Project Studio](./modules/09-final-project-studio.md) | Project kickoff and story, requirement mapping, building and integrating the sensor/actuator system; checkpoint 3 (Modules 7–8). |
| 10 | [Module 9 — Final Project Studio (continued)](./modules/09-final-project-studio.md) + [Module 10 — Project Presentation & Submitted Artifacts](./modules/10-demonstration-and-presentation.md) | Characterization, evaluation, fault injection, documentation, peer review dry run; artifact-based presentation of the submitted slide deck and demo artifacts, portfolio walkthrough, retrospective. |

> [!TIP]
> **Buffer and pacing:** Days 9–10 form the final-project block. Part of it is deliberately loose and can absorb spill-over from earlier labs, be released as flexible/wiggle time, or be used for stretcher tasks and peer mentoring. Announce the concrete use of each part in the LMS as the course progresses.

<a id="final-project-requirements-5-points"></a>
## Final Project Requirements (5 Points)

The final project is a sensor/actuator system built by **Project Teams of 4–6 students** — the project merges two Task Pods from Modules 1–8, so you keep your pod and gain two or three more members (4–6 total). Project Teams form and pitch a stakeholder story during the project kickoff (Module 9), then map their requirements onto the criteria below. A Project Team may, by agreement with the instructor, continue an earlier project of their own instead of starting fresh — this is a possibility, not a requirement; the default is a self-contained sensor/actuator project.

### Must-Have System Criteria:

1. **Sensing with real characterization:** At least two sensors, including at least one I²C device, with the transfer function or calibration of at least one sensor determined from your own measurements, plus a stated uncertainty and resolution.
2. **Actuation:** At least one actuator that physically acts — a motor/servo/stepper, or an addressable LED installation — demonstrated under program control.
3. **The bus is understood, not hidden:** Evidence that you scanned/identified your I²C device(s), can name the address(es), and read or reasoned about at least one register/raw value.
4. **Embedded integration:** The node publishes sensor values and subscribes to actuator commands over MQTT, with documented topics and at least one filter for processing. Deploying via IoTempower is welcome as an optional alternative but is not required.
5. **System layer:** A Node-RED dashboard, plain MQTT subscriber/CLI, or Python service that displays the measured data and can control at least one actuator, including one closed-loop or rule-based behavior (e.g. threshold control, on/off control, animation tied to a sensor).
6. **Evaluation:** Documented measurement and performance evidence — e.g. resolution, latency, sampling rate, current consumption, or robustness to noise/interference.
7. **Reliability:** The system recovers gracefully from a sensor disconnect, an I²C device that fails to answer, an actuator stall, or a broker restart (tested during the demo).

### Assessment Criteria:

- **Code and system documentation (3 points):** Working sensor/actuator system, credible characterization and uncertainty, architecture and wiring, bus/address documentation, reproducible build, and clean Git history.
- **Slide deck / demo artifacts (2 points):** The submitted slide deck and demo artifacts show the story, architecture, measurement evidence, fault-injection evidence, and an artifact walkthrough. All claims must be traceable to the portfolio, code, or measurements.

#### Detailed rubric

| Criterion | Points | Excellent (full) | Sufficient (partial) | Weak / missing |
|---|---:|---|---|---|
| **Code and system documentation** | 3.0 | Meets all must-haves; two sensors (≥1 I²C, addresses documented), one actuator demonstrated under control, credible transfer function/calibration with resolution and uncertainty, correct addressing/register handling, clear wiring/system diagram, firmware plus at least one filter, MQTT topics, reproducible build, and clean Git history. | Documentation present and mostly complete; one gap (e.g. weak characterization or an undocumented address). | Hand-loaded data, no measured characterization, missing integrity, or non-reproducible build. |
| **Slide deck / demo artifacts** | 2.0 | The submitted slide deck and demo artifacts clearly show the story, architecture, measurement evidence, fault-injection evidence, and an artifact walkthrough; every claim is traceable to the portfolio or code. | Artifacts present but one section is thin, or the walkthrough is uneven across the team. | Artifacts missing, or they fail to show the measured quantity, the actuation, or the evidence behind the claims. |

See the full [final project specification](./modules/10-demonstration-and-presentation.md) for the artifact checklist and presentation script.

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
6. **Open-source mindset:** Share discoveries and help other pods (and, later, other Project Teams). Accepted pull requests to IoTempower, this course repository, or open-source tools can be proposed as an **Excellence Stretcher**.

## Contacts & Support

- Primary Communication Channel: Course LMS. Check regularly for updates and announcements.
- Main Instructor: Prof. Dr. Ulrich Norbisrath (Ulno) — [ulno.net](https://ulno.net/)
- IoTempire Community: [iotempire.net](https://iotempire.net/)
- IoTempower Framework (optional): [https://iotempower.us](https://iotempower.us) / [GitHub](https://github.com/iotempire/iotempower)
- MQTT baseline: [mqtt.org](https://mqtt.org/) / [Mosquitto documentation](https://mosquitto.org/documentation/)
