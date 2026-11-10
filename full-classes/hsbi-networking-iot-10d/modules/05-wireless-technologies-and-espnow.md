# Module 5 – Wireless Technologies & ESP-NOW Micro-Networking

[← Back to Module 4](./04-mqtt-and-integration.md) | [Quick module index](./00-index.md) | [Next: Module 6 →](./06-industrial-protocols-and-bridging.md)

**Course placement:** Day 5 — the wireless challenge. You choose a radio by measurement, then build an ESP-NOW-to-MQTT bridge.

## 🎯 Learning Goals

This module gives you the opportunity to explore wireless IoT communication and achieve competency in radio and ISM-band trade-offs, Wi-Fi vs. BLE vs. LoRaWAN, and connectionless ESP-NOW with a gateway bridge.

By the end of this module, you can:
1. Explain the physics and trade-offs of the wireless spectrum: 2.4 GHz vs. Sub-GHz ISM bands, path loss, and channel interference.
2. Compare Wi-Fi, Bluetooth Low Energy (BLE), LoRaWAN, and ESP-NOW across bandwidth, latency, range, and power consumption.
3. Use ESP-NOW: connectionless IEEE 802.11 action frames for ultra-low latency, sub-millisecond edge communication.
4. Architect and deploy an ESP-NOW to MQTT Gateway Bridge using M5Stack hardware.

**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 🎬 Opening the Challenge

**The day starts in the greenhouse, not a slide.** Module 4 gave you a broker; today you choose the radio that feeds it. The opening runs in five quick beats:

1. **Pre-study check-in.** In your pod, show one artefact from Module 4 — the topic tree, the Node-RED flow, or the LWT screenshot — and name one question you still have. Park the questions on the board.
2. **Confirm the pod and the roles.** Rotate: one drives the sender, one the receiver/bridge, one keeps the measurements and notes. Swap after each round.
3. **Collect the hardware.** 2× M5Stack nodes (e.g. 1 M5StickC and 1 M5Atom) + 1× OpenWrt router + a laptop. Check that the bridge node and the router will use the **same Wi-Fi channel**.
4. **Draw the two paths.** One sketch for ESP-NOW (Layer 2, no association, no IP) and one for Wi-Fi/MQTT (association, DHCP, TCP, broker, dashboard). Mark where the bridge sits.
5. **Skim the studio, do not start.** Read the challenge and the round table, then skim the theory boxes and the evidence list. Find **where the frame becomes an MQTT message** and **where the latency is measured**. Then start Round 1.

Before you touch the radios, answer these three in one sentence each — they are the questions the day will answer:

- Which job in the greenhouse needs range, which needs latency, and which needs a coin cell for a year?
- What does a Wi-Fi client do before it can send one byte of sensor data?
- What does a bridge node have to do to speak both worlds?

### Your portfolio entry for today — sections, not files

Everything from today goes into **`Module05/README.md`** as sections. Split something into its own file only when a section outgrows the page.

- `## Radio decision` — the trade-off matrix and one justified choice per greenhouse job.
- `## Study log` — the running log: the theory you actually needed, the commands that surprised you, and the LLM answers you checked. Not an essay, and not a separate study phase.
- `## Discussion log` — one line per discussion: who listened, what they asked, what you changed. This is personal.
- `## ESP-NOW experiments` — the MACs, the serial send/receive output, and the latency comparison.
- `## Bridge` — the ESP-NOW → MQTT architecture and the published messages.
- `## Story seeds` — optional: the odd bits worth turning into a story later.

*One pod member keeps the shared `## Study log`; the others link to it from their own `Module05/README.md` and add one sentence on what they took from it. The `## Discussion log` is yours alone.*

### The radio contract

The radios are shared infrastructure, and the 2.4 GHz band is crowded. Agree before you start:

- **One channel for the bridge.** The ESP-NOW peer and the Wi-Fi connection must use the same channel; a bridge on a different channel hears nothing.
- **No personal data on the air.** ESP-NOW can be unencrypted; send sensor values, not names, credentials, or captures of other people's traffic.
- **One sender per experiment.** Two pods on the same channel with the same payload shape will confuse the measurements; coordinate before you transmit.

## 📖 The Challenge — The Greenhouse With Too Many Radios

**Klimapark GmbH** is expanding its greenhouse network. Agronomist **Dr. Elif Kaya** wants soil-moisture and temperature nodes in three polytunnels, a gate controller at the far end, and a battery-powered button for the night crew. The first proposal uses Wi-Fi for everything; the nodes at the far end drop out, the button drains a coin cell in a week, and the gate controller takes seconds to react.

Operations manager **Tobias Kern** asks the question that drives this module: *"Which radio actually fits each job — and what does it cost in range, latency, power, and payload?"*

**Your challenge.** Choose the radio for each job by measurement, then build the bridge that brings a connectionless ESP-NOW micro-network into the MQTT system. You are done when you can show:

1. A trade-off matrix for **soil moisture**, **the far gate**, **the night button**, and **the indoor temperature node** — with one justified choice each.
2. A raw ESP-NOW send/receive between two nodes, with the MAC addresses and the serial output.
3. An ESP-NOW → MQTT bridge that publishes a received frame to the pod broker.
4. A latency comparison: button → LED over ESP-NOW vs. the same action over Wi-Fi/MQTT.
5. *(Optional stretch)* A pcap of one ESP-NOW frame, and an answer to where the reliability went.

**Constraints.** 2 M5Stack nodes + 1 router per pod. The bridge node and the router share a Wi-Fi channel. ESP-NOW payloads are small (250 bytes). No association, no DHCP, no TCP on the ESP-NOW path. The 2.4 GHz band is shared with the class; coordinate channels. No personal data on the air.

**This story is unfinished on purpose.** The hooks below are starting points, not a script. Pick the ones that match what you actually saw, and add a line of your own — *"and the button worked until the microwave in the break room turned on"* is worth more than a perfect table. Collect those lines under `## Story seeds` and use them in a discussion or the harvest.

## 🧭 How this studio works now

**The study is folded into the practice.** There is no separate pod-study phase and no scheduled hand-off to another pod. Each round gives you a small thing to do, a short **Theory you need** box you read only when the task makes you want it, and a **discussion** at the end. Keep your notes in `Module05/README.md` under `## Study log` — a running log, not an essay.

**First: skim, do not start.** Read the challenge and the round table, then skim the theory boxes and the evidence list. You are looking for two things: **where the frame becomes an MQTT message** and **where the latency is measured**. Then start Round 1.

**Every round ends with a discussion — one person is enough.** Ask someone at the nearest pod if they have a moment; show them the round's artefact and ask the discussion question. If they want, let them show you theirs and ask you one question back. **This is a brag, not a quiz.** Write one line in `## Discussion log`: who listened, what they asked, what you changed. If nobody is free, ask someone else or come back later — do not wait.

**Take a study break when a box is not enough.** Read the linked source, then explain it to one person. Explaining is the test, not reading. You do not need permission; take the break when the task makes you want it.

The table is the discussion map: the **[Goal](#-learning-goals) · theory box** column names what each discussion checks. The question tests understanding, not task completion.

| # | Round | You produce | [Goal](#-learning-goals) · theory box | Discussion question for one person |
|---|---|---|---|---|
| 1 | **Choose the radio** | A matrix and one justified choice per greenhouse job | G1 + G2 · Choose the radio | "Which radio for the gate, and which for the button? Why?" |
| 2 | **Send a raw frame** | MACs and serial send/receive output | G3 · Send a raw frame | "What did ESP-NOW skip?" |
| 3 | **Build the bridge** | An ESP-NOW frame published to MQTT | G4 · Build the bridge | "Where does the frame become an MQTT message?" |
| 4 | **Measure the difference** | Button→LED latency over ESP-NOW vs Wi-Fi/MQTT | G4 · Measure the difference | "What did you measure, and what did it cost?" |
| ◇ | **Capture the air** | A pcap with one ESP-NOW frame | G3 · Capture the air | "Where did reliability go?" |

**The order is a suggestion.** The rounds are a path, not a timetable. If the bridge node refuses the Wi-Fi channel, fix the channel before you debug the code; if you finish early, take the sniffer stretch. **The instructor demos one ESP-NOW send and one bridge publish live on the beamer** — ask for the demo you need. Rotate roles after each round; everybody should send, receive, and publish at least once. The question you should always be able to answer is *"what did you choose, and what did it cost you?"*

## 🛠️ The Studio: The Sub-Millisecond ESP-NOW Swarm — **Challenging**

*Hardware:* 2× M5Stack nodes (e.g. 1 M5StickC and 1 M5Atom) + 1× OpenWrt router.

### ★ Round 1: Choose the radio

Fill the matrix for the four greenhouse jobs and write one sentence per choice. Ask an LLM for its comparison, then check it against the table and your own constraints.

| Technology | Frequency band | Typical range | Max payload | Latency | Power (active TX) |
|---|---|---|---|---|---|
| Standard Wi-Fi | 2.4 GHz / 5 GHz | ~30–50 m | 1500 bytes (MTU) | ~5–50 ms | 100–300 mA |
| BLE (Bluetooth LE) | 2.4 GHz | ~10–30 m | ~20–250 bytes | ~10–100 ms | ~10–20 mA |
| LoRa / LoRaWAN | 868 MHz (EU) | 2–15 km | ~51–222 bytes | 1–10 seconds | ~30–50 mA (burst) |
| ESP-NOW | 2.4 GHz | ~50–100 m | 250 bytes | < 2 ms | 100 mA (for < 10 ms) |

**Theory you need.** IoT wireless technologies operate largely in unlicensed **ISM** bands. **2.4 GHz** is the global standard (Wi-Fi, BLE, Zigbee, ESP-NOW): high data rates, but high attenuation through walls and water, and crowded channels. **Sub-GHz** (868 MHz in Europe, 915 MHz in the US) is used by LoRa, Sigfox, and 802.11ah: longer wavelength, better building penetration, lower absorption, but strict duty-cycle limits (for example, a 1% airtime limit per hour in the EU). The table is a starting point, not a verdict: range depends on antennas, walls, and interference; power depends on duty cycle, not just the TX current. *Go deeper: the ISM-band article and the LoRaWAN/ESP-NOW docs.*

**Do.** Choose a radio for each: soil moisture in a polytunnel, the far gate controller, the coin-cell night button, the indoor temperature node. Write one sentence per choice with the constraint that decided it.

> **Discussion — show one person.** Show your matrix and ask: *"Which radio for the gate, and which for the button? Why?"* Write one line in `## Discussion log`.

> **Story hook.** *Tobias's question.* The first proposal used Wi-Fi for everything; the far nodes dropped out, the button drained a coin cell, and the gate took seconds. The radio is a requirements decision, not a religion.

*Portfolio evidence:* the filled matrix and the four one-sentence choices.

### ★ Round 2: Send a raw action frame

1. **Find the MAC address of each node.** Upload a quick identifier sketch or read the MAC from the serial console at boot:
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

2. **Send your first ESP-NOW message.** Configure Node A (the sender) to initialize ESP-NOW and register Node B's MAC as a peer:
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

3. **Receive on Node B.** Set up a callback on Node B using `esp_now_register_recv_cb()`. Watch the incoming packets appear instantly on the serial monitor with zero Wi-Fi network or router involved.

**Theory you need.** Standard Wi-Fi before one byte of sensor data: scan for SSIDs, 802.11 authentication and association, the WPA2/WPA3 four-way handshake, DHCP, and a TCP three-way handshake. That is seconds of radio-on time. ESP-NOW skips the whole stack: it sends **IEEE 802.11 vendor-specific action frames** directly to a peer MAC address at Layer 2, connectionless, with a 250-byte payload. A node can wake from deep sleep, fire a frame, and return to sleep in milliseconds. *Go deeper: the Espressif ESP-NOW docs.*

> **Discussion — show one person.** Show the serial send/receive output and ask: *"What did ESP-NOW skip?"* Write one line in `## Discussion log`.

> **Story hook.** *The button that skipped the network.* The night crew's button does not need an IP address, a DHCP lease, or a TCP connection; it needs to tell the gate "pressed" before the person lets go.

*Portfolio evidence:* the two MAC addresses and the serial output showing the received payload.

### ★ Round 3: Build the ESP-NOW to MQTT bridge

Can a single ESP32 speak ESP-NOW and connect to standard Wi-Fi simultaneously? Yes — as long as both use the same Wi-Fi radio channel (e.g. Channel 1, 6, or 11).

1. Connect Node B (the bridge node) to your OpenWrt router's Wi-Fi network.
2. Note the Wi-Fi channel of the router:
   ```cpp
   int channel = WiFi.channel();
   ```
3. When Node B receives an incoming ESP-NOW frame from Node A:
   - Extract the payload.
   - Forward it to your OpenWrt Mosquitto broker via MQTT (`client.publish("espnow/sensor/data", jsonPayload)`).
4. Verify the flow in Node-RED (if available) or MQTT Explorer:
   `M5 Sensor (ESP-NOW) -> M5 Bridge Node (Wi-Fi) -> OpenWrt Broker -> Node-RED Dashboard (if available) or MQTT Explorer`.

**Theory you need.** The ESP32 has one 2.4 GHz radio, so the ESP-NOW peer and the Wi-Fi connection must share a channel. The bridge node is the protocol translator: it receives a Layer-2 action frame, parses the struct, serializes it as JSON, and publishes to the broker over TCP. From the broker's point of view, the bridge is just another MQTT client; from the sensor's point of view, there is no network at all. *Go deeper: the ESP-NOW docs and the MQTT cheat sheet.*

> **Discussion — show one person.** Show the MQTT message arriving from the bridge and ask: *"Where does the frame become an MQTT message?"* Write one line in `## Discussion log`.

> **Story hook.** *The bridge that speaks both.* The gate controller speaks action frames; the dashboard speaks MQTT. The bridge is the only device that has to know both, and it is the seam where the two worlds meet.

*Portfolio evidence:* the bridge architecture diagram, the `client.publish` line, and the MQTT message in MQTT Explorer or Node-RED.

### ★ Round 4: Latency and interference shootout

1. Trigger a physical button press on Node A that controls an LED on Node B via ESP-NOW.
2. Measure the response time (perceived latency is essentially instantaneous, < 5 ms).
3. Compare this with triggering the LED via traditional Wi-Fi MQTT through the router:
   - Notice the difference in latency, especially when the Wi-Fi channel is heavily congested with class traffic.

**Theory you need.** "Latency" here is the time from the physical press to the physical reaction, not the ping time. ESP-NOW is one frame at Layer 2; the Wi-Fi/MQTT path has association state, TCP, the broker, and the return path. Under congestion, the difference is not just milliseconds — it is whether the reaction feels immediate. Measure what you can see (a slow-motion phone video, a logic analyzer, or the serial timestamps) and state the method; an estimate without a method is a guess. *Go deeper: the ESP-NOW docs; repeat the measurement with the class traffic on and off.*

> **Discussion — show one person.** Show the two paths and your measurement, and ask: *"What did you measure, and what did it cost?"* Write one line in `## Discussion log`.

> **Story hook.** *The gate that reacted in milliseconds.* The far gate cannot wait for a TCP retransmission; the night button cannot keep the radio on for a handshake. The difference is the whole reason for the micro-network.

*Portfolio evidence:* the measurement method, the two latency numbers, and one sentence on what the Wi-Fi path added.

### ◇ Stretch: Watch the air — capture ESP-NOW as pcap

ESP-NOW is connectionless, so there is no broker to look at and no TCP connection to follow. The frames are still there on the channel, and an ESP32 in promiscuous mode can hand them to you as an ordinary capture:

1. Flash [`sp4rkie/ultra-espnow-sniff`](https://github.com/sp4rkie/ultra-espnow-sniff) to a third ESP32 and capture while Round 2 sends its frames.
2. Open the pcap and find one ESP-NOW frame: source and destination MAC, the vendor action-frame header, your payload.
3. Answer: where did the *reliability* go? What would you have to add in your own protocol to notice a lost frame?

**Theory you need.** Promiscuous mode puts the radio in monitor mode for the channel; the sniffer sees frames that are not addressed to it, but it will miss some depending on where it sits. There is no ACK, no retransmission, and no broker to tell you a frame was lost; reliability is a decision you add above the frame. A single observer cannot tell a broken link from a badly placed observer. *Go deeper: the [capture recipes](./Z-resources-bank.md#packet-capture-without-a-second-wifi-card) and the sniffer repository.*

> **Discussion — show one person.** Show the pcap and ask: *"Where did reliability go?"* Write one line in `## Discussion log`.

*Portfolio evidence:* the pcap, the one-frame breakdown, and the reliability answer.

## 🤖 Ask an LLM — then verify

Use these when a theory box is not enough. Treat every answer as a **claim to test**, not a fact, and run it against your own radios.

- "Compare Wi-Fi, BLE, LoRaWAN, and ESP-NOW for a battery-powered soil-moisture sensor. Give range, payload, latency, and power trade-offs."
- "Why does standard Wi-Fi take seconds to send the first byte, while ESP-NOW can send in milliseconds? List the connection steps ESP-NOW skips."
- "How does an ESP32 receive ESP-NOW frames and publish to MQTT over Wi-Fi at the same time? What channel constraint applies?"
- "What is the EU duty-cycle limit for the 868 MHz band, and how does it affect a LoRaWAN sensor design?"
- "My ESP-NOW packets are lost when the room is crowded. What are the likely causes, and how would I measure them?"

Record where the model is wrong, vague, or over-confident in `## Study log`.

## 🔁 Optional: the harvest — collect curiosities, swap lists

> **Optional and ungraded.** The full ritual is in [Module 1](./01-foundations-and-masterclass.md#harvest); run the short version here.

As you work, mark the odd bits: a channel mismatch that looked like a dead node, a frame the sniffer missed, a button that reacted late only when the Wi-Fi was busy, a payload that was one byte too large. Put a `?` in the margin or a line under `## Story seeds`. At the break and at the end, swap lists with one person at another pod: briefly, no explaining, every entry gets a source. Anything two pods collected, or that nobody can place, goes to the course channel. The list is the artefact; the conversation is the point.

## ✅ Suggested portfolio evidence (proofs of the learning goals)

This is a **suggestion, not a checklist** — the learning goals are the contract. A convincing subset, or a better artefact you design yourself, is worth more than a ticked list.

1. **Radio decision (goals 1 and 2):** the trade-off matrix and the four one-sentence choices.
2. **Raw frame (goal 3):** the two MACs and the serial send/receive output.
3. **Bridge (goal 4):** the architecture diagram, the publish line, and the MQTT message arriving from the bridge.
4. **Latency comparison (goals 2 and 3):** the method, the ESP-NOW number, the Wi-Fi/MQTT number, and what the Wi-Fi path added.
5. **The running log and discussions:** your `## Study log` with the theory you actually needed, plus `## Discussion log` — one line per discussion.
6. **Optional sniffer (goal 3):** the pcap, the one-frame breakdown, and the reliability answer.
7. **Deeper question:** why is connectionless transmission a game-changer for battery-powered edge buttons and sensors?

> [!IMPORTANT]
> Never commit secrets, credentials, private keys, or personal data. Where you did not work entirely alone, link your pod mates and sources.

## 📚 If you want to go deeper

- [Espressif ESP-NOW documentation](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/api-reference/network/esp_now.html) — peers, callbacks, and channel behavior.
- [IEEE 802.11](https://en.wikipedia.org/wiki/IEEE_802.11) — the standard behind both Wi-Fi and ESP-NOW action frames.
- [esp32_eth_wifi_bridge](https://github.com/martin-ger/esp32_eth_wifi_bridge) and [ultra-espnow-sniff](https://github.com/sp4rkie/ultra-espnow-sniff) — two ways to get packets off the air and into a pcap.
- [Bluetooth Low Energy](https://en.wikipedia.org/wiki/Bluetooth_Low_Energy) — connection intervals and payload limits.
- [LoRa Alliance](https://lora-alliance.org/) and the [LoRaWAN specification](https://lora-alliance.org/resource-hub/) — long range, low power, duty cycle.
- [ISM radio band](https://en.wikipedia.org/wiki/ISM_radio_band) — the regulatory context.
- The [resource bank's wireless references](./Z-resources-bank.md#pre-class-videos-by-module) and [capture recipes](./Z-resources-bank.md#packet-capture-without-a-second-wifi-card).

---

[← Previous: Module 4](./04-mqtt-and-integration.md) | [Back to front page](../README.md) | [Quick module index](./00-index.md) | [Next: Module 6 — Industrial Protocols & Edge Bridging →](./06-industrial-protocols-and-bridging.md)
