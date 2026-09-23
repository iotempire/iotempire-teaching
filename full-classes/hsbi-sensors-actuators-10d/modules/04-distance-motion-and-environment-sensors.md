# Module 4 – Distance, Motion & Environment Sensors

[← Back to Module 3](./03-sensor-characterization-and-calibration.md) | [Quick module index](./00-index.md) | [Next: Module 5 →](./05-leds-and-light-output.md)

> **Today: how the world around the node is measured.** Distance and motion are the workhorses of the example projects — people counters, flow sensors, interactive installations.

---

## 🎯 Learning Goals

> **How these are assessed:** You earn this module's points by **proving these goals** in a short (~10-minute) checkpoint presentation with the instructor (see the [syllabus](../syllabus.md#how-module-points-are-earned-checkpoint-presentations)) — based on your portfolio and reflections, not on completing every task. You may skip tasks, fail at some, or add your own; documented exploration and demonstrated deep understanding both count in your favor.

This module gives you the opportunity to explore **distance, motion, and environment sensing** and achieve competency in **ToF, ultrasonic, and IR distance principles, IMU orientation and fusion, and Hall-effect/current and environment sensors**.

By the end of this module, you can:
1. Compare the main **distance-sensing principles**: IR triangulation, ultrasonic time-of-flight, optical time-of-flight.
2. Use a **ToF sensor** (VL53L0X) and an **ultrasonic sensor** and explain their failure modes.
3. Read an **IMU** (accelerometer + gyroscope), compute tilt, recognize drift, and apply a simple sensor fusion.
4. Explain **Hall-effect** and **current** sensing and use a Hall sensor.
5. Choose an appropriate **environment sensor** (temperature, humidity, pressure) for a task.

> [!WARNING]
> **DRAFT — first taught in WS 2026/27.** Everything below this line is a working draft and will likely change as we refine it together in class; the line moves down as we approve content. Your input is welcome and can shape this module.

**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

---

## 📖 Part A — Measuring Distance

Three families dominate the kit:

- **IR triangulation** (e.g. sharp IR sensors): emit IR, measure the *angle* of the reflected spot. Cheap, but strongly target- and light-dependent.
- **Ultrasonic time-of-flight**: emit a sound pulse, time the echo. Immune to target color; sensitive to soft/angled surfaces, temperature, and crosstalk between units.
- **Optical ToF** (VL53L0X): emit IR laser pulses, time the reflection precisely. Fast and accurate; range depends on **target reflectance** and ambient light; needs an I²C address (`0x29`).

| Sensor | Range (typ.) | Resolution | Latency | Weakness |
|---|---|---|---|---|
| Sharp IR analog | ~10–80 cm | low, non-linear | fast | target color, ambient light |
| Ultrasonic HC-SR04 | ~2 cm–4 m | ~0.3 cm | tens of ms | soft surfaces, crosstalk, temperature |
| VL53L0X ToF (I²C) | ~3 cm–2 m | ~mm | ms | dark/low-reflectance targets, sunlight |

Because an ultrasonic or ToF unit fires energy and waits, **two of them pointed at the same target can interfere**. In a people-counter or multi-sensor setup, either interleave their firing or budget the timing.

## 📖 Part B — Motion and Orientation

An **IMU** (e.g. MPU6050 at I²C `0x68`) combines:

- an **accelerometer** (measures proper acceleration, including gravity) — good for *static tilt*, noisy for quick motion;
- a **gyroscope** (measures angular velocity) — good for *short-term rotation*, but **drifts** over time due to bias.

Neither alone is enough for orientation. A **complementary filter** blends them: trust the gyro for fast changes and the accelerometer to correct slow drift. (A Kalman filter does the same more rigorously.)

For simple use cases you often do not need full fusion — a tilt angle from the accelerometer, or a gesture from acceleration thresholds, is enough (but say so explicitly in your documentation).

## 📖 Part C — Magnetic Field and Current

- A **Hall-effect** sensor outputs a voltage proportional to magnetic field. Digital **latch** versions switch state at a field polarity — perfect for a light barrier, a flow-meter reed substitute, or a magnetic **door/window** sensor.
- **Current sensing** measures current either with a small **shunt resistor** (voltage across a known resistor; needs a differential amplifier) or with a **Hall-based** sensor (isolated, no shunt loss). This is the basis of an "energy/current monitor" project.

## 📖 Part D — Environment Sensors

- **DS18B20** (OneWire): robust, cheap temperature, addressable in chains, slower.
- **DHT22**: cheap T + RH, slower and with modest accuracy.
- **BME280 / environment modules** (I²C): T + RH + pressure, faster, more accurate — usually the right default for a station.
- Remember the lessons from Modules 2 and 3: these are I²C devices with **addresses and registers**, and they have **time constants** and **self-heating** (a sensor near a hot MCU reads warm — isolate or compensate).

---

## 🛠️ In-Class Lab: Distance and Motion

*Hardware:* VL53L0X (I²C) + MPU6050 (I²C) for the fast path; optionally HC-SR04 and a Hall sensor for the physics path. Ruler or measuring tape as reference.

> [!WARNING]
> Some ultrasonic modules are 5 V devices — check before connecting to 3.3 V logic, and use a level shifter/divider for the echo line if required.

---

### ★ Task 1: Characterize a ToF Sensor (40 min)

1. Mount the VL53L0X firmly and measure against a ruler at **ten known distances** across its range.
2. Record distance-error and repeatability at each point (measure 5× and take the spread).
3. Repeat near the extremes of the range and with a **dark** and a **shiny/angled** target. Note where the sensor becomes unreliable.
4. Produce a short distance-vs-error table and name the **weaknesses** you observed (this is characterization — Module 3 skills applied to a different sensor).

---

### ★ Task 2: Ultrasonic vs. ToF Comparison (30 min)

1. Measure the same targets with an ultrasonic sensor (if available).
2. Compare **accuracy**, **repeatability**, **measuring rate**, **beam shape** (does one see obstacles the other misses?), and **surface sensitivity**.
3. With two ultrasonic units, try to trigger **crosstalk** and describe how you would avoid it in a product.

---

### ★ Task 3: A People Counter / Detector (30 min)

Build the first half of an example project from the announcement:

1. Use **two** distance sensors along a path (or one ToF plus a light barrier) to detect **direction** of passage rather than mere presence.
2. Implement a minimal state machine: count a person only when the two sensors trigger in the correct order within a time window.
3. Test it with a hand/object passing in each direction and log the count.
4. Note the false detections you get and the timing window that reduces them.

*This is the seed of a capstone: "**person counter with several distance sensors**" is a listed example project.*

---

### ★ Task 4: IMU — Tilt, Rotation, Drift (30 min)

1. Read accelerometer and gyroscope raw values from the MPU6050 (I²C address `0x68`).
2. Compute a **tilt angle** from the accelerometer alone. Check it against a spirit level or a protractor.
3. Integrate the gyroscope over a few seconds while the sensor is **static** and show that the angle **drifts**. That is bias.
4. Implement a simple **complementary filter** (e.g. 98 % gyro + 2 % accelerometer per step) and show that drift is corrected.

---

### ◇ Task 5 (Stretcher): Hall-Effect Current Monitor (25 min)

Use a Hall sensor to build a simple current monitor (the announcement lists "**current/power sensor with Hall effect**"):

1. Measure the output with **no current** to establish the offset.
2. Pass a known current through a wire near/by the sensor (a calibrated load, or a known resistor) and record the output change.
3. Compute the sensitivity (mV per ampere) and state the resolution and uncertainty.
4. Alternatively, use a **digital Hall latch** as a light barrier / flow sensor: count pulses and convert to a rate.

---

## 📝 Working-Day Reflection & Portfolio Tasks

In your portfolio under `modules/04-distance-motion/`:
1. **ToF characterization:** distance-error table across the range and under different targets.
2. **Comparison table:** IR/ultrasonic/ToF and your recommendation for two scenarios.
3. **People counter:** state diagram, timing window, observed false detections.
4. **IMU results:** tilt accuracy, observed gyro drift over time, and the effect of your complementary filter.
5. **Reflection:** Why can no single distance principle be "the best"? Give one task where each wins.
