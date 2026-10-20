# HSBI/GT Sensors and Actuators (Sensorik und Aktorik) — 10-Day Edition

> **Make the physical world legible.** Turn a real quantity into a trustworthy number, and turn that number into light, motion, or heat — with measurements you can defend.

This is the course workbook and front page for **Sensors and Actuators (Sensorik und Aktorik)** at Hochschule Bielefeld University of Applied Sciences and Arts (HSBI), Campus Gütersloh. It is a hands-on, studio-style elective for engineering students who want to understand the *physical* side of IoT: what a sensor really measures, how a bus really works, how an actuator really moves, and how to prove it with a measurement instead of a slide.

The course runs over **10 working days / 12 sessions (4 hours each, 48 contact hours)**. The official timetable, rooms, and announcements are published through the course LMS.

- **[Module index & roadmap](./modules/00-index.md)** — the course at a glance: every module and the day-by-day plan.
- **[Syllabus](./syllabus.md)** — the single source of truth: schedule, learning objectives, the learning-goals contract, tools, and policies.
- **[Pre-study guide](./pre-study.md)** — Module 0: start here before Day 1.
- **[Prompt bank](./modules/Y-resources-prompt-bank.md)** — reflection prompts and LLM-verification drills.
- **[Resource bank](./modules/Z-resources-bank.md)** — cheat sheets, datasheets, Git/GitHub primer, story canon, troubleshooting, and instructor hints.

## Why this course looks different

A sensor is not a number, and an actuator is not a pin that goes high. Most courses teach a catalogue of principles and then let you copy a library example. This course flips that:

- **You go to the bus before the device.** You wire and scan I²C, read registers, and resolve address conflicts before you trust a library.
- **You characterize what you measure.** You determine real transfer functions, linearity, hysteresis, resolution, and uncertainty, then calibrate and filter.
- **You build real systems.** Distance, motion, environment, Hall/current, LEDs and animation, servos, DC motors, and steppers — each with its driver, current draw, and safety rules.
- **You connect the node to a system.** Your sensor/actuator node becomes part of a local-first IoTempower + MQTT + Node-RED system with a closed control loop.
- **You prove claims with evidence.** A number without units, conditions, and uncertainty is not a measurement. A demonstration without a characterization is not engineering.

> [!IMPORTANT]
> **Local-first, buildable, documented.** The course is designed around hardware you actually have: M5Stack nodes with Grove modules for the fast path, and raw ESP32/ESP8266 plus breadboard parts when physics matters. Cloud services are optional; everything core runs on the local network.

## How we teach — challenge- and project-based, in person, and always in flux

This course is taught as Challenge-Based and Project-Based Learning (CBL/PBL): you learn by investigating an authentic challenge and building a real solution, not by reproducing a lecture. We begin from stories — a real problem that matters to a person — because you learn best what connects to something meaningful for your own life, studies, or community.

It also matters that we do this in person, together. A university class is at its best where we actually meet, and you will learn a great deal from direct interaction with your peers: explaining, questioning, debugging, and demoing to one another, while the instructor learns alongside you.

And this class is always in flux — that is a feature, not a bug. No course is ever finished: every offering is adjusted while it runs, and each class teaches us as much as it teaches you.

> [!NOTE]
> **How the modules work.** Each module opens with its **learning goals** and a ***DRAFT BOUNDARY***; the tasks are negotiable as long as the goals are met. The [syllabus](./syllabus.md) is the single source of truth for the learning-goals contract and the “draft in motion” model.

## How the course is organized

- **10 working days / 12 four-hour sessions (48 contact hours)**, plus optional tutorial support announced via the LMS.
- **Module 0 (pre-study):** portfolio setup, measurement basics, datasheet reading, and a Wokwi mini-exercise — completed before Day 1 (or run as the first in-class module when the cohort needs more setup time).
- **Modules 1–8:** one technical studio per day — measurement and the signal chain, I²C and addressing, characterization and calibration, distance/motion/environment sensors, LEDs and light, animation and installations, motors, and system integration.
- **Modules 9–10:** the final-project arc — a story-driven sensor/actuator system built and documented in a merged **Project Team** of 4–6 (two Task Pods), then demonstrated and defended in the last session.

The full module list, one-line summaries, and the session roadmap live in the **[module index](./modules/00-index.md)**.

## Get started

> **Module 0 (pre-study) is required.** Create your portfolio from the template, add the instructor as a collaborator, and complete the pre-study tasks before Day 1.

1. Create your personal portfolio from the [IoTempire portfolio template](https://github.com/iotempire/iot-portfolio-template) with **“Use this template”** (not “Fork”), then add the instructor as a collaborator.
2. Complete the **[pre-study guide](./pre-study.md)** (Module 0) before Day 1.
3. Read the **[module index](./modules/00-index.md)**, then start with **[Module 1 — Foundations](./modules/01-foundations-measurement-and-sensor-chain.md)**.
4. Keep the **[syllabus](./syllabus.md)** handy for the schedule, the learning-goals contract, and policies.

The [Git & GitHub primer](./modules/Z-resources-bank.md#git--github-primer-template-editor-markdown-conflicts) in the resource bank walks you through the template workflow, your editor, Markdown, and merge conflicts.

## What you will work with

- **Hardware:** M5Stack nodes and Grove modules (fast path); ESP32/ESP8266 boards, breadboards, and discrete sensors/actuators (physics path); multimeter, USB power meter, optional logic analyzer.
- **Firmware:** Arduino IDE v2 or PlatformIO with the ESP32/ESP8266 cores; FastLED for addressable LEDs.
- **System layer:** [IoTempower](https://github.com/iotempire/iotempower) for declarative drivers, filters, and OTA deployment; Mosquitto MQTT; Node-RED dashboards.
- **Optional Python glue:** a pinned `uv` environment for `paho-mqtt` and integration scripts where useful.
- **Editor and terminal:** VS Code or Zed with the **integrated terminal**; on Windows, set the terminal profile to **Git Bash** (ships with Git for Windows) because the labs use bash.
- **AI co-pilots:** use them to draft and explain — then verify against the datasheet, the multimeter, and your own measurements. Verification is the graded skill. The hands-on experiment comes first: touch the hardware, form a hypothesis, then ask AI — and respect voltage, current, and polarity limits.

## For instructors

The workbook is meant to be reused and adapted. It relies on open hardware and open-source software; the labs are self-contained and run on a local network; and each module keeps its learning goals separate from the (draft) tasks, so you can swap exercises without breaking the course. Fork it, translate it, and change the stories to your own context — and please keep the attribution to IoTempower and Ulrich Norbisrath. Feedback and pull requests are welcome.

Instructor hints — running the checkpoints, presenting from the workbook, hardware-kit tips, and the story canon — live in the [resource bank](./modules/Z-resources-bank.md#instructor-hints). If you present from slides, keep them plain Markdown (slides separated by `---`) and render a 16:9 PDF with **pandoc + Typst**; there is no notebook runtime and no build step.

## Navigation & resources

- [Module index & roadmap](./modules/00-index.md)
- [Syllabus](./syllabus.md)
- [Pre-study guide](./pre-study.md)
- [Reflection prompts & LLM-verification drills](./modules/Y-resources-prompt-bank.md)
- [Cheat sheets, datasheets, Git primer, story canon & troubleshooting](./modules/Z-resources-bank.md)
- [IoTempower](https://github.com/iotempire/iotempower) — declarative sensor/actuator framework ([iotempower.us](https://iotempower.us))
- [IoTempire](https://iotempire.net/) — organization, teaching tools, and community

### LMS PDF exports

Generate dated, upload-ready PDFs from the syllabus and pre-study guide using LibreOffice (default), Chromium, or LaTeX:

```sh
./generate-lms-pdfs.sh 2026-27
```

## Contacts & support

- Questions, schedule, and technical support: use the course LMS, the authoritative communication channel.
- Main instructor: Prof. Dr. Ulrich Norbisrath (Ulno) — [ulno.net](https://ulno.net/)
- Teaching support: Fabian Tilman Schmid-Michels *(if available)*
- Community: [IoTempire](https://iotempire.net/)
