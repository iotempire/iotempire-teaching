# Module 9 – Capstone Project Studio: From Story to Characterized System

[← Back to Module 8](./08-sensor-to-system-and-integration.md) | [Quick module index](./00-index.md) | [Next: Module 10 →](./10-demonstration-and-defense.md)

> **Course placement:** This module spans the final project arc — the studio sessions dedicated to ideation, requirement mapping, building, characterization, hardening, and rehearsal. The exact split depends on the timetable and group progress; the schedule deliberately reserves buffer time here so slower labs do not eat into the project.

---

## 📌 Module Outcomes
By the end of this module, you will:
1. Turn a stakeholder **story** into a concrete sensor/actuator architecture with explicit requirements.
2. Build and integrate a working sensor/actuator system on the local-first stack.
3. **Characterize and evaluate** the system: transfer function, resolution/uncertainty, actuator performance, and at least one system metric.
4. Perform **fault injection** and show that the system degrades gracefully.
5. Conduct a structured **peer review and dry run** of your demonstration.

---

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
[Rehearse]       Peer dry run against the rubric
    |
[Defend]         Module 10: live demo + portfolio defense
```

Sessions are **open-ended by design**. If you finish a milestone early, harden the system, take more measurements, or help a neighboring team (which counts toward bonus points).

---

## 📖 The Capstone Architecture Stack

```text
==================== SENSOR / ACTUATOR CAPSTONE STACK ====================

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

A strong project uses each layer it includes **deliberately** and can defend the choice.

---

## 🛠️ Studio Labs

*Teams of 2–4 students. Work through the milestones; they are not a rigid clock.*

---

### Task 1: Project Kickoff — Story, Team & Requirements (45 min)

1. **Craft a story** around a real stakeholder (a person with a name and a problem). Start from your pre-study abstract and refine it. It must be **playable and pitchable**.
2. **Pitch to a neighboring team (2×5 min)** and note their questions.
3. **Form your team of 2–4** and document individual roles and contributions in each portfolio. If a team wants to extend an existing project from *Networking and IoT-Lösungen* instead of starting fresh, agree on this with the instructor — it is a possibility, not the default.
4. **Map requirements** onto the capstone must-haves (see the syllabus): which sensors (with which bus/addresses), which actuator, which characterization you will perform, which integration, which resilience test.

---

### Task 2: Build and Integrate (milestones across sessions)

Verify your system against the must-haves:

1. **Two sensors, at least one I²C**, both identified by address in your documentation.
2. **One actuator that physically acts** — motor/servo/stepper or an addressable LED installation.
3. **One IoTempower filter** for processing.
4. **Node-RED dashboard** with display **and** control, plus one closed-loop/rule-based behavior.
5. **Safety and interlocks:** a defined safe state and at least one limit (max duty, timeout, or limit switch).

---

### Task 3: Characterize and Evaluate (60 min)

This is what distinguishes a Sensors-and-Actuators project from a generic IoT project.

1. **Sensor characterization:** determine the **transfer function** (or a calibration table) of at least one sensor from your own reference measurements; report **resolution** and a simple **uncertainty** (Module 3).
2. **Actuator performance:** measure what the actuator actually does — speed, torque/force proxy, current, and the **stall/limit** behavior (Module 7).
3. **System metrics:** pick and measure at least one — sampling rate, end-to-end **latency**, current consumption, or robustness to noise/interference.
4. Present the results as a small table/plot with conditions stated.

---

### Task 4: Fault Injection & Resilience Testing (30 min)

Intentionally break things and document the recovery:

- **Test A (sensor fault):** disconnect the I²C sensor. Does the node stay alive and report a fault?
- **Test B (noise/interference):** introduce noise (motor running, longer wires, a light source) and show how your filtering/characterization copes.
- **Test C (actuator limit):** block the motor/servo. Does current rise, and does your interlock/timeout react safely?
- **Test D (broker restart):** restart Mosquitto. Do node and dashboard reconnect and resubscribe?

---

### Task 5: Peer Review & Dry Run Rehearsal (40 min)

Pair with another team for a reciprocal dry run:

#### Presenting Team (5 min):
1. **Story (1 min):** problem, users, and value.
2. **Architecture (2 min):** sensors (bus/addresses), actuator, drivers, data path.
3. **Live demo (2 min):** measure a real quantity and make the actuator respond; show one characterization result.

#### Reviewing Team (5 min, against the rubric):
- **Measurement quality:** is the characterization credible, with units, conditions, and uncertainty?
- **Robustness:** what happens under the fault-injection tests?
- **Evidence:** are wiring, addresses, transfer functions, and metrics documented in the portfolio?

---

## 📝 Working-Day Reflection & Portfolio Tasks

In your portfolio under `modules/09-capstone-studio/`:
1. **Kickoff story** and the requirement-to-must-have mapping.
2. **System architecture diagram:** sensors (with bus/addresses), conditioning, actuator + driver, node, data path.
3. **Characterization report:** transfer function/calibration, resolution, uncertainty.
4. **Evaluation report:** actuator performance and at least one system metric.
5. **Fault-injection log** for the four tests.
6. **Peer feedback log** and the concrete changes you will make before the final defense.
