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


### Optional Task: Bomb Defusal Game

Download the Bomb Defusal Arduino code and adapt it to work with the M5StickC buttons:
[https://github.com/chrisparton1991/led-pixel-master-course/blob/master/01_BombDefusalGame/09_SomeFinalPolish/BombDefusalGame/BombDefusalGame.ino](https://github.com/chrisparton1991/led-pixel-master-course/blob/master/01_BombDefusalGame/09_SomeFinalPolish/BombDefusalGame/BombDefusalGame.ino)

Adapt the Arduino schematics to work with the available classroom hardware.

Tips:

- the original schematic is for a **5 V** LED strip; classroom strips may be **5 V** or **12 V**
- identify the actual strip, power supply, signal requirements, and safe wiring before connecting it
- use the **Y cable** only when the instructor confirms that it is appropriate for the selected strip and power supply
- use a `10R` or `22R` resistor if needed; higher resistors may get glitchy
- do not use a capacitor if the local setup does not require it
- our RGB strip works in triplets, every 3 LEDs behave like one pixel, so adjust the code for that
- fix the RGB order
- adapt the code to M5StickC or M5StickC Plus and check GPIO ports for buttons and signal output

Have fun!

![][image10]
