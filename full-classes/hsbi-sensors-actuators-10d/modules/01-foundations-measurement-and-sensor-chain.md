# Module 1 – Foundations: Measurement, Signals & the Sensor–Actuator Chain

[← Back to front page](../README.md) | [Quick module index](./00-index.md) | [Next: Module 2 →](./02-i2c-and-sensor-addressing.md)

**Course placement:** Day 1 — the opening studio. We start with the signal chain, then build the first sensor node in the same session, together and in person.

## 🎯 Learning Goals

This module gives you the opportunity to explore measurement and the digital signal chain and achieve competency in metrology and uncertainty, signal conditioning, and ADC sampling and quantization.

By the end of this module, you can:
1. Describe what a sensor is (a transducer) and how it fits into the full signal chain.
2. Use the vocabulary of measurement correctly: true value, error, uncertainty, accuracy, precision, resolution, range, sensitivity.
3. Explain the digital signal chain: conditioning, ADC, sampling theorem, quantization, coding.
4. Have a first working sensor node deployed with IoTempower and visible on MQTT/Node-RED.
5. Have measured a real ADC and calculated its quantization step.


**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 📖 Story — The Reading That Would Not Sit Still

**Wittkamp Zerspanung GmbH** is a small CNC machine shop in Gütersloh. Plant manager **Kai Lehmann** wants a simple thing: a temperature and vibration node on the oldest milling machine, so the team can see a bearing fail before it scraps a batch. The first prototype works — the serial monitor prints numbers — but the numbers jump, the temperature reads warm when the machine is cold, and nobody trusts the threshold.

Kai asks the question every measurement engineer has to answer: *"What does this number actually mean, and how wrong is it?"* Before you can answer, you need the signal chain: the transducer, the conditioning, the ADC, the sampling, and the coding. That chain is this module.

## 📖 Pod Study: From Transduction to a Trustworthy Number

This is **self/pod study, not a lecture.** Work through the concepts below with your Task Pod, look things up, ask an LLM, and keep notes — the goal is a shared mental model you can defend in the checkpoint.

### Warm-up (in your pod)

Before reading on, answer these in one sentence each:

- What is the difference between a **sensor** and a **transducer**? Give one example you own.
- Your phone reports **23.4 °C**. What would you need to know before calling that a *measurement*?
- Where in the chain from the physical quantity to the display could an error enter?

### ★ Task 0: Form your Task Pod — who do you build with?

You will do the labs and checkpoints in a **Task Pod** of two or three (three by default for a large cohort; pairs are welcome). For the final project, two pods merge into a **Project Team** of 4–6.

1. On a note, write down **your skills** (languages, tools, hardware, design, …) and **your expectations / what you want to build**.
2. No pod yet? Find **two other unpaired people**, compare notes, and check whether you **complement** each other — not merely whether you are alike.
3. Exchange contacts and a first idea today. If you already have a pod, share your notes so the room knows who can help with what.
4. Agree on how you will keep in touch and how you will split roles (who drives, who documents, who asks the next question).

*Portfolio evidence:* your pod's names, skills, and one line on what you want to build.

### What a Sensor Really Is

A sensor is a device that converts one physical quantity into another, more convenient one — usually a voltage, a resistance, a charge, a current, a frequency, or a light intensity. That conversion is called transduction, and the sensor is a transducer.

Useful ways to classify sensors (get used to naming the class of any sensor you meet):

| Axis | Examples from our kit |
|---|---|
| Energy source: active vs. passive | Active: ultrasonic, ToF (emits). Passive: NTC, LDR, thermocouple. |
| Output: analog vs. digital | Analog: NTC voltage divider. Digital: DS18B20, MPU6050, VL53L0X. |
| Measurand: direct vs. indirect | Direct: temperature sensor. Indirect: current via magnetic field, distance via time-of-flight. |
| Physical principle | Resistive, capacitive, inductive, piezo, photoelectric, thermoelectric, magnetic (Hall). |

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

### Measurement Fundamentals

- True value: the value we would obtain with a perfect measurement. We never know it exactly; we estimate it and state an uncertainty.
- Measurement error: measured value − reference value. It can be systematic (offset, gain, temperature drift) or random (noise).
- Measurement uncertainty: a quantified statement of how far our value may be from the true value. "23.4 °C ± 0.3 °C" is a measurement; "23.4 °C" is only a number.
- Accuracy vs. precision: accuracy = closeness to the true value; precision = repeatability of repeated measurements. A precise instrument can be systematically wrong.
- Resolution: the smallest distinguishable change it can report (often set by the ADC and the conditioning). Resolution ≠ accuracy.
- Range / span: the minimum and maximum quantity the sensor is specified for. Outside the range, all bets are off.
- Sensitivity: how much the output changes per unit of input (e.g. mV per °C).

### The Digital Signal Chain

1. Conditioning: a raw sensor rarely matches the ADC. A voltage divider scales a resistance change into a voltage; an amplifier raises a small signal; a filter removes noise or anti-aliases; a reference fixes the conversion baseline.
2. ADC (analog-to-digital converter): compares the conditioned voltage against a reference and returns an integer code.
   - An n-bit ADC gives `2^n` codes over the reference range. A 12-bit ADC on a 3.3 V reference has a step of `3.3 V / 4096 ≈ 0.8 mV`.
   - `value = code × (Vref / 2^n)`.
3. Sampling: to reconstruct a signal, you must sample faster than twice its highest frequency (Nyquist). If you sample too slowly, the signal aliases into a fake, lower frequency.
4. Quantization: rounding to discrete codes introduces a quantization error of up to ±½ LSB. For small signals near one step, this is large — a classic trap.
5. Coding & processing: the MCU scales, filters, and calibrates the code into a physical value with a unit.

> [!TIP]
> The ESP32 has a 12-bit ADC with a non-linear region near the rails and some channel-to-channel variation. Its absolute accuracy is far worse than its resolution — a perfect illustration of this module. In Module 3 you will calibrate around exactly this.

### Pointers (start here, then keep looking)

- Measurement vocabulary — [Wikipedia: Measurement](https://en.wikipedia.org/wiki/Measurement), [Accuracy and precision](https://en.wikipedia.org/wiki/Accuracy_and_precision)
- The signal chain and ADCs — [Wikipedia: Analog-to-digital converter](https://en.wikipedia.org/wiki/Analog-to-digital_converter), [Sampling (signal processing)](https://en.wikipedia.org/wiki/Sampling_(signal_processing)), [Nyquist–Shannon sampling theorem](https://en.wikipedia.org/wiki/Nyquist%E2%80%93Shannon_sampling_theorem)
- The ESP32 ADC in practice — [Espressif ADC documentation](https://docs.espressif.com/projects/arduino-esp32/en/latest/api/adc.html) (note the non-linearity and attenuation)
- Simulate before you wire — [Wokwi](https://wokwi.com/) (the pre-study tool)
- Your kit's datasheets — linked from the [resource bank](./Z-resources-bank.md#datasheets--standards-to-read-once)

### Questions to ask an LLM (then verify against your hardware)

Ask your co-pilot — but treat every answer as a **claim to test**, not a fact. Good starting prompts:

- "I am a 3rd-semester engineering student. Explain **very briefly** what a sensor, a transducer, and signal conditioning are, with **simple examples**, and tell me how to explain the chain to a peer."
- "A 12-bit ADC has a 3.3 V reference. What is the ideal step size, and why is the real ESP32 accuracy worse than that? Give me a measurement I can run to see the difference."
- "My temperature reading jumps by 0.8 °C between samples. List the possible causes in the chain and one experiment for each."
- "Explain quantization error and aliasing with a concrete example from a slow temperature sensor and a fast vibration sensor."
- "What is the difference between resolution, accuracy, and precision? Give one example where a sensor is precise but inaccurate."

> Run each prompt against your own circuit, and record where the model is wrong, vague, or over-confident.

### ★ Task A: Study in your pod

Work through the concepts above with your Task Pod and fill in `module-01/study-log.md`:

1. **The references you used** — the source and the one concept you understood best from it.
2. **Things you googled** — the term, what you found, and the source (URL). One line each.
3. **Remarkable things** — surprises, "aha"s, and counterexamples from your own readings.
4. **LLM Q&A** — for each prompt: the prompt, a 2–3 line summary, and **how you verified it** (and where it was wrong).
5. **Your two best found explanations or diagrams** — compile down to the best two, with source and what they taught you.

*Portfolio evidence:* `module-01/study-log.md`.

### ★ Task B: Explain & share with another pod

Pair with a **neighbouring pod**:

1. **Explain to each other** — each pod walks the other through its study log and its chain diagram; ask questions and fill each other's gaps.
2. Agree on the **3–5 most noteworthy points** and the **learning you jointly stand behind** (e.g. *"resolution is not accuracy"*).
3. **Clean up your documentation** — update your `study-log.md` with what you learned from the other pod.
4. Agree on **one shared artefact** — the best diagram, a measurement table, or a new sketch the two pods make together — and **post it in the course Discord**, with a one-sentence note on why you chose it.
5. Each member adds a short **“Agreed learning (pod discussion)”** section to *their own* `study-log.md`.

*Portfolio evidence:* your cleaned-up `study-log.md` (with the **“Agreed learning (pod discussion)”** section) and your pod-pair's shared artefact.

## 🛠️ In-Class Lab: From Blink to Measurement — **Challenging**

*Hardware:* 1× M5Stack node (or ESP32 DevKit / ESP32 Ethernet mini kit / Wemos D1 Mini + breadboard), 1× potentiometer, a local broker/gateway with Mosquitto + Node-RED, multimeter.

### ★ Task 1: Master Class — A First Sensor Node

The goal is to experience the complete loop immediately, using the fast path.

1. Power up your local gateway/broker (a small OpenWrt router or Linux/Raspberry Pi host running Mosquitto + Node-RED; ≥2 A USB supply — not your laptop port). Connect your laptop and open the Node-RED dashboard.
2. Deploy an IoTempower node: in a fresh system, declare a node with a Grove environment or light sensor, for example:
   ```cpp
   // setup.cpp — declarative IoTempower node
   i2c(0, "Grove");
   temperature(temp, "ENV");
   humidity(hum, "ENV");
   ```
   Flash it once over USB (`iot flash`), then verify it connects and appears in MQTT.
3. Watch the value on the Node-RED dashboard and in MQTT Explorer under the node's topic.
4. Breathe on the sensor, shade it, or warm it, and observe the value move. Note how long it takes to react — that is a dynamic characteristic you will quantify later.

*Portfolio:* screenshot of the node's MQTT topics plus the dashboard receiving live values.

### ★ Task 2: The ADC Precision Dance

*Work in pairs; one person measures, the other records.*

1. Wire a potentiometer as a voltage divider into an analog input of an ESP32 (ESP32 has 12-bit ADCs; ESP8266 has 10-bit).
2. Print the raw code, and also the scaled voltage using your assumed `Vref`, in `setup()`/`loop()` and watch it in the Serial Plotter.
3. Slowly turn the potentiometer across its full range and record:
   - the minimum and maximum raw codes you observe,
   - the number of distinct steps in the full sweep,
   - the code-to-code step size in volts.
4. Compare the observed step size with your calculated `Vref / 2^n`. Explain any difference between the two ends of the range.
5. Change the resolution (for example to 10 bits) and repeat. What changed — resolution, accuracy, or both?
6. Cross-check with a multimeter: measure the potentiometer's output with the multimeter at several positions and compare it with the MCU's reading. Note any offset or gain error.

> **Document the failure worth having:** the flat/erratic regions near 0 V and 3.3 V. This is where the ESP32 ADC is least trustworthy — remember it in Module 3.

### ★ Task 3: Draw Your Own Chain

Pick one sensor from the kit (NTC, LDR, VL53L0X, MPU6050, DS18B20). Draw the full chain for it: physical quantity → transducer principle → conditioning (if any) → interface (analog? I²C?) → MCU processing → system use. Label where error and noise enter.

### ◇ Task 4 (Stretcher): Resolution vs. Reality

Reduce the ADC to the smallest signal change you can measure at the top of the range and at the bottom. Where is the effective resolution worst, and why? Propose one conditioning change (e.g. an op-amp, a better reference, or a different divider ratio) that would improve it.

## ✅ Suggested portfolio evidence (proofs of the learning goals)

Your portfolio only needs to **prove this module's learning goals**. The items below are **suggested proofs** — commit them if they fit, or demonstrate the same goals your own way. (Under `module-01/`.)
- A pod-formation note: names, skills, and one line on what you want to build.
1. Chain diagram for your own sensor, with error/noise sources marked.
2. ADC table: observed raw range, number of steps, step size in volts, and comparison with the theoretical value for at least two resolutions.
3. Master Class proof: Node-RED/MQTT screenshot of your first sensor node.
4. Vocabulary: define, in your own words, accuracy, precision, resolution, sensitivity, and uncertainty, each with one example.
5. Reflection: Why can a sensor with high resolution still give an inaccurate measurement? Which link of the chain is responsible in your example?

### Reflection logbook

Write one entry for this teaching block in `reflection.md`: *What worked? What broke? How did my mental model shift? How did I verify AI suggestions?*

> [!IMPORTANT]
> Never commit secrets, credentials, or personal data. Where you did not work entirely alone, link your pod mates and sources.

## 📚 If you want to go deeper

- [Wikipedia: Measurement](https://en.wikipedia.org/wiki/Measurement) and [Accuracy and precision](https://en.wikipedia.org/wiki/Accuracy_and_precision) — the vocabulary, with examples.
- [Wikipedia: Analog-to-digital converter](https://en.wikipedia.org/wiki/Analog-to-digital_converter) — resolution, quantization, and conversion architectures.
- [Nyquist–Shannon sampling theorem](https://en.wikipedia.org/wiki/Nyquist%E2%80%93Shannon_sampling_theorem) — why sampling too slowly invents frequencies.
- [Espressif ADC documentation](https://docs.espressif.com/projects/arduino-esp32/en/latest/api/adc.html) — the real limits of the ESP32 ADC.
- [Wokwi](https://wokwi.com/) — simulate the chain before you wire it.

---

[← Course workbook](../README.md) | [Quick module index](./00-index.md) | [Next: Module 2 — I²C & Sensor Addressing →](./02-i2c-and-sensor-addressing.md)
