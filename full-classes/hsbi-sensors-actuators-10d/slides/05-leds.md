# The Wall That Browned Out

**Lumenwerk Gütersloh GmbH** is building a light wall for the Stadtmuseum's new exhibition. Curator **Aylin Demir** wants a warm, continuous glow that follows visitors along a 5-metre corridor. The prototype is beautiful for ten minutes — then the strip dims, the controller resets, and one section turns an unhealthy shade of pink.

Technician **Jonas Feld** has made the classic mistake: he powered a 30-LED strip from the microcontroller's 5 V pin and treated “brightness” as a single number. Aylin's question is practical: *"How much current does this wall actually need, and how do we drive it so it survives an opening night?"* Today: LED physics, current limiting, PWM and gamma, RGB mixing, addressable strips, and a power budget you measure.

> Light is the actuator you will use most in this course. Today: how to drive it correctly — safely, dimmably, in color, and addressably.

<!-- Note: Module 5 · LEDs & Light as Output — two sessions: one LED → RGB → addressable strip. Open here. Tell the story slowly; the motto is the promise for the session. Do not start with the agenda. The story is the power budget, not the library. -->

---

# Now back to the workbook

**Build the circuit → load the code → deploy to the ESP32 MiniKit.**

**Stage 1a — one LED**

- Anode → 220 Ω → GPIO 16; cathode → GND
- Load the Stage 1a fade; deploy; watch it fade
- Measure the current at full duty

<!-- Note: Story first, then hands on. Stop the deck here for Stage 1; resume at “An LED is a diode” after first light. -->

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

<!-- Note: Ask which fade looked smooth in Stage 2. -->

---

# RGB mixing

- Three diodes, three PWM channels
- Additive: red + green = yellow, all three = white
- Common cathode vs common anode
- One resistor value ≠ balanced white

<!-- Note: The common-anode toggle inverts the PWM values. -->

---

# Wiring at a glance

**Stage 1a — one LED**

- Anode → 220 Ω → GPIO 16; cathode → GND
- Red or yellow; blue/green stay dim at 220 Ω

**Stage 1b — discrete RGB LED**

- R → GPIO 16, G → GPIO 17, B → GPIO 18
- 220 Ω per channel; common → GND (3.3 V for common anode)

**Stage 2 — 8× WS2812B**

- DIN → GPIO 16, 5 V → 5 V, GND → GND
- Stage 2 reuses GPIO 16: unplug Stage 1a/1b first

<!-- Note: Say the GPIO 16 conflict out loud before handing out the strips. -->

---

# Now back to the workbook

**Build the circuit → load the code → deploy to the ESP32 MiniKit.**

**Stage 1b — RGB LED**

- R → GPIO 16, G → GPIO 17, B → GPIO 18; 220 Ω each; common → GND
- Load the Stage 1b `R G B` sketch; deploy
- Type `255 0 0`, `0 255 0`, `0 0 255`

<!-- Note: Stop the deck here. Hands on for Stage 2. -->

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
- USB 2.0 500 mA; USB 3 900 mA; USB-C 1.5–3 A
- The ESP32 adds 100–250 mA with Wi-Fi
- 8 LEDs + ESP32 fit USB 3/USB-C; USB 2.0 is the tight case
- `SetLuminance(80)` is the guardrail

<!-- Note: 9 LEDs would be 540 mA — over a 500 mA port. That is why 8. Most laptops are USB 3/USB-C, but keep the USB 2.0 case as the constraint. -->

---

# Talking to it: the REPL

- Stage 1b: `R G B` (0–255)
- Stage 2: `index R G B`, `clear`
- Echo the applied values
- Validate bounds and malformed input

<!-- Note: The REPL makes the strip inspectable; it is also the demo artifact. -->

---

# Now back to the workbook

**Build the circuit → load the code → deploy to the ESP32 MiniKit.**

**Stage 2 — 8× WS2812B**

- 5 V and GND from the MiniKit; DIN → GPIO 16; common ground
- Load the NeoPixelBus sketch with `SetLuminance(80)`; deploy
- Type `3 255 0 0`, then `clear`

<!-- Note: Stop the deck here. Hands on for Stage 3. -->

---

# AI-first: prompt → draft → verify

- AI scaffolds the project and README
- Verify pin, LED count, GRB, library, current
- `AGENTS.md` holds the guardrails
- Commit the verified repo

<!-- Note: The AI is the drafting tool; the meter and datasheet are the evidence. -->

---

# Now back to the workbook

**Create `stage3-project` → paste the Stage 3 prompt → build the extension.**

- Non-blocking animation
- Perceptual gamma
- Sensor-to-actuator bridge

<!-- Note: Stage 3 is the open project; use the prompt you prepared. -->

---

# Today's build

- **Session 1:** Stage 1a — one LED, PWM; Stage 1b — RGB, Vf
- **Session 2:** Stage 2 — 8× WS2812B, DMA, power; Stage 3 — extension project
- Share the repo

<!-- Note: Three builds, one repo. Stage 2 rewires GPIO 16 from red to DIN. -->

---

# Your turn

- Build Stage 1a, then 1b to first light
- Then the 8-LED strip
- Pick one Stage 3 extension
- Measure, verify, commit

<!-- Note: Circulate; ask for one choice per pod. -->
