# Portfolio Prompts Bank – Sensors and Actuators

*Use these prompts to guide your reflections and portfolio entries. You may choose any 3–5 prompts per module (mixing technical, measurement, and process reflections). Write 1–2 paragraphs per answer; include tables, plots, screenshots, and code where relevant.*

[← Back to Module Index](./00-index.md) | [Back to Resources Bank](./Z-resources-bank.md)

## 🧠 LLM verification drills (use in every module)

AI is a **drafting tool**, not an oracle. For each module, pick at least one prompt, run it, and record in your `study-log.md`: the prompt, a 2–3 line summary, **how you verified it**, and where the model was wrong.

- **Explain-and-test:** "Explain `<concept>` in three levels — a peer, a technician, a customer — then give me one measurement or experiment that would prove you right."
- **Debug my reasoning:** "Here is my wiring and my code: `<paste>`. What is the most likely failure, and what should I measure first?"
- **Break the answer:** "Give me three ways this result could be wrong or misleading, and the experiment that would expose each."
- **Translate a datasheet:** "Here is the relevant datasheet page: `<paste>`. Extract the conditions behind the accuracy number and the register I need for a raw reading."
- **Design a characterization:** "Design a five-point experiment to determine the transfer function and hysteresis of `<sensor>` with the equipment in our kit."
- **Challenge a claim:** "I measured `<value>` with `<method>`. What could make this measurement systematically wrong, and how would I check?"

> [!WARNING]
> Never paste credentials, private keys, or personal data into a public LLM. Treat every generated circuit, register value, and formula as a hypothesis — verify it against the datasheet, the multimeter, and a live measurement.

## 🤝 Pod discussion prompts

Use these to end a pod-study block with **agreed learning** and one shared artefact:

- "What is the one sentence we would put on the whiteboard to explain this concept to another pod?"
- "Which of our measurements surprised us, and why?"
- "Where did the LLM mislead us, and how did we catch it?"
- "What is the smallest demonstration that would convince a skeptic that we understand this?"

## 📌 Module 1 – Foundations: Electronics, Arduino & Measurement
*Focus: transducer, error/uncertainty, accuracy vs. precision, basic electronics, button pull-up/pull-down and debouncing, Arduino serial console and plotting, ADC, LDR, filtering.*

1. Technical: *The chain:* Draw the full chain for one sensor and mark where each kind of error enters.
2. Technical: *ADC precision dance:* Report your observed code range, step count, and step size, and compare with the theoretical `Vref/2^n`.
3. Technical: *Accuracy vs. precision:* Give one example from your own measurements of a precise-but-inaccurate and an accurate-but-imprecise result.
4. Technical: *Actuator and button basics:* Explain the LED/relay as an actuator and the button as a digital sensor, including the resistor calculation, pull-up/pull-down choice, and debounce.
5. Technical: *LDR and filtering:* Show the LDR transfer behavior and compare raw, average, median, and cutoff output — what did each fix and what did it cost?
6. Process: *Serial console and visualization:* Which tool did you use to inspect and plot your data, what did the plot reveal, and how did `delay()` versus `millis()` affect your sampling?

## 📌 Module 2 – Buses & I²C
*Focus: bus landscape, simple pins/PWM/divider, I²C physics, addresses, registers, conflicts, scope/analyzer choice.*

1. Technical: *Bus comparison:* Pick two buses (e.g. RS-485 and I²C) and compare wiring, signaling, topology, speed/length, and one use case each.
2. Technical: *Simple pins vs. bus:* Why is PWM not a bus? What does a bus add (addressing, framing, error handling, multi-drop)?
3. Technical: *UART to RS-485:* What does the transceiver add to a plain UART link, and why does that make a 20 m multi-drop run possible?
4. Technical: *Voltage divider:* Show your `Vout` calculation, the measured value, and why the divider is needed.
5. Technical: *Instrument choice:* Which scope/analyzer did the class adopt, what sample rate and input range does it have, and which signals can it not capture?
6. Technical: *Scan map:* Show your scan output and map each address to its module and datasheet.
7. Technical: *Raw vs. library:* Present the raw register value, your datasheet-based reconstruction, and the library value — and explain any mismatch.
8. Hybrid: *Conflict resolution:* Describe the address conflict you created and exactly how you resolved (or would resolve) it.
9. Project Context: *Why not just add pins?* Explain why one data pair for many devices is elegant, and name its limits.

## 📌 Module 3 – Sensor Characterization, Calibration & Data Quality
*Focus: transfer function, linearity, hysteresis, calibration, uncertainty, filtering.*

1. Technical: *Transfer function:* Show your plot and fit; report sensitivity and residuals.
2. Technical: *Calibration:* Compare error before and after two-point calibration, and report the independent validation point.
3. Technical: *Noise vs. latency:* Present your raw/mean/median noise numbers and the latency each filter adds.
4. Process: *Uncertainty honesty:* Write your uncertainty budget and state `y ± U`. Which contribution dominates, and why?

## 📌 Module 4 – Distance, Motion & Environment Sensors
*Focus: ToF/ultrasonic/IR, IMU, Hall/current, environment sensors.*

1. Technical: *ToF characterization:* Report error and repeatability across the range and for different targets.
2. Technical: *Principle comparison:* Give one task each where IR, ultrasonic, and ToF win — with justification.
3. Hybrid: *People counter:* Present your state machine, timing window, and the false detections you observed.
4. Technical: *IMU drift:* Show the gyro drift over time and the effect of your complementary filter.

## 📌 Module 5 – LEDs & Light as Output
*Focus: current limiting, PWM/gamma, RGB mixing, addressable strips, power budget.*

1. Technical: *Resistor math:* Show predicted vs. measured forward voltage and current.
2. Technical: *Gamma:* Explain why a linear duty ramp looks wrong and how gamma correction fixed it.
3. Technical: *Power budget:* Compare calculated and measured strip current for the three states and justify your supply.
4. Project Context: *Installation realism:* What would you change about your strip wiring for a permanent installation?

## 📌 Module 6 – LED Animation, Sound & Interactive Installations
*Focus: non-blocking animation, palettes, sensor/sound interaction, installation constraints.*

1. Technical: *Animation architecture:* Explain your `millis()`-based loop and why `delay()` would break the interaction.
2. Technical: *Color space:* Why is HSV easier than RGB for animation? Show a parameter change that made an effect better.
3. Hybrid: *Interaction:* Describe your sensor→animation mapping and the hysteresis you needed.
4. Project Context: *Two-hour show:* What did you have to consider about power, heat, and mounting to make it survive a long run?

## 📌 Module 7 – Motors & Motion Actuators
*Focus: servo, DC motor + H-bridge, stepper, drivers, current, safety.*

1. Technical: *Stall current:* Report measured running vs. stall current and explain why a supply/driver must be sized for stall.
2. Technical: *Actuator selection:* For a pointer gauge, a wheel, and a precise dial, pick servo/DC/stepper with justification.
3. Hybrid: *Sensor→motor logic:* Present your control rule, hysteresis, and safety interlock.
4. Process: *Safety near-miss or lesson:* Document one wiring/current/ground lesson you will not forget.

## 📌 Module 8 – From Sensor to System: MQTT & Integration
*Focus: MQTT publishing/commands, filters, Node-RED, control loops, failures; optional IoTempower comparison.*

1. Technical: *Direct vs. declarative:* What did you have to implement yourself for MQTT (connect, reconnect, topics, payloads), and what would an optional IoTempower node remove?
2. Technical: *Filter choice:* Which filter and window did you choose for your sensor, and what did it cost in latency?
3. Hybrid: *Closed loop:* Describe your control rule and how you arbitrated manual vs. automatic control.
4. Process: *Fault injection:* Which of the four faults did your system survive, and what did you fix afterward?

## 📌 Module 9 – Final Project Studio
*Focus: requirements, integration, characterization, evaluation, resilience.*

1. Technical: *Characterization explanation:* Explain your transfer function/calibration and the uncertainty you report from the submitted evidence.
2. Technical: *Evaluation:* Present the actuator performance and one system metric (latency, rate, current) with conditions.
3. Project Context: *Architecture split:* Which processing lives on the node and which in the integration layer — and why?
4. Process: *Peer review value:* What blind spot did your review team find, and how did you fix it before the presentation?

## 📌 Module 10 – Project Presentation & Submitted Artifacts
*Focus: submitted slide deck, demo artifacts, portfolio walkthrough, retrospective.*

1. Technical: *The live demo:* Summarize how your system performed, including the fault-injection challenge.
2. Technical: *What I measured:* Which single measurement from this course are you most confident in, and why?
3. Personal Retrospective: *The biggest "Aha!" moment:* From an ADC code to a characterized system — what changed in how you think about sensors?
4. Looking Ahead: How will you use characterization and actuator skills in your next project, thesis, or job?
