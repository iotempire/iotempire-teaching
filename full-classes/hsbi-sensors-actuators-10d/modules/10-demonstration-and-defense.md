# Module 10 – Demonstration & Portfolio Defense

[← Back to Module 9](./09-final-project-studio.md) | [Quick module index](./00-index.md)

**Course placement:** Day 10 / Session 12 — the final session. You demonstrate a characterized sensor/actuator system and defend the engineering behind it, to the instructor and to your peers.

## 🎯 Learning Goals

This module gives you the opportunity to explore engineering communication and defense and achieve competency in delivering a live sensor/actuator demonstration, defending your measurements, and presenting your portfolio.

By the end of this module, you can:
1. Deliver a compelling live demonstration of your sensor/actuator system.
2. Defend your measurement and characterization decisions, your actuator choices, and your resilience design.
3. Complete the portfolio evaluation and defense.
4. Reflect on your journey from an ADC code to a documented, characterized system.


**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 📖 Story — The Night the System Has to Work

It is the opening night at the Stadtmuseum. **Aylin Demir** is watching the corridor; **Mara Voss** is standing by the controller; **Jonas Feld** has a USB cable and a fallback recording. The light wall is supposed to breathe, wake on approach, and survive a guest unplugging the wrong thing. Nobody cares how elegant the sketch is if the wall goes dark at 19:55.

Your final demo is the same moment in miniature. You have a short slot: first show the system measuring and acting, then defend the decisions you own. The instructor will ask you to break something on purpose. The story gives you the *why*; the characterization and the fault-injection log give you the *how do you know?*

## 🛠️ In-Class Demo & Defense Procedure

*The format and timing are set in the [syllabus](../syllabus.md#final-project-requirements-5-points); this page is the working script.*

### Demonstration Script Guidelines

1. System Story & Problem Context: Who uses this system? What real-world quantity does it measure, and what does it move?
2. Architecture & Measurement Defense:
   - Show the physical nodes, the I²C bus and addresses, the second sensor, the actuator and its driver/supply.
   - Justify your sensor principles and your transfer function/calibration. State resolution and uncertainty.
   - Justify your actuator choice by torque/speed/precision and control complexity.
3. Live Demonstration:
   - Measure a real quantity and show it on the dashboard.
   - Make the actuator respond (or show the animation/installation reacting to a sensor).
   - Show one characterization result (e.g. the error table before/after calibration).
4. Live Fault Injection (Instructor Challenge):
   - The instructor or a peer will test your resilience (disconnect the sensor, block the actuator, restart the broker).
   - Show how the system fails gracefully, reports the fault, or recovers.

## 📋 Where the Rubric Lives

The final project is assessed according to the [syllabus](../syllabus.md#final-project-requirements-5-points), and the rubric lives **only** there. This page is the working demo script and evidence checklist; if the two ever disagree, the syllabus wins.

## ✅ Suggested portfolio evidence (proofs of the learning goals)

- [ ] Module 0: Pre-study notes, Wokwi simulation screenshot(s), datasheet notes, project abstract, and answers to the guiding questions.
- [ ] Module 1: Chain diagram, basic-electronics/button/debounce evidence, serial log and plot, ADC table (raw range, steps, step size), LDR/filter comparison, vocabulary definitions.
- [ ] Module 2: I²C scan output, addresses mapped to modules, raw-register reconstruction, address-conflict report.
- [ ] Module 3: Transfer-function plot, calibration table, hysteresis/repeatability numbers, noise/filtering table, uncertainty statement.
- [ ] Module 4: ToF characterization table, distance-sensor comparison, people-counter state machine, IMU tilt/drift/fusion results.
- [ ] Module 5: Resistor calculation vs. measurement, PWM/gamma notes, RGB evidence, strip artifacts, power-budget table.
- [ ] Module 6: Animation engine structure, effect videos/photos, sensor/sound interaction, installation-constraints note.
- [ ] Module 7: Servo evidence and currents, H-bridge truth table and stall current, stepper results, sensor→motor logic.
- [ ] Module 8: MQTT publishing/command sketch or optional IoTempower node definition, topic map, filter evidence, Node-RED flow export and dashboard, fault-injection report.
- [ ] Modules 9 & 10: Final Project architecture diagram, characterization and evaluation reports, fault-injection log, presentation slides/script, and final retrospective.
- [ ] Reflection logbook entries for the teaching blocks, using the [reflection template](https://github.com/iotempire/iot-portfolio-template/blob/main/Reflections/TEMPLATE.md) in `Reflections/`.
- [ ] Where you did not work entirely alone: links to pod mates, sources, and borrowed code.

> [!IMPORTANT]
> Never commit `*.db`, `.venv/`, credentials, private keys, or personal data. Commit the scripts and configuration that rebuild your evidence.

## 🎓 Course Retrospective & What's Next

Congratulations on completing Sensors and Actuators!

You have developed practical mastery of:
- From physics to numbers: measurement technique, the digital signal chain, and honest uncertainty.
- The bus, understood: I²C wiring, addressing, register maps — the skill that makes every modern sensor approachable.
- Characterized sensing: transfer functions, calibration, hysteresis, and filtering you can defend.
- Actuation: LEDs and LED animation, servos, DC motors, and steppers, driven safely and correctly.
- Systems: sensors and actuators integrated through direct MQTT and Node-RED (and, optionally, deployed declaratively with IoTempower).

### Next Steps:
- Optionally continue with the IoTempire ecosystem: [iotempire.net](https://iotempire.net/) and [github.com/iotempire/iotempower](https://github.com/iotempire/iotempower).
- Extend your final project toward the announcement's larger ideas: a flow sensor with light barriers, a Hall-effect power monitor, an interactive LED installation, or a music-synchronized fountain.
- If you continue into a bachelor thesis or project, your characterization and evaluation documentation is exactly the material that turns a prototype into a credible engineering result.

## 📚 If you want to go deeper

- [Wikipedia: Story-driven modeling](https://en.wikipedia.org/wiki/Story-driven_modeling) — the method behind the project stories.
- [Wikipedia: Fault injection](https://en.wikipedia.org/wiki/Fault_injection) — the resilience test you will face live.
- [Wikipedia: Technical presentation](https://en.wikipedia.org/wiki/Technical_presentation) — structure, evidence, and time discipline.
- The [resource bank's instructor hints](./Z-resources-bank.md#instructor-hints) — how the demo and defense are run.

---

[← Previous: Module 9](./09-final-project-studio.md) | [Back to front page](../README.md) | [Quick module index](./00-index.md)
