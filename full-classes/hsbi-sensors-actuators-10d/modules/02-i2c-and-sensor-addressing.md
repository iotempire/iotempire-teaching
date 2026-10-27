# Module 2 – Buses & I²C: From Simple Pins to One Bus, Many Devices

[← Back to Module 1](./01-foundations-measurement-and-sensor-chain.md) | [Quick module index](./00-index.md) | [Next: Module 3 →](./03-sensor-characterization-and-calibration.md)

**Course placement:** Day 2 — the module runs across the day's two 90-minute sessions, with a break between them. We start with the bus landscape (simple pins and UART → RS-232/RS-485/Modbus/CAN/I²C/SPI/OneWire), zoom into I²C, and finish by building and choosing the scope/logic analyzer we use for the rest of the course. The instrument build is deliberately exploratory and a little risky: start it in class, and carry it into self-study if it needs more time.

> **Session shape.** Session 1: simple pins, UART, and the divider; launch the bus survey. Session 2: bus pitches and the class comparison, then the I²C pod study and the scan/register lab. Address conflicts and the instrument sprint are the natural carry-over into self-study; start the build in class so the class can compare candidates together. Keep the sequence; move the break points to fit the room.

> **Why this order?** A bus is not just a wire. You need the comparison first — point-to-point vs. multi-drop, single-ended vs. differential, addressing vs. chip-select, short vs. long cable — before I²C's two-wire elegance makes sense. And you need I²C traffic before the scope/analyzer sprint has something real to capture.

## 🎯 Learning Goals

This module gives you the opportunity to explore buses and device addressing and achieve competency in the bus landscape, I²C physics and addressing, register maps, multi-device buses, and low-cost bus instrumentation.

By the end of this module, you can:
1. Compare simple digital/analog/PWM pins, UART serial, and the main buses (RS-232, RS-485, Modbus RTU, CAN, I²C/I³C, SPI, OneWire) by wiring, voltage, signaling, drive style, speed, length, topology, use, and historical origin — and explain why PWM is not a bus.
2. Explain how I²C works physically and logically: two wires, open-drain, pull-ups, addressing, ACK/NACK, repeated start, clock stretching.
3. Wire and scan an I²C bus and identify every connected device by address.
4. Read a sensor through a library and read its raw registers directly.
5. Run two devices on one bus and resolve an address conflict.
6. Build and evaluate a low-cost ESP32 scope/logic analyzer, and agree on 1–2 class solutions for future bus debugging.

**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 📖 Story — Two Sensors, One Address

**Lumenwerk Gütersloh GmbH** builds interactive light installations for museums and public spaces. Creative director **Mara Voss** has a simple brief for the new Stadtmuseum exhibit: a distance sensor should wake the light wall when a visitor approaches, and an IMU should tilt the color field when they lean. Technician **Jonas Feld** wires both sensors to one controller, powers it up, and gets… one device.

The scanner finds a single address. Reads are intermittent. Mara asks the question that turns a wiring problem into a lesson: *"If both sensors are on the same two wires, how does the controller know which one is answering?"* Before you can answer, you need the bus landscape: what a simple pin can do, and where I²C sits among RS-232, RS-485, Modbus, CAN, SPI, and OneWire. Today you build that map, then zoom in.

*Hardware for the module:* 1× ESP32 DevKit or ESP32 Ethernet mini kit per pod, 2× I²C sensor modules with different addresses (e.g. environment sensor + MPU6050 or VL53L0X), jumper wires, one shared multimeter, optional USB-serial adapter or second board for the UART check, optional 2× 10 kΩ pull-ups, optional voltage divider/clamp for the scope input, optional Linux host or Raspberry Pi with `i2c-tools`.

> [!WARNING]
> Power off before rewiring. Check that every module's logic voltage matches 3.3 V. I²C modules with their own 5 V pull-ups can over-voltage a 3.3 V device — check before connecting. The scope/analyzer inputs are **3.3 V only**; use a divider or clamp for higher voltages and never connect to mains-referenced circuits.

## 🛠️ Studio Lab 1: From Simple Pins to Buses — **Challenging**

### ★ Task 1: Simple pins, PWM, UART, and a voltage divider

Before the bus survey, get the baseline right. Work in your pod and record the answers in `Module02/pins-and-dividers.md`.

1. **Classify the simple connections in the kit.** For each, name the wires, the voltage, and one failure mode:
   - **Digital high/low:** button, switch, LED, relay.
   - **PWM:** LED dimming, servo. PWM is a modulation technique for average power — **not** a bus: it has no addressing, no framing, and no error handling.
   - **Analog:** capacitive soil sensor, gas sensor, NTC divider → ADC.
   - **Serial/UART:** TX/RX at 3.3 V, point-to-point, no addressing. RS-232 and RS-485 add an electrical layer (voltage levels, differential pair, multi-drop) on top of the same serial idea.
2. **Measure a divider.** Build a voltage divider for a 5 V sensor signal into a 3.3 V ADC:
   ```text
   Vout = Vin · R2 / (R1 + R2)
   Example: Vin = 5 V, R1 = 10 kΩ, R2 = 20 kΩ → Vout = 5 · 20 / 30 = 3.33 V
   ```
   Measure `Vout` with the multimeter and compare it with the calculation.
3. **Watch a UART line.** Open the serial console and send one line to a second device or a USB-serial adapter (or loop TX back to RX). Note the baud rate, and how you would recognize a wrong baud rate. Then explain in one sentence what an RS-485 transceiver adds for a 20 m multi-drop run.
4. **Explain the why.** Why does a 5 V sensor need a divider for a 3.3 V board? Where else does a divider help (resistance sensors, level protection, reference scaling)?
5. **Write the baseline table** in `Module02/pins-and-dividers.md`: connection, wires, voltage, speed/length, example, failure mode.

*Portfolio evidence:* `Module02/pins-and-dividers.md` with the table, the UART note, the divider calculation, and the measurement.

### ★ Task 2: Bus systems survey — research and pitch

Your pod owns one bus. Research it from the English Wikipedia, the datasheet of a kit device, **or an LLM used as a research partner** — then produce a one-page profile. If you use an LLM, do not stop at “what is it”: ask for the **history and background**, its **relations to the other buses in the list**, and especially the **curiosities and remarkable design choices**. Treat every voltage, timing, and part number as a claim to verify against a datasheet or the bench.

| Pod | Bus | What to focus on |
|:---:|---|---|
| 1 | **RS-232** | Point-to-point serial, voltage levels, connectors, legacy PCs/instruments |
| 2 | **RS-485** | Differential signaling, multi-drop, termination, long cable runs |
| 3 | **Modbus RTU** | RS-485 + protocol: registers, master/slave, industrial meters |
| 4 | **CAN** | Differential, multi-master, arbitration, automotive/robotics |
| 5 | **I²C / I³C** | Two wires, addressing, pull-ups, sensors and displays |
| 6 | **SPI** | Four+ wires, chip-select, speed, short board-level links |
| backup | **OneWire** | One data wire, 64-bit ROM ID, DS18B20 chains |

With fewer pods, combine Modbus RTU + CAN or use OneWire as the backup. With more pods, split a bus into “wiring/electrical” and “protocol/use” and present together.

**All pods:** be ready to explain the I²C open-drain/pull-up question in Task 3, even if I²C is not your assigned bus.

**LLM research prompts (an alternative or complement to Wikipedia).** Pick 3–5, record the prompt, a short summary, and how you verified it.

- **History and background:** “Trace the history of `<bus>`: who created it, which problem it solved, what it replaced, and which design decision from that era still shapes it today. Separate documented history from folklore.”
- **Relation to the others:** “Compare `<bus>` with RS-232, RS-485, Modbus RTU, CAN, I²C/I³C, SPI, and OneWire. What does `<bus>` make easy that the others make hard, and vice versa? Give the trade-off in one sentence per bus.”
- **Curiosities and remarkable features:** “What is genuinely unusual or surprising about `<bus>` compared with the other buses in this list? Give three technically substantive curiosities — not marketing facts — and say why each one matters for wiring or debugging.”
- **The I²C question (all pods should be able to answer this):** “Explain I²C’s open-drain signaling: why can a device only pull a line low, and why does the bus rely on pull-ups? What happens electrically when several devices — possibly with different supply voltages — share SDA/SCL? Cover level shifting, bus capacitance, and what a stuck-low device does to the whole bus.”
- **Failure lore:** “Give one classic failure mode of `<bus>` and the measurement or capture that identifies it. What would a beginner blame first, and what is the actual root cause?”
- **Verification list:** “List the five claims from your answer that I should verify in a datasheet or on the bench, and name the source or measurement for each.”

> [!WARNING]
> LLMs are good at history, comparisons, and curiosities; they are unreliable on exact voltages, timing, and part numbers. Verify every number against a datasheet or standard, and mark in your profile which claims you verified and which remain open.

**Cover at least:** history and background (who, when, why) · wires and connectors · voltage, signaling, and drive style (single-ended/differential, open-drain/pull-up) · serial/parallel · speed and maximum length · topology and addressing (point-to-point, multi-drop, multi-master) · typical use and one example from our kit · relation to the other buses in the list · one curiosity or remarkable design choice · what can go wrong and how you would debug it.

**Deliverable:** `Module02/bus-<name>.md`, using this shape:

```markdown
## Bus profile: <bus>
- History and background:
- Wires and connectors:
- Voltage, signaling, and drive style:
- Topology and addressing:
- Speed and maximum length:
- Relation to the other buses:
- Typical use and kit example:
- Curiosities / remarkable features:
- What can go wrong / how to debug:
- Sources and verification:
```

Keep it short — one page, one table or image, the facts that matter for choosing and debugging, and a short “curiosities” list. Post the best table/image in the course Discord, and be ready to give a short pitch.

*Portfolio evidence:* `Module02/bus-<name>.md` plus your notes from the other pods' pitches.

### ★ Task 3: Build the class comparison table

Merge the pod profiles into one class table. Suggested columns:

| Bus | Wires | Signaling | Drive style | Topology / addressing | Speed / length | Typical use | Kit example | Debug tool |
|---|---|---|---|---|---|---|---|---|

Then discuss and write down the answers:

1. Which buses are **point-to-point**, which are **multi-drop**, which are **multi-master**?
2. Which need **termination**? Which are **differential**? Which are **self-clocking**?
3. Which are **open-drain with pull-ups**, which are **push-pull**, and which are **differential**? What does that mean for sharing one bus and for connecting devices with different supply voltages?
4. Where does **I²C** sit, and why does it win for many small sensors on one board?
5. Which bus would you choose for **20 m across a room**, for **20 sensors on one board**, and for a **motor driver**? Give one sentence each.
6. Which bus is the oldest, and which design constraint from its era is still visible in its wiring or protocol?

*Portfolio evidence:* `Module02/bus-comparison.md` (or a link to the shared class table) with your bus-choice sentences, your open-drain/voltage answer, and one “what surprised me” note.

## 📖 Pod Study: One Bus, Many Devices (I²C)

Now that you have the map, zoom in on the bus the kit uses most. This is **self/pod study, not a lecture.** Work through the concepts below with your Task Pod, look things up, ask an LLM, and keep notes — the goal is a shared mental model you can defend in the checkpoint.

### The I²C Bus

I²C (*Inter-Integrated Circuit*) uses just two wires plus ground:

- SCL — serial clock (driven by the master, i.e. your MCU),
- SDA — serial data (bidirectional).

Both lines are open-drain: a device can only pull a line low or release it. The high level comes from pull-up resistors (typically 2.2–10 kΩ to 3.3 V). This is why a missing pull-up, or two devices both fighting the bus, is a classic failure.

### A transaction, step by step

```text
START → [ 7-bit address | R/W ] → ACK → register/data bytes → ... → STOP
```

1. The master issues a START condition (SDA falls while SCL is high).
2. It sends the 7-bit address plus a read/write bit.
3. The addressed device answers with ACK (pulls SDA low) — or nobody answers, and you get a NACK (the "nothing there" case a scanner detects).
4. Data bytes follow, each acknowledged.
5. The master issues a STOP (SDA rises while SCL is high).

Common speeds are 100 kHz (standard) and 400 kHz (fast mode). A device may hold SCL low to slow the master down — clock stretching.

### The address confusion you must resolve today

- The 7-bit address is what tools show (e.g. `0x3C` for a typical OLED, `0x68`/`0x69` for the MPU6050, `0x29` for the VL53L0X).
- Some libraries and datasheets quote the 8-bit form, which is the 7-bit address shifted left by one (`0x3C → 0x78`). If a scan shows `0x3C` but your library wants `0x78`, this is why.
- Address conflicts: many sensors use a fixed address. If you connect two MPU6050s, both answer at `0x68`. Resolution options: change the address with a jumper/pin or software if the device supports it, or use an I²C multiplexer (TCA9548A) as a stretcher.

### Register model

Most I²C sensors are not "send a command, get a value". They expose a register map: you write a register address (e.g. "start a measurement", "select a range"), then read a register (or several bytes) and combine them. Datasheets for I²C sensors *are* register maps — reading them is a core skill here.

### Where I²C sits among the buses

Your class comparison table has the full landscape; this is the subset you will touch in the kit:

| Bus | Wires | Addressing | Typical use |
|---|---|---|---|
| I²C | 2 + GND | 7-bit addresses on a shared bus | Many sensors, displays, IO expanders |
| SPI | 4+ (MOSI, MISO, SCK, CS) | Chip-select per device | Fast peripherals (RFID, SD, some ADCs) |
| UART | 2 (TX/RX), point-to-point | None (fixed peers), sometimes AT commands | GPS, some modules, RS-485 links |
| OneWire | 1 + GND | 64-bit ROM ID per device | DS18B20 temperature chains |
| Analog / PWM | 1 signal | None | Simple sensors, servos, dimming |

### Pointers (start here, then keep looking)

- The definitive bus reference — [NXP: I²C-bus specification (UM10204)](https://www.nxp.com/docs/en/user-guide/UM10204.pdf)
- The readable overview — [Wikipedia: I²C](https://en.wikipedia.org/wiki/I%C2%B2C)
- Arduino's implementation — [Arduino: Wire library](https://www.arduino.cc/reference/en/language/functions/communication/wire/)
- Scanning from Linux — [`i2c-tools` / `i2cdetect`](https://i2c.wiki.kernel.org/index.php/I2C_Tools)
- Your devices' register maps — the datasheets linked in the [resource bank](./Z-resources-bank.md#datasheets--standards-to-read-once)

### Questions to ask an LLM (then verify against your hardware)

Ask your co-pilot — but treat every answer as a **claim to test**, not a fact. Good starting prompts:

- "Explain I²C to a student who has only used GPIO. What do START, ACK/NACK, repeated start, and clock stretching mean, and how would I see each on a logic analyzer?"
- "My scan shows `0x3C` but my library wants `0x78`. Explain the 7-bit vs. 8-bit address convention and show the shift."
- "Two identical sensors answer at `0x68`. List every way to make them coexist, with the trade-offs of each."
- "Here is a register map from a sensor datasheet: `<paste the relevant page>`. Walk me through reading one raw value with `Wire`, including the byte order and scaling."
- "Why do I²C lines need pull-up resistors, and what changes when I add more devices or a longer cable?"

> Run each prompt against your own bus, and record where the model is wrong, vague, or over-confident.

### ★ Task A: I²C study log

Work through the concepts above with your Task Pod and fill in `Module02/study-log.md`:

1. **The references you used** — the source and the one concept you understood best from it.
2. **Things you googled** — the term, what you found, and the source (URL). One line each.
3. **Remarkable things** — surprises, "aha"s, and counterexamples from your own bus.
4. **LLM Q&A** — for each prompt: the prompt, a 2–3 line summary, and **how you verified it** (and where it was wrong).
5. **Your two best found bus explanations or diagrams** — compile down to the best two, with source and what they taught you.

*Portfolio evidence:* `Module02/study-log.md`.

### ★ Task B: Share your bus profile and I²C study log

Pair with a **neighbouring pod**:

1. **Explain to each other** — each pod walks the other through its bus profile and its I²C study log; compare the bus choices and fill each other's gaps.
2. Agree on the **3–5 most noteworthy points** and the **learning you jointly stand behind** (e.g. *"a scan shows the 7-bit address; the library may want the 8-bit form"*).
3. **Clean up your documentation** — update your `study-log.md` with what you learned from the other pod.
4. Agree on **one shared artefact** — the best bus table, a scan map, or a new diagram the two pods make together — and **post it in the course Discord**, with a one-sentence note on why you chose it.
5. Each member adds a short **“Agreed learning (pod discussion)”** section to *their own* `study-log.md`.

*Portfolio evidence:* your cleaned-up `study-log.md` (with the **“Agreed learning (pod discussion)”** section) and your pod-pair's shared artefact.

## 🛠️ Studio Lab 2: Talk to the I²C Bus — **Challenging**

### ★ Task 4: Wire the Bus and Scan It

1. Connect SCL and SDA (plus `3V3` and `GND`) to your board, using the correct pins for your board (ESP32 default is usually GPIO21=SDA, GPIO22=SCL; check your board).
2. Upload an I²C scanner and record every address:
   ```cpp
   #include <Wire.h>
   void setup() {
     Serial.begin(115200);
     Wire.begin();              // use the correct SDA/SCL pins for your board
     Serial.println("Scanning I2C bus...");
     for (uint8_t addr = 1; addr < 127; addr++) {
       Wire.beginTransmission(addr);
       if (Wire.endTransmission() == 0) {
         Serial.printf("device at 0x%02X\n", addr);
         delay(5);
       }
     }
     Serial.println("scan done");
   }
   void loop() {}
   ```
3. Write down every address found and match it to the module it belongs to (find the address in its datasheet).
4. Deliberately unplug one sensor and scan again. Note which address disappears — this is your fastest I²C debugging tool.

> **Alternative/complement:** if you have a Linux host with an exposed I²C bus, run `i2cdetect -y 1`. It shows the same map and is the standard tool on gateways and Raspberry Pis.

### ★ Task 5: Read Through the Library, Then Read the Register

1. Read one sensor using its library (e.g. an environment sensor) and log values.
2. Now open the datasheet and find the register that returns the raw value (for example a temperature register). Read it directly with `Wire` and reconstruct the value using the datasheet's scaling.
3. Compare your raw reconstruction with the library output. They should agree; if not, find out why (scaling, signed vs. unsigned, byte order, bit shifting).

> This step is the difference between "it works" and "I understand it." You will need it whenever a library is missing, outdated, or wrong.

### ★ Task 6: Two Devices on One Bus

1. Add a second I²C sensor with a *different* address to the same SCL/SDA pair (no extra pins). Power and ground both.
2. Scan again: both addresses must appear.
3. Read both sensors in one sketch. Confirm that adding a device did not require new pins.
4. Note the two addresses in your portfolio and explain why they can coexist.

### ★ Task 7: Create and Resolve an Address Conflict

1. If you have two modules with the same fixed address, connect both. Scan: only one address appears, and reads become unreliable or wrong. Explain what the bus is doing electrically.
2. Resolve it in the way your hardware allows:
   - change one device's address via a jumper or a configuration register (datasheet!), or
   - use an I²C multiplexer to give each device its own channel.
3. Document the conflict and the fix — this is exactly the kind of engineering note the portfolio rewards.

## 🛠️ Studio Lab 3: Build the Instrument — **Challenging**

> [!NOTE]
> **Lab reality: no benchtop oscilloscope, one shared multimeter.** This instrument sprint follows the I²C work, which has given you real traffic to capture. It is deliberately a **risky, exploratory build**: try the candidates, compare them, and let the class's enthusiasm and evidence decide. Then agree on **1–2 solutions** we use for the rest of the course. For I²C and OneWire, a **logic analyzer** with PulseView/sigrok is the right tool; for slow analog signals and PWM, a browser-based ESP32 scope is useful. Use the multimeter for reference/sanity checks and let the scope/analyzer carry the bus debugging.

> [!WARNING]
> The scope/analyzer inputs are **3.3 V only**; use a divider or clamp for higher voltages and never connect to mains-referenced circuits. Power off before rewiring.

### ★ Task 8: Build and Choose Our Scope — instrument sprint

**Goal:** by the end of this task, the class agrees on **1–2 open-source solutions** and writes down how to build, flash, and use them. Future modules use those solutions unless a documented reason forces a change.

**Pick by role, not by repo name.** The shortlist falls into roles; the class needs at least one **A** and one **B**. A candidate can be replaced if it fills the same role.

**A. Digital bus analyzers — SUMP firmware + PulseView.** Use these for I²C, SPI, UART, and OneWire. Sampling is in the MS/s range; protocol decoding happens in PulseView.

| Candidate | What it gives you | Limits / notes |
|---|---|---|
| [lmcapacho/ESP32_LogicAnalyzer](https://github.com/lmcapacho/ESP32_LogicAnalyzer) | 16-channel SUMP, up to **20 MS/s**, 128k samples, RLE, PulseView/sigrok | Digital only, 3.3 V; Arduino IDE; **best default for I²C/OneWire** |
| [EUA/ESP32_LogicAnalyzer](https://github.com/EUA/ESP32_LogicAnalyzer) | 16-channel SUMP, I2S DMA, up to **20 MS/s** | Digital only; PlatformIO; alternate codebase |
| [pschatzmann/logic-analyzer](https://github.com/pschatzmann/logic-analyzer) | Arduino SUMP library; ESP32, ESP32-S3, RP2040; clean sketch you can inspect and compile | SUMP max **65535 samples**; serial at 921600; more “build it yourself”; the ESP32 `MAX_FREQ` is not a reliable sampling rate — measure it |
| [hepter/web-logic-analyzer](https://github.com/hepter/web-logic-analyzer) | Browser digital capture with export to PulseView; configurable sample rate (example: 1 MHz) | Digital only; export-based, not live SUMP/decoding; set the rate correctly on import |
| [ok-home/logic_analyzer](https://github.com/ok-home/logic_analyzer) | SUMP plus `.bin` export; useful fallback | UART0 logging must be off; some PulseView quirks; less polished |

**B. Browser analog scopes — zero-install web UI.** Use these for RC curves, PWM, sensor outputs, and slow analog signals. They do **not** decode I²C.

| Candidate | What it gives you | Limits / notes |
|---|---|---|
| [GUELORD-MWENDERWA/esp32-web-oscilloscope](https://github.com/GUELORD-MWENDERWA/esp32-web-oscilloscope) | 100 S/s–**50 kS/s**, 12-bit, edge trigger with pre-trigger history, automatic measurements, 1 kHz test signal, prebuilt binary and browser flashing | Single analog channel; Wi-Fi AP; **new and not yet validated on hardware — timing figures are design targets**; **Web Serial flashing is Chromium-only**; treat as an experimental candidate |
| [BojanJurca/Esp32_oscilloscope](https://github.com/BojanJurca/Esp32_oscilloscope) | Browser scope, analog + digital, optional I2S single-channel mode, public demo | ~736 samples/screen; sample rate varies with load; **not a fast-bus decoder**; Arduino IDE; MIT |
| [MatAtBread/esp-scope](https://github.com/MatAtBread/esp-scope) | Browser scope with trigger, cursors, attenuation, and test signal; up to ~**83 kS/s** | ESP-IDF toolchain; more setup; analog only |

**C. Hybrid / mixed-signal — stretcher.**

| Candidate | What it gives you | Limits / notes |
|---|---|---|
| [Ebiroll/esp32_sigrok](https://github.com/Ebiroll/esp32_sigrok) | SUMP digital capture **plus** Rigol DS1000 emulation, so analog appears in PulseView | Only ~1400 analog samples; uncalibrated; older code; ESP-IDF; use as a stretcher/benchmark, not the default |

**D. Host software / baseline.**

- **[PulseView / sigrok](https://sigrok.org/wiki/PulseView):** the host for A and C, with I²C, 1-Wire, SPI, UART, and CAN protocol decoders.
- **Arduino IDE Serial Plotter:** slow trend plot for `Serial.println()` values; useful as a sanity check, not a bus tool.
- **Optional `sigrok-cli`:** scripted, reproducible captures for the portfolio.

**E. Reference check (if available).** A known-good commercial **fx2lafw** 8-channel 24 MHz USB analyzer (often under €20) or a borrowed scope is not the class default. If you have one, use it for **one** reference capture and compare it with your ESP32 build. The point is calibration by comparison, not buying more hardware.

**Recommended pairing:** one **A** + one **B**. If you adopt only one solution, choose **A** — it is the tool that actually decodes I²C/OneWire traffic. **C** is a stretcher for a pod that wants analog and digital in one host.

> **Sampling rule of thumb:** for 100 kHz I²C, sample at **≥1 MS/s** to see clean edges (the Nyquist minimum is 200 kS/s, but decoding wants margin); for 400 kHz I²C, use **≥4 MS/s**. Even the fastest web scopes here (50–83 kS/s) cannot decode 100 kHz I²C — they are for slow analog signals and PWM. Use **A** for buses.

> **Browser caveat:** the web UI itself works in modern browsers, but **Web Serial flashing** works only in Chrome, Edge, and Opera — not Safari or stable Firefox. On Safari/Firefox, flash with Arduino IDE/PlatformIO or use an AP-based firmware that does not need Web Serial.

> **Board note:** most candidates target a classic ESP32; some support ESP32-S3, ESP32-C6, or RP2040. Check the board, pin map, and ADC pins before flashing. For analog captures, use **ADC1** pins (on a classic ESP32: GPIO32–39) because Wi-Fi uses ADC2.

> **Pin-conflict warning:** the SUMP analyzers reserve dedicated I2S/LEDC pins (for `lmcapacho` and `EUA`, GPIO23 and GPIO22 by default). Do not use those pins for I2C or other signals; remap them in the config or use a separate ESP32. Draw the pin map before wiring.

> **Host software:** [PulseView / sigrok](https://sigrok.org/wiki/PulseView) is the open-source host for the logic-analyzer candidates and includes I²C and 1-Wire protocol decoders. Install it before the sprint. `sigrok-cli` is optional for scripted captures; the Arduino IDE Serial Plotter is a separate slow-trend baseline, not a bus decoder.

1. **Split the candidates by role across pods.** Each pod picks one or two candidates, aiming for at least one **A** and one **B** in the room. Record the repo URL and the commit/version you used. With a small cohort (e.g. 12 students = six pairs), a good split is three A pods, two B pods, and one cross-check pod; adapt to the room.
2. **Build and flash** on your ESP32 DevKit or Ethernet mini kit. Use the project's Arduino IDE or PlatformIO instructions. Time the install: from unboxing to first capture.
3. **Test on known signals:**
   - **PWM / square wave:** generate 1 kHz on a second ESP32 (or use the board's LEDC/DAC/test output) and display it.
   - **I²C:** run an I²C scanner on SDA/SCL at 100 kHz. A scanner's address probes are enough traffic. Look for **START, address, ACK/NACK, and STOP**; with PulseView, enable the I²C decoder.
   - **OneWire (optional):** read a DS18B20 and capture the reset/presence/data pulses.
4. **Measure and record:** sample rate/timebase, whether edges are stable or missed, whether the I²C decode works, browser/OS compatibility (viewing vs. Web Serial flashing), input voltage range and protection, and the total setup effort.
5. **Class decision:** each pod gives a short demo of its candidate. As a class, agree on **1–2 solutions** and write `Module02/scope-decision.md`:
   - chosen solution(s), role (A/B/C), and repo/commit,
   - install steps (Web Serial, Arduino IDE, or PlatformIO) and pin mapping,
   - sample rate/timebase and input limits,
   - what it can and cannot capture,
   - test captures (PWM, I²C, optional OneWire),
   - who owns the setup instructions.

> If time runs short, finish the class decision and carry the captures into portfolio time.

### ◇ Task 9 (Stretcher): See the Bits on the Wire

With the class scope/analyzer chosen in Task 8, capture one I²C transaction:

- Identify START, the 7-bit address, the R/W bit, the ACK from the device, the data byte(s), and STOP.
- Measure the actual clock frequency and compare it with the configured speed.
- Try a longer/poorer cable or remove a pull-up and observe the signal integrity degrade. Record what you see.

## ✅ Suggested portfolio evidence (proofs of the learning goals)

1. Simple pins, UART, and divider: the table, the `Vout` calculation, and the multimeter measurement (`Module02/pins-and-dividers.md`).
2. Bus profile: `Module02/bus-<name>.md` including history/background, relation to the other buses, one or two curiosities, and your verification notes (which claims came from a datasheet or the bench vs. an LLM).
3. Class comparison: `Module02/bus-comparison.md` (or a link to the shared table) with your bus-choice sentences, the open-drain/voltage answer, and one “what surprised me” note.
4. Scope decision: chosen solution(s), repo/commit, install steps, pin mapping, sample rate, input limits, and the PWM/I²C test captures. Include one sentence on what the chosen tool cannot measure.
5. Scan artifact: serial output of at least two scans (one device, two devices), with each address mapped to its module.
6. Register proof: the raw register value you read and the reconstruction you computed with the datasheet formula, next to the library's value.
7. Address table: for each device in the kit: type, interface, address(es), and whether the address is configurable.
8. Conflict report: how you created and resolved (or would resolve) an address conflict.
9. Deeper question: Why does adding a second I²C device not need a second data pin, and what are the limits of that elegance (capacitance, address space, speed, one defective device pulling the bus down)?

> [!IMPORTANT]
> Never commit secrets, credentials, or personal data. Where you did not work entirely alone, link your pod mates and sources.

## 📚 If you want to go deeper

- [SparkFun: Voltage Dividers](https://learn.sparkfun.com/tutorials/voltage-dividers) — the formula and practical examples.
- [Wikipedia: RS-232](https://en.wikipedia.org/wiki/RS-232) · [RS-485](https://en.wikipedia.org/wiki/RS-485) · [Modbus](https://en.wikipedia.org/wiki/Modbus) · [CAN bus](https://en.wikipedia.org/wiki/CAN_bus) · [SPI](https://en.wikipedia.org/wiki/Serial_Peripheral_Interface) · [OneWire](https://en.wikipedia.org/wiki/1-Wire)
- [NXP UM10204 — I²C-bus specification](https://www.nxp.com/docs/en/user-guide/UM10204.pdf) — the definitive reference for addressing, arbitration, and clock stretching.
- [Wikipedia: I²C](https://en.wikipedia.org/wiki/I%C2%B2C) — the readable overview and history.
- [Arduino Wire library](https://www.arduino.cc/reference/en/language/functions/communication/wire/) — the API you will use.
- [Linux `i2c-tools`](https://i2c.wiki.kernel.org/index.php/I2C_Tools) — the standard gateway/Pi scanner.
- [PulseView / sigrok](https://sigrok.org/wiki/PulseView) — open-source logic-analyzer software with I²C and 1-Wire protocol decoders.
- Scope/analyzer candidates from Task 8: [lmcapacho/ESP32_LogicAnalyzer](https://github.com/lmcapacho/ESP32_LogicAnalyzer), [EUA/ESP32_LogicAnalyzer](https://github.com/EUA/ESP32_LogicAnalyzer), [hepter/web-logic-analyzer](https://github.com/hepter/web-logic-analyzer), [BojanJurca/Esp32_oscilloscope](https://github.com/BojanJurca/Esp32_oscilloscope), [MatAtBread/esp-scope](https://github.com/MatAtBread/esp-scope).
- Your sensor datasheets — linked from the [resource bank](./Z-resources-bank.md#datasheets--standards-to-read-once).

---

[← Previous: Module 1](./01-foundations-measurement-and-sensor-chain.md) | [Back to front page](../README.md) | [Quick module index](./00-index.md) | [Next: Module 3 — Sensor Characterization →](./03-sensor-characterization-and-calibration.md)
