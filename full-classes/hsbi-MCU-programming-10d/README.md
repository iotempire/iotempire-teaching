# HSBI/GT Microcontroller Programming – 10-Day Extended Course

---

Welcome to the **Microcontroller Programming** course at **HSBI Campus Gütersloh**!

This repository contains your course workbook, syllabus, and modules. The course reuses the **same modules** as the condensed HSBI/GT 4-day blocked workshop, but spreads them out over **10 weeks** (roughly one 4h session per week), paced like the **University of Tartu IoT Introduction** course — **about one module per day**, with a bit of built-in flexibility.

---

## 🚀 Course Goal
Build **real embedded systems**, from blinking LEDs to full MQTT-connected sensor networks that collect, process, and act on real-world data.

You'll work hands-on with **ESP32/ESP8266 microcontrollers** (and M5StickC for the Day 1 Master Class), wire circuits, write firmware, and document your journey in a **GitHub portfolio** that doubles as a future job reference.

---

## 📚 Day-by-Day Plan

| Day  | Focus                                                                     | Points |
|------|-----------------------------------------------------------------------------|--------|
| 1    | **Module 1** – Introduction + **Master Class** (M5StickC + Node-RED)        | 1 module pt + 1 reflection pt |
| 2    | **Module 2** – Hardware and Basic Electronics                               | 2 module pts |
| 3    | **Module 3** – Infrastructure and Gateway Setup *(+ stretcher time if needed)* | 2 module pts |
| 4    | **Module 4** – Embedded Programming and Deploying Nodes *(+ stretcher time if needed, else bonus)* | 2 module pts |
| 5    | **Module 5** – Integration and Simulations                                  | 2 module pts |
| 6    | **Module 6** – IoT Systems                                                   | 2 module pts |
| 7–9  | **Module 7** – Final Project: ideation → prototyping → build → live demo    | 5 project pts + 3 reflection pts (1/day) |
| 10   | *Flexible buffer* — extra final-project time if the group needs it          | — |

This gives roughly the same total contact time as the earlier 4-day blocked version (4 × 10h = 40h), just spread out at a more relaxed pace across the semester, with **Days 7–9 fully dedicated to the final project** (ideation → build → demo), and an optional **Day 10** buffer if more time is needed.

---

## 🗂️ How to Navigate This Workbook

Start here:
```
📖 /workbook.md            ← overall course guide
🗂️ /modules/00-index.md    ← module map
🗂️ /modules/01-introduction.md → your first day
```

Every module lists learning goals, hands-on lab instructions, and expected artifacts (code, diagrams, measurements) for your portfolio.

---

## 🛠️ Key Tools & Hardware
- **Microcontrollers**: Wemos D1 Mini, ESP32, ESP8266, M5StickC (Day 1 Master Class)
- **Sensors**: DHT22, BME280, PIR, Ultrasonic, RFID (MFRC522), OLED
- **Actuators**: LEDs, RGB-LEDs, relays, motors (ULN), buzzer, stepper
- **Dev Stack**: Arduino IDE v2 / PlatformIO (VSCode)
- **Networking**: MQTT broker, Node-RED dashboards, IoTempower OTA
- **VCS**: Git & GitHub (portfolio linked via template)
- **Docs**: engineering logbook (markdown in repo)

Hardware kits issued in **Day 2 – Hardware & Electronics** lab.

---

## ✅ Grading & Portfolio

| Category               | Points | %   |
|------------------------|--------|-----|
| Module Labs + Participation (Days 1–6) | 11     | 55% |
| Reflections (Day 1 + Days 7–9) | 4      | 20% |
| Final Project (Days 7–9)      | 5      | 25% |
| **Total**             | **20**   | 100% |

- **Must pass project ≥2/5** to pass the course.
- **All artifacts live in GitHub portfolio** under permissive license (MIT/CC-BY-SA).
- **Reflections use the same standard format every time** — see the [reflection guidance in the portfolio template](https://github.com/iotempire/iot-portfolio-template/blob/main/Reflections/README.md); done after Day 1 and after each final-project day.
- **Day 1's Master Class is not a special reflection** — it's documented like any other day's work: pictures, notes on how the Node-RED/MQTT exercise and peer collaboration went, and how wiring the temperature sensor to the M5StickC (your first hands-on electronics) worked out.

---

## 🧰 Portfolio Template
Kick-off your **engineering notebook** with our template repo:
> 🔗 [https://github.com/iotempire/iot-portfolio-template](https://github.com/iotempire/iot-portfolio-template)

Fork, commit, reflect, and grow. Your portfolio is your **job reference** and **grade artifact** combined.

---

## 🏷️ A Note on Naming: IoTempire vs. IoTempower
- **IoTempire** is the organization behind all our IoT activities — courses, tools, and community: [https://iotempire.net/](https://iotempire.net/)
- **IoTempower** is the specific open-source framework we use for device management, flashing, and integration throughout this course: [https://iotempower.us](https://iotempower.us) (resolves to the GitHub project at [github.com/iotempire/iotempower](https://github.com/iotempire/iotempower))

---

## 🆘 Support & Etiquette
- **Technical issues?** Open a GitHub issue with screen shots & serial logs.
- **Need help?** Schedule 10-minute TA huddles during lab or via Discord.
- **Academic integrity:** Cite sources; ask early if unsure.
- **Collaboration:** Review teammates' PRs; share discoveries openly.
- **Hardware can break.** Keep logs, power-cycle, scope the pins.

---

## 🏁 Final Project Checklist (Days 7–9)
1. **Idea:** user story + problem statement in README
2. **Architecture:** block diagram + data flow + failure modes
3. **Hardware:** ≥3 MCUs, sensors & actors wired & tested
4. **Firmware:** C/C++ source with comments & OTA tokens
5. **Integration:** MQTT → gateway → Node-RED → dashboard
6. **Documentation:** README + short reflection
7. **Demo:** live showcase + Q&A

---

## 📜 License & Open by Default
All course artifacts (code, logs, schematics) are published under the **MIT License** unless otherwise specified.

Why? So you can **reuse**, **remix**, and **showcase** your work without friction.

---

## 🚀 Go Ahead

```bash
# Clone your portfolio template to get started
git clone https://github.com/iotempire/iot-portfolio-template.git my-portfolio
git remote add upstream https://github.com/iotempire/iotempire-teaching.git
```

Now open your workbook and jump into **Module 1 – Introduction** 👇

> 📖 [/modules/01-introduction.md](./modules/01-introduction.md)
