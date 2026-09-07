# Workshop Overview: Mastering IoT Solutions (2–3 h)

[← Back to Workbook (README.md)](./README.md) | [Instructor Guide →](./INSTRUCTOR-GUIDE.md)

This document describes the high-level structure, didactical concept, learning outcomes, and dual role of the **Mastering IoT Solutions** workshop.

---

## 1. Concept & Purpose

The **Mastering IoT Solutions** masterclass is a hardware-first, highly practical workshop designed to introduce participants to distributed IoT architectures, edge device management, and visual dataflow integration.

It serves a **dual purpose**:

### A. Day 1 Kick-Off in University Curricula
- **HSBI Gütersloh:** [MCU Programming (10-Day Extended Edition)](../../full-classes/hsbi-MCU-programming-10d/syllabus.md) – Day 1 / Module 1 introduction.
- **University of Tartu:** [Introduction to IoT (15-Day Edition)](../../full-classes/unitartu-IoT-intro-15d/syllabus.md) – Day 1 / Module 1 kick-off.
- In both semester courses, this masterclass provides immediate hands-on success on Day 1 without getting bogged down in toolchain installations. Students capture their first engineering evidence and write their **Module 1 Portfolio Work Report** based on this session.

### B. Standalone Masterclass & Outreach
- Functions as an inspiring, self-contained workshop (2–3 hours) for maker faires, summer schools, engineering meetups, or professional continuous education.
- Shows how modern edge frameworks ([IoTempower](https://iotempower.us)) and visual integration engines ([Node-RED](https://nodered.org)) make IoT accessible, rapid, and fun.

---

## 2. Didactical Approach & Flexible Cadence

### Hardware-First, Zero-Install
Participants do not spend their first hour installing drivers, cross-compilers, or IDEs. Instead:
- Microcontrollers (**M5StickC**) are pre-provisioned.
- Isolated **Node-RED** instances run as lightweight containers on the instructor's host (or local server).
- Participants only need a standard web browser on their laptop or tablet.

### Organic Flow (~90 Minutes Baseline + Open Exploration)
Rather than adhering to rigid, school-like bells and 45-minute cutoffs, the workshop follows an **organic arc**:
1. **Ignition & Quick Warm-Up (~10 min):** Short welcome, whoami, and rapid crowd-sourcing of IoT definitions and challenges.
2. **Live Sparks (~5 min):** Instructor demonstrates Node-RED Hello World on the beamer, sends a message to an instructor M5StickC (LED flips, screen greets), and hands out hardware to teams.
3. **Team Bring-Up & Ping-Pong (~25 min):** Teams log into their container, listen to button presses, toggle LEDs, and establish cross-table "domino" links.
4. **Physical Sensing & OTA Deploy (~25 min):** Teams wire a Dallas DS18B20 temperature sensor. The instructor triggers an Over-The-Air (OTA) deployment via IoTempower without touching USB cables. Live temperature streams appear!
5. **Dashboards & Aggregation (~25 min):** Teams assemble live gauges, historical line charts, and subscribe to class-wide room telemetry using MQTT wildcards (`+/temp`).
6. **Open-Ended Extensions & Spontaneous Breakouts:** For faster teams or longer (3h) sessions, participants branch into custom explorations (e.g. CO2 sensor integration, IMU tilt control, Telegram bot messaging, or diving into IoTempower's fluent syntax).

---

## 3. Learning Outcomes

By the end of this workshop, participants are able to:
- **Understand Event-Driven IoT Messaging:** Explain the publish/subscribe pattern, MQTT broker star topology, and hierarchical topic conventions (`<node>/<device>/<topic>`).
- **Integrate Systems with Node-RED:** Wire visual dataflow nodes, inspect payloads in real time, and map input events to physical actuators.
- **Connect Physical Digital Sensors:** Interface a 1-wire digital temperature sensor (Dallas DS18B20) to microcontroller GPIO headers.
- **Experience Declarative Edge Management:** Understand single-line hardware abstractions in IoTempower and witness fleet-wide Over-The-Air (OTA) firmware deployment.
- **Build Real-Time Dashboards:** Visualise streaming telemetry using gauges and charts, and aggregate multi-node classroom data.

---

## 4. Hardware & Equipment Inventory

| Item | Quantity | Purpose |
|---|---|---|
| **M5StickC / Plus / Plus2** | 1 per team (up to 15) | Pre-flashed ESP32 microcontroller with screen, buttons, LED, and IMU. |
| **USB-C Cables & Power** | 1 per team | Power supply from participant laptop or USB hub. |
| **Dallas DS18B20 Sensor Module** | 1 per team | 1-wire digital temperature sensor with 3 DuPont jumpers. |
| *(Optional)* **Sensirion SCD4x** | Optional | I2C sensor for CO2, temperature, and relative humidity. |
| **Wi-Fi Router (e.g. GL-iNet B1300)** | 1 for room | Local network (`iotempire-b1300`), isolates workshop traffic. |
| **Instructor Laptop** | 1 for room | Runs Mosquitto broker, Node-RED containers, and IoTempower CLI. |

---

## 5. Course Alignment & Portfolio Deliverables

In the HSBI and UniTartu courses, this session forms the foundation for subsequent modules (Hardware/Electronics, Gateways, Embedded C++, Integration).

Students document the hands-on outcomes in their individual GitHub portfolio under `Module-01/` or `Day-01/`:
- Photo of their wired M5StickC on the desk.
- Screenshot of their working Node-RED flows (Button/LED, Domino, and Dashboard).
- Screenshot of their live temperature dashboard.
- A concise reflection addressing what went smoothly, what caused friction, and lessons learned about distributed systems.
