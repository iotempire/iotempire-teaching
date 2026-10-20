# Module 8 – From Sensor to System: IoTempower & Integration

[← Back to Module 7](./07-motors-and-motion-actuators.md) | [Quick module index](./00-index.md) | [Next: Module 9 →](./09-final-project-studio.md)

> A characterized sensor and a working actuator are still not a product. Today they become a deployed system: declared in IoTempower, published over MQTT, shown and controlled in Node-RED, and closed into a control loop.

**Course placement:** Day 8 — the integration studio, after Checkpoint 2 (Modules 4–6). A characterized sensor and a working actuator become a deployed system.

## 🎯 Learning Goals

This module gives you the opportunity to explore embedded-to-system integration and achieve competency in declarative IoTempower nodes, filters, MQTT and Node-RED integration, and closed-loop control.

By the end of this module, you can:
1. Deploy a sensor and an actuator as one declarative IoTempower node.
2. Use filters for processing instead of hard-coding it in the sketch.
3. Publish a clean, documented MQTT topic structure and control an actuator from it.
4. Build a Node-RED dashboard and one closed-loop / rule-based behavior.
5. Inject faults (sensor disconnect, actuator stall, broker restart) and show graceful recovery.


**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 📖 Story — The Greenhouse That Kept Its Own Weather

**Klimapark GmbH** has a working greenhouse and a new problem: the frost alarm, the vent fan, and the irrigation valve each run on their own controller, and none of them share a state. Operations manager **Tobias Kern** wants one dashboard and one rule: if the air temperature drops below 2 °C, close the vent, start the fan, and open the heater valve; if the sensor dies, fail safe and tell him.

Agronomist **Dr. Elif Kaya** adds the constraint that matters: *“The plants do not care whether the broker is reachable — the local loop has to keep working.”* Today you declare the sensor and actuator in one IoTempower node, process the signal with a filter, publish a clean MQTT topic, build a Node-RED dashboard, close the loop, and inject the faults that will happen in a real greenhouse.

## 📖 Pod Study: From Node to System

This is **self/pod study, not a lecture.** Work through the concepts below with your Task Pod, look things up, ask an LLM, and keep notes — the goal is a shared mental model you can defend in the checkpoint.

### Why Declarative Deployment

By now you have written plenty of boilerplate: connect Wi-Fi, reconnect, format payloads, debounce buttons, publish periodically. IoTempower moves that into a declarative node definition:

- You declare which devices are connected (sensor, actuator, display, bus), and the framework generates a robust runtime.
- You get a standardized MQTT topic scheme for free (`<node>/<device>` for telemetry, `<node>/<device>/set` for commands).
- You get Over-The-Air (OTA) updates once a node is provisioned: change the declaration, then `iot deploy` — no USB cable, ideal for a device already mounted in an installation.

### Filters: Processing as Configuration

Sensor data usually needs conditioning before it is useful. IoTempower provides filters so that you do not re-implement them in every sketch:

- average / median — noise and spike suppression (Module 3),
- mapping/scaling — raw code → physical units, or → a custom range,
- smoothing / thresholds / on-off — turning a stream into decisions.

This is where the measurement theory of Module 3 becomes an operational, declarative choice — and where you should document *why* you chose a given filter and window.

### Integration and Control

- MQTT topics publish data and receive commands; the broker decouples sensor nodes, dashboard, and actuators in a local-first stack.
- Node-RED turns a stream into a dashboard gauge/chart, a rule, or a control command.
- Closed-loop control makes the system *act on what it measures*. Start simple:
  - On/off control with hysteresis (a dead band) — the robust default (e.g. fan on above 30 °C, off below 28 °C).
  - Proportional (P) adds an output proportional to the error; PI removes steady-state error. Tune cautiously and document the behavior.
- Safety and interlocks belong here: a maximum duty cycle, a timeout that stops a motor if commands stop arriving, and a defined state on startup.

### Failure Modes to Expect

Design for these — you will test some of them today and during the final project:

- An I²C sensor stops answering (NACK) → does the node keep running, retry, and report "sensor fault"?
- An actuator is blocked or disconnected → does current/behavior reveal it, and does the logic fail safe?
- The broker restarts → do publisher and controller reconnect and resubscribe?
- The network drops → does local behavior continue, and does the system re-sync when it returns?

### Pointers (start here, then keep looking)

- [IoTempower documentation](https://github.com/iotempire/iotempower) — nodes, devices, filters, `iot deploy`
- MQTT essentials — [mqtt.org](https://mqtt.org/), [HiveMQ: MQTT essentials](https://www.hivemq.com/mqtt-essentials/)
- Node-RED — [Node-RED documentation](https://nodered.org/docs/), dashboard nodes
- Control loops — [Wikipedia: Control theory](https://en.wikipedia.org/wiki/Control_theory), [PID controller](https://en.wikipedia.org/wiki/Proportional%E2%80%93integral%E2%80%93derivative_controller)
- Reliability patterns — the [resource bank's troubleshooting table](./Z-resources-bank.md#troubleshooting-quick-drops)

### Questions to ask an LLM (then verify against your system)

Ask your co-pilot — but treat every answer as a **claim to test**, not a fact. Good starting prompts:

- "What boilerplate does IoTempower remove compared with a raw Arduino sketch? List the reconnect, MQTT, and formatting code I no longer write."
- "Design an MQTT topic hierarchy for a greenhouse with several nodes, sensors, and actuators. Justify the levels and the command/state split."
- "Explain on/off control with hysteresis versus proportional control. Give me a temperature example and the trade-offs."
- "My Node-RED rule and my manual dashboard control fight each other. What arbitration patterns are used in real systems?"
- "List the failure modes of an MQTT sensor/actuator node and the smallest recovery behavior for each."

> Run each prompt against your own system, and record where the model is wrong, vague, or over-confident.

### ★ Task A: Study in your pod

Work through the concepts above with your Task Pod and fill in `Module08/study-log.md`:

1. **The references you used** — the source and the one concept you understood best from it.
2. **Things you googled** — the term, what you found, and the source (URL). One line each.
3. **Remarkable things** — surprises, "aha"s, and counterexamples from your own system.
4. **LLM Q&A** — for each prompt: the prompt, a 2–3 line summary, and **how you verified it** (and where it was wrong).
5. **Your two best found integration diagrams or topic hierarchies** — compile down to the best two, with source and what they taught you.

*Portfolio evidence:* `Module08/study-log.md`.

### ★ Task B: Explain & share with another pod

Pair with a **neighbouring pod**:

1. **Explain to each other** — each pod walks the other through its node definition, topic hierarchy, and control rule; ask questions and fill each other's gaps.
2. Agree on the **3–5 most noteworthy points** and the **learning you jointly stand behind** (e.g. *"the local loop must survive a broker restart"*).
3. **Clean up your documentation** — update your `study-log.md` with what you learned from the other pod.
4. Agree on **one shared artefact** — the best dashboard screenshot, topic diagram, or failure-mode table the two pods make together — and **post it in the course Discord**, with a one-sentence note on why you chose it.
5. Each member adds a short **“Agreed learning (pod discussion)”** section to *their own* `study-log.md`.

*Portfolio evidence:* your cleaned-up `study-log.md` (with the **“Agreed learning (pod discussion)”** section) and your pod-pair's shared artefact.

## 🛠️ In-Class Lab: Close the Loop — **Challenging**

*Hardware:* 1× M5Stack node and/or a raw ESP board (ESP32 DevKit, ESP32 Ethernet mini kit, or Wemos D1 Mini) with a sensor (e.g. environment or ToF) and an actuator (relay/fan mock, LED, or servo), plus a local broker/gateway (OpenWrt router or Linux host) running Mosquitto + Node-RED.

> [!WARNING]
> Power off before rewiring, and re-check that any motor/relay/LED load has its own supply and a common ground (Module 7).

### ★ Task 1: Declare Sensor + Actuator in One Node

1. Create a fresh IoTempower system and a node with both a sensor and an actuator, for example:
   ```cpp
   // setup.cpp — a small sensor/actuator node
   temperature(temp, "ENV");
   // an actuator you can drive from a command topic
   relay(fan, "RELAY", "D1");     // or an LED / servo / buzzer
   ```
2. Flash once over USB, then verify the node's MQTT topics: telemetry on `<node>/temp`, commands on `<node>/fan/set`.
3. Publish a command from the CLI (`mosquitto_pub`) and watch the actuator react.

### ★ Task 2: Process the Signal with a Filter

1. Add an average (or median) filter to the sensor and observe the reduction in jitter.
2. Compare the raw and filtered values on the same dashboard. State the window size you chose and why.
3. Note the added latency and whether it matters for your intended behavior.

### ★ Task 3: Dashboard and Rule

1. In Node-RED, build a dashboard showing the measured value (gauge + chart) and a control for the actuator.
2. Add at least one rule: a threshold with hysteresis that automatically drives the actuator (e.g. fan on/off, warning LED, servo position).
3. Verify that manual control and the automatic rule do not fight each other (document how you arbitrate them).

### ★ Task 4: Deploy Over the Air and Inject Faults

1. Change the node's declaration (add a device, change an interval or filter) and deploy with **`iot deploy`** — without the USB cable.
2. Inject faults and record the system's behavior:
   - Sensor fault: unplug the I²C sensor; does the node keep running and report a fault?
   - Actuator stall: block a motor/servo; observe current/behavior and any timeout.
   - Broker restart: restart Mosquitto; do the node and the dashboard reconnect and resubscribe?
3. Document each recovery (or missing recovery) — these are the seeds of the final project's resilience test.

### ◇ Task 5 (Stretcher): A Smarter Loop or a Data Log

Either:

- implement a simple P (or PI) controller for your actuator and record the step response (overshoot, settling time), comparing it with plain on/off control; or
- log the sensor stream to a local database (SQLite/InfluxDB) and plot a longer trend in Node-RED.

## ✅ Suggested portfolio evidence (proofs of the learning goals)

1. Node definition (`setup.cpp`) plus the exact MQTT topics produced.
2. Filter evidence: raw vs. filtered data and the filter/window you chose, with rationale.
3. Dashboard assets: screenshot of the dashboard and the exported Node-RED flow JSON.
4. Control rule: the hysteresis/control logic and how manual vs. automatic control is arbitrated.
5. Fault-injection report: the three faults and the observed recovery.
6. Deeper question: Which parts of a sensor/actuator product belong on the node, and which belong in the integration layer? Justify one split.


> [!IMPORTANT]
> Never commit secrets, credentials, or personal data. Where you did not work entirely alone, link your pod mates and sources.

## 📚 If you want to go deeper

- [IoTempower](https://github.com/iotempire/iotempower) — declarative nodes, filters, and OTA deployment.
- [mqtt.org](https://mqtt.org/) and [HiveMQ: MQTT essentials](https://www.hivemq.com/mqtt-essentials/) — topics, QoS, retain, and LWT.
- [Node-RED documentation](https://nodered.org/docs/) — flows, dashboards, and context.
- [Control theory](https://en.wikipedia.org/wiki/Control_theory) and [PID controller](https://en.wikipedia.org/wiki/Proportional%E2%80%93integral%E2%80%93derivative_controller) — from on/off to proportional control.
- The [resource bank's troubleshooting table](./Z-resources-bank.md#troubleshooting-quick-drops) — the failures you will actually see.

---

[← Previous: Module 7](./07-motors-and-motion-actuators.md) | [Back to front page](../README.md) | [Quick module index](./00-index.md) | [Next: Module 9 — Final Project Studio →](./09-final-project-studio.md)
