# Module 5 – LEDs & Light as Output

[← Back to Module 4](./04-liquid-measurement-and-sensor-selection.md) | [Quick module index](./00-index.md) | [Next: Module 6 →](./06-led-animation-sound-and-installations.md)

> Light is the actuator you will use most in this course. Today: how to drive it correctly — safely, dimmably, in color, and addressably.

**Course placement:** Day 5 — the light-output session. It starts as a guided walkthrough (the instructor drives, you follow along on your laptop), then the strip is yours.

## 🎯 Learning Goals

This module gives you the opportunity to explore light as an actuator and achieve competency in LED current limiting, PWM and gamma, RGB mixing, addressable WS2812 strips, and power budgeting.

By the end of this module, you can:
1. Explain LED physics and dimension a current-limiting resistor correctly.
2. Use PWM to dim an LED and explain duty cycle, frequency, and gamma.
3. Mix colors on an RGB LED and describe additive mixing.
4. Address individual pixels on a WS2812 strip and explain how the data reaches every pixel.
5. Compute and measure a strip's power budget, and decide what a USB supply can and cannot power.

**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 📖 Story — The Wall That Browned Out

**Lumenwerk Gütersloh GmbH** is building a light wall for the Stadtmuseum's new exhibition. Curator **Aylin Demir** wants a warm, continuous glow that follows visitors along a 5-metre corridor. The prototype is beautiful for ten minutes — then the strip dims, the controller resets, and one section turns an unhealthy shade of pink.

Technician **Jonas Feld** has made the classic mistake: he powered a 30-LED strip from the microcontroller's 5 V pin and treated “brightness” as a single number. Aylin's question is practical: *"How much current does this wall actually need, and how do we drive it so it survives an opening night?"* Today: LED physics, current limiting, PWM and gamma, RGB mixing, addressable strips, and a power budget you measure.

## 🎬 How today runs

Today is a **guided session with a challenge at the end**: we build together first, then you take over.

1. **Ramp-up.** Open the prepared sketch in the Arduino IDE (or the PlatformIO project if you already use it), select the board and port, upload, and open the Serial Monitor. By the end of this step, your board is flashed and the monitor answers commands.
2. **Follow along.** The instructor builds the RGB example, then the 8-LED strip, one step at a time. You follow the same steps. Stop and ask at any point; we go at the speed of the room.
3. **Your challenge.** The strip and a power budget are yours. You choose the animation, the colors, and the method. The hints are in the appendix — use them when you are stuck, not before. You make it shareable: AI drafts the README or an animation variant, you verify it on the strip and commit.

The guided part is deliberately step-by-step so that nobody loses the session to a toolchain fight. The challenge is deliberately open: there is no required sequence, only evidence. **Where this goes next:** Module 6 scales the animation (palettes, sound, installations, LED panels); Module 7 applies the same driver and power thinking to motors.

## 🧭 Ramp-up: from the sketch to a flashing board

**You need:** the ESP32 Ethernet mini kit, a USB cable, and the prepared `led_lab` sketch folder (your instructor shares it). The common path is the **Arduino IDE 2**, because most of you already have it from Module 1. If you already use PlatformIO, the same sketch builds there — the optional path is in Appendix A.

1. Open `led_lab.ino` in the Arduino IDE.
2. Select the board: **Tools → Board → esp32 → ESP32 Dev Module** (or the profile your instructor names for the mini kit).
3. Select the port: **Tools → Port**. On Windows, install the CP210x/CH340 driver if no port appears.
4. Install the library once: **Library Manager → “Adafruit NeoPixel” → Install**.
5. Upload with the arrow button, then open the **Serial Monitor** at **115200 baud**.

- Close the Serial Monitor before uploading if the port is busy.
- The sketch prints the command help when it starts. Nothing else is needed.

**If you already use PlatformIO/VS Code:** open the same folder as a PlatformIO project and run `pio run -t upload`, then `pio device monitor`. The `platformio.ini` and the file layout are in Appendix A.

**Done when:** the monitor prints the command help.

## 🧭 Follow along 1: one RGB LED

1. **Start with 220 Ω on each channel.** It is the safe practitioner default: a red LED (`Vf ≈ 1.9 V`) on 3.3 V draws about 6 mA; green and blue draw less because their `Vf` is higher. Everything lights, and nothing is near the GPIO limit. If your RGB LED is common-anode on 5 V, the same 220 Ω gives 8–14 mA per channel.
2. **Measure the three currents.** Put the meter in series with each channel (or measure the voltage across the resistor and use `I = U/R`). Red will be much higher than blue. That is the lesson: one resistor value does not give equal currents, because `Vf` depends on color.
3. **Compute only if you need a target.** `R = (Vs − Vf) / I`. The result is very sensitive to `Vf` near the 3.3 V rail: a 33 Ω resistor on a red LED would draw ~42 mA, over the comfortable GPIO current. That is why 220 Ω is the safe default.
4. **Wire one channel first.** RGB LED with a series resistor per channel; common cathode to GND, or common anode to the 5 V rail — check your part.
5. **PWM.** Attach three PWM channels and sweep the duty from 0 to 255. Note the frequency and resolution of your core's API, and confirm there is no visible flicker.
6. **Mix.** Produce red, green, blue, yellow, cyan, magenta, and white. Compare with a color picker; note how good “white” is.
7. **Gamma.** Fade linearly, then with `out = 255 · (in/255)^2.2`. Which looks smooth, and which steps at the bright end?

**Done when:** the LED shows six recognizable colors and a fade without a visible step near the top.

> PWM calls differ between ESP32 core versions (`ledcSetup`/`ledcAttachPin` vs. `ledcAttach`). Check the docs for your installed core; do not copy an old tutorial.

## 🧭 Follow along 2: the 8-LED strip

1. **Wire it.** 5 V and GND from the board's 5 V pin (USB) or a separate USB supply, data through the ~330 Ω resistor to the GPIO, and a common ground. Never power the strip from a GPIO or the 3.3 V pin. No bulk capacitor is required today; the optional parts are in the [resource bank](./Z-resources-bank.md#ws2812-resistor-bulk-capacitor-level-shifter).
2. **Light one pixel by index.** In the monitor: `3 255 0 0` lights pixel 3 red; `5 0 0 255` lights pixel 5 blue; `all 0 0 0` clears.
3. **Walk the pixel.** `walk 1` moves one lit pixel down the strip. That is addressing: the sketch writes a color per index, and the strip shifts the values down the line.
4. **Compute the budget.** 8 LEDs × 60 mA = **480 mA** at full white. USB 2.0 gives 500 mA, USB 3 gives 900 mA, and a USB charger often 1.5–3 A. The ESP32 itself draws 100–250 mA with Wi-Fi. So 8 LEDs fit a 1 A port together with the ESP32. On a 500 mA port the strip alone is already at 480 mA, and the ESP32 pushes it over — use a 1 A+ port, a powered hub, or a separate supply. Set `b 255`, measure the worst case with the USB power meter, then return to a comfortable brightness.
5. **Scale it.** 30 LEDs → 1.8 A; 60 → 3.6 A; 144 → 8.6 A. The data line still works at those counts; the power does not. That is the wall in the story.

**Done when:** you can light any single pixel by index, run a walk, and state the supply current for 8, 30, and 60 LEDs.

> **Why 8 LEDs?** Eight is the largest count that stays inside a standard USB port's budget for the strip alone (9 × 60 mA = 540 mA). The arithmetic is the point: the LED count is a power decision, not a data decision.

## 🎯 Your challenge

**The strip is yours.** Make the 8 pixels do something you would show someone — a mood, a small animation, a reaction, a tiny game. Then prove it scales.

The method is yours. These are the evidence requirements, not steps:

- **Address pixels individually.** At least one effect uses the index, not just “all red”.
- **Design the animation yourself.** Changing the palette, timing, or logic of a library demo is design; running the demo unchanged is not.
- **Make the fade look right** with gamma or a brightness cap, and keep the current sane.
- **Measure and compute the power** for your animation, then for 30, 60, and 144 LEDs. State which supply you would use and why.
- **One paragraph of rationale:** what it is, why these colors and timing, and what you would change at 144 LEDs.

Tools: Adafruit NeoPixel, NeoPixelBus, or FastLED. Input: serial REPL, a button, or a sensor from Module 4. If you finish early, add a second effect and a mode switch, or make the animation react to a distance sensor.

Three example projects, if you want one:
- **Mood lamp:** slow color drift, one hue at a time.
- **Pixel runner:** a comet with a fading tail, speed controlled by serial.
- **Wave:** a distance sensor from Module 4 pushes a light band along the strip.

## 🔗 Share it (AI-first)

The challenge is not finished on your laptop. Your `Module05/` folder in the portfolio repo is the shareable project: code, README, photo/video, power table. Build in the Arduino IDE; do the repo and AI work in VS Code or Zed.

1. **Open the portfolio repo** in VS Code or Zed. The Source Control panel (or `gh`) commits and pushes; the [Git primer](./Z-resources-bank.md#git--github-primer-template-editor-markdown-conflicts) has the workflow.
2. **Let an AI draft the README.** Give it the wiring, the REPL commands, and the power table; ask for a short README with a wiring table, the library, how to run the REPL, and the measured currents.
3. **Verify before you commit.** Check the pin, the LED count, the color order (GRB), the library, the baud rate, and the measured current. The AI's arithmetic is a claim, not a measurement.
4. **Let an AI draft one animation variant.** Ask for a different palette or timing, run it, keep what works, and note what you changed.
5. **Commit and share.** Commit code, README, and the power table; copy the repo link into the Discord and your study log. No secrets, no build output, no binaries.

The AI is the drafting tool; verification is the skill. If you want a standalone repo instead of the portfolio folder, `gh repo create led-lab --public --source=. --push` works.

> **GitHub Education.** If you want Copilot or the Student Developer Pack, apply at [education.github.com](https://education.github.com/); it is optional for this session. The course template is [iot-portfolio-template](https://github.com/iotempire/iot-portfolio-template).

## ★ Task A: Log your challenge

Write under `## Study log` in `Module05/README.md` — a section, not a file. One pod member keeps the shared log; the others link to it and add one sentence.

1. What you built, with the repo link and a photo or short video.
2. The power table: measured vs. computed for 8, 30, 60, and 144 LEDs.
3. Two things that failed and what fixed them.
4. One claim you verified against the datasheet or the meter — and where an LLM was wrong.

*Portfolio evidence:* the `## Study log` section.

## ★ Task B: Exchange with a neighbouring pod

Pair with a neighbouring pod:

1. Show each other the animation and the power table.
2. Agree on the 3–5 most noteworthy points and one learning you jointly stand behind.
3. Agree on one shared artefact — the best animation clip, power table, or wiring photo — and post it in the course Discord with one sentence on why.
4. Add the “Agreed learning (pod discussion)” note to the shared log.

## ✅ Suggested portfolio evidence (proofs of the learning goals)

1. Working demo: repo link with the code and README, plus a video or photos of the animation.
2. Wiring photo and the resistor calculation (predicted vs. measured current).
3. Power table: measured vs. computed for 8, 30, 60, and 144 LEDs, and the supply decision.
4. Design rationale paragraph.
5. Deeper question: Why does an addressable strip need a power budget *and* a data-level consideration, while a single indicator LED needs neither?

> You may prove the same goals another way. The evidence is the point, not the task list.

## 📎 Appendix A — Reference sketch: Arduino IDE and PlatformIO

The follow-along uses this sketch. It is also your fallback if you fall behind.

**Arduino IDE:** save it as `led_lab/led_lab.ino` (the folder and file name must match). The sketch uses 8 LEDs on GPIO 18 — change both numbers to match your wiring. The code is the same:

```cpp
#include <Adafruit_NeoPixel.h>

Adafruit_NeoPixel strip(8, 18, NEO_GRB + NEO_KHZ800);  // 8 LEDs, data on GPIO 18

void help() {
  Serial.println("<i> <r> <g> <b> | all <r> <g> <b> | walk <n> | b <0-255> | off");
}

void setup() {
  Serial.begin(115200);
  strip.begin();
  strip.setBrightness(64);      // start well below full current
  strip.show();
  help();
}

void loop() {
  if (!Serial.available()) return;
  String cmd = Serial.readStringUntil('\n');
  cmd.trim();

  if (cmd == "help") { help(); return; }
  if (cmd == "off") { strip.clear(); strip.show(); return; }

  if (cmd.startsWith("b ")) {
    strip.setBrightness(constrain(cmd.substring(2).toInt(), 0, 255));
    strip.show();
    return;
  }
  if (cmd.startsWith("all ")) {
    int r, g, b;
    if (sscanf(cmd.c_str(), "all %d %d %d", &r, &g, &b) == 3) {
      for (int i = 0; i < strip.numPixels(); i++)
        strip.setPixelColor(i, strip.Color(r, g, b));
      strip.show();
    }
    return;
  }
  if (cmd.startsWith("walk ")) {
    int n = cmd.substring(5).toInt();
    for (int k = 0; k < n; k++)
      for (int i = 0; i < strip.numPixels(); i++) {
        strip.clear();
        strip.setPixelColor(i, strip.Color(255, 120, 0));
        strip.show();
        delay(80);              // a demo; Module 6 does this non-blocking
      }
    return;
  }

  int i, r, g, b;
  if (sscanf(cmd.c_str(), "%d %d %d %d", &i, &r, &g, &b) == 4) {
    strip.setPixelColor(i, strip.Color(r, g, b));
    strip.show();
    return;
  }
  Serial.println("?");
}
```

**PlatformIO/VS Code (optional):** put the same code in `src/main.cpp` and add this `platformio.ini`:

```ini
[env:esp32dev]
platform = espressif32
board = esp32dev
framework = arduino
monitor_speed = 115200
lib_deps = adafruit/Adafruit NeoPixel
```

Commands: `<index> <r> <g> <b>` (for example `3 255 0 0`), `all <r> <g> <b>`, `walk <n>`, `b <0-255>`, `off`, `help`.

## 📎 Appendix B — The background you need

**LED physics.** A diode conducts above its forward voltage `Vf`, and brightness follows current, not voltage. `Vf` depends on color (red ≈ 1.9 V, green/blue/white ≈ 3.0–3.4 V). Limit the current with `R = (Vs − Vf) / I`, and choose the next higher standard value. A **220 Ω** resistor on each channel is a safe default for a 3.3 V GPIO; compute only when you need a target current. ESP32 GPIOs source ~12 mA comfortably; use one indicator LED per pin, and a transistor/MOSFET or driver for more. Never connect an LED across a pin without a resistor.

**PWM and gamma.** Duty cycle is the on-fraction; average current and brightness follow it. Below ~100 Hz you see flicker; LEDs usually run at 1–20 kHz. A linear duty ramp looks like it jumps at the bright end; apply gamma (`out ≈ in^2.2`) or a lookup table. PWM calls differ by core — check yours.

**RGB.** Three diodes in one package; set each channel with its own PWM duty. Additive mixing: red + green = yellow, all three = white. Common-anode and common-cathode parts swap polarity.

**Addressable WS2812.** A driver chip in every LED; one data line carries 24-bit values, and each pixel takes the first value it sees and regenerates the rest. Data level: the input needs ~0.7 × VDD (≈3.5 V), so a 3.3 V pin is out of spec — a short strip often works, a level shifter is the reliable fix. Power: up to ~60 mA per LED at full white; the MCU's 5 V pin cannot supply a strip. The data resistor, bulk capacitor, and level shifter are three different jobs — see the [resource bank](./Z-resources-bank.md#ws2812-resistor-bulk-capacitor-level-shifter).

**Libraries.** Adafruit NeoPixel for the first bring-up; NeoPixelBus for robust or multi-strip work with Wi-Fi; FastLED as a reference for palettes and HSV. With Wi-Fi/MQTT running, prefer NeoPixelBus.

## 📎 Appendix C — Failure modes and fixes

| Symptom | Likely cause | Fix |
|---|---|---|
| No light at all | polarity, missing resistor, wrong pin, no common ground | check the LED polarity and the pin; measure `Vf` |
| Only the first pixel lights | data direction (DIN/DOUT), wrong index, wrong LED count | check the strip orientation and `numPixels` |
| Wrong colors | color order (RGB vs. GRB) | change `NEO_GRB`/`NEO_RGB` |
| Flicker or random resets | data level, long wires, supply droop, Wi-Fi interrupts | 330 Ω data resistor, level shifter, shorter wires, separate supply, NeoPixelBus |
| Strip browns out at high brightness | current budget, weak USB port | lower brightness, 1 A+ supply, measure with the USB meter |
| Upload fails or the port is busy | monitor holds the port, wrong board | close the monitor, `pio device list`, check `board` |

More in the [resource bank's troubleshooting table](./Z-resources-bank.md#troubleshooting-quick-drops).

> **Bulk capacitor.** Optional today. If you add one: 10–16 V rating, correct polarity, power off while wiring. A reverse-connected electrolytic can explode. Decoupling (0.1 µF at an IC) is a different job.

## 📎 Appendix D — Pointers and LLM prompts

**Pointers**

- LED basics and resistors — [Wikipedia: Light-emitting diode](https://en.wikipedia.org/wiki/Light-emitting_diode), [LED circuit](https://en.wikipedia.org/wiki/LED_circuit)
- PWM and gamma — [Wikipedia: Pulse-width modulation](https://en.wikipedia.org/wiki/Pulse-width_modulation), [Gamma correction](https://en.wikipedia.org/wiki/Gamma_correction)
- Addressable LEDs — the [WS2812B datasheet](https://cdn-shop.adafruit.com/datasheets/WS2812B.pdf), [Adafruit NeoPixel](https://github.com/adafruit/Adafruit_NeoPixel), and [NeoPixelBus](https://github.com/Makuna/NeoPixelBus)
- Patterns and palettes reference — [FastLED](https://fastled.io/)
- Power budgets — the [Adafruit NeoPixel Überguide](https://learn.adafruit.com/adafruit-neopixel-uberguide/powering-neopixels)
- The [resource bank](./Z-resources-bank.md#formulas-you-will-use) has the formulas and the common-address table.

**Questions to ask an LLM (then verify against your hardware)**

Ask your co-pilot — but treat every answer as a **claim to test**, not a fact. Good starting prompts:

- "I have a 3.3 V supply and a white LED with Vf ≈ 3.2 V. Compute a resistor for 10 mA and explain why the result is so sensitive to Vf."
- "Explain PWM duty cycle, frequency, and resolution. Why does a linear duty ramp look like it jumps at the bright end, and what does gamma correction change?"
- "A 30-LED WS2812 strip draws up to 60 mA per LED at full white. Compute the supply current and explain why the MCU's 5 V pin cannot provide it."
- "What do the data-line resistor, a bulk capacitor across the supply, and a level shifter each protect against in a WS2812 installation — and under what conditions are they unnecessary?"
- "Compare a common-anode and a common-cathode RGB LED. How does the wiring and the PWM polarity change?"
- "Scaffold an Arduino/PlatformIO project for an ESP32 with 8 WS2812 LEDs on GPIO 18 and a serial REPL with `<index> <r> <g> <b>`, `all`, `walk`, `b`, and `off`. Include `platformio.ini`, the sketch, and a README with wiring, the library, and a power table. I will verify the pin, LED count, color order, and current on my strip."

> A good answer distinguishes **bulk** capacitance (supply transients) from **decoupling** (high-frequency noise at an IC) and says when each is optional.

> Run each prompt against your own circuit, and record where the model is wrong, vague, or over-confident.

## 📚 If you want to go deeper

- [Wikipedia: Light-emitting diode](https://en.wikipedia.org/wiki/Light-emitting_diode) and [LED circuit](https://en.wikipedia.org/wiki/LED_circuit) — forward voltage, current, and resistor sizing.
- [Pulse-width modulation](https://en.wikipedia.org/wiki/Pulse-width_modulation) and [Gamma correction](https://en.wikipedia.org/wiki/Gamma_correction) — why a linear ramp looks wrong.
- [WS2812B datasheet](https://cdn-shop.adafruit.com/datasheets/WS2812B.pdf) — timing, current, and data levels.
- [Adafruit NeoPixel](https://github.com/adafruit/Adafruit_NeoPixel) — simple API for the first strip bring-up.
- [NeoPixelBus](https://github.com/Makuna/NeoPixelBus) — robust ESP32 driver, multiple strips, and color helpers.
- [FastLED](https://fastled.io/) — reference for patterns, palettes, and HSV; compare if curious.
- [Adafruit NeoPixel Überguide](https://learn.adafruit.com/adafruit-neopixel-uberguide/powering-neopixels) — power injection and protection.

---

[← Previous: Module 4](./04-liquid-measurement-and-sensor-selection.md) | [Back to front page](../README.md) | [Quick module index](./00-index.md) | [Next: Module 6 — LED Animation, Sound & Interactive Installations →](./06-led-animation-sound-and-installations.md)
