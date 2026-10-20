# Module 6 – LED Animation, Sound & Interactive Installations

[← Back to Module 5](./05-leds-and-light-output.md) | [Quick module index](./00-index.md) | [Next: Module 7 →](./07-motors-and-motion-actuators.md)

> Today the light comes alive. Static colors become animation, and animation becomes an interaction: the strip reacts to a hand or to music. This directly seeds the "interactive LED installations" and "music-synchronized fountains" example projects.

**Course placement:** Day 6 — the animation and interaction studio. Static colors become motion, and motion becomes an interaction.

## 🎯 Learning Goals

This module gives you the opportunity to explore interactive and animated lighting and achieve competency in non-blocking animation, palettes and blending, and sensor- and sound-reactive installations.

By the end of this module, you can:
1. Structure animation as a non-blocking, time-based state machine (no `delay()` in the main loop).
2. Build recognizable patterns and use palettes/HSV and blending instead of hard-coded RGB values.
3. Fuse a sensor input with the animation so the installation reacts to the world.
4. Read a simple audio signal and drive LEDs from its envelope (and, as a stretch, a beat).
5. Reason about the practical constraints of a real installation: power, heat, mounting, and safety.


**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 📖 Story — The Exhibition That Had to Breathe

**Lumenwerk Gütersloh GmbH** has one week before the Stadtmuseum opening. Curator **Aylin Demir** wants the light wall to *breathe*: a slow pulse when the room is empty, a faster wave when visitors approach, and a bright ripple when the room gets loud. Creative director **Mara Voss** has the concept; technician **Jonas Feld** has a strip, a distance sensor, and a microphone.

The prototype works on the bench — until the animation freezes whenever the distance sensor updates, and the “breathing” looks like a stutter. The problem is not the LED library. It is the loop: `delay()` blocks everything. Today you build a non-blocking, time-based animation engine, map sensor and sound input onto it, and think like an installer: power, heat, mounting, and what happens when a cable fails at 19:55 on opening night.

## 📖 Pod Study: Animation as a Time-Based State Machine

This is **self/pod study, not a lecture.** Work through the concepts below with your Task Pod, look things up, ask an LLM, and keep notes — the goal is a shared mental model you can defend in the checkpoint.

### Animation as a Time-Based State Machine

The naive way (`delay(50)` between frames) blocks everything: the node cannot read sensors, talk MQTT, or react. The professional way:

```text
loop():
  now = millis()
  read inputs (non-blocking)
  if (now - last_frame >= frame_interval) { advance_animation(); render(); last_frame = now; }
  service other tasks (MQTT, buttons, safety)
```

Key concepts:

- Frame rate / interval: choose it per effect (a slow breath vs. a fast chase). Keep the *render* independent of the *update* timing.
- Fractional progress: animate on a normalized `0..1` parameter and map to whatever you display, so an effect can be slowed, reversed, or driven by a sensor.
- Determinism: the same animation code should run for a strip of 8 or 300 LEDs — compute positions from an index, never hard-code pixel numbers.

### Patterns, Palettes, and Color Spaces

- Patterns: solid, breathing, wipe, chase/runner, rainbow, sparkle/confetti, theater-chase. A few well-parameterized patterns compose into many effects.
- HSB/HSV (hue, saturation, brightness) is more intuitive than RGB for animation — sweep hue for a rainbow, modulate brightness for breathing. FastLED provides HSV conversion and pre-built palettes.
- Blending and fading: cross-fade between patterns, or "trail" decays (`pixel = max(pixel*decay, new)`) to create motion blur.
- Mapping: decide how abstract time/positions map to the physical strip (left-to-right? around a ring? radial?), then keep the mapping in one place.

### Reading Sound

Two common approaches:

- Analog microphone / sound sensor (or an electret mic + amplifier): read the signal on an analog pin, compute a short-term envelope (e.g. peak or RMS over a window). Drive brightness/color from the envelope — this alone gives a convincing "music-reactive" effect.
- MSGEQ7 / spectrum analyzer: gives a few frequency bands (bass/mid/treble). Map bands to zones of the strip for a classic equalizer look.
- Beat detection (stretch): a simple approach is to track a running average of the envelope and trigger when the current value exceeds it by a factor — enough to flash on beats without a full DSP.

> Mind the sampling rate. The envelope is only meaningful if you sample the audio much faster than the effect updates (Nyquist, Module 1). Decouple the fast audio sampling from the slower visual frame update.

### Building an Installation

Technical success is not the same as a good installation. Plan for:

- Power: re-check the Module 5 budget — animations at full white draw the worst case, and long shows add heat.
- Heat and lifetime: a strip at full brightness in a sealed enclosure gets hot; limit brightness or add airflow.
- Optics/mounting: diffusers, spacing, and viewing distance change the perceived result dramatically.
- Robustness: strain relief on wires, a stable 5 V supply, and a plan for what happens if the sensor or the network drops.
- Safety: keep mains and high-voltage far away from breadboards; if an installation uses a pump, motor, or mains-driven element, keep it physically and electrically separated from the logic.

### Pointers (start here, then keep looking)

- Non-blocking timing — [Arduino: `millis()`](https://docs.arduino.cc/language-reference/en/functions/time/millis/) and the [Blink Without Delay](https://docs.arduino.cc/built-in-examples/digital/BlinkWithoutDelay/) example
- Patterns and palettes — [FastLED documentation](https://fastled.io/), especially palettes and HSV
- Color spaces — [Wikipedia: HSL and HSV](https://en.wikipedia.org/wiki/HSL_and_HSV)
- Sound envelopes — [Wikipedia: Envelope (music)](https://en.wikipedia.org/wiki/Envelope_(music)), [Root mean square](https://en.wikipedia.org/wiki/Root_mean_square)
- Installation practice — the [Adafruit NeoPixel Überguide](https://learn.adafruit.com/adafruit-neopixel-uberguide) and the [resource bank](./Z-resources-bank.md#troubleshooting-quick-drops)

### Questions to ask an LLM (then verify against your hardware)

Ask your co-pilot — but treat every answer as a **claim to test**, not a fact. Good starting prompts:

- "Refactor a `delay()`-based LED animation into a non-blocking `millis()` loop. Show the state variables and the frame timing."
- "Explain HSV vs. RGB for animation. Give me a single-parameter hue sweep and a brightness breath in FastLED."
- "How do I compute a short-term audio envelope (peak or RMS) on an ESP32, and how do I decouple the fast audio sampling from the slower LED frame rate?"
- "My sensor-triggered animation flickers at the threshold. Explain hysteresis and show a small state machine that fixes it."
- "List the practical constraints of a two-hour LED installation: power, heat, mounting, strain relief, and failure behavior."

> Run each prompt against your own installation, and record where the model is wrong, vague, or over-confident.

### ★ Task A: Study in your pod

Work through the concepts above with your Task Pod and fill in `Module06/study-log.md`:

1. **The references you used** — the source and the one concept you understood best from it.
2. **Things you googled** — the term, what you found, and the source (URL). One line each.
3. **Remarkable things** — surprises, "aha"s, and counterexamples from your own animation tests.
4. **LLM Q&A** — for each prompt: the prompt, a 2–3 line summary, and **how you verified it** (and where it was wrong).
5. **Your two best found animation or installation examples** — compile down to the best two, with source and what they taught you.

*Portfolio evidence:* `Module06/study-log.md`.

### ★ Task B: Explain & share with another pod

Pair with a **neighbouring pod**:

1. **Explain to each other** — each pod walks the other through its animation architecture and its interaction mapping; ask questions and fill each other's gaps.
2. Agree on the **3–5 most noteworthy points** and the **learning you jointly stand behind** (e.g. *"render timing and update timing are different problems"*).
3. **Clean up your documentation** — update your `study-log.md` with what you learned from the other pod.
4. Agree on **one shared artefact** — a short video, a state-machine sketch, or a new effect the two pods make together — and **post it in the course Discord**, with a one-sentence note on why you chose it.
5. Each member adds a short **“Agreed learning (pod discussion)”** section to *their own* `study-log.md`.

*Portfolio evidence:* your cleaned-up `study-log.md` (with the **“Agreed learning (pod discussion)”** section) and your pod-pair's shared artefact.

## 🛠️ In-Class Lab: Make It Move — **Challenging**

*Hardware:* WS2812 strip + separate 5 V supply, ESP32/ESP8266, a distance sensor from Module 4, a simple analog sound sensor (or microphone module).

### ★ Task 1: A Non-Blocking Animation Engine

1. Write a loop that renders at a fixed interval using `millis()` — **no `delay()`** in the drawing path.
2. Implement at least two patterns (e.g. a breathing effect and a color wipe) and switch between them without restarting the sketch.
3. While the animation runs, print a counter on the serial console every second to prove the loop is not blocked.

### ★ Task 2: Palettes, Hue, and Blending

1. Re-implement one pattern using HSV so a single "speed/phase" parameter drives the hue.
2. Add a palette and a smooth cross-fade or trail decay between frames.
3. Make the frame interval and the effect speed parameters you can change live. Note how the same code now supports slow and fast effects.

### ★ Task 3: Sensor → Animation

Fuse Module 4 with today:

1. Read the distance sensor (ToF or ultrasonic).
2. Map distance to an animation parameter — e.g. closer = brighter/faster, or position along the strip.
3. Implement a threshold reaction (e.g. a "wave" when someone approaches) with hysteresis so it does not flicker at the boundary.
4. Test by moving your hand and record the interaction.

*This is the "interactive LED installation" seed project.*

### ★ Task 4: Sound-Reactive LEDs

1. Sample the audio signal fast in the loop and compute a short-term envelope (peak or RMS).
2. Map the envelope to brightness and/or hue. Confirm the strip visibly responds to speech/music.
3. Add automatic gain control (normalize to a recent maximum) so it works in both quiet and loud rooms. Note why this matters for a real installation.

### ◇ Task 5 (Stretcher): Toward the Music-Synchronized Fountain

Combine a "water" actuator with the light show:

1. Use a servo or a small pump/valve as the water element (mock it with a servo arm or an LED if a pump is not available).
2. Drive both the strip and the actuator from the same envelope/beat signal so they move together — the announcement's "music-synchronized fountain" in miniature.
3. Note the latency between audio and visible action, and how you would reduce it.

## ✅ Suggested portfolio evidence (proofs of the learning goals)

1. Animation engine: your `millis()`-based loop structure and why it beats `delay()`.
2. Effects: short videos/photos of at least three effects (one HSV, one blended, one sensor-triggered).
3. Interaction: the mapping you chose (distance/sound → animation), plus the hysteresis you used.
4. Sound notes: how you computed the envelope, and what changed when you added gain control.
5. Installation constraints: a short paragraph on power, heat, mounting, and failure behavior for your effect.
6. Deeper question: What is the difference between an animation that *looks* good and an installation that *survives* a two-hour show?


> [!IMPORTANT]
> Never commit secrets, credentials, or personal data. Where you did not work entirely alone, link your pod mates and sources.

## 📚 If you want to go deeper

- [Arduino: `millis()`](https://docs.arduino.cc/language-reference/en/functions/time/millis/) and [Blink Without Delay](https://docs.arduino.cc/built-in-examples/digital/BlinkWithoutDelay/) — the non-blocking pattern.
- [FastLED](https://fastled.io/) — patterns, palettes, HSV, and blending.
- [Wikipedia: HSL and HSV](https://en.wikipedia.org/wiki/HSL_and_HSV) — why hue is easier than RGB for animation.
- [Envelope (music)](https://en.wikipedia.org/wiki/Envelope_(music)) and [Root mean square](https://en.wikipedia.org/wiki/Root_mean_square) — the sound features you can compute on a microcontroller.
- [Adafruit NeoPixel Überguide](https://learn.adafruit.com/adafruit-neopixel-uberguide) — power, heat, and installation practice.

---

[← Previous: Module 5](./05-leds-and-light-output.md) | [Back to front page](../README.md) | [Quick module index](./00-index.md) | [Next: Module 7 — Motors & Motion Actuators →](./07-motors-and-motion-actuators.md)
