# Module 3 – Mesh & Overlay Networks: Nebula, Yggdrasil & B.A.T.M.A.N.

[← Back to Module 2](./02-local-networking-and-gateways.md) | [Quick module index](./00-index.md) | [Next: Module 4 →](./04-mqtt-and-integration.md)

**Course placement:** Day 3 — the overlay and mesh studio. The core is overlay/remote access (Nebula and Yggdrasil); B.A.T.M.A.N. is an optional stretcher if time and routers allow.

## 🎯 Learning Goals

This module gives you the opportunity to explore extending a network beyond a single router and achieve competency in NAT traversal and remote access with the Nebula overlay and the Yggdrasil IPv6 mesh, plus the concepts of Layer-2 router meshes and self-healing failover.

By the end of this module, you can:
1. Explain why classical port forwarding fails under Carrier-Grade NAT (CGNAT), DS-Lite, and campus/enterprise firewalls.
2. Deploy Nebula, a peer-to-peer overlay with lighthouse discovery and UDP hole punching — from a class **bundle** onto a router or a laptop, and explain what the certificate, the key, and the config each do.
3. Evaluate Yggdrasil, a self-arranging, cryptographically addressed IPv6 mesh.
4. Distinguish a Layer-3 overlay (Nebula/Yggdrasil) from a Layer-2 router mesh (B.A.T.M.A.N. advanced) and choose the right tool for local vs. wide-area coverage.
5. *(Optional stretch)* Configure an **OpenWrt 802.11s + `batman-adv`** mesh across several routers, inspect it with `batctl`, and observe self-healing rerouting under live traffic.


**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 📖 Story — The Exhibition Across the City

**Lumenwerk Gütersloh GmbH** has installed an interactive light sculpture in a partner museum on the other side of town. Creative director **Mara Voss** needs to update the animation and read the sensor logs without driving over, and the museum's network is behind a campus firewall: no public IP, no inbound ports, no cooperation from the IT department.

Technician **Jonas Feld** tries port forwarding, then a dynamic-DNS service, then gives up. Mara asks the question that motivates today: *"How do we give the sculpture its own private network address without asking anyone to open a hole in their firewall?"* The answer is an overlay — Nebula for a certificate-based peer-to-peer network, Yggdrasil for a cryptographically addressed IPv6 mesh — and, optionally, a Layer-2 mesh when the routers are in the same room.

## 📖 Pod Study: Extending the Network Beyond One Router

This is **self/pod study, not a lecture.** Work through the concepts below with your Task Pod, look things up, ask an LLM, and keep notes — the goal is a shared mental model you can defend in the checkpoint.

### Overlay Networks: Remote Access Without Port Forwarding

### Why Traditional Port Forwarding Fails in Modern IoT
In Module 2, you forwarded ports on your local router. If you did the SSH-tunnel stretcher, you have already built a one-off version of an overlay; the difference is that Nebula gives every node an address and a policy instead of a hand-built tunnel. But in real life:
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
- **The deployment unit is a node = certificate + private key + config.** In this class you receive those three as a **bundle** (plus an installer and a README). That is the whole credential model: no shared passwords, and revoking one machine is one certificate — which is why an overlay is administratively cheaper than a VPN account for every device.

### 2. Yggdrasil Network
- Architecture: A fully decentralized, zero-configuration end-to-end encrypted IPv6 mesh network.
- Cryptographic Addressing: Node IPs are derived directly from a public encryption key (in the `200::/7` range).
- Self-Healing Tree Routing: Yggdrasil peers establish connections over TCP, TLS, or raw link-local Wi-Fi, forming a global or private spanning-tree metric space. Packets route greedily along the tree even across complex, dynamic topologies.

### Layer-2 Router Mesh: `batman-adv`

> [!NOTE]
> Optional stretcher territory. Layer-2 mesh is worth understanding conceptually, but the hands-on B.A.T.M.A.N. lab is optional (stretcher): it needs several routers sharing a Wi-Fi channel, and the core of this module is the overlay/remote-access work. Do the mesh lab only if time, routers, and interest allow.

### Why Layer-2 Mesh Instead of IP Routing?
In traditional networks, extending a network across multiple hops requires Layer-3 routing (OSPF, RIP, BGP) with complex IP subnetting and routing tables on every node. If a link drops, IP routes must recalculate, dropping existing TCP sessions.

**B.A.T.M.A.N. (Better Approach To Mobile Adhoc Networking) Advanced:**
- Operates directly at the Data Link layer (Layer 2) as a Linux kernel module (`kmod-batman-adv`).
- Emulates a **virtual Ethernet switch (`bat0`)**: to the operating system, DHCP servers, and applications, every device on the mesh appears as if it is plugged into the same physical Ethernet switch!
- Zero Subnetting Headache: You can run a single flat IPv4 subnet (e.g. `192.168.14.0/24`) across dozens of routers spanning multiple hops.
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

### Choosing the Right Tool

| | Port Forwarding | Nebula | Yggdrasil | B.A.T.M.A.N. adv *(optional)* |
|---|---|---|---|---|
| Layer / model | Layer 3/4 (NAT rule) | Layer 3 overlay | Layer 3 overlay (IPv6) | Layer 2 mesh |
| Scope | One exposed service | Wide-area, P2P | Wide-area, P2P | Local / campus |
| Works behind CGNAT / firewall? | No | Yes (hole punching) | Yes (outbound peers) | N/A (must be link-local) |
| Addressing | Static/leased public IP | Fixed virtual IP per cert | Key-derived `200::/7` IPv6 | Flat Ethernet `bat0` |
| Encryption | Depends on service (TLS) | Yes (Noise Protocol) | Yes (end-to-end) | No (add your own, e.g. TLS) |
| Infrastructure needed | Upstream NAT access | Lighthouse (1 node) | At least one reachable peer | Wi-Fi coverage + 802.11s |
| Best for | Quick one-off demo | Remote access to your gateway | Decentralized class mesh | Multi-hop coverage across rooms |

### Pointers (start here, then keep looking)

- Nebula — [Nebula documentation](https://nebula.defined.net/docs/), [GitHub](https://github.com/slackhq/nebula)
- The class bundles — [nebula-manager](https://github.com/iotempire/nebula-manager), [client bundles & installers](https://github.com/iotempire/nebula-manager/blob/main/docs/bundles.md), and the [bundle cheat sheet in the resource bank](./Z-resources-bank.md#nebula-bundles--the-class-ca)
- Yggdrasil — [Yggdrasil documentation](https://yggdrasil-network.github.io/)
- B.A.T.M.A.N. advanced — [OpenWrt batman-adv documentation](https://openwrt.org/docs/guide-user/network/wifi/mesh/batman)
- NAT traversal — [Wikipedia: NAT traversal](https://en.wikipedia.org/wiki/NAT_traversal), [UDP hole punching](https://en.wikipedia.org/wiki/UDP_hole_punching)
- The [resource bank's networking snippets](./Z-resources-bank.md#networking-snippets-copypaste)

### Questions to ask an LLM (then verify against your network)

Ask your co-pilot — but treat every answer as a **claim to test**, not a fact. Good starting prompts:

- "Explain why port forwarding fails behind Carrier-Grade NAT and a campus firewall. What does an overlay do differently?"
- "How does Nebula's lighthouse help two peers behind different NATs establish a direct tunnel? Does the lighthouse relay the traffic?"
- "How does Yggdrasil derive an IPv6 address from a public key, and what does the spanning-tree routing do when a peer disappears?"
- "Compare a Layer-3 overlay (Nebula/Yggdrasil) with a Layer-2 mesh (batman-adv). Give one use case where each is the right tool."
- "What happens if a Nebula certificate or private key leaks? How does the CA isolate the compromise?"

> Run each prompt against your own overlay, and record where the model is wrong, vague, or over-confident.

### ★ Task A: Study in your pod

Work through the concepts above with your Task Pod and write it up under `## Study log` in `Module03/README.md` — a section, not a file, unless it outgrows the page. **One pod member keeps the shared log; the others link to that section from their own module README and add one sentence on what they took from it.**

1. **The references you used** — the source and the one concept you understood best from it.
2. **Things you googled** — the term, what you found, and the source (URL). One line each.
3. **Remarkable things** — surprises, "aha"s, and counterexamples from your own overlay.
4. **LLM Q&A** — for each prompt: the prompt, a 2–3 line summary, and **how you verified it** (and where it was wrong).
5. **Your two best found overlay/mesh diagrams** — compile down to the best two, with source and what they taught you.

*Portfolio evidence:* the `## Study log` section (yours, or a link to your pod's shared one).

### ★ Task B: Explain & share with another pod

Pair with a **neighbouring pod**:

1. **Explain to each other** — each pod walks the other through its tool-selection matrix and its remote-access proof; ask questions and fill each other's gaps.
2. Agree on the **3–5 most noteworthy points** and the **learning you jointly stand behind** (e.g. *"an overlay gives you an address, not a public hole"*).
3. **Clean up your documentation** — update the `## Study log` with what you learned from the other pod.
4. Agree on **one shared artefact** — the best topology diagram, a `ping`/`ssh` proof, or a new decision table the two pods make together — and **post it in the course Discord**, with a one-sentence note on why you chose it.
5. Each member adds a short **“Agreed learning (pod discussion)”** note — in the shared log, or in your own module README with a link to it.

*Portfolio evidence:* the cleaned-up `## Study log` (with the **“Agreed learning (pod discussion)”** note) and your pod-pair's shared artefact.

## 🛠️ In-Class Lab: Three Networks — **Challenging**

*Hardware:* 1× OpenWrt router per pod (with the **USB stick and extroot** you set up in Module 2) + laptops with a connection to the university/mobile network. For the optional mesh stretcher, the class connects 3–6 routers into a shared multi-hop mesh.

This module has one ★ Core task (Nebula) and several ◇ Stretchers (B.A.T.M.A.N. mesh, Yggdrasil). Choose the stretchers that fit your time and interest; the core is the overlay/remote-access work.

### ★ Task 1: Deploying Nebula for Team Remote Access

**You get a bundle, not a certificate ceremony.** The instructor runs the class CA and one lighthouse; every pod receives a **self-contained bundle** — `<name>.crt`, `<name>.key`, `ca.crt`, `config.yml.template`, `install.sh`, `install.ps1`, `README.txt`. A node is exactly that: a certificate, a key, and a config. The bundle is also the thing you can hand to a machine, which is why a whole class can join in one session.

> **Story hook.** *The keys to the sculpture.* Mara does not want an account on a museum server; she wants the sculpture to have its own address and its own key, while the museum's IT department never opens a port. A bundle is that promise in a file — and revoking it costs one certificate, not a password reset for everybody.

1. **Collect your bundle and read its `README.txt`.** It arrives as a croc code or a URL from the projector, one archive per pod. The README lists your overlay IP, your groups, and the exact install commands. **The archive contains a private key** — keep it out of Git, out of chat, and delete it after installing. Find the lighthouse in your config (`lighthouse.hosts`, `static_host_map`): you never configure the lighthouse, but you have to be able to point at it.
2. **Pick the machine you will join from.** Most pods join with the **router** (that gives the whole LAN behind it a way in); students with admin rights can also join directly from Windows; Linux and macOS laptops use the installer. You may hold **two bundles** — one for the router, one for your laptop: they are two separate nodes with two overlay addresses, and that is the normal case, not a mistake.

| Your machine | What you need | Path |
|---|---|---|
| **OpenWrt router** — the default for most pods | static `nebula` binary for the router's architecture + the four bundle files | **A** |
| **Windows 10/11 laptop with admin rights** | Nebula for Windows + the bundle | **B** |
| **Linux / macOS laptop** | `nebula` from the package manager + the bundle | **C** |
| Linux laptop or VM that wants the manager UI | [nebula-manager](https://github.com/iotempire/nebula-manager) | **D** *(optional)* |

**Path A — the OpenWrt router (class default).** No systemd and 16 MB of flash, so the bundle's `install.sh` is not used here: copy four files, run the binary.

```bash
# on the router: architecture and space
uname -m                 # mips | mipsle | arm | aarch64
df -h /overlay

# on your laptop: unpack the bundle and push the four files
unzip <name>-nebula-bundle.zip -d nb && cd nb
ssh root@192.168.14.1 'mkdir -p /etc/nebula'
scp <name>.crt <name>.key ca.crt config.yml.template root@192.168.14.1:/etc/nebula/
ssh root@192.168.14.1 'cd /etc/nebula && [ -f config.yml ] || mv config.yml.template config.yml; chmod 600 *.key'

# the static binary must match `uname -m`: download it from
# https://github.com/slackhq/nebula/releases and copy it over
scp nebula root@192.168.14.1:/etc/nebula/nebula
ssh root@192.168.14.1 'chmod +x /etc/nebula/nebula'

# validate, watch it once in the foreground, then keep it running
ssh root@192.168.14.1 '/etc/nebula/nebula -test -config /etc/nebula/config.yml'
ssh root@192.168.14.1 'nohup /etc/nebula/nebula -config /etc/nebula/config.yml >/tmp/nebula.log 2>&1 &'
sleep 2; ssh root@192.168.14.1 'ip -brief addr show nebula1; tail -5 /tmp/nebula.log'
```

- The bundle's config already points at `/etc/nebula/…`, so the paths match. If yours does not, edit `pki.ca`, `pki.cert`, and `pki.key` — that is the only config difference between a router and a laptop.
- **16 MB is tight — and your router already has extroot from Module 2.** Verify `df -h /overlay` shows the stick before you copy the binary. If it does not, do the [extroot recipe](./Z-resources-bank.md#packet-capture-without-a-second-wifi-card) first; the same stick later holds `tshark` and MicroPython.
- **Firewall:** outbound UDP is open by default. If other nodes must reach *you* first, allow the Nebula UDP port (default `4242`) inbound on WAN.
- **Survives a reboot?** Not yet — an initscript is the difference between a demo and a gateway. That is a good stretcher (see the note at the end of this task).

**Path B — a Windows laptop (needs admin).**

```powershell
# once: install Nebula for Windows (release zip/MSI) so nebula.exe is in PATH
#       or under C:\Program Files\Nebula\
# then, in an ELEVATED PowerShell, inside the extracted bundle:
powershell -ExecutionPolicy Bypass -File .\install.ps1
Get-Service Nebula
ipconfig | Select-String nebula
```

The installer backs up existing files, restricts the key to `SYSTEM` + `Administrators`, validates with `nebula.exe -test`, writes `config.yml`, installs the `Nebula` service and starts it. `-CertsOnly` refreshes only cert/key/CA, `-NoStart` installs without starting the service. **No admin rights?** Use Path C in WSL2, or join from the router — both are perfectly good evidence.

**Path C — a Linux or macOS laptop.**

```bash
sudo apt install -y nebula unzip        # macOS: brew install nebula
unzip <name>-nebula-bundle.zip -d nb && sudo bash nb/install.sh
systemctl status nebula; ip -brief addr show nebula1    # macOS: brew services list
```

The same script with `--certs-only` refreshes the certificate without touching a working config — that is what you use after the instructor re-signs you.

**Path D (optional) — the manager UI.** The bundle needs nothing else, but [`nebula-manager`](https://github.com/iotempire/nebula-manager) gives you a menu, config editing, and diagnostics. It is a bash tool for Linux (WSL2 is fine, systemd required) — **it does not run on OpenWrt, and you never run it as root**:

```bash
curl -fsSL https://github.com/iotempire/nebula-manager/releases/latest/download/nebula-manager -o nebula-manager
curl -fsSL https://github.com/iotempire/nebula-manager/releases/latest/download/nebula-manager.sha256 -o nebula-manager.sha256
sha256sum -c nebula-manager.sha256 && chmod +x nebula-manager
./nebula-manager import --bundle ~/Downloads/<name>-nebula-bundle.zip --yes
./nebula-manager diag        # TUN address, UDP socket, certificate expiry
./nebula-manager             # the same actions in a numbered menu
```

If you would rather click than type: run `./nebula-manager` and use **Manager Setup ▸ Import client bundle**, then **Diagnostics**. The menu and the CLI do the same things — use whichever you can explain to your pod.

3. **The cross-NAT test.** Now prove that a hole in a firewall was never needed:
   - Disconnect your laptop from the lab router and use your phone's hotspot or eduroam. Both ends are now behind different firewalls.
   - Ping your node's overlay IP (from its README — e.g. `10.100.0.10`):
     ```bash
     ping 10.100.0.10
     ssh root@10.100.0.10
     mosquitto_sub -h 10.100.0.10 -t 'test/#' -v
     ```
   - *Success:* secure, direct, bidirectional access to your gateway from a network that would never accept an inbound connection.

4. **(Stretcher) Make the router a gateway.** Joining from the router gives the *router* an overlay address. If the devices **behind** it should reach the overlay too, enable forwarding and give `nebula1` a firewall zone (input `reject`, forward `accept`, masquerading off) — that is the step that turns “my router is on the mesh” into “my substation is on the mesh”. Document what you had to allow.

### ◇ Task 2 (Stretcher): Building the Class Mesh with B.A.T.M.A.N. advanced

Work in pairs. The classroom becomes a single multi-hop mesh — coordinate mesh IDs and channels with your neighbors!

1. **Install & Enable `batman-adv`:**
   SSH into your OpenWrt router and install the kernel module and control tool:
   ```bash
   ssh root@192.168.14.1
   opkg update
   opkg install kmod-batman-adv batctl-default
   lsmod | grep batman
   ```
2. Configure the 802.11s Wireless Mesh Interface:
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
3. **Visualize the Mesh with `batctl`:**
   Once 3 or more student routers are active:
   - Direct neighbors: `batctl n` — directly reachable 1-hop routers with signal quality and latency.
   - Originator routing table: `batctl o` — all nodes across the multi-hop mesh and the best next-hop MAC address to reach them.
   - Trace multi-hop paths: `batctl traceroute <target_mac>` — watch packets hop across intermediate student routers.

### ◇ Task 3 (Stretcher): The Live Failover Test

Because this session runs *before* the MQTT module, we test resilience at the network level — which is exactly where routing decisions are made anyway. We will re-run the same experiment *with* MQTT traffic in the final project studio (Module 8).

1. Start a continuous stream across the mesh: `ping <remote-node>` or `iperf3 -c <remote-node>` to a router on the other side of the room.
2. Simulate a link failure: have the intermediate relay router (Team B) abruptly unplug from power.
3. **Observe `batman-adv` react:**
   - Watch `batctl o` immediately detect the missing OGMs.
   - Traffic dynamically re-routes through a different neighbor.
   - Notice that the flat Layer-2 subnet and any TCP sessions it carried survive the reroute without re-addressing.

### ◇ Task 4 (Stretcher): Exploring Decentralized Mesh with Yggdrasil

Do this task if you finish the core labs early, or as homework/stretcher practice.

1. Install Yggdrasil on your laptop or OpenWrt router (available via apt, brew, or pre-compiled).
2. Inspect your cryptographic identity: run `yggdrasil -genconf` and find your assigned IPv6 address.
3. Peer with the class mesh: add the lab's local Yggdrasil peer address to your `Peers: [...]` config:
   ```json
   Peers: [
     "tcp://192.168.14.1:9001"
   ]
   ```
   Start Yggdrasil and inspect it:
   ```bash
   yggdrasilctl getPeers
   yggdrasilctl getPaths
   ```
4. End-to-end IPv6 ping: ask another student for their Yggdrasil IPv6 address and `ping -6 200:...` — then reach a simple service (for example an HTTP server or SSH) listening on that Yggdrasil IPv6 socket.

### ◇ Task 5 (Stretcher): Be the CA — run the other side of the bundle

The bundle exists because somebody ran a CA and signed a certificate. Do it yourself once, in a **scratch workspace**, so the bundle stops being magic. Linux laptop or WSL; the manager never needs root for this:

```bash
curl -fsSL https://github.com/iotempire/nebula-manager/releases/latest/download/nebula-manager -o nebula-manager
chmod +x nebula-manager
./nebula-manager ca   --name LabCA --cert-dir ~/keys/lab
./nebula-manager sign --name demo1 --ip 10.99.0.1/24 --groups lighthouse --cert-dir ~/keys/lab
./nebula-manager sign --name demo2 --ip 10.99.0.2/24 --groups home       --cert-dir ~/keys/lab
./nebula-manager cert config generate --all --cert-dir ~/keys/lab
./nebula-manager cert bundle demo2 --out ~/Downloads
./nebula-manager cert list --cert-dir ~/keys/lab      # expiry, groups, IPs
```

*(The menu does the same: run `./nebula-manager` with no arguments.)*

Then answer, in three sentences each:

1. What did the CA actually sign, and which file must never leave your machine?
2. What does the **bundle** contain that the certificate alone does not — and why does that make the archive a credential?
3. The instructor revokes one node. What does “revoked” mean here, and why is that cheaper than deleting a VPN account?

> **Never use this scratch CA for anything real, and never commit `~/keys/lab`.** Delete it when you are done — the exercise is the artifact, not the key.

## ✅ Suggested portfolio evidence (proofs of the learning goals)

1. Tool Selection Matrix: Compare Port Forwarding, Nebula, Yggdrasil, and B.A.T.M.A.N. advanced across: central infrastructure required, NAT traversal, encryption model, layer, and suitability for remote vs. local coverage. (Extend the table from Part C with your own observations.)
2. Remote-Access Proof: Terminal screenshot showing your laptop on an external network (e.g. mobile hotspot) with a successful `ping` and `ssh` session to your OpenWrt router via its Nebula IP (`10.100.0.x`). Say **which path** you used (router / Windows / Linux) and what you had to do that the bundle did not do for you.
3. *(Optional)* Mesh Routing Artifacts: Capture `batctl n` and `batctl o` output showing your router's multi-hop neighbors, plus a `batctl traceroute` across the room.
4. *(Optional)* Failover Experiment Report: Describe what happened during the link drop: how many pings/packets were lost before B.A.T.M.A.N. converged on the alternate route?
5. Deeper question: Why can `batman-adv` give you a flat subnet across the room, while Nebula/Yggdrasil are needed to reach a device across the Internet? Which one would your final project use — and why?


> [!IMPORTANT]
> Never commit **bundles**, credentials, private keys, or certificates — an archive containing a `.key` file *is* a credential, even if it is “just” for a class mesh. Where you did not work entirely alone, link your pod mates and sources.

## 📚 If you want to go deeper

- [Nebula documentation](https://nebula.defined.net/docs/) — lighthouses, certificates, and firewall rules.
- [nebula-manager](https://github.com/iotempire/nebula-manager) — the class CA and bundle tool: [client bundles & installers](https://github.com/iotempire/nebula-manager/blob/main/docs/bundles.md), [certificates & workspaces](https://github.com/iotempire/nebula-manager/blob/main/docs/certificates.md).
- [Yggdrasil documentation](https://yggdrasil-network.github.io/) — cryptographic addressing and tree routing.
- [OpenWrt batman-adv](https://openwrt.org/docs/guide-user/network/wifi/mesh/batman) — the Layer-2 mesh stretcher.
- [NAT traversal](https://en.wikipedia.org/wiki/NAT_traversal) and [UDP hole punching](https://en.wikipedia.org/wiki/UDP_hole_punching) — why overlays work where port forwarding fails.

---

[← Previous: Module 2](./02-local-networking-and-gateways.md) | [Back to front page](../README.md) | [Quick module index](./00-index.md) | [Next: Module 4 — MQTT Deep Dive & Integration →](./04-mqtt-and-integration.md)
