# Module 2 – Local Networking, TCP/IP & OpenWrt Gateways

[← Back to Module 1](./01-foundations-and-masterclass.md) | [Quick module index](./00-index.md) | [Next: Module 3 →](./03-overlay-and-mesh-networks.md)

<!-- TODO(instructor): consider mirroring the Sensors & Actuators Module 2 bus survey (simple pins → UART → RS-232/RS-485/Modbus/CAN/I²C/SPI/OneWire) here; see Z-resources-bank.md#instructor-hints. Not scheduled for the current offering. -->

**Course placement:** Day 2 — the edge-router studio. You subnet, route, NAT, and capture packets at the choke point.

## 🎯 Learning Goals

This module gives you the opportunity to explore TCP/IP at the network edge and achieve competency in **IPv4 addressing and subnetting, DHCP/DNS/NAT, OpenWrt administration, and packet capture at the choke point with `tcpdump`** (read in Wireshark when it is available).

By the end of this module, you can:
1. Configure IPv4 addressing, CIDR subnetting, default gateways, and routing tables.
2. Inspect and diagnose the core IP plumbing services: ARP, DHCP (DORA), DNS, and NAT.
3. Configure, administer, and secure an OpenWrt edge router via SSH and the LuCI web interface.
4. Capture traffic at the choke point with `tcpdump` on the router, and read the dump with Wireshark, `tshark`, or as text — without needing a second network adapter.


**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 📖 Story — The Substation Behind the Router

**Stadtwerke Gütersloh** is connecting a district-heating substation to the control room. Field engineer **Malik Yilmaz** has a Cudy router, two M5Stack nodes, and a laptop. The router receives a `10.x.x.x` address from the campus uplink, hands out `192.168.8.x` leases to the nodes, and hides them behind NAT. The dashboard works from the laptop on the LAN — but the control room cannot reach the nodes, and Malik cannot see why.

Petra Sommer's question is precise: *"Which address is which, who is allowed to initiate the connection, and where can I prove it?"* Today you take the router apart: subnetting, DHCP/DNS/NAT, routing tables, OpenWrt's UCI, and a live `tcpdump` capture at the choke point.

## 📖 Pod Study: TCP/IP at the Edge

This is **self/pod study, not a lecture.** Work through the concepts below with your Task Pod, look things up, ask an LLM, and keep notes — the goal is a shared mental model you can defend in the checkpoint.

### 1. Subnetting & Private Address Spaces (RFC 1918)
In IoT edge networks, devices operate in private address blocks:
- `10.0.0.0/8`
- `172.16.0.0/12`
- `192.168.0.0/16`

Understanding CIDR (Classless Inter-Domain Routing):
- `/24` = `255.255.255.0` (254 usable host addresses)
- `/28` = `255.255.255.240` (14 usable host addresses)

If two IoT nodes have the IP `192.168.8.10/24` and `192.168.9.10/24`, can they communicate directly at Layer 2? No; their traffic must cross a router (Layer 3) that knows how to route between subnets.

### 2. The Core Edge Services:
- ARP (Address Resolution Protocol): Resolves IP addresses (Layer 3) to physical MAC addresses (Layer 2). Without ARP, an Ethernet/Wi-Fi frame cannot be addressed to a physical destination.
- DHCP (Dynamic Host Configuration Protocol): Automatically assigns IP, subnet mask, gateway, and DNS servers via the DORA sequence (Discover $\rightarrow$ Offer $\rightarrow$ Request $\rightarrow$ Acknowledge).
- NAT (Network Address Translation - Masquerading): Allows dozens of private IoT devices behind the OpenWrt router to share a single upstream WAN IP address by mapping TCP/UDP ports.
- DNS (Domain Name System) & mDNS: Translates human-readable names to IPs. In local IoT networks, mDNS (Zeroconf/Avahi, e.g. `openwrt.local` or `node1.local`) allows discovery without a central DNS server.

### Pointers (start here, then keep looking)

- Private addressing — [RFC 1918](https://www.rfc-editor.org/rfc/rfc1918)
- Subnetting and CIDR — [Wikipedia: Classless Inter-Domain Routing](https://en.wikipedia.org/wiki/Classless_Inter-Domain_Routing) (and the [Practical Networking subnetting series](https://www.practicalnetworking.net/))
- DHCP — [RFC 2131](https://www.rfc-editor.org/rfc/rfc2131)
- NAT — [RFC 3022](https://www.rfc-editor.org/rfc/rfc3022)
- OpenWrt — [OpenWrt documentation](https://openwrt.org/docs/start), [UCI](https://openwrt.org/docs/guide-user/base-system/uci)
- `tcpdump` — [tcpdump manual](https://www.tcpdump.org/manpages/tcpdump.1.html), and [Wireshark](https://www.wireshark.org/docs/)

### Questions to ask an LLM (then verify against your network)

Ask your co-pilot — but treat every answer as a **claim to test**, not a fact. Good starting prompts:

- "Explain CIDR subnetting with a `/24` and a `/28`. Give me the network address, broadcast address, and usable host range for `192.168.8.10/24`."
- "Walk me through the DHCP DORA exchange. Which packets are broadcast, which are unicast, and which ports are used?"
- "Why can a LAN client reach the internet through NAT, but an internet host cannot initiate a connection to the LAN client without port forwarding?"
- "Explain ARP and what happens when the ARP cache is empty. How would I see the request/reply in a capture?"
- "My router has a WAN address from the campus and a LAN subnet. Draw the routing table and explain which interface a packet to `8.8.8.8` uses."

> Run each prompt against your own router and capture, and record where the model is wrong, vague, or over-confident.

### ★ Task A: Study in your pod

Work through the concepts above with your Task Pod and write it up under `## Study log` in `Module02/README.md` — a section, not a file, unless it outgrows the page. **One pod member keeps the shared log; the others link to that section from their own module README and add one sentence on what they took from it.**

1. **The references you used** — the source and the one concept you understood best from it.
2. **Things you googled** — the term, what you found, and the source (URL). One line each.
3. **Remarkable things** — surprises, "aha"s, and counterexamples from your own network.
4. **LLM Q&A** — for each prompt: the prompt, a 2–3 line summary, and **how you verified it** (and where it was wrong).
5. **Your two best found subnet/routing diagrams** — compile down to the best two, with source and what they taught you.

*Portfolio evidence:* the `## Study log` section (yours, or a link to your pod's shared one).

### ★ Task B: Explain & share with another pod

Pair with a **neighbouring pod**:

1. **Explain to each other** — each pod walks the other through its network map and its packet capture; ask questions and fill each other's gaps.
2. Agree on the **3–5 most noteworthy points** and the **learning you jointly stand behind** (e.g. *"NAT is why the outside cannot start the conversation"*).
3. **Clean up your documentation** — update the `## Study log` with what you learned from the other pod.
4. Agree on **one shared artefact** — the best network diagram, a DHCP/ARP capture, or a new routing sketch the two pods make together — and **post it in the course Discord**, with a one-sentence note on why you chose it.
5. Each member adds a short **“Agreed learning (pod discussion)”** note — in the shared log, or in your own module README with a link to it.

*Portfolio evidence:* the cleaned-up `## Study log` (with the **“Agreed learning (pod discussion)”** note) and your pod-pair's shared artefact.

## 🛠️ In-Class Lab: Taming the OpenWrt Edge Router — **Challenging**

*Hardware per pair:* 1× OpenWrt Router (GL.iNet or TP-Link), 2× Laptops, Ethernet cables.

### ★ Task 1: OpenWrt Discovery & SSH Administration
1. Connect your laptop to the OpenWrt router's LAN port or Wi-Fi.
2. Verify your assigned IP address and default gateway:
   - Linux: `ip route show`
   - macOS: `netstat -nr`
   - Windows: `ipconfig`
3. Access OpenWrt via SSH:
   ```bash
   ssh root@192.168.8.1
   ```
4. Explore the OpenWrt Unified Configuration Interface (UCI):
   ```bash
   uci show network
   uci show wireless
   uci show dhcp
   ```
5. Inspect the routing table and active network interfaces on the router:
   ```bash
   ip route
   ip addr
   brctl show   # Check the br-lan bridge
   ```

### ★ Task 2: Packet inspection at the choke point — `tcpdump` first, Wireshark second

Capture where every packet must pass: the router. **You do not need a second Wi-Fi adapter, and you do not need Wireshark to prove anything** — but a dump is easier to read in a GUI, so the pattern is always: capture on the router → copy the file → open it. The recipes and the extroot setup live in the [resource bank](./Z-resources-bank.md#packet-capture-without-a-second-wifi-card).

1. `tcpdump` is already on the class image. On a fresh router: `opkg update && opkg install tcpdump` (`apk add tcpdump` on OpenWrt 24.10 and newer).
2. Capture on the router and copy the dump over:
   ```bash
   ssh root@192.168.8.1 "tcpdump -i br-lan -s 0 -w /tmp/lan.pcap 'arp or udp port 67 or udp port 68'"
   # stop with Ctrl-C, then from your laptop:
   scp root@192.168.8.1:/tmp/lan.pcap .
   ```
   `br-lan` is the LAN bridge, so it sees traffic between LAN ports and Wi-Fi clients. Use `-i any` if you also want the router's own WAN traffic.
3. **Read it — Wireshark optional.** `wireshark lan.pcap` if you have it; otherwise `tshark -r lan.pcap -V`, or straight on the router `tcpdump -r /tmp/lan.pcap -A`. The text output is enough for the portfolio.
4. Trigger and observe these specific network events:
   - **DHCP:** connect a fresh client (your phone) to the OpenWrt Wi-Fi. Watch Discover (broadcast, 67→68), Offer, Request, ACK.
   - **ARP:** flush your ARP cache (`ip -s -s neigh flush all` on Linux; `arp -d *` or `netsh interface ip delete arpcache` in an **admin** shell on Windows), then `ping 192.168.8.1`. Look for *Who has 192.168.8.1?* and the unicast reply.
   - **TCP handshake:** connect MQTTX or `curl` to a port on the router. Find `[SYN]`, `[SYN, ACK]`, `[ACK]`, and the teardown.

> [!NOTE]
> **No live streaming into a GUI.** `ssh … | wireshark -k -i -` works on Linux and macOS when netcat is in the path; on Windows, and in this lab generally, the two-step is the reliable route. If you cannot capture at all today, use the instructor's dump — the analysis is the skill, not the tapping.

### ★ Task 3: Custom Subnets, Static Leases & Port Forwarding
1. Open the LuCI web interface: `http://192.168.8.1` (Network $\rightarrow$ DHCP and DNS).
2. Assign a Static DHCP Lease to your M5Stack node based on its MAC address so it always receives `192.168.8.150`.
3. Port Forwarding Exercise:
   - Your OpenWrt router has a WAN port connected to the classroom upstream network (e.g. receiving `10.x.x.x`).
   - Create a firewall port forwarding rule in LuCI (Network $\rightarrow$ Firewall $\rightarrow$ Port Forwards):
     - Forward external port `11883` on WAN to internal port `1883` (Mosquitto) on `192.168.8.1`.
   - Ask a neighboring pod to connect their MQTT client to your router's WAN IP on port `11883`. Confirm the connection in `logread`!

## ✅ Suggested portfolio evidence (proofs of the learning goals)

1. Network Map: Draw a clean network diagram of your setup showing MAC addresses, assigned IPs, subnets, and the WAN/LAN interfaces of the OpenWrt router.
2. Packet Trace Proof: A Wireshark screenshot **or** the `tcpdump -A` / `tshark` text of a DHCP DORA sequence or an ARP request/reply, captured on the router. Say which one you used and why.
3. Port Forwarding & NAT Analysis: Explain how NAT masquerading works and why a client on the outside WAN cannot connect to an internal M5Stack node without explicit port forwarding.
4. Deeper question: What surprised you about the volume of background broadcast/multicast traffic (mDNS, SSDP, ARP) on a local network?


> [!IMPORTANT]
> Never commit secrets, credentials, private keys, or captures containing personal traffic. Where you did not work entirely alone, link your pod mates and sources.

## 📚 If you want to go deeper

- [RFC 1918](https://www.rfc-editor.org/rfc/rfc1918) — private address space.
- [RFC 2131](https://www.rfc-editor.org/rfc/rfc2131) — DHCP.
- [RFC 3022](https://www.rfc-editor.org/rfc/rfc3022) — NAT.
- [OpenWrt documentation](https://openwrt.org/docs/start) and [UCI](https://openwrt.org/docs/guide-user/base-system/uci) — the router you are actually configuring.
- [tcpdump manual](https://www.tcpdump.org/manpages/tcpdump.1.html) — capture at the choke point.

---

[← Previous: Module 1](./01-foundations-and-masterclass.md) | [Back to front page](../README.md) | [Quick module index](./00-index.md) | [Next: Module 3 — Mesh & Overlay Networks →](./03-overlay-and-mesh-networks.md)
