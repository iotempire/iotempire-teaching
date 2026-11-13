# Module 2 – Local Networking, TCP/IP & OpenWrt Gateways

[← Back to Module 1](./01-foundations-and-masterclass.md) | [Quick module index](./00-index.md) | [Next: Module 3 →](./03-overlay-and-mesh-networks.md)

**Course placement:** Day 2 — the edge-router challenge. You take one boxed router to a working pod gateway, prove the protocols at the choke point, and hand it over so the pod can continue at home.

## 🎯 Learning Goals

This module gives you the opportunity to explore TCP/IP at the network edge and achieve competency in **IPv4 addressing and subnetting, DHCP/DNS/NAT, OpenWrt administration, and packet capture at the choke point with `tcpdump`** (read in Wireshark when it is available).

By the end of this module, you can:
1. Configure IPv4 addressing, CIDR subnetting, default gateways, and routing tables.
2. Inspect and diagnose the core IP plumbing services: ARP, DHCP (DORA), DNS, and NAT.
3. Flash, configure, administer, and secure an OpenWrt edge router via SSH and the LuCI web interface — from factory firmware to a working pod LAN with a WAN uplink (eduroam, phone tether, or the class Wi-Fi).
4. Capture traffic at the choke point with `tcpdump` on the router, and read the dump with Wireshark, `tshark`, or as text — without needing a second network adapter.

**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 🎬 Opening the Challenge

**The day starts with the challenge, not a slide.** Module 1 gave you the continuum; today you make the edge real. The opening runs in five quick beats:

1. **Pre-study check-in.** In your pod, show each other one artefact from Module 0 or Module 1 — the packet-path sketch, the `traceroute`, or the MQTT screenshot — and name one question you still have.
2. **Confirm the pod and the roles.** You will rotate the roles: one drives LuCI, one drives the terminal, one keeps the network map and photos. Swap often (at least after each round). After the OpenWrt flash, the router stays at `192.168.1.1` until Round 4; use that address for the first three rounds.
3. **Collect the hardware.** One Cudy TR1200 v1 with factory firmware, one USB stick (> 4 GB), one mini USB hub (we will set this up later), Ethernet cables, and one M5StickC (optional client). Label the router and the stick with your pod ID. Make sure you have two laptops, one phone, and paper and pen for drawing and refining the architecture — how it all plays together.
4. **Draw the network you are about to build.** Before you touch the router, draft the architecture you will build and network together (eduroam 5 GHz, phone tether, or the class `iotempire-b1300-5g` Wi-Fi), the router's WAN and LAN sides, the 2.4 GHz AP, and at least one client. You will correct the sketch all day; that is the point.
5. **Skim the studio, do not start.** Read the challenge and the round table below, then skim the theory boxes and the evidence list. You are looking for two things: **where the capture happens** and **where the router leaves the room**. Then start Round 1.

Before you touch the router, answer these three in one sentence each — they are the questions the day will answer (this is a draft answer; you can and should refine it later. Do not delete your first answer — prefix new answers with “update” and add a note at the end: “we changed this because we learned that …”):

- What must a client have before it can send a packet to `1.1.1.1` through your router?
- Why does the router need a WAN address *and* a LAN address? Which one does the laptop see?
- Your phone joins the pod Wi-Fi. Which device assigns its address, and how does the phone find it?

### Your portfolio entry for today — sections, not files

Everything from today goes into **`Module02/README.md`** as sections. Split something into its own file only when a section outgrows the page.

- `## Network plan` — the sketch, the subnet calculation, the SSID/channel, and the pod ID.
- `## Router baseline` — model, OpenWrt version, LAN/WAN addresses, MACs, SSH access, extroot status, broker status, open ports. **No passwords, no eduroam credentials.**
- `## Study log` — the running log: the theory you actually needed, the commands that surprised you, and the LLM answers you checked. This is not an essay and not a separate study phase.
- `## Discussion log` — one line per discussion: who listened, what they asked, what you changed. This is personal; the shared study log is still one per pod.
- `## Vocabulary tracker` — the Module 2 vocabulary table, copied with two extra columns: `✓` and `Link / evidence`. See the reference at the end for how to fill it.
- `## Captures` — the pcap or the `tshark`/`tcpdump -A` text, and what each protocol proves.
- `## NAT and port forwarding` — the rule, the two-sided capture, and the explanation.
- `## Take it home` — the upstream switch and the evidence that the router still works.
- `## Story seeds` — optional: the odd bits worth turning into a story later.

*One pod member keeps the shared `## Study log`; the others link to it from their own `Module02/README.md` and add one sentence on what they took from it. The `## Discussion log` is yours alone.* If you switch roles, cross-link your logs.

### The pod router contract

The router is a shared piece of infrastructure, and one of you will put a personal eduroam credential on it. Agree before you start:

- **Whose eduroam account?** That person consents; the credential is stored on the router; the pod does not publish the config, a backup, or a screenshot that contains it. **The credential owner is the router owner for the course.** Remove the credential or reset the router at the end of the course. Do not put the credential into the portfolio. The person who provides the eduroam credential also sets the router admin password; we advise against sharing it. If you do share the admin password, everyone agrees not to look up the eduroam password of the person who added it.
- **Who carries the router?** The router and its USB stick travel together. The stick is part of the router; label it and keep it in. If the router moves to another pod member, remove the eduroam credential first; never hand over a router with someone else's login.
- **Which upstream?** Prefer eduroam on 5 GHz. If that fails (or you don't want to add your credentials into the router), use phone USB tethering or as a last resort the class `iotempire-b1300-5g` Wi-Fi. The learning goal is the same; the path is negotiable.

## 📖 The Challenge — The Substation Behind the Router

**Stadtwerke Gütersloh** is connecting a district-heating substation to the control room. Field engineer **Malik Yilmaz** has a Cudy router still in its box, a USB stick, two M5Stack nodes, and a laptop. The campus uplink is **eduroam on 5 GHz**; the sensors only speak **2.4 GHz**. Malik flashes OpenWrt, moves the root filesystem to the stick, joins the campus uplink, and builds a `192.168.14.0/24` LAN with a local Mosquitto broker. The dashboard works from the laptop on the LAN — but the control room cannot reach the nodes, and Malik cannot see why.

Petra Sommer's question is precise: *"Which address is which, who is allowed to initiate the connection, and where can I prove it?"*

**Your challenge.** Take one boxed Cudy from factory firmware to a pod gateway that survives leaving the room. You are done when you can show all six:

1. A router on upstream OpenWrt with its writable overlay on the USB stick.
2. A `wwan` with a default route, over eduroam, a phone tether, or — only in special circumstances — the class Wi-Fi.
3. A `192.168.14.0/24` LAN with DHCP, DNS, NAT, and a local broker that two clients can use.
4. A capture at the choke point that shows ARP, DHCP, DNS, and MQTT.
5. A tighter subnet, one pinned client, and one port forward that works from outside — then closes.
6. A router that still works on a different upstream at home, with the credential owner and the handover agreed.

**Constraints.** One router per pod. 16 MB of flash. One Wi-Fi adapter per laptop, usually Windows, no monitor mode. No cloud dependency. The eduroam credential and the router admin password are personal and stay off Git, screenshots, and chat; your Wi-Fi credentials may appear in your personal portfolio only if it is not public.

**There will be story hooks coming up.** Feel free to add your own story-hook extensions that define scenarios where things go wrong — especially when you struggle or explore at a point. Collect those lines under `## Story seeds` and use them in a discussion or the harvest.

## 🧭 How this studio works now

Read this section as a guide: you can alternate freely among the rounds — you are driving your own study in this class.

**Your knowledge and theory acquisition (study) is folded into the practice.** There is no separate pod-study phase and no scheduled hand-off to another pod. Each round below gives you a small thing to do, a short **Theory you need** box you read only when the task makes you want it, and a **discussion** at the end. Keep your notes in `Module02/README.md` under `## Study log` — a running log, not an essay.

**First: skim (meaning read), do not start.** Read the challenge, then skim the nine rounds, the theory boxes, and the evidence list. You are looking for two things: **where the capture happens** and **where the router leaves the room**. After that, start Round 1 and work at your pod's pace.

**Every round ends with a discussion.** You do not need the whole pod to stop. Ask someone at the nearest pod if they have a moment; show them the round's artefact and ask the discussion question. If they want, let them show you theirs and ask you one question back. **This is a brag, not a quiz**: you are showing what works and inviting one question, not asking for permission. Write one line in `## Discussion log`: who listened, what they asked, what you changed. If nobody is free, ask someone else or come back later — do not wait; just record the question or the artefact you wanted to show off.

**Take a study break when the theory box is not enough.** A short break with the linked source, then explain it to one person. Explaining is the test, not reading. You do not need permission; take the break when the task makes you want it. If two of you want the same theory, take it together and bring back one sentence each. Feel free to use this option often, and try to relate it to the learning goals stated at the beginning (going back to the OSI seven layers or the TCP/IP layers is a welcome connection and strengthens your module requirements).

For guidance, the table below is the discussion map: the **[Goal](#-learning-goals) · theory box** column names what each discussion checks. The question tests understanding, not task completion.

| # | Round | You produce | [Goal](#-learning-goals) · theory box | Discussion question for one person |
|---|---|---|---|---|
| 1 | **Flash and own the edge** | A router on upstream OpenWrt; the verified image hash | G3 · Flash OpenWrt | "What did you flash, in which order, and why over Ethernet?" |
| 2 | **Give the router room** | `df -h /overlay` showing the USB stick | G3 · Extroot | "What did extroot move, and what happens if the stick is missing at boot?" |
| 3 | **Join the upstream** | `wwan` with a default route; `ip route get 1.1.1.1` | G1 + G3 · Uplink | "Which path did you choose, and what did it cost?" |
| 4 | **Build the pod LAN** | A client with a lease; a broker from two clients | G2 + G3 · Build the pod LAN | "Which device gave the phone its address, and how do you know?" |
| 5 | **Read the choke point** | A pcap with ARP, DHCP, DNS and MQTT | G2 + G4 · Read the choke point | "Show me one packet and tell me what it proves." |
| 6 | **Tighten and pin** | A subnet table and a static lease outside the pool | G1 · Tighten the subnet | "What is the broadcast address of your /26, and why?" |
| 7 | **Open one door** | An outside subscribe and both sides of the NAT capture | G2 · One door | "Why can the outside start the conversation now, and why close the door?" |
| 8 | **Take it home** | A baseline and a second upstream | G1 + G3 · Handoff | "What changed when the upstream changed?" |
| 9 | **Why OpenWrt?** | A short argument for or against upstream OpenWrt, with one device-table example | G3 · Why OpenWrt | "What does upstream OpenWrt buy you that the vendor UI does not — and what does it cost?" |
| ◇ | **Stretch** | Two-pod chain, SSH tunnel, or Nebula preview | G3–G4 · stretch | "What does this prove that the LAN alone did not?" |

**The order is a suggestion.** The rounds are a path, not a timetable. If your pod's eduroam association fails, switch to phone tethering or the `iotempire-b1300-5g` Wi-Fi and come back; if you finish early, take a stretcher. **The instructor demos the risky steps live on the beamer** — flashing, extroot, the eduroam join, and one capture — so ask for the demo you need instead of waiting with a broken step. Rotate roles after each round; everybody should flash or configure at least one piece. The question you should always be able to answer is *"what did you choose, and what did it cost you?"*

## 🛠️ The Studio: From Factory Router to Pod Gateway — **Challenging**

| What | Notes |
|---|---|
| Cudy TR1200 v1 | 16 MB flash, 128 MB RAM, 2.4 + 5 GHz, 1× WAN + 1× LAN (100 Mbit/s), USB 2.0 |
| USB stick + hub | extroot for the router; label the stick with the pod ID and keep it in |
| 2 laptops | one wired on the LAN port, one on 2.4 GHz Wi-Fi |
| Phone | fresh DHCP client, or USB-tethered upstream |
| M5StickC | optional client; re-point its Wi-Fi to your pod SSID |
| Class B1300 Wi-Fi | `iotempire-b1300-5g` / `iotempire-b1300`, `192.168.114.0/24`, fallback WAN and the "outside" client for the port-forward test |

| Address / service | Value |
|---|---|
| Stock Cudy UI | `http://192.168.10.1` — user `admin`, password `admin` (check the label) |
| Intermediate OpenWrt | `http://192.168.1.1` |
| Class LAN | `192.168.14.0/24`, router `192.168.14.1` |
| Local broker | `mosquitto` on `192.168.14.1:1883`, anonymous, no TLS |
| Class Wi-Fi fallback / outside | `iotempire-b1300-5g`, `192.168.114.0/24` |

### ★ Round 1: Flash OpenWrt — from factory to your router

1. **Verify the hardware.** The label must say **TR1200 v1**. Do not cross-flash a different revision or model.
2. **Get the two images.** The Cudy-signed **intermediate** image (the stock UI only accepts that), and the current stable OpenWrt **sysupgrade** image for `cudy_tr1200-v1` that the instructor names. Do not use a snapshot. Verify the SHA-256 of the OpenWrt image. Your instructors may have provided additional resources in the LMS; check there as well and compare them with this manual. The two should complement each other — if they contradict, that is a curiosity worth recording, not a reason to guess.
3. **Connect by Ethernet.** Laptop to the router's LAN port, open `http://192.168.10.1`, and flash the intermediate image. Wait until the router has rebooted; do not interrupt power. If the laptop keeps its old `192.168.10.x` lease, renew DHCP or set a temporary static address such as `192.168.1.2`.
4. **Replace the intermediate build.** Reconnect to `http://192.168.1.1`, flash the OpenWrt sysupgrade image, and **do not keep settings**. Set a strong root password.
5. **Verify the result.** `ubus call system board`, `uname -a`, `df -h /overlay`, and `ssh root@192.168.1.1` — the router keeps the OpenWrt default until Round 4 moves it to `192.168.14.1`.
6. **If it fails, stop.** Ask the instructor; do not force a TFTP/UART recovery unless the instructor walks you through it. A working spare is better than a bricked router.

**Theory you need.** The vendor UI accepts only a Cudy-signed **intermediate** image; that image then accepts the upstream OpenWrt **sysupgrade**. Flashing over Ethernet is deliberate: a failed Wi-Fi flash leaves you no network to fix it. `sysupgrade` writes the kernel and root filesystem; your changes live in the writable **overlay**, which Round 2 moves to the stick. Do not keep settings when you leave the intermediate build — you want a clean upstream baseline. *Go deeper: the OpenWrt installation docs and the Cudy TR1200 device page.*

> **Discussion — show one person.** Ask someone at the nearest pod if they have a moment. Show them the router and the verified hash, and ask: *"What did you flash, in which order, and why over Ethernet?"* If they want, let them show you theirs and ask you one question back. This is a brag, not a quiz. Write one line in `## Discussion log`.

> **Story hook.** *The box in the substation.* Malik has done this before, but the label still matters: the wrong image is the difference between a gateway and a paperweight.

*Portfolio evidence:* the model/revision, the OpenWrt version, the SHA-256 you verified, the stock and OpenWrt addresses you saw, and one sentence on why the flash goes over Ethernet.

### ★ Round 2: Extroot — give the router room

The Cudy has 16 MB of flash; the writable overlay is small. Nebula and `tshark` will not fit there; the phone-tether drivers may, but the stick gives you room — including for the MicroPython integration service in Module 4. Move the overlay to the USB stick now, before it becomes an error message. The full recipe lives in the [resource bank](./Z-resources-bank.md#packet-capture-without-a-second-wifi-card); this is the class path.

You might have to format the stick first. Your instructor can help or may have provided a script in the LMS to do it on the router.

1. **Insert the stick through the hub.** Check that it is seen: `logread | grep -i usb`, `ls /dev/sd*`, `block info`. Confirm the device name; it is usually `/dev/sda` or `/dev/sda1`.
2. **Install the storage packages.** On 25.12: `apk update && apk add block-mount kmod-fs-ext4 kmod-usb-storage e2fsprogs`. On 24.10 or 23.05: `opkg update && opkg install block-mount kmod-fs-ext4 kmod-usb-storage e2fsprogs`. If the stick does not show up at all, add `kmod-usb2` (`apk add`/`opkg install`) and check `logread`.
3. **Prepare the filesystem.** If your instructor pre-formatted the stick, verify it with `block info` and skip the format. Otherwise create one Linux partition and `mkfs.ext4 /dev/sda1`. **Never format a device you have not identified.**
4. **Copy the overlay.** `mkdir -p /mnt/sda1 && mount /dev/sda1 /mnt/sda1`, then `cp -a /overlay/. /mnt/sda1/`, then `umount /mnt/sda1`.
5. **Point the boot at the stick.** `block detect > /etc/config/fstab`, find the stick's mount section with `uci show fstab`, set its target to `/overlay` and `enabled='1'`, then `uci commit fstab`.
6. **Reboot and prove it.** `df -h /overlay` must show the stick; `mount | grep overlay` must show it too. Install a small package and reboot again to prove it survives.
7. **Label the stick.** It is part of the router now. Do not swap it with another pod's stick; the overlay will not match.

**Theory you need.** OpenWrt splits the firmware into a read-only **rootfs** and a writable **overlay**. On a 16 MB device the overlay is tiny, so packages and logs fill it. **Extroot** moves the overlay to the USB stick: the router still boots from internal flash, but `/overlay` — and therefore your packages and most of `/etc` — lives on the stick. The stick is part of the router now; if it is missing at boot, the router falls back to the internal overlay and looks like a different machine. *Go deeper: the [extroot recipe](./Z-resources-bank.md#packet-capture-without-a-second-wifi-card) in the resource bank.*

> **Discussion — show one person.** Ask someone at the nearest pod if they have a moment. Show them `df -h /overlay` and ask: *"What did extroot move, and what happens if the stick is missing at boot?"* If they want, let them show you theirs and ask you one question back. Write one line in `## Discussion log`.

> **Story hook.** *The router's memory is a filing cabinet.* The internal drawer is full; the stick is the new drawer Malik bolts onto the side. If the drawer is missing at boot, the router is not the same router.

> [!TIP]
> If the router does not come back after the extroot reboot, remove the stick and boot from the internal overlay, then inspect `/etc/config/fstab`. OpenWrt failsafe can repair the config; never delete the internal overlay before the first successful boot from the stick. The [resource bank recipe](./Z-resources-bank.md#packet-capture-without-a-second-wifi-card) has the recovery notes.

*Portfolio evidence:* `df -h /overlay` before and after, the `fstab` mount section (redacted), and one sentence on what extroot actually moved.

### ★ Round 3: Uplink — consume eduroam on 5 GHz, or tether

Pick the upstream that fits your pod. **Prefer eduroam on 5 GHz**; phone USB tethering is the second path; the class `iotempire-b1300-5g` Wi-Fi is the reliable fallback. All three end in the same place: a WAN interface with a default route — all three call it `wwan`.

**Path A — eduroam on 5 GHz (default).**

1. In LuCI, **Network → Wireless → Scan** on `radio1` (the 5 GHz radio). Join the eduroam SSID and create a new interface named `wwan`.
2. Set the security to **WPA2-EAP** with **PEAP** and **MSCHAPv2**; enter the student's identity and password; select the HSBI CA certificate and the correct authentication server/domain. A full `wpad` variant is required (`wpad-mbedtls` or another full build); `wpad-basic` cannot do EAP. If it is missing, install it now (`apk update && apk add wpad-mbedtls` on 25.12, or `opkg update && opkg install wpad` on 24.10/23.05; use the full variant for your build); remove `wpad-basic-mbedtls` (or `wpad-basic`) first if your package manager asks. That is one reason extroot comes before this round.
3. Put `wwan` in the `wan` firewall zone, as a DHCP client.
4. Check the clock (`date`) before you debug the certificate. A wrong clock makes every certificate look invalid. Check `logread -e wpa_supplicant` and `ubus call network.interface.wwan status`.
5. If the SSID is missing, check the channel: the Cudy's 5 GHz radio does not support DFS. If the association still fails, fall back to Path B or C and come back later.

**Path B — phone USB tethering.**

1. Connect the phone to the hub, enable USB tethering, and check `lsusb`, `dmesg | tail`, and `ip link`. The interface is often `usb0` or `eth1`.
2. Install the matching driver if it is missing (`apk add`/`opkg install`): `kmod-usb-net-rndis` for many Android phones, `kmod-usb-net-cdc-ether` for others; `usb-modeswitch` and `usbutils` help.
3. Create a `wwan` interface on that device as a DHCP client and put it in the `wan` zone.
4. If the phone is not detected through the hub, try a powered hub or the phone's Wi-Fi hotspot instead.

**Path C — the class `iotempire-b1300-5g` Wi-Fi.**

1. In LuCI, **Network → Wireless → Scan** on `radio1` and join `iotempire-b1300-5g` (password `iotempire`). Assign the connection to `wwan` and the `wan` zone, as in Path A. If eduroam is already using `radio1`, switch the STA to the class SSID for this fallback; you do not need both at once.
2. If the 5 GHz SSID is not visible, use `iotempire-b1300` (2.4 GHz) on `radio0`; the STA and AP then share that radio, so expect lower throughput. Verify DHCP and the default route. This is also the upstream for the port-forward test in Round 7.

**Verify any path:**

```bash
ubus call network.interface.wwan status   # 'wan' only if you added an optional Ethernet uplink
ip route
ip route get 1.1.1.1
ping -c 3 1.1.1.1
nslookup openwrt.org
```

**Theory you need.** A router has at least two logical sides: `wan` (the upstream, where the default route points) and `lan` (the pod, where DHCP and the AP live). The Cudy has two radios, so it can **consume** one network on 5 GHz and **broadcast** another on 2.4 GHz.

| Radio / port | Role | Interface | Firewall zone |
|---|---|---|---|
| `radio1` — 5 GHz | Wi-Fi **client** to eduroam, home Wi-Fi, or `iotempire-b1300-5g` | `wwan` | `wan` |
| `radio0` — 2.4 GHz | Wi-Fi **access point** for the pod | `br-lan` | `lan` |
| Ethernet WAN | optional wired uplink (if the venue provides one) | `wan` | `wan` |
| Ethernet LAN | wired pod client | `br-lan` | `lan` |

eduroam is 802.1X (WPA2-EAP/PEAP/MSCHAPv2), not a captive portal; it needs a full `wpad`, a correct clock, and the HSBI CA. A phone tether is a DHCP client on `usb0`/`eth1`; the class Wi-Fi is a DHCP client on `wwan`. All three end in the same place: a WAN address and a default route. *Go deeper: OpenWrt network basics; RFC 2131.*

> **Discussion — show one person.** Ask someone at the nearest pod if they have a moment. Show them `ip route get 1.1.1.1` and ask: *"Which path did you choose, and what did it cost?"* If they want, let them show you theirs and ask you one question back. Write one line in `## Discussion log`.

> **Story hook.** *The campus port is the only way out.* The substation has no public address; the uplink is a borrowed door. The sensors only speak 2.4 GHz, so the router has to be the translator.

> [!IMPORTANT]
> The eduroam credential is personal. Use it with the owner's consent, keep it out of Git, screenshots, and chat, and remove it or reset the router at the end of the course. A router backup contains the credential; never commit one.

*Portfolio evidence:* the WAN status (`wwan` or `wan`), `ip route`, `ip route get 1.1.1.1`, and one sentence on which path you chose and what it cost (speed, stability, power, or a credential on the router).

### ★ Round 4: Build the pod LAN and the local broker

1. **Plan first.** Write the network address, mask, gateway, DHCP range, SSID, and channel in `## Network plan`. The class default is `192.168.14.1/24`, DHCP `.100–.200`, SSID `pod<NN>` (your pod ID), channel 1, 6, or 11.
2. **Configure the LAN from the wired laptop.** In LuCI, set the LAN interface to `192.168.14.1/24`; set the DHCP range; keep the router as DNS. Change the default OpenWrt `192.168.1.1`; do not leave it in place. When you apply, LuCI and the Wi-Fi AP drop: reconnect at `http://192.168.14.1` and renew your laptop's lease if it still holds an old `192.168.1.x` address.
3. **Broadcast on 2.4 GHz.** Create an AP on `radio0` with your `pod<NN>` SSID, WPA2-PSK, country DE, 20 MHz, and the `lan` network. Disable or rename the default OpenWrt APs you are not using, so only your pod SSID is visible. Pick a channel that is not crowded; the class is a shared RF environment.
4. **Check the firewall.** The `lan` zone accepts input and forwards; the `wan` zone masquerades. Verify with `uci show firewall` and `ip route`.
5. **Join clients.** Connect one laptop by Ethernet and one laptop or phone over 2.4 GHz. Verify `ip addr`, `ip route`, `ip neigh`, and `logread -e dnsmasq`. The M5StickC can join too if you re-point its Wi-Fi credentials; the phone is the faster fresh client.
6. **Install and run the local broker.** The class image does not include Mosquitto by default. Install it (`apk update && apk add mosquitto` on 25.12, or `opkg update && opkg install mosquitto` on 24.10/23.05), then edit (or create) `/etc/mosquitto/mosquitto.conf` with this deliberately open lab configuration:

   ```text
   listener 1883 0.0.0.0
   allow_anonymous true
   ```

   Then `/etc/init.d/mosquitto enable`, `/etc/init.d/mosquitto restart`, and check `logread -e mosquitto` (or `netstat -tlnp | grep 1883` if your image has `netstat`).
7. **Prove it from two clients.** On one client subscribe to `pod<NN>/#`; on the other publish a test message to `pod<NN>/test`. Both must see it.

**Theory you need.** Private address space (RFC 1918) is `10.0.0.0/8`, `172.16.0.0/12`, and `192.168.0.0/16`. The class standard is `192.168.14.0/24` with the router at `.1`; do not leave the OpenWrt default `192.168.1.0/24`, because an upstream may already use it and the point is to make the addressing a decision.

CIDR in one line each: `/24` = `255.255.255.0` (254 usable); `/26` = `255.255.255.192` (62); `/28` = `255.255.255.240` (14). Two nodes on `192.168.14.10/24` and `192.168.15.10/24` cannot talk at Layer 2; their traffic must cross a router that knows both subnets.

The edge services:
- **ARP** resolves an IP address to a MAC address; without it, a frame cannot be addressed to a physical destination.
- **DHCP** assigns address, mask, gateway, and DNS via DORA: Discover → Offer → Request → Acknowledge.
- **DNS** resolves names; OpenWrt's `dnsmasq` serves leases and forwards queries. `.lan` names come from DHCP; **mDNS** (`openwrt.local`) needs `umdns` or Avahi and is not guaranteed on a fresh router — test it before you promise it.
- **NAT/masquerade** lets the pod share one WAN address by mapping ports. The mapping is stateful; Round 7 opens a deliberate hole.
- **Firewall zones:** `lan` accepts input and forwards; `wan` masquerades. That is why the laptop can reach out and the outside cannot reach in.

*Go deeper: RFC 1918; RFC 2131; OpenWrt network and firewall docs.*

> **Discussion — show one person.** Ask someone at the nearest pod if they have a moment. Show them a client lease and the broker from two clients, and ask: *"Which device gave the phone its address, and how do you know?"* If they want, let them show you theirs and ask you one question back. Write one line in `## Discussion log`.

> **Story hook.** *The noticeboard in the basement.* The broker is where the substation's readings land; the laptops and the phone are the people reading them. It works without the cloud — and without a password, which is exactly why it stays inside the LAN.

> [!NOTE]
> This broker is deliberately open: anonymous, no TLS, LAN only. That is the lab configuration, not a production default. Module 4 adds authentication, TLS, QoS, retained messages, and Last Will. Never expose this broker to WAN except during the controlled port-forward test, and remove the forward afterwards.

*Portfolio evidence:* your `## Network plan`, a DHCP lease from the router, a `mosquitto_pub`/`mosquitto_sub` screenshot from two clients, and `uci show firewall`.

### ★ Round 5: Read the choke point — ARP, DHCP, DNS, MQTT

Capture where every packet must pass: the router. **You do not need a second Wi-Fi adapter, and you do not need Wireshark to prove anything** — but a dump is easier to read in a GUI, so the pattern is always: capture on the router → copy the file → open it. The recipes live in the [resource bank](./Z-resources-bank.md#packet-capture-without-a-second-wifi-card).

1. Install `tcpdump` if it is not already there: `apk update && apk add tcpdump` on 25.12, or `opkg update && opkg install tcpdump` on 24.10/23.05.
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

**Theory you need.** A capture at the choke point shows what actually crossed the router. `br-lan` is the bridge that covers Ethernet LAN ports and Wi-Fi clients; `-i any` can show the same packet twice, so name the interface. What to look for:

| Protocol | Port | What proves it |
|---|---|---|
| ARP | — | A request/reply binds an IP address to a MAC address. |
| DHCP | UDP 67/68 | Discover/Offer/Request/ACK gives the client its address. |
| DNS | UDP 53 | A query and a response resolve a name. |
| MQTT | TCP 1883 | A PUBLISH carries the reading. |

Read the dump offline: `tshark -r`, or `tcpdump -A`. A packet is evidence; a dashboard is a claim. *Go deeper: the capture recipe in the resource bank; RFC 2131; the tcpdump manual.*

> **Discussion — show one person.** Ask someone at the nearest pod if they have a moment. Open your capture, show them one packet, and ask: *"What does this packet prove?"* If they want, let them show you theirs and ask you one question back. Write one line in `## Discussion log`.

> **Story hook.** *Petra's proof.* She does not want a screenshot of a dashboard; she wants the four packets that show the phone got an address, the router answered ARP, DNS resolved, and the broker received the reading.

> [!NOTE]
> **No live streaming into a GUI.** The two-step — capture on the router, copy the file, read it — is the reliable route on Windows and in this lab generally. If you cannot capture at all today, use the instructor's dump: the analysis is the skill, the tapping is plumbing.

*Portfolio evidence:* the pcap or a `tshark`/`tcpdump -A` excerpt, plus one sentence for each protocol: what it did and what the packet proves.

### ★ Round 6: Tighten the subnet and pin a client

1. **Calculate before you change.** For `192.168.14.0/24`, `/26`, and `/28`, write the network address, broadcast address, and usable host range. Show the arithmetic, not just the answer.
2. **Tighten the LAN from the wired laptop.** Change the LAN to `192.168.14.1/26` (or `/28`), update the DHCP range so it fits inside the new subnet (for `/26`, `.10–.49`; for `/28`, `.2–.10`), and reconnect. Verify with `ip addr` and `ip route`. If you lose the router, use a static address on the client or restore the old lease.
3. **Pin a client.** Find the MAC of your M5StickC or a laptop (`ip neigh` on the router, or `logread -e dnsmasq`), and create a static DHCP lease **outside the dynamic range** (for `/24`, `.150`; for `/26`, `.50`; for `/28`, `.12`). Reconnect the client and verify it gets the same address.
4. **Document the before/after.** Keep `/26` if it works for your pod; restore `/24` and its `.100–.200` DHCP range if you need the larger pool. The gateway stays `192.168.14.1`, so the broker address does not change.

**Theory you need.** A `/26` has 64 addresses: network `.0`, broadcast `.63`, usable `.1–.62`. A `/28` has 16: network `.0`, broadcast `.15`, usable `.1–.14`. The router keeps `.1`, so the broker address does not change when you tighten the subnet. A **static lease** (DHCP reservation) is not a static IP: the client still asks DHCP, and the router always gives the same address. Put the reservation outside the dynamic pool so the two cannot collide. *Go deeper: RFC 1918; the Practical Networking subnetting series.*

> **Discussion — show one person.** Ask someone at the nearest pod if they have a moment. Show them the subnet table and ask: *"What is the broadcast address of your /26, and why?"* If they want, let them show you theirs and ask you one question back. Write one line in `## Discussion log`.

> **Story hook.** *The address plan is the substation's floor plan.* A tighter subnet is not a punishment; it is a decision about how many devices the basement will ever hold.

*Portfolio evidence:* the subnet table, `uci show dhcp`, and the before/after `ip addr` of the pinned client.

### ★ Round 7: One door — port forwarding and NAT

For this test, use the **class `iotempire-b1300-5g` Wi-Fi as the upstream** so the "outside" client is deterministic. eduroam often isolates clients, which would make a successful forward look broken.

1. Join the Cudy's `wwan` to `iotempire-b1300-5g` (or use the instructor's wired uplink if you enable client isolation as an experiment). The Cudy's WAN gets a `192.168.114.x` address; the Cudy's LAN stays `192.168.14.0/24`. For this test, disable the eduroam STA or make the class SSID the active uplink, so the default route actually uses it.
2. Create a port forward in LuCI (**Network → Firewall → Port Forwards**): WAN port `11883` → `192.168.14.1:1883` (TCP). Give it a name you will remember.
3. **Test from outside.** On a laptop connected to `iotempire-b1300-5g`, subscribe through the Cudy's WAN address:
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

**Theory you need.** NAT/masquerade lets many private clients share one WAN address. The mapping is stateful: the router remembers which inside client opened which connection, so replies come back. An outside host cannot start a conversation because there is no mapping yet. A **port forward** creates a static mapping: WAN port `11883` → `192.168.14.1:1883`. It is a deliberate hole; capture both sides to see the rewrite. Close it when the test is done. *Go deeper: RFC 3022; the OpenWrt firewall docs.*

> **Discussion — show one person.** Ask someone at the nearest pod if they have a moment. Show them the outside subscribe and the two-sided capture, and ask: *"Why can the outside start the conversation now, and why should you close the door?"* If they want, let them show you theirs and ask you one question back. Write one line in `## Discussion log`.

> **Story hook.** *Malik opens exactly one door, writes down why, and closes it again.* The control room can reach the broker now — but only through that one port, and only while the rule exists.

> [!NOTE]
> The class B1300 does not isolate wireless clients by default, so the outside laptop can subscribe directly. If you enable client isolation as an experiment, use the instructor's wired outside client; the forward itself is unchanged.

> [!NOTE]
> If your normal uplink is eduroam, switch back to it after this round and verify the router still works. The port-forward test is a controlled lab experiment, not the production path; Module 3 replaces the fragile door with an overlay.

*Portfolio evidence:* the forward rule, both sides of the capture, and a short explanation of the address/port rewrite. Say why eduroam would have made this test unreliable.

### ★ Round 8: Handoff — take the router home

The pod will meet in person between sessions. The router has to survive the trip and work on a different upstream. This is also the baseline Module 3 starts from.

1. **Write the baseline.** Model, OpenWrt version, LAN/WAN addresses, router MAC, SSH access, extroot status, Mosquitto status, open ports, and clock. No passwords; no eduroam credential.
2. **Switch the upstream.** At home or in the dorm, connect the router to a home Wi-Fi (STA), a phone tether, or an Ethernet port; reuse the Round 3 paths with the new upstream. Verify DHCP, DNS, NAT, and the broker from a laptop. If the upstream uses `192.168.14.0/24`, change your LAN subnet first — this is the overlap lesson.
3. **Record what changed.** Which path did you use? What broke? What did you have to change? Add it to `## Take it home`.
4. **Agree the pod handover.** The student who provided the eduroam credential owns and carries the router. If the router moves to another pod member, remove the credential first; never hand over a router with someone else's login. Remove the credential or reset the router at the end of the course.
5. **Prepare for Module 3.** Confirm `/overlay` is on the stick, the clock is correct, SSH works, and you know your router's LAN address. A Nebula bundle is a credential: it arrives tomorrow, and it never goes into Git.

**Theory you need.** The LAN is the constant; the WAN is the variable. When the upstream changes, the WAN address and default route change, but `192.168.14.0/24` and the broker stay. Check for an address overlap before you connect: if the upstream also uses `192.168.14.0/24`, change your LAN subnet. The router must survive a new upstream without reconfiguring the pod. *Go deeper: the OpenWrt WWAN and USB-tethering docs.*

> **Discussion — show one person.** Ask someone at the nearest pod if they have a moment. Show them the baseline and the home `ip route`, and ask: *"What changed when the upstream changed?"* If they want, let them show you theirs and ask you one question back. Write one line in `## Discussion log`.

> **Story hook.** *The substation must survive the trip home.* The control room does not care which café or dorm the router is in; it cares that the same `192.168.14.1` is still there when the pod meets again.

*Portfolio evidence:* the baseline table, the take-home `ip route`/`ping`/`mosquitto_sub` output, and one sentence on the upstream change.

### ★ Round 9: Why OpenWrt? — the router you can own

This is a discussion round, not a build round; it can continue after class.

1. **Read the short history.** OpenWrt started in January 2004 from Linksys WRT54G GPL sources, forked as LEDE in 2016, and merged back in 2018. Read [OpenWrt's version history](https://openwrt.org/about/history) and find one release or device story that explains why the project exists.
2. **Trace the lineage.** The Cudy TR1200 ships a vendor firmware but has an upstream OpenWrt path; some AVM FRITZ!Box models can run OpenWrt, while FRITZ!OS itself is AVM's own firmware. Check the [OpenWrt Table of Hardware](https://openwrt.org/toh/start) and the [TR1200 device page](https://openwrt.org/toh/cudy/tr1200). Pick one device and note its install method, supported release, and warnings.
3. **Argue the trade.** Upstream OpenWrt gives you current security updates, the package repository, a real CLI, and configuration you can reproduce. It also costs you vendor support, warranty comfort, and sometimes a feature the vendor added. Write three sentences: would you run upstream OpenWrt on a router you depend on, and under what conditions?
4. **Connect it to the lab.** You have just flashed, extrooted, and administered this router. Which of those steps would be impossible or much harder on a locked vendor firmware? Which vendor feature would you miss?

> [!NOTE]
> **Myth check: “The FRITZ!Box is based on OpenWrt.”** It is not. **FRITZ!OS** is a Linux-based firmware that mixes open-source components with proprietary AVM code. Some FRITZ!Box models can run OpenWrt, but that is a replacement port, not the base of FRITZ!OS.

**Discussion input — pick one or two.**

- **The German love affair.** AVM says almost every second German household uses a FRITZ!Box, and the box earned that place with long update support, local management, and an all-in-one design ([20 years of FRITZ!Box](https://en.avm.de/about-avm/press/press-releases/2024/03/20-years-of-fritzbox-the-heart-of-the-digital-home-is-celebrating-its-birthday)). Is the affection for the product, the brand, or the support promise — and what happens when one of those changes?
- **Sovereignty is more than a postcode.** FRITZ! products are developed in Berlin and produced in Europe ([about FRITZ!](https://en.avm.de/about-avm/who-we-are)). That is a real supply-chain choice. But sovereignty also means: can you inspect the firmware, fork it, repair it, and keep the device alive without the vendor? FRITZ!OS gives integration and support; OpenWrt gives source and control. You rarely get both.
- **The ownership question.** In 2024 the founders brought in **Imker Capital Partners** as a long-term investor and kept a minority stake ([succession press release](https://about.fritz.com/en/press/press-releases/2024/07/fritzbox-manufacturer-avm-organizes-succession)); the company now presents itself as FRITZ! (formerly AVM). Does ownership change the incentives? What would you watch: update length, local features, cloud dependence, or support quality?
- **Giving back vs. complying.** AVM publishes source for the open-source parts of FRITZ!OS, but a 2025 LGPL dispute found the source incomplete until legal pressure ([The Register](https://www.theregister.com/2025/01/10/german_router_maker_avm_lgpl/)). Is that “giving back” or “complying late”? What would good open-source citizenship look like for a router vendor — upstream patches, funded maintainers, documented recovery, a published end-of-support date?
- **The enshittification watchlist.** Cory Doctorow's term describes a product degrading after users are locked in. For a router, the early warning signs would be mandatory accounts or cloud features, a crippled local UI, subscription-only functions, ads, shorter update windows, telemetry, or a locked bootloader. Is FRITZ!OS there? Not proven — but what would you watch? ([Enshittification](https://en.wikipedia.org/wiki/Enshittification))

**A comparison to argue with.**

| Question | FRITZ!OS | OpenWrt |
|---|---|---|
| Who can inspect the code? | Open-source parts published; proprietary core | Open source |
| Who ships updates? | The vendor | You and the community |
| Who supports it? | The vendor | Community and yourself |
| Local control | Strong UI, limited CLI | Full CLI and package manager |
| Hardware | AVM devices | Broad device table |
| Failure mode | Vendor policy or ownership change | Your maintenance burden |

**Theory you need.** OpenWrt is a Linux distribution for embedded routers, not a single vendor's firmware. It keeps a read-only root filesystem and a writable **overlay**, exposes **UCI** for configuration, and offers **LuCI** and a package manager (OpenWrt 24.10 and older use `opkg`; 25.12 and newer use `apk`). The project began in 2004; the **LEDE** fork (2016) merged back in 2018. Its value is not "more features" in the abstract; it is **control and reproducibility** — you can inspect, script, patch, and keep a device alive after the vendor stops. The trade is real: vendor firmware may integrate hardware better, and flashing can void support. On a FRITZ!Box, OpenWrt can replace FRITZ!OS on some models, but it does not inherit AVM's DECT/telephony integration; you gain control and lose vendor integration. *Go deeper: the OpenWrt history, the Table of Hardware, and the TR1200 device page.*

> **Discussion — show one person.** Ask someone at the nearest pod if they have a moment. Show them your three-sentence argument and the device-table entry, and ask: *"What does upstream OpenWrt buy you that the vendor UI does not — and what does it cost?"* If they want, let them show you theirs and ask you one question back. Write one line in `## Discussion log`.

> **Story hook.** *The box that outlives its vendor.* Petra's substation router is old enough that the vendor has stopped caring. The community device page is the reason it can still be patched — if someone is willing to do the work.

*Portfolio evidence:* a `## Study log` note with the device-table entry and your three-sentence argument for or against upstream OpenWrt.

### ◇ Stretch 1: Two pods, one wire

Connect two routers in series: Router B's LAN feeds Router A's WAN. Use different LAN subnets (for example `192.168.14.0/24` on B and `192.168.15.0/24` on A; set A's LAN address to `192.168.15.1`), or you will create an overlap you have to debug. Then:

1. Draw the double-NAT path and label both WAN and LAN addresses.
2. Put a guest laptop on B's LAN and reach a service on A's LAN through A's port forward. Which address does the guest see? Which address does the service see?
3. Capture on both routers and explain the two translations.
4. Break it: remove A's forward and watch the guest fail. What does the failure look like from each side?

> **Story hook.** *Two substations share one cable.* The control room can reach the first one, but the second is hidden behind it. Draw the double NAT before you debug it.

*Portfolio evidence:* the double-NAT diagram, the two captures, and three sentences on what double NAT hides.

### ◇ Stretch 2: SSH tunnels — the poor man's overlay

You already use SSH to administer the router. SSH can also carry other TCP traffic. This is a one-off tunnel, not a mesh; it is the bridge between today's port forwarding and tomorrow's overlay. The full cheat sheet is in the [resource bank](./Z-resources-bank.md#ssh--tunneling).

1. **Local forward.** On your laptop, forward a local port to the broker through the router:
   ```bash
   ssh -L 1883:192.168.14.1:1883 root@192.168.14.1
   ```
   In another terminal: `mosquitto_sub -h localhost -p 1883 -t '#' -v`. The broker is now on `localhost:1883` on your laptop.
2. **Remote forward.** If your laptop can reach the router but the class host cannot, open a door from the router to the class host:
   ```bash
   ssh -R 11883:192.168.14.1:1883 <user>@<class-host>
   ```
   On the class host: `mosquitto_sub -h localhost -p 11883 -t '#' -v`. The connection is initiated from the router; no inbound port on the router is needed.
3. **Dynamic forward.** `ssh -D 1080 <user>@<class-host>` gives you a SOCKS proxy on `localhost:1080`; point a browser or `curl --socks5 localhost:1080` at it. Useful for a quick encrypted path, not for a fleet.
4. **Jump host.** `ssh -J root@192.168.14.1 <user>@<inner-host>` reaches a device behind the router without a separate tunnel command.
5. **Make it repeatable.** Put the forward in `~/.ssh/config`:
   ```text
   Host pod
       HostName 192.168.14.1
       User root
       LocalForward 1883 192.168.14.1:1883
       ServerAliveInterval 30
   ```
6. **Harden it.** Use keys, not passwords; `PermitRootLogin prohibit-password`; keep `AllowTcpForwarding yes`; `GatewayPorts no`; and use `PermitOpen` to limit destinations. On the router, edit `/etc/ssh/sshd_config` and restart the SSH service.
7. **Compare with Nebula.** SSH is TCP-only, one tunnel per session, hand-built, and has no peer discovery. Nebula gives every node an address and a policy, carries UDP, and survives NAT changes. What does the SSH tunnel give you that port forwarding does not? What does it still lack?

> **Story hook.** *The door that opens from the inside.* The router can call out to the class host; the class host cannot call in. `ssh -R` is the door Malik can open without asking the campus firewall.

> [!TIP]
> A local forward binds to `localhost` by default. Do not add `-g` or set `GatewayPorts` unless you really want other machines to reach the forwarded port; an open broker is exactly the door we closed in Round 7.

*Portfolio evidence:* a terminal screenshot of the tunnel and the MQTT message, plus a short table comparing SSH tunneling, port forwarding, and Nebula.

### ◇ Stretch 3: Nebula preview

If your extroot, LAN, and broker are solid and you are breezing through, ask the instructor for your Module 3 bundle. Read its `README.txt`, find the lighthouse in `static_host_map`, and — only if the instructor hands you a bundle — follow **Module 3 Round 2** on your router. Bring the result to Day 3; Module 3 will still explain the why, the cross-NAT test, and the certificate model. This is a preview, not a replacement: do not commit the bundle, the key, or the config.

> **Story hook.** *The key to the substation.* Tomorrow's bundle is the key; today you only check that the door has room for it.

*Portfolio evidence:* one sentence on what the bundle contains that a certificate alone does not, and the overlay address you received (no key material).

> **Stretch discussion — show one person.** Ask someone who has not done the stretcher: *"What does this prove that the LAN alone did not?"* A short moment. If they are curious, show them the capture or the diagram.

## 📖 Reference: the vocabulary the module handbook expects

The module handbook names classic networking terms that you will meet in the labs but rarely find in one place. This table is a reference dictionary, not a second lecture: the OSI model is the dictionary, and this is the index. **Do not read it front to back.** Copy it into `Module02/README.md` under `## Vocabulary tracker`, add two columns — `✓` and `Link / evidence` — and fill it as the rounds give you evidence. The header becomes `| Term | Meaning | Where you meet it | ✓ | Link / evidence |`.

- **✓** — you can explain the term in your own words *and* you have seen it in your own network or a capture. Leave it blank until then.
- **Link / evidence** — a link to your `## Captures` section, a screenshot, a command output, or the round where you met it. A tick without a link is a claim you cannot prove; a blank row is a question you have not answered yet.

You can already tick and link some rows in this module: transmission media (Rounds 3/4), MAC addressing/ARP (Round 5), collision/broadcast domain (Rounds 4/5), routing/default gateway (Round 3), classful addressing vs. CIDR (Round 6), broadcast/fragmentation (Rounds 4/5), TCP vs. UDP and flow control (Round 5, then Module 4), and session/presentation/application (Round 5, then Module 4). The rest is your map for Modules 3–7. Revisit the tracker when you review your portfolio; it doubles as an outline for the learning-goal argumentation.

| Term | Meaning | Where you meet it |
|---|---|---|
| Transmission media | Copper twisted pair, fiber, radio | Ethernet LAN port, 2.4/5 GHz Wi-Fi, RS-485 in Module 6 |
| Line codes / modulation | How bits become symbols on the medium (NRZ, Manchester, OFDM) | Module 5 radio; the lab measures behaviour, not the code |
| Serial vs. parallel | Bits one after another on one wire vs. several wires at once | RS-485/UART vs. parallel buses; Module 6 |
| Synchronous vs. asynchronous | A shared clock vs. start/stop framing | Wi-Fi/ESP-NOW vs. UART/RS-485; Modules 5/6 |
| Simplex / half-duplex / full-duplex | One way / both ways one at a time / both ways at once | RS-485 half-duplex, Ethernet full-duplex, Wi-Fi shared medium |
| Topology | Bus, star, ring, mesh | Pod LAN star, B.A.T.M.A.N. mesh, MQTT star |
| MAC addressing / ARP | Layer-2 address and IP-to-MAC resolution | Round 5 capture; `ip neigh` |
| Collision domain / broadcast domain | Where frames can collide / where broadcasts reach | Ethernet switch vs. router; `br-lan` vs. WAN |
| Error detection | FCS/CRC checks; a bad frame is dropped | Ethernet FCS, Modbus CRC16 (Module 6) |
| CSMA/CD vs. CSMA/CA | Collision detection (wired Ethernet) vs. collision avoidance (Wi-Fi) | Module 5 radio, Round 4 Ethernet |
| Routing / default gateway | Forwarding between subnets; longest-prefix match | Round 3 `ip route`, `ip route get` |
| Spanning Tree Protocol | Prevents Layer-2 loops in a bridged LAN | Module 3's mesh uses B.A.T.M.A.N. for multi-hop routing, not STP |
| Classful addressing vs. CIDR | Legacy fixed classes vs. prefix-based subnets | Round 6 subnetting |
| Broadcast / fragmentation | One-to-all delivery / splitting a packet to fit the MTU | DHCP broadcast, `br-lan`; MTU and Wi-Fi |
| TCP vs. UDP; flow control | Reliable stream vs. datagram; receiver window vs. congestion | MQTT/TCP, CoAP/UDP; Module 4 |
| Session / presentation / application | Session setup and teardown, data format, application protocol | MQTT session, JSON/TLS, DNS/DHCP/NTP/SSH/HTTP; SMTP/POP3/FTP are the same layer, not used in the lab |

## 🤖 Ask an LLM — then verify

Use these when a theory box is not enough. Treat every answer as a **claim to test**, not a fact, and run each prompt against your own router or capture.

- "Explain CIDR subnetting with a `/24` and a `/28`. Give me the network address, broadcast address, and usable host range for `192.168.14.10/24`."
- "Walk me through the DHCP DORA exchange. Which packets are broadcast, which are unicast, and which ports are used?"
- "Why can a LAN client reach the internet through NAT, but an internet host cannot initiate a connection to the LAN client without port forwarding?"
- "Explain ARP and what happens when the ARP cache is empty. How would I see the request/reply in a capture?"
- "My router consumes eduroam on 5 GHz and broadcasts a 2.4 GHz AP. Explain what each radio is doing and what changes if the upstream is 2.4 GHz only."
- "When I join eduroam from the router, what is stored on the router, and why is that a credential? How would I remove it?"

Record where the model is wrong, vague, or over-confident in `## Study log`.

## 🔁 Optional: the harvest — collect curiosities, swap lists

> **Optional and ungraded.** The full ritual is in [Module 1](./01-foundations-and-masterclass.md#harvest); run the short version here.

As you work, mark the odd bits: a DHCP offer that never arrived, an ARP entry that pointed at the wrong port, a DNS answer that came from a cache, a phone that refused the 2.4 GHz AP, an extroot that survived a reboot but not a stick swap. Put a `?` in the margin or a line under `## Story seeds`. At the break and at the end, swap lists with one person at another pod (or whoever is nearby): briefly, no explaining, every entry gets a source. Anything two pods collected, or that nobody can place, goes to the course channel. The list is the artefact; the conversation is the point.

## ✅ Suggested portfolio evidence (proofs of the learning goals)

This is a **suggestion, not a checklist** — the learning goals are the contract. A convincing subset, or a better artefact you design yourself, is worth more than a ticked list.

1. **Addressing and routing (goal 1):** the `## Network plan`, the subnet table with network/broadcast/usable ranges, `ip route`, `ip route get 1.1.1.1`, and the before/after LAN configuration.
2. **The plumbing (goal 2):** a DHCP DORA capture, an ARP request/reply, a DNS query/response, `ip neigh`, the DHCP lease, and the NAT/port-forward analysis with both sides of the capture.
3. **OpenWrt (goal 3):** the flash evidence (model, OpenWrt version, verified SHA-256, stock → OpenWrt addresses), the extroot `df -h /overlay` before/after, the UCI/firewall excerpts you are willing to publish, the `## Router baseline`, the `## Take it home` check, and the Round 9 argument for or against upstream OpenWrt.
4. **Capture at the choke point (goal 4):** the pcap or the `tshark`/`tcpdump -A` text, one sentence per protocol, and a note on why the router sees traffic that a laptop cannot.
5. **The running log and discussions:** your `## Study log` with the theory you actually needed and the LLM answers you checked, plus `## Discussion log` — one line per discussion: who listened, what they asked, what you changed.
6. **The handbook vocabulary:** your `## Vocabulary tracker` with the rows you can tick and link today; leave the rest blank until Modules 3–7 give you the evidence.
7. **Optional:** the two-pod double-NAT diagram, the SSH-tunnel comparison, the Nebula preview note, or your harvest and story-seed list.

> [!IMPORTANT]
> Never commit router passwords, eduroam credentials, Wi-Fi keys, private keys, configuration backups, or captures containing other people's traffic. Redact MAC addresses, serial numbers, and public IPs before you publish. The eduroam credential is a personal credential; remove it or reset the router at the end of the course.

## 📚 If you want to go deeper

- [RFC 1918](https://www.rfc-editor.org/rfc/rfc1918) — private address space.
- [RFC 2131](https://www.rfc-editor.org/rfc/rfc2131) — DHCP.
- [RFC 3022](https://www.rfc-editor.org/rfc/rfc3022) — NAT.
- [Wikipedia: CIDR](https://en.wikipedia.org/wiki/Classless_Inter-Domain_Routing) and [Practical Networking](https://www.practicalnetworking.net/) — the subnetting refresher.
- [OpenWrt documentation](https://openwrt.org/docs/start), [UCI](https://openwrt.org/docs/guide-user/base-system/uci), and the [firewall configuration](https://openwrt.org/docs/guide-user/firewall/firewall_configuration) — the router you are actually configuring.
- [OpenWrt Cudy TR1200 device page](https://openwrt.org/toh/cudy/tr1200) — hardware, flash layout, and recovery.
- [OpenWrt WWAN / USB tethering](https://openwrt.org/docs/guide-user/network/wan/wwan/start) — the phone-tether path.
- [tcpdump manual](https://www.tcpdump.org/manpages/tcpdump.1.html) and [Wireshark User's Guide](https://www.wireshark.org/docs/wsug_html_chunked/) — capture at the choke point and read it offline.
- [mosquitto.conf manual](https://mosquitto.org/man/mosquitto-conf-5.html) — the broker you are running.

---

[← Previous: Module 1](./01-foundations-and-masterclass.md) | [Back to front page](../README.md) | [Quick module index](./00-index.md) | [Next: Module 3 — Mesh & Overlay Networks →](./03-overlay-and-mesh-networks.md)
