# Module 3 – Mesh & Overlay Networks: Nebula, Yggdrasil & B.A.T.M.A.N.

[← Back to Module 2](./02-local-networking-and-gateways.md) | [Quick module index](./00-index.md) | [Next: Module 4 →](./04-mqtt-and-integration.md)

**Course placement:** Day 3 — the overlay and mesh challenge. The core is Nebula remote access; Yggdrasil and the B.A.T.M.A.N. Layer-2 mesh are stretchers if time, routers, and interest allow.

## 🎯 Learning Goals

This module gives you the opportunity to explore extending a network beyond a single router and achieve competency in NAT traversal and remote access with the Nebula overlay and the Yggdrasil IPv6 mesh, plus the concepts of Layer-2 router meshes and self-healing failover.

By the end of this module, you can:
1. Explain why classical port forwarding fails under Carrier-Grade NAT (CGNAT), DS-Lite, and campus/enterprise firewalls.
2. Deploy Nebula, a peer-to-peer overlay with lighthouse discovery and UDP hole punching — from a class **bundle** onto a router or a laptop, and explain what the certificate, the key, and the config each do.
3. Evaluate Yggdrasil, a self-arranging, cryptographically addressed IPv6 mesh.
4. Distinguish a Layer-3 overlay (Nebula/Yggdrasil) from a Layer-2 router mesh (B.A.T.M.A.N. advanced) and choose the right tool for local vs. wide-area coverage.
5. *(Optional stretch)* Configure an **OpenWrt 802.11s + `batman-adv`** mesh across several routers, inspect it with `batctl`, and observe self-healing rerouting under live traffic.

**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 🎬 Opening the Challenge

**The day starts with the sculpture, not a slide.** Module 2 gave you a gateway; today you make it reachable without asking anyone to open a port. The opening runs in five quick beats:

1. **Pre-study check-in.** In your pod, show one artefact from Module 2 — the router baseline, a capture, or the port-forward note — and name one question you still have. Park the questions on the board.
2. **Confirm the pod and the roles.** Rotate: one drives the bundle install, one drives the terminal, one keeps the topology and the notes. Swap after each round.
3. **Collect the hardware and the bundle.** One OpenWrt router per pod with the **USB stick and extroot from Module 2**, laptops with campus/mobile connectivity, and one **bundle per pod** from the instructor. For the optional mesh, 3–6 routers share a Wi-Fi channel.
4. **Draw the two networks.** Sketch the underlay (museum firewall, campus, home, mobile) and the overlay (virtual addresses, lighthouse, peers). Mark where the bundle sits and which device is the gateway. You will correct it all day.
5. **Skim the studio, do not start.** Read the challenge and the round table, then skim the theory boxes and the evidence list. Find **where the cross-NAT test happens** and **where the bundle is a credential**. Then start Round 1.

Before you touch the bundle, answer these three in one sentence each — they are the questions the day will answer:

- Why does a port forward fail when the router is behind CGNAT or a campus firewall?
- What does an overlay add that a VPN account or a dynamic-DNS service does not?
- When is a Layer-2 mesh the right tool, and when is it the wrong one?

### Your portfolio entry for today — sections, not files

Everything from today goes into **`Module03/README.md`** as sections. Split something into its own file only when a section outgrows the page.

- `## Overlay plan` — the topology sketch, the tool choice, the overlay addresses, and the lighthouse.
- `## Study log` — the running log: the theory you actually needed, the commands that surprised you, and the LLM answers you checked. Not an essay, and not a separate study phase.
- `## Discussion log` — one line per discussion: who listened, what they asked, what you changed. This is personal.
- `## Bundle notes` — what the bundle contains, where it is installed, and what you had to do that the bundle did not. **No keys, no certificates, no config with credentials.**
- `## Remote-access proof` — the ping/ssh/mosquitto output from an external network, and the path you used.
- `## Mesh notes` — optional: `batctl` output, the failover observations, or the Yggdrasil peer list.
- `## Story seeds` — optional: the odd bits worth turning into a story later.

*One pod member keeps the shared `## Study log`; the others link to it from their own `Module03/README.md` and add one sentence on what they took from it. The `## Discussion log` is yours alone.*

### The bundle contract

The bundle is a credential, and one of you will install it. Agree before you start:

- **One archive per pod.** Never a shared archive: each bundle contains one private key.
- **The archive is a credential.** Keep it out of Git, chat, screenshots, and the portfolio. Delete it from the download folder after installing.
- **Two bundles are normal.** A router bundle and a laptop bundle are two separate nodes with two overlay addresses. That is not a mistake.
- **If it leaks, say so.** The instructor re-signs one certificate; that is cheaper than a password reset for everybody.

## 📖 The Challenge — The Exhibition Across the City

**Lumenwerk Gütersloh GmbH** has installed an interactive light sculpture in a partner museum on the other side of town. Creative director **Mara Voss** needs to update the animation and read the sensor logs without driving over, and the museum's network is behind a campus firewall: no public IP, no inbound ports, no cooperation from the IT department.

Technician **Jonas Feld** tries port forwarding, then a dynamic-DNS service, then gives up. Mara asks the question that motivates today: *"How do we give the sculpture its own private network address without asking anyone to open a hole in their firewall?"*

**Your challenge.** Give the sculpture a private address without opening a port, prove you can reach it from outside, and choose the right tool for the room as well as for the city. You are done when you can show:

1. A tool-selection matrix with a justified choice for the wide-area case and the local case.
2. A Nebula node joined from a class **bundle** — on the router or a laptop.
3. A cross-NAT proof: `ping`, `ssh`, or `mosquitto_sub` to the overlay address from an external network.
4. An explanation of the bundle's credential model: which file is the private key, what the CA signed, and what revocation means.
5. *(Optional stretch)* A B.A.T.M.A.N. mesh with `batctl` evidence and a live failover, a Yggdrasil IPv6 ping, or a scratch CA that signs its own bundle.

**Constraints.** One router per pod with the extroot from Module 2. 16 MB of flash. One Wi-Fi adapter per laptop. No public IP and no inbound port. The bundle is a credential. The manager UI never runs as root; on OpenWrt it does not run at all.

**This story is unfinished on purpose.** The hooks below are starting points, not a script. Pick the ones that match what you actually saw, and add a line of your own — *"and the museum's captive portal ate the UDP hole punch"* is worth more than a perfect diagram. Collect those lines under `## Story seeds` and use them in a discussion or the harvest.

## 🧭 How this studio works now

**The study is folded into the practice.** There is no separate pod-study phase and no scheduled hand-off to another pod. Each round gives you a small thing to do, a short **Theory you need** box you read only when the task makes you want it, and a **discussion** at the end. Keep your notes in `Module03/README.md` under `## Study log` — a running log, not an essay.

**First: skim, do not start.** Read the challenge and the round table, then skim the theory boxes and the evidence list. You are looking for two things: **where the cross-NAT test happens** and **where the bundle becomes a credential**. Then start Round 1.

**Every round ends with a discussion — one person is enough.** Ask someone at the nearest pod if they have a moment; show them the round's artefact and ask the discussion question. If they want, let them show you theirs and ask you one question back. **This is a brag, not a quiz**: you are showing what works and inviting one question. Write one line in `## Discussion log`: who listened, what they asked, what you changed. If nobody is free, ask someone else or come back later — do not wait.

**Take a study break when a box is not enough.** Read the linked source, then explain it to one person. Explaining is the test, not reading. You do not need permission; take the break when the task makes you want it.

The table is the discussion map: the **[Goal](#-learning-goals) · theory box** column names what each discussion checks. The question tests understanding, not task completion.

| # | Round | You produce | [Goal](#-learning-goals) · theory box | Discussion question for one person |
|---|---|---|---|---|
| 1 | **Pick the tool** | A filled tool matrix and a one-sentence choice for each scope | G1–G4 · Pick the tool | "Which tool for the sculpture, and which for the room? Why?" |
| 2 | **Join the overlay** | A node with an overlay address and bundle notes | G2 · Join the overlay | "What is in the bundle, and which file is the credential?" |
| 3 | **Cross the NAT** | A ping/ssh/mosquitto proof from an external network | G2 · Cross the NAT | "What did the lighthouse do, and what did it not do?" |
| ◇ | **Gateway** | A LAN client reaching the overlay through the router | G2 · Gateway | "What did you have to allow?" |
| ◇ | **Mesh** | `batctl n`/`batctl o` across the room | G4 + G5 · B.A.T.M.A.N. | "What does `bat0` hide from the IP layer?" |
| ◇ | **Failover** | A stream that survives an intermediate router drop | G4 + G5 · Live failover | "How many packets did convergence cost?" |
| ◇ | **Yggdrasil** | A `200::/7` ping to another pod | G3 · Yggdrasil | "Where does the address come from?" |
| ◇ | **Be the CA** | A scratch CA and a bundle you signed | G2 · Be the CA | "What does revocation mean?" |

**The order is a suggestion.** The rounds are a path, not a timetable. If the bundle install fails, switch to another path (router, Windows, Linux) and come back; if you finish early, take a stretcher. **The instructor demos the bundle import and one cross-NAT test live on the beamer** — ask for the demo you need. Rotate roles after each round; everybody should install or test at least one piece. The question you should always be able to answer is *"what did you choose, and what did it cost you?"*

## 🛠️ The Studio: Three Networks — **Challenging**

*Hardware:* 1× OpenWrt router per pod (with the **USB stick and extroot** from Module 2) + laptops with a connection to the university/mobile network. For the optional mesh, the class connects 3–6 routers into a shared multi-hop mesh.

### ★ Round 1: Pick the tool

Fill the matrix for the two scopes — **the sculpture across the city** and **the routers in the room** — and write one sentence per choice. Ask an LLM for its comparison, then check it against the table and your own constraints.

| | Port Forwarding | Nebula | Yggdrasil | B.A.T.M.A.N. adv *(optional)* |
|---|---|---|---|---|
| Layer / model | Layer 3/4 (NAT rule) | Layer 3 overlay | Layer 3 overlay (IPv6) | Layer 2 mesh |
| Scope | One exposed service | Wide-area, P2P | Wide-area, P2P | Local / campus |
| Works behind CGNAT / firewall? | No | Yes (hole punching) | Yes (outbound peers) | N/A (must be link-local) |
| Addressing | Static/leased public IP | Fixed virtual IP per cert | Key-derived `200::/7` IPv6 | Flat Ethernet `bat0` |
| Encryption | Depends on service (TLS) | Yes (Noise Protocol) | Yes (end-to-end) | No (add your own, e.g. TLS) |
| Infrastructure needed | Upstream NAT access | Lighthouse (1 node) | At least one reachable peer | Wi-Fi coverage + 802.11s |
| Best for | Quick one-off demo | Remote access to your gateway | Decentralized class mesh | Multi-hop coverage across rooms |

**Theory you need.** In Module 2 you forwarded a port on your local router. In real life that fails for three reasons: **CGNAT/DS-Lite** (many households share one public IPv4 address), **campus/enterprise firewalls** (inbound ports are blocked), and **dynamic WAN addresses** (the target changes). An **overlay** builds a virtual Layer-3 network on top of the underlay:

```text
Underlay (physical / Internet):
[Student laptop at home] ---> [Home NAT] ---> (Public Internet) <--- [Campus firewall] <--- [OpenWrt gateway]
                                                       |
                                            (direct connection blocked)

Overlay (Nebula / Yggdrasil):
[Virtual IP 10.100.0.5] ================= encrypted tunnel ================= [Virtual IP 10.100.0.1]
```

**Nebula** is a mutually authenticated peer-to-peer mesh. A **lighthouse** is a node with a stable public address; it is a directory, not a relay: it tells peers each other's current public `ip:port` so they can punch a UDP hole and talk directly. Every node has a certificate signed by a private CA, a fixed overlay IP, and firewall rules. The deployment unit is a **node = certificate + private key + config** — the bundle.

**Yggdrasil** is a decentralized, zero-configuration encrypted IPv6 mesh. Addresses are derived from public keys in `200::/7`; peers form a self-healing spanning tree over TCP, TLS, or link-local Wi-Fi.

**B.A.T.M.A.N. advanced** is a Layer-2 mesh: a Linux kernel module that presents a virtual Ethernet switch (`bat0`) to the OS. Every router in the mesh looks like it is plugged into the same switch, so one flat subnet works across many hops. It is for the room, not the city. *Go deeper: the Nebula, Yggdrasil, and OpenWrt batman-adv docs; the NAT-traversal article.*

> **Discussion — show one person.** Ask someone at the nearest pod if they have a moment. Show them your matrix and ask: *"Which tool for the sculpture, and which for the room? Why?"* If they want, let them show you theirs and ask you one question back. Write one line in `## Discussion log`.

> **Story hook.** *Mara's question.* She does not want a VPN account for every device, and she cannot ask the museum to open a port. She wants the sculpture to have its own address — and to be able to revoke one machine without changing everybody's password.

*Portfolio evidence:* the filled matrix with the two choices and one sentence of justification each.

### ★ Round 2: Join the overlay — the bundle, not a ceremony

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
- **Survives a reboot?** Not yet — an initscript is the difference between a demo and a gateway. That is a good stretcher (see Stretch 1).

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

**Theory you need.** The **certificate** proves the node's identity and fixed overlay IP; the **private key** is the secret that makes the certificate usable; the **config** says which lighthouse to ask, which groups to join, and which firewall rules apply. The **CA** signed the certificate; the CA **key** never leaves the instructor's machine. The **lighthouse** is a directory: it tells peers how to reach each other, but it does not relay their traffic. On the router, `nebula1` is the virtual interface; the 16 MB flash is why the binary lives on the extroot stick, not in a package. *Go deeper: the Nebula docs and the bundle cheat sheet in the resource bank.*

> **Discussion — show one person.** Ask someone at the nearest pod if they have a moment. Show them `ip -brief addr show nebula1` and your bundle notes, and ask: *"What is in the bundle, and which file is the credential?"* If they want, let them show you theirs and ask you one question back. Write one line in `## Discussion log`.

*Portfolio evidence:* the bundle notes (what it contains, where it is installed, what you had to do that the bundle did not), the `nebula -test` result, and the overlay address. **No key material, no certificate contents.**

### ★ Round 3: Cross the NAT — prove no hole was needed

Now prove that a hole in a firewall was never needed:

1. Disconnect your laptop from the lab router and use your phone's hotspot or eduroam. Both ends are now behind different firewalls.
2. Ping your node's overlay IP (from its README — e.g. `10.100.0.10`):
   ```bash
   ping 10.100.0.10
   ssh root@10.100.0.10
   mosquitto_sub -h 10.100.0.10 -t 'test/#' -v
   ```
3. *Success:* secure, direct, bidirectional access to your gateway from a network that would never accept an inbound connection.

**Theory you need.** Both peers are behind NAT, so neither can accept an unsolicited inbound connection. The lighthouse is reachable, so each peer tells it its current public `ip:port`; the peers then send outbound UDP packets to each other at the same time, which creates the NAT mappings in both directions — **UDP hole punching**. Once the mapping exists, traffic is direct and encrypted; the lighthouse is out of the path. That is why the test works from a phone hotspot and why the museum's firewall never needs a rule. *Go deeper: the NAT-traversal and UDP-hole-punching articles.*

> **Discussion — show one person.** Ask someone at the nearest pod if they have a moment. Show them the external-network terminal and ask: *"What did the lighthouse do, and what did it not do?"* If they want, let them show you theirs and ask you one question back. Write one line in `## Discussion log`.

> **Story hook.** *The museum's firewall never opened.* Mara's laptop is on a hotel Wi-Fi, the sculpture is behind the museum's campus firewall, and the two still talk. The proof is a `ping` and an `ssh` prompt, not a network diagram.

*Portfolio evidence:* a terminal screenshot from the external network with the successful `ping`/`ssh`/`mosquitto_sub`, the path you used, and one sentence on what the bundle did **not** do for you.

### ◇ Stretch 1: Make the router a gateway

Joining from the router gives the *router* an overlay address. If the devices **behind** it should reach the overlay too, enable forwarding and give `nebula1` a firewall zone (input `reject`, forward `accept`, masquerading off) — that is the step that turns "my router is on the mesh" into "my substation is on the mesh".

**Theory you need.** A router with an overlay address is a **node**; a router that forwards between its LAN and the overlay is a **gateway**. Forwarding is a kernel setting plus a firewall zone; the zone must allow forward traffic but not input. Masquerading is off because the overlay address is already routable inside the overlay — you are routing, not hiding behind another NAT. *Go deeper: the OpenWrt firewall and forwarding docs.*

> **Discussion — show one person.** Show a LAN client reaching the overlay and ask: *"What did you have to allow?"* Write one line in `## Discussion log`.

*Portfolio evidence:* the forwarding/zone configuration and the LAN-client test.

### ◇ Stretch 2: Build the class mesh with B.A.T.M.A.N. advanced

Work in pairs. The classroom becomes a single multi-hop mesh — coordinate mesh IDs and channels with your neighbors!

1. **Install & enable `batman-adv`:**
   ```bash
   ssh root@192.168.14.1
   opkg update
   opkg install kmod-batman-adv batctl-default
   lsmod | grep batman
   ```
2. **Configure the 802.11s wireless mesh interface.** Edit `/etc/config/wireless` (or use LuCI under Network → Wireless → Add):
   ```text
   config wifi-iface 'mesh0'
       option device 'radio0'
       option mode 'mesh'
       option mesh_id 'hsbi-iot-mesh'
       option network 'batman_mesh'
       option encryption 'none'
   ```
   Bind the mesh interface to `bat0` in `/etc/config/network` and bridge it into your LAN:
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
   Restart networking:
   ```bash
   /etc/init.d/network restart
   ```
3. **Visualize the mesh with `batctl`.** Once 3 or more student routers are active:
   - Direct neighbors: `batctl n` — directly reachable 1-hop routers with signal quality and latency.
   - Originator routing table: `batctl o` — all nodes across the multi-hop mesh and the best next-hop MAC address to reach them.
   - Trace multi-hop paths: `batctl traceroute <target_mac>` — watch packets hop across intermediate student routers.

**Theory you need.** `batman-adv` runs at Layer 2 as a kernel module. It presents a virtual Ethernet switch, `bat0`; to the OS, DHCP, and applications, every mesh node looks like it is on the same physical switch. That is why one flat subnet (`192.168.14.0/24`) works across many hops without routing tables on every node. Routers send **Originator Messages (OGMs)** and pick the best next hop by transmit quality (TQ).

```text
       [Router 1 (Team A)] <--- 802.11s mesh ---> [Router 2 (Team B)]
               ^                                           |
               |                                           |
       802.11s mesh                                   802.11s mesh
               |                                           |
               v                                           v
       [Router 4 (Team D)] <---------------------> [Router 3 (Team C)]

  All routers form a unified virtual Layer-2 switch: "bat0"
  Devices connected to any router share the same broadcast domain!
```

`batman-adv` and ESP-NOW (Module 5) share the same superpower: they move routing/adjacency decisions down the stack so the layers above do not have to care. *Go deeper: the OpenWrt batman-adv docs.*

> **Discussion — show one person.** Show `batctl n` and `batctl o` and ask: *"What does `bat0` hide from the IP layer?"* Write one line in `## Discussion log`.

*Portfolio evidence:* the `batctl n`/`batctl o` output and one sentence on what the flat Layer-2 view buys you.

### ◇ Stretch 3: The live failover test

Because this session runs *before* the MQTT module, we test resilience at the network level — which is exactly where routing decisions are made anyway. We will re-run the same experiment *with* MQTT traffic in the final project studio (Module 8).

1. Start a continuous stream across the mesh: `ping <remote-node>` or `iperf3 -c <remote-node>` to a router on the other side of the room.
2. Simulate a link failure: have the intermediate relay router (Team B) abruptly unplug from power.
3. **Observe `batman-adv` react:**
   - Watch `batctl o` immediately detect the missing OGMs.
   - Traffic dynamically re-routes through a different neighbor.
   - Notice that the flat Layer-2 subnet and any TCP sessions it carried survive the reroute without re-addressing.

**Theory you need.** OGMs are periodic; when they stop, neighbors mark the originator as unreachable and choose the next-best path. Because the mesh presents a flat Layer-2 domain, the IP addresses do not change when the path changes; TCP can retransmit and survive. That is the difference between **rerouting** (Layer 3) and **self-healing at Layer 2**. *Go deeper: the batman-adv docs; re-run the test with MQTT in Module 8.*

> **Discussion — show one person.** Show the stream and the `batctl o` change, and ask: *"How many packets did convergence cost?"* Write one line in `## Discussion log`.

*Portfolio evidence:* the failover observations: how many packets were lost, how `batctl o` changed, and whether the TCP session survived.

### ◇ Stretch 4: Exploring decentralized mesh with Yggdrasil

Do this if you finish the core rounds early, or as homework/stretcher practice.

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

**Theory you need.** Yggdrasil derives the IPv6 address from the node's public key, so the address **is** the identity; there is no certificate authority and no assignment. Peers connect outbound over TCP, TLS, or link-local Wi-Fi and form a spanning tree; packets route greedily along the tree and the tree re-forms when a peer disappears. That is a different trade from Nebula: no CA and no fixed address assignment, but also no per-node policy from a central authority. *Go deeper: the Yggdrasil docs.*

> **Discussion — show one person.** Show the `200::/7` ping and ask: *"Where does the address come from?"* Write one line in `## Discussion log`.

*Portfolio evidence:* the `yggdrasilctl getPeers` output and the IPv6 ping to another pod.

### ◇ Stretch 5: Be the CA — run the other side of the bundle

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
3. The instructor revokes one node. What does "revoked" mean here, and why is that cheaper than deleting a VPN account?

**Theory you need.** The CA signs a certificate that binds a public key to an overlay IP and a group. The **CA private key** is the root of trust and never leaves the machine that runs the CA. A **bundle** packages the certificate, the node's private key, the CA certificate, and a config/installer; the private key is why the archive is a credential. **Revocation** means the node's certificate is no longer trusted (or is re-signed); it is one certificate, not a shared password change. *Go deeper: the nebula-manager certificates and bundles docs.*

> **Discussion — show one person.** Show your scratch CA and ask: *"What does revocation mean?"* Write one line in `## Discussion log`.

> **Never use this scratch CA for anything real, and never commit `~/keys/lab`.** Delete it when you are done — the exercise is the artifact, not the key.

*Portfolio evidence:* the three answers and the `cert list` output (no keys).

## 🤖 Ask an LLM — then verify

Use these when a theory box is not enough. Treat every answer as a **claim to test**, not a fact, and run it against your own overlay.

- "Explain why port forwarding fails behind Carrier-Grade NAT and a campus firewall. What does an overlay do differently?"
- "How does Nebula's lighthouse help two peers behind different NATs establish a direct tunnel? Does the lighthouse relay the traffic?"
- "How does Yggdrasil derive an IPv6 address from a public key, and what does the spanning-tree routing do when a peer disappears?"
- "Compare a Layer-3 overlay (Nebula/Yggdrasil) with a Layer-2 mesh (batman-adv). Give one use case where each is the right tool."
- "What happens if a Nebula certificate or private key leaks? How does the CA isolate the compromise?"

Record where the model is wrong, vague, or over-confident in `## Study log`.

## 🔁 Optional: the harvest — collect curiosities, swap lists

> **Optional and ungraded.** The full ritual is in [Module 1](./01-foundations-and-masterclass.md#harvest); run the short version here.

As you work, mark the odd bits: a bundle that installed but never got an address, a lighthouse that was reachable but a peer that was not, a `batctl o` entry that pointed at the wrong neighbor, a Yggdrasil peer that never appeared. Put a `?` in the margin or a line under `## Story seeds`. At the break and at the end, swap lists with one person at another pod: briefly, no explaining, every entry gets a source. Anything two pods collected, or that nobody can place, goes to the course channel. The list is the artefact; the conversation is the point.

## ✅ Suggested portfolio evidence (proofs of the learning goals)

This is a **suggestion, not a checklist** — the learning goals are the contract. A convincing subset, or a better artefact you design yourself, is worth more than a ticked list.

1. **Tool selection (goals 1 and 4):** the filled matrix with the wide-area and local choices and one sentence of justification each.
2. **Overlay deployment (goal 2):** the bundle notes, the `nebula -test` result, `ip -brief addr show nebula1`, and the overlay address. **No key material.**
3. **Remote access (goal 2):** the ping/ssh/mosquitto proof from an external network, the path you used, and what the bundle did not do for you.
4. **Credential model (goal 2):** one paragraph naming the certificate, the private key, the CA, and what revocation means.
5. **Optional mesh (goals 4 and 5):** `batctl n`/`batctl o`/`batctl traceroute`, the failover report, or the Yggdrasil peer/ping output.
6. **Optional CA (goal 2):** the three scratch-CA answers and the `cert list` output.
7. **The running log and discussions:** your `## Study log` with the theory you actually needed, plus `## Discussion log` — one line per discussion: who listened, what they asked, what you changed.
8. **Deeper question:** why can `batman-adv` give you a flat subnet across the room, while Nebula/Yggdrasil are needed to reach a device across the Internet? Which one would your final project use — and why?

> [!IMPORTANT]
> Never commit **bundles**, credentials, private keys, or certificates — an archive containing a `.key` file *is* a credential, even if it is "just" for a class mesh. Where you did not work entirely alone, link your pod mates and sources.

## 📚 If you want to go deeper

- [Nebula documentation](https://nebula.defined.net/docs/) — lighthouses, certificates, and firewall rules.
- [nebula-manager](https://github.com/iotempire/nebula-manager) — the class CA and bundle tool: [client bundles & installers](https://github.com/iotempire/nebula-manager/blob/main/docs/bundles.md), [certificates & workspaces](https://github.com/iotempire/nebula-manager/blob/main/docs/certificates.md).
- [Yggdrasil documentation](https://yggdrasil-network.github.io/) — cryptographic addressing and tree routing.
- [OpenWrt batman-adv](https://openwrt.org/docs/guide-user/network/wifi/mesh/batman) — the Layer-2 mesh stretcher.
- [NAT traversal](https://en.wikipedia.org/wiki/NAT_traversal) and [UDP hole punching](https://en.wikipedia.org/wiki/UDP_hole_punching) — why overlays work where port forwarding fails.
- The [resource bank's Nebula bundle cheat sheet](./Z-resources-bank.md#nebula-bundles--the-class-ca) and [networking snippets](./Z-resources-bank.md#networking-snippets-copypaste).

---

[← Previous: Module 2](./02-local-networking-and-gateways.md) | [Back to front page](../README.md) | [Quick module index](./00-index.md) | [Next: Module 4 — MQTT Deep Dive & Integration →](./04-mqtt-and-integration.md)
