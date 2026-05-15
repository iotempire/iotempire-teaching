# Module 2 – Hardware and Basic Electronics

[← Previous: Module 1](./01-introduction.md) | [Back to front page](../workbook.md) | [Quick module index](./00-index.md) | [Next: Module 3 →](./03-infrastructure-and-gateway-setup.md)

All tasks in this module can be executed as a pair. **Do not forget to take photos for your GitHub report and save your code.**

Slides: [Lab - Kit and Electronics](https://docs.google.com/presentation/d/1K5AVZUYA0UU4u1OMoSzZYUYvfAs2JFqSr6qJAftk_kI)

## Task 1 – Breadboards and Electronic Prototyping Intro

Answer the following questions in one of your portfolios — either from memory, Google/AI, and/or by watching [this video](https://youtu.be/yXirMBP3x4U):

- What is an electric circuit?
- What is a breadboard for electronic prototyping?
- Describe a breadboard and mention at least two memorable features.
- Name one or two conventions for color coding of cables.
- How do you wire an LED to 5V?
- Describe an LED.
- What is special about diodes?
- One thing that still seemed unclear.

## Task 2 – Collect Hardware

Collect and note down your hardware:

- cloth bag for parts
- breadboard
- Dupont cables
- LEDs
- resistors
- 3 buttons
- 2 Wemos D1 Mini + 2 USB cables
- USB charger + 12V power supply + Y-cable
- optional multimeter

## Task 3 – “Hello World” Electronic Prototyping

Follow the second part of the [Breadboard and Prototyping IoT Intro Video](https://youtu.be/yXirMBP3x4U?t=375) as a pair.

Document steps, missteps, and pictures in your portfolio.

Coarse steps:

- Optional: watch [this video](https://youtu.be/wOEDaFRlhLo)
- Find a pinout for the Wemos D1 Mini
- Connect 5V and GND from the Wemos to the breadboard
- Wire up yellow and red LEDs with 330 Ohm resistors
- Add the button and document whether it works

## Task 4 – Fritzing, SimulIDE, or Cirkit Designer

Take a look at Fritzing or another EDA/prototyping tool.

- What are these tools?
- Why are they useful?
- Make a schematic for your hello-world setup.

## Task 5 – Blink on the Wemos D1 Mini

- Video: [Blink on Wemos D1 Mini](https://youtu.be/2nN_ZVyWLzg)
- Research the Wemos D1 Mini pinout.
- Explain different port addressing schemes.
- Find the GPIO and board pin number for `D6`.

Coarse steps:

- install Arduino IDE v2
- install CH340 driver if needed
- select “Wemos D1 R2 & Mini”
- select serial port
- compile and flash Blink
- add LED on `D6`
- add another synchronous LED on `D4`

## Task 6 – Toggle LED With Button

- Figure out what a pull-up resistor is.
- Add a button to the breadboard with a resistor to 3.3V.
- Test the `DigitalReadSerial` example.
- Then replace the external resistor approach with `INPUT_PULLUP`.
- Write an Arduino sketch that toggles an LED on `D6` with a button press.

## Task 7 – Relay-Lock Button

This task introduces the relay and solenoid lock as building blocks for an access-control style system.

- Understand the relay module:
  - what a relay is
  - relay terminals
  - control side vs switched side
- Wire Wemos, button, and relay
- Understand the solenoid lock and its default states
- Wire the solenoid lock using an external 12V supply
- Test the relay first without a button
- Add serial command handling
- Finally, add a button on a separate GPIO pin

![][image1]

> [!WARNING]
> Do **not** power the solenoid lock directly from a Wemos pin. Do **not** keep it activated for more than 0.5 seconds.

## Task 8 – LED Fade (optional)

- Learn about PWM
- Add an LED on `D6`
- Implement smooth fading with `analogWrite()`
- Measure timing and compare to your theoretical estimate
- Change one parameter at a time and note the effect

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
