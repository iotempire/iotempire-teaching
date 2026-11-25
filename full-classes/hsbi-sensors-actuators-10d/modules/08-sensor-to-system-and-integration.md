# Module 8 – From Sensor to System: Boundary, Local Loop & Optional MQTT

[← Back to Module 7](./07-motors-and-motion-actuators.md) | [Quick module index](./00-index.md) | [Next: Module 9 →](./09-final-project-studio.md)

> A sensor and an actuator become a system when you can say what stays on the node, what the user sees, and what the network is allowed to change. The local loop must survive the network.

**Course placement:** Day 8 — the clinic block, after Checkpoint 3 (Module 7) and after the Day 7 kickoff that formed the teams. This is a clinic, not a catalogue: you define the system boundary and close the local loop, and you may add MQTT if you take the networked track. The last block of the day is the first project build.

## 🎯 Learning Goals

By the end of this module, you can:
1. Define the system boundary: what runs on the node, what the local UI shows, and what a network interface would expose.
2. Close a local control loop with one filter and a defined safe state.
3. Test sensor disconnect, actuator stall, and noise — and, on the networked track, a broker restart.
4. Write a System Boundary Document: protocol, payloads or topics, broker, security, and failure behavior.
5. *(Optional)* Implement MQTT publish/subscribe and a dashboard or CLI.

**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 📖 Story — The Greenhouse That Kept Its Own Weather

**Klimapark GmbH** has a working greenhouse and a new problem: the frost alarm, the vent fan, and the irrigation valve each run on their own controller, and none of them share a state. Operations manager **Tobias Kern** wants one view and one rule: if the air temperature drops below 2 °C, close the vent, start the fan, and open the heater valve; if the sensor dies, fail safe and tell him.

Agronomist **Dr. Elif Kaya** adds the constraint that matters: *“The plants do not care whether the broker is reachable — the local loop has to keep working.”* That sentence is the module. You can build the greenhouse as a self-contained node with a local display and a documented network boundary (Track A), or add MQTT and a dashboard (Track B). Both are valid; both must keep the local loop alive.

## 🔀 Two tracks

- **Track A — self-contained (default).** The node senses, filters, controls the actuator, and shows or logs the data. You write the System Boundary Document.
- **Track B — networked (optional).** Add MQTT publish/subscribe and a dashboard or CLI, and test a broker restart.

The final project uses the same split; choose the track you want to defend there.

## 🛠️ The clinic

### ★ Task 1 — Draw the boundary, close the local loop

**Proves:** Goals 1, 2, and 4 · **Produces:** a working local loop and the first System Boundary Document.

1. **Choose your track** and write one sentence why.
2. **Draw the boundary.** One sensor, one actuator, a local rule, and a local UI or log. Mark what must keep working when the network is gone.
3. **Close the loop.** Read the sensor, apply one filter (average, median, or cutoff), apply a rule with hysteresis, drive the actuator, and define the safe state on startup and on sensor failure.
4. **Write the System Boundary Document** (template in Appendix A), or the topic map if you are on Track B.
5. **Log it.** In `## Study log` in `Module08/README.md`: the boundary, the filter and rule, the safe state, and the track choice.

**Done when:** the local loop keeps working with the network off, and the boundary document says what the network would change.

### ★ Task 2 — Break it on purpose

**Proves:** Goal 3 · **Produces:** a short fault log with observed behavior.

1. **Sensor disconnect:** unplug the I²C sensor. Does the node stay alive, report a fault, and enter the safe state?
2. **Actuator stall:** block the motor or servo. Does current or timing reveal it, and does the interlock react?
3. **Noise:** add a motor, longer wires, or a light source. Does the filter or hysteresis cope?
4. **Track B only — broker restart:** restart Mosquitto. Do node and dashboard reconnect and resubscribe?
5. **Log it.** One line per test: what you broke, what happened, what you changed.

**Done when:** each test has an observed result, including “it did not recover” — that is a finding, not a failure.

### ◇ Task 3 — MQTT and a dashboard (Track B)

**Proves:** Goal 5 · **Produces:** working topics, a dashboard or CLI view, and a topic map.

1. Start a broker on any host, publish the sensor value, and subscribe to a command topic.
2. Add reconnect, resubscription, and a last-will message so a dead node is visible.
3. Build a Node-RED dashboard or a small CLI view with one rule, and document how manual and automatic control are arbitrated.
4. **Log it.** The topic map, the reconnect behavior, and the dashboard link.

### ★ Task 4 — Exchange and evidence

**Proves:** Goals 1–5 · **Produces:** the agreed learning in your shared log, one shared artefact, and the evidence list below.

1. Show each other the local loop, the boundary document, and the fault log.
2. Compare tracks: what did the network add, and what did it complicate?
3. Agree on the 3–5 most noteworthy points and one learning you jointly stand behind; write the “Agreed learning (pod discussion)” note into the shared log.
4. Pick one shared artefact — the boundary document, the fault log, or the dashboard — and post it in the course Discord with one sentence on why.
5. Check the evidence list below and fill the gaps.

## ✅ Suggested portfolio evidence (proofs of the learning goals)

1. `## Study log` in `Module08/README.md` with the boundary, the local loop, and the track choice.
2. Local-loop code and wiring: sensor, filter, rule, actuator, safe state.
3. System Boundary Document (Track A) or topic map + dashboard capture (Track B).
4. Fault log: sensor disconnect, actuator stall, noise, and (Track B) broker restart.
5. One paragraph: what must stay on the node, and why.
6. Deeper question: if the network is optional, what still makes this a *system* rather than a lab circuit?

> You may prove the same goals another way. The evidence is the point, not the task list.

## 📎 Appendix A — System Boundary Document template

```text
System Boundary — <project name>

Node:                 <board, sensors, actuator, power>
Local loop:           sensor -> filter -> rule -> actuator
Safe state:           <startup, sensor failure, actuator stall>
Local UI / logging:   <display, serial, SD, plot>

Network interface (planned or implemented):
  Protocol:           <MQTT / serial / BLE / Wi-Fi / none>
  Endpoint:           <broker or peer>
  Topics / payloads:  <telemetry, commands, units, rate>
  Security:           <credentials, network, exposure>
  Failure behavior:   <what stays local, what reconnects>

What must stay local if the network drops: <...>
What the network is allowed to change:     <...>
```

## 📎 Appendix B — MQTT quick start (Track B only)

- **Publish/subscribe:** the node publishes telemetry and subscribes to a command topic; the broker decouples the node, the dashboard, and other clients.
- **Topics:** keep a stable hierarchy, for example `<site>/<node>/<device>` for telemetry and `<site>/<node>/<device>/set` for commands. Document it.
- **Four details:** QoS (0/1/2), retain (last value for new subscribers), last will and testament (a dead node becomes visible), and unique client IDs (duplicates disconnect each other).
- **Reconnect:** Wi-Fi and brokers restart. Reconnect in `loop()`, resubscribe, and keep the local loop alive while the broker is unreachable.
- **Clients:** `PubSubClient` on Arduino/ESP, `paho-mqtt` in Python, or `mosquitto_pub`/`mosquitto_sub` for testing.
- **Dashboard:** Node-RED is the usual choice; a plain MQTT subscriber or a small Python service is equally valid.
- **IoTempower:** an optional declarative alternative that generates the topic scheme and supports OTA. It is an exploration, not a requirement.
- **Security:** no credentials or personal data in the repository; use a local broker and document the exposure.

## 📎 Appendix C — Reading homework: three principles not on the bench

Module 4 gave you distance and level by ToF, ultrasound, a scale, and switches. Three handbook principles were not on that bench. Read them; the final project may need one.

- **Hydrostatic pressure.** A column of liquid produces `p = ρ · g · h` at the bottom. Measure the pressure at the lowest point and you get level without line of sight — it works in opaque, dirty, and foamy liquids, which is why it is the default in real tanks. The catch is density: diesel (≈830 kg/m³) and water (1000 kg/m³) give different pressures at the same height, so a water-calibrated level reads about 17 % low in diesel. A sealed tank needs a vent or a differential sensor. Industrial transmitters send 4–20 mA — live zero, so 4 mA is empty and 3 mA means a broken wire.
- **Triangulation.** An IR emitter and a position-sensitive detector measure the angle of the reflected spot; the fixed baseline gives the distance. Cheap and fast, but the target decides: black, mirror-like, or transparent surfaces return too little or the wrong light, and resolution falls with distance.
- **Gyroscope.** A gyro measures angular rate (deg/s), not angle. Integrate the rate and the angle drifts because a small bias accumulates; the accelerometer gives an absolute but noisy reference. Real systems fuse the two. Your BMI270 used the accelerometer half in Module 4; the gyro is the other half.

## 📎 Appendix D — Pointers and prompts

**Pointers**

- MQTT — [mqtt.org](https://mqtt.org/), [HiveMQ: MQTT essentials](https://www.hivemq.com/mqtt-essentials/)
- Broker — [Mosquitto documentation](https://mosquitto.org/documentation/)
- Arduino client — [PubSubClient](https://github.com/knolleary/pubsubclient)
- Dashboard — [Node-RED documentation](https://nodered.org/docs/)
- Optional declarative path — [IoTempower](https://github.com/iotempire/iotempower)
- Control — [Wikipedia: Control theory](https://en.wikipedia.org/wiki/Control_theory)
- Reading homework — [Pressure sensor](https://en.wikipedia.org/wiki/Pressure_sensor), [Laser rangefinder](https://en.wikipedia.org/wiki/Laser_rangefinder), [Inertial measurement unit](https://en.wikipedia.org/wiki/Inertial_measurement_unit)

**Questions to ask an LLM (then verify against your system)**

- “Given this sensor and actuator, propose a local control loop with hysteresis and a safe state. What must stay local if the network drops?”
- “Review this System Boundary Document: which fields are missing, and which failure behavior is untestable?”
- “Write a minimal `PubSubClient` sketch with publish, subscribe, reconnect, and last-will handling for this greenhouse.”
- “What does a broker restart do to a node that also runs a local control loop, and how do I test it without stopping the greenhouse?”
- “Compare hydrostatic pressure, ToF, ultrasonic, and a scale for a diesel tank. Which survives dirty fuel, foam, and a sealed tank?”

> Run each prompt against your own system, and record where the model is wrong, vague, or over-confident.

## 📚 If you want to go deeper

- [Wikipedia: Systems architecture](https://en.wikipedia.org/wiki/Systems_architecture) — layers, interfaces, and trade-offs.
- [Wikipedia: Fault injection](https://en.wikipedia.org/wiki/Fault_injection) — how to prove resilience.
- [Wikipedia: Control theory](https://en.wikipedia.org/wiki/Control_theory) — the local loop in the wider picture.
- [Module 9](./09-final-project-studio.md) — the project uses the same two tracks.

---

[← Previous: Module 7](./07-motors-and-motion-actuators.md) | [Back to front page](../README.md) | [Quick module index](./00-index.md) | [Next: Module 9 — Final Project Studio →](./09-final-project-studio.md)
