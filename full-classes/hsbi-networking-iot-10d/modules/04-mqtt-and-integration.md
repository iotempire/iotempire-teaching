# Module 4 – Application Messaging: MQTT Deep Dive & Integration

[← Back to Module 3](./03-overlay-and-mesh-networks.md) | [Quick module index](./00-index.md) | [Next: Module 5 →](./05-wireless-technologies-and-espnow.md)

## 🎯 Learning Goals

> **How these are assessed:** You earn this module's points by proving these goals in a short (~10-minute) checkpoint presentation with the instructor (see the [syllabus](../syllabus.md#how-module-points-are-earned-checkpoint-presentations)) — based on your portfolio and reflections, not on completing every task. You may skip tasks, fail at some, or add your own; documented exploration and demonstrated deep understanding both count in your favor.

This module gives you the opportunity to explore decoupled messaging and system integration and achieve competency in **MQTT mechanics (topics, QoS, retain, LWT), Node-RED flows, and Python (`paho-mqtt` / IoTknit) services**.

By the end of this module, you can:
1. Deeply understand the MQTT protocol mechanisms: topic hierarchies, QoS levels, retained messages, and Last Will and Testament (LWT).
2. Build data pipelines, state machines, and dashboards in Node-RED.
3. Develop event-driven programmatic integration services in **Python using `paho-mqtt` and IoTknit**.
4. Experience the power of pub/sub abstraction by swapping simulated/mock devices with physical M5Stack nodes with zero downstream code changes.

> [!WARNING]
> DRAFT — first taught in WS 2026/27. Everything below this line is a working draft and will likely change as we refine it together in class; the line moves down as we approve content. Your input is welcome and can shape this module.

**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 📖 The Architecture of Decoupled Messaging

### Why MQTT Over Request/Response (HTTP)?
Traditional web architectures rely on client-server request/response over HTTP:
- The client must know the server's IP address and port.
- Both client and server must be online simultaneously.
- If 10 components need the temperature, the sensor must send 10 separate HTTP requests.

MQTT (Message Queuing Telemetry Transport) decouples producers and consumers:
1. Space Decoupling: Publishers and subscribers do not know each other’s IP addresses; they only know the broker.
2. Time Decoupling: With retained messages and persistent sessions, subscribers can receive the latest state even if they were offline when it was published.
3. Synchronization Decoupling: Operations are non-blocking and asynchronous.

```text
[Publisher: M5Stack Temp Node]
       |
       |  PUBLISH "home/livingroom/temp" (21.4°C) [QoS 1, Retain]
       v
[Mosquitto MQTT Broker on OpenWrt]
       |
       +----------------------------+
       |                            |
       v                            v
[Subscriber: Node-RED]     [Subscriber: Python Logger / IoTknit]
```

### Essential MQTT Mechanics:
- Topic Hierarchies: `/` separated strings (e.g. `factory/hall1/press/temp`).
  - `+` Single-level wildcard (e.g. `factory/+/press/temp`).
  - `#` Multi-level wildcard (e.g. `factory/hall1/#`).
- Quality of Service (QoS):
  - QoS 0 (At most once): "Fire and forget". Fastest, lowest energy, no guarantee.
  - QoS 1 (At least once): Broker acknowledges with `PUBACK`. Guarantees delivery, but duplicate packets can occur if an ACK is lost.
  - QoS 2 (Exactly once): 4-way handshake (`PUBLISH` $\rightarrow$ `PUBREC` $\rightarrow$ `PUBREL` $\rightarrow$ `PUBCOMP`). Highest overhead; rarely needed in typical sensor telemetry.
- Retained Messages: The broker stores the last message published with `retain=true`. When a new dashboard or node subscribes, it immediately receives the current state instead of waiting minutes for the next publish.
- Last Will and Testament (LWT): When a client connects, it gives the broker a "will" message (e.g. topic `devices/m5stick1/status`, payload `offline`, retain `true`). If the device suddenly loses power or drops Wi-Fi, the broker automatically publishes this message.

## 🛠️ In-Class Lab: Building the Integration Engine

### Task 1: Exploring QoS, Retain & LWT with MQTT Explorer (20 min)
1. Open MQTT Explorer or `mosquitto_sub` on your laptop, connecting to your OpenWrt broker (`192.168.8.1:1883` or via your Nebula IP).
2. Connect an M5Stack node configured with an LWT topic:
   ```text
   Status Topic: devices/m5node-01/status
   Connect payload: "online" (retained)
   LWT payload: "offline" (retained)
   ```
3. Watch the topic tree in MQTT Explorer.
4. The Hard Disconnect Test: Unplug the M5Stack node from power (do not send a graceful disconnect).
5. Watch how many seconds pass before the broker detects the missing TCP keep-alive (PINGREQ) and automatically fires the LWT `offline` payload!

### Task 2: Visual Integration with Node-RED (30 min)
1. Open Node-RED on your OpenWrt gateway (`http://192.168.8.1:1880`).
2. Build an intelligent thermostat/alarm flow:
   - Input: MQTT subscriber on `devices/+/temp`.
   - Function Node: Parse the JSON payload `{"temp": float, "battery": int}`. If `temp > 28.0`, trigger an alarm state.
   - Output 1: Publish an actuator command to `devices/cooler/set` with payload `{"power": "ON"}`.
   - Output 2: Node-RED Dashboard Gauge and Alert notification banner.
3. Test the flow by publishing simulated values via terminal:
   ```bash
   mosquitto_pub -h 192.168.8.1 -t "devices/sensor1/temp" -m '{"temp": 29.5, "battery": 92}'
   ```
4. Verify the dashboard triggers and the control topic receives the command.

### Task 3: Programmatic Integration with Python & `paho-mqtt` / IoTknit (40 min)
Instead of putting all logic in Node-RED, modern production systems often use lightweight Python background services or IoTknit to bridge systems, write to databases, or handle custom business logic.

1. Create a Python script `iot_bridge.py`:
   ```python
   import json
   import paho.mqtt.client as mqtt

   BROKER = "192.168.8.1"  # Or your Nebula IP
   PORT = 1883

   def on_connect(client, userdata, flags, rc):
       print(f"Connected to broker with result code {rc}")
       # Subscribe to all sensor telemetry
       client.subscribe("devices/+/env")

   def on_message(client, userdata, msg):
       try:
           payload = json.loads(msg.payload.decode())
           topic_parts = msg.topic.split('/')
           device_id = topic_parts[1]
           
           temp = payload.get("temp")
           humidity = payload.get("humidity")
           print(f"[{device_id}] Temp: {temp}°C, Humidity: {humidity}%")
           
           # Compute Heat Index or business logic
           if temp is not None and temp > 27.0:
               alert_payload = json.dumps({"device": device_id, "alert": "HIGH_TEMP", "val": temp})
               client.publish("alerts/temperature", alert_payload, qos=1)
               print(f"--> Triggered alert for {device_id}")
       except Exception as e:
           print(f"Error parsing message: {e}")

   client = mqtt.Client()
   client.on_connect = on_connect
   client.on_message = on_message

   client.connect(BROKER, PORT, 60)
   client.loop_forever()
   ```
2. Run the script and observe it process messages in real time.
3. Zero-Friction Hardware Swap:
   - Create a second script `mock_sensor.py` that publishes simulated sensor values every 2 seconds.
   - Run it. Observe Node-RED and your Python bridge processing the mock data.
   - Turn on your physical M5Stack node publishing to the same topic structure.
   - Notice how neither Node-RED nor the Python bridge care whether the message originated from a mock script or a real M5Stack device!

## 📝 Working-Day Reflection & Portfolio Tasks

In your portfolio under `modules/04-mqtt-integration/`:
1. MQTT Architecture Diagram: Diagram your pub/sub flow showing the M5Stack node, OpenWrt broker, Node-RED flow, and Python bridge.
2. QoS and LWT Protocol Analysis: In your own words, describe what happens at the network packet level when an MQTT client with LWT drops off the network without sending a `DISCONNECT` packet.
3. Integration Code & Flow: Commit your Python script and export your Node-RED flow JSON into your portfolio repository.
4. Reflection: Why is decoupling publishers from subscribers essential for scaling an IoT deployment across multiple teams and microservices?
