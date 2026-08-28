> **AI-generated draft – to be edited and adapted before teaching.**

# 🍎 Mini Workshop – Mastering IoT Solutions (2 h)

Short, hardware-first IoT introduction with **pre-flashed M5StickC** devices and a shared **Node-RED** instance. Participants send MQTT messages between their devices and the dashboard, then wire a **temperature sensor** and see live values.

---

## 1. Concept (Draft)

- **Goal:** Show the full path from **button press → MQTT message → Node-RED → LED / gauge update** in one room.
- **Devices:** M5StickC as pre-configured MQTT client on local Wi-Fi.
- **Flow:**
  1. Use buttons/LEDs on the stick to send/receive messages via MQTT.
  2. Add a simple temp sensor (NTC/DS18B20) to the stick and publish readings.
  3. Visualise temp and events on Node-RED dashboard.

> TODO: Add 1–2 concrete use cases (e.g. “mini first-aid room panic button” or “classroom climate overview”).

---

## 2. Learning Outcomes (Draft)

By the end participants should be able to:
- power a pre-flashed M5StickC and confirm basic connectivity.
- explain (in their own words) how **MQTT topics** and publish/subscribe work.
- wire and read a simple temperature sensor on the M5StickC.
- create or modify a **Node-RED** flow to show incoming MQTT data.

> TODO: Decide whether they also edit firmware, or keep firmware fixed and only change Node-RED.

---

## 3. Rough Structure (2 h)

| Phase | Time | Focus |
|-------|------|-------|
| Intro & hardware check | 10 min | welcome, M5StickC bring-up, Wi-Fi test |
| MQTT ping-pong | 25 min | button → MQTT → Node-RED → LED return |
| Add temperature sensor | 30 min | wire sensor, publish `teamXX/temp` |
| Dashboard extension | 20 min | gauge / simple alert in Node-RED |
| Wrap-up & reflection | 15 min | screenshots, very short reflection |

> TODO: Draft 3–5 guiding questions for reflection and short debrief script.

---

## 4. Minimal Hardware & Software Checklist

- **Per participant / pair:**
  - 1× M5StickC (pre-flashed with MQTT client)
  - 1× temperature sensor (NTC 10 kΩ or DS18B20)
  - small breadboard & 3 Dupont jumpers
  - 1× USB cable + USB power
- **Per room:**
  - 1× MQTT broker (e.g. Mosquitto on teacher laptop/router)
  - 1× Node-RED instance (e.g. via `iot service start --web`)

> TODO: Add exact wiring diagram and recommended pins for NTC/DS18B20 on the M5StickC.

---

## 5. Open Design Questions / Ideas

- Should this workshop be runnable **without internet** (local-only), or allow optional cloud MQTT broker?
- How much **Node-RED editing** vs importing pre-made flow JSON should we expect from participants?
- Add a small **challenge** at the end (e.g. change LED colour based on temp threshold or create a “chat” between two sticks).
- Optional: include a **very brief electronics intro** (resistors, pull-ups) or keep that for another workshop.

> TODO: Collect 2–3 screenshots of Node-RED flows and 1–2 photos of the hardware setup for this README.

---

_Last touched: AI-draft August 2026 – please revise with concrete pin maps, screenshots, and institutional details before use._
