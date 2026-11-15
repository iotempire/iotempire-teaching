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

**Session 1 — guided tutorial: one LED, then RGB.**

- **Stage 1a:** one red or yellow LED on GPIO 16, a 220 Ω resistor, and a PWM fade. No AI, no project scaffold — just first light.
- **Theory slides:** forward voltage and voltage capping, resistor computation, PWM, and gamma — now explaining what you just saw.
- **Stage 1b:** the RGB LED, `R G B` over serial, and the three channel currents.
- Commit Stage 1 to the portfolio repo.

**Session 2 — two project folders.**

- **Stage 2:** create `stage2-strip/`, paste the Stage 2 prompt, wire the 8-LED strip, and deploy. The theory slides cover the WS2812B signal, DMA/RMT, and the power budget while the agent scaffolds.
- **Stage 3:** create `stage3-project/`, paste the Stage 3 prompt (the placeholder), and build one or two extensions.
- Commit both projects and share the repo.

The theory slides are [`slides/05-leds.md`](../slides/05-leds.md). They are the theory interlude — the instructor may also leave them up while the AI scaffolds or a build runs. The module body carries no timings; the run sheet is in the instructor notes.

## 🔌 Stage 1 — guided tutorial: one LED, then RGB

### Stage 1a — one LED, one PWM

**Hardware.** A red or yellow 5 mm LED: anode (long leg) → **220 Ω** → **GPIO 16**; cathode (short leg, flat side) → **GND**. Do not use blue or green here — their forward voltage is close to 3.3 V, so 220 Ω leaves almost no current and the LED looks broken.

**Arduino IDE.** Select the board (`ESP32 Dev Module`, or the profile your instructor names for the MiniKit) and the port. Save it as `stage1-led/stage1-led.ino`, paste the code, and upload it. It fades the LED up and down; no library is needed.

```cpp
// Stage 1a — one LED, PWM fade on GPIO 16
// PlatformIO: uncomment the next line. Arduino IDE includes it automatically.
// #include <Arduino.h>

const int LED_PIN = 16; // for the lazy ones, you can also use 2 for the inverted blue onboard led.

void setup() {
  Serial.begin(115200);
  Serial.print("Stage 1: PWM fade on GPIO ");
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

**PlatformIO.** Create `stage1-led/`, open it, and run `pio project init --board mhetesp32minikit`. Then put the same code in `src/main.cpp` with this `platformio.ini`:

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

**Done when:** the LED fades smoothly from off to full and back, and you can say what duty cycle means. This stage is deliberately manual: first light, no scaffold.

### Stage 1b — discrete RGB LED

**Hardware.** Common-cathode RGB LED through **three 220 Ω resistors**: red → GPIO 16, green → GPIO 17, blue → GPIO 18, common cathode → GND. The code has a `#define COMMON_ANODE false` toggle; if your part is common anode, connect the common pin to 3.3 V (or 5 V) and set the toggle to `true` — the PWM values invert.

**Firmware.** At **115200 baud**, read space- or comma-separated `R G B` values in `0–255`, clamp them, apply them with `analogWrite()`, echo the applied tuple, and reject malformed input. The reference sketch is in [Appendix A](#appendix-a); Stage 1 is manual, so use it directly.

> `analogWrite()` on the ESP32 works through the LEDC peripheral in the current Arduino-ESP32 core. If you are on an older core, use `ledcAttach()`/`ledcWrite()` instead; check your core version before copying an old tutorial.

**Measure as you go.** Put the meter in series with each channel (or measure the voltage across the resistor and use `I = U/R`). Red will draw much more than blue at the same resistor value, because the forward voltages differ. That imbalance is the lesson, not a fault.

**Why 220 Ω is the default.** It is a safe, conservative value: red draws about 6 mA on 3.3 V, green less, blue much less; everything lights, and nothing is near the GPIO limit. You only need the precise calculation when you want a target current, a balanced white, or when a low-`Vf` LED with a small resistor would exceed the pin's comfort range. The full arithmetic is in [Appendix C](#appendix-c).

**Done when:** the LED shows the colors you type, and you can state the measured current for red, green, and blue.

## 🧰 Setup — the CLI, the folder, the prompt

Stage 1 is manual. **Stage 2 and Stage 3 each get their own folder** — `stage2-strip/` and `stage3-project/` — so both projects go into your portfolio separately. A project is just a folder: create it with `mkdir`, your file manager, or your editor, open it, and let the agent scaffold it.

1. **Install the CLI once** (skip if `pio --version` already works):

   ```sh
   uv tool install --with pip platformio
   uv tool update-shell          # restart the shell
   pio --version                 # an existing pio on PATH is also fine
   ```

   No `uv`? [Install it first](./Z-resources-bank.md#python-environment-with-uv); an existing `pio` on `PATH` is also fine.

2. **Create the folder** and open it in Zed or VS Code. For Stage 2: `mkdir stage2-strip`. Do not reuse the Stage 1 folder.
3. **Paste the stage prompt** into your AI agent. It initializes PlatformIO, writes `platformio.ini`, the editor configs, `AGENTS.md`, and `src/main.cpp`, and runs `pio run -t compiledb && pio run`.
4. **Wire, deploy, measure.** `pio run -t upload`, then `pio device monitor` (or the editor task).
5. **Repeat** with a new `stage3-project` folder and the Stage 3 prompt.

No serial port? Linux needs your user in `dialout` (or `uucp`) and the PlatformIO udev rules; Windows and macOS need the CP210x or CH340 driver. The table is in the [resource bank](./Z-resources-bank.md#platformio-cli--zedvscode-setup). The `AGENTS.md` template is in [Appendix F](#agentsmd); the editor snippets are in the [resource bank](./Z-resources-bank.md#platformio-cli--zedvscode-setup).

<a id="stage-2-prompt"></a>
### Stage 2 prompt — 8× WS2812B strip project

<details>
<summary>Copy this prompt into your AI agent</summary>

```text
Initialize a PlatformIO Arduino project in this empty folder for `board = mhetesp32minikit` (using `pio` on PATH, or installing it via `uv tool install --with pip platformio`). Configure `platformio.ini` with `monitor_speed = 115200`, `monitor_echo = yes`, and `monitor_filters = send_on_enter`.

Create a short `AGENTS.md` documenting the board (`mhetesp32minikit`), wiring (discrete RGB LED via 220 Ω resistors on GPIO 16=R, 17=G, 18=B), and to run `pio run -t compiledb` after dependency changes.

In `src/main.cpp`, drive the RGB LED with `analogWrite()` (include a `COMMON_ANODE` flag, default `false`). Read `R G B` integers (0–255) over Serial, clamp and apply them, echo back the values, and print an error on invalid input. Verify with `pio run -t compiledb && pio run`.
```

</details>

<a id="stage-3-prompt"></a>
### Stage 3 prompt — extension project

<details>
<summary>Replace this placeholder with the final Stage 3 prompt</summary>

```text
Initialize a PlatformIO Arduino project in this empty folder for `board = mhetesp32minikit` (using `pio` on PATH, or installing it via `uv tool install --with pip platformio`). Configure `platformio.ini` with `lib_deps = makuna/NeoPixelBus`, `monitor_speed = 115200`, `monitor_echo = yes`, and `monitor_filters = send_on_enter`.

Create a short `AGENTS.md` documenting:
- Board: `mhetesp32minikit` (ESP32)
- Wiring: 8-LED WS2812B strip powered from 5V USB and GND, data on GPIO 16
- Library: Always use `NeoPixelBus` (`NeoPixelBusLg`) for hardware DMA/RMT output—never `FastLED`
- Power limit: Keep `SetLuminance(80)` or lower so 8 LEDs stay within the 500 mA USB budget

In `src/main.cpp`, use `NeoPixelBusLg<NeoGrbFeature, NeoWs2812xMethod>` with `SetLuminance(80)` to control the 8 LEDs over Serial: accept `index R G B` (`index` 0–7, `R/G/B` 0–255) and `clear`, validate bounds, echo updates, and verify with `pio run -t compiledb && pio run`.
```

</details>

## 🌈 Stage 2 — 8× WS2812B strip

**Project.** Create `stage2-strip/`, open it, and paste the Stage 2 prompt above. The agent generates the project and firmware; the reference sketch is in [Appendix B](#appendix-b) if you prefer to read or rebuild it by hand.

**Hardware.** An 8-LED WS2812B strip powered from the MiniKit's **5 V (VCC)** and **GND**, data to **GPIO 16 (DIN)**, over USB. Prefer a USB 3.0 or USB-C port; a USB 2.0 port is the tight case. Stage 2 **reuses GPIO 16**: unplug the Stage 1b red channel first. A ~330 Ω series resistor in the data line is cheap insurance on a short strip; it is optional here (see [Appendix C](#appendix-c)).

**Library.** Use **NeoPixelBus** with `NeoPixelBusLg<NeoGrbFeature, NeoEsp32I2s1Ws2812xMethod>`. On the ESP32, Wi-Fi and BLE generate high-priority radio interrupts; a software-timed or naive bit-banged strip can glitch. NeoPixelBus offloads the 800 kHz NRZ waveform to the hardware I²S1 DMA/RMT path, so the frame survives the radio. **Do not default to FastLED** on this board — encode that rule in `AGENTS.md`.

**Power.** Each LED can draw up to ~60 mA at full white: 8 × 60 mA = **480 mA**. A USB 2.0 port supplies 500 mA; USB 3 supplies 900 mA; a USB-C port on a modern laptop or a USB charger usually supplies 1.5–3 A (check the port or charger). The ESP32 itself draws 100–250 mA with Wi-Fi. So 8 LEDs plus the ESP32 fit comfortably on USB 3.0/USB-C. On a 500 mA USB 2.0 port the strip alone is already at 480 mA and the ESP32 pushes it over — keep that as the constraint: use a 1 A+ port, a USB 3.0/USB-C port, or a separate supply with a common ground. `strip.SetLuminance(80)` is the guardrail: it caps the brightness and keeps the real animation well below the full-white bound.

**Firmware.** At **115200 baud**, parse `index R G B` with `index` in `0..7` and `R/G/B` in `0..255`, plus `clear` (`strip.ClearTo(RgbColor(0))`). Validate the index and the color values, and echo the applied update. The reference sketch is in [Appendix B](#appendix-b).

**Done when:** you can light any single pixel by index, clear the strip, and state the supply current for 8, 30, and 60 LEDs.

## 🚀 Stage 3 — extension project

**Project.** Create `stage3-project/`, open it, and paste the Stage 3 prompt above . The strip is the starting point; build one or two of the extensions below.

Pick one or two; each is a small, AI-assisted iteration on the working strip.

1. **Non-blocking animations.** Add `all R G B` and `rainbow` modes with `HslColor` sweeps and `millis()` timing (or `NeoPixelAnimator`) without blocking serial input.
2. **Perceptual linearity.** Compare linear NeoPixelBus output with `NeoPixelBusLg`'s gamma-corrected luminance curve (`NeoGammaTableMethod`). At which step size does the eye stop seeing a difference?
3. **Sensor-to-actuator bridge.** Connect an analog sensor on **GPIO 34 (ADC1)** from an earlier module and map its calibrated reading to the active pixel index, an `HslColor` hue, or `SetLuminance()`.

## 🔗 Share it (AI-first)

The challenge is not finished on your laptop. Your `Module05/` folder in the portfolio repo holds `stage1-led/`, `stage2-strip/`, and `stage3-project/`, plus the README, `AGENTS.md`, photo/video, and power table.

1. **Open the portfolio repo** in Zed or VS Code. The Source Control panel (or `gh`) commits and pushes; the [Git primer](./Z-resources-bank.md#git--github-primer-template-editor-markdown-conflicts) has the workflow.
2. **Let an AI draft the README.** Give it the wiring, the REPL commands, and the power table; ask for a short README with a wiring table, the library, how to run the REPL, and the measured currents.
3. **Verify before you commit.** Check the pin, the LED count, the color order (GRB), the library, the baud rate, and the measured current. The AI's arithmetic is a claim, not a measurement.
4. **Let an AI draft one extension** (Stage 3). Run it, keep what works, and note what you changed.
5. **Commit and share.** Commit code, README, `AGENTS.md`, and the power table; copy the repo link into the Discord and your study log. No secrets, no `.pio/`, no `compile_commands.json`, no binaries.

The AI is the drafting tool; verification is the skill. If you want a standalone repo instead of the portfolio folder, `gh repo create stage2-strip --public --source=. --push` works.

> **AI assistant and GitHub Education.** Use whatever you already have — Claude, DeepSeek, ChatGPT, Copilot — in Zed or VS Code. If you want Copilot with education credits, apply at [education.github.com](https://education.github.com/); it is optional. The course template is [iot-portfolio-template](https://github.com/iotempire/iot-portfolio-template).

> **Credits.** Copilot Education gives unlimited inline completions but limited chat/agent credits; other plans have their own limits. Use a lightweight model for the scaffold and save the heavy model for the one hard bug.

## ★ Task A: Log the stages

Write under `## Study log` in `Module05/README.md` — a section, not a file. One pod member keeps the shared log; the others link to it and add one sentence.

1. Stage 1a: the fade and a one-sentence explanation of duty cycle.
2. Stage 1b: the measured red/green/blue currents, and whether your part is common cathode or anode.
3. Stage 2: the `index R G B`/`clear` demo, your luminance setting, and the measured current.
4. The power table: measured vs. computed for 8, 30, 60, and 144 LEDs.
5. One AI claim you verified against the datasheet or the meter — and where the agent was wrong.

*Portfolio evidence:* the `## Study log` section.

## ★ Task B: Exchange with a neighbouring pod

Pair with a neighbouring pod:

1. Show each other the Stage 1a fade, the Stage 1b/2 builds, and the power table.
2. Compare your AI prompts: what did the agents get wrong, and what did you have to fix?
3. Agree on the 3–5 most noteworthy points and one learning you jointly stand behind.
4. Agree on one shared artefact — the best animation clip, power table, or wiring photo — and post it in the course Discord with one sentence on why.
5. Add the “Agreed learning (pod discussion)” note to the shared log.

## ✅ Suggested portfolio evidence (proofs of the learning goals)

1. Stage 1a demo: the fade and a one-sentence duty-cycle explanation.
2. Stage 1b demo: the serial `R G B` interaction and the measured channel currents.
3. Stage 2 demo: repo link with the code, README, and `AGENTS.md`, plus a video or photos of `index R G B` and `clear`.
4. Power table: measured vs. computed for 8, 30, 60, and 144 LEDs, and the supply decision.
5. AI verification note: what the agent drafted, what you checked, and what was wrong.
6. One Stage 3 extension, or a design rationale for the animation you chose.
7. Deeper question: Why does an addressable strip need a power budget *and* a data-level consideration, while a single indicator LED needs neither?

> You may prove the same goals another way. The evidence is the point, not the task list.

<a id="appendix-a"></a>
## 📎 Appendix A — Stage 1b reference sketch (RGB LED)

Common-cathode by default; set `COMMON_ANODE` to `true` if your part is common anode. The serial parser accepts `255 0 0`, `255,0,0`, and rejects trailing junk.

```cpp
// Stage 1b — discrete RGB LED, common cathode by default.
// PlatformIO: uncomment the next line. Arduino IDE includes it automatically.
// #include <Arduino.h>

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
## 📎 Appendix B — Stage 2 reference sketch (WS2812B)

8 LEDs on GPIO 16, `SetLuminance(80)`, `index R G B` and `clear`. The color order is GRB; change the feature if your strip differs.

```cpp
// PlatformIO: uncomment the next line. Arduino IDE includes it automatically.
// #include <Arduino.h>
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
## 📎 Appendix D — Doing it by example, without AI

You do not have to use an AI. The scaffold is a convenience; the same project can be built by hand. This is the classic route — and the reference for what the agent was supposed to do.

**Classic examples to start from**

- **One LED / PWM:** the Arduino [Fade example](https://docs.arduino.cc/built-in-examples/basics/Fade/) (`File → Examples → 01.Basics → Fade`) uses `analogWrite`. On ESP32 core 3.x it works as written; on older cores use the [ESP32 `AnalogOut` LEDC examples](https://github.com/espressif/arduino-esp32/tree/master/libraries/ESP32/examples), and mind the `ledcSetup`/`ledcAttach` API change.
- **RGB LED:** there is no single stock example; wire three PWM channels and apply the `Fade` logic per channel. The [Stage 1b sketch](#appendix-a) is the reference.
- **NeoPixelBus:** the library ships [examples](https://github.com/Makuna/NeoPixelBus/tree/master/examples). After `pio project init` and `lib_deps = makuna/NeoPixelBus`, they are under `.pio/libdeps/mhetesp32minikit/NeoPixelBus/examples/`. Start with `NeoPixelTest`, then adapt to `NeoPixelBusLg` with `NeoEsp32I2s1Ws2812xMethod`.
- **Adafruit NeoPixel:** [`strandtest` and `simple`](https://github.com/adafruit/Adafruit_NeoPixel/tree/master/examples) are the classic first-strip examples; use them to compare, not as the course default.
- **FastLED:** [`blink` and `DemoReel100`](https://github.com/FastLED/FastLED/tree/master/examples) are the classic patterns; reference only on this board.

**What the agent would do — do it yourself**

1. Install the CLI: `uv tool install --with pip platformio && uv tool update-shell`; check `pio --version`.
2. `pio project init --board mhetesp32minikit`.
3. Write `platformio.ini` (board, framework, `monitor_speed`, `lib_deps` for the strip).
4. Add `.gitignore` (`.pio/`, `compile_commands.json`).
5. Write `src/main.cpp` from the [Stage 1b](#appendix-a) or [Stage 2](#appendix-b) sketch, starting with `#include <Arduino.h>`; keep the pinout and power rules in the [AGENTS.md template](#agentsmd).
6. `pio run`, `pio run -t upload`, `pio device monitor`.
7. Commit code, README, and measurements to `Module05/`.

The editor extras (Zed tasks, clangd, VS Code settings) are optional for the build; copy them from the [resource bank](./Z-resources-bank.md#platformio-cli--zedvscode-setup) if you want them.

**Why this path exists.** The AI is a drafting tool, not a requirement. The evidence is the working hardware and the measurements. If you build it by hand, document the same things: the pinout, the library, the current, and what failed.

<a id="appendix-e"></a>
## 📎 Appendix E — Pointers and LLM prompts

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

<a id="agentsmd"></a>
## 📎 Appendix F — `AGENTS.md` template

One `AGENTS.md` at the project root, **not** a separate `CLAUDE.md`, so Copilot and Claude agents load the same rules. A working template:

```md
# AGENTS.md — LED lab

- Board: MH-ET LIVE ESP32 MiniKit (`mhetesp32minikit`), PlatformIO CLI (`pio`).
- Stage 1a: single red/yellow LED, 220 Ω, GPIO 16 (PWM fade).
- Stage 1b: common-cathode RGB LED, 220 Ω per channel, R=GPIO16, G=GPIO17, B=GPIO18.
- Stage 2: 8× WS2812B, DIN=GPIO16, 5 V from the MiniKit USB rail, common ground.
- Library: `makuna/NeoPixelBus`, `NeoPixelBusLg<NeoGrbFeature, NeoEsp32I2s1Ws2812xMethod>`.
  Do not default to FastLED.
- `strip.SetLuminance(80)`. 8 LEDs × 60 mA = 480 mA; stay inside the USB budget.
- Serial: 115200. Stage 1b: `R G B`; Stage 2: `index R G B` and `clear`.
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
