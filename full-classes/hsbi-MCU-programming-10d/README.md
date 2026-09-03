# HSBI/GT Microcontroller Programming — 10-Day Extended Edition

## Contents

| Start here | What it contains |
|---|---|
| [Pre-study guide](./pre-study.md) | A practical first IoT build and essential preparation |
| [Syllabus](./syllabus.md) | Schedule, language guidance, assessment, and policies |
| [Module 1 — Introduction](./modules/01-introduction.md) | Course start and Node-RED master class |
| [Module 2 — Hardware & Electronics](./modules/02-hardware-and-basic-electronics.md) | Breadboards, GPIO, sensors, and actuators |
| [Module 3 — Infrastructure & Gateway](./modules/03-infrastructure-and-gateway-setup.md) | Local LAN, OpenWRT, and MQTT |
| [Module 4 — Embedded Programming](./modules/04-embedded-programming-and-deploying.md) | Firmware, debugging, and deployment |
| [Module 5 — Integration & Simulations](./modules/05-integration-and-simulations.md) | Node-RED integration and system mocks |
| [Module 6 — IoT Systems](./modules/06-iot-systems.md) | Scaling and IoTempower management |
| [Module 7 — Final Project](./modules/07-final-project.md) | Build, document, and demonstrate a system |
| [Module 8 — Extra & Archive](./modules/08-extra-and-archival-material.md) | Optional and historical material |

This README is the course workbook and front page for the HSBI/GT Microcontroller Programming course, delivered over **10 weeks** in roughly one four-hour session per week.

The course reuses the modules of the condensed HSBI/GT four-day workshop, paced more gradually with room to catch up, explore, and build a substantial final project.

> [!NOTE]
> This is a living document. Expect minor adaptations as the semester progresses; check weekly announcements for calendar details.

---

## Course Times & Location

| Setting | Details |
|---|---|
| **Time** | Tuesday, 10:15–13:45 |
| **Location** | Delta 1022 (IoT Lab / Mechatronics Workshop) |
| **Languages** | English and German; shared materials are in English |

For the complete language arrangement, teaching team, learning objectives, assessment rules, and policies, read the [syllabus](./syllabus.md).

---

## Course Plan

| Day | Module / focus | Points |
|---|---|---|
| 1 | [Module 1 — Introduction](./modules/01-introduction.md) + [Mastering IoT Solutions](../../workshops/mastering-iot-solutions/README.md) | 1 module pt + 1 reflection pt |
| 2 | [Module 2 — Hardware and Basic Electronics](./modules/02-hardware-and-basic-electronics.md) | 2 module pts |
| 3 | [Module 3 — Infrastructure and Gateway Setup](./modules/03-infrastructure-and-gateway-setup.md) | 2 module pts |
| 4 | [Module 4 — Embedded Programming and Deploying Nodes](./modules/04-embedded-programming-and-deploying.md) | 2 module pts |
| 5 | [Module 5 — Integration and Simulations](./modules/05-integration-and-simulations.md) | 2 module pts |
| 6 | [Module 6 — IoT Systems](./modules/06-iot-systems.md) | 2 module pts |
| 7–9 | [Module 7 — Final Project](./modules/07-final-project.md) | 5 project pts |
| 10 | Flexible final-project buffer | — |

Every session combines a short introduction, hands-on lab work, and portfolio documentation. Days 3 and 4 include stretcher time for catching up or bonus work; Day 10 is available when the group needs more project time.

---

## Portfolio & Hardware

Publish your work in a GitHub portfolio: source code, binaries, schematics, serial logs, dashboard screenshots, measurements, and reflections. Use the [portfolio template](https://github.com/iotempire/iot-portfolio-template) and its [reflection guidance](https://github.com/iotempire/iot-portfolio-template/blob/main/Reflections/README.md).

Document the Day 1 Master Class as a normal work report—pictures, process notes, peer collaboration, Node-RED/MQTT observations, and your M5StickC temperature-sensor wiring—not as a special reflection topic. The laboratory kit is issued at the course start; see [Module 2](./modules/02-hardware-and-basic-electronics.md) for the inventory and safety notes.

---

## Navigation & Resources

- [Module index](./modules/00-index.md) — compact navigation only
- [Master Class material](../../workshops/mastering-iot-solutions/README.md)
- [IoTempower](https://github.com/iotempire/iotempower) — local deployment and fleet-management framework
- [IoTempire](https://iotempire.net/) — organisation, teaching tools, and community

### How to work well

- Keep a clean repository with meaningful commits and linked issues or pull requests.
- Reflect after Day 1 and each final-project day using the portfolio template.
- Collaborate openly: pair-debug, review work, and share useful discoveries.
- Treat hardware and documentation with equal care. When something fails, record the symptoms, inspect the circuit, verify power and pins, and keep useful serial logs.

### Contacts & support

- **Technical issues:** Open an issue in your portfolio repository with relevant screenshots and serial logs.
- **Main Instructor:** Ulrich Norbisrath (**Ulno**) — [ulno.net](https://ulno.net/)
- **Teaching Support:** Fabian Tilman Schmid-Michels *(if available)*
- **Discord:** To be announced

---

## ⚠️ Review: material retained from the previous README

> [!WARNING]
> The following items appeared in the previous top-level README but not in the workbook that this page is based on. They are retained for an instructor to review, reconcile with the [syllabus](./syllabus.md), and either promote, revise, or remove.

### Course goal and toolchain

The previous page foregrounded the goal of building real embedded systems—from LEDs to MQTT-connected sensor networks—and explicitly named ESP32/ESP8266 and M5StickC boards, Arduino IDE/PlatformIO, MQTT, Node-RED, IoTempower, Git/GitHub, and Markdown engineering logbooks. Review whether this compact overview should return as a student-facing section or remain covered by the syllabus and individual modules.

### Assessment, final project, and licensing

The previous page stated an 11/4/5 point split, a minimum final-project score of 2/5, and a final-project checklist covering a user story, architecture and failure modes, tested hardware, firmware, MQTT-to-gateway-to-Node-RED integration, documentation, and a live demo. These requirements should stay aligned with the authoritative [syllabus assessment section](./syllabus.md#grading-breakdown). It also contained conflicting license language (MIT/CC-BY-SA in one place, MIT by default in another); decide and document the intended code/documentation licensing policy.

### Operational details

Review whether to retain the prior portfolio setup commands and any promise of TA huddles or Discord support. The old page said that kits arrived on Day 2, while the workbook said they were issued at course start; this README follows the workbook pending confirmation. If firmware deployment credentials are discussed, never commit secrets or tokens to student portfolios.
