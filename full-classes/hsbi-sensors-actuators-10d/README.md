# HSBI/GT Sensors and Actuators (Sensorik und Aktorik) — 10-Day Edition

## Contents

| Start here | What it contains |
|---|---|
| [Pre-study guide](./pre-study.md) | Measurement basics, a Wokwi mini-exercise, and first sensor/actuator thinking (Module 0) |
| [Syllabus](./syllabus.md) | Course schedule, learning objectives, assessment rules, and hardware kit |
| [Module 1 — Foundations: Measurement, Signals & the Sensor–Actuator Chain](./modules/01-foundations-measurement-and-sensor-chain.md) | Metrology, error, ADC/sampling, Master Class with a first IoTempower sensor node |
| [Module 2 — I²C & Sensor Addressing](./modules/02-i2c-and-sensor-addressing.md) | Buses, 7-bit addresses, scans, register maps, multiple devices on one bus |
| [Module 3 — Sensor Characterization, Calibration & Data Quality](./modules/03-sensor-characterization-and-calibration.md) | Transfer function, linearity, hysteresis, resolution, calibration, filtering |
| [Module 4 — Distance, Motion & Environment Sensors](./modules/04-distance-motion-and-environment-sensors.md) | ToF, ultrasonic, IR, IMU, Hall/current, temperature/humidity/pressure |
| [Module 5 — LEDs & Light as Output](./modules/05-leds-and-light-output.md) | LED physics, current limiting, PWM, RGB mixing, addressable WS2812 strips |
| [Module 6 — LED Animation, Sound & Interactive Installations](./modules/06-led-animation-sound-and-installations.md) | Animation, timing, sound reactivity, interactive installation prototyping |
| [Module 7 — Motors & Motion Actuators](./modules/07-motors-and-motion-actuators.md) | Servo, DC motor with H-bridge, stepper, drivers, torque, current, safety |
| [Module 8 — From Sensor to System: IoTempower & Integration](./modules/08-sensor-to-system-and-integration.md) | Declarative drivers and filters, MQTT, Node-RED dashboards, closed-loop control |
| [Module 9 — Final Project Studio](./modules/09-final-project-studio.md) | Project kickoff, requirement mapping, build, characterization, resilience, peer review |
| [Module 10 — Demonstration & Portfolio Defense](./modules/10-demonstration-and-defense.md) | Live demonstration, technical defense, portfolio evaluation, retrospective |
| [Resource Prompts](./modules/Y-resources-prompt-bank.md) | Portfolio prompts and quick references |
| [Resource Bank](./modules/Z-resources-bank.md) | Extra resources, cheat sheets, and troubleshooting |

This README is the course workbook and front page for the Sensors and Actuators (Sensorik und Aktorik) course taught at Hochschule Bielefeld University of Applied Sciences and Arts (HSBI), Campus Gütersloh. It is delivered over 10 working days / 12 sessions (4 hours each, 48 contact hours) across the semester. The official timetable, room, and announcements are published through the course LMS (ILIAS).

> [!NOTE]
> This is a new class, first taught in WS 2026/27, and a living document: expect adaptations before and during the semester. Large parts are still a draft — each module marks unsettled content with a moving *DRAFT BOUNDARY* that we raise as we approve it together, and your feedback is explicitly welcome and can shape the class.

## Course Overview

- Duration: 10 working days / 12 sessions (4 hours each).
- Target Group: Bachelor students in *Digitale Technologien* (6th semester, Wahlmodul). Module number 3350.
- Workload: 150 hours (5 ECTS credits).
- Format: Practical, laboratory-driven course combining measurement fundamentals, sensor characterization, and hands-on work with real sensors and actuators — from a first I²C scan to motors, LEDs, and animated installations.
- A standalone elective: *Sensorik und Aktorik* is a 6th-semester elective (Wahlmodul) and stands on its own — it neither requires nor continues a specific earlier module. It concentrates on the *physical* side of IoT: what a sensor really measures and how an actuator really moves. The small amount of local-first infrastructure it uses (a node, a local MQTT broker, Node-RED) is introduced in the course itself. If you also take other IoT classes and notice useful touch points, you are welcome to raise them with the instructor — but there is no required prior course.
- Hardware Kit:
  - M5Stack Modular Nodes (M5StickC Plus2, M5Atom Matrix/Lite) with Grove sensors and actuators — the fast path to working I²C and PWM devices.
  - Raw ESP boards on breadboards — the path where you meet physics: voltage dividers, current limiting, real transfer functions. Available as ESP32 DevKits, ESP32 Ethernet mini kits, and ESP8266/Wemos D1 Mini boards.
  - Sensor set: NTC, LDR, Hall-effect, DS18B20, VL53L0X ToF, MPU6050 (IMU), ultrasonic, PIR, environment (T/RH/P).
  - Actuator set: SG90 servo, DC motor + H-bridge driver, 28BYJ-48 stepper + ULN2003, relay, buzzers, RGB LEDs, and WS2812 (NeoPixel) strips.
  - Instruments: multimeter, USB power meter, optional logic analyzer.
- Software Stack:
  - Firmware & Build: Arduino IDE v2 or PlatformIO (VSCode).
  - Framework: [IoTempower](https://github.com/iotempire/iotempower) for declarative drivers, filters, and Over-The-Air deployment.
  - Integration: Mosquitto MQTT broker, Node-RED dashboards, Python (`paho-mqtt`) where useful.
  - Simulation & Tools: Wokwi (browser simulation), `i2c-tools`, FastLED.

For the complete language arrangement, teaching team, learning objectives, assessment rules, and policies, read the [syllabus](./syllabus.md).

## Assessment: Kombinationsprüfung (20 Points Base + Bonus)

Your final grade is assessed continuously through your personal GitHub Portfolio and a final project:

- Module 0 (Pre-Study): 1 point (compulsory preparation before the first session; see [pre-study guide](./pre-study.md)).
- Modules 1–8 (Learning goals): 10 points, earned through checkpoint presentations (~10 min each, covering 2–3 modules) that prove the module learning goals from your portfolio and reflections — not by completing every task. You may skip tasks, fail at some, or add your own. See the [syllabus](./syllabus.md#how-module-points-are-earned-checkpoint-presentations).
- Working-Day Reflections: 4 points (one reflection for each working day documenting measurements, failures, and solutions).
- Final Project: 5 points (25% of base score; a documented sensor/actuator system with characterization and an integration layer).
- Bonus / Extra Points: Up to 3 points for outstanding work, peer mentoring, advanced stretcher tasks, or accepted upstream pull requests to IoTempower or this curriculum repository.
- Passing Mark: 14 / 20 points (~70%).

## Portfolio & Hardware

Maintain a personal GitHub portfolio with circuits, measurement tables, transfer-function plots, calibration notes, code, MQTT topics, Node-RED flow exports, and working-day reflections. Start from the [portfolio template](https://github.com/iotempire/iot-portfolio-template).

Module 0 is required: before the first session, fork your portfolio and complete the pre-study tasks in [pre-study.md](./pre-study.md). In sensor work, documented measurement and calibration matter more than a lucky reading — showing how you found a dead I²C device, a noisy channel, or a wrong transfer function is exactly the engineering skill this course builds.

## Navigation & Resources

- [Module index](./modules/00-index.md) — compact navigation
- [Pre-study guide](./pre-study.md) — start here before Day 1
- [Syllabus](./syllabus.md) — official course rules and policies
- [IoTempower](https://github.com/iotempire/iotempower) — declarative sensor/actuator framework ([iotempower.us](https://iotempower.us))
- [IoTempire](https://iotempire.net/) — organization, teaching tools, and community

### LMS PDF Exports

Generate dated, upload-ready PDFs from the syllabus and pre-study guide using LibreOffice (default), Chromium, or LaTeX:

```sh
./generate-lms-pdfs.sh 2026-27
```

## Contacts & Support

- Questions, schedule, and technical support: Use the course LMS (ILIAS), the authoritative communication channel.
- Main Instructor: Prof. Dr. Ulrich Norbisrath (Ulno) — [ulno.net](https://ulno.net/)
- Teaching Support: Fabian Tilman Schmid-Michels *(if available)*
- Community: [IoTempire](https://iotempire.net/)
