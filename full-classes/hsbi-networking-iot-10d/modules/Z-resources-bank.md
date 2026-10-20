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
- **PowerShell translation** (only if you must stay there): `mkdir -p module-02` → `New-Item -ItemType Directory -Force module-02`; `cmd < file` → `Get-Content file | cmd`; `time cmd` → `Measure-Command { cmd }`.

> Keep one terminal for the router SSH session and one for the laptop capture. Do not paste multi-line shell blocks with comments into a PowerShell prompt; save them to a file and run the file.

<a id="git--github-primer-template-editor-markdown-conflicts"></a>
## 🐙 Git & GitHub primer (template, editor, Markdown, conflicts)

In class we work with **GitHub on the web** and the **Git UI inside your editor** (VS Code or Zed) — commit, fetch, pull, and push from the buttons, not the terminal. **`gh` is used exactly once: to clone your new repository.** Command-line `git`/`gh` and SSH keys are *optional*.

### Create the portfolio from the template (not a fork)

1. Open [iot-portfolio-template](https://github.com/iotempire/iot-portfolio-template) → **Use this template → Create a new repository**.
2. Name it `networking-portfolio` and make it **public** (or at least readable by the instructor).
3. Add the instructor as a collaborator (repo → *Settings → Collaborators → Add people*).

> A **template** gives you a fresh repo with one clean commit and no upstream link; a **fork** keeps a link to the original and the full history — not what a personal portfolio wants.

### Clone it once with `gh`

```sh
gh auth login                                # GitHub.com → HTTPS → "Login with a web browser"
gh repo clone <you>/networking-portfolio     # the ONLY gh command you need
```

Then **open the folder in VS Code or Zed** and do everything else in the editor's Git UI.

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

| Module | Topic                 | Video                                                                               | Guiding Question                                                                 |
|------------|---------------------------|---------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------|
| 1          | OSI Model Critique         | [OSI Model – Practical Perspective](https://www.youtube.com/watch?v=vv4y_vyBGN8)        | How does layering help—or hinder—debugging an MQTT broker crash?                            |
| 1          | OSI vs TCP/IP             | [OSI Model vs TCP/IP](https://www.youtube.com/watch?v=ZT07sZ0tJcc)                     | What benefit does TCP/IP’s flexible layering bring to real-time IoT?                      |
| 4          | MQTT in IoT                | [MQTT Beginner Guide](https://www.youtube.com/watch?v=hzJ00SqJYeY)                   | How does MQTT’s pub/sub reduce integration friction compared to REST?                      |
| 4          | Mocking Hardware with MQTT  | [Mocking Hardware for IoT](https://www.youtube.com/watch?v=4QbQ0xVGG0M)                 | What’s the benefit of swapping a Python mock for an ESP32 with *no other changes*?       |
| 5          | LoRaWAN Deep Dive          | [LoRaWAN Protocol & Hardware](https://www.youtube.com/watch?v=VhB1Iv7Q3HY)           | What’s the trade-off between WiFi’s throughput and LoRaWAN’s range?                      |
| 5          | WiFi vs LoRaWAN Choices    | [WiFi LoRaWAN Infographic](https://www.youtube.com/watch?v=fFoRz2q2yqA)             | If a project needs a 15 km line-of-sight, which would you pick and why?                      |
| 7          | Raspberry Pi Gateway        | [Pi as IoT Gateway](https://www.youtube.com/watch?v=6Nz7Xv7sLqM)                     | What job does the gateway perform that neither the sensor nor the cloud can do alone?        |
| 6 (optional) | OPC-UA for Beginners       | [OPC-UA Explained](https://www.youtube.com/watch?v=5m5q6XZKJXQ)                        | How is an OPC-UA node different from a Modbus register?                                     |
| 6 (optional) | Modbus for Beginners       | [Modbus Explained](https://www.youtube.com/watch?v=Txv-OT-AJrA)                         | What happens when 100 Modbus devices share a single RS-485 line?                        |
| 5          | ESP32 Deep Sleep Modes      | [ESP32 Deep Sleep vs Light Sleep](https://www.youtube.com/watch?v=ZvfA1XxjVa4)       | What sleep mode achieves 6-month battery life on your ESP-NOW soil sensor?                          |
| 5          | IoT Power Optimization      | [IoT Power Techniques](https://www.youtube.com/watch?v=eEE9xTQHw9c)                   | Why is frequency scaling often unused in IoT? What’s cheaper instead?                         |

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
- **Retained MQTT messages:** a “live” test may show an old retained value. Clear retained state or publish a fresh value before you draw conclusions.
- **Throughput/latency measurements:** note the payload size, protocol, channel, and load. A single ping is not a benchmark; use `iperf3` and repeat.
- **Clock skew:** timestamps from different devices disagree. Compare durations, not absolute times, unless the clocks are synced.

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

**Before the first studio.** Label every router and node, record which router is the lab uplink, and keep one known-good Ethernet cable and one known-good M5Stack. Test the local Mosquitto broker and Node-RED on the gateway before students arrive. If you use the B.A.T.M.A.N. stretcher, pre-check that the routers have `kmod-batman-adv` and a common Wi-Fi channel.

**Pods and checkpoints.** Form Task Pods of two or three on Day 1 (three is the default for a large cohort). The checkpoint schedule, the 2-pod practice round, and the video alternative are defined in the [syllabus](../syllabus.md#how-module-points-are-earned-checkpoint-presentations); run the slots from there. Assess from the portfolio, not from task completion, and keep the checkpoint a short conversation rather than a presentation rehearsal.

**Studio rhythm.** A good 4-hour session is roughly: 15 min opening/warm-up, 45–60 min pod study (concepts, pointers, LLM Q&A, study log), 10–15 min share with a neighbouring pod, a short whole-room clarification, then the lab with the remaining time for debugging and evidence. Resist the urge to lecture the concept a second time; let the pod study surface the gaps.

**Network safety.** Keep every experiment inside the isolated lab router network. Never plug a rogue DHCP server into the campus network. Before any mesh/overlay lab, agree on team IDs, channels, and address ranges; write them on the board.

**Stories.** The stories in the modules are deliberately separate case studies. Keep new examples consistent with the [story canon](#story-canon-the-recurring-cast), and make a story concrete enough to pitch in a minute: one named person, one place, one moment of pain, something at stake.

**Demo day.** Ask every Project Team for a fallback recording of the live flow. Run the fault injection yourself (pull an intermediate router, unplug a node, restart the broker) and let the team explain the recovery. The rubric lives only in the syllabus.

**Slides (optional).** The workbook is the source. If you want slides, write plain Markdown separated by `---` and render a 16:9 PDF with **pandoc + Typst**; do not introduce a notebook runtime or a browser-only presentation tool. HTML comments (`<!-- note -->`) are a good place for speaker hints.

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
