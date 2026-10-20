# Sensors and Actuators (Sensorik und Aktorik) — Module Index & Roadmap

[← Course workbook](../README.md) | [Pre-study guide](../pre-study.md) | [Syllabus](../syllabus.md)

> Each module opens with its **learning goals** and a ***DRAFT BOUNDARY*** marking the content still under construction. How learning goals are assessed, and why the tasks are negotiable, is explained once in the [syllabus](../syllabus.md#how-module-points-are-earned-checkpoint-presentations).

## Session roadmap (10 days / 12 sessions)

| Module | Day / Session | Modern studio | Hands-on focus |
|:---:|:---:|---|---|
| [Module 0 — Pre-study](../pre-study.md) | Before Day 1 | Portfolio, measurement basics, Wokwi | Measurement chain, datasheet reading, ADC resolution in simulation, first project abstract. |
| [Module 1](./01-foundations-measurement-and-sensor-chain.md) | Day 1 / Session 1 | Foundations: Measurement, Signals & the Sensor–Actuator Chain | Metrology and uncertainty, the signal chain, ADC precision dance, first IoTempower sensor node. |
| [Module 2](./02-i2c-and-sensor-addressing.md) | Day 2 / Session 2 | I²C & Sensor Addressing | Bus wiring and scan, 7-bit addresses, register maps, two devices on one bus, address conflicts. |
| [Module 3](./03-sensor-characterization-and-calibration.md) | Day 3 / Session 3 | Sensor Characterization, Calibration & Data Quality | Transfer function, linearity, hysteresis, calibration, filtering, uncertainty of an NTC/LDR. |
| [Module 4](./04-distance-motion-and-environment-sensors.md) | Day 4 / Session 4 | Distance, Motion & Environment Sensors **+ Checkpoint 1** | ToF and ultrasonic distance, people counting, IMU tilt/drift/fusion, Hall current sensing. |
| [Module 5](./05-leds-and-light-output.md) | Day 5 / Session 5 | LEDs & Light as Output | Current limiting, PWM and gamma, RGB mixing, addressable WS2812, power budget. |
| [Module 6](./06-led-animation-sound-and-installations.md) | Day 6 / Session 6 | LED Animation, Sound & Interactive Installations | Non-blocking animation, palettes and blending, sensor- and sound-reactive installations. |
| [Module 7](./07-motors-and-motion-actuators.md) | Day 7 / Session 7 | Motors & Motion Actuators | Servo position, DC motor with H-bridge, stepper steps, current and stall, sensor→motor logic. |
| [Module 8](./08-sensor-to-system-and-integration.md) | Day 8 / Session 8 | From Sensor to System: IoTempower & Integration **+ Checkpoint 2** | Declarative node, filters, MQTT, Node-RED dashboard, closed-loop control, fault injection. |
| [Module 9](./09-final-project-studio.md) | Days 9–10 / Sessions 9–11 | Final Project Studio | Kickoff and story, build and integrate, characterization and evaluation, peer review; **checkpoint 3** (Modules 7–8). |
| [Module 10](./10-demonstration-and-defense.md) | Day 10 / Session 12 | Demonstration & Portfolio Defense | Live sensor/actuator demonstration, fault injection, individual defense. |
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

Assessment — how the points are earned, the checkpoints, the reflection format, the task tiers, and the grade scale — is defined **only** in the [syllabus](../syllabus.md#assessment-kombinationsprüfung-20-base-points--bonus).
