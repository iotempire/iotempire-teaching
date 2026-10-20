# Module 5 – Wireless Technologies & ESP-NOW Micro-Networking

[← Back to Module 4](./04-mqtt-and-integration.md) | [Quick module index](./00-index.md) | [Next: Module 6 →](./06-industrial-protocols-and-bridging.md)

**Course placement:** Day 5 — the wireless studio. You choose a radio by measurement, then build an ESP-NOW-to-MQTT bridge.

## 🎯 Learning Goals

This module gives you the opportunity to explore wireless IoT communication and achieve competency in radio and ISM-band trade-offs, Wi-Fi vs. BLE vs. LoRaWAN, and connectionless ESP-NOW with a gateway bridge.

By the end of this module, you can:
1. Explain the physics and trade-offs of the wireless spectrum: 2.4 GHz vs. Sub-GHz ISM bands, path loss, and channel interference.
2. Compare Wi-Fi, Bluetooth Low Energy (BLE), LoRaWAN, and ESP-NOW across bandwidth, latency, range, and power consumption.
3. Use ESP-NOW: connectionless IEEE 802.11 action frames for ultra-low latency, sub-millisecond edge communication.
4. Architect and deploy an ESP-NOW to MQTT Gateway Bridge using M5Stack hardware.


**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 📖 Story — The Greenhouse With Too Many Radios

**Klimapark GmbH** is expanding its greenhouse network. Agronomist **Dr. Elif Kaya** wants soil-moisture and temperature nodes in three polytunnels, a gate controller at the far end, and a battery-powered button for the night crew. The first proposal uses Wi-Fi for everything; the nodes at the far end drop out, the button drains a coin cell in a week, and the gate controller takes seconds to react.

Operations manager **Tobias Kern** asks the question that drives this module: *"Which radio actually fits each job — and what does it cost in range, latency, power, and payload?"* Today you compare Wi-Fi, BLE, LoRaWAN, and ESP-NOW, then build the bridge that brings a connectionless ESP-NOW micro-network into the MQTT system.

## 📖 Pod Study: The Wireless Landscape for IoT

This is **self/pod study, not a lecture.** Work through the concepts below with your Task Pod, look things up, ask an LLM, and keep notes — the goal is a shared mental model you can defend in the checkpoint.

### 1. The Physics of Radio & The ISM Band
IoT wireless technologies operate largely in unlicensed ISM (Industrial, Scientific, Medical) bands:
- 2.4 GHz: Global standard (Wi-Fi, BLE, Zigbee, ESP-NOW). High data rates, but high attenuation through walls/water and crowded channels.
- Sub-GHz (868 MHz in Europe, 915 MHz in US): Used by LoRa, Sigfox, and 802.11ah (Wi-Fi HaLow). Long wave length, superior building penetration, lower absorption, but strictly capped duty cycles (e.g. 1% airtime limit per hour in EU).

| Technology | Frequency Band | Typical Range | Max Payload | Latency | Power (Active TX) |
|---|---|---|---|---|---|
| Standard Wi-Fi | 2.4 GHz / 5 GHz | ~30–50 m | 1500 bytes (MTU) | ~5–50 ms | 100–300 mA |
| BLE (Bluetooth LE) | 2.4 GHz | ~10–30 m | ~20–250 bytes | ~10–100 ms | ~10–20 mA |
| LoRa / LoRaWAN | 868 MHz (EU) | 2–15 km | ~51–222 bytes | 1–10 seconds | ~30–50 mA (burst) |
| ESP-NOW | 2.4 GHz | ~50–100 m | 250 bytes | < 2 ms | 100 mA (for <10 ms) |

### 2. What Makes ESP-NOW Unique?
Standard Wi-Fi requires:
1. Scanning for SSIDs.
2. 802.11 Authentication & Association frames.
3. WPA2/WPA3 4-way cryptographic handshake.
4. DHCP broadcast to acquire an IP.
5. TCP 3-way handshake.
*Total time before sending 1 byte of sensor data:* 2 to 5 seconds! For a battery-powered sensor, keeping the radio active for 5 seconds drains immense energy.

ESP-NOW eliminates the entire TCP/IP and connection stack:
- Operates directly at Data Link (Layer 2) using IEEE 802.11 Vendor-Specific Action Frames.
- Connectionless: Devices transmit directly to a destination MAC address (or broadcast `FF:FF:FF:FF:FF:FF`).
- Instant Transmission: Wakes from deep sleep, fires an encrypted or unencrypted 250-byte packet in under 3 milliseconds, and returns immediately to deep sleep.
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

### Pointers (start here, then keep looking)

- ESP-NOW — [Espressif ESP-NOW documentation](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/api-reference/network/esp_now.html)
- Wi-Fi — [IEEE 802.11](https://en.wikipedia.org/wiki/IEEE_802.11)
- BLE — [Bluetooth Low Energy](https://en.wikipedia.org/wiki/Bluetooth_Low_Energy)
- LoRaWAN — [LoRa Alliance](https://lora-alliance.org/), [LoRaWAN 1.0 specification](https://lora-alliance.org/resource-hub/)
- ISM bands and duty cycle — [Wikipedia: ISM radio band](https://en.wikipedia.org/wiki/ISM_radio_band)
- The [resource bank's wireless references](./Z-resources-bank.md#pre-class-videos-by-module)

### Questions to ask an LLM (then verify against your hardware)

Ask your co-pilot — but treat every answer as a **claim to test**, not a fact. Good starting prompts:

- "Compare Wi-Fi, BLE, LoRaWAN, and ESP-NOW for a battery-powered soil-moisture sensor. Give range, payload, latency, and power trade-offs."
- "Why does standard Wi-Fi take seconds to send the first byte, while ESP-NOW can send in milliseconds? List the connection steps ESP-NOW skips."
- "How does an ESP32 receive ESP-NOW frames and publish to MQTT over Wi-Fi at the same time? What channel constraint applies?"
- "What is the EU duty-cycle limit for the 868 MHz band, and how does it affect a LoRaWAN sensor design?"
- "My ESP-NOW packets are lost when the room is crowded. What are the likely causes, and how would I measure them?"

> Run each prompt against your own radios, and record where the model is wrong, vague, or over-confident.

### ★ Task A: Study in your pod

Work through the concepts above with your Task Pod and fill in `Module05/study-log.md`:

1. **The references you used** — the source and the one concept you understood best from it.
2. **Things you googled** — the term, what you found, and the source (URL). One line each.
3. **Remarkable things** — surprises, "aha"s, and counterexamples from your own measurements.
4. **LLM Q&A** — for each prompt: the prompt, a 2–3 line summary, and **how you verified it** (and where it was wrong).
5. **Your two best found wireless comparison tables** — compile down to the best two, with source and what they taught you.

*Portfolio evidence:* `Module05/study-log.md`.

### ★ Task B: Explain & share with another pod

Pair with a **neighbouring pod**:

1. **Explain to each other** — each pod walks the other through its wireless trade-off matrix and its ESP-NOW bridge; ask questions and fill each other's gaps.
2. Agree on the **3–5 most noteworthy points** and the **learning you jointly stand behind** (e.g. *"the radio choice is a requirements question, not a religion"*).
3. **Clean up your documentation** — update your `study-log.md` with what you learned from the other pod.
4. Agree on **one shared artefact** — the best trade-off matrix, a latency measurement, or a new bridge diagram the two pods make together — and **post it in the course Discord**, with a one-sentence note on why you chose it.
5. Each member adds a short **“Agreed learning (pod discussion)”** section to *their own* `study-log.md`.

*Portfolio evidence:* your cleaned-up `study-log.md` (with the **“Agreed learning (pod discussion)”** section) and your pod-pair's shared artefact.

## 🛠️ In-Class Lab: The Sub-Millisecond ESP-NOW Swarm — **Challenging**

*Hardware:* 2× M5Stack nodes (e.g. 1 M5StickC and 1 M5Atom) + 1× OpenWrt Router.

### ★ Task 1: Peer Discovery & Sending Raw Action Frames

1. Find the MAC Address of Each Node:
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

2. Send Your First ESP-NOW Message:
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

3. Receive on Node B:
   Set up a callback on Node B using `esp_now_register_recv_cb()`.
   Watch the incoming packets appear instantly on the serial monitor with zero Wi-Fi network or router involved!

### ★ Task 2: Building the ESP-NOW to MQTT Gateway Bridge
Can a single ESP32 speak ESP-NOW and connect to standard Wi-Fi simultaneously? Yes! As long as both use the same Wi-Fi radio channel (e.g. Channel 1, 6, or 11).

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

### ★ Task 3: Latency & Interference Shootout
1. Trigger a physical button press on Node A that controls an LED on Node B via ESP-NOW.
2. Measure the response time (perceived latency is essentially instantaneous, <5 ms).
3. Compare this with triggering the LED via traditional Wi-Fi MQTT through the router:
   - Notice the difference in latency, especially when the Wi-Fi channel is heavily congested with class traffic.

## ✅ Suggested portfolio evidence (proofs of the learning goals)

1. Wireless Trade-off Matrix: Detail when you would choose ESP-NOW vs. Standard Wi-Fi vs. LoRaWAN vs. BLE in a commercial IoT deployment.
2. Bridge Architecture Diagram: Diagram the data flow from the standalone ESP-NOW sender, across the Layer-2 action frame, through the M5Stack dual-mode bridge, into the OpenWrt MQTT broker.
3. Serial Capture Evidence: Include serial monitor output showing the received ESP-NOW payload and the corresponding MQTT publish on the gateway.
4. Deeper question: Why is connectionless transmission a game-changer for battery-powered IoT edge buttons and sensors?


> [!IMPORTANT]
> Never commit secrets, credentials, private keys, or personal data. Where you did not work entirely alone, link your pod mates and sources.

## 📚 If you want to go deeper

- [Espressif ESP-NOW documentation](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/api-reference/network/esp_now.html) — peers, callbacks, and channel behavior.
- [Bluetooth Low Energy](https://en.wikipedia.org/wiki/Bluetooth_Low_Energy) — connection intervals and payload limits.
- [LoRa Alliance](https://lora-alliance.org/) and the [LoRaWAN specification](https://lora-alliance.org/resource-hub/) — long range, low power, duty cycle.
- [ISM radio band](https://en.wikipedia.org/wiki/ISM_radio_band) — the regulatory context.

---

[← Previous: Module 4](./04-mqtt-and-integration.md) | [Back to front page](../README.md) | [Quick module index](./00-index.md) | [Next: Module 6 — Industrial Protocols & Edge Bridging →](./06-industrial-protocols-and-bridging.md)
