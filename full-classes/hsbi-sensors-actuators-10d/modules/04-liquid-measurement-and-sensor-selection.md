# Module 4 – Liquid Measurement & Sensor Selection

[← Back to Module 3](./03-sensor-characterization-and-calibration.md) | [Back to front page](../README.md) | [Quick module index](./00-index.md) | [Next: Module 5 →](./05-leds-and-light-output.md)

> A tank is not a number. Today you choose sensing principles for four liquids, build a mock tank, and prove which measurement you would trust on a boat.

**Course placement:** Day 4 — the liquid-measurement studio. Two sessions; the Day 4 feedback conversation runs at the bench, with the rules and scheduling in the syllabus.

## 🎯 Learning Goals

This module gives you the opportunity to explore liquid-level sensing and achieve competency in sensor selection, tank calibration, and the safety and maintenance constraints of real liquids.

By the end of this module, you can:
1. Explain what each candidate principle actually measures: optical ToF, ultrasonic, weight/load cell, magnetic float + Hall, capacitive/conductive, a float/reed switch, and IMU motion/shock.
2. Match a principle to a liquid, a tank, and a failure mode using opacity, foam, conductivity, dielectric constant, density, hygiene, flammability, tank shape, mounting, and motion.
3. Build and calibrate at least two mock tank measurements; convert raw readings into level and volume; state the uncertainty.
4. Use a motion/shock sensor to distinguish “in harbor” from “outside” and explain how boat motion affects the tank reading.
5. Test the failure cases — foam, dirty/clear/dark liquid, tilt/slosh, empty/full — and choose filtering, hysteresis, and alarm logic.
6. Write a recommendation report for Nordwind and a theory report, and transfer the reasoning to a local industrial story.


**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 📖 Story — The Charter Boat That Did Not Know How Full It Was

**Nordsee Charter Cuxhaven GmbH** runs **SY "Nordwind"**, a 14 m sailing yacht, from **Cuxhaven**: day trips to **Helgoland**, multi-day trips along the **East Frisian coast**, and occasional **Atlantic delivery** trips. Owner and skipper **Hauke Petersen**; marine systems engineer **Imke Thomsen**.

On a late-October return from Helgoland, the fuel gauge on *Nordwind* stuck at a quarter tank. The engine died on the approach to **Neuwerk**; Hauke had to sail the last miles into the **Alte Liebe** harbor with the tide falling and a charter group on board. The same week, the holding-tank alarm only sounded when the tank was already over the floorboards, and a guest ran the fresh-water tank dry because the gauge showed "half" until it showed "empty". The charter office wants a remote view of the fleet; Hauke wants a local display he can trust before the next booking.

*Nordwind* has four tanks: **diesel**, **fresh water**, **waste water (holding tank)**, and the **bilge**. The first three are volume problems; the bilge is a presence problem — any water there is a message. The boat rolls, pitches, and heels; the liquid surface is never flat, and the tanks are not simple boxes. The sensors must survive salt, vibration, condensation, and a wet deck. Hauke's question is not "which sensor is best?" but *"which principle fits this tank, this liquid, and this failure mode — and what will it cost in maintenance and false alarms?"*

### Where this challenge comes from

The first version of this challenge was built on a friend's yacht **Hither-and-Yarn** on the US East Coast — the boat in the photo. He used the boat himself and chartered it out, and he needed a reliable way to see fuel, fresh water, and waste water at a glance, from the dock and later remotely. We developed the challenge together; he has since sold the boat, but the challenge remains.

We first taught it in the IoT class at the **University of Applied Sciences Linz, Campus Hagenberg**; it later moved with the course to **Tartu**. The North Sea charter above is the German adaptation. The tanks, liquids, and failure modes are the same — only the weather is worse.

![Hither-and-Yarn, the original testbed on the US East Coast.](./assets/boat-challenge.jpg)

*Photo from the original challenge; used with permission.*

## 🛠️ Liquid-Measurement Studio — **Challenging**

*Hardware per pod:* 1× ESP32, breadboard and jumper wires, 1× ToF distance sensor (VL53L0X), 1× ultrasonic module, 1× Hall sensor + small magnet + cork float, foil or copper tape, 1× reed/float switch or light barrier (optional), 1× M5StickC-S3 (StickS3) with its built-in BMI270 IMU — one per pod where available, otherwise share with the partner pod — and a local display (the M5StickC-S3 screen, an OLED, LEDs/buzzer, or the serial plotter).

*Shared:* 3× HX711 load-cell scales with calibration weights — one scale per two pods; 3 multimeters for 6 pods; trays, towels, a ruler, a funnel, labels, cardboard, scissors, glue, tape, salt, dish soap, coffee grounds/soil/paper. Students bring three clear plastic bottles: clear water, vegetable oil, and dirty water.

> **If the kit is short:** share the ToF/ultrasonic modules like the scales; the divide-and-conquer split still works.

> **◇ Optional extra:** If you have an MPR121 capacitive-touch board and want the extra challenge, use it instead of the ESP32 touch pins; it is a clean I²C controller and a possible final-project part.

> **Divide and conquer.** Pair with a neighbouring Task Pod. Split the benches — for example, one pod owns distance + IMU, the other owns weight + Hall/capacitive — and share the raw data, calibration records, and picture proofs. **The reports are individual:** cite the shared log, do not copy it.

> **Studio rhythm.** Each session has four modes: **Brief** (read the short concept block), **Bench** (build and measure), **Explain** (a random mini check), and **Log/Swap** (write and exchange). There is no separate Pod Study block; the theory arrives just in time.

> **Mini checks are random and short.** The instructor picks a pod and one prompt; answer from your bench or your log.

> **Exchange is planned.** Session 1: your partner pod checks your scale calibration. Session 2: a gallery walk with another pod and an instructor; show the prototype, the selection matrix, and the transfer story.
>
> **Day 4 feedback at the bench.** The instructors will join your pod while you work; keep the log, the prototype, and one failure case handy. The rules and scheduling stay in the syllabus.

> **Finish the practice in class.** The two sessions are for building, measuring, and taking the picture proofs. The reports are written outside class from the data and photos you already have.
>
> **Visualization is your choice.** Show the tanks however you like: the M5StickC-S3 screen, an OLED, LEDs/buzzer, the Arduino serial plotter, a collage of plots, or another local display. Node-RED is not required in this module; it is available for Module 8 and the final project.

| Session | Focus | Bench | Exchange |
|---|---|---|---|
| **1 — Measure** | Principles; liquids; tank geometry; motion | Task 1: build the mock tank; distance + weight; Hall/capacitive; IMU harbor/outside | Partner pod checks calibration; share the raw data |
| **2 — Break and recommend** | Failure modes; filtering; dashboard; reports | Task 1: break it; build the prototype; picture proofs; set up the reports | Gallery walk; instructor review; Task 2 transfer story |

> [!WARNING]
> **Water, oil, and electronics.** No real fuel and no real waste water; no tasting. Use plastic cups and bottles only — no glass. No hot liquids and no open flame. Keep the ESP32, the scale, and the breadboard dry; use trays and towels; label every bottle; clean up spills; dispose of oil separately, not in the sink. Cooking oil is a qualitative fuel simulant, not diesel.
>
> **Ultrasonic warning.** Some ultrasonic modules are 5 V devices — check before connecting to 3.3 V logic, and use a level shifter/divider for the echo line.

## ★ Task 1 — Solve the Nordwind challenge

*Work as a pair of Task Pods. Split the benches, share the data, and finish the practice in the two sessions. Every student writes their own reports.*

Nordwind needs a trustworthy local view of four tanks. You cannot test on the real boat, so build a mock tank, characterize the candidate principles, and recommend a sensor set with mounting, calibration, maintenance, and a local display.

### Brief 1 — What does each principle actually measure?

- **Optical ToF:** `d = c·t / 2`; reflectance, ambient light, clear water, condensation.
- **Ultrasonic:** `d = v·t / 2`; `v ≈ 331 + 0.6·T` m/s; foam, soft/angled surfaces, beam angle, crosstalk.
- **Weight / load cell:** `m = F/g`; `V = m/ρ`; `h = V/A` for a cylinder, or a calibration curve for a tapered tank; tare, mounting, acceleration.
- **Magnetic float + Hall:** buoyancy; magnetic field vs. distance; binary vs. continuous; no electronics inside the tank.
- **Capacitive:** `C = ε₀·ε_r·A/d`; water vs. oil vs. air; through-wall detection; drift and humidity.
- **Conductive / switch:** two electrodes, a reed/float switch, or a light barrier; binary; corrosion, fouling, mounting.
- **Motion / shock (M5StickC-S3, BMI270):** acceleration magnitude and a short window; `harbor / moving / rough`; no fusion, no tilt accuracy.

### Bench 1 — Build, measure, and log

1. **Build a mock tank.** Use a clear plastic bottle or cup and a cardboard stand. Put it on the shared HX711 scale. Add a ruler or reference marks; label the bottle. Fill it with water first.
2. **Measure the level from above.** Use ToF and/or ultrasonic; log distance vs. time; convert to level and then to volume. Note where the reading fails.
3. **Measure the mass from below.** Calibrate the HX711 scale with the known weights, tare the empty tank, and convert mass to volume with the liquid density. Repeat with oil and dirty water; record what changes.
4. **Measure the motion.** Mount the M5StickC-S3 on the mock boat/tray. Log acceleration for `in harbor` (still), `moving` (gentle rock), and `rough` (sharp shake). Compare the level noise in each state. The BMI270 is a 6-axis IMU; a threshold on the acceleration magnitude and a short window is enough.

### Brief 2 — Liquids, tanks, and moving surfaces

A tank is a geometry problem and a liquid problem at the same time. Level → volume is a cylinder only for a cylinder; a tapered bottle needs a calibration curve. A tilted tank changes the zero. Empty and full are end stops, not reliable measurements.

| Tank | Liquid | Decision | What makes it hard |
|---|---|---|---|
| Diesel | fuel | range / low alarm | opaque, flammable, no electronics inside, gauge sticking |
| Fresh water | drinking water | fill level / low alarm | food-safe, clear, condensation, tank shape |
| Waste water | holding tank | full alarm | dark, dirty, foam, hygiene, not overfill |
| Bilge | seawater / rain | presence alarm | any water is a message; salt, debris, false alarms |

The boat rolls, pitches, and heels; the liquid surface is never flat. Use the IMU to label the sea state, and use the level series to show how much the reading moves. The report should say which part of the variation is real level and which part is motion.

> The original challenge also listed heating/AC water. On *Nordwind* that is the engine coolant/heating loop; treat it as an optional fifth tank in your recommendation if you want the extra case.

### Bench 2 — Try the alternatives

1. **Magnet + Hall.** Float a small magnet on a cork; scan the Hall sensor along the outside of the tank. Is the output continuous or only a threshold? Where does the float stick?
2. **Capacitive / conductive.** Put foil or copper tape on the outside of a cup; detect water through the wall. Compare water with oil. Then try two electrodes inside the cup: water conducts, oil does not. Which version is binary, and which can give a level?
3. **Switch.** Use a reed or float switch as a high/low limit. Note intrusion, fouling, and mounting.
4. **Record a first selection matrix.** Which principle would you trust for each tank, and what evidence do you already have?

### Brief 3 — Calibration, uncertainty, filtering, and alarms

- **Scale:** calibrate with known masses; tare the empty tank; check linearity; state the uncertainty. The HX711 is a 24-bit ADC, but the load cell, mounting, and temperature set the real accuracy.
- **Tank:** level → volume with a ruler or a calibration curve; repeat the fill/drain cycle; record the residuals.
- **Distance:** calibrate against a ruler; note offset and temperature; compare ToF and ultrasonic on the same surface.
- **Filtering:** moving average, median, EMA; know the latency each adds. **Hysteresis and debounce** stop alarm chatter; a short alarm delay is a design choice, not a fix for a bad sensor.
- **Uncertainty:** reuse the Module 3 calibration record and state `y ± U` for at least one tank measurement.

### Bench 3 — Break it and build the prototype

1. **Break the measurement on purpose.** Try foam, dirty water, clear/dark liquid, tilt/slosh, an empty tank, a full tank, and condensation. Record what fails and what the failure looks like in the data.
2. **Add the fix.** Filter, add hysteresis/debounce, or choose a different principle. Set a local low/high alarm with a clear state.
3. **Build a local visualization.** Use the M5StickC-S3 screen, an OLED, LEDs/buzzer, the serial plotter, or a collage of plots — whatever makes the tanks legible. Show the four tanks (measured or marked as not measured) and one alarm state.
4. **Take the picture proofs.** Photograph the build, the wiring, the display, the calibration setup, and one failure case. Add a one-sentence caption saying what each picture proves.

### Deliverable 1 — Prototype and picture proofs

- One working prototype per pair of Task Pods: mock tank + at least two measurement principles + local visualization/alarm.
- A photo set with captions: build, wiring, display, calibration, failure case.
- A code link (repository or gist) and a short wiring note.
- A one-page result table: liquid, principle, range, failure mode, and uncertainty.

### Deliverable 2 — Recommendation report for Nordwind

Write this as your own section in `Module04/README.md`. Even when the experiments are shared, the report is individual.

1. The four tanks and the decision each one supports: full/empty, alarm, range.
2. Criteria and weights: accuracy, range, mounting, maintenance, safety, cost, remote readiness.
3. Candidate principles and your test evidence.
4. Selection matrix per tank.
5. Recommendation per tank: primary and backup, mounting sketch, calibration plan, maintenance.
6. Local visualization and alarm (your choice of display or plot) plus a remote outlook (topics, update rate, alarm payload) — describe it, do not build it in this module.
7. Risks and open questions.

### Deliverable 3 — Theory report

Write this as your own section in `Module04/README.md`. It is the "how everything works and how the measurements are done" part of the module.

1. Principles and equations: ToF, ultrasonic, weight, Hall, capacitive/conductive, switch, IMU motion.
2. Liquid properties and why they matter: opacity, foam, conductivity, dielectric constant, density, hygiene, flammability, fouling.
3. Tank geometry and level → volume; tilted and tapered tanks.
4. Calibration and uncertainty for the scale, the tank, and the distance sensor.
5. Filtering and alarm logic: noise, slosh, hysteresis, debounce, latency.
6. Failure modes and mitigations, with your own measurements as evidence.
7. References: datasheets, application notes, and the Module 3 material.

### ◇ Optional sub-task — Pump current

If a Hall current sensor and a small pump or motor are available, measure the current with the pump dry, wet, and blocked. A dry-running pump usually draws less; a blocked pump draws more. Add one sentence to the recommendation report: could current tell you something the level sensor cannot?

### Mini checks and exchange

> **Random mini check.** The instructor picks a pod and one prompt; answer from your bench or your log:
> - "Show your scale calibration and the residual at the heaviest known mass."
> - "Which principle survives foam, and which one survives clear water? Show the data."
> - "What does the IMU add that the level sensor cannot tell you?"
> - "Which tank decision is binary, and which one needs a volume?"
>
> **Partner check.** Your partner pod checks your scale calibration and your tank calibration record. Sign each other's record with a one-line "checked by".
>
> **Instructor bench round.** Show the prototype, the display, and one failure case; the instructor asks one "why" question.

## ★ Task 2 — Transfer to a local industrial story

Pick a fictional local facility that measures liquids — a dairy, a brewery, a camper van, a fuel depot, a heating/AC loop, a wastewater plant, an aquarium. Do not reuse the boat.

- Who is the user, what liquid, what decision, and what failure hurts?
- Which principles from Task 1 transfer, which do not, and why?
- Sketch the installation and the local display; say what you would verify before trusting it.
- Present it in the gallery walk and add it as your own section in `Module04/README.md`.

> **Speculate, then check.** The transfer story is allowed to be a hypothesis. Mark what you know from your bench, what you infer, and what you would measure next.

> Task A and Task B are the collaboration wrapper for the two tasks — not extra lab work.

### ★ Task A — Keep the shared study log

One shared `## Study log` section per pair of Task Pods in `Module04/README.md`: calibration records, raw-data links, picture proofs, and the one surprise. Each pod links to it; each student adds one sentence on what they contributed. The reports stay individual.

### ★ Task B — Exchange with a neighbouring pod

- Session 1: the partner pod checks your scale calibration and your tank calibration.
- Session 2: gallery walk — show the prototype, the selection matrix, and the transfer story; ask one question of another pod.
- Agree on one learning and one shared artefact (the prototype photo, the selection matrix, or the failure-mode table). Post it in the course channel.
- Each student adds the agreed learning to their own README, with a link to the shared log.

## Templates to fill in and exchange

### Scale calibration record

Use the calibration weights you have. Use at least three known masses, including the empty/tare state. Replace the example masses with the weights in your set.

| Known mass (g) | Raw HX711 reading | Calculated mass (g) | Error (g) | Notes |
|---:|---:|---:|---:|---|
| 0 (tare) | | 0 | | empty tank / tray |
| | | | | |
| | | | | |
| | | | | |

### Tank calibration record

| Added volume (mL) | Level from distance (mm) | Mass reading (g) | Calculated volume (mL) | Difference (mL) | Notes |
|---:|---:|---:|---:|---:|---|
| 0 | | | 0 | | empty |
| | | | | | |
| | | | | | |

### Selection matrix

Rate each principle for each tank. The rating must cite a measurement, not an opinion.

| Tank | Liquid | Decision | Primary principle | Backup | Evidence | Mounting | Maintenance |
|---|---|---|---|---|---|---|---|
| Diesel | fuel | range / low alarm | | | | | |
| Fresh water | drinking water | fill level / low alarm | | | | | |
| Waste water | holding tank | full alarm | | | | | |
| Bilge | seawater / rain | presence alarm | | | | | |

## ✅ Suggested portfolio evidence (proofs of the learning goals)

1. Shared study log: scale and tank calibration records, raw data, and picture proofs.
2. Prototype photos with captions: build, wiring, display, calibration, failure case.
3. Recommendation report for Nordwind (your own section).
4. Theory report (your own section).
5. Transfer story (your own section).
6. Task B: agreed learning and shared artefact.

*You may prove the same goals another way. The reports are individual even when the experiments are shared; cite the shared log instead of copying it.*

## Pointers (start here, then keep looking)

- [M5StickC-S3 / StickS3 documentation](https://docs.m5stack.com/en/core/StickS3) — BMI270 IMU, display, pinout.
- [VL53L0X](https://www.st.com/en/imaging-and-photonics-solutions/vl53l0x.html) — datasheet and API.
- [HX711 load-cell guide](https://learn.sparkfun.com/tutorials/load-cell-amplifier-hx711-breakout-hookup-guide) — wiring, tare, calibration.
- [Wikipedia: Level sensor](https://en.wikipedia.org/wiki/Level_sensor) — the principle catalogue.
- [Wikipedia: Hall effect sensor](https://en.wikipedia.org/wiki/Hall_effect_sensor) — magnetic float and switch.
- [Wikipedia: Capacitive sensing](https://en.wikipedia.org/wiki/Capacitive_sensing) — through-wall detection.
- The [resource bank](./Z-resources-bank.md#formulas-you-will-use) — formulas, datasheets, troubleshooting.
- [Module 3](./03-sensor-characterization-and-calibration.md) — calibration record, uncertainty, filtering.

## Questions to ask an LLM (then verify against your bench)

- "Compare ToF, ultrasonic, and weight for a diesel tank on a moving boat. Which one fails first, and why?"
- "How do I calibrate an HX711 scale with known masses, and what does tare do to the offset?"
- "My ToF reads correctly on a wall but wrongly on clear water. Explain the physics and design a quick test."
- "How can an IMU distinguish a boat in harbor from a boat underway without sensor fusion?"
- "Which dielectric property makes capacitive water detection work through a plastic wall?"

> Treat each answer as a claim to test. Record where the model is wrong, vague, or over-confident.

## 📚 If you want to go deeper

- [M5Stack StickS3](https://docs.m5stack.com/en/core/StickS3) and the BMI270 datasheet — the motion detector and its limits.
- [VL53L0X](https://www.st.com/en/imaging-and-photonics-solutions/vl53l0x.html) — reflectance and ambient-light caveats.
- [SparkFun HX711 guide](https://learn.sparkfun.com/tutorials/load-cell-amplifier-hx711-breakout-hookup-guide) — load-cell wiring and calibration.
- [Wikipedia: Level sensor](https://en.wikipedia.org/wiki/Level_sensor) — ultrasonic, radar, float, capacitive, and pressure.
- [Wikipedia: Ultrasonic transducer](https://en.wikipedia.org/wiki/Ultrasonic_transducer) — beam angle, foam, and soft surfaces.
- The [resource bank](./Z-resources-bank.md#datasheets--standards-to-read-once) — the datasheet shelf.

---

[← Previous: Module 3](./03-sensor-characterization-and-calibration.md) | [Back to front page](../README.md) | [Quick module index](./00-index.md) | [Next: Module 5 — LEDs & Light as Output →](./05-leds-and-light-output.md)
