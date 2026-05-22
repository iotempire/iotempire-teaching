# Module 4 – Embedded Programming and Deploying Nodes

[← Previous: Module 3](./03-infrastructure-and-gateway-setup.md) | [Back to front page](../workbook.md) | [Quick module index](./00-index.md) | [Next: Module 5 →](./05-integration-and-simulations.md)

**Preparation:** Both Arduino and PlatformIO can be used.
PlatformIO IDE installation in VSCode ([Link](https://docs.platformio.org/en/latest/integration/ide/vscode.html#installation))

**Block placement:** This module is scheduled for **Day 2**, after the continuation and completion of Module 3.

## Breaking Things (with Software) and Simple Debugging via Serial Console Monitor

You might have already experienced occasional crashes while trying to debug in the serial console of the MCU. Let’s take a closer look together. C++ can be a strange beast. All these exercises will be done together. You will follow along while one of you is trying under instructor guidance. This will also allow you to take a look at basic debugging techniques with `Serial.print` statements.

In PlatformIO, don’t forget to add the following into your `platformio.ini` files to see something on the serial console:

`monitor_speed = 115200`

## Task 1: Simple Crash: Nullpointer Dereference

You might have heard of pointers in C; they are basically memory addresses. Sometimes they end up pointing into regions where they should not point. One of these regions is `0`, which is often also the initial value of a pointer. Let’s take the working PubSub example and break the client object initialization (and then fix it again). In Module 3 we used the new async MQTT library that is actually harder to break, so here we go back to the simpler PubSubClient library.

Start from here:
[https://raw.githubusercontent.com/knolleary/pubsubclient/refs/heads/master/examples/mqtt_esp8266/mqtt_esp8266.ino](https://raw.githubusercontent.com/knolleary/pubsubclient/refs/heads/master/examples/mqtt_esp8266/mqtt_esp8266.ino)

For example, you can add in the beginning of your code:

`char* super_message;`

And then in the callback:

- print something first
- then update `super_message[0] = 'A';`
- then print the message again

Share broken code in the portfolio and the fixed one too.

## Task 2: Simple Crash: Divide by Zero

Take the working code and break it again. Send a series of messages that will finally divide by zero and break the program again.

Start the value count at something like `10` and then count down and print the result similar to:

- decrement `value`
- print `1000 / value`

Share broken and fixed code in the portfolio.

## Share broken code in portfolio

Keep both the broken and the corrected versions as evidence of debugging and understanding.

## Task 3: Too Little Memory

Again, start from the fixed PubSub example.

Add and call a function similar to the original workbook example:

- allocate a `char* msg = new char[512]`
- write something into it with `sprintf`
- append it repeatedly to a static `String`
- publish it without freeing memory

Observe the resulting behavior.

Share broken and fixed code in the portfolio.

## Task 4: Crashing with interrupts

There is no easy way to achieve multi-tasking on the Arduino platform, apart from the WiFi thread — and you should be careful not to tamper with that. If you want multitasking, you need to share resources carefully.

Use the original example structure with:

- `ESP8266WiFi.h`
- `INPUT_PULLUP`
- `attachInterrupt`
- a volatile flag
- a blocking `delay(1000)` inside the interrupt handler

and investigate why it crashes when the button is pressed.

Focus on:

- what code is allowed inside an interrupt handler
- what blocking calls do inside interrupt context
- how shared state between interrupt and loop must be handled
- how WiFi timing interacts with this behavior

Put your personal notes into the portfolio, and describe in your own words why this is crashing.

(As far as we know this crashes not the esp32, but please try and report and ask AI how to do an interrupt based break on the esp32.)

## Task 5: OTA Flashing

How can you flash over the air with the built-in OTA library in PlatformIO? Start from the BasicOTA Arduino ESP8266 example.

We need to add a hostname with `WiFi.setHostname(hostname)` and `ArduinoOTA.setHostname(hostname)`. Then we can use the hostname directly to program the node without looking up its IP.

Add an OTA section into `platformio.ini` like this conceptually:

- environment for OTA upload
- `upload_protocol = espota`
- `upload_port = ota-test`
- `upload_flags = --auth=iotempower`

Do not forget to define a new hostname and adapt the OTA target accordingly.

ESP8266:
[https://raw.githubusercontent.com/esp8266/Arduino/refs/heads/master/libraries/ArduinoOTA/examples/BasicOTA/BasicOTA.ino](https://raw.githubusercontent.com/esp8266/Arduino/refs/heads/master/libraries/ArduinoOTA/examples/BasicOTA/BasicOTA.ino)

ESP32:
[https://raw.githubusercontent.com/espressif/arduino-esp32/refs/heads/master/libraries/ArduinoOTA/examples/BasicOTA/BasicOTA.ino](https://raw.githubusercontent.com/espressif/arduino-esp32/refs/heads/master/libraries/ArduinoOTA/examples/BasicOTA/BasicOTA.ino)

Put your own code into the portfolio; one code reference per pair is enough if linked by others.

## Task 6: Emergency Scenario: Better MQTT Alarm with smooth flashing

Listen to an MQTT topic and do smooth flashing via PWM on an `on` message, then send this via OTA. Extend a previous MQTT example and merge it with OTA support so the new code handles both MQTT and OTA.

Read up on PWM, for example here:
[Pulse Width Modulation - SparkFun Learn](https://learn.sparkfun.com/tutorials/pulse-width-modulation/all)

Hook up a simple LED with a resistor to a GPIO port of a Wemos D1 Mini.

The original workbook example uses:

- a callback that checks whether the topic is `alarm`
- `on` message starts flashing and stores a `startTime`
- `off` message stops flashing and calls `analogWrite(ledPin, 0)`
- a helper loop function computes smooth brightness values and stops after about 30 seconds

Put your own code into the portfolio.

## General information for adding an ESP32 (not a task)

Submit the code from following along with the projects described above.

The ESP32 in the kit is an **MH-ET LIVE ESP32 MiniKit**.

- In PlatformIO, set the board as `mhetesp32minikit`
- In Arduino IDE, you may need to follow this guide:
  [https://docs.espressif.com/projects/arduino-esp32/en/latest/installing.html](https://docs.espressif.com/projects/arduino-esp32/en/latest/installing.html)
- To flash the ESP32 MiniKit, you may need to wire `IO0` to `GND` before plugging it into USB
- Remove that wire after flashing and reboot or replug

## Task 7: MQTT to Serial to Serial to Console

### Scenario – Guard Communication in a Shielded Facility

Imagine that a very dangerous prisoner is being held inside a **heavily shielded metal facility** where **Wi-Fi signals cannot penetrate**. The only thing that can pass through the walls are **wired connections**.

Inside this protected facility there is also a **guard station**, and the guard must receive information about whether there are any external threats — for example, if the prisoner’s friends might attempt to break in and free him.

Outside the facility there is an **ESP node with Wi-Fi access** that receives messages from the **MQTT network**. This node then forwards these messages through a **serial cable** to another ESP node located **inside the protected facility**, near the guard station.

The inner node displays the messages on the **serial console** so that the guard can see the current security status.

Typical system messages could be:

- `all_clear`
- `possible_threat`
- `lockdown`

The message path should look like this:

- MQTT broker
- ESP node outside the facility (WiFi + MQTT)
- serial cable
- ESP node inside the protected facility
- serial console for the guard

### Part 1 – Research

Before starting, investigate and briefly describe in your portfolio:

1. How many **hardware serial (UART)** interfaces are available on:
   - ESP8266 / Wemos D1 Mini
   - ESP32 / MH-ET LIVE ESP32 MiniKit
2. Which Arduino objects (`Serial`, `Serial1`, `Serial2`) correspond to them, and which GPIO pins are typically used?
3. What is the difference between **hardware serial** and **software serial** communication? Which one is generally more stable, and when might software serial be needed?
4. Find the **EspSoftwareSerial** library and investigate how it can be used on ESP boards.

### Part 2 – Practical Task

Build a system with **two ESP nodes**.

#### Node A – Outside the protected facility

- connects to **Wi-Fi**
- connects to the **MQTT broker**
- subscribes to a topic such as `prison/security`
- when it receives a message (`all_clear`, `possible_threat`, `lockdown`), it forwards the message via **serial communication** to the second ESP node

Use the following libraries:

- **PubSubClient or AsyncMQTT**
- **EspSoftwareSerial**

#### Node B – Inside the protected facility

- **does not use Wi-Fi**
- listens for incoming **serial messages**
- prints the received text to the **Serial Monitor**

Example output:

`Security status: all_clear`

#### Hardware Connection

- TX (Node A) → RX (Node B)
- RX (Node A) → TX (Node B)
- GND → GND

### Delivery

Include in your portfolio:

- answers to the research questions
- the code for both nodes
- the wiring used between the nodes
- a short description of how the system works

## Task 8: Alarm Message on OLED mini Screen (on esp32 minikit)

- Make sure you picked up two ESP32 MiniKits
- Create a new PlatformIO project and select the **MH ET LIVE ESP32MiniKit** board
- Connect the `0.66" 64x48 Mini OLED` shield to the ESP32 MiniKit
- Note that it is not a perfect physical fit because it was meant for the Wemos D1 mini ESP8266
- Use the code below as a starter and adapt it to print an MQTT message received on a topic of your choice
- Make sure it connects to WiFi and MQTT broker
- Use OTA if possible to flash over WiFi

Use the original starter based on:

- `Wire.h`
- `U8g2lib.h`
- `U8G2_SSD1306_64X48_ER_F_HW_I2C`

and adapt the `Hello, World!` display to your own MQTT message display.

## Task 9: Use Node-RED to bridge Button, Alarm LED Strip, and Alarm Message

Now that you have nodes with some sensors and actuators, integrate them in a simple system using Node-RED.

- run `iot service start --web`
- Node-RED should be served on `https://localhost:1880/nodered/`
- user: `admin`
- password: `iotempire`
- find the **MQTT IN** and **MQTT OUT** nodes in the left menu
- study the nodes’ help on the top right menu

![][image7]

![][image8]

Create a simple system where the **button** node can:

- send a message to fire the **LED flashing** on the second node
- send a message to the OLED display node

Use phone or CLI MQTT tools to send and receive messages on your system.

**For the LED strip:**

- the reference schematic is for a 5V LED strip, but the classroom strip is **12V**
- use the Y cable to power the strip
- the RGB LED strip is arranged in triplets, every 3 LEDs behave like one pixel, so adjust the code accordingly
- pins are typically: red = power, green = signal, white = GND

Tips:

- understand how the MQTT server is configured on the MQTT IN and OUT nodes
- make sure your topics are correct
- use the **CHANGE** node too
- the **DEBUG** node is very useful

## Task 10: Optional: Build support for the BME/BMP280 i2c sensor or colr sensor of teh kit to run on the ESP32 MiniKit

- Verify whether you have BME280 or BMP280 and select the library correspondingly
- For BME280, use Adafruit’s BME280 library
- You can also try out to use the color sensor from the Arduino kit (and post it to an mqtt topic)

### Optional: Alarm LED Strip extension

Extend the smooth flashing via PWM node to flash the LED strip with 10 LEDs.

Attention: use **NeoPixelBus** (to avoid interrupt crashes that can happen with FastLED when using WiFi and MQTT).

## Task 11: Optional: Build support for the VL53L0X LIDAR Distance sensor to run on the ESP32 MiniKit

- Find and test libraries to see which one can run on the ESP32 with multitasking (WiFi) without crashing
- Report crashes and successes
- Give it an honest try; crash documentation is still useful evidence

## Task 12: Optional: LED Animation

If you have spare resources, try to build a simple animation for the LED strip.

## Task 13: Optional: Deep Sleep

Test the deep sleep functionality of the Wemos D1 Mini. Why is deep sleep needed?


[image7]: ../images/image7.png
[image8]: ../images/image8.png
