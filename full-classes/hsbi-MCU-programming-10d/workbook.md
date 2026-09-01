# HSBI/GT Lab Tutorials 2026 – 10-Day Extended Edition

This workbook is the **front page** for the HSBI/GT Microcontroller Programming workshop, delivered over **10 weeks (roughly one 4h session per week)**.

The course reuses the **same modules** as the condensed HSBI/GT 4-day blocked workshop, but paces them like the **University of Tartu IoT Introduction** course: roughly **one module per day**, with more room to breathe, and built-in flexibility for groups that need more or less time.

> [!NOTE]
> This is a living document. Expect minor adaptations and updates as the semester progresses. The exact calendar dates are TBD — check weekly announcements.

---

## Course Times & Locations
| Setting                        | Details                                  |
|-------------------------------|-------------------------------------------|
| **Time:**                     | Tuesday 10:15–13:45                     |
| **Location:**                 | Delta 1022 (IoT Lab / Mechatronics)     |
| **Language:**                 | English (lectures, docs, repos)           |

---

## Syllabus & Grading
- [Course Syllabus: syllabus.md](./syllabus.md) – day-by-day topics, grading breakdown, and learning objectives

---

## Day-by-Day Plan

| Day  | Module / Focus                                                                 | Points |
|------|----------------------------------------------------------------------------------|--------|
| 1    | [Module 1 – Introduction](./modules/01-introduction.md) + **Master Class** (M5StickC + Node-RED, see [mastering-iot-solutions](../../workshops/mastering-iot-solutions/README.md)) | 1 module pt + 1 reflection pt |
| 2    | [Module 2 – Hardware and Basic Electronics](./modules/02-hardware-and-basic-electronics.md) | 2 module pts |
| 3    | [Module 3 – Infrastructure and Gateway Setup](./modules/03-infrastructure-and-gateway-setup.md) *(+ stretcher time if needed)* | 2 module pts |
| 4    | [Module 4 – Embedded Programming and Deploying Nodes](./modules/04-embedded-programming-and-deploying.md) *(+ stretcher time if needed, else bonus)* | 2 module pts |
| 5    | [Module 5 – Integration and Simulations](./modules/05-integration-and-simulations.md) | 2 module pts |
| 6    | [Module 6 – IoT Systems](./modules/06-iot-systems.md) | 2 module pts |
| 7–9  | [Module 7 – Final Project](./modules/07-final-project.md): ideation → prototyping → build → live demo | 5 project pts |
| 10   | *Flexible buffer* — extra final-project time if the group needs it | — |

Each teaching day includes mini-lecture, hands-on lab, and portfolio documentation. **Days 3 and 4** carry a bit of slack for stretcher tasks — used to finish the module if needed, or as bonus work if the group is ahead. **Day 10** is kept open as a flexible buffer, mainly for final-project work.

---

## Workbook Index – Modules

1. [Module 1 – Introduction](./modules/01-introduction.md) — course structure, expectations, Master Class (M5StickC + Node-RED)
2. [Module 2 – Hardware and Basic Electronics](./modules/02-hardware-and-basic-electronics.md) — breadboards, LEDs, resistors, sensors
3. [Module 3 – Infrastructure and Gateway Setup](./modules/03-infrastructure-and-gateway-setup.md) — LAN, Wi-Fi, MQTT brokers, Node-RED
4. [Module 4 – Embedded Programming and Deploying Nodes](./modules/04-embedded-programming-and-deploying.md) — Arduino/PlatformIO, debugging, watchdogs, OTA
5. [Module 5 – Integration and Simulations](./modules/05-integration-and-simulations.md) — HVAC demos, access systems, and Node-RED
6. [Module 6 – IoT Systems](./modules/06-iot-systems.md) — scaling systems, IoTempower fleet management
7. [Module 7 – Final Project](./modules/07-final-project.md) — project proposal, architecture, build, test, and demo guide
8. [Module 8 – Extra and Archival Material](./modules/08-extra-and-archival-material.md) *(bonus / optional)* — archived labs, deep dives, and historical notes

---

## Portfolio & Grading Artifacts
All deliverables are published in your **GitHub portfolio**:
- Hardware logs & schematics
- Source code & binaries
- Screenshots: serial console, dashboards, logic analyzer traces
- Measured performance (energy, timing, memory usage) as graphs
- Reflections: the same standard reflection format (see [reflection guidance in the portfolio template](https://github.com/iotempire/iot-portfolio-template/blob/main/Reflections/README.md)) after Day 1 and after each final-project day (Days 7–9) — 4 points total
- Day 1's Master Class is **not** a special reflection topic — it gets a normal portfolio work report like any other day: pictures, notes on how the Node-RED/MQTT exercise and the peer collaboration went, and how wiring the temperature sensor to the M5StickC (your first hands-on electronics) worked out

---

## Hardware Kit
Issued at course start. See **Module 2 – Hardware & Electronics** for inventory and safety notes.

---

## Additional Navigation
- Quick module index: [modules/00-index.md](./modules/00-index.md)
- Portfolio template: [https://github.com/iotempire/iot-portfolio-template](https://github.com/iotempire/iot-portfolio-template)
- IoTempower framework: [https://github.com/iotempire/iotempower](https://github.com/iotempire/iotempower) (vanity URL [https://iotempower.us](https://iotempower.us))
- IoTempire organization (behind all our IoT teaching, tools, and community efforts): [https://iotempire.net/](https://iotempire.net/)
- Master Class material: [workshops/mastering-iot-solutions](../../workshops/mastering-iot-solutions/README.md)

---

## How to Succeed
- ✔️ Keep a clean repo with clear git history and linked issues/PRs
- ✔️ Reflect after Day 1 and each final-project day, always in the same format — see the [reflection guidance in the portfolio template](https://github.com/iotempire/iot-portfolio-template/blob/main/Reflections/README.md)
- ✔️ Document the Day 1 Master Class like any other day's work (pictures, notes, peer collaboration) — it is a portfolio report, not a special reflection
- ✔️ Collaborate openly; review teammates' PRs and join pair-debugs
- ✔️ Use stretcher time on Days 3–4 wisely, whichever way you need it
- ✔️ Treat hardware and docs equally (both are graded)

---

## Contacts & Support
- **Technical issues:** GitHub issues in your portfolio repo
- **Course feedback:** Mid- and end-semester forms
- **Academic integrity:** Cite sources; clarify early if in doubt
- **Local Instructors:** [to be filled]
- **Discord:** [to be filled]

---

> ###### 
Document version: 3.0 (HSBI Campus Gütersloh 10-Day Edition)  
Last Updated: August 2026  
Adapted from the HSBI/GT 4-day blocked workshop, paced like the University of Tartu IoT Introduction modular workbook.
