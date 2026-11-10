# Module 2 – Local Networking, TCP/IP & OpenWrt Gateways

[← Back to Module 1](./01-foundations-and-masterclass.md) | [Quick module index](./00-index.md) | [Next: Module 3 →](./03-overlay-and-mesh-networks.md)

**Course placement:** Day 2 — the edge-router studio. You flash the router, join an upstream, build the pod LAN, run a local broker, and capture packets at the choke point.

## 🎯 Learning Goals

This module gives you the opportunity to explore TCP/IP at the network edge and achieve competency in **IPv4 addressing and subnetting, DHCP/DNS/NAT, OpenWrt administration, and packet capture at the choke point with `tcpdump`** (read in Wireshark when it is available).

By the end of this module, you can:
1. Configure IPv4 addressing, CIDR subnetting, default gateways, and routing tables.
2. Inspect and diagnose the core IP plumbing services: ARP, DHCP (DORA), DNS, and NAT.
3. Flash, configure, administer, and secure an OpenWrt edge router via SSH and the LuCI web interface — from factory firmware to a working pod LAN with a WAN uplink (eduroam, phone tether, or lab wire).
4. Capture traffic at the choke point with `tcpdump` on the router, and read the dump with Wireshark, `tshark`, or as text — without needing a second network adapter.

**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 🎬 Opening the Studio

**The day starts at the router, not at a slide.** Module 1 gave you the continuum; today you make the edge real. The opening runs in four quick beats:

1. **Pre-study check-in.** In your pod, show one artefact from Module 0 or Module 1 — the packet-path sketch, the `traceroute`, or the MQTT screenshot — and name one question you still have. Park the questions on the board.
2. **Confirm the pod and the roles.** You will rotate: one drives LuCI, one drives the terminal, one keeps the network map and photos. Swap after each task. After the OpenWrt flash, the router stays at `192.168.1.1` until Task 4; use that address for the first three tasks.
3. **Collect the hardware.** One Cudy TR1200 v1 with factory firmware, one USB stick (> 4 GB), one mini USB hub, two laptops, one phone, Ethernet cables, and one M5StickC (optional client). Label the router and the stick with your pod ID.
4. **Draw the network you are about to build.** Before you touch the router, sketch the upstream (eduroam 5 GHz, phone tether, or the class B1300 wire), the router's WAN and LAN sides, the 2.4 GHz AP, and at least one client. You will correct the sketch all day; that is the point.

### Your portfolio entry for today — sections, not files

Everything from today goes into **`Module02/README.md`** as sections. Split something into its own file only when a section outgrows the page.

- `## Network plan` — the sketch, the subnet calculation, the SSID/channel, and the pod ID.
- `## Router baseline` — model, OpenWrt version, LAN/WAN addresses, MACs, SSH access, extroot status, broker status, open ports. **No passwords, no eduroam credentials.**
- `## Study log` — the pod study below (Task A) and your *Agreed learning* note (Task B).
- `## Captures` — the pcap or the `tshark`/`tcpdump -A` text, and what each protocol proves.
- `## NAT and port forwarding` — the rule, the two-sided capture, and the explanation.
- `## Take it home` — the upstream switch and the evidence that the router still works.
- `## Story seeds` — optional: the odd bits worth turning into a story later.

*One pod member keeps the shared `## Study log`; the others link to it from their own `Module02/README.md` and add one sentence on what they took from it.*

### The pod router contract

The router is a shared piece of infrastructure, and one of you will put a personal eduroam credential on it. Agree before you start:

- **Whose eduroam account?** That person consents; the credential is stored on the router; the pod does not publish the config, a backup, or a screenshot that contains it. Remove the credential or reset the router at the end of the course.
- **Who carries the router?** The router and its USB stick travel together. The stick is part of the router; label it and keep it in.
- **Which upstream?** Prefer eduroam on 5 GHz. If that fails, use phone USB tethering or the class B1300 wire. The learning goal is the same; the path is negotiable.

## 📖 Story — The Substation Behind the Router

**Stadtwerke Gütersloh** is connecting a district-heating substation to the control room. Field engineer **Malik Yilmaz** has a Cudy router still in its box, a USB stick, two M5Stack nodes, and a laptop. The campus uplink is **eduroam on 5 GHz**; the sensors only speak **2.4 GHz**. Malik flashes OpenWrt, moves the root filesystem to the stick, joins the campus uplink, and builds a `192.168.14.0/24` LAN with a local Mosquitto broker. The dashboard works from the laptop on the LAN — but the control room cannot reach the nodes, and Malik cannot see why.

Petra Sommer's question is precise: *"Which address is which, who is allowed to initiate the connection, and where can I prove it?"* Today you take the router from factory firmware to a working pod gateway: subnetting, DHCP/DNS/NAT, OpenWrt's UCI, a local broker, and a live `tcpdump` capture at the choke point.

**This story is unfinished on purpose.** The hooks below are starting points, not a script. Pick the ones that match what you actually saw, and add a line of your own — *"and the phone never got a lease because the AP was still on channel 6"* is worth more than a perfect diagram. Collect those lines under `## Story seeds` and use them in the pod share.

## 📖 Pod Study: TCP/IP at the Edge

This is **self/pod study, not a lecture.** Work through the concepts below with your Task Pod, look things up, ask an LLM, and keep notes — the goal is a shared mental model you can defend.

### Warm-up (with your pod)

Before reading on, answer these in one sentence each:

- What must a client have before it can send a packet to `1.1.1.1` through your router?
- Why does the router need a WAN address *and* a LAN address? Which one does the laptop see?
- Your phone joins the pod Wi-Fi. Which device assigns its address, and how does the phone find it?

### 1. Subnetting & Private Address Spaces (RFC 1918)

In IoT edge networks, devices operate in private address blocks:
- `10.0.0.0/8`
- `172.16.0.0/12`
- `192.168.0.0/16`

The class standard is **`192.168.14.0/24`** (the IoTempower convention), with the router at `192.168.14.1`. Do not use the OpenWrt default `192.168.1.1` in this lab: an upstream network may already use it, and the point is to make the addressing a decision.

CIDR refresher:
- `/24` = `255.255.255.0` (254 usable host addresses)
- `/26` = `255.255.255.192` (62 usable host addresses)
- `/28` = `255.255.255.240` (14 usable host addresses)

If two IoT nodes have the IP `192.168.14.10/24` and `192.168.15.10/24`, can they communicate directly at Layer 2? No; their traffic must cross a router (Layer 3) that knows how to route between subnets.

### 2. The Core Edge Services

- **ARP (Address Resolution Protocol):** resolves an IP address (Layer 3) to a physical MAC address (Layer 2). Without ARP, an Ethernet or Wi-Fi frame cannot be addressed to a physical destination.
- **DHCP (Dynamic Host Configuration Protocol):** assigns IP, subnet mask, gateway, and DNS servers via the DORA sequence (Discover → Offer → Request → Acknowledge).
- **NAT (Network Address Translation / masquerading):** lets dozens of private IoT devices behind the router share one upstream WAN address by mapping TCP/UDP ports.
- **DNS (Domain Name System):** translates human-readable names to IPs. OpenWrt's `dnsmasq` serves DHCP leases and forwards DNS to the upstream. Local names under `.lan` come from DHCP; **mDNS** (`openwrt.local`, `node1.local`) needs `umdns` or Avahi and is not guaranteed on a fresh router — test it before you promise it.

### 3. The Vocabulary the Module Handbook Expects

The module handbook names classic networking terms that you will meet in the labs but rarely find in one place. This table is a reference dictionary, not a second lecture: the OSI model is the dictionary, and this is the index.

| Term | Meaning | Where you meet it |
|---|---|---|
| Transmission media | Copper twisted pair, fiber, radio | Ethernet LAN port, 2.4/5 GHz Wi-Fi, RS-485 in Module 6 |
| Line codes / modulation | How bits become symbols on the medium (NRZ, Manchester, OFDM) | Module 5 radio; the lab measures behavior, not the code |
| Serial vs. parallel | Bits one after another on one wire vs. several wires at once | RS-485/UART vs. parallel buses; Module 6 |
| Synchronous vs. asynchronous | A shared clock vs. start/stop framing | Wi-Fi/ESP-NOW vs. UART/RS-485; Modules 5/6 |
| Simplex / half-duplex / full-duplex | One way / both ways one at a time / both ways at once | RS-485 half-duplex, Ethernet full-duplex, Wi-Fi shared medium |
| Topology | Bus, star, ring, mesh | Pod LAN star, B.A.T.M.A.N. mesh, MQTT star |
| MAC addressing / ARP | Layer-2 address and IP-to-MAC resolution | Module 2 capture; `ip neigh` |
| Collision domain / broadcast domain | Where frames can collide / where broadcasts reach | Ethernet switch vs. router; `br-lan` vs. WAN |
| Error detection | FCS/CRC checks; a bad frame is dropped | Ethernet FCS, Modbus CRC16 (Module 6) |
| CSMA/CD vs. CSMA/CA | Collision detection (wired Ethernet) vs. collision avoidance (Wi-Fi) | Module 5 radio, Module 2 Ethernet |
| Routing / default gateway | Forwarding between subnets; longest-prefix match | Module 2 `ip route`, `ip route get` |
| Spanning Tree Protocol | Prevents Layer-2 loops in a bridged LAN | Module 3's mesh uses B.A.T.M.A.N. for multi-hop routing, not STP |
| Classful addressing vs. CIDR | Legacy fixed classes vs. prefix-based subnets | Module 2 subnetting |
| Broadcast / fragmentation | One-to-all delivery / splitting a packet to fit the MTU | DHCP broadcast, `br-lan`; MTU and Wi-Fi |
| TCP vs. UDP; flow control | Reliable stream vs. datagram; receiver window vs. congestion | MQTT/TCP, CoAP/UDP; Module 4 |
| Session / presentation / application | Session setup and teardown, data format, application protocol | MQTT session, JSON/TLS, DNS/DHCP/NTP/SSH/HTTP; SMTP/POP3/FTP are the same layer, not used in the lab |

### 4. The Router as a Travel Gateway

Your Cudy has two radios, and that is the key to today's topology:

| Radio / port | Role | Interface | Firewall zone |
|---|---|---|---|
| `radio1` — 5 GHz | Wi-Fi **client** to eduroam (or home Wi-Fi) | `wwan` | `wan` |
| `radio0` — 2.4 GHz | Wi-Fi **access point** for the pod | `br-lan` | `lan` |
| Ethernet WAN | backup uplink (class B1300 wire) | `wan` | `wan` |
| Ethernet LAN | wired pod client | `br-lan` | `lan` |

- **Consume 5 GHz, broadcast 2.4 GHz.** The uplink radio joins the campus network; the other radio serves the sensors and laptops. If the upstream is 2.4 GHz only, the STA and AP share one radio — it works, but throughput and latency suffer.
- **Eduroam is 802.1X, not a captive portal.** OpenWrt needs a full `wpad` variant (`wpad-mbedtls` or another full build), not `wpad-basic`; it cannot do EAP. It also needs a correct clock and the HSBI CA. The Cudy's 5 GHz radio does not support DFS channels; check the channel if the scan does not show the SSID.
- **Phone tethering** uses the USB port and a `usb0`/`eth1` interface; it needs the matching `kmod-usb-net-*` driver. **Ethernet WAN** is the boring, reliable fallback.
- **At home**, the same router must work on a home Wi-Fi, a phone hotspot, or a dorm Ethernet port. Check for an address overlap before you connect: if the upstream also uses `192.168.14.0/24`, change your LAN subnet.

### Pointers (start here, then keep looking)

- Private addressing — [RFC 1918](https://www.rfc-editor.org/rfc/rfc1918)
- Subnetting and CIDR — [Wikipedia: Classless Inter-Domain Routing](https://en.wikipedia.org/wiki/Classless_Inter-Domain_Routing) (and the [Practical Networking subnetting series](https://www.practicalnetworking.net/))
- DHCP — [RFC 2131](https://www.rfc-editor.org/rfc/rfc2131)
- NAT — [RFC 3022](https://www.rfc-editor.org/rfc/rfc3022)
- OpenWrt — [documentation](https://openwrt.org/docs/start), [UCI](https://openwrt.org/docs/guide-user/base-system/uci), [firewall](https://openwrt.org/docs/guide-user/firewall/firewall_configuration)
- The Cudy TR1200 — [OpenWrt device page](https://openwrt.org/toh/cudy/tr1200)
- `tcpdump` — [tcpdump manual](https://www.tcpdump.org/manpages/tcpdump.1.html), and [Wireshark](https://www.wireshark.org/docs/)
- Mosquitto — [mosquitto.conf manual](https://mosquitto.org/man/mosquitto-conf-5.html)

### Questions to ask an LLM (then verify against your network)

Ask your co-pilot — but treat every answer as a **claim to test**, not a fact. Good starting prompts:

- "Explain CIDR subnetting with a `/24` and a `/28`. Give me the network address, broadcast address, and usable host range for `192.168.14.10/24`."
- "Walk me through the DHCP DORA exchange. Which packets are broadcast, which are unicast, and which ports are used?"
- "Why can a LAN client reach the internet through NAT, but an internet host cannot initiate a connection to the LAN client without port forwarding?"
- "Explain ARP and what happens when the ARP cache is empty. How would I see the request/reply in a capture?"
- "My router consumes eduroam on 5 GHz and broadcasts a 2.4 GHz AP. Explain what each radio is doing and what changes if the upstream is 2.4 GHz only."
- "When I join eduroam from the router, what is stored on the router, and why is that a credential? How would I remove it?"

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
5. Each member adds a short **"Agreed learning (pod discussion)"** note — in the shared log, or in your own module README with a link to it.

*Portfolio evidence:* the cleaned-up `## Study log` (with the **"Agreed learning (pod discussion)"** note) and your pod-pair's shared artefact.

## 🛠️ In-Class Lab: From Factory Router to Pod Gateway — **Challenging**

*Hardware per pod:* 1× Cudy TR1200 v1 with factory firmware, 1× USB stick (> 4 GB) + mini USB hub, 2× laptops, 1× phone, Ethernet cables, 1× M5StickC (optional client), and access to eduroam, phone tethering, or the class B1300 wire.

| What | Notes |
|---|---|
| Cudy TR1200 v1 | 16 MB flash, 128 MB RAM, 2.4 + 5 GHz, 1× WAN + 1× LAN (100 Mbit/s), USB 2.0 |
| USB stick + hub | extroot for the router; label the stick with the pod ID and keep it in |
| 2 laptops | one wired on the LAN port, one on 2.4 GHz Wi-Fi |
| Phone | fresh DHCP client, or USB-tethered upstream |
| M5StickC | optional client; re-point its Wi-Fi to your pod SSID |
| Class B1300 | `192.168.114.0/24`, fallback WAN and the "outside" client for the port-forward test |

| Address / service | Value |
|---|---|
| Stock Cudy UI | `http://192.168.10.1` — user `admin`, password `admin` (check the label) |
| Intermediate OpenWrt | `http://192.168.1.1` |
| Class LAN | `192.168.14.0/24`, router `192.168.14.1` |
| Local broker | `mosquitto` on `192.168.14.1:1883`, anonymous, no TLS |
| B1300 fallback / outside | `192.168.114.0/24` |

> **The order is a suggestion.** The tasks are a path, not a timetable. If your pod's eduroam association fails, switch to phone tethering or the B1300 wire and come back; if you finish early, do the two-pod chain or the Nebula preview. **The instructor demos the risky steps live on the beamer** — flashing, extroot, the eduroam join, and one capture — so ask for the demo you need instead of waiting with a broken step. Rotate roles after each task; everybody should flash or configure at least one piece. The question you should always be able to answer is *"what did you choose, and what did it cost you?"*

### ★ Task 1: Flash OpenWrt — from factory to your router

1. **Verify the hardware.** The label must say **TR1200 v1**. Do not cross-flash a different revision or model.
2. **Get the two images.** The Cudy-signed **intermediate** image (the stock UI only accepts that), and the current stable OpenWrt **sysupgrade** image for `cudy_tr1200-v1` that the instructor names. Do not use a snapshot. Verify the SHA-256 of the OpenWrt image.
3. **Connect by Ethernet.** Laptop to the router's LAN port, open `http://192.168.10.1`, and flash the intermediate image. Wait until the router has rebooted; do not interrupt power. If the laptop keeps its old `192.168.10.x` lease, renew DHCP or set a temporary static address such as `192.168.1.2`.
4. **Replace the intermediate build.** Reconnect to `http://192.168.1.1`, flash the OpenWrt sysupgrade image, and **do not keep settings**. Set a strong root password.
5. **Verify the result.** `ubus call system board`, `uname -a`, `df -h /overlay`, and `ssh root@192.168.1.1` — the router keeps the OpenWrt default until Task 4 moves it to `192.168.14.1`.
6. **If it fails, stop.** Ask the instructor; do not force a TFTP/UART recovery unless the instructor walks you through it. A working spare is better than a bricked router.

> **Story hook.** *The box in the substation.* Malik has done this before, but the label still matters: the wrong image is the difference between a gateway and a paperweight.

*Portfolio evidence:* the model/revision, the OpenWrt version, the SHA-256 you verified, the stock and OpenWrt addresses you saw, and one sentence on why the flash goes over Ethernet.

### ★ Task 2: Extroot — give the router room

The Cudy has 16 MB of flash; the writable overlay is small. Nebula and `tshark` will not fit there; the phone-tether drivers may, but the stick gives you room. Move the overlay to the USB stick now, before it becomes an error message. The full recipe lives in the [resource bank](./Z-resources-bank.md#packet-capture-without-a-second-wifi-card); this is the class path.

1. **Insert the stick through the hub.** Check that it is seen: `logread | grep -i usb`, `ls /dev/sd*`, `block info`. Confirm the device name; it is usually `/dev/sda` or `/dev/sda1`.
2. **Install the storage packages.** On 24.10: `apk update && apk add block-mount kmod-fs-ext4 kmod-usb-storage e2fsprogs`. On 23.05: `opkg update && opkg install block-mount kmod-fs-ext4 kmod-usb-storage e2fsprogs`. If the stick does not show up at all, add `kmod-usb2` (`apk add`/`opkg install`) and check `logread`.
3. **Prepare the filesystem.** If your instructor pre-formatted the stick, verify it with `block info` and skip the format. Otherwise create one Linux partition and `mkfs.ext4 /dev/sda1`. **Never format a device you have not identified.**
4. **Copy the overlay.** `mkdir -p /mnt/sda1 && mount /dev/sda1 /mnt/sda1`, then `cp -a /overlay/. /mnt/sda1/`, then `umount /mnt/sda1`.
5. **Point the boot at the stick.** `block detect > /etc/config/fstab`, find the stick's mount section with `uci show fstab`, set its target to `/overlay` and `enabled='1'`, then `uci commit fstab`.
6. **Reboot and prove it.** `df -h /overlay` must show the stick; `mount | grep overlay` must show it too. Install a small package and reboot again to prove it survives.
7. **Label the stick.** It is part of the router now. Do not swap it with another pod's stick; the overlay will not match.

> **Story hook.** *The router's memory is a filing cabinet.* The internal drawer is full; the stick is the new drawer Malik bolts onto the side. If the drawer is missing at boot, the router is not the same router.

> [!TIP]
> If the router does not come back after the extroot reboot, remove the stick and boot from the internal overlay, then inspect `/etc/config/fstab`. OpenWrt failsafe can repair the config; never delete the internal overlay before the first successful boot from the stick. The [resource bank recipe](./Z-resources-bank.md#packet-capture-without-a-second-wifi-card) has the recovery notes.

*Portfolio evidence:* `df -h /overlay` before and after, the `fstab` mount section (redacted), and one sentence on what extroot actually moved.

### ★ Task 3: Uplink — consume eduroam on 5 GHz, or tether

Pick the upstream that fits your pod. **Prefer eduroam on 5 GHz**; phone USB tethering is the second path; the class B1300 wire is the reliable fallback. All three end in the same place: a WAN interface with a default route — the Wi-Fi and tether paths call it `wwan`, the wire path calls it `wan`.

**Path A — eduroam on 5 GHz (default).**

1. In LuCI, **Network → Wireless → Scan** on `radio1` (the 5 GHz radio). Join the eduroam SSID and create a new interface named `wwan`.
2. Set the security to **WPA2-EAP** with **PEAP** and **MSCHAPv2**; enter the student's identity and password; select the HSBI CA certificate and the correct authentication server/domain. A full `wpad` variant is required (`wpad-mbedtls` or another full build); `wpad-basic` cannot do EAP. If it is missing, install it now (`apk update && apk add wpad-mbedtls` on 24.10, or `opkg update && opkg install wpad` on 23.05; use the full variant for your build); remove `wpad-basic-mbedtls` (or `wpad-basic`) first if your package manager asks. That is one reason extroot comes before this task.
3. Put `wwan` in the `wan` firewall zone, as a DHCP client.
4. Check the clock (`date`) before you debug the certificate. A wrong clock makes every certificate look invalid. Check `logread -e wpa_supplicant` and `ubus call network.interface.wwan status`.
5. If the SSID is missing, check the channel: the Cudy's 5 GHz radio does not support DFS. If the association still fails, fall back to Path B or C and come back later.

**Path B — phone USB tethering.**

1. Connect the phone to the hub, enable USB tethering, and check `lsusb`, `dmesg | tail`, and `ip link`. The interface is often `usb0` or `eth1`.
2. Install the matching driver if it is missing (`apk add`/`opkg install`): `kmod-usb-net-rndis` for many Android phones, `kmod-usb-net-cdc-ether` for others; `usb-modeswitch` and `usbutils` help.
3. Create a `wwan` interface on that device as a DHCP client and put it in the `wan` zone.
4. If the phone is not detected through the hub, try a powered hub or the phone's Wi-Fi hotspot instead.

**Path C — class B1300 wire.**

1. Connect the Cudy's WAN port to a LAN port on the B1300 (or the class DHCP WAN port).
2. Use the Ethernet `wan` interface as a DHCP client. This is also the upstream for the port-forward test in Task 7.

**Verify any path:**

```bash
ubus call network.interface.wwan status   # use 'wan' for the B1300 wire path
ip route
ip route get 1.1.1.1
ping -c 3 1.1.1.1
nslookup openwrt.org
```

> **Story hook.** *The campus port is the only way out.* The substation has no public address; the uplink is a borrowed door. The sensors only speak 2.4 GHz, so the router has to be the translator.

> [!IMPORTANT]
> The eduroam credential is personal. Use it with the owner's consent, keep it out of Git, screenshots, and chat, and remove it or reset the router at the end of the course. A router backup contains the credential; never commit one.

*Portfolio evidence:* the WAN status (`wwan` or `wan`), `ip route`, `ip route get 1.1.1.1`, and one sentence on which path you chose and what it cost (speed, stability, power, or a credential on the router).

### ★ Task 4: Build the pod LAN and the local broker

1. **Plan first.** Write the network address, mask, gateway, DHCP range, SSID, and channel in `## Network plan`. The class default is `192.168.14.1/24`, DHCP `.100–.200`, SSID `pod<NN>` (your pod ID), channel 1, 6, or 11.
2. **Configure the LAN from the wired laptop.** In LuCI, set the LAN interface to `192.168.14.1/24`; set the DHCP range; keep the router as DNS. Change the default OpenWrt `192.168.1.1`; do not leave it in place. When you apply, LuCI and the Wi-Fi AP drop: reconnect at `http://192.168.14.1` and renew your laptop's lease if it still holds an old `192.168.1.x` address.
3. **Broadcast on 2.4 GHz.** Create an AP on `radio0` with your `pod<NN>` SSID, WPA2-PSK, country DE, 20 MHz, and the `lan` network. Disable or rename the default OpenWrt APs you are not using, so only your pod SSID is visible. Pick a channel that is not crowded; the class is a shared RF environment.
4. **Check the firewall.** The `lan` zone accepts input and forwards; the `wan` zone masquerades. Verify with `uci show firewall` and `ip route`.
5. **Join clients.** Connect one laptop by Ethernet and one laptop or phone over 2.4 GHz. Verify `ip addr`, `ip route`, `ip neigh`, and `logread -e dnsmasq`. The M5StickC can join too if you re-point its Wi-Fi credentials; the phone is the faster fresh client.
6. **Run the local broker.** The class image should already have Mosquitto; if not, `apk update && apk add mosquitto` (24.10) or `opkg update && opkg install mosquitto` (23.05). Over SSH, edit (or create) `/etc/mosquitto/mosquitto.conf` with this deliberately open lab configuration:

   ```text
   listener 1883 0.0.0.0
   allow_anonymous true
   ```

   Then `/etc/init.d/mosquitto enable`, `/etc/init.d/mosquitto restart`, and check `logread -e mosquitto` (or `netstat -tlnp | grep 1883` if your image has `netstat`).
7. **Prove it from two clients.** On one client subscribe to `pod<NN>/#`; on the other publish a test message to `pod<NN>/test`. Both must see it.

> **Story hook.** *The noticeboard in the basement.* The broker is where the substation's readings land; the laptops and the phone are the people reading them. It works without the cloud — and without a password, which is exactly why it stays inside the LAN.

> [!NOTE]
> This broker is deliberately open: anonymous, no TLS, LAN only. That is the lab configuration, not a production default. Module 4 adds authentication, TLS, QoS, retained messages, and Last Will. Never expose this broker to WAN except during the controlled port-forward test, and remove the forward afterwards.

*Portfolio evidence:* your `## Network plan`, a DHCP lease from the router, a `mosquitto_pub`/`mosquitto_sub` screenshot from two clients, and `uci show firewall`.

### ★ Task 5: Read the choke point — ARP, DHCP, DNS, MQTT

Capture where every packet must pass: the router. **You do not need a second Wi-Fi adapter, and you do not need Wireshark to prove anything** — but a dump is easier to read in a GUI, so the pattern is always: capture on the router → copy the file → open it. The recipes live in the [resource bank](./Z-resources-bank.md#packet-capture-without-a-second-wifi-card).

1. Install `tcpdump` if it is not already there: `apk update && apk add tcpdump` (24.10) or `opkg update && opkg install tcpdump` (23.05).
2. Capture on the LAN bridge:
   ```bash
   ssh root@192.168.14.1 "tcpdump -i br-lan -s 0 -w /tmp/pod.pcap 'arp or udp port 67 or udp port 68 or udp port 53 or tcp port 1883'"
   ```
   Stop with Ctrl-C, then copy it over:
   ```bash
   scp root@192.168.14.1:/tmp/pod.pcap .
   ```
3. **Trigger the events while the capture runs:**
   - **DHCP:** disconnect and reconnect a client (your phone), or connect a second device, to the pod Wi-Fi. Watch Discover (broadcast, 67→68), Offer, Request, ACK.
   - **ARP:** flush your ARP cache (`ip -s -s neigh flush all` on Linux; `arp -d *` or `netsh interface ip delete arpcache` in an **admin** shell on Windows), then `ping 192.168.14.1`. Look for *Who has 192.168.14.1?* and the unicast reply.
   - **DNS:** `nslookup openwrt.org` from a client. Find the query and the response.
   - **MQTT:** publish one message with `mosquitto_pub` and find the PUBLISH packet.
4. **Read it offline — Wireshark optional.** `wireshark pod.pcap` if you have it; otherwise `tshark -r pod.pcap -V`, or straight from the router `tcpdump -r /tmp/pod.pcap -A`. The text output is enough for the portfolio.
5. **Name the interface.** `br-lan` covers Ethernet LAN ports and Wi-Fi clients. If you also capture WAN traffic, note that `-i any` can show the same packet twice; state which interface you used.

> **Story hook.** *Petra's proof.* She does not want a screenshot of a dashboard; she wants the four packets that show the phone got an address, the router answered ARP, DNS resolved, and the broker received the reading.

> [!NOTE]
> **No live streaming into a GUI.** The two-step — capture on the router, copy the file, read it — is the reliable route on Windows and in this lab generally. If you cannot capture at all today, use the instructor's dump: the analysis is the skill, the tapping is plumbing.

*Portfolio evidence:* the pcap or a `tshark`/`tcpdump -A` excerpt, plus one sentence for each protocol: what it did and what the packet proves.

### ★ Task 6: Tighten the subnet and pin a client

1. **Calculate before you change.** For `192.168.14.0/24`, `/26`, and `/28`, write the network address, broadcast address, and usable host range. Show the arithmetic, not just the answer.
2. **Tighten the LAN from the wired laptop.** Change the LAN to `192.168.14.1/26` (or `/28`), update the DHCP range so it fits inside the new subnet (for `/26`, `.10–.49`; for `/28`, `.2–.10`), and reconnect. Verify with `ip addr` and `ip route`. If you lose the router, use a static address on the client or restore the old lease.
3. **Pin a client.** Find the MAC of your M5StickC or a laptop (`ip neigh` on the router, or `logread -e dnsmasq`), and create a static DHCP lease **outside the dynamic range** (for `/24`, `.150`; for `/26`, `.50`; for `/28`, `.12`). Reconnect the client and verify it gets the same address.
4. **Document the before/after.** Keep `/26` if it works for your pod; restore `/24` and its `.100–.200` DHCP range if you need the larger pool. The gateway stays `192.168.14.1`, so the broker address does not change.

> **Story hook.** *The address plan is the substation's floor plan.* A tighter subnet is not a punishment; it is a decision about how many devices the basement will ever hold.

*Portfolio evidence:* the subnet table, `uci show dhcp`, and the before/after `ip addr` of the pinned client.

### ★ Task 7: One door — port forwarding and NAT

For this test, use the **B1300 as the upstream** so the "outside" client is deterministic. Eduroam often isolates clients, which would make a successful forward look broken.

1. Connect the Cudy's WAN port to a LAN port on the B1300 (or use the class wire). The Cudy's WAN gets a `192.168.114.x` address; the Cudy's LAN stays `192.168.14.0/24`. For this test, disable the Wi-Fi `wwan` or give the Ethernet WAN a lower metric, so the default route actually uses the B1300.
2. Create a port forward in LuCI (**Network → Firewall → Port Forwards**): WAN port `11883` → `192.168.14.1:1883` (TCP). Give it a name you will remember.
3. **Test from outside.** On a laptop connected to the B1300's LAN, subscribe through the Cudy's WAN address:
   ```bash
   mosquitto_sub -h <cudy-wan-ip> -p 11883 -t '#' -v
   ```
   Publish from a client on the Cudy's LAN. The outside subscriber must see the message.
4. **Prove the rewrite.** Capture on both sides while you publish once:
   ```bash
   tcpdump -i any -s 0 -w /tmp/nat.pcap 'tcp port 1883 or tcp port 11883'
   ```
   Compare the outside packet (WAN address, port 11883) with the inside packet (`192.168.14.1`, port 1883). `logread -e firewall` shows the rule firing.
5. **Close the door.** Remove the forward after the test. An anonymous broker on a WAN port is exactly the kind of door Petra would ask about.

> **Story hook.** *Malik opens exactly one door, writes down why, and closes it again.* The control room can reach the broker now — but only through that one port, and only while the rule exists.

> [!NOTE]
> If your normal uplink is eduroam, switch back to it after this task and verify the router still works. The port-forward test is a controlled lab experiment, not the production path; Module 3 replaces the fragile door with an overlay.

*Portfolio evidence:* the forward rule, both sides of the capture, and a short explanation of the address/port rewrite. Say why eduroam would have made this test unreliable.

### ★ Task 8: Handoff — take the router home

The pod will meet in person between sessions. The router has to survive the trip and work on a different upstream. This is also the baseline Module 3 starts from.

1. **Write the baseline.** Model, OpenWrt version, LAN/WAN addresses, router MAC, SSH access, extroot status, Mosquitto status, open ports, and clock. No passwords; no eduroam credential.
2. **Switch the upstream.** At home or in the dorm, connect the router to a home Wi-Fi (STA), a phone tether, or an Ethernet port; reuse the Task 3 paths with the new upstream. Verify DHCP, DNS, NAT, and the broker from a laptop. If the upstream uses `192.168.14.0/24`, change your LAN subnet first — this is the overlap lesson.
3. **Record what changed.** Which path did you use? What broke? What did you have to change? Add it to `## Take it home`.
4. **Agree the pod handover.** Who carries the router? Who owns the eduroam credential? How do you hand it over without publishing it? Remove the credential or reset the router at the end of the course.
5. **Prepare for Module 3.** Confirm `/overlay` is on the stick, the clock is correct, SSH works, and you know your router's LAN address. A Nebula bundle is a credential: it arrives tomorrow, and it never goes into Git.

> **Story hook.** *The substation must survive the trip home.* The control room does not care which café or dorm the router is in; it cares that the same `192.168.14.1` is still there when the pod meets again.

*Portfolio evidence:* the baseline table, the take-home `ip route`/`ping`/`mosquitto_sub` output, and one sentence on the upstream change.

### ◇ Task 9 (Stretcher): Two pods, one wire

Connect two routers in series: Router B's LAN feeds Router A's WAN. Use different LAN subnets (for example `192.168.14.0/24` on B and `192.168.15.0/24` on A; set A's LAN address to `192.168.15.1`), or you will create an overlap you have to debug. Then:

1. Draw the double-NAT path and label both WAN and LAN addresses.
2. Put a guest laptop on B's LAN and reach a service on A's LAN through A's port forward. Which address does the guest see? Which address does the service see?
3. Capture on both routers and explain the two translations.
4. Break it: remove A's forward and watch the guest fail. What does the failure look like from each side?

> **Story hook.** *Two substations share one cable.* The control room can reach the first one, but the second is hidden behind it. Draw the double NAT before you debug it.

*Portfolio evidence:* the double-NAT diagram, the two captures, and three sentences on what double NAT hides.

### ◇ Task 10 (Stretcher): Nebula preview

If your extroot, LAN, and broker are solid and you are breezing through, ask the instructor for your Module 3 bundle. Read its `README.txt`, find the lighthouse in `static_host_map`, and — only if the instructor hands you a bundle — follow **Module 3 Task 1** on your router. Bring the result to Day 3; Module 3 will still explain the why, the cross-NAT test, and the certificate model. This is a preview, not a replacement: do not commit the bundle, the key, or the config.

> **Story hook.** *The key to the substation.* Tomorrow's bundle is the key; today you only check that the door has room for it.

*Portfolio evidence:* one sentence on what the bundle contains that a certificate alone does not, and the overlay address you received (no key material).

## 🔁 Optional: the harvest — collect curiosities, swap lists

> **Optional and ungraded.** The full ritual is in [Module 1](./01-foundations-and-masterclass.md#harvest); run the short version here.

As you work, mark the odd bits: a DHCP offer that never arrived, an ARP entry that pointed at the wrong port, a DNS answer that came from a cache, a phone that refused the 2.4 GHz AP, an extroot that survived a reboot but not a stick swap. Put a `?` in the margin or a line under `## Story seeds`. At the break and at the end, swap lists with another pod: briefly, no explaining, every entry gets a source. Anything two pods collected, or that nobody can place, goes to the course channel. The list is the artefact; the conversation is the point.

## ✅ Suggested portfolio evidence (proofs of the learning goals)

This is a **suggestion, not a checklist** — the learning goals are the contract. A convincing subset, or a better artefact you design yourself, is worth more than a ticked list.

1. **Addressing and routing (goal 1):** the `## Network plan`, the subnet table with network/broadcast/usable ranges, `ip route`, `ip route get 1.1.1.1`, and the before/after LAN configuration.
2. **The plumbing (goal 2):** a DHCP DORA capture, an ARP request/reply, a DNS query/response, `ip neigh`, the DHCP lease, and the NAT/port-forward analysis with both sides of the capture.
3. **OpenWrt (goal 3):** the flash evidence (model, OpenWrt version, verified SHA-256, stock → OpenWrt addresses), the extroot `df -h /overlay` before/after, the UCI/firewall excerpts you are willing to publish, the `## Router baseline`, and the `## Take it home` check.
4. **Capture at the choke point (goal 4):** the pcap or the `tshark`/`tcpdump -A` text, one sentence per protocol, and a note on why the router sees traffic that a laptop cannot.
5. **Optional:** the two-pod double-NAT diagram, the Nebula preview note, or your harvest and story-seed list.

> [!IMPORTANT]
> Never commit router passwords, eduroam credentials, Wi-Fi keys, private keys, configuration backups, or captures containing other people's traffic. Redact MAC addresses, serial numbers, and public IPs before you publish. The eduroam credential is a personal credential; remove it or reset the router at the end of the course.

## 📚 If you want to go deeper

- [RFC 1918](https://www.rfc-editor.org/rfc/rfc1918) — private address space.
- [RFC 2131](https://www.rfc-editor.org/rfc/rfc2131) — DHCP.
- [RFC 3022](https://www.rfc-editor.org/rfc/rfc3022) — NAT.
- [OpenWrt documentation](https://openwrt.org/docs/start), [UCI](https://openwrt.org/docs/guide-user/base-system/uci), and the [firewall configuration](https://openwrt.org/docs/guide-user/firewall/firewall_configuration) — the router you are actually configuring.
- [OpenWrt Cudy TR1200 device page](https://openwrt.org/toh/cudy/tr1200) — hardware, flash layout, and recovery.
- [OpenWrt WWAN / USB tethering](https://openwrt.org/docs/guide-user/network/wan/wwan/start) — the phone-tether path.
- [tcpdump manual](https://www.tcpdump.org/manpages/tcpdump.1.html) — capture at the choke point.
- [mosquitto.conf manual](https://mosquitto.org/man/mosquitto-conf-5.html) — the broker you are running.

---

[← Previous: Module 1](./01-foundations-and-masterclass.md) | [Back to front page](../README.md) | [Quick module index](./00-index.md) | [Next: Module 3 — Mesh & Overlay Networks →](./03-overlay-and-mesh-networks.md)
