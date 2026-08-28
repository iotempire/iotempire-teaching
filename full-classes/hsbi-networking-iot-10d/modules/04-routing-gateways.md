# Module 4 – Gateways & Routing: The Invisible Middle Mile for IoT

[← Back to Module 3](./03-wireless-power.md) | [Quick module index](./00-index.md) | [Next: Module 5 →](./05-industrial-protocols.md)

---

## 📌 Module Outcomes
By the end of this session, you will:
• Deploy a **Raspberry Pi as an IoT gateway** (WAN ↔ LAN bridge).
• Configure **NAT, firewall rules, and port forwarding** to expose an internal MQTT broker to the internet.
• Troubleshoot **broken routes** and **DNS hiccups** (the ‘middle mile’ that often fails quietly).
• Measure **end-to-end latency** from sensor → gateway → cloud.

---

## 📚 Pre-Class Homework (30 min max)

### 🎥 Watch (10 min total)
- **[Raspberry Pi as IoT Gateway | Step-by-Step](https://www.youtube.com/watch?v=6Nz7Xv7sLqM)** *(NetworkChuck)*
  *Guiding Questions:*
  - What’s the **primary job** of an IoT gateway?
  - When does the gateway **become the single point of failure**?



---
### 📖 Read (10 min total)
- [NANOG Paper: “The Invisible Middle Mile”](https://archive.nanog.org/meetings/nanog76/agenda)
  *(Focus on “chokepoint” bridging WAN and LAN—5-minute speed-read.)*
- [RFC 1918: Address Allocation for Private Internets](https://tools.ietf.org/html/rfc1918)
  *(Review how internal IP blocks like `192.168.x.x` map via gateways.)*


---
## 🛠 In-Class Lab: Build the Invisible Middle Mile

**Hardware per student/team:**
- **1× OpenWRTGL.iNet router** (or TP-Link) flashed to latest stable release.
  - **Mosquitto MQTT broker** pre-installed (`opkg install mosquitto mosquitto-client`).
  - Static DHCP leases via LuCI (`192.168.8.100–192.168.8.150`).
> [!TIP]
>Your instructor will pre-flash routers with IoTempower images (GL.iNet "Slate" recommended). Bring a USB-to-serial cable if you want to tinker.
- **1× ESP32** (already flashed from Module 2)
- **1× MQTT broker** (your Mosquitto broker throughout modules)
- **1× Public IP or Ngrok tunnel** *(in case your home router blocks ports)*

**Software stack:**
- OS: Raspberry Pi OS Lite (or Desktop without GUI to save power)
- `avahi-daemon` (bonjour/zeroconf)
- `mosquitto_pub/sub` (installed on Pi)
- `iptables` / `ufw` (firewall)

---

### Step 1: OpenWRT Gateway First Boot (5 min)
1. **Power on** the OpenWRT router (factory default: `192.168.8.1`).
2. Connect to Wi-Fi `GL-iNet_XXXX` or plug Ethernet cable to LAN port.
3. Launch admin panel: <http://192.168.8.1> (password: `goodlife`).
4. Confirm **Mosquitto broker is running**:
   ```bash
   ssh root@192.168.8.1
   ps | grep mosquitto
   ```
   Expected output includes `mosquitto -c /etc/mosquitto/mosquitto.conf`.

*Task*: Screenshot your Pi’s IP and host name in your portfolio (Module 4 folder).

---

### **Step 2: Share Your MQTT Broker via Pi Gateway (20 min)**
VoIP recipes for exposing a backend service from a home LAN.

**Option A – Port Forwarding (Ports 1883 & 80)**
1. Login to **home router**: <http://192.168.1.1> or <http://routerlogin.net>
2. Find **Port Forwarding** under NAT/Advanced.
3. Rule 1:
   - Service Name: `MQTT-Broker`
   - External Port: `1883`
   - Internal IP: `192.168.1.100` (your Pi)
   - Internal Port: `1883`
4. Rule 2:
   - External Port: `80`
   - Internal IP: `192.168.1.100`
   - Internal Port: `80` (for web dashboard debug)

5. **Test**: 
   ```bash
   curl http://WAN_IP:1883   # (should get empty response—Mosquitto doesn’t handle HTTP)
   mosquitto_sub -t "#" -h WAN_IP
   ```


*Task*: Photo your router’s port-forwarding page and save the WAN_IP in your portfolio.


---

**Option B – Cloud Tunnel via Ngrok** *(if router is locked by ISP)*
1. Install Ngrok:
   ```bash
   wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-arm.zip
   unzip ngrok-v3-stable-linux-arm.zip
   ./ngrok tcp 1883
   ```
2. Note **Ngrok TCP URL**: `tcp://0.tcp.ngrok.io:12345` (example).
3. ESP32 code change:
   ```cpp
   client.setServer("0.tcp.ngrok.io", 12345);  // replace WAN_IP
   ```

*Task*: Log the Ngrok URL in portfolio.

---

### **Step 3: ZeroConf & Discovery (10 min)**
1. On Pi:
   ```bash
   sudo apt install avahi-daemon avahi-utils
   avahi-resolve -a raspberrypi.local  # should give local IP
   ```
2. ESP32 debug snippet:
   ```cpp
   if (WiFi.status() != WL_CONNECTED){
     Serial.println("WiFi: " + WiFi.SSID());
   }
   ```

*Task: Open LuCI (`http://192.168.8.1`); take a **screenshot** of Network → DHCP leases **(Administration → Static Leases)** showing your ESP32’s IP (`192.168.8.100-120`).

*Task: Open SSH (`ssh root@192.168.8.1`) and run `ps | grep mosquitto`; screenshot the output. Upload screenshot + ASCII file `04-gateway-mosquitto.txt` into **portfolio/04-routing/**.

---

### **Step 4: Latency End-to-End Test (15 min)**
1. Sensor → ESP32 → Pi gateway → MQTT broker → Phone MQTTX client.
2. Measure **round-trip time**:
   ```python
   # publisher.py on Pi
   import time, paho.mqtt.client as mqtt
   def on_message(client, userdata, msg):
       print(f"RTT = {time.time_ns()-int(msg.payload.decode())} ns")
   client = mqtt.Client()
   client.on_message = on_message
   client.connect("localhost")
   client.subscribe("iot/rt")
   client.loop_forever()
   ```


3. ESP32 firmware **injects timestamp**:
   ```cpp
   char msg[20];
   unsigned long ts = millis();
   sprintf(msg, "%lu", ts);
   client.publish("iot/rt", msg);
   ```

*Task*: Export 50 RTT readings to `rtt_module4.csv` and upload to your portfolio.

---

### **Step 5: Three Failure Scenarios (15 min)**
*Instructor will trigger scenarios; students forward-troubleshoot.*

| **Scenario**               | **Symptom**                          | **Root cause** idea            | **Fix**                            |
|---------------------------|---------------------------------------|----------------------------------|-------------------------------------|
| ISP blocks port 1883      | ESP32 connects but no MQTT message     | Router NAT/firewall              | Swap to Ngrok or port 8883         |
| DNS resolution failure      | `raspberrypi.local` → not found      | Avahi broken or multihoming      | Use static IP; log `/etc/hosts`      |
| Broker crash              | ESP32 logs MQTT_connfailed            | Mosquitto not running on Pi       | `sudo systemctl restart mosquitto`    |

*Task*: Each student records their fix steps in **portfolio troubleshooting log** *Week 4*.


---

## 📝 Portfolio Reflection Prompts
Write your reflection (1 page) in the portfolio by EOD addressing:

### **Technical**
1. **Gateway Routing**
   - Why did we expose the broker to the internet (QoS vs LAN-only)? Would you do `1883:80` in prod?
   - How did NAT **lie** to you (e.g., “my WAN IP is the same everywhere”)?

2. **Discovery Stack**
   - Write 3 bullet points: how Avahi/bonjour **saves time** vs. static IPs.
   - What’s one tool you’ll adopt for future debugging?

---

### **Project Context**
3. **System Boundaries**
   - Include a **small UML diagram** (ASCII or draw.io) of:
     - ESP32 → Pi Gateway → MQTT Broker → Subscriber (phone).
   - Label each connection. What happens if the **gateway reboots unexpectedly**?

---
### **Process & Learning**
4. **Teamwork**
   - What **1 workaround** did the class share that saved everyone 10 min?
   - How did **dividing tasks** (Pi setup vs ESP32 vs MQTTX) feel?
5. **Future Steps**
   - What **one module** from now on feels *critical* for your final system?
   - What **1 open question** will you research before Week 6?

---
## 🔧 Why This Module Matters
- The gateway is the **least sexy but most critical** component in IoT.
- NAT/firewall failures are **the #1 support ticket** in real systems.
- *Middle mile rules* determine if your device works 10 m away or 10 km out.

---
## 📌 Resources & References
- **[Raspberry Pi as IoT Gateway Scripts](https://github.com/raspberrypi/documentation/tree/develop/documentation)** (RPi Foundation)
- **[Mosquitto on Pi Guide](https://mosquitto.org/blog/2021/09/troubleshooting-and-profiling-mosquitto/)** (troubleshooting)
- **[tcpdump Cheat Sheet](https://packetlife.net/media/library/12/tcpdump.pdf)** — for sniffing traffic at the gateway
- **[Port Forwarding Visual Explainer](https://www.rfc-editor.org/rfc/rfc1918.txt)** (IETF RFC 1918 context)


---
## 📌 Next Steps
1. Complete your reflection **before next meetup.**
2. **Next module**: Unit 5 covers Industrial Protocols (OPC-UA, Modbus).

---
*[Use your existing portfolio template](https://portfolio.iotempower.us) for uploading reflections, diagrams, and screenshots.*