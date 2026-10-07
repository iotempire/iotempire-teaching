<!--
Session 1 slide deck for Databases (DBS) — Local-First Edition, HSBI Campus Gütersloh.

Plain Markdown: open it in any Markdown viewer (Zed Markdown preview, GitHub, VS Code),
or present it from the terminal with presenterm (https://github.com/mfontanini/presenterm):

    presenterm slides/01-introduction.md

Slides are separated by a lone `---` line. Speaker notes use `<!-- speaker_note: ... -->`
and appear only in presenterm's speaker-notes view. No build step, no runtime — the live
Python is run on demand from the workbook modules in Zed or the terminal.
-->

# Databases (DBS) — Local-First Edition

### Session 1 · Introduction & Local-First Foundations

*How does raw data become a trustworthy, fast, and safe answer — on a machine you actually own?*

---

# whoami

**ULrich NOrbisrath (ulno)** — [ulno.net](https://ulno.net)

- Educator · Consultant · Mentor
- Researcher · Inventor · Maker · Artist
- YouTuber ([youtube.ulno.net](https://youtube.ulno.net/)) → Geek

<!-- speaker_note: Introduce yourself and point them at ulno.net. Keep it to a minute. -->

---

# whoami (cont.)

- **Globalist** — lived, taught, and researched in
  Estonia · USA · Germany · Austria · Kazakhstan · Singapore · Indonesia · Brazil
- **Research:** VR/AR · Internet of Things · Digital Twin · Software Craftsmanship · Education & Creativity
- **PhD: Home Automation** (RWTH Aachen)

---

# Who are U?

*(Write this down — it is the **start of your personal portfolio**. Note the sub-questions as we interact.)*

- Who has a lot of **programming** experience? In which languages?
- Who has written **SQL** before? (`SELECT`, `WHERE`, `JOIN`, `GROUP BY`, …)
- Who has used a **database**? Which one — MySQL, PostgreSQL, SQLite, Oracle, MongoDB, …?
- Who has used **Python**? Who has used the **command line** / a terminal?

<!-- speaker_note: Hands up, count out loud. Their notes here become their first portfolio entry. -->

---

# Who are U? (cont.)

- Who has used **Git / GitHub**?
- Who has built a **web app** (a frontend and/or a backend)?
- Who has run their own **server** or a Docker container?
- Who has an idea what **“local-first”** or an **embedded database** might mean?
- **What are your expectations from this class?** What would you like to build?

<!-- speaker_note: The expectations answers drive the podding and the project ideas. -->

---

# This is an experiment!

- Teaching with **modern education principles** — challenge- and project-based
- You are supposed to **learn and explore**
- Put **you** front and center; give the content **meaning**
- **You** bring a meaningful challenge

---

# Class logistics & assessment (short version)

- Usually **no dedicated homework** — but finish lab work, module tasks, portfolio, and reflections
- **You work in small Task Pods** — two or three (three by default; a few pairs; four only by arrangement). For the **final project, two pods merge into a Project Team (4–6)**.
- In-class exercises are initially **individual**
- **Ongoing feedback** in the lab — talk to us!
- Final assessment: **module points + final project + reflections** (+ bonuses), with your **portfolio** as the record
- The details live in the **syllabus** — next slide

<!-- speaker_note: Emphasise the pod work and the continuous in-lab feedback. -->

---

# Everything lives in the online workbook

Central entry point: **the course repository**.

- **[Module index & roadmap](https://github.com/iotempire/iotempire-teaching/tree/main/full-classes/hsbi-databases-10d/modules/00-index.md)** — every module, session, and a one-line summary
- **[Syllabus](https://github.com/iotempire/iotempire-teaching/tree/main/full-classes/hsbi-databases-10d/syllabus.md)** — schedule, learning objectives, assessment, tools, policies
- **Modules 1–8** — the actual studios

<!-- speaker_note: Open the repository on screen so they see the real thing, not a picture of it. -->

---

# How the class works — the deal we make

- Every module **begins with its learning goals** — that is the *contract*: demonstrate the goals and you have met the module
- The **tasks are a draft** — you may modify, replace, or extend them, as long as you reach the goals
- A moving ***DRAFT BOUNDARY*** marks what we are still designing together — your input shapes it

*(Let’s open the workbook together now.)*

<!-- speaker_note: This is the deal. The goals are fixed, the tasks are negotiable. -->

---

# Form your Task Pod — who do you build with?

1. On a note, write **your skills** (languages, tools, hardware, design, …) and **your expectations / what you want to build**.
2. No pod yet? Find **two other unpaired people**, compare notes, and check whether you **complement** each other — not just “same as me”.
3. **You will work in a Task Pod — two or three (three by default)** (a few pairs). Exchange contacts and a first idea today.
4. Optional: pair your pod with a **neighbouring pod** — each pre-verifies the other, and the instructor assesses one half of each in a single checkpoint slot.
5. For the **final project, two pods merge into a Project Team of 4–6** — your neighbouring pod is the natural partner.

<!-- speaker_note: Ask one pod to say out loud what they expect from the module. It anchors the session. -->

---

# Discovery: what are the two shapes a database can take?

*(In your pod — a few minutes.)*

1. **Brainstorm:** when does a database live **inside** your program, and when does it live on a **separate server**?
2. List **one advantage** and **one cost** of each shape.
3. **Jigsaw:** one of you joins a neighbouring pod, the rest stay; **merge** your lists.

<!-- speaker_note: Do not advance yet. Collect their answers on the board first. -->

---

# The answer: two shapes of a database

| | Embedded (SQLite, DuckDB) | Client/server (MySQL, PostgreSQL) |
|---|---|---|
| Where it runs | Inside your process, as a library | A separate server process you connect to |
| Admin needed | None | Users, auth, backups, tuning, upgrades |
| Reliability | “Down” is not a state — no server to fall over | Network + server + credentials are failure modes |
| Concurrency | Many readers, **one writer** at a time | Many concurrent writers |
| Sweet spot | Local apps, edge devices, single-node analytics, tests | Many concurrent clients, networked multi-user apps |
| Cost | Zero infrastructure | A server, an operator, a bill |

**Keep the data where it is produced.** Ship a file, not a deployment. Go to a server only when a *measured* requirement forces you to — **GoToSocial** (a whole Fediverse server on SQLite) and **Chatto** (a chat platform as one binary) each ship as a **single binary**.

<!-- speaker_note: Advance only after they have shared their own table. Compare, then add what they found. -->
