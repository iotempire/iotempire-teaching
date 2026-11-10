# Module 6 – Industrial Protocols & Edge Bridging: Modbus, OPC-UA & RS-485 (overview; optional lab)

[← Back to Module 5](./05-wireless-technologies-and-espnow.md) | [Quick module index](./00-index.md) | [Next: Module 7 →](./07-fleet-management-and-iotempower.md)

> [!NOTE]
> **Short and dry on purpose.** We do not have an industrial lab. The module is one video, one discussion, one RS-485/Modbus demo if the hardware is there, and an EtherCAT guest slot if we can get one. The rest of the page is a reference map for the handbook, not a lecture. You are not expected to own a factory.

**Course placement:** Day 6 — a short industrial-interoperability briefing: place the protocols, watch and discuss, one RS-485/Modbus demo if the hardware is there, an EtherCAT guest slot, and an optional Python wrapper.

## 🎯 Learning Goals

This module gives you the opportunity to explore industrial interoperability and achieve competency in the concepts of Modbus, OPC-UA, RS-485, and deterministic/real-time networking, plus (optionally) a simulated bridge into MQTT.

By the end of this module, you can:
1. Explain why Modbus and OPC-UA dominate industrial automation, factory floors, and energy grids.
2. Describe the principles of deterministic industrial networking, field buses (RS-485, CAN, Profinet), and Time-Sensitive Networking (TSN).
3. Contrast the register/tag-based industrial paradigm with the topic-based pub/sub model of modern IoT.
4. *(Optional)* Build a small Modbus-to-MQTT wrapper in Python that translates a register into MQTT telemetry.

**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 🎬 Opening the Briefing

**The day starts with the meter, not a slide.** Module 5 gave you a radio; today you meet the factory floor it has to talk to. The opening runs in four quick beats:

1. **Pre-study check-in.** In your pod, show one artefact from Module 5 — the radio matrix, the bridge diagram, or the latency comparison — and name one question you still have. Park the questions on the board.
2. **Confirm the pod and the roles.** Rotate: one drives the video/notes, one drives the RS-485 demo (if we have hardware), one keeps the bus map. Swap after each round.
3. **Collect what is there.** One RS-485 device and a USB-RS485 adapter if available; otherwise the videos, the register map, and the tables are the material. The EtherCAT test device is a guest slot, not a dependency.
4. **Draw the two domains.** On one side the OT world (meter, PLC, RS-485, Modbus), on the other the IT world (MQTT, JSON, broker); mark where the wrapper sits. You will correct it all day.

Before you start, answer these three in one sentence each:

- What does the meter speak, and what does the monitoring platform speak?
- Where does the wrapper sit, and what does it translate?
- Why can a motion-control loop not simply run over ordinary Wi-Fi?

### Your portfolio entry for today — sections, not files

Everything from today goes into **`Module06/README.md`** as sections. Split something into its own file only when a section outgrows the page.

- `## Bus map` — the OSI placement of Modbus RTU/TCP, OPC-UA, EtherCAT, and TSN, plus the meter/motion choice.
- `## Study log` — the running log: the video, the discussion answers, and the one LLM claim you checked. Short is fine.
- `## Discussion log` — one line per discussion: who listened, what they asked, what you changed. This is personal.
- `## Demo notes` — the RS-485 register you read and the MQTT topic you published, if the hardware was there.
- `## Bridge` — optional: the simulated Modbus → MQTT bridge and what it translated.
- `## Story seeds` — optional: the odd bits worth turning into a story later.

*One pod member keeps the shared `## Study log`; the others link to it from their own `Module06/README.md` and add one sentence on what they took from it. The `## Discussion log` is yours alone.*

### The no-factory contract

- **No PLC code changes.** The bridge is non-invasive: read registers, publish topics, leave the certified control loop alone.
- **No plant data.** Do not publish real meter data, customer names, or plant identifiers. Use the simulator or a lab device.
- **No hardware dependency.** The video, the register map, and the tables are enough if the RS-485 device is not there. The wrapper is the transferable skill.

## 📖 The Challenge — The Meter That Speaks 1979

**Brinkmann Maschinenbau GmbH** has a working test rig and a problem that will be familiar to anyone who has walked into a factory: the energy meter on the rig speaks Modbus RTU over RS-485, the PLC speaks Modbus TCP, the company's new monitoring platform speaks MQTT with JSON, and nobody wants to touch the certified PLC code.

Automation engineer **Sofia Roth** needs a non-invasive bridge: read the meter's registers, map them to meaningful names and units, and publish them into the local IoT fabric without changing the machine. She also needs to explain why a microsecond-precise motion loop cannot run over ordinary Wi-Fi.

**Your challenge.** Explain the factory floor well enough to bridge it safely. You are done when you can show:

1. A bus map that places Modbus RTU, Modbus TCP, OPC-UA, EtherCAT, and TSN in the OSI model, with a justified choice for the meter and for the motion axis.
2. Answers to the three discussion questions — short, concrete, no memorized stack.
3. One RS-485/Modbus observation: a register read and the topic you published, if the hardware is there; otherwise the register map and what you would publish.
4. An explanation of the wrapper: **register → topic**, what the wrapper adds, and what is lost.
5. *(Optional stretch)* A simulated Modbus → MQTT bridge in Python.

**Constraints.** No industrial lab. No PLC code changes. No plant data. One video, one discussion, one demo if the hardware is there. The guest slot is a bonus, not a dependency.

**This story is unfinished on purpose.** The hooks below are starting points, not a script. Pick the ones that match what you actually saw, and add a line of your own — *"and the register was signed, so the negative power read as 65,000"* is worth more than a perfect table. Collect those lines under `## Story seeds` and use them in a discussion or the harvest.

## 🧭 How this studio works now

**The study is folded into the practice.** There is no separate pod-study phase and no scheduled hand-off to another pod. Each round gives you a small thing to do, a short **Theory you need** box you read only when the task makes you want it, and a **discussion** at the end. Keep your notes in `Module06/README.md` under `## Study log` — short is fine.

**First: skim, do not start.** Read the challenge and the round table, then skim the two tables and the evidence list. You are looking for **where the wrapper sits** and **which layers a bus actually occupies**. Then start Round 1.

**Every round ends with a discussion — one person is enough.** Ask someone at the nearest pod if they have a moment; show them the round's artefact and ask the discussion question. If they want, let them show you theirs and ask you one question back. **This is a brag, not a quiz.** Write one line in `## Discussion log`: who listened, what they asked, what you changed. If nobody is free, ask someone else or come back later — do not wait.

**Take a study break when a box is not enough.** Read the linked source, then explain it to one person. Explaining is the test, not reading. You do not need permission; take the break when the task makes you want it.

The table is the discussion map: the **[Goal](#-learning-goals) · theory box** column names what each discussion checks. The question tests understanding, not task completion.

| # | Round | You produce | [Goal](#-learning-goals) · theory box | Discussion question for one person |
|---|---|---|---|---|
| 1 | **Place the protocols** | A bus map and the meter/motion choice | G2 · Place the protocols | "Which layers does Modbus RTU occupy, and which does Modbus TCP borrow?" |
| 2 | **Watch and discuss** | Your answers to the three questions | G1 + G3 · Watch and discuss | "What does Modbus add on top of RS-485?" |
| 3 | **Touch the bus** | A register read and the topic you published (or the map) | G1 + G3 · Touch the bus | "What does the wrapper add?" |
| ◇ | **Guest: EtherCAT** | Notes from the guest/test device, or the video contrast | G2 · EtherCAT | "Why can EtherCAT be deterministic when Modbus TCP is not?" |
| ◇ | **Simulated bridge** | A Modbus → MQTT wrapper and the topic stream | G4 · Simulated bridge | "What is lost in the translation?" |

**The order is a suggestion.** The rounds are a path, not a timetable. If the RS-485 hardware is missing, do Round 3 on the register map and move on; if the guest is not there, use the EtherCAT video. **The instructor demos one register read and one publish live if the hardware is present.** The question you should always be able to answer is *"what did you choose, and what did it cost you?"*

## 🛠️ The Briefing: Four Layers and a Wrapper — **Short and Dry**

### ★ Round 1: Place the protocols

Fill the bus map for the meter and the motion axis. Use the two tables as the index, not as a text to memorize.

**Theory you need.** **Modbus** (1979) is the most ubiquitous industrial protocol: master/slave polling, a register-based memory model (discrete inputs, coils, input registers, holding registers). **Modbus RTU** runs over RS-485 with a CRC16; **Modbus TCP** encapsulates the same application frame in TCP port 502. **OPC-UA** replaces brittle register tables with an object-oriented information model, rich metadata, engineering units, and certificate-based security over TCP 4840 or WebSockets.

Standard Ethernet and Wi-Fi are best-effort: CSMA/CD and CSMA/CA allow collisions and indeterminate queueing delay. **EtherCAT** and **Profinet IRT** process frames deterministically for motion control; **TSN** (IEEE 802.1) adds time-aware traffic shaping to standard Ethernet. The factory cell may keep Modbus RTU on the machine and add an MQTT bridge at the edge; that is cheaper and safer than replacing the certified control loop.

| Technology | Physical | Data link | Network / transport | Application | What it means in practice |
|---|---|---|---|---|---|
| Modbus RTU over RS-485 | RS-485 twisted pair, multi-drop | Modbus serial framing, CRC16 | — | Modbus function codes/registers | One master polls many slaves; no IP, no routing |
| Modbus TCP | Ethernet | Ethernet MAC | TCP/IP (port 502) | Modbus function codes/registers | Same register model, now routable |
| OPC-UA | Ethernet/Wi-Fi/TSN | Ethernet/Wi-Fi | TCP/IP or WebSocket; Pub/Sub over UDP/TSN | OPC-UA information model, services, security | The upper layers carry the semantics; the lower layers are transport |
| CAN / CANopen | Differential bus | CAN arbitration and framing | — (CANopen adds profiles) | CANopen objects | Multi-master, priority arbitration, automotive/machinery |
| Profinet / EtherCAT | Ethernet | Real-time Ethernet | — (cyclic frames) | Application profile | Deterministic factory control |
| TSN | Ethernet | IEEE 802.1 time-aware shaping | — | — | Bounded latency for converged IT/OT traffic |

**How to read the table.** RS-485/Modbus RTU is a fieldbus in the classic sense: physical + data link + application, with no network layer. Modbus TCP keeps the application model and borrows TCP/IP. OPC-UA lives in the upper layers and uses the lower layers as transport. TSN is a Layer-2 mechanism that makes Ethernet deterministic for the layers above.

| Bus / family | Topology and media | Typical speed / range | Determinism | Best fit |
|---|---|---|---|---|
| RS-485 / Modbus RTU | Multi-drop twisted pair, half-duplex | 9.6–115.2 kbit/s over long runs; higher over short runs | Polling; predictable but not hard real-time | Meters, PLCs, retrofits over existing wiring |
| CAN / CANopen | Differential bus, multi-master | Up to 1 Mbit/s, short bus | Priority arbitration; deterministic enough for control | Vehicles, mobile machinery, embedded control |
| Profinet / EtherCAT | Ethernet, line/ring/star | 100 Mbit/s and up, short cycles | Cyclic real-time; vendor-specific | Factory automation, motion control |
| TSN | Ethernet, star/ring | 1 Gbit/s and up | Scheduled traffic, bounded latency | Converged IT/OT, time-critical Ethernet |
| MQTT over TCP/IP | Any IP link | Network-limited | Best-effort; QoS is delivery, not latency | Telemetry, dashboards, cloud/edge integration |

**Do.** Place Modbus RTU, Modbus TCP, OPC-UA, EtherCAT, and TSN on the OSI layers. Then choose one for the energy meter and one for a microsecond motion axis; write one sentence each.

> **Discussion — show one person.** Show the bus map and ask: *"Which layers does Modbus RTU occupy, and which does Modbus TCP borrow?"* Write one line in `## Discussion log`.

> **Story hook.** *Sofia's problem.* The meter speaks 1979, the platform speaks MQTT, and the PLC code is certified. The bridge has to respect all three.

*Portfolio evidence:* the `## Bus map` with the OSI placement and the two choices.

### ★ Round 2: Watch and discuss

Watch one video, then discuss the three questions. The videos are the factory tour you cannot take; the tables are the reference.

- **Modbus, the essential one** — [RealPars: What is Modbus and How does it Work?](https://www.youtube.com/watch?v=txi2p5_OjKU) — RTU over RS-485, the register model, master/slave.
- **EtherCAT, the interesting contrast** — [RealPars: What is EtherCAT?](https://www.youtube.com/watch?v=tYAl2jkaB8Q) — the Ethernet fieldbus, on-the-fly processing, deterministic cycles.
- **Two-minute vocabulary** — [Fieldbus Explained in 2 Minutes](https://www.youtube.com/watch?v=G-M3YmkMcZk) — if you want the terms before the longer videos.

If the videos are unavailable, use the Modbus/EtherCAT organization pages and the tables; the discussion is the point.

**Theory you need.** A fieldbus is optimized for the factory floor: deterministic timing, simple devices, long cable runs, and a control loop that must not wait for a cloud. MQTT is optimized for integration: decoupled producers and consumers, a broker, and best-effort delivery. The wrapper is the seam between the two; it does not make the fieldbus real-time-capable.

**Discuss in your pod:**
1. What does Modbus add on top of RS-485, and what does it still not give you?
2. Why does EtherCAT process frames differently from Modbus TCP, and what does that buy a motion-control loop?
3. Where does the wrapper between the fieldbus and MQTT sit — and what do you lose if you remove it?

> **Discussion — show one person.** Give your answer to question 1 and ask: *"What does Modbus add on top of RS-485?"* Write one line in `## Discussion log`.

> **Story hook.** *The video is the factory tour you cannot take.* You do not need to own a factory to see where the timing and the semantics come from.

*Portfolio evidence:* your three discussion answers, one short paragraph each.

### ★ Round 3: Touch the bus — a short demo, not a lab

If we have an RS-485 device and a USB-RS485 adapter, we do this together:

1. Wire A, B, and GND; add termination only if the bus needs it; keep a common ground.
2. Read one holding register with the vendor tool, `pymodbus`, or a small script.
3. Publish that register as `factory/meter/power` with `mosquitto_pub` or a ten-line Python script.
4. Discuss: **Modbus turns RS-485 into a bus; the wrapper turns a register into a topic.** If you can wire one RS-485 device, you can read Modbus; the wrapper is the part you will actually build.

If the hardware is not there, the video and the register map are enough. The wrapper is the transferable skill.

**Theory you need.** RS-485 is a differential, multi-drop physical layer: two wires, a common ground, and a shared bus. Modbus RTU adds serial framing, a slave address, function codes, and a CRC16; the master polls, the slaves answer only when asked. The register model is the API: coils and discrete inputs are bits, input and holding registers are 16-bit words. A register has no name, unit, or timestamp — the wrapper supplies them. *Go deeper: the Modbus and RS-485 references.*

> **Discussion — show one person.** Show the register you read and the topic you published, and ask: *"What does the wrapper add?"* Write one line in `## Discussion log`.

> **Story hook.** *One register, one topic.* The meter does not know what a topic is; the wrapper is the only place where a number becomes a named measurement.

*Portfolio evidence:* the register read, the topic/payload you published, and one sentence on what the wrapper added.

### ◇ Guest: EtherCAT and the test device

EtherCAT is the useful counterexample: it keeps Ethernet's physical layer but processes frames **on the fly**, so one frame can visit many devices in a single cycle. That is why it can be deterministic at microsecond scale while Modbus TCP is not.

If we can get a guest lecturer and the test device from upstairs, the slot is: the guest explains the device's parts and the EtherCAT topology, then you build your own small setup in the project studio. If not, use the EtherCAT video and the comparison table. The exam does not require you to own a test rig.

**Theory you need.** Standard Ethernet queues frames; a switch introduces variable delay, and TCP retransmits. EtherCAT's master sends a frame that each slave reads and writes **as it passes**, so the cycle time is bounded by the wire, not by store-and-forward queueing. TSN takes a different route: it schedules critical traffic on standard Ethernet with time-aware shapers. Both are answers to the same requirement — bounded latency and low jitter — with different trade-offs. *Go deeper: the TSN and EtherCAT references.*

> **Discussion — show one person.** Explain the contrast and ask: *"Why can EtherCAT be deterministic when Modbus TCP is not?"* Write one line in `## Discussion log`.

> **Story hook.** *The test device upstairs.* The guest can show the parts; your job is to explain why the timing matters, not to memorize the rig.

*Portfolio evidence:* the guest/video notes and one sentence on the deterministic difference.

### ◇ Simulated bridge — Modbus to MQTT in Python

*No tedious C++ compilation on microcontrollers — and no industrial hardware required.* This is one optional stretcher: a small Python wrapper on a laptop, against a simulated Modbus server. There is no Node-RED dependency. If you have a real RS-485 device (for example a Modbus RTU meter) and a USB-RS485 adapter, that is the closest genuine experience and a strong Excellence Stretcher candidate.

**1. Simulate an industrial Modbus power meter.** In your `uv` environment (see the [resource bank](./Z-resources-bank.md#python-environment-with-uv-optional)), add `pymodbus`:

```bash
uv add pymodbus
```

Run a simulated Modbus TCP server (`industrial_meter.py`) with `uv run python industrial_meter.py`:

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

Read the registers using a quick client script or CLI to verify voltage, current, and power.

**2. Build the Modbus-to-MQTT bridge.** Now write an edge bridging service that polls the Modbus registers, maps them to human-readable JSON, and publishes them into the MQTT bus:

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

Run the bridge and verify in MQTT Explorer or `mosquitto_sub` that the industrial registers now appear as real-time MQTT streams.

**Theory you need.** The bridge does three translations: **register → named field** (the register map supplies names, units, and scaling), **polling → publish** (the Modbus master asks; the MQTT client publishes), and **device → topic** (the topic carries the location and the measurement). What is lost? The device's own semantics, its timing guarantees, and its error model. That is why the wrapper is a product decision, not a line of code. *Go deeper: the pymodbus and asyncua docs.*

> **Discussion — show one person.** Show the MQTT stream from the simulated meter and ask: *"What is lost in the translation?"* Write one line in `## Discussion log`.

*Portfolio evidence:* the two scripts, the MQTT stream, and one sentence each on what the wrapper added and what it lost.

## 🤖 Ask an LLM — then verify

Use these when a theory box is not enough. Treat every answer as a **claim to test**, not a fact, and run it against a simulator or a real device.

- "Explain Modbus RTU vs. Modbus TCP: physical layer, framing, addressing, and the role of the CRC."
- "Contrast a Modbus holding register with an OPC-UA variable node and an MQTT topic. What is lost and gained in each translation?"
- "Why is standard Ethernet non-deterministic, and what does TSN change for a motion-control loop?"
- "Design a read-only Modbus-to-MQTT bridge for a power meter. How do I handle polling, timeouts, scaling, and units?"
- "A factory forbids changes to its PLC code. How can an external edge bridge still provide monitoring without touching the PLC?"

Record where the model is wrong, vague, or over-confident in `## Study log`.

## 🔁 Optional: the harvest — collect curiosities, swap lists

> **Optional and ungraded.** The full ritual is in [Module 1](./01-foundations-and-masterclass.md#harvest); run the short version here.

As you work, mark the odd bits: a register that was signed and read as a huge positive, a CRC error that looked like a dead device, a unit that was missing from the map, an OPC-UA node that had a timestamp and a Modbus register that did not. Put a `?` in the margin or a line under `## Story seeds`. At the break and at the end, swap lists with one person at another pod: briefly, no explaining, every entry gets a source. Anything two pods collected, or that nobody can place, goes to the course channel. The list is the artefact; the conversation is the point.

## ✅ Suggested portfolio evidence (proofs of the learning goals)

This is a **suggestion, not a checklist** — the learning goals are the contract. A convincing subset, or a better artefact you design yourself, is worth more than a ticked list.

1. **Bus map (goals 1 and 2):** the OSI placement of Modbus RTU/TCP, OPC-UA, EtherCAT, and TSN, plus the meter/motion choices and one sentence each.
2. **Real-time answer (goal 2):** why standard Wi-Fi/TCP cannot run a microsecond motion loop, and what TSN/EtherCAT change.
3. **Discussion answers (goal 3):** the three questions, one short paragraph each.
4. **Demo notes (goal 3):** the register you read and the topic you published, if the hardware was there; otherwise the register map and the topic you would publish.
5. **The running log and discussions:** your `## Study log` and `## Discussion log` — one line per discussion.
6. **Optional bridge (goal 4):** the simulated server, the wrapper, the MQTT stream, and what was lost in the translation.
7. **Optional real RS-485:** the wiring, adapter, register read, and the bridge, if you had the hardware.

> [!IMPORTANT]
> Never commit secrets, credentials, private keys, or plant data. Where you did not work entirely alone, link your pod mates and sources.

## 📚 If you want to go deeper

- [Modbus Organization](https://modbus.org/) and [Wikipedia: Modbus](https://en.wikipedia.org/wiki/Modbus) — the register model and framing.
- [OPC Foundation: OPC-UA](https://opcfoundation.org/about/opc-technologies/opc-ua/) — the information model and security.
- [Wikipedia: RS-485](https://en.wikipedia.org/wiki/RS-485) — the physical layer behind Modbus RTU.
- [Time-Sensitive Networking](https://en.wikipedia.org/wiki/Time-Sensitive_Networking) — why factory control needs bounded latency.
- [pymodbus](https://pymodbus.readthedocs.io/) and [asyncua](https://github.com/FreeOpcUa/opcua-asyncio) — the Python bridges.
- The [resource bank's OPC-UA and Modbus quick references](./Z-resources-bank.md#opc-ua-quick-nodes-optional).

---

[← Previous: Module 5](./05-wireless-technologies-and-espnow.md) | [Back to front page](../README.md) | [Quick module index](./00-index.md) | [Next: Module 7 — Fleet Management & IoTempower →](./07-fleet-management-and-iotempower.md)
