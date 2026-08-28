# Module 4 – Embedded Programming and Deploying Nodes

[← Previous: Module 3](./03-infrastructure-and-gateway-setup.md) | [Back to front page](../workbook.md) | [Quick module index](./00-index.md) | [Next: Module 5 →](./05-integration-and-simulations.md)

**Preparation**: Both Arduino and PlatformIO can be used.  
PlatformIO IDE installation in VSCode ([Link](https://docs.platformio.org/en/latest/integration/ide/vscode.html#installation))


All embedded programming tasks build on the gateway and network setup from Module 3 and use IoTempower or the Arduino IDE/Programming for embedded development. The goal is becoming proficient in building robust microcontroller nodes, uploading firmware, and debugging runtime issues.


## Breaking Things (with Software) and Simple Debugging via Serial Console Monitor


You might have already experienced occasional crashes while trying to debug in the serial console of the MCU. Let’s take a closer look together. C++ can be a strange beast. All these exercises will be done together. You will follow along while one of you is trying under Ulno’s guidance. This will also allow you to take a look at basic debugging techniques with Serial.print statements.


In PlatformIO, don’t forget to add the following into your platformio.ini files to see something on the serial console: 
Tasks:

1. Simple crash: null pointer dereference
2. Simple crash: divide by zero
3. Too little memory
4. Crashing with interrupts
5. OTA flashing
6. Emergency Scenario: Better MQTT Alarm with smooth flashing
7. Adding an ESP32 (new board platform)
8. Task 7: MQTT to Serial to Serial to Console
9. Task 8: Alarm Message on OLED mini Screen (on ESP32 minikit)
10. Task 9: Use Node-RED to bridge Button, Alarm LED Strip, and Alarm Message
11. Task 10: Optional: Build support for the BME/BMP280 i2c sensor to run on the ESP 32 - Minikit
12. Task 11: Optional: Build support for the VL53L0X LIDAR Distance sensor i2c sensor to run on the ESP 32 - Minikit
13. Task 12: Optional: LED-Animation
14. Task 13: Optional: Deep Sleep

## Notes on the tasks

- The crash tasks are intended for understanding runtime failure modes.
- OTA flashing is introduced for faster wireless iteration.
- The later tasks extend earlier MQTT work into richer embedded nodes.
- The ESP32 minikit is introduced as a second board platform.

### Adding an ESP32

The workbook introduces the **MH-ET LIVE ESP32 MiniKit** and notes that `IO0` may need to be wired to `GND` during flashing.


### Task 7: MQTT to Serial to Console

This task bridges Wi-Fi/MQTT outside a shielded facility to a serial-only node inside, simulating a physical separation with useful security and IoT implications.


#### Scenario – Guard Communication in a Shielded Facility

Choose your own creative scenario or use the guard communication theme provided by [https://iot.moodle.cs.hm.edu/pluginfile.php/112840/mod_resource/content/1/dokuwiki_guard_scenario.pdf](https://iot.moodle.cs.hm.edu/pluginfile.php/112840/mod_resource/content/1/dokuwiki_guard_scenario.pdf) for context.

In this scenario:

- **Node A – Outside the protected facility**: Reads external temperature using DHT sensor and publishes MQTT message to the broker via Wi-Fi
- **Node B – Inside the protected facility**: Runs MQTT-Serial only due to facility restrictions. Receives MQTT over serial connection, decodes temperature, and displays it. You can also add the serial interfacing and printing to serial console.


#### Part 1 – Research

- Research STM32 / arduino/ esp platforms restrictions and regulations (EMI, radio bands)
- Research physical layer limitations of Serial communication for interfacing MCU with MCU/facility computer- Read following references:
  - SoC wireless regulation differences (US FCC vs. EU ETSI)
  - Typical intra-facility distance for considered interfaces (Serial is only reliable at short distances as opposed to MQTT and WiFi)
  - RS-485 or other interfaces, typical pull-up topologies, and resistances
  - IEEE 802.3 (ethernet) and 802.11 standards (wifi) physical layer limitations
  - **optional** for advanced students: physical layer of LoRa/LoRaWAN, SigFox, NFC, Bluetooth, or cellular.

- Implement a simple connection over a serial link

- **Document** the serial communication interface in detail including: baud rate, word size, parity, stop bits.

- Run the basic example and make a proof of concept using one of the boards and document the results into your portfolio.



List five communication protocols and name their physical layers and maximum distance.


#### Part 2 – Practical Task



Pick one PART A or PART B:


**A: Serial over USB or TTL serial – Guards’ room**


**Hardware connections:**
 - The simplest and most practical approach for an Arduino Uno or ESP8266/32 with a USB port is a physical USB connection to the facility computer under guard control.
 - All devices can be powered off a single power supply by using a USB hub or internal port expansion.



**Example code or inspiration:**
Create a sketch that consists of two communicating devices, one acting as a "sender", the other as a "receiver", connected via their Serial.


**Steps:**
1\. Connect two devices (e.g. two arduino unos) together with **TX** (transmit) to **RX** (receive) and GND to GND using jumper cables under 2m distance (stronger pull-up; different length).
2\. Use Arduino IDE for both sketches, write either Serial Talk or use the Serial Passthrough provided in the arduino IDE Serial Monitor for both boards.
3\. Verify communication works by having one board send text to the other.

4\. Adapt code to send temperatures in the correct format (using DHT sensor connected to one board, sending values over serial connection to the second board).
5\. Modify the second board to receive the serial information on the serial console and display it (on a secondary oled connected via I2C or on the primary serial console).

6\. Document your setup and the serial settings used in your portfolio.



**B: Point-to-Point RS-485 link – Long range guards’ room**



**Hardware connections:**
If your facility is larger than 2-5m, an RS-485 bus might be a more applicable alternative:
- Using an RS-485 transreciever module on both ends for long-range wired communication
- terminate with **120 Ohm** bus termination resistors at both ends
- Use **pull-up/pull-downs** if required by the modules to prevent floating line states when no sender is active


**Example code or inspiration:**
- Implement communication that conforms to ([https://github.com/mikalhart/TinyGPSPlus](https://github.com/mikalhart/TinyGPSPlus)) for message framing
- **Test** by sending dht values over your rs-485 link with the [https://github.com/adafruit/Adafruit_DHT](https://github.com/adafruit/Adafruit_DHT) library


**Steps:**
1\. Connect RS-485 module to both boards (uart connections) including power.
2\. Wire the buses as follows - A to A, B to B (do not forget GND and power rails) and terminate appropriately with 120 Ohm.
3\. Use a modified Arduino SerialPassthrough example using either TinyGPS or a simple frame protocol to send/receive data
4\. connect both arduinos to a same power supply and wires in a Y cable (cut apart USB cable and solder it for intance) and deliver power to both boards
5\. Implement to send/receive (sensor) information over the RS485 link and document your process in your portfolio.



#### Delivery

Document your work in the portfolio with a small writeup and code; if you went with a creative scenario, include a simple one-page handout that might help reproduce your concept.



### Task 8: Alarm Message on OLED mini Screen (on ESP32 minikit)


Goal: Rework the starter code ([https://iotempower.us/support/starter-code/](https://iotempower.us/support/starter-code/)) for the ESP32 MiniKit OLED shield to display team messages pushed through MQTT. Discuss the architecture and message design in your reflection.

- Connect the OLED display to the ESP32 MiniKit
- Receive an MQTT message on topic `station/alerts` on your local network
- Parse the incoming message and display it on the OLED screen
- You may need to resize/adjust sample code.


### Task 9: Use Node-RED to bridge Button, Alarm, LED Strip, and OLED Message

Use Node-RED to connect a button event to:

- MQTT message to topic `station/alerts`
- an LED flashing sequence (on a separate ESP8266 node via MQTT message topic `station/ledcontrol`)
- OLED message display (on ESP32 via MQTT message `station/oled`)
  
Create a **flow** that listens for a button press, forwards the alert to these outputs, and visualizes the message in a simple Node-RED dashboard.

![][images/alert-flow-diagram.png]

> [!NOTE]
> This integration highlights how Node-RED can orchestrate events across multiple hardware platforms and protocols.

### Task 10: Optional: Build support for the BME/BMP280 i2c sensor on the ESP 32 - Minikit

Connect BME280 or BMP280 sensor to ESP32 via I2C (SCL, SDA pins), read and publish temperature and humidity/pressure data to MQTT topic `environment/sensors`.

- Use [Adafruit BME280 library](https://github.com/adafruit/Adafruit_BME280_Library) or [Adafruit BMP085 library](https://github.com/adafruit/Adafruit-BMP085-Library) depending on your sensor type
- Generate meaningful temperature, humidity, and pressure readings
- Display or store data in a Node-RED dashboard.


Customize the sensor rate and readings according to your desired use case.


### Task 11: Optional: Build support for the VL53L0X LIDAR Distance sensor on the ESP 32 - Minikit
Add VL53L0X LIDAR distance sensor to the ESP32 mini-kit over I2C and publish measurements to MQTT topic `sensors/range`.

- Use [Pololu VL53L0X library](https://github.com/pololu/vl53l0x-arduino)
- Implement distance measurement loop and MQTT publishing
- Optional extension: Add LED strip lighting effects based on proximity (e.g., warn when < 0.5m)


### Task 12: Optional: LED-Animation
Implement a custom LED strip animation on WS2812 addressable LEDs. Display patterns and react to MQTT topics controlling start, color, or speed.

### Task 13: Optional: Deep Sleep

Enable deep sleep mode on ESP32 to reduce power consumption and demonstrate wakeup from deep sleep requiring an external interrupt (e.g., button press or external wakeup pin).