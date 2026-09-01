# Module 2 – Hardware and Basic Electronics

[← Previous: Module 1](./01-introduction.md) | [Back to front page](../workbook.md) | [Quick module index](./00-index.md) | [Next: Module 3 →](./03-infrastructure-and-gateway-setup.md)

All tasks of this module can be executed as a pair. **Do not forget to take photos for your GitHub report and save your code.**

**Block placement:** This module is scheduled for **Day 2**.

Slides: [Lab - Kit and Electronics](https://docs.google.com/presentation/d/1K5AVZUYA0UU4u1OMoSzZYUYvfAs2JFqSr6qJAftk_kI)

## Task 1 – Breadboards and Electronic Prototyping Intro

Answer the following questions into one of your portfolio(s) — either from memory, Google/AI, and/or by watching [this video](https://youtu.be/yXirMBP3x4U):

- What is an electric circuit (what are the basic properties)?
- What is a breadboard for electronic prototyping?
  - Describe a breadboard — include at least 2 remarkable / memorable features.
- Name one or two convention(s) for color coding of cables.
- How do you wire a Light Emitting Diode (LED) to 5V?
- Describe an LED.
- What is special about (light-emitting) diodes?
- One thing that seemed unclear (or something very important).

## Task 2 – Collect Hardware

Get and note down your hardware for the next tasks.

- One blue bag or similar for keeping all your IoT parts (maybe several small plastic bags for keeping smaller parts like resistors and diodes)
- One big or medium size breadboard
- Dupont cables — about 20 of each type (there are three types — which and why?), varying colors
- 2–5 LEDs / unicolor (2 pins)
- 2–5 resistors >150 Ohm and <1kOhm
- 3 buttons
- 2 Wemos D1 Mini + 2 USB cables
- USB charger (MH-KC24-4) + 12V power supply + Y-cable

## Task 3 – “Hello World” Electronic Prototyping

Basically, follow as a pair the second part of the [Breadboard and Prototyping IoT Intro Video](https://youtu.be/yXirMBP3x4U?t=375).

Rebuild the content, document your steps (and also missteps) with text (keywords are enough) and pictures. Link pair-task documentation to your respective personal portfolios.

Coarse steps:

- Optional: Consider watching [https://youtu.be/wOEDaFRlhLo](https://youtu.be/wOEDaFRlhLo) and answering the important question “What does this all have to do with coffee?”
- Find a pinout for the Wemos D1 Mini, what type of pins are there, what are GPIOs?
- Wire up a Wemos D1 Mini to your computer (via USB cable — only plug it in for testing) and get 5V and Ground (G) from the Wemos D1 Mini to the correct places on the breadboard
- Wire up the yellow and red LEDs like described in the video (with 330 Ohm resistor) — take a picture for proof of lit LEDs in the portfolio and document problems/steps
- Add the button like described in the video and write down the steps as well as whether it is working, and take a picture of the setup for the portfolio

## Task 4 – Fritzing, SimulIDE, or Cirkit Designer

Take a look at Fritzing ([link](https://fritzing.org/download?dlid=khfI2NwLQN4FHv5jAMd-2A)) or other examples. What are they, and why are they needed?

Cirkit Designer platform ([link](https://app.cirkitdesigner.com/project))

Make schematics for the “hello world” end-stage task above with any **EDA tool**.

Note: installation is not necessary; online prototyping sketches or hand-drawn sketches are also good.

## Task 5 – Blink on the Wemos D1 Mini

- Video: [https://youtu.be/2nN_ZVyWLzg](https://youtu.be/2nN_ZVyWLzg)
- Wemos D1 Mini
  - Google and document the Wemos D1 Mini pinout and general intro info
  - Elaborate on different addressing schemes of ports, find a corresponding GPIO and board pin number for `D6`
- Follow the “Blink on Wemos D1 Mini” video from the slides

Coarse steps:

- install Arduino IDE (v2)
- install [ch340 driver](https://www.wemos.cc/en/latest/ch340_driver.html#ch340-driver) if needed
- plug in a Wemos D1 Mini
- check if you can find “Wemos D1 R2 & Mini” and select it
- if not, follow [https://github.com/esp8266/Arduino#installing-with-boards-manager](https://github.com/esp8266/Arduino#installing-with-boards-manager)
- select serial port
- select example `Blink`
- compile and flash
- add LED on `D6` blinking asynchronously
- use another pin in addition to `D6` (not in the video) and make them blink synchronously (`D4`)

## Task 6 – Toggle LED With Button

- Careful, challenging (no video) — plan first, also in a designer if you like
- Spend 5 minutes figuring out what a pull-up resistor is and what it has to do with a push button; take very brief notes
- Add a button to the breadboard (wire the button to ground on one side and the other side to a GPIO port such as `D5` and also via a resistor of 10kOhm to 3.3V)
  - Attention: do **not** wire ground and 3.3V directly together
- Test out the `DigitalReadSerial` example
  - adjust `pushButton` to `D5` (or the respective GPIO number you chose)
  - flash and check serial monitor
  - taking a screenshot when this works is good proof for the portfolio
  - remove the resistor, replace `INPUT` in `pinMode` with `INPUT_PULLUP`, flash and test again, and try to answer why this is better or what the better alternative would be
- Write an Arduino sketch that allows you to toggle a LED on `D6` with a push of the button

## Task 7 – Relay-Lock Button

This task is about the hardware basics of building an access control system and understanding the relay and the solenoid lock. There is a lot written here, so also use some outside resources to understand and augment it. Take condensed notes about the concepts and pictures of your electric prototyping setups.

### Understanding the Relay Module

- **What is a Relay?**
- A relay is an electrically operated switch. It allows a low-power circuit (like the one on the Wemos D1 Mini) to control a high-power circuit (like the one required for a solenoid lock) while keeping them electrically isolated.
- **Internal Components?**
  - A relay typically contains an electromagnet. When current flows through the electromagnet's coil, it creates a magnetic field that moves an armature, which in turn opens or closes a set of electrical contacts.
- **Relay Terminals:**
  - **Control Side (Low Voltage):**
    - **VCC/JD-VCC:** power for the relay coil and/or module electronics (often 5V for the module — try 3.3V first)
    - **GND:** ground for the control circuit
    - **IN (or Signal Pin):** the digital input pin from the Wemos D1 Mini that switches the relay ON or OFF
  - **Switched Side (High Voltage/Load):**
    - **Common (COM):** the central connection point
    - **Normally Open (NO):** open when the relay is inactive, current flows when activated
    - **Normally Closed (NC):** closed when the relay is inactive, current stops flowing when activated

### Wiring the Wemos D1 Mini to the Button and Relay

- **Relay Circuit:**
  - Connect the **VCC** pin of the relay module to the **5V** pin on the Wemos D1 Mini (check your module's required voltage)
  - Connect the **GND** pin of the relay module to the **GND** pin on the Wemos D1 Mini
- **Button-Relay Circuit:**
  - Connect the push button to the same **+5V** power rail used in the circuit
  - Use a pull-down resistor from the button signal node to **GND**, so the line stays **LOW** when the button is not pressed
  - When the button is pressed, the signal line is driven to **+5V**
  - This signal line should then be fed into an appropriate relay input stage

![][image1]

### Understanding the Solenoid Lock

- **What is a Solenoid Lock? What normal states can it have? Which state does your device have?**
  - A solenoid lock is an electromechanical locking device that uses electrical power to move a metal plunger and change the lock state (lock or unlock).
  - It allows a low-power controller circuit (for example, Wemos D1 Mini through a relay) to control a higher-power locking mechanism safely and reliably.
- **Internal Components?**
  - A solenoid lock typically contains a copper coil, a movable ferromagnetic plunger, a return spring, and a mechanical latch interface.
  - When current flows through the coil, a magnetic field is generated and pulls or pushes the plunger, depending on design.

### Wiring the Solenoid Lock (Load) Circuit

- **Safety First:** Solenoid locks usually require a separate higher-voltage power supply (for example **12V DC**).
  - **Never** attempt to power the lock directly from the Wemos D1 Mini pins.
  - **Do not connect the 12V power supply to any Wemos D1 Mini pin.**
  - **Do not keep it activated for more than 0.5 second.**
- Solenoid power supply:
  - connect the positive terminal of the external power supply to the **COM** terminal of the relay
- Solenoid lock connection:
  - connect the **NO** terminal of the relay to one wire of the solenoid lock
- Completing the circuit:
  - connect the other wire of the solenoid lock to the negative terminal of the external power supply
- Operation:
  - when the button is pressed, the relay connects **COM** to **NO**, completing the circuit and powering the solenoid lock so that it opens
- **Question:** What happens if you wire the relay differently — specifically, if you swap the wires connected to **COM** and **NO**? Figure it out and explain why.

### Required Extra Logic (Conceptual)

- First test relay control **without a button** by connecting the relay control input to a digital pin on the Wemos D1 Mini and driving it from Arduino IDE with a loop or timed loop.
- Use a 5–6 second loop with a short unlocking interval.
- **Do not keep it activated for more than 0.5 second — it gets very hot very quickly.**
- After that, implement command handling through the Serial port:
  - type a keyword such as `UNLOCK` or `OFF` in the Serial Monitor
  - make the Wemos parse the command and switch the relay state for a short amount of time
- Finally, modify the circuit and add a button using a **separate Wemos D1 Mini pin** so that closing the button contact sends a trigger signal to the relay input.
- Write code for that and prove stable switching behavior.

## Task 8 – LED Fade (optional task for advanced students)

- Familiarize yourself with **PWM** and why `analogWrite` on ESP8266 is not a true **DAC** output; take notes and references
- Add an LED to the breadboard (wire the LED anode to **D6** through a 220–330 Ohm resistor, and the cathode to **GND**)
- Do a simple PWM test sketch and verify that the LED brightness changes:
  - implement a smooth fade from minimum to maximum brightness and back in a loop using `analogWrite()`
  - find out what the PWM range is by default for the ESP8266
  - use a PWM range of min-max PWM and choose a small delay per step (for example 3–10 ms)
  - flash and check behavior; take a screenshot/photo as proof for your portfolio
- Measure the duration of one full cycle (`0 → max → 0`). Is it the same as in your theoretical calculation?
- Change one parameter at a time (step size or delay), retest, and briefly note whether it affects smoothness and cycle time and why.

## Task 9 – Get to know the devices and oeripheral communication

- Get to know the hardware, check what else is available in front of the class as well as catalog your own lab kit so far
- Example part list:
  - Dallas temperature sensor (`DS1820B`)
  - DHT22
  - MPR121 touch sensor
  - gesture sensor
  - RFID reader (+tags)
  - RGB LED + 3 resistors
- **Peripheral Communication**
  - Which buses are used in the available hardware? How can they be wired to the Wemos D1 Mini or one of the ESP32s you have?
  - Give one example from the available material, or if not available, Google an interesting one and give wiring examples for all of the following:
    - direct GPIO or PWM output
    - I2C / I3C
    - SPI
    - UART / RS232 / RS485
    - OneWire
    - PWM
- Implement examples in Arduino IDE (and wire them and take pictures) and include serial monitor output for Dallas sensor, MPR121, RGB LED cycling through at least 5 colors

[image1]: ../images/image1.png
