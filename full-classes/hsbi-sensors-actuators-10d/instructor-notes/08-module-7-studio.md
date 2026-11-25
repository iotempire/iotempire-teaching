# Module 7 Studio — Motors & Motion Actuators

[Module 7](../modules/07-motors-and-motion-actuators.md) · [Architecture decisions](./00-architecture-decisions.md) · [All instructor notes](./README.md)

**Day 7 · three sessions · 8 school hours (360 minutes):** Praktikum 08:30–11:30, Übung 12:30–14:00, supervised self-study 14:15–15:45.

| | |
|---|---|
| **Prepare** | One motor set per two pods, multimeters, CP2 registration, the three reference sketches flashed |
| **Practice** | Measure the stall current of one DC motor yourself before the day — know the number |
| **Students leave with** | A servo at three angles, a DC motor at two speeds each way, a stepper that steps a known count, one honest current reading, CP2 feedback, and a project team with a story draft |
| **Must run** | CP2, servo, DC motor with the H-bridge, one current measurement, team formation |
| **Cut first** | The stepper (Task 3), then the `◇` stretcher — never the current measurement, never CP2 |

## Why this day is open

Modules 5 and 6 set the pattern: a small first win, then the bench, then an open end (D19, D24). Module 7 carries more handbook breadth than any other module — hydraulics, pneumatics, thermal and unconventional actuators — and none of it is on the bench. That breadth is **reading, not teaching** (D18): each pod reads one family and reports back in a minute. The bench time goes to the three actuators the students can actually hold.

This is also the largest single-module allocation in the course: 8 school hours, twice Module 5 or Module 6. It is not a day to fill; it is a day to let the motors run.

## Before the session

- **Pack per two pods:** one SG90-class servo, one small DC motor with a TB6612 or L298N driver, one 28BYJ-48 with its ULN2003 board, a separate 5 V supply, and jumpers. The Module 6 packing list already carries motors and joysticks; this day needs the driver boards with them.
- **Say the power rule out loud:** motors never run from the 3.3 V pin or the board's regulator. Separate 5 V, common ground, driver in between.
- **Flash the references.** Servo sweep, DC ramp in both directions, stepper N steps. If the agents are slow, the Module 5 backup sketches are the model for a non-AI fallback.
- **CP2 logistics.** Six pods × 10–12 minutes is 60–72 minutes — too long for one lane if three motors are also to run. Use two lanes where a second person is available, and register pods at the door so the first one starts at minute zero.

## Session 1 — 08:30–11:30 (180 minutes): CP2, servo, DC motor

| Time | Segment | What happens |
|---:|---|---|
| 0–30 | Checkpoint 2 | Modules 4–6, two lanes if possible; the rest of the room sets up its bench |
| 30–40 | Safety and the current rule | Separate 5 V, common ground, driver between logic and motor, multimeter in series |
| 40–95 | Task 1 — servo by position | Wire, sweep three angles, then drive the angle from a serial command |
| 95–105 | Break | — |
| 105–160 | Task 2 — DC motor with the H-bridge | Two speeds each direction, then a PWM ramp; the enable pin is the interesting one |
| 160–180 | Stall and current | Block the shaft briefly, read the current, write the number down; compare it with the running current |

If CP2 overruns, turn the stall measurement into a demonstration at the front — but do not drop it. The current number is the learning goal.

## Session 2 — 12:30–14:00 (90 minutes): stepper and the sensor in the loop

| Time | Segment | What happens |
|---:|---|---|
| 0–35 | Task 3 — stepper | N steps, direction, and a step rate the motor accepts; find the rate where it buzzes instead of turning |
| 35–75 | Task 4 — sensor in the loop | Module 4's ToF or ultrasonic drives servo position or motor speed; add hysteresis so it stops twitching |
| 75–90 | `◇` Task 5 or harden Task 4 | Thermal actuator as reading plus a mock, or make Task 4 robust |

Task 4 is the bridge to the project: the smallest honest example of "sensor → filter → rule → actuator", which Module 8 then formalises.

## Session 3 — 14:15–15:45 (90 minutes, supervised self-study): reading and team formation

| Time | Segment | What happens |
|---:|---|---|
| 0–25 | Handbook families | One family per pod — hydraulic/pneumatic, thermal, unconventional, motor sizing — one minute each at the front (D18) |
| 25–35 | The comparison table | Fill the five-family table from the module together; the examinable breadth is now in the room |
| 35–70 | Project teams form | Two pods merge into 4–6; pick the story; draft requirements against the syllabus must-haves |
| 70–85 | Pitches | 90 seconds per team, one question from the room |
| 85–90 | Commit and log | Story and draft requirements in the repository; preview Day 8 |

Keep formation tight: **team and story by minute 70, or you pick for them.** Modules 9 and 10 assume a team arrives on Day 8 with a story in hand. If they arrive empty, Day 8 has no build slot left.

## What to demo, what to hand over

- **Demo:** one servo that goes where it is told, one motor that runs both ways, one current number with the shaft blocked.
- **Hand over:** the reading table, the reference sketches, and each project team's story draft.
- The joystick dev boards belong to the play task and the project; keep them on the table, not in the cupboard.

## Common failures

- **Servo jitters or resets the board:** powered from the board's 5 V pin, or no common ground. Give it its own supply.
- **DC motor runs the wrong way:** swap the two motor leads or invert the direction pin — agree on one convention per pod.
- **Driver hot, nothing moves:** both inputs high (brake), or no PWM on the enable pin.
- **Stepper buzzes without turning:** coil order swapped at the ULN2003, or a step rate past what the motor can follow.
- **Current reads zero:** the meter is in parallel, not in series; or the range is wrong.
- **Task 4 twitches at the threshold:** that is the missing hysteresis, and it is the exercise.

## After the run

Record in the TODO and the ADR: which driver boards survived, what the stall current was, which family each pod read, and whether the teams formed cleanly in the self-study slot. If formation consumed the whole slot, Day 8's build block is at risk — note it and move story confirmation into the LMS.
