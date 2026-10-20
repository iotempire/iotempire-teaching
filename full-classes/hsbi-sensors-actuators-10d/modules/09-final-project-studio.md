# Module 9 – Final Project Studio: From Story to Characterized System

[← Back to Module 8](./08-sensor-to-system-and-integration.md) | [Quick module index](./00-index.md) | [Next: Module 10 →](./10-demonstration-and-defense.md)

**Course placement:** Days 9–10 (Sessions 9–11) — the final project studio: ideation, requirement mapping, building, characterization, hardening, and rehearsal. The exact split depends on the timetable and group progress; the schedule deliberately reserves buffer time here so slower labs do not eat into the project.

## 🎯 Learning Goals

This module gives you the opportunity to explore sensor/actuator system engineering and achieve competency in requirement mapping, sensor characterization and evaluation, and resilience testing.

By the end of this module, you can:
1. Turn a stakeholder story into a concrete sensor/actuator architecture with explicit requirements.
2. Build and integrate a working sensor/actuator system on the local-first stack.
3. Characterize and evaluate the system: transfer function, resolution/uncertainty, actuator performance, and at least one system metric.
4. Perform fault injection and show that the system degrades gracefully.
5. Conduct a structured peer review and dry run of your demonstration.


**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 📖 Story — The Project Fair

The last three days are a small project fair. Three stakeholders bring three real problems into the room:

- **Aylin Demir**, curator at the Stadtmuseum, wants an interactive exhibit that reacts to visitors without a visible computer.
- **Dr. Elif Kaya**, agronomist at Klimapark, wants a frost alarm and a vent/heater loop that keeps working when the network does not.
- **Hendrik Brinkmann**, workshop lead at Brinkmann Maschinenbau, wants a part counter and a safe gate actuator for a test rig.

Your **Project Team** — two Task Pods merged into 4–6 people — picks one story (or brings a stakeholder of your own), turns it into requirements, and builds a characterized sensor/actuator system. The story is the spine; the must-haves and the learning goals are the contract. By the end of the studio you have a working system, a measurement file, a short report, and a demo you can defend.

## 📖 Studio Briefing: From Story to System

Before you build, spend a short pod-study block on the project craft:

### Pointers (start here, then keep looking)

- Story-driven modeling — [Wikipedia: Story-driven modeling](https://en.wikipedia.org/wiki/Story-driven_modeling)
- Requirements and acceptance criteria — [Wikipedia: Requirement](https://en.wikipedia.org/wiki/Requirement), [Acceptance testing](https://en.wikipedia.org/wiki/Acceptance_testing)
- System architecture — [Wikipedia: Systems architecture](https://en.wikipedia.org/wiki/Systems_architecture)
- Reliability and fault injection — [Wikipedia: Fault injection](https://en.wikipedia.org/wiki/Fault_injection)
- The [story canon](./Z-resources-bank.md#story-canon-the-recurring-cast) and the [final-project must-haves](../syllabus.md#final-project-requirements-5-points)

### Questions to ask an LLM (then verify against your kit)

- "Here is our stakeholder story: `<paste it>`. Turn it into a requirements list with measurable acceptance criteria, and flag anything we cannot build with an ESP32 and the sensors in our kit."
- "What is the smallest architecture that satisfies these requirements? Draw the data flow from sensor to actuator and name every failure point."
- "Which characterization experiment would prove that our headline sensor is good enough for this story?"
- "List five fault-injection tests for this architecture and the graceful behavior we should expect from each."
- "Review our must-have mapping and tell us what is missing or untestable."

> Treat every generated requirement as a hypothesis. Verify it against the kit, the syllabus must-haves, and a live test.

## 📖 How the Studio Sessions Work

The project is a short engineering sprint, not a single lab:

```text
[Kickoff]        Story, team, requirements, first architecture sketch
    |
[Build]          Sensors on the bus, actuator, firmware, IoTempower node
    |
[Characterize]   Transfer function / calibration, actuator performance, metrics
    |
[Harden]         Fault injection, recovery, documentation
    |
[Rehearse]       Peer dry run against the must-haves
    |
[Defend]         Module 10: live demo + portfolio defense
```

Sessions are open-ended by design. If you finish a milestone early, harden the system, take more measurements, or help a neighboring Project Team (which counts toward bonus points).

## 📖 The Final Project Architecture Stack

```text
==================== SENSOR / ACTUATOR FINAL PROJECT STACK ====================

[Physical process]   the quantity you measure and the thing you move
                           |
[Sensors]            I²C (>=1) + a second sensor, characterized & calibrated
                           |
[Conditioning]       divider / reference / filtering (hardware or IoTempower)
                           |
[Actuator]           motor/servo/LED installation with its own driver & supply
                           |
[Node]               ESP32/ESP8266 or M5Stack, declared in IoTempower
                           |
[Integration]        MQTT topics + Node-RED dashboard + one control rule
                           |
[Evaluation]         transfer function, resolution, latency, current, robustness
=========================================================================
```

A strong project uses each layer it includes deliberately and can defend the choice.

## 🛠️ Studio Labs — **Challenging**

*Project Teams of 4–6 students (two merged Task Pods). Work through the milestones; they are not a rigid clock.*

### ★ Task 1: Project Kickoff — Story, Project Team & Requirements

1. Craft a story around a real stakeholder (a person with a name and a problem). Start from your pre-study abstract and refine it. It must be playable and pitchable.
2. Pitch to a neighboring Project Team and note their questions.
3. Merge two Task Pods into a **Project Team of 4–6** and document individual roles and contributions in each portfolio. If a team wants to continue an earlier project of their own instead of starting fresh, agree on this with the instructor — it is a possibility, not the default.
4. Map requirements onto the final-project must-haves (see the syllabus): which sensors (with which bus/addresses), which actuator, which characterization you will perform, which integration, which resilience test.

### ★ Task 2: Build and Integrate (milestones across sessions)

Verify your system against the must-haves:

1. Two sensors, at least one I²C, both identified by address in your documentation.
2. One actuator that physically acts — motor/servo/stepper or an addressable LED installation.
3. One IoTempower filter for processing.
4. Node-RED dashboard with display and control, plus one closed-loop/rule-based behavior.
5. Safety and interlocks: a defined safe state and at least one limit (max duty, timeout, or limit switch).

### ★ Task 3: Characterize and Evaluate

This is what distinguishes a Sensors-and-Actuators project from a generic IoT project.

1. Sensor characterization: determine the transfer function (or a calibration table) of at least one sensor from your own reference measurements; report resolution and a simple uncertainty (Module 3).
2. Actuator performance: measure what the actuator actually does — speed, torque/force proxy, current, and the stall/limit behavior (Module 7).
3. System metrics: pick and measure at least one — sampling rate, end-to-end latency, current consumption, or robustness to noise/interference.
4. Present the results as a small table/plot with conditions stated.

### ★ Task 4: Fault Injection & Resilience Testing

Intentionally break things and document the recovery:

- Test A (sensor fault): disconnect the I²C sensor. Does the node stay alive and report a fault?
- Test B (noise/interference): introduce noise (motor running, longer wires, a light source) and show how your filtering/characterization copes.
- Test C (actuator limit): block the motor/servo. Does current rise, and does your interlock/timeout react safely?
- Test D (broker restart): restart Mosquitto. Do node and dashboard reconnect and resubscribe?

### ★ Task 5: Peer Review & Dry Run Rehearsal

Pair with another Project Team for a reciprocal dry run:

#### Presenting Project Team:
1. Story: problem, users, and value.
2. Architecture: sensors (bus/addresses), actuator, drivers, data path.
3. Live demo: measure a real quantity and make the actuator respond; show one characterization result.

#### Reviewing Project Team:
- Measurement quality: is the characterization credible, with units, conditions, and uncertainty?
- Robustness: what happens under the fault-injection tests?
- Evidence: are wiring, addresses, transfer functions, and metrics documented in the portfolio?

## ✅ Suggested portfolio evidence (proofs of the learning goals)

1. Kickoff story and the requirement-to-must-have mapping.
2. System architecture diagram: sensors (with bus/addresses), conditioning, actuator + driver, node, data path.
3. Characterization report: transfer function/calibration, resolution, uncertainty.
4. Evaluation report: actuator performance and at least one system metric.
5. Fault-injection log for the four tests.
6. Peer feedback log and the concrete changes you will make before the final defense.


> [!IMPORTANT]
> Never commit secrets, credentials, or personal data. Where you did not work entirely alone, link your pod mates and sources.

## 📚 If you want to go deeper

- [Wikipedia: Story-driven modeling](https://en.wikipedia.org/wiki/Story-driven_modeling) — the method behind the stories.
- [Wikipedia: Requirement](https://en.wikipedia.org/wiki/Requirement) and [Acceptance testing](https://en.wikipedia.org/wiki/Acceptance_testing) — turning a story into testable criteria.
- [Wikipedia: Systems architecture](https://en.wikipedia.org/wiki/Systems_architecture) — layers, interfaces, and trade-offs.
- [Wikipedia: Fault injection](https://en.wikipedia.org/wiki/Fault_injection) — how to prove resilience.
- The [story canon](./Z-resources-bank.md#story-canon-the-recurring-cast) — keep your new story consistent with the course universe.

---

[← Previous: Module 8](./08-sensor-to-system-and-integration.md) | [Back to front page](../README.md) | [Quick module index](./00-index.md) | [Next: Module 10 — Demonstration & Portfolio Defense →](./10-demonstration-and-defense.md)
