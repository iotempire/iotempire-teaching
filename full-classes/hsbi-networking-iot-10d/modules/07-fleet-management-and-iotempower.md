# Module 7 – Fleet Management & Scaling with IoTempower

[← Back to Module 6](./06-industrial-protocols-and-bridging.md) | [Quick module index](./00-index.md) | [Next: Module 8 →](./08-capstone-project-studio.md)

---

## 📌 Module Outcomes
By the end of this session, you will:
1. Understand the operational challenge of **IoT fleet management**: provisioning, configuration drift, and over-the-air deployment.
2. Master **IoTempower**, an open-source framework for declarative IoT node definition, Over-The-Air (OTA) updates, and automated MQTT integration.
3. Configure and deploy **M5Stack nodes** using IoTempower's declarative syntax.
4. Orchestrate a fleet of heterogeneous nodes publishing and receiving synchronized control messages across your OpenWrt network.

---

## 📖 The Scaling Challenge: From 1 Prototype to a Fleet

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
**IoTempower** (developed by Prof. Dr. Ulrich Norbisrath / IoTempire) shifts embedded IoT from imperative programming to **declarative infrastructure-as-code**:
- **Configuration Over Coding:** Instead of writing boilerplate Wi-Fi reconnect loops, MQTT pub/sub handlers, and debouncers, you declare what devices are connected to which pins in a clean configuration file (`setup.cpp`).
- **Standardized Topic Namespaces:** Every node automatically adheres to a strict, predictable MQTT topic hierarchy:
  - Telemetry: `<node>/<device>`
  - Commands: `<node>/<device>/set`
- **Zero-Friction OTA (Over-The-Air) Updates:** Once initially provisioned, nodes are discovered on the local network (or over Nebula). You re-flash firmware over Wi-Fi with a single command: `iot deploy <node_name>`.

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

---

## 🛠️ In-Class Lab: Declarative Fleet Deployment

*Hardware:* 2× M5Stack nodes (e.g. M5StickC + M5Atom) + 1× OpenWrt Router.

---

### Task 1: Setting Up the IoTempower Node Environment (25 min)

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

---

### Task 2: Declarative Node Definition for M5Stack (30 min)

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

Notice what is missing: **no Wi-Fi connection logic, no MQTT connect code, no reconnect timers!** IoTempower generates the full robust C++ runtime automatically.

1. **First Flash (USB):**
   Connect your M5Stack via USB-C and run:
   ```bash
   iot flash
   ```
2. Once flashed, observe the node connect to your OpenWrt router and announce itself.

---

### Task 3: The Magic of Over-The-Air (OTA) Updates (25 min)

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
3. Watch the terminal: IoTempower compiles the firmware, discovers the node via mDNS, contacts the internal OTA server on the ESP32, uploads the binary, and reboots the node—**all over Wi-Fi without touching the device!**

---

### Task 4: Coordinating Fleet Actions via MQTT (30 min)

1. Have your teammate deploy a second node (`node2` — e.g. M5Atom with a relay or buzzer).
2. Look at the MQTT Explorer topic tree:
   - `node1/btn` publishes `pressed` / `released`.
   - `node1/temp` publishes `23.4`.
   - `node2/relay/set` accepts `ON` / `OFF`.
3. In Node-RED, create a simple integration link:
   - When `node1/btn` is `pressed`, publish `ON` to `node2/relay/set`.
4. Congratulations: You have built a fully declarative, wirelessly updatable, networked fleet!

---

## 📝 Working-Day Reflection & Portfolio Tasks

In your portfolio under `modules/07-fleet-management/`:
1. **IoTempower vs. Raw Firmware Comparison:** Explain how declarative configuration changes the maintenance burden of a 100-node deployment compared to raw C++ sketches.
2. **OTA Deployment Log:** Include terminal output from a successful Over-The-Air (`iot deploy`) update.
3. **Topic Structure Documentation:** Document the exact MQTT topics generated by your IoTempower nodes.
4. **Reflection:** How does combining IoTempower with an overlay network like Nebula enable remote fleet maintenance across different geographic sites?
