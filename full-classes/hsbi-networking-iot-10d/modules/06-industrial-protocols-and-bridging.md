# Module 6 – Industrial Protocols & Edge Bridging: Modbus, OPC-UA & RS-485 (overview; optional lab)

[← Back to Module 5](./05-wireless-technologies-and-espnow.md) | [Quick module index](./00-index.md) | [Next: Module 7 →](./07-fleet-management-and-iotempower.md)

> [!NOTE]
> **Short and dry on purpose.** We do not have an industrial lab. The module is one video, one discussion, one RS-485/Modbus demo if the hardware is there, and an EtherCAT guest slot if we can get one. The rest of the page is a reference map for the handbook, not a lecture. You are not expected to own a factory.

**Course placement:** Day 6 — a short industrial-interoperability briefing: watch, discuss, one RS-485/Modbus demo, an EtherCAT guest slot, and an optional Python wrapper.

## 🎯 Learning Goals

This module gives you the opportunity to explore industrial interoperability and achieve competency in the concepts of Modbus, OPC-UA, RS-485, and deterministic/real-time networking, plus (optionally) a simulated bridge into MQTT.

By the end of this module, you can:
1. Explain why Modbus and OPC-UA dominate industrial automation, factory floors, and energy grids.
2. Describe the principles of deterministic industrial networking, field buses (RS-485, CAN, Profinet), and Time-Sensitive Networking (TSN).
3. Contrast the register/tag-based industrial paradigm with the topic-based pub/sub model of modern IoT.
4. *(Optional)* Build a small Modbus-to-MQTT wrapper in Python that translates a register into MQTT telemetry.


**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 📖 Story — The Meter That Speaks 1979

**Brinkmann Maschinenbau GmbH** has a working test rig and a problem that will be familiar to anyone who has walked into a factory: the energy meter on the rig speaks Modbus RTU over RS-485, the PLC speaks Modbus TCP, the company's new monitoring platform speaks MQTT with JSON, and nobody wants to touch the certified PLC code.

Automation engineer **Sofia Roth** needs a non-invasive bridge: read the meter's registers, map them to meaningful names and units, and publish them into the local IoT fabric without changing the machine. She also needs to explain why a microsecond-precise motion loop cannot run over ordinary Wi-Fi. Today you learn the industrial vocabulary — Modbus, OPC-UA, RS-485, TSN — and see the wrapper that translates a register world into a topic world.

## 🎬 Watch & Discuss — the quick path

This module is deliberately short and dry. Watch one video, discuss the three questions, and use the rest of the page as a reference map.

- **Modbus, the essential one** — [RealPars: What is Modbus and How does it Work?](https://www.youtube.com/watch?v=txi2p5_OjKU) — RTU over RS-485, the register model, master/slave.
- **EtherCAT, the interesting contrast** — [RealPars: What is EtherCAT?](https://www.youtube.com/watch?v=tYAl2jkaB8Q) — the Ethernet fieldbus, on-the-fly processing, deterministic cycles.
- **Two-minute vocabulary** — [Fieldbus Explained in 2 Minutes](https://www.youtube.com/watch?v=G-M3YmkMcZk) — if you want the terms before the longer videos.

**Discuss in your pod:**
1. What does Modbus add on top of RS-485, and what does it still not give you?
2. Why does EtherCAT process frames differently from Modbus TCP, and what does that buy a motion-control loop?
3. Where does the wrapper between the fieldbus and MQTT sit — and what do you lose if you remove it?

If the videos are unavailable, use the Modbus/EtherCAT organization pages and the diagrams below; the discussion is the point.

## 📖 Pod Study: Industrial Communication vs. Modern IoT

This is **self/pod study, not a lecture.** Work through the concepts below with your Task Pod, look things up, ask an LLM, and keep notes — the goal is a shared mental model you can defend in the checkpoint. **The video and the discussion are the quick path; the sections below are a reference map.**

### 1. The Legacy Factory Floor: Modbus (RTU & TCP)
Developed in 1979 by Modicon, Modbus is still the most ubiquitous protocol in industrial sensors, PLCs, solar inverters, and power meters:
- Master/Slave (Client/Server) Architecture: The Master polls; slaves never speak unless asked.
- Register-Based Memory Model:
  - Discrete Inputs (1 bit, Read-Only): Digital sensors.
  - Coils (1 bit, Read/Write): Relays, solenoid valves.
  - Input Registers (16 bit, Read-Only): Analog measurements.
  - Holding Registers (16 bit, Read/Write): Configuration parameters, setpoints.
- Modbus RTU: Serial over RS-485 with CRC16 checksum.
- Modbus TCP: Encapsulates the Modbus frame inside standard TCP (port 502).

### 2. The Modern Industrial Standard: OPC-UA (IEC 62541)
OPC Unified Architecture (OPC-UA) replaces brittle register tables with rich, object-oriented semantics:
- Information Model & Address Space: Every sensor, motor, and machine is represented as a structured object node with metadata, engineering units (`°C`, `bar`), data types, and timestamps.
- Built-in Security: Certificate-based authentication, integrity signing, and payload encryption.
- Transport: Standardized binary protocol over TCP (`opc.tcp://host:4840`) or WebSockets, with emerging Pub/Sub extensions over UDP/TSN.

### 3. Real-Time Ethernet & Time-Sensitive Networking (TSN)
Standard Ethernet and Wi-Fi are best-effort: CSMA/CD and CSMA/CA allow collisions and indeterminate queueing delay.
- In robotics and precision manufacturing, a control loop requires bounded latency and microsecond jitter.
- Solutions include proprietary real-time Ethernet (EtherCAT, Profinet IRT) and standardized IEEE 802.1 TSN (Time-Sensitive Networking), which introduces time-aware traffic shapers (IEEE 802.1Qbv) to guarantee scheduled bandwidth for critical control frames alongside regular IT traffic.

```text
[Factory PLC / Sensor]
       |
       | Modbus TCP (Port 502) / OPC-UA (Port 4840)
       v
[Edge Gateway / Python Bridge]
       |
       | JSON over MQTT (Port 1883)
       v
[OpenWrt Broker]
       |
       | MQTT (local clients)
       v
[Node-RED (if available) / MQTT Explorer / IoTempower Dashboard]
```

### 4. Fieldbuses in the ISO/OSI Model

The module handbook asks you to place fieldbuses in the ISO/OSI model. The point is not to memorize a stack; it is to see which layers a bus actually occupies.

| Technology | Physical | Data link | Network / transport | Application | What it means in practice |
|---|---|---|---|---|---|
| Modbus RTU over RS-485 | RS-485 twisted pair, multi-drop | Modbus serial framing, CRC16 | — | Modbus function codes/registers | One master polls many slaves; no IP, no routing |
| Modbus TCP | Ethernet | Ethernet MAC | TCP/IP (port 502) | Modbus function codes/registers | Same register model, now routable |
| OPC-UA | Ethernet/Wi-Fi/TSN | Ethernet/Wi-Fi | TCP/IP or WebSocket; Pub/Sub over UDP/TSN | OPC-UA information model, services, security | The upper layers carry the semantics; the lower layers are transport |
| CAN / CANopen | Differential bus | CAN arbitration and framing | — (CANopen adds profiles) | CANopen objects | Multi-master, priority arbitration, automotive/machinery |
| Profinet / EtherCAT | Ethernet | Real-time Ethernet | — (cyclic frames) | Application profile | Deterministic factory control |
| TSN | Ethernet | IEEE 802.1 time-aware shaping | — | — | Bounded latency for converged IT/OT traffic |

> **How to read the table.** RS-485/Modbus RTU is a fieldbus in the classic sense: physical + data link + application, with no network layer. Modbus TCP keeps the application model and borrows TCP/IP. OPC-UA lives in the upper layers and uses the lower layers as transport. TSN is a Layer-2 mechanism that makes Ethernet deterministic for the layers above.

### 5. Choosing a Bus: What Actually Matters

| Bus / family | Topology and media | Typical speed / range | Determinism | Best fit |
|---|---|---|---|---|
| RS-485 / Modbus RTU | Multi-drop twisted pair, half-duplex | 9.6–115.2 kbit/s over long runs; higher over short runs | Polling; predictable but not hard real-time | Meters, PLCs, retrofits over existing wiring |
| CAN / CANopen | Differential bus, multi-master | Up to 1 Mbit/s, short bus | Priority arbitration; deterministic enough for control | Vehicles, mobile machinery, embedded control |
| Profinet / EtherCAT | Ethernet, line/ring/star | 100 Mbit/s and up, short cycles | Cyclic real-time; vendor-specific | Factory automation, motion control |
| TSN | Ethernet, star/ring | 1 Gbit/s and up | Scheduled traffic, bounded latency | Converged IT/OT, time-critical Ethernet |
| MQTT over TCP/IP | Any IP link | Network-limited | Best-effort; QoS is delivery, not latency | Telemetry, dashboards, cloud/edge integration |

> **The design question.** Choose the bus for the *physical and timing* requirements first, then choose the integration protocol. A factory cell may keep Modbus RTU on the machine and add an MQTT bridge at the edge; that is cheaper and safer than replacing the certified control loop.

### Pointers (start here, then keep looking)

- Modbus — [Modbus Organization](https://modbus.org/), [Wikipedia: Modbus](https://en.wikipedia.org/wiki/Modbus)
- OPC-UA — [OPC Foundation](https://opcfoundation.org/about/opc-technologies/opc-ua/), [open62541](https://www.open62541.org/)
- RS-485 — [Wikipedia: RS-485](https://en.wikipedia.org/wiki/RS-485)
- TSN — [IEEE 802.1 Time-Sensitive Networking](https://en.wikipedia.org/wiki/Time-Sensitive_Networking)
- Python bridges — [pymodbus](https://pymodbus.readthedocs.io/), [asyncua](https://github.com/FreeOpcUa/opcua-asyncio)
- The [resource bank's OPC-UA and Modbus quick references](./Z-resources-bank.md#opc-ua-quick-nodes-optional)

### Questions to ask an LLM (then verify against a simulator)

Ask your co-pilot — but treat every answer as a **claim to test**, not a fact. Good starting prompts:

- "Explain Modbus RTU vs. Modbus TCP: physical layer, framing, addressing, and the role of the CRC."
- "Contrast a Modbus holding register with an OPC-UA variable node and an MQTT topic. What is lost and gained in each translation?"
- "Why is standard Ethernet non-deterministic, and what does TSN change for a motion-control loop?"
- "Design a read-only Modbus-to-MQTT bridge for a power meter. How do I handle polling, timeouts, scaling, and units?"
- "A factory forbids changes to its PLC code. How can an external edge bridge still provide monitoring without touching the PLC?"

> Run each prompt against a simulator, and record where the model is wrong, vague, or over-confident.

## 🛠️ RS-485/Modbus in the Room — a short demo, not a lab

If we have an RS-485 device and a USB-RS485 adapter, we do this together:

1. Wire A, B, and GND; add termination only if the bus needs it; keep a common ground.
2. Read one holding register with the vendor tool, `pymodbus`, or a small script.
3. Publish that register as `factory/meter/power` with `mosquitto_pub` or a ten-line Python script.
4. Discuss: **Modbus turns RS-485 into a bus; the wrapper turns a register into a topic.** If you can wire one RS-485 device, you can read Modbus; the wrapper is the part you will actually build.

If the hardware is not there, the video and the register map are enough. The wrapper is the transferable skill.

## 🏭 EtherCAT and the Test Device — guest slot

EtherCAT is the useful counterexample: it keeps Ethernet's physical layer but processes frames **on the fly**, so one frame can visit many devices in a single cycle. That is why it can be deterministic at microsecond scale while Modbus TCP is not.

If we can get a guest lecturer and the test device from upstairs, the slot is: the guest explains the device's parts and the EtherCAT topology, then you build your own small setup in the project studio. If not, use the EtherCAT video and the comparison table. The exam does not require you to own a test rig.

### ★ Task A: Study in your pod

This is a short briefing, so keep the log short. Write it under `## Study log` in `Module06/README.md` — a section, not a file, unless it outgrows the page. **One pod member keeps the shared log; the others link to that section from their own module README and add one sentence on what they took from it.**

1. **The video you watched** (or the source you read) and the one concept you understood best from it.
2. **Your answers to the three discussion questions** — one short paragraph each.
3. **The one-page bus map** — place Modbus RTU, Modbus TCP, OPC-UA, EtherCAT, and TSN on the OSI layers; say which you would choose for a meter and for a motion axis, and why.
4. **Optional:** one LLM claim you checked and where it was wrong.

*Portfolio evidence:* the `## Study log` section (yours, or a link to your pod's shared one).

### ★ Task B: Explain & share with another pod

Pair with a **neighbouring pod**:

1. **Explain to each other** — each pod walks the other through its bus map and its wrapper sketch; ask questions and fill each other's gaps.
2. Agree on the **3–5 most noteworthy points** and the **learning you jointly stand behind** (e.g. *"a register is not a variable; the bridge supplies the semantics"*).
3. **Clean up your documentation** — update the `## Study log` with what you learned from the other pod.
4. Agree on **one shared artefact** — the best translation matrix, a bridge diagram, or a simulated capture the two pods make together — and **post it in the course Discord**, with a one-sentence note on why you chose it.
5. Each member adds a short **“Agreed learning (pod discussion)”** note — in the shared log, or in your own module README with a link to it.

*Portfolio evidence:* the cleaned-up `## Study log` (with the **“Agreed learning (pod discussion)”** note) and your pod-pair's shared artefact.

## 🛠️ Optional Lab: Bridging Industry to the Cloud (simulated) — **Challenging (optional lab)**

*No tedious C++ compilation on microcontrollers — and no industrial hardware required.* This is one optional stretcher: a small Python wrapper on a laptop, against a simulated Modbus server. There is no Node-RED dependency. If you have a real RS-485 device (for example a Modbus RTU meter) and a USB-RS485 adapter, that is the closest genuine experience and a strong Excellence Stretcher candidate.

### ◇ Task 1 (Stretcher): Simulating an Industrial Modbus Power Meter

1. In your `uv` environment (see the [resource bank](./Z-resources-bank.md#python-environment-with-uv-optional)), add `pymodbus`:
   ```bash
   uv add pymodbus
   ```
2. Run a simulated Modbus TCP server (`industrial_meter.py`) with `uv run python industrial_meter.py`:
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

### ◇ Task 2 (Stretcher): Building the Modbus-to-MQTT Bridge in Python

Now write an edge bridging service that polls the Modbus registers, maps them to human-readable JSON, and publishes them into the MQTT bus:

```python
import time, json
from pymodbus.client import ModbusTcpClient
import paho.mqtt.client as mqtt

MQTT_BROKER = "192.168.14.1"
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

Run the bridge and verify in MQTT Explorer or `mosquitto_sub` that the industrial registers now appear as real-time MQTT streams!

## ✅ Suggested portfolio evidence (proofs of the learning goals)

1. Protocol Translation & Bus Map *(recommended)*: Compare Modbus TCP, OPC-UA, and MQTT:
   - Data model (registers vs. objects/tags vs. topic payloads)
   - Read/Write model (polling vs. events/pub-sub)
   - Security features
   - Primary deployment domain
   - Add the ISO/OSI layers each protocol occupies, and the bus comparison (RS-485, CAN, Profinet/EtherCAT, TSN)
2. Real-Time Question *(recommended)*: Why cannot standard Wi-Fi or standard TCP/IP be used for microsecond-precise motion control in a factory, and how does TSN address this?
3. *(Optional)* Bridge Architecture & Code: Include your bridge script and a diagram showing how the edge gateway bridges the factory domain to the IT/IoT domain.
4. *(Optional stretcher)* Real RS-485/Modbus: If you have an RS-485 device, document reading it (physical layer, wiring, adapter, registers) and bridging it to MQTT.


> [!IMPORTANT]
> Never commit secrets, credentials, private keys, or plant data. Where you did not work entirely alone, link your pod mates and sources.

## 📚 If you want to go deeper

- [Modbus Organization](https://modbus.org/) and [Wikipedia: Modbus](https://en.wikipedia.org/wiki/Modbus) — the register model and framing.
- [OPC Foundation: OPC-UA](https://opcfoundation.org/about/opc-technologies/opc-ua/) — the information model and security.
- [Wikipedia: RS-485](https://en.wikipedia.org/wiki/RS-485) — the physical layer behind Modbus RTU.
- [Time-Sensitive Networking](https://en.wikipedia.org/wiki/Time-Sensitive_Networking) — why factory control needs bounded latency.
- [pymodbus](https://pymodbus.readthedocs.io/) and [asyncua](https://github.com/FreeOpcUa/opcua-asyncio) — the Python bridges.

---

[← Previous: Module 5](./05-wireless-technologies-and-espnow.md) | [Back to front page](../README.md) | [Quick module index](./00-index.md) | [Next: Module 7 — Fleet Management & IoTempower →](./07-fleet-management-and-iotempower.md)
