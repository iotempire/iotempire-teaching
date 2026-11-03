# Module 3 – Sensor Characterization, Calibration & Data Quality

[← Back to Module 2](./02-i2c-and-sensor-addressing.md) | [Back to front page](../README.md) | [Quick module index](./00-index.md) | [Next: Module 4 →](./04-distance-motion-and-environment-sensors.md)

> A number without a transfer function and an uncertainty is not a measurement. Today you turn raw readings into characterized, calibrated, trustworthy values.

**Course placement:** Day 3 — the characterization studio. The module runs across the day's three sessions: characterize, calibrate, then filter and decide. Each round alternates a short brief with bench work, a mini check, and a log or exchange step.

## 🎯 Learning Goals

This module gives you the opportunity to explore sensor metrology and data quality and achieve competency in transfer functions, linearity and hysteresis, calibration, filtering, and uncertainty — using an analog LDR, a digital DS18B20, and the ADC chain.

By the end of this module, you can:
1. Describe a sensor by its static characteristics: transfer function, offset, sensitivity, span, linearity, hysteresis, repeatability, resolution.
2. Describe its dynamic characteristics: response time, time constant, bandwidth, self-heating.
3. Perform a two-point calibration and validate it at a third point.
4. Quantify noise and improve data quality with filtering, understanding the latency trade-off.
5. State a simple uncertainty budget for a measured value.


**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 📖 Story — The Frost Alarm That Cried Wolf

**Klimapark GmbH** runs a greenhouse on the edge of Gütersloh. Agronomist **Dr. Elif Kaya** wants a frost alarm: when the air temperature near the seedlings drops below 2 °C, a fan and a heater should switch on. The first NTC prototype works in the lab, but in the greenhouse it reads 0.8 °C when the reference thermometer says 2.2 °C — so the heater runs on mild nights, and the error changes with the season.

Elif replaced the NTC with a **DS18B20** and added an **LDR** to the same node for the grow-light control. Now she has two numbers she does not yet trust: the DS18B20's temperature and the LDR's light level. If the temperature is wrong, the heater runs when it should not — or stays off on a cold night. If the light is wrong, the grow lights run at the wrong time.

Elif does not need a prettier plot. She needs a number she can act on: *"How wrong is each reading, and can I trust it at the threshold?"* Today you characterize, calibrate, and state the uncertainty for both sensors — and use a **potentiometer** as the stable "known input" that lets you check the measurement chain itself.

## 🛠️ Characterization Studio — **Challenging**

*Hardware per pod:* 1× ESP32 (or ESP8266), breadboard and jumper wires, 1× LDR + 10 kΩ resistor, 1× 10 kΩ potentiometer, 2–3× DS18B20 (OneWire) plus a 4.7 kΩ pull-up, a sealed bag and two cups for water baths.

*Shared:* lamps, rulers, dark cards or boxes, a phone with a lux-meter app (or one per bench); 3 multimeters for 6 pods — pair pods, one meter per pair, and swap at the round boundary; the class reference thermometer (or a DS18B20 checked against it); hot and cold water.

> **No NTC in this kit.** The NTC in the story is the failed first prototype. This run characterizes the sensors you actually have: the **LDR** (analog, nonlinear), the **DS18B20** (digital, factory-calibrated), and the **potentiometer** (a stable input for checking the chain). If an NTC appears, the Beta equation is in the [resource bank](./Z-resources-bank.md#formulas-you-will-use); the method is the same.

> [!WARNING]
> **Water and electronics.** Seal the DS18B20 in a bag before it goes into water, dry the leads, and keep the ESP32 and breadboard away from the water. Use warm, not boiling, water. Check the DS18B20 wiring: `VDD` to 3.3 V, `GND` to GND, `DQ` to the GPIO with a 4.7 kΩ pull-up to 3.3 V.

> **Your bench.** Each pod has its own LDR, potentiometer, and 2–3 DS18B20s. The class still compares results — add your LDR rows and DS18B20 unit means to the class tables if your instructor sets them up — but the measurements happen at your own bench.
>
> **Studio rhythm.** Each round has four modes: **Brief** (read the short concept block), **Bench** (measure), **Explain** (a mini check), and **Log/Swap** (write and exchange). The three rounds map to the module's three sessions; keep the order if your timetable differs.
>
> **Exchange is planned.** In Round 2, a neighbouring pod checks your validation point. In Round 3, you agree on a shared artefact and the learning you stand behind. An instructor joins each pod at least once per round.
>
> **Mini checks are for you.** The instructor picks a pod and one prompt at random; answer from your bench or your log. The point is to surface a gap while you can still fix it, not to perform. The reference shelf at the end of the module has the sources and LLM prompts.

| Round | Brief | Bench | Exchange |
|---|---|---|---|
| **1 — Characterize** | Static and dynamic characteristics | Task 1 (LDR) + Task 2 (DS18B20) | Compare LDR fits with a neighbouring pod; share rows if a class table exists |
| **2 — Calibrate and challenge** | Calibration, validation, uncertainty | Task 3 (three calibrations) + Task 4 (hysteresis/repeatability) | Peer validation of your third point |
| **3 — Filter and decide** | Noise, filters, latency | Task 5 (noise/filtering) + Task 6 (stretcher) | Agreed learning and one shared artefact |

### Round 1 — Characterize: What Does the Number Mean?

> **Divide the work.** Each pod has its own LDR, potentiometer, and DS18B20s. In a pod of three, one member can own the LDR, one the DS18B20 bus, and one the potentiometer/dead-band check; in a pair, take the LDR first and the DS18B20 second. Compare at the end: which sensor tells you more about the chain, and which tells you more about the world?

#### Brief: Static characteristics

The transfer function maps the physical input `x` to the sensor output `y`. For a well-behaved sensor it is often approximately linear; for an LDR it is a power law. You will meet both today:

```text
y = gain · x + offset        (idealized, linear)
R_LDR = A · E^(−γ)           (LDR, power law)
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

**Resolution is not accuracy.** The DS18B20 is the clean example: at 12-bit it reports 0.0625 °C steps, but the datasheet specifies ±0.5 °C over the usual range. The step size tells you how finely it reports; the ±0.5 °C tells you how close it is to the truth. A precise number can still be wrong.

**Linearity depends on the axes.** The LDR is not linear in `R` vs. `E`; its log-log plot is approximately linear. That is why Task 1 fits a power law, not a straight line.

**Not every term applies to every sensor.** The LDR's power law has no additive offset, and its slope in log-log space is the exponent `γ`, not a linear gain. The DS18B20's transfer function is the datasheet's code-to-temperature mapping. Use the table as vocabulary, then say which model fits your sensor.

#### ◇ Optional study sub-task: Dead band vs. dead zone

A **dead band** is a range of inputs over which the output does not change. It can come from the sensor's physics (a thermostat's on/off gap, a Hall switch's hysteresis), from mechanics (backlash), or from quantization in your ADC. A **dead-zone filter** is a decision you make in firmware: you ignore changes smaller than a band you chose. One is a property of the chain, the other is policy — and confusing them hides which part of the chain you can improve.

| | Dead band (chain) | Dead zone (software) |
|---|---|---|
| Where it lives | Sensor physics, mechanics, or ADC quantization | Your firmware decision |
| Who chose it | The device and the chain | You |
| What it does to small changes | They become invisible | You deliberately ignore them |
| Good for | Knowing the limit of detection | Suppressing chatter around a threshold |
| What it costs | Information lost before your firmware sees it | Information you chose to lose, plus detection delay |

1. **Find a dead band you can observe.** Easiest is the quantization dead band of your ADC: slowly turn your potentiometer and log the raw code as you turn. Record the smallest input change that produces a new code — each code is a small no-change band. Repeat near mid-scale and near the ends of the range. If you have a datasheet that specifies a dead band or hysteresis (a servo, a digital-output sensor, a thermostat), compare its number with what you can measure.
2. **Apply a dead zone.** Take the same log and update the output only when `abs(x - last_output) > band` (for example 3 ADC codes). Which changes disappear now?
3. **Compare.** Which of the two loses information you could have recovered by better wiring, a better divider, or a better ADC? Which loses information on purpose?
4. **One sentence for your study log:** when would you fix the sensor or the conditioning instead of adding a software dead zone?

> You built the software version in [Module 1](./01-foundations-measurement-and-sensor-chain.md) (optional sub-task 5a). Here the point is the measurement: the dead band you measure is a property of the chain; the dead zone you choose is a design decision.

#### ★ Task 1: The LDR's transfer function — resistance vs. light

The LDR is the analog, nonlinear sensor in your kit. Its resistance falls as light increases, roughly as a power law. Your job is to measure that curve, not assume it — and the class compares the curves across LDRs.

1. **Wire the divider — and state its orientation.** Use `3V3 → LDR → node → 10 kΩ → GND` (`Vs = 3.3 V`) and connect the divider ground to your ESP32 ground. Measure the node with the ADC and the multimeter; measure `Vs` once with the meter too. In this orientation, more light lowers `R_LDR` and **raises** `Vout`. Record the orientation in your log; if you wire it the other way, derive the other formula.
   ```text
   Vout = Vs · R_fixed / (R_LDR + R_fixed)
   R_LDR = R_fixed · (Vs − Vout) / Vout
   ```
2. **Make a light ladder.** Fix a lamp and a ruler; measure at least six distances (or six lux-meter levels). If your instructor sets up a class LDR table (course channel or a shared document), add your rows so the class can compare LDRs. Suggested columns: pod, distance, lux (if available), Vout, R_LDR, orientation. Shield the LDR from ambient light with a dark card or box. Let the lamp stabilize, wait for the reading to settle, keep the same lamp and spectrum for every reading, and keep the distances large compared with the lamp's size. Record `(distance, lux if available, Vout, R_LDR)`.
3. **Use the inverse-square law for relative illuminance.** For a point source, `E ∝ 1/d²`. If you have a lux meter, compare the measured ratios with the inverse-square prediction; if not, use the distances. A phone lux meter is a relative reference, not a calibration standard — state that in your log.
4. **Plot and fit your LDR dataset.** Plot `log R_LDR` vs. `log E` for your rows; fit a line; report the slope `−γ` and the residual. Compare the log-log fit with a linear fit over the same range. Where does the linear fit fail? If the class table exists, compare your slope with it; the spread across LDRs is itself a result. If your rows scatter more than you expect, check Task 4: light history can make the same light level give different resistances.
5. **Repeat one level three times** and add the spread in `R_LDR` to the class LDR table if your instructor set one up. Compare it with the change in `R_LDR` caused by one ADC step at that light level. Which is larger?
6. **Optional:** measure your LDR's response to a light step (a card or shutter) and estimate its time constant. Compare it with the DS18B20 in Task 2.

> **Measure with the meter, not only the ADC.** The multimeter is your voltage reference; the ADC is the logger. Keep the ADC code in its linear band, or mark where it is not. The difference between the meter and the ADC is part of your uncertainty budget.

#### Brief: Dynamic characteristics

Sensors and their conditioning do not respond instantly:

- Response time / time constant τ: time to reach ~63 % of a step change. After ~4–5 τ, the value is essentially settled.
- Bandwidth: how fast a signal the sensor can follow without distortion.
- Self-heating: resistive sensors (like an LDR) heat themselves from the measuring current, and the DS18B20 heats itself during an active conversion. The effect is small, but it matters in still air or a small enclosure.

A practical consequence: if you request a DS18B20 reading every 100 ms but its 12-bit conversion takes 750 ms and its thermal time constant is tens of seconds, you are recording the same conversion and the same temperature, not new information.

#### ★ Task 2: The DS18B20 — resolution, accuracy, and response time

The DS18B20 is the digital, factory-calibrated sensor. It does not need a voltage divider, but it does need a 1-Wire bus and a pull-up. Its datasheet gives the transfer function; your job is to find out what that means at the threshold.

1. **Read the datasheet first.** Find the 9–12-bit resolution settings, the conversion time for each, the accuracy specification, the active/standby current, and the 1-Wire pull-up. Write the key numbers in your log.
2. **Wire 2–3 DS18B20s on one bus.** Use a 4.7 kΩ pull-up to 3.3 V; scan the ROM IDs; read each sensor. Each DS18B20 has a unique 64-bit ROM ID — that is how several sensors share one wire. Confirm that all units are visible.
3. **Resolution vs. accuracy.** Configure 9, 10, 11, and 12 bits; record the step size and the datasheet conversion time. Compare the step size with the datasheet accuracy. Which one limits your frost decision?
4. **Unit-to-unit check.** Put all sensors in the same stable place (still air, or a sealed bag in stirred water) next to the reference thermometer. Wait for all sensors and the reference to settle. Record 10 readings per unit. Add your unit means to the class DS18B20 table if your instructor set one up; the class has more units than any one pod. Compare the means and the spread. Is the difference between units calibration, accuracy, or noise?
5. **Response time.** Put one sensor in a sealed bag in stirred water; move it from cold to warm; log `(time, temperature)` at 12-bit. Plot the step response and estimate `τ` (63 % of the change) and the settling time (4–5 τ). Repeat in still air and compare; keep the bag and its position the same for both runs. Explain why the air measurement is slower.
6. **Optional — self-heating.** Compare continuous conversions with a duty-cycled read in still air. Does the reading shift? How large is the effect compared with the datasheet accuracy?

> **Mini check — Round 1.** The instructor picks a pod and one prompt. Answer from your bench or your log:
> - "Show your divider orientation and predict the direction of `Vout` when the light increases."
> - "Which term in the static-characteristics table does your LDR fit actually give you, and which term does not apply?"
> - "Which DS18B20 is the outlier, and is that calibration, accuracy, or noise?"
>
> **Log and swap.** Update Task A with your LDR class-table rows, your DS18B20 table, and one surprise. Compare your LDR fit with a neighbouring pod's: did you choose the same levels, and do your slopes agree?
>
> **Instructor bench round.** Show your LDR plot and your DS18B20 setup; the instructor will ask one "why" question.

### Round 2 — Calibrate and Challenge

#### Brief: Calibration and uncertainty

Calibration compares your device under test (DUT) against a reference of known, better quality. The DUT can be the whole chain, not just the sensor:

- One-point calibration corrects an offset (a DS18B20 checked against the reference at one temperature).
- Two-point calibration corrects offset and gain (the potentiometer/ADC chain; the LDR over a narrow range, or its power law in log space).
- Multi-point / polynomial calibration handles a clearly nonlinear sensor (the LDR over a wide range).

Always validate at a point you did not calibrate at. A calibration that has not been checked at a third point is a hope, not a result.

Uncertainty at an appropriate level of rigor is a budget: list the contributions (reference uncertainty, component tolerance, resolution/quantization, repeatability, noise, nonlinearity/fit residual, drift, self-heating, reading error), convert them to a common unit, and combine them in quadrature:

```text
u_c = sqrt( u_ref² + u_res² + u_repeat² + u_noise² + u_nonlin² + u_drift² + ... )
```

Report the expanded uncertainty `U = k · u_c` (often `k = 2`, i.e. ~95 %). You do not need a full metrology treatment; you do need honest error bars.

#### ★ Task 3: Two-point calibration and validation — three cases

Calibration is not one recipe. Calibrate the chain, the analog sensor, and the digital sensor, and compare what "two measurements" means in each case.

> **Divide the work.** In a pod of three, take one case each; in a pair, do 3a together, then split 3b and 3c. Compare at the end: which calibration corrected the most error, and which was not worth applying?

**3a — The chain (potentiometer + multimeter).** This is the clean case.

1. Wire the potentiometer across 3.3 V and GND with the wiper to an ADC input; connect the ground to your ESP32 ground. Measure the wiper with the shared multimeter; the ADC and the meter share ground. The ADC's full-scale range depends on the board's reference and attenuation; keep the 3.3 V rail stable — if it moves, the calibration moves with it.
2. Set two voltages spread across the ADC's linear range. Measure each with the multimeter; record the ADC code.
3. Fit `code = a·V + b` (or `V = a·code + b`). Apply the correction.
4. Set a third voltage you did not use for the fit; compare the corrected reading with the multimeter. Report the error before and after. If the third point is off, the chain may not be linear over that range; narrow the range or use more calibration measurements, and check whether the residual is larger than your noise.
5. Compare your offset and gain with a neighbouring pod's. Your pots are nominally identical; your ADCs are not. What does the comparison tell you about unit-to-unit variation?
6. In one sentence: what does this calibration correct — the sensor, the ADC, or the chain?

**3b — The analog sensor (LDR).** This is the nonlinear case.

1. Use your LDR data from Task 1 (and compare with the class table if there is one). Choose two light levels for the fit and fit the power law in log space: `log R = log A − γ log E`. Two measurements determine `A` and `γ`.
2. Validate at a third light level that you did not use for the fit. Compare the predicted and measured `R` (or lux).
3. Fit a linear two-point calibration over the same range and validate at the same third point. Which model generalizes? Why?
4. State the uncertainty of your validation point in one line, naming the two largest contributions; the full budget is Task 6.

**3c — The digital sensor (DS18B20).** This is the factory-calibrated case.

1. Compare one DS18B20 with the reference thermometer at a stable temperature. Record the offset.
2. Apply a one-point offset correction; validate at a second temperature.
3. Compare the residual with the datasheet accuracy. Is the correction worth applying? What would you tell Elif?

> **A one-point correction at room temperature does not guarantee accuracy at 2 °C.** The datasheet accuracy is a bound over a range, not a constant offset. That is exactly the story's seasonal problem in miniature.

#### ★ Task 4: Hysteresis and repeatability — where the loop is real

1. **LDR — light up and down.** Fix the lamp; slowly cover and uncover it with a card, logging light and resistance in both directions. Overlay the two curves; measure the maximum gap at the same light level. An LDR can remember previous illumination — light history — and that can look like hysteresis. Repeat at two sweep speeds and with a pause at each level: lag changes with speed, light history changes with time. Is the gap hysteresis, light history, or lag? How would you tell?
2. **Potentiometer — mechanical repeatability.** Set the pot to a marked position, read the voltage; turn it away and back to the mark; read again. Repeat 10 times. Report the spread. Is this the pot's mechanical play, the ADC's noise, or your marking error?
3. **DS18B20 — repeatability and resolution.** Hold a sensor at a stable temperature; take 10 readings at 9-bit and 12-bit. Compare the spread with the resolution step. Do the same for 2–3 units. Which sensor shows hysteresis? Which shows only quantization?
4. **One sentence:** for each sensor, name the effect you actually measured and the effect you did not.

> **Mini check — Round 2.** The instructor picks a pod and one prompt. Answer from your bench or your log:
> - "Which calibration corrected the sensor, which corrected the chain, and which corrected nothing?"
> - "Why is your validation point independent?"
> - "Which error is systematic, and which is random?"
>
> **Peer validation (Task B, first pass).** Swap calibration tables with a neighbouring pod. One pod explains its procedure; the other checks the validation point: was it fresh, was it outside the fit, was the reference in the same conditions? Record one thing the other pod caught and one thing you caught in theirs.
>
> **Instructor bench round.** Show your calibration table and your validation point, and name one systematic and one random error. The instructor will ask one "why" question.

### Round 3 — Filter and Decide

#### Brief: Data quality and filtering

Noise comes from the sensor, the wiring, the ADC, and the environment. Practical tools:

- Hardware: shorter/cleaner wiring, a good ground, decoupling capacitors, a stable reference, averaging inside the sensor.
- Moving average: smooth, but adds latency ~ window size × sample interval.
- Median filter: excellent against single spikes/outliers.
- Exponential moving average (EMA): light, tunable smoothing for streaming data (a simple recursive low-pass filter).
- Oversampling + decimation: average many samples for extra effective bits, at the cost of speed.

**Match the input to the question.** The potentiometer gives a clean, fast step — use it to measure filter latency. The LDR gives a noisy sensor signal — use it to measure noise and spike rejection. A DS18B20's output is quantized; averaging identical codes does not add information unless the input changes.

#### ◇ Optional study sub-task: The wider filter toolbox

The tools above cover most measurements in this lab. You met the software versions as optional sub-tasks in [Module 1](./01-foundations-measurement-and-sensor-chain.md); a few more are worth recognizing, because a library — or an IoTempower filter chain — will offer them by name:

| Tool | What it is | What to watch |
|---|---|---|
| **Analog RC low-pass** | A resistor and capacitor before the ADC; `fc = 1/(2πRC)`. | Source and load impedance shift the cutoff; a high-impedance source needs buffering. |
| **Analog RC high-pass** | A capacitor in series; passes edges, blocks DC. | On a single 3.3 V supply, bias the output at mid-rail or the ADC clips the negative part. |
| **Software low-pass / high-pass** | First-order IIR: EMA as the low-pass, `x − lowpass(x)` as the high-pass. | `alpha` depends on the sample interval; the phase lag is the price of smoothing. |
| **Software hysteresis / dead zone** | Two thresholds, or a no-change band, in the decision path. | Suppresses chatter but hides small real changes and delays detection. |

**Mini task — choose, don't collect.** For each disturbance, name the first filter you would try and the failure mode you accept:

| Disturbance | Your first filter? | What could it break? |
|---|---|---|
| White noise on a slow temperature | | |
| A single spike from a loose wire | | |
| Slow drift over a season | | |
| A threshold that chatters at 2 °C | | |

Ask an LLM for its recommendation for the frost alarm, then mark which of its claims you can test in Task 5. Add one line to your study log.

> [!TIP]
> Implement the filters you choose in Task 5 and optional sub-task 5a. If you later explore [Module 8](./08-sensor-to-system-and-integration.md), IoTempower has built-in `average`, `median`, smoothing, and mapping filters — comparing the two is a good stretcher.

#### ★ Task 5: Noise and filtering — measure the cost

> **Logging.** Use the Serial Monitor's save output, Teleplot, or a short `pyserial` script; the analysis is the point, not the tool.

1. **The chain's noise floor (potentiometer).** Hold the pot fixed; log 500 raw samples with your ESP32. Compute the mean and standard deviation. This is the ADC/electrical noise, not the sensor.
2. **The sensor's noise (LDR).** Hold the light fixed; log 500 samples. Compute the mean and standard deviation. Compare with the chain's noise floor. How much of the noise comes from the sensor?
3. **The filter comparison.** Apply a 5-sample moving average, a 5-sample median, and an EMA (`alpha = 0.2`, or tuned to match the moving average) to your LDR log. Recompute the standard deviation. Introduce a single-sample outlier (a synthetic spike; a brief shadow is a wider pulse) and compare how each filter reacts.
4. **The step and the lag (potentiometer).** Step the pot between two voltages; log raw and filtered. Measure the lag each filter adds. For the moving average, the group delay is about `(N−1)/2` samples; for the EMA, measure it. State the trade-off in one sentence.
5. **The decision (LDR or DS18B20).** Add a hysteresis (two thresholds) or a dead zone to a threshold decision. Show what it does to a slow drift that crosses the threshold. Which would you ship for the frost alarm?

##### ◇ Optional sub-task 5a: One step, one spike, four filters

Replay the same raw log through several filters so the comparison is fair:

1. Save the raw samples from Task 5 to a CSV file (or print `raw,filtered` pairs from the sketch). If the log has no clean step, use the potentiometer step from Task 5.4.
2. Apply a 5-sample moving average, a 5-sample median, an EMA, and — if you have the RC parts from Module 1 — an analog RC low-pass. If you built the RC high-pass, add it too and explain why it is the wrong tool for an absolute threshold.
3. Plot raw and all filtered traces on one plot; mark the step and the spike.
4. Measure the lag each filter adds on the step. For the moving average, the group delay is about `(N−1)/2` samples; for the EMA, measure it rather than guessing.
5. Add a software hysteresis (two thresholds) and a dead zone (a no-change band) to the **decision**, not the signal. Show what each does to a slow drift that crosses the frost threshold.
6. Which would you ship for Elif's alarm, and what would you tell her about its lag?

#### ◇ Task 6 (Stretcher): Uncertainty and Declarative Filtering

1. Choose one measurement: the LDR's lux estimate, the DS18B20's temperature, or the potentiometer's voltage. Use the budget method from Round 2 and build a table like this:

   | Contribution | Estimate | Distribution | Standard uncertainty | Source |
   |---|---|---|---|---|
   | Reference | | | | |
   | Component tolerance | | | | |
   | Resolution / quantization | | | | |
   | Repeatability | | | | |
   | Noise | | | | |
   | Nonlinearity / fit residual | | | | |
   | Drift | | | | |
   | Self-heating | | | | |

   Convert each to the same unit and combine in quadrature. For a rectangular contribution of half-width `a`, use `a/√3`; state your assumption. Report `y ± U` with `k = 2`. Drift and self-heating may be bounded from the datasheet rather than measured in one session; say which.
2. Compare your firmware filter with a declarative one: if you explore IoTempower (optional), declare an average/median filter on the device and compare its behavior with your software filter. If you are not using IoTempower, compare a moving average with an EMA or a median filter instead.
3. Which contribution dominates? What would you improve first — the sensor, the reference, or the filter?

> **Mini check — Round 3.** The instructor picks a pod and one prompt. Answer from your bench or your log:
> - "Which filter would you ship for the frost alarm, and what does it cost?"
> - "Where is your dead band, and where is your dead zone?"
> - "What would you tell Elif about the lag?"
>
> **End exchange (Task B, second pass).** Agree on the 3–5 most noteworthy takeaways and the learning you jointly stand behind. Agree on one shared artefact — the best plot, calibration table, or uncertainty sketch — and post it in the course Discord with a one-sentence note on why you chose it.
>
> **Instructor bench round.** Show your noise table and your uncertainty statement; the instructor will ask what you would change first.

#### Back to Elif

Write the one-sentence answer she needs: *"At 2 °C, my DS18B20 reads … ± … °C; the LDR tells me …; I would/would not trust this at the threshold because …"* Then answer the harder question: the error in the story changed with the season. Which part of that can you reproduce in one session (offset, gain, nonlinearity, repeatability, noise), and which part can you only bound from the datasheet (long-term drift, humidity, temperature, self-heating, installation)? Add it to your study log.

### ★ Task A: Keep the study log

Work through the round briefs with your Task Pod and keep one shared `## Study log` in `Module03/README.md` — a section, not a file, unless it outgrows the page. **One pod member keeps the shared log; the others link to that section from their own module README and add one sentence on what they took from it.** Write it as you go, not at the end.

By the end, it should contain:

1. **The references you used** — the source and the one concept you understood best from it.
2. **Things you googled** — the term, what you found, and the source (URL). One line each.
3. **Remarkable things** — surprises, "aha"s, and counterexamples from your own data.
4. **LLM Q&A** — for each prompt: the prompt, a 2–3 line summary, and **how you verified it** (and where it was wrong).
5. **Your two best found characterization examples** — compile down to the best two, with source and what they taught you.
6. **The mini checks you answered** — the prompt and your one-line answer.
7. **The calibration decision** — which correction you applied, which you rejected, and why.

*Portfolio evidence:* the `## Study log` section (yours, or a link to your pod's shared one).

### ★ Task B: Exchange with a neighbouring pod — twice

**First exchange — end of Round 2 (peer validation).**

1. Swap calibration tables with a neighbouring pod.
2. One pod explains its procedure; the other checks the validation point: was it fresh, was it outside the fit, was the reference in the same conditions?
3. Record one thing the other pod caught and one thing you caught in theirs.

**Second exchange — end of Round 3 (shared artefact).**

1. **Explain to each other** — each pod walks the other through its best plot and its uncertainty statement; ask questions and fill each other's gaps.
2. Agree on the **3–5 most noteworthy takeaways** and the **learning you jointly stand behind** (e.g. *"a calibration without a validation point is a hope"*).
3. **Clean up your documentation** — update the `## Study log` with what you learned from the other pod.
4. Agree on **one shared artefact** — the best plot, calibration table, or a new uncertainty sketch the two pods make together — and **post it in the course Discord**, with a one-sentence note on why you chose it.
5. Each member adds a short **“Agreed learning (pod discussion)”** note — in the shared log, or in your own module README with a link to it.

*Portfolio evidence:* the cleaned-up `## Study log` (with the **“Agreed learning (pod discussion)”** note) and your pod-pair's shared artefact.

### Pointers (start here, then keep looking)

- LDR — [Wikipedia: Photoresistor](https://en.wikipedia.org/wiki/Photoresistor), including the power law and light history
- DS18B20 — [Analog Devices datasheet](https://www.analog.com/media/en/technical-documentation/data-sheets/DS18B20.pdf): resolution, accuracy, conversion time, OneWire
- OneWire — [Wikipedia: 1-Wire](https://en.wikipedia.org/wiki/1-Wire) and the [Arduino OneWire library](https://github.com/PaulStoffregen/OneWire), [DallasTemperature library](https://github.com/milesburton/Arduino-Temperature-Control-Library)
- Light measurement — [Wikipedia: Inverse-square law](https://en.wikipedia.org/wiki/Inverse-square_law); a phone lux meter is a relative reference, not a calibration standard
- Calibration and uncertainty — [Wikipedia: Calibration](https://en.wikipedia.org/wiki/Calibration), [Measurement uncertainty](https://en.wikipedia.org/wiki/Measurement_uncertainty), and the [GUM](https://www.bipm.org/en/publications/guides/gum.html)
- Filtering — [Moving average](https://en.wikipedia.org/wiki/Moving_average), [Median filter](https://en.wikipedia.org/wiki/Median_filter), [Exponential smoothing](https://en.wikipedia.org/wiki/Exponential_smoothing)
- Optional declarative filters — [IoTempower documentation](https://github.com/iotempire/iotempower)
- Your sensor datasheets — linked from the [resource bank](./Z-resources-bank.md#datasheets--standards-to-read-once)

### Questions to ask an LLM (then verify against your measurements)

Ask your co-pilot — but treat every answer as a **claim to test**, not a fact. Good starting prompts:

- "Explain the difference between resolution, accuracy, and repeatability for a DS18B20. The datasheet says 0.0625 °C steps and ±0.5 °C accuracy — what does each number mean for a 2 °C frost alarm?"
- "My LDR divider gives a raw ADC code. Walk me through converting it to resistance, then to relative illuminance with the inverse-square law, and show me where the largest error comes from."
- "I have two light levels and a third validation level for an LDR. How do I fit a power law in log space, and how do I know whether a linear fit is good enough?"
- "My potentiometer/ADC chain has an offset and a gain error. Show me how to fit and validate a two-point correction, and how to tell whether the residual is noise or nonlinearity."
- "Compare a moving average, a median filter, and an exponential moving average for a noisy LDR signal. Give the latency and the failure mode of each."
- "How do I write an honest uncertainty budget for an LDR measurement with a phone lux meter, a 12-bit ADC, and a lamp at measured distances? Include the fit residual."

> Run each prompt against your own measurements, and record where the model is wrong, vague, or over-confident.

## ✅ Suggested portfolio evidence (proofs of the learning goals)

1. LDR transfer-function plot: `log R` vs. `log E`, the fitted slope and residual, and the linear-fit comparison.
2. DS18B20 characterization: resolution settings and step sizes, unit-to-unit table, and the response-time curve (`τ` in air vs. water).
3. Calibration table: chain before/after error at the validation point; LDR log-fit prediction vs. the measured third point; DS18B20 offset check and its residual against the datasheet accuracy.
4. Hysteresis/repeatability: LDR up/down curves, potentiometer repeat-set spread, DS18B20 repeat readings at two resolutions; the effect you measured and the effect you did not.
5. Noise table: standard deviation raw vs. moving average vs. median vs. EMA, plus the step-latency measurement on the potentiometer.
6. Uncertainty statement for one final value (`y ± U`, `k = 2`) with the dominant contribution named.
7. The one-sentence answer to Elif at 2 °C, with the uncertainty.
8. Deeper question: Which error in your chain is systematic and could be calibrated, and which is random and must be averaged or accepted? Which is resolution, and which is accuracy?


> [!IMPORTANT]
> Never commit secrets, credentials, or personal data. Where you did not work entirely alone, link your pod mates and sources.

## 📚 If you want to go deeper

- [Wikipedia: Photoresistor](https://en.wikipedia.org/wiki/Photoresistor) — the power law, spectral response, and light history.
- [DS18B20 datasheet](https://www.analog.com/media/en/technical-documentation/data-sheets/DS18B20.pdf) — resolution, accuracy, conversion time, and the 1-Wire interface.
- [Wikipedia: 1-Wire](https://en.wikipedia.org/wiki/1-Wire) — one data wire, ROM IDs, and the pull-up.
- [Wikipedia: Inverse-square law](https://en.wikipedia.org/wiki/Inverse-square_law) — why a lamp at twice the distance gives a quarter of the illuminance.
- [Wikipedia: Calibration](https://en.wikipedia.org/wiki/Calibration) — one-point, two-point, and multi-point calibration.
- [Measurement uncertainty](https://en.wikipedia.org/wiki/Measurement_uncertainty) and the [GUM](https://www.bipm.org/en/publications/guides/gum.html) — how to state `y ± U` honestly.
- [Moving average](https://en.wikipedia.org/wiki/Moving_average), [Median filter](https://en.wikipedia.org/wiki/Median_filter), [Exponential smoothing](https://en.wikipedia.org/wiki/Exponential_smoothing) — the filters you will compare.
- [IoTempower](https://github.com/iotempire/iotempower) — optional declarative filters and node definitions.
- [Wikipedia: Thermistor](https://en.wikipedia.org/wiki/Thermistor) — the NTC in the story's failed first prototype, if you want the backstory.

---

[← Previous: Module 2](./02-i2c-and-sensor-addressing.md) | [Back to front page](../README.md) | [Quick module index](./00-index.md) | [Next: Module 4 — Distance, Motion & Environment Sensors →](./04-distance-motion-and-environment-sensors.md)
