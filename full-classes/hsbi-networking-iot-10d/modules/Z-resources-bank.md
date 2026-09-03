# Resources Bank – Networking and IoT Solutions

*A living cheat sheet for students and instructors. Contribute improvements in your portfolio portfolios!*(Roll in the table with your changes.)

---

## 🎥 Pre-Class Videos by Module

| **Module** | **Topic**                 | **Video**                                                                               | **Guiding Question**                                                                 |
|------------|---------------------------|---------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------|
| 1          | OSI Model Critique         | [OSI Model – Practical Perspective](https://www.youtube.com/watch?v=vv4y_vyBGN8)        | How does layering help—or hinder—debugging an MQTT broker crash?                            |
| 1          | OSI vs TCP/IP             | [OSI Model vs TCP/IP](https://www.youtube.com/watch?v=ZT07sZ0tJcc)                     | What benefit does TCP/IP’s flexible layering bring to real-time IoT?                      |
| 2          | MQTT in IoT                | [MQTT Beginner Guide](https://www.youtube.com/watch?v=hzJ00SqJYeY)                   | How does MQTT’s pub/sub reduce integration friction compared to REST?                      |
| 2          | Mocking Hardware with MQTT  | [Mocking Hardware for IoT](https://www.youtube.com/watch?v=4QbQ0xVGG0M)                 | What’s the benefit of swapping a Python mock for an ESP32 with *no other changes*?       |
| 3          | LoRaWAN Deep Dive          | [LoRaWAN Protocol & Hardware](https://www.youtube.com/watch?v=VhB1Iv7Q3HY)           | What’s the trade-off between WiFi’s throughput and LoRaWAN’s range?                      |
| 3          | WiFi vs LoRaWAN Choices    | [WiFi LoRaWAN Infographic](https://www.youtube.com/watch?v=fFoRz2q2yqA)             | If a project needs a 15 km line-of-sight, which would you pick and why?                 |
| 4          | Raspberry Pi Gateway        | [Pi as IoT Gateway](https://www.youtube.com/watch?v=6Nz7Xv7sLqM)                     | What job does the gateway perform that neither the sensor nor the cloud can do alone?        |
| 5          | OPC-UA for Beginners       | [OPC-UA Explained](https://www.youtube.com/watch?v=5m5q6XZKJXQ)                        | How is an OPC-UA node different from a Modbus register?                                     |
| 5          | Modbus for Beginners       | [Modbus Explained](https://www.youtube.com/watch?v=Txv-OT-AJrA)                         | What happens when 100 Modbus devices share a single RS-485 line?                        |
| 6          | ESP32 Deep Sleep Modes      | [ESP32 Deep Sleep vs Light Sleep](https://www.youtube.com/watch?v=ZvfA1XxjVa4)       | What sleep mode achieves 6-month battery life on your soil sensor?                          |
| 6          | IoT Power Optimization      | [IoT Power Techniques](https://www.youtube.com/watch?v=eEE9xTQHw9c)                   | Why is frequency scaling often unused in IoT? What’s cheaper instead?                         |

---



## 📖 RFCs & Standards Every Student Should Glance Once

| **RFC/Document**                                                    | **Focus**                                                                              | **Why it Matters**                                                                         |
|---------------------------------------------------------------------|-----------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------|
| [RFC 1918](https://tools.ietf.org/html/rfc1918)                     | Private IPv4 networks (`192.168.x.x`, `10.x.x.x`)                                    | Gateway NAT + port forwarding depends on reserving private IP blocks (Module 4).                |
| [RFC 3439 Section 3](https://tools.ietf.org/html/rfc3439#section-3) | "Layering Considered Harmful"                                                         | Forces students to question if OSI layers help or hinder engineering *in practice* (Module 1).  |
| [RFC 1958](https://tools.ietf.org/html/rfc1958)                     | Architectural principles of the Internet (end-to-end principle)                          | Explains why TCP/IP succeeded over rigid OSI stacks (Module 1).                            |
| [MQTT v5.0 Spec](http://docs.oasis-open.org/mqtt/mqtt/v5.0/mqtt-v5.0.html) | Publish/subscribe, QoS levels, session management                                       | Defines how ESP32 MQTT clients in Modules 2–7 must behave.                                   |
| [LoRaWAN 1.0 Spec](https://lora-alliance.org/resource-hub/)        | Physical layer, MAC commands, ADR                                                    | Helps debug why LoRaWAN range sometimes jumps 2 km suddenly (Module 3).                      |
| [OPC-UA Part 3](https://www.opcfoundation.org/ua/part3/)           | Address space and data model                                                          | Explains what an OPC-UA node/tag means (Module 5).                                        |
| [ESP32 Technical Reference](https://www.espressif.com/sites/default/files/documentation/esp32_technical_reference_manual_en.pdf) | Power states, clock domains, sleep modes                                               | Each µA in deep sleep; core text for Module 6 optimizations.                                 |

---


## 🛒 Cheat Sheets & Quick References

### 📌 Hardware Quick Guides
- **[ESP32 Pinout](https://www.etechnophiles.com/esp32-gpio-pinout-datasheet/)** – A0–A3, GPIO, power domains.
- **[RPi 4 Pinout](https://www.raspberrypi.com/documentation/computers/os.html#gpio-and-the-40-pin-header)** – UART, I2C, power pins.
- **[LiPo vs Coin Cell](https://www.ti.com/lit/an/slyt670/slyt670.pdf)** – Discharge curves, self-discharge.


### 📌 Networking Snippets (Copy/Paste)
- **Ping sweep to find ESP32 IP:**
  ```bash
  nmap -sn 192.168.1.0/24 | grep "IoT"
  ```
- **Find open ports on Pi:**
  ```bash
  sudo netstat -tulnp | grep mosquitto
  ```
- **Port forward Pi 1883 → WAN:**
  ```bash
  sudo iptables -t nat -A PREROUTING -p tcp --dport 1883 -j DNAT --to-destination 192.168.1.100:1883
  ```
- **Enable Avahi for Pi host naming:**
  ```bash
  sudo apt install avahi-daemon avahi-utils
  ```

### 📌 MQTT Command Cheat Sheet
| Command                      | Example                                      | Purpose                                  |
|------------------------------|-----------------------------------------------|------------------------------------------|
| `mosquitto_pub`              | `mosquitto_pub -t "temp" -m "22.5" -h 192.168.1.100` | Publish test message                      |
| `mosquitto_sub`              | `mosquitto_sub -t "#" -h localhost`         | Subscribe to all topics                  |
| `mosquitto_sub` RTT logger   | `mosquitto_sub -t "iot/rt" -h localhost --retained | Measure latency                         |

### 📌 Power Measurement Cheat Sheet
| Tool             | Command / Setup                           | Purpose                                  |
|------------------|-------------------------------------------|------------------------------------------|
| USB meter        | Record CSV (*power_profile.csv*): `time,current_mA` | Baseline current draw                     |
| Serial Monitor   | `Serial.print(digitalRead(3V3))`          | Quick sanity check                       |
| Multimeter shunt | Attach to GND rail on Pi (yellow wire)  | Accurate deep sleep µA measurement        |

### 📌 OPC-UA Quick Nodes
| Node Type                   | Example Path / ID          | Purpose                        |
|-----------------------------|----------------------------|--------------------------------|
| **Variable**                | `ns=3;i=1008`                     | Simple temp reading              |
| **Method Call**             | `ns=3;i=2001`                     | Remote procedure invoke          |
| **Object**                  | `ns=2;i=58880`                     | A folder holding variables       |

*Use [UA Expert](https://www.unified-automation.com/products/development-tools/uaexpert.html) to explore.*



### 📌 Modbus Address Map (Simplified)
| Description               | Address Range       | Example Usage          |
|---------------------------|--------------------|-----------------------|
| Coils/Discrete Outputs    | 0x0000–0xFFFF    | On/Off states         |
| Discrete Inputs            | 0x1000–0x1FFF    | Door sensors           |
| Holding Registers           | 0x2000–0x2FFF    | Temperature x10       |
| Input Registers             | 0x3000–0x3FFF    | Analog sensor readings  |


---

## 📚 Software & Library Landmarks

| **Use Case**               | **Library / Framework**                                     | **Quick Link**                                                                         | **Typical Module**                          |
|-----------------------------|-----------------------------------------------------------|-----------------------------------------------------------------------------------------|---------------------------------------------|
| MQTT Client (ESP32)         | PubSubClient ESP                     | [GitHub](https://github.com/knolleary/pubsubclient)                            | Module 2, 3, 5, 6                         |
| LoRaWAN ESP32               | RadioHead or LoRa library              | [LoRa-Net](https://github.com/LoRa-net/LoRa)                                      | Module 3                                    |
| OPC-UA Client (ESP32)        | [open62541](https://github.com/open62541/open62541)      | [open62541](https://github.com/open62541/open62541)                              | Module 5                                    |
| OPC-UA Python                | freeOPC-UA (UA-Expert)                | [GitHub](https://github.com/FreeOpcUa/python-opcua)                               | Module 5                                    |
| Modbus TCP (Python)          | pymodbus                              | [Docs](https://pymodbus.readthedocs.io/)                                           | Module 5                                    |
| ESP32 Gateway Firmware        | ESP32-MQTT-Client via Arduino Core    | [GitHub](https://github.com/espressif/arduino-esp32)                             | Module 2–6                                  |

---

## 🧰 Troubleshooting Quick Drops

| **Symptom**                                   | **Diagnosis**               | **Fix**                                                                              | **Module**         |
|-----------------------------------------------|-------------------------------|---------------------------------------------------------------------------------------|--------------------|
| ESP32 can’t `pubsub.connect()`              | Wrong broker IP/port           | Check `client.setServer()` vs. `mosquitto` running status.                            | 2, 3, 5, 6         |
| `mosquitto_sub` sees no messages              | ESP32 not publishing            | Firmware crashed; check `Serial.print()`; reboot.                                      | 2, 3, 5           |
| Pi gateway loses WiFi every 5 min             | Router deauth drops ESP32        | Switch router to **WPA2-AES**; ESP32 power saving = 0 in config.h.                   | 4                  |
| RSSI jumps wildly (+/-15 dBm)                 | Multipath interference         | Move router to higher shelf; switch channels or use 5 GHz.                               | 3, 4               |
| LoRa messages arrive 20% packet loss          | Channel busy or ADR hysteresis  | Lora.begin(915E6); check `lora.receive(2000)` timeout.                                | 3                  |
| Battery voltage drops 10% overnight            | Deep sleep leaking 50 µA         | Comment out `Serial.begin()`; add `#ifdef DEBUG` guard.                               | 6                  |
| OPC-UA discovery fails                         | Firewall blocking 4840           | `sudo ufw allow 4840`; use open62541 debug logging.                                 | 5                  |

---

## 🧑‍🏫 Reflection Questions Bank (Snippets to Spark Discussions)

Use these as portfolio prompts or in-class hook.

### Power & Battery Life
- *"If your ESP32 consumes 8 mA in light sleep and 100 mA awake every 15 min, how long does a 500 mAh coin cell last? (**≈100 days**)"*

- *"What’s more painful: hunting for 1 µA leaks or waiting for firmware flashes? What’s the bigger impact on time schedule?"*


### Gateway Design
- *"Your gateway lost WiFi every 30 mins—switch to *USB WiFi dongle* or move router? What’s the **lowest-effort fix**?"*


### Industrial Protocols (Module 5)
- *"Would you rewrite factory code if OPC-UA adds 10 JSON fields? How does JSON compare to Tag encoded as 32-bit int?"*


---

## 💡 Tips from Students & Instructors (Pull-Requests Welcome)

- **From CS Student #23:** "I added `setCpuFrequencyMhz(80)` to `setup()` in sleep-heavy firmware—dropped active current 60 mA → 25 mA. **Portfolio entry:** *‘Power hack cheatsheet’* guide."

- **From Prof #3:** "Keep 2 *batteries* per lab: fresh coin cell and reused 2000 mAh LiPo for comparison. **Lesson:** students never touch the LiPo due to fear of fire—** bring a 5 V USB power probe instead**."


---


## 📌 Next Steps
- **Add your tricks** to this page via Pull Request into your class folder.
- Contribute **dataset screenshots**, **CSV logs**, or **fixed typos** to the portfolio repositories.
- *Tip: Use this bank as your session ‘go-to’ sheet—annotate margins with sticky notes!*


---

*[Back to Workbook](../README.md)*