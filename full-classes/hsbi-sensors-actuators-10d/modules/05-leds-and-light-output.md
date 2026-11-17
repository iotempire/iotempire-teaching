# Module 5 – LEDs & Light as Output

[← Back to Module 4](./04-liquid-measurement-and-sensor-selection.md) | [Quick module index](./00-index.md) | [Next: Module 6 →](./06-led-animation-sound-and-installations.md)

> Light is the actuator you will use most in this course. Today: how to drive it correctly — safely, dimmably, in color, and addressably.

**Course placement:** Day 5 — two sessions. Session 1 is Tasks 1–2; Session 2 is Task 3, the optional extensions, and the closing Tasks 4–5. The theory slides are [`slides/05-leds.md`](../slides/05-leds.md) — the interlude between builds, and the instructor may leave them up while an agent scaffolds. The run sheet is in the instructor notes.

## 🎯 Learning Goals

This module gives you the opportunity to explore light as an actuator and achieve competency in LED current limiting, PWM and gamma, RGB mixing, addressable WS2812B strips, power budgeting, and an AI-assisted, reproducible project setup.

By the end of this module, you can:
1. Explain LED physics and dimension a current-limiting resistor correctly.
2. Use PWM to dim an LED and explain duty cycle, frequency, and gamma.
3. Mix colors on an RGB LED and describe additive mixing.
4. Set up a reproducible PlatformIO project (`uv`/`pio`, Zed or VS Code, `AGENTS.md`) and use an AI agent to scaffold it — then verify the draft on hardware.
5. Address individual pixels on a WS2812B strip, explain the single-wire data path, and choose a driver that survives Wi-Fi.
6. Compute and measure a strip's power budget, and decide what a USB supply can and cannot power.

**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 📖 Story — The Wall That Browned Out

**Lumenwerk Gütersloh GmbH** is building a light wall for the Stadtmuseum's new exhibition. Curator **Aylin Demir** wants a warm, continuous glow that follows visitors along a 5-metre corridor. The prototype is beautiful for ten minutes — then the strip dims, the controller resets, and one section turns an unhealthy shade of pink.

Technician **Jonas Feld** has made the classic mistake: he powered a 30-LED strip from the microcontroller's 5 V pin and treated “brightness” as a single number. Aylin's question is practical: *"How much current does this wall actually need, and how do we drive it so it survives an opening night?"* Today: LED physics, current limiting, PWM and gamma, RGB mixing, addressable strips, and a power budget you measure.

## 🧭 How to follow along

In Tasks 1–3 the instructor may build at the front instead of leaving you to work from the text. **Follow along** means: do the same steps on your own bench — wire the same circuit, run the same code — ask questions when something is unclear, and report problems and curiosities as they happen — that dialog is part of the learning, not an interruption. The instructor will usually be too fast, so say so and slow the pace down until you can follow. If you prefer to work from the text at your own speed, that is fine too; each task is written to stand alone.

## 🧰 One-time setup

Install the CLI once — skip this if `pio --version` already works:

```sh
uv tool install --with pip platformio
uv tool update-shell          # restart the shell
pio --version                 # an existing pio on PATH is also fine
```

No `uv`? [Install it first](./Z-resources-bank.md#python-environment-with-uv). Each task below gets its **own folder** — `task1-led/`, `task2-rgb/`, `task3-strip/` — so every build goes into your portfolio separately. A project is just a folder: create it and open it in your editor.

No serial port? Linux needs your user in `dialout` (or `uucp`) and the PlatformIO udev rules; Windows needs the CP210x or CH340 driver; macOS needs the driver and, if the port stays invisible, `admin` and `wheel` membership. The table is in the [resource bank](./Z-resources-bank.md#platformio-cli--zedvscode-setup).

## 🔌 ★ Task 1 — one LED, no AI

**Proves:** Goals 1 and 2 · **Produces:** `task1-led/` with the fading LED.

> **Follow along** if the instructor presents this at the front.

**Hardware.** A red or yellow 5 mm LED: anode (long leg) → **220 Ω** → **GPIO 16**; cathode (short leg, flat side) → **GND**. Do not use blue or green here — their forward voltage is close to 3.3 V, so 220 Ω leaves almost no current and the LED looks broken.

**Arduino IDE.** Select the board (`ESP32 Dev Module`, or the profile your instructor names for the MiniKit) and the port. Save it as `task1-led/task1-led.ino`, paste the code, and upload it. It fades the LED up and down; no library is needed.

```cpp
// Task 1 — one LED, PWM fade on GPIO 16
// PlatformIO: uncomment the next line. Arduino IDE includes it automatically.
// #include <Arduino.h>

const int LED_PIN = 16; // for the lazy ones, you can also use 2 for the inverted blue onboard led.

void setup() {
  Serial.begin(115200);
  Serial.print("Task 1: PWM fade on GPIO ");
  Serial.println(LED_PIN);
}

void loop() {
  for (int duty = 0; duty <= 255; duty++) {
    analogWrite(LED_PIN, duty);
    delay(8);
  }
  for (int duty = 255; duty >= 0; duty--) {
    analogWrite(LED_PIN, duty);
    delay(8);
  }
}
```

**PlatformIO.** Create `task1-led/`, open it, and run `pio project init --board mhetesp32minikit`. Then put the same code in `src/main.cpp` with this `platformio.ini`:

```ini
[env:mhetesp32minikit]
platform = espressif32
board = mhetesp32minikit
framework = arduino
monitor_speed = 115200
```

```sh
pio run -t upload          # build and flash
pio device monitor         # serial monitor, 115200; Ctrl+C to exit
# or both in one line:
pio run -t upload -t monitor
```

> `analogWrite()` uses the LEDC peripheral on the current Arduino-ESP32 core. On an older core, use `ledcAttach()`/`ledcWrite()`.

> **If `Serial`, `analogWrite`, or `delay` are undeclared in PlatformIO**, uncomment `#include <Arduino.h>` at the top of `src/main.cpp`. PlatformIO compiles `.cpp` files as C++ and does not auto-include it; the Arduino IDE does.

**Done when:** the LED fades smoothly from off to full and back, and you can say what duty cycle means.

**★ Log it.** Under `## Study log` in `Module05/README.md`, one sentence on what the fade does and what duty cycle means. One pod member keeps the shared log; the others link to it and add one sentence.

## 🌈 ★ Task 2 — RGB LED project

**Proves:** Goals 1, 3, and 4 · **Produces:** `task2-rgb/` with the serial `R G B` REPL.

> **Follow along** if the instructor presents this at the front.

**1. Create the folder.** `task2-rgb/`, opened in Zed or VS Code — a new folder, not the Task 1 one.

**2. Paste the prompt** into your AI agent. It scaffolds PlatformIO, `AGENTS.md`, the firmware, the README, and the `.gitignore`.

<a id="task-2-prompt"></a>

<details>
<summary>Task 2 prompt — copy this into your AI agent</summary>

```text
Initialize a PlatformIO Arduino project in this empty folder for `board = mhetesp32minikit` (using `pio` on PATH, or installing it via `uv tool install --with pip platformio`). Configure `platformio.ini` with `monitor_speed = 115200`, `monitor_echo = yes`, and `monitor_filters = send_on_enter`. Add a `.gitignore` for `.pio/` and `compile_commands.json`.

Create a short `AGENTS.md` documenting the board (`mhetesp32minikit`), wiring (discrete RGB LED via 220 Ω resistors on GPIO 16=R, 17=G, 18=B), and to run `pio run -t compiledb` after dependency changes.

In `src/main.cpp`, start with `#include <Arduino.h>` (PlatformIO does not add it automatically), then drive the RGB LED with `analogWrite()` (include a `COMMON_ANODE` flag, default `false`). Read `R G B` integers (0–255) over Serial, clamp and apply them, echo back the values, and print an error on invalid input. Add a short `README.md` with the wiring, the REPL commands, and how to build, upload, and open the monitor. Verify with `pio run -t compiledb && pio run`.
```

</details>

**3. Wire the LED.** Common-cathode RGB LED through **three 220 Ω resistors**: red → GPIO 16, green → GPIO 17, blue → GPIO 18, common cathode → GND. For a common-anode part, connect the common pin to 3.3 V (or 5 V) and set `COMMON_ANODE` to `true` — the PWM values invert.

**4. Verify and measure.** Deploy, open the monitor at **115200**, and type `255 0 0`, `0 255 0`, `0 0 255`. Check that the agent echoes the applied values and rejects malformed input. Then put the meter in series with each channel (or measure the voltage across the resistor and use `I = U/R`): red will draw much more than blue at the same resistor value, because the forward voltages differ. That imbalance is the lesson, not a fault.

**Done when:** the LED shows the colors you type, and you can state the measured current for red, green, and blue.

**Why 220 Ω is the default.** It is a safe, conservative value: red draws about 6 mA on 3.3 V, green less, blue much less; everything lights, and nothing is near the GPIO limit. You only need the precise calculation when you want a target current, a balanced white, or when a low-`Vf` LED with a small resistor would exceed the pin's comfort range. The full arithmetic is in [Appendix A](#appendix-a).

**★ Log it.** In the same `## Study log`: the measured red, green, and blue currents, whether your part is common cathode or anode, and one sentence on what the agent got wrong (if anything).

## ✨ ★ Task 3 — WS2812B strip project

**Proves:** Goals 4, 5, and 6 · **Produces:** `task3-strip/` with the addressable strip and the power table.

> **Follow along** if the instructor presents this at the front.

**1. Create the folder.** `task3-strip/`, opened in Zed or VS Code.

**2. Paste the prompt** into your AI agent. It scaffolds the project, picks an ESP32 driver method for the board, and writes the firmware and the README.

<a id="task-3-prompt"></a>

<details>
<summary>Task 3 prompt — copy this into your AI agent</summary>

```text
Initialize a PlatformIO Arduino project in this empty folder for `board = mhetesp32minikit` (using `pio` on PATH, or installing it via `uv tool install --with pip platformio`). Configure `platformio.ini` with `lib_deps = makuna/NeoPixelBus`, `monitor_speed = 115200`, `monitor_echo = yes`, and `monitor_filters = send_on_enter`. Add a `.gitignore` for `.pio/` and `compile_commands.json`.

Create a short `AGENTS.md` documenting:
- Board: `mhetesp32minikit` (ESP32)
- Wiring: 8-LED WS2812B strip powered from 5V USB and GND, data on GPIO 16
- Library: Always use `NeoPixelBus` with an ESP32 method that offloads the waveform to hardware (I2S or RMT) — never `FastLED`
- Power limit: Keep `SetLuminance(80)` or lower so 8 LEDs stay within the 500 mA USB budget

In `src/main.cpp`, start with `#include <Arduino.h>` (PlatformIO does not add it automatically), then use `NeoPixelBus` with `NeoGrbFeature` and an ESP32 method that fits this board and keeps Wi-Fi/BLE usable: choose the I2S or RMT hardware method appropriate for the MH-ET LIVE ESP32 MiniKit and the installed Arduino-ESP32 core, and state in the README which method and channel you chose and why. Consult the NeoPixelBus ESP32 methods documentation (https://github.com/Makuna/NeoPixelBus/wiki/ESP32-NeoMethods). Apply `SetLuminance(80)` and control the 8 LEDs over Serial: accept `index R G B` (`index` 0–7, `R/G/B` 0–255) and `clear`, validate bounds, echo updates. Add a short `README.md` with the wiring, the chosen method and channel, the REPL commands, and the power note. Verify with `pio run -t compiledb && pio run`.
```

</details>

**3. Wire the strip.** 8-LED WS2812B on the MiniKit's **5 V (VCC)** and **GND**, data to **GPIO 16 (DIN)**, over USB. Task 3 **reuses GPIO 16**: unplug the Task 2 red channel first. A ~330 Ω series resistor in the data line is optional insurance on a short strip.

**4. Verify and budget.** At **115200**, light any pixel with `index R G B` (`0..7`), clear the strip, and check that the index and values are validated and echoed. Then the power: each LED can draw up to ~60 mA at full white, so 8 × 60 mA = **480 mA** — the strip alone sits inside a USB 2.0 port's 500 mA, but the ESP32 adds 100–250 mA with Wi-Fi and pushes it over. USB 3 supplies 900 mA, a USB-C port or charger usually 1.5–3 A. `strip.SetLuminance(80)` is the guardrail.

**Done when:** you can light any single pixel by index, clear the strip, name the driver method and channel you used, and state the supply current for 8, 30, and 60 LEDs.

**Why NeoPixelBus.** On the ESP32, Wi-Fi and BLE generate high-priority radio interrupts; a software-timed or bit-banged strip can glitch. NeoPixelBus puts the 800 kHz NRZ waveform on hardware (I²S or RMT), so the frame survives the radio. Which method and channel fits depends on the board and the Arduino-ESP32 core — check the agent's pick against the [ESP32 methods documentation](https://github.com/Makuna/NeoPixelBus/wiki/ESP32-NeoMethods), and if it does not compile or the strip glitches, refine the prompt, not the wiring. **Do not default to FastLED.**

**◇ Optional extensions — if you finish early.** One is enough; two is fast. Each is a small, AI-assisted iteration on the working strip.

1. **Non-blocking animations.** Add `all R G B` and `rainbow` modes with `HslColor` sweeps and `millis()` timing (or `NeoPixelAnimator`) without blocking serial input.
2. **Perceptual linearity.** Compare a linear ramp with a gamma-corrected one — `NeoPixelBusLg` with `NeoGammaTableMethod` applies the gamma table for you. At which step size does the eye stop seeing a difference?
3. **Sensor-to-actuator bridge.** Connect an analog sensor on **GPIO 34 (ADC1)** from an earlier module and map its calibrated reading to the active pixel index, an `HslColor` hue, or `SetLuminance()`.

**★ Log it.** In the same `## Study log`: the `index R G B`/`clear` demo, your `SetLuminance` value, the measured current, and the power table — measured vs. computed for 8, 30, 60, and 144 LEDs.

## 🔗 ★ Task 4 — Share the repo (AI-first)

**Proves:** Goal 4 · **Produces:** the committed `Module05/` repo and its README.

The challenge is not finished on your laptop. Your `Module05/` folder in the portfolio repo holds `task1-led/`, `task2-rgb/`, and `task3-strip/`, plus the README, `AGENTS.md`, photo/video, and power table.

1. **Open the portfolio repo** in Zed or VS Code. The Source Control panel (or `gh`) commits and pushes; the [Git primer](./Z-resources-bank.md#git--github-primer-template-editor-markdown-conflicts) has the workflow.
2. **Finish the README.** The scaffold already drafted one; give the AI the wiring, the REPL commands, and the power table, and ask it to complete the README with a wiring table, the library and method, how to run the REPL, and the measured currents.
3. **Verify before you commit.** Check the pin, the LED count, the color order (GRB), the library, the baud rate, and the measured current. The AI's arithmetic is a claim, not a measurement.
4. **Commit and share.** Commit code, README, `AGENTS.md`, and the power table; copy the repo link into the Discord and your study log. No secrets, no `.pio/`, no `compile_commands.json`, no binaries.

The AI is the drafting tool; verification is the skill. If you want a standalone repo instead of the portfolio folder, `gh repo create task3-strip --public --source=. --push` works.

> **AI assistant and GitHub Education.** Use whatever you already have — Claude, DeepSeek, ChatGPT, Copilot — in Zed or VS Code. If you want Copilot with education credits, apply at [education.github.com](https://education.github.com/); it is optional. The course template is [iot-portfolio-template](https://github.com/iotempire/iot-portfolio-template).

> **Credits.** Copilot Education gives unlimited inline completions but limited chat/agent credits; other plans have their own limits. Use a lightweight model for the scaffold and save the heavy model for the one hard bug.

## ★ Task 5 — Exchange and evidence

**Proves:** Goals 1–6 · **Produces:** the agreed learning in your shared log, one shared artefact, and the evidence list below.

1. Show each other the Task 1 fade, the Task 2/3 builds, and the power table.
2. Compare your prompts: what did the agents get wrong, and what did you have to fix? Include one AI claim you verified against the datasheet or the meter.
3. Agree on the 3–5 most noteworthy points and one learning you jointly stand behind; one of you writes the “Agreed learning (pod discussion)” note into the shared log.
4. Pick one shared artefact — the best animation clip, power table, or wiring photo — and post it in the course Discord with one sentence on why.
5. Check the evidence list below and fill the gaps.

## ✅ Suggested portfolio evidence (proofs of the learning goals)

1. `## Study log` in `Module05/README.md` with the three task entries and the AI claim you checked.
2. The three project folders (`task1-led/`, `task2-rgb/`, `task3-strip/`) with code, README, and `AGENTS.md`.
3. Photos or video of the fade, the RGB REPL, and `index R G B`/`clear`.
4. The power table: measured vs. computed for 8, 30, 60, and 144 LEDs, and the supply decision.
5. One optional extension, or a design rationale for the animation you chose.
6. Deeper question: Why does an addressable strip need a power budget *and* a data-level consideration, while a single indicator LED needs neither?

> You may prove the same goals another way. The evidence is the point, not the task list.

<a id="appendix-a"></a>
## 📎 Appendix A — Background and failure modes

**Forward voltage and voltage capping.** An LED is a diode: above its forward voltage `Vf` it conducts, and brightness follows current, not voltage. `Vf` depends on color (red ≈ 1.9 V, green ≈ 2.1 V, blue/white ≈ 3.0–3.4 V). The LED effectively caps the voltage across itself at `Vf`; the series resistor takes the difference `Vs − Vf`. On a 3.3 V pin, a blue LED with `Vf ≈ 3.2 V` leaves only 0.1 V across the resistor — tiny changes in `Vf` change the current enormously. That is why the same 220 Ω gives a bright red and a dim blue.

**Resistor computation.** `R = (Vs − Vf) / I`. For a target current, compute and choose the next higher standard value. Examples: red at 6 mA on 3.3 V needs `(3.3 − 1.9)/0.006 ≈ 233 Ω` → 240 Ω; 220 Ω is the safe default. A 33 Ω resistor on red would draw `(3.3 − 1.9)/33 ≈ 42 mA`, over the GPIO comfort range. Resistor power: `P = I² · R`; at 42 mA and 33 Ω that is ~58 mW, so a ¼ W part is fine, but the pin is not.

**PWM and gamma.** Duty cycle is the on-fraction; average current and brightness follow it. Below ~100 Hz you see flicker; LEDs usually run at 1–20 kHz. A linear duty ramp looks like it jumps at the bright end; apply gamma (`out ≈ in^2.2`) or a lookup table. `analogWrite()` uses the LEDC peripheral on the ESP32; older cores need `ledcAttach()`/`ledcWrite()`.

**RGB.** Three diodes in one package; set each channel with its own PWM duty. Additive mixing: red + green = yellow, all three = white. Common-anode and common-cathode parts swap polarity; the code's `COMMON_ANODE` toggle handles the inversion.

**WS2812B.** A driver chip in every LED; one data line carries 24-bit values (GRB), and each pixel takes the first value it sees and regenerates the rest. The protocol is 800 kHz NRZ with a reset/latch gap; timing is tight. On the ESP32, Wi-Fi/BLE interrupts can corrupt software-timed output, which is why NeoPixelBus uses a hardware I²S/RMT path. The data line is not the power line: 8 LEDs at full white are 480 mA, 30 are 1.8 A, 144 are 8.6 A.

| Symptom | Likely cause | Fix |
|---|---|---|
| No light at all | polarity, missing resistor, wrong pin, no common ground | check the LED polarity and the pin; measure `Vf` |
| Only the first pixel lights | data direction (DIN/DOUT), wrong index, wrong LED count | check the strip orientation and `LED_COUNT` |
| Wrong colors | color order (RGB vs. GRB) | change `NeoGrbFeature`/`NeoRgbFeature` |
| Flicker or random resets | data level, long wires, supply droop, Wi-Fi interrupts | 330 Ω data resistor, shorter wires, separate supply, NeoPixelBus |
| Strip browns out at high brightness | current budget, weak USB port | lower `SetLuminance`, 1 A+ supply, measure with the USB meter |
| Upload fails or the port is busy | monitor holds the port, wrong board | close the monitor, `pio device list`, check `board` |
| AI code uses the wrong pin or library | hallucinated detail | fix it, add the rule to `AGENTS.md`, re-run |

> **Bulk capacitor.** Optional. If you add one: 10–16 V rating, correct polarity, power off while wiring. A reverse-connected electrolytic can explode. Decoupling (0.1 µF at an IC) is a different job.

<a id="appendix-b"></a>
## 📎 Appendix B — Doing it by example, without AI

You do not have to use an AI. The scaffold is a convenience; the same project can be built by hand. This is the classic route — and the reference for what the agent was supposed to do.

**Classic examples to start from**

- **One LED / PWM:** the Arduino [Fade example](https://docs.arduino.cc/built-in-examples/basics/Fade/) (`File → Examples → 01.Basics → Fade`) uses `analogWrite`. On ESP32 core 3.x it works as written; on older cores use the [ESP32 `AnalogOut` LEDC examples](https://github.com/espressif/arduino-esp32/tree/master/libraries/ESP32/examples), and mind the `ledcSetup`/`ledcAttach` API change.
- **RGB LED:** there is no single stock example; wire three PWM channels and apply the `Fade` logic per channel. The working reference sketch is in the [instructor backup sketches](../instructor-notes/07-module-5-backup-sketches.md).
- **NeoPixelBus:** the library ships [examples](https://github.com/Makuna/NeoPixelBus/tree/master/examples). After `pio project init` and `lib_deps = makuna/NeoPixelBus`, they are under `.pio/libdeps/mhetesp32minikit/NeoPixelBus/examples/`. Start with `NeoPixelTest`, then adapt to `NeoPixelBusLg` with `NeoEsp32I2s1Ws2812xMethod`.
- **Adafruit NeoPixel:** [`strandtest` and `simple`](https://github.com/adafruit/Adafruit_NeoPixel/tree/master/examples) are the classic first-strip examples; use them to compare, not as the course default.
- **FastLED:** [`blink` and `DemoReel100`](https://github.com/FastLED/FastLED/tree/master/examples) are the classic patterns; reference only on this board.

**What the agent would do — do it yourself**

1. Install the CLI: `uv tool install --with pip platformio && uv tool update-shell`; check `pio --version`.
2. `pio project init --board mhetesp32minikit`.
3. Write `platformio.ini` (board, framework, `monitor_speed`, `lib_deps` for the strip).
4. Add `.gitignore` (`.pio/`, `compile_commands.json`).
5. Write `src/main.cpp` from the [backup sketches](../instructor-notes/07-module-5-backup-sketches.md), starting with `#include <Arduino.h>`; keep the pinout and power rules in the [AGENTS.md template](#agentsmd).
6. `pio run`, `pio run -t upload`, `pio device monitor`.
7. Commit code, README, and measurements to `Module05/`.

The editor extras (Zed tasks, clangd, VS Code settings) are optional for the build; copy them from the [resource bank](./Z-resources-bank.md#platformio-cli--zedvscode-setup) if you want them.

**Why this path exists.** The AI is a drafting tool, not a requirement. The evidence is the working hardware and the measurements. If you build it by hand, document the same things: the pinout, the library, the current, and what failed.

<a id="appendix-c"></a>
## 📎 Appendix C — Pointers and LLM prompts

**Pointers**

- LED basics and resistors — [Wikipedia: Light-emitting diode](https://en.wikipedia.org/wiki/Light-emitting_diode), [LED circuit](https://en.wikipedia.org/wiki/LED_circuit)
- PWM and gamma — [Wikipedia: Pulse-width modulation](https://en.wikipedia.org/wiki/Pulse-width_modulation), [Gamma correction](https://en.wikipedia.org/wiki/Gamma_correction)
- Addressable LEDs — the [WS2812B datasheet](https://cdn-shop.adafruit.com/datasheets/WS2812B.pdf), [NeoPixelBus](https://github.com/Makuna/NeoPixelBus) and its [ESP32 method and channel guide](https://github.com/Makuna/NeoPixelBus/wiki/ESP32-NeoMethods)
- Power budgets — the [Adafruit NeoPixel Überguide](https://learn.adafruit.com/adafruit-neopixel-uberguide/powering-neopixels)
- Setup and editor tasks — the [resource bank](./Z-resources-bank.md#platformio-cli--zedvscode-setup)
- Formulas — the [resource bank](./Z-resources-bank.md#formulas-you-will-use)

**Questions to ask an LLM (then verify against your hardware)**

Ask your co-pilot — but treat every answer as a **claim to test**, not a fact. Good starting prompts:

- "I have a 3.3 V supply and a blue LED with Vf ≈ 3.2 V. Why is the current so sensitive to Vf, and why does a 220 Ω resistor still light it?"
- "Compute the resistor for a red LED at 6 mA on 3.3 V and compare it with 220 Ω. What changes at 33 Ω?"
- "Explain PWM duty cycle, frequency, and resolution. Why does a linear duty ramp look like it jumps at the bright end?"
- "Why does a WS2812B strip need a power budget and a data-level consideration, while a single indicator LED needs neither?"
- "Why is NeoPixelBus with I2S1 DMA more robust than FastLED on an ESP32 with Wi-Fi? Give me the failure mode each one has."
- "Scaffold an Arduino/PlatformIO project for an ESP32 with 8 WS2812B LEDs on GPIO 16 and a serial REPL (`index R G B`, `clear`). Include `platformio.ini`, the sketch, and a README with wiring, the library, and a power table. I will verify the pin, LED count, color order, and current."

> Run each prompt against your own circuit, and record where the model is wrong, vague, or over-confident.

<a id="appendix-d"></a>
<a id="agentsmd"></a>
<a id="appendix-d--agentsmd-template"></a>
## 📎 Appendix D — `AGENTS.md` template

One `AGENTS.md` at the project root, **not** a separate `CLAUDE.md`, so Copilot and Claude agents load the same rules. A working template:

```md
# AGENTS.md — LED lab

- Board: MH-ET LIVE ESP32 MiniKit (`mhetesp32minikit`), PlatformIO CLI (`pio`).
- Task 1: single red/yellow LED, 220 Ω, GPIO 16 (PWM fade).
- Task 2: common-cathode RGB LED, 220 Ω per channel, R=GPIO16, G=GPIO17, B=GPIO18.
- Task 3: 8× WS2812B, DIN=GPIO16, 5 V from the MiniKit USB rail, common ground.
- Library: `makuna/NeoPixelBus`, an ESP32 hardware method (e.g. `NeoEsp32I2s1Ws2812xMethod`).
  Do not default to FastLED.
- `strip.SetLuminance(80)`. 8 LEDs × 60 mA = 480 mA; stay inside the USB budget.
- Serial: 115200. Task 2: `R G B`; Task 3: `index R G B` and `clear`.
  Echo applied values; validate input and index bounds.
- PlatformIO `src/main.cpp` needs `#include <Arduino.h>`; the Arduino IDE includes it automatically.
- Never power the strip from a GPIO or the 3.3 V pin.
```

## 📚 If you want to go deeper

- [Wikipedia: Light-emitting diode](https://en.wikipedia.org/wiki/Light-emitting_diode) and [LED circuit](https://en.wikipedia.org/wiki/LED_circuit) — forward voltage, current, and resistor sizing.
- [Pulse-width modulation](https://en.wikipedia.org/wiki/Pulse-width_modulation) and [Gamma correction](https://en.wikipedia.org/wiki/Gamma_correction) — why a linear ramp looks wrong.
- [WS2812B datasheet](https://cdn-shop.adafruit.com/datasheets/WS2812B.pdf) — timing, current, and data levels.
- [NeoPixelBus](https://github.com/Makuna/NeoPixelBus) — robust ESP32 driver, I2S/DMA methods, and color helpers.
- [FastLED](https://fastled.io/) — reference for patterns, palettes, and HSV; compare if curious.
- [Adafruit NeoPixel Überguide](https://learn.adafruit.com/adafruit-neopixel-uberguide/powering-neopixels) — power injection and protection.

---

[← Previous: Module 4](./04-liquid-measurement-and-sensor-selection.md) | [Back to front page](../README.md) | [Quick module index](./00-index.md) | [Next: Module 6 — LED Animation, Sound & Interactive Installations →](./06-led-animation-sound-and-installations.md)
