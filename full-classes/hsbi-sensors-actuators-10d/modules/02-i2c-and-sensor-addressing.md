# Module 2 – I²C & Sensor Addressing: One Bus, Many Devices

[← Back to Module 1](./01-foundations-measurement-and-sensor-chain.md) | [Quick module index](./00-index.md) | [Next: Module 3 →](./03-sensor-characterization-and-calibration.md)

> **This is the module that turns "a sensor in a library example" into "a device on a bus that you understand."** We deliberately scan and poke the bus *before* trusting a library.

## 🎯 Learning Goals

> **How these are assessed:** You earn this module's points by **proving these goals** in a short (~10-minute) checkpoint presentation with the instructor (see the [syllabus](../syllabus.md#how-module-points-are-earned-checkpoint-presentations)) — based on your portfolio and reflections, not on completing every task. You may skip tasks, fail at some, or add your own; documented exploration and demonstrated deep understanding both count in your favor.

This module gives you the opportunity to explore **sensor buses and device addressing** and achieve competency in **I²C physics and addressing, register maps, multi-device buses, and bus comparison (SPI, UART, OneWire, analog)**.

By the end of this module, you can:
1. Explain how **I²C** works physically and logically: two wires, open-drain, pull-ups, addressing, ACK/NACK, repeated start, clock stretching.
2. **Wire and scan** an I²C bus and identify every connected device by address.
3. Read a sensor through a library **and** read its raw registers directly.
4. Run **two devices on one bus** and resolve an **address conflict**.
5. Recognize when a device is I²C, SPI, UART, OneWire, or analog, and why that matters for wiring and debugging.

> [!WARNING]
> **DRAFT — first taught in WS 2026/27.** Everything below this line is a working draft and will likely change as we refine it together in class; the line moves down as we approve content. Your input is welcome and can shape this module.

**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 📖 Part A — The I²C Bus

I²C (*Inter-Integrated Circuit*) uses just **two wires** plus ground:

- **SCL** — serial clock (driven by the master, i.e. your MCU),
- **SDA** — serial data (bidirectional).

Both lines are **open-drain**: a device can only pull a line **low** or release it. The high level comes from **pull-up resistors** (typically 2.2–10 kΩ to 3.3 V). This is why a missing pull-up, or two devices both fighting the bus, is a classic failure.

### A transaction, step by step

```text
START → [ 7-bit address | R/W ] → ACK → register/data bytes → ... → STOP
```

1. The master issues a **START** condition (SDA falls while SCL is high).
2. It sends the **7-bit address** plus a **read/write bit**.
3. The addressed device answers with **ACK** (pulls SDA low) — or nobody answers, and you get a **NACK** (the "nothing there" case a scanner detects).
4. Data bytes follow, each acknowledged.
5. The master issues a **STOP** (SDA rises while SCL is high).

Common speeds are **100 kHz** (standard) and **400 kHz** (fast mode). A device may hold SCL low to slow the master down — **clock stretching**.

### The address confusion you must resolve today

- The **7-bit** address is what tools show (e.g. `0x3C` for a typical OLED, `0x68`/`0x69` for the MPU6050, `0x29` for the VL53L0X).
- Some libraries and datasheets quote the **8-bit** form, which is the 7-bit address shifted left by one (`0x3C → 0x78`). If a scan shows `0x3C` but your library wants `0x78`, this is why.
- **Address conflicts:** many sensors use a fixed address. If you connect two MPU6050s, both answer at `0x68`. Resolution options: change the address with a **jumper/pin** or **software** if the device supports it, or use an **I²C multiplexer** (TCA9548A) as a stretcher.

### Register model

Most I²C sensors are not "send a command, get a value". They expose a **register map**: you write a register address (e.g. "start a measurement", "select a range"), then read a register (or several bytes) and combine them. Datasheets for I²C sensors *are* register maps — reading them is a core skill here.

### Where does I²C sit among the buses?

| Bus | Wires | Addressing | Typical use |
|---|---|---|---|
| **I²C** | 2 + GND | 7-bit addresses on a shared bus | Many sensors, displays, IO expanders |
| **SPI** | 4+ (MOSI, MISO, SCK, CS) | Chip-select per device | Fast peripherals (RFID, SD, some ADCs) |
| **UART** | 2 (TX/RX), point-to-point | None (fixed peers), sometimes AT commands | GPS, some modules, RS-485 links |
| **OneWire** | 1 + GND | 64-bit ROM ID per device | DS18B20 temperature chains |
| **Analog / PWM** | 1 signal | None | Simple sensors, servos, dimming |

## 🛠️ In-Class Lab: Talk to the Bus

*Hardware:* 1× ESP32/ESP8266 (or M5Stack), 2× I²C sensor modules with different addresses (e.g. environment sensor + MPU6050 or VL53L0X), jumper wires, optional logic analyzer, optional Linux host or Raspberry Pi with `i2c-tools`.

> [!WARNING]
> Power off before rewiring. Check that every module's logic voltage matches **3.3 V**. I²C modules with their own 5 V pull-ups can over-voltage a 3.3 V device — check before connecting.

### ★ Task 1: Wire the Bus and Scan It (30 min)

1. Connect **SCL** and **SDA** (plus `3V3` and `GND`) to your board, using the correct pins for your board (ESP32 default is usually GPIO21=SDA, GPIO22=SCL; check your board).
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
4. **Deliberately unplug one sensor** and scan again. Note which address disappears — this is your fastest I²C debugging tool.

> **Alternative/complement:** if you have a Linux host with an exposed I²C bus, run `i2cdetect -y 1`. It shows the same map and is the standard tool on gateways and Raspberry Pis.

### ★ Task 2: Read Through the Library, Then Read the Register (35 min)

1. Read one sensor using its **library** (e.g. an environment sensor) and log values.
2. Now open the datasheet and find the **register** that returns the raw value (for example a temperature register). Read it **directly** with `Wire` and reconstruct the value using the datasheet's scaling.
3. Compare your raw reconstruction with the library output. They should agree; if not, find out why (scaling, signed vs. unsigned, byte order, bit shifting).

> **This step is the difference between "it works" and "I understand it."** You will need it whenever a library is missing, outdated, or wrong.

### ★ Task 3: Two Devices on One Bus (30 min)

1. Add a **second** I²C sensor with a *different* address to the same SCL/SDA pair (no extra pins). Power and ground both.
2. Scan again: both addresses must appear.
3. Read both sensors in one sketch. Confirm that adding a device did not require new pins.
4. Note the two addresses in your portfolio and explain why they can coexist.

### ★ Task 4: Create and Resolve an Address Conflict (25 min)

1. If you have two modules with the same fixed address, connect both. Scan: only one address appears, and reads become unreliable or wrong. Explain what the bus is doing electrically.
2. Resolve it in the way your hardware allows:
   - change one device's address via a jumper or a configuration register (datasheet!), **or**
   - use an **I²C multiplexer** to give each device its own channel.
3. Document the conflict and the fix — this is exactly the kind of engineering note the portfolio rewards.

### ◇ Task 5 (Stretcher): See the Bits on the Wire (30 min)

With a USB logic analyzer (or an oscilloscope), capture one transaction:

- Identify START, the 7-bit address, the R/W bit, the ACK from the device, the data byte(s), and STOP.
- Measure the actual clock frequency and compare it with the configured speed.
- Try a longer/poorer cable or remove a pull-up and observe the signal integrity degrade. Record what you see.

## 📝 Working-Day Reflection & Portfolio Tasks

In your portfolio under `modules/02-i2c/`:
1. **Scan artifact:** serial output of at least two scans (one device, two devices), with each address mapped to its module.
2. **Register proof:** the raw register value you read and the reconstruction you computed with the datasheet formula, next to the library's value.
3. **Address table:** for each device in the kit: type, interface, address(es), and whether the address is configurable.
4. **Conflict report:** how you created and resolved (or would resolve) an address conflict.
5. **Reflection:** Why does adding a second I²C device not need a second data pin, and what are the limits of that elegance (capacitance, address space, speed, one defective device pulling the bus down)?
