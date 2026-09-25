# Module 3 – Mesh & Overlay Networks: Nebula, Yggdrasil & B.A.T.M.A.N.

[← Back to Module 2](./02-local-networking-and-gateways.md) | [Quick module index](./00-index.md) | [Next: Module 4 →](./04-mqtt-and-integration.md)

> **One session, one question:** *How do I extend my network beyond a single router — locally and across the Internet?*
> The core is the overlay/remote-access work (Nebula, plus the Yggdrasil IPv6 mesh); the B.A.T.M.A.N. Layer-2 mesh is an optional stretcher you can explore if time and routers allow.

## 🎯 Learning Goals

> **How these are assessed:** You earn this module's points by proving these goals in a short (~10-minute) checkpoint presentation with the instructor (see the [syllabus](../syllabus.md#how-module-points-are-earned-checkpoint-presentations)) — based on your portfolio and reflections, not on completing every task. You may skip tasks, fail at some, or add your own; documented exploration and demonstrated deep understanding both count in your favor.

This module gives you the opportunity to explore extending a network beyond a single router and achieve competency in NAT traversal and remote access with the Nebula overlay and the Yggdrasil IPv6 mesh, plus the concepts of Layer-2 router meshes and self-healing failover.

By the end of this module, you can:
1. Explain why classical port forwarding fails under Carrier-Grade NAT (CGNAT), DS-Lite, and campus/enterprise firewalls.
2. Deploy Nebula, a peer-to-peer overlay with lighthouse discovery and UDP hole punching.
3. Evaluate Yggdrasil, a self-arranging, cryptographically addressed IPv6 mesh.
4. Distinguish a Layer-3 overlay (Nebula/Yggdrasil) from a Layer-2 router mesh (B.A.T.M.A.N. advanced) and choose the right tool for local vs. wide-area coverage.
5. *(Optional stretch)* Configure an **OpenWrt 802.11s + `batman-adv`** mesh across several routers, inspect it with `batctl`, and observe self-healing rerouting under live traffic.

> [!NOTE]
> Task tiers. Tasks marked ★ Core must be completed by everyone. Tasks marked ◇ Stretcher are optional and are the natural trim point if time runs short — they are excellent bonus-task material.

> [!WARNING]
> DRAFT — first taught in WS 2026/27. Everything below this line is a working draft and will likely change as we refine it together in class; the line moves down as we approve content. Your input is welcome and can shape this module.

**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 📖 Part A — Overlay Networks: Remote Access Without Port Forwarding

### Why Traditional Port Forwarding Fails in Modern IoT
In Module 2, you forwarded ports on your local router. But in real life:
- CGNAT (Carrier-Grade NAT) & DS-Lite: Most residential mobile (LTE/5G) and fiber connections no longer provide a public IPv4 address. Multiple households share one public IP.
- University & Enterprise Firewalls: Campus networks block inbound ports. You cannot expose an MQTT broker or OpenWrt SSH port directly to the world.
- Dynamic IPs: Home routers change their WAN IP periodically.

### The Solution: Encrypted Overlay Networks
An overlay network builds a virtual Layer-3 network on top of an existing underlay network (the public Internet):

```text
Underlay (Physical / Internet):
[Student Laptop at Home] ---> [Home NAT] ---> (Public Internet) <--- [Campus Firewall] <--- [OpenWrt Gateway in Lab]
                                                       |
                                            (Direct connection blocked!)

Overlay Network (Nebula / Yggdrasil):
[Virtual IP: 10.100.0.5] ================= Encrypted Tunnel ================= [Virtual IP: 10.100.0.1]
```

### 1. Nebula (Slack / Defined Networking)
- Architecture: Mutually authenticated peer-to-peer mesh using Noise Protocol cryptography (similar to WireGuard).
- Lighthouse: A node with a static, public IP that acts as a directory server. It does *not* relay user traffic; it only tells peers each other's current public IP:port so they can perform UDP hole punching to establish direct, peer-to-peer encrypted tunnels.
- Security: Every node has a cryptographic certificate signed by a private Certificate Authority (CA), defining its fixed overlay IP and firewall rules.

### 2. Yggdrasil Network
- Architecture: A fully decentralized, zero-configuration end-to-end encrypted IPv6 mesh network.
- Cryptographic Addressing: Node IPs are derived directly from a public encryption key (in the `200::/7` range).
- Self-Healing Tree Routing: Yggdrasil peers establish connections over TCP, TLS, or raw link-local Wi-Fi, forming a global or private spanning-tree metric space. Packets route greedily along the tree even across complex, dynamic topologies.

## 📖 Part B — Layer-2 Router Mesh: `batman-adv`

> [!NOTE]
> Optional stretcher territory. Layer-2 mesh is worth understanding conceptually, but the hands-on B.A.T.M.A.N. lab is optional (stretcher): it needs several routers sharing a Wi-Fi channel, and the core of this module is the overlay/remote-access work. Do the mesh lab only if time, routers, and interest allow.

### Why Layer-2 Mesh Instead of IP Routing?
In traditional networks, extending a network across multiple hops requires Layer-3 routing (OSPF, RIP, BGP) with complex IP subnetting and routing tables on every node. If a link drops, IP routes must recalculate, dropping existing TCP sessions.

**B.A.T.M.A.N. (Better Approach To Mobile Adhoc Networking) Advanced:**
- Operates directly at the Data Link layer (Layer 2) as a Linux kernel module (`kmod-batman-adv`).
- Emulates a **virtual Ethernet switch (`bat0`)**: to the operating system, DHCP servers, and applications, every device on the mesh appears as if it is plugged into the same physical Ethernet switch!
- Zero Subnetting Headache: You can run a single flat IPv4 subnet (e.g. `192.168.8.0/24`) across dozens of routers spanning multiple hops.
- Link Quality Sensing (OGM): Routers continuously send lightweight Originator Messages (OGMs) to determine the best next-hop neighbor based on Transmit Quality (TQ).

```text
       [Router 1 (Team A)] <--- 802.11s Mesh ---> [Router 2 (Team B)]
               ^                                           |
               |                                           |
       802.11s Mesh                                   802.11s Mesh
               |                                           |
               v                                           v
       [Router 4 (Team D)] <---------------------> [Router 3 (Team C)]

  All routers form a unified virtual Layer-2 switch: "bat0"
  Devices connected to any router share the same broadcast domain!
```

> [!TIP]
> Notice how `batman-adv` (Part B) and ESP-NOW (Module 5) share the same superpower: they move routing/adjacency decisions down the stack so that the layers above do not have to care. Keep that pattern in mind — it recurs throughout the course.

## 📖 Part C — Choosing the Right Tool

| | Port Forwarding | Nebula | Yggdrasil | B.A.T.M.A.N. adv *(optional)* |
|---|---|---|---|---|
| Layer / model | Layer 3/4 (NAT rule) | Layer 3 overlay | Layer 3 overlay (IPv6) | Layer 2 mesh |
| Scope | One exposed service | Wide-area, P2P | Wide-area, P2P | Local / campus |
| Works behind CGNAT / firewall? | No | Yes (hole punching) | Yes (outbound peers) | N/A (must be link-local) |
| Addressing | Static/leased public IP | Fixed virtual IP per cert | Key-derived `200::/7` IPv6 | Flat Ethernet `bat0` |
| Encryption | Depends on service (TLS) | Yes (Noise Protocol) | Yes (end-to-end) | No (add your own, e.g. TLS) |
| Infrastructure needed | Upstream NAT access | Lighthouse (1 node) | At least one reachable peer | Wi-Fi coverage + 802.11s |
| Best for | Quick one-off demo | Remote access to your gateway | Decentralized class mesh | Multi-hop coverage across rooms |

## 🛠️ In-Class Lab: One Session, Three Networks

*Hardware:* 1× OpenWrt router per student pair + laptops with a connection to the university/mobile network. For the optional mesh stretcher, the class connects 3–6 routers into a shared multi-hop mesh.

Time budget: ★ Core ≈ 40 min (Nebula), ◇ Stretchers ≈ 100 min (B.A.T.M.A.N. mesh + Yggdrasil), plus theory, reflection, and portfolio work.

### ★ Task 1: Deploying Nebula for Team Remote Access (40 min)

1. Meet the Lighthouse:
   - The instructor provides a running Nebula lighthouse address (e.g. `lighthouse.iotempire.net` or a dedicated lab VM).
   - Your team receives signed client certificates:
     - `gateway-<team>.crt` / `gateway-<team>.key` (assigned IP e.g. `10.100.0.10`)
     - `laptop-<student>.crt` / `laptop-<student>.key` (assigned IP e.g. `10.100.0.11`)
2. Install & Configure Nebula on Your Laptop:
   - Download Nebula for your OS (Linux, macOS, Windows) from [github.com/slackhq/nebula](https://github.com/slackhq/nebula/releases).
   - Create `config.yaml` pointing to the CA certificate, your node key/cert, and the lighthouse IP.
   - Start Nebula:
     ```bash
     sudo nebula -config config.yaml
     ```
   - Verify that your virtual network adapter (`nebula1`) receives your assigned overlay IP.
3. Install Nebula on the OpenWrt Router:
   - Transfer the OpenWrt MIPS/ARM binary and certificates to the router via SCP:
     ```bash
     scp nebula root@192.168.8.1:/usr/bin/
     scp config-router.yaml root@192.168.8.1:/etc/nebula/config.yaml
     ```
   - Start Nebula on the router:
     ```bash
     nebula -config /etc/nebula/config.yaml &
     ```
4. The Cross-NAT Ping Test:
   - Disconnect your laptop from the OpenWrt router! Connect your laptop to your smartphone's mobile hotspot or the campus eduroam network.
   - Both devices are now behind completely separate, firewalled networks.
   - Run:
     ```bash
     ping 10.100.0.10   # Ping your OpenWrt router over the Nebula overlay
     ```
   - Connect to your OpenWrt SSH or Mosquitto broker over the overlay:
     ```bash
     ssh root@10.100.0.10
     mosquitto_sub -h 10.100.0.10 -t "test/#" -v
     ```
   - *Success:* You now have secure, direct, bidirectional access to your IoT gateway from anywhere!

### ◇ Task 2 (Stretcher): Building the Class Mesh with B.A.T.M.A.N. advanced (60 min)

Work in pairs. The classroom becomes a single multi-hop mesh — coordinate mesh IDs and channels with your neighbors!

1. **Install & Enable `batman-adv` (10 min):**
   SSH into your OpenWrt router and install the kernel module and control tool:
   ```bash
   ssh root@192.168.8.1
   opkg update
   opkg install kmod-batman-adv batctl-default
   lsmod | grep batman
   ```
2. Configure the 802.11s Wireless Mesh Interface (25 min):
   - Edit `/etc/config/wireless` (or use LuCI under Network → Wireless → Add):
     ```text
     config wifi-iface 'mesh0'
         option device 'radio0'
         option mode 'mesh'
         option mesh_id 'hsbi-iot-mesh'
         option network 'batman_mesh'
         option encryption 'none'
     ```
   - Bind the mesh interface to `bat0` in `/etc/config/network` and bridge it into your LAN:
     ```text
     config interface 'batman_mesh'
         option proto 'batadv'
         option mesh 'bat0'

     # Add bat0 to the LAN bridge (br-lan) so wired/Wi-Fi clients join the mesh
     config device
         option name 'br-lan'
         option type 'bridge'
         list ports 'eth0'
         list ports 'bat0'
     ```
   - Restart networking:
     ```bash
     /etc/init.d/network restart
     ```
3. **Visualize the Mesh with `batctl` (15 min):**
   Once 3 or more student routers are active:
   - Direct neighbors: `batctl n` — directly reachable 1-hop routers with signal quality and latency.
   - Originator routing table: `batctl o` — all nodes across the multi-hop mesh and the best next-hop MAC address to reach them.
   - Trace multi-hop paths: `batctl traceroute <target_mac>` — watch packets hop across intermediate student routers.

### ◇ Task 3 (Stretcher): The Live Failover Test (15 min)

Because this session runs *before* the MQTT module, we test resilience at the network level — which is exactly where routing decisions are made anyway. We will re-run the same experiment *with* MQTT traffic in the final project studio (Module 8).

1. Start a continuous stream across the mesh: `ping <remote-node>` or `iperf3 -c <remote-node>` to a router on the other side of the room.
2. Simulate a link failure: have the intermediate relay router (Team B) abruptly unplug from power.
3. **Observe `batman-adv` react:**
   - Watch `batctl o` immediately detect the missing OGMs.
   - Traffic dynamically re-routes through a different neighbor.
   - Notice that the flat Layer-2 subnet and any TCP sessions it carried survive the reroute without re-addressing.

### ◇ Task 4 (Stretcher): Exploring Decentralized Mesh with Yggdrasil (25 min)

Do this task if you finish the core labs early, or as homework/bonus.

1. Install Yggdrasil on your laptop or OpenWrt router (available via apt, brew, or pre-compiled).
2. Inspect your cryptographic identity: run `yggdrasil -genconf` and find your assigned IPv6 address.
3. Peer with the class mesh: add the lab's local Yggdrasil peer address to your `Peers: [...]` config:
   ```json
   Peers: [
     "tcp://192.168.8.1:9001"
   ]
   ```
   Start Yggdrasil and inspect it:
   ```bash
   yggdrasilctl getPeers
   yggdrasilctl getPaths
   ```
4. End-to-end IPv6 ping: ask another student for their Yggdrasil IPv6 address and `ping -6 200:...` — then reach a simple service (for example an HTTP server or SSH) listening on that Yggdrasil IPv6 socket.

## 📝 Working-Day Reflection & Portfolio Tasks

In your portfolio under `modules/03-mesh-overlay/`:
1. Tool Selection Matrix: Compare Port Forwarding, Nebula, Yggdrasil, and B.A.T.M.A.N. advanced across: central infrastructure required, NAT traversal, encryption model, layer, and suitability for remote vs. local coverage. (Extend the table from Part C with your own observations.)
2. Remote-Access Proof: Terminal screenshot showing your laptop on an external network (e.g. mobile hotspot) with a successful `ping` and `ssh` session to your OpenWrt router via its Nebula IP (`10.100.0.x`).
3. *(Optional)* Mesh Routing Artifacts: Capture `batctl n` and `batctl o` output showing your router's multi-hop neighbors, plus a `batctl traceroute` across the room.
4. *(Optional)* Failover Experiment Report: Describe what happened during the link drop: how many pings/packets were lost before B.A.T.M.A.N. converged on the alternate route?
5. Reflection: Why can `batman-adv` give you a flat subnet across the room, while Nebula/Yggdrasil are needed to reach a device across the Internet? Which one would your final project use — and why?
