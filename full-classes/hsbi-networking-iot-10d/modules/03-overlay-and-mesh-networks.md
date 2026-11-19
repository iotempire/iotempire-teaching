# Module 3 – Overlay Networks: Nebula & Remote MQTT

[← Back to Module 2](./02-local-networking-and-gateways.md) | [Quick module index](./00-index.md) | [Next: Module 4 →](./04-mqtt-and-integration.md)

**Course placement:** Fri 2026-11-20 — the overlay challenge: Nebula on the pod router, then one MQTT message to Node-RED and one command back.

## 🎯 Learning Goals

By the end of this module, you can:

1. Explain what an overlay network is and when it beats a port forward: changing WAN addresses, campus firewalls, CGNAT/DS-Lite, hole punching. *(The NAT variants are optional depth; know the shape of the problem.)*
2. Deploy a Nebula node from a bundle on the router, and explain what the CA, the certificate, the key, and the config each do.
3. Explain the roles in the mesh — certificate, peer, lighthouse — and what the lighthouse does and deliberately does not do.
4. Make the router a gateway, reach your Node-RED instance on the Optiplex cluster through the overlay, and move one MQTT message each way.

**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 📖 The Challenge — The Exhibition Across the City

**Lumenwerk Gütersloh GmbH** has installed an interactive light sculpture in a partner museum across town. Creative director **Mara Voss** wants to update the animation and read the sensor logs without driving over. The museum network is behind a campus firewall: no public IP, no inbound ports, no help from their IT.

Technician **Jonas Feld** tries a port forward, then dynamic DNS, then gives up. The broker is on the pod router, the dashboard runs on a Node-RED instance on the class cluster. Mara asks the question behind today: *"How do we reach the sculpture and the dashboard without asking anyone to open a hole in their firewall?"*

**Your challenge.** Give the sculpture a private address without opening a port, then move one MQTT message from the pod broker to Node-RED and one command back.

### Your portfolio entry — sections in `Module03/README.md`

- `## Overlay plan` — the underlay/overlay sketch, the overlay addresses, the lighthouse, the Node-RED host, the MQTT path, and the note to Mara.
- `## Study log` — what you actually needed, what surprised you, the LLM answers you checked. One pod member keeps it; the others link to it and add one sentence.
- `## Bundle notes` — what the bundle contains and where it went. **No keys, no certificates, no credentials.**
- `## Discussion log` — one line per discussion: who listened, what they asked.
- `## Remote proof` — the ping/ssh output from another network, and the Node-RED URL.
- `## MQTT through the overlay` — broker address, topics, the flow, the command that changed an output.

### Two rules that keep this clean

- **The bundle is a credential.** One archive per pod, never shared, never in Git, chat, or a screenshot; delete it after installing. If one leaks, say so — one certificate is re-signed, not everybody's password.
- **Node-RED is a shared service.** The router routes and brokers; the *cluster* runs the flow — never install Node-RED on the router. Use the class login on the board (`admin` / `iotempire`); it is a lab credential, not a personal password.

## 🧭 How this works

There is no separate study phase: each task gives you the theory when the task makes you want it. End every task by showing your artefact to **one person at another pod** and asking the discussion question — a brag, not a quiz — then write one line in `## Discussion log`. Take a study break when a task raises a question you cannot answer; explaining it to someone is the test. **The order is a suggestion**: if the bundle install fights you, ask for the live demo and come back.

*Hardware per pod:* the Module 2 router with extroot, one bundle, laptops, and your assigned Node-RED on the cluster.

## 🛠️ The Build — **Challenging**

### ★ Task 1 — Connect your router to the overlay

**Proves:** Goal 2 · **Produces:** `nebula1` up with its mesh address, and the lighthouse reachable.

This is the path that works on the pod routers (OpenWrt + LuCI):

1. **Get your bundle.** Your instructor posts a `croc` code per pod. Open <https://getcroc.com/#receive> and follow the receive instructions — it works in the browser, no install needed. Prefer the command line? Download the binary from <https://getcroc.com/> and run `croc` then enter your code. Check that the archive was for **your** pod — the ID is on the label on your router. Keep code and archive to yourself; both are credentials.

2. **Install the protocol.** *System → Software*: install `luci-proto-nebula`, then **reboot the router**. Over SSH: `opkg update && opkg install luci-proto-nebula && reboot`.

3. **Unpack and copy four files to the router.** Unzip the archive (Windows: right-click → *Extract All*, macOS: double-click, Linux: `unzip`). You need exactly four files: `ca.crt`, `<host>.crt`, `<host>.key`, `config.yml`.

   Open a terminal — PowerShell on Windows (10/11 ships `scp` with the OpenSSH client), Terminal on macOS, your shell on Linux — and `cd` into the unpacked folder. Tip: type `cd `, then drag the folder from the file manager into the terminal window.

   ```bash
   scp -O ca.crt <host>.crt <host>.key config.yml root@192.168.14.1:/etc/nebula/
   ```

   `-O` because OpenWrt has no sftp server. If `scp` is missing on Windows: *Settings → Apps → Optional features → OpenSSH client*.

4. **Check it over SSH** — the same login you used in Module 2:

   ```bash
   ssh root@192.168.14.1
   ls -l /etc/nebula/
   chmod 600 /etc/nebula/*.key
   grep -E 'ca:|cert:|key:' /etc/nebula/config.yml
   ```

   All four files must be in `/etc/nebula/`, the key at mode `600`, and the three paths in `config.yml` must point at `/etc/nebula/…`. **Not** `/etc/config/` — that is UCI's directory.

5. **Interface.** *Network → Interfaces → Add new interface*: name `nebula1`, protocol **Nebula**, config file `/etc/nebula/config.yml`. Put it in a new firewall zone `nebula`, save and apply. The device `nebula1` appears with its mesh address; LuCI may still show the interface as *pending* — that is expected.
6. **Firewall.** Zone `nebula`: input **accept**, output **accept**, forward **reject**, **masquerading on** (the mesh only accepts source addresses from the certificate), allow forward from `lan`, and under *Advanced → Covered devices* add `nebula1`. That last one is the decisive setting: without a device the zone has no interface and LAN→mesh traffic is refused.
7. **DNS.** *Network → DHCP and DNS*: forward `/ulno.mesh/10.100.0.1`, and add `ulno.mesh` to the domain whitelist — otherwise dnsmasq discards the private answers as a "possible DNS-rebind attack".
8. **Test.** On the router: `ping vps.ulno.mesh` (DNS works and the lighthouse answers). From a laptop on the pod LAN: `ping ulno-oldplex02.hsbi01.ulno.mesh` — every service host is `ulno-oldplexNN.hsbi01.ulno.mesh`.

Because of masquerading every LAN device appears in the mesh as the router. Whether a mesh service answers is decided by the **Nebula firewall rules on the other side**, which select the router's certificate and groups.

*Deutsche Fassung dieser Anleitung:* [Nebula auf OpenWrt einrichten](./03-annex-nebula-openwrt-de.md).

> **Story hook.** *Mara's keys.* She does not want an account on a museum server. She wants the sculpture to have its own address and its own key — and to be able to revoke one machine without changing everybody's password.

> **Show and ask.** Show the `nebula1` address. *"Which file in the bundle is the credential, and what happens if it leaks?"*

### ★ Task 2 — Reach Node-RED and move one message

**Proves:** Goals 3–4 · **Produces:** Node-RED open from a pod laptop, one MQTT round trip, a path sketch.

1. From a laptop on the pod LAN, open the URL on the board (`http://<optiplex-host>:1808x`) and log in.
2. In Node-RED: an `mqtt in` node on `pod<NN>/#`, an `mqtt out` node to `pod<NN>/<device>/set`, and one inject. Broker address: the **router's overlay address**, port `1883`.
3. Send one command and watch the LED or actuator change.
4. Draw the path: sensor → pod broker → overlay → Node-RED → overlay → pod broker → actuator. Mark the two rules that allowed it: the group rule on the service host, and the router's forward + masquerade.

> **Story hook.** *The dashboard is in the class, the broker is in the basement.* The sculpture publishes locally; the dashboard runs across town; nobody opened a port.

> **Show and ask.** Show the flow and the output that changed. *"Which two rules made the message move?"*

### ◇ Task 3 (optional) — A certificate for your laptop

If you have admin rights on your laptop, join a second node with its own bundle and show two overlay addresses for one pod. Explain why that is normal and not a mistake. The laptop bundle is a credential too: do not share it and get it from the instructor (for example via croc). Without admin rights, skip this — the router path is the default and full evidence.

> **Show and ask.** *"What does the second node prove that the router path did not?"*

### ★ Task 4 — Draw the two networks

**Proves:** Goals 1 and 3 · **Produces:** the `## Overlay plan` section, including a short note to Mara.

1. **Underlay:** museum firewall, campus, home, mobile. Where does each connection actually leave the building?
2. **Overlay:** virtual addresses, the lighthouse, the peers. Mark the tunnel and mark everything the lighthouse is **not** on.
3. **Answer in three sentences:** what an overlay is; what the lighthouse does (and that it only relays when two peers cannot punch, e.g. behind one NAT or CGNAT); what the instructor had to prepare, and how you would repeat it for another site.
4. **Answer Mara.** Under the sketch, write 5–8 sentences to Mara Voss — a creative director, not an engineer. She asked how you reach the sculpture and the dashboard without anyone opening a hole in a firewall: answer that, say what she can do now that she could not before, what did **not** change in the museum network, and one limit she will notice (both ends must run the client; a path through the relay is slower than one on the same LAN). No word she would have to look up.

*Pointers:* [Nebula docs](https://nebula.defined.net/docs/), [NAT traversal](https://en.wikipedia.org/wiki/NAT_traversal), [UDP hole punching](https://en.wikipedia.org/wiki/UDP_hole_punching).

> **Story hook.** *Nothing was opened.* Mara's laptop is on a hotel Wi-Fi, the sculpture sits behind the museum firewall, and they still talk. The proof is a `ping` and an `ssh` prompt, not a diagram.

> **Show and ask.** Hand your sketch to someone and ask them to explain one hop without your notes.

### ★ Task 5 — Measure it

**Proves:** Goal 1 · **Produces:** two numbers and one sentence.

1. `ping` between your laptop, the router, and the measurement host `10.100.1.1`.
2. **Throughput against the class target** — the instructor runs an `iperf3` server on `10.100.1.1:5201` for everyone:

   ```bash
   iperf3 -c 10.100.1.1 -t 10          # uplink
   iperf3 -c 10.100.1.1 -t 10 -R       # downlink
   iperf3 -c 10.100.1.1 -t 10 -P 4     # parallel streams

   # LAN baseline, for comparison: run iperf3 -s on the router, then
   iperf3 -c 192.168.14.1 -t 10
   ```

   **Keep every test to 5–10 seconds.** A pod on eduroam is relayed through the class VPS: a minute at line rate spends the VPS traffic budget and measures the relay, not your network. One short run, one number, move on.
3. Where is it fast (same LAN), where is it slow (a hop through the internet, a relayed path)?
4. **Optional depth:** what are CGNAT and DS-Lite, and why does a peer behind them need a relay while a peer behind a home router usually does not?

> **Optional graphical aids.** The numbers are the evidence; these only make them easier to see.
>
> - **Latency over time:** [`gping`](https://github.com/orf/gping) draws a live graph for several hosts in one terminal — Windows, macOS, Linux (`winget install orf.gping`, `brew install gping`, `apt install gping`). For *where* the delay starts, `mtr` (Linux/macOS) shows latency and loss **per hop**; on Windows use **WinMTR**, which is maintained again.
> - **iperf3 without a shell:** **iperf3 Speed Test** (Android) and **HE.NET Network Tools** (Android/iOS) run a real iperf3 client against any `iperf3 -s`. Old Java wrappers for iperf2 are not worth installing on a laptop.
> - **Any device with a browser:** run **LibreSpeed** (`ghcr.io/librespeed/speedtest`) or **OpenSpeedTest** as one more container on the service host; a phone or a locked-down laptop then measures the overlay with nothing installed.

> **Show and ask.** *"Where did the path stop being a LAN, and how do you know?"*

### ◇ Task 6 (Stretcher) — The router as a node

**Proves:** Goal 4 · **Produces:** a MicroPython script that publishes and subscribes on the pod broker.

So far the router has been the broker and the gateway. Make it a **node** too:

1. Install MicroPython on the router (`opkg install micropython` on 24.10, `apk add micropython` on 25.12) and the `umqtt.simple` library — from the feed if present, otherwise copy it next to your script.
2. Write a script that connects to `192.168.14.1:1883`, publishes one reading per second to `pod<NN>/router/uptime`, and subscribes to `pod<NN>/router/set`.
3. Run it, publish a command from your laptop, and watch the router react — print the payload, or toggle the LED.

`paho-mqtt` does **not** belong here: it is CPython and stays the laptop client. On MicroPython the client is `umqtt.simple` from `micropython-lib`.

> **Show and ask.** *"What does this prove that the laptop client did not?"*

## 🔁 Curiosities — the harvest ritual is gone

We dropped the formal harvest. Keep collecting anyway: note the odd bits in `## Study log` and share them — in a reflection, on Discord, or by telling someone at another pod when you take a break. A bundle that installed but got no address, a peer that answers while another does not, MQTT that subscribes but cannot publish: these are the questions worth carrying forward, and two pods hitting the same one is worth a line in the class channel.

## ✅ Suggested evidence (proofs of the learning goals)

A suggestion, not a checklist — a better artefact of your own is worth more than a ticked list.

1. The overlay plan: underlay/overlay sketch, addresses, one sentence on why the lighthouse is not in the data path, and the note that answers Mara.
2. The deployment: `ip -brief addr show nebula1`, the overlay address, and bundle notes. **No key material.**
3. The remote proof: ping/ssh output from a different network, plus the Node-RED URL.
4. The MQTT round trip: flow, topics, the command that changed an output, and the two rules that allowed it.
5. The running log: `## Study log` and `## Discussion log`.
6. **Optional:** the MicroPython client on the router, the direct laptop join, or the B.A.T.M.A.N. showcase notes.

## 🤖 Ask an LLM — then verify

Treat every answer as a claim to test against your own mesh.

- "Why does a port forward fail behind CGNAT and behind a campus firewall? What does an overlay do differently?"
- "What do certificate, private key, CA, and config each do in a Nebula bundle? What does revocation mean?"
- "A Node-RED instance can subscribe to the pod broker but cannot publish. Which layers would you check, in order?"

## 📚 If you want to go deeper

- [Nebula documentation](https://nebula.defined.net/docs/) — lighthouses, certificates, firewall rules, relay.
- [nebula-manager](https://github.com/iotempire/nebula-manager) — the class CA and bundle tool: [bundles](https://github.com/iotempire/nebula-manager/blob/main/docs/bundles.md), [certificates](https://github.com/iotempire/nebula-manager/blob/main/docs/certificates.md), [firewall](https://github.com/iotempire/nebula-manager/blob/main/docs/firewall.md).
- [OpenWrt firewall](https://openwrt.org/docs/guide-user/firewall/firewall_configuration) — zones, forwarding, masquerading.
- [Node-RED](https://nodered.org/docs/), [NAT traversal](https://en.wikipedia.org/wiki/NAT_traversal), [UDP hole punching](https://en.wikipedia.org/wiki/UDP_hole_punching).
- [MicroPython](https://micropython.org/) and [`umqtt.simple`](https://github.com/micropython/micropython-lib/tree/master/micropython/umqtt.simple) — the stretcher's MQTT client on the router.
- The [resource bank's Nebula bundle sheet](./Z-resources-bank.md#nebula-bundles--the-class-ca) and [networking snippets](./Z-resources-bank.md#networking-snippets-copypaste).
- **Showcase (instructor):** if the mesh kit is out, watch the B.A.T.M.A.N. demonstration and compare a Layer-2 mesh for one room with a Layer-3 overlay for the city. It is not a setup task; Yggdrasil is deferred to a later class.
- **If mesh clients cannot reach the router's broker,** check that Mosquitto listens on `nebula1` (or `0.0.0.0`) with `netstat -ltn` on the router — the broker's bind address is the usual culprit.

---

[← Previous: Module 2](./02-local-networking-and-gateways.md) | [Back to front page](../README.md) | [Quick module index](./00-index.md) | [Next: Module 4 — MQTT Deep Dive & Integration →](./04-mqtt-and-integration.md)
