# Syllabus: Internet of Things Introduction

> **Warning:** This syllabus is a living document and will evolve throughout the semester. Expect minor updates based on class progress and feedback.


---

## Class Times and Locations

- **Day:** TBA
- **Location:** TBA
- **Time:** TBA
- **Language of Instruction:** English

---

## Instructors (TBD for local instance)


| **Role**       | **Name (example)**         | **Contact**                             | **Discord**       | **GitHub**          |
|----------------|---------------------------|------------------------------------------|-------------------|---------------------
| Lead Instructor| <Instructor 1>           | <email or contact link>                  | <discord handle>   | <github handle>      |
| Instructor     | <Instructor 2>           | <email or contact link>                  | <discord handle>   | <github handle>      |

**Course Discord Invite:**
Add your course Discord invite once available.

---

## Course Load

- **Contact Hours (60):** 15 × 2h (lecture/lab) per student (6 ECTS) = total of ~156 hours of student effort (~1.5h outside of class per hour in class).
- **ECTS Credits:** 6

- **Assessment Breakdown:**
  - **Module Points:** 11 (±1 per week) — tasks, participation, and progress
  - **Reflections Log:** 4 points (0.25 per week, rounded up) 
  - **Final Project:** 5 points (mandatory; min 2/5 required)
  - **Extra Points:** Up to 3 — exemplary contributions, help, or extra projects
- **Minimum Passing Grade:** 14/20 points (~70%)

---

## Description

### What is the Internet of Things (IoT)?

The **Internet of Things (IoT)** is redefining how the physical and digital worlds connect—turning everyday objects like lights, refrigerators, pacemakers, dogs, and even cows into smart, networked devices. By 2030, we’ll have **over 29 billion IoT devices** streaming data in real time, each broadcasting insights, warnings, and intelligence that can reshape industries, save energy, improve health, or transform classrooms.

In this hands-on course, you won’t just study IoT—you’ll **build it**. You’ll assemble sensors and devices, connect them using secure networks, and make them work together in meaningful systems. From measuring room temperature, detecting motion, and triggering LED alerts to creating dashboards that show real-time data, you’ll learn to collect, visualize, and act on the physical world. You’ll tame complexity, debug systems, and harness automation—skills that power smart homes, automated greenhouses, and emergency-response networks worldwide.

By the end, you’ll be able to **tame the physical world with code and electronics**—turning coffee makers into learning tools, clinics into data-driven teams, and waste bins into intelligent services.


### How You Will Learn

In this course, **you won’t just watch demos—you’ll lift the hood, break things on purpose, and put them back together stronger.** Classes blend mini-lectures, hands-on labs, and team challenges. You’ll debug real-time sensor failures, orchestrate MQTT messages across networks, design dashboards that turn data into clarity, and complete a real IoT deployment every two weeks.

Each project is a **live demo**: sensors arriving in your lab kit, Node-RED flows that flip LEDs, and systems that respond to emergencies. Every week, you’ll leave with working hardware in your hands and a new hacking story.

Finally, you’ll **demo your capstone**: a live five-node IoT system, complete with documentation, dashboards, and a public showcase ready for your portfolio.

---

## Learning Objectives

After completing this course, you will be able to:

- **Define and de-risk IoT**: Critically analyze what the Internet of Things is, its industrial and societal potential, and its pitfalls (privacy, power, latency). 
- **Embed and interact**: Attach sensors and actuators to microcontrollers and write embedded logic to read, compute, and act on the real world.
- **Network and orchestrate**: Set up wired/wireless networks (LAN, Wi-Fi, MQTT), connect nodes, and build Node-RED dashboards to visualize and control your system.
- **Design iterative systems**: Prototype, test, debug, and refine IoT systems using Arduino/PlatformIO, IoTempower, and collaborative workflows.
- **Reflect and present**: Document your work in a GitHub portfolio and defend designs in live presentations and reports.

---

## Prerequisites and Tools

This course assumes **basic technical curiosity**—no advanced prior knowledge is required. Helpful starting points include: Git/GitHub, Linux basics (CLI navigation), Python/JavaScript basics, C++ basics, network protocols (MQTT/http), and user stories/scenarios.

All tools and languages are taught or scaffolded in class using guided labs and template repositories.

---

## Projects and Assessment

### Module Projects

Through the semester, you’ll complete short labs and module projects that build toward a final deliverable. Expect teamwork, logs, and reflections.

- **Weeks 1–3:** Build foundational circuits, prototype nodes, and set up networks (≈4–5 module points).
- **Weeks 4–10:** Integrate sensors and actors with orchestration via Node-RED, build dashboards, and debug MQTT flows (≈6 module points).
- **Weeks 11–16:** Final project design-to-delivery sprint, culminating in a public demo (≈5 project pts).

Your **GitHub portfolio** is the primary artifact for grading. It documents code, data, photos, diagrams, bugs, and reflections, and grows into a portfolio-ready artifact.

### Final Project & Portfolio (50% of final grade)
- **Objective**: Propose, plan, prototype, deliver, and demo a **real IoT system** (e.g., smart greenhouse, climate dashboard, competitive multi-player access control, emergency alert station).
- **Rules**: Use at least 3 microcontrollers, MQTT, Node-RED or IoTempower, sensors/actors, public repo + presentation.
- **Assessment**: system functionality (2), documentation + diagrams (1), robustness + ethical sensitivity (1), presentation (1). Minimum 2/5 required to pass.
- **Showcase**: Present live demos in final two weeks; record videos for assessment clarity.

---

## Evaluation Criteria and Grading Scale

Grades are based on:
- **Module Points (11 pts):** Timely contributions to team labs, hardware logs, and reflections.
- **Reflections Log (4 pts):** Weekly summaries in your GitHub portfolio; quantitative grading.
- **Final Project (5 pts):** Mandatory; min 2/5.
- **Extra Points (up to 3):** Unusual contributions, help, or complementary projects.

**Grading Scale:**
- 0–13 pts: Fail
- 14–20 pts: Pass (19–20 = A equivalence for Erasmus students)
---

## Course Materials and Resources

deployed using this workbook:

- **Primary Workbook**: [./README.rst](README.rst) and modular per-week files under [./modules/](./modules)
- **Portfolio Template & Starter**: [https://github.com/iotempower/iotempower-portfolio-template](https://github.com/iotempower/iotempower-portfolio-template)
- **IoTempower Framework**: [https://github.com/iotempower/iotempower](https://github.com/iotempower/iotempower)
- **MQTT & Node-RED Guides**: See modules 3–5
- **Hardware Kits**: Provided at course start—see [Module 2 – Hardware and Basic Electronics](./modules/02-hardware-and-basic-electronics.md)

All project code, logs, and reflections must be published to your GitHub portfolio under permissive and open licenses (MIT, CC-BY-SA) to enable learning and reuse.

---

## Module Overview

| Week | Module | Core Activities                                                         |
|------|---------|-----------------------------------------------------------------------|
| 1–3  | Module 1–2 | Course intro, Git, embedded boards, sensors, breadboards, electronics |
| 4–6  | Module 3 | Build an ad-hoc **local network**, set up an MQTT broker, first integration |
| 7–9  | Module 4 | ESP32/ESP8266 — **debug crashes, OTA flash**, bridge MQTT‑to‑serial systems |
| 10–12| Module 5 | Advanced **Node‑RED integrations**: HVAC control, access systems, dashboards |
| 13–15| Module 6 | **Scale systems**: IoTempower deployments, monitoring, multi‑node orchestration |
| 16   | Module 7 | Final **project showcase & presentations**                               |

Each module pairs mini-lecture, lab, guided setup, and reflective writing, building toward your capstone.

---

## Expectations and Policies

- **Punctuality:** Doors close at 10:20; late arrivals may miss critical setup steps.
- **Presence:** Active participation required. Unexcused absences can affect module points.
- **Collaboration:** Pair/group expected. Document roles in logs.
- **Conduct & Ethics:** Treat tools, peers, and data with respect; build ethically and with stakeholders in mind.
- **Open by Default:** Publish portfolio and project artifacts under permissive licenses to enable reuse and learning.

---

## How to Succeed

1. **Keep a clean repo.** Use clear branches and descriptive PRs; link commits to issues.
2. **Reflect weekly.** Summarize sessions in your GitHub portfolio: successes, failures, next steps.
3. **Fail forward.** Early crashes are expected; log bugs, poke teammates, and schedule 1:1s when stuck.
4. **Portfolio first.** Reflections = 25% of grade; treat hardware as seriously as your write-up.
5. **Be generous.** Review teammates’ drafts, co-present honestly, and share your pain points.
6. **Finish strong.** Plan final two weeks for polish, rehearsal, and video recording.

---

## Course Flow & Cadence

| Week | Flow Goal                                      | Card Deliverable             |
|------|------------------------------------------------|------------------------------|
| 1–2  | Course intro, Git basics, simple circuits       | First hardware photo + journal|
| 3–5  | LAN, Wi‑Fi, MQTT broker                       | Working network + broker logs |
| 6–7  | ESP32 bring-up, OTA flashing                  | First OTA deploy             |
| 8–12 | Node-RED integrations (HVAC & Access Control)   | Dashboards + actuators       |
| 13–15| Multi-node orchestration & monitoring           | IoTempower system + metrics   |
| 16   | Final demos                                  | Public showcase              |

Actual dates will shift; stay on top of commits and communication.

---

## Contacts & Questions

- **Technical issues:** GitHub issues in repo (issue tracker)
- **Course feedback:** Mid- and end-of-semester forms
- **Academic integrity:** Cite sources; talk to instructors
- **Local course contact:** <replace>
- **Discord server:** <replace>

---

> ###### 
Document version: 2.0 (UT edition)  
Last updated: August 2026  
Seeded from Syllabus IoT Intro UT 2026 → converted to modular workbook for TA‑friendly reuse
