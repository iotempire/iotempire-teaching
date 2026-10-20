# Module 2 – I²C & Sensor Addressing: One Bus, Many Devices

[← Back to Module 1](./01-foundations-measurement-and-sensor-chain.md) | [Quick module index](./00-index.md) | [Next: Module 3 →](./03-sensor-characterization-and-calibration.md)

> This is the module that turns "a sensor in a library example" into "a device on a bus that you understand." We deliberately scan and poke the bus *before* trusting a library.

**Course placement:** Day 2 — the instrument-and-bus studio. We first build and choose a low-cost ESP32 scope/analyzer, then scan and poke the bus before trusting a library.

> **Session order:** begin the studio with **Task 1 — the 2-hour instrument sprint**. The pod-study concepts can be read before, during, or after; the class decision on 1–2 scope/analyzer solutions is the day's first deliverable.

## 🎯 Learning Goals

This module gives you the opportunity to explore sensor buses and device addressing and achieve competency in I²C physics and addressing, register maps, multi-device buses, and bus comparison (SPI, UART, OneWire, analog).

By the end of this module, you can:
1. Explain how I²C works physically and logically: two wires, open-drain, pull-ups, addressing, ACK/NACK, repeated start, clock stretching.
2. Wire and scan an I²C bus and identify every connected device by address.
3. Read a sensor through a library and read its raw registers directly.
4. Run two devices on one bus and resolve an address conflict.
5. Recognize when a device is I²C, SPI, UART, OneWire, or analog, and why that matters for wiring and debugging.
6. Build and evaluate a low-cost ESP32 scope/logic analyzer, and agree on 1–2 class solutions for future bus debugging.


**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 📖 Story — Two Sensors, One Address

**Lumenwerk Gütersloh GmbH** builds interactive light installations for museums and public spaces. Creative director **Mara Voss** has a simple brief for the new Stadtmuseum exhibit: a distance sensor should wake the light wall when a visitor approaches, and an IMU should tilt the color field when they lean. Technician **Jonas Feld** wires both sensors to one controller, powers it up, and gets… one device.

The scanner finds a single address. Reads are intermittent. Mara asks the question that turns a wiring problem into a lesson: *"If both sensors are on the same two wires, how does the controller know which one is answering?"* Today you learn the bus — addresses, registers, pull-ups, and what happens when two devices claim the same identity.

## 📖 Pod Study: One Bus, Many Devices

This is **self/pod study, not a lecture.** Work through the concepts below with your Task Pod, look things up, ask an LLM, and keep notes — the goal is a shared mental model you can defend in the checkpoint.

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

### Where does I²C sit among the buses?

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

### ★ Task A: Study in your pod

Work through the concepts above with your Task Pod and fill in `Module02/study-log.md`:

1. **The references you used** — the source and the one concept you understood best from it.
2. **Things you googled** — the term, what you found, and the source (URL). One line each.
3. **Remarkable things** — surprises, "aha"s, and counterexamples from your own bus.
4. **LLM Q&A** — for each prompt: the prompt, a 2–3 line summary, and **how you verified it** (and where it was wrong).
5. **Your two best found bus explanations or diagrams** — compile down to the best two, with source and what they taught you.

*Portfolio evidence:* `Module02/study-log.md`.

### ★ Task B: Explain & share with another pod

Pair with a **neighbouring pod**:

1. **Explain to each other** — each pod walks the other through its scan map and its register-reading proof; ask questions and fill each other's gaps.
2. Agree on the **3–5 most noteworthy points** and the **learning you jointly stand behind** (e.g. *"a scan shows the 7-bit address; the library may want the 8-bit form"*).
3. **Clean up your documentation** — update your `study-log.md` with what you learned from the other pod.
4. Agree on **one shared artefact** — the best scan map, a register table, or a new diagram the two pods make together — and **post it in the course Discord**, with a one-sentence note on why you chose it.
5. Each member adds a short **“Agreed learning (pod discussion)”** section to *their own* `study-log.md`.

*Portfolio evidence:* your cleaned-up `study-log.md` (with the **“Agreed learning (pod discussion)”** section) and your pod-pair's shared artefact.

## 🛠️ In-Class Lab: Build the Instrument, Then Talk to the Bus — **Challenging**

*Hardware:* 1× ESP32 DevKit or ESP32 Ethernet mini kit per pod (for the scope/analyzer and for the bus), 2× I²C sensor modules with different addresses (e.g. environment sensor + MPU6050 or VL53L0X), jumper wires, one shared multimeter, optional 2× 10 kΩ pull-ups, optional voltage divider/clamp for the scope input, optional Linux host or Raspberry Pi with `i2c-tools`.

> [!NOTE]
> **Lab reality: no benchtop oscilloscope, one shared multimeter.** Task 1 is a **2-hour instrument sprint**: build and compare low-cost ESP32 solutions, then agree as a class on **1–2 solutions** we use for the rest of the course. For I²C and OneWire, a **logic analyzer** with PulseView/sigrok is the right tool; for slow analog signals and PWM, a browser-based ESP32 scope is useful. Use the multimeter for reference/sanity checks and let the scope/analyzer carry the bus debugging.

> [!WARNING]
> Power off before rewiring. Check that every module's logic voltage matches 3.3 V. I²C modules with their own 5 V pull-ups can over-voltage a 3.3 V device — check before connecting. The scope/analyzer inputs are **3.3 V only**; use a divider or clamp for higher voltages and never connect to mains-referenced circuits.

### ★ Task 1: Build and Choose Our Scope — **2-hour instrument sprint**

**Goal:** by the end of this task, the class agrees on **1–2 open-source solutions** and writes down how to build, flash, and use them. Future modules use those solutions unless a documented reason forces a change.

**Candidate shortlist (all open source):**

| Candidate | What it gives you | Limits / notes |
|---|---|---|
| [lmcapacho/ESP32_LogicAnalyzer](https://github.com/lmcapacho/ESP32_LogicAnalyzer) | 16-channel SUMP logic analyzer, up to **20 MHz**, 128k samples, PulseView/sigrok | Digital only, 3.3 V; Arduino IDE; **best fit for I²C/OneWire** |
| [EUA/ESP32_LogicAnalyzer](https://github.com/EUA/ESP32_LogicAnalyzer) | SUMP/PulseView logic analyzer, I2S DMA, up to **20 MHz** | Digital only; PlatformIO; alternate codebase |
| [hepter/web-logic-analyzer](https://github.com/hepter/web-logic-analyzer) | Browser-based digital capture, export to PulseView; configurable sample rate (example: 1 MHz) | Digital only; set the correct rate when importing; easiest browser-only option |
| [BojanJurca/Esp32_oscilloscope](https://github.com/BojanJurca/Esp32_oscilloscope) | Browser scope, analog + digital, optional I2S single-channel mode | ~736 samples/screen; **not a fast-bus decoder**; Arduino IDE; MIT |
| [MatAtBread/esp-scope](https://github.com/MatAtBread/esp-scope) | Browser scope with trigger and test signal | Low-rate; ESP-IDF toolchain; nice UI, more setup |

**Recommended pairing:** one **bus analyzer** (first three rows) + one **analog web scope** (last two rows). If you adopt only one solution, choose the bus analyzer — it is the tool that actually decodes I²C/OneWire traffic.

> **Sampling rule of thumb:** for 100 kHz I²C, sample at **≥1 MS/s** to see clean edges (the Nyquist minimum is 200 kS/s, but decoding wants margin); for 400 kHz I²C, use **≥4 MS/s**. A ~700-samples/s web scope cannot decode I²C — it is for slow analog signals and PWM only.

> **Board note:** all candidates target a generic ESP32. The ESP32 Ethernet mini kit runs the same firmware; check whether the web UI expects Wi-Fi and adapt the network setup if you want Ethernet. For analog captures, use **ADC1** pins (on a classic ESP32: GPIO32–39) because Wi-Fi uses ADC2.

> **Pin-conflict warning:** the SUMP logic analyzers reserve dedicated I2S/LEDC pins (for `lmcapacho`, GPIO23 and GPIO22 by default). Do not use those pins for I2C or other signals; remap them in the config or use a separate ESP32. Draw the pin map before wiring.

> **Host software:** [PulseView / sigrok](https://sigrok.org/wiki/PulseView) is the open-source host for the logic-analyzer candidates and includes I²C and 1-Wire protocol decoders. Install it before the sprint.

1. **Split the candidates across pods.** Each pod picks one or two from the shortlist, aiming for at least one bus analyzer and one analog scope in the room. Record the repo URL and the commit/version you used. With a small cohort (e.g. 12 students = six pairs), a good split is three bus-analyzer pods, two web-scope pods, and one cross-check pod; adapt to the room.
2. **Build and flash** on your ESP32 DevKit or Ethernet mini kit. Use the project's Arduino IDE or PlatformIO instructions. Time the install: from unboxing to first capture.
3. **Test on known signals:**
   - **PWM / square wave:** generate 1 kHz on a second ESP32 (or use the board's LEDC/DAC/test output) and display it.
   - **I²C:** run an I²C scanner on SDA/SCL at 100 kHz. A scanner's address probes are enough traffic. Look for **START, address, ACK/NACK, and STOP**; with PulseView, enable the I²C decoder.
   - **OneWire (optional):** read a DS18B20 and capture the reset/presence/data pulses.
4. **Measure and record:** sample rate/timebase, whether edges are stable or missed, whether the I²C decode works, browser/OS compatibility, input voltage range and protection, and the total setup effort.
5. **Class decision:** each pod gives a **2-minute demo** of its candidate. As a class, agree on **1–2 solutions** and write `Module02/scope-decision.md`:
   - chosen solution(s) and repo/commit,
   - install steps (Arduino IDE/PlatformIO) and pin mapping,
   - sample rate/timebase and input limits,
   - what it can and cannot capture,
   - test captures (PWM, I²C, optional OneWire),
   - who owns the setup instructions.

> **Timebox:** Task 1 is the first ~2 hours. Tasks 2–6 are the rest of the studio; if time runs short, finish the bus scan/register proof and carry the conflict/stretcher work into portfolio time.

> **Suggested rhythm (2 h):** 15 min split/pick · 35 min build/flash · 30 min test PWM/I²C · 20 min record · 20 min demos + class decision.

### ★ Task 2: Wire the Bus and Scan It

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

### ★ Task 3: Read Through the Library, Then Read the Register

1. Read one sensor using its library (e.g. an environment sensor) and log values.
2. Now open the datasheet and find the register that returns the raw value (for example a temperature register). Read it directly with `Wire` and reconstruct the value using the datasheet's scaling.
3. Compare your raw reconstruction with the library output. They should agree; if not, find out why (scaling, signed vs. unsigned, byte order, bit shifting).

> This step is the difference between "it works" and "I understand it." You will need it whenever a library is missing, outdated, or wrong.

### ★ Task 4: Two Devices on One Bus

1. Add a second I²C sensor with a *different* address to the same SCL/SDA pair (no extra pins). Power and ground both.
2. Scan again: both addresses must appear.
3. Read both sensors in one sketch. Confirm that adding a device did not require new pins.
4. Note the two addresses in your portfolio and explain why they can coexist.

### ★ Task 5: Create and Resolve an Address Conflict

1. If you have two modules with the same fixed address, connect both. Scan: only one address appears, and reads become unreliable or wrong. Explain what the bus is doing electrically.
2. Resolve it in the way your hardware allows:
   - change one device's address via a jumper or a configuration register (datasheet!), or
   - use an I²C multiplexer to give each device its own channel.
3. Document the conflict and the fix — this is exactly the kind of engineering note the portfolio rewards.

### ◇ Task 6 (Stretcher): See the Bits on the Wire

With the class scope/analyzer chosen in Task 1, capture one I²C transaction:

- Identify START, the 7-bit address, the R/W bit, the ACK from the device, the data byte(s), and STOP.
- Measure the actual clock frequency and compare it with the configured speed.
- Try a longer/poorer cable or remove a pull-up and observe the signal integrity degrade. Record what you see.

## ✅ Suggested portfolio evidence (proofs of the learning goals)

1. Scope decision: chosen solution(s), repo/commit, install steps, pin mapping, sample rate, input limits, and the PWM/I²C test captures. Include one sentence on what the chosen tool cannot measure.
2. Scan artifact: serial output of at least two scans (one device, two devices), with each address mapped to its module.
3. Register proof: the raw register value you read and the reconstruction you computed with the datasheet formula, next to the library's value.
4. Address table: for each device in the kit: type, interface, address(es), and whether the address is configurable.
5. Conflict report: how you created and resolved (or would resolve) an address conflict.
6. Deeper question: Why does adding a second I²C device not need a second data pin, and what are the limits of that elegance (capacitance, address space, speed, one defective device pulling the bus down)?


> [!IMPORTANT]]
> Never commit secrets, credentials, or personal data. Where you did not work entirely alone, link your pod mates and sources.

## 📚 If you want to go deeper

- [NXP UM10204 — I²C-bus specification](https://www.nxp.com/docs/en/user-guide/UM10204.pdf) — the definitive reference for addressing, arbitration, and clock stretching.
- [Wikipedia: I²C](https://en.wikipedia.org/wiki/I%C2%B2C) — the readable overview and history.
- [Arduino Wire library](https://www.arduino.cc/reference/en/language/functions/communication/wire/) — the API you will use.
- [Linux `i2c-tools`](https://i2c.wiki.kernel.org/index.php/I2C_Tools) — the standard gateway/Pi scanner.
- [PulseView / sigrok](https://sigrok.org/wiki/PulseView) — open-source logic-analyzer software with I²C and 1-Wire protocol decoders.
- Scope/analyzer candidates from Task 1: [lmcapacho/ESP32_LogicAnalyzer](https://github.com/lmcapacho/ESP32_LogicAnalyzer), [EUA/ESP32_LogicAnalyzer](https://github.com/EUA/ESP32_LogicAnalyzer), [hepter/web-logic-analyzer](https://github.com/hepter/web-logic-analyzer), [BojanJurca/Esp32_oscilloscope](https://github.com/BojanJurca/Esp32_oscilloscope), [MatAtBread/esp-scope](https://github.com/MatAtBread/esp-scope).
- Your sensor datasheets — linked from the [resource bank](./Z-resources-bank.md#datasheets--standards-to-read-once).

---

[← Previous: Module 1](./01-foundations-measurement-and-sensor-chain.md) | [Back to front page](../README.md) | [Quick module index](./00-index.md) | [Next: Module 3 — Sensor Characterization →](./03-sensor-characterization-and-calibration.md)
