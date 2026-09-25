# Portfolio Prompts Bank – Sensors and Actuators

*Use these prompts to guide your reflections and portfolio entries. You may choose any 3–5 prompts per module (mixing technical, measurement, and process reflections). Write 1–2 paragraphs per answer; include tables, plots, screenshots, and code where relevant.*

[← Back to Module Index](./00-index.md) | [Back to Resources Bank](./Z-resources-bank.md)

---

## 📌 Module 1 – Foundations: Measurement, Signals & the Chain
*Focus: transducer, error/uncertainty, accuracy vs. precision, ADC, sampling, quantization.*

1. **Technical:** *The chain:* Draw the full chain for one sensor and mark where each kind of error enters.
2. **Technical:** *ADC precision dance:* Report your observed code range, step count, and step size, and compare with the theoretical `Vref/2^n`.
3. **Technical:** *Accuracy vs. precision:* Give one example from your own measurements of a precise-but-inaccurate and an accurate-but-imprecise result.
4. **Process:** *Master Class first impressions:* What was smooth about getting a sensor onto the dashboard, and where did you get stuck?

---

## 📌 Module 2 – I²C & Sensor Addressing
*Focus: bus physics, addresses, register maps, conflicts, bus comparison.*

1. **Technical:** *Scan map:* Show your scan output and map each address to its module and datasheet.
2. **Technical:** *Raw vs. library:* Present the raw register value, your datasheet-based reconstruction, and the library value — and explain any mismatch.
3. **Hybrid:** *Conflict resolution:* Describe the address conflict you created and exactly how you resolved (or would resolve) it.
4. **Project Context:** *Why not just add pins?* Explain why one data pair for many devices is elegant, and name its limits.

---

## 📌 Module 3 – Sensor Characterization, Calibration & Data Quality
*Focus: transfer function, linearity, hysteresis, calibration, uncertainty, filtering.*

1. **Technical:** *Transfer function:* Show your plot and fit; report sensitivity and residuals.
2. **Technical:** *Calibration:* Compare error before and after two-point calibration, and report the independent validation point.
3. **Technical:** *Noise vs. latency:* Present your raw/mean/median noise numbers and the latency each filter adds.
4. **Process:** *Uncertainty honesty:* Write your uncertainty budget and state `y ± U`. Which contribution dominates, and why?

---

## 📌 Module 4 – Distance, Motion & Environment Sensors
*Focus: ToF/ultrasonic/IR, IMU, Hall/current, environment sensors.*

1. **Technical:** *ToF characterization:* Report error and repeatability across the range and for different targets.
2. **Technical:** *Principle comparison:* Give one task each where IR, ultrasonic, and ToF win — with justification.
3. **Hybrid:** *People counter:* Present your state machine, timing window, and the false detections you observed.
4. **Technical:** *IMU drift:* Show the gyro drift over time and the effect of your complementary filter.

---

## 📌 Module 5 – LEDs & Light as Output
*Focus: current limiting, PWM/gamma, RGB mixing, addressable strips, power budget.*

1. **Technical:** *Resistor math:* Show predicted vs. measured forward voltage and current.
2. **Technical:** *Gamma:* Explain why a linear duty ramp looks wrong and how gamma correction fixed it.
3. **Technical:** *Power budget:* Compare calculated and measured strip current for the three states and justify your supply.
4. **Project Context:** *Installation realism:* What would you change about your strip wiring for a permanent installation?

---

## 📌 Module 6 – LED Animation, Sound & Interactive Installations
*Focus: non-blocking animation, palettes, sensor/sound interaction, installation constraints.*

1. **Technical:** *Animation architecture:* Explain your `millis()`-based loop and why `delay()` would break the interaction.
2. **Technical:** *Color space:* Why is HSV easier than RGB for animation? Show a parameter change that made an effect better.
3. **Hybrid:** *Interaction:* Describe your sensor→animation mapping and the hysteresis you needed.
4. **Project Context:** *Two-hour show:* What did you have to consider about power, heat, and mounting to make it survive a long run?

---

## 📌 Module 7 – Motors & Motion Actuators
*Focus: servo, DC motor + H-bridge, stepper, drivers, current, safety.*

1. **Technical:** *Stall current:* Report measured running vs. stall current and explain why a supply/driver must be sized for stall.
2. **Technical:** *Actuator selection:* For a pointer gauge, a wheel, and a precise dial, pick servo/DC/stepper with justification.
3. **Hybrid:** *Sensor→motor logic:* Present your control rule, hysteresis, and safety interlock.
4. **Process:** *Safety near-miss or lesson:* Document one wiring/current/ground lesson you will not forget.

---

## 📌 Module 8 – From Sensor to System: IoTempower & Integration
*Focus: declarative nodes, filters, MQTT, Node-RED, control loops, failures.*

1. **Technical:** *Declarative vs. imperative:* What boilerplate disappeared when you moved to an IoTempower node?
2. **Technical:** *Filter choice:* Which filter and window did you choose for your sensor, and what did it cost in latency?
3. **Hybrid:** *Closed loop:* Describe your control rule and how you arbitrated manual vs. automatic control.
4. **Process:** *Fault injection:* Which of the four faults did your system survive, and what did you fix afterward?

---

## 📌 Module 9 – Final Project Studio
*Focus: requirements, integration, characterization, evaluation, resilience.*

1. **Technical:** *Characterization defense:* Defend your transfer function/calibration and the uncertainty you report.
2. **Technical:** *Evaluation:* Present the actuator performance and one system metric (latency, rate, current) with conditions.
3. **Project Context:** *Architecture split:* Which processing lives on the node and which in the integration layer — and why?
4. **Process:** *Peer review value:* What blind spot did your review team find, and how did you fix it before the defense?

---

## 📌 Module 10 – Demonstration & Portfolio Defense
*Focus: live demo, technical defense, retrospective.*

1. **Technical:** *The live demo:* Summarize how your system performed, including the fault-injection challenge.
2. **Technical:** *What I measured:* Which single measurement from this course are you most confident in, and why?
3. **Personal Retrospective:** *The biggest "Aha!" moment:* From an ADC code to a characterized system — what changed in how you think about sensors?
4. **Looking Ahead:** How will you use characterization and actuator skills in your next project, thesis, or job?
