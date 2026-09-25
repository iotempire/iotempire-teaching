# Module 8 – Final Project Studio: Strategy, Integration & Resilience

[← Back to Module 7](./07-fleet-management-and-iotempower.md) | [Quick module index](./00-index.md) | [Next: Module 9 →](./09-demonstrations-and-defense.md)

> **Course placement:** This module spans the final project arc — several sessions dedicated to project ideation, architecture planning, integration, resilience testing, and presentation readiness. The exact split depends on the timetable and group progress; the schedule deliberately reserves buffer time here so that slower labs elsewhere do not eat into the project.

---

## 🎯 Learning Goals

> **How these are assessed:** You earn this module's points by **proving these goals** in a short (~10-minute) checkpoint presentation with the instructor (see the [syllabus](../syllabus.md#how-module-points-are-earned-checkpoint-presentations)) — based on your portfolio and reflections, not on completing every task. You may skip tasks, fail at some, or add your own; documented exploration and demonstrated deep understanding both count in your favor.

This module gives you the opportunity to explore **systems integration and resilience engineering** and achieve competency in **turning a story into an architecture, integrating sensors/actuators/network layers, and fault-injection testing**.

By the end of this module, you can:
1. Turn a **stakeholder story** into a concrete networked IoT system architecture with explicit roles and interfaces.
2. Synthesize all networking, messaging, and hardware layers into an integrated **Final Project IoT Architecture**.
3. Perform **fault-injection testing and resilience validation**: verify how the system behaves under network partition, packet loss, or node failure.
4. Conduct a structured **peer review and rehearsal** of your final project demonstration.
5. Refine your system documentation and live demonstration script for the final defense.

> [!WARNING]
> **DRAFT — first taught in WS 2026/27.** Everything below this line is a working draft and will likely change as we refine it together in class; the line moves down as we approve content. Your input is welcome and can shape this module.

**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

---

## 📖 How the Studio Sessions Work

The project is not a single lab exercise; it is a short engineering sprint. Expect roughly this arc:

```text
[Kickoff]            Story, team, requirements, first architecture sketch
    |
[Build & Integrate]  Assemble hardware, network, broker, integration layer
    |
[Harden]             Fault injection, resilience fixes, documentation
    |
[Rehearse]           Peer dry run against the rubric
    |
[Defend]             Module 9: live demo + portfolio defense
```

Sessions are **open-ended by design**: teams naturally progress at different speeds. If you finish an integration milestone early, use the time for hardening, measurements, or helping a neighboring team (which counts toward bonus points). If a lab from an earlier module ran over, this is the buffer that absorbs it.

---

## 📖 Architecting for Resiliency in the Continuum

A toy IoT project works only when every component is connected under ideal conditions. An engineered IoT system anticipates failure:
- What happens when an intermediate OpenWrt router loses power? Does a mesh or overlay re-route packets?
- What happens when Wi-Fi disconnects? Do M5Stack nodes buffer data, or does ESP-NOW continue functioning locally?
- What happens when the MQTT broker restarts? Do subscribers receive the latest system state via retained messages upon reconnection?
- What happens when an unexpected payload arrives at the Node-RED or Python integration bridge?

```text
======================= FINAL PROJECT ARCHITECTURE STACK =======================

[Edge Layer]         M5Stack Nodes (ESP-NOW micro-mesh / Wi-Fi)
                           |
[Router Mesh Layer]  OpenWrt Routers (optional: B.A.T.M.A.N. adv Layer-2 mesh)
                           |
[Overlay Layer]      Nebula / Yggdrasil (Encrypted remote WAN access)
                           |
[Broker Layer]       Mosquitto MQTT Broker (Retained states, LWT, QoS 1)
                           |
[Integration Layer]  Node-RED Dashboards + Python / IoTknit Event Bridge
                           |
[Industrial / Cloud] External Services (or optional OPC-UA / Modbus bridge)
===========================================================================
```

You do **not** have to use every layer. A strong project uses each layer it includes *deliberately* and can defend that choice. If you configured a B.A.T.M.A.N. mesh in Module 3, this is where it earns its place by carrying real traffic across a link you can physically break.

---

## 🛠️ Studio Labs

*Teams of 2–4 students assemble their full hardware and networking setup. Work through the tasks as milestones, not as a rigid clock.*

---

### Task 1: Project Kickoff — Story, Team & Requirements (45 min)

1. **Craft a story.** Pick one scenario around a real stakeholder (a person with a name and a problem). If you have no idea yet, generate one with AI and refine it by hand — the story must be *yours*.
   - It must be **playable and pitchable**: something you can demo live in a few minutes.
2. **Pitch to a neighboring team (2×5 min):** present the story, take notes on their questions.
3. **Discuss feasibility (10 min):** what can you build with the kit, what must be mocked, and what integration is needed?
4. **Form your team of 2–4** and document individual roles and contributions in each personal portfolio.
5. **Map requirements** onto the final project must-haves (see the syllabus): which nodes, which network layers, which messaging, which integration, which resilience test will you demonstrate?

---

### Task 2: Complete System Integration (45 min)

Verify that your system meets the Final Project Must-Haves:
1. **Multi-Node:** At least 4 independent physical nodes active (e.g. 2 M5Stack nodes, 1 OpenWrt router, 1 laptop/edge server).
2. **Multi-Network:** At least two distinct communication/networking layers working together (e.g. ESP-NOW → Wi-Fi gateway; a Nebula/Yggdrasil overlay; or, optionally, an OpenWrt B.A.T.M.A.N. mesh).
3. **Structured MQTT Topics:** Clear, documented hierarchy with QoS, Retain for state topics, and LWT for node health.
4. **Integration Engine:** Node-RED flow and/or Python script orchestrating real-time logic.
5. **Declarative Management:** At least one node managed and updatable via IoTempower Over-The-Air (OTA).

---

### Task 3: Fault Injection & Resilience Testing (30 min)

Before presenting, intentionally break your system and document the recovery:

- **Test A (Link Drop):** Abruptly power down an intermediate router or overlay peer. Does traffic re-route? How many seconds until telemetry resumes?
- **Test B (Node Power Loss):** Unplug an M5Stack sensor node. Does the broker publish its Last Will and Testament (`offline`)? Does the dashboard alert update accordingly?
- **Test C (Broker Restart):** Restart Mosquitto (`/etc/init.d/mosquitto restart`). Do the M5Stack nodes and Python bridges automatically reconnect and resubscribe?

Document these failure scenarios and your mitigation strategies in your portfolio!

---

### Task 4: Peer Review & Dry Run Rehearsal (40 min)

Pair with another team for a 15-minute reciprocal dry run:

#### Presenting Team (5 min):
1. **The System Story (1 min):** Problem domain, users, and core value proposition.
2. **Architecture Walkthrough (2 min):** Point out physical nodes, network topologies, routing layers, and data flow.
3. **Live Demo (2 min):** Trigger a physical interaction on an M5Stack node, show data crossing the network, and show the dashboard/actuator response.

#### Reviewing Team (5 min Feedback using Rubric):
- **Clarity:** Did they explain *why* specific protocols were chosen?
- **Robustness:** What happens if the network drops? Did they demonstrate resilience?
- **Evidence:** Are the network configs and packet flows documented in their GitHub repository?

---

## 📝 Working-Day Reflection & Portfolio Tasks

In your portfolio under `modules/08-final-project-studio/`:
1. **Kickoff Story:** Your stakeholder story, target users, team roles, and the requirement-to-must-have mapping.
2. **Final Project Architecture Diagram:** Detailed schematic of your integrated system showing physical hardware, network interfaces, IP/overlay addressing, and protocol flows.
3. **Fault-Injection Test Report:** Document the results of your three resilience tests (Link Drop, Node Loss, Broker Restart) with log snippets or screenshots.
4. **Peer Feedback Log:** Summarize the feedback received from your review team and the concrete adjustments you are making for the final defense.
