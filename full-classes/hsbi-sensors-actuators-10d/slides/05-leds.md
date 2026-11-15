# Module 5 — LEDs: from Vf to a Shareable Strip

### Day 5 · Two sessions: discrete RGB → addressable WS2812B

*Light is the actuator you will use most — drive it correctly.*

<!-- Note: This deck is the waiting-time material. Show it while the AI scaffolds the project or a build runs; stop when the build finishes. -->

---

# The wall that browned out

- A 30-LED strip powered from the 5 V pin
- Beautiful for ten minutes — then dim, reset, pink
- The question: how much current, and how do we drive it?

<!-- Note: Lumenwerk / Aylin Demir / Jonas Feld. The story is the power budget, not the library. -->

---

# An LED is a diode

- Conducts above its forward voltage `Vf`
- Brightness follows **current**, not voltage
- `Vf` depends on color: red ≈ 1.9 V, green ≈ 2.1 V, blue ≈ 3.0–3.4 V

<!-- Note: Ask: what happens if you connect an LED without a resistor? -->

---

# Vf is a voltage cap

- The LED clamps the voltage across itself at `Vf`
- The resistor takes the rest: `Vs − Vf`
- Blue on 3.3 V: only ~0.1 V across the resistor
- Small `Vf` changes → large current changes

<!-- Note: This is the “voltage capping” intuition: the diode sets the voltage, the resistor sets the current. -->

---

# Resistor computation

- `R = (Vs − Vf) / I`
- Red at 6 mA on 3.3 V: `(3.3 − 1.9) / 0.006 ≈ 233 Ω` → 240 Ω
- **220 Ω is the safe default**
- 33 Ω on red: ~42 mA — over the pin's comfort range
- Resistor power: `P = I²R`

<!-- Note: 220 Ω is conservative, not magic. The precise value targets a current. -->

---

# Why 220 Ω is fine

- Red ~6 mA, green ~5 mA, blue <1 mA at 3.3 V
- Common anode on 5 V: all three 8–14 mA
- The eye sees 1 mA; nothing is near the GPIO limit
- Precision only for a target current or a balanced white

<!-- Note: Measure the three channels and show the imbalance. That is the lesson. -->

---

# PWM

- Duty cycle = on-fraction
- Average current follows duty
- Below ~100 Hz you see flicker; LEDs run at 1–20 kHz
- `analogWrite()` → LEDC on the ESP32

<!-- Note: One PWM channel per color. The duty is not the perceived brightness yet — gamma comes next. -->

---

# Gamma

- A linear duty ramp jumps at the bright end
- Perceived brightness ≈ `in^2.2`
- `out = 255 · (in/255)^2.2`
- `NeoPixelBusLg` applies a gamma table

<!-- Note: Ask which fade looked smooth in Stage A. -->

---

# RGB mixing

- Three diodes, three PWM channels
- Additive: red + green = yellow, all three = white
- Common cathode vs common anode
- One resistor value ≠ balanced white

<!-- Note: The common-anode toggle inverts the PWM values. -->

---

# Wiring at a glance

**Stage A — discrete RGB LED**

- R → GPIO 16, G → GPIO 17, B → GPIO 18
- 220 Ω per channel; common → GND (3.3 V for common anode)

**Stage B — 8× WS2812B**

- DIN → GPIO 16, 5 V → 5 V, GND → GND
- Stage B reuses GPIO 16: unplug the Stage A red channel first

<!-- Note: Say the GPIO 16 conflict out loud before handing out the strips. -->

---

# WS2812B: one wire, many pixels

- A driver chip in every LED
- 24 bits per pixel: **GRB**
- 800 kHz NRZ
- Each pixel regenerates the rest of the stream
- A reset/latch gap ends the frame

<!-- Note: The data line is not the power line. -->

---

# Timing is the hard part

- Wi-Fi/BLE interrupts corrupt software-timed output
- Hardware I²S1 DMA/RMT generates the waveform
- **NeoPixelBus, not FastLED**, on this board
- `AGENTS.md` carries the rule for the AI

<!-- Note: This is the “why the library” slide. The failure mode is a glitch under radio load. -->

---

# Power budget

- 60 mA per LED at full white
- 8 × 60 = **480 mA**
- USB 2.0 500 mA; USB 3 900 mA
- The ESP32 adds 100–250 mA with Wi-Fi
- `SetLuminance(80)` is the guardrail

<!-- Note: 9 LEDs would be 540 mA — over a 500 mA port. That is why 8. -->

---

# Talking to it: the REPL

- Stage A: `R G B` (0–255)
- Stage B: `index R G B`, `clear`
- Echo the applied values
- Validate bounds and malformed input

<!-- Note: The REPL makes the strip inspectable; it is also the demo artifact. -->

---

# AI-first: prompt → draft → verify

- AI scaffolds the project and README
- Verify pin, LED count, GRB, library, current
- `AGENTS.md` holds the guardrails
- Commit the verified repo

<!-- Note: The AI is the drafting tool; the meter and datasheet are the evidence. -->

---

# Today's build

- **Session 1:** Stage A — discrete RGB, Vf, PWM
- **Session 2:** Stage B — 8× WS2812B, DMA, power
- **Stage C:** non-blocking, gamma, sensor bridge
- Share the repo

<!-- Note: Two stages, one repo. Stage B rewires GPIO 16 from red to DIN. -->

---

# Your turn

- Build Stage A to first light
- Then the 8-LED strip
- Pick one Stage C extension
- Measure, verify, commit

<!-- Note: Circulate; ask for one choice per pod. -->
