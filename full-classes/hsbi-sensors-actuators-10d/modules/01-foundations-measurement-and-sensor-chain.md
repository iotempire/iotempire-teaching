# Module 1 – Foundations: Measurement, Signals & the Sensor–Actuator Chain

[← Back to front page](../README.md) | [Quick module index](./00-index.md) | [Next: Module 2 →](./02-i2c-and-sensor-addressing.md)

> **One question for the whole course:** *How does a physical quantity become a trustworthy number — and how does that number move the world?*

---

## 🎯 Learning Goals

> **How these are assessed:** You earn this module's points by **proving these goals** in a short (~10-minute) checkpoint presentation with the instructor (see the [syllabus](../syllabus.md#how-module-points-are-earned-checkpoint-presentations)) — based on your portfolio and reflections, not on completing every task. You may skip tasks, fail at some, or add your own; documented exploration and demonstrated deep understanding both count in your favor.

This module gives you the opportunity to explore **measurement and the digital signal chain** and achieve competency in **metrology and uncertainty, signal conditioning, and ADC sampling and quantization**.

By the end of this module, you can:
1. Describe what a sensor is (a **transducer**) and how it fits into the full signal chain.
2. Use the vocabulary of measurement correctly: true value, error, uncertainty, accuracy, precision, resolution, range, sensitivity.
3. Explain the **digital signal chain**: conditioning, ADC, sampling theorem, quantization, coding.
4. Have a first working sensor node deployed with **IoTempower** and visible on MQTT/Node-RED.
5. Have measured a real ADC and calculated its quantization step.

> [!NOTE]
> **Task tiers.** Tasks marked **★ Core** must be completed by everyone. Tasks marked **◇ Stretcher** are optional and are the natural trim point if time runs short — they are excellent bonus-task material.

> [!WARNING]
> **DRAFT — first taught in WS 2026/27.** Everything below this line is a working draft and will likely change as we refine it together in class; the line moves down as we approve content. Your input is welcome and can shape this module.

**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

---

## 📖 Part A — What a Sensor Really Is

A **sensor** is a device that converts one physical quantity into another, more convenient one — usually a voltage, a resistance, a charge, a current, a frequency, or a light intensity. That conversion is called **transduction**, and the sensor is a **transducer**.

Useful ways to classify sensors (get used to naming the class of any sensor you meet):

| Axis | Examples from our kit |
|---|---|
| **Energy source:** active vs. passive | Active: ultrasonic, ToF (emits). Passive: NTC, LDR, thermocouple. |
| **Output:** analog vs. digital | Analog: NTC voltage divider. Digital: DS18B20, MPU6050, VL53L0X. |
| **Measurand:** direct vs. indirect | Direct: temperature sensor. Indirect: current via magnetic field, distance via time-of-flight. |
| **Physical principle** | Resistive, capacitive, inductive, piezo, photoelectric, thermoelectric, magnetic (Hall). |

### The chain you must always be able to draw

```text
physical quantity
        |
        v
  transducer (sensor)
        |
        v
  signal conditioning
  (amplifier, divider,
   filter, reference)
        |
        v
  ADC + MCU
  (sample, filter, calibrate)
        |
        v
  system
  (MQTT, Node-RED, dashboard)
        |
        |  command
        |  (PWM / driver)
        v
  actuator
  (acts on the world)
```

Every lab in this course is one link of this chain. When something does not work, ask *which link* is failing: the physics, the conditioning, the conversion, the calculation, or the system.

---

## 📖 Part B — Measurement Fundamentals

- **True value:** the value we would obtain with a perfect measurement. We never know it exactly; we estimate it and state an uncertainty.
- **Measurement error:** measured value − reference value. It can be **systematic** (offset, gain, temperature drift) or **random** (noise).
- **Measurement uncertainty:** a quantified statement of how far our value may be from the true value. "23.4 °C ± 0.3 °C" is a measurement; "23.4 °C" is only a number.
- **Accuracy vs. precision:** accuracy = closeness to the true value; precision = repeatability of repeated measurements. A precise instrument can be systematically wrong.
- **Resolution:** the smallest distinguishable change it can report (often set by the ADC and the conditioning). Resolution ≠ accuracy.
- **Range / span:** the minimum and maximum quantity the sensor is specified for. Outside the range, all bets are off.
- **Sensitivity:** how much the output changes per unit of input (e.g. mV per °C).

---

## 📖 Part C — The Digital Signal Chain

1. **Conditioning:** a raw sensor rarely matches the ADC. A **voltage divider** scales a resistance change into a voltage; an amplifier raises a small signal; a filter removes noise or anti-aliases; a reference fixes the conversion baseline.
2. **ADC (analog-to-digital converter):** compares the conditioned voltage against a reference and returns an integer code.
   - An **n-bit** ADC gives `2^n` codes over the reference range. A 12-bit ADC on a 3.3 V reference has a step of `3.3 V / 4096 ≈ 0.8 mV`.
   - `value = code × (Vref / 2^n)`.
3. **Sampling:** to reconstruct a signal, you must sample faster than twice its highest frequency (**Nyquist**). If you sample too slowly, the signal **aliases** into a fake, lower frequency.
4. **Quantization:** rounding to discrete codes introduces a **quantization error** of up to ±½ LSB. For small signals near one step, this is large — a classic trap.
5. **Coding & processing:** the MCU scales, filters, and calibrates the code into a physical value with a unit.

> [!TIP]
> The ESP32 has a **12-bit** ADC with a **non-linear** region near the rails and some channel-to-channel variation. Its absolute accuracy is far worse than its resolution — a perfect illustration of this module. In Module 3 you will calibrate around exactly this.

---

## 🛠️ In-Class Lab: From Blink to Measurement

*Hardware:* 1× M5Stack node (or ESP32 DevKit / ESP32 Ethernet mini kit / Wemos D1 Mini + breadboard), 1× potentiometer, a local broker/gateway with Mosquitto + Node-RED, multimeter.

---

### ★ Task 1: Master Class — A First Sensor Node (45 min)

The goal is to experience the complete loop immediately, using the fast path.

1. **Power up your local gateway/broker** (a small OpenWrt router or Linux/Raspberry Pi host running Mosquitto + Node-RED; ≥2 A USB supply — not your laptop port). Connect your laptop and open the Node-RED dashboard.
2. **Deploy an IoTempower node:** in a fresh system, declare a node with a Grove environment or light sensor, for example:
   ```cpp
   // setup.cpp — declarative IoTempower node
   i2c(0, "Grove");
   temperature(temp, "ENV");
   humidity(hum, "ENV");
   ```
   Flash it once over USB (`iot flash`), then verify it connects and appears in MQTT.
3. **Watch the value** on the Node-RED dashboard and in MQTT Explorer under the node's topic.
4. **Breathe on the sensor**, shade it, or warm it, and observe the value move. Note how long it takes to react — that is a dynamic characteristic you will quantify later.

*Portfolio:* screenshot of the node's MQTT topics plus the dashboard receiving live values.

---

### ★ Task 2: The ADC Precision Dance (45 min)

*Work in pairs; one person measures, the other records.*

1. Wire a **potentiometer** as a voltage divider into an analog input of an ESP32 (ESP32 has 12-bit ADCs; ESP8266 has 10-bit).
2. Print the raw code, and also the scaled voltage using your assumed `Vref`, in `setup()`/`loop()` and watch it in the **Serial Plotter**.
3. Slowly turn the potentiometer across its full range and record:
   - the minimum and maximum raw codes you observe,
   - the number of distinct steps in the full sweep,
   - the **code-to-code step size** in volts.
4. Compare the observed step size with your calculated `Vref / 2^n`. Explain any difference between the two ends of the range.
5. **Change the resolution** (for example to 10 bits) and repeat. What changed — resolution, accuracy, or both?
6. **Cross-check with a multimeter:** measure the potentiometer's output with the multimeter at several positions and compare it with the MCU's reading. Note any **offset** or **gain error**.

> **Document the failure worth having:** the flat/erratic regions near 0 V and 3.3 V. This is where the ESP32 ADC is least trustworthy — remember it in Module 3.

---

### ★ Task 3: Draw Your Own Chain (20 min)

Pick one sensor from the kit (NTC, LDR, VL53L0X, MPU6050, DS18B20). Draw the full chain for it: physical quantity → transducer principle → conditioning (if any) → interface (analog? I²C?) → MCU processing → system use. Label where error and noise enter.

---

### ◇ Task 4 (Stretcher): Resolution vs. Reality (20 min)

Reduce the ADC to the smallest signal change you can measure at the top of the range and at the bottom. Where is the effective resolution worst, and why? Propose one conditioning change (e.g. an op-amp, a better reference, or a different divider ratio) that would improve it.

---

## 📝 Working-Day Reflection & Portfolio Tasks

In your portfolio under `modules/01-foundations/`:
1. **Chain diagram** for your own sensor, with error/noise sources marked.
2. **ADC table:** observed raw range, number of steps, step size in volts, and comparison with the theoretical value for at least two resolutions.
3. **Master Class proof:** Node-RED/MQTT screenshot of your first sensor node.
4. **Vocabulary:** define, in your own words, accuracy, precision, resolution, sensitivity, and uncertainty, each with one example.
5. **Reflection:** Why can a sensor with high resolution still give an inaccurate measurement? Which link of the chain is responsible in your example?
