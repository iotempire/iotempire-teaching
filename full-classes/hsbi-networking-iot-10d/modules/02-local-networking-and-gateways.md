# Module 2 – Local Networking, TCP/IP & OpenWrt Gateways

[← Back to Module 1](./01-foundations-and-masterclass.md) | [Quick module index](./00-index.md) | [Next: Module 3 →](./03-overlay-and-mesh-networks.md)

---

## 📌 Module Outcomes
By the end of this session, you will:
1. Master **IPv4 addressing, CIDR subnetting, default gateways, and routing tables**.
2. Inspect and diagnose the core IP plumbing services: **ARP, DHCP (DORA), DNS, and NAT**.
3. Configure, administer, and secure an **OpenWrt edge router** via SSH and the LuCI web interface.
4. Capture and analyze real-time network traffic directly on the router using `tcpdump` and stream it into **Wireshark**.

---

## 📖 Network Fundamentals: The TCP/IP Edge

### 1. Subnetting & Private Address Spaces (RFC 1918)
In IoT edge networks, devices operate in private address blocks:
- `10.0.0.0/8`
- `172.16.0.0/12`
- `192.168.0.0/16`

Understanding CIDR (Classless Inter-Domain Routing):
- `/24` = `255.255.255.0` (254 usable host addresses)
- `/28` = `255.255.255.240` (14 usable host addresses)

If two IoT nodes have the IP `192.168.8.10/24` and `192.168.9.10/24`, can they communicate directly at Layer 2? No; their traffic must cross a **router** (Layer 3) that knows how to route between subnets.

### 2. The Core Edge Services:
- **ARP (Address Resolution Protocol):** Resolves IP addresses (Layer 3) to physical MAC addresses (Layer 2). Without ARP, an Ethernet/Wi-Fi frame cannot be addressed to a physical destination.
- **DHCP (Dynamic Host Configuration Protocol):** Automatically assigns IP, subnet mask, gateway, and DNS servers via the **DORA** sequence (**D**iscover $\rightarrow$ **O**ffer $\rightarrow$ **R**equest $\rightarrow$ **A**cknowledge).
- **NAT (Network Address Translation - Masquerading):** Allows dozens of private IoT devices behind the OpenWrt router to share a single upstream WAN IP address by mapping TCP/UDP ports.
- **DNS (Domain Name System) & mDNS:** Translates human-readable names to IPs. In local IoT networks, mDNS (Zeroconf/Avahi, e.g. `openwrt.local` or `node1.local`) allows discovery without a central DNS server.

---

## 🛠️ In-Class Lab: Taming the OpenWrt Edge Router

*Hardware per pair:* 1× OpenWrt Router (GL.iNet or TP-Link), 2× Laptops, Ethernet cables.

### Task 1: OpenWrt Discovery & SSH Administration (20 min)
1. Connect your laptop to the OpenWrt router's LAN port or Wi-Fi.
2. Verify your assigned IP address and default gateway:
   - Linux: `ip route show`
   - macOS: `netstat -nr`
   - Windows: `ipconfig`
3. Access OpenWrt via SSH:
   ```bash
   ssh root@192.168.8.1
   ```
4. Explore the OpenWrt Unified Configuration Interface (**UCI**):
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

---

### Task 2: Live Packet Inspection with `tcpdump` and Wireshark (30 min)
Instead of capturing packets only on your laptop, capture packets *at the choke point*—the OpenWrt router itself!

1. Install/verify `tcpdump` on the OpenWrt router:
   ```bash
   opkg update && opkg install tcpdump
   ```
2. Stream live router traffic directly into Wireshark on your laptop:
   ```bash
   # Run this on your local laptop terminal:
   ssh root@192.168.8.1 "tcpdump -i any -U -s 0 -w - not port 22" | wireshark -k -i -
   ```
3. Trigger and observe these specific network events:
   - **DHCP:** Disconnect and reconnect your M5Stack node or phone Wi-Fi. Observe the DHCP Discover, Offer, Request, and ACK packets (UDP ports 67 & 68).
   - **ARP:** Flush your laptop's ARP table (`ip -s -s neigh flush all` or `arp -d *`) and ping `192.168.8.1`. Observe the `Who has 192.168.8.1? Tell ...` broadcast frame and unicast reply.
   - **TCP Handshake:** Connect MQTTX or curl an HTTP page. Observe the 3-way handshake (`[SYN]`, `[SYN, ACK]`, `[ACK]`) and subsequent teardown (`[FIN, ACK]`).

---

### Task 3: Custom Subnets, Static Leases & Port Forwarding (30 min)
1. Open the LuCI web interface: `http://192.168.8.1` (Network $\rightarrow$ DHCP and DNS).
2. Assign a **Static DHCP Lease** to your M5Stack node based on its MAC address so it always receives `192.168.8.150`.
3. **Port Forwarding Exercise:**
   - Your OpenWrt router has a WAN port connected to the classroom upstream network (e.g. receiving `10.x.x.x`).
   - Create a firewall port forwarding rule in LuCI (Network $\rightarrow$ Firewall $\rightarrow$ Port Forwards):
     - Forward external port `11883` on WAN to internal port `1883` (Mosquitto) on `192.168.8.1`.
   - Ask a neighboring team to connect their MQTT client to your router's WAN IP on port `11883`. Confirm the connection in `logread`!

---

## 📝 Working-Day Reflection & Portfolio Tasks

In your portfolio under `modules/02-local-networking/`:
1. **Network Map:** Draw a clean network diagram of your setup showing MAC addresses, assigned IPs, subnets, and the WAN/LAN interfaces of the OpenWrt router.
2. **Packet Trace Proof:** Export a Wireshark screenshot showing either a DHCP DORA sequence or an ARP request/reply captured live from the router.
3. **Port Forwarding & NAT Analysis:** Explain how NAT masquerading works and why a client on the outside WAN cannot connect to an internal M5Stack node without explicit port forwarding.
4. **Reflection:** What surprised you about the volume of background broadcast/multicast traffic (mDNS, SSDP, ARP) on a local network?
