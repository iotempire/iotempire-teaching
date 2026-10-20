# Resources Bank – Sensors and Actuators

*A living cheat sheet for students and instructors. Contribute improvements via your portfolio!*

<a id="where-to-run-the-labs-your-editors-terminal"></a>
## 💻 Where to run the labs: your editor's terminal

Run the module commands in your **editor's integrated terminal** (VS Code or Zed) — you are already inside your portfolio repo, and you can run the tools on demand from there.

- **macOS / Linux:** the built-in terminal is already a Unix shell (bash/zsh). Nothing to set up.
- **Windows:** it defaults to **PowerShell**, which cannot run the heredoc (`<<'SH'`) or `<` redirection commands used in some labs. Point it at **Git Bash** once — **no extra install**, because Git Bash ships with Git for Windows:
  - **VS Code:** in the terminal, click the **⌄** beside **+** → *Select Default Profile* → **Git Bash** (auto-detected). New terminals then use bash.
  - **Zed (Windows):** the terminal follows your default system shell — set **Git Bash** (e.g. via Windows Terminal) as the default, or open the standalone **Git Bash** app.
  - **Also fine:** run the labs in **WSL** (`wsl`) for a full Linux shell.
- **PowerShell translation** (only if you must stay there): `mkdir -p Module02` → `New-Item -ItemType Directory -Force Module02`; `cmd < file` → `Get-Content file | cmd`; `time cmd` → `Measure-Command { cmd }`.

> The Arduino IDE and PlatformIO each have their own serial monitor; keep the integrated terminal for Git, `uv`, and small scripts. Do not paste multi-line C++ into a REPL — use a file and flash it.

<a id="git--github-primer-template-editor-markdown-conflicts"></a>
## 🐙 Git & GitHub primer (template, editor, Markdown, conflicts)

In class we work with **GitHub on the web** and the **Git UI inside your editor** (VS Code or Zed) — commit, fetch, pull, and push from the buttons, not the terminal. **`gh` is used exactly once: to clone your new repository.** Command-line `git`/`gh` and SSH keys are *optional*.

### Create the portfolio from the template (not a fork)

1. Open [iot-portfolio-template](https://github.com/iotempire/iot-portfolio-template) → **Use this template → Create a new repository**.
2. Name it `sensors-portfolio` and make it **public** (or at least readable by the instructor).
3. Add the instructor as a collaborator (repo → *Settings → Collaborators → Add people*).

> A **template** gives you a fresh repo with one clean commit and no upstream link; a **fork** keeps a link to the original and the full history — not what a personal portfolio wants.

### Clone it once with `gh`

```sh
gh auth login                              # GitHub.com → HTTPS → "Login with a web browser"
gh repo clone <you>/sensors-portfolio      # the ONLY gh command you need
```

Then **open the folder in VS Code or Zed** and do everything else in the editor's Git UI.

### Install the tools (once)

| OS | Install Git | Install `gh` |
|---|---|---|
| **Windows** | **Git for Windows** from [git-scm.com/download/win](https://git-scm.com/download/win), or `winget install --id Git.Git -e` (also installs **Git Bash**) | `winget install --id GitHub.cli`, or `scoop install gh` |
| **macOS** | `xcode-select --install`, or `brew install git` | `brew install gh` |
| **Linux** | `sudo apt install git` · `sudo dnf install git` | `sudo apt install gh` · `sudo dnf install gh` |

Set your identity once: `git config --global user.name "Your Name"` and `git config --global user.email "you@example.com"`.

### Day-to-day commits — in your IDE (recommended)

- **VS Code** — the **Source Control** view: stage, write a message, **Commit**, then **Sync/Push**; **Pull** when you sit down. ([docs](https://code.visualstudio.com/docs/sourcecontrol/overview))
- **Zed** — the **Git panel**: stage, commit, push/pull. ([docs](https://zed.dev/docs/git))
- **GitHub on the web** — edit any file and commit right in the browser; ideal for a quick fix or pasting a measurement table.

**What “Git proficiency” means here.** You prove it by **edits and check-ins**, not by memorizing commands: several commits with messages that say what changed; Markdown with headings, lists, tables, code fences, and **interlinks** (including pod mates' evidence); and working in your pod with changing roles.

**Learning the pieces:** [Hello World / your first commit](https://docs.github.com/en/get-started/start-your-journey/hello-world) · [create from a template](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template) · [Markdown basics](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax) · [resolve a merge conflict (GitHub editor)](https://docs.github.com/en/pull-requests/how-tos/merge-and-close-pull-requests/resolving-a-merge-conflict-on-github) · [GitHub Skills](https://skills.github.com/)

> [!TIP]
> Keep your portfolio **public** (or at least readable by the instructor) and build it up with **many small commits**, each message saying what changed — a clean `git log` is itself part of the evidence.

<a id="python-environment-with-uv-optional"></a>
## 🐍 Python environment with `uv` (optional)

You do **not** need Python for the core Arduino/IoTempower labs. If you write an integration script (for example a `paho-mqtt` logger or a measurement plotter), use a pinned `uv` environment instead of bare `pip install`:

```sh
# install uv once (macOS/Linux)
curl -LsSf https://astral.sh/uv/install.sh | sh
# Windows (PowerShell):
#   powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"

uv python install 3.14
uv python pin 3.14
uv init --name sensors-portfolio      # skip if pyproject.toml exists
uv add paho-mqtt pandas matplotlib
uv sync                               # rebuild from uv.lock after a fresh clone
uv run python plot_measurements.py
```

> Commit `pyproject.toml` and `uv.lock`; never commit `.venv/`. The lab scripts are reproducible when a reviewer can run `uv sync` and re-create your plots.

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

<a id="datasheets--standards-to-read-once"></a>
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

<a id="formulas-you-will-use"></a>
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

<a id="power--instrumentation"></a>
### 📌 Power & Instrumentation

| Tool | Use |
|---|---|
| USB power meter | Log current for strips, servos, motors; verify the power budget |
| Multimeter | Forward voltage, divider output, current draw, continuity |
| Logic analyzer (optional) | I²C transactions, PWM duty, WS2812 timing |
| Reference thermometer / lux meter | A reference for your characterization labs |

## 🧰 Tool gotchas

- **Pasting into a REPL or serial monitor** executes line by line, and some boards reset when the serial port opens. Put multi-line code in a file, save it, then flash/upload. Close the serial monitor before flashing if the port is busy.
- **Windows shell:** the labs assume bash. Use the editor's **Git Bash** profile (or WSL); PowerShell will choke on heredocs and `<` redirects. See [Where to run the labs](#where-to-run-the-labs-your-editors-terminal).
- **I²C “nothing found”:** check power, ground, SDA/SCL order, and pull-ups before suspecting the library. A known-good sensor and jumper wire save time.
- **Multimeter burden voltage:** a current measurement inserts a shunt; it can change the circuit. For motors and strips, prefer a USB power meter or a clamp/Hall sensor.
- **USB power meter sampling:** cheap meters average; they can miss short stall spikes. Note the measurement conditions.
- **Calibration references:** a “known” ice bath or phone lux meter has its own uncertainty. State it in your budget.
- **Thermal drift:** let sensors and references settle; a warm MCU or a hand on the sensor changes the reading.

<a id="troubleshooting-quick-drops"></a>
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

<a id="instructor-hints"></a>
## 🧑‍🏫 Instructor hints

**Before the first studio.** Check the kit: label every Grove module with its I²C address, keep one known-good jumper wire and one known-good sensor as a reference, and test the local broker + Node-RED on the gateway before students arrive. A USB power meter saves many “why does it reset?” conversations.

**Pods and checkpoints.** Form Task Pods of two or three on Day 1 (three is the default for a large cohort). The checkpoint schedule, the 2-pod practice round, and the video alternative are defined in the [syllabus](../syllabus.md#how-module-points-are-earned-checkpoint-presentations); run the slots from there. Assess from the portfolio, not from task completion, and keep the checkpoint a short conversation rather than a presentation rehearsal.

**Studio rhythm.** A good 4-hour session is roughly: 15 min opening/warm-up, 45–60 min pod study (concepts, pointers, LLM Q&A, study log), 10–15 min share with a neighbouring pod, a short whole-room clarification, then the lab with the remaining time for debugging and evidence. Resist the urge to lecture the concept a second time; let the pod study surface the gaps.

**Stories.** The stories in the modules are deliberately separate case studies. Keep new examples consistent with the [story canon](#story-canon-the-recurring-cast), and make a story concrete enough to pitch in a minute: one named person, one place, one moment of pain, something at stake.

**Demo day.** Ask every Project Team for a fallback recording of the live flow. Run the fault injection yourself (disconnect the sensor, block the actuator, restart the broker) and let the team explain the recovery. The rubric lives only in the syllabus.

**Slides (optional).** The workbook is the source. If you want slides, write plain Markdown separated by `---` and render a 16:9 PDF with **pandoc + Typst**; do not introduce a notebook runtime or a browser-only presentation tool. HTML comments (`<!-- note -->`) are a good place for speaker hints.

<a id="story-craft-is-it-concrete-enough"></a>
## ✍️ Story craft: is it concrete enough?

Hitting the right level of abstraction is genuinely difficult. The balance between *too abstract* ("a system for a greenhouse") and *too precise* (an already-finished specification) **is** the skill. The test: a story is concrete enough when it is **pitchable** (you can pitch it in a minute) and/or **playable** (it could carry a short film or a stage scene) — one named person, one place, one moment of pain, and something at stake.

<a id="story-canon-the-recurring-cast"></a>
## 📖 Story canon: the recurring cast

The module stories share a small cast of named (fictional) organizations and people. New material should stay consistent with them — the stories are deliberately kept as separate case studies.

| Module(s) | Organization | People | Place |
|---|---|---|---|
| 0, 1 | **Wittkamp Zerspanung GmbH** — a small CNC machine shop | **Kai Lehmann** (plant manager) | Gütersloh |
| 2, 5, 6, 9, 10 | **Lumenwerk Gütersloh GmbH** — interactive light installations | **Mara Voss** (creative director), **Jonas Feld** (embedded technician) | Gütersloh |
| 2, 5, 6, 9, 10 | **Stadtmuseum** — the exhibition client | **Aylin Demir** (curator) | Gütersloh |
| 3, 8, 9 | **Klimapark GmbH** — a greenhouse / urban-farming startup | **Dr. Elif Kaya** (agronomist), **Tobias Kern** (operations) | Gütersloh |
| 4, 7, 9 | **Brinkmann Maschinenbau GmbH** — special-purpose machines | **Hendrik Brinkmann** (workshop lead), **Sofia Roth** (automation engineer) | Bielefeld / Gütersloh |

> Cross-course consistency: Wittkamp, Frachtflow, and the local-first theme also appear in the Databases and Networking courses. Reuse the names, but keep each course's story self-contained.

<a id="extended-reading"></a>
## 📚 Extended reading

- **Measurement and uncertainty:** [Wikipedia: Measurement](https://en.wikipedia.org/wiki/Measurement) · [Accuracy and precision](https://en.wikipedia.org/wiki/Accuracy_and_precision) · [Measurement uncertainty](https://en.wikipedia.org/wiki/Measurement_uncertainty) · [GUM](https://www.bipm.org/en/publications/guides/gum.html)
- **Signals and conversion:** [Analog-to-digital converter](https://en.wikipedia.org/wiki/Analog-to-digital_converter) · [Nyquist–Shannon sampling theorem](https://en.wikipedia.org/wiki/Nyquist%E2%80%93Shannon_sampling_theorem) · [Espressif ADC documentation](https://docs.espressif.com/projects/arduino-esp32/en/latest/api/adc.html)
- **Sensors:** [Thermistor](https://en.wikipedia.org/wiki/Thermistor) · [Hall effect sensor](https://en.wikipedia.org/wiki/Hall_effect_sensor) · [Inertial measurement unit](https://en.wikipedia.org/wiki/Inertial_measurement_unit) · [VL53L0X](https://www.st.com/en/imaging-and-photonics-solutions/vl53l0x.html)
- **Actuators:** [Light-emitting diode](https://en.wikipedia.org/wiki/Light-emitting_diode) · [Pulse-width modulation](https://en.wikipedia.org/wiki/Pulse-width_modulation) · [Servomotor](https://en.wikipedia.org/wiki/Servomotor) · [Stepper motor](https://en.wikipedia.org/wiki/Stepper_motor)
- **Systems:** [IoTempower](https://github.com/iotempire/iotempower) · [MQTT essentials](https://www.hivemq.com/mqtt-essentials/) · [Node-RED](https://nodered.org/docs/) · [Control theory](https://en.wikipedia.org/wiki/Control_theory)
- **Method:** [Story-driven modeling](https://en.wikipedia.org/wiki/Story-driven_modeling) · [Challenge-based learning](https://en.wikipedia.org/wiki/Challenge-based_learning) · [Project-based learning](https://www.pblworks.org/what-is-pbl)

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
