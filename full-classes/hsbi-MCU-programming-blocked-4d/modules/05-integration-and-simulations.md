# Module 5 – Integration and Simulations

[← Previous: Module 4](./04-embedded-programming-and-deploying.md) | [Back to front page](../README.md) | [Quick module index](./00-index.md) | [Next: Module 6 →](./06-iot-systems.md)

**Block placement:** This module is scheduled for **Day 3** of the condensed four-day HSBI/GT workshop.

## Integration and Simulations

The instructor will lead through this prelude and talk and discuss a bit about the need for integration.

At this point, we assume that you can do the following things:

1. Set up a spontaneous network infrastructure (hint: power your Mango or small router from a >=2A USB charger -- do not power it from your computer USB port - nobody did so far, but was an issue in other classes).
2. Send and receive messages via phone, Node-RED, and CLI in MQTT with at least one MQTT broker in your local network.
3. Flash Wemos D1 Mini or ESP32 MiniKit from your own computers.
4. Work in Visual Studio Code with PlatformIO or Arduino IDE on your PC.
5. Use git and a markup language.

In class, you are expected to already be operational with the infrastructure basics and continue more independently.

We will  skip the Python programming with IoTknit in class,
but consider taking a look if you are interested and know a bit about Python.

> Optional at HSBI:
> 
> Watch the [IoTknit](https://github.com/iotempire/iotknit) video and, ideally before class, take notes or try to set up a programming sketch:
>[https://youtu.be/a3p9lALoUQY](https://youtu.be/a3p9lALoUQY)

Optional (in general) recap videos:

- MQTT barebones: [https://youtu.be/RxrCS5Fi2LY](https://youtu.be/RxrCS5Fi2LY)
- Node-RED recap: [https://youtu.be/ycTVafrn3Pw](https://youtu.be/ycTVafrn3Pw)

## Task 1: HVAC system with Integration (Orchestration) and Simulators/Mockups (Testers)

### Task 1.1: Purely software integrator + mocks
Integration, in the sense used here, is about separation of concerns, integration, testing, scaling, and orchestration.

Build integration and mock components of an air condition unit in Node-RED:

1. one flow that shows with a colored button (check hints below) in the dashboard 2 if it is turned on or off (the air conditioner mock-up) and listens on an mqtt topic for state changes

2. one flow that let's you set the temperature with the dashboard 2 slider and sends it to an mqtt topic

3. a flow that is the integrator that decides when to tund the air conditioner on or off
This can be done on one node-red installation, but is more fun when different components/flows are deployed on different installations

> Old (now optional for HSBI) Python based part:
>
> - Rebuild the air conditioning integrator component from the [video](https://youtu.be/a3p9lALoUQY?list=PLlppUpfgGsvkfAGJ38_mzQc1-_Z7bNOgq)
> - the original example is with IoTknit in Python, but you may also build your own directly with `paho.mqtt` or another language/tool
> - put your code in the portfolio and provide a small explanation of the problems faced and the steps taken
>
> Build two simulator components (software mockups of actual hardware sensors that behave like the hardware):
>
> - **Temperature Simulator:**
>   - publishes temperature values on a specific topic
>   - values should slowly rise and then slowly drop again, then repeat
> - **AC Simulator:**
>   - subscribes to on/off values on a specific `/set` topic
>   - presents its own status on the console or a UI, for example by repeatedly displaying whether AC is on or off

Show the two simulators with the integrator in concert and fix things if they do not work.

> Old tips: if IoTknit is not working well for the simulators, `paho.mqtt` or another MQTT-capable approach is fine.

Supply steps, code, and screenshots from running everything together in the portfolio.

## Task 1.2+: HVAC system with real sensors in Node-RED

**Attention:** When attaching new actors or sensors to a microcontroller, disconnect the microcontroller from power first. Most things use 3.3V. Only wire things to 5V if explicitly stated. Be even more careful when using 12V.

### Task 1.2: Sensor: Node with Temperature Sensor

Connect the Dallas sensor shield onto a tripler (or with dupont cables) onto an ESP and program it with PlatformIO or Arduino IDE to send the measured temperature to an MQTT topic. Why do I ask you to not slot it on directly? You can also use the long cable water proof dallas sensor with a 5K resistor (check exact wiring online).

### Task 1.3: Actor: Second Node: AC as smoothly flashing LED

Remember the smoothly flashing led? Use it to simulate an air conditioner turning on and off: This means, the light nicely pulsates when it is turned on and simply turned off when everything is turned off.

- build a node that listens to a topic and turns on/off the pulsating led depending on the message
- create a different topic to report the status of the AC (`ON` / `OFF`)
- make sure it re-reports the status every 5 seconds


<!--### Task 1.5: Rebuild integration and simulation in Node-RED with Dashboard

Node-RED: [http://localhost:40080/nodered/](http://localhost:40080/nodered/)
Node-RED dashboard: [http://localhost:40080/](http://localhost:40080/)

1. Debug your hardware with the Node-RED dashboard:
   - display the temperature sensor values as a chart, slider, or gauge
   - also display a label like `Temperature: 25C`
   - use a **switch** node to turn AC on and off
   - make the switch show the actual state of the physical switch in the dashboard
2. Rebuild your MQTT integration component in Node-RED.
3. Rebuild the switch simulator / AC unit simulator with a Node-RED dashboard text field whose color and value change depending on status.-->

Hint: **Import** the following flow and adjust in Node-RED for the colored button:

**flow, copy and import:**

```json
[{"id":"1d969f873d804748","type":"ui-button","z":"f990f90b36e918f9","group":"f4ce9dbd36ee6e28","name":"","label":"test-button","order":0,"width":0,"height":0,"emulateClick":false,"tooltip":"","color":"","bgcolor":"","className":"","icon":"","iconPosition":"left","payload":"blue","payloadType":"str","topic":"topic","topicType":"msg","buttonColor":"","textColor":"","iconColor":"","enableClick":true,"enablePointerdown":false,"pointerdownPayload":"","pointerdownPayloadType":"str","enablePointerup":false,"pointerupPayload":"","pointerupPayloadType":"str","x":390,"y":160,"wires":[["1666c12a70cb0df2"]]},{"id":"6ffe7c85636f2b5e","type":"inject","z":"f990f90b36e918f9","name":"","props":[{"p":"ui_update.buttonColor","v":"red","vt":"str"},{"p":"payload"}],"repeat":"","crontab":"","once":false,"onceDelay":0.1,"topic":"","payload":"test","payloadType":"str","x":150,"y":140,"wires":[["1d969f873d804748"]]},{"id":"6c306b1e5866a87d","type":"ui-button","z":"f990f90b36e918f9","group":"f4ce9dbd36ee6e28","name":"","label":"green","order":0,"width":0,"height":0,"emulateClick":false,"tooltip":"","color":"","bgcolor":"","className":"","icon":"","iconPosition":"left","payload":"green","payloadType":"str","topic":"topic","topicType":"msg","buttonColor":"","textColor":"","iconColor":"","enableClick":true,"enablePointerdown":false,"pointerdownPayload":"","pointerdownPayloadType":"str","enablePointerup":false,"pointerupPayload":"","pointerupPayloadType":"str","x":130,"y":220,"wires":[["1666c12a70cb0df2"]]},{"id":"fe99edef4d34d15c","type":"ui-button","z":"f990f90b36e918f9","group":"f4ce9dbd36ee6e28","name":"","label":"red","order":0,"width":0,"height":0,"emulateClick":false,"tooltip":"","color":"","bgcolor":"","className":"","icon":"","iconPosition":"left","payload":"red","payloadType":"str","topic":"topic","topicType":"msg","buttonColor":"","textColor":"","iconColor":"","enableClick":true,"enablePointerdown":false,"pointerdownPayload":"","pointerdownPayloadType":"str","enablePointerup":false,"pointerupPayload":"","pointerupPayloadType":"str","x":130,"y":360,"wires":[["1666c12a70cb0df2"]]},{"id":"1666c12a70cb0df2","type":"change","z":"f990f90b36e918f9","name":"","rules":[{"t":"set","p":"ui_update.buttonColor","pt":"msg","to":"payload","tot":"msg"}],"action":"","property":"","from":"","to":"","reg":false,"x":430,"y":340,"wires":[["1d969f873d804748"]]},{"id":"f4ce9dbd36ee6e28","type":"ui-group","name":"Group Name","page":"1346afdac5fdd33f","width":6,"height":1,"order":-1,"showTitle":true,"className":"","visible":"true","disabled":"false","groupType":"default"},{"id":"1346afdac5fdd33f","type":"ui-page","name":"testing","ui":"f3796c1c0479c671","path":"/page3","icon":"home","layout":"grid","theme":"bdb96990ac424a7f","breakpoints":[{"name":"Default","px":"0","cols":"3"},{"name":"Tablet","px":"576","cols":"6"},{"name":"Small Desktop","px":"768","cols":"9"},{"name":"Desktop","px":"1024","cols":"12"}],"order":-1,"className":"","visible":"true","disabled":"false"},{"id":"f3796c1c0479c671","type":"ui-base","name":"My Dashboard","path":"/dashboard","appIcon":"","includeClientData":true,"acceptsClientConfig":["ui-notification","ui-control"],"showPathInSidebar":false,"headerContent":"page","navigationStyle":"default","titleBarStyle":"default","showReconnectNotification":true,"notificationDisplayTime":1,"showDisconnectNotification":true,"allowInstall":false},{"id":"bdb96990ac424a7f","type":"ui-theme","name":"Default Theme","colors":{"surface":"#ffffff","primary":"#0094CE","bgPage":"#eeeeee","groupBg":"#ffffff","groupOutline":"#cccccc"},"sizes":{"density":"default","pagePadding":"12px","groupGap":"12px","groupBorderRadius":"4px","widgetGap":"12px"}},{"id":"6d42fcaebd2f3da4","type":"global-config","env":[],"modules":{"@flowfuse/node-red-dashboard":"1.29.0"}}]
```

You can also realize the same with a dashboard button - for that one, assigning the color is explained in the local Node-RED manual. 

Please deliver your implementation steps, screenshots of the flows, and exports of your flows for your portfolio. 

<!--## Make sure you can see your dashboard on any device on the network using a browser

**In the end you must have for Task 1:**

1. 2 simulators for temperature sensor: 1 in Node-RED and 1 in IoTknit or a language of your choice
2. 1 physical implementation of a temperature sensor using a microcontroller node
3. 2 simulators for AC unit: 1 in Node-RED and 1 in IoTknit or a language of your choice
4. 1 physical implementation of AC unit actor using a microcontroller node reporting its status every 5 seconds
5. 1Z integrator for the system in IoTknit or a language of your choice
6. 1 integrator in a Node-RED flow with a dashboard and several debugging views-->

## Task 2: Full Access Control System in Node-RED

In this project, you will put together what you have learned so far. Build an access control system using the RFID reader, RGB LED, buzzer, OLED display, and the relay with the solenoid drawer lock.

When access is granted (the following is the task description, it is broken down in subtasks below):

- open the lock
- make sure it locks again after a short while
- write an access message to the physical display (oled or LCD)
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

Here is the wiring diagram for the RFID-reader:

```
        Wemos D1 Mini/    mfrc522/

         NodeMCU      -  rfid-rc522 board
         (esp32)

             3V3      -  3.3V
              D8 ( 5) -  sda
              D7 (23) -  MOSI
              D6 (19) -  MISO
              D5 (18) -  SCK
              D0 (26) -  RST
               G      -  GND
             N/C      -  IRQ (IRQ not needed in a polling library)
```

You will face alot of connection challenges and interferences in this task, embrace the challenges and make sure to document them in your portfolio task reports.

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
- remark: there are some buzzers that can be turned on or off to make a sound and some that react to PWM for different tones - use the latter

All necessary functionality should already be available in the installed dashboard nodes.

### Task 2.4: Actor: Mini OLED Text receiver

Use the OLED I2C display mini project to implement a text receiver for the access control system (or if you used the LCD display, use that - or if you want ot challnege yourself take the respective other)

Examples:

- `Access granted`
- `Access denied`
- `Welcome home [your name]`

Send some MQTT messages via phone or Mosquitto CLI tools to test that the message arrives on the display.

### Task 2.5: Actor: PWM LED or RGB LED

If you managed smooth flashing via PWM before, now use Node-RED to control the brightness directly (duty cycle) of 2 LEDs (green and red) - so transfer the "smoothness" away from the MCU to the integrating system with Node-RED. You should see a difference and learn something from that small experiment.

- observe whether the smoothness changes when controlled by Node-RED
- integrate the LEDs into the access control system
- red for access denied
- green for access granted
- or use one RGB LED if available (if you do the latter observe the mixing of colors)

## Task 3: Optional: Display Weather info on OLED display

While the OLED display is idle and not being used by the access control, fetch some weather info from an API in Node-REDand display it there (check out the pallette and available plug-ins/libraries).

Find out on your own how this can be done using Node-RED.

## Task 4: Optional: Discord/Telegram bridge

Build a bridge to Discord or Telegram (or another supported messaging service of your choice - no, mqtt already works!) to interact with your security system: notifications of attempted access and possibility to remote unlock.
