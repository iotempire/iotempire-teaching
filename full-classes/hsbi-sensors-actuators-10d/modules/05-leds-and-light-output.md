# Module 5 – LEDs & Light as Output

[← Back to Module 4](./04-distance-motion-and-environment-sensors.md) | [Quick module index](./00-index.md) | [Next: Module 6 →](./06-led-animation-sound-and-installations.md)

> Light is the actuator you will use most in this course. Today: how to drive it correctly — safely, dimmably, in color, and addressably.

**Course placement:** Day 5 — the light-output studio. You size the resistor, dim with PWM, mix color, and bring up a strip.

## 🎯 Learning Goals

This module gives you the opportunity to explore light as an actuator and achieve competency in LED current limiting, PWM and gamma, RGB mixing, addressable WS2812 strips, and power budgeting.

By the end of this module, you can:
1. Explain LED physics and dimension a current-limiting resistor correctly.
2. Use PWM to dim an LED and explain duty cycle, frequency, and gamma.
3. Mix colors on an RGB LED and describe additive mixing.
4. Bring up an addressable WS2812 (NeoPixel) strip and explain how the data reaches every pixel.
5. Compute and measure the power budget of a strip and explain why it cannot be powered from a GPIO pin.


**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 📖 Story — The Wall That Browned Out

**Lumenwerk Gütersloh GmbH** is building a light wall for the Stadtmuseum's new exhibition. Curator **Aylin Demir** wants a warm, continuous glow that follows visitors along a 5-metre corridor. The prototype is beautiful for ten minutes — then the strip dims, the controller resets, and one section turns an unhealthy shade of pink.

Technician **Jonas Feld** has made the classic mistake: he powered a 30-LED strip from the microcontroller's 5 V pin and treated “brightness” as a single number. Aylin's question is practical: *"How much current does this wall actually need, and how do we drive it so it survives an opening night?"* Today: LED physics, current limiting, PWM and gamma, RGB mixing, addressable strips, and a power budget you measure.

## 📖 Pod Study: Light as an Actuator

This is **self/pod study, not a lecture.** Work through the concepts below with your Task Pod, look things up, ask an LLM, and keep notes — the goal is a shared mental model you can explain in the checkpoint.

### LED Physics and Current Limiting

A light-emitting diode is a diode: it conducts in one direction above its forward voltage `Vf`, and its brightness is roughly proportional to current, not voltage. `Vf` depends on color (red ≈ 1.9 V, green/blue/white ≈ 3.0–3.4 V).

You must limit the current with a series resistor:

```text
R = (Vs − Vf) / I

Example: 3.3 V supply, white LED (Vf ≈ 3.2 V), target I = 10 mA
R = (3.3 − 3.2) / 0.010 = 10 Ω   →  choose the next higher standard value
```

Practical ESP32/ESP8266 limits and rules:

- Keep each GPIO well below its absolute maximum (ESP32 sources only ~12 mA comfortably; never drive a load from a pin).
- A GPIO drives one indicator LED; for several or for high brightness, use a transistor/MOSFET or a dedicated LED driver.
- Never connect an LED across a pin and ground without a resistor "just to test" — that is how diodes (and pins) die.

### PWM: Dimming Without Losing Light

Pulse-width modulation switches the output on and off fast. The duty cycle is the fraction of time it is on; the average current (and perceived brightness) follows it.

- Frequency: too low (< 100 Hz) causes visible flicker; LEDs are usually driven at 1–20 kHz. (Servos need ~50 Hz — a reminder that "PWM" means different things in different contexts.)
- Resolution: the duty cycle steps define dimming resolution. On the ESP32, the LEDC peripheral provides many independent PWM channels; on the ESP8266, `analogWrite` gives 10-bit resolution.
- Gamma: human brightness perception is non-linear, so a linear duty ramp looks like it "jumps" at the bright end. Applying a gamma correction (roughly `out ≈ in^2.2`, or a lookup table) makes fades look smooth.

> [!NOTE]
> PWM APIs differ across Arduino cores and versions. The exact calls (`ledcSetup`/`ledcAttachPin` vs. `ledcAttach`, `analogWriteRange`, etc.) change between ESP32 core versions — check the documentation for *your* installed core rather than copying an old tutorial.

### RGB LEDs

An RGB LED is three diodes (red, green, blue) in one package. Set each channel with its own PWM duty, and the eye mixes additive colors: red + green = yellow, all three = white. Common-anode and common-cathode variants swap the polarity — check your part.

### Addressable LEDs (WS2812 / NeoPixel)

An addressable strip has a driver chip inside every LED. A single data line carries a stream of 24-bit color values; each pixel takes the first value it "sees", then regenerates the rest down the line. That is why one pin can control hundreds of independently colored LEDs.

Requirements and traps:

- Data level: WS2812 expects ~5 V logic. A 3.3 V ESP32 usually works with a short strip, but a level shifter (or powering the strip from a level close to 3.3 V with a suitable type) makes it reliable. A ~300–500 Ω resistor in the data line and a large capacitor (~1000 µF) across the strip's 5 V/GND reduce glitches.
- Power: each LED can draw up to ~60 mA at full white. A 30-LED strip can need ~1.8 A. The microcontroller's 5 V pin cannot provide this — use a separate 5 V supply with a common ground.
- Power injection: long strips drop voltage along the copper; inject 5 V at both ends (and sometimes the middle).
- Frame timing: WS2812 is timing-sensitive; interrupts or Wi-Fi activity can occasionally glitch a frame.

Use **Adafruit NeoPixel** for the first bring-up: it is simple and well documented. Use **NeoPixelBus** when you need a more robust driver for larger strips, multiple strips, or concurrent Wi-Fi/MQTT. **FastLED** remains a useful reference — especially for palettes and HSV — but it is not our default.

> [!WARNING]
> **Library choice matters on ESP32.** With Wi-Fi/MQTT running, prefer **NeoPixelBus** for addressable strips; FastLED can suffer interrupt-related instability in that combination. Adafruit NeoPixel is fine for small, simple strips. If you use FastLED, treat it as a reference and test it under your actual network load.

### Pointers (start here, then keep looking)

- LED basics and resistors — [Wikipedia: Light-emitting diode](https://en.wikipedia.org/wiki/Light-emitting_diode), [LED circuit](https://en.wikipedia.org/wiki/LED_circuit)
- PWM and gamma — [Wikipedia: Pulse-width modulation](https://en.wikipedia.org/wiki/Pulse-width_modulation), [Gamma correction](https://en.wikipedia.org/wiki/Gamma_correction)
- Addressable LEDs — the [WS2812B datasheet](https://cdn-shop.adafruit.com/datasheets/WS2812B.pdf), [Adafruit NeoPixel](https://github.com/adafruit/Adafruit_NeoPixel), and [NeoPixelBus](https://github.com/Makuna/NeoPixelBus)
- Patterns and palettes reference — [FastLED](https://fastled.io/)
- Power budgets — the [Adafruit NeoPixel Überguide](https://learn.adafruit.com/adafruit-neopixel-uberguide/powering-neopixels)
- The [resource bank](./Z-resources-bank.md#formulas-you-will-use) has the formulas and the common-address table.

### Questions to ask an LLM (then verify against your hardware)

Ask your co-pilot — but treat every answer as a **claim to test**, not a fact. Good starting prompts:

- "I have a 3.3 V supply and a white LED with Vf ≈ 3.2 V. Compute a resistor for 10 mA and explain why the result is so sensitive to Vf."
- "Explain PWM duty cycle, frequency, and resolution. Why does a linear duty ramp look like it jumps at the bright end, and what does gamma correction change?"
- "A 30-LED WS2812 strip draws up to 60 mA per LED at full white. Compute the supply current and explain why the MCU's 5 V pin cannot provide it."
- "What do the data-line resistor, the decoupling capacitor, and a level shifter each protect against in a WS2812 installation?"
- "Compare a common-anode and a common-cathode RGB LED. How does the wiring and the PWM polarity change?"

> Run each prompt against your own circuit, and record where the model is wrong, vague, or over-confident.

### ★ Task A: Study in your pod

Work through the concepts above with your Task Pod and fill in `Module05/study-log.md`:

1. **The references you used** — the source and the one concept you understood best from it.
2. **Things you googled** — the term, what you found, and the source (URL). One line each.
3. **Remarkable things** — surprises, "aha"s, and counterexamples from your own measurements.
4. **LLM Q&A** — for each prompt: the prompt, a 2–3 line summary, and **how you verified it** (and where it was wrong).
5. **Your two best found LED/power diagrams** — compile down to the best two, with source and what they taught you.

*Portfolio evidence:* `Module05/study-log.md`.

### ★ Task B: Explain & share with another pod

Pair with a **neighbouring pod**:

1. **Explain to each other** — each pod walks the other through its resistor calculation, power budget, and strip wiring; ask questions and fill each other's gaps.
2. Agree on the **3–5 most noteworthy points** and the **learning you jointly stand behind** (e.g. *"a GPIO commands; it does not power"*).
3. **Clean up your documentation** — update your `study-log.md` with what you learned from the other pod.
4. Agree on **one shared artefact** — the best power-budget table, a wiring photo, or a new diagram the two pods make together — and **post it in the course Discord**, with a one-sentence note on why you chose it.
5. Each member adds a short **“Agreed learning (pod discussion)”** section to *their own* `study-log.md`.

*Portfolio evidence:* your cleaned-up `study-log.md` (with the **“Agreed learning (pod discussion)”** section) and your pod-pair's shared artefact.

## 🛠️ In-Class Lab: Drive the Light — **Challenging**

*Hardware:* breadboard, 2 LEDs + resistors, RGB LED, WS2812 strip, separate 5 V supply, USB power meter, multimeter.

> [!WARNING]
> Power off before rewiring. For the strip: connect 5 V, GND, and data correctly, share ground with the MCU, and add the decoupling capacitor before powering on. Wrong polarity kills the strip instantly.

### ★ Task 1: Size and Verify a Resistor

1. Pick an LED and compute the resistor for a target current (e.g. 10 mA) at 3.3 V. Install the next higher standard value.
2. Power it and measure the actual forward voltage and current with a multimeter.
3. Compute the real current from the measured values and compare with your target. Explain any difference.

### ★ Task 2: PWM Fade with Gamma

1. Fade the LED up and down using PWM.
2. First with a linear duty ramp, then with a gamma-corrected ramp. Watch both closely: which looks smooth, and which appears to "jump" near the top?
3. Note your PWM frequency and resolution, and confirm there is no visible flicker.

### ★ Task 3: RGB Mixing

1. Drive the red, green, and blue channels of the RGB LED with independent PWM values.
2. Produce at least six colors (red, green, blue, yellow, cyan, magenta) and "white" by balancing the channels.
3. Compare the mixed result with a color wheel/picker. Note how accurate "white" is with three channels.

### ★ Task 4: Addressable Strip First Light

1. Wire the WS2812 strip: 5 V and GND from the separate supply, data through the ~330 Ω resistor to a GPIO, and a common ground between MCU and supply.
2. With **Adafruit NeoPixel** (or **NeoPixelBus** for a more robust driver), light a single pixel, then a color wipe, then a rainbow.
3. Change the number of LEDs and the brightness and observe the effects. Note the first-pixel (start-of-strip) orientation.

### ★ Task 5: Power Budget — Compute and Measure

1. Compute the worst case: `N LEDs × 60 mA` at full white. Choose a power supply that can actually deliver it.
2. Measure the real current with the USB power meter for: all-off, one LED at medium, all LEDs full white.
3. Compare measurement with your calculation and explain the difference (color/white composition, brightness setting, per-LED variation).
4. State clearly why the microcontroller's 5 V pin is not an option here.

### ◇ Task 6 (Stretcher): Signal Integrity and Reliability

Deliberately introduce problems and record the symptoms: remove the data-line resistor, remove the decoupling capacitor, use a long/unshielded data wire, drive a longer strip from one injection point only. Document which glitches appear and which fix restores reliable operation.

## ✅ Suggested portfolio evidence (proofs of the learning goals)

1. Resistor calculation and measurement: predicted vs. measured forward voltage and current.
2. PWM notes: your frequency, resolution, and a short statement of why gamma correction matters.
3. RGB evidence: photo/notes of the six colors and how well "white" worked.
4. Strip artifacts: a short video or photos of the color wipe and rainbow, plus your wiring.
5. Power budget table: calculated vs. measured current in the three states, and the supply you selected.
6. Deeper question: Why does an addressable strip need a power budget *and* a level-shifter/data consideration, while a single indicator LED needs neither?


> [!IMPORTANT]
> Never commit secrets, credentials, or personal data. Where you did not work entirely alone, link your pod mates and sources.

## 📚 If you want to go deeper

- [Wikipedia: Light-emitting diode](https://en.wikipedia.org/wiki/Light-emitting_diode) and [LED circuit](https://en.wikipedia.org/wiki/LED_circuit) — forward voltage, current, and resistor sizing.
- [Pulse-width modulation](https://en.wikipedia.org/wiki/Pulse-width_modulation) and [Gamma correction](https://en.wikipedia.org/wiki/Gamma_correction) — why a linear ramp looks wrong.
- [WS2812B datasheet](https://cdn-shop.adafruit.com/datasheets/WS2812B.pdf) — timing, current, and data levels.
- [Adafruit NeoPixel](https://github.com/adafruit/Adafruit_NeoPixel) — simple API for the first strip bring-up.
- [NeoPixelBus](https://github.com/Makuna/NeoPixelBus) — robust ESP32 driver, multiple strips, and color helpers.
- [FastLED](https://fastled.io/) — reference for patterns, palettes, and HSV; compare if curious.
- [Adafruit NeoPixel Überguide](https://learn.adafruit.com/adafruit-neopixel-uberguide/powering-neopixels) — power injection and protection.

---

[← Previous: Module 4](./04-distance-motion-and-environment-sensors.md) | [Back to front page](../README.md) | [Quick module index](./00-index.md) | [Next: Module 6 — LED Animation, Sound & Interactive Installations →](./06-led-animation-sound-and-installations.md)
