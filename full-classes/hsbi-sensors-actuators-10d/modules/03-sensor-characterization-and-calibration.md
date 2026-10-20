# Module 3 – Sensor Characterization, Calibration & Data Quality

[← Back to Module 2](./02-i2c-and-sensor-addressing.md) | [Quick module index](./00-index.md) | [Next: Module 4 →](./04-distance-motion-and-environment-sensors.md)

> A number without a transfer function and an uncertainty is not a measurement. Today you turn raw readings into characterized, calibrated, trustworthy values.

**Course placement:** Day 3 — the characterization studio. You turn raw readings into characterized, calibrated values.

## 🎯 Learning Goals

This module gives you the opportunity to explore sensor metrology and data quality and achieve competency in transfer functions, linearity and hysteresis, calibration, filtering, and uncertainty.

By the end of this module, you can:
1. Describe a sensor by its static characteristics: transfer function, offset, sensitivity, span, linearity, hysteresis, repeatability, resolution.
2. Describe its dynamic characteristics: response time, time constant, bandwidth, self-heating.
3. Perform a two-point calibration and validate it at a third point.
4. Quantify noise and improve data quality with filtering, understanding the latency trade-off.
5. State a simple uncertainty budget for a measured value.


**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 📖 Story — The Frost Alarm That Cried Wolf

**Klimapark GmbH** runs a greenhouse on the edge of Gütersloh. Agronomist **Dr. Elif Kaya** wants a frost alarm: when the air temperature near the seedlings drops below 2 °C, a fan and a heater should switch on. The first NTC prototype works in the lab, but in the greenhouse it reads 2.8 °C when the reference thermometer says 1.6 °C — and the error changes with the season.

Elif does not need a prettier plot. She needs a number she can act on: *"How wrong is this reading, and can I trust it at the threshold?"* That is a characterization and calibration question. Today you build the transfer function, calibrate, validate, and state the uncertainty — for a sensor you can hold.

## 📖 Pod Study: From Raw Reading to Trustworthy Value

This is **self/pod study, not a lecture.** Work through the concepts below with your Task Pod, look things up, ask an LLM, and keep notes — the goal is a shared mental model you can defend in the checkpoint.

### Static Characteristics

The transfer function maps the physical input `x` to the sensor output `y`. For a well-behaved sensor it is often approximately linear:

```text
y = gain · x + offset        (idealized)
```

| Term | Meaning |
|---|---|
| Offset | Output at zero input (additive error). |
| Sensitivity / gain | Output change per unit input (e.g. mV per °C). |
| Span | Output range over the specified input range. |
| Linearity | How far the real curve deviates from a straight line (often quoted as % of full scale). |
| Hysteresis | Different output for the same input, depending on whether you approached it from below or above. |
| Repeatability | Spread of repeated measurements of the same input under the same conditions. |
| Resolution | Smallest input change that produces a detectable output change. |
| Dead band | A range of inputs with no output change. |
| Drift | Slow change of output over time or with temperature. |

### Dynamic Characteristics

Sensors and their conditioning do not respond instantly:

- Response time / time constant τ: time to reach ~63 % of a step change. After ~4–5 τ, the value is essentially settled.
- Bandwidth: how fast a signal the sensor can follow without distortion.
- Self-heating: resistive sensors (like an NTC) heat themselves from the measuring current, biasing the result — relevant at low air flow or in a small enclosure.

A simple practical consequence: if you sample a temperature every 100 ms but the sensor's time constant is 15 s, you are recording noise, not information.

### Calibration and Uncertainty

Calibration compares your device under test (DUT) against a reference of known, better quality:

- One-point calibration corrects an offset (e.g. an ice-water bath at 0 °C).
- Two-point calibration corrects offset and gain (e.g. 0 °C and a known warm reference).
- Polynomial / multi-point calibration handles a clearly non-linear sensor.

Always validate at a point you did not calibrate at. A calibration that has not been checked at a third point is a hope, not a result.

Uncertainty at an appropriate level of rigor is a budget: list the contributions (reference uncertainty, resolution/quantization, repeatability, noise, drift, reading error), convert them to a common unit, and combine them in quadrature:

```text
u_c = sqrt( u_ref² + u_res² + u_repeat² + u_noise² + ... )
```

Report the expanded uncertainty `U = k · u_c` (often `k = 2`, i.e. ~95 %). You do not need a full metrology treatment; you do need honest error bars.

### Data Quality and Filtering

Noise comes from the sensor, the wiring, the ADC, and the environment. Practical tools:

- Hardware: shorter/cleaner wiring, a good ground, decoupling capacitors, a stable reference, averaging inside the sensor.
- Moving average: smooth, but adds latency ~ window size × sample interval.
- Median filter: excellent against single spikes/outliers.
- Exponential moving average (EMA): light, tunable smoothing for streaming data (a simple recursive low-pass filter).
- Oversampling + decimation: average many samples for extra effective bits, at the cost of speed.

> [!TIP]
> Implement these filters in your sketch. If you explore IoTempower (optional), it also has built-in `average`, `median`, smoothing, and mapping filters — comparing the two is a good stretcher task.

### Pointers (start here, then keep looking)

- NTC thermistors — [Wikipedia: Thermistor](https://en.wikipedia.org/wiki/Thermistor), the Beta equation and Steinhart–Hart model
- Calibration and uncertainty — [Wikipedia: Calibration](https://en.wikipedia.org/wiki/Calibration), [Measurement uncertainty](https://en.wikipedia.org/wiki/Measurement_uncertainty), and the [GUM](https://www.bipm.org/en/publications/guides/gum.html)
- Filtering — [Moving average](https://en.wikipedia.org/wiki/Moving_average), [Median filter](https://en.wikipedia.org/wiki/Median_filter), [Exponential smoothing](https://en.wikipedia.org/wiki/Exponential_smoothing)
- Optional declarative filters — [IoTempower documentation](https://github.com/iotempire/iotempower)
- Your sensor datasheets — linked from the [resource bank](./Z-resources-bank.md#datasheets--standards-to-read-once)

### Questions to ask an LLM (then verify against your measurements)

Ask your co-pilot — but treat every answer as a **claim to test**, not a fact. Good starting prompts:

- "Explain a sensor transfer function, offset, sensitivity, span, linearity, hysteresis, and repeatability with one concrete example each. How do I measure each of these in a student lab?"
- "My NTC divider gives a raw ADC code. Walk me through converting it to resistance and then to temperature with the Beta equation, and show me where the largest error comes from."
- "I have six reference points. How do I fit an offset and gain correction, and how do I validate it at a seventh point?"
- "Compare a moving average, a median filter, and an exponential moving average for a noisy temperature signal. Give the latency and the failure mode of each."
- "How do I write an honest uncertainty budget for a temperature measurement with a multimeter reference, a 12-bit ADC, and a noisy NTC?"

> Run each prompt against your own measurements, and record where the model is wrong, vague, or over-confident.

### ★ Task A: Study in your pod

Work through the concepts above with your Task Pod and fill in `Module03/study-log.md`:

1. **The references you used** — the source and the one concept you understood best from it.
2. **Things you googled** — the term, what you found, and the source (URL). One line each.
3. **Remarkable things** — surprises, "aha"s, and counterexamples from your own data.
4. **LLM Q&A** — for each prompt: the prompt, a 2–3 line summary, and **how you verified it** (and where it was wrong).
5. **Your two best found characterization examples** — compile down to the best two, with source and what they taught you.

*Portfolio evidence:* `Module03/study-log.md`.

### ★ Task B: Explain & share with another pod

Pair with a **neighbouring pod**:

1. **Explain to each other** — each pod walks the other through its transfer-function plot and its uncertainty statement; ask questions and fill each other's gaps.
2. Agree on the **3–5 most noteworthy points** and the **learning you jointly stand behind** (e.g. *"a calibration without a validation point is a hope"*).
3. **Clean up your documentation** — update your `study-log.md` with what you learned from the other pod.
4. Agree on **one shared artefact** — the best plot, calibration table, or a new uncertainty sketch the two pods make together — and **post it in the course Discord**, with a one-sentence note on why you chose it.
5. Each member adds a short **“Agreed learning (pod discussion)”** section to *their own* `study-log.md`.

*Portfolio evidence:* your cleaned-up `study-log.md` (with the **“Agreed learning (pod discussion)”** section) and your pod-pair's shared artefact.

## 🛠️ In-Class Lab: Characterize, Calibrate, Trust — **Challenging**

*Hardware:* 1× ESP32/ESP8266 + breadboard, 1× NTC 10 kΩ (or LDR), resistors for the divider, reference thermometer (or lux meter/phone), multimeter.

### ★ Task 1: Determine a Transfer Function

1. Wire the NTC as a voltage divider (a fixed resistor in series) into an analog input. Measure the divider output:
   ```text
   Vout = Vs · R_ntc / (R_fixed + R_ntc)   →  solve for R_ntc
   ```
2. Convert the ADC reading to `R_ntc`, then to temperature using the Beta equation (or use Steinhart–Hart). Look up the NTC's `R25` and `B` values.
3. Record a table of `(reference temperature, your computed temperature)` across at least six points, from cold (ice water, fridge) to warm (warm water, hand).
4. Plot the data and assess linearity over your range.

> No NTC? Do the same with an LDR and a phone lux meter (or a fixed light source at different distances), and characterize light instead of temperature.

### ★ Task 2: Two-Point Calibration and Validation

1. From Task 1, fit an offset and gain correction using two reference points spread across the range.
2. Apply it and re-measure a third, independent point.
3. Compare: how large was the error before and after calibration? Did validation pass?

### ★ Task 3: Hysteresis and Repeatability

1. Sweep the input up and then down slowly, logging both directions. Overlay the two curves; measure the maximum vertical gap at the same input — that is your hysteresis.
2. Repeat the same measurement three times and report the spread — that is your repeatability.

### ★ Task 4: Noise and Filtering

1. Hold the sensor at a constant input and log 500 raw samples. Compute the mean and the standard deviation — that is your noise floor.
2. Apply a 5-sample moving average and a 5-sample median to the same data. Recompute the standard deviation.
3. Introduce a deliberate spike (tap/light change) and compare how the two filters react.
4. Measure the latency each filter adds on a step change. State the trade-off in one sentence.

### ◇ Task 5 (Stretcher): Uncertainty and Declarative Filtering

1. Write a small uncertainty budget for your measurement (reference, resolution, repeatability, noise, drift). Report `y ± U` with a reasonable `k`.
2. Compare your firmware filter with a declarative one: if you explore IoTempower (optional), declare an average/median filter on the device and compare its behavior with your software filter. If you are not using IoTempower, compare a moving average with an EMA or a median filter instead.

## ✅ Suggested portfolio evidence (proofs of the learning goals)

1. Transfer-function plot with your fitted offset/gain and the residuals (deviation from the reference).
2. Calibration table: before/after error at the validation point.
3. Hysteresis/repeatability numbers with the up/down curves.
4. Noise table: standard deviation raw vs. moving average vs. median, plus the measured latency.
5. Uncertainty statement for one final value.
6. Deeper question: Which error in your sensor is systematic and could be calibrated, and which is random and must be averaged or accepted?


> [!IMPORTANT]
> Never commit secrets, credentials, or personal data. Where you did not work entirely alone, link your pod mates and sources.

## 📚 If you want to go deeper

- [Wikipedia: Thermistor](https://en.wikipedia.org/wiki/Thermistor) — Beta equation, Steinhart–Hart, and self-heating.
- [Wikipedia: Calibration](https://en.wikipedia.org/wiki/Calibration) — one-point, two-point, and multi-point calibration.
- [Measurement uncertainty](https://en.wikipedia.org/wiki/Measurement_uncertainty) and the [GUM](https://www.bipm.org/en/publications/guides/gum.html) — how to state `y ± U` honestly.
- [Moving average](https://en.wikipedia.org/wiki/Moving_average), [Median filter](https://en.wikipedia.org/wiki/Median_filter), [Exponential smoothing](https://en.wikipedia.org/wiki/Exponential_smoothing) — the filters you will compare.
- [IoTempower](https://github.com/iotempire/iotempower) — optional declarative filters and node definitions.

---

[← Previous: Module 2](./02-i2c-and-sensor-addressing.md) | [Back to front page](../README.md) | [Quick module index](./00-index.md) | [Next: Module 4 — Distance, Motion & Environment Sensors →](./04-distance-motion-and-environment-sensors.md)
