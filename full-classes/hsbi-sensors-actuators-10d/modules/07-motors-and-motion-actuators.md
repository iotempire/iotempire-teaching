# Module 7 – Motors & Motion Actuators

[← Back to Module 6](./06-led-animation-sound-and-installations.md) | [Quick module index](./00-index.md) | [Next: Module 8 →](./08-sensor-to-system-and-integration.md)

> **Now the node moves things.** Servos, DC motors, and steppers each solve a different motion problem — and each has its own driver, current draw, and safety rules.

## 🎯 Learning Goals

> **How these are assessed:** You earn this module's points by **proving these goals** in a short (~10-minute) checkpoint presentation with the instructor (see the [syllabus](../syllabus.md#how-module-points-are-earned-checkpoint-presentations)) — based on your portfolio and reflections, not on completing every task. You may skip tasks, fail at some, or add your own; documented exploration and demonstrated deep understanding both count in your favor.

This module gives you the opportunity to explore **motion actuation** and achieve competency in **servo, DC-motor, and stepper control, driver selection, and current/torque/safety**.

By the end of this module, you can:
1. Place actuators in the classical taxonomy: **mechanical, thermal, optical, unconventional** — and choose appropriately.
2. Control a **servo** by position with a 50 Hz PWM signal.
3. Control a **brushed DC motor's** speed and direction with an **H-bridge** and PWM.
4. Step a **stepper motor** precisely and explain the difference from the other two.
5. Measure motor **current**, recognize **stall**, and follow the safety rules for motor supplies and grounds.
6. Couple a **sensor to a motor** with a simple control logic.

> [!WARNING]
> **DRAFT — first taught in WS 2026/27.** Everything below this line is a working draft and will likely change as we refine it together in class; the line moves down as we approve content. Your input is welcome and can shape this module.

**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 📖 Part A — The Actuator Landscape

The classical taxonomy (from the module handbook) is still the right map:

| Type | Examples | Where you meet it here |
|---|---|---|
| **Mechanical** | Electric motors, hydraulic/pneumatic cylinders, valves, pumps, fans | Servo, DC motor, stepper, (pump/valve as stretcher) |
| **Thermal** | Heaters, Peltier coolers | Stretcher: Peltier element, power/heat measurement |
| **Optical** | Lamps, dimming, shading | Modules 5–6: LEDs and animation |
| **Unconventional** | Piezo, electrostrictive, magnetostrictive, shape-memory | Buzzer/Piezo, discussed as context |

Choosing an actuator is a requirements question: **how much force/torque, how fast, how precise, how often, and at what power?**

## 📖 Part B — Brushed DC Motors

A brushed DC motor spins **fast** and is easy to drive, but gives no position feedback by itself.

- Speed roughly follows voltage; direction reverses with polarity.
- **Current is the real constraint.** Running current is modest; **stall current** (blocked shaft) can be many times higher and will destroy an H-bridge or supply sized only for running current.
- Motors are **inductive**: switching them produces voltage spikes. Drivers include **flyback diodes** — do not drive a motor with a bare transistor and no protection.
- Control with an **H-bridge** (e.g. TB6612, L298N): two direction inputs plus a **PWM** enable pin give speed and direction. The motor gets its own supply; **grounds must be common** with the MCU.

## 📖 Part C — Servos

A hobby servo contains a motor, gears, and a feedback potentiometer. It is a **closed-loop position device** you command by pulse width:

- **50 Hz** PWM, pulse width ≈ **1 ms → 0°**, **1.5 ms → center**, **2 ms → 180°** (typical, varies by model).
- The servo holds its position while powered and resists being moved — it draws current to do so.
- Servos can draw **several hundred mA to >1 A** under load or when stalled; **power them from a separate 5 V supply**, with the signal from the MCU and a common ground.
- Do not command a servo beyond its mechanical range; it will buzz and heat.

## 📖 Part D — Stepper Motors

A stepper moves in **discrete steps** (e.g. 28BYJ-48 with ULN2003 driver) — ideal for precise, repeatable positioning without feedback, though without position feedback it can still "lose steps" if overloaded.

- Control by sequencing coils (**full-step** vs. **half-step**); a driver IC handles the current and the flyback.
- It has **holding torque** when powered (and gets warm), and its torque falls as step rate rises.
- Great for: precise dials, linear stages, valves, camera sliders. Poor for: high-speed continuous spinning without a suitable driver.

> [!WARNING]
> **Motor safety rules.** Never power a motor, servo, or pump from the MCU's pins or 3.3 V rail. Use a motor supply sized for **stall** current, keep a **common ground**, add decoupling, and disconnect power before rewiring.

## 🛠️ In-Class Lab: Make It Move

*Hardware:* SG90 servo, small DC motor, 28BYJ-48 stepper + ULN2003, H-bridge driver (TB6612/L298N), separate 5 V supply, multimeter, USB power meter.

### ★ Task 1: Servo by Position (35 min)

1. Connect the servo signal to a PWM-capable pin, and the servo's power to the **separate 5 V supply** (common ground).
2. Sweep the servo across its range with a smooth, non-blocking update (no `delay()` blocking your loop — Module 6 habits).
3. Measure the servo's current with the meter: idle/holding, sweeping, and **blocked** (gently hold the arm). Note the difference.
4. Add a serial command (`0`–`180`) so you can set the angle by typing.

### ★ Task 2: DC Motor Speed and Direction (40 min)

1. Wire the motor to an H-bridge; connect the H-bridge logic to the MCU and the motor supply to the separate 5 V rail (common ground).
2. Drive the motor forward and reverse, and vary speed with PWM on the enable pin.
3. Measure the current at low speed, high speed, and with the shaft **gently blocked** (stall). Record the stall current — this is why driver ratings matter.
4. Observe the motor's behavior at very low duty cycles (a motor may not even start) and explain why.

### ★ Task 3: Precise Steps with the Stepper (30 min)

1. Drive the 28BYJ-48 through the ULN2003 in **full-step** and then **half-step** mode.
2. Command an exact number of steps (e.g. one revolution) and verify the angle against a protractor/mark.
3. Compare **positional precision** with the servo and **speed** with the DC motor in one sentence each.
4. Note how warm the motor becomes while holding position.

### ★ Task 4: Sensor in the Loop (30 min)

Join a sensor to a motor with real control logic:

1. Use a distance sensor (Module 4) to set a **servo angle** (e.g. a pointer/gauge driven by measured distance), **or** start/stop the DC motor when an object is detected.
2. Add **hysteresis** (a dead band) so the actuator does not chatter at the threshold.
3. Add a safety condition (e.g. never run the motor if a limit/beam is broken).
4. Test with moving objects and document the timing and any jitter.

### ◇ Task 5 (Stretcher): Thermal Actuator and Context (30 min)

1. If available, power a **Peltier element** through a suitable driver and measure its current, the temperature change, and how hot the hot side gets. Relate this to "thermal actuators" from the taxonomy.
2. Or research a **pump/valve** working point (flow, pressure, voltage, current) for the fountain/flow projects and write a short engineering note on how you would drive it safely.

## 📝 Working-Day Reflection & Portfolio Tasks

In your portfolio under `modules/07-motors/`:
1. **Servo evidence:** wiring, angle sweep, and measured current (idle/sweep/stall).
2. **H-bridge notes:** your truth table for direction + PWM, and the measured stall current.
3. **Stepper evidence:** full/half-step sequence, commanded vs. measured rotation.
4. **Sensor→motor logic:** the control rule, the hysteresis, and the safety interlock.
5. **Actuator choice table:** for three tasks (pointer gauge, wheel, precise dial), pick servo/DC/stepper and justify by torque, precision, and control complexity.
6. **Reflection:** Why is "the motor turns" not enough information to design a supply or driver?
