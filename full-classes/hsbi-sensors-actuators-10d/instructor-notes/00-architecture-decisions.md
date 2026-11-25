# Instructor Notes — Architecture Decisions (Sensors and Actuators)

> **What this document is.** The design memory of the Sensors and Actuators class (module 3350). It records *why* the course has this shape, *what was tried and rejected*, and *what a new instructor or an agent needs to know to rebuild it*. It is written for the people who teach and maintain the class, not for students looking for the schedule.
>
> **What it is not.** It is not the syllabus, not the module content, not the operations checklist, and not a changelog. The binding assessment rules — form, points, checkpoints, grade scale — live **only** in the [syllabus](../syllabus.md); the operational view is in [Assessment & operations](./00-assessment-and-operations.md). Teaching material lives in the [modules](../modules/00-index.md). If this page and those disagree, those win.
>
> **Status.** First version, 2026-11-15. Reconstructed from the current files, the first offering, and the sibling architecture logs. It will be incomplete or wrong in places: correct the record rather than replace it, and keep the old reasoning visible.

[← Course workbook](../README.md) · [Syllabus](../syllabus.md) · [Module index](../modules/00-index.md) · [All instructor notes](./README.md) · [Networking ADR](../../hsbi-networking-iot-10d/instructor-notes/00-architecture-decisions.md) · [Databases ADR](../../hsbi-databases-10d/instructor-notes/00-architecture-decisions.md)

## How to use this log

Each record has the same shape:

**Context** (the forces) → **Decision** (what we do) → **Consequences** (what it costs) → **Alternatives rejected** (what we did not do) → **Evidence** (where it lives) → **Revisit if** (the trigger that would change the decision).

The status vocabulary is deliberately small:

| Status | Meaning |
|---|---|
| **accepted** | In force, encoded in the current files. Change it only with a new record. |
| **provisional** | In force for this offering, expected to move after the first run. |
| **open** | Not decided; recorded in §4 so it does not get decided by accident. |
| **rejected** | Considered and declined; kept in §3 so it does not come back disguised as a new idea. |

**What belongs here.** Forces that constrain future material; a decision and what it costs; alternatives that looked plausible; the trigger that would reverse the decision; links to the artefact. **What does not.** Task steps (module), point values and checkpoints (syllabus), operational checklists (`00-assessment-and-operations.md`), troubleshooting recipes (resource bank), routine edits (Git log). If a sentence would fit better in one of those, it is in the wrong document.

**For an agent.** Read §1 and the decision index, then only the records that touch your task. Operational rules — commits, edit tools, privacy, language, vocabulary, and validation — live in the repository [`AGENTS.md`](../../../AGENTS.md); this log records the class-specific decisions and their rationale. Do not re-introduce a rejected alternative because it looks simpler in isolation; the reasons are in §3. Do not move assessment text out of the syllabus. Do not add points, tiers, or a separate "reflection logbook" to a module. When you change a decision, update its record and status; do not silently rewrite history.

**Maintenance rule.** Add a record when a choice constrains future material, when you reject a plausible alternative, or when a first-offering improvisation becomes the pattern. Keep records short; link to the artefact instead of pasting it.

### Decision index

| ID | Decision | Status | Encoded in |
|---|---|---|---|
| [D1](#d1) | The module handbook is the constraint; the studio is ours | accepted | syllabus; Appendix A |
| [D2](#d2) | Measurement-first, not a sensor catalogue | accepted | Modules 1, 3, 4; resource bank |
| [D3](#d3) | Learning goals are the contract; tasks are negotiable | accepted | every module; syllabus |
| [D4](#d4) | Assessment is the Kombinationsprüfung; only the syllabus owns it | accepted | syllabus; `00-assessment-and-operations.md` |
| [D5](#d5) | Stories carry the why; the canon keeps them consistent | accepted | Modules 3, 4; resource bank canon |
| [D6](#d6) | Studio rhythm: just-in-time briefs in Modules 3–4 | accepted | Modules 3, 4; general hints |
| [D7](#d7) | Module 3 uses the sensors we have; the NTC is story-only | accepted | Module 3; Module 3 studio |
| [D8](#d8) | Module 4 is the Nordwind liquid challenge, not a sensor catalogue | accepted | Module 4; alternative module |
| [D9](#d9) | Binary/threshold/continuous/hybrid is the Module 4 spine | provisional | Module 4; Module 4 studio; email |
| [D10](#d10) | Module 4 uses the real sensor set; no DIY foil capacitive sensor | accepted | Module 4; resource bank; syllabus |
| [D11](#d11) | Scale calibration is two readings plus an optional check | accepted | Module 4 templates; studio note |
| [D12](#d12) | Sharing is normal; no big allocation process | accepted | Module 4; studio note; email |
| [D13](#d13) | Module 4 practice is two sessions; checkpoint at the bench | provisional | Module 4; email; studio note |
| [D14](#d14) | One fact, one home; concepts move to the resource bank | accepted | Module 4; resource bank |
| [D15](#d15) | The old Module 4 is an instructor alternative | accepted | `alternatives/`; instructor notes |
| [D16](#d16) | English material, bilingual delivery; local-first systems | accepted | syllabus; README |
| [D17](#d17) | The class is a draft in motion; ADR and TODO are its memory | accepted | every module; this file; TODO |
| [D18](#d18) | Handbook examples that are not on the bench are reading homework | accepted | Modules 7, 8; resource bank |
| [D19](#d19) | Module 5 is evaluated: guided walkthrough, then challenge | accepted | Module 5; Module 5 studio |
| [D20](#d20) | A teaching day is 180 minutes: two 90-minute blocks | accepted | every module; instructor run sheets |
| [D21](#d21) | One vocabulary: Task, Subtask, Evidence | accepted | every module; syllabus; sibling workbooks |
| [D22](#d22) | Commits are instructor-only; agents never commit | accepted | every file; this log |
| [D23](#d23) | Nine-day timetable, two project tracks, and a video artifact | accepted | syllabus; Modules 8–10; index |
| [D24](#d24) | Module 6: two controllers, UART default, play mandatory | provisional | Module 6; Module 6 studio; reference project |

## 1. Provenance — how this class came to be

### 1.1 Three lineages, one class

| Lineage | Where it lives | What it contributed | What it could not provide |
|---|---|---|---|
| **HSBI module handbook** *Sensorik und Aktorik* (3350) | Syllabus and the module handbook (external) | The outcomes, 5 ECTS / 150 h, the examination form, the breadth of measurement and actuator principles | Student labs, hardware, stories, the daily studio |
| **Tartu IoT introduction** (15–16 weeks) | [`full-classes/unitartu-IoT-intro-15d/`](../../unitartu-IoT-intro-15d/README.md) | The practical thread: modules, portfolio, storytelling, M5Stack/IoTempower, the final project, "tasks are a path, not a checklist" | The HSBI assessment form; the hardware ceiling; the 10-day compression |
| **HSBI 10-day studio format** | This folder | One module per day, a lab per day, six pods, three multimeters, three scales, a project arc | — (this is the new constraint) |

The class is one of three siblings. Databases and Networking supplied the **document structure and didactic patterns** — one job per document, learning goals as contract, stories, resource bank, instructor notes — not the subject content. The old Module 4 (distance, motion, environment) was part of the first HSBI-style draft; the current Module 4 is the Nordwind liquid challenge. The archive of the old version is in [`alternatives/04-distance-motion-and-environment-sensors.md`](./alternatives/04-distance-motion-and-environment-sensors.md).

### 1.2 Timeline

Dates are design events, not every commit; Git history is the authority.

| Date | Event | What happened | Why it matters |
|---|---|---|---|
| 2026-10 | First 10-day workbook | Modules 1–10, syllabus, resource bank; old Module 4 (distance/motion/environment); Module 3 draft with NTC/LDR/DS18B20 | The first shape tried to cover the classical catalogue. |
| 2026-10/11 | Module 3 rework | NTC demoted to the failed prototype in the story; LDR, DS18B20 sealed probes, and potentiometer become the bench; DHT11 optional; three rounds; three shared multimeters | The class starts using the hardware it actually has. |
| 2026-11 | Module 4 rework | Nordwind liquid challenge replaces the distance/motion/environment catalogue; old module archived; decision sheet, two benches, hybrid modes, real sensor set, two-reading scale check | The module gets one goal and a comparable artifact. |
| 2026-11-15 | This ADR and TODO | Design memory written down before the next architectural change | The next change starts from a recorded baseline. |

### 1.3 The constraints that shaped the class

- **9 days / 48 school hours (≈36 clock hours) / 5 ECTS / 150 h**, one module per day; a normal day is two 90-minute slots, Module 3 uses three, and Days 7–9 add 180-minute slots (D23).
- **Six pods / twelve students.** Three shared multimeters, three shared HX711 scales, one shared binary capacitive water sensor. Sharing is normal, not an exception.
- **Hardware reality:** LDR, potentiometer, DHT11, DS18B20 sealed probes, ToF, ultrasonic, Hall, light barrier, reed/float, analog soil/humidity probes (open/sealed/needle), one binary capacitive water sensor, M5StickC-S3 with BMI270, ESP32 boards. **No NTC in the kit.** **No benchtop oscilloscope** — Module 2 builds/selects an ESP32 scope/analyzer.
- **Assessment:** the module handbook fixes the Kombinationsprüfung; the syllabus owns the form, points, checkpoints, grade scale, and policies. Modules never restate them.
- **Local-first:** everything core runs on the local network; MQTT is local; Node-RED is optional; no cloud dependency.
- **Language:** written material English; German may be spoken; German technical terms in parentheses are fine.
- **One of three siblings:** reuse structure and didactics from Databases and Networking, never their subject content.

## 2. Decision records

<a id="d1"></a>
### D1 — The module handbook is the constraint; the studio is ours

**Status:** accepted.

**Context.** Module 3350 fixes 5 ECTS, 150 h, the learning outcomes, and the permitted examination form. The handbook is a contract, not a daily lesson plan. The class is new and changes while it runs.

**Decision.** Treat the handbook as the outer constraint and the studio as ours. Map every outcome to a module (Appendix A). Keep assessment rules only in the syllabus. Change tasks freely; change a learning goal only after a handbook check.

**Consequences.** The class can be measurement-first and project-based without becoming non-compliant. Some outcomes are covered at "can explain and place" depth rather than "can build"; that trade must be defensible in the project discussion.

**Alternatives rejected.** Rewriting the handbook; teaching the legacy lecture line by line; putting points or checkpoints in modules.

**Evidence.** [Syllabus](../syllabus.md); [Assessment & operations](./00-assessment-and-operations.md); Appendix A.

**Revisit if.** The handbook, the examination form, or the module description changes.

<a id="d2"></a>
### D2 — Measurement-first, not a sensor catalogue

**Status:** accepted.

**Context.** A classical course lists sensor principles, then tests recall. Students can name a transfer function but cannot calibrate a divider, read a datasheet condition, or explain why a reading is wrong.

**Decision.** Every module starts from a quantity to measure, a story, a bench, and evidence. Principles arrive when the bench needs them. Reference tables, equations, datasheets, and troubleshooting live in the resource bank; the module does not recite them.

**Consequences.** Less breadth in the lecture sense; more depth and more hardware dependence. The resource bank becomes a real reference, not an appendix. A missing sensor changes the lab, not the learning goal.

**Alternatives rejected.** Lecture-first catalogue; datasheet-only study; simulation-first course.

**Evidence.** Modules 1, 3, and 4; [resource bank](../modules/Z-resources-bank.md); [story canon](../modules/Z-resources-bank.md#story-canon-the-recurring-cast).

**Revisit if.** The cohort arrives without hardware or the handbook demands broader principle coverage.

<a id="d3"></a>
### D3 — Learning goals are the contract; tasks are negotiable

**Status:** accepted.

**Context.** The class is new, the tasks move, and students respond better when they can choose a path. A fixed task checklist rewards completion, not understanding.

**Decision.** Every module opens with 4–6 observable learning goals and a visible `DRAFT BOUNDARY`. Tasks are tiered `★ Core` and `◇ Stretcher`; long or risky work is marked **Challenging**, not timed. Students may prove a goal another way; the portfolio evidence is suggested, not prescribed.

**Consequences.** More assessment conversation and instructor judgement; fewer "did you do task 3?" answers. Tasks must be open enough to allow a different proof but concrete enough to start.

**Alternatives rejected.** Fixed task checklist; points per task; exam recall; a separate reflection logbook.

**Evidence.** Every module; [syllabus](../syllabus.md); [Assessment & operations](./00-assessment-and-operations.md).

**Revisit if.** The assessment form changes, or task negotiation makes the room unmanageable.

<a id="d4"></a>
### D4 — Assessment is the Kombinationsprüfung; only the syllabus owns it

**Status:** accepted.

**Context.** The module handbook fixes the Kombinationsprüfung: portfolio documentation plus project documentation/artifacts, with an artifact-based presentation. The exact points, checkpoints, grade scale, and policies are examination-law material.

**Decision.** Modules never restate assessment rules. They link to the syllabus and list suggested portfolio evidence. Points, checkpoints, tiers, grade scale, and the reflection format live only in the syllabus; the operational view lives in `00-assessment-and-operations.md`.

**Working interpretation (2026-11-15, provisional).** The individual portfolio — the learning-goal evidence plus the checkpoint record — is the *Leistungsnachweis*; the portfolio report and the project presentation are the two parts of the *Modulprüfung*. This is not confirmed with the Prüfungsausschuss (Q2). Do not encode it as a rule in a module; if it hardens, it belongs in the syllabus.

**Consequences.** One source of truth; modules stay readable; students must open the syllabus. Any assessment change is a syllabus change, not a module edit.

**Alternatives rejected.** Per-module points; task-completion grading; an oral exam; a separate module-level logbook.

**Evidence.** [Syllabus](../syllabus.md); [Assessment & operations](./00-assessment-and-operations.md).

**Revisit if.** The examination form or the Prüfungsausschuss decision changes.

<a id="d5"></a>
### D5 — Stories carry the why; the canon keeps them consistent

**Status:** accepted.

**Context.** "A greenhouse" or "a boat" is too abstract; students need one named person, one place, one moment of pain, and something at stake. Generic examples do not survive a long day.

**Decision.** Each module has a domain-realistic story with named fictional people and organizations. The recurring cast lives in the [story canon](../modules/Z-resources-bank.md#story-canon-the-recurring-cast). New stories add their cast there; numbers stay consistent. The Module 4 challenge also credits its real origin: the US yacht **Hither & Yon**, the friend who chartered her, and the Hagenberg → Tartu lineage.

**Consequences.** A small maintenance cost; stories must not contradict each other. The reward is a class that remembers *why* the measurement matters.

**Alternatives rejected.** Generic scenarios; unnamed stakeholders; real companies without permission; story-less labs.

**Evidence.** Module 3 (Klimapark, Dr. Elif Kaya), Module 4 (Nordwind, Hauke Petersen, Imke Thomsen); resource bank canon.

**Revisit if.** A story becomes misleading, or a cohort needs a different context.

<a id="d6"></a>
### D6 — Studio rhythm: just-in-time briefs in Modules 3–4

**Status:** accepted.

**Context.** A long Pod Study before the lab ate the session. Students responded better when the concept arrived at the bench, when they had a question to answer.

**Decision.** Modules 3 and 4 use **Brief → Bench → Explain (random mini check) → Log/Swap**. There is no separate Pod Study block in those modules. The shared study log and the exchange with a neighbouring pod are the collaboration wrapper, not extra lab work. Modules that need a shared vocabulary first may still use a Pod Study.

**Consequences.** Shorter front-load, more bench time, more instructor movement. Briefs must be short and well-prepared; a vague brief becomes a lecture.

**Alternatives rejected.** A 30-minute Pod Study before every lab; lecture-first; self-study with no brief.

**Evidence.** [Module 3](../modules/03-sensor-characterization-and-calibration.md); [Module 4](../modules/04-liquid-measurement-and-sensor-selection.md); [general teaching hints](./01-general-teaching-hints.md).

**Revisit if.** A cohort lacks the shared vocabulary to start, or the briefs grow into lectures.

<a id="d7"></a>
### D7 — Module 3 uses the sensors we have; the NTC is story-only

**Status:** accepted.

**Context.** There is no NTC in the kit. There are plenty of LDRs, potentiometers, DHT11s, and DS18B20 sealed probes on long cables. Water safety matters: the probe is sealed, the connector is not.

**Decision.** Characterize the **LDR** (nonlinear, analog), the **DS18B20** (digital, factory-calibrated, sealed), and the **potentiometer** (a stable input for checking the chain). The NTC appears only as the failed first prototype in the story; the Beta equation stays in the resource bank. The DHT11 is an optional comparison and stays dry. No plastic bags are needed for the sealed probe; the connector stays out of the water.

**Consequences.** Students still meet transfer functions, resolution vs. accuracy, response time, calibration, and filtering. The NTC theory is available but not a hardware requirement.

**Alternatives rejected.** Buying NTCs; making the DHT11 the primary sensor; putting probes in bags; using boiling water.

**Evidence.** [Module 3](../modules/03-sensor-characterization-and-calibration.md); [Module 3 studio](./02-module-3-studio.md); [resource bank](../modules/Z-resources-bank.md).

**Revisit if.** NTCs enter the kit, or the DS18B20/probe supply changes.

<a id="d8"></a>
### D8 — Module 4 is the Nordwind liquid challenge, not a sensor catalogue

**Status:** accepted.

**Context.** The old Module 4 was dense and step-heavy: ToF, ultrasonic, IR, IMU fusion, Hall current, environment sensors, a people counter, and a long Pod Study. Students could not name the overall goal. The original Tartu boat challenge — fuel, fresh water, waste water, bilge; distance, weight, switches — was a better story and a better trade study.

**Decision.** Replace Module 4 with the **Nordwind** liquid-measurement challenge. Candidate principles are ToF, ultrasonic, Hall + float, HX711 scale, analog soil/humidity probe, the binary capacitive water sensor, light barrier/reed/float, and the M5StickC-S3 IMU. The old distance/motion/environment module is archived as an instructor alternative; it is not in the student path.

**Handbook check (2026-11-15).** The handbook lists sensor principles as examples (*"z.B."*), not as a fixed catalogue, and permits the Kombinationsprüfung; the liquid challenge covers position, distance, and force directly (Q1 resolved).

**Consequences.** The Module 4 learning goals changed; the handbook check passed (Q1 resolved). The old module remains available for instructors who prefer it. The new module is one story, not a catalogue.

**Alternatives rejected.** Keeping the old Module 4; merging both; dropping distance/motion entirely; copying the Databases or Networking content.

**Evidence.** [Module 4](../modules/04-liquid-measurement-and-sensor-selection.md); [alternative Module 4](./alternatives/04-distance-motion-and-environment-sensors.md); [module index](../modules/00-index.md); [syllabus](../syllabus.md).

**Revisit if.** The handbook text changes, or the liquid challenge does not fit the cohort.

<a id="d9"></a>
### D9 — Binary/threshold/continuous/hybrid is the Module 4 spine

**Status:** provisional.

**Context.** The first liquid draft had many fine-grained steps, a long failure-case list, and one pod filling one row. Students and the instructor lost the overall goal: *what decision does this tank need?*

**Decision.** Organize the module around **binary / threshold / continuous / hybrid** sensing. The one artifact is a **4–5 row decision sheet** (four tanks plus the optional heating/AC row). Two neighbouring pods aim to fill 4–5 rows; the class table compares results. A hybrid is a continuous reading plus a binary failsafe at the critical limit, or a **staggered binary** arrangement of several float/reed switches at different heights. Reports are per pod, with a short individual contribution note.

**Consequences.** Less sensor breadth per pod; the class table and the shared log matter. The decision sheet becomes the spine; failure cases become evidence, not a separate goal. The report is short because the table carries the structure.

**Alternatives rejected.** A sensor catalogue; one row per pod; a full sensor sweep by every pod; a separate Pod Study; per-student reports (revisit if the handbook requires them).

**Evidence.** [Module 4](../modules/04-liquid-measurement-and-sensor-selection.md); [Module 4 studio](./03-module-4-studio.md); [student email](./04-module-4-student-email.md).

**Revisit if.** Two pods cannot fill 4–5 rows, or the decision sheet turns into a checklist to complete rather than a decision to argue.

<a id="d10"></a>
### D10 — Module 4 uses the real sensor set; no DIY foil capacitive sensor

**Status:** accepted.

**Context.** The kit has ToF, ultrasonic, HX711 scales, Hall, analog soil/humidity probes in several forms, **one** binary capacitive water sensor, light barriers, reed/float switches, and M5StickC-S3/BMI270. Foil/copper tape was for the touch sensor, not for liquid measurement. From experience, distance/pressure/scale sensing is usually more reliable for liquids than a DIY capacitive build.

**Decision.** The sensor menu is ToF, ultrasonic, Hall + float, **analog soil/humidity probe (open, sealed, needle)**, **binary capacitive water sensor (shared)**, light barrier, reed/float, HX711 scale, M5StickC-S3 IMU, and optional MPR121 for **touch**. No foil/DIY capacitive sensor in the liquid path. Node-RED is not required; visualization is the pod's choice. The analog probe is a concept test: it can kind of measure level, but splashes/movement make it unstable, and it is not food-safe. The binary sensor is a presence/threshold device.

**Consequences.** The hardware matches the kit; one shared binary sensor needs coordination. The analog probe is interesting but not a default for drinking water or fuel. The foil idea survives only as a touch side note in the pre-study and the optional extras.

**Alternatives rejected.** DIY foil capacitive liquid sensor; MPR121 as a liquid sensor; Node-RED requirement; one scale per pod; multiple binary capacitive sensors; treating the analog probe as food-safe.

**Evidence.** [Module 4](../modules/04-liquid-measurement-and-sensor-selection.md); [liquid-level principles](../modules/Z-resources-bank.md#liquid-level-principles); [Module 4 studio](./03-module-4-studio.md); [student email](./04-module-4-student-email.md); [syllabus](../syllabus.md).

**Revisit if.** More binary capacitive sensors arrive, or the analog probe proves reliable enough to recommend.

<a id="d11"></a>
### D11 — Scale calibration is two readings plus an optional check

**Status:** accepted.

**Context.** The first draft had a full scale calibration table with three or more known masses. The HX711/load cell is linear; tare at 0 g plus one known mass sets the offset and factor. A third mass is a linearity check, not a calibration requirement. The tank's level → volume curve is a different problem.

**Decision.** The scale check is **0 g (tare) + one known mass** (for example, 50 g). A third known mass — even a phone's published weight — is an optional check. The tank calibration table stays at empty/half/full because it maps level to volume. The test card records the calibration/uncertainty.

**Consequences.** Less record-keeping; the students still state uncertainty and check the scale. The tank table remains the place for residuals.

**Alternatives rejected.** A full scale calibration table; no calibration; requiring three or more masses.

**Evidence.** [Module 4 templates](../modules/04-liquid-measurement-and-sensor-selection.md); [Module 4 studio](./03-module-4-studio.md).

**Revisit if.** The load cells prove nonlinear, or a formal calibration record becomes necessary.

<a id="d12"></a>
### D12 — Sharing is normal; no big allocation process

**Status:** accepted.

**Context.** Six pods, three HX711 scales, three multimeters, one binary capacitive water sensor, and a small class. A formal checkout would cost more than the sharing it manages.

**Decision.** Pair Task Pods. Scales, multimeters, and the binary capacitive sensor are shared; the "We need — look at home" list makes supplies a common scavenger hunt rather than a division of responsibility. The class table coordinates the work. No formal booking sheet.

**Consequences.** Some waiting at the scales; the instructor owns the rotation. Less bureaucracy and more shared responsibility. The one binary sensor must be passed around deliberately.

**Alternatives rejected.** One kit per pod; a strict rotation schedule; buying more hardware before testing the room.

**Evidence.** [Module 4](../modules/04-liquid-measurement-and-sensor-selection.md); [Module 4 studio](./03-module-4-studio.md); [student email](./04-module-4-student-email.md); [syllabus](../syllabus.md).

**Revisit if.** The cohort grows or the hardware shrinks.

<a id="d13"></a>
### D13 — Module 4 practice is two sessions; checkpoint at the bench

**Status:** provisional.

**Context.** Module 4 has two sessions. Students need time to build, measure, break, and photograph; the reports can be written outside class. The first checkpoint covers Modules 1–3.

**Decision.** The bench work, prototype, and picture proofs finish in the two sessions. Reports and the transfer paragraph are written outside. The instructors run the first checkpoint **at the bench** while pods work — about 15 minutes per pod — rather than stopping the room for a presentation. The module does not carry time estimates; operational timing lives in the instructor note and the student email.

**Consequences.** The checkpoint runs in parallel with the studio; the room needs two instructors or a clear rotation. Reports depend on data and photos taken in class. No presentation rehearsal.

**Alternatives rejected.** A third session; report writing in class; a separate checkpoint presentation; time estimates in the module.

**Evidence.** [Module 4](../modules/04-liquid-measurement-and-sensor-selection.md); [Module 4 studio](./03-module-4-studio.md); [student email](./04-module-4-student-email.md); [syllabus](../syllabus.md).

**Revisit if.** Two sessions are insufficient, or the bench checkpoint disrupts the room.

<a id="d14"></a>
### D14 — One fact, one home; concepts move to the resource bank

**Status:** accepted.

**Context.** The modules grew long because principles, formulas, datasheets, troubleshooting, and teaching hints were repeated in several places. Students lost the goal in the reference material.

**Decision.** Modules link to the [resource bank](../modules/Z-resources-bank.md) for principles, formulas, datasheets, and troubleshooting; instructor notes hold teaching hints and answer keys; the syllabus holds assessment; the module holds the challenge and the evidence. No duplication.

**Consequences.** Students must follow links; the resource bank becomes canonical. Modules get shorter and the goal stays visible. The cost is link maintenance.

**Alternatives rejected.** Everything in the module; separate handouts; repeating the reference in slides.

**Evidence.** [Module 4](../modules/04-liquid-measurement-and-sensor-selection.md); [liquid-level principles](../modules/Z-resources-bank.md#liquid-level-principles); [Module 4 studio](./03-module-4-studio.md).

**Revisit if.** Links break repeatedly or students do not use the bank.

<a id="d15"></a>
### D15 — The old Module 4 is an instructor alternative

**Status:** accepted.

**Context.** The old distance/motion/environment module still has useful material: ToF/ultrasonic, IMU tilt, Hall current, environment sensors, a people counter. Some instructors may prefer that route; the student path needs one story.

**Decision.** Archive the old module under [`alternatives/`](./alternatives/04-distance-motion-and-environment-sensors.md) with an instructor banner and fixed relative links. Link it only from the instructor notes, not from the student index, syllabus, or module navigation.

**Consequences.** Two versions to maintain; the old one is not student-facing. The current path stays coherent.

**Alternatives rejected.** Deleting the old module; keeping both in the student index; merging the two modules.

**Evidence.** [Alternative Module 4](./alternatives/04-distance-motion-and-environment-sensors.md); [instructor notes index](./README.md).

**Revisit if.** No instructor uses the archive, or the handbook requires its goals.

<a id="d16"></a>
### D16 — English material, bilingual delivery; local-first systems

**Status:** accepted.

**Context.** HSBI material is English; students and instructors speak German and English. The class runs on a local network; cloud services are optional.

**Decision.** Written material is English; German may be spoken; German technical terms in parentheses are fine. The core stack is local: ESP32/M5Stack, local MQTT broker, optional Node-RED, optional IoTempower. No cloud dependency.

**Consequences.** No translation burden; German questions are welcome. The local-first design makes the class portable and privacy-preserving. The handbook lists the language as *deutsch*; the workbook is English by design — a recorded deviation (Q14), not an oversight.

**Alternatives rejected.** German-only material; cloud-first stack; vendor lock-in.

**Evidence.** [Syllabus](../syllabus.md); [README](../README.md).

**Revisit if.** The cohort language or the network policy changes.

<a id="d17"></a>
### D17 — The class is a draft in motion; ADR and TODO are its memory

**Status:** accepted.

**Context.** The class changes during the run; tasks are provisional; a design decision that is not written down gets lost or re-litigated.

**Decision.** Every module carries a visible `DRAFT BOUNDARY`. This ADR records decisions, alternatives, and reversal triggers; the [TODO](./TODO.md) records next-run actions. Update the record when a decision changes; do not silently rewrite history.

**Consequences.** Maintenance work; students see provisional material. The next instructor inherits the reasoning, not just the files.

**Alternatives rejected.** A frozen syllabus; a changelog only; hidden decisions.

**Evidence.** Every module; this file; [TODO](./TODO.md).

**Revisit if.** The class stabilizes or the record-keeping becomes heavier than the design work.

<a id="d18"></a>
### D18 — Handbook examples that are not on the bench are reading homework

**Status:** accepted.

**Context.** The handbook names triangulation and the gyroscope among its sensor examples, and thermal, fluid-power, and unconventional actuators among its families. The kit has no triangulation sensor, no pressure transmitter, no Peltier for every pod, and no hydraulic rig. Buying them would not survive a budget, and adding bench tasks would crowd Modules 4 and 7, which have just found their one-goal shape.

**Decision.** Cover the missing examples as **reading homework in the module that owns the theme**, with a small comparable artefact: Module 7 adds fluid power, thermal, and unconventional actuation plus a five-family comparison table; Module 8 adds hydrostatic pressure, triangulation, and the gyroscope, tied to the final project. The resource bank carries the reference rows and formulas. No new hardware, no new core bench task.

**Consequences.** The handbook examples are addressed at "explain and compare" depth, not "build"; the evidence is a study-log paragraph and one table, not a measurement. Students who want the bench can take it into the final project. The reading must stay short, or it becomes a lecture.

**Alternatives rejected.** Buying triangulation or pressure hardware; adding a new lab module; leaving the syllabus examples uncovered; turning the reading into a graded quiz.

**Evidence.** [Module 7](../modules/07-motors-and-motion-actuators.md); [Module 8](../modules/08-sensor-to-system-and-integration.md); [liquid-level principles](../modules/Z-resources-bank.md#liquid-level-principles).

<a id="d19"></a>
### D19 — Module 5 is evaluated: guided walkthrough, then challenge

**Status:** accepted.

**Context.** Module 5 is the session observed for the teaching evaluation. The evaluation format expects a lecture-style segment and an AI-first approach, while the module outcomes are hands-on. A pure lecture would not produce the evidence; a pure lab would not fit the observation. The class is also the first test of the “one open challenge plus a hints appendix” idea.

**Decision.** Run Module 5 as a guided walkthrough — first light with one LED, then the RGB LED, then the 8-LED strip and an optional extension — with students following on their own laptops, then hand the strip over for an open challenge with a comparable artefact (animation, power table, and a shareable repo). The repo is drafted with AI and verified on the strip: prompt → draft → verify → commit. The old task ladder becomes the appendix: background and failure modes, the manual route, pointers, and the `AGENTS.md` template; the two reference sketches move to the instructor notes as a backup for when AI or the editor tooling is unavailable. The module body keeps the goals, the story, the walkthrough, the challenge, and the share step.

**First run (2026-11-18).** The evaluation was positive. Every pod controlled the strip; two pods went beyond the extension list and built a small Tetris-like game, used a phone hotspot, and added a piezo. The no-AI Task 1 worked as the confidence builder and as the instructor's backup when the AI tooling was slow. The creative payoff came from the optional extension, not from the guided walkthrough.

**Consequences.** Less free exploration at the start; the walkthrough must stay short and interactive, or it eats the challenge. The learning evidence is the challenge, not the walkthrough. AI-first is visible in the challenge, not as a separate lecture; the repo makes the artifact shareable. **The guided format is now an observed-session pattern, not the default:** Modules 6+ use the open studio with a short brief, a no-AI first step where the hardware is new, and an AI-scaffolded build.

**Alternatives rejected.** A pure lecture (fails the hands-on outcomes); a pure lab (does not fit the observation); slides-only (students watch instead of building).

**Evidence.** [Module 5](../modules/05-leds-and-light-output.md); [Module 5 studio](./05-module-5-studio.md); the TODO structural idea.

**Revisit if.** The evaluation format changes; the open studio stops producing the evidence; or the no-AI first step proves unnecessary.

<a id="d20"></a>
### D20 — A teaching day is 180 minutes: two 90-minute blocks

**Status:** accepted.

**Context.** The timetable gives 48 school hours (≈36 clock hours) over 9 days, and the syllabus describes a block as 2 × 45-minute class hours. In practice a normal teaching day is **two 90-minute blocks (180 minutes)**, with the break between them. Run sheets that plan only 90 minutes leave half the day unplanned and make modules look overfull.

**Decision.** Plan a normal module in **180-minute days**: two 90-minute blocks. “Two sessions” means two blocks, not two 45-minute hours. The current timetable gives one to three slots per day (90 or 180 minutes) and no Day 10 — see D23. Module bodies carry no time estimates; the run sheets in the instructor notes use the block unit.

**Consequences.** More room for the guided walkthrough and the challenge; older run sheets must be checked for a 90-minute assumption. The syllabus wording (“2 × 45 min”) stays, because one 90-minute block is two 45-minute class hours.

**Alternatives rejected.** Planning 90-minute days; adding a third block; leaving the unit implicit.

**Evidence.** [Syllabus](../syllabus.md); [Module 5 studio](./05-module-5-studio.md); [TODO](./TODO.md).

**Revisit if.** The timetable changes or a day is split differently.

<a id="d21"></a>
### D21 — One vocabulary: Task, Subtask, Evidence

**Status:** accepted.

**Context.** The modules had grown four names for the same level of work: `Task` (Modules 1, 2, 6–8), `Round` (Module 3), `Studio` (Module 4), and `Stage` (Module 5). The syllabus — the single source of truth — already says “task” throughout (“the tasks are studio starters”, “the task list is a guide”, “Tasks are marked ★ Core or ◇ Stretcher”). Students had to relearn the map in every module, and the cross-cutting log and exchange (formerly Task A/B) looked like sections of their own instead of actions inside the work.

**Decision.** Every module uses **Task → Subtask → Evidence** and nothing else at those levels:

- The main divider is `### ★ Task N — <outcome>`; every task states `Proves:` (the learning goals it evidences) and `Produces:` (the artefact).
- Subtasks are the short, unnumbered bold moves inside a task (`1. Create the folder.`); cap them at four, sequence only, and never give a subtask its own evidence. Number them only when the run sheet or an evidence item must point at one.
- Every task ends with the same standing line, **Log it** — or the task is the module's closing exchange.
- The module closes with a final task for the pod exchange and the evidence check; the `## ✅ Suggested portfolio evidence` section stays and maps back to the goals. Module 6 is the exception: its exchange is an instructor-run end-of-session demo, and the evidence list closes the module; Tasks 1–3 are the module.
- `Session` remains the time unit (one 90-minute block). `Task Pod` and `Project Team` keep their names. `Stage`, `Round`, and `Studio` retire as student-facing activity names; `Studio` survives only as a heading word where the block is one open challenge (Module 4), not as a level in the vocabulary.
- Tasks remain tiered (`★`/`◇`) and negotiable; the vocabulary changes the label, not the contract.

**Why Task.** It is the syllabus's word, so the three documents now agree; it is the word students already met in most modules; it makes “Task Pod” and “Task” coherent; and it keeps the evidence chain visible — a task proves a goal, the portfolio evidences the task. The nuance lost by dropping Stage/Round (escalation vs. repetition) moves into the task title: “Task 2 — RGB LED project”, “Task 1 — Characterize”.

**Consequences.** Module 5 is the reference implementation (Tasks 1–5). Modules 1–4 keep their current wording for this run, with bracketed task numbers on their main dividers; their full refactor and the same convention in the Databases and Networking workbooks are TODOs for the next offering.

**Alternatives rejected.** Keeping Stage/Round/Studio with a glossary (three words to learn, and the syllabus would still say “task”); one flat task list without subtasks (long tasks become unreadable); numbered subtasks everywhere (cross-reference drift and a checklist feel).

**Evidence.** [Module 5](../modules/05-leds-and-light-output.md); [Module 5 studio](./05-module-5-studio.md); [TODO](./TODO.md).

**Revisit if.** The “one challenge plus hints appendix” architecture lands and tasks stop being the right container, or students treat the task list as boxes to tick rather than evidence to build.


<a id="d22"></a>
### D22 — Commits are instructor-only; agents never commit

**Status:** accepted.

**Context.** The Git history is the review surface. A commit made without the instructor reading the diff hides the change, mixes unrelated edits, and removes the single-file revert. The failure mode has occurred in this repository: a change reached the Git history without the instructor reviewing the diff, and from then on it could no longer be reviewed as a diff or reverted piecewise. The sibling logs record the same rule: [Databases D20](../../hsbi-databases-10d/instructor-notes/00-architecture-decisions.md#d20) and [Networking D18](../../hsbi-networking-iot-10d/instructor-notes/00-architecture-decisions.md#d18).

**Decision.** No agent and no collaborator runs `git commit`, `git commit --amend`, `git rebase`, `git tag`, `git reset`, or `git push` unless the instructor explicitly asks for it in the current conversation. Agents leave every change in the working tree; the instructor reviews the diff and commits. When a commit is explicitly requested, scope it to the files named in that request and do not fold in other work.

**Consequences.** The working tree may carry uncommitted changes between sessions; that is intended, not a mistake to clean up. Editors and tooling must not auto-commit in this folder. A clean tree is a sign that someone committed, not that the work is finished.

**Alternatives rejected.** Commit at the end of every task (removes the review gate); commit but never push (the local commit still hides the diff); commit only documentation (same problem, smaller file set); describe the diff in chat instead (a summary is not a review).

**Evidence.** The operative rules live in the repository [`AGENTS.md`](../../../AGENTS.md); this record keeps the rationale. Module and instructor-note edits stay in the working tree until the instructor commits them.

**Revisit if.** The instructor delegates a defined batch of commits (for example a scripted migration), or an automation account is explicitly authorised to commit on its own branch.

<a id="d23"></a>
### D23 — Nine-day timetable, two project tracks, and a video artifact

**Status:** accepted.

**Context.** The timetable changed after the first planning pass: Days 5–6 have two 90-minute slots, Days 7–9 are longer, and there is no Day 10. The WS 2026/27 calendar has 20 slots over 9 dates: 16 × 90 min + 4 × 180 min = **48 school hours = 36 clock hours**, exactly the handbook’s 16 Übung + 16 Praktikum + 16 betreutes Selbststudium. An earlier count of 22 blocks (44 school hours, 33 clock hours) was a unit and block miscount — a 90-minute slot is two 45-minute school hours — and is corrected here. At the same time the syllabus made MQTT mandatory in the final project, although this is the sensors/actuators class and the Networking & IoT class owns the network stack. The combination left the project too little time and forced a networking module into a schedule that no longer had room for it.

**Decision.**

- **Timetable:** 9 teaching days, **48 school hours (≈36 clock hours)**, 90- and 180-minute slots. The annual pattern varies over 8–10 days and is published in the LMS; student-facing text uses school hours, not a fixed block count. No Day 10.
- **Checkpoints:** CP2 moves to the start of Day 7 (Modules 4–6); CP3 moves to the start of Day 8 (Modules 7–8). Day 9 stays free for the project.
- **Project tracks:** Track A (default) is self-contained — local control loop, local UI/logging, and a **System Boundary Document** describing the network interface it would expose. Track B (optional) implements MQTT and a dashboard, and tests a broker restart. Both carry the same 5 points and the same sensing, characterization, actuation, and reliability must-haves.
- **Module 8** becomes a one-block clinic: boundary, local loop, filter, fault behavior; MQTT and dashboard are `◇` (Track B).
- **Final session:** Day 9, 08:30–11:30 finish, beautify, and practise; 11:30–12:30 break; 12:30–14:00 demo preparation and a full rehearsal; 14:15–15:45 three teams × 30 minutes (15–20 presentation, feedback fills the slot). The live walkthrough is a **feedback rehearsal**; the assessed artifacts are the submitted 5–10 minute video, slide deck, and documentation. The video is recorded and edited after class and submitted by the last day of the examination period (*Prüfungszeitraum*, announced in the LMS). The Part 1 portfolio is due on the same day; its Days 7–9 reflection may be written on the evening of Day 9 or the next morning.
- **Grade table:** 20 = 1.0, 19 = 1.3, 18 = 1.7, 17 = 2.0, 16 = 2.3, 15 = 3.0, 14 = 4.0, below 14 = 5.0. A 2.7 is not a table row; the instructor may award it for an overall 3.0 performance with an exceptionally well-shaped portfolio.

**Consequences.** The syllabus, Modules 8–10, and the index are rewritten to match. The schedule is expressed in school hours, and the annual slot pattern comes from the LMS; the day table is a planning abstraction, not a contract. The two tracks must be announced in the first session, and the video requirement must be in the project brief from the start.

**Alternatives rejected.** Keeping MQTT mandatory (duplicates the Networking class and costs project time); a 10-minute stage talk per team (nervous, weak evidence, no room for retries); assessing the live presentation (contradicts the artifact-based Kombinationsprüfung and the syllabus); lowering the pass mark to fit a full German grade scale (the 14-point pass stays); publishing a fixed block count and converting it to clock hours (caused the 22-block/44-hour/33-clock-hour miscount).

**Evidence.** [Syllabus](../syllabus.md); [Module 8](../modules/08-sensor-to-system-and-integration.md); [Module 9](../modules/09-final-project-studio.md); [Module 10](../modules/10-demonstration-and-presentation.md); [index](../modules/00-index.md).

**Revisit if.** The timetable returns to 10 days; the Prüfungsausschuss rejects the contact-hour deviation; or a cohort wants the networked track as the default.

<a id="d24"></a>
### D24 — Module 6: two controllers, UART default, play mandatory

**Status:** provisional (first run 2026-11-25).

**Context.** The 32×32 HUB75 panel needs thirteen signals; the M5StickC-S3 carries the microphone, IMU, speaker, display, and only a small exposed header. The class board is the MH-ET LIVE ESP32 MiniKit; its header exposes the pins the panel needs, and the 2026-11-18 Module 5 run showed that the creative payoff comes from an open build. The ES8311 codec is half-duplex: microphone and speaker cannot run at the same time.

**Decision.**

- **Two controllers.** The MH-ET LIVE ESP32 MiniKit (`mhetesp32minikit`) drives the panel; the M5StickC-S3 reads the microphone and IMU and sends `L 0..100` and `H 0..255`.
- **UART default.** Hardware `Serial2` on the Stick's HAT2 G1/G2 (or Grove G9/G10) to the panel's GPIO32/33, 115200, newline-terminated. No SoftwareSerial: it competes with the I2S microphone and the panel DMA. ESP-NOW is the `◇` “cut the cable” extension; a phone hotspot with MQTT is Module 8/final-project territory.
- **First light without AI.** The panel is new hardware; Task 1 uses the library example and the meter, not an agent. AI scaffolds Task 2.
- **Controller family: ESP32, not ESP8266 — with the reason on record.** An ESP8266 *can* drive a
  HUB75 panel with [`PxMatrix`](https://github.com/2dom/PxMatrix), and that was a working recipe in
  earlier years, including several panels chained on one ribbon. It gets away with the ESP8266's
  single SPI data line by chaining the panel's six colour registers into one, using five jumpers
  between the input and the output header. So the harness is *not* identical: the ESP8266 uses
  fewer GPIOs (8 panel signals instead of 13) and puts three times as many bits on the wire per
  frame. It is still rejected here, but for the refresh, not for the pins: the refresh is CPU-bound
  (no DMA, lower colour depth, flicker below 160 MHz), and bit-banging leaves no CPU to sample
  audio, run the animation, and keep a wireless path alive. The ESP32's DMA path buys that headroom.
  The ESP8266 route is kept as a working plan B for a cohort with only ESP8266 boards and as the
  control experiment for a dark ESP32 build:
  [`module6-panel-lab/pxmatrix-fallback/`](module6-panel-lab/pxmatrix-fallback/README.md). Students
  should still be able to explain the trade (see the resource bank's
  [1/16-scan entry](../modules/Z-resources-bank.md#hub75-scan)).
- **Play is mandatory.** Task 3 is a `★` task, stays open after the session, and starts with a one-sentence story hook. The hook is part of the design note and the evidence; the realization may stay small.
- **No closing task.** The repo and the evidence list are implicit; the instructor runs a short demo at the end. Module 6's tasks are 1–3 (D21 exception).
- **One 180-minute studio.** Two halves with a break; the run sheet is in the Module 6 studio note.

**Consequences.** More moving parts than Module 5: two boards, a link, a 5 V supply, and a level shifter. Pre-flight is mandatory; keep a known-good reference project. The play task gives the creativity a home and seeds the final-project story. The Stick's speaker and microphone cannot run simultaneously; use a piezo on the panel controller or a second Stick.

**Alternatives rejected.** One controller (the Stick does not expose enough pins; the MiniKit is the class board with the needed header); SoftwareSerial (competes with I2S/DMA); ESP-NOW as the default (pairing and channel state add friction); phone hotspot plus MQTT (duplicates Module 8); one AI prompt for both boards (two PlatformIO projects are clearer).

**Evidence.** [Module 6](../modules/06-led-animation-sound-and-installations.md); [Module 6 studio](./06-module-6-studio.md); [reference project](./module6-panel-lab/README.md).

**Revisit if.** A supported S3 board with enough exposed pins appears; ESP-NOW proves easier than UART in the room; or the play task stops producing evidence.


## 3. Deliberately rejected or retired

| Idea | Why it is not in the current path | Where it survives |
|---|---|---|
| NTC as the primary temperature sensor | No NTC in the kit; the sealed DS18B20 is the robust probe | Module 3 story; resource-bank Beta equation |
| Foil/copper-tape DIY capacitive liquid sensor | It was a touch idea, not a liquid method; distance/scale sensing is more reliable for liquids | Optional MPR121/touch side note in Module 4 and the pre-study |
| MPR121 as a liquid-level sensor | It is a touch/proximity controller, not a liquid probe | Optional touch side idea |
| Node-RED as a Module 4 requirement | The module is before Module 8; visualization is the pod's choice | Module 8; final project |
| The old Module 4 distance/motion/environment catalogue | It obscured the goal and duplicated sensor families | Archived instructor alternative |
| One pod per decision-sheet row | Too little work and no comparison | Two pods aim for 4–5 rows |
| A full sensor sweep by every pod | Impossible in two sessions and unnecessary | 80% class-level coverage; each pod tests a few |
| A full scale calibration table with three or more masses | The HX711/load cell is linear; two readings are enough | Two-reading scale check + optional third check |
| Time estimates in modules | They become false promises and crowd the goal | Operational timing in instructor notes/email |
| A separate Pod Study before every lab | It ate the bench time in Modules 3–4 | Just-in-time briefs; Pod Study where vocabulary demands it |
| Per-student reports | The pod shares the work; the contribution note keeps accountability | One report per pod + contribution note (provisional) |
| Points, grades, checkpoints in modules | Assessment lives only in the syllabus | Syllabus |
| Cloud-first / Node-RED-first | Local-first is the design; cloud is optional | README/syllabus |
| Copying Databases or Networking content | The siblings share structure, not subject matter | Sibling ADRs as references |
| Deleting the old Module 4 | Some instructors may prefer it | Archived alternative |
| Buying NTCs or more hardware before testing the room | The kit is sufficient for the current design | TODO hardware check |
| Triangulation, gyroscope, and hydrostatic pressure as bench labs | No hardware; the gyro adds little to the harbor/outside decision | Reading homework in Module 8; D18 |
| Thermal, fluid-power, and unconventional actuators as bench labs | No Peltier per pod, no hydraulic rig; would crowd Module 7 | Reading plus the five-family table in Module 7; D18 |
| A pure lecture for Module 5 | The outcomes are hands-on; a lecture would not produce the evidence | Guided walkthrough then challenge (D19) |
| A pure lab for Module 5 | The evaluation format expects a lecture-style segment | Guided walkthrough then challenge (D19) |
| Stage/Round/Studio as activity names | Four words for one level; the syllabus already says “task”; students relearned the map each module | Task → Subtask → Evidence (D21) |
| DHT11 as the primary frost sensor | ±2 °C is too wide for a 2 °C decision | Optional comparison |
| Water in bags / boiling water | The probe is sealed; the connector is not | Module 3 safety note |
| One binary capacitive sensor per pod | There is one unit | Shared sensor; D12 |
| "Students must test every sensor" | Coverage is a class property, not a pod requirement | 80% class-level |

## 4. Open questions

| # | Question | Why it matters | Owner |
|---|---|---|---|
| Q2 | **Reports: per pod or per student, and what is the Leistungsnachweis?** Working interpretation (2026-11-15, unconfirmed): the individual portfolio with its checkpoint evidence is the *Leistungsnachweis*; the portfolio report and the project presentation are the two parts of the *Modulprüfung*. Still open: whether the Module 4 pod report satisfies the individual portfolio, and what the Prüfungsausschuss actually counts. | Affects the module text, the report ownership, and the portfolio evidence. | D4, D9, D13 |
| Q3 | **How do three pod pairs fill 4–5 rows?** One pair may take two tanks; the class table must stay comparable. | The workload and the jigsaw need a stable assignment. | D9, D12 |
| Q4 | **Is one shared binary capacitive sensor enough?** Does it need a rotation, or should it become a per-pod item? | It is a single unit; the module marks it shared. | D10, D12 |
| Q5 | **What is the analog soil/humidity probe's role?** Concept test, optional principle, or a recommended sensor for waste/bilge? It is not food-safe and is unstable in splashes. | Students may over-trust it for drinking water or fuel. | D10 |
| Q6 | **Is the two-reading scale check enough evidence?** Does the test card need a formal calibration record, or is the tank table plus the check sufficient? | The current design removed the full table. | D11 |
| Q7 | **Does the bench checkpoint fit two sessions?** The email says about 15 minutes per pod; the module carries no time estimate. | The room needs a rotation and two instructors. | D13 |
| Q8 | **Is Node-RED clearly optional in Module 4?** The global README/syllabus mention it; the module does not require it. | Students may think they need it before Module 8. | D10, D14 |
| Q9 | **Is the old Module 4 archive still useful?** Does anyone teach it, and do its links/story canon stay valid? | It is instructor-facing maintenance. | D15 |
| Q11 | **How many M5StickC-S3 units are available, and is the BMI270 library stable?** | The IMU/display path depends on it. | D10 |
| Q12 | **Is environment sensing covered enough?** The new Module 4 no longer has BME280/DHT22 as a core lab; Module 3 covers T/RH, and the final project can use environment sensors. | The handbook outcome 3 includes environment sensing. | D8, Appendix A |
| Q13 | **Which semester is the module in?** The handbook says *5. Semester*; the syllabus says *6th semester*. | Students read both; it affects prerequisites and cohort expectations. | D1; syllabus |
| Q14 | **Language of record.** The handbook says *Sprache: deutsch*; the class is taught and written in English and German. | If the Prüfungsausschuss treats the handbook line as binding, the material language needs a documented exception. | D16 |

**Resolved.**

- **Q1 — Module 4 handbook coverage (2026-11-15).** The module handbook 3350 lists sensor principles as examples (*"z.B. Positions- und Abstandssensoren, Time-of-Flight, Gyroskop, Triangulation"*), not as a fixed catalogue, and permits the *Kombinationsprüfung*. The liquid challenge covers position, distance, and force directly; triangulation, gyroscope, and hydrostatic pressure are now reading homework in Module 8 (D18). D8 moves to **accepted**.

- **Q10 — the collaboration wrapper (2026-11-16).** Resolved by D21: the study log is a standing `Log it` line inside every task, and each module closes with an exchange/evidence task; the letter tasks A/B retire. Modules 1–4 migrate at their next revision; this run only gains bracketed task numbers on their main dividers.

## 5. Recreation checklist

- Read the [syllabus](../syllabus.md), [module index](../modules/00-index.md), this ADR, and the [TODO](./TODO.md) before changing anything.
- Confirm the module handbook and the examination form; keep assessment rules out of modules.
- Check the [DRAFT BOUNDARY](../modules/04-liquid-measurement-and-sensor-selection.md) positions and the learning-goal count (4–6).
- Prepare the shared kit: six pods, three multimeters, three HX711 scales with one known mass each, ToF/ultrasonic, Hall/magnet/cork, analog soil/humidity probes (open/sealed/needle), one binary capacitive water sensor, light barriers, reed/float, M5StickC-S3/BMI270, HX711 wiring.
- Prepare the consumables: trays, towels, ruler, funnel, labels, cardboard, scissors, glue, tape, salt, dish soap, coffee grounds/soil/paper, bottles/cups; oil waste bottle; no glass.
- Build the Module 4 class table (4–5 rows) and the test cards; send the [student email](./04-module-4-student-email.md) and ask the co-instructor to scrounge.
- Render the slide deck (or run `./tools/check-slides.sh`) and check the page count; run `./tools/check-all.sh`.
- Teach; record what actually happened in the [TODO](./TODO.md) observations.

## Appendix A — Module handbook coverage

The authoritative wording is in the [syllabus](../syllabus.md). This table is a design check, not a second syllabus.

| Outcome | Where it is taught | Where it is evidenced |
|---|---|---|
| 1. Measurement fundamentals | Module 1; Module 3 | ADC/divider lab; calibration record; uncertainty |
| 2. Digital signal chain | Modules 1–3 | ADC, sampling, scope/analyzer, filtering |
| 3. Sensor principles | Module 2 (bus), Module 3 (T/RH), Module 4 (ToF, ultrasonic, IMU, Hall, load cell, liquid) | Characterization and liquid decision sheet; environment via Module 3/final project |
| 4. Actuator principles | Modules 5–7 | LED, animation, servo, DC motor, stepper |
| 5. Characterize and calibrate | Modules 3, 4 | Transfer function, hysteresis, two-reading scale check, tank table, uncertainty |
| 6. Buses | Module 2 | I²C/OneWire/SPI/UART, address conflicts, scope/analyzer |
| 7. Drive actuators safely | Modules 5–7 | Current limits, power budget, drivers, flyback |
| 8. Build and evaluate systems | Modules 8–10 | MQTT, optional Node-RED, closed loop, final project |

> **Module 4 handbook check (resolved 2026-11-15).** The handbook lists examples (*"z.B."*), not a fixed catalogue. The liquid challenge covers distance (ToF/ultrasonic), position (float/reed/Hall), motion (IMU), and force (load cell). Triangulation, gyroscope, and hydrostatic pressure are reading homework in Module 8 (D18). Revisit only if the handbook text changes.

## Appendix B — Where the source material lives

| Topic | Where |
|---|---|
| Student path | [README](../README.md); [module index](../modules/00-index.md); [syllabus](../syllabus.md) |
| Module 3 | [Module 3](../modules/03-sensor-characterization-and-calibration.md); [Module 3 studio](./02-module-3-studio.md); [resource bank](../modules/Z-resources-bank.md) |
| Module 4 | [Module 4](../modules/04-liquid-measurement-and-sensor-selection.md); [Module 4 studio](./03-module-4-studio.md); [student email](./04-module-4-student-email.md); [liquid-level principles](../modules/Z-resources-bank.md#liquid-level-principles) |
| Old Module 4 | [Alternative Module 4](./alternatives/04-distance-motion-and-environment-sensors.md) |
| Assessment and operations | [Assessment & operations](./00-assessment-and-operations.md); [syllabus](../syllabus.md) |
| Story canon | [Resource bank](../modules/Z-resources-bank.md#story-canon-the-recurring-cast) |
| Prompts and reference | [Prompt bank](../modules/Y-resources-prompt-bank.md); [resource bank](../modules/Z-resources-bank.md) |
| Session 1 slides | [Slides](../slides/01-introduction.md) |
| Sibling ADRs | [Networking](../../hsbi-networking-iot-10d/instructor-notes/00-architecture-decisions.md); [Databases](../../hsbi-databases-10d/instructor-notes/00-architecture-decisions.md) |

## Appendix C — Change log of this document

- **2026-11-15** — First version, written before the next architectural change. Reconstructed from the current modules, the first offering, the instructor notes, and the sibling ADRs. It is a baseline, not a final history; update the records and keep the old reasoning visible.
- **2026-11-15** — Handbook check and reading gaps. Q1 resolved against the module handbook; D8 accepted; D18 added (reading homework for triangulation, gyroscope, pressure, fluid power, thermal, unconventional); Q2 reopened with the *Leistungsnachweis* interpretation; Q13/Q14 recorded; Modules 7–8 and the liquid-level table updated.
- **2026-11-15** — Module 5 format. D19 added: the evaluated session runs as a guided walkthrough, then an open challenge; the old task ladder becomes the appendix; the challenge deliverable is an AI-drafted, verified, shareable repo. The TODO records the all-classes “one challenge plus hints appendix” and AI-first patterns.
- **2026-11-15** — Planning unit. D20 added: a teaching day is two 90-minute blocks (180 minutes); Module 5's run sheet and the constraints table now use that unit.
- **2026-11-16** — Review gate. D22 added: no agent or collaborator commits, amends, rebases, tags, or pushes without an explicit instruction; changes stay in the working tree for the instructor's review. The same rule is recorded in Databases (D20) and Networking (D18).
- **2026-11-16** — Timetable and project. D23 added: 9 teaching days, 48 school hours (≈36 clock hours) in 90/180-minute slots, CP2/CP3 moved, two project tracks with optional MQTT, Module 8 as a clinic, Day 9 feedback rehearsal plus a 5–10 minute assessed video, grade table B. D20 amended for the longer Days 7–9.
- **2026-11-16** — Vocabulary. D21 added: every module uses Task → Subtask → Evidence; Module 5 refactored as the reference (Tasks 1–5, `Proves:`/`Produces:`, standing `Log it`, closing exchange task); Modules 1–4 carry bracketed task numbers until their refactor; the sibling workbooks get the same TODO. Q10 resolved.
- **2026-11-22** — Module 5 evidence and Module 6. D19 accepted after the evaluation: every pod controlled the strip, two pods built games with phone hotspots and a piezo; the guided format stays an observed-session pattern. D24 added: two controllers, UART default, ESP-NOW as the wireless extension, mandatory play task with a story hook, one 180-minute studio.
- **2026-11-23** — Module 6 controller family. D24 extended: the ESP32/DMA choice is recorded against the ESP8266 + PxMatrix route that worked in earlier years, with the reason (no CPU left for audio and the link). The resource bank gained a [1/16-scan entry](../modules/Z-resources-bank.md#hub75-scan) so the module's Task 1 question has a reference, and the reference lab documents the GPIO-12 strapping hazard and a GPIO-18 remap.
- **2026-11-23** — Module 6 panel bring-up. Corrected a factual claim in D24 and in the resource bank: the ESP8266 + PxMatrix harness is *not* identical to the ESP32 one — it chains the six colour registers with five jumpers and drives one data line, so it uses fewer GPIOs and three times the bits per frame. The 2026-11-21…23 bring-up also showed a dark panel with a running DMA driver (frames climbing, dark at brightness 255), so the sketch gained a brightness beacon, a config banner, a periodic diagnostic line and a serial console, and the lab gained a plan-B project, [`module6-panel-lab/pxmatrix-fallback/`](module6-panel-lab/pxmatrix-fallback/README.md), which separates a panel or ribbon fault from an ESP32 harness fault. The lab's wiring tables were renumbered to the panel's printed HUB75 order (R1 G1 / B1 GND / … / CLK LAT / OE GND): the earlier numbers were swapped within each pair, which silently swaps `CLK` and `LAT` — the classic cause of a black panel with a healthy driver. The whole wiring reference moved to the student side, [Module 6 Appendix A](../modules/06-led-animation-sound-and-installations.md#appendix-a), because students wire the panel themselves; the instructor lab keeps only build, test, failure table and known issues, and no longer duplicates pin data. The reference sketch gained a `c` console command that shows the corner/ramp frame alone, the only frame that proves the address lines.
