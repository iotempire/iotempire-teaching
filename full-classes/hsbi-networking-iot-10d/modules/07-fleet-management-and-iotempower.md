# Module 7 – Fleet Management & Scaling with IoTempower

[← Back to Module 6](./06-industrial-protocols-and-bridging.md) | [Quick module index](./00-index.md) | [Next: Module 8 →](./08-final-project-studio.md)

**Course placement:** Day 7 — the fleet studio. A prototype becomes a fleet you can update without a USB cable.

## 🎯 Learning Goals

This module gives you the opportunity to explore IoT fleet operations at scale and achieve competency in declarative node definition, Over-The-Air deployment, and topic standardization with IoTempower.

By the end of this module, you can:
1. Explain the operational challenge of IoT fleet management: provisioning, configuration drift, inventory, and over-the-air deployment.
2. Apply IoTempower's declarative node model — `system.conf`, `node.conf`, and `setup.cpp` — and explain what the framework generates around your declaration.
3. Configure and deploy at least two M5Stack/ESP32 nodes, first over USB and then over the air, without relying on a cloud service.
4. Orchestrate a small heterogeneous fleet with a stable MQTT topic namespace, a canary rollout, and a documented recovery path.

**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 🎬 Opening the Challenge

**The day starts with the fleet, not a slide.** Module 6 gave one device a voice; today you make the voice repeatable across a fleet. The opening runs in five quick beats:

1. **Pre-study check-in.** In your pod, show one artefact from Module 6 — the bus map, the wrapper diagram, or the register-to-topic note — and name one question you still have. Park the questions on the board.
2. **Confirm the pod and the roles.** Rotate: one drives the node definitions, one drives the deployment terminal, one keeps the fleet inventory and the evidence. Swap after each round.
3. **Collect the hardware.** One router from Module 2 with its USB stick and Mosquitto broker, two class-supported M5Stack/ESP32 nodes, USB cables for the first flash, and a laptop or the class host with the IoTempower environment. Label the nodes with your pod ID and a role — not just a number.
4. **Draw the fleet.** Sketch the IoTempower host, the router and broker, each node's name and role, the topic namespace, and the update path. Mark the cable as **first flash only**; mark the Wi-Fi path as the normal update path. You will correct the sketch all day.
5. **Skim the studio, do not start.** Read the challenge and the round table, then skim the theory boxes and the evidence list. Find **where the build happens**, **where the broker runs**, and **what proof an OTA update leaves**. Then start Round 1.

Before you touch a node, answer these three in one sentence each — they are the questions the day will answer:

- If the Wi-Fi password is compiled into thirty nodes, what exactly has to change when the password changes?
- Where does the build happen, and where does the broker run? Why keep those two jobs on different machines?
- After the laptop that deployed the fleet leaves the room, what still works — and what needs the host to come back?

### Your portfolio entry for today — sections, not files

Everything from today goes into **`Module07/README.md`** as sections. Split something into its own file only when a section outgrows the page.

- `## Fleet plan` — the topology sketch, node names and roles, board types, broker address, topic map, and the canary choice.
- `## Study log` — the running log: the theory you actually needed, the commands that surprised you, and the LLM answers you checked. This is not an essay and not a separate study phase.
- `## Discussion log` — one line per discussion: who listened, what they asked, what you changed. This is personal; the shared study log is still one per pod.
- `## Node definitions` — `system.conf` with secrets redacted, `node.conf`, and `setup.cpp`; one sentence on what IoTempower generated from each definition.
- `## OTA deployment log` — node name, change, command, timestamp, result, and the first telemetry or behaviour after the reboot.
- `## Fleet evidence` — the topic tree, one telemetry stream from each node, one command path, and the proof that both nodes have distinct identities.
- `## Drift and recovery` — what differed from the plan, how you found it, and how you recovered the node.
- `## Story seeds` — optional: the odd bits worth turning into a story later.

*One pod member keeps the shared `## Study log`; the others link to it from their own `Module07/README.md` and add one sentence on what they took from it. The `## Discussion log` is yours alone.*

### The fleet contract

A fleet is shared infrastructure, and a copied node is how fleets get mysterious. Agree before you start:

- **One source of truth.** The node folder is the definition: `node.conf` names the board, `setup.cpp` declares the devices. The `build/` directory and the flashed binary are outputs; never hand-edit them. Keep `system.conf` out of Git — it contains the Wi-Fi password.
- **The host builds, the router brokers.** IoTempower runs on a laptop or the class host; Mosquitto runs on the router. Never install the build toolchain or Node-RED on the router — 16 MB of flash is for routing and the broker, not a development environment.
- **A node has a name and a job.** Node names and topics are unique and stable. If you copy a node folder, rename it and flash it as a new identity; two nodes answering to the same name are one node with a race condition.

## 📖 The Challenge — Thirty Nodes and One Ladder

**Stadtwerke Gütersloh** has a successful pilot: one M5Stack node in one substation, publishing temperature and pressure to a local broker. Network operations lead **Petra Sommer** now wants thirty nodes across the city. The pilot firmware has the Wi-Fi password, the broker IP, and the topic string hard-coded; every change means a ladder, a USB cable, and a technician in a basement.

Field engineer **Malik Yilmaz** has already found the first crack: the inventory has thirty rows, but only twenty-eight node names answer on the broker. Two nodes were cloned from the same image and publish under the same name; one of them still reports the old threshold. Petra's question is operational: *"How do I change a threshold on thirty devices without visiting thirty basements — and how do I know which one did not get it?"*

**Your challenge.** Turn a one-off build into a small fleet you can define, deploy, and recover. You are done when you can show all five:

1. A fleet inventory with at least two nodes: name, board, role, source definition, topics, and last-seen evidence.
2. One declarative node definition — `system.conf`, `node.conf`, `setup.cpp` — that builds and flashes over USB, with an explanation of what IoTempower generated.
3. An OTA update to one node without the USB cable: the change, the deploy log, the reboot, and the first telemetry or behaviour afterwards.
4. A stable topic namespace for both nodes: telemetry and commands, one command that changes an output, and no duplicate identities.
5. A canary rollout and a drift report: one node first, then the second, including what happened when one node missed the update — or a controlled failure that proves you can detect it.

**Constraints.** One router per pod with the Module 2 broker. Two class-supported nodes if the kit has them; if a node is dead, use the instructor's spare and document the substitution. The IoTempower host is a laptop or the class host — never the router. First flash over USB; OTA over the pod LAN. No cloud dependency. Node-RED is optional and never runs on the router. No Wi-Fi passwords, keys, or private config in Git or screenshots.

**This story is unfinished on purpose.** The hooks below are starting points, not a script. Pick the ones that match what you actually saw, and add a line of your own — *"and the second node never came back because we copied its neighbour's name"* is worth more than a perfect diagram. Collect those lines under `## Story seeds` and use them in a discussion or the harvest.

## 🧭 How this studio works now

**The study is folded into the practice.** There is no separate pod-study phase and no scheduled hand-off to another pod. Each round gives you a small thing to do, a compact **Theory you need** box you read only when the task makes you want it, and a **discussion** at the end. Keep your notes in `Module07/README.md` under `## Study log` — a running log, not an essay.

**First: skim, do not start.** Read the challenge and the round table, then skim the six rounds, the theory boxes, and the evidence list. You are looking for two things: **where the build happens** and **what proof an OTA update leaves**. Then start Round 1 and work at your pod's pace.

**Every round ends with a discussion — one person is enough.** You do not need the whole pod to stop. Ask someone at the nearest pod if they have a moment; show them the round's artefact and ask the discussion question. If they want, let them show you theirs and ask you one question back. **This is a brag, not a quiz**: you are showing what works and inviting one question, not asking for permission. Write one line in `## Discussion log`: who listened, what they asked, what you changed. If nobody is free, ask someone else or come back later — do not wait.

**Take a study break when a box is not enough.** A short break with the linked source, then explain it to one person. Explaining is the test, not reading. You do not need permission; take the break when the task makes you want it. If two of you want the same theory, take it together and bring back one sentence each.

The table is the discussion map: the **[Goal](#-learning-goals) · theory box** column names what each discussion checks. The question tests understanding, not task completion.

| # | Round | You produce | [Goal](#-learning-goals) · theory box | Discussion question for one person |
|---|---|---|---|---|
| 1 | **Inventory the fleet** | A baseline table and a canary choice | G1 · Inventory the fleet | "Which node would you update first, and what would make you stop?" |
| 2 | **Declare the node** | `system.conf`, `node.conf`, `setup.cpp`; a node flashed over USB | G2 · Declare the node | "What did you declare, and what did IoTempower generate?" |
| 3 | **Deploy over the air** | An OTA log and post-update telemetry | G3 · Deploy over the air | "What made OTA possible, and what would break it?" |
| 4 | **Standardize the namespace** | A topic map and a working command path | G4 · Standardize the namespace | "Show me one topic and tell me who owns it." |
| 5 | **Scale with a canary** | Two nodes updated in order, with a drift report | G4 · Scale with a canary | "What did you change, and how did you know it reached both?" |
| 6 | **Recover a node** | A recovered node and a symptom-to-recovery log | G4 · Recover a node | "What did you lose, and what did you keep?" |
| ◇ | **Stretch** | Canary rollback, fleet lint, or cross-node automation | G4 · stretch | "What does this prove that a single update did not?" |

**The order is a suggestion.** The rounds are a path, not a timetable. If the IoTempower host is not ready, start with the inventory and the topic map and come back to the flash; if a board string is wrong, stop and ask instead of guessing. **The instructor demos the risky steps live on the beamer** — the first serial flash, one OTA deploy, and one recovery — so ask for the demo you need instead of waiting with a broken step. Rotate roles after each round; everybody should declare, deploy, or verify at least one piece. The question you should always be able to answer is *"what did you choose, and what did it cost you?"*

## 🛠️ The Studio: From One-Off Sketch to a Fleet — **Challenging**

*Hardware per pod:* 1× OpenWrt router from Module 2 with its USB stick and Mosquitto broker, 2× class-supported M5Stack/ESP32 nodes, USB cables for the first flash, and 1× IoTempower host (a Linux/WSL laptop or the class host). Node-RED is optional and, if used, runs on the host or laptop — not on the router.

| What | Notes |
|---|---|
| Router | Cudy TR1200 from Module 2; LAN `192.168.14.0/24`; Mosquitto on `192.168.14.1:1883` |
| IoTempower host | Linux or WSL2 laptop, or the class host; the build and deploy CLI run here |
| Nodes | 2× M5StickC / Plus2 or another board the instructor confirms; label each with pod and role |
| First flash | USB cable from host to node; this is the only cable the normal update path needs |
| OTA path | Node and host on the same pod LAN, reachable by name or address |
| Node-RED | Optional integration on the host/laptop; **not** on the router, and not required for the lab |

> [!TIP]
> **If your laptop cannot run IoTempower** — no WSL, no admin rights, or no USB passthrough for the first flash — use the class host. If the class host is not ready, pair with another pod's host and keep your own system folder and node names. The router is not a fallback build host; it is the broker.

| Address / name | Value |
|---|---|
| System folder | `~/iot-systems/pod<NN>` |
| Node names | `pod<NN>-node1`, `pod<NN>-node2` (role suffix is clearer: `-sensor`, `-alarm`) |
| Broker | `192.168.14.1:1883`, or `_gateway` in `system.conf` |
| Topics | `<node>/<device>` for telemetry, `<node>/<device>/set` for commands |

### ★ Round 1: Inventory the fleet

1. **Label first.** Give each node a physical label with its pod ID and role. Write the same name into `## Fleet plan`; the label and the MQTT topic must agree.
2. **Build the baseline table.** For each node record: node name, board, role, what it publishes, what it accepts as a command, the source folder you will use, and how you know it is alive. If a node is pre-provisioned, record that instead of pretending you flashed it.
3. **Listen before you change anything.** Subscribe to the broker and capture one message from each node:
   ```bash
   mosquitto_sub -h 192.168.14.1 -t '#' -v
   ```
   If nothing arrives, check the node's Wi-Fi association and the broker before you touch the definition.
4. **Pick the canary.** Choose one node to update first. Prefer the node that is easiest to reach and least critical to the demo, but still representative of the change. Write one sentence: *why this node first?*
5. **Name the drift you already have.** Which node is on an older definition? Which topic name does not match the plan? Which node has no last-seen evidence? That list is the start of `## Drift and recovery`.

**Theory you need.** Fleet management is the discipline of keeping a **desired state** and an **observed state** for many devices, and noticing the difference. The vocabulary:

- **Provisioning** — the first flash, the identity, and the network credentials that let a node join.
- **Configuration** — what the node should do: board, devices, pins, reporting, topic names.
- **Observed state** — what the broker and the node actually show: last message, behaviour, version, reachability.
- **Drift** — the difference between desired and observed. A node that missed an update is drifting even if it is still publishing.
- **Inventory** — the list that lets you answer *which node, where, doing what, running which definition?* without walking the building.
- **Canary** — the one node you update first, so a bad change costs one node instead of the fleet.

A fleet is not a pile of prototypes. The source of truth is the node definition, and the deployment log is how you prove what reached which device. *Go deeper: the IoTempower architecture and deployment docs.*

> **Discussion — show one person.** Ask someone at the nearest pod if they have a moment. Show them the baseline table and ask: *"Which node would you update first, and what would make you stop?"* If they want, let them show you theirs and ask you one question back. This is a brag, not a quiz. Write one line in `## Discussion log`.

> **Story hook.** *The basement inventory.* Petra's spreadsheet has thirty rows; the broker has twenty-eight names. The gap is not a paperwork problem — it is two nodes that will never receive the next threshold.

*Portfolio evidence:* the `## Fleet plan` table, one captured message per node, and the canary choice with one sentence of justification.

### ★ Round 2: Declare the node

The first node is built and flashed over USB. You are not writing a Wi-Fi reconnect loop, an MQTT client, or a JSON formatter; you are declaring what is attached and letting IoTempower generate the runtime.

1. **Create the system folder.** In the IoTempower environment:
   ```bash
   cd ~/iot-systems
   create_system_template pod<NN>
   cd pod<NN>
   ```
2. **Edit `system.conf`.** Set the pod Wi-Fi and the broker. `_gateway` means "the router that gave this host its default route", which is your Cudy:
   ```text
   IOTEMPOWER_AP_NAME="pod<NN>"
   IOTEMPOWER_AP_PASSWORD="<pod-wifi-password>"
   IOTEMPOWER_MQTT_HOST="_gateway"
   ```
   Keep this file out of Git and redact the password in the portfolio.
3. **Create the node folder and set the board.**
   ```bash
   create_node_template pod<NN>-node1
   cd pod<NN>-node1
   ```
   In `node.conf`, set the board string the instructor confirms for your hardware — for the class M5StickC Plus2 image that is typically:
   ```text
   board="m5stickc plus2"
   ```
   Do not guess a board string. The wrong board means the wrong pins and a flash that looks successful but does nothing.
4. **Declare the devices in `setup.cpp`.** Use the class-supported names, not guessed pin numbers:
   ```cpp
   out(led, ONBOARDLED).inverted().off();
   button(home, BUTTON_HOME, "pressed", "released").inverted().debounce(10);
   m5stickc_display(console, 2, 270);
   // Only with the Grove protoboard and the DS18B20 fitted:
   // ds18b20(temp, 32);
   ```
   The exact device is less important than the declaration: a name, a device type, and the parameters that belong to it.
5. **Flash over USB.**
   ```bash
   deploy serial
   ```
   Watch the compile, upload, reboot, Wi-Fi association, and the first MQTT message. If the upload cannot find the port, fix the cable or the serial permission before changing the definition.
6. **Read what was generated.** Open `build/src/devices_generated.h` and `build/platformio-libs.ini`; find the drivers and libraries that came from your three lines. Notice that `build/` is an output, not a second source of truth.

**Theory you need.** An IoTempower **system folder** holds `system.conf` and one folder per node. The node folder holds `node.conf` (the board) and `setup.cpp` (the devices). The framework:

1. parses `setup.cpp` to find the device commands;
2. resolves the drivers and libraries it needs;
3. generates `build/src/devices_generated.h` and `build/platformio-libs.ini`;
4. compiles the firmware with PlatformIO;
5. uploads it — over USB for the first flash, over Wi-Fi for later updates.

Declarative does not mean "no code". It means the code you write describes **what is attached**, not the boilerplate that keeps Wi-Fi and MQTT alive. The generated runtime supplies the reconnects, the publishing, and the `<node>/<device>` topic convention. `system.conf` is where the credentials live, which is why it stays out of Git. *Go deeper: the IoTempower quickstart and first-node docs.*

> **Discussion — show one person.** Ask someone at the nearest pod if they have a moment. Show them the node folder and the generated header, and ask: *"What did you declare, and what did IoTempower generate?"* If they want, let them show you theirs and ask you one question back. Write one line in `## Discussion log`.

> **Story hook.** *The ladder becomes a compiler.* Malik no longer edits a Wi-Fi reconnect loop in a basement; he edits three lines on a laptop and lets the generated runtime do the job it was written for.

*Portfolio evidence:* the redacted `system.conf`, `node.conf`, `setup.cpp`, the serial flash result, and one sentence on what was generated rather than hand-written.

### ★ Round 3: Deploy over the air

1. **Remove the cable.** Power the node from a battery or a USB charger, not from the laptop. Confirm it is on the pod Wi-Fi and still publishing before you change anything.
2. **Make one observable change.** Add a second button, add the temperature device if the sensor is fitted, or change the debounce interval. Choose something you can see in MQTT:
   ```cpp
   button(right, BUTTON_RIGHT, "pressed", "released").inverted().debounce(10);
   ```
3. **Deploy without the cable.** From the node folder:
   ```bash
   deploy
   ```
   From the system folder, target one node by name:
   ```bash
   deploy pod<NN>-node1
   ```
   Watch the compile, the upload, the reboot, and the reconnection. The node must publish its new behaviour after it comes back.
4. **Record the proof.** In `## OTA deployment log`, write the node name, the exact change, the command, the time, the result, and the first new message or action. A deploy command that returns is not proof; the post-reboot behaviour is.
5. **If it fails, stop and read the failure.** Check that the host and node are on the same LAN, the node is powered, the node name is unique, and the board string still matches. Do not retry blindly; Round 6 is the recovery path.

**Theory you need.** OTA means the node already runs a firmware with an update service. The IoTempower host resolves the node on the network, compiles the new firmware, uploads it over Wi-Fi, and the node reboots into the new image. That requires:

- **reachability** — host and node on the same LAN, or a routed path that allows the upload;
- **a running OTA-capable firmware** — the first flash creates this;
- **stable power** — a brownout during upload is how a node ends up half-updated;
- **a matching board and identity** — the binary must fit the board, and the name must identify the right node.

OTA is not remote magic and it is not a backup. It removes the cable from the normal path; it does not remove the need for a physical recovery path when the network or the image is wrong. *Go deeper: the IoTempower deployment process and the OTA update concept.*

> **Discussion — show one person.** Ask someone at the nearest pod if they have a moment. Show them the OTA log and the post-update message, and ask: *"What made OTA possible, and what would break it?"* If they want, let them show you theirs and ask you one question back. Write one line in `## Discussion log`.

> **Story hook.** *The node that kept its old name.* The update found the node because it announced an identity. Copy the folder, keep the name, and two basements now answer as one.

> [!IMPORTANT]
> Do not use a production device for the first OTA test. Use the pod's lab node, keep the USB cable available, and never deploy a node whose physical label you cannot match to a name in the inventory.

*Portfolio evidence:* the OTA command and result, the post-reboot telemetry or action, and one sentence on the conditions that made the update possible.

### ★ Round 4: Standardize the namespace

1. **Write the topic map before adding the second node.** For each node, list the telemetry topics and the command topics. Use the generated convention — telemetry `<node>/<device>`, commands `<node>/<device>/set` — and give the device a name a stranger can understand:
   ```text
   pod07-sensor/home          pressed | released
   pod07-sensor/temp          23.4
   pod07-alarm/led            on | off
   pod07-alarm/led/set        on | off
   ```
2. **Subscribe with a wildcard.** From the host:
   ```bash
   mosquitto_sub -h 192.168.14.1 -t 'pod<NN>-*/#' -v
   ```
   Press the button and confirm which node and device produced the message. A wildcard is only useful if the names are consistent.
3. **Send one command.** Change an output from outside the node:
   ```bash
   mosquitto_pub -h 192.168.14.1 -t 'pod<NN>-alarm/led/set' -m on
   ```
   Verify the physical or visible result, not just the broker echo.
4. **Add the second node.** Give it a different role: a sensor node and an alarm node, or a button node and a display node. Copy the definition pattern, but rename the folder, the node name, and every topic prefix. Never copy a node and leave the identity unchanged.
5. **Link the roles if you can.** Reuse the integration pattern from Module 4 — Node-RED on the host/laptop, or a short Python service — so the sensor node's event changes the alarm node's output. If Node-RED is not installed, `mosquitto_sub` and `mosquitto_pub` are enough to prove the path.

**Theory you need.** The topic namespace is the fleet's public API. The first segment is the **node identity**; the next is the **device**; `/set` marks the command direction. A control room can subscribe to `+/temp` only if every node agrees on `temp`; a wildcard cannot repair an inconsistent name. Renaming a node or a device is an API change, not a cosmetic edit. Duplicate node names are worse than ugly names: two devices publish into one namespace and commands reach whichever one happens to be connected. Choose names for the operator who reads them at 3 a.m., not for the folder you happened to create. *Go deeper: the MQTT essentials topic chapter and the IoTempower topic convention.*

> **Discussion — show one person.** Ask someone at the nearest pod if they have a moment. Show them one topic and the command that changes an output, and ask: *"Show me one topic and tell me who owns it."* If they want, let them show you theirs and ask you one question back. Write one line in `## Discussion log`.

> **Story hook.** *One topic, thirty basements.* The control room does not care which basement a reading came from until the topic tells it. A node that invents `temperature` instead of `temp` disappears from the wall.

*Portfolio evidence:* the topic map for both nodes, a wildcard subscription, one command with its visible result, and one sentence on why the node name is part of the API.

### ★ Round 5: Scale with a canary

1. **Choose one change to roll out.** A threshold, a report interval, a second device, or a renamed device. Write the desired state in one line.
2. **Deploy to the canary only.** From the system folder:
   ```bash
   deploy pod<NN>-node1
   ```
   Verify the behaviour and the deployment log before touching the second node. If the canary fails, stop the rollout; that is the point of a canary.
3. **Deploy to the rest.** Run the same command for the second node, or deploy the system and watch each result. Do not assume the second deployment succeeded because the first one did.
4. **Create a controlled miss.** Power down one node before a deployment, or use a node that is already offline, and run the rollout. Record what the command reports, what the broker shows, and what the inventory says. Power the node back up and deploy again.
5. **Write the drift report.** For each node: desired change, observed behaviour, last deploy result, and whether it is in sync. The report is the answer to Petra's question, not the deploy command.

**Theory you need.** A fleet rollout is a sequence of decisions, not one command. **Canary** limits the blast radius: one node proves the change before the fleet sees it. **Rolling** updates a few at a time and keeps the service available. **All-at-once** is fast and has no safety net. The deployment command returning success only means the upload was attempted; **observed behaviour** is the proof. A node that is offline during the rollout is not updated, even if the command printed a success for the others. That gap is configuration drift, and the inventory plus the broker is how you find it. *Go deeper: the deployment process and the fleet-management patterns in the IoTempower docs.*

> **Discussion — show one person.** Ask someone at the nearest pod if they have a moment. Show them the two deployment results and the drift report, and ask: *"What did you change, and how did you know it reached both?"* If they want, let them show you theirs and ask you one question back. Write one line in `## Discussion log`.

> **Story hook.** *The threshold that reached twenty-nine.* The rollout says success, the dashboard shows the new value almost everywhere, and one basement is still reporting the old one. Petra does not want an average; she wants the exception.

*Portfolio evidence:* the canary result, the second-node result, the controlled miss, and a drift table that distinguishes "commanded" from "observed".

### ★ Round 6: Recover a node

1. **Choose one safe failure.** Examples: a node that misses the rollout because it is offline; a node whose name was copied from its neighbour; a wrong board string that builds but does not behave; a node whose Wi-Fi configuration is wrong after a change. Do not factory-reset a node that still works, and do not attempt a bootloader recovery without the instructor.
2. **Record the symptom before fixing it.** What does the broker show? What does the physical node show? What does the deployment log say? Which of the three — definition, network, power — is the likely layer?
3. **Recover with the smallest tool.**
   - Offline node: power it, confirm Wi-Fi and MQTT, deploy again.
   - Duplicate identity: rename the folder and the node, flash the renamed node, confirm the old topic disappears and the new one appears.
   - Bad image or unreachable node: connect USB and `deploy serial`; if the board is wrong, fix `node.conf` first.
   - Wrong credentials: restore the last known-good `system.conf`, then deploy; if the node cannot join at all, USB is the out-of-band path.
4. **Prove recovery.** The node must publish again under the expected name and answer a command. Update the inventory and the drift report; a recovered node with the wrong name is still drifting.
5. **Write the rule you will use next time.** One sentence: *"If the node is reachable but the behaviour is wrong, I check X before Y."*

**Theory you need.** Most OTA failures are not firmware bugs; they are reachability, power, or identity. The node may be on the wrong Wi-Fi, the host may be on a different subnet, the name may resolve to a neighbour, or the board string may describe a different pin map. The recovery ladder goes from **cheapest and least destructive** to **most invasive**:

1. check power, link, and broker;
2. check the node name and the topic it actually publishes;
3. re-deploy the last known-good definition;
4. connect USB and flash over serial;
5. only then consider a factory reset or bootloader recovery — with the instructor.

OTA is the normal path, not the only path. A fleet you cannot recover physically is a fleet you cannot update safely. *Go deeper: the IoTempower troubleshooting notes and the board's recovery documentation.*

> **Discussion — show one person.** Ask someone at the nearest pod if they have a moment. Show them the recovery log and the node publishing again, and ask: *"What did you lose, and what did you keep?"* If they want, let them show you theirs and ask you one question back. Write one line in `## Discussion log`.

> **Story hook.** *The node that came back.* Malik keeps one USB cable in the van. It is not a failure of the fleet; it is the rollback plan that makes the fleet safe to update.

*Portfolio evidence:* the symptom, the layer you suspected, the recovery command, the post-recovery telemetry, and the one-sentence rule.

### ◇ Stretch 1: Canary and rollback

Deploy a deliberately visible change to the canary, verify it, then revert the definition and deploy again. Capture both deployment logs and the behaviour before, during, and after. What did the rollback cost in time, attention, and risk? This is the drill that makes an all-at-once rollout look reckless.

> **Story hook.** *The undo button is a definition, not a backup.* Malik does not restore a binary from a basement shelf; he redeploys the last good declaration.

*Portfolio evidence:* the before/after logs and a short rollback runbook.

### ◇ Stretch 2: Fleet lint

Write a small checklist or script that reads your node folders and fails on: duplicate node names, duplicate topic prefixes, a missing board string, a missing device declaration, or a `system.conf` that is tracked by Git. Run it against your fleet and against a deliberately broken copy.

> **Story hook.** *The inventory that checks itself.* Petra does not want a spreadsheet that is true on Monday; she wants a check that fails when the fleet stops matching it.

*Portfolio evidence:* the check, one passing run, one failing run, and the fix.

### ◇ Stretch 3: Cross-node automation

Connect the roles: a button on the sensor node changes the alarm node's LED or display through Node-RED on the host/laptop, or through a short Python service. Keep the topic contract from Round 4; do not hard-code the other node's IP in the firmware. Then break the link — stop the integration service — and explain what still works in the fleet and what does not.

> **Story hook.** *The control room is a subscriber.* The nodes do not need to know each other; they need to agree on the topic and let the integration layer connect them.

*Portfolio evidence:* the flow or script, the cross-node action, and the failure observation.

> **Stretch discussion — show one person.** Ask someone who has not done the stretcher: *"What does this prove that the basic fleet did not?"* A short moment. If they are curious, show them the rollback or the lint failure.

## 🤖 Ask an LLM — then verify

Use these when a theory box is not enough. Treat every answer as a **claim to test**, not a fact, and run each prompt against your own node, host, and broker.

- "Compare an IoTempower `setup.cpp` with a raw Arduino MQTT sketch. Which boilerplate is generated, and which decisions remain with the developer?"
- "How does an ESP32 OTA upload work, and what conditions must hold for the node to accept the new image and come back?"
- "Design an MQTT topic namespace for a 30-node municipal fleet with telemetry and commands. What breaks when two nodes share a name?"
- "What is configuration drift in an IoT fleet, and how would I detect it from the broker and a deployment log?"
- "A node missed a rollout but is still publishing. What are the possible layers of failure, and in what order would you check them?"
- "Why should the build toolchain and Node-RED not run on the 16 MB edge router, even though the broker does?"

Record where the model is wrong, vague, or over-confident in `## Study log`.

## 🔁 Optional: the harvest — collect curiosities, swap lists

> **Optional and ungraded.** The full ritual is in [Module 1](./01-foundations-and-masterclass.md#harvest); run the compact version here.

As you work, mark the odd bits: a node that kept an old topic after a rename, an OTA that timed out because the node was on the wrong Wi-Fi, a board string that built but did not behave, two nodes with the same name, a sensor that published before the broker was reachable. Put a `?` in the margin or a line under `## Story seeds`. At the break and at the end, swap lists with one person at another pod (or whoever is nearby): briefly, no explaining, every entry gets a source. Anything two pods collected, or that nobody can place, goes to the course channel. The list is the artefact; the conversation is the point.

## ✅ Suggested portfolio evidence (proofs of the learning goals)

This is a **suggestion, not a checklist** — the learning goals are the contract. A convincing subset, or a better artefact you design yourself, is worth more than a ticked list.

1. **Fleet operations (goal 1):** the `## Fleet plan` inventory, the desired/observed drift table, and the canary choice with its justification.
2. **Declarative model (goal 2):** the redacted `system.conf`, `node.conf`, and `setup.cpp`, plus one paragraph on what IoTempower generated and why the `build/` output is not the source.
3. **Node deployment (goal 3):** the first serial-flash result, the OTA deployment log, and the post-reboot telemetry or behaviour that proves the update landed.
4. **Fleet orchestration (goal 4):** the topic map for two roles, a wildcard subscription, a command path that changes an output, a canary rollout, and a recovered node with a distinct identity.
5. **The running log and discussions:** your `## Study log` with the theory you actually needed and the LLM answers you checked, plus `## Discussion log` — one line per discussion: who listened, what they asked, what you changed.
6. **Optional:** the rollback drill, the fleet-lint check, or the cross-node automation, with the failure it exposed.

> [!IMPORTANT]
> Never commit Wi-Fi passwords, broker credentials, private keys, device certificates, or an unredacted `system.conf`. A node definition is safe to publish; the credentials inside the system configuration are not. If you copied a neighbour's node, say so and show how you changed the identity.

## 📚 If you want to go deeper

- [IoTempower](https://github.com/iotempire/iotempower) — the declarative node model and deployment workflow.
- [IoTempower quickstart](https://github.com/iotempire/iotempower/blob/master/doc/quickstart.rst) — the shortest path from install to the first node.
- [IoTempower deployment process](https://github.com/iotempire/iotempower/blob/master/doc/deployment-process.rst) — code generation, PlatformIO, serial and OTA upload.
- [IoTempower website](https://iotempower.us/) — examples and teaching material.
- [Over-the-air update](https://en.wikipedia.org/wiki/Over-the-air_update) — the general concept and its risks.
- [HiveMQ: MQTT essentials](https://www.hivemq.com/mqtt-essentials/) — the topic namespace your fleet publishes into.
- [PlatformIO](https://docs.platformio.org/) — the build system under the generated project.

---

[← Previous: Module 6](./06-industrial-protocols-and-bridging.md) | [Back to front page](../README.md) | [Quick module index](./00-index.md) | [Next: Module 8 — Final Project Studio →](./08-final-project-studio.md)
