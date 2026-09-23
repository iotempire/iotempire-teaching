# Pre-Study Guide: Sensors and Actuators (Sensorik und Aktorik)

Welcome to **Sensors and Actuators (Sensorik und Aktorik) – 10-Day Edition**!

This course is about the physical side of IoT: how a real quantity in the world becomes a trustworthy number, and how that number becomes motion, light, or heat. We keep the classical foundations — **measurement technique, error, the digital signal chain, sensor characterization, and actuator principles** — and we build them:

- **I²C and addressing:** you will scan a bus and understand where your sensors live before you trust a library.
- **Sensor principles and characterization:** distance and motion (ToF, ultrasonic, IMU), magnetic field and current (Hall), environment (T, RH, P) — with real transfer functions and calibration.
- **Actuators:** **servos and other motors**, relays, buzzers, and especially **LEDs and LED animation**.
- **Systems:** your node becomes part of a local-first **IoTempower** + MQTT + Node-RED system, extending the stack you already met in *Networking and IoT Solutions*.

See the [syllabus](./syllabus.md) for the complete course schedule and policies.

> **Canonical source:** [IoTempire Teaching repository — HSBI/GT Sensors and Actuators](https://github.com/iotempire/iotempire-teaching/tree/main/full-classes/hsbi-sensors-actuators-10d)

> [!NOTE]
> **Language:** This course is taught in English and German; the written materials are in English. You may freely use German, English, or a mixture in class and in your portfolio documentation.
>
> **Für deutschsprachige Studierende:** Diese Lehrveranstaltung wird auf Englisch und Deutsch unterrichtet; die gemeinsamen Materialien bleiben auf Englisch. Sie können im Unterricht und für Ihr Portfolio Deutsch, Englisch oder eine Mischung aus beidem verwenden.

> [!IMPORTANT]
> **Required Module 0 — 1 Module Point:** Before the first session, create your personal portfolio from the [course Git template](https://github.com/iotempire/iot-portfolio-template) and add a first pre-study entry. Include notes responding to Guiding Questions 1–8 and evidence from the **Wokwi mini-exercise** below. Module 0 is assessed during the second session.
>
> **Preparation time and access:** Plan approximately **3 to 6 hours** for the required core. You need **no special hardware and no paid account** — a laptop with a browser is enough. Wokwi may require a free account to save or share a simulation; if you cannot use it, contact the instructor through the LMS before the second session so an agreed alternative evidence (for example a hand-drawn circuit plus explanation) can be used.

> [!NOTE]
> **This pre-study guide is final for this first run.** Work through it as written — there is no need to keep checking back on it.
>
> That said, this is the **first time we run this**, so please keep your eyes open. The **main class is still in flux** and may even change based on what you experience here. Take notes as you go: anything that felt **strange**, tasks that seem **unnecessary for the main class**, or anything you found **missing**. Please share those notes with me — they directly shape the class.

---

## 1. Sensors and Actuators — The Big Picture

Almost every sensor system follows the same chain. Learn to draw it and to point at every stage:

```text
physical quantity
        |
        v
  transducer (sensor)
        |
        v
  signal conditioning
  (amplifier, divider,
   filter, reference)
        |
        v
  ADC + MCU
  (sample, filter, calibrate)
        |
        v
  system
  (MQTT, Node-RED, dashboard)
        |
        |  command
        |  (PWM / driver)
        v
  actuator
  (acts on the world)
```

Key ideas to internalize early:

- **A sensor never measures what you think directly.** It measures a physical effect (resistance, voltage, charge, light, time) that *correlates* with the quantity you want. Good work means knowing that relationship — the **transfer function**.
- **Every number carries uncertainty.** Resolution, accuracy, noise, and calibration all limit what you may claim. "23.4 °C" is a statement with conditions and an uncertainty attached.
- **Actuators are also physical.** A motor needs current and a driver; an LED needs a current-limiting resistor; a strip needs a power budget. Logic pins command; they do not power.

---

## 2. Required Mini-Exercise: Wokwi Simulation (60–90 min)

Wokwi is a browser-based ESP32/Arduino simulator. It lets you practice the signal chain before the hardware kit arrives and see the difference between a *value* and a *measurement*.

1. Open **[Wokwi](https://wokwi.com/)** and start a new **ESP32** project (C++/Arduino).
2. Recreate this **analog-in, digital-out** loop:
   - Add a **potentiometer** to the simulation and connect it to an analog input pin.
   - In the sketch, read the analog value in `setup()`/`loop()`, and print it with `Serial.println(...)`.
   - Map the reading to an **LED** (or its brightness) so that turning the potentiometer visibly changes the output.
3. Run the simulation and open the **Serial Monitor** (and, if available, the **Serial Plotter**).
4. Then extend it, and record what changes:
   - Change the ADC resolution (8 / 10 / 12 bits) and note how the integer range and the step size change.
   - Deliberately set a step size or threshold too coarse and describe why the output now "jumps".
   - **Optional (foreshadows Module 2):** add an **I²C device** from the Wokwi parts library (for example an OLED display or an IMU) and try to read it, noting the device's address.
5. Save the simulation (or take two screenshots: the circuit and the serial output) for your portfolio.

The simulation is for program flow and logic. Real hardware adds everything this course is about: board pin labels, voltage limits, loose wires, noise, offset, self-heating, and current draw. Simulation never replaces the multimeter.

---

## 3. Read Like a Sensor Engineer (45–60 min)

You will be given, or can use, a standard sensor reference such as J. Fraden, ***Handbook of Modern Sensors*** (the legacy class read the first chapters). If you do not have it, use any *two* sensor datasheets from our kit (for example the **VL53L0X** ToF sensor and the **MPU6050** IMU) and answer the same questions about them.

For one sensor, find and note:

- What physical quantity does it measure, by **which physical principle**?
- What is its **supply voltage**, **interface** (I²C / SPI / analog / PWM / OneWire), and **address** (if I²C)?
- **Range**, **resolution**, **accuracy**, **response time**, and any **temperature dependence**.
- Any conditions or limitations the datasheet warns about (e.g. target reflectance, ambient light, warm-up time, self-heating).

> **Tip:** The datasheet is a measurement document, not marketing. Look for the conditions attached to every performance number.

---

## 4. Measurement and Uncertainty Basics (45–60 min)

Look up and be able to explain, in your own words and with one concrete example from our kit:

- **True value, measurement error, and measurement uncertainty** — how do they differ?
- **Accuracy vs. precision** — draw the classic four-target picture and give an example of each case.
- **Resolution vs. accuracy** — why a 12-bit ADC does not by itself make a good sensor.
- **Systematic vs. random error** — which one does calibration address? Which one does averaging address?
- **Sampling and quantization** — what does the **Nyquist** condition require, and what does quantization error do to a small signal?

---

## 5. Actuators Primer (30–45 min)

Look up short answers for:

- **PWM (pulse-width modulation):** what is a duty cycle, and why can it dim an LED or set a servo angle?
- **LED basics:** why does every plain LED need a current-limiting resistor, and what happens without one (or with too much current)?
- **Addressable LEDs (WS2812 / NeoPixel):** what is the difference from a plain RGB LED, and why does a strip need a serious **power budget**?
- **Motors:** what is the difference between a **servo**, a **brushed DC motor**, and a **stepper** — in terms of what they are good at, and what electronics they need?
- **Isolation and drivers:** why do motors and relays need a driver (transistor/H-bridge/driver IC) rather than a direct GPIO connection?

---

## 6. Prepare Your Project Idea (30 min)

The capstone is a documented sensor/actuator system. You do not have to fix it now, but start thinking. As in the legacy offering, write a short **abstract (5–10 lines)** in your portfolio describing:

- an **application scenario** (who uses it, and why),
- the **sensors** you think it needs, and
- the **actuators** that respond.

The announcement lists example directions: liquid measurement in a forest, a **people counter with several distance sensors**, a **flow sensor with light barriers**, a **power/current sensor using the Hall effect**, **interactive LED installations**, and **music-synchronized fountains**. You may use one of these or invent your own. The abstract is a first direction, not a commitment — it may change during the course.

---

## 7. Guiding Questions for Your Portfolio

Answer these in your portfolio under `pre-study/README.md` (or `00-pre-study.md`). Include your Wokwi screenshot(s) and the connector for the datasheet notes from Section 3.

1. **The chain:** Draw the sensor → conditioning → ADC → MCU → system chain for one device you actually own (a thermometer, a scale, a phone, a car sensor). Name each stage.
2. **Wokwi observation:** In your simulation, how many discrete steps did the full analog range have? Change the ADC resolution once and report the new number. What changed — resolution, accuracy, or both?
3. **Datasheet:** For one of your chosen sensors, state its interface (I²C/SPI/analog/…), its address if applicable, and its stated accuracy *with the conditions attached*.
4. **Accuracy vs. precision:** Give one example from everyday life where a device is precise but not accurate, and one where it is accurate but not precise.
5. **I²C anticipation:** Two sensors on one bus share the same clock and data wires. What problem does that create, and what do you think the address is for? (You will answer this fully in Module 2.)
6. **Actuator choice:** For "move a small door latch once every few minutes", which actuator would you choose — and which would you not? Justify by torque, simple control, and power.
7. **LED power math:** A short WS2812 strip has 30 LEDs. Assuming each draws up to ~60 mA at full white, what current must the power supply provide, and why can the microcontroller's 5 V pin not supply this?
8. **Project abstract:** Include your 5–10 line scenario abstract from Section 6 and note which two sensors and one actuator you would start with.

---

## Ready for Day 1? Checklist

Before walking into the first lab session:
- [ ] You have created your personal GitHub portfolio from [iot-portfolio-template](https://github.com/iotempire/iot-portfolio-template).
- [ ] You have committed your pre-study notes, answers to the 8 guiding questions, your Wokwi screenshot(s), and your project abstract.
- [ ] You have your laptop ready with Arduino IDE v2 or PlatformIO installed (and, optionally, Wokwi and `i2c-tools`).
- [ ] You are ready to receive your sensor/actuator kit and to work with the course's local broker/gateway setup (Mosquitto + Node-RED).

See you in the Sensors and Actuators Lab!
