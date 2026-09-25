# Resources Bank – Sensors and Actuators

*A living cheat sheet for students and instructors. Contribute improvements via your portfolio!*

## 🎥 Pre-Class and In-Class Videos by Module

| Module | Topic | Suggested video | Guiding question |
|---|---|---|---|
| 1 | Measurement & uncertainty | Search for a short "accuracy vs precision" or "measurement uncertainty" explainer | Which error is systematic and which is random in your ADC reading? |
| 1 | The signal chain / ADC | A short "how an ADC works" explainer | What limits resolution? What limits accuracy? |
| 2 | I²C explained | A concise "I²C bus / addressing / clock stretching" explainer | How does a device know a message is meant for it? |
| 2 | I²C debugging | A short "logic analyzer reads I²C" demonstration | Where do you see the ACK? What does a NACK tell you? |
| 3 | Calibration & transfer function | A short sensor-calibration walkthrough | What is the difference between calibration and verification? |
| 4 | Time-of-flight vs ultrasonic | A comparison of ToF and ultrasonic distance sensing | Which fails on a black or a soft target, and why? |
| 4 | IMU / sensor fusion | A short complementary/Kalman filter intuition video | Why does the gyro drift while the accelerometer does not? |
| 5 | PWM & LED dimming | A "PWM and gamma correction" explainer | Why does a linear ramp look like it "jumps"? |
| 5 | Addressable LEDs | A WS2812 / NeoPixel overview | Why does each pixel need a driver chip? |
| 6 | LED animation | A FastLED patterns/palettes demo | How do palettes and HSV simplify effects? |
| 6 | Sound-reactive LEDs | A "music-reactive LED" build | How do you extract an envelope and avoid flicker? |
| 7 | Servo / motor / stepper | A "servo vs DC motor vs stepper" comparison | Which needs feedback, and which needs a driver? |
| 8 | IoTempower | See the course's [IoTempower docs and videos](https://github.com/iotempire/iotempower) | What does "declarative" remove from your code? |

## 📄 Datasheets & Standards to Read Once

| Document | Focus | Why it matters |
|---|---|---|
| VL53L0X datasheet | Optical ToF, registers, I²C address `0x29` | Your primary distance sensor; the register map is the lesson |
| MPU6050 register map | Accel/gyro scales, `0x68`/`0x69`, WHO_AM_I | Shows how an IMU is configured via registers |
| NTC datasheet (R25, B value) | Beta/Steinhart–Hart, tolerance | The basis of your transfer-function lab |
| WS2812B datasheet | 5 V, ~60 mA/LED full white, 800 kHz timing | Why the strip needs a power budget and level shifting |
| SG90 / servo datasheet | 50 Hz PWM, pulse widths, stall current | Why servos need their own 5 V supply |
| TB6612 / L298N datasheet | H-bridge, current ratings, flyback | Why running vs. stall current decides your driver |
| BME280 / SHT3x datasheet | I²C addresses, accuracy, self-heating | Choosing and calibrating an environment sensor |
| I²C-bus specification (NXP, UM10204) | Addressing, clock stretching, open-drain | The definitive reference behind Module 2 |

> Reminder: the datasheet is a measurement document. Every performance number has conditions attached — read them.

## 🗺️ Cheat Sheets & Quick References

### 📌 Common I²C Addresses (7-bit, typical)

| Device | Address(es) | Notes |
|---|---|---|
| SSD1306 OLED | `0x3C` / `0x3D` | Often shown as `0x78`/`0x7A` in 8-bit form |
| MPU6050 IMU | `0x68` / `0x69` | `AD0` pin selects |
| VL53L0X ToF | `0x29` | Fixed; conflicts need power-cycling or a mux |
| BME280 / BMP280 | `0x76` / `0x77` | Environment |
| SHT3x | `0x44` / `0x45` | Environment |
| ADS1115 ADC | `0x48`–`0x4B` | `ADDR` pin selects |
| PCF8574 IO expander | `0x20`–`0x27` | Jumper-selectable |
| TCA9548A I²C mux | `0x70`–`0x77` | Resolves address conflicts |

> **7-bit vs. 8-bit:** the 8-bit form is `7-bit << 1`. If a scan and a library disagree, check this first.

### 📌 Formulas You Will Use

```text
LED resistor:        R = (Vs − Vf) / I
Voltage divider:     Vout = Vs · R_lower / (R_upper + R_lower)
ADC step:            ΔV = Vref / 2^n
Code → voltage:      V = code · Vref / 2^n
NTC (Beta equation):1/T = 1/T0 + (1/B) · ln(R/R0)      [T in Kelvin]
Servo:               1.0 ms ≈ 0°, 1.5 ms ≈ 90°, 2.0 ms ≈ 180° at 50 Hz
WS2812 power:        I ≈ N_LED · 0.06 A  (full white, worst case)
```

### 📌 Power & Instrumentation

| Tool | Use |
|---|---|
| USB power meter | Log current for strips, servos, motors; verify the power budget |
| Multimeter | Forward voltage, divider output, current draw, continuity |
| Logic analyzer (optional) | I²C transactions, PWM duty, WS2812 timing |
| Reference thermometer / lux meter | A reference for your characterization labs |

## 🧰 Troubleshooting Quick Drops

| Symptom | Likely cause | Fix | Module |
|---|---|---|---|
| I²C scan finds nothing | Wiring, power, or missing pull-ups | Check SDA/SCL/power/GND; confirm pull-ups; try 100 kHz | 2 |
| Device found at an unexpected address | 8-bit vs. 7-bit confusion | Shift the address (`0x3C → 0x78`) or trust the scan | 2 |
| Only one of two identical sensors responds | Address conflict | Change the address or use a TCA9548A mux | 2 |
| Bus "locks up" after a while | One device holding SDA low / noise | Shorter wires, lower speed, power-cycle, check one device at a time | 2 |
| Sensor reading drifts with load | Self-heating or supply sag | Isolate the sensor, check supply, average | 3 |
| Reading is jumpy | Noise / no filtering | Add averaging/median, tidy wiring, add decoupling | 3 |
| Distance wrong on dark/shiny targets | Reflectance-dependent principle | Re-characterize; choose a different principle | 4 |
| Gyro angle drifts | Bias in the gyroscope | Use a complementary/Kalman filter | 4 |
| LED dims other parts of the circuit | Drawing too much from the pin/rail | Use a driver/transistor, separate supply | 5 |
| RGB "white" looks wrong | Channel imbalance / common anode mixup | Rebalance channels; check anode/cathode | 5 |
| WS2812 flickers or shows wrong colors | Data level, grounding, or power | Level shifter, common ground, data resistor, decoupling cap, power injection | 5 |
| Animation stutters | Blocking `delay()` in the loop | Use `millis()`-based timing | 6 |
| Servo jitters or the MCU resets | Servo powered from the MCU rail | Power the servo separately, common ground | 7 |
| Motor does not turn / driver hot | Undersized supply/driver, stall | Size for stall current; check H-bridge wiring and PWM enable | 7 |
| ADC reads are wildly non-linear | ESP32 ADC non-linearity near the rails | Keep the signal in the linear region; calibrate | 1, 3 |

## 📚 Software & Library Landmarks

| Use case | Tool / library | Notes |
|---|---|---|
| ESP32/ESP8266 development | Arduino IDE v2, PlatformIO | Pick one and stay consistent |
| Declarative deployment | [IoTempower](https://github.com/iotempire/iotempower) | Drivers, filters, OTA deploy |
| MQTT client (ESP) | PubSubClient | Topic + payload handling |
| Addressable LEDs | FastLED (or Adafruit NeoPixel) | Patterns, palettes, HSV |
| I²C convenience | `Wire` (Arduino core) | Scan, read/write registers |
| I²C tools (Linux) | `i2c-tools` (`i2cdetect`) | Standard bus scan on a Pi/gateway |
| Integration & dashboards | Node-RED, Mosquitto | Local-first IoT stack |
| Simulation | [Wokwi](https://wokwi.com/) | Pre-study and quick prototyping |

## 🧑‍🏫 Discussion Starters

- *"Your sensor is precise but inaccurate. Which of the two can calibration fix, and which can it not?"*
- *"A 12-bit ADC sounds great. Give one reason your real measurement is far worse than 12 bits."*
- *"You have two sensors but only one address. Name two different ways to make them coexist."*
- *"Your strip is beautiful for 10 minutes and browns out at full white. What did you forget?"*
- *"The gyro drifts and the accelerometer is noisy. Why is blending them better than choosing one?"*

## 📌 Next Steps

- Add your tricks and measurements to this page via a pull request into this class folder.
- Contribute corrected wiring, extra datasheet notes, or better calibration recipes — good candidates for bonus points.
- Reuse this bank during the final project and keep it as a reference for later projects.

*[Back to Workbook](../README.md)*
