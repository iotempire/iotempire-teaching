# Module 1 – Foundations: Electronics, Arduino & Measurement

[← Back to front page](../README.md) | [Quick module index](./00-index.md) | [Next: Module 2 →](./02-i2c-and-sensor-addressing.md)

**Course placement:** Day 1 — the opening studio. We start with basic electronics, then move quickly to the Arduino IDE, the serial console, and measurement.

> **Session 1 opening:** the first part of Day 1 is presented from the plain-Markdown deck [`slides/01-introduction.md`](../slides/01-introduction.md). It covers who we are, your first in-class portfolio notes, how the course and the online workbook work, a rehash of the pre-study, and the hand-over to the tasks below. Read it in any Markdown viewer, or render a 16:9 PDF with [`slides/render-slides.sh`](../slides/render-slides.sh) (pandoc + Typst) and present it fullscreen.

## 🎯 Learning Goals

This module gives you the opportunity to explore basic electronics, Arduino input/output, and the digital signal chain, and achieve competency in metrology and uncertainty, signal conditioning, and ADC sampling and quantization.

By the end of this module, you can:
1. Describe what a sensor is (a transducer) and how it fits into the full signal chain.
2. Use the vocabulary of measurement correctly: true value, error, uncertainty, accuracy, precision, resolution, range, sensitivity.
3. Explain the digital signal chain: conditioning, ADC, sampling theorem, quantization, coding.
4. Wire and drive a simple actuator safely (an LED with a current-limiting resistor, or a relay module) and read a digital sensor (a button with a pull-up or pull-down).
5. Explain contact bounce, observe it, and mitigate it in software and/or hardware.
6. Use the Arduino IDE and serial console (Serial Monitor/Plotter) to inspect, log, and visualize data.
7. Have measured a real ADC and calculated its quantization step.
8. Have read an LDR and applied a first filter (moving average, median, and cutoff) to a noisy signal.


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

You will do the labs and checkpoints in a **Task Pod** of **two** (pairs by default; a third podmate only by arrangement). For the final project, two pods merge into a **Project Team** of 4–6.

1. On a note, write down **your skills** (languages, tools, hardware, design, …) and **your expectations / what you want to build**.
2. No pod yet? Find **one other unpaired person**; a third podmate is only by arrangement. Compare notes and check whether you **complement** each other — not merely whether you are alike.
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
  (logging, visualization,
   control logic)
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
- Arduino input/output and serial — [Arduino: Digital Read Serial](https://docs.arduino.cc/built-in-examples/basics/DigitalReadSerial/), [Arduino: Analog Read Serial](https://docs.arduino.cc/built-in-examples/basics/AnalogReadSerial/), [Arduino IDE Serial Monitor/Plotter](https://docs.arduino.cc/software/ide-v2/tutorials/ide-v2-serial-monitor/)
- Debouncing — [Wikipedia: Switch](https://en.wikipedia.org/wiki/Switch#Contact_bounce) (contact bounce)
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

Work through the concepts above with your Task Pod and fill in `Module01/study-log.md`:

1. **The references you used** — the source and the one concept you understood best from it.
2. **Things you googled** — the term, what you found, and the source (URL). One line each.
3. **Remarkable things** — surprises, "aha"s, and counterexamples from your own readings.
4. **LLM Q&A** — for each prompt: the prompt, a 2–3 line summary, and **how you verified it** (and where it was wrong).
5. **Your two best found explanations or diagrams** — compile down to the best two, with source and what they taught you.

*Portfolio evidence:* `Module01/study-log.md`.

### ★ Task B: Explain & share with another pod

Pair with a **neighbouring pod**:

1. **Explain to each other** — each pod walks the other through its study log and its chain diagram; ask questions and fill each other's gaps.
2. Agree on the **3–5 most noteworthy points** and the **learning you jointly stand behind** (e.g. *"resolution is not accuracy"*).
3. **Clean up your documentation** — update your `study-log.md` with what you learned from the other pod.
4. Agree on **one shared artefact** — the best diagram, a measurement table, or a new sketch the two pods make together — and **post it in the course Discord**, with a one-sentence note on why you chose it.
5. Each member adds a short **“Agreed learning (pod discussion)”** section to *their own* `study-log.md`.

*Portfolio evidence:* your cleaned-up `study-log.md` (with the **“Agreed learning (pod discussion)”** section) and your pod-pair's shared artefact.

## 🛠️ In-Class Lab: From Blink to Measurement — **Challenging**

*Hardware:* 1× M5Stack node and/or a raw ESP board (ESP32 DevKit / ESP32 Ethernet mini kit / Wemos D1 Mini), breadboard and jumper wires, 1× LED + 220–330 Ω resistor, 1× push button, **2× 10 kΩ resistors** (one for the button — or use the internal pull-up — and one fixed resistor for the LDR divider), 1× 100 nF capacitor (optional, for hardware debounce), 1× potentiometer, 1× LDR, optional relay module for a low-voltage load, multimeter.

> **Optional RC-filter parts (for the optional subtasks):** 1× 1 µF and 1× 10 µF film/ceramic capacitors (if electrolytic, observe polarity), 1× 100 nF, 1× 100 µF (electrolytic is fine; observe polarity), 1× 100 kΩ, and **4× 10 kΩ resistors in total for the high-pass experiment** (two more than the core kit); the low-pass can reuse one. A second GPIO (for a clean square wave) or a button (for a manual step) can serve as the signal source.

> **Suggested pacing (4 h):** opening/pods ~45–60 min → Task 1 ~40 min (or a quick skip check) → Task 2 ~25 min → Task 3 ~35 min → Tasks 4–5 ~45 min → chain/evidence ~20 min. If time runs short, carry Task 4–5 into self-study/portfolio time — that is expected, not a failure; the optional subtasks are stretch.

> **Board note:** the ADC and breadboard tasks are easiest on a raw ESP32/ESP8266 DevKit. On a M5Stack, use the Grove/breakout pins and check which ones are ADC-capable; the logic is the same. Always check your board's pinout before wiring.

### ★ Task 1: Basic Electronics — LED, Button, Pull-up/Pull-down

> [!NOTE]
> **Know this already?** You may skip this task. Add a short note to your portfolio explaining where you learned it (a previous course, project, or job) and demonstrate the two key skills in a quick instructor check: light an LED through a current-limiting resistor, and read a button with a defined pull-up or pull-down. If you cannot show both, do the task.

1. **Breadboard and GPIO basics.** Learn which breadboard rows are connected, where the power rails are, and that every circuit needs a common ground. All boards here use 3.3 V logic: never connect 3.3 V directly to GND, and never put 5 V on a 3.3 V input.
2. **An LED is an actuator.** Wire a GPIO pin → **220–330 Ω resistor** → LED anode → LED cathode → GND. Calculate the resistor with `R = (Vs − Vf) / I` for `Vs = 3.3 V`, a typical `Vf` for your LED, and `I ≈ 5–10 mA`. For a blue/white LED with a higher `Vf`, recalculate — the same resistor gives a much smaller current. Test it from the 3.3 V pin, or by driving a GPIO high with the `Blink` example. Never connect an LED directly across the supply without a resistor: the GPIO commands the LED, it does not safely limit its current.
3. **Relay alternative (optional).** If you want to switch a load instead of lighting an LED, use a **relay module** with its own driver (often opto-isolated) — never a bare relay coil from a GPIO. Connect `VCC`, `GND`, and `IN` as labeled, check whether the module needs 5 V and whether it triggers reliably from 3.3 V logic, and switch only a **low-voltage load** in this lab. Never switch mains voltage.
4. **A button is a digital sensor — with two valid wirings.**
   - **Pull-up:** resistor (or the MCU's internal `INPUT_PULLUP`) from the GPIO to 3.3 V; button from the GPIO to GND. Released = `HIGH`, pressed = `LOW`.
   - **Pull-down:** resistor from the GPIO to GND; button from the GPIO to 3.3 V. Released = `LOW`, pressed = `HIGH`.
   Draw both. Explain why an input must never float, and why an external 10 kΩ resistor can be more robust than the internal pull-up in a noisy or long-wire setup.
5. Read the button with `digitalRead()` and use it to toggle the LED. Print both states to the serial console.
6. **Experience bouncing.** Count button transitions in your loop (or with an interrupt) and print the count. Press the button once and watch: a mechanical contact often produces several edges within a few milliseconds. Make it more obvious with a worn button or longer wires; after Module 2 you can also capture the raw edge with the class scope/analyzer.
7. **Mitigate bouncing.** First add a software debounce (ignore new edges for 20–50 ms after a change). Then try a hardware variant: a **100 nF capacitor from the input node to GND** together with the 10 kΩ pull-up gives an RC time constant of about 1 ms; a Schmitt-trigger buffer (for example 74HC14 — note that it is **inverting**) produces even cleaner edges. Compare the raw and debounced counts.

#### ◇ Optional sub-task 1a: The RC low-pass hiding in your debounce circuit

The button's 10 kΩ pull-up plus 100 nF capacitor is already an analog low-pass filter:

```text
τ = R · C = 10 kΩ · 100 nF = 1 ms
fc = 1 / (2πRC) ≈ 159 Hz
```

It slows the edge and suppresses fast bounce. Too large an RC makes the button feel sluggish; too small lets bounce through.

> **RC asymmetry:** closing the button discharges the capacitor quickly through the switch; opening it charges the capacitor through the pull-up. That is still a useful low-pass, but for a more symmetric filter put a resistor in series before the capacitor.

**Experiment — RC low-pass (if the parts are available):**

- **Parts:** 1× 10 kΩ, 1× 1 µF ceramic/film capacitor, optional 1× 100 nF, breadboard, a GPIO square-wave source.
- Wire: GPIO square wave (start at 10 Hz) → 10 kΩ → output node → 1 µF → GND. Measure the output node with an ADC input. Generate the square wave with `tone()`/LEDC or a simple `millis()` toggle on a second GPIO.
- Here `τ = 10 ms` and `fc ≈ 16 Hz`: the 10 Hz square wave should come out rounded and smoothed, and high-frequency noise is reduced. Swap the capacitor to 100 nF (`fc ≈ 159 Hz`) and compare. If you have the Module 2 scope/analyzer, capture input and output together.
- **ADC tip:** a 0–3.3 V square wave sits in the ESP32 ADC's least linear regions. For the ADC version, attenuate the input (for example with a 10 kΩ/10 kΩ divider to about 0–1.65 V; the divider adds source resistance, so the cutoff shifts a little) or use the Module 2 scope/analyzer.
- **Slow version with a multimeter (no scope):** 100 kΩ + 100 µF gives `τ = 10 s`. Charge from 3.3 V, measure the capacitor voltage every second, plot `V(t)`, and estimate `τ`. Use a film/ceramic capacitor if possible; with an electrolytic, observe polarity.

**AI prompts to deepen it:**

- “Explain an RC low-pass filter for a student: what `τ = RC` and `fc = 1/(2πRC)` mean, and why a button debounce capacitor is a low-pass.”
- “I have a 10 kΩ resistor and a 1 µF capacitor. What is the cutoff frequency, and what will a 10 Hz square wave look like at the output?”
- “How do I choose R and C so a button debounce is fast enough for a human but slow enough to suppress contact bounce?”

**Pointers:** [RC circuit](https://en.wikipedia.org/wiki/RC_circuit), [Low-pass filter](https://en.wikipedia.org/wiki/Low-pass_filter), [RC time constant](https://en.wikipedia.org/wiki/RC_time_constant), [Falstad circuit simulator](https://www.falstad.com/circuit/).

> [!TIP]
> **Optional electronic-prototyping refresher.** If breadboards, LEDs, resistors, or buttons are new to you, work through the matching tasks in the MCU programming class: [Breadboards and electronic prototyping](../../hsbi-MCU-programming-10d/modules/02-hardware-and-basic-electronics.md#task-1--breadboards-and-electronic-prototyping-intro), [Hello World prototyping](../../hsbi-MCU-programming-10d/modules/02-hardware-and-basic-electronics.md#task-3--hello-world-electronic-prototyping), [Blink](../../hsbi-MCU-programming-10d/modules/02-hardware-and-basic-electronics.md#task-5--blink-on-the-wemos-d1-mini), and [toggle an LED with a button](../../hsbi-MCU-programming-10d/modules/02-hardware-and-basic-electronics.md#task-6--toggle-led-with-button). The short breadboard video there is [youtu.be/yXirMBP3x4U](https://youtu.be/yXirMBP3x4U) and the blink video is [youtu.be/2nN_ZVyWLzg](https://youtu.be/2nN_ZVyWLzg).

*Portfolio:* a wiring photo or schematic, your resistor calculation, the pull-up/pull-down explanation, and the button counts before and after debouncing.

### ★ Task 2: Arduino IDE, Serial Console, and Visualization

1. Install or open **Arduino IDE 2**, install the board core for your ESP32/ESP8266, and select the correct board and serial port. If you already use PlatformIO, the same steps apply there.
2. Load `Blink`, change the pin to your external LED, and flash it. Confirm that your toolchain and upload path work before adding sensors.
3. Open the **Serial Monitor** at `115200` baud. Print short, structured lines that are easy to read and parse, for example:
   ```text
   t=1234 button=1 led=0
   ```
4. Open the **Serial Plotter** and plot the button state and, later, analog values. Separate multiple traces with spaces, tabs, or commas; for named traces use `name:value` with **no space after the colon**.
   > **Tool choice:** the baseline is the Arduino IDE 2 Serial Plotter. If you already have a better local plotting setup — for example PlatformIO with Teleplot, or Python with `pyserial` and `matplotlib` — use that instead and document which tool you used.
5. Measure your loop interval (`millis()` before and after, or print every N ms) and note how the sampling rate changes when you add `Serial.print()` calls or a `delay()`.
6. Compare `delay()` with a `millis()`-based loop: a blocking delay stops you from reading the button and refreshing the display while it waits. Keep the console responsive with non-blocking timing.

*Portfolio:* a serial log or screenshot, a plot of at least one signal, the tool you used, and a note on your loop timing.

### ★ Task 3: The ADC Precision Dance

*Work in pairs; one person measures, the other records.*

1. Wire a potentiometer as a voltage divider into an analog input of an ESP32 (ESP32 has 12-bit ADCs; ESP8266 has 10-bit).
2. Print the raw code, and also the scaled voltage using your assumed `Vref`, in `setup()`/`loop()` and watch it with the plotting tool you chose in Task 2 (Arduino IDE Serial Plotter by default).
3. Slowly turn the potentiometer across its full range and record:
   - the minimum and maximum raw codes you observe,
   - the number of distinct steps in the full sweep,
   - the code-to-code step size in volts.
4. Compare the observed step size with your calculated `Vref / 2^n`. Explain any difference between the two ends of the range.
5. Change the resolution and repeat. On classic ESP32, `analogReadResolution()` can change the SAR hardware resolution between 9 and 12 bits; the ESP8266 is fixed at 10 bits, so use an ESP32 for this comparison. What changed — resolution, accuracy, or both?
6. Cross-check with a multimeter: measure the potentiometer's output with the multimeter at several positions and compare it with the MCU's reading. Note any offset or gain error.

> **Document the failure worth having:** the flat/erratic regions near 0 V and above roughly 3.1 V. Keep signals away from the extremes — many classic ESP32 boards are most linear roughly between 0.15 V and 2.9 V. This is where the ESP32 ADC is least trustworthy — remember it in Module 3.

### ★ Task 4: An Analog Light Sensor — the LDR

Now repeat the ADC exercise with a sensor whose resistance depends on light: a light-dependent resistor (LDR). An LDR's resistance typically **decreases** as light increases.

1. Build a voltage divider: 3.3 V → LDR → measurement node → 10 kΩ → GND (or swap the LDR and the fixed resistor — decide which gives the larger voltage change in the light range you care about). Connect the measurement node to an analog input.
2. Read the raw code and the voltage. Cover the LDR, shade it, and expose it to room light and a phone flashlight. Record the raw-code range, the voltage range, and how repeatable the same condition is.
3. Convert voltage back to an approximate LDR resistance. For the orientation above:
   ```text
   Vout = Vref · R_fixed / (R_LDR + R_fixed)
   R_LDR = R_fixed · (Vref − Vout) / Vout
   ```
   Show one worked example and state the assumptions.
4. Note the LDR's limitations: it is slow (response time matters when light changes quickly), nonlinear, and temperature-dependent. This is exactly the kind of sensor you will characterize and calibrate in Module 3.
5. Record at least three conditions (dark, shade, bright) with several repeated readings each — you will use this data in the next task.

*Portfolio:* LDR divider schematic/photo, raw and voltage table, one resistance calculation, and a note on repeatability.

### ★ Task 5: First Filtering — Average, Median, and Cutoff

Raw ADC values are noisy. Try three simple ideas on the same LDR data (or on the potentiometer if you prefer a stable signal):

1. **Moving average:** keep the last `N` samples (start with 5, then 10 and 20) and print or plot their mean. Observe that noise falls but the signal lags: the output settles in about `N` samples, and the group delay is about `(N−1)/2` samples.
2. **Median:** keep the last `N` samples and output the middle value. Introduce a deliberate single spike (cover/uncover the LDR, or tap the potentiometer) and compare the median with the average. The median should reject the spike; the average smears it across the window.
3. **Cutoff:** use two complementary ideas:
   - **Outlier cutoff / validity gate:** discard samples outside a plausible band (for example below 5 % or above 95 % of the expected range, or more than a chosen deviation from the running median) before filtering. This prevents one broken reading from poisoning the average.
   - **Low-pass cutoff:** the window length sets how fast the filter follows changes. A longer window gives a lower cutoff frequency: more noise rejection, more lag. State the trade-off for your signal.
4. Compare raw, average, median, and cutoff/gated output on the same plot or serial log. For each, state what it fixes and what it costs.
5. Optional: implement an exponential moving average (EMA) with `y += alpha * (x - y)`, and explain how `alpha` plays the role of a cutoff.

> **Optional filter toolbox.** These subtasks go beyond the core task. Do them if you have time and the parts; document what you tried. The analog experiments are easier after Module 2, when the class scope/analyzer exists, but a slow RC step response can be measured with a multimeter.

#### ◇ Optional sub-task 5a: Software hysteresis and dead-zone

A single threshold chatters when the signal sits near it. **Hysteresis** uses two thresholds; a **dead-zone** ignores changes inside a band. Both are tiny state machines.

1. Use the LDR or potentiometer. Switch an LED at one threshold and watch it chatter near the boundary.
2. **Hysteresis:** turn on above e.g. 2200, turn off below 1800, and keep the previous state in a variable.
3. **Dead-zone:** update the output only when `abs(x - last_output) > band`.
4. Compare chatter, response lag, and how the band size trades noise immunity for sensitivity.

**AI prompts to deepen it:**

- “Show a minimal Arduino state machine for hysteresis with two thresholds and explain how to choose them.”
- “What is the difference between hysteresis, a dead band, and a dead-zone filter? Give one sensor example each.”
- “My LDR reading flickers around the threshold. Propose a hysteresis rule and a dead-zone rule and explain the trade-offs.”

**Pointers:** [Hysteresis](https://en.wikipedia.org/wiki/Hysteresis), [Deadband](https://en.wikipedia.org/wiki/Deadband).

#### ◇ Optional sub-task 5b: Software low-pass and high-pass

A first-order low-pass is just `y += alpha * (x - y)` (the EMA). Smaller `alpha` gives a lower cutoff, more smoothing, and more lag. A high-pass can be made by subtracting the low-pass: `hp = x - lp` — it removes slow drift/DC and keeps changes and edges.

1. Low-pass the LDR or potentiometer; tune `alpha` and observe noise versus lag.
2. High-pass it with `hp = x - lp` and wave your hand over the LDR or tap the potentiometer: slow lighting changes disappear; fast changes remain.
3. Estimate the relationship between `alpha`, sample interval `dt`, and cutoff. For small `alpha`, `fc ≈ alpha / (2π·dt)`; more exactly, `fc = −ln(1−alpha) / (2π·dt)`. State the assumptions.

**AI prompts to deepen it:**

- “Derive the first-order IIR low-pass `y += alpha*(x-y)` and relate `alpha` to an RC cutoff frequency and the sample interval.”
- “How do I make a high-pass from a low-pass in software? Show the equation and a sensor example.”
- “Compare moving average, median, EMA low-pass, and high-pass for a noisy LDR signal.”

**Pointers:** [Low-pass filter](https://en.wikipedia.org/wiki/Low-pass_filter), [High-pass filter](https://en.wikipedia.org/wiki/High-pass_filter), [Exponential smoothing](https://en.wikipedia.org/wiki/Exponential_smoothing), [RC time constant](https://en.wikipedia.org/wiki/RC_time_constant).

#### ◇ Optional sub-task 5c: Analog RC high-pass experiment (if the parts are available)

A high-pass passes edges and blocks DC. On a single 3.3 V supply, bias the output at mid-rail so negative excursions do not clip at 0 V.

- **Parts:** 1× 1 µF film/ceramic capacitor, 4× 10 kΩ, 1× 10 µF (bias AC ground; observe polarity if electrolytic), breadboard.
- **Input divider:** GPIO square wave (~10 Hz) → 10 kΩ → input node → 10 kΩ → GND (about 0–1.65 V).
- **Bias:** 3.3 V → 10 kΩ → bias node → 10 kΩ → GND; add 10 µF from the bias node to GND.
- **Signal path:** input node → 1 µF → output node → 10 kΩ → bias node. Measure the output node versus GND with an ADC input.

At each edge the output jumps; between edges it decays back to about 1.65 V. The input divider keeps the output within the ADC's 0–3.3 V range. This is the complement of the RC low-pass in Task 1. Without the mid-rail bias, the ADC clips the negative part.

**AI prompts to deepen it:**

- “Explain an RC high-pass filter on a single 3.3 V supply. Why do I need a mid-rail bias, and how do I choose R and C?”
- “I have a 1 µF capacitor and a 10 kΩ resistor. What is the cutoff, and what will a 10 Hz square wave look like after the high-pass?”

**Pointers:** [High-pass filter](https://en.wikipedia.org/wiki/High-pass_filter), [RC circuit](https://en.wikipedia.org/wiki/RC_circuit), [Falstad circuit simulator](https://www.falstad.com/circuit/).

*Portfolio:* a short table or figure comparing raw, average, median, and cutoff, with the window sizes and the observed latency. If you tried the optional subtasks, add the hysteresis/dead-zone behavior and one low-pass/high-pass result.

### ★ Task 6: Draw Your Own Chain

Pick one more sensor from the available material (NTC, LDR, VL53L0X, MPU6050, DS18B20). Draw the full chain for it: physical quantity → transducer principle → conditioning (if any) → interface (analog? I²C?) → MCU processing → system use. Label where error and noise enter.

### ◇ Task 7 (Stretcher): Resolution vs. Reality

Reduce the ADC to the smallest signal change you can measure at the top of the range and at the bottom. Where is the effective resolution worst, and why? Propose one conditioning change (e.g. an op-amp, a better reference, or a different divider ratio) that would improve it.

## ✅ Suggested portfolio evidence (proofs of the learning goals)

- A pod-formation note: names, skills, and one line on what you want to build.
1. Chain diagram for your own sensor, with error/noise sources marked.
2. Basic-electronics evidence: wiring photo or schematic, LED resistor calculation (or relay wiring/safety note), the pull-up/pull-down explanation, and the button-count comparison before and after debouncing. (If you skipped Task 1, include your justification and the quick-check evidence instead.)
3. Serial-visualization evidence: a structured serial log and a plot from the Arduino IDE Serial Plotter or your chosen local tool, plus a note on loop timing.
4. ADC table: observed raw range, number of steps, step size in volts, and comparison with the theoretical value for at least two resolutions.
5. LDR table: raw, voltage, and approximate resistance for dark/shade/bright conditions, with a repeatability note.
6. Filter comparison: raw vs. moving average vs. median vs. cutoff, including window sizes and observed latency. Optional: hysteresis/dead-zone behavior and one low-pass/high-pass result.
7. Vocabulary: define, in your own words, accuracy, precision, resolution, sensitivity, and uncertainty, each with one example.
8. Deeper question: Why can a sensor with high resolution still give an inaccurate measurement? Which link of the chain is responsible in your example?


> [!IMPORTANT]
> Never commit secrets, credentials, or personal data. Where you did not work entirely alone, link your pod mates and sources.

## 📚 If you want to go deeper

- [Wikipedia: Measurement](https://en.wikipedia.org/wiki/Measurement) and [Accuracy and precision](https://en.wikipedia.org/wiki/Accuracy_and_precision) — the vocabulary, with examples.
- [Wikipedia: Analog-to-digital converter](https://en.wikipedia.org/wiki/Analog-to-digital_converter) — resolution, quantization, and conversion architectures.
- [Nyquist–Shannon sampling theorem](https://en.wikipedia.org/wiki/Nyquist%E2%80%93Shannon_sampling_theorem) — why sampling too slowly invents frequencies.
- [Espressif ADC documentation](https://docs.espressif.com/projects/arduino-esp32/en/latest/api/adc.html) — the real limits of the ESP32 ADC.
- [Wokwi](https://wokwi.com/) — simulate the chain before you wire it.
- [Arduino IDE 2: Serial Monitor and Serial Plotter](https://docs.arduino.cc/software/ide-v2/tutorials/ide-v2-serial-monitor/) — the baseline tools for inspecting and plotting data.
- [Arduino: Digital Read Serial](https://docs.arduino.cc/built-in-examples/basics/DigitalReadSerial/), [Analog Read Serial](https://docs.arduino.cc/built-in-examples/basics/AnalogReadSerial/), and [Debounce](https://docs.arduino.cc/built-in-examples/digital/Debounce/) — reading a button and taming bounce.
- Filters: [Moving average](https://en.wikipedia.org/wiki/Moving_average), [Median filter](https://en.wikipedia.org/wiki/Median_filter), [Low-pass filter](https://en.wikipedia.org/wiki/Low-pass_filter), [High-pass filter](https://en.wikipedia.org/wiki/High-pass_filter), [RC circuit](https://en.wikipedia.org/wiki/RC_circuit), [RC time constant](https://en.wikipedia.org/wiki/RC_time_constant).
- Decisions: [Hysteresis](https://en.wikipedia.org/wiki/Hysteresis), [Deadband](https://en.wikipedia.org/wiki/Deadband).
- [Falstad circuit simulator](https://www.falstad.com/circuit/) — try the RC low-pass and high-pass circuits before wiring them.
- **Optional electronic-prototyping refresher:** [Module 2 — Hardware and Basic Electronics](../../hsbi-MCU-programming-10d/modules/02-hardware-and-basic-electronics.md) in the MCU programming class, including the [breadboard intro](https://youtu.be/yXirMBP3x4U) and [Blink](https://youtu.be/2nN_ZVyWLzg) videos.

---

[← Course workbook](../README.md) | [Quick module index](./00-index.md) | [Next: Module 2 — I²C & Sensor Addressing →](./02-i2c-and-sensor-addressing.md)
