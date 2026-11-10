# Resources Bank – Networking and IoT Solutions

*A living cheat sheet for students and instructors. Contribute improvements through your portfolio or a pull request.*

<a id="where-to-run-the-labs-your-editors-terminal"></a>
## 💻 Where to run the labs: your editor's terminal

Run the module commands in your **editor's integrated terminal** (VS Code or Zed) — you are already inside your portfolio repo, and the router/SSH/capture commands work best from there.

- **macOS / Linux:** the built-in terminal is already a Unix shell (bash/zsh). Nothing to set up.
- **Windows:** it defaults to **PowerShell**, which cannot run the heredocs, pipes, and `<` redirects used in some labs. Point it at **Git Bash** once — **no extra install**, because Git Bash ships with Git for Windows:
  - **VS Code:** in the terminal, click the **⌄** beside **+** → *Select Default Profile* → **Git Bash** (auto-detected). New terminals then use bash.
  - **Zed (Windows):** the terminal follows your default system shell — set **Git Bash** (e.g. via Windows Terminal) as the default, or open the standalone **Git Bash** app.
  - **Also fine:** run the labs in **WSL** (`wsl`) for a full Linux shell and a real `ssh`/`tcpdump` experience.
- **PowerShell translation** (only if you must stay there): `mkdir -p Module02` → `New-Item -ItemType Directory -Force Module02`; `cmd < file` → `Get-Content file | cmd`; `time cmd` → `Measure-Command { cmd }`.

> Keep one terminal for the router SSH session and one for the laptop capture. Do not paste multi-line shell blocks with comments into a PowerShell prompt; save them to a file and run the file.

<a id="git--github-primer-template-editor-markdown-conflicts"></a>
## 🐙 Git & GitHub primer (template, editor, Markdown, conflicts)

In class we work with **GitHub on the web** and the **Git UI inside your editor** (VS Code or Zed) — commit, fetch, pull, and push from the buttons, not the terminal. **`gh` is optional**: it can create your repository, invite the instructor, and clone it, but the browser does all three as well. Command-line `git`/`gh` and SSH keys are *optional*.

### Create the portfolio from the template (not a fork)

[![Create Portfolio](https://img.shields.io/badge/1--Click-Create%20Portfolio-brightgreen?style=for-the-badge&logo=github)](https://github.com/new?template_name=iot-portfolio-template&template_owner=iotempire)

The button opens GitHub's *new repository* form with `iotempire/iot-portfolio-template` already selected — no hunting for the green **Use this template** button, and no way to fork by accident. If it ever lands you on an empty form without the template pre-selected, use [`github.com/iotempire/iot-portfolio-template/generate`](https://github.com/iotempire/iot-portfolio-template/generate) instead: same form, guaranteed to be the template.

1. **Name it exactly** `net-iot-hsbi-2026-portfolio` and make it **public** — or at least readable by the instructor. Same name for everybody; your GitHub account tells them apart.
2. **Invite the instructor.** Open `https://github.com/<YOUR-USERNAME>/net-iot-hsbi-2026-portfolio/settings/access` → **Add people** → search for **`ulno`** → role **Write** (Admin is fine too).
3. **Confirm it worked:** the repository shows `ulno` under *Settings → Access*.

> **`gh` users:** if you already have the GitHub CLI authenticated, the whole step is three lines:
>
> ```sh
> gh repo create net-iot-hsbi-2026-portfolio --template iotempire/iot-portfolio-template --public --clone
> cd net-iot-hsbi-2026-portfolio
> gh api -X PUT "repos/{owner}/{repo}/collaborators/ulno" -f permission=push   # there is no `gh repo invite`
> ```
>
> Everyone else: the button and two clicks are the normal path, and nobody needs a terminal for this.

**Reflections:** copy `Reflections/TEMPLATE.md` to `Reflections/refNN.md`; `ref02.md` is the worked example.

> A **template** gives you a fresh repo with one clean commit and no upstream link; a **fork** keeps a link to the original and the full history — not what a personal portfolio wants.

### Clone it once (if you work locally)

```sh
gh repo clone <you>/net-iot-hsbi-2026-portfolio    # the ONLY gh command you need
```

Then **open the folder in VS Code or Zed** and do everything else in the editor's Git UI. Working only in the browser is fine too — GitHub's web editor commits for you.

### Install the tools (once)

| OS | Install Git | Install `gh` |
|---|---|---|
| **Windows** | **Git for Windows** from [git-scm.com/download/win](https://git-scm.com/download/win), or `winget install --id Git.Git -e` (also installs **Git Bash**) | `winget install --id GitHub.cli`, or `scoop install gh` |
| **macOS** | `xcode-select --install`, or `brew install git` | `brew install gh` |
| **Linux** | `sudo apt install git` · `sudo dnf install git` | `sudo apt install gh` · `sudo dnf install gh` |

Set your identity once: `git config --global user.name "Your Name"` and `git config --global user.email "you@example.com"`.

### Day-to-day commits — in your IDE (recommended)

- **VS Code** — the **Source Control** view: stage, write a message, **Commit**, then **Sync/Push**; **Pull** when you sit down. ([docs](https://code.visualstudio.com/docs/sourcecontrol/overview))
- **Zed** — the **Git panel**: stage, commit, push/pull. ([docs](https://zed.dev/docs/git))
- **GitHub on the web** — edit any file and commit right in the browser; ideal for a quick fix or pasting a capture note.

**What “Git proficiency” means here.** You prove it by **edits and check-ins**, not by memorizing commands: several commits with messages that say what changed; Markdown with headings, lists, tables, code fences, and **interlinks** (including pod mates' evidence); and working in your pod with changing roles.

**Learning the pieces:** [Hello World / your first commit](https://docs.github.com/en/get-started/start-your-journey/hello-world) · [create from a template](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template) · [Markdown basics](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax) · [resolve a merge conflict (GitHub editor)](https://docs.github.com/en/pull-requests/how-tos/merge-and-close-pull-requests/resolving-a-merge-conflict-on-github) · [GitHub Skills](https://skills.github.com/)

> [!TIP]
> Keep your portfolio **public** (or at least readable by the instructor) and build it up with **many small commits**, each message saying what changed — a clean `git log` is itself part of the evidence.

<a id="python-environment-with-uv-optional"></a>
## 🐍 Python environment with `uv`

The integration labs use Python (`paho-mqtt`, IoTknit, optional `pymodbus` / `asyncua`). Use a pinned `uv` environment instead of bare `pip install`:

```sh
# install uv once (macOS/Linux)
curl -LsSf https://astral.sh/uv/install.sh | sh
# Windows (PowerShell):
#   powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"

uv python install 3.14
uv python pin 3.14
uv init --name networking-portfolio   # skip if pyproject.toml exists
uv add paho-mqtt pymodbus asyncua     # add only what you use
uv sync                               # rebuild from uv.lock after a fresh clone
uv run python iot_bridge.py
```

> Commit `pyproject.toml` and `uv.lock`; never commit `.venv/`. If you only use Node-RED and the shell, you can skip this section — but do not mix a global `pip install` into the lab instructions.

<a id="pre-class-videos-by-module"></a>
## 🎥 Pre-Class Videos by Module

> [!NOTE]
> **Videos are external and temporary.** YouTube links get renamed, region-locked, or taken down without notice, so an entry that worked when this table was written may already be gone. Each row carries the date it was last verified (see the *Checked* column). The **guiding question**, not the exact video, is the part that matters: if a link is dead, search for the topic yourself and post a working replacement in the class channel. The written pointers and LLM prompts inside the modules are the authoritative path — a video is only ever a second opinion.

| Module | Topic | Video | Guiding Question | Checked |
|---|---|---|---|---|
| 1 | OSI Model Critique | [OSI Model: A Practical Perspective (Practical Networking)](https://www.youtube.com/watch?v=LkolbURrtTs) | How does layering help — or hinder — debugging an MQTT broker crash? | 2026-11-02 |
| 1 | OSI vs TCP/IP | [OSI and TCP/IP Models — Best Explanation](https://www.youtube.com/watch?v=3b_TAYtzuho) | What benefit does TCP/IP’s flexible layering bring to real-time IoT? | 2026-11-02 |
| 4 | MQTT in IoT | [What is MQTT and How It Works (Rui Santos)](https://www.youtube.com/watch?v=EIxdz-2rhLs) | How does MQTT’s pub/sub reduce integration friction compared to REST? | 2026-11-02 |
| 4 | Replacing a mock with real hardware | [Getting Started with ESP32 & MQTT](https://www.youtube.com/watch?v=OAoM5IV393o) | What’s the benefit of swapping a Python mock for an ESP32 with *no other changes*? | 2026-11-02 |
| 5 | LoRaWAN Architecture | [LoRaWAN Explained: Basics, Devices, Architecture](https://www.youtube.com/watch?v=EAby2vOeLpc) | What’s the trade-off between WiFi’s throughput and LoRaWAN’s range? | 2026-11-02 |
| 5 | Wireless Technology Choices | [Wi-Fi, Bluetooth, Zigbee, and LoRa in IoT (comparison)](https://www.youtube.com/watch?v=V7E6ytEttsA) | If a project needs a 15 km line-of-sight, which would you pick and why? | 2026-11-02 |
| 5 | ESP32 Deep Sleep Modes | [ESP32 Deep Sleep Tutorial for Low Power Projects](https://www.youtube.com/watch?v=y1R2y8dCsIg) | What sleep mode achieves 6-month battery life on your ESP-NOW soil sensor? | 2026-11-02 |
| 5 | IoT Power Optimization | [Power Management in IoT: Battery Life & Energy Harvesting](https://www.youtube.com/watch?v=a7PTizUNfsI) | Why is frequency scaling often unused in IoT? What’s cheaper instead? | 2026-11-02 |
| 6 (optional) | OPC-UA for Beginners | [The ABCs of OPC UA (RealPars)](https://www.youtube.com/watch?v=_rQHcKwvRJw) | How is an OPC-UA node different from a Modbus register? | 2026-11-02 |
| 6 (optional) | Modbus for Beginners | [What is Modbus and How does it Work? (RealPars)](https://www.youtube.com/watch?v=txi2p5_OjKU) | What happens when 100 Modbus devices share a single RS-485 line? | 2026-11-02 |
| 7 | Raspberry Pi Gateway | [Raspberry Pi IoT Server: InfluxDB, MQTT, Grafana, Node-RED & Docker](https://www.youtube.com/watch?v=_DO2wHI6JWQ) | What job does the gateway perform that neither the sensor nor the cloud can do alone? | 2026-11-02 |

<a id="rfcs--standards-every-student-should-glance-once"></a>
## 📖 RFCs & Standards Every Student Should Glance Once

| RFC/Document                                                    | Focus                                                                              | Why it Matters                                                                         |
|---------------------------------------------------------------------|-----------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------|
| [RFC 1918](https://tools.ietf.org/html/rfc1918)                     | Private IPv4 networks (`192.168.x.x`, `10.x.x.x`)                                    | Gateway NAT + port forwarding depends on reserving private IP blocks (Module 2).                |
| [RFC 3439 Section 3](https://tools.ietf.org/html/rfc3439#section-3) | "Layering Considered Harmful"                                                         | Forces students to question if OSI layers help or hinder engineering *in practice* (Module 1).  |
| [RFC 1958](https://tools.ietf.org/html/rfc1958)                     | Architectural principles of the Internet (end-to-end principle)                          | Explains why TCP/IP succeeded over rigid OSI stacks (Module 1).                            |
| [MQTT v5.0 Spec](http://docs.oasis-open.org/mqtt/mqtt/v5.0/mqtt-v5.0.html) | Publish/subscribe, QoS levels, session management                                       | Defines how ESP32 MQTT clients in Modules 4–9 must behave.                                   |
| [LoRaWAN 1.0 Spec](https://lora-alliance.org/resource-hub/)        | Physical layer, MAC commands, ADR                                                    | Helps debug why LoRaWAN range sometimes jumps 2 km suddenly (Module 5).                      |
| [OPC-UA Part 3](https://www.opcfoundation.org/ua/part3/)           | Address space and data model                                                          | Explains what an OPC-UA node/tag means (Module 6, optional).                                        |
| [ESP32 Technical Reference](https://www.espressif.com/sites/default/files/documentation/esp32_technical_reference_manual_en.pdf) | Power states, clock domains, sleep modes                                               | Each µA in deep sleep; core text for Module 5 optimizations.                                 |

## 🛒 Cheat Sheets & Quick References

### 📌 Hardware Quick Guides
- [ESP32 Pinout](https://www.etechnophiles.com/esp32-gpio-pinout-datasheet/) – A0–A3, GPIO, power domains.
- [RPi 4 Pinout](https://www.raspberrypi.com/documentation/computers/os.html#gpio-and-the-40-pin-header) – UART, I2C, power pins.
- [LiPo vs Coin Cell](https://www.ti.com/lit/an/slyt670/slyt670.pdf) – Discharge curves, self-discharge.

<a id="networking-snippets-copypaste"></a>
### 📌 Networking Snippets (Copy/Paste)
- Ping sweep to find ESP32 IP:
  ```bash
  nmap -sn 192.168.1.0/24 | grep "IoT"
  ```
- Find open ports on Pi:
  ```bash
  sudo netstat -tulnp | grep mosquitto
  ```
- Port forward Pi 1883 → WAN:
  ```bash
  sudo iptables -t nat -A PREROUTING -p tcp --dport 1883 -j DNAT --to-destination 192.168.1.100:1883
  ```
- Enable Avahi for Pi host naming:
  ```bash
  sudo apt install avahi-daemon avahi-utils
  ```

<a id="ssh--tunneling"></a>
### 📌 SSH & tunneling

**Keys first.** Generate once, copy the public key to the router, then use the key for every login:

```bash
ssh-keygen -t ed25519 -C "pod07-laptop"
ssh-copy-id root@192.168.14.1
ssh root@192.168.14.1          # no password prompt now
```

**The three forwards.**

```bash
# Local: put the router's broker on your laptop's localhost:1883
ssh -L 1883:192.168.14.1:1883 root@192.168.14.1

# Remote: let the class host reach the router's broker on its localhost:11883
ssh -R 11883:192.168.14.1:1883 <user>@<class-host>

# Dynamic: a SOCKS proxy on localhost:1080
ssh -D 1080 <user>@<class-host>
```

**Jump host and config.** `ssh -J root@192.168.14.1 <user>@<inner-host>` reaches a device behind the router. Put the repeatable version in `~/.ssh/config`:

```text
Host pod
    HostName 192.168.14.1
    User root
    LocalForward 1883 192.168.14.1:1883
    ServerAliveInterval 30
```

**Harden the router's SSH.** Keys only, no root password login, and no forwarding to arbitrary destinations:

```text
PermitRootLogin prohibit-password
PasswordAuthentication no
AllowTcpForwarding yes
GatewayPorts no
PermitOpen 192.168.14.1:1883
```

Restart the SSH service after editing `/etc/ssh/sshd_config` and keep a second session open until the new one works.

> **Telnet is the warning, not the tool.** Telnet sends everything — including passwords — in plaintext. Use SSH. A local forward binds to `localhost` by default; `-g` or `GatewayPorts` opens it to other machines, which is usually the opposite of what you want.

<a id="packet-capture-without-a-second-wifi-card"></a>
### 📌 Packet capture without a second Wi-Fi card

**The room has one Wi-Fi adapter per laptop, usually on Windows, and no monitor mode.** That is fine: you do not need to see the air in order to read the traffic. Capture at a point the packets *must* cross, copy the dump, and read it afterwards.

| Where you capture | How | Good for |
|---|---|---|
| **The OpenWrt router** (default) | `ssh root@<router>`, `tcpdump -i br-lan -w /tmp/x.pcap '<filter>'`, then `scp` the file | Everything that crosses the router: ARP, DHCP, DNS, NAT, MQTT |
| **An ESP32 as a transparent tap** | [`martin-ger/esp32_eth_wifi_bridge`](https://github.com/martin-ger/esp32_eth_wifi_bridge) sits in the path as an L2 bridge and streams pcap over TCP. On its console: `pcap start`; from the collector: `nc <bridge-ip> 19000 \| wireshark -k -i -` (or save to a file) | Watching all traffic without installing anything on the router. [`martin-ger/esp32_nat_router`](https://github.com/martin-ger/esp32_nat_router) has the same PCAP feature |
| **Your own laptop** | Wireshark / `tcpdump` on your normal interface | Only *your* traffic — see the caveat below |

**Why sniffing from the laptop does not work.** On managed Wi-Fi your adapter receives frames addressed to *you* (plus broadcast and multicast). Another station's unicast traffic never reaches your card — promiscuous mode cannot help, because the access point does not forward it to you. Seeing it requires **monitor mode**, which on Windows means a specific adapter *and* driver, and usually a second radio anyway. This course does not assume either.

**Always two steps:** capture on the device → copy the file → open it. Do not build a lab step around streaming into a GUI, especially not on Windows.

```bash
# On the router: capture (stop with Ctrl-C)
tcpdump -i br-lan -s 0 -w /tmp/lan.pcap 'arp or udp port 67 or udp port 68 or udp port 53 or tcp port 1883'

# From your laptop: copy it over and open it
scp root@192.168.14.1:/tmp/lan.pcap .
wireshark lan.pcap            # or: tshark -r lan.pcap -V | less
```

**If Wireshark is not installed** (or you cannot install software), `tcpdump -A` prints the packets as text — enough to prove a DORA exchange or an ARP request/reply, in any SSH client:

```bash
ssh root@192.168.14.1 "tcpdump -i br-lan -A -c 20 'arp'"
ssh root@192.168.14.1 "tcpdump -r /tmp/lan.pcap -A 'udp port 67 or udp port 68'"
```

**Storage: 16 MB of flash.** `tcpdump` and Mosquitto are already on the class image. For anything bigger — Nebula, `tshark`, MicroPython — move the root filesystem to a **USB stick** (the routers have one USB 2.0 port). The class hands out a **> 4 GB stick and a mini USB hub**, so the stick and a USB-tethered phone can share that one port. Label the stick with the router ID; it is part of the router, not a spare.

```bash
# on the router, once, with the stick plugged in
# 24.10 and newer:
apk update
apk add block-mount kmod-fs-ext4 kmod-usb-storage e2fsprogs
# 23.05 and older:
# opkg update
# opkg install block-mount kmod-fs-ext4 kmod-usb-storage e2fsprogs
# If the stick does not show up at all, the USB controller module is missing too:
#   apk add kmod-usb2  (or opkg install kmod-usb2 / kmod-usb-ohci), then check `logread`
# Confirm the device with `logread`, `ls /dev/sd*`, and `block info` before you touch it.
# If the stick is blank, create one Linux partition first (fdisk /dev/sda), then use /dev/sda1.
# If the instructor pre-formatted the stick, skip mkfs and go straight to mount.
mkfs.ext4 /dev/sda1                       # only for a stick you identified and may erase
mkdir -p /mnt/sda1 && mount /dev/sda1 /mnt/sda1
cp -a /overlay/. /mnt/sda1/ && umount /mnt/sda1
block detect > /etc/config/fstab
uci show fstab                            # find the mount section for your stick
uci set fstab.@mount[0].target='/overlay' # adjust the section index if yours is not 0
uci set fstab.@mount[0].enabled='1'
uci commit fstab
reboot
# after the reboot: df -h /overlay and mount | grep overlay must show the stick
```

> **If the router does not come back after the extroot reboot, remove the stick and boot from the internal overlay.** Inspect `/etc/config/fstab`; OpenWrt failsafe can repair the config. Never delete the internal overlay before the first successful boot from the stick. The stick is not a backup: it is the live root filesystem.

> **Never commit the contents of a USB stick, and do not commit a router backup you did not read.** Document *what* you installed and *how* instead — that is the reproducible part.

**ESP-NOW is its own case.** Unencrypted ESP-NOW frames *can* be captured by an ESP32 in promiscuous mode: [`sp4rkie/ultra-espnow-sniff`](https://github.com/sp4rkie/ultra-espnow-sniff) streams them as ordinary pcap over UART or Ethernet. Expect a few percent of frames to be missed depending on where the observer sits — one sniffer cannot tell a broken link from a badly placed observer (Module 5).

**What to capture for which module**

| Module | Capture | What it shows |
|---|---|---|
| 1 | `tcp port 1883` | MQTT publish/subscribe, the header overhead |
| 2 | `arp`, `udp port 67 or 68`, `udp port 53`, `tcp port 1883` | ARP resolution, DHCP DORA, DNS, MQTT on the LAN |
| 3 | `-i nebula1` (or `-i tun0`) | overlay traffic inside the tunnel, and its encapsulation outside |
| 4 | `tcp port 1883` | QoS bits, retained message, Last Will |
| 5 | ESP32 sniffer | ESP-NOW frames on the air |

<a id="nebula-bundles--the-class-ca"></a>
### 📌 Nebula bundles & the class CA

A **bundle** is the deployment unit: certificate, private key, `ca.crt`, `config.yml.template`, `install.sh`, `install.ps1`, `README.txt`. The installers are self-contained — a client does **not** need nebula-manager. Treat every archive and every `.key` as a credential.

```bash
# client, Linux/macOS: unpack and install (needs the nebula package)
unzip <name>-nebula-bundle.zip -d nb && sudo bash nb/install.sh
sudo bash nb/install.sh --certs-only     # after a re-sign: refresh cert/key, keep config

# client, Windows (elevated PowerShell, nebula.exe already installed)
powershell -ExecutionPolicy Bypass -File .\install.ps1
powershell -ExecutionPolicy Bypass -File .\install.ps1 -CertsOnly

# inspect what a certificate actually says
nebula-cert print -path /etc/nebula/<name>.crt
```

On **OpenWrt** the installer does not apply (no systemd): copy `<name>.crt`, `<name>.key`, `ca.crt` and `config.yml` into `/etc/nebula/`, `chmod 600` the key, and run the static binary — the full recipe is in [Module 3](./03-overlay-and-mesh-networks.md).

**The instructor side (the class CA).** All of this runs as a normal user; only the lighthouse's `/etc/nebula` needs sudo:

```bash
./nebula-manager ca   --name ClassCA --cert-dir ~/keys/class
./nebula-manager sign --name pod07-router --ip 10.100.0.7/24 --groups students --cert-dir ~/keys/class
./nebula-manager cert config generate --all --cert-dir ~/keys/class
./nebula-manager cert list --cert-dir ~/keys/class            # expiry, groups, addresses
./nebula-manager cert bundle pod07-router --out ~/bundles
./nebula-manager fleet croc --select group:students --policy students   # one code per node
./nebula-manager cert resign-all --yes                          # after a CA rotation
```

The CA **key** never leaves the instructor's machine; only `ca.crt` and the signed node certificates travel. Back up `~/keys/class` — losing the CA key means re-issuing the whole mesh.

<a id="mqtt-command-cheat-sheet"></a>
### 📌 MQTT Command Cheat Sheet
| Command                      | Example                                      | Purpose                                  |
|------------------------------|-----------------------------------------------|------------------------------------------|
| `mosquitto_pub`              | `mosquitto_pub -t "temp" -m "22.5" -h 192.168.1.100` | Publish test message                      |
| `mosquitto_sub`              | `mosquitto_sub -t "#" -h localhost`         | Subscribe to all topics                  |
| `mosquitto_sub` RTT logger   | `mosquitto_sub -t "iot/rt" -h localhost --retained | Measure latency                         |

### 📌 Power Measurement Cheat Sheet
| Tool             | Command / Setup                           | Purpose                                  |
|------------------|-------------------------------------------|------------------------------------------|
| USB meter        | Record CSV (*power_profile.csv*): `time,current_mA` | Baseline current draw                     |
| Serial Monitor   | `Serial.print(digitalRead(3V3))`          | Quick sanity check                       |
| Multimeter shunt | Attach to GND rail on Pi (yellow wire)  | Accurate deep sleep µA measurement        |

<a id="opc-ua-quick-nodes-optional"></a>
### 📌 OPC-UA Quick Nodes *(optional)*
| Node Type                   | Example Path / ID          | Purpose                        |
|-----------------------------|----------------------------|--------------------------------|
| Variable                | `ns=3;i=1008`                     | Simple temp reading              |
| Method Call             | `ns=3;i=2001`                     | Remote procedure invoke          |
| Object                  | `ns=2;i=58880`                     | A folder holding variables       |

*Use [UA Expert](https://www.unified-automation.com/products/development-tools/uaexpert.html) to explore.*

### 📌 Modbus Address Map (Simplified) *(optional)*
| Description               | Address Range       | Example Usage          |
|---------------------------|--------------------|-----------------------|
| Coils/Discrete Outputs    | 0x0000–0xFFFF    | On/Off states         |
| Discrete Inputs            | 0x1000–0x1FFF    | Door sensors           |
| Holding Registers           | 0x2000–0x2FFF    | Temperature x10       |
| Input Registers             | 0x3000–0x3FFF    | Analog sensor readings  |

<a id="software--library-landmarks"></a>
## 📚 Software & Library Landmarks

| Use Case               | Library / Framework                                     | Quick Link                                                                         | Typical Module                          |
|-----------------------------|-----------------------------------------------------------|-----------------------------------------------------------------------------------------|---------------------------------------------|
| MQTT Client (ESP32)         | PubSubClient ESP                     | [GitHub](https://github.com/knolleary/pubsubclient)                            | Modules 4, 5, 7, 8                         |
| LoRaWAN ESP32               | RadioHead or LoRa library              | [LoRa-Net](https://github.com/LoRa-net/LoRa)                                      | Module 5                                    |
| OPC-UA Client (ESP32)        | [open62541](https://github.com/open62541/open62541)      | [open62541](https://github.com/open62541/open62541)                              | Module 6 (optional)                                    |
| OPC-UA Python                | freeOPC-UA (UA-Expert)                | [GitHub](https://github.com/FreeOpcUa/python-opcua)                               | Module 6 (optional)                                    |
| Modbus TCP (Python)          | pymodbus                              | [Docs](https://pymodbus.readthedocs.io/)                                           | Module 6 (optional)                                    |
| ESP32 Gateway Firmware        | ESP32-MQTT-Client via Arduino Core    | [GitHub](https://github.com/espressif/arduino-esp32)                             | Modules 4–8                                  |

## 🧰 Tool gotchas

- **Pasting into a shell:** multi-line blocks with comments can execute line by line. Save the block to a file (or use a heredoc) and run the file. On Windows, use the editor's **Git Bash** profile or WSL.
- **SSH host keys after a reflash:** a reflashed router presents a new host key. Remove the old entry (`ssh-keygen -R <host>`) instead of disabling the check.
- **`opkg update` first:** installs fail on a stale package list. Run `opkg update` before `opkg install tcpdump` or `kmod-batman-adv`.
- **Capturing on `any`:** `tcpdump -i any` can show the same packet twice (ingress and egress). Note the interface when you interpret a capture.
- **Nebula has no `nebula1`:** run it in the foreground first (`/etc/nebula/nebula -config …`) instead of with `nohup`; the error is almost always a wrong `pki.*` path, a missing lighthouse in `static_host_map`, or a key with the wrong permissions.
- **`certificate is not yet valid` / `expired`:** the node clock is wrong. Check `date` on the router (NTP) before touching certificates.
- **Overlay ping works one way:** the receiving node's firewall is blocking the Nebula UDP port (default `4242`) — outbound UDP is open by default, inbound is not.
- **Windows installer fails silently:** `install.ps1` needs an **elevated** PowerShell and `nebula.exe` on `PATH` (or in `C:\Program Files\Nebula\`). `-NoStart` isolates install problems from service problems.
- **After a re-sign:** refresh only the credentials (`install.sh --certs-only` / `install.ps1 -CertsOnly` / copy the `.crt` on the router) — do not overwrite a working config just because the certificate changed.
- **Retained MQTT messages:** a “live” test may show an old retained value. Clear retained state or publish a fresh value before you draw conclusions.
- **Throughput/latency measurements:** note the payload size, protocol, channel, and load. A single ping is not a benchmark; use `iperf3` and repeat.
- **Clock skew:** timestamps from different devices disagree. Compare durations, not absolute times, unless the clocks are synced.
- **Node-RED is not on the router.** Module 1 uses the `classroom-nodered.sh` fleet on the class host; Module 4 onward uses your own Node-RED install on the class host or a laptop. The router runs Mosquitto and, optionally, small MicroPython services. A MicroPython IoTknit port is planned, not yet supported.

<a id="troubleshooting-quick-drops"></a>
## 🧰 Troubleshooting Quick Drops

| Symptom                                   | Diagnosis               | Fix                                                                              | Module         |
|-----------------------------------------------|-------------------------------|---------------------------------------------------------------------------------------|--------------------|
| ESP32 can’t `pubsub.connect()`              | Wrong broker IP/port           | Check `client.setServer()` vs. `mosquitto` running status.                            | 4, 5, 7, 8         |
| `mosquitto_sub` sees no messages              | ESP32 not publishing            | Firmware crashed; check `Serial.print()`; reboot.                                      | 4, 5              |
| Pi gateway loses WiFi every 5 min             | Router deauth drops ESP32        | Switch router to WPA2-AES; ESP32 power saving = 0 in config.h.                   | 7                  |
| RSSI jumps wildly (+/-15 dBm)                 | Multipath interference         | Move router to higher shelf; switch channels or use 5 GHz.                               | 5                  |
| LoRa messages arrive 20% packet loss          | Channel busy or ADR hysteresis  | Lora.begin(915E6); check `lora.receive(2000)` timeout.                                | 5                  |
| Battery voltage drops 10% overnight            | Deep sleep leaking 50 µA         | Comment out `Serial.begin()`; add `#ifdef DEBUG` guard.                               | 5                  |
| OPC-UA discovery fails                         | Firewall blocking 4840           | `sudo ufw allow 4840`; use open62541 debug logging.                                 | 6 (optional)                  |

## 🧑‍🏫 Reflection Questions Bank (Snippets to Spark Discussions)

Use these as portfolio prompts or in-class hook.

### Power & Battery Life
- *"If your ESP32 consumes 8 mA in light sleep and 100 mA awake every 15 min, how long does a 500 mAh coin cell last? (≈100 days)"*

- *"What’s more painful: hunting for 1 µA leaks or waiting for firmware flashes? What’s the bigger impact on time schedule?"*

### Gateway Design
- *"Your gateway lost WiFi every 30 mins—switch to *USB WiFi dongle* or move router? What’s the lowest-effort fix?"*

### Industrial Protocols (Module 6, optional)
- *"Would you rewrite factory code if OPC-UA adds 10 JSON fields? How does JSON compare to Tag encoded as 32-bit int?"*

## 💡 Tips from Students & Instructors (Pull-Requests Welcome)

- From CS Student #23: "I added `setCpuFrequencyMhz(80)` to `setup()` in sleep-heavy firmware—dropped active current 60 mA → 25 mA. Portfolio entry: *‘Power hack cheatsheet’* guide."

- From Prof #3: "Keep 2 *batteries* per lab: fresh coin cell and reused 2000 mAh LiPo for comparison. Lesson: students never touch the LiPo due to fear of fire— bring a 5 V USB power probe instead."

<a id="instructor-hints"></a>
## 🧑‍🏫 Instructor hints

**Before the first studio.** Label every router and node, record which router is the lab uplink, and keep one known-good Ethernet cable and one known-good M5Stack. Test the local Mosquitto broker on the gateway and the `classroom-nodered.sh` fleet for the Master Class; from Module 4, students run their own Node-RED on the class host or a laptop. Node-RED does not run on the router. If you use the B.A.T.M.A.N. stretcher, pre-check that the routers have `kmod-batman-adv` and a common Wi-Fi channel.

**Nebula in one session — bundles, not ceremonies.** Before class, create the class CA and sign **one certificate per pod** for its router (e.g. `pod07-router`, `10.100.0.7/24`, group `students`), plus laptop certs for the students who have admin rights on their own machine. Generate the configs and bundles and hand out **one croc code per pod** (`fleet croc --select group:students`), with the lighthouse already in `static_host_map`; the [bundles chapter](https://github.com/iotempire/nebula-manager/blob/main/docs/bundles.md) is the reference. Two things to prepare: (1) the router path needs a **static `nebula` binary** matching MIPS/ARM — pre-download the right release and keep it on a USB stick or an HTTP folder, because 16 MB of flash will not take a package install; (2) a **re-sign drill** for the pod that loses its key (`cert resign-all` or a single `sign`, then `--certs-only`) — it is a five-minute lesson in why the key *is* the credential. Never put the CA key on a shared drive, and delete the student bundles from the instructor host at the end of the day.

**Pods and checkpoints.** Form Task Pods of two or three on Day 1 (three is the default for a large cohort). The checkpoint schedule, the 2-pod practice round, and the video alternative are defined in the [syllabus](../syllabus.md#how-module-points-are-earned-portfolio-evidence-and-checkpoints); run the slots from there. Treat checkpoints as feedback on the portfolio evidence, not as task-completion audits, and keep them a short conversation rather than a presentation rehearsal.

**Studio rhythm.** Open with the challenge brief, then the rounds. Fold the theory into the work: each round has a short **Theory you need** box read only when the task needs it, and ends with a short **discussion** with one person at the nearest pod. Call it a discussion, not a gate: the round table names the learning goal and theory box it checks, and the question asks for understanding, not task completion. There is no separate pod-study block and no scheduled whole-pod hand-off; the exchange is ad hoc and one-to-one. If a box is not enough, allow a **study break**: read the source, then explain it to one person. Protect the break, and close with the optional short **harvest** if it fits — never a quiz. Resist the urge to lecture the concept a second time; let the task surface the gap. Module 2 was the first module in this class with the new rhythm; Modules 2–7 now use it. Module 1 remains the exception because its Master Class opening is the course introduction, not a pod-study block to migrate mechanically.

**Network safety.** Keep every experiment inside the isolated lab router network. Never plug a rogue DHCP server into the campus network. Before any mesh/overlay lab, agree on team IDs, channels, and address ranges; write them on the board.

**Packet capture in the room.** Assume **one Wi-Fi adapter per laptop and no monitor mode**: a laptop cannot see another station's unicast traffic, and Windows rarely supports monitor mode at all. Prepare capture *points*, not sniffers: (a) `tcpdump` on the router — it is on the class image, and `br-lan` covers the LAN; (b) one ESP32 running [`martin-ger/esp32_eth_wifi_bridge`](https://github.com/martin-ger/esp32_eth_wifi_bridge) as a transparent tap that streams pcap over TCP port 19000 (`pcap start`); and (c) one recorded dump per module (`module01.pcap`, `module02.pcap`, …) for pods whose hardware or laptop cannot capture that day. Open every dump yourself before handing it out, and say out loud that analysing a provided dump is full evidence. Hand out the **USB sticks and mini hubs for extroot** in Module 2 — Nebula does not fit into 16 MB of flash — and walk through the [extroot recipe](#packet-capture-without-a-second-wifi-card) with the first pod that hits it; Module 3 then verifies `/overlay` instead of discovering the problem.

**Bus and fieldbus coverage.** Low-level buses (UART, I²C, SPI, OneWire) belong to the Sensors & Actuators and Microcontroller Programming courses. Industrial fieldbuses (RS-485/Modbus, CAN, Profinet, TSN) are covered in [Module 6](../modules/06-industrial-protocols-and-bridging.md), including the ISO/OSI mapping and the bus comparison table. Do not duplicate the bus survey in Module 2; revisit it in Module 7/8 only if the project wiring needs it.

**Module 6 (fieldbuses) — keep it short.** One video, one discussion, the RS-485/Modbus demo if the hardware is there, and the EtherCAT guest slot. The OSI/bus tables are reference; do not turn this into an industrial lab. A guest lecturer with the test device upstairs is a strong optional slot, not a dependency.

**Stories.** The stories in the modules are deliberately separate case studies. Keep new examples consistent with the [story canon](#story-canon-the-recurring-cast), and make a story concrete enough to pitch in a minute: one named person, one place, one moment of pain, something at stake.

**Demo day.** Ask every Project Team for a fallback recording of the live flow. Run the fault injection yourself (pull an intermediate router, unplug a node, restart the broker) and let the team explain the recovery. The rubric lives only in the syllabus.

**Slides (optional).** Module 1's opening is presented from the plain-Markdown deck [`slides/01-introduction.md`](../slides/01-introduction.md); render it with [`slides/render-slides.sh`](../slides/render-slides.sh) (pandoc + Typst → 16:9 PDF, `---` separates slides, `<!-- note -->` is a speaker hint that is dropped from the PDF). For further sessions, keep the same format: plain Markdown, no notebook runtime and no browser-only presentation tool.

<a id="story-craft-is-it-concrete-enough"></a>
## ✍️ Story craft: is it concrete enough?

Hitting the right level of abstraction is genuinely difficult. The balance between *too abstract* ("a network for a factory") and *too precise* (an already-finished specification) **is** the skill. The test: a story is concrete enough when it is **pitchable** (you can pitch it in a minute) and/or **playable** (it could carry a short film or a stage scene) — one named person, one place, one moment of pain, and something at stake.

<a id="story-canon-the-recurring-cast"></a>
## 📖 Story canon: the recurring cast

The module stories share a small cast of named (fictional) organizations and people. New material should stay consistent with them — the stories are deliberately kept as separate case studies.

| Module(s) | Organization | People | Place |
|---|---|---|---|
| 1, 2, 7, 8, 9 | **Stadtwerke Gütersloh** — municipal utility / district heating | **Petra Sommer** (network operations), **Malik Yilmaz** (field engineer) | Gütersloh |
| 3, 5, 8 | **Lumenwerk Gütersloh GmbH** — interactive light installations | **Mara Voss** (creative director), **Jonas Feld** (embedded technician) | Gütersloh |
| 4, 8 | **Frachtflow** — logistics startup / warehouse | **Nils Bergmann** (lead developer), **Rosa Klein** (operations) | Gütersloh |
| 5, 8 | **Klimapark GmbH** — greenhouse / urban-farming startup | **Dr. Elif Kaya** (agronomist), **Tobias Kern** (operations) | Gütersloh |
| 6 | **Brinkmann Maschinenbau GmbH** — special-purpose machines | **Hendrik Brinkmann** (workshop lead), **Sofia Roth** (automation engineer) | Bielefeld / Gütersloh |
| 1 | **Cirrus Cloud Systems** — the vendor pitching a cloud-only stack | — | — |

> Cross-course consistency: Wittkamp, Frachtflow, and the local-first theme also appear in the Databases and Sensors/Actuators courses. Reuse the names, but keep each course's story self-contained.

<a id="extended-reading"></a>
## 📚 Extended reading

- **Architecture and layering:** [RFC 1958](https://www.rfc-editor.org/rfc/rfc1958) · [RFC 3439 §3](https://www.rfc-editor.org/rfc/rfc3439#section-3) · [Wikipedia: OSI model](https://en.wikipedia.org/wiki/OSI_model)
- **TCP/IP and routing:** [RFC 1918](https://www.rfc-editor.org/rfc/rfc1918) · [RFC 2131](https://www.rfc-editor.org/rfc/rfc2131) · [RFC 3022](https://www.rfc-editor.org/rfc/rfc3022) · [Practical Networking](https://www.practicalnetworking.net/)
- **Overlays and mesh:** [Nebula](https://nebula.defined.net/docs/) · [Yggdrasil](https://yggdrasil-network.github.io/) · [OpenWrt batman-adv](https://openwrt.org/docs/guide-user/network/wifi/mesh/batman)
- **Messaging:** [MQTT 5.0](https://docs.oasis-open.org/mqtt/mqtt/v5.0/mqtt-v5.0.html) · [HiveMQ: MQTT essentials](https://www.hivemq.com/mqtt-essentials/) · [Node-RED](https://nodered.org/docs/) · [paho-mqtt](https://eclipse.dev/paho/files/paho.mqtt.python/html/index.html)
- **Wireless:** [ESP-NOW](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/api-reference/network/esp_now.html) · [LoRa Alliance](https://lora-alliance.org/) · [Bluetooth LE](https://en.wikipedia.org/wiki/Bluetooth_Low_Energy)
- **Industrial:** [Modbus](https://modbus.org/) · [OPC-UA](https://opcfoundation.org/about/opc-technologies/opc-ua/) · [TSN](https://en.wikipedia.org/wiki/Time-Sensitive_Networking)
- **Fleet and method:** [IoTempower](https://github.com/iotempire/iotempower) · [Story-driven modeling](https://en.wikipedia.org/wiki/Story-driven_modeling) · [Challenge-based learning](https://en.wikipedia.org/wiki/Challenge-based_learning)

## 📌 Next Steps
- Add your tricks to this page via Pull Request into your class folder.
- Contribute dataset screenshots, CSV logs, or fixed typos to the portfolio repositories.
- *Tip: Use this bank as your session ‘go-to’ sheet—annotate margins with sticky notes!*

*[Back to Workbook](../README.md)*
