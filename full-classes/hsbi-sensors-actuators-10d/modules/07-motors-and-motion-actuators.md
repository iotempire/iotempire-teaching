# Module 7 – Motors & Motion Actuators

[← Back to Module 6](./06-led-animation-sound-and-installations.md) | [Quick module index](./00-index.md) | [Next: Module 8 →](./08-sensor-to-system-and-integration.md)

> Now the node moves things. Servos, DC motors, and steppers each solve a different motion problem — and each has its own driver, current draw, and safety rules.

**Course placement:** Day 7 — the motion-actuator studio. Servos, DC motors, and steppers each solve a different motion problem.

## 🎯 Learning Goals

This module gives you the opportunity to explore motion actuation and achieve competency in servo, DC-motor, and stepper control, driver selection, and current/torque/safety.

By the end of this module, you can:
1. Place actuators in the classical taxonomy: mechanical, thermal, optical, unconventional — and choose appropriately.
2. Control a servo by position with a 50 Hz PWM signal.
3. Control a brushed DC motor's speed and direction with an H-bridge and PWM.
4. Step a stepper motor precisely and explain the difference from the other two.
5. Measure motor current, recognize stall, and follow the safety rules for motor supplies and grounds.
6. Couple a sensor to a motor with a simple control logic.


**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 📖 Story — The Gate That Would Not Hold

**Brinkmann Maschinenbau GmbH** is automating a small material gate on a test rig. Workshop lead **Hendrik Brinkmann** has three candidate actuators on the bench: a hobby servo, a geared DC motor with an H-bridge, and a 28BYJ-48 stepper. The servo is easy to position but buzzes and overheats when the gate is held closed. The DC motor is strong but has no idea where the gate is. The stepper is precise but loses steps when the gate jams.

Hendrik asks the question that separates a prototype from a machine: *"What does the actuator have to do, and what does it cost in current, torque, and control complexity?"* Today you drive all three, measure running and stall current, and couple a sensor to a motor with a safe control rule.

## 📖 Pod Study: Choosing and Driving a Motion Actuator

This is **self/pod study, not a lecture.** Work through the concepts below with your Task Pod, look things up, ask an LLM, and keep notes — the goal is a shared mental model you can explain in the checkpoint.

### The Actuator Landscape

The classical taxonomy (from the module handbook) is still the right map:

| Family | Examples | Strength | Limitation | Where you meet it here |
|---|---|---|---|---|
| Mechanical — electric | DC motor, servo, stepper, solenoid | Precise, clean, efficient at small scale | Needs a driver; stall current; a DC motor has no position sense | Tasks 1–4 |
| Mechanical — fluid | Hydraulic and pneumatic cylinders, valves, pumps, fans | Very high force density; a hydraulic load can hold without power | Pump/compressor, leaks, springy pneumatics, stored pressure | Reading below; pump/valve stretcher |
| Thermal | Resistive heater, Peltier cooler | Simple, no moving parts, even heat | Slow; cooling has a COP well below 1; the hot side needs a heatsink | Stretcher: Peltier |
| Optical | LED, dimmer, blinds, electrochromic glass | Fast, precise, no wear | Nonlinear perception, heat, driver | Modules 5–6 (LEDs, dimming); shading as reading |
| Unconventional | Piezo, electrostrictive, magnetostrictive, shape memory | High force at a tiny stroke, or high frequency | Small stroke, hysteresis, high drive voltage, fatigue | Reading below; buzzer and ultrasonic transducer |

Choosing an actuator is a requirements question: how much force/torque, how fast, how precise, how often, and at what power?

Optical actuation is not only “LED on”: dimming (PWM, or phase-cut for mains lamps), shading (blinds, electrochromic glass), and projection all change light deliberately. Perceived brightness is nonlinear, which is why Module 5 applies gamma. The three sections after the stepper are **reading homework** — you will not drive them today, but you must be able to compare them.

### Brushed DC Motors

A brushed DC motor spins fast and is easy to drive, but gives no position feedback by itself.

- Speed roughly follows voltage; direction reverses with polarity.
- Current is the real constraint. Running current is modest; stall current (blocked shaft) can be many times higher and will destroy an H-bridge or supply sized only for running current.
- Motors are inductive: switching them produces voltage spikes. Drivers include flyback diodes — do not drive a motor with a bare transistor and no protection.
- Control with an H-bridge (e.g. TB6612, L298N): two direction inputs plus a PWM enable pin give speed and direction. The motor gets its own supply; grounds must be common with the MCU.

### Servos

A hobby servo contains a motor, gears, and a feedback potentiometer. It is a closed-loop position device you command by pulse width:

- 50 Hz PWM, pulse width ≈ 1 ms → 0°, 1.5 ms → center, 2 ms → 180° (typical, varies by model).
- The servo holds its position while powered and resists being moved — it draws current to do so.
- Servos can draw several hundred mA to >1 A under load or when stalled; power them from a separate 5 V supply, with the signal from the MCU and a common ground.
- Do not command a servo beyond its mechanical range; it will buzz and heat.

### Stepper Motors

A stepper moves in discrete steps (e.g. 28BYJ-48 with ULN2003 driver) — ideal for precise, repeatable positioning without feedback, though without position feedback it can still "lose steps" if overloaded.

- Control by sequencing coils (full-step vs. half-step); a driver IC handles the current and the flyback.
- It has holding torque when powered (and gets warm), and its torque falls as step rate rises.
- Great for: precise dials, linear stages, valves, camera sliders. Poor for: high-speed continuous spinning without a suitable driver.

> [!WARNING]
> Motor safety rules. Never power a motor, servo, or pump from the MCU's pins or 3.3 V rail. Use a motor supply sized for stall current, keep a common ground, add decoupling, and disconnect power before rewiring.

### Fluid Power: Hydraulics and Pneumatics

Hydraulics pushes incompressible oil; pneumatics pushes compressed air. Both buy force density: a small cylinder moves a heavy load slowly, and a hydraulic load can hold position with the pump off. The price is infrastructure — pump or compressor, reservoir, filtration, hoses, and valves (directional for on/off, proportional for throttling). Pneumatics is fast and cheap but springy, so intermediate positions are hard to hold; hydraulics is stiff and precise but leaks and stores energy. The bilge pump and the fuel valve from Module 4 are fluid-power components you would rather monitor than guess at. Never deadhead a pump — give it a relief path — and remember that stored pressure is dangerous after the power is off.

### Thermal Actuators: Heating and Cooling

A resistive heater turns electrical energy into heat at a coefficient of performance (COP) of 1 by definition: every watt becomes heat. A Peltier element is a heat pump — it moves heat from the cold side to the hot side, so it can cool below ambient — but its COP is typically well below 1, and the hot side needs a heatsink or it stops working. Thermal systems are slow: a thermal resistance and heat capacity give a time constant `τ = R_th · C_th`, and on/off control overshoots without hysteresis. Cooling is harder than heating because you must move heat, not create cold. That makes enclosure cooling a system problem, not a component choice.

### Unconventional Actuators: Piezo, Magnetostrictive, Shape Memory

These trade stroke for force or bandwidth. A piezo element moves only micrometres, but at high force and high frequency, driven by tens to hundreds of volts; it shows hysteresis, so position control needs feedback or charge control. The same effect in reverse is your buzzer and the ultrasonic transducer from Module 4. Magnetostrictive materials strain in a magnetic field, and shape-memory alloys change shape with temperature — strong, slow, and subject to fatigue. In all of them the drive electronics, not the actuator, dominate the design.

### Pointers (start here, then keep looking)

- Servos — [Wikipedia: Servomotor](https://en.wikipedia.org/wiki/Servomotor), and the SG90 datasheet (pulse widths, stall current)
- Brushed DC motors and H-bridges — [Wikipedia: Brushed DC electric motor](https://en.wikipedia.org/wiki/Brushed_DC_electric_motor), [H-bridge](https://en.wikipedia.org/wiki/H-bridge)
- Steppers — [Wikipedia: Stepper motor](https://en.wikipedia.org/wiki/Stepper_motor), and the 28BYJ-48/ULN2003 datasheet
- Driver selection — the TB6612/L298N datasheets in the [resource bank](./Z-resources-bank.md#datasheets--standards-to-read-once)
- Fluid power — [Hydraulic machinery](https://en.wikipedia.org/wiki/Hydraulic_machinery), [Pneumatics](https://en.wikipedia.org/wiki/Pneumatics)
- Thermal — [Thermoelectric cooling](https://en.wikipedia.org/wiki/Thermoelectric_cooling)
- Unconventional — [Piezoelectric actuator](https://en.wikipedia.org/wiki/Piezoelectric_actuator), [Magnetostriction](https://en.wikipedia.org/wiki/Magnetostriction), [Shape-memory alloy](https://en.wikipedia.org/wiki/Shape-memory_alloy)
- Safety — the [resource bank's formulas and power guidance](./Z-resources-bank.md#power--instrumentation)

### Questions to ask an LLM (then verify against your hardware)

Ask your co-pilot — but treat every answer as a **claim to test**, not a fact. Good starting prompts:

- "Compare a hobby servo, a brushed DC motor with an H-bridge, and a stepper for a gate that must hold position. Which would you choose and why?"
- "Explain stall current and why a driver/supply must be sized for it, not for the running current. Give me a measurement procedure."
- "Why does a motor need a flyback path, and what happens to an H-bridge without one?"
- "Explain servo pulse widths at 50 Hz and how to command an angle without blocking the loop."
- "My stepper loses steps when the load jams. What are the mechanical and electrical causes, and how would I detect a stall?"
- "When would you choose a pneumatic cylinder over a geared DC motor for a gate? Compare force, speed control, cost, and safety."
- "Why is a Peltier cooler's COP usually below 1 while a heater's is 1? What does that mean for a battery-powered enclosure?"
- "Why does a piezo actuator need a special driver, and why does its hysteresis matter for positioning?"

> Run each prompt against your own actuators, and record where the model is wrong, vague, or over-confident.

### ★ Task A: Study in your pod

Work through the concepts above with your Task Pod and write it up under `## Study log` in `Module07/README.md` — a section, not a file, unless it outgrows the page. **One pod member keeps the shared log; the others link to that section from their own module README and add one sentence on what they took from it.**

1. **The references you used** — the source and the one concept you understood best from it.
2. **Things you googled** — the term, what you found, and the source (URL). One line each.
3. **Remarkable things** — surprises, "aha"s, and counterexamples from your own measurements.
4. **LLM Q&A** — for each prompt: the prompt, a 2–3 line summary, and **how you verified it** (and where it was wrong).
5. **Your two best found actuator-selection tables or driver diagrams** — compile down to the best two, with source and what they taught you.
6. **The families you did not drive** — one short paragraph each for fluid power, thermal, and unconventional actuation: what it is for, what it costs, and one failure mode.

*Portfolio evidence:* the `## Study log` section (yours, or a link to your pod's shared one).

### ★ Task B: Explain & share with another pod

Pair with a **neighbouring pod**:

1. **Explain to each other** — each pod walks the other through its actuator comparison and its current measurements; ask questions and fill each other's gaps.
2. Agree on the **3–5 most noteworthy points** and the **learning you jointly stand behind** (e.g. *"size the supply for stall, not for running"*).
3. **Clean up your documentation** — update the `## Study log` with what you learned from the other pod.
4. Agree on **one shared artefact** — the best actuator-selection table, a wiring diagram, or a current plot the two pods make together — and **post it in the course Discord**, with a one-sentence note on why you chose it.
5. Each member adds a short **“Agreed learning (pod discussion)”** note — in the shared log, or in your own module README with a link to it.

*Portfolio evidence:* the cleaned-up `## Study log` (with the **“Agreed learning (pod discussion)”** note) and your pod-pair's shared artefact.

## In-Class Lab: Make It Move — **Challenging**

*Hardware:* SG90 servo, small DC motor, 28BYJ-48 stepper + ULN2003, H-bridge driver (TB6612/L298N), separate 5 V supply, multimeter, USB power meter.

### ★ Task 1: Servo by Position

1. Connect the servo signal to a PWM-capable pin, and the servo's power to the separate 5 V supply (common ground).
2. Sweep the servo across its range with a smooth, non-blocking update (no `delay()` blocking your loop — Module 6 habits).
3. Measure the servo's current with the meter: idle/holding, sweeping, and blocked (gently hold the arm). Note the difference.
4. Add a serial command (`0`–`180`) so you can set the angle by typing.

### ★ Task 2: DC Motor Speed and Direction

1. Wire the motor to an H-bridge; connect the H-bridge logic to the MCU and the motor supply to the separate 5 V rail (common ground).
2. Drive the motor forward and reverse, and vary speed with PWM on the enable pin.
3. Measure the current at low speed, high speed, and with the shaft gently blocked (stall). Record the stall current — this is why driver ratings matter.
4. Observe the motor's behavior at very low duty cycles (a motor may not even start) and explain why.

### ★ Task 3: Precise Steps with the Stepper

1. Drive the 28BYJ-48 through the ULN2003 in full-step and then half-step mode.
2. Command an exact number of steps (e.g. one revolution) and verify the angle against a protractor/mark.
3. Compare positional precision with the servo and speed with the DC motor in one sentence each.
4. Note how warm the motor becomes while holding position.

### ★ Task 4: Sensor in the Loop

Join a sensor to a motor with real control logic:

1. Use a distance sensor (Module 4) to set a servo angle (e.g. a pointer/gauge driven by measured distance), or start/stop the DC motor when an object is detected.
2. Add hysteresis (a dead band) so the actuator does not chatter at the threshold.
3. Add a safety condition (e.g. never run the motor if a limit/beam is broken).
4. Test with moving objects and document the timing and any jitter.

### ◇ Task 5 (Stretcher): Thermal Actuator and Context

1. If available, power a Peltier element through a suitable driver and measure its current, the temperature change, and how hot the hot side gets. Relate this to "thermal actuators" from the taxonomy.
2. Or research a pump/valve working point (flow, pressure, voltage, current) for the fountain/flow projects and write a short engineering note on how you would drive it safely.

## ✅ Suggested portfolio evidence (proofs of the learning goals)

1. Servo evidence: wiring, angle sweep, and measured current (idle/sweep/stall).
2. H-bridge notes: your truth table for direction + PWM, and the measured stall current.
3. Stepper evidence: full/half-step sequence, commanded vs. measured rotation.
4. Sensor→motor logic: the control rule, the hysteresis, and the safety interlock.
5. Actuator choice table: for three tasks (pointer gauge, wheel, precise dial), pick servo/DC/stepper and justify by torque, precision, and control complexity.
6. Five-family comparison: one row per family (electric, fluid, thermal, optical, unconventional) with principle, typical use, strength, limitation, and one failure mode — from the reading, no hardware needed.
7. Deeper question: Why is "the motor turns" not enough information to design a supply or driver?


> [!IMPORTANT]
> Never commit secrets, credentials, or personal data. Where you did not work entirely alone, link your pod mates and sources.

## 📚 If you want to go deeper

- [Wikipedia: Servomotor](https://en.wikipedia.org/wiki/Servomotor) — the closed-loop hobby servo and its pulse-width command.
- [Brushed DC electric motor](https://en.wikipedia.org/wiki/Brushed_DC_electric_motor) and [H-bridge](https://en.wikipedia.org/wiki/H-bridge) — speed, direction, and flyback.
- [Stepper motor](https://en.wikipedia.org/wiki/Stepper_motor) — full-step, half-step, holding torque, and lost steps.
- The TB6612/L298N datasheets — linked from the [resource bank](./Z-resources-bank.md#datasheets--standards-to-read-once).
- [Hydraulic machinery](https://en.wikipedia.org/wiki/Hydraulic_machinery) and [pneumatics](https://en.wikipedia.org/wiki/Pneumatics) — force density, valves, and why compressed air is springy.
- [Thermoelectric cooling](https://en.wikipedia.org/wiki/Thermoelectric_cooling) — why a Peltier moves heat instead of making cold.
- [Piezoelectric actuator](https://en.wikipedia.org/wiki/Piezoelectric_actuator), [magnetostriction](https://en.wikipedia.org/wiki/Magnetostriction), and [shape-memory alloy](https://en.wikipedia.org/wiki/Shape-memory_alloy) — the unconventional families.
- The [resource bank's power guidance](./Z-resources-bank.md#power--instrumentation) — measuring current safely.

---

[← Previous: Module 6](./06-led-animation-sound-and-installations.md) | [Back to front page](../README.md) | [Quick module index](./00-index.md) | [Next: Module 8 — From Sensor to System →](./08-sensor-to-system-and-integration.md)
