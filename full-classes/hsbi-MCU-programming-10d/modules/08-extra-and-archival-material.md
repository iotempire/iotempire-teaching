# Extra and Archival Material

[← Previous: Module 7](./07-final-project.md) | [Back to front page](../README.md) | [Quick module index](./00-index.md)

This file collects material from the later parts of the original workbook that are clearly marked as unfinished, optional, obsolete, or archival.

## Extra Module

### IoTempower Gateway on Raspberry Pi

Setup IoTempower gateway and make sure WiFi and internet work. Follow the linked video and manuals below.

Tasks:

- download, verify, and flash the Pi image (for example with [balena etcher](https://www.balena.io/etcher))
- check some services offered
- log the process into the pair portfolio
- use the documentation links, but do not continue to the first IoT node yet:
  - [https://github.com/iotempire/iotempower/blob/master/doc/image-pi.rst](https://github.com/iotempire/iotempower/blob/master/doc/image-pi.rst)
  - updated etcher video: [https://drive.google.com/file/d/1PfSHLtGOiw9m6Xiff8fu2XTGlEsdh3dk](https://drive.google.com/file/d/1PfSHLtGOiw9m6Xiff8fu2XTGlEsdh3dk)
  - [https://github.com/iotempire/iotempower/blob/master/doc/quickstart-pi.rst](https://github.com/iotempire/iotempower/blob/master/doc/quickstart-pi.rst)

![][image9]

> [!WARNING] UT-ADAPT
> The original text references UT-specific WiFi and credential practices such as `ut-public` and secret eduroam entry. Replace or remove these for HSBI.

### Optional Task: Bomb Diffuser Game

Download the Bomb Diffusal Arduino code and adapt it to work with the M5StickC buttons:
[https://github.com/chrisparton1991/led-pixel-master-course/blob/master/01_BombDefusalGame/09_SomeFinalPolish/BombDefusalGame/BombDefusalGame.ino](https://github.com/chrisparton1991/led-pixel-master-course/blob/master/01_BombDefusalGame/09_SomeFinalPolish/BombDefusalGame/BombDefusalGame.ino)

Adapt the Arduino schematics to work with the available classroom hardware.

Tips:

- the original schematic is for a **5V** LED strip but the classroom LED strip is **12V**
- use the **Y cable** to power the strip
- use a `10R` or `22R` resistor if needed; higher resistors may get glitchy
- do not use a capacitor if the local setup does not require it
- our RGB strip works in triplets, every 3 LEDs behave like one pixel, so adjust the code for that
- fix the RGB order
- adapt the code to M5StickC or M5StickC Plus and check GPIO ports for buttons and signal output

Have fun!

![][image10]

> [!WARNING] UT-ADAPT
> The original file references `renato.perotto.machado@ut.ee` and contains a TODO about image source attribution. Replace or remove these UT-specific remnants.

## Obsolete

> [!WARNING] UT-ADAPT
> The sections below are kept for recovery and reference only. They still contain older UT-era assumptions, tooling choices, and course-structure references and should not be considered workshop-ready without review.

The original workbook explicitly marks the following sections as obsolete or legacy material:

- MQTT on microcontroller
- More temperature
- More sensors
- liquids measuring project
- old Manjaro installation and gateway setup instructions
- old network game cheat sheets
- Discord emergency button
- remote control of an internal device
- PWM motor
- remote access to the gateway
- laptop hotspot fallback
- IoTempower networking setup
- web request control tasks
- initial project planning
- SNodeC / mqttsuite demo material
- module 5 not used
- legacy liquids measuring project material

### MQTT on microcontroller

This obsolete section describes rebuilding the two HVAC simulators directly in hardware using two Wemos D1 Minis, a tripler board, a Dallas temperature shield, and a relay shield, with PubSubClient.

It expects:

- one Wemos for the temperature reader
- one Wemos for the relay switch / AC unit
- code, images of both setups, steps taken, and difficulties encountered in the portfolio

### More Temperature

This obsolete section describes building and programming an ESP32 device with a DHT22 temperature/humidity shield and sending MQTT values with PubSubClient, then receiving them in Node-RED and displaying them as a graph.

It also contains:

- ESP32 flashing notes for the MH-ET LIVE ESP32 MiniKit
- a pointer to the `DHTesp` library
- expectations for code, dashboard screenshots, and implementation notes

### Resources

The original archival workbook also carries a list of legacy resources such as:

- Breadboards / prototyping video
- breadboards and electronics slides
- ESP8266 introduction video
- blink on Wemos video
- PlatformIO recommendation video
- buses slides
- generic SoC references
- M5StickC references

## Explicit UT-specific legacy notes found in archival material

These should be reviewed, removed, or replaced for HSBI:

- references to **UT students**
- references to **Tartu**
- references to **ut-public** WiFi
- references to `@ut.ee` email addresses
- references to original room setup assumptions from UT

> [!WARNING] UT-ADAPT
> This archival file intentionally keeps the old material grouped out of the main module flow, but it should not be assumed workshop-ready.

[image9]: ../images/image9.png
[image10]: ../images/image10.png
