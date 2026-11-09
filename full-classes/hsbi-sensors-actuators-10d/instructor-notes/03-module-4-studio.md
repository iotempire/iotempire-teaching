# Module 4 Studio — Instructor Notes

Operational setup for Module 4 (Liquid Measurement & Sensor Selection). The student-facing material is [Module 4](../modules/04-liquid-measurement-and-sensor-selection.md); the schedule, assessment, and feedback rules stay in the [syllabus](../syllabus.md).

[All instructor notes](./README.md) · [Syllabus](../syllabus.md) · [Module index](../modules/00-index.md)

## 1. Before the session — communicate and scrounge

- **Send the student email today.** The ready-to-send draft is [Module 4 student email](./04-module-4-student-email.md). It lists what students bring, the sensor menu, the visualization freedom, and the portfolio/checkpoint expectation.
- **Ask the co-instructor to scrounge at home and bring:** trays, towels, a ruler, a funnel, labels, cardboard, scissors, glue, tape, salt, dish soap, coffee grounds/soil/paper, and extra bottles/cups.
- **Confirm the student bring list:** 2–3 clear plastic bottles or large cups, water, optional cooking oil, and scissors/cardboard/tape if they have them.
- **Kit check:** 3 HX711 scales + calibration weights; 3 multimeters; known-good HX711 wiring; ToF and ultrasonic modules (check 5 V); Hall sensor + magnet + cork; reed/float switch; light barrier; foil/copper tape; analog capacitive liquid/soil probe; M5StickC-S3 + BMI270.
- **Class table:** prepare one shared four-row decision sheet; each pod pair will own one row.

## 2. Room and kit

- **Six pods, three scales:** pair Task Pods; one scale per pair; one pod pair owns one tank (one pair may take two). The class assembles the four-row decision sheet.
- **Six pods, three multimeters:** same pairing as Module 3; one meter per pair.
- **Per pod:** one ESP32, one ToF sensor, one ultrasonic module, one Hall sensor with a small magnet and cork, foil or copper tape, one reed/float switch (optional), one light barrier (photo-interrupter), one analog capacitive liquid/soil probe, one M5StickC-S3 (StickS3) with its BMI270 IMU where available, and a local display (the StickS3 screen, an OLED, LEDs/buzzer, or the serial plotter).
- **Shared:** calibration weights for the scales, trays, towels, a ruler, a funnel, labels, cardboard, scissors, glue, tape, salt, dish soap, coffee grounds/soil/paper.
- **Optional:** an MPR121 capacitive-touch board for pods that want the extra challenge or a final-project part.
- **Two instructors:** split the room three pods each; one instructor owns the scale-corner check.

## 3. Prepare the liquids

- **Clear water:** tap water. **Dirty water:** water plus coffee grounds, soil, or torn paper — not real waste water.
- **Fuel simulant:** vegetable oil. It is not diesel; the report must say so.
- **Bilge simulant:** water plus salt and a little soil/leaves. **Foam case:** water plus dish soap, agitated.
- **No real fuel, no real waste water, no tasting.** Plastic bottles and cups only — no glass. No hot liquids and no open flame.
- **Oil disposal:** collect used oil in a labelled waste bottle; do not pour it down the sink. Wipe trays and bottles before the next liquid.
- **Dry side:** keep the ESP32, the breadboard, and the scale on a dry tray. A spill is a cleanup, not a reason to keep power on.

## 4. Scales and calibration

- **Three shared scales, one per two pods.** The scale is the bottleneck; do not queue the whole room behind one.
- **Calibrate with the known weights you have.** At least three known masses, including the empty/tare state. Check linearity and repeatability; record the residuals.
- **Keep the scale dry.** Put it on a dry tray or in a clear bag; tare with the empty tank and the tray.
- **HX711 wiring:** follow the load-cell label — `E+`, `E−`, `A+`, `A−`, `B+`, `B−`. Share ground with the ESP32, use a stable supply, and check the wiring before powering.
- **Common issues:** drift from long leads or temperature, saturation from an overloaded cell, and wrong gain/colouring. Verify with a known mass before trusting the reading.

## 5. IMU shock/motion check

- The **M5StickC-S3 (StickS3)** uses a **BMI270** 6-axis IMU. This is not the MPU6886/SH200Q of the older StickC/Plus2; use the board support and the BMI270 driver.
- The goal is **not fusion and not tilt accuracy**. Use the acceleration magnitude over a short window and classify `in harbor` (still), `moving` (gentle rock), and `rough` (sharp shake). A simple threshold with hysteresis is enough.
- Mount the StickS3 on the mock boat/tray. Log through the serial plotter or show the state on the display; compare the level noise in each state.
- If StickS3 units are limited, share them between the paired pods. If a pod uses an older StickC/Plus2, the IMU and library differ — do not assume the same code.
- The useful report sentence is: "The level moved by X while the boat was in state Y; the IMU lets us label the sea state, not measure the level."

## 6. Divide and conquer

- **Pair two Task Pods.** One tank per pair (one pair may take two); test one continuous and one binary principle; fill the test card and the decision-sheet row.
- **Class table.** Each pair adds its row; the class assembles the four rows. Aim for roughly 80% coverage of the sensor menu across the class, not per pod.
- **Reports are per pod.** Each pod writes its own recommendation and theory report; every student adds a contribution note and links the pod report from their portfolio.
- **One shared study log per pair of pods.** One pod hosts the `## Study log` section; the other links to it.
- **Finish the practice in the two sessions.** The reports are written outside class from the data and photos the pods already have.

## 7. Running the two sessions

- **Session 1 — Explore:** assign tanks; build the mock tank; test one continuous and one binary principle; calibrate; fill the row; run the IMU states; partner calibration check.
- **Session 2 — Break and choose:** test the failure cases; add filter/hysteresis/debounce; complete the class decision sheet; build the demo; take picture proofs; gallery walk; start the transfer story.
- **Mini checks:** draw one prompt at random; ask the pod to answer from the bench or the log. Keep it short.
- **Day 4 feedback at the bench:** the instructors run the Day 4 feedback conversation while pods are working — move pod to pod, ask one "why" question, and do not stop the room for a presentation. The first checkpoint is about **15 minutes per pod**; ask students to have their portfolio and evidence ready. The rules stay in the syllabus.
- **Student email:** a ready-to-send draft is in [Module 4 student email](./04-module-4-student-email.md).
- **Gallery walk:** each pod shows its decision-sheet row, the demo, and the transfer story; another pod asks one question. The instructor checks that the evidence, not the opinion, carries the recommendation.

## 8. Answer key (instructor only)

Use this to steer without handing students the answer. The students should derive it from their tests. The defaults are bench answers, not final boat installations; the report must still justify mounting and maintenance.

| Tank | Decision | Default mode | Default principle | Likely failure |
|---|---|---|---|---|
| Diesel | range / low alarm | continuous | scale or ToF/ultrasonic | clear water defeats ToF; slender-bottle echoes for ultrasonic; slosh |
| Fresh water | level / low alarm | continuous | scale or ultrasonic | condensation; clear-water ToF |
| Waste water | full alarm | threshold | float / light barrier / ultrasonic threshold | foam, fouling |
| Bilge | presence | binary | float / light barrier / conductive | debris, false alarms |

## 9. Common hiccups

- **ToF on clear water:** it often reads imprecisely or fails; the ultrasonic sensor usually works. Compare with the scale and record the failure.
- **Ultrasonic echoes in a slender bottle:** multiple reflections make the reading jump; use a wider tank, angle the sensor, or filter/median.
- **Foam (optional):** non-contact sensors may see the foam; the scale does not. Try it with dish soap if you have it, but do not make it the main failure case.
- **HX711 drift or saturation:** check the supply, leads, wiring, and load; tare and verify with a known mass.
- **Capacitive drift:** re-baseline, keep the foil flat, and avoid stray capacitance and strapping pins.
- **Analog capacitive probe:** not food-safe; keep the electronics dry; it can drift with temperature, salinity, and probe coating.
- **Light barrier:** alignment and ambient light; a floating flag can stick.
- **Scale queue:** pair pods and rotate; do not let six pods wait for three scales.
- **Oil and water on the bench:** trays, towels, labels, and a dry side for the electronics. Clean oil before the next liquid.
- **Report scope:** keep the decision sheet as the spine; the theory explainer should cover only the principles actually used.
- **No Node-RED requirement:** visualization is the pod's choice — screen, OLED, LEDs, serial plotter, or a collage of plots. If they want Node-RED, it belongs to Module 8 or the final project; do not teach the broker twice.

## 10. Story and photo

- The original challenge was co-developed on the US yacht **Hither & Yon**. The friend who owned her has since sold the boat; the photo is from the original challenge and is used with permission.
- The German adaptation is **Nordsee Charter Cuxhaven GmbH** with **SY "Nordwind"**, **Hauke Petersen**, and **Imke Thomsen**. Keep the names and the Cuxhaven/German Bight setting consistent with the [story canon](../modules/Z-resources-bank.md#story-canon-the-recurring-cast).
- The image lives at `modules/assets/boat-challenge.jpg`; the module caption credits the original challenge.

[All instructor notes](./README.md) · [Syllabus](../syllabus.md) · [Module index](../modules/00-index.md)
