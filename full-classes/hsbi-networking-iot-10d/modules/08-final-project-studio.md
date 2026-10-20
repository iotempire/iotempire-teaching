# Module 8 – Final Project Studio: Strategy, Integration & Resilience

[← Back to Module 7](./07-fleet-management-and-iotempower.md) | [Quick module index](./00-index.md) | [Next: Module 9 →](./09-demonstrations-and-defense.md)

**Course placement:** Days 8–9 (Sessions 8–11) — the final project studio, after Checkpoint 2 (Modules 4–7). The exact split depends on the timetable and group progress; the schedule deliberately reserves buffer time here so slower labs elsewhere do not eat into the project.

## 🎯 Learning Goals

This module gives you the opportunity to explore systems integration and resilience engineering and achieve competency in turning a story into an architecture, integrating sensors/actuators/network layers, and fault-injection testing.

By the end of this module, you can:
1. Turn a stakeholder story into a concrete networked IoT system architecture with explicit roles and interfaces.
2. Synthesize all networking, messaging, and hardware layers into an integrated Final Project IoT Architecture.
3. Perform fault-injection testing and resilience validation: verify how the system behaves under network partition, packet loss, or node failure.
4. Conduct a structured peer review and rehearsal of your final project demonstration.
5. Refine your system documentation and live demonstration script for the final defense.


**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 📖 Story — The Operations Centre at 3 A.M.

**Stadtwerke Gütersloh** is about to run its first winter with the new monitoring system. **Petra Sommer** is on call. At 3 a.m. an intermediate router loses power, a sensor node reboots, and the MQTT broker restarts after an update. The control room must still show the last known state, flag what is stale, and recover without a technician driving across the city.

Your **Project Team** — two Task Pods merged into 4–6 people — is the engineering team behind that night. You pick a stakeholder story (Stadtwerke, Lumenwerk's remote exhibition, Klimapark's greenhouse, Frachtflow's warehouse, or one of your own), turn it into a multi-node architecture, and then do the thing that separates a demo from a system: break it on purpose and prove it recovers.

## 📖 Studio Briefing: From Story to Resilient System

Before you build, spend a short pod-study block on the project craft:

### Pointers (start here, then keep looking)

- Story-driven modeling — [Wikipedia: Story-driven modeling](https://en.wikipedia.org/wiki/Story-driven_modeling)
- Requirements and acceptance criteria — [Wikipedia: Requirement](https://en.wikipedia.org/wiki/Requirement), [Acceptance testing](https://en.wikipedia.org/wiki/Acceptance_testing)
- Fault injection and resilience — [Wikipedia: Fault injection](https://en.wikipedia.org/wiki/Fault_injection), [Chaos engineering](https://en.wikipedia.org/wiki/Chaos_engineering)
- Network architecture — [Wikipedia: Network architecture](https://en.wikipedia.org/wiki/Network_architecture)
- The [story canon](./Z-resources-bank.md#story-canon-the-recurring-cast) and the [final-project must-haves](../syllabus.md#final-project-requirements-5-points)

### Questions to ask an LLM (then verify against your kit)

- "Here is our stakeholder story: `<paste it>`. Turn it into a requirements list with measurable acceptance criteria and flag anything we cannot build with our routers and M5Stack nodes."
- "What is the smallest multi-node architecture that satisfies these requirements? Name every failure point."
- "List five fault-injection tests for this architecture and the graceful behavior we should expect from each."
- "How do we measure recovery time objectively, and what evidence should we capture?"
- "Review our must-have mapping and tell us what is missing or untestable."

> Treat every generated requirement as a hypothesis. Verify it against the kit, the syllabus must-haves, and a live test.

## 📖 How the Studio Sessions Work

The project is not a single lab exercise; it is a short engineering sprint. Expect roughly this arc:

```text
[Kickoff]            Story, team, requirements, first architecture sketch
    |
[Build & Integrate]  Assemble hardware, network, broker, integration layer
    |
[Harden]             Fault injection, resilience fixes, documentation
    |
[Rehearse]           Peer dry run against the must-haves
    |
[Defend]             Module 9: live demo + portfolio defense
```

Sessions are open-ended by design: Project Teams naturally progress at different speeds. If you finish an integration milestone early, use the time for hardening, measurements, or helping a neighboring Project Team (which counts toward bonus points). If a lab from an earlier module ran over, this is the buffer that absorbs it.

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

You do not have to use every layer. A strong project uses each layer it includes *deliberately* and can defend that choice. If you configured a B.A.T.M.A.N. mesh in Module 3, this is where it earns its place by carrying real traffic across a link you can physically break.

## 🛠️ Studio Labs — **Challenging**

*Project Teams of 4–6 students (two merged Task Pods) assemble their full hardware and networking setup. Work through the tasks as milestones, not as a rigid clock.*

### ★ Task 1: Project Kickoff — Story, Project Team & Requirements

1. Craft a story. Pick one scenario around a real stakeholder (a person with a name and a problem). If you have no idea yet, generate one with AI and refine it by hand — the story must be *yours*.
   - It must be playable and pitchable: something you can demo live in a few minutes.
2. Pitch to a neighboring Project Team: present the story, take notes on their questions.
3. Discuss feasibility: what can you build with the kit, what must be mocked, and what integration is needed?
4. Merge two Task Pods into a **Project Team of 4–6** and document individual roles and contributions in each personal portfolio.
5. Map requirements onto the final project must-haves (see the syllabus): which nodes, which network layers, which messaging, which integration, which resilience test will you demonstrate?

### ★ Task 2: Complete System Integration

Verify that your system meets the Final Project Must-Haves:
1. Multi-Node: At least 4 independent physical nodes active (e.g. 2 M5Stack nodes, 1 OpenWrt router, 1 laptop/edge server).
2. Multi-Network: At least two distinct communication/networking layers working together (e.g. ESP-NOW → Wi-Fi gateway; a Nebula/Yggdrasil overlay; or, optionally, an OpenWrt B.A.T.M.A.N. mesh).
3. Structured MQTT Topics: Clear, documented hierarchy with QoS, Retain for state topics, and LWT for node health.
4. Integration Engine: Node-RED flow and/or Python script orchestrating real-time logic.
5. Declarative Management: At least one node managed and updatable via IoTempower Over-The-Air (OTA).

### ★ Task 3: Fault Injection & Resilience Testing

Before presenting, intentionally break your system and document the recovery:

- Test A (Link Drop): Abruptly power down an intermediate router or overlay peer. Does traffic re-route? How many seconds until telemetry resumes?
- Test B (Node Power Loss): Unplug an M5Stack sensor node. Does the broker publish its Last Will and Testament (`offline`)? Does the dashboard alert update accordingly?
- Test C (Broker Restart): Restart Mosquitto (`/etc/init.d/mosquitto restart`). Do the M5Stack nodes and Python bridges automatically reconnect and resubscribe?

Document these failure scenarios and your mitigation strategies in your portfolio!

### ★ Task 4: Peer Review & Dry Run Rehearsal

Pair with another Project Team for a reciprocal dry run:

#### Presenting Project Team:
1. The System Story: Problem domain, users, and core value proposition.
2. Architecture Walkthrough: Point out physical nodes, network topologies, routing layers, and data flow.
3. Live Demo: Trigger a physical interaction on an M5Stack node, show data crossing the network, and show the dashboard/actuator response.

#### Reviewing Project Team (feedback):
- Clarity: Did they explain *why* specific protocols were chosen?
- Robustness: What happens if the network drops? Did they demonstrate resilience?
- Evidence: Are the network configs and packet flows documented in their GitHub repository?

## ✅ Suggested portfolio evidence (proofs of the learning goals)

Your portfolio only needs to **prove this module's learning goals**. The items below are **suggested proofs** — commit them if they fit, or demonstrate the same goals your own way. (Under `module-08/`.)
1. Kickoff Story: Your stakeholder story, target users, team roles, and the requirement-to-must-have mapping.
2. Final Project Architecture Diagram: Detailed schematic of your integrated system showing physical hardware, network interfaces, IP/overlay addressing, and protocol flows.
3. Fault-Injection Test Report: Document the results of your three resilience tests (Link Drop, Node Loss, Broker Restart) with log snippets or screenshots.
4. Peer Feedback Log: Summarize the feedback received from your review team and the concrete adjustments you are making for the final defense.

### Reflection logbook

Write one entry for this teaching block in `reflection.md`: *What worked? What broke? How did my mental model shift? How did I verify AI suggestions?*

> [!IMPORTANT]
> Never commit secrets, credentials, private keys, captures with personal traffic, or `.venv/`. Where you did not work entirely alone, link your pod mates and sources.

## 📚 If you want to go deeper

- [Wikipedia: Story-driven modeling](https://en.wikipedia.org/wiki/Story-driven_modeling) — the method behind the stories.
- [Wikipedia: Requirement](https://en.wikipedia.org/wiki/Requirement) and [Acceptance testing](https://en.wikipedia.org/wiki/Acceptance_testing) — turning a story into testable criteria.
- [Fault injection](https://en.wikipedia.org/wiki/Fault_injection) and [Chaos engineering](https://en.wikipedia.org/wiki/Chaos_engineering) — how to prove resilience.
- [Network architecture](https://en.wikipedia.org/wiki/Network_architecture) — layers, interfaces, and trade-offs.
- The [story canon](./Z-resources-bank.md#story-canon-the-recurring-cast) — keep your new story consistent with the course universe.

---

[← Previous: Module 7](./07-fleet-management-and-iotempower.md) | [Back to front page](../README.md) | [Quick module index](./00-index.md) | [Next: Module 9 — Final Project Demonstrations & Defense →](./09-demonstrations-and-defense.md)
