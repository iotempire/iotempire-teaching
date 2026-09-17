# Module 6 – LED Animation, Sound & Interactive Installations

[← Back to Module 5](./05-leds-and-light-output.md) | [Quick module index](./00-index.md) | [Next: Module 7 →](./07-motors-and-motion-actuators.md)

> **Today the light comes alive.** Static colors become animation, and animation becomes an interaction: the strip reacts to a hand or to music. This directly seeds the "**interactive LED installations**" and "**music-synchronized fountains**" example projects.

---

## 📌 Module Outcomes
By the end of this session, you will:
1. Structure animation as a **non-blocking, time-based state machine** (no `delay()` in the main loop).
2. Build recognizable patterns and use **palettes/HSV** and blending instead of hard-coded RGB values.
3. Fuse a **sensor input** with the animation so the installation reacts to the world.
4. Read a simple audio signal and drive LEDs from its **envelope** (and, as a stretch, a beat).
5. Reason about the practical constraints of a real installation: **power, heat, mounting, and safety**.

---

## 📖 Part A — Animation as a Time-Based State Machine

The naive way (`delay(50)` between frames) blocks everything: the node cannot read sensors, talk MQTT, or react. The professional way:

```text
loop():
  now = millis()
  read inputs (non-blocking)
  if (now - last_frame >= frame_interval) { advance_animation(); render(); last_frame = now; }
  service other tasks (MQTT, buttons, safety)
```

Key concepts:

- **Frame rate / interval:** choose it per effect (a slow breath vs. a fast chase). Keep the *render* independent of the *update* timing.
- **Fractional progress:** animate on a normalized `0..1` parameter and map to whatever you display, so an effect can be slowed, reversed, or driven by a sensor.
- **Determinism:** the same animation code should run for a strip of 8 or 300 LEDs — compute positions from an index, never hard-code pixel numbers.

## 📖 Part B — Patterns, Palettes, and Color Spaces

- **Patterns:** solid, breathing, wipe, chase/runner, rainbow, sparkle/confetti, theater-chase. A few well-parameterized patterns compose into many effects.
- **HSB/HSV** (hue, saturation, brightness) is more intuitive than RGB for animation — sweep **hue** for a rainbow, modulate **brightness** for breathing. FastLED provides HSV conversion and pre-built palettes.
- **Blending and fading:** cross-fade between patterns, or "trail" decays (`pixel = max(pixel*decay, new)`) to create motion blur.
- **Mapping:** decide how abstract time/positions map to the physical strip (left-to-right? around a ring? radial?), then keep the mapping in one place.

## 📖 Part C — Reading Sound

Two common approaches:

- **Analog microphone / sound sensor** (or an electret mic + amplifier): read the signal on an analog pin, compute a **short-term envelope** (e.g. peak or RMS over a window). Drive brightness/color from the envelope — this alone gives a convincing "music-reactive" effect.
- **MSGEQ7 / spectrum analyzer**: gives a few frequency bands (bass/mid/treble). Map bands to zones of the strip for a classic equalizer look.
- **Beat detection (stretch):** a simple approach is to track a running average of the envelope and trigger when the current value exceeds it by a factor — enough to flash on beats without a full DSP.

> **Mind the sampling rate.** The envelope is only meaningful if you sample the audio much faster than the effect updates (Nyquist, Module 1). Decouple the fast audio sampling from the slower visual frame update.

## 📖 Part D — Building an Installation

Technical success is not the same as a good installation. Plan for:

- **Power:** re-check the Module 5 budget — animations at full white draw the worst case, and long shows add heat.
- **Heat and lifetime:** a strip at full brightness in a sealed enclosure gets hot; limit brightness or add airflow.
- **Optics/mounting:** diffusers, spacing, and viewing distance change the perceived result dramatically.
- **Robustness:** strain relief on wires, a stable 5 V supply, and a plan for what happens if the sensor or the network drops.
- **Safety:** keep mains and high-voltage far away from breadboards; if an installation uses a pump, motor, or mains-driven element, keep it physically and electrically separated from the logic.

---

## 🛠️ In-Class Lab: Make It Move

*Hardware:* WS2812 strip + separate 5 V supply, ESP32/ESP8266, a distance sensor from Module 4, a simple analog sound sensor (or microphone module).

---

### ★ Task 1: A Non-Blocking Animation Engine (40 min)

1. Write a loop that renders at a fixed interval using `millis()` — **no `delay()`** in the drawing path.
2. Implement at least **two** patterns (e.g. a breathing effect and a color wipe) and switch between them without restarting the sketch.
3. While the animation runs, print a counter on the serial console every second to prove the loop is not blocked.

---

### ★ Task 2: Palettes, Hue, and Blending (30 min)

1. Re-implement one pattern using **HSV** so a single "speed/phase" parameter drives the hue.
2. Add a **palette** and a smooth cross-fade or trail decay between frames.
3. Make the frame interval and the effect speed **parameters** you can change live. Note how the same code now supports slow and fast effects.

---

### ★ Task 3: Sensor → Animation (30 min)

Fuse Module 4 with today:

1. Read the distance sensor (ToF or ultrasonic).
2. Map distance to an animation parameter — e.g. **closer = brighter/faster**, or position along the strip.
3. Implement a threshold reaction (e.g. a "wave" when someone approaches) with **hysteresis** so it does not flicker at the boundary.
4. Test by moving your hand and record the interaction.

*This is the "interactive LED installation" seed project.*

---

### ★ Task 4: Sound-Reactive LEDs (35 min)

1. Sample the audio signal **fast** in the loop and compute a short-term **envelope** (peak or RMS).
2. Map the envelope to brightness and/or hue. Confirm the strip visibly responds to speech/music.
3. Add **automatic gain control** (normalize to a recent maximum) so it works in both quiet and loud rooms. Note why this matters for a real installation.

---

### ◇ Task 5 (Stretcher): Toward the Music-Synchronized Fountain (30 min)

Combine a "water" actuator with the light show:

1. Use a **servo** or a small **pump/valve** as the water element (mock it with a servo arm or an LED if a pump is not available).
2. Drive both the strip and the actuator from the same envelope/beat signal so they move together — the announcement's "**music-synchronized fountain**" in miniature.
3. Note the **latency** between audio and visible action, and how you would reduce it.

---

## 📝 Working-Day Reflection & Portfolio Tasks

In your portfolio under `modules/06-animation/`:
1. **Animation engine:** your `millis()`-based loop structure and why it beats `delay()`.
2. **Effects:** short videos/photos of at least three effects (one HSV, one blended, one sensor-triggered).
3. **Interaction:** the mapping you chose (distance/sound → animation), plus the hysteresis you used.
4. **Sound notes:** how you computed the envelope, and what changed when you added gain control.
5. **Installation constraints:** a short paragraph on power, heat, mounting, and failure behavior for your effect.
6. **Reflection:** What is the difference between an animation that *looks* good and an installation that *survives* a two-hour show?
