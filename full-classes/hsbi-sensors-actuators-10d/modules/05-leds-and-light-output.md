# Module 5 – LEDs & Light as Output

[← Back to Module 4](./04-liquid-measurement-and-sensor-selection.md) | [Quick module index](./00-index.md) | [Next: Module 6 →](./06-led-animation-sound-and-installations.md)

> Light is the actuator you will use most in this course. Today: how to drive it correctly — safely, dimmably, in color, and addressably.

**Course placement:** Day 5 — two 90-minute sessions. Session 1 is the toolchain, the theory interlude, and the discrete RGB LED. Session 2 is the 8-LED WS2812B strip and the extensions. The instructor drives the setup; after that it is hands-on.

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

## 🗓️ How the two sessions run

**Session 1 — setup and the discrete LED.**

- The instructor starts the **AI scaffold** in an empty folder. The agent creates the PlatformIO project, the editor tasks, `AGENTS.md`, and the first sketch.
- While the agent works, the **theory slides** run: forward voltage and voltage capping, resistor computation, PWM, and gamma.
- **Stage A:** wire the RGB LED, talk to it over the serial REPL, and measure the three channel currents.
- Commit Stage A to the portfolio repo.

**Session 2 — the addressable strip.**

- **Rewire:** remove the Stage A red channel; GPIO 16 becomes the strip data line.
- **Theory slides:** the WS2812B single-wire signal, hardware DMA/RMT, and the power budget.
- **Stage B:** the 8-LED strip, `index R G B` and `clear`, `SetLuminance(80)`, and a measured current budget.
- **Stage C:** one or two extensions, then commit and share.

The theory slides are [`slides/05-leds.md`](../slides/05-leds.md). They are the “while the AI is working” material — you can read them afterwards as well. The module body carries no timings; the run sheet is in the instructor notes.

## 🧰 Setup — one project, two editors

The project is plain PlatformIO, so **Zed** (the instructor's demo) and **VS Code** (optional for you) open the same folder. The full setup — editor tasks, clangd flags, serial-port fixes — is in the [resource bank](./Z-resources-bank.md#platformio-cli--zedvscode-setup).

No `uv` yet? Install it first; the [one-liner for macOS, Linux, and Windows](./Z-resources-bank.md#python-environment-with-uv) is in the resource bank.

```sh
uv tool install --with pip platformio
uv tool update-shell          # restart the shell
pio --version                 # an existing pio on PATH is also fine

mkdir led-lab && cd led-lab
pio project init --board mhetesp32minikit
```

`platformio.ini`:

```ini
[env:mhetesp32minikit]
platform = espressif32
board = mhetesp32minikit
framework = arduino
monitor_speed = 115200
monitor_echo = yes
monitor_filters = send_on_enter
lib_deps = makuna/NeoPixelBus
```

No serial port? Linux needs your user in `dialout` (or `uucp`) and the PlatformIO udev rules; Windows and macOS need the CP210x or CH340 driver. The table is in the [resource bank](./Z-resources-bank.md#platformio-cli--zedvscode-setup).

**Or let the AI scaffold it.** The [starter prompt](./Z-resources-bank.md#platformio-cli--zedvscode-setup) checks `pio`, initializes the board, generates `.zed/`, `.vscode/`, `.clangd`, `.gitignore`, and `AGENTS.md`, writes `src/main.cpp`, and verifies with `pio run -t compiledb && pio run`. Read the prompt before you run it; edit the pinout if your wiring differs.

<a id="agentsmd"></a>
### `AGENTS.md` — the project's AI guardrails

One `AGENTS.md` at the project root, **not** a separate `CLAUDE.md`, so Copilot and Claude agents load the same rules. A working template:

```md
# AGENTS.md — LED lab

- Board: MH-ET LIVE ESP32 MiniKit (`mhetesp32minikit`), PlatformIO CLI (`pio`).
- Stage A: common-cathode RGB LED, 220 Ω per channel, R=GPIO16, G=GPIO17, B=GPIO18.
- Stage B: 8× WS2812B, DIN=GPIO16, 5 V from the MiniKit USB rail, common ground.
- Library: `makuna/NeoPixelBus`, `NeoPixelBusLg<NeoGrbFeature, NeoEsp32I2s1Ws2812xMethod>`.
  Do not default to FastLED.
- `strip.SetLuminance(80)`. 8 LEDs × 60 mA = 480 mA; stay inside the USB budget.
- Serial: 115200. Stage A: `R G B`; Stage B: `index R G B` and `clear`.
  Echo applied values; validate input and index bounds.
- Never power the strip from a GPIO or the 3.3 V pin.
```

## 🔌 Stage A — discrete RGB LED

**Hardware.** Common-cathode RGB LED through **three 220 Ω resistors**: red → GPIO 16, green → GPIO 17, blue → GPIO 18, common cathode → GND. The code has a `#define COMMON_ANODE false` toggle; if your part is common anode, connect the common pin to 3.3 V (or 5 V) and set the toggle to `true` — the PWM values invert.

**Firmware.** At **115200 baud**, read space- or comma-separated `R G B` values in `0–255`, clamp them, apply them with `analogWrite()`, echo the applied tuple, and reject malformed input. The reference sketch is in [Appendix A](#appendix-a).

> `analogWrite()` on the ESP32 works through the LEDC peripheral in the current Arduino-ESP32 core. If you are on an older core, use `ledcAttach()`/`ledcWrite()` instead; check your core version before copying an old tutorial.

**Measure as you go.** Put the meter in series with each channel (or measure the voltage across the resistor and use `I = U/R`). Red will draw much more than blue at the same resistor value, because the forward voltages differ. That imbalance is the lesson, not a fault.

**Why 220 Ω is the default.** It is a safe, conservative value: red draws about 6 mA on 3.3 V, green less, blue much less; everything lights, and nothing is near the GPIO limit. You only need the precise calculation when you want a target current, a balanced white, or when a low-`Vf` LED with a small resistor would exceed the pin's comfort range. The full arithmetic is in [Appendix C](#appendix-c).

**Done when:** the LED shows the colors you type, and you can state the measured current for red, green, and blue.

## 🌈 Stage B — 8× WS2812B strip

**Hardware.** An 8-LED WS2812B strip powered from the MiniKit's **5 V (VCC)** and **GND**, data to **GPIO 16 (DIN)**, over USB. Stage B **reuses GPIO 16**: unplug the Stage A red channel first. A ~330 Ω series resistor in the data line is cheap insurance on a short strip; it is optional here (see [Appendix C](#appendix-c)).

**Library.** Use **NeoPixelBus** with `NeoPixelBusLg<NeoGrbFeature, NeoEsp32I2s1Ws2812xMethod>`. On the ESP32, Wi-Fi and BLE generate high-priority radio interrupts; a software-timed or naive bit-banged strip can glitch. NeoPixelBus offloads the 800 kHz NRZ waveform to the hardware I²S1 DMA/RMT path, so the frame survives the radio. **Do not default to FastLED** on this board — encode that rule in `AGENTS.md`.

**Power.** Each LED can draw up to ~60 mA at full white: 8 × 60 mA = **480 mA**. A USB 2.0 port supplies 500 mA, USB 3 supplies 900 mA, and a USB charger often 1.5–3 A. The ESP32 itself draws 100–250 mA with Wi-Fi. On a 500 mA port the strip alone is already at 480 mA and the ESP32 pushes it over; use a 1 A+ port or a separate supply with a common ground. `strip.SetLuminance(80)` is the guardrail: it caps the brightness and keeps the real animation well below the full-white bound.

**Firmware.** At **115200 baud**, parse `index R G B` with `index` in `0..7` and `R/G/B` in `0..255`, plus `clear` (`strip.ClearTo(RgbColor(0))`). Validate the index and the color values, and echo the applied update. The reference sketch is in [Appendix B](#appendix-b).

**Done when:** you can light any single pixel by index, clear the strip, and state the supply current for 8, 30, and 60 LEDs.

## 🚀 Stage C — live-coding extensions

Pick one or two; each is a small, AI-assisted iteration on the working strip.

1. **Non-blocking animations.** Add `all R G B` and `rainbow` modes with `HslColor` sweeps and `millis()` timing (or `NeoPixelAnimator`) without blocking serial input.
2. **Perceptual linearity.** Compare linear NeoPixelBus output with `NeoPixelBusLg`'s gamma-corrected luminance curve (`NeoGammaTableMethod`). At which step size does the eye stop seeing a difference?
3. **Sensor-to-actuator bridge.** Connect an analog sensor on **GPIO 34 (ADC1)** from an earlier module and map its calibrated reading to the active pixel index, an `HslColor` hue, or `SetLuminance()`.

## 🔗 Share it (AI-first)

The challenge is not finished on your laptop. Your `Module05/` folder in the portfolio repo is the shareable project: code, README, `AGENTS.md`, photo/video, power table.

1. **Open the portfolio repo** in Zed or VS Code. The Source Control panel (or `gh`) commits and pushes; the [Git primer](./Z-resources-bank.md#git--github-primer-template-editor-markdown-conflicts) has the workflow.
2. **Let an AI draft the README.** Give it the wiring, the REPL commands, and the power table; ask for a short README with a wiring table, the library, how to run the REPL, and the measured currents.
3. **Verify before you commit.** Check the pin, the LED count, the color order (GRB), the library, the baud rate, and the measured current. The AI's arithmetic is a claim, not a measurement.
4. **Let an AI draft one extension** (Stage C). Run it, keep what works, and note what you changed.
5. **Commit and share.** Commit code, README, `AGENTS.md`, and the power table; copy the repo link into the Discord and your study log. No secrets, no `.pio/`, no `compile_commands.json`, no binaries.

The AI is the drafting tool; verification is the skill. If you want a standalone repo instead of the portfolio folder, `gh repo create led-lab --public --source=. --push` works.

> **AI assistant and GitHub Education.** Use whatever you already have — Claude, DeepSeek, ChatGPT, Copilot — in Zed or VS Code. If you want Copilot with education credits, apply at [education.github.com](https://education.github.com/); it is optional. The course template is [iot-portfolio-template](https://github.com/iotempire/iot-portfolio-template).

> **Credits.** Copilot Education gives unlimited inline completions but limited chat/agent credits; other plans have their own limits. Use a lightweight model for the scaffold and save the heavy model for the one hard bug.

## ★ Task A: Log the two stages

Write under `## Study log` in `Module05/README.md` — a section, not a file. One pod member keeps the shared log; the others link to it and add one sentence.

1. Stage A: what you built, the measured red/green/blue currents, and whether your part is common cathode or anode.
2. Stage B: the `index R G B`/`clear` demo, your luminance setting, and the measured current.
3. The power table: measured vs. computed for 8, 30, 60, and 144 LEDs.
4. One AI claim you verified against the datasheet or the meter — and where the agent was wrong.

*Portfolio evidence:* the `## Study log` section.

## ★ Task B: Exchange with a neighbouring pod

Pair with a neighbouring pod:

1. Show each other Stage A and Stage B, and the power table.
2. Compare your AI prompts: what did the agents get wrong, and what did you have to fix?
3. Agree on the 3–5 most noteworthy points and one learning you jointly stand behind.
4. Agree on one shared artefact — the best animation clip, power table, or wiring photo — and post it in the course Discord with one sentence on why.
5. Add the “Agreed learning (pod discussion)” note to the shared log.

## ✅ Suggested portfolio evidence (proofs of the learning goals)

1. Stage A demo: the serial `R G B` interaction and the measured channel currents.
2. Stage B demo: repo link with the code, README, and `AGENTS.md`, plus a video or photos of `index R G B` and `clear`.
3. Power table: measured vs. computed for 8, 30, 60, and 144 LEDs, and the supply decision.
4. AI verification note: what the agent drafted, what you checked, and what was wrong.
5. One Stage C extension, or a design rationale for the animation you chose.
6. Deeper question: Why does an addressable strip need a power budget *and* a data-level consideration, while a single indicator LED needs neither?

> You may prove the same goals another way. The evidence is the point, not the task list.

<a id="appendix-a"></a>
## 📎 Appendix A — Stage A reference sketch

Common-cathode by default; set `COMMON_ANODE` to `true` if your part is common anode. The serial parser accepts `255 0 0`, `255,0,0`, and rejects trailing junk.

```cpp
// Stage A — discrete RGB LED, common cathode by default.
#define COMMON_ANODE false

const int R_PIN = 16;
const int G_PIN = 17;
const int B_PIN = 18;

int clamp8(int v) { return v < 0 ? 0 : (v > 255 ? 255 : v); }

void apply(int r, int g, int b) {
  r = clamp8(r); g = clamp8(g); b = clamp8(b);
  int lr = r, lg = g, lb = b;              // echo the logical values
  if (COMMON_ANODE) { r = 255 - r; g = 255 - g; b = 255 - b; }
  analogWrite(R_PIN, r);
  analogWrite(G_PIN, g);
  analogWrite(B_PIN, b);
  Serial.printf("RGB(%d,%d,%d)\n", lr, lg, lb);
}

void setup() {
  Serial.begin(115200);
  Serial.println("RGB: <r> <g> <b> (0-255), space or comma separated");
}

void loop() {
  if (!Serial.available()) return;
  String line = Serial.readStringUntil('\n');
  line.trim();

  int r, g, b; char extra;
  int n = sscanf(line.c_str(), "%d,%d,%d%c", &r, &g, &b, &extra);
  if (n != 3) n = sscanf(line.c_str(), "%d %d %d%c", &r, &g, &b, &extra);

  if (n == 3) apply(r, g, b);
  else Serial.println("? RGB: <r> <g> <b> (0-255)");
}
```

<a id="appendix-b"></a>
## 📎 Appendix B — Stage B reference sketch

8 LEDs on GPIO 16, `SetLuminance(80)`, `index R G B` and `clear`. The color order is GRB; change the feature if your strip differs.

```cpp
#include <NeoPixelBus.h>

const uint16_t LED_COUNT = 8;
const uint16_t DATA_PIN = 16;

NeoPixelBusLg<NeoGrbFeature, NeoEsp32I2s1Ws2812xMethod> strip(LED_COUNT, DATA_PIN);

int clamp8(int v) { return v < 0 ? 0 : (v > 255 ? 255 : v); }

void setup() {
  Serial.begin(115200);
  strip.Begin();
  strip.SetLuminance(80);          // power guardrail, not full white
  strip.ClearTo(RgbColor(0));
  strip.Show();
  Serial.println("pixel: <index 0-7> <r> <g> <b> | clear");
}

void loop() {
  if (!Serial.available()) return;
  String line = Serial.readStringUntil('\n');
  line.trim();

  if (line == "clear") {
    strip.ClearTo(RgbColor(0));
    strip.Show();
    Serial.println("cleared");
    return;
  }

  int i, r, g, b; char extra;
  if (sscanf(line.c_str(), "%d %d %d %d%c", &i, &r, &g, &b, &extra) == 4
      && i >= 0 && i < LED_COUNT) {
    r = clamp8(r); g = clamp8(g); b = clamp8(b);
    strip.SetPixelColor(i, RgbColor(r, g, b));
    strip.Show();
    Serial.printf("pixel %d = RGB(%d,%d,%d)\n", i, r, g, b);
  } else {
    Serial.println("? pixel: <index 0-7> <r> <g> <b> | clear");
  }
}
```

<a id="appendix-c"></a>
## 📎 Appendix C — Background and failure modes

**Forward voltage and voltage capping.** An LED is a diode: above its forward voltage `Vf` it conducts, and brightness follows current, not voltage. `Vf` depends on color (red ≈ 1.9 V, green ≈ 2.1 V, blue/white ≈ 3.0–3.4 V). The LED effectively caps the voltage across itself at `Vf`; the series resistor takes the difference `Vs − Vf`. On a 3.3 V pin, a blue LED with `Vf ≈ 3.2 V` leaves only 0.1 V across the resistor — tiny changes in `Vf` change the current enormously. That is why the same 220 Ω gives a bright red and a dim blue.

**Resistor computation.** `R = (Vs − Vf) / I`. For a target current, compute and choose the next higher standard value. Examples: red at 6 mA on 3.3 V needs `(3.3 − 1.9)/0.006 ≈ 233 Ω` → 240 Ω; 220 Ω is the safe default. A 33 Ω resistor on red would draw `(3.3 − 1.9)/33 ≈ 42 mA`, over the GPIO comfort range. Resistor power: `P = I² · R`; at 42 mA and 33 Ω that is ~58 mW, so a ¼ W part is fine, but the pin is not.

**PWM and gamma.** Duty cycle is the on-fraction; average current and brightness follow it. Below ~100 Hz you see flicker; LEDs usually run at 1–20 kHz. A linear duty ramp looks like it jumps at the bright end; apply gamma (`out ≈ in^2.2`) or a lookup table. `analogWrite()` uses the LEDC peripheral on the ESP32; older cores need `ledcAttach()`/`ledcWrite()`.

**RGB.** Three diodes in one package; set each channel with its own PWM duty. Additive mixing: red + green = yellow, all three = white. Common-anode and common-cathode parts swap polarity; the code's `COMMON_ANODE` toggle handles the inversion.

**WS2812B.** A driver chip in every LED; one data line carries 24-bit values (GRB), and each pixel takes the first value it sees and regenerates the rest. The protocol is 800 kHz NRZ with a reset/latch gap; timing is tight. On the ESP32, Wi-Fi/BLE interrupts can corrupt software-timed output, which is why NeoPixelBus uses the hardware I²S1 DMA/RMT path. The data line is not the power line: 8 LEDs at full white are 480 mA, 30 are 1.8 A, 144 are 8.6 A.

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

<a id="appendix-d"></a>
## 📎 Appendix D — Pointers and LLM prompts

**Pointers**

- LED basics and resistors — [Wikipedia: Light-emitting diode](https://en.wikipedia.org/wiki/Light-emitting_diode), [LED circuit](https://en.wikipedia.org/wiki/LED_circuit)
- PWM and gamma — [Wikipedia: Pulse-width modulation](https://en.wikipedia.org/wiki/Pulse-width_modulation), [Gamma correction](https://en.wikipedia.org/wiki/Gamma_correction)
- Addressable LEDs — the [WS2812B datasheet](https://cdn-shop.adafruit.com/datasheets/WS2812B.pdf), [NeoPixelBus](https://github.com/Makuna/NeoPixelBus)
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

## 📚 If you want to go deeper

- [Wikipedia: Light-emitting diode](https://en.wikipedia.org/wiki/Light-emitting_diode) and [LED circuit](https://en.wikipedia.org/wiki/LED_circuit) — forward voltage, current, and resistor sizing.
- [Pulse-width modulation](https://en.wikipedia.org/wiki/Pulse-width_modulation) and [Gamma correction](https://en.wikipedia.org/wiki/Gamma_correction) — why a linear ramp looks wrong.
- [WS2812B datasheet](https://cdn-shop.adafruit.com/datasheets/WS2812B.pdf) — timing, current, and data levels.
- [NeoPixelBus](https://github.com/Makuna/NeoPixelBus) — robust ESP32 driver, I2S/DMA methods, and color helpers.
- [FastLED](https://fastled.io/) — reference for patterns, palettes, and HSV; compare if curious.
- [Adafruit NeoPixel Überguide](https://learn.adafruit.com/adafruit-neopixel-uberguide/powering-neopixels) — power injection and protection.

---

[← Previous: Module 4](./04-liquid-measurement-and-sensor-selection.md) | [Back to front page](../README.md) | [Quick module index](./00-index.md) | [Next: Module 6 — LED Animation, Sound & Interactive Installations →](./06-led-animation-sound-and-installations.md)
