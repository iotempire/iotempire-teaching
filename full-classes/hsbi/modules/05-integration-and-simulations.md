# Module 5 – Integration and Simulations

[← Previous: Module 4](./04-embedded-programming-and-deploying.md) | [Back to front page](../workbook.md) | [Quick module index](./00-index.md) | [Next: Module 6 →](./06-iot-systems.md)

This section corresponds to **Module 4 Part 2** from the original workbook.

**Block placement:** This module is scheduled for **Day 3** of the condensed four-day HSBI/GT workshop.

## Integration and Simulations

At this point students are expected to already be able to:

- set up the network infrastructure
- send and receive MQTT messages from phone, CLI, and Node-RED
- flash Wemos D1 Mini and ESP32 boards
- work in VS Code / PlatformIO or Arduino IDE
- use git and markdown

## Task 1 – HVAC system with Integration and Simulators/Mockups

### Task 1.1 – Integration (Orchestration)

Rebuild the air-conditioning integrator component shown in the IoTknit video, or create your own MQTT-based integrator.

### Task 1.2 – Simulators (Testers)

Build two software simulators:

- temperature simulator
- AC simulator

### Task 1.3 – Sensor Node with Temperature Sensor

Use a Dallas sensor on an ESP node and publish temperature via MQTT.

### Task 1.4 – Actor Node with Relay + Lock to simulate AC

Use the relay-lock setup to simulate an AC unit.

### Task 1.5 – Rebuild integration and simulation in Node-RED with Dashboard

Use Node-RED dashboard elements to:

- visualize temperature
- control AC state
- rebuild the integrator logic
- show status with text and/or color changes

## Make sure the dashboard is accessible on any device in the network

The original workbook requires the final result for Task 1 to include:

- 2 temperature simulators
- 1 physical temperature sensor node
- 2 AC simulators
- 1 physical AC actor node
- 1 integrator in code
- 1 integrator in Node-RED with dashboard

## Task 2 – Full Access Control System in Node-RED

Build an access-control system using multiple separate microcontroller nodes.

Subtasks:

- RFID reader and UI
- ultrasonic / LIDAR / PIR presence detector
- PWM buzzer
- OLED text receiver
- PWM LED or RGB LED

## Optional tasks

- Display weather info on OLED
- Discord/Telegram bridge

> [!WARNING] UT-ADAPT
> The expectations in this section still reflect the scale of the older long-form course. For the HSBI 4×10h workshop, this should likely be reduced to a smaller mandatory core and a clearer optional extension path.
