# Module

[← Back to Module 5](./05-industrial-protocols.md) | [Quick module index](./00-index.md) | [Next: Module 7 →](./07-final-project-rehearsal.md)

---

## 📌 Module Outcomes
By the end of this session you’ll be able to:
- Profile an IoT node’s **CPU power states** and **WiFi power modes** (ESP32).
- Tune **radio duty cycles** and **sensor polling** for maximal battery life.
- Compare **latency vs. power** trade-offs in a real prototype.

---

## 📚 Pre-Class Homework (25 min max)

### 🎥 Watch (10 min total)
- **[LoRa vs WiFi power draw (Paul Clark)](https://www.youtube.com/watch?v=fFoRz2q2yqA)**
  *Guiding Questions:*
  • How many messages per day can you afford if the **battery budget is 500 mAh**? Solve a **simple linear equation** in `portfolio/06-readings.txt`.
  • What **sleep interval** keeps latency <2 s but still hits 6-month life on a coin cell?


- *(OPTIONAL)*[ESP32 deep sleep video – for curiosity](https://www.youtube.com/watch?v=ZvfA1XxjVa4) – use only if your power trace surprises you.



---
### 📖 Read (10 min total)
- [ESP32 Technical Reference: Power Management](https://www.espressif.com/sites/default/files/documentation/esp32_technical_reference_manual_en.pdf) *(pp 13-20 – skim power tables)*
- [ARM Cortex-M Power Modes Cheat Sheet](https://developer.arm.com/documentation/100730/0601/Power-management/Power-modes-and-sleep-cycles)
  *(Understand the contrast between *WFI* and WFE)


---
## 🛠 In-Class Lab: Profile & Optimize Your Prototype

**Goal:** Take your ESP32 project from "works in lab" → "survives 6 months on coin cell".


**Hardware per student/team:**
- 1x ESP32 (NodeMCU clone ok)
- 1x 500 mAh LiPo or 3V coin cell (or USB power probe)
- 1x **DHT11** or **BME280** sensor (or use built-in ADC)
- 1x **USB power meter** or **ShakeBug / AEOtech knockoff**
- 1x Multimeter with mA measuring shunt for fine grained traces

**Software:**
- Arduino IDE / ESP-IDF
- `esp-deep-sleep`, `WiFi`, `PubSubClient` libraries
- Wireshark/TCPdump
- **FreeRTOS idle hook** if advanced

---

### **Step 1: Baseline Power Profile (15 min)**
1. Plug ESP32 into power meter.
2. Clone a **fresh minimal MQTT publisher** (no debugging Serial prints):

```cpp
#include <WiFi.h>
#include <PubSubClient.h>

typedef struct {
  unsigned long lastMsg = 0;
  #define MSG_INTERVAL 5000  // publish every 5 sec
} PubStats;

PubStats stats;
WiFiClient net;
PubSubClient client(net);

void setup() {
  WiFi.begin(ssid,pass);
  client.setServer(mqtt_server,1883);
}

void reconnect() {
  while (!client.connected()) { client.connect("espMin"); }
}

void loop() {
  if (millis() - stats.lastMsg > MSG_INTERVAL) {
     client.publish("temp", "22.5");
     stats.lastMsg = millis();
  }
  client.loop();
}
```

3. **Run 2 mins clock**—measure average current (max/min/average).
4. Open Wireshark, capture WiFi traffic on channel.
   *Task: screenshot power graph (min 1 min sample) + Wireshark 802.11 headers.*

---

### **Step 2: Power States Analysis (15 min)**
| State          | ESP32 mA (typical) | Observation          |
|----------------|-----------------------|---------------------|
| Active         | 50–100               | Full WiFi TX/RX     |
| WiFi idle      | 15–30                | Beacon listening    |
| Light Sleep    | 0.8–1.5 mA per 10 ms | Timer wake           |
| Deep Sleep     | 5–20 µA              | RAM off            |


**Experiment:**
- Switch to `ESP.deepSleep(5000000)` (5 minute sleep).
- Measure current during wake → sleep transition.
- *Task: Photo power profile (peak surge 800 mA shown in screenshot).*



---

### **Step 3: Sweep Transmit Interval (15 min)**
Set up a **spreadsheet** and measure **battery life** vs **sensor interval**:

| Sleep Interval secs | Messages/day | mAh/day (at 100 mA average TX) | Life on 500 mAh |
|--------------------|---------------|-------------------------------------|------------------|
| 5                  | 17280         | 17.3                               | 29 days          |
| 10                 | 8640          | 8.64                                | 58 days          |
| 30                 | 2880          | 2.88                                | 174 days         |
| 60                 | 1440          | 1.44                                | 347 days         |

**Lab:**
- Program ESP32 to report every 10/30/60/300 seconds.
- Measure average current per interval with power meter.
- *Task: Export CSV table to portfolio `battery_life_module6.csv`* 



---
### **Step 4: Latency Checkpoint (10 min)**
**Question:** Does deep sleep **increase latency**?
- Re-run **RTT test** (Module 3):
  - ESP32 wakes, connects to WiFi, publishes, goes back to sleep.
  - Note 95-percentile ‘cold’ RTT.
  - Compare to **idle-connected constant TX loop**.

**Latency Acceptance**
- Is 2 sec acceptable for a garage door open/close sensor?
- Is 0.2 sec required for bidirectional dimming?
*Task: Record cold start times and portfolio* latency_chart_module6.png.


---

### **Step 5: Power Bug Hunt (15 min)**
**Instructor shares:**
A ‘broken’ ESP32 preset that leaks 50 mA in deep sleep (Serial.begin 115200 at 2 µA target moment).

**Steps:**
1. Use **multimeter current shunt** on 3v3 pin.
2. Comment out `Serial.begin()`—re-measure.
3. Did current drop from 50 → 5 µA?

4. *Task: Bitmap/photo of shunt meter before/after fix*.

---

### **Step 6: OTA vs. Battery (Stretch 10 min)**
- Does **over-the-air update** spike power for 100 ms (OTA flasher)?
- How often would you **limit OTA pushes** in prod devices?
*Task: Note in portfolio under *policy design decisions*.


---
## 📝 Portfolio Reflection Prompts
Write your reflection (1–2 pages) addressing:

### **Data-Driven Reflection**
1. **Power Math**
   - Calculate your **worst-case battery life** (coin cell 500 mAh). Do you hit 6 months, 1 year, or fail?
   - What **single line of code** saved the most mAh in your project?

2. **Latency Pain**
   - What **threshold RTT** did you set for customer acceptance? (e.g., <2 s for LED status)
   - Does deep sleep **break** your latency budget? How did you negotiate the trade-off?


---
### **Project Context**
3. **Scenario Planning**
   - Re-design your project if the battery **quadruples** (2000 mAh). How does footprint grow?
   - What **power-hungry misfeature** did you eliminate? (Be honest!)
4. **Process**
   - Did **pair debugging** with a peer make the power profile *clearer* or *fuzzier*?
   - What **tool outside ESP32** (J-Link, USB hub) massively sped up tests?

---
### **Synthesis**
5. **One Design Rule**
   - State **one sentence** summarizing what you’d advise a new IoT team about power management.
   Example: *Always log sensor duty cycle in first 5 minutes—the surprises are incredible.*
6. **Next Experiment**
   - If you had another 3 hours in lab, what **one power tweak** would you test next?

---
## 🔧 Why This Module Matters
Power and latency are **orthogonal**: shrinking one often balloons the other.
- Engineers **underestimate deep sleep wake spikes** until measured.
- **60% of IoT failures** trace to power rail exhaustion (not software bugs).


---
## 📌 Resources & References
- **[ESP32 Power Save Modes Deep Dive](https://github.com/espressif/arduino-esp32/tree/master/libraries/ESP32/examples/ResetReason)** (in ResetReason.ino)
- **[ARM Cortex Power Calculator](https://lowpowerlab.com/2018/03/19/low-power-design-guide/)**
- **[Wireshark WiFi Power Filter](https://wiki.wireshark.org/SampleCaptures)** – filter `wlan.fc.type_subtype == 0x08` for beacons
- **[LiPo vs Coin Cell AppNote TI](https://www.ti.com/lit/an/slyt670/slyt670.pdf)** – contrast curves
- **[ESP32-C3 Better Power Modes](https://www.espressif.com/sites/default/files/documentation/esp32-c3_technical_reference_manual_en.pdf)**(for newer silicon)

---
## 📌 Next Steps
1. **Finalize battery life estimate** and add to your **project report draft** (`project_report_v1.md`).
2. **Next Module 7**: Peer **rehearsals**, final dry-run, rubric-driven feedback.

---
*[Portfolio template link](https://portfolio.iotempower.us) – drop CSV power graphs and reflections in your Week 6 folder.*