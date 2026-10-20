# Module 7 – Fleet Management & Scaling with IoTempower

[← Back to Module 6](./06-industrial-protocols-and-bridging.md) | [Quick module index](./00-index.md) | [Next: Module 8 →](./08-final-project-studio.md)

**Course placement:** Day 7 — the fleet studio. A prototype becomes a fleet you can update without a USB cable.

## 🎯 Learning Goals

This module gives you the opportunity to explore IoT fleet operations at scale and achieve competency in declarative node definition, Over-The-Air deployment, and topic standardization with IoTempower.

By the end of this module, you can:
1. Explain the operational challenge of IoT fleet management: provisioning, configuration drift, and over-the-air deployment.
2. Apply IoTempower, an open-source framework for declarative IoT node definition, Over-The-Air (OTA) updates, and automated MQTT integration.
3. Configure and deploy M5Stack nodes using IoTempower's declarative syntax.
4. Orchestrate a fleet of heterogeneous nodes publishing and receiving synchronized control messages across your OpenWrt network.


**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 📖 Story — Thirty Nodes and One Ladder

**Stadtwerke Gütersloh** has a successful pilot: one M5Stack node in one substation, publishing temperature and pressure to a local broker. Network operations lead **Petra Sommer** now wants thirty nodes across the city. The pilot firmware has the Wi-Fi password, the broker IP, and the topic string hard-coded; every change means a ladder, a USB cable, and a technician.

Petra's question is operational: *"How do I change a threshold on thirty devices without visiting thirty basements?"* The answer is declarative fleet management: describe the node, not the boilerplate; deploy over the air; standardize the topic namespace. Today you turn a one-off sketch into a small fleet.

## 📖 Pod Study: The Scaling Challenge

This is **self/pod study, not a lecture.** Work through the concepts below with your Task Pod, look things up, ask an LLM, and keep notes — the goal is a shared mental model you can defend in the checkpoint.

### The "One-Off" Trap in Embedded Development
When hacking a single Arduino or ESP32 node, developers often:
- Hard-code Wi-Fi credentials, broker IP, and topic strings into C++ code.
- Plug in a USB cable every time they change a pin or adjust a threshold.
- Manually format custom JSON strings.

*What happens when you deploy 50 nodes in a factory, warehouse, or school?*
- Walking around with a laptop and USB cable to update firmware is impossible.
- Inconsistent topic names create chaos in integration dashboards.
- A changed Wi-Fi password bricks the entire fleet.

### The IoTempower Solution: Declarative Configuration & OTA
IoTempower (developed by Prof. Dr. Ulrich Norbisrath / IoTempire) shifts embedded IoT from imperative programming to declarative infrastructure-as-code:
- Configuration Over Coding: Instead of writing boilerplate Wi-Fi reconnect loops, MQTT pub/sub handlers, and debouncers, you declare what devices are connected to which pins in a clean configuration file (`setup.cpp`).
- Standardized Topic Namespaces: Every node automatically adheres to a strict, predictable MQTT topic hierarchy:
  - Telemetry: `<node>/<device>`
  - Commands: `<node>/<device>/set`
- Zero-Friction OTA (Over-The-Air) Updates: Once initially provisioned, nodes are discovered on the local network (or over Nebula). You re-flash firmware over Wi-Fi with a single command: `iot deploy <node_name>`.

```text
                                IoTempower Host
                       (Your Laptop or OpenWrt Gateway)
                                       |
                   +-------------------+-------------------+
                   | (OTA Flash via Wi-Fi)                 |
                   v                                       v
          [M5StickC Temp Node]                    [M5Atom Alert Node]
                   |                                       |
                   | MQTT Telemetry                        | MQTT Control
                   +-----------------> [Mosquitto] <-------+
                                      (OpenWrt)
```

### Pointers (start here, then keep looking)

- [IoTempower documentation](https://github.com/iotempire/iotempower) — nodes, devices, `iot flash`, `iot deploy`
- [IoTempower website](https://iotempower.us/) — examples and teaching material
- OTA update concepts — [Wikipedia: Over-the-air update](https://en.wikipedia.org/wiki/Over-the-air_update)
- MQTT topic design — [HiveMQ: MQTT essentials](https://www.hivemq.com/mqtt-essentials/)
- The [resource bank's IoTempower references](./Z-resources-bank.md#software--library-landmarks)

### Questions to ask an LLM (then verify against your node)

Ask your co-pilot — but treat every answer as a **claim to test**, not a fact. Good starting prompts:

- "What boilerplate disappears when I move from a raw Arduino MQTT sketch to an IoTempower node definition? List the reconnect, formatting, and provisioning code."
- "How does OTA flashing discover a node on the local network, and what safety checks prevent bricking it?"
- "Design an MQTT topic namespace for a 30-node municipal fleet. How do I keep telemetry and commands separate?"
- "What is configuration drift, and how does declarative configuration reduce it compared with hand-edited sketches?"
- "How would I roll out one changed threshold to thirty nodes and verify that all of them applied it?"

> Run each prompt against your own fleet, and record where the model is wrong, vague, or over-confident.

### ★ Task A: Study in your pod

Work through the concepts above with your Task Pod and fill in `Module07/study-log.md`:

1. **The references you used** — the source and the one concept you understood best from it.
2. **Things you googled** — the term, what you found, and the source (URL). One line each.
3. **Remarkable things** — surprises, "aha"s, and counterexamples from your own deployment.
4. **LLM Q&A** — for each prompt: the prompt, a 2–3 line summary, and **how you verified it** (and where it was wrong).
5. **Your two best found fleet/OTA diagrams** — compile down to the best two, with source and what they taught you.

*Portfolio evidence:* `Module07/study-log.md`.

### ★ Task B: Explain & share with another pod

Pair with a **neighbouring pod**:

1. **Explain to each other** — each pod walks the other through its node definition and its OTA deployment log; ask questions and fill each other's gaps.
2. Agree on the **3–5 most noteworthy points** and the **learning you jointly stand behind** (e.g. *"declare the node, not the boilerplate"*).
3. **Clean up your documentation** — update your `study-log.md` with what you learned from the other pod.
4. Agree on **one shared artefact** — the best topic namespace, a deployment log, or a fleet diagram the two pods make together — and **post it in the course Discord**, with a one-sentence note on why you chose it.
5. Each member adds a short **“Agreed learning (pod discussion)”** section to *their own* `study-log.md`.

*Portfolio evidence:* your cleaned-up `study-log.md` (with the **“Agreed learning (pod discussion)”** section) and your pod-pair's shared artefact.

## 🛠️ In-Class Lab: Declarative Fleet Deployment — **Challenging**

*Hardware:* 2× M5Stack nodes (e.g. M5StickC + M5Atom) + 1× OpenWrt Router.

### ★ Task 1: Setting Up the IoTempower Node Environment

1. Ensure the IoTempower CLI is active in your environment (or inside the course container / VM):
   ```bash
   iot
   ```
2. Navigate to your project directory and create a system folder:
   ```bash
   mkdir -p ~/iot/my-fleet
   cd ~/iot/my-fleet
   ```
3. Initialize the system configuration (`system.env`):
   ```bash
   # Configure Wi-Fi and MQTT broker
   wifi_ssid="IoTempire-Lab"
   wifi_password="class-password"
   mqtt_broker="192.168.8.1"
   ```

### ★ Task 2: Declarative Node Definition for M5Stack

Create a node directory for your M5StickC (`node1`):
```bash
mkdir -p node1
cd node1
```
Create `setup.cpp`:
```cpp
// Declarative IoTempower setup for M5StickC
// Built-in button A and onboard display/sensors
button(btn, "M5_BUTTON_A");

// Grove Port Environmental Sensor (SHT30 / ENV)
temperature(temp, "SHT30");
humidity(hum, "SHT30");

// RGB LED indicator
rgb_single(led, "M5_LED", "WS2812");
```

Notice what is missing: no Wi-Fi connection logic, no MQTT connect code, no reconnect timers! IoTempower generates the full robust C++ runtime automatically.

1. First Flash (USB):
   Connect your M5Stack via USB-C and run:
   ```bash
   iot flash
   ```
2. Once flashed, observe the node connect to your OpenWrt router and announce itself.

### ★ Task 3: The Magic of Over-The-Air (OTA) Updates

Now, unplug the USB cable! Power the node from a battery pack or standard USB wall charger.

1. Edit `setup.cpp` to add a new virtual device or change reporting intervals:
   ```cpp
   // Adjust report interval or add a second button
   button(btn2, "M5_BUTTON_B");
   ```
2. Deploy the update wirelessly over the network:
   ```bash
   iot deploy
   ```
3. Watch the terminal: IoTempower compiles the firmware, discovers the node via mDNS, contacts the internal OTA server on the ESP32, uploads the binary, and reboots the node—all over Wi-Fi without touching the device!

### ★ Task 4: Coordinating Fleet Actions via MQTT

1. Have your pod mate deploy a second node (`node2` — e.g. M5Atom with a relay or buzzer).
2. Look at the MQTT Explorer topic tree:
   - `node1/btn` publishes `pressed` / `released`.
   - `node1/temp` publishes `23.4`.
   - `node2/relay/set` accepts `ON` / `OFF`.
3. In Node-RED, create a simple integration link:
   - When `node1/btn` is `pressed`, publish `ON` to `node2/relay/set`.
4. Congratulations: You have built a fully declarative, wirelessly updatable, networked fleet!

## ✅ Suggested portfolio evidence (proofs of the learning goals)

1. IoTempower vs. Raw Firmware Comparison: Explain how declarative configuration changes the maintenance burden of a 100-node deployment compared to raw C++ sketches.
2. OTA Deployment Log: Include terminal output from a successful Over-The-Air (`iot deploy`) update.
3. Topic Structure Documentation: Document the exact MQTT topics generated by your IoTempower nodes.
4. Deeper question: How does combining IoTempower with an overlay network like Nebula enable remote fleet maintenance across different geographic sites?


> [!IMPORTANT]
> Never commit secrets, credentials, private keys, or device certificates. Where you did not work entirely alone, link your pod mates and sources.

## 📚 If you want to go deeper

- [IoTempower](https://github.com/iotempire/iotempower) — the declarative node model and OTA workflow.
- [IoTempower website](https://iotempower.us/) — examples and teaching material.
- [Over-the-air update](https://en.wikipedia.org/wiki/Over-the-air_update) — the general concept and its risks.
- [HiveMQ: MQTT essentials](https://www.hivemq.com/mqtt-essentials/) — the topic namespace your fleet publishes into.

---

[← Previous: Module 6](./06-industrial-protocols-and-bridging.md) | [Back to front page](../README.md) | [Quick module index](./00-index.md) | [Next: Module 8 — Final Project Studio →](./08-final-project-studio.md)
