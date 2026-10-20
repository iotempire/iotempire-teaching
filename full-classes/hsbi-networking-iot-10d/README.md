# HSBI/GT Networking and IoT Solutions — 10-Day Edition

> **Build networks that survive the real world.** Move beyond the rigid seven-layer diagram: route at the edge, cross NAT without port forwarding, decouple with pub/sub, and prove resilience by breaking your own system.

This is the course workbook and front page for **Networking and IoT Solutions (Vernetzung und IoT-Lösungen)** at Hochschule Bielefeld University of Applied Sciences and Arts (HSBI), Campus Gütersloh. It is a hands-on, laboratory-driven course about the networking and integration layer of modern IoT: edge routers, overlays, messaging, wireless links, industrial bridges, and fleet operations.

The course runs over **10 working days / 12 sessions (4 hours each, 48 contact hours)**. The official timetable, rooms, and announcements are published through the course LMS.

- **[Module index & roadmap](./modules/00-index.md)** — the course at a glance: every module and the day-by-day plan.
- **[Syllabus](./syllabus.md)** — the single source of truth: schedule, learning objectives, the learning-goals contract, tools, and policies.
- **[Pre-study guide](./pre-study.md)** — Module 0: start here before Day 1.
- **[Prompt bank](./modules/Y-resources-prompt-bank.md)** — reflection prompts and LLM-verification drills.
- **[Resource bank](./modules/Z-resources-bank.md)** — cheat sheets, RFCs, Git/GitHub primer, story canon, troubleshooting, and instructor hints.

## Why this course looks different

Classical networking courses often begin with the seven-layer ISO/OSI model and abstract header arithmetic. The OSI model is a useful dictionary, but real IoT systems are engineered bottom-up: a device has to associate, get an address, cross a NAT, reach a broker, and keep working when a link dies.

In this course you will:

- **Work at the edge.** Configure OpenWrt routers, subnet a local network, run DHCP/DNS/NAT, and capture packets at the choke point with `tcpdump` and Wireshark.
- **Extend the network without asking for a public IP.** Deploy Nebula and Yggdrasil overlays that cross CGNAT, campus firewalls, and changing WAN addresses.
- **Decouple producers from consumers.** Design MQTT topic hierarchies with QoS, retained state, and Last Will and Testament, then integrate with Node-RED and Python.
- **Choose the right radio.** Compare Wi-Fi, BLE, LoRaWAN, and connectionless ESP-NOW by range, latency, power, and payload — and build an ESP-NOW-to-MQTT bridge.
- **Bridge the factory floor.** Understand Modbus, OPC-UA, RS-485, and deterministic networking, and build a simulated industrial-to-IoT bridge.
- **Manage a fleet.** Provision, configure, and update nodes over the air with IoTempower.
- **Prove resilience.** Inject link drops, node failures, and broker restarts — and show graceful recovery.

> [!IMPORTANT]
> **Local-first, buildable, measured.** The core runs on your own OpenWrt router and a local Mosquitto broker. The internet is a link to test, not a dependency you assume. Every resilience claim is demonstrated by breaking something on purpose.

## How we teach — challenge- and project-based, in person, and always in flux

This course is taught as Challenge-Based and Project-Based Learning (CBL/PBL): you learn by investigating an authentic challenge and building a real solution, not by reproducing a lecture. We begin from stories — a real problem that matters to a person — because you learn best what connects to something meaningful for your own life, studies, or community.

It also matters that we do this in person, together. A university class is at its best where we actually meet, and you will learn a great deal from direct interaction with your peers: explaining, questioning, debugging, and demoing to one another, while the instructor learns alongside you.

And this class is always in flux — that is a feature, not a bug. No course is ever finished: every offering is adjusted while it runs, and each class teaches us as much as it teaches you.

> [!NOTE]
> **How the modules work.** Each module opens with its **learning goals** and a ***DRAFT BOUNDARY***; the tasks are negotiable as long as the goals are met. The [syllabus](./syllabus.md) is the single source of truth for the learning-goals contract and the “draft in motion” model.

## How the course is organized

- **10 working days / 12 four-hour sessions (48 contact hours)**, plus optional tutorial support announced via the LMS.
- **Module 0 (pre-study):** portfolio setup, a network mental model, packet-journey videos, and a first MQTT exploration — completed before Day 1 (or run as the first in-class module when the cohort needs more setup time).
- **Modules 1–7:** one technical studio per day — the IoT continuum, local networking and OpenWrt, overlays and mesh, MQTT and integration, wireless and ESP-NOW, industrial protocols, and fleet management.
- **Modules 8–9:** the final-project arc — a multi-node, multi-protocol IoT system built and documented in a merged **Project Team** of 4–6 (two Task Pods), then demonstrated and defended in the last session.

The full module list, one-line summaries, and the session roadmap live in the **[module index](./modules/00-index.md)**.

## Get started

> **Module 0 (pre-study) is required.** Create your portfolio from the template, add the instructor as a collaborator, and complete the pre-study tasks before Day 1.

1. Create your personal portfolio from the [IoTempire portfolio template](https://github.com/iotempire/iot-portfolio-template) with **“Use this template”** (not “Fork”), then add the instructor as a collaborator.
2. Complete the **[pre-study guide](./pre-study.md)** (Module 0) before Day 1.
3. Read the **[module index](./modules/00-index.md)**, then start with **[Module 1 — Foundations & Master Class](./modules/01-foundations-and-masterclass.md)**.
4. Keep the **[syllabus](./syllabus.md)** handy for the schedule, the learning-goals contract, and policies.

The [Git & GitHub primer](./modules/Z-resources-bank.md#git--github-primer-template-editor-markdown-conflicts) in the resource bank walks you through the template workflow, your editor, Markdown, and merge conflicts.

## What you will work with

- **Hardware:** one OpenWrt travel router per two students (Cudy TR1200 with pure upstream OpenWrt; GL.iNet Mango/Shadow as partners), M5Stack nodes with Grove modules, Ethernet and USB cables, lab switches/access points.
- **Networking:** OpenWrt + LuCI, `tcpdump`, Wireshark, `iperf3`, Nebula, Yggdrasil, optional B.A.T.M.A.N. advanced.
- **Messaging and integration:** Mosquitto, MQTT Explorer, Node-RED, Python with `paho-mqtt` / IoTknit, optional `pymodbus` / `asyncua`.
- **Fleet:** [IoTempower](https://github.com/iotempire/iotempower) for declarative nodes and OTA deployment.
- **Editor and terminal:** VS Code or Zed with the **integrated terminal**; on Windows, set the terminal profile to **Git Bash** (ships with Git for Windows) because the labs use bash.
- **AI co-pilots:** use them to draft and explain — then verify against a packet capture, a routing table, or a live test. Verification is the graded skill. The hands-on experiment comes first: build the network, observe the failure, then ask AI.

## For instructors

The workbook is meant to be reused and adapted. It relies on open hardware and open-source software; the labs run on an isolated local network; and each module keeps its learning goals separate from the (draft) tasks, so you can swap exercises without breaking the course. Fork it, translate it, and change the stories to your own context — and please keep the attribution to IoTempower and Ulrich Norbisrath. Feedback and pull requests are welcome.

Instructor hints — running the checkpoints, router sourcing, hardware-setup tips, and the story canon — live in the [resource bank](./modules/Z-resources-bank.md#instructor-hints). If you present from slides, keep them plain Markdown (slides separated by `---`) and render a 16:9 PDF with **pandoc + Typst**; there is no notebook runtime and no build step.

> [!NOTE]
> **Instructor note (router sourcing).** Deploy only routers running pure upstream OpenWrt. Avoid vendor forks such as the GL-SFT1200 ("Opal") — an outdated, proprietary 2018 fork with closed drivers that blocks bridging, access-point mode, and modern mesh packages. *Why* upstream OpenWrt beats a pseudo-OpenWrt vendor fork is a good real-world case study in edge-infrastructure selection.

## Navigation & resources

- [Module index & roadmap](./modules/00-index.md)
- [Syllabus](./syllabus.md)
- [Pre-study guide](./pre-study.md)
- [Reflection prompts & LLM-verification drills](./modules/Y-resources-prompt-bank.md)
- [Cheat sheets, RFCs, Git primer, story canon & troubleshooting](./modules/Z-resources-bank.md)
- [IoTempower](https://github.com/iotempire/iotempower) — declarative fleet management framework ([iotempower.us](https://iotempower.us))
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
