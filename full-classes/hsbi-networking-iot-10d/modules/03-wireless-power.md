# Module 3 – Wireless IoT: Fat vs. Fit – WiFi vs. LoRaWAN Tradeoffs

[← Back to Module 2](./02-mqtt-abstraction.md) | [Quick module index](./00-index.md) | [Next: Module 4 →](./04-routing-gateways.md)

---

## 📌 Module Outcomes
By the end of this module, you will:
1. Compare **WiFi** and **LoRaWAN** for power, range, bandwidth, and cost in IoT systems.
2. Profile a real device’s power draw using a **USB power meter** and **software tools**.
3. Measure **latency** (round-trip time) and **throughput** differences between protocols.
4. Apply the results to optimize your project’s connectivity choice.

---
## 🎯 Node-RED Dashboard – Bring WiFi vs. LoRaWAN Alive (15 min)
1. Open Node-RED (<http://192.168.8.1:1880>).
2. Import [`03-wifi-lora-dashboard.json`](./flows/03-wifi-lora-dashboard.json).
3. Both **charts** (`WiFi_rssi`, `LoRa_rssi`) and **gauge** (`power_mA`) will auto-fill once boards begin publishing.
   *Deliverable:* Screenshot of dashboard after 30 sec logging.

---
## 📚 Pre-Class Preparation (30 min max)

### 🎥 Watch (15 min total) – use your IoT playlist
- **[v2kV6pgJxuo – IoT playlist item 2](https://www.youtube.com/watch?v=v2kV6pgJxuo&list=PLlppUpfgGsvkfAGJ38_mzQc1-_Z7bNOgq&index=2&pp=iAQB)** *(Paul Clark on WiFi vs. BLE vs. LoRa – focusing on latency & power sections)*
  *Guiding Questions (add to portfolio reflection `03-wireless.md`):*
  • At 6:40 the video shows a **power**-latency scatter; **re-create the scatter plot with 4 points** (your measured WiFi vs. LoRa) in your Google-Sheets/ASCII under `03-scatter.csv`.

- **[jJaWMWz6RpE – IoT playlist item 3](https://www.youtube.com/watch?v=jJaWMWz6RpE&list=PLlppUpfgGsvkfAGJ38_mzQc1-_Z7bNOgq&index=3&t=2s&pp=iAQB)** – quick LoRa basics refresher *(30 s intro + payload size comparison)*
  *Guiding Question:*
  • What is the **maximum payload length** of LoRa before fragmentation is required?


---

## 🛠 In-Class Lab: Profile WiFi vs. LoRaWAN

### **Lab Goal**
Build a **side-by-side testbed** to measure:
- Power consumption (`mA`)
- RSSI (signal strength)
- Latency (round-trip time from sensor → broker → subscriber)
- Payload throughput (bytes/second)

**Hardware per team:**
- 1x **ESP32-WiFi** (e.g., NodeMCU)
- 1x **ESP32-LoRa** (e.g., TTGO Lora32)
- 1x **USB power meter** (or phone multimeter app if no hardware available)
- 1x **MQTT broker** (your Mosquitto instance from Module 2)

---

### **Step 1: Connect Power Meters & Sensors (10 min)**
1. **Power setup:**
   - Plug each ESP32 into a **USB power meter** or connect to a PC. Note baseline current (~50–100 mA for ESP32).
   - Connect a **DHT11** (temperature/humidity) to both boards for consistency.
   - Ensure both devices connect to the **same MQTT broker**. 

2. **Sensor firmware setup:**
   - Use the **same MQTT publish code** from Module 2 (adapted for each board):
     ```cpp
     // ESP32-WiFi (using WiFi) version
     #include <WiFi.h>
     #include <PubSubClient.h>
     
     void setup() {
       WiFi.begin("YOUR_SSID", "YOUR_PASSWORD");
       client.setServer("192.168.1.100", 1883);
     }
     ```
     ```cpp
     // ESP32-LoRa (using LoRa32) version
     #include <LoRa.h>
     #include "mqtt_esp32.h"
     ```
   - *Goal:* Same measurement topic (`iot/room/temp`), same broker.

*Record screenshots:* Power meter readings, device wiring, firmware snippets.

---

### **Step 2: Measure Power Consumption (15 min)**
**WiFi Mode:**
1. Measure **baseline** (ESP32 idle, no WiFi): ~50 mA
2. Measure **active** (WiFi connected, publishing every 5 sec): ___ mA
3. **Duty cycle planning**:
   - If your sensor is outdoors, how many tx/hour would keep a 500mAh coin cell **alive for 1 year**?

*Formula hint:*
`battery_life_hours = battery_capacity_mAh / avg_current_mA`

---

**LoRa Mode:**
1. Measure **baseline** (LoRa idle): ~20 mA
2. Measure **active** (LoRa transmitting every 5 sec): ___ mA
3. Compare:**
   - Which protocol saves **more battery**?
   - How does **range** affect power? (Bring your boards closer/farther)

Record readings in a table:
| Metric               | WiFi (ESP32) | LoRa (ESP32) |
|----------------------|---------------|--------------|
| Baseline Current     | ___ mA        | ___ mA       |
| Active Current       | ___ mA        | ___ mA       |
| Approx. battery life | ___ hours     | ___ hours    |
| Max Range (indoors) | ___ meters    | ___ meters   |

---

### **Step 3: Measure Latency & Throughput (20 min)**
**Lab tools:**
- **Wireshark** (on your PC) + **MQTTX** (client)
- **ESP32 serial monitor**

**Steps:**
1. **Latency test:**
   - Publish a timestamped message from each ESP32.
   - Use `current_time_ms = millis()` in firmware to capture publish time.
   - Use MQTTX to subscribe and **log timestamp** on arrival:
     ```bash
     mosquitto_sub -t "iot/room/temp" -h localhost | while read line; do echo "$(date +%s%3N) $line"; done > timestamps.csv
     ```
   - Calculate **round-trip time** (RTT):
     `RTT = (subscriber_receive_time - publisher_send_time) in ms`

2. **Throughput test:**
   - Subscribe to a topic with `mosquitto_sub` and measure how many **messages/sec** you receive.
   - Compare: WiFi (high throughput) vs. LoRa (low throughput).

3. **Record:**
   - Save CSV files and screenshots in your portfolio.

   - Answer: *Which protocol feels "snappier" for your use case?*


---

### **Step 4: Range & Obstacle Test (10 min)**
1. **Walk-test:** Take both devices outside (or to different rooms).
   - Record **RSSI** (received signal strength indicator) at 1m, 10m, 50m.
   - Note when messages drop (WiFi vs. LoRa).
2. **Obstacle challenge:**
   - Try placing devices behind metal, through walls, or underground.
   - Answer: *Which protocol wins in your environment?*


---

### **Step 5: Team Debate – Choice Matrix (10 min)**
**Prompt:** "Your project requires **3 years of battery life**, **10 km range**, and **100 kB/sec throughput**. Which protocol do you pick—and why?"

*Grid to fill:*
| Criterion           | WiFi | LoRa  | Cellular |
|---------------------|------|--------|----------|
| Power Efficiency     |      |        |          |
| Range              |      |        |          |
| Throughput         |      |        |          |
| Latency            |      |        |          |
| Cost ($ - $$$)     |      |        |          |

*Consensus:* Choose 1 priority and justify.


---
## 📝 Portfolio Reflection Prompts
Write **your individual reflection** (1–2 pages) in your portfolio. Address:

### **Technical Reflection**
1. **Power vs. Range:**
   - What **1 rule of thumb** would you give for choosing between WiFi and LoRaWAN?
   - Was the **3.x hour ESP32 experiment** surprising? Why?

2. **Latency & Throughput:**
   - What’s the **minimum RTT** you measured for each protocol?
   - How would **10Mbps WiFi** vs. **0.5kbps LoRa** impact your project?


---
### **Project Context Reflection**
3. **Design Choice:**
   - Sketch your **top 3 requirements** (e.g., "99.9% uptime", "0–100m range").
   - Which protocol **best matches your goals**? What are the tradeoffs?
4. **Process Reflection:**
   - What hack fixed a bug fastest? (e.g., `mosquitto_sub -t "+" -v` to debug all topics)
   - How did **dividing labor** (WiFi vs. LoRa tests) go?


---
### **End-to-End Question**
5. **Future Steps:**
   - Contemplated a **‘design pattern’** you noticed:
     - Example: "Use LoRa for uplink, WiFi for downlink in gateways."
   - What’s **one tool/strategy** that would make tomorrow’s tests faster?

---
## 🔧 Why This Matters
- LoRaWAN **doesn’t replace WiFi**—both have roles in real systems.
- **Power profiling** can make or break a product’s success.
- **Latency vs. range vs. cost** are tradeoffs you’ll negotiate for life.

---
## 📌 Resources & References
- [ESP32 WiFi Power Draw Analysis](https://github.com/espressif/arduino-esp32/issues/3234) *(GitHub)*
- [LoRaWAN 1.0 Specification](https://lora-alliance.org/resource-hub/lorawanr-specification-v100)
- [Wireshark IoT Cheat Sheet](https://github.com/satta/cheat-sheet#iot)
- [ESP32 LoRa Library](https://github.com/LoRa-net/LoRa)

---
## 📌 Next Steps
1. **Complete your reflection** (due before next meetup).
2. **Prepare for Module 4** by reviewing:
   - [Raspberry Pi as Gateway Video](https://www.youtube.com/watch?v=6Nz7Xv7sLqM) *(guiding Q: What’s the role of a gateway in routing traffic between WAN and LAN?)*
3. **Next meetup:** Bring your **WiFi/LoRa devices**, **power meter readings**, and **latency CSV**!


---
*[Portfolio Template for Reflections](https://portfolio.iotempower.us)*
*Reminder: Use the shared template for your submissions.*