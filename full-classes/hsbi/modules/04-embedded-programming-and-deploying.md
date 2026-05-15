# Module 4 – Embedded Programming and Deploying Nodes

[← Previous: Module 3](./03-infrastructure-and-gateway-setup.md) | [Back to front page](../workbook.md) | [Quick module index](./00-index.md) | [Next: Module 5 →](./05-integration-and-simulations.md)

**Preparation:** Arduino IDE or PlatformIO can be used.

**Block placement:** This module is scheduled for **Day 2**, after the continuation and completion of Module 3.

## Breaking Things and Simple Debugging via Serial Console Monitor

This section introduces deliberate crashes and basic debugging techniques with `Serial.print`.

Tasks:

1. Simple crash: null pointer dereference
2. Simple crash: divide by zero
3. Too little memory
4. Crashing with interrupts
5. OTA flashing
6. Emergency scenario: better MQTT alarm with smooth flashing
7. MQTT to serial to serial to console
8. Alarm message on OLED mini screen
9. Use Node-RED to bridge button, LED strip, and OLED message
10. Optional: BME/BMP280 on ESP32
11. Optional: VL53L0X on ESP32
12. Optional: LED animation
13. Optional: deep sleep

## Notes on the tasks

- The crash tasks are intended for understanding runtime failure modes.
- OTA flashing is introduced for faster wireless iteration.
- The later tasks extend earlier MQTT work into richer embedded nodes.
- The ESP32 minikit is introduced as a second board platform.

### Adding an ESP32

The workbook introduces the **MH-ET LIVE ESP32 MiniKit** and notes that `IO0` may need to be wired to `GND` during flashing.

### Task 7 – MQTT to Serial to Serial to Console

This scenario bridges Wi-Fi/MQTT outside a shielded space to a serial-only node inside.

### Task 8 – Alarm Message on OLED mini Screen

Use the OLED mini shield and adapt the provided starter code to display MQTT messages.

### Task 9 – Use Node-RED to bridge Button, Alarm LED Strip, and Alarm Message

Use Node-RED to connect:

- button node
- LED flashing node
- OLED display node

![][image7]

![][image8]

> [!WARNING] UT-ADAPT
> This module was originally part of a longer multi-week sequence. For the condensed HSBI format, task ordering and depth likely need further trimming or day-by-day regrouping.

[image7]: ../images/image7.png
[image8]: ../images/image8.png
