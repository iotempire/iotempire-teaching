# Module 5 – Integration and Simulations

[← Previous: Module 4](./04-embedded-programming-and-deploying.md) | [Back to front page](../workbook.md) | [Quick module index](./00-index.md) | [Next: Module 6 →](./06-iot-systems.md)

**Block placement:** This module is scheduled for **Day 3** of the condensed four-day HSBI/GT workshop.

## Integration and Simulations

At this point, we assume that you can do the following things:

1. Set up a spontaneous network infrastructure (hint: power your Mango from a >=2A USB charger).
2. Send and receive messages via phone, Node-RED, and CLI in MQTT with at least one MQTT broker in your local network.
3. Flash Wemos D1 Mini or ESP32 MiniKit from your own computers.
4. Work in Visual Studio Code or Arduino IDE on your PC.
5. Use git and a markup language.

In class, you are expected to already be operational with the infrastructure basics and continue more independently.

Watch the [IoTknit](https://github.com/iotempire/iotknit) video and, ideally before class, take notes or try to set up a programming sketch:
[https://youtu.be/a3p9lALoUQY](https://youtu.be/a3p9lALoUQY)

Optional recap videos:

- MQTT barebones: [https://youtu.be/RxrCS5Fi2LY](https://youtu.be/RxrCS5Fi2LY)
- Node-RED recap: [https://youtu.be/ycTVafrn3Pw](https://youtu.be/ycTVafrn3Pw)

## Task 1: HVAC system with Integration and Simulators/Mockups

### Task 1.1: Integration (Orchestration)

Integration, in the sense used here, is about separation of concerns, integration, testing, scaling, and orchestration.

- Rebuild the air conditioning integrator component from the [video](https://youtu.be/a3p9lALoUQY?list=PLlppUpfgGsvkfAGJ38_mzQc1-_Z7bNOgq)
- the original example is with IoTknit in Python, but you may also build your own directly with `paho.mqtt` or another language/tool
- put your code in the portfolio and provide a small explanation of the problems faced and the steps taken

### Task 1.2: Simulators (Testers)

Build two simulator components (software mockups of actual hardware sensors that behave like the hardware):

- **Temperature Simulator:**
  - publishes temperature values on a specific topic
  - values should slowly rise and then slowly drop again, then repeat
- **AC Simulator:**
  - subscribes to on/off values on a specific `/set` topic
  - presents its own status on the console or a UI, for example by repeatedly displaying whether AC is on or off

Show the two simulators with the integrator in concert and fix things if they do not work.

Tips: if IoTknit is not working well for the simulators, `paho.mqtt` or another MQTT-capable approach is fine.

Supply steps, code, and screenshots from running everything together in the portfolio.

## Task 1 (still): HVAC system with real sensors in Node-RED

**Attention:** When attaching new actors or sensors to a microcontroller, disconnect the microcontroller from power first. Most things use 3.3V. Only wire things to 5V if explicitly stated. Be even more careful when using 12V.

### Task 1.3: Sensor: Node with Temperature Sensor

Connect the Dallas sensor shield onto a tripler (or with dupont cables) onto an ESP and program it with PlatformIO or Arduino IDE to send the measured temperature to an MQTT topic.

### Task 1.4: Actor: Second Node with Relay + Lock to simulate AC

Remember the relay and lock system from Module 2 task 7. Use it to simulate an air conditioner turning on and off.

- build a node that listens to a topic and turns on/off depending on the message
- create a different topic to report the status of the AC (`ON` / `OFF`)
- make sure it re-reports the status every 5 seconds
- careful: the lock gets hot when turned on too long, so keep activation short

### Task 1.5: Rebuild integration and simulation in Node-RED with Dashboard

Node-RED: [http://localhost:40080/nodered/](http://localhost:40080/nodered/)
Node-RED dashboard: [http://localhost:40080/](http://localhost:40080/)

1. Debug your hardware with the Node-RED dashboard:
   - display the temperature sensor values as a chart, slider, or gauge
   - also display a label like `Temperature: 25C`
   - use a **switch** node to turn AC on and off
   - make the switch show the actual state of the physical switch in the dashboard
2. Rebuild your MQTT integration component in Node-RED.
3. Rebuild the switch simulator / AC unit simulator with a Node-RED dashboard text field whose color and value change depending on status.

The original workbook includes a sample importable flow for colored dashboard text. That flow should be preserved conceptually during later cleanup.

Please deliver your implementation steps, screenshots of flows, and exports of your flows for the portfolio.

## Make sure you can see your dashboard on any device on the network using a browser

**In the end you must have for Task 1:**

1. 2 simulators for temperature sensor: 1 in Node-RED and 1 in IoTknit or a language of your choice
2. 1 physical implementation of a temperature sensor using a microcontroller node
3. 2 simulators for AC unit: 1 in Node-RED and 1 in IoTknit or a language of your choice
4. 1 physical implementation of AC unit actor using a microcontroller node reporting its status every 5 seconds
5. 1 integrator for the system in IoTknit or a language of your choice
6. 1 integrator in a Node-RED flow with a dashboard and several debugging views

## Task 2: Full Access Control System in Node-RED

In this project, you will put together what you have learned so far. Build an access control system using the RFID reader, RGB LED, buzzer, OLED display, and the relay with the solenoid drawer lock.

When access is granted:

- open the lock
- make sure it locks again after a short while
- write an access message to the display
- turn the LED green
- make a positive buzzer sound

## More actuators and sensors

Please deploy each sensor and actor in a different node, meaning different microcontroller boards, where possible.

### Task 2.1: Sensor: RFID reader and UI

- Connect the RFID-RC522 RFID tag reader via SPI to a Wemos D1 Mini and program it.
- Check a reference video if needed: https://www.youtube.com/watch?v=JcuzLO_2g3E
- Evaluate the UID of the tag in Node-RED (check at least two RFID tags)
- Based on the detected UID, make a Node-RED dashboard button either red and display `Access Denied` or green and display `Access Granted`
- If you press the button, reset its color and make it display `Scan Tag`
- Optionally try out your own personal tags if the given ones show no ID
- Power the reader from the multiport USB charger

The original workbook includes a detailed wiring diagram for the RFID reader using 3V3, D8, D7, D6, D5, D0, and GND.

### Task 2.2: Sensor: Ultrasonic Distance Sensor / LIDAR / PIR as “presence” detector

Connect the 3.3V ultrasonic distance sensor (or LIDAR / PIR if used) to an ESP and program it to send measured distance or detected signal to an MQTT topic.

This is supposed to detect if there is an actual person in front of the door before it unlocks.

### Task 2.3: Actor: UI Sound notification / PWM Buzzer

Use the code from the PWM LED project to deploy a new node.

- replace the LED with a buzzer
- register a new topic
- vary the sound with PWM
- create a dashboard slider to control the sound of the buzzer
- optionally add a second slider for frequency
- extend this to playing notification sounds
- in the Node-RED dashboard, create a notification system that plays a short deny-sound when access is denied

All necessary functionality should already be available in the installed dashboard nodes.

### Task 2.4: Actor: Mini OLED Text receiver

Use the OLED I2C display mini project to implement a text receiver for the access control system.

Examples:

- `Access granted`
- `Access denied`
- `Welcome home [your name]`

Send some MQTT messages via phone or Mosquitto CLI tools to test that the message arrives on the display.

### Task 2.5: Actor: PWM LED or RGB LED

If you managed smooth flashing via PWM before, now use Node-RED to control the brightness (duty cycle) of 2 LEDs (green and red).

- observe whether the smoothness changes when controlled by Node-RED
- integrate the LEDs into the access control system
- red for access denied
- green for access granted
- or use one RGB LED if available

## Task 3: Optional: Display Weather info on OLED display

While the OLED display is idle and not being used by the access control, fetch some weather info from an API and display it there.

Find out on your own how this can be done using Node-RED.

## Task 4: Optional: Discord/Telegram bridge

Build a bridge to Discord or Telegram to interact with your security system: notifications of attempted access and possibility to remote unlock.
