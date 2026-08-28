> **AI-generated draft – to be edited and adapted before teaching.**

# ✨ Magic Wands – Edge & Voice Computing Workshop (4–16 h)

Voice- and motion-driven IoT: use **M5StickC** (ESP32 + mic + IMU), a **local Whisper** speech-to-text server, and **Node-RED** to turn spoken “spells” and wand gestures into visual and/or physical reactions.

The same basic idea can be run as a **4 h taste**, **8 h standard lab**, or **2-day deep-dive** with performance measurements and small research-style write-ups.

---

## 1. Concept (Draft)

- **Input 1 – Voice:** M5StickC microphone sends audio to a local Whisper instance (on a laptop/Raspberry Pi). Recognised spell words are pushed via MQTT (e.g. `spells/voice`).
- **Input 2 – Gestures:** the built-in MPU6886 IMU streams motion data; simple patterns (tap, swipe, tilt) are classified in firmware or Node-RED, published to `spells/gesture/...`.
- **Fusion:** Node-RED combines both to trigger effects: LEDs, images, dashboards, maybe a relay or servo.

> TODO: Decide minimal spell set (e.g. `fireball`, `heal`, `freeze`) and what each spell does in the room.

---

## 2. Rough Learning Outcomes

Participants should be able to:
- explain the basic architecture of an **edge pipeline**: MCU → local server → MQTT → Node-RED.
- capture spoken commands locally and turn them into text using **Whisper**.
- read IMU data from the M5StickC and detect at least one **gesture type**.
- build a simple **Node-RED flow** that merges voice + gesture into one action.

> TODO: For the long version, add explicit outcomes on measuring latency and power consumption.

---

## 3. Variants by Time Budget

| Variant | Time | Focus |
|---------|------|-------|
| **Quick taste** | ~4 h | 1–2 spells, 1–2 gestures, LED colour change only |
| **Standard** | ~8 h | add Node-RED dashboard, simple FSM, basic latency discussion |
| **Deep-dive** | 12–16 h | collect small dataset, track latency & energy, mini report / poster |

> TODO: For each variant, sketch 3–4 concrete tasks or milestones.

---

## 4. Minimal Hardware & Software Checklist

- **Per team (2–3 people):**
  - 1× M5StickC (mic + IMU)
  - USB cable & stable 5 V power
- **Per room:**
  - 1× machine capable of running `whisper.cpp` (Tiny model) locally
  - 1× MQTT broker (e.g. Mosquitto)
  - 1× Node-RED instance

> TODO: Add suggested wiring / extra hardware if we want relay, LED strip, or other tangible output.

---

## 5. High-Level Flow

1. **Bring-up:** test that M5StickC is visible via serial and can publish simple MQTT messages.
2. **Voice path:** record short audio clips → Whisper Tiny → send recognised text to `spells/voice`.
3. **Gesture path:** stream IMU values; detect a “tap” or “swipe” and send `spells/gesture/tap` or similar.
4. **Fusion:** in Node-RED, combine topics into a single “cast spell” action that triggers UI / LEDs.
5. **Show & tell:** short demos by teams (2–3 minutes each).

> TODO: Insert 1–2 Node-RED screenshots and very small code snippets once the prototype is stable.

---

## 6. Open Design Questions / Ideas

- How much of the **Whisper pipeline** should students see vs. be pre-packaged?
- Where should gesture classification live: on-device (C++ on ESP32) vs. in Node-RED or Python?
- Should long versions include a **mini benchmark** (latency histograms, power draw charts)?
- Could we reuse this workshop as a starting point for **student projects or theses** (e.g. privacy-preserving edge AI)?

> TODO: Add a short safety note about local processing of voice data and data-retention policies.

---

_Last touched: AI-draft August 2026 – please revise with concrete tasks, wiring diagrams, screenshots, and institutional details before use._
