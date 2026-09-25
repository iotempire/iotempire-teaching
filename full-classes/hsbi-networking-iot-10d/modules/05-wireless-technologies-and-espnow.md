# Module 5 – Wireless Technologies & ESP-NOW Micro-Networking

[← Back to Module 4](./04-mqtt-and-integration.md) | [Quick module index](./00-index.md) | [Next: Module 6 →](./06-industrial-protocols-and-bridging.md)

## 🎯 Learning Goals

> **How these are assessed:** You earn this module's points by **proving these goals** in a short (~10-minute) checkpoint presentation with the instructor (see the [syllabus](../syllabus.md#how-module-points-are-earned-checkpoint-presentations)) — based on your portfolio and reflections, not on completing every task. You may skip tasks, fail at some, or add your own; documented exploration and demonstrated deep understanding both count in your favor.

This module gives you the opportunity to explore **wireless IoT communication** and achieve competency in **radio and ISM-band trade-offs, Wi-Fi vs. BLE vs. LoRaWAN, and connectionless ESP-NOW with a gateway bridge**.

By the end of this module, you can:
1. Explain the **physics and trade-offs of the wireless spectrum**: 2.4 GHz vs. Sub-GHz ISM bands, path loss, and channel interference.
2. Compare **Wi-Fi, Bluetooth Low Energy (BLE), LoRaWAN, and ESP-NOW** across bandwidth, latency, range, and power consumption.
3. Use **ESP-NOW**: connectionless IEEE 802.11 action frames for ultra-low latency, sub-millisecond edge communication.
4. Architect and deploy an **ESP-NOW to MQTT Gateway Bridge** using M5Stack hardware.

> [!WARNING]
> **DRAFT — first taught in WS 2026/27.** Everything below this line is a working draft and will likely change as we refine it together in class; the line moves down as we approve content. Your input is welcome and can shape this module.

**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 📖 The Wireless Landscape for IoT

### 1. The Physics of Radio & The ISM Band
IoT wireless technologies operate largely in unlicensed **ISM (Industrial, Scientific, Medical) bands**:
- **2.4 GHz:** Global standard (Wi-Fi, BLE, Zigbee, ESP-NOW). High data rates, but high attenuation through walls/water and crowded channels.
- **Sub-GHz (868 MHz in Europe, 915 MHz in US):** Used by LoRa, Sigfox, and 802.11ah (Wi-Fi HaLow). Long wave length, superior building penetration, lower absorption, but strictly capped duty cycles (e.g. 1% airtime limit per hour in EU).

| Technology | Frequency Band | Typical Range | Max Payload | Latency | Power (Active TX) |
|---|---|---|---|---|---|
| **Standard Wi-Fi** | 2.4 GHz / 5 GHz | ~30–50 m | 1500 bytes (MTU) | ~5–50 ms | 100–300 mA |
| **BLE (Bluetooth LE)** | 2.4 GHz | ~10–30 m | ~20–250 bytes | ~10–100 ms | ~10–20 mA |
| **LoRa / LoRaWAN** | 868 MHz (EU) | 2–15 km | ~51–222 bytes | 1–10 seconds | ~30–50 mA (burst) |
| **ESP-NOW** | 2.4 GHz | ~50–100 m | 250 bytes | **< 2 ms** | 100 mA (for <10 ms) |

### 2. What Makes ESP-NOW Unique?
Standard Wi-Fi requires:
1. Scanning for SSIDs.
2. 802.11 Authentication & Association frames.
3. WPA2/WPA3 4-way cryptographic handshake.
4. DHCP broadcast to acquire an IP.
5. TCP 3-way handshake.
*Total time before sending 1 byte of sensor data:* **2 to 5 seconds!** For a battery-powered sensor, keeping the radio active for 5 seconds drains immense energy.

**ESP-NOW** eliminates the entire TCP/IP and connection stack:
- Operates directly at **Data Link (Layer 2)** using IEEE 802.11 **Vendor-Specific Action Frames**.
- **Connectionless:** Devices transmit directly to a destination MAC address (or broadcast `FF:FF:FF:FF:FF:FF`).
- **Instant Transmission:** Wakes from deep sleep, fires an encrypted or unencrypted 250-byte packet in **under 3 milliseconds**, and returns immediately to deep sleep.
- Perfect for ultra-responsive switches, remote controls, alarm triggers, and dense sensor swarms.

```text
[M5Stack Sensor Node] 
       |
       | ESP-NOW (Layer-2 Action Frame, <2ms)
       v
[M5Stack Gateway Bridge Node]
       |
       | Wi-Fi / TCP / IP (Port 1883)
       v
[OpenWrt Router / Mosquitto MQTT Broker]
```

## 🛠️ In-Class Lab: The Sub-Millisecond ESP-NOW Swarm

*Hardware:* 2× M5Stack nodes (e.g. 1 M5StickC and 1 M5Atom) + 1× OpenWrt Router.

### Task 1: Peer Discovery & Sending Raw Action Frames (30 min)

1. **Find the MAC Address of Each Node:**
   Upload a quick identifier sketch or read the MAC from the serial console at boot:
   ```cpp
   #include <WiFi.h>
   void setup() {
     Serial.begin(115200);
     WiFi.mode(WIFI_STA);
     Serial.print("Node MAC: ");
     Serial.println(WiFi.macAddress());
   }
   void loop() {}
   ```
   *Record your partner's node MAC address.*

2. **Send Your First ESP-NOW Message:**
   Configure Node A (the sender) to initialize ESP-NOW and register Node B's MAC as a peer:
   ```cpp
   #include <WiFi.h>
   #include <esp_now.h>

   uint8_t peerMAC[] = {0x24, 0x6F, 0x28, 0xXX, 0xXX, 0xXX}; // Partner's MAC

   typedef struct struct_message {
     char device[16];
     float temp;
     int count;
   } struct_message;

   struct_message myData;

   void setup() {
     Serial.begin(115200);
     WiFi.mode(WIFI_STA);
     if (esp_now_init() != ESP_OK) {
       Serial.println("Error initializing ESP-NOW");
       return;
     }
     
     esp_now_peer_info_t peerInfo = {};
     memcpy(peerInfo.peer_addr, peerMAC, 6);
     peerInfo.channel = 0;  // Use current channel
     peerInfo.encrypt = false;
     esp_now_add_peer(&peerInfo);
   }

   void loop() {
     strcpy(myData.device, "M5-Sender");
     myData.temp = 22.4;
     myData.count++;
     esp_now_send(peerMAC, (uint8_t *) &myData, sizeof(myData));
     Serial.printf("Sent packet #%d\n", myData.count);
     delay(1000);
   }
   ```

3. **Receive on Node B:**
   Set up a callback on Node B using `esp_now_register_recv_cb()`.
   Watch the incoming packets appear instantly on the serial monitor with zero Wi-Fi network or router involved!

### Task 2: Building the ESP-NOW to MQTT Gateway Bridge (40 min)
Can a single ESP32 speak ESP-NOW and connect to standard Wi-Fi simultaneously? **Yes!** As long as both use the **same Wi-Fi radio channel** (e.g. Channel 1, 6, or 11).

1. Connect Node B (the bridge node) to your OpenWrt router's Wi-Fi network.
2. Note the Wi-Fi channel of the router:
   ```cpp
   int channel = WiFi.channel();
   ```
3. When Node B receives an incoming ESP-NOW frame from Node A:
   - Extract the payload.
   - Forward it to your OpenWrt Mosquitto broker via MQTT (`client.publish("espnow/sensor/data", jsonPayload)`).
4. Verify the flow in Node-RED:
   `M5 Sensor (ESP-NOW) -> M5 Bridge Node (Wi-Fi) -> OpenWrt Broker -> Node-RED Dashboard`.

### Task 3: Latency & Interference Shootout (20 min)
1. Trigger a physical button press on Node A that controls an LED on Node B via ESP-NOW.
2. Measure the response time (perceived latency is essentially instantaneous, <5 ms).
3. Compare this with triggering the LED via traditional Wi-Fi MQTT through the router:
   - Notice the difference in latency, especially when the Wi-Fi channel is heavily congested with class traffic.

## 📝 Working-Day Reflection & Portfolio Tasks

In your portfolio under `modules/05-wireless-espnow/`:
1. **Wireless Trade-off Matrix:** Detail when you would choose **ESP-NOW vs. Standard Wi-Fi vs. LoRaWAN vs. BLE** in a commercial IoT deployment.
2. **Bridge Architecture Diagram:** Diagram the data flow from the standalone ESP-NOW sender, across the Layer-2 action frame, through the M5Stack dual-mode bridge, into the OpenWrt MQTT broker.
3. **Serial Capture Evidence:** Include serial monitor output showing the received ESP-NOW payload and the corresponding MQTT publish on the gateway.
4. **Reflection:** Why is connectionless transmission a game-changer for battery-powered IoT edge buttons and sensors?
