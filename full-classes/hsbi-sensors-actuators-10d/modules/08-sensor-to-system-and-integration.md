# Module 8 – From Sensor to System: MQTT & Integration

[← Back to Module 7](./07-motors-and-motion-actuators.md) | [Quick module index](./00-index.md) | [Next: Module 9 →](./09-final-project-studio.md)

> A characterized sensor and a working actuator are still not a product. Today they become a deployed system: the node publishes over MQTT to a Mosquitto broker running anywhere on the local network, a dashboard shows and controls it, and the loop closes. IoTempower is an optional declarative path you can explore.

**Course placement:** Day 8 — the integration studio, after Checkpoint 2 (Modules 4–6). A characterized sensor and a working actuator become a deployed system.

## 🎯 Learning Goals

This module gives you the opportunity to explore embedded-to-system integration and achieve competency in direct MQTT communication, topic design, filtering, Node-RED integration, and closed-loop control. Declarative IoTempower deployment is offered as an optional comparison.

By the end of this module, you can:
1. Publish sensor data and subscribe to actuator commands over MQTT from the node.
2. Design a clean, documented topic structure and handle reconnect, QoS, retain, and last-will behavior.
3. Implement at least one filter (average, median, or cutoff) in firmware and explain its latency trade-off.
4. Build a Node-RED dashboard and one closed-loop / rule-based behavior.
5. Inject faults (sensor disconnect, actuator stall, broker restart) and show graceful recovery.
6. *(Optional)* Compare your implementation with a declarative IoTempower node.


**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 📖 Story — The Greenhouse That Kept Its Own Weather

**Klimapark GmbH** has a working greenhouse and a new problem: the frost alarm, the vent fan, and the irrigation valve each run on their own controller, and none of them share a state. Operations manager **Tobias Kern** wants one dashboard and one rule: if the air temperature drops below 2 °C, close the vent, start the fan, and open the heater valve; if the sensor dies, fail safe and tell him.

Agronomist **Dr. Elif Kaya** adds the constraint that matters: *“The plants do not care whether the broker is reachable — the local loop has to keep working.”* Today you publish the sensor over MQTT, subscribe to actuator commands, process the signal with a filter in firmware, build a Node-RED dashboard, close the loop, and inject the faults that will happen in a real greenhouse. If you are curious, you can also compare this with a declarative IoTempower node — but that is an optional exploration.

## 📖 Pod Study: From Node to System

This is **self/pod study, not a lecture.** Work through the concepts below with your Task Pod, look things up, ask an LLM, and keep notes — the goal is a shared mental model you can defend in the checkpoint.

### Talking MQTT from the Node

The baseline is deliberately small: a **Mosquitto broker running anywhere in the network** and a node that speaks MQTT directly. There is no gateway in between.

- **Publish telemetry:** the node sends a reading to a topic such as `sensors/<yourname>/module08/temperature`. Any subscriber — `mosquitto_sub`, MQTT Explorer, Node-RED, or another node — can receive it.
- **Subscribe to commands:** the node listens on a command topic such as `sensors/<yourname>/module08/fan/set` and drives its actuator when a message arrives.
- **Choose a topic hierarchy and keep it stable:** for example `<site>/<node>/<device>` for telemetry and `<site>/<node>/<device>/set` for commands. Document it.
- **Know four MQTT details:** QoS (0/1/2 delivery guarantees), retain (last value kept for new subscribers), last will and testament (LWT, so a dead node is visible), and client-ID uniqueness (two clients with the same ID disconnect each other).
- **Handle disconnects:** Wi-Fi and brokers restart. Reconnect in `loop()`, resubscribe after reconnect, and keep the local control loop alive when the broker is unreachable.

Client options: `PubSubClient` on Arduino/ESP, `paho-mqtt` in Python, or `mosquitto_pub`/`mosquitto_sub` for testing from the shell.

### Optional: Declarative Deployment with IoTempower

If you want to see how a framework removes the boilerplate above, IoTempower offers a declarative alternative. It is **optional** — every learning goal in this module can be met with the direct MQTT path.

- You declare which devices are connected (sensor, actuator, display, bus), and the framework generates a robust runtime.
- You get a standardized MQTT topic scheme for free (`<node>/<device>` for telemetry, `<node>/<device>/set` for commands).
- You get Over-The-Air (OTA) updates once a node is provisioned: change the declaration, then `iot deploy` — no USB cable, ideal for a device already mounted in an installation.

### Filters: Processing in Firmware (or Declaratively)

Sensor data usually needs conditioning before it is useful. Implement the basic filters in your sketch, and only move them into a framework if you choose the optional IoTempower path:

- average / median — noise and spike suppression (Module 3 and Module 1),
- mapping/scaling — raw code → physical units, or → a custom range,
- cutoff / outlier gate — discard values outside a valid band before averaging,
- smoothing / thresholds / on-off — turning a stream into decisions.

This is where the measurement theory of Module 3 becomes an operational choice — and where you should document *why* you chose a given filter and window.

> [!TIP]
> If you use IoTempower (optional), it also provides built-in `average`, `median`, smoothing, and mapping filters. Comparing your firmware filter with a declared filter is a good stretcher exercise.

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

- MQTT essentials — [mqtt.org](https://mqtt.org/), [HiveMQ: MQTT essentials](https://www.hivemq.com/mqtt-essentials/)
- Broker — [Mosquitto documentation](https://mosquitto.org/documentation/) (run it on any host in the network)
- Arduino client — [PubSubClient](https://github.com/knolleary/pubsubclient) library
- Node-RED — [Node-RED documentation](https://nodered.org/docs/), dashboard nodes
- Optional declarative path — [IoTempower documentation](https://github.com/iotempire/iotempower) — nodes, devices, filters, `iot deploy`
- Control loops — [Wikipedia: Control theory](https://en.wikipedia.org/wiki/Control_theory), [PID controller](https://en.wikipedia.org/wiki/Proportional%E2%80%93integral%E2%80%93derivative_controller)
- Reliability patterns — the [resource bank's troubleshooting table](./Z-resources-bank.md#troubleshooting-quick-drops)

### Questions to ask an LLM (then verify against your system)

Ask your co-pilot — but treat every answer as a **claim to test**, not a fact. Good starting prompts:

- "Write a minimal `PubSubClient` sketch that publishes a sensor value and subscribes to a command topic. What reconnect, resubscribe, and last-will handling should I add?"
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

*Hardware:* 1× M5Stack node and/or a raw ESP board (ESP32 DevKit, ESP32 Ethernet mini kit, or Wemos D1 Mini) with a sensor (e.g. environment or ToF) and an actuator (relay/fan mock, LED, or servo), plus a Mosquitto broker on any host in the network (router, Raspberry Pi, or laptop) and optional Node-RED.

> [!WARNING]
> Power off before rewiring, and re-check that any motor/relay/LED load has its own supply and a common ground (Module 7).

### ★ Task 1: Publish a Sensor and Command an Actuator over MQTT

1. Start a Mosquitto broker on any host in the network (or use the one provided by the course) and note its IP address.
2. In your sketch, publish the sensor reading to a telemetry topic, for example `sensors/<yourname>/module08/temperature`.
3. Subscribe to a command topic, for example `sensors/<yourname>/module08/fan/set`, and drive an actuator (relay, LED, servo, or buzzer) when a message arrives.
4. Verify both directions from the shell:
   ```sh
   mosquitto_sub -h <broker-ip> -t 'sensors/<yourname>/module08/#' -v
   mosquitto_pub -h <broker-ip> -t 'sensors/<yourname>/module08/fan/set' -m '1'
   ```
5. Add reconnect and resubscribe handling, and document your topic hierarchy.

> [!NOTE]
> **Optional comparison:** if you also want to try the declarative path, create a fresh IoTempower system with the same sensor and actuator, for example `temperature(temp, "ENV");` and `relay(fan, "RELAY", "D1");`, flash once, and compare the generated topics with your own. This is an exploration, not a requirement.

### ★ Task 2: Process the Signal with a Filter

1. Implement an average or median filter (or a cutoff/outlier gate) in your sketch and observe the reduction in jitter.
2. Compare the raw and filtered values on the same dashboard or serial plot. State the window size you chose and why.
3. Note the added latency and whether it matters for your intended behavior.

> If you use IoTempower (optional), you can alternatively declare the same filter and compare both implementations.

### ★ Task 3: Dashboard and Rule

1. In Node-RED, build a dashboard showing the measured value (gauge + chart) and a control for the actuator.
2. Add at least one rule: a threshold with hysteresis that automatically drives the actuator (e.g. fan on/off, warning LED, servo position).
3. Verify that manual control and the automatic rule do not fight each other (document how you arbitrate them).

### ★ Task 4: Reconnect, Optional OTA, and Inject Faults

1. Restart the broker and the Wi-Fi connection; verify that the node reconnects and resubscribes automatically.
2. *(Optional)* Try an over-the-air update — `ArduinoOTA` in your sketch, or `iot deploy` if you are exploring IoTempower.
3. Inject faults and record the system's behavior:
   - Sensor fault: unplug the I²C sensor; does the node keep running and report a fault?
   - Actuator stall: block a motor/servo; observe current/behavior and any timeout.
   - Broker restart: restart Mosquitto; do the node and the dashboard reconnect and resubscribe?
4. Document each recovery (or missing recovery) — these are the seeds of the final project's resilience test.

### ◇ Task 5 (Stretcher): A Smarter Loop or a Data Log

Either:

- implement a simple P (or PI) controller for your actuator and record the step response (overshoot, settling time), comparing it with plain on/off control; or
- log the sensor stream to a local database (SQLite/InfluxDB) and plot a longer trend in Node-RED.

## ✅ Suggested portfolio evidence (proofs of the learning goals)

1. Firmware (sketch or IoTempower node definition, if used) plus the exact MQTT topics produced and consumed.
2. Filter evidence: raw vs. filtered data and the filter/window you chose, with rationale.
3. Dashboard assets: screenshot of the dashboard and the exported Node-RED flow JSON (or a CLI/subscriber capture if you did not use Node-RED).
4. Control rule: the hysteresis/control logic and how manual vs. automatic control is arbitrated.
5. Fault-injection report: the three faults and the observed recovery.
6. Deeper question: Which parts of a sensor/actuator product belong on the node, and which belong in the integration layer? Justify one split.


> [!IMPORTANT]
> Never commit secrets, credentials, or personal data. Where you did not work entirely alone, link your pod mates and sources.

## 📚 If you want to go deeper

- [mqtt.org](https://mqtt.org/), [HiveMQ: MQTT essentials](https://www.hivemq.com/mqtt-essentials/), and [Mosquitto documentation](https://mosquitto.org/documentation/) — topics, QoS, retain, LWT, and running a broker.
- [PubSubClient](https://github.com/knolleary/pubsubclient) — the Arduino MQTT client used in the baseline labs.
- [Node-RED documentation](https://nodered.org/docs/) — flows, dashboards, and context.
- [Control theory](https://en.wikipedia.org/wiki/Control_theory) and [PID controller](https://en.wikipedia.org/wiki/Proportional%E2%80%93integral%E2%80%93derivative_controller) — from on/off to proportional control.
- [IoTempower](https://github.com/iotempire/iotempower) — optional declarative nodes, filters, and OTA deployment.
- The [resource bank's troubleshooting table](./Z-resources-bank.md#troubleshooting-quick-drops) — the failures you will actually see.

---

[← Previous: Module 7](./07-motors-and-motion-actuators.md) | [Back to front page](../README.md) | [Quick module index](./00-index.md) | [Next: Module 9 — Final Project Studio →](./09-final-project-studio.md)
