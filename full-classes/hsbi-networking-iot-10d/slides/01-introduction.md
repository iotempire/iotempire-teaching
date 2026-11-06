# Networking and IoT Solutions (Vernetzung und IoT-Lösungen) — 10-Day Edition

### Day 1 · Introduction, Pre-Study Rehash & The Master Class

*Make things talk to each other — then prove the system still works when something dies.*

<!--
Render:  ./render-slides.sh 01-introduction.md
Reading: pandoc + typst -> 16:9 PDF; `---` separates slides; HTML comments are
speaker notes and are dropped from the PDF.
-->

---

# whoami

**ULrich NOrbisrath (ulno)** — [me.ulno.net](https://me.ulno.net)

- Educator · Consultant · Mentor
- Researcher · Inventor · Maker · Artist
- YouTuber ([youtube.ulno.net](https://youtube.ulno.net/)) → Geek
- **Globalist** — lived, taught, and researched in
  Estonia · USA · Germany · Austria · Kazakhstan · Singapore · Indonesia · Brazil
- **Research:** VR/AR · Internet of Things · Digital Twin · Software Craftsmanship · Education & Creativity
- **PhD: Home Automation** (RWTH Aachen)
- Around here: [IoTempire](https://iotempire.net/) and [IoTempower](https://iotempower.us)

<!-- Note: one minute. Point them at me.ulno.net; do not read the list aloud. -->

---

# Who are U?

*(Write this down — it is the **start of your in-class portfolio notes**, in addition to the pre-study.)*

- Who has **programming** experience? In which languages?
- Who has used a **microcontroller** — Arduino, ESP32/ESP8266, Raspberry Pi, …?
- Who has **configured a router**, set an IP address by hand, run `ping` / `traceroute`?
- Who has used **Wireshark**, `tcpdump`, or a packet capture?
- Who has used **MQTT**? **Node-RED**? **Python**? The **command line**? **Git/GitHub**?
- **What would you like to connect to what?**
- **What do you expect from this class?**

<!-- Note: hands up, count out loud. Their answers are their first in-class portfolio section and drive the podding. -->

---

# This is an experiment!

- Teaching with **modern education principles** — challenge- and project-based
- You are supposed to **learn and explore**
- Put **you** front and center; give the content **meaning**
- **You** bring a meaningful challenge
- This is a **first-time course**: parts of it are still being written, with you

<!-- Note: be honest about the moving bar; it is an invitation, not an excuse. -->

---

# How the class works — the deal we make

- Every module **begins with its learning goals** — that is the *contract*: demonstrate the goals and you have met the module
- The **tasks are a draft** — you may modify, replace, or extend them, as long as you reach the goals
- Tasks are marked with tiers; the **syllabus** explains what **★ Core** and **◇ Stretcher** mean for you
- A moving ***DRAFT BOUNDARY*** marks what we are still designing together — your input shapes it
- **AI drafts, you verify** — against a capture, a datasheet, a routing table, or a running system
- **Already know a topic?** Skip the task, document why, and show the skill in a quick check

*(Let's open the syllabus and Module 1 together now.)*

<!-- Note: the goals are fixed; the tasks are negotiable. Keep all assessment talk in the syllabus. -->

---

# Class logistics (short version)

- **No separate exercise sheets** — but expect at least ~6 hours/week of self-study to finish labs, portfolio, and project work
- **10 working days / 48 contact hours, one module per day**; session lengths vary (typically two sessions of 2 × 45 min, longer blocks on some days)
- You work in small **Task Pods of two or three** (three by default in a large cohort). For the **final project, two pods merge into a Project Team (4–6)**
- In-class exercises are initially **individual**
- **Ongoing feedback** in the lab — talk to us!
- **Assessment, checkpoints, task tiers, and the grade scale live in the syllabus** — your **portfolio** is the record

<!-- Note: point at the syllabus; do not summarise assessment here. -->

---

# Everything lives in the online workbook

Central entry point: **the course repository**.

- **[Module index & roadmap](https://github.com/iotempire/iotempire-teaching/blob/main/full-classes/hsbi-networking-iot-10d/modules/00-index.md)** — every module and the day-by-day plan
- **[Syllabus](https://github.com/iotempire/iotempire-teaching/blob/main/full-classes/hsbi-networking-iot-10d/syllabus.md)** — schedule, objectives, assessment, tools, policies
- **[Pre-study guide](https://github.com/iotempire/iotempire-teaching/blob/main/full-classes/hsbi-networking-iot-10d/pre-study.md)** — Module 0
- **[Module 1](https://github.com/iotempire/iotempire-teaching/blob/main/full-classes/hsbi-networking-iot-10d/modules/01-foundations-and-masterclass.md)** — today's module
- **[Resource bank](https://github.com/iotempire/iotempire-teaching/blob/main/full-classes/hsbi-networking-iot-10d/modules/Z-resources-bank.md)** — cheat sheets, RFCs, troubleshooting, story canon
- **[Master Class workbook](https://github.com/iotempire/iotempire-teaching/blob/main/workshops/mastering-iot-solutions/README.md)** — the hands-on steps for today

*(Let's open the workbook on screen now — this is the material we will actually use.)*

---

# Today's path

1. **Who we are** — and how this class works
2. **Form Task Pods** and check in on the pre-study
3. **The story** — a dashboard that needed a cloud
4. **Pod study** — the IoT computing continuum and what layers cost
5. **The Master Class** — a real sensor, broker, and dashboard, end to end
6. **Measure, then pitch** — the overhead, and the system you just built

<!-- Note: this is the map for the day; keep it to 30 seconds. -->

---

# Form your Task Pod — who do you build with?

1. On a note, write **your skills** (networking, Linux, Python, hardware, documentation, design, …) and **your expectations / what you want to build**.
2. No pod yet? Find **one or two other unpaired people** (three-person pods are the default in a large cohort; pairs are welcome). Compare notes and check whether you **complement** each other — not just “same as me”.
3. Exchange contacts and a first idea today. If you already have a pod, share your notes so the room knows who can help with what.
4. Agree on how you keep in touch and how you split roles.

> **Why “Task Pod”?** In orchestration a *pod* is the smallest deployable unit — a few tightly coupled containers that are scheduled, run, and retired together. Your pod is that, for people. Two pods later merge into a **Project Team**.

<!-- Note: give them a hard stop and walk the room. Do not let pods form by friendship alone. -->

---

# Portfolio check — before we touch hardware

1. **No repository yet? Do it now — it takes two minutes.** [Create it in one click](https://github.com/new?template_name=iot-portfolio-template&template_owner=iotempire) → name it exactly `net-iot-hsbi-2026-portfolio` → *Settings → Access → Add people* → **`ulno`** (role *Write*). Nothing in this module can be checked without that invite.
2. Today's entry is a **section in `Module01/README.md`**, not a new file — files are fine too, sections are simpler to read.
3. Write **`## Who I am`** (your *Who are U?* answers + expectations) and **`## My pod`** (names, skills, first idea).
4. During the day you add **`## Pre-study artefact`**, **`## Study log`**, and (optional) **`## Story seeds`** — shared notes are kept **once per pod**; the others link to that section and add one sentence.
5. Commit and push — a small commit with a clear message.
6. Keep `PreStudy/` where it is: this is an **additional** in-class entry, not a replacement.

<!-- Note: help anyone without a repo. This is the first evidence entry for today. -->

---

# Pre-study check-in

*(In your pod. Two minutes per person.)*

1. Show **one artefact** from Module 0 — your packet-path sketch, the `traceroute` with the private-to-public transition marked, or your first MQTT screenshot.
2. Explain **one thing you understood only after doing it**.
3. Name **one question you still have** — park it on the board.

*(We pick the questions up during the day; several of them are today's lesson.)*

<!-- Note: walk around and listen for gaps. Do not reteach the pre-study. -->

---

# The story — The Dashboard That Needed a Cloud

**Stadtwerke Gütersloh** operates district-heating substations across the city.

**Petra Sommer**, network operations, wants one simple thing: the **temperature and pressure of each substation**, updated every few seconds, visible in the control room and on a technician's phone.

**Cirrus Cloud Systems** proposes the usual stack: a cloud broker, a managed database, a monthly fee — and a firmware update for every controller.

<!-- Note: name the people. The story needs a person, a place, a moment of pain. -->

---

# The two questions we do not answer today

> **Petra:** *“The data is produced in the basement of a building we own, and the person who reads it is standing in the same building. Why does it need a round trip through the internet?”*

> **Malik Yilmaz, field engineer:** *“And when the uplink is down — what does my dashboard show me?”*

By the end of today you will have built the loop those two questions are about. Whether the answer is *“the cloud”* or *“a box in the basement”* is yours to defend.

<!-- Note: leave the questions open. Do not resolve them; the day resolves them. -->

---

# What you will build today

```text
  [ M5StickC ]  --Wi-Fi-->  [ Broker ]  -->  [ Node-RED ]
   button, LED,               (MQTT)          gauge, chart,
   DS18B20 temp                               +/temp heatmap

  ... and the other way:  Node-RED  -->  Broker  -->  M5StickC LED
  ... and the whole room on one chart with +/temp
```

- A **sensor** that publishes, a **broker** that carries, a **flow** that reacts
- A **button** that switches hardware in another part of the room
- A **dashboard** a stranger could read without you talking

<!-- Note: point at the room, not the diagram. They will build all three parts in one session. -->

---

# The Master Class — five phases

Follow the **[Master Class workbook](https://github.com/iotempire/iotempire-teaching/blob/main/workshops/mastering-iot-solutions/README.md)**; Module 1 adds the story and the evidence.

1. **First contact** — room Wi-Fi, your Node-RED, inject → debug
2. **Your stick answers** — button, LED, screen text
3. **The domino chain** — your button switches your neighbour's LED
4. **A real sensor** — connect the DS18B20 (Grove protoboard, or three jumpers), watch an over-the-air deploy
5. **The control room** — gauge, chart, and the whole room with `+/temp`

*Then: measure what it cost, and pitch the system.*

<!-- Note: the phases are a path, not a schedule. See the next slide. -->

---

# The order is a suggestion

- The phases are a **path**, not a timetable. Take a different route if your pod can still **prove the goals**.
- **The instructor demos live in Node-RED** — ask for the demo you need, when you need it, instead of waiting.
- Stuck on wiring? Swap to a flow task. Bored of flows? Wire the sensor. The room is a lab, not a queue.
- **Write down what you changed and why.** The checkpoint question is always *“what did you choose, and what did it cost you?”*

<!-- Note: say this out loud. It is the licence students need to work at their own pace. -->

---

# Where you are

| What | Where to find it |
|:---|:---|
| Room Wi-Fi | `iotempire-b1300-5g` (laptop) · `iotempire-b1300` (2.4 GHz, sticks) · password `iotempire` |
| Your Node-RED | `http://<instructor-ip>:18nn/` — exact address and port on the board |
| Login | `admin` + the password on your sticky note |
| Broker | `broker.internal` → `192.168.114.1:1883` (classroom router) — already configured |
| Your node | the M5StickC labeled with your pod's two-digit ID |

**Hardware per pod:** 1× M5StickC, 1× USB-C cable, 1× Dallas DS18B20 — Grove protoboard or 3 jumpers.

<!-- Note: display this slide while handing out hardware. Write the instructor PC's IP on the board. -->

---

# Your roles — and rotate them

- **Driver** — laptop, Node-RED canvas, deploys
- **Navigator** — workbook open, topics and pinouts, keeps the notes
- **Documenter** — photos, screenshots, the one-line “what just happened”

Every member should have **published to a topic** and **wired a jumper** at least once today. Swap after each phase.

> **Who owns the machine?** Your Node-RED runs on the instructor's host. That is why there is nothing to install — and why the whole room shares one point of failure. Keep that for the pitch.

<!-- Note: the "who owns the machine" line is the resilience seed for Module 2 and Module 9. -->

---

# Story hooks — add a chapter

The story is not finished. Each phase has a chapter you can extend with **what you just saw**:

- **The lamp test** — a basement button lights a lamp in the control room.
- **“I am here”** — Malik's button, and the light that says the door is open.
- **The alarm relay chain** — each substation rings the next; the last rings the first. *What happens when pod 07 goes for coffee?*
- **Somebody leaned on the pipe** — pinch the sensor: a burst pipe. Pull the jumper: `-127`. The sensor is not lying.
- **Petra's accountant** — twenty bytes of temperature in a frame that is mostly paperwork.
- **The district is the room** — the `+/temp` chart, and the corner that is always colder.

Add **one line of your own** to your portfolio and bring it to the pitch.

<!-- Note: leave this slide up during the lab. Ask pods which chapter they are living in right now. -->

---

# What to keep today

- `## Who I am` and `## My pod` in `Module01/README.md`
- One pre-study artefact, linked with one sentence
- A screenshot of inject → debug, and your button/LED flow
- Your **domino** flow as `.json`, and what its weakest link is
- A photo of the wired stick and `<id>/temp` arriving
- The gauge, the chart, and the `+/temp` heatmap
- Your **overhead table** with the assumptions behind it
- The **continuum sketch**, the two-minute pitch, and the weakest-link sentence

<!-- Note: not a checklist to tick — the evidence proves the goals. Students may prove them another way. -->

---

# Before you leave

1. **One line for the story** — what did your system do that surprised you?
2. **Commit** — small commit, clear message, link your pod mates where you did not work alone.
3. **One question for tomorrow** — leave it on the board.

**Next: Module 2 — Local Networking & OpenWrt Gateways.** Subnetting, DHCP, DNS, NAT, and the first capture at the choke point.

**Questions?**

<!-- Note: close with the next concrete action. Do not end on the slides — end on the board. -->
