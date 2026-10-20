# Module 4 – Distance, Motion & Environment Sensors

[← Back to Module 3](./03-sensor-characterization-and-calibration.md) | [Quick module index](./00-index.md) | [Next: Module 5 →](./05-leds-and-light-output.md)

> Today: how the world around the node is measured. Distance, motion, touch, and environment are the workhorses of the example projects — people counters, flow sensors, interactive installations.

**Course placement:** Day 4 — the sensor-principle studio, after Checkpoint 1 (Modules 1–3).

## 🎯 Learning Goals

This module gives you the opportunity to explore distance, motion, and environment sensing and achieve competency in ToF, ultrasonic, and IR distance principles, motion/orientation sensing (or an agreed alternative sensor), and Hall-effect/current and environment sensing.

By the end of this module, you can:
1. Compare the main distance-sensing principles: IR triangulation, ultrasonic time-of-flight, optical time-of-flight.
2. Use a ToF sensor (VL53L0X) and an ultrasonic sensor and explain their failure modes.
3. Read a motion/orientation sensor (IMU, or an agreed alternative), compute a derived quantity such as tilt, recognize drift, and apply a simple processing or fusion step.
4. Explain Hall-effect and current sensing and use a Hall sensor.
5. Choose an appropriate environment sensor (temperature, humidity, pressure) for a task.


**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 📖 Story — The Conveyor That Counts Twice

**Brinkmann Maschinenbau GmbH** builds special-purpose machines for small factories. Automation engineer **Sofia Roth** is adding a part counter to a conveyor: every metal bracket that passes a distance sensor should increment a count, and a Hall sensor should confirm that the drive is actually moving. On the bench it works. On the line, the counter double-counts when a bracket wobbles, misses when the surface is dark, and reports “moving” for a motor that has stalled.

Sofia's question is not “which sensor is best?” but *“which sensing principle fits this target, this surface, and this failure mode?”* Today you compare ToF, ultrasonic, IR, IMU, Hall, and environment sensors — and you characterize them on the bench so the answer is evidence, not opinion.

## 📖 Pod Study: Which Principle Fits?

This is **self/pod study, not a lecture.** Work through the concepts below with your Task Pod, look things up, ask an LLM, and keep notes — the goal is a shared mental model you can defend in the checkpoint.

### Measuring Distance

Three families dominate the kit:

- IR triangulation (e.g. sharp IR sensors): emit IR, measure the *angle* of the reflected spot. Cheap, but strongly target- and light-dependent.
- Ultrasonic time-of-flight: emit a sound pulse, time the echo. Immune to target color; sensitive to soft/angled surfaces, temperature, and crosstalk between units.
- Optical ToF (VL53L0X): emit IR laser pulses, time the reflection precisely. Fast and accurate; range depends on target reflectance and ambient light; needs an I²C address (`0x29`).

| Sensor | Range (typ.) | Resolution | Latency | Weakness |
|---|---|---|---|---|
| Sharp IR analog | ~10–80 cm | low, non-linear | fast | target color, ambient light |
| Ultrasonic HC-SR04 | ~2 cm–4 m | ~0.3 cm | tens of ms | soft surfaces, crosstalk, temperature |
| VL53L0X ToF (I²C) | ~3 cm–2 m | ~mm | ms | dark/low-reflectance targets, sunlight |

Because an ultrasonic or ToF unit fires energy and waits, two of them pointed at the same target can interfere. In a people-counter or multi-sensor setup, either interleave their firing or budget the timing.

### Motion and Orientation

A motion sensor — an IMU such as the MPU6050 (I²C `0x68`), the M5StickC's built-in IMU (e.g. MPU6886), or a similar part — combines:

- an accelerometer (measures proper acceleration, including gravity) — good for *static tilt*, noisy for quick motion;
- a gyroscope (measures angular velocity) — good for *short-term rotation*, but drifts over time due to bias.

Neither alone is enough for orientation. A complementary filter blends them: trust the gyro for fast changes and the accelerometer to correct slow drift. (A Kalman filter does the same more rigorously.)

For simple use cases you often do not need full fusion — a tilt angle from the accelerometer, or a gesture from acceleration thresholds, is enough (but say so explicitly in your documentation).

### Magnetic Field and Current

- A Hall-effect sensor outputs a voltage proportional to magnetic field. Digital latch versions switch state at a field polarity — perfect for a light barrier, a flow-meter reed substitute, or a magnetic door/window sensor.
- Current sensing measures current either with a small shunt resistor (voltage across a known resistor; needs a differential amplifier) or with a Hall-based sensor (isolated, no shunt loss). This is the basis of an "energy/current monitor" project.

### Environment Sensors

- DS18B20 (OneWire): robust, cheap temperature, addressable in chains, slower.
- DHT22: cheap T + RH, slower and with modest accuracy.
- BME280 / environment modules (I²C): T + RH + pressure, faster, more accurate — usually the right default for a station.
- If the DS18B20 is the only environment sensor available, treat it as a full lab sensor — see Task 4, Option C.
- Remember the lessons from Modules 2 and 3: these are I²C devices with addresses and registers, and they have time constants and self-heating (a sensor near a hot MCU reads warm — isolate or compensate).

### Pointers (start here, then keep looking)

- Optical time-of-flight — [VL53L0X datasheet and API](https://www.st.com/en/imaging-and-photonics-solutions/vl53l0x.html)
- Ultrasonic ranging — [Wikipedia: Ultrasonic transducer](https://en.wikipedia.org/wiki/Ultrasonic_transducer) and the HC-SR04 datasheet
- IMUs and sensor fusion — [Wikipedia: Inertial measurement unit](https://en.wikipedia.org/wiki/Inertial_measurement_unit), [Complementary filter](https://en.wikipedia.org/wiki/Complementary_filter)
- Hall effect and current sensing — [Wikipedia: Hall effect sensor](https://en.wikipedia.org/wiki/Hall_effect_sensor)
- Environment sensors — the BME280/SHT3x/DS18B20 datasheets linked in the [resource bank](./Z-resources-bank.md#datasheets--standards-to-read-once)

### Questions to ask an LLM (then verify against your hardware)

Ask your co-pilot — but treat every answer as a **claim to test**, not a fact. Good starting prompts:

- "Compare IR triangulation, ultrasonic time-of-flight, and optical time-of-flight for distance measurement. Give one task where each wins and one failure mode each."
- "My ToF sensor is accurate on a white wall and wrong on a black shirt. Explain why, and design a quick characterization experiment."
- "Explain how a complementary filter combines an accelerometer and a gyroscope. Give me pseudo-code and the role of the filter constant."
- "How does a Hall sensor measure current without a shunt? What are the offset, sensitivity, and temperature-drift issues I should measure?"
- "Two ultrasonic sensors pointed at the same target interfere. How would I interleave them, and what timing budget do I need?"

> Run each prompt against your own sensors, and record where the model is wrong, vague, or over-confident.

### ★ Task A: Study in your pod

Work through the concepts above with your Task Pod and fill in `module-04/study-log.md`:

1. **The references you used** — the source and the one concept you understood best from it.
2. **Things you googled** — the term, what you found, and the source (URL). One line each.
3. **Remarkable things** — surprises, "aha"s, and counterexamples from your own measurements.
4. **LLM Q&A** — for each prompt: the prompt, a 2–3 line summary, and **how you verified it** (and where it was wrong).
5. **Your two best found comparison tables or diagrams** — compile down to the best two, with source and what they taught you.

*Portfolio evidence:* `module-04/study-log.md`.

### ★ Task B: Explain & share with another pod

Pair with a **neighbouring pod**:

1. **Explain to each other** — each pod walks the other through its sensor comparison and its characterization table; ask questions and fill each other's gaps.
2. Agree on the **3–5 most noteworthy points** and the **learning you jointly stand behind** (e.g. *"no distance principle is best; the target and the failure mode decide"*).
3. **Clean up your documentation** — update your `study-log.md` with what you learned from the other pod.
4. Agree on **one shared artefact** — the best comparison table, error plot, or a new decision diagram the two pods make together — and **post it in the course Discord**, with a one-sentence note on why you chose it.
5. Each member adds a short **“Agreed learning (pod discussion)”** section to *their own* `study-log.md`.

*Portfolio evidence:* your cleaned-up `study-log.md` (with the **“Agreed learning (pod discussion)”** section) and your pod-pair's shared artefact.

## 🛠️ In-Class Lab: Distance, Motion & Environment — **Challenging**

*Hardware:* a distance sensor (VL53L0X ToF and/or an ultrasonic module) plus one motion/environment sensor chosen from what is available — the MPU6050 or the M5StickC's built-in IMU, the MPR121 capacitive-touch controller, or the DS18B20 (OneWire) temperature sensor. A ruler or measuring tape as reference; a Hall sensor is optional.

> [!NOTE]
> Use what you have. This module is about *sensing principles*, not one specific part. Do the motion/environment task with whichever sensor you can actually get working — MPU6050, the M5StickC's built-in IMU, an MPR121 touch sensor, or "just" the DS18B20 temperature sensor — and note in your portfolio which one you used and why.

> [!WARNING]
> Some ultrasonic modules are 5 V devices — check before connecting to 3.3 V logic, and use a level shifter/divider for the echo line if required.

### ★ Task 1: Characterize a ToF Sensor

1. Mount the VL53L0X firmly and measure against a ruler at ten known distances across its range.
2. Record distance-error and repeatability at each point (measure 5× and take the spread).
3. Repeat near the extremes of the range and with a dark and a shiny/angled target. Note where the sensor becomes unreliable.
4. Produce a short distance-vs-error table and name the weaknesses you observed (this is characterization — Module 3 skills applied to a different sensor).

### ★ Task 2: Ultrasonic vs. ToF Comparison

1. Measure the same targets with an ultrasonic sensor (if available).
2. Compare accuracy, repeatability, measuring rate, beam shape (does one see obstacles the other misses?), and surface sensitivity.
3. With two ultrasonic units, try to trigger crosstalk and describe how you would avoid it in a product.

### ★ Task 3: A People Counter / Detector

Build the first half of an example project from the announcement:

1. Use two distance sensors along a path (or one ToF plus a light barrier) to detect direction of passage rather than mere presence.
2. Implement a minimal state machine: count a person only when the two sensors trigger in the correct order within a time window.
3. Test it with a hand/object passing in each direction and log the count.
4. Note the false detections you get and the timing window that reduces them.

*This is the seed of a final project: "person counter with several distance sensors" is a listed example project.*

### ★ Task 4: Motion, Touch, or Temperature — Pick What You Have

Read a motion/environment sensor and find its characteristic behavior. Do one of the options below (whichever hardware you have), and state in your portfolio which you chose and why.

**Option A — IMU (MPU6050, or the M5StickC's built-in IMU):**
1. Read accelerometer and gyroscope raw values (the MPU6050 is at I²C `0x68`).
2. Compute a tilt angle from the accelerometer alone. Check it against a spirit level or a protractor.
3. Integrate the gyroscope over a few seconds while the sensor is static and show that the angle drifts. That is bias.
4. Implement a simple complementary filter (e.g. 98 % gyro + 2 % accelerometer per step) and show that drift is corrected.

**Option B — MPR121 capacitive touch (I²C, `0x5A`):**
1. Read the capacitive channels and establish a baseline with nothing touching.
2. Detect touch/proximity on one or more channels and tune a threshold and filtering (sensitivity).
3. Show that touch sensors drift too (baseline wandering, temperature/humidity effects) and that re-baselining corrects it — the same "drift" idea as the gyro, in a different sensor.
4. Note what the capacitive reading depends on (contact area, grounding, nearby objects).

**Option C — DS18B20 temperature (OneWire):**
1. Read the temperature and compare it against a reference thermometer.
2. Do a step-response measurement (move it from cold to warm) and estimate the time constant τ.
3. Note self-heating and the effect of the measurement rate; read a chained/second sensor and record its 64-bit OneWire address (parallel to I²C addressing).
4. Estimate the resolution and uncertainty of your reading.

### ◇ Task 5 (Stretcher): Hall-Effect Current Monitor

Use a Hall sensor to build a simple current monitor (the announcement lists "current/power sensor with Hall effect"):

1. Measure the output with no current to establish the offset.
2. Pass a known current through a wire near/by the sensor (a calibrated load, or a known resistor) and record the output change.
3. Compute the sensitivity (mV per ampere) and state the resolution and uncertainty.
4. Alternatively, use a digital Hall latch as a light barrier / flow sensor: count pulses and convert to a rate.

## ✅ Suggested portfolio evidence (proofs of the learning goals)

Your portfolio only needs to **prove this module's learning goals**. The items below are **suggested proofs** — commit them if they fit, or demonstrate the same goals your own way. (Under `module-04/`.)
1. ToF characterization: distance-error table across the range and under different targets.
2. Comparison table: IR/ultrasonic/ToF and your recommendation for two scenarios.
3. People counter: state diagram, timing window, observed false detections.
4. Sensor results (Task 4): for the option you chose, report the characterized behavior — e.g. tilt accuracy and gyro drift (IMU), baseline drift and threshold tuning (MPR121), or time constant, resolution, and OneWire address (DS18B20).
5. Reflection: Why can no single distance principle be "the best"? Give one task where each wins.

### Reflection logbook

Write one entry for this teaching block in `reflection.md`: *What worked? What broke? How did my mental model shift? How did I verify AI suggestions?*

> [!IMPORTANT]
> Never commit secrets, credentials, or personal data. Where you did not work entirely alone, link your pod mates and sources.

## 📚 If you want to go deeper

- [VL53L0X](https://www.st.com/en/imaging-and-photonics-solutions/vl53l0x.html) — the register map and the reflectance caveats.
- [Wikipedia: Inertial measurement unit](https://en.wikipedia.org/wiki/Inertial_measurement_unit) and [Complementary filter](https://en.wikipedia.org/wiki/Complementary_filter) — why gyro and accelerometer need each other.
- [Wikipedia: Hall effect sensor](https://en.wikipedia.org/wiki/Hall_effect_sensor) — current sensing without a shunt.
- The BME280/SHT3x/DS18B20 datasheets — linked from the [resource bank](./Z-resources-bank.md#datasheets--standards-to-read-once).

---

[← Previous: Module 3](./03-sensor-characterization-and-calibration.md) | [Back to front page](../README.md) | [Quick module index](./00-index.md) | [Next: Module 5 — LEDs & Light as Output →](./05-leds-and-light-output.md)
