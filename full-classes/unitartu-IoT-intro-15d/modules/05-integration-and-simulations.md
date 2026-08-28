# Module 5 – Integration and Simulations

[← Previous: Module 4](./04-embedded-programming-and-deploying.md) | [Back to front page](../workbook.md) | [Quick module index](./00-index.md) | [Next: Module 6 →](./06-iot-systems.md)


**Placement:** The tasks in this module assume working infrastructure and embedded nodes from Modules 3-4. This module focuses on orchestration, simulation, and user interfaces, expanding into Node-RED workflows and mock data sources with HVAC and access control scenarios.


## Task 1: HVAC system with Integration and Simulators/Mockups


This integrated task explores command-and-control patterns for simulated HVAC systems with contention safety and notification. The setup includes both simulated components (mock nodes) and real sensors/actors as rehearsal for building real integrations.


### Task 1.1: Integration (Orchestration)

The goal is to build an automated HVAC controller in Node-RED:

- Use MQTT to connect Node-RED to sensor nodes and actor nodes
- Create a flow that:
  - Subscribes to temperature readings from one MQTT topic (e.g. `environment/temperature`)
  - Publishes cooling/heating commands to another topic (e.g. `hvac/relaycontrol`)
  - Includes a user dashboard control to override or set target temperature
  - Adds visual feedback (dashboard gauge and history chart)

- Provide clear logging and reflection on integration pitfalls


### Task 1.2: Simulators (Testers)

Build simplified mocked data sources and consumers to test your HVAC system without live hardware:

- **Mock Temperature Sensor**: Generate periodic temperature readings (e.g. every 5 seconds) mimicking real drift and noise; random walk or sine-wave
- **Mock Actor Node**: Simulate a relay lock actuator with blinking LED or console log; no real hardware required
- **Scenario Testing**: Simulate extreme temperatures to verify your controller logic and dashboard response

Document lessons learned in your portfolio, especially around message formats, update rates, and contention handling (race conditions, double writes).


## Task 1 (Still): HVAC system with real sensors in Node-RED


Replace mock components with real sensors and actors:


### Task 1.3: Sensor: NODE with Temperature Sensor
Add a real Dallas DS18B20 or DHT22 temperature sensor via OneWire or DHT library on an ESP8266/32. Publish readings to MQTT topic `environment/temperature`.


- Wiring pins: Ensure pull-up resistor on data line if using OneWire (4.7kΩ–10kΩ to 3.3V)
- Code: Use Adafruit_DHT or OneWire library; read every N seconds and publish to MQTT
- Dashboard: Display live temperature with timestamp

### Task 1.4: Actor: Second NODE with Relay + lock to simulate AC
Add a second ESP node with relay and 12V solenoid lock to simulate air conditioning (lock = AC on). Control via MQTT topic `hvac/relaycontrol` with payload _0_/_1_. 

- Safety: Limit activation to 1-2 seconds to prevent overheating
- Node-RED flow: Trigger on temperature threshold → publish to MQTT topic → node activates relay

### Task 1.5: Rebuild integration and simulation in Node-RED with Dashboard
Integrate both hardware nodes into a unified Node-RED HVAC flow with:

- Dashboard gauge showing live temperature
- Temperature history chart (last 60 data points)
- Manual override switch (disable automatic cooling)
- Threshold slider (define target temperature)
- Alert when temp exceeds threshold for >60 seconds

Ensure Node-RED connection is accessible on any network device via your Wi-Fi IP address, not just localhost.

Use sensible defaults for ports, topics, and retention policy.


## Task 2: Full Access Control system in Node-RED

Build a complete RFID-based access control flow in Node-RED integrating multiple sensors and actors:

## More actuators and sensors

- RFID reader interface and Node-RED UI for card registration
- Ultrasonic/PIR/LIDAR presence detector
- UI sound alert (buzzer/PWM) on entry
- Mini OLED text receiver for messages
- PWM LED or RGB LED for status indication


### Task 2.1: Sensor: RFID reader and UI

Wire an MFRC522 RFID reader to an ESP32 via SPI and:

- Read card UIDs and send to MQTT topic `access/rfid`
- Maintain an allow-list in Node-RED; respond to new cards with permission request UI
- Display access logs on dashboard; store last N entries
- Include a manual override input (toggle) on dashboard to deny all new entries temporarily

Use [MFRC522 library](https://github.com/miguelbalboa/rfid) for ESP32/NodeMCU.


### Task 2.2: Sensor: Ultrasonic Distance Sensors (also LIDAR laser or PIR sensor) as “presence” detector

Connect an HC-SR04 ultrasonic sensor or PIR motion sensor to ESP8266/ESP32 and:

- Publish presence events (0/1) to MQTT topic `access/motion/`
- Wire according to datasheet; mind required logic levels and power (5V→level shifter)
- Calibrate max range (ultrasonic) or sensitivity (PIR, ~7m horizontal)
- Add hysteresis to avoid chatter; Node-RED flow debounces events

### Task 2.3: Actor: UI Sound notification/PWM Buzzer
Tie Node-RED flow to PWM buzzer on a separate ESP node (or same node via level shifter) on GPIO pin 18.
- Sound 500ms on each RFID access (success or failure) and on presence detected
- Use tone() or analogWrite() depending on buzzer type (active vs passive)

### Task 2.4: Actor: Mini OLED Text receiver
Connect SSD1306 OLED to separate ESP node on I2C; listen to MQTT topic `access/info` and display first packet on screen (e.g. “Alice: ENTERED 10:13”).
- Use U8g2 library; show scroll if text > line width

### Task 2.5: Actor: PWM LED or RGB Led
Connect WS2812 NeoPixel LED strip (3 LEDs) or common cathode RGB LED to ESP I/O. Node-RED flow publishes on `access/status`:
- “granted” → green fade
- “denied” → red flash
- “timeout” → blue sweep
- “alarm” → red strobe

Ensure power budget: 3 LEDs at 50% brightness ≈ 45mA at 5V; no external supply needed.


## Task 3: Optional Display Weather info on OLED display
Wire an SSD1306 OLED to an ESP8266 and fetch open-worldweather.org API (or use mock data) and display basic weather info (temperature, humidity) on the OLED at 10–30 second refresh rate.
Use [ESP8266 Weather Station](https://github.com/ThingPulse/esp8266-weather-station) codebase for inspiration.


## Task 4: Optional: Discord/Telegram bridge
Add Node-RED flows that bridge MQTT topics to Discord or Telegram webhooks:
- Alert when new device registered (RFID ok)
- Alert when presence detected during closed hours or unauthorized card
- Ad-hoc commands from group chat (restart nodes, dump logs)
Document setup procedure in your portfolio, including webhook creation and limitations.

*
*Wire connections and pin mappings are modular; adapt per available hardware and avoid assuming exact boards.*