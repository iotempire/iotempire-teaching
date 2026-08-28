# Module 2 – Hardware and Basic Electronics

[← Previous: Module 1](./01-introduction.md) | [Back to front page](../workbook.md) | [Quick module index](./00-index.md) | [Next: Module 3 →](./03-infrastructure-and-gateway-setup.md)


All tasks of this module can be executed as a pair. **Don't forget to take photos for your GitHub report and save your code.**


Slides: [Lab - Kit and Electronics](https://docs.google.com/presentation/d/1K5AVZUYA0UU4u1OMoSzZYUYvfAs2JFqSr6qJAftk_kI/edit?slide=id.p14#slide=id.p14)

## Task 1 – Breadboards and Electronic Prototyping Intro

Answer the following questions into (one of) your portfolio(s) - either from memory, Google/AI,  and/or watch video ([https://youtu.be/yXirMBP3x4U](https://youtu.be/yXirMBP3x4U))

* What is an electric circuit (what are the basic properties)?
* What is a breadboard for electronic prototyping?
  * Describe a breadboard - include at least 2 remarkable/memorable features
* Name one (or two) convention(s) for color coding for cables.
* How do you wire a Light Emitting Diode (LED) to 5V?
* Describe an LED
* What is special about (light-emitting) diodes?
* One thing that seemed unclear (or something very important)

## Task 2 – Collect Hardware

Get and note down your hardware for next task

- One blue bag for keeping all your IoT parts (maybe several small plastic bags for keeping smaller parts like resistors and diode)
- One big, one medium size breadboard
- Dupont cables - about 20 of each type (there are three types - which and why?), varying colors
- 2-5 Leds/Unicolor (2 pins)
- 2-5 resistors >150 Ohm (<1kOhm)
- 3 buttons
- 2 Wemos D1 Mini + 2 USB cables
- USB Charger (MH-KC24-4) + 12V Power-Supply + Y-cable
- If enough present also one multimeter

## Task 3 – "Hello World" Electronic Prototyping

Basically, follow as a "pair" the second part of "[Breadboard and Prototyping IoT Intro Video](https://youtu.be/yXirMBP3x4U?t=375)"
I.e.: rebuild the content, document your steps (and also missteps) with text (keywords are enough) and pictures. Link pair task documentation to your respective personal portfolios (as all future pair tasks).

Coarse steps:

* Optional: Consider watching [https://youtu.be/wOEDaFRlhLo](https://youtu.be/wOEDaFRlhLo) and answering the important question "What does this all have to do with coffee?"
* Find a pinout for the Wemos D1 Mini, what type of pins are there, what are GPIOs?
* Wire up a Wemos D1 Mini to your computer (via usb cable - only plug it in for testing) and get 5V and Ground (G) from the Wemos D1 Mini to the correct places on the breadboard (different from video)
* Wire up the yellow and red LEDs like described in video (with 330 Ohm resistor) - take picture for proof of lit LEDs in portfolio (and document problems/steps)
* Add the button like described in video and write down steps as well as if its working and take picture of setup for portfolio.

## Task 4 – Fritzing, SimulIDE, or Cirkit Designer

Take a look at Fritzing ([link](https://fritzing.org/download?dlid=khfI2NwLQN4FHv5jAMd-2A)) or other examples. What are they, and why are they needed? 
Cirkit Designer platform ([link](https://app.cirkitdesigner.com/project))
Make schematics for the "hello world" (end stage of task above) task with any **EDA tool**. 
Note: Installation is not necessary; online prototyping sketches or hand-drawn sketches are also good.

## Task 5 – Blink on the Wemos D1 Mini

* Video - [https://youtu.be/2nN_ZVyWLzg](https://youtu.be/2nN_ZVyWLzg)
* Wemos D1 Mini
  * Google and document the Wemos D1 Mini pinout and general intro info
  * Elaborate on different addressing schemes of ports, find a corresponding GPIO and board pin number for D6
* Follow the "Blink on Wemos D1 Mini" video from the slides.
* Coarse steps: 
  * Install Arduino IDE (v2)
  * Install [ch340 driver](https://www.wemos.cc/en/latest/ch340_driver.html#ch340-driver) (if on windows or older mac [https://www.wemos.cc/en/latest/ch340_driver.html](https://www.wemos.cc/en/latest/ch340_driver.html)) and plug in a Wemos D1 Mini to one of your computers
  * Check if you can find "Wemos D1 R2 &Mini" board and select it (if not, follow [https://github.com/esp8266/Arduino#installing-with-boards-manager](https://github.com/esp8266/Arduino#installing-with-boards-manager) to add the respective link to *file - preferences - additional board managers*)
  * Select serial port
  * Select example (Blink)
  * Compile and flash -> enjoy
  * Add led on D6 blinking async
  * Use another pin in addition to  D6 (not in video) and make them blink synchronously (D4)

## Task 6 – Toggle Led With Button

* Careful, challenging (no video) - plan first (also in a  designer)
* Please spend 5 minutes to figure out what a pull-up resistor is (and what it has to do with a push button), take very brief notes
* Add a button to the breadboard (wire the button to ground on one side and the other side to a GPIO port like D5 and also via a resistor of 10kOhm to 3.3V)
  Attention: do NOT wire ground and 3.3V directly together
* Test out the DigitalReadSerial example
  * Adjust  pushButton to D5 (or the respective GPIO port number you chose)
  * Flash and check serial monitor (taking a screenshot when this is working is good proof for your portfolio - remember to take photos during your setup)
  * Remove the resistor, replace in pinMode INPUT with INPUT_PULLUP, flash and test again,  try to answer why this is better or what would be the better alternative
* Write an Arduino sketch that allows you to toggle (switch from turned on to turned off and back) with a push of the button a led on D6.

## Task 7 – Relay-Lock Button

This task is about the hardware basics of building an access control system (and about understanding the Relay and the solenoid lock). There is a lot written here, but please also use some internet resources to understand and augment this here. Take (condensed) notes about the concepts in terms of what is important for yourself and pictures of your electric prototyping setups.

**Understanding the Relay Module:**
* **What is a Relay?**
* A relay is an electrically operated switch. It allows a low-power circuit (like the one on the Wemos D1 Mini) to control a high-power circuit (like the one required for a solenoid lock) while keeping them electrically isolated.
* **Internal Components?**
  A relay typically contains an electromagnet. When current flows through the electromagnet's coil (triggered by the Wemos), it creates a magnetic field that moves an armature, which in turn opens or closes a set of electrical contacts.
* **Relay Terminals:**
  * **Control Side (Low Voltage):**
    * **VCC/JD-VCC:** Power for the relay coil and/or module electronics (often 5V for the module - try 3.3V first).
    * **GND:** Ground for the control circuit.
    * **IN (or Signal Pin):** The digital input pin from the Wemos D1 Mini that switches the relay ON or OFF.
  * **Switched Side (High Voltage/Load):**
    * **Common (COM):** The central connection point.
    * **Normally Open (NO):** The contact is *open* (no connection) when the relay is *inactive* (no power to the coil). Current flows when the relay is activated. This is typically used for a solenoid lock that needs power to *open* (unlatch).
    * **Normally Closed (NC):** The contact is *closed* (connected to COM) when the relay is *inactive*. Current stops flowing when the relay is activated.

* **Wiring the Wemos D1 Mini to the Button and Relay:**
  * **Relay Circuit:**
    * Connect the **VCC** pin of the relay module to the **5V** pin on the Wemos D1 Mini (check your specific relay module's required voltage for the coil and logic).
    * Connect the **GND** pin of the relay module to the **GND** pin on the Wemos D1 Mini.
  * **Button-Relay Circuit**
    * Connect the push button to the same **+5V** power rail used in the circuit.
    * Use a pull-down resistor from the button signal node to **GND**, so the line stays **LOW** when the button is not pressed.
    * When the button is pressed, the signal line is driven to **+5V**. 
    * This signal line should then be fed into an appropriate Relay input stage.

![image1]()

* **Understanding the Solenoid Lock:**
  * **What is a Solenoid Lock? What normal states can it have? Which state does your device have?**
    A solenoid lock is an electromechanical locking device that uses electrical power to move a metal plunger and change the lock state (lock or unlock). It allows a low-power controller circuit (for example, Wemos D1 Mini through a relay) to control a higher-power locking mechanism safely and reliably.
  * **Internal Components?**
    A solenoid lock typically contains a copper coil, a movable ferromagnetic plunger, a return spring, and a mechanical latch interface. When current flows through the coil, a magnetic field is generated and pulls (or pushes, depending on design) the plunger, which releases or engages the latch. When power is removed, the spring returns the plunger to its default position.
* **Wiring the Solenoid Lock (Load) Circuit:**
  * Safety First: Solenoid locks usually require a separate, higher-voltage power supply (e.g. **12V DC**). **NEVER** attempt to power the lock directly from the Wemos D1 Mini pins. **DO NOT CONNECT THE 12V POWER SUPPLY TO ANY Wemos D1 Mini PIN.** **DO NOT KEEP IT ACTIVATED FOR MORE THAN 0,5 SECOND.**
  * Solenoid Power Supply: Connect the positive (red) terminal of the external power supply (e.g. **12V**) to the **COM** terminal of the relay.
  * Solenoid Lock Connection: Connect the **NO (Normally Open)** terminal of the relay to one wire of the solenoid lock.
  * Completing the Circuit: Connect the other wire of the solenoid lock to the negative (**- / GND**) terminal of the external power supply.
  * Operation: When the button is pressed, the relay connects **COM** to **NO**, completing the circuit and powering the solenoid lock, causing it to open.
    (remember to take a video of the result and convert it to .gif before uploading to GitHub)
  * **QUESTION:** *What will happen if you wire the relay differently than instructed? Specifically, if you swap the wires connected to **COM** and **NO** in the relay?* Figure it out and tell why it happens.
* **Required Extra Logic (Conceptual):**
  * In this basic setup, first test relay control without a button by connecting the relay control input to a digital pin on the Wemos D1 Mini and driving it from Arduino IDE using a for loop (or a timed loop) to switch the relay ON and OFF with a 5-6 second loop with a short unlocking interval. **DO NOT KEEP IT ACTIVATED FOR MORE THAN 0,5 SECOND - IT GET'S VERY HOT, VERY QUICKLY.**
  * After that, implement command handling through the Serial port: type keyword from the keyboard in the Serial Monitor (for example, UNLOCK, OFF), and make the Wemos parse this command and switch the relay state for some short amount of time.
  * Finally, modify the circuit and add a button using a  **separate Wemos D1 Mini pin** so that closing the button contact sends a trigger signal to the relay input. Write code for that and prove stable switching behavior.
  * (remember to take a video of the result and convert it to .gif before uploading to GitHub)

## Task 8 – LED Fade (optional task for advanced students)

* Familiarize yourself with **PWM** (and why analogWrite on ESP8266 is not a true **DAC** output), and take notes and references
* Add an LED to the breadboard (wire the LED anode to **D6 - like above -**through a 220–330 Ohm resistor, and LED cathode to **GND**)
* Do a simple **PWM** test sketch and verify that the LED brightness changes:
  * Implement a smooth fade from minimum to maximum brightness and back in a loop using **analogWrite()**
  * Find out what the PWM range is by default for the ESP8266
  * Use a PWM range of min-max **PWM**, and choose a small delay per step (for example 3-10 ms)
  * Flash and check behavior; take a screenshot/photo as proof for your portfolio (remember to take a video of the result and convert it to .gif before uploading to GitHub)
* Measure the duration of one full cycle (0 → max → 0). Is it the same as in your theoretical calculation (for example, from step count × delay)?
* Change one parameter at a time (step size or delay), re-test, and briefly note if it affects smoothness and cycle time and why.

## Task 9 – Get to know the IoT Cart and peripheral communication

Mostly homework.

- Collect and catalog your lab kit
- Study buses and peripheral communication:
  - GPIO/PWM
  - I2C / I3C
  - SPI
  - UART / RS232 / RS485
  - OneWire
- Implement examples in Arduino IDE for selected devices

Attention: do not forget the reflection.

[image1]: ../images/image1.png
