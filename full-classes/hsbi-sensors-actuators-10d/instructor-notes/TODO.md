# Future work — TODOs for the next run

> Working list, written during the first run (WS 2026/27). Nothing here is a promise; it is the memory of what we noticed and did not have time to fix. Tick items as they land, and add the observation that motivated them — a TODO without a reason gets dropped.
>
> **Decisions are not made here.** The reasoning, rejected alternatives, and reversal triggers live in the [architecture log](./00-architecture-decisions.md). Each item below names the decision that owns it (`D…`) or the open question in §4. If a TODO turns out to be a design choice, write the record there and leave only the action here.

[All instructor notes](./README.md) · [Architecture decisions](./00-architecture-decisions.md) · [Syllabus](../syllabus.md) · [Module index](../modules/00-index.md) · [Networking TODO](../../hsbi-networking-iot-10d/instructor-notes/TODO.md) · [Databases TODO](../../hsbi-databases-10d/instructor-notes/TODO.md)

## Discrepancy watch

Read this before the next redesign. These are places where this file, the architecture log, the module files, or the sibling classes disagree. Do not fix one side locally; close the question in the architecture log first.

| # | Discrepancy | Owner | Meanwhile |
|---|---|---|---|
| 1 | **Reports per pod vs. per student, and the Leistungsnachweis.** Working interpretation: the individual portfolio with its checkpoint evidence is the Leistungsnachweis; the pod report and the project presentation are the Modulprüfung. Not confirmed. | [D4](./00-architecture-decisions.md#d4), [D9](./00-architecture-decisions.md#d9), [D13](./00-architecture-decisions.md#d13), [Q2](./00-architecture-decisions.md#4-open-questions) | Keep the pod report and the contribution note; do not state a Leistungsnachweis rule beyond the syllabus. |
| 2 | **Three pod pairs, 4–5 rows.** Two pods aim for 4–5 decision-sheet rows, but there are three pairs and four or five tanks. | [D9](./00-architecture-decisions.md#d9), [D12](./00-architecture-decisions.md#d12), [Q3](./00-architecture-decisions.md#4-open-questions) | One pair takes two tanks; the class table keeps the rows comparable. Write the assignment on the class table. |
| 3 | **One shared binary capacitive sensor.** The module, syllabus, and instructor note say shared; students may queue for it. | [D10](./00-architecture-decisions.md#d10), [D12](./00-architecture-decisions.md#d12), [Q4](./00-architecture-decisions.md#4-open-questions) | Mark it shared and plan a pass-around; do not imply one per pod. |
| 4 | **Analog soil/humidity probe role.** It is a concept test, not food-safe, and unstable in splashes/moving water. | [D10](./00-architecture-decisions.md#d10), [Q5](./00-architecture-decisions.md#4-open-questions) | Use it for waste/bilge/dirty water or a side test; keep it out of drinking water and fuel. |
| 5 | **No DIY foil/capacitive liquid sensor.** Foil survives only as an optional touch side idea. | [D10](./00-architecture-decisions.md#d10) | Keep the liquid path free of foil; the optional MPR121/touch note is the only place it belongs. |
| 6 | **Node-RED is optional.** The module does not require it; the global README/syllabus list it for Module 8 and the final project. | [D10](./00-architecture-decisions.md#d10), [D14](./00-architecture-decisions.md#d14), [Q8](./00-architecture-decisions.md#4-open-questions) | Say “choose your visualization” in the room; Node-RED is a Module 8/final-project option. |
| 7 | **Scale calibration.** The scale check is two readings plus an optional third; the tank table still has empty/half/full. | [D11](./00-architecture-decisions.md#d11), [Q6](./00-architecture-decisions.md#4-open-questions) | Keep the two-reading check; the tank table is a different curve. |
| 8 | **Checkpoint timing.** The email and instructor note say about 15 minutes per pod; the module carries no time estimate. | [D13](./00-architecture-decisions.md#d13), [Q7](./00-architecture-decisions.md#4-open-questions) | Keep the timing operational; do not add it to the module. |
| 9 | **Old Module 4 archive.** It is instructor-only, but its links and story canon still need care. | [D15](./00-architecture-decisions.md#d15), [Q9](./00-architecture-decisions.md#4-open-questions) | Keep it out of the student index; check links when the module changes. |
| 10 | **Task A/B convention.** Module 4 keeps the shared study log and exchange but no Task A/B headings. | [D6](./00-architecture-decisions.md#d6), [D14](./00-architecture-decisions.md#d14), [Q10](./00-architecture-decisions.md#4-open-questions) | The collaboration wrapper is intentional; decide whether the convention requires the headings. |
| 11 | **M5StickC-S3/BMI270.** The IMU/display path depends on the StickS3 count and the BMI270 library. | [D10](./00-architecture-decisions.md#d10), [Q11](./00-architecture-decisions.md#4-open-questions) | Verify the count and a known-good M5Unified/BMI270 build before the session. |
| 12 | **Environment coverage.** Module 4 no longer has BME280/DHT22 as a core lab; Module 3 covers T/RH. | [D8](./00-architecture-decisions.md#d8), [Appendix A](./00-architecture-decisions.md), [Q12](./00-architecture-decisions.md#4-open-questions) | Keep Module 3 T/RH and the final-project option; confirm the handbook does not require a dedicated environment lab. |
| 13 | **NTC story vs. hardware.** Module 3 uses the NTC only as the failed prototype; the kit has no NTC. | [D7](./00-architecture-decisions.md#d7) | Keep the story; make sure students do not search for an NTC they will not find. |
| 14 | **Semester.** The handbook says *5. Semester*; the syllabus says *6th semester*. | [Q13](./00-architecture-decisions.md#4-open-questions) | Do not advertise a semester until it is confirmed; check the syllabus line. |
| 15 | **Language.** The handbook says *Sprache: deutsch*; the workbook is English with bilingual delivery. | [D16](./00-architecture-decisions.md#d16), [Q14](./00-architecture-decisions.md#4-open-questions) | Keep the bilingual delivery; record the deviation, do not translate. |

**Resolved 2026-11-15:** Module 4 handbook coverage (Q1/D8) — the handbook lists sensor principles as examples, not a fixed catalogue, and permits the Kombinationsprüfung. The liquid challenge stands; triangulation, gyroscope, and hydrostatic pressure are reading homework in Module 8 (D18).

## Before the next semester (reset)

- [ ] **Close Q2 and the Leistungsnachweis definition with the Prüfungsausschuss.** Q1 is settled (the handbook lists examples, not a catalogue). Confirm what counts as the Leistungsnachweis and whether the Module 4 pod report satisfies the individual portfolio (D4, D9, D13).
- [ ] **Re-run the link/anchor/fence checker and `git diff --check`** from the repository root before the first session.
- [ ] **Check the DRAFT BOUNDARY positions** against what was actually taught. Move each boundary to the first genuinely provisional section, not to the end by habit (D17).
- [ ] **Re-check the session mapping and hardware counts** against the real semester calendar: six pods, twelve students, three multimeters, three scales, one shared binary capacitive sensor (D12).
- [ ] **Refresh the story numbers and canon** — Klimapark 0.8 °C vs. 2.2 °C; Nordwind/Cuxhaven; Hither & Yon; no invented names in the canon (D5).
- [ ] **Render the Session 1 slide deck** and check the page count against the number of slides.
- [ ] **Prepare the Module 4 class table, test cards, and email.** The email should say what to bring, the sensor menu, the visualization freedom, and the first-checkpoint/portfolio expectation (D13).
- [ ] **Check the old Module 4 archive links** and its banner; it stays instructor-only (D15).

## Structural ideas to weigh

Proposals, not decisions. Prototype them as outlines before touching the module files.

- [ ] **Compress Days 5–7 into two modules.** Merge Module 7 (motors plus the reading on fluid, thermal, and unconventional actuators) into Module 6, and move the animation and sound parts of Module 6 into Module 5. The liquid challenge showed that one story plus a decision sheet beats a catalogue; three actuator days may be more than the outcomes need. Cost: Module 6 becomes a long day (animation + motors), and Module 5 gains animation — but Module 5 is now the evaluated guided session, so weigh whether it can absorb animation at all. Keep Module 7 as the fallback until the compressed version has been taught once (D6, D17, D19).
- [ ] **Check handbook coverage after the compression.** Outcome 4 (mechanical, thermal, optical, unconventional) must still be evidenced; the five-family table in Module 7 is the current evidence (D18, Appendix A).
- [ ] **Decide the Module 5 format after the evaluation.** Keep the guided walkthrough only if it produced the evidence; otherwise return to the open challenge. Record the observer feedback (D19).
- [ ] **Rework every class around one open challenge plus a hints appendix.** Keep the learning goals and the story; replace the task ladder with a short, deliberately vague challenge that admits several solutions; move the old tasks, theory, recipes, and pointers into an appendix of hints and resources. Module 4 is the model; Module 5 is the first test. The risk is vagueness without a comparable artefact — fix one required artefact per challenge (decision sheet, demo plus power table) before rewriting. Do this after the current run, not during it (D17, D19).
- [ ] **Make AI-first explicit in every challenge.** The evaluation expects AI-first teaching; Module 5 uses the loop prompt → draft → verify → commit, with the repo as the deliverable. Decide the pattern for the other modules: what the AI drafts, what must be verified on hardware, and what is committed (D14, D17, D19).

## Module 3 carry-over

- [ ] **Keep the NTC in the story, not the kit.** The failed prototype explains the problem; the LDR, DS18B20 sealed probe, and potentiometer are the bench (D7).
- [ ] **Keep the DS18B20 connector dry.** The probe is sealed; the cable connector is not. Warm water, not boiling; no bags needed (D7).
- [ ] **Keep the DHT11 optional and dry.** It is a ±2 °C comparison, not a frost sensor; it does not go into water or the field transect (D7).
- [ ] **Prepare the water and the field transect.** Cold water from freezer bottles; hot water from the kitchen mixed warm; a dry tray; a fall outside spot with the long probe cable (Module 3 studio).
- [ ] **Pair pods for the three multimeters.** One meter per pair; swap at the round boundary.
- [ ] **Watch the resolution-vs-accuracy confusion.** `setResolution()` may look like it does nothing at constant temperature; check `getResolution(address)`, take a new conversion, and test a second probe (clone).
- [ ] **Keep the dead-band and filter sub-tasks optional.** They are good stretchers, not additional core tasks.
- [ ] **Check the three-session mapping.** The syllabus says Module 3 uses three sessions; do not compress it by accident (D6).

## Module 4 carry-over

- [ ] **Two pods aim for 4–5 rows.** Not one row per pod. One pair may take two tanks; the class table keeps the rows comparable (D9).
- [ ] **Keep the decision sheet as the spine.** Binary/threshold/continuous/hybrid; the mode is the design choice (D9).
- [ ] **Use hybrid deliberately.** Continuous + binary failsafe, or staggered binary with float/reed switches at different heights. Do not imply several DIY capacitive levels (D9, D10).
- [ ] **Use the real sensor set.** ToF, ultrasonic, HX711 scale, Hall + float, analog soil/humidity probe (open/sealed/needle), binary capacitive water sensor (shared), light barrier, reed/float, M5StickC-S3 IMU. No foil/DIY capacitive liquid sensor (D10).
- [ ] **Try more than one analog soil/humidity probe form.** Open, sealed, and needle probes respond differently; the analog probe is a concept test, not a food-safe drinking-water sensor, and splashes/movement make it unstable (D10).
- [ ] **Use the binary capacitive sensor as a presence/threshold device.** One shared unit; check nearby objects, splashes, and threshold adjustment (D10, D12).
- [ ] **Keep the clear-water/ToF and slender-bottle/ultrasonic failures.** Clear drinking water often defeats ToF; ultrasonic usually works, but a slender bottle can give echoes. Foam is worth trying, not the main failure case.
- [ ] **Keep the scale check simple.** 0 g tare + one known mass; a third known mass (even a phone's published weight) is an optional check; the tank table stays at empty/half/full (D11).
- [ ] **Keep visualization free.** Screen, OLED, LEDs, serial plotter, collage of plots; Node-RED is not required (D10).
- [ ] **Keep reports per pod + contribution note.** The class table is shared; the report is the pod's argument; each student links it and states their contribution (D9, D13).
- [ ] **Run the checkpoint at the bench.** About 15 minutes per pod while students work; do not stop the room for a presentation (D13).
- [ ] **Send the student email today.** Ask the co-instructor to scrounge the shared materials; use the “We need — look at home” framing (D12).
- [ ] **Keep the gallery walk.** Each two-pod group shows its 4–5 rows, the demo, and the transfer story; another pod asks one question.

## Documentation and consistency

- [x] **Link the ADR and TODO from the instructor-notes index** — done 2026-11-15; keep the class README and index pointers current as files move.
- [ ] **Keep one fact, one home.** Principles, formulas, datasheets, and troubleshooting live in the [resource bank](../modules/Z-resources-bank.md); teaching hints and answer keys live in the instructor notes; assessment lives in the [syllabus](../syllabus.md) (D14).
- [ ] **Keep the liquid-level principles table current.** The analog soil/humidity probe and binary capacitive water sensor replaced the foil/DIY capacitive row; the hybrid note uses float/reed switches; the hydrostatic-pressure row is the industrial default (D10, D18).
- [ ] **Keep the reading homework current.** The Module 7 five-family table and the Module 8 pressure/triangulation/gyroscope block carry the handbook examples that are not on the bench (D18).
- [ ] **Keep the story canon current.** Module 4 adds Nordwind, Hauke Petersen, Imke Thomsen; Hither & Yon stays in the origin note, not the fictional canon (D5).
- [ ] **Keep the old Module 4 archive valid.** Links, banner, and instructor-only status (D15).
- [ ] **Keep the module text free of assessment rules** — no points, grades, checkpoint rules, or time estimates (D4).
- [ ] **Update the index, syllabus, and README** whenever Module 3/4 changes; do not leave the old Module 4 filename in the student path (D8, D14).

## Infrastructure and hardware

- [ ] **Check the scale kit.** Three HX711 scales with one known calibration mass each (e.g., 50 g; a second weight is optional); known-good HX711 wiring; dry trays.
- [ ] **Check the multimeters.** Three shared meters, one per pair; known-good leads.
- [ ] **Check the M5StickC-S3/BMI270 units.** Count them, verify a known-good M5Unified/BMI270 build, and decide how to share if short (D10).
- [ ] **Check the sensor kit.** ToF, ultrasonic, Hall/magnet/cork, analog soil/humidity probes (open/sealed/needle), one binary capacitive water sensor, light barriers, reed/float switches.
- [ ] **Check the consumables.** Trays, towels, ruler, funnel, labels, cardboard, scissors, glue, tape, salt, dish soap, coffee grounds/soil/paper, bottles/cups, oil waste bottle, no glass.
- [ ] **Check the room.** Bench space for six pods, a dry side for electronics, a water/oil cleanup plan, and a place for the shared class table.
- [ ] **Check the slide deck and PDF.** Render Session 1 and confirm the page count matches the slide count.

## Communication

- [ ] **Send the student email** with the bring list, the sensor menu, the visualization freedom, and the portfolio/checkpoint expectation (D13).
- [ ] **Ask the co-instructor to scrounge** the shared materials: trays, towels, ruler, funnel, labels, cardboard, scissors, glue, tape, salt, dish soap, coffee grounds/soil/paper, extra bottles/cups (D12).
- [ ] **Remind students to polish their portfolios** before the first checkpoint; the checkpoint verifies Modules 1–3 at the bench.
- [ ] **Do not state a Leistungsnachweis rule** beyond the syllabus until Q2 is confirmed; the working interpretation lives in the ADR (D4).
- [ ] **Say explicitly that Node-RED is not required in Module 4.** Visualization is the pod's choice; Node-RED belongs to Module 8/final project (D10).
- [ ] **Announce the class table and the two-pod unit.** Students should know they are filling 4–5 rows together, not one row each (D9).

## Observations, not decisions

These came out of the first run and were not resolved. Anything that becomes a decision moves to the architecture log §4 and gets a record; do not leave it here as a permanent question.

- Did the one-goal/decision-sheet structure reduce the “what are we actually doing?” confusion?
- Did two pods actually fill 4–5 rows, and how did they split the tanks?
- Did the hybrid/failsafe and staggered-binary idea land, or did students default to one sensor per tank?
- Did the analog soil/humidity probe help as a concept, or did splashes/movement make it too unstable to use?
- Did students try more than one probe form (open/sealed/needle), and did the forms differ enough to discuss?
- Did the shared binary capacitive sensor work reliably, and did it false-trigger on nearby objects or splashes?
- Did the clear-water/ToF and slender-bottle/ultrasonic failures produce the intended “the principle decides” insight?
- Did foam add value, or did it distract from the clearer failure cases?
- Did the two-reading scale check suffice, or did the tank table need more points?
- Did the no-Node-RED visualization freedom produce good local displays/collages, or did students wait for a tool?
- Did the report-per-pod + contribution note work, or did one student carry the report?
- Did the bench checkpoint fit into the two sessions without stopping the room?
- Did the class table make the results comparable across pods?
- Did the “We need — look at home” framing work better than a you-bring/we-provide split?
- Did anyone use the old Module 4 archive as an instructor alternative?

## Deliberately not in this TODO

- Reintroducing foil/copper-tape DIY capacitive sensing into the liquid path. It was a touch idea, not a liquid method (D10).
- Making Node-RED a Module 4 requirement. It belongs to Module 8 and the final project (D10).
- Adding time estimates to modules. Operational timing stays in the instructor notes and the email (D13).
- Changing assessment, points, checkpoints, or the grade scale. That is syllabus/examination-law territory (D4).
- Rewriting Module 4 during the run. Teach it, observe it, then change it (D17).
- Deleting the old Module 4 archive. It stays available for instructors (D15).
- Copying Databases or Networking subject content. Only the structure and didactics travel (D1, D16).
- Buying NTCs or more hardware before testing the room. Use the kit and record what is missing (D7, D12).
- One sensor kit per pod, or one binary capacitive sensor per pod. Sharing is the design (D12).
- Per-student reports unless the handbook requires them. The current unit is the pod report plus a contribution note (D9).
