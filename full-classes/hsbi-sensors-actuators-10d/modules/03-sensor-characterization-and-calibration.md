# Module 3 – Sensor Characterization, Calibration & Data Quality

[← Back to Module 2](./02-i2c-and-sensor-addressing.md) | [Quick module index](./00-index.md) | [Next: Module 4 →](./04-distance-motion-and-environment-sensors.md)

> **A number without a transfer function and an uncertainty is not a measurement.** Today you turn raw readings into characterized, calibrated, trustworthy values.

## 🎯 Learning Goals

> **How these are assessed:** You earn this module's points by **proving these goals** in a short (~10-minute) checkpoint presentation with the instructor (see the [syllabus](../syllabus.md#how-module-points-are-earned-checkpoint-presentations)) — based on your portfolio and reflections, not on completing every task. You may skip tasks, fail at some, or add your own; documented exploration and demonstrated deep understanding both count in your favor.

This module gives you the opportunity to explore **sensor metrology and data quality** and achieve competency in **transfer functions, linearity and hysteresis, calibration, filtering, and uncertainty**.

By the end of this module, you can:
1. Describe a sensor by its **static characteristics**: transfer function, offset, sensitivity, span, linearity, hysteresis, repeatability, resolution.
2. Describe its **dynamic characteristics**: response time, time constant, bandwidth, self-heating.
3. Perform a **two-point calibration** and validate it at a third point.
4. Quantify **noise** and improve data quality with filtering, understanding the latency trade-off.
5. State a simple **uncertainty budget** for a measured value.

> [!WARNING]
> **DRAFT — first taught in WS 2026/27.** Everything below this line is a working draft and will likely change as we refine it together in class; the line moves down as we approve content. Your input is welcome and can shape this module.

**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 📖 Part A — Static Characteristics

The **transfer function** maps the physical input `x` to the sensor output `y`. For a well-behaved sensor it is often approximately linear:

```text
y = gain · x + offset        (idealized)
```

| Term | Meaning |
|---|---|
| **Offset** | Output at zero input (additive error). |
| **Sensitivity / gain** | Output change per unit input (e.g. mV per °C). |
| **Span** | Output range over the specified input range. |
| **Linearity** | How far the real curve deviates from a straight line (often quoted as % of full scale). |
| **Hysteresis** | Different output for the same input, depending on whether you approached it from below or above. |
| **Repeatability** | Spread of repeated measurements of the same input under the same conditions. |
| **Resolution** | Smallest input change that produces a detectable output change. |
| **Dead band** | A range of inputs with no output change. |
| **Drift** | Slow change of output over time or with temperature. |

## 📖 Part B — Dynamic Characteristics

Sensors and their conditioning do not respond instantly:

- **Response time / time constant τ:** time to reach ~63 % of a step change. After ~4–5 τ, the value is essentially settled.
- **Bandwidth:** how fast a signal the sensor can follow without distortion.
- **Self-heating:** resistive sensors (like an NTC) heat themselves from the measuring current, biasing the result — relevant at low air flow or in a small enclosure.

A simple practical consequence: if you sample a temperature every 100 ms but the sensor's time constant is 15 s, you are recording noise, not information.

## 📖 Part C — Calibration and Uncertainty

**Calibration** compares your device under test (DUT) against a **reference** of known, better quality:

- **One-point calibration** corrects an **offset** (e.g. an ice-water bath at 0 °C).
- **Two-point calibration** corrects **offset and gain** (e.g. 0 °C and a known warm reference).
- **Polynomial / multi-point calibration** handles a clearly non-linear sensor.

Always **validate** at a point you did not calibrate at. A calibration that has not been checked at a third point is a hope, not a result.

**Uncertainty** at an appropriate level of rigor is a budget: list the contributions (reference uncertainty, resolution/quantization, repeatability, noise, drift, reading error), convert them to a common unit, and combine them in quadrature:

```text
u_c = sqrt( u_ref² + u_res² + u_repeat² + u_noise² + ... )
```

Report the expanded uncertainty `U = k · u_c` (often `k = 2`, i.e. ~95 %). You do not need a full metrology treatment; you do need honest error bars.

## 📖 Part D — Data Quality and Filtering

Noise comes from the sensor, the wiring, the ADC, and the environment. Practical tools:

- **Hardware:** shorter/cleaner wiring, a good ground, decoupling capacitors, a stable reference, averaging inside the sensor.
- **Moving average:** smooth, but adds latency ~ window size × sample interval.
- **Median filter:** excellent against single spikes/outliers.
- **Exponential moving average (EMA):** light, tunable smoothing for streaming data (and what many IoTempower filters use).
- **Oversampling + decimation:** average many samples for extra effective bits, at the cost of speed.

> [!TIP]
> IoTempower has built-in **filters** (`average`, `median`, smoothing, mapping). You can move processing out of your sketch and declare it instead — try this as a stretcher task.

## 🛠️ In-Class Lab: Characterize, Calibrate, Trust

*Hardware:* 1× ESP32/ESP8266 + breadboard, 1× NTC 10 kΩ (or LDR), resistors for the divider, reference thermometer (or lux meter/phone), multimeter.

### ★ Task 1: Determine a Transfer Function (50 min)

1. Wire the NTC as a **voltage divider** (a fixed resistor in series) into an analog input. Measure the divider output:
   ```text
   Vout = Vs · R_ntc / (R_fixed + R_ntc)   →  solve for R_ntc
   ```
2. Convert the ADC reading to `R_ntc`, then to temperature using the **Beta equation** (or use Steinhart–Hart). Look up the NTC's `R25` and `B` values.
3. Record a table of `(reference temperature, your computed temperature)` across at least **six points**, from cold (ice water, fridge) to warm (warm water, hand).
4. Plot the data and assess **linearity** over your range.

> No NTC? Do the same with an **LDR** and a phone lux meter (or a fixed light source at different distances), and characterize light instead of temperature.

### ★ Task 2: Two-Point Calibration and Validation (30 min)

1. From Task 1, fit an offset and gain correction using **two** reference points spread across the range.
2. Apply it and re-measure a **third**, independent point.
3. Compare: how large was the error before and after calibration? Did validation pass?

### ★ Task 3: Hysteresis and Repeatability (25 min)

1. Sweep the input **up** and then **down** slowly, logging both directions. Overlay the two curves; measure the maximum vertical gap at the same input — that is your **hysteresis**.
2. Repeat the same measurement three times and report the spread — that is your **repeatability**.

### ★ Task 4: Noise and Filtering (30 min)

1. Hold the sensor at a constant input and log **500 raw samples**. Compute the **mean** and the **standard deviation** — that is your noise floor.
2. Apply a **5-sample moving average** and a **5-sample median** to the same data. Recompute the standard deviation.
3. Introduce a deliberate **spike** (tap/light change) and compare how the two filters react.
4. Measure the **latency** each filter adds on a step change. State the trade-off in one sentence.

### ◇ Task 5 (Stretcher): Uncertainty and Declarative Filtering (25 min)

1. Write a small **uncertainty budget** for your measurement (reference, resolution, repeatability, noise, drift). Report `y ± U` with a reasonable `k`.
2. Move your smoothing into **IoTempower**: declare an average/median filter on the device and compare its behavior with your software filter.

## 📝 Working-Day Reflection & Portfolio Tasks

In your portfolio under `modules/03-characterization/`:
1. **Transfer-function plot** with your fitted offset/gain and the residuals (deviation from the reference).
2. **Calibration table:** before/after error at the validation point.
3. **Hysteresis/repeatability numbers** with the up/down curves.
4. **Noise table:** standard deviation raw vs. moving average vs. median, plus the measured latency.
5. **Uncertainty statement** for one final value.
6. **Reflection:** Which error in your sensor is systematic and could be calibrated, and which is random and must be averaged or accepted?
