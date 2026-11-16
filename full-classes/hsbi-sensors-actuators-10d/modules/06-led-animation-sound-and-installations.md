# Module 6 – LED Animation, Sound & Interactive Installations

[← Back to Module 5](./05-leds-and-light-output.md) | [Quick module index](./00-index.md) | [Next: Module 7 →](./07-motors-and-motion-actuators.md)

> A panel is not a bigger strip. It is a display: 1024 pixels, a scan rate, and a power budget you have to measure.

**Course placement:** Day 6 — two sessions. Session 1 is the panel and its power budget; Session 2 is breathing, sound, and the exchange. Work in your Task Pod. The appendices are optional: read them in any order, or replace them with your own research.

## 🎯 Learning Goals

This module gives you the opportunity to explore a real LED display and achieve competency in driving a scanned matrix, measuring its power ceiling, animating without blocking, and fusing sound (and optionally motion) into the light.

By the end of this module, you can:
1. Drive a 32×32 HUB75 RGB panel from a microcontroller: wiring, library, and a stable test pattern.
2. Measure the panel’s current at several brightness levels and choose a maximum luminance that leaves margin on the 5 V 4 A supply.
3. Build a non-blocking breathing animation with `millis()` and one parameter that controls speed and depth.
4. Fuse a microphone signal — and, if you want, the IMU — into the animation so it reacts without flicker.
5. Justify the architecture — one microcontroller or two — from pin count, memory, timing, and library constraints.

**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 📖 Story — The Exhibition That Had to Breathe

**Lumenwerk Gütersloh GmbH** has one week before the Stadtmuseum opening. Curator **Aylin Demir** wants the light wall to *breathe*: a slow pulse when the room is empty, a faster wave when visitors approach, and a bright ripple when the room gets loud. Creative director **Mara Voss** has replaced the prototype strip with a 32×32 RGB panel; technician **Jonas Feld** has the panel, a 5 V 4 A supply, and an M5StickC-S3 with a microphone.

The first test is beautiful — until Jonas sets the panel to full white and the supply sags. The second problem is quieter: the panel needs thirteen control pins, the Stick has a microphone and an IMU, and the animation must keep running while the audio is sampled. Aylin’s question is practical: *“Can one board do both jobs, or does this installation need two — and how bright can we actually run it?”*

## 🧰 What you have

| Part | What it gives you |
|---|---|
| 32×32 HUB75 RGB panel, 5 mm pitch ([Adafruit 2026](https://www.adafruit.com/product/2026)) | 1024 RGB pixels, 5 V logic, up to 4 A at full white, 13 control signals |
| 5 V 4 A power supply | The panel’s supply — not the microcontroller’s USB port |
| M5StickC-S3 | ESP32-S3, 8 MB PSRAM, BMI270 IMU, ES8311 codec with MEMS microphone and speaker |
| ESP32 MiniKit(s), jumpers, breadboard, level shifter | A second controller if you need one, and the wiring between them |
| Multimeter (shared), phone camera | Current measurements and the video for your portfolio |

Meters are shared; ask your instructor which panels and supplies are per pod, and plan the pass-around with your neighbouring pod.

## 🔌 ★ Task 1 — Light the panel, find the ceiling

**Proves:** Goals 1, 2, and 5 · **Produces:** a working panel, a power table, and a one-sentence architecture decision.

1. **Choose the architecture.** One microcontroller or two? Count the panel’s thirteen signals, check which pins your board actually exposes, and check what the driver library needs. Write the decision in one sentence before you wire anything.
2. **Wire it.** HUB75 ribbon to the panel, 5 V and GND from the 4 A supply, common ground with the microcontroller. Do not power the panel from USB or from a GPIO. Add level shifting if your panel or wiring is unhappy at 3.3 V.
3. **Bring it up.** Run a test pattern at low brightness first. Confirm orientation, color order, and that the whole 32×32 area is addressed.
4. **Measure the ceiling.** Measure current at several brightness levels — for example 25 %, 50 %, 75 %, and 100 % white — and find the highest setting that stays stable with margin on the 4 A supply. Watch the panel voltage, not only the current.
5. **★ Log it.** In `## Study log` in `Module06/README.md`: the architecture decision and why, the wiring, the max luminance you trust, and the measured current at each step.

**Done when:** the panel shows a stable test pattern, you can state the maximum brightness you trust on the 4 A supply, and you can defend one controller versus two.

## ✨ ★ Task 2 — Breathe, then listen

**Proves:** Goals 3 and 4 · **Produces:** a breathing mode, a sound-reactive mode, a video, and a mapping note.

1. **Breathe.** Build a `millis()`-based breathing effect — no `delay()` in the loop — with one normalized parameter that controls speed and depth. The loop must stay responsive while it runs.
2. **Listen.** Use the Stick’s microphone (M5Unified) or an analog sound sensor: sample fast, compute a short-term envelope (peak or RMS), and map it to brightness or hue. Add automatic gain control so quiet and loud rooms both work.
3. **◇ Optional — motion.** Use the BMI270 IMU for tilt or shake as a second input. Only if you want it; the sound path is the required one.
4. **Test and record.** Quiet and loud, still and moving. Note latency, flicker, and what you changed to make it stable.
5. **★ Log it.** In the same log: the envelope you computed, the mapping you chose, the IMU input if used, and what still flickers.

**Done when:** the panel breathes smoothly while the loop stays responsive, and the sound mode reacts visibly without constant re-tuning.

## ★ Task 3 — Exchange and evidence

**Proves:** Goals 1–5 · **Produces:** the agreed learning in your shared log, one shared artefact, and the evidence list below.

1. Show each other the panel, the power table, and the breathing and sound modes.
2. Compare architectures: who used one controller, who used two, and what broke in each case?
3. Agree on the 3–5 most noteworthy points and one learning you jointly stand behind; one of you writes the “Agreed learning (pod discussion)” note into the shared log.
4. Pick one shared artefact — the best video, the power table, or a wiring photo — and post it in the course Discord with one sentence on why.
5. Check the evidence list below and fill the gaps.

## ✅ Suggested portfolio evidence (proofs of the learning goals)

1. `## Study log` in `Module06/README.md` with the two task entries and the architecture decision.
2. Panel wiring: a photo or diagram, the pin mapping, and the library you used.
3. Power table: brightness versus measured current, the maximum stable luminance, and the supply margin.
4. Video: the breathing effect and the sound reaction (plus the IMU input if you used it).
5. One paragraph on the installation constraints: heat, mounting, and what happens when a cable or the sound input fails.
6. Deeper question: why is a scanned panel a different engineering problem from a WS2812B strip?

> You may prove the same goals another way. The evidence is the point, not the task list.

## 📎 Appendix A — Hints and resources (read in any order)

**Panel facts.** The 32×32 panel is a HUB75 display: 1024 RGB LEDs, 5 V logic, thirteen signals (six data: R1/G1/B1/R2/G2/B2; seven control: A/B/C/D, CLK, LAT, OE — some panels also expose E). It is scanned, so the whole image is not lit at once. Adafruit rates the panel at up to 4 A with all LEDs on; typical animations draw less. Product: [Adafruit 2026](https://www.adafruit.com/product/2026); background: [RGB LED matrix basics](https://learn.adafruit.com/32x16-32x32-rgb-led-matrix).

**Power.** Use the 4 A supply for the panel, with a common ground to the controller, short thick wires, and a bulk capacitor across 5 V/GND if the image flickers on bright frames. Full white is the worst case and leaves no margin on a 4 A supply; that is why you measure and cap the brightness. Never power the panel from USB, a GPIO, or the 3.3 V rail. Panels get warm at high brightness — do not cover them.

**Driver.** The usual ESP32 choice is [`ESP32-HUB75-MatrixPanel-DMA`](https://github.com/mrfaptastic/ESP32-HUB75-MatrixPanel-DMA) (PlatformIO: `mrfaptastic/ESP32-HUB75-MatrixPanel-DMA`); it uses DMA, supports double buffering, and ships examples. `Adafruit_Protomatter` is an alternative. The library defines the pin mapping; check that your board exposes every pin it needs. The panel expects 5 V logic; 3.3 V often works, a level shifter (for example a 74HCT245) is the safe choice.

**One controller or two?** Count the thirteen signals against the pins your board exposes, then add the pins the microphone, IMU, and display already use. On a small board the honest answer is often a second ESP32 that only drives the panel, with the Stick sending brightness, hue, or level over serial, I2C, or ESP-NOW. There is no single right answer; there is an answer you can defend.

**M5StickC-S3.** ESP32-S3 with 8 MB PSRAM, BMI270 IMU, and an ES8311 codec with a MEMS microphone and speaker. Use [M5Unified](https://github.com/m5stack/M5Unified) for the microphone and IMU; the microphone is an I2S codec, not a bare analog pin. The Stick’s exposed header and Grove port are limited — that is part of the architecture decision.

**Non-blocking animation.** Keep the render interval and the update interval separate, animate a normalized `0..1` parameter, and never `delay()` in the loop. The pattern is the same as in [Module 5](./05-leds-and-light-output.md).

**Sound envelope.** Sample in blocks, compute peak or RMS over a short window, and decouple the fast audio sampling from the slower frame rate. Automatic gain control normalizes to a recent maximum, so the effect survives both a whisper and a loud room.

**Installation.** Plan for heat, mounting, a diffuser, strain relief on the ribbon and power wires, and a defined behavior when the sensor or the network drops. An installation that looks good for a minute is not the same as one that survives an evening.

## 📎 Appendix B — Ideas and prompts when you are stuck

Read in any order, take what helps, and replace the rest with your own research. Cite what you use.

**Immediate experiments**

- Solid colors, a gradient, a moving bar, and a plasma — the four test patterns that expose wiring, orientation, and refresh problems.
- Change the gamma and the brightness steps; compare what the eye sees with what the meter reads.
- Rotate or mirror the image in software; the panel’s orientation is a mapping choice, not a wiring fact.
- Map the microphone level to rows (a VU meter), to hue, or to a peak-hold bar.
- Use the IMU: tilt maps to direction, a shake triggers sparkle.
- If you use two controllers, define a tiny protocol (`LEVEL 0..100`, `HUE 0..255`) before you write code.

**Questions to ask an LLM (then verify on the panel)**

- “Scaffold a PlatformIO project for a 32×32 HUB75 panel on an ESP32-S3 with the HUB75 DMA library: test pattern, brightness control, and a non-blocking loop.”
- “Count the pins a HUB75 panel needs and compare them with the exposed GPIOs of the M5StickC-S3. Propose a one-controller and a two-controller architecture, with the trade-offs.”
- “Given measured currents at 25/50/75/100 % white, estimate the maximum safe brightness for a 5 V 4 A supply and the margin I should keep.”
- “Write a `millis()`-based breathing effect for a 32×32 panel with one speed/depth parameter. No `delay()`.”
- “Compute a short-term RMS envelope from an I2S microphone and map it to brightness with automatic gain control.”
- “Explain HUB75 scan and refresh, and why a phone camera may show flicker that the eye does not.”

> Run each prompt against your own panel, and record where the model is wrong, vague, or over-confident.

## 📚 If you want to go deeper

- [Adafruit 32×32 panel](https://www.adafruit.com/product/2026) and [RGB LED matrix basics](https://learn.adafruit.com/32x16-32x32-rgb-led-matrix) — wiring, power, and scan.
- [`ESP32-HUB75-MatrixPanel-DMA`](https://github.com/mrfaptastic/ESP32-HUB75-MatrixPanel-DMA) — DMA driver, examples, and pin mapping.
- [M5Unified](https://github.com/m5stack/M5Unified) — microphone, IMU, and display on the Stick.
- [Arduino: `millis()`](https://docs.arduino.cc/language-reference/en/functions/time/millis/) and [Blink Without Delay](https://docs.arduino.cc/built-in-examples/digital/BlinkWithoutDelay/) — the non-blocking pattern.
- [Envelope (music)](https://en.wikipedia.org/wiki/Envelope_(music)) and [Root mean square](https://en.wikipedia.org/wiki/Root_mean_square) — the sound features you can compute on a microcontroller.

---

[← Previous: Module 5](./05-leds-and-light-output.md) | [Back to front page](../README.md) | [Quick module index](./00-index.md) | [Next: Module 7 — Motors & Motion Actuators →](./07-motors-and-motion-actuators.md)
