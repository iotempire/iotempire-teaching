# Module 5 – LEDs & Light as Output

[← Back to Module 4](./04-distance-motion-and-environment-sensors.md) | [Quick module index](./00-index.md) | [Next: Module 6 →](./06-led-animation-sound-and-installations.md)

> Light is the actuator you will use most in this course. Today: how to drive it correctly — safely, dimmably, in color, and addressably.

## 🎯 Learning Goals

> **How these are assessed:** You earn this module's points by proving these goals in a short (~10-minute) checkpoint presentation with the instructor (see the [syllabus](../syllabus.md#how-module-points-are-earned-checkpoint-presentations)) — based on your portfolio and reflections, not on completing every task. You may skip tasks, fail at some, or add your own; documented exploration and demonstrated deep understanding both count in your favor.

This module gives you the opportunity to explore light as an actuator and achieve competency in LED current limiting, PWM and gamma, RGB mixing, addressable WS2812 strips, and power budgeting.

By the end of this module, you can:
1. Explain LED physics and dimension a current-limiting resistor correctly.
2. Use PWM to dim an LED and explain duty cycle, frequency, and gamma.
3. Mix colors on an RGB LED and describe additive mixing.
4. Bring up an addressable WS2812 (NeoPixel) strip and explain how the data reaches every pixel.
5. Compute and measure the power budget of a strip and explain why it cannot be powered from a GPIO pin.

> [!WARNING]
> DRAFT — first taught in WS 2026/27. Everything below this line is a working draft and will likely change as we refine it together in class; the line moves down as we approve content. Your input is welcome and can shape this module.

**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 📖 Part A — LED Physics and Current Limiting

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

## 📖 Part B — PWM: Dimming Without Losing Light

Pulse-width modulation switches the output on and off fast. The duty cycle is the fraction of time it is on; the average current (and perceived brightness) follows it.

- Frequency: too low (< 100 Hz) causes visible flicker; LEDs are usually driven at 1–20 kHz. (Servos need ~50 Hz — a reminder that "PWM" means different things in different contexts.)
- Resolution: the duty cycle steps define dimming resolution. On the ESP32, the LEDC peripheral provides many independent PWM channels; on the ESP8266, `analogWrite` gives 10-bit resolution.
- Gamma: human brightness perception is non-linear, so a linear duty ramp looks like it "jumps" at the bright end. Applying a gamma correction (roughly `out ≈ in^2.2`, or a lookup table) makes fades look smooth.

> [!NOTE]
> PWM APIs differ across Arduino cores and versions. The exact calls (`ledcSetup`/`ledcAttachPin` vs. `ledcAttach`, `analogWriteRange`, etc.) change between ESP32 core versions — check the documentation for *your* installed core rather than copying an old tutorial.

## 📖 Part C — RGB LEDs

An RGB LED is three diodes (red, green, blue) in one package. Set each channel with its own PWM duty, and the eye mixes additive colors: red + green = yellow, all three = white. Common-anode and common-cathode variants swap the polarity — check your part.

## 📖 Part D — Addressable LEDs (WS2812 / NeoPixel)

An addressable strip has a driver chip inside every LED. A single data line carries a stream of 24-bit color values; each pixel takes the first value it "sees", then regenerates the rest down the line. That is why one pin can control hundreds of independently colored LEDs.

Requirements and traps:

- Data level: WS2812 expects ~5 V logic. A 3.3 V ESP32 usually works with a short strip, but a level shifter (or powering the strip from a level close to 3.3 V with a suitable type) makes it reliable. A ~300–500 Ω resistor in the data line and a large capacitor (~1000 µF) across the strip's 5 V/GND reduce glitches.
- Power: each LED can draw up to ~60 mA at full white. A 30-LED strip can need ~1.8 A. The microcontroller's 5 V pin cannot provide this — use a separate 5 V supply with a common ground.
- Power injection: long strips drop voltage along the copper; inject 5 V at both ends (and sometimes the middle).
- Frame timing: WS2812 is timing-sensitive; interrupts or Wi-Fi activity can occasionally glitch a frame.

FastLED is a convenient, well-documented library for driving these strips (and plain RGB/PWM too).

## 🛠️ In-Class Lab: Drive the Light

*Hardware:* breadboard, 2 LEDs + resistors, RGB LED, WS2812 strip, separate 5 V supply, USB power meter, multimeter.

> [!WARNING]
> Power off before rewiring. For the strip: connect 5 V, GND, and data correctly, share ground with the MCU, and add the decoupling capacitor before powering on. Wrong polarity kills the strip instantly.

### ★ Task 1: Size and Verify a Resistor (25 min)

1. Pick an LED and compute the resistor for a target current (e.g. 10 mA) at 3.3 V. Install the next higher standard value.
2. Power it and measure the actual forward voltage and current with a multimeter.
3. Compute the real current from the measured values and compare with your target. Explain any difference.

### ★ Task 2: PWM Fade with Gamma (30 min)

1. Fade the LED up and down using PWM.
2. First with a linear duty ramp, then with a gamma-corrected ramp. Watch both closely: which looks smooth, and which appears to "jump" near the top?
3. Note your PWM frequency and resolution, and confirm there is no visible flicker.

### ★ Task 3: RGB Mixing (25 min)

1. Drive the red, green, and blue channels of the RGB LED with independent PWM values.
2. Produce at least six colors (red, green, blue, yellow, cyan, magenta) and "white" by balancing the channels.
3. Compare the mixed result with a color wheel/picker. Note how accurate "white" is with three channels.

### ★ Task 4: Addressable Strip First Light (35 min)

1. Wire the WS2812 strip: 5 V and GND from the separate supply, data through the ~330 Ω resistor to a GPIO, and a common ground between MCU and supply.
2. With FastLED, light a single pixel, then a color wipe, then a rainbow.
3. Change the number of LEDs and the brightness and observe the effects. Note the first-pixel (start-of-strip) orientation.

### ★ Task 5: Power Budget — Compute and Measure (30 min)

1. Compute the worst case: `N LEDs × 60 mA` at full white. Choose a power supply that can actually deliver it.
2. Measure the real current with the USB power meter for: all-off, one LED at medium, all LEDs full white.
3. Compare measurement with your calculation and explain the difference (color/white composition, brightness setting, per-LED variation).
4. State clearly why the microcontroller's 5 V pin is not an option here.

### ◇ Task 6 (Stretcher): Signal Integrity and Reliability (25 min)

Deliberately introduce problems and record the symptoms: remove the data-line resistor, remove the decoupling capacitor, use a long/unshielded data wire, drive a longer strip from one injection point only. Document which glitches appear and which fix restores reliable operation.

## 📝 Working-Day Reflection & Portfolio Tasks

In your portfolio under `modules/05-leds/`:
1. Resistor calculation and measurement: predicted vs. measured forward voltage and current.
2. PWM notes: your frequency, resolution, and a short statement of why gamma correction matters.
3. RGB evidence: photo/notes of the six colors and how well "white" worked.
4. Strip artifacts: a short video or photos of the color wipe and rainbow, plus your wiring.
5. Power budget table: calculated vs. measured current in the three states, and the supply you selected.
6. Reflection: Why does an addressable strip need a power budget *and* a level-shifter/data consideration, while a single indicator LED needs neither?
