# Module 8 – From Sensor to System: IoTempower & Integration

[← Back to Module 7](./07-motors-and-motion-actuators.md) | [Quick module index](./00-index.md) | [Next: Module 9 →](./09-final-project-studio.md)

> A characterized sensor and a working actuator are still not a product. Today they become a deployed system: declared in IoTempower, published over MQTT, shown and controlled in Node-RED, and closed into a control loop.

## 🎯 Learning Goals

> **How these are assessed:** You earn this module's points by proving these goals in a short (~10-minute) checkpoint presentation with the instructor (see the [syllabus](../syllabus.md#how-module-points-are-earned-checkpoint-presentations)) — based on your portfolio and reflections, not on completing every task. You may skip tasks, fail at some, or add your own; documented exploration and demonstrated deep understanding both count in your favor.

This module gives you the opportunity to explore embedded-to-system integration and achieve competency in declarative IoTempower nodes, filters, MQTT and Node-RED integration, and closed-loop control.

By the end of this module, you can:
1. Deploy a sensor and an actuator as one declarative IoTempower node.
2. Use filters for processing instead of hard-coding it in the sketch.
3. Publish a clean, documented MQTT topic structure and control an actuator from it.
4. Build a Node-RED dashboard and one closed-loop / rule-based behavior.
5. Inject faults (sensor disconnect, actuator stall, broker restart) and show graceful recovery.

> [!WARNING]
> DRAFT — first taught in WS 2026/27. Everything below this line is a working draft and will likely change as we refine it together in class; the line moves down as we approve content. Your input is welcome and can shape this module.

**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 📖 Part A — Why Declarative Deployment

By now you have written plenty of boilerplate: connect Wi-Fi, reconnect, format payloads, debounce buttons, publish periodically. IoTempower moves that into a declarative node definition:

- You declare which devices are connected (sensor, actuator, display, bus), and the framework generates a robust runtime.
- You get a standardized MQTT topic scheme for free (`<node>/<device>` for telemetry, `<node>/<device>/set` for commands).
- You get Over-The-Air (OTA) updates once a node is provisioned: change the declaration, then `iot deploy` — no USB cable, ideal for a device already mounted in an installation.

## 📖 Part B — Filters: Processing as Configuration

Sensor data usually needs conditioning before it is useful. IoTempower provides filters so that you do not re-implement them in every sketch:

- average / median — noise and spike suppression (Module 3),
- mapping/scaling — raw code → physical units, or → a custom range,
- smoothing / thresholds / on-off — turning a stream into decisions.

This is where the measurement theory of Module 3 becomes an operational, declarative choice — and where you should document *why* you chose a given filter and window.

## 📖 Part C — Integration and Control

- MQTT topics publish data and receive commands; the broker decouples sensor nodes, dashboard, and actuators in a local-first stack.
- Node-RED turns a stream into a dashboard gauge/chart, a rule, or a control command.
- Closed-loop control makes the system *act on what it measures*. Start simple:
  - On/off control with hysteresis (a dead band) — the robust default (e.g. fan on above 30 °C, off below 28 °C).
  - Proportional (P) adds an output proportional to the error; PI removes steady-state error. Tune cautiously and document the behavior.
- Safety and interlocks belong here: a maximum duty cycle, a timeout that stops a motor if commands stop arriving, and a defined state on startup.

## 📖 Part D — Failure Modes to Expect

Design for these — you will test some of them today and during the final project:

- An I²C sensor stops answering (NACK) → does the node keep running, retry, and report "sensor fault"?
- An actuator is blocked or disconnected → does current/behavior reveal it, and does the logic fail safe?
- The broker restarts → do publisher and controller reconnect and resubscribe?
- The network drops → does local behavior continue, and does the system re-sync when it returns?

## 🛠️ In-Class Lab: Close the Loop

*Hardware:* 1× M5Stack node and/or a raw ESP board (ESP32 DevKit, ESP32 Ethernet mini kit, or Wemos D1 Mini) with a sensor (e.g. environment or ToF) and an actuator (relay/fan mock, LED, or servo), plus a local broker/gateway (OpenWrt router or Linux host) running Mosquitto + Node-RED.

> [!WARNING]
> Power off before rewiring, and re-check that any motor/relay/LED load has its own supply and a common ground (Module 7).

### ★ Task 1: Declare Sensor + Actuator in One Node (35 min)

1. Create a fresh IoTempower system and a node with both a sensor and an actuator, for example:
   ```cpp
   // setup.cpp — a small sensor/actuator node
   temperature(temp, "ENV");
   // an actuator you can drive from a command topic
   relay(fan, "RELAY", "D1");     // or an LED / servo / buzzer
   ```
2. Flash once over USB, then verify the node's MQTT topics: telemetry on `<node>/temp`, commands on `<node>/fan/set`.
3. Publish a command from the CLI (`mosquitto_pub`) and watch the actuator react.

### ★ Task 2: Process the Signal with a Filter (25 min)

1. Add an average (or median) filter to the sensor and observe the reduction in jitter.
2. Compare the raw and filtered values on the same dashboard. State the window size you chose and why.
3. Note the added latency and whether it matters for your intended behavior.

### ★ Task 3: Dashboard and Rule (35 min)

1. In Node-RED, build a dashboard showing the measured value (gauge + chart) and a control for the actuator.
2. Add at least one rule: a threshold with hysteresis that automatically drives the actuator (e.g. fan on/off, warning LED, servo position).
3. Verify that manual control and the automatic rule do not fight each other (document how you arbitrate them).

### ★ Task 4: Deploy Over the Air and Inject Faults (30 min)

1. Change the node's declaration (add a device, change an interval or filter) and deploy with **`iot deploy`** — without the USB cable.
2. Inject faults and record the system's behavior:
   - Sensor fault: unplug the I²C sensor; does the node keep running and report a fault?
   - Actuator stall: block a motor/servo; observe current/behavior and any timeout.
   - Broker restart: restart Mosquitto; do the node and the dashboard reconnect and resubscribe?
3. Document each recovery (or missing recovery) — these are the seeds of the final project's resilience test.

### ◇ Task 5 (Stretcher): A Smarter Loop or a Data Log (30 min)

Either:

- implement a simple P (or PI) controller for your actuator and record the step response (overshoot, settling time), comparing it with plain on/off control; or
- log the sensor stream to a local database (SQLite/InfluxDB) and plot a longer trend in Node-RED.

## 📝 Working-Day Reflection & Portfolio Tasks

In your portfolio under `modules/08-sensor-to-system/`:
1. Node definition (`setup.cpp`) plus the exact MQTT topics produced.
2. Filter evidence: raw vs. filtered data and the filter/window you chose, with rationale.
3. Dashboard assets: screenshot of the dashboard and the exported Node-RED flow JSON.
4. Control rule: the hysteresis/control logic and how manual vs. automatic control is arbitrated.
5. Fault-injection report: the three faults and the observed recovery.
6. Reflection: Which parts of a sensor/actuator product belong on the node, and which belong in the integration layer? Justify one split.
