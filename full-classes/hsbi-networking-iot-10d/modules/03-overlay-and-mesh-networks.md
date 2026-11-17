# Module 3 – Overlay Networks: Nebula & Remote MQTT

[← Back to Module 2](./02-local-networking-and-gateways.md) | [Quick module index](./00-index.md) | [Next: Module 4 →](./04-mqtt-and-integration.md)

**Course placement:** Fri 2026-11-20 — the overlay challenge. The core is Nebula remote access and a working MQTT path to Node-RED on the Optiplex cluster.

## 🎯 Learning Goals

This module gives you the opportunity to explore extending a network beyond a single router and achieve competency in **NAT traversal, Nebula overlay deployment, and moving MQTT through the overlay to a service node**.

By the end of this module, you can:
1. Explain why classical port forwarding fails under Carrier-Grade NAT (CGNAT), DS-Lite, and campus/enterprise firewalls — and what an overlay adds.
2. Deploy Nebula from a class **bundle** onto the pod router (or a laptop where you have admin rights), and explain what the certificate, the private key, the CA, the config, and the lighthouse each do.
3. Prove cross-NAT access to the pod router from an external network.
4. Make the router a gateway, reach a Node-RED instance on the Optiplex cluster through the overlay, and move MQTT between that instance and the pod's Mosquitto broker.

**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 🎬 Opening the Challenge

**The day starts with the unreachable service, not a slide.** Module 2 gave you a gateway; today you make it reachable without asking anyone to open a port. The opening runs in five quick beats:

1. **Pre-study check-in.** In your pod, show one artefact from Module 2 — the router baseline, a capture, or the port-forward note — and name one question you still have. Park the questions on the board.
2. **Confirm the pod and the roles.** Rotate: one drives the bundle install, one drives the router gateway and firewall, one keeps the topology, Node-RED path, and evidence. Swap after each task.
3. **Collect the hardware and the bundle.** One OpenWrt router per pod with the **USB stick and extroot from Module 2**, laptops with campus/mobile connectivity, and one **bundle per pod** from the instructor. Your assigned Node-RED URL and the class login are on the board.
4. **Draw the two networks.** Sketch the underlay (museum firewall, campus, home, mobile), the overlay (virtual addresses, lighthouse, peers), and the MQTT path from the pod broker to Node-RED and back. Mark where the bundle sits and which device is the gateway.
5. **Skim the tasks, do not start.** Read the challenge and the task table, then skim the theory boxes and the evidence list. Find **where the cross-NAT proof happens** and **where MQTT crosses the overlay**. Then start Task 1.

Before you touch the bundle, answer these three in one sentence each — they are the questions the day will answer:

- Why does a port forward fail when the router is behind CGNAT or a campus firewall?
- What does the lighthouse do — and what does it deliberately not do?
- Where does the MQTT message cross from the pod LAN to Node-RED, and which firewall rule allows it?

### Your portfolio entry for today — sections, not files

Everything from today goes into **`Module03/README.md`** as sections. Split something into its own file only when a section outgrows the page.

- `## Overlay plan` — the underlay/overlay sketch, the overlay addresses, the lighthouse, the Node-RED host, and the MQTT path.
- `## Study log` — the running log: the theory you actually needed, the commands that surprised you, and the LLM answers you checked. Not an essay, and not a separate study phase.
- `## Discussion log` — one line per discussion: who listened, what they asked, what you changed. This is personal.
- `## Bundle notes` — what the bundle contains, where it is installed, and what you had to do that the bundle did not. **No keys, no certificates, no config with credentials.**
- `## Remote-access proof` — the ping/ssh output from an external network, the Node-RED URL, and the path you used.
- `## MQTT through the overlay` — the broker address, the topics, the Node-RED flow, and the command that changed an output.
- `## Showcase notes` — optional: `batctl` output if the instructor runs the B.A.T.M.A.N. showcase.
- `## Story seeds` — optional: the odd bits worth turning into a story later.

*One pod member keeps the shared `## Study log`; the others link to it from their own `Module03/README.md` and add one sentence on what they took from it. The `## Discussion log` is yours alone.*

### The bundle contract

The bundle is a credential, and one of you will install it. Agree before you start:

- **One archive per pod.** Never a shared archive: each bundle contains one private key.
- **The archive is a credential.** Keep it out of Git, chat, screenshots, and the portfolio. Delete it from the download folder after installing.
- **Two bundles are normal.** A router bundle and a laptop bundle are two separate nodes with two overlay addresses. That is not a mistake.
- **If it leaks, say so.** The instructor re-signs one certificate; that is cheaper than a password reset for everybody.

### The service contract

Node-RED is a shared class service on the Optiplex cluster, not another thing to install on the router.

- **The router routes and brokers; the Optiplex runs the flow.** Never install Node-RED on the router.
- **Use the class login on the board.** It is a lab credential, not a personal password, and it is not reused outside this class. If you run your own Node-RED instance later, change the default login.
- **The Nebula firewall is the door policy.** Access is restricted by host and port; there are no broad subnet rules in this first overlay session.

## 📖 The Challenge — The Exhibition Across the City

**Lumenwerk Gütersloh GmbH** has installed an interactive light sculpture in a partner museum on the other side of town. Creative director **Mara Voss** needs to update the animation and read the sensor logs without driving over, and the museum's network is behind a campus firewall: no public IP, no inbound ports, no cooperation from the IT department.

Technician **Jonas Feld** tries port forwarding, then a dynamic-DNS service, then gives up. The sculpture's broker is on the pod router; the dashboard runs on a Node-RED instance on the class service cluster. Mara asks the question that motivates today: *"How do we reach the sculpture's broker and the dashboard without asking anyone to open a hole in their firewall?"*

**Your challenge.** Give the sculpture a private address without opening a port, then move one MQTT message from the pod broker to Node-RED and one command back. You are done when you can show:

1. A port-forward-vs-Nebula decision with one sentence for the museum and one for the pod.
2. A Nebula node joined from a class **bundle** — on the router by default, on a laptop only if you have admin rights.
3. A cross-NAT proof: `ping` or `ssh` to the overlay address from an external network.
4. A Node-RED instance on the Optiplex cluster reached from a laptop on the pod LAN.
5. An MQTT command from Node-RED to the pod broker that changes an output.
6. An explanation of the bundle's credential model: which file is the private key, what the CA signed, and what revocation means.

**Constraints.** One router per pod with the extroot from Module 2. 16 MB of flash. One Wi-Fi adapter per laptop. No public IP and no inbound port on the museum side. The router is the **default gateway** for the pod LAN; the laptop path is an optional stretch. Node-RED runs on the Optiplex cluster, never on the router. The bundle is a credential. Today is **Nebula only**; Yggdrasil moves to a later class and B.A.T.M.A.N. is only an instructor showcase.

**There will be story hooks coming up.** Feel free to add your own story-hook extensions that define scenarios where things go wrong — especially when you struggle or explore at a point. Collect those lines under `## Story seeds` and use them in a discussion or the harvest.

## 🧭 How this works now

**The study is folded into the practice.** There is no separate pod-study phase and no scheduled hand-off to another pod. Each task gives you a small thing to do, a compact **Theory you need** box you read only when the task makes you want it, and a **discussion** at the end. Keep your notes in `Module03/README.md` under `## Study log` — a running log, not an essay.

**First: skim (meaning read), do not start.** Read the challenge and the task table, then skim the theory boxes and the evidence list. You are looking for two things: **where the cross-NAT test happens** and **where MQTT crosses the overlay**. Then start Task 1.

**Every task ends with a discussion — one person is enough.** Ask someone at the nearest pod if they have a moment; show them the task's artefact and ask the discussion question. If they want, let them show you theirs and ask you one question back. **This is a brag, not a quiz**: you are showing what works and inviting one question. Write one line in `## Discussion log`; this is your **★ Log it** for the task.

**Take a study break when the theory box is not enough.** Read the linked source, then explain it to one person. Explaining is the test, not reading. You do not need permission; take the break when the task makes you want it.

The table is the discussion map: the **[Goal](#-learning-goals) · theory box** column names what each discussion checks. The question tests understanding, not task completion.

| # | Task | You produce | [Goal](#-learning-goals) · theory box | Discussion question for one person |
|---|---|---|---|---|
| 1 | **Choose the overlay path** | A port-forward vs Nebula decision and an underlay/overlay sketch | G1 · Choose the overlay path | "Why does the lighthouse not need to relay the traffic?" |
| 2 | **Join from the bundle** | `nebula1` address, `nebula -test`, bundle notes | G2 · Join from the bundle | "What is in the bundle, and which file is the credential?" |
| 3 | **Cross the NAT** | A ping/ssh proof from an external network | G3 · Cross the NAT | "What did the lighthouse do, and what did it not do?" |
| 4 | **Move MQTT through the overlay** | A Node-RED screenshot, MQTT proof, and path diagram | G4 · Move MQTT through the overlay | "Which two firewall rules made the message move?" |
| 5 | **Evidence and exchange** | The portfolio sections and a shared artefact | G1–G4 · Evidence and exchange | "Can you explain one hop without opening your notes?" |
| ◇ | **Stretcher** | Be the CA, join from a laptop, or see the B.A.T.M.A.N. showcase | G2/G4 · stretcher | "What does this prove that the basic path did not?" |

**The order is a suggestion.** The tasks are a path, not a timetable. If the bundle install fails, switch to the laptop path or ask for the demo and come back; if the router gateway is not working, prove the overlay first and finish the MQTT path after the demo. **The instructor demos the risky steps live on the beamer** — the bundle import, one cross-NAT test, and one MQTT command through the overlay — so ask for the demo you need instead of waiting with a broken step. Rotate roles after each task; everybody should install, route, or prove one piece. The question you should always be able to answer is *"what did you choose, and what did it cost you?"*

## 🛠️ The Build: Nebula and Remote MQTT — **Challenging**

*Hardware per pod:* 1× OpenWrt router from Module 2 with its USB stick and extroot, 1× class bundle, laptops with campus/mobile connectivity, and the assigned Node-RED instance on the Optiplex cluster. A second laptop bundle is optional for students with admin rights.

| What | Notes |
|---|---|
| Router | Cudy TR1200 from Module 2; `192.168.14.0/24`; Mosquitto on `192.168.14.1:1883` |
| Overlay | Nebula `nebula1` on the router; address from the bundle (`10.100.0.x`) |
| Lighthouse | Class lighthouse; directory only, not a relay |
| Node-RED | Optiplex cluster, one container per pod; URL and class login on the board |
| Node-RED port | `1808x` on the assigned Optiplex host (exact port on the board) |
| Broker over the overlay | The pod router's overlay address, port `1883` |
| Direct laptop path | Optional; needs admin rights and a laptop bundle |

> [!TIP]
> **If your laptop cannot install Nebula**, use the router as the gateway. That is the default path for the whole pod, and it is enough for full evidence. The direct laptop join is a stretcher, not a requirement.

### ★ Task 1 — Choose the overlay path

**Proves:** Goal 1 · **Produces:** a port-forward vs Nebula decision and an underlay/overlay sketch.

1. **List the failure cases.** For port forwarding, write when it works and what breaks it: CGNAT/DS-Lite, a campus firewall, and a changing WAN address.
2. **Draw the overlay.** Put the lighthouse, the sculpture, the dashboard, and the pod router on the sketch. Mark the direct tunnel and the path the lighthouse is *not* on.
3. **Decide.** Choose a path for the museum and a path for the pod. One sentence each: what does it buy, and what does it cost?

**Theory you need.** An **overlay** builds a virtual Layer-3 network on top of the underlay. **Nebula** is mutually authenticated: every node has a certificate signed by the class CA, a private key, a fixed overlay address, and a config. A **lighthouse** is a directory with a stable address; it tells peers how to find each other, but it does not relay their traffic. Once the peers have a direct encrypted path, the lighthouse is out of the data path. That is why the museum firewall needs no inbound rule. *Go deeper: the Nebula docs; the NAT-traversal article.*

> **Discussion — show one person.** Show your sketch and ask: *"Why does the lighthouse not need to relay the traffic?"* Write one line in `## Discussion log`; this is your **★ Log it** for the task.

> **Story hook.** *Mara's question.* She does not want a VPN account for every device, and she cannot ask the museum to open a port. She wants the sculpture to have its own address — and to revoke one machine without changing everybody's password.

### ★ Task 2 — Join from the bundle

**Proves:** Goal 2 · **Produces:** `nebula1` address, `nebula -test` result, and bundle notes.

1. **Read the bundle before installing.** Find the certificate, the private key, the CA certificate, and the config. Identify which file is the credential that must never leave the machine.
2. **Install on the router.** Copy the four bundle files and the static `nebula` binary to `/etc/nebula/`; keep the key at mode `600`; run `nebula -test -config /etc/nebula/config.yml`; start it and check `ip -brief addr show nebula1`.
3. **Explain the model.** What did the CA sign? What does the config add that the certificate does not? What happens if this bundle leaks?

**Theory you need.** The **certificate** proves the node's identity and fixed overlay address. The **private key** makes that certificate usable. The **CA** signed the certificate; the CA key never leaves the instructor's machine. The **config** says which lighthouse to ask, which groups to join, and which firewall rules apply. The deployment unit is **certificate + key + config** — the bundle. On OpenWrt, the installer is not used: four files and a static binary are enough. *Go deeper: the bundle cheat sheet in the resource bank and the Nebula certificate docs.*

> **Discussion — show one person.** Show `ip -brief addr show nebula1` and your bundle notes, and ask: *"What is in the bundle, and which file is the credential?"* Write one line in `## Discussion log`; this is your **★ Log it** for the task.

> **Story hook.** *The keys to the sculpture.* Mara does not want an account on a museum server; she wants the sculpture to have its own address and its own key, while the museum's IT department never opens a port.

### ★ Task 3 — Cross the NAT

**Proves:** Goal 3 · **Produces:** a ping/ssh proof from an external network and a path note.

1. **Leave the pod LAN.** Use your phone's hotspot or eduroam. You are now on a different network from the router.
2. **Reach the router.** Ping its overlay address, then open an SSH session to it.
3. **Record the path.** Which network were you on? What did the lighthouse do? What did *not* happen on the museum firewall?

**Theory you need.** Both peers are behind NAT, so neither can accept an unsolicited inbound connection. The lighthouse is reachable, so each peer tells it its current public `ip:port`; the peers then send outbound UDP packets to each other at the same time, which creates the NAT mappings in both directions — **UDP hole punching**. Once the mapping exists, traffic is direct and encrypted; the lighthouse is out of the path. *Go deeper: the NAT-traversal and UDP-hole-punching articles.*

> **Discussion — show one person.** Show the external-network terminal and ask: *"What did the lighthouse do, and what did it not do?"* Write one line in `## Discussion log`; this is your **★ Log it** for the task.

> **Story hook.** *The museum's firewall never opened.* Mara's laptop is on a hotel Wi-Fi, the sculpture is behind the museum's campus firewall, and the two still talk. The proof is a `ping` and an `ssh` prompt, not a network diagram.

### ★ Task 4 — Move MQTT through the overlay

**Proves:** Goal 4 · **Produces:** a Node-RED screenshot, an MQTT proof, and a one-line path diagram.

1. **Make the router a gateway.** Give `nebula1` a firewall zone, allow `lan → nebula` forwarding, and masquerade LAN clients so their traffic can reach the service node. Allow only `1883` from the service group; do not open all input.
2. **Open your Node-RED.** From a laptop on the pod LAN, open the assigned Optiplex URL on the board and log in with the class credential.
3. **Move one message.** Add an `mqtt in` node for `pod<NN>/#`, an `mqtt out` node for `pod<NN>/<device>/set`, and an inject node. Send one command and observe the LED or actuator.
4. **Draw the path.** Sensor → pod broker → overlay → Node-RED → overlay → pod broker → actuator. Mark the two firewall rules that made it work.

**Theory you need.** A router with an overlay address is a **node**; a router that forwards between its LAN and the overlay is a **gateway**. Forwarding is a kernel setting plus a firewall zone: the LAN side may forward to the overlay, the overlay side must not accept arbitrary input, and masquerading hides the pod LAN behind the router's overlay address. Node-RED is a **service** on the Optiplex; the pod broker stays on the router. MQTT is still pub/sub — the overlay changes the path, not the topic model. *Go deeper: the OpenWrt firewall docs, the Node-RED MQTT nodes, and the class firewall policy.*

> **Discussion — show one person.** Show the Node-RED flow, the changed output, and your path diagram, and ask: *"Which two firewall rules made the message move?"* Write one line in `## Discussion log`; this is your **★ Log it** for the task.

> **Story hook.** *The dashboard is in the class, the broker is in the basement.* The sculpture publishes to its local broker; the dashboard runs on the service cluster; the overlay is the only path between them. Nobody opened a port.

### ★ Task 5 — Evidence and exchange

**Proves:** Goals 1–4 · **Produces:** the portfolio sections and one shared artefact.

1. **Exchange with a neighbouring pod.** Show your path diagram and ask them to explain one hop without opening your notes. If they cannot, add the missing label.
2. **Clean the sections.** `## Overlay plan`, `## Bundle notes`, `## Remote-access proof`, and `## MQTT through the overlay` should each tell a stranger what you did and what proves it.
3. **Agree one shared artefact.** The best path diagram, the firewall table, or the Node-RED flow — with a one-sentence note on why you chose it.

**★ Log it.** In `## Study log`, write the one thing that surprised you about the path, and one sentence on what you would check first if MQTT stopped flowing.

### ◇ Task 6 (Stretcher) — Be the CA

The bundle exists because somebody ran a CA and signed a certificate. Do it yourself once, in a **scratch workspace**, so the bundle stops being magic. Use the `nebula-manager` source or the resource-bank recipe; do not touch the class CA. Answer: what did the CA sign, which file must never leave the machine, and what does revocation mean?

> **Story hook.** *The key that signs the keys.* The class CA is one machine in the instructor's bag; losing it means re-issuing the whole mesh. That is why it never travels in a bundle.

### ◇ Task 7 (Stretcher) — Join from your laptop

If you have admin rights, join a second node from your laptop with its own bundle. Show two overlay addresses for one pod and explain why that is normal, not a mistake. Do not share the laptop bundle; it is a credential.

### ◇ Task 8 (Stretcher/showcase) — See the B.A.T.M.A.N. mesh

If the instructor brings the mesh kit, join the showcase and record `batctl n`/`batctl o`. Explain why a Layer-2 mesh is for the room, not for the city, and why it is **not** the same tool as Nebula. This is a showcase, not a setup task; Yggdrasil is deferred to a later class.

## 🤖 Ask an LLM — then verify

Use these when a theory box is not enough. Treat every answer as a **claim to test**, not a fact, and run it against your own overlay.

- "Explain why port forwarding fails behind Carrier-Grade NAT and a campus firewall. What does an overlay do differently?"
- "How does Nebula's lighthouse help two peers behind different NATs establish a direct tunnel? Does the lighthouse relay the traffic?"
- "What do the certificate, private key, CA, and config each do in a Nebula bundle? What does revocation mean?"
- "What must a router do to forward LAN clients to an overlay service, and which firewall rule should it *not* have?"
- "A Node-RED instance on the overlay can subscribe to the pod broker but cannot publish. Which layers would you check, in order?"

Record where the model is wrong, vague, or over-confident in `## Study log`.

## 🔁 Optional: the harvest — collect curiosities, swap lists

> **Optional and ungraded.** The full ritual is in [Module 1](./01-foundations-and-masterclass.md#harvest); run the compact version here.

As you work, mark the odd bits: a bundle that installed but never got an address, a lighthouse that was reachable but a peer that was not, a Node-RED flow that subscribed but could not publish, a gateway that worked from the router but not from the LAN. Put a `?` in the margin or a line under `## Story seeds`. At the break and at the end, swap lists with one person at another pod: briefly, no explaining, every entry gets a source. Anything two pods collected, or that nobody can place, goes to the course channel. The list is the artefact; the conversation is the point.

## ✅ Suggested portfolio evidence (proofs of the learning goals)

This is a **suggestion, not a checklist** — the learning goals are the contract. A convincing subset, or a better artefact you design yourself, is worth more than a ticked list.

1. **Overlay choice (goal 1):** the port-forward vs Nebula decision and the underlay/overlay sketch.
2. **Overlay deployment (goal 2):** the bundle notes, the `nebula -test` result, `ip -brief addr show nebula1`, and the overlay address. **No key material.**
3. **Remote access (goal 3):** the ping/ssh proof from an external network and one sentence on what the lighthouse did not do.
4. **MQTT through the overlay (goal 4):** the Node-RED flow, the broker address, the topics, the command that changed an output, and the two firewall rules.
5. **The running log and discussions:** your `## Study log` with the theory you actually needed and the LLM answers you checked, plus `## Discussion log` — one line per discussion.
6. **Optional:** the scratch-CA answers, the direct laptop join, or the B.A.T.M.A.N. showcase notes.

> [!IMPORTANT]
> Never commit **bundles**, credentials, private keys, certificates, or the class Node-RED password. An archive containing a `.key` file *is* a credential, even if it is "just" for a class mesh. Where you did not work entirely alone, link your pod mates and sources.

## 📚 If you want to go deeper

- [Nebula documentation](https://nebula.defined.net/docs/) — lighthouses, certificates, and firewall rules.
- [nebula-manager](https://github.com/iotempire/nebula-manager) — the class CA and bundle tool: [client bundles & installers](https://github.com/iotempire/nebula-manager/blob/main/docs/bundles.md), [certificates & workspaces](https://github.com/iotempire/nebula-manager/blob/main/docs/certificates.md), [firewall policy](https://github.com/iotempire/nebula-manager/blob/main/docs/firewall.md).
- [OpenWrt firewall configuration](https://openwrt.org/docs/guide-user/firewall/firewall_configuration) — zones, forwarding, and masquerading.
- [Node-RED](https://nodered.org/docs/) — the MQTT nodes and flows.
- [NAT traversal](https://en.wikipedia.org/wiki/NAT_traversal) and [UDP hole punching](https://en.wikipedia.org/wiki/UDP_hole_punching) — why overlays work where port forwarding fails.
- The [resource bank's Nebula bundle cheat sheet](./Z-resources-bank.md#nebula-bundles--the-class-ca) and [networking snippets](./Z-resources-bank.md#networking-snippets-copypaste).

---

[← Previous: Module 2](./02-local-networking-and-gateways.md) | [Back to front page](../README.md) | [Quick module index](./00-index.md) | [Next: Module 4 — MQTT Deep Dive & Integration →](./04-mqtt-and-integration.md)
