# Sensors and Actuators (Sensorik und Aktorik) — Module Index & Roadmap

[← Course workbook](../README.md) | [Pre-study guide](../pre-study.md) | [Syllabus](../syllabus.md)

## Session roadmap (10 days, one module per day)

| Module | Day | Modern studio | Hands-on focus |
|:---:|:---:|---|---|
| [Module 0 — Pre-study](../pre-study.md) | Before Day 1 | Portfolio, measurement basics, Wokwi | Measurement chain, datasheet reading, ADC resolution in simulation, first project abstract. |
| [Module 1](./01-foundations-measurement-and-sensor-chain.md) | Day 1 | Foundations: Electronics, Arduino & Measurement | Basic electronics (LED actor, button with pull-up/pull-down, debouncing), Arduino serial console and plotting, metrology and the signal chain, ADC precision dance, LDR and first filtering. |
| [Module 2](./02-i2c-and-sensor-addressing.md) | Day 2 | Buses & I²C: From Simple Pins to One Bus, Many Devices | Simple pins/PWM/voltage divider (optional UART detour), bus survey (RS-232/RS-485/Modbus/CAN/I²C/SPI/OneWire), I²C wiring/scan/register, address conflicts, scope/analyzer sprint. |
| [Module 3](./03-sensor-characterization-and-calibration.md) | Day 3 | Sensor Characterization, Calibration & Data Quality | Transfer function, linearity, hysteresis, calibration, filtering, uncertainty of an NTC/LDR. |
| [Module 4](./04-distance-motion-and-environment-sensors.md) | Day 4 | Distance, Motion & Environment Sensors **+ Checkpoint 1** | ToF and ultrasonic distance, people counting, IMU tilt/drift/fusion, Hall current sensing. |
| [Module 5](./05-leds-and-light-output.md) | Day 5 | LEDs & Light as Output | Current limiting, PWM and gamma, RGB mixing, addressable WS2812, power budget. |
| [Module 6](./06-led-animation-sound-and-installations.md) | Day 6 | LED Animation, Sound & Interactive Installations | Non-blocking animation, palettes and blending, sensor- and sound-reactive installations. |
| [Module 7](./07-motors-and-motion-actuators.md) | Day 7 | Motors & Motion Actuators | Servo position, DC motor with H-bridge, stepper steps, current and stall, sensor→motor logic. |
| [Module 8](./08-sensor-to-system-and-integration.md) | Day 8 | From Sensor to System: MQTT & Integration **+ Checkpoint 2** | Direct MQTT publishing and commands, filters in firmware, Node-RED dashboard, closed-loop control, fault injection; optional IoTempower comparison. |
| [Module 9](./09-final-project-studio.md) | Days 9–10 | Final Project Studio | Kickoff and story, build and integrate, characterization and evaluation, peer review; **checkpoint 3** (Modules 7–8). |
| [Module 10](./10-demonstration-and-presentation.md) | Day 10 | Project Presentation & Submitted Artifacts | Artifact-based presentation of the submitted slide deck and demo artifacts, measurement and fault-injection evidence, portfolio walkthrough. |
| [Session 1 slides](../slides/01-introduction.md) | Day 1 | Supplementary | Plain-Markdown intro deck: whoami, first portfolio notes, course contract, pre-study rehash, and hand-over to the Module 1 tasks. |
| [Prompt bank](./Y-resources-prompt-bank.md) | — | Supplementary | Reflection prompts, LLM-verification drills, quick references. |
| [Resource bank](./Z-resources-bank.md) | — | Supplementary | Datasheets, cheat sheets, Git/GitHub primer, story canon, troubleshooting, instructor hints. |

## What changed, and why

| Legacy emphasis | This course's emphasis | Reason |
|---|---|---|
| A lecture catalogue of sensor and actuator principles | Pod study + mini exercises around real hardware | You learn what you can wire, measure, and debug — not what you can recite. |
| A library example as the goal | Scan the bus, read the register, then trust the library | Understanding the device is the difference between "it works" and "I can fix it." |
| A single lucky reading | Characterization, calibration, and stated uncertainty | A number without conditions and error bars is not a measurement. |
| Actuators as pins that go high | Drivers, current, power budgets, and safety | Logic pins command; they do not power motors, strips, or relays. |
| Isolated labs | Story-driven challenges with a named stakeholder | The story supplies the "why"; the learning goals stay explicit. |
| A fixed, lecture-scripted syllabus | A moving bar with fixed learning goals and ★/◇ task tiers | The class is new; goals stay stable while tasks move with the cohort. |
| An exam that rewards recall | A portfolio and checkpoints that prove the goals | Evidence over task-completion: students prove goals, not tick boxes. |
| AI as an oracle | AI as a drafting tool that must be verified | Verification against the datasheet, meter, and measurement is the skill. |

> **Sources for these shifts.** The measurement-first, local-first stance is documented in the [resource bank](./Z-resources-bank.md#extended-reading), together with sensor datasheets and the [story canon](./Z-resources-bank.md#story-canon-the-recurring-cast).

## Assessment

Assessment — how the points are earned, the checkpoints, the reflection format, the task tiers, and the grade scale — is defined **only** in the [syllabus](../syllabus.md#assessment-kombinationsprüfung-20-points).
