# Module 10 – Demonstration & Portfolio Defense

[← Back to Module 9](./09-final-project-studio.md) | [Quick module index](./00-index.md)

> The final session: you demonstrate a characterized sensor/actuator system and defend the engineering behind it.

---

## 🎯 Learning Goals

> **How these are assessed:** You earn this module's points by **proving these goals** in a short (~10-minute) checkpoint presentation with the instructor (see the [syllabus](../syllabus.md#how-module-points-are-earned-checkpoint-presentations)) — based on your portfolio and reflections, not on completing every task. You may skip tasks, fail at some, or add your own; documented exploration and demonstrated deep understanding both count in your favor.

This module gives you the opportunity to explore **engineering communication and defense** and achieve competency in **delivering a live sensor/actuator demonstration, defending your measurements, and presenting your portfolio**.

By the end of this module, you can:
1. Deliver a compelling **5-minute live demonstration** of your sensor/actuator system.
2. Defend your **measurement and characterization** decisions, your **actuator** choices, and your **resilience** design.
3. Complete the **portfolio evaluation and assessment defense**.
4. Reflect on your journey from an ADC code to a documented, characterized system.

> [!WARNING]
> **DRAFT — first taught in WS 2026/27.** Everything below this line is a working draft and will likely change as we refine it together in class; the line moves down as we approve content. Your input is welcome and can shape this module.

**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

---

## 🛠️ In-Class Demo & Defense Procedure

*Format: 5-minute presentation + 2-minute live interaction / fault injection + 2-minute Q&A per team.*

---

### Demonstration Script Guidelines (5 min)

1. **System Story & Problem Context (1 min):** Who uses this system? What real-world quantity does it measure, and what does it move?
2. **Architecture & Measurement Defense (2 min):**
   - Show the physical nodes, the **I²C bus and addresses**, the second sensor, the actuator and its driver/supply.
   - Justify your **sensor principles** and your **transfer function/calibration**. State resolution and uncertainty.
   - Justify your **actuator** choice by torque/speed/precision and control complexity.
3. **Live Demonstration (2 min):**
   - Measure a real quantity and show it on the dashboard.
   - Make the actuator respond (or show the animation/installation reacting to a sensor).
   - Show one **characterization result** (e.g. the error table before/after calibration).
4. **Live Fault Injection (Instructor Challenge):**
   - The instructor or a peer will test your resilience (disconnect the sensor, block the actuator, restart the broker).
   - Show how the system fails gracefully, reports the fault, or recovers.

---

## 📋 Final Project Assessment Rubric (5 Points)

| Criteria | Max Points | Expectations |
|---|:---:|---|
| **System Functionality & Measurement Quality** | **2.0 pts** | Two sensors (≥1 I²C, with addresses documented), one actuator demonstrated under control, credible transfer function/calibration with resolution and uncertainty, and correct addressing/register handling. |
| **Architecture, Documentation & Evaluation** | **1.5 pts** | Clear wiring/system diagram, bus and address documentation, IoTempower node + filter, MQTT topics, actuator performance and at least one system metric, and clean Git commits in the portfolio. |
| **Live Presentation & Technical Defense** | **1.5 pts** | Clear, fluent demonstration; confident explanation of sensor/actuator principles, characterization, and trade-offs; thoughtful answers to technical questions. |

---

## 📝 Final Portfolio Submission Checklist

Ensure your personal GitHub portfolio includes all required evidence before final submission:
- [ ] **Module 0:** Pre-study notes, Wokwi simulation screenshot(s), datasheet notes, project abstract, and answers to the guiding questions.
- [ ] **Module 1:** Chain diagram, ADC table (raw range, steps, step size), Master Class node evidence, vocabulary definitions.
- [ ] **Module 2:** I²C scan output, addresses mapped to modules, raw-register reconstruction, address-conflict report.
- [ ] **Module 3:** Transfer-function plot, calibration table, hysteresis/repeatability numbers, noise/filtering table, uncertainty statement.
- [ ] **Module 4:** ToF characterization table, distance-sensor comparison, people-counter state machine, IMU tilt/drift/fusion results.
- [ ] **Module 5:** Resistor calculation vs. measurement, PWM/gamma notes, RGB evidence, strip artifacts, power-budget table.
- [ ] **Module 6:** Animation engine structure, effect videos/photos, sensor/sound interaction, installation-constraints note.
- [ ] **Module 7:** Servo evidence and currents, H-bridge truth table and stall current, stepper results, sensor→motor logic.
- [ ] **Module 8:** IoTempower node definition, MQTT topics, filter evidence, Node-RED flow export and dashboard, fault-injection report.
- [ ] **Modules 9 & 10:** Final Project architecture diagram, characterization and evaluation reports, fault-injection log, presentation slides/script, and final retrospective.
- [ ] **Working-Day Reflections:** Complete entries for every working day.

---

## 🎓 Course Retrospective & What's Next

Congratulations on completing **Sensors and Actuators**!

You have developed practical mastery of:
- **From physics to numbers:** measurement technique, the digital signal chain, and honest uncertainty.
- **The bus, understood:** I²C wiring, addressing, register maps — the skill that makes every modern sensor approachable.
- **Characterized sensing:** transfer functions, calibration, hysteresis, and filtering you can defend.
- **Actuation:** LEDs and LED animation, servos, DC motors, and steppers, driven safely and correctly.
- **Systems:** sensors and actuators deployed declaratively with IoTempower and integrated through MQTT and Node-RED.

### Next Steps:
- Continue with the IoTempire ecosystem: [iotempire.net](https://iotempire.net/) and [github.com/iotempire/iotempower](https://github.com/iotempire/iotempower).
- Extend your final project toward the announcement's larger ideas: a **flow sensor with light barriers**, a **Hall-effect power monitor**, an **interactive LED installation**, or a **music-synchronized fountain**.
- If you continue into a bachelor thesis or project, your characterization and evaluation documentation is exactly the material that turns a prototype into a credible engineering result.
