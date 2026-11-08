# Module 4 Studio — Instructor Notes

Operational setup for Module 4 (Liquid Measurement & Sensor Selection). The student-facing material is [Module 4](../modules/04-liquid-measurement-and-sensor-selection.md); the schedule, assessment, and feedback rules stay in the [syllabus](../syllabus.md).

[All instructor notes](./README.md) · [Syllabus](../syllabus.md) · [Module index](../modules/00-index.md)

## 1. Room and kit

- **Six pods, three HX711 scales:** pair Task Pods, one scale per pair, and swap at the round boundary. One pod builds or measures distance while the other weighs.
- **Six pods, three multimeters:** same pairing as Module 3; one meter per pair.
- **Per pod:** one ESP32, one ToF sensor, one ultrasonic module, one Hall sensor with a small magnet and cork, foil or copper tape, one reed/float switch (optional), one M5StickC-S3 (StickS3) with its BMI270 IMU where available, and a local display (the StickS3 screen, an OLED, LEDs/buzzer, or the serial plotter).
- **Shared:** calibration weights for the scales, trays, towels, a ruler, a funnel, labels, cardboard, scissors, glue, tape, salt, dish soap, coffee grounds/soil/paper.
- **Students bring:** three clear plastic bottles — clear water, vegetable oil, and dirty water. Drinking cups are useful as extra tanks.
- **Two instructors:** split the room three pods each; one instructor owns the scale-corner check.

## 2. Prepare the liquids

- **Clear water:** tap water. **Dirty water:** water plus coffee grounds, soil, or torn paper — not real waste water.
- **Fuel simulant:** vegetable oil. It is not diesel; the report must say so.
- **Bilge simulant:** water plus salt and a little soil/leaves. **Foam case:** water plus dish soap, agitated.
- **No real fuel, no real waste water, no tasting.** Plastic bottles and cups only — no glass. No hot liquids and no open flame.
- **Oil disposal:** collect used oil in a labelled waste bottle; do not pour it down the sink. Wipe trays and bottles before the next liquid.
- **Dry side:** keep the ESP32, the breadboard, and the scale on a dry tray. A spill is a cleanup, not a reason to keep power on.

## 3. Scales and calibration

- **Three shared scales, one per two pods.** The scale is the bottleneck; do not queue the whole room behind one.
- **Calibrate with the known weights you have.** At least three known masses, including the empty/tare state. Check linearity and repeatability; record the residuals.
- **Keep the scale dry.** Put it on a dry tray or in a clear bag; tare with the empty tank and the tray.
- **HX711 wiring:** follow the load-cell label — `E+`, `E−`, `A+`, `A−`, `B+`, `B−`. Share ground with the ESP32, use a stable supply, and check the wiring before powering.
- **Common issues:** drift from long leads or temperature, saturation from an overloaded cell, and wrong gain/colouring. Verify with a known mass before trusting the reading.

## 4. IMU shock/motion check

- The **M5StickC-S3 (StickS3)** uses a **BMI270** 6-axis IMU. This is not the MPU6886/SH200Q of the older StickC/Plus2; use the board support and the BMI270 driver.
- The goal is **not fusion and not tilt accuracy**. Use the acceleration magnitude over a short window and classify `in harbor` (still), `moving` (gentle rock), and `rough` (sharp shake). A simple threshold with hysteresis is enough.
- Mount the StickS3 on the mock boat/tray. Log through the serial plotter or show the state on the display; compare the level noise in each state.
- If StickS3 units are limited, share them between the paired pods. If a pod uses an older StickC/Plus2, the IMU and library differ — do not assume the same code.
- The useful report sentence is: "The level moved by X while the boat was in state Y; the IMU lets us label the sea state, not measure the level."

## 5. Divide and conquer

- **Pair two Task Pods.** Split the benches: one pod owns distance + IMU, the other owns weight + Hall/capacitive. Share the raw data, calibration records, and picture proofs.
- **Reports are individual.** Each student writes their own recommendation report, theory report, and transfer story; cite the shared log instead of copying it.
- **One shared study log per pair of pods.** One pod hosts the `## Study log` section; the other links to it. Each student adds one sentence on what they contributed.
- **Finish the practice in the two sessions.** The reports are written outside class from the data and photos the pods already have.

## 6. Running the two sessions

- **Session 1 — Measure:** Brief 1 (principles), Bench 1 (build the mock tank, distance + weight, IMU states), Brief 2 (liquids and tanks), Bench 2 (Hall/capacitive/switch), a random mini check, and the partner calibration check.
- **Session 2 — Break and recommend:** Brief 3 (calibration, filtering, alarms), Bench 3 (break it, prototype, picture proofs), a random mini check, the gallery walk with another pod and an instructor, and the Task 2 transfer story.
- **Mini checks:** draw one prompt at random; ask the pod to answer from the bench or the log. Keep it short.
- **Instructor bench round:** ask one "why" question per pod — for example, "Why did you choose this principle for the waste tank?" or "What does the IMU tell you that the level sensor does not?"
- **Gallery walk:** each pod shows the prototype, the selection matrix, and the transfer story; another pod asks one question. The instructor checks that the evidence, not the opinion, carries the recommendation.

## 7. Common hiccups

- **ToF on clear water:** the beam may see the bottom or scatter. That is a result, not a failed task; compare with the scale.
- **Foam:** ultrasonic and ToF can fail; the scale usually does not. Use the contrast.
- **Ultrasonic 5 V:** check the module before connecting the echo line to a 3.3 V pin; use a divider/level shifter.
- **Ultrasonic crosstalk:** two pods firing at once can see each other. Stagger or shield; keep the beams apart.
- **HX711 drift or saturation:** check the supply, leads, wiring, and load; tare and verify with a known mass.
- **Capacitive drift:** re-baseline, keep the foil flat, and avoid stray capacitance and strapping pins.
- **Slosh:** a single reading is not a level. Log a series, filter, and add hysteresis; use the IMU to label the state.
- **Scale queue:** pair pods and rotate; do not let six pods wait for three scales.
- **Oil and water on the bench:** trays, towels, labels, and a dry side for the electronics. Clean oil before the next liquid.
- **Report scope:** keep the selection matrix as the spine; the theory report should explain only the principles actually used.
- **Node-RED before MQTT:** Module 4 is before Module 8. Build a local display and describe the remote view; do not teach the broker twice.

## 8. Story and photo

- The original challenge was co-developed on the US yacht **Hither-and-Yarn**. The friend who owned her has since sold the boat; the photo is from the original challenge and is used with permission.
- The German adaptation is **Nordsee Charter Cuxhaven GmbH** with **SY "Nordwind"**, **Hauke Petersen**, and **Imke Thomsen**. Keep the names and the Cuxhaven/German Bight setting consistent with the [story canon](../modules/Z-resources-bank.md#story-canon-the-recurring-cast).
- The image lives at `modules/assets/boat-challenge.jpg`; the module caption credits the original challenge.

[All instructor notes](./README.md) · [Syllabus](../syllabus.md) · [Module index](../modules/00-index.md)
