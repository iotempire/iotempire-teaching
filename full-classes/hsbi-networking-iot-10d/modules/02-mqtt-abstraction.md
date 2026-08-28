# Module 2 – MQTT Up-Front: Mocking Devices in 10 Lines of Code

[← Back to Module 1](./01-introduction.md) | [Quick module index](./00-index.md) | [Next: Module 3 →](./03-wireless-power.md)

---

## 📌 Module Outcomes
By the end of this module, you will:
1. Use **MQTT** as a flexible abstraction layer to mock and swap IoT devices (sensors/actors) rapidly.
2. Design a **mock IoT system** where a central broker routes messages between virtual and real devices.
3. Measure **integration friction**—how easily can you swap components?
4. Document your **portfolio** with screenshots, code, and reflections.

---

## 📚 Pre-Class Preparation (30 min max)

### 🎥 Watch (15 min total)
- **[MQTT for Beginners – 2aHV2Fn0I60](https://www.youtube.com/watch?v=2aHV2Fn0I60)**
  *Guiding Questions:*
  • MQTT connects devices faster than HTTP; **diagram MQTT pub/sub flow** from video frame 1:20 in your portfolio (`Week-02-Q1.png`).
  • When might HTTP still **win** over MQTT in an IoT mobile app? Compare single messages per minute vs. stream burst.

- **[How to Get Started with MQTT – Practical demo – GhjYFJqJsmY](https://www.youtube.com/watch?v=GhjYFJqJsmY)**
  *Guiding Questions:*
  • After the demo, **retrace the MQTT client steps**: broker local IP, port 1883, subscriptions—save terminal prints (`Week-02-Q2.txt`).


---

## 🛠 In-Class Lab: Mock Devices, Real Systems

### **Lab Goal**
Build a miniature **IoT system** where you can:
- **Mock a temperature sensor** in 5 lines of code.
- Swap the mock for a **real ESP32** with no other changes.
- Use **Mosquitto** as the MQTT broker.

---
### **Step 0: Node-RED Warmup – The Dashboard Awaits (5 min)**
Before touching Python/ESP32:
1. Open Node-RED on your gateway: <http://192.168.8.1:1880>
2. Open [`02-mock-sensor-flow.json`](./flows/02-mock-sensor-flow.json).
3. Confirm the **temperature topic** (`iot/room/temp`) and broker address (`192.168.8.1:1883`).
4. *Selfie:* Screenshot the Node-RED canvas and ensure the debug node shows the incoming value.

### **Step 1: Set Up Mosquitto Broker (10 min)**
*Team effort.*
1. **Install Mosquitto** on your laptop or a device:
   ```bash
   sudo apt install mosquitto mosquitto-clients  # Ubuntu/Debian
   brew install mosquitto            # macOS (Homebrew)
   ```
2. **Start the broker**:
   ```bash
   mosquitto -v
   ```
   (On OpenWRT gateway, broker should already be pre-installed at `192.168.8.1:1883`)
3. **Test connection** via gateway:
   ```bash
   mosquitto_pub -t "iot/room/temp" -m "21.5" -h 192.168.8.1
   mosquitto_sub -t "iot/#" -h 192.168.8.1
   ```
*Record screenshots:* Broker running output, terminal commands, code snippet, and debug console.

---

### **Step 2: Mock a Sensor (15 min)**
*Individual/Pair work.*
**Goal:** Publish mock sensor data using Python (or any language you prefer).

**Example Python Code (5 lines):**
```python
import paho.mqtt.client as mqtt
import time, random

def on_connect(client, userdata, flags, rc):
    client.subscribe("iot/room/#")

client = mqtt.Client()
client.connect("localhost", 1883)
client.loop_start()

while True:
    temp = round(random.uniform(18.0, 25.0), 1)
    client.publish("iot/room/temp", str(temp))  # Mock sensor
    time.sleep(5)
```

**Tasks:**
1. Run the mock sensor.
2. Verify messages arrive on `mosquitto_sub`.
3. **Document your code** in your portfolio (highlight the simplicity!)

---

### **Step 3: Swap Mock for Real Hardware (20 min)**
*Team effort.*
**Goal:** Replace the Python mock with an **ESP32** publishing real sensor data.

1. **Set up ESP32**:
   - Install [Arduino-ESP32 core](https://github.com/espressif/arduino-esp32).
   - Copy the mock code to the Arduino IDE.
   - Replace the random number generator with a **real sensor** (e.g., DHT11 for temperature/humidity).

2. **Test**:
   - Upload the code to your ESP32.
   - Verify that the broker receives messages at the same topic (`iot/room/temp`).
   - *Key Question:* Did the swap require changes to the broker or subscriber?


3. **Document** in your portfolio:
   - Screenshot of ESP32 serial monitor.
   - Side-by-side comparison: Python mock vs. ESP32 code.

---

### **Step 4: Integration Friction Audit (10 min)**
*Team reflection.*
Discuss:
1. **What was easier than expected?** (e.g., "Topics are just strings—no schema needed!")
2. **What friction did you hit?** (e.g., "WiFi keeps dropping—is that layer 1?")
3. **How would this approach scale?** (e.g., monitoring 1000 devices)

*Record key findings in your portfolio.*

---
## 📝 Portfolio Reflection Prompts
Write **your individual reflection** (1 page max) in your portfolio. Address:

### **Technical Reflection**
1. **MQTT Abstraction**:
   - How did MQTT’s **loose coupling** (publishers/subscribers) reduce integration friction?
   - Were there any **surprises** in swapping mock → real hardware? (e.g., "ESP32 needed WiFi configuration!")

2. **Tooling**:
   - What tool did you prefer for debugging? (`mosquitto_sub`, Wireshark, ESP32 serial monitor)? Why?
   - How did **MQTT’s topic structure** (`iot/room/temp`) clarify the system’s purpose?


---
### **Project Context Reflection**
3. **System Design**:
   - Describe **one scenario** where you’d use mocking in a real IoT project.
   - Example: "Before our sensors arrived, we mocked traffic with a Python script to test our gateway."

4. **Process Reflection**:
   - What’s **one workflow hack** you discovered? (e.g., "I named topics after modules to keep them organized.")
   - How did your **team collaborate** on the ESP32 setup?


5. **Future Steps**:
   - What’s **one module you’ll explore next** that builds on MQTT? (e.g., security, wireless)
   - What **one feature would you add** to your mock system? (e.g., "real-time alerts for temperature spikes")

---
## 🔧 Why This Matters
- **Mocking** lets you **build systems before hardware arrives**.
- **Abstraction** (MQTT) decouples **what you send** from **how you send it**.
- **Integration friction** is the #1 killer of IoT projects—measure it early!

---
## 📌 Resources & References
- [MQTT Protocol Specification](http://docs.oasis-open.org/mqtt/mqtt/v5.0/mqtt-v5.0.html)
- [Arduino-ESP32 MQTT Example](https://github.com/espressif/arduino-esp32/tree/master/libraries/MQTT/examples)
- [Mosquitto Broker Docs](https://mosquitto.org/documentation/)

---
## 📌 Next Steps
1. **Complete your reflection** (due before next meetup).
2. **Prepare for Module 3** by reviewing:
   - [LoRaWAN Deep Dive Video](https://www.youtube.com/watch?v=VhB1Iv7Q3HY) *(guiding Q: What’s the tradeoff between WiFi’s speed and LoRaWAN’s range?)*.
3. **Next meetup:** Bring your **ESP32 setup/notebook** and **screenshots** of your mock system!


---

*[Portfolio Template for Reflections](https://portfolio.iotempower.us)*
*Use this template for your reflections in your personal GitHub repo.*