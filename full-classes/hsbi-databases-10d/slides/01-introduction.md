# Databases (DBS) — Local-First Edition

### Session 1 · Introduction & Local-First Foundations

*How does raw data become a trustworthy, fast, and safe answer — on a machine you actually own?*

---

# whoami

**ULrich NOrbisrath (ulno)** — [ulno.net](https://ulno.net)

- Educator · Consultant · Mentor
- Researcher · Inventor · Maker · Artist
- YouTuber ([youtube.ulno.net](https://youtube.ulno.net/)) → Geek
- **Globalist** — lived, taught, and researched in
  Estonia · USA · Germany · Austria · Kazakhstan · Singapore · Indonesia · Brazil
- **Research:** VR/AR · Internet of Things · Digital Twin · Software Craftsmanship · Education & Creativity
- **PhD: Home Automation** (RWTH Aachen)

<!-- Note: introduce yourself and point them at ulno.net — keep it to a minute. -->

---

# Who are U?

*(Write this down — it is the **start of your personal portfolio**. Note the sub-questions as we interact.)*

- Who has a lot of **programming** experience? In which languages?
- Who has written **SQL** before? (`SELECT`, `WHERE`, `JOIN`, `GROUP BY`, …)
- Who has used a **database**? Which one — MySQL, PostgreSQL, SQLite, Oracle, MongoDB, …?
- Who has used **Python**? Who has used the **command line** / a terminal?
- Who has used **Git / GitHub**?
- Who has built a **web app** (a frontend and/or a backend)?
- Who has run their own **server** or a Docker container?
- Who has an idea what **“local-first”** or an **embedded database** might mean?
- **What are your expectations from this class?** What would you like to build?

<!-- Note: hands up, count out loud — their answers are their first portfolio entry and drive the podding. -->

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

<!-- Note: emphasise the pod work and the continuous in-lab feedback. -->

---

# Everything lives in the online workbook

Central entry point: **the course repository**.

- **[Module index & roadmap](https://github.com/iotempire/iotempire-teaching/tree/main/full-classes/hsbi-databases-10d/modules/00-index.md)** — every module, session, and a one-line summary
- **[Syllabus](https://github.com/iotempire/iotempire-teaching/tree/main/full-classes/hsbi-databases-10d/syllabus.md)** — schedule, learning objectives, assessment, tools, policies
- **Modules 1–8** — the actual studios

<!-- Note: open the repository on screen so they see the real thing. -->

---

# How the class works — the deal we make

- Every module **begins with its learning goals** — that is the *contract*: demonstrate the goals and you have met the module
- The **tasks are a draft** — you may modify, replace, or extend them, as long as you reach the goals
- A moving ***DRAFT BOUNDARY*** marks what we are still designing together — your input shapes it

*(Let’s open the workbook together now.)*

<!-- Note: the goals are fixed; the tasks are negotiable. -->

---

# Form your Task Pod — who do you build with?

1. On a note, write **your skills** (languages, tools, hardware, design, …) and **your expectations / what you want to build**.
2. No pod yet? Find **two other unpaired people**, compare notes, and check whether you **complement** each other — not just “same as me”.
3. **You will work in a Task Pod — two or three (three by default)** (a few pairs). Exchange contacts and a first idea today.
4. Very optional (more chances later - even to change your initial pod): pair your pod with a **neighbouring pod** for a **2-pod practice round** — present your learning-goal proof and give each other free-style feedback.
5. For the **final project, two pods merge into a Project Team of 4–6** — your neighbouring pod is the natural partner.

<!-- Note: ask one pod to say aloud what they expect from the module. -->

---

# Warm-up: what is a database — and why SQL?

*(You are in your pods now — do this together, then jigsaw with a neighbouring pod.)*

1. **What is a database?** Say it in your own words — no textbook definition.
2. **Why SQL?** Why query with a language instead of clicking around a spreadsheet?
3. **A bit of “local-first”:** what would it mean to keep the data *with* the app, on the machine that produces it?

<!-- Note: pods answer, then jigsaw one member across; open a short discussion. Collect their answers — do not reveal anything yet. -->

---

# Warm-up: a few angles to compare against

- **A database** is data *plus* a structure, rules, and a way to ask questions — and it keeps working as the data grows and changes.
- **SQL** is the common language of relational data: *declarative* (say what you want, not how), readable, portable, and it outlives any single tool — BI, analytics, and ML all read it.
- **Why local-first (in one line):** most data is created *and* read on the same machine. Keep it there; add a server only when a *measured* need forces you to.

<!-- Note: a discussion seed, not a definition to memorize — the Discovery exercise below digs into the last point. -->

---

# Discovery: what are the two shapes a database can take?

*(Now the exercise — in your fresh pods, a few minutes.)*

1. **Brainstorm:** when does a database live **inside** your program, and when does it live on a **separate server**?
2. List **one advantage** and **one cost** of each shape.
3. **Jigsaw:** one of you joins a neighbouring pod, the rest stay; **merge** your lists.

<!-- Note: do not advance yet — collect their answers on the board first. -->

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

<!-- Note: advance only after they shared their own table — compare, then add what they found. -->

---

# Play time: SQL Island (30 minutes)

[SQL Island](https://sql-island.informatik.uni-kl.de/) — a free browser text adventure that teaches the basics of SQL. **Play for ~30 minutes**, then answer the tutorial questions in `module-01/sql-island.md`.

- What have you learned about databases and SQL so far, *just by playing*?
- Which SQL commands did you actually use?
- What is a table, a row, a column, a query — in your own words?
- What surprised you? What is still confusing?

*(Leave the tab open — finish the game at home.)*

<!-- Note: hand out ~30 minutes of play; the questions are the tutorial deliverable. -->
