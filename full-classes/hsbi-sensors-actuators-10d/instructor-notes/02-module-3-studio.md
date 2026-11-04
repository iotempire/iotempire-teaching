# Module 3 Studio — Instructor Notes

Operational setup for Module 3 (Sensor Characterization, Calibration & Data Quality). The student-facing material is [Module 3](../modules/03-sensor-characterization-and-calibration.md); the schedule, assessment, and feedback rules stay in the [syllabus](../syllabus.md).

[All instructor notes](./README.md) · [Syllabus](../syllabus.md) · [Module index](../modules/00-index.md)

## 1. Room and kit

- **Six pods, three multimeters:** pair pods, one meter per pair, and swap at the round boundary.
- **Per pod:** one ESP32, one LDR + 10 kΩ resistor, one 10 kΩ potentiometer, 2–3 DS18B20 sealed probes on long cables plus a 4.7 kΩ pull-up, two cups.
- **Shared:** lamps, rulers, dark cards or boxes, a phone lux meter, the class reference thermometer (or a checked DS18B20), hot and cold water.
- **Two instructors:** split the room three pods each; the class reference thermometer stays with an instructor.

## 2. Water prep

- **Cold water:** about an hour before the session, put a few **plastic drink bottles** of water in the freezer. They make a clean, mess-free cold source, and the slush can be poured into cups for the ice-water validation.
- **Hot water:** get it from the kitchen on demand. Mix it down to **warm — never boiling** — before the probes go in.
- **Dry side:** keep a towel and a dry tray for the connectors. The DS18B20 probe is sealed; the cable connector is not.
- **DHT11:** it is **not waterproof**. Keep it dry and out of the ice water, the warm water, and the field transect; it is an air-only comparison.
- If the kitchen is not nearby, a thermos of hot water works; refill as needed.

## 3. Field transect (fall)

- In fall, use the cold weather: send pods outside with the DS18B20 probes and the shared reference thermometer (or the checked DS18B20).
- The long cable lets the probe sit in the cold spot while the ESP32 stays dry under cover. Keep the connector dry.
- Each pod takes one or two spots. The class field table collects air at 1 m and 10 cm, soil surface and 10 cm, a puddle or water butt, the tunnel/greenhouse air, and the indoor reference.
- Record spot, time, probe ID, DS18B20 reading, reference reading, and notes.
- If it is raining or too cold to stay outside, use the tunnel/greenhouse and a sheltered outdoor spot; do not put the electronics in the rain.
- The field data feeds Task 3c: calibrate at the cold spot and the indoor reference, then validate in stirred ice water at 0 °C.

## 4. DHT11 comparison (optional)

- The DHT11 is the cheap-sensor counterexample: 0–50 °C, ±2 °C, 1 °C resolution, 20–90 % RH, ±5 % RH, about one reading per second, proprietary single-wire.
- It is **not waterproof**; keep it out of water and the field transect.
- Use it in the same stable **air** spot as a DS18B20; log 10 readings each, respecting the DHT11's sampling interval.
- The point is sensor selection: ±2 °C accuracy is as wide as the 2 °C decision margin, and 0 °C is the bottom of its range.
- If a pod wants humidity or dew point, use the SHT3x/BME280 class, not the DHT11.

## 5. Running the studio

- The module's three rounds map to the module's three sessions: characterize, calibrate, then filter and decide.
- Each round: **Brief → Bench → Explain (random mini check) → Log/Swap**.
- The mini-check prompts are at the end of each round in the module. Draw one at random and ask a pod to answer from its bench or log.
- In Round 2, pair neighbouring pods for the peer validation of the third point. In Round 3, the pair agrees on one shared artefact and the agreed learning.
- An instructor joins each pod at least once per round. Keep it a short conversation, not a presentation rehearsal.
- The class tables (LDR rows, DS18B20 unit means, field transect) are optional but useful; set them up in the course channel or a shared document.

## 6. Common hiccups

- **DS18B20 not found:** check 3.3 V, GND, DQ, and the 4.7 kΩ pull-up. Long cables add capacitance; try a shorter cable or a lower pull-up.
- **DS18B20 resolution seems to do nothing:** first check that the temperature is changing and that you took a new conversion after `setResolution()`; a constant temperature can look identical at every resolution. Then check `getResolution(address)`; if it stays at 12, the probe may be a clone. Test a known-good probe.
- **DHT11 checksum errors:** respect the sampling interval, retry, and do not read faster than the datasheet allows.
- **LDR near the rails:** keep `Vout` in the ESP32 ADC's linear band; the multimeter is the voltage reference.
- **Ice water:** use a slush of ice and water, stir it, and keep the connector dry. The probe is sealed; the connector is not.
- **Warm water:** warm, not boiling. The probe may survive it; the cable and connector may not.
- **Outdoor cold:** dress warm, watch for wet or slippery ground, and keep the electronics under cover.

[All instructor notes](./README.md) · [Syllabus](../syllabus.md) · [Module index](../modules/00-index.md)
