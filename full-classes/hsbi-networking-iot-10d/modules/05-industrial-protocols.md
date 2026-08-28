# Module 5 – Industrial Protocols (Optional Sprint): OPC-UA vs. Modbus

[← Back to Module 4](./04-routing-gateways.md) | [Quick module index](./00-index.md) | [Next: Module 6 →](./06-power-latency.md)

---

## 📌 Module Outcomes
By the end of this sprint you will:
- Explain **why OPC-UA and Modbus** dominate factories vs. MQTT/HTTP.
- Connect an **ESP32** to an OPC-UA server *or* simulate a Modbus device (minimal code).
- Articulate the **translation friction** between IoT-world (MQTT/json) and factory-world (OPC-UA/tags).

---

## 📚 Pre-Class Preparation (15 min max)

### 🎥 Watch (8 min total)
- **[OPC-UA for Beginners](https://www.youtube.com/watch?v=5m5q6XZKJXQ)** *(IoT Engineering)*
  *Guiding Questions:*
  - What’s an **OPC-UA node** vs. a **tag**?
  - Why is OPC-UA safer than legacy Modbus?


- **[Modbus for Beginners](https://www.youtube.com/watch?v=Txv-OT-AJrA)** *(Instrumentation Tools)*
  *Guiding Questions:*
  - How does Modbus **bit-banging** compare to MQTT’s topic strings?
  - What’s the **breaking point** of 100+ Modbus devices on a single RS-485 line?


---

## 🛠 In-Class Lab: Bridging IoT & Industry

*Choose **one path** (ESP32→OPC-UA **or** ESP32→Modbus simulation) based on kit availability.*

**Shared hardware per team:**
- **Raspberry Pi or your OpenWRT gateway** (port forwarding to 8080 if needed) as a "factory gateway" or test server.
- **Built-in laptops/tablets** for clients.

**Software stack:**
- OPC-UA: [freeOPC-UA server](https://open62541.org/) (C/Python)
- Modbus: [pymodbus](https://pymodbus.readthedocs.io/) (Python) or [esp32-modbus](https://github.com/andresarmento/esp32-modbus) (C)
- Optional: [Node-RED OPC-UA node](https://flows.nodered.org/node/node-red-contrib-opcua)

---

### **Track A: ESP32 → OPC-UA Server (Modern Factory Protocol)**
**Goal:** Push sensor data from ESP32 to an OPC-UA server namespace.

#### Step 0: Server & Client Setup (10 min – team effort)
1. **Install open62541 server** on the Pi:
   ```bash
   sudo apt install open62541-tools  # compiled from source elsewhere
   # or use Docker:
   docker run -p 4840:4840 -p 4841:4841 open62541/sample-server
   ```
2. **Check server address**: `opc.tcp://localhost:4840`


#### Step 1: ESP32 Publisher (10 min – individual)
Example Arduino code to publish ESP32 sensor to OPC-UA:
*(Uses [ESP32 OPC-UA Client Example](https://github.com/Open62541/cmake-examples/tree/master/esp32))
*Parallel to MQTT publish, just change endpoint.

```cpp
#include <open62541.h>

UA_Client *client = UA_Client_new(UA_ClientConfig_default);
UA_StatusCode status = UA_Client_connect(client, "opc.tcp://YOUR_PI_IP:4840");

UA_Variant value; 
char tempStr[20];
float temp = 22.5;
snprintf(tempStr, 20, "%2.1f", temp);
UA_Variant_setScalarCopy(&value, &tempStr, &UA_TYPES[UA_TYPES_STRING]);
UA_Client_writeValueAttribute(client, 
  UA_NODEID_STRING(2, "MyTemperature"), &value);
```

*Task: Capture serial monitor output and save ESP32 logs.*


#### Step 2: Client Read (5 min – group)
1. On Pi/laptop, use **UA Expert GUI** or `ua-client` CLI to subscribe:
   ```bash
   ua-client -e opc.tcp://localhost:4840 -n "Connection1" -s "MyTemperature"
   ```
2. Verify: Temperature updates every 5 sec from ESP32.

*Task: Screenshot UA Expert GUI with the numeric value visible.*

---

### **Track B: ESP32 ↔ Modbus Simulator (Legacy Factory Protocol)**
**Goal:** Simulate a Modbus sensor on ESP32 and read it from a Python client.

#### Step 0: Python Modbus Server (10 min)
1. Install pymodbus:
   ```bash
   pip install pymodbus[repl]
   ```
2. Run **Modbus TCP server**:
   ```python
   from pymodbus.server import StartTcpServer
   from pymodbus.device import ModbusDeviceIdentification
   
   server = StartTcpServer(context=None, address=("0.0.0.0", 5020))
   # Register holding register 0x100 stores temperature (scaled x10)
   ```


#### Step 1: ESP32 Modbus Slave (10 min)
Example sketch (pull request-style Modbus):
```cpp
#include <ModbusIP_ESP8266.h>

ModbusIP mb;
int coil = 0x0000; // discrete input (example)

void setup() {
  mb.config("yourWiFi", "password");
  mb.addCoil(coil); // Simple boolean example
}

void loop() {
  mb.task();
  bool sensorState = digitalRead(D5); // fake sensor
  mb.Coil(0) = sensorState;
}
```
*Task: Modify so coil 0x100 holds 225 (coerced to 22.5C*).


#### Step 2: Python Client Read (5 min)
```python
from pymodbus.client import ModbusTcpClient
client = ModbusTcpClient("192.168.1.x", port=5020)
rr = client.read_holding_registers(0x100, 1) # address 0, count 1
print(rr.registers[0]) # 225 => 22.5°C
```
*Task: Screenshot client terminal with the value.*



---

### **Step 3: Translation Friction Sprint (15 min – whole group)**
*Teams compare tracks A vs. B using a matrix: When would you **translate vs. rebuild**?*

| Scenario                     | Track A (OPC-UA) | Track B (Modbus) | Notes                          |
|-----------------------------|-------------------|-------------------|--------------------------------|
| Modern factory with IT budget| ✅✅✅           | ❌               | OPC-UA supports JSON payloads   |
| 100 sensors on 1 RS-485    | ❌                | ✅✅             | Modbus bit rate under 1Mbps     |
| Need cloud MQTT bridge       | Translation ok    | Translation hell  | Modbus over cloud = kludge       |

*Task: Each team records **1 sentence** of ‘design pattern’ learned (attach to portfolio).*


---

### **Step 4: Integrate into MQTT World (10 min – optional stretch)**
Bridge OPC-UA/Modbus output to your **existing MQTT broker** (from Module 2):

- **OPC-UA → JSON → MQTT bridge** (use Node-RED, Python, or ESP32-cpp).
- **Modbus → MQTT** via `python-pymodbus → paho-mqtt`

*Task: Take 1 screenshot of the bridge running and posting to `iot/oee/temp` topic.*


---

## 📝 Portfolio Reflection Prompts
Write your reflection (1 page) answering:

### Technical Reflection
1. **Protocol Chasm**
   - If your project were placed in a factory tomorrow, which protocol (OPC-UA vs. Modbus vs. MQTT) would you choose—and why?
   - What **bit of glue** (translation layer) scared you most? Are you comfortable trying Node-RED?

2. **Legacy vs. Modern**
   - Summarize the **single biggest advantage of OPC-UA** over Modbus in 1 sentence.
   - What’s the **single biggest risk** of relying on a Translation Micro-service?


---

### Project Context Reflection
3. **Industrial Lenses**
   - Name **one feature** your team added or cut because of protocol choice. Example: "We removed the Temp display because OPC-UA VAT cost RAM."
4. **Process & Learning**
   - What **one debugging workflow** did you borrow from Modbus that would also help MQTT? (e.g., `pymodbus --debug`)?

---

## 🔧 Why This Matters
- **Protocol wars** decide who pays the integration tax.
- **Bridge patterns** (OPC-UA→MQTT) are real-world glue code.
- Many IoT projects **fail at the factory gate** because they can’t speak Modbus symbols.

---
## 📌 Resources & References
- **[open62541 GitHub](https://github.com/open62541/open62541)** (OPC-UA open-source stack)
- **[pymodbus Docs](https://pymodbus.readthedocs.io/)**
- **[Modbus Mapper Cheat Sheet](https://www.simplymodbus.ca/FAQ.htm)**
- **[UA-Nodeset Registry](https://www.opcfoundation.org/ua/part3/)** (OPC-UA types)

---
## 📌 Next Steps
1. Push code screenshots to portfolio **before next meetup**.
2. **Next Module 6:** Module focuses on *power and latency optimization* across the stack you just built.

---
*[Use portfolio template](https://portfolio.iotempower.us) to collect code snippets, screenshots, and reflections.*