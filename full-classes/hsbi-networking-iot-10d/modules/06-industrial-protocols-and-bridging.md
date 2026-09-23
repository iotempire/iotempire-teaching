# Module 6 – Industrial Protocols & Edge Bridging: OPC-UA & Modbus

[← Back to Module 5](./05-wireless-technologies-and-espnow.md) | [Quick module index](./00-index.md) | [Next: Module 7 →](./07-fleet-management-and-iotempower.md)

---

## 🎯 Learning Goals

> **How these are assessed:** You earn this module's points by **proving these goals** in a short (~10-minute) checkpoint presentation with the instructor (see the [syllabus](../syllabus.md#how-module-points-are-earned-checkpoint-presentations)) — based on your portfolio and reflections, not on completing every task. You may skip tasks, fail at some, or add your own; documented exploration and demonstrated deep understanding both count in your favor.

This module gives you the opportunity to explore **industrial interoperability** and achieve competency in **Modbus and OPC-UA, deterministic/real-time networking, and edge bridging into MQTT**.

By the end of this module, you can:
1. Explain why **Modbus and OPC-UA** dominate industrial automation, factory floors, and energy grids.
2. Describe the principles of **deterministic industrial networking**, field buses (RS-485, CAN, Profinet), and **Time-Sensitive Networking (TSN)**.
3. Contrast the register/tag-based industrial paradigm with the topic-based pub/sub model of modern IoT.
4. Build a bidirectional **Industrial-to-IoT Edge Bridge** in Python or Node-RED that translates Modbus/OPC-UA into MQTT telemetry.

> [!WARNING]
> **DRAFT — first taught in WS 2026/27.** Everything below this line is a working draft and will likely change as we refine it together in class; the line moves down as we approve content. Your input is welcome and can shape this module.

**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

---

## 📖 Industrial Communication vs. Modern IoT

### 1. The Legacy Factory Floor: Modbus (RTU & TCP)
Developed in 1979 by Modicon, Modbus is still the most ubiquitous protocol in industrial sensors, PLCs, solar inverters, and power meters:
- **Master/Slave (Client/Server) Architecture:** The Master polls; slaves never speak unless asked.
- **Register-Based Memory Model:**
  - **Discrete Inputs (1 bit, Read-Only):** Digital sensors.
  - **Coils (1 bit, Read/Write):** Relays, solenoid valves.
  - **Input Registers (16 bit, Read-Only):** Analog measurements.
  - **Holding Registers (16 bit, Read/Write):** Configuration parameters, setpoints.
- **Modbus RTU:** Serial over RS-485 with CRC16 checksum.
- **Modbus TCP:** Encapsulates the Modbus frame inside standard TCP (port 502).

### 2. The Modern Industrial Standard: OPC-UA (IEC 62541)
OPC Unified Architecture (OPC-UA) replaces brittle register tables with rich, object-oriented semantics:
- **Information Model & Address Space:** Every sensor, motor, and machine is represented as a structured object node with metadata, engineering units (`°C`, `bar`), data types, and timestamps.
- **Built-in Security:** Certificate-based authentication, integrity signing, and payload encryption.
- **Transport:** Standardized binary protocol over TCP (`opc.tcp://host:4840`) or WebSockets, with emerging Pub/Sub extensions over UDP/TSN.

### 3. Real-Time Ethernet & Time-Sensitive Networking (TSN)
Standard Ethernet and Wi-Fi are **best-effort**: CSMA/CD and CSMA/CA allow collisions and indeterminate queueing delay.
- In robotics and precision manufacturing, a control loop requires **bounded latency and microsecond jitter**.
- Solutions include proprietary real-time Ethernet (EtherCAT, Profinet IRT) and standardized **IEEE 802.1 TSN (Time-Sensitive Networking)**, which introduces time-aware traffic shapers (IEEE 802.1Qbv) to guarantee scheduled bandwidth for critical control frames alongside regular IT traffic.

```text
[Factory PLC / Sensor]
       |
       | Modbus TCP (Port 502) / OPC-UA (Port 4840)
       v
[Edge Gateway / Python Bridge]
       |
       | JSON over MQTT (Port 1883)
       v
[OpenWrt Broker / Node-RED / IoTempower Dashboard]
```

---

## 🛠️ In-Class Lab: Bridging Industry to the Cloud

*No tedious C++ compilation on microcontrollers! We implement clean, educational, industry-grade edge bridging on the gateway/laptop using Python and Node-RED.*

---

### Task 1: Simulating an Industrial Modbus Power Meter (20 min)

1. On your laptop or gateway, install `pymodbus`:
   ```bash
   pip3 install pymodbus
   ```
2. Run a simulated Modbus TCP server (`industrial_meter.py`):
   ```python
   from pymodbus.server import StartTcpServer
   from pymodbus.datastore import ModbusSequentialDataBlock, ModbusSlaveContext, ModbusServerContext
   import threading, time, random

   # Block of 10 holding registers starting at 0
   store = ModbusSlaveContext(hr=ModbusSequentialDataBlock(0, [230, 15, 3450, 0, 0, 0, 0, 0, 0, 0]))
   context = ModbusServerContext(slaves=store, single=True)

   def update_measurements():
       while True:
           time.sleep(1)
           voltage = int(230 + random.uniform(-3, 3))
           current = int(15 + random.uniform(-1, 2))
           power = voltage * current
           store.setValues(3, 0, [voltage, current, power])

   threading.Thread(target=update_measurements, daemon=True).start()
   print("Modbus TCP Server running on port 5020...")
   StartTcpServer(context=context, address=("0.0.0.0", 5020))
   ```
3. Read the registers using a quick client script or CLI to verify voltage, current, and power.

---

### Task 2: Building the Modbus-to-MQTT Bridge in Python (35 min)

Now write an edge bridging service that polls the Modbus registers, maps them to human-readable JSON, and publishes them into the MQTT bus:

```python
import time, json
from pymodbus.client import ModbusTcpClient
import paho.mqtt.client as mqtt

MQTT_BROKER = "192.168.8.1"
MODBUS_HOST = "localhost"
MODBUS_PORT = 5020

mqtt_client = mqtt.Client()
mqtt_client.connect(MQTT_BROKER, 1883, 60)

modbus_client = ModbusTcpClient(MODBUS_HOST, port=MODBUS_PORT)
modbus_client.connect()

print("Bridge started: Modbus TCP -> MQTT...")
while True:
    # Read 3 holding registers starting at address 0
    result = modbus_client.read_holding_registers(0, 3)
    if not result.isError():
        data = {
            "voltage_v": result.registers[0],
            "current_a": result.registers[1],
            "power_w": result.registers[2],
            "timestamp": time.time()
        }
        mqtt_client.publish("factory/press1/power", json.dumps(data), qos=1)
        print(f"Published to MQTT: {data}")
    time.sleep(2)
```

Run the bridge and verify in Node-RED or MQTT Explorer that the industrial registers now appear as real-time MQTT streams!

---

### Task 3: OPC-UA Integration in Node-RED (35 min)
*Alternatively or in addition, explore OPC-UA:*

1. In Node-RED, install the OPC-UA palette: `node-red-contrib-opcua`.
2. Connect to an OPC-UA demo server (e.g. `opc.tcp://opcuaserver.com:48010` or a local Python `asyncua` server).
3. Browse the Address Space hierarchy:
   `Root -> Objects -> Server -> ServerStatus -> CurrentTime`.
4. Create an inject/read node in Node-RED that subscribes to variable changes and outputs them to the Node-RED UI dashboard.
5. Create a reverse flow: A button on the Node-RED dashboard writes a setpoint value into an OPC-UA Variable Node!

---

## 📝 Working-Day Reflection & Portfolio Tasks

In your portfolio under `modules/06-industrial-protocols/`:
1. **Protocol Translation Matrix:** Compare **Modbus TCP**, **OPC-UA**, and **MQTT**:
   - Data model (registers vs. objects/tags vs. topic payloads)
   - Read/Write model (polling vs. events/pub-sub)
   - Security features
   - Primary deployment domain
2. **Bridge Architecture & Code:** Include your Python bridge script and a diagram showing how the edge gateway bridges the factory domain to the IT/IoT domain.
3. **Real-Time Reflection:** Why cannot standard Wi-Fi or standard TCP/IP be used for microsecond-precise motion control in a factory, and how does TSN address this?
