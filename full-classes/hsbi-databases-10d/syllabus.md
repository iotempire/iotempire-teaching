# Syllabus: Databases (DBS) — Local-First Edition

> Important: This syllabus is a living document and will evolve throughout the semester. Minor updates may apply based on class progress, tool availability, and student feedback.
>
> **Canonical source:** [IoTempire Teaching repository — HSBI/GT Databases](https://github.com/iotempire/iotempire-teaching/tree/main/full-classes/hsbi-databases-10d)

> [!NOTE]
> **Every module begins with its learning goals.** Those goals are the agreement between you and the instructor: you earn a module's points by *demonstrating the goals* — in a short checkpoint conversation and through your portfolio — not by ticking off every task. The goals are fixed; the way you reach them is yours.

> [!NOTE]
> **This class is a draft in motion.** It is a full redesign of the legacy Databases course, taught for the first time in WS 2026/27 by an instructor who is *also* new to teaching databases and is learning the material alongside you. In every module a ***DRAFT BOUNDARY*** marks the part that is not settled yet; it moves down as we approve content together. Expect this syllabus to keep changing, and bring your own deep dives and stretchers — your input can shape the class.

## Class Times and Locations

- Schedule, location, and room: Published in the official HSBI timetable and course LMS before teaching begins.
- Official announcements and course contact: Course LMS.
- Language of Instruction: English.
- Course Materials: English.

## Instructors & Teaching Team (HSBI Gütersloh)

| Role | Name | Contact / Status |
|---|---|---|
| Main Instructor | Prof. Dr. Ulrich Norbisrath (Ulno) | [ulno.net](https://ulno.net) |
| Module Coordinator (legacy) | Prof. Dr. rer. nat. Alexander Maier | Module 3386 owner of record |
| Teaching Support | Fabian Tilman Schmid-Michels *(if available)* | To be confirmed |

> [!NOTE]
> **Course information:** Ulno is the primary instructor for this HSBI offering. The course LMS is the authoritative source for local dates, rooms, contact details, and announcements. Students and interested people are always welcome to join the IoTempire community Discord (link maintained in the [repository README](../../README.md#references--resources)).

## Language, Communication & Course Material

This class is taught in **English**, for our international students. The shared workbook, schemas, code, documentation, and technical exercises are all in English.

Ask questions at any time — in class or through the LMS — whenever a term or a task formulation needs clarification. Notes, portfolio documentation, reports, and presentations are written in English. Write plainly and precisely rather than perfectly: clear technical communication matters far more than flawless grammar.

## Course Description & Philosophy

### Databases — From Schema Audits to Measured, Embedded Persistence

> **One question runs through the whole course:** *How does raw data become a trustworthy, fast, and safe answer — on a machine you actually own?*

A database is not a server you inherit and maintain until it dies. This course keeps the classical foundations that module 3386 requires — architecture of database systems, entity-relationship modeling, the relational model and relational algebra, normalization, standard SQL (DDL, DML, DQL, DCL), procedures and triggers, and NoSQL — but teaches them the way they are actually used: by modeling, querying, measuring, and shipping something local.

Instead of memorizing syntax and proving it on an exam sheet, you will:

- **Read real, messy schemas.** A huge share of professional database work is auditing somebody else's design. You will reconstruct an ER model from a legacy schema, hunt for missing constraints and integrity bugs, and document the findings.
- **Write data contracts, not just `CREATE TABLE`s.** Modern data boundaries are expressed in code — Pydantic models, SQLAlchemy schemas, versioned migrations. You will translate an ER model into a contract an application can actually enforce.
- **Let AI draft, then verify like an engineer.** LLMs are excellent at producing plausible SQL. Your job is to *profile* it (`EXPLAIN QUERY PLAN`), *benchmark* the index it recommends, and *break* it with injection attempts. Every AI suggestion is a hypothesis, not an answer.
- **Trade normalization against performance with evidence.** You will normalize to 3NF, then deliberately denormalize, and measure what that does to query time, insert throughput, and storage.
- **Embrace polyglot persistence on purpose.** JSON documents inside SQLite, DuckDB analytics over Parquet files at the edge, a key-value store for sessions — and a clear reason each time the relational model is or is not the right tool.

This gives you both: the formal competence a database engineer needs, and the local-first, measured habits of modern IoT and edge work.

> [!IMPORTANT]
> Local-first, embedded, buildable. The default engines are embedded — SQLite for transactional data and DuckDB for analytics — running inside your own process, on your own laptop or an edge device. A hosted MySQL/PostgreSQL server is a *topic we compare against*, not the tool we install.

### How We Teach — Challenge- and Project-Based, In Person, and Always in Flux

This course is deliberately taught as Challenge-Based and Project-Based Learning (CBL/PBL): you learn by investigating an authentic challenge and building a real solution, not by reproducing a lecture. We begin from stories — a real problem that matters to you and the people it touches — because you learn best what connects to something meaningful for your own life, studies, or community. Your instructors genuinely care that you find that connection.

It also matters that we do this in person, together — a university class is at its best where we actually meet. You will learn a great deal from direct interaction with your peers: explaining a schema, questioning a query plan, debugging a constraint, and demoing to one another, while your instructors learn alongside you.

Sessions run in **two 90-minute blocks with a 15-minute break**, and both halves close with a five-minute **harvest**: you collect the curious bits you noticed while working — a SQL, Python, or Bash statement that looked strange or hard, an odd ER diagram, a bug, a UX surprise — and swap lists with your pod. Nobody explains anything; *"I collected these — which did you find?"* is the whole conversation, and "I don't know what this does" is a perfectly good entry. It is ungraded on purpose: it exists so the odd bits get a second look while they are still cheap to ask about, and so the next session can open with two of the questions you actually have. The full ritual lives in [Module 3](./modules/03-llm-assisted-sql-and-query-profiling.md).

And this class is always in flux — that is a feature, not a bug. No course is ever finished: every offering is adjusted while it runs, and each class teaches us as much as it teaches you. Expect the plan, the tasks, and even this syllabus to move as we discover together what works best; your questions, ideas, and feedback are part of the design.

> Want to read more? Challenge-Based Learning — [en.wikipedia.org/wiki/Challenge-based_learning](https://en.wikipedia.org/wiki/Challenge-based_learning) · Project-Based Learning — [pblworks.org/what-is-pbl](https://www.pblworks.org/what-is-pbl) · Why active, interactive learning beats passive lectures — [Harvard Gazette, 2019](https://news.harvard.edu/gazette/story/2019/09/study-shows-that-students-learn-more-when-taking-part-in-classrooms-that-employ-active-learning-strategies)

## Learning Objectives

By the end of this course, you will be able to (mapped to the module-handbook competence goals):

1. **Explain database architecture and organization**: the ANSI three-level model, the role of the DBMS, transactions, and why Codd's relational rules still shape modern engines. *(Handbook: architecture, functioning, and organization of database systems.)*
2. **Model data from requirements**: derive use cases and an ER/EER model, and audit an existing legacy schema against its intended meaning. *(Handbook: data modeling.)*
3. **Transform and normalize a schema**: apply EER-to-relational transformation rules, functional dependencies, keys, and 1NF–3NF, and *justify* denormalization with measured trade-offs. *(Handbook: importance of normalization rules.)*
4. **Implement a schema in SQL**: use DDL to create tables, views, constraints, indexes, and triggers, and DCL to manage users and access rights. *(Handbook: implement a relational schema using SQL; access rights and users.)*
5. **Query and manipulate data**: write complex DQL (joins, aggregation, subqueries, window functions), tune it against real `EXPLAIN QUERY PLAN` output, and use DML safely and parameterized. *(Handbook: standard SQL for simple and complex queries and change operations.)*
6. **Implement procedures and triggers**: encode integrity and automation rules at the edge, and reason about their cost. *(Handbook: procedures and triggers.)*
7. **Evaluate and select database technologies**: compare relational, embedded, and NoSQL families against a workload, and choose deliberately. *(Handbook: looking at NoSQL databases.)*
8. **Plan and deliver a database project**: design, build, benchmark, document, and defend a complete local-first database application. *(Handbook: plan and implement database projects.)*

## Course Load & Credits

- Format: 11 four-hour sessions (44 contact hours) across the semester, plus optional tutorial sessions run by the teaching assistant (times announced via the LMS). The course begins with Module 1 in Session 1.
- Target Audience: Bachelor students in *Mechatronics and Automation* and *Industrial Engineering* (3rd semester, Campus Gütersloh).
- Module Number: 3386 (*Databases*), 5 ECTS.
- Total Workload: 150 hours.
  - Core studio contact time: 44 hours (11 sessions × 4 h), plus optional tutorial sessions.
  - Self-study, portfolio documentation, benchmarking, and final project: the remaining ≈106 hours.

> [!NOTE]
> **Where the 150 hours come from.** The module handbook specifies 150 h (5 ECTS). The delivered format is 11 four-hour studios plus tutorial sessions; the balance is self-study, portfolio work, and the final project. Treat the session count as fixed (11) and the *hours per session* as ~4.

### Prerequisites & Relationship to Other Modules

- **Formal:** none (module handbook Section 5).
- **Content:** none required (module handbook Section 5). Basic Python, a terminal, and Git help and are scaffolded in Session 1 (Module 1).
- **Relationship to other modules:** *Databases* is a standalone 3rd-semester module. It pairs naturally with the IoT course family (MCU programming, networking, sensors/actuators): the data those courses produce on the edge is exactly the data you will store, query, and analyze here — but there is no required prior course.

## Assessment: Project Work (20 Base Points + Bonus)

Assessment is **project work** — one of the forms the module handbook allows (*written examination, project work, or oral examination, or a combination*); there is **no written examination**. You keep one **GitHub portfolio** through the term and present a **final project** in the last session. **The graded assessment happens at the end of the term**, from that portfolio and that project.

### Points Breakdown

| Component | Points | How it is earned |
|---|---|---|
| Modules 1–6 | **11** | **1 point for Module 1, 2 points for each of Modules 2–6.** I record a module's points when your portfolio shows you reached that module's learning goals. |
| Reflections | **4** | One short logbook entry per teaching block — four blocks, one point each. |
| Final project | **5** | **3 points for the work** — your **story**, your **architecture** (schema, ingestion, query, interface), and your **plan** — and **2 points for the demo and your individual defense** in week 11. |
| **Base total** | **20** | Pass at **14 / 20** (~70 %). |
| Bonus | up to +3 | Optional; the total stays capped at 20. |

### How module points are earned: from your portfolio

There is no exam to pass module by module. For each of Modules 1–6 I look for the module's **learning goals** in your portfolio and record its points as soon as I can see them — in a checkpoint, in the studio, or in the final portfolio review, whichever comes first. **You never have to prove the same goal twice.**

**Checkpoints are feedback, not assessment.** We meet for about ten minutes with your **Task Pod** (two or three people), look at what you have, and talk about what is missing. Nothing is decided in that conversation. If a module's goals are not visible yet, the answer is **"not yet"**, and you show them later. Missing a checkpoint costs you feedback, not points.

**Each round opens with a peer practice.** Your pod presents to a neighbouring pod, then they present to you — **12 minutes each way**, with a three-minute switch to write feedback notes. You start by opening your **own portfolio** on your own device, so the other pod can check that it is yours and that you can edit, commit, and link in it. Then each of you shows **one artefact** that proves a learning goal, and the pod shows **one reflection** it is proud of.

**If you are ill on the day.** Tell your pod and me — this is not a problem to solve alone. You can **join the round by video call**, your pod can **record it** and share the recording, and if something about *your* contribution is missing from what they show, **send me a short message** so it is on the record. If it needs a real conversation, **book a 15-minute slot in my office hour**. None of this changes your points; it only changes how much feedback you get.

**Task Pods and Project Teams.** Your Task Pod of two or three is the unit for labs and checkpoints. For the final project, two pods merge into a **Project Team of 4–6**.

**Why it is built this way.** In database work the evidence is the artefact: a schema, a query plan, a benchmark table, a constraint that refuses bad data. Your portfolio is where those live, and a short conversation about them is a better test than a written exam — and a better use of our time than grading every task.

### Task tiers: ★ Core and ◇ Stretcher

Tasks are marked **★ Core** or **◇ Stretcher**. A **★ Core** task is one we consider *core* to the module — the straightforward way to reach its learning goals. It is not a hard requirement, but note the asymmetry: for an ordinary task you can argue “this was not needed to reach the goals” and we will usually accept it; for a **★ Core** task that argument is harder, so skipping one means convincing us you reached the same goals another way. A **◇ Stretcher** is optional — an extension, a deeper dive, or bonus material, and the natural trim point when time is short.

### Reflection format

For each teaching block, write one logbook entry in `Reflections/refNN.md`, using the [reflection template](https://github.com/iotempire/iot-portfolio-template/blob/main/Reflections/TEMPLATE.md). The template includes the **AI-verification** question.

### Grade Scale

| Points (0–20) | German Grade | Status |
|---|---|---|
| 0–13 | Nicht bestanden (5.0) | Fail |
| 14–15 | Ausreichend (4.0) | Passed |
| 16–17 | Befriedigend (3.0) | Satisfactory |
| 18–19 | Gut (2.0) | Good |
| 20 | Sehr gut (1.0) | Very Good |

## Tools & Environment

| Layer | Tool | Notes |
|---|---|---|
| Environment manager | **`uv`** (Astral) | Installs a fixed Python plus all libraries and CLI tools in one step — the same commands on Windows, macOS, and Linux. Set up in Module 1. |
| Language | **Python 3.14** | The glue for every lab; `sqlite3` is in the standard library. Install and pin it with `uv python install 3.14`. |
| Transactional DB | **SQLite 3.38+** | JSON1 built in; use `STRICT` tables and generated columns. Ships as the `sqlite3` CLI and the Python `sqlite3` module. |
| Analytical DB | **DuckDB** | In-process columnar engine; reads Parquet/CSV directly and can attach a SQLite file. |
| Exploration & publishing | **Datasette** + **sqlite-utils** | One command turns a `.db` into an explorable site and JSON API. Datasette Lite runs in the browser. |
| Editor | **VSCode** or **Zed** | With an SQLite/DuckDB extension for browsing and SQL execution. |
| Version control | **Git + GitHub** | Your portfolio is the assessment artifact. |
| AI co-pilots | **ChatGPT / Claude / DeepSeek / local models** | Used to *draft*, never to *decide*. Verification is the graded skill. |

> [!WARNING]
> **No server required, and no secrets in Git.** SQLite and DuckDB are embedded — there is no MySQL server to install and no root password to manage. Never commit API keys, credentials, or personal data; a `.gitignore` for `*.db`, `*.duckdb`, and `.env` is provided in the template.

## 11-Session Course Schedule

The 11 sessions deliver Module 1 (introduction), the technical foundations (Modules 2–6), and the final-project arc (Modules 7–8). Sessions 1–7 are taught studios, with Modules 5–6 spread over three weeks; Sessions 8–10 are project studios; Session 11 is demo and defense. Optional **TA-led tutorial sessions** (times announced via the LMS) add catch-up, deeper practice, and project support.

The full roadmap — with a one-line summary and learning goals for every studio — is in the [module index](./modules/00-index.md).

> Indicative plan. The session-by-session mapping below is a planning draft and may shift — including during the semester — as we refine this class together. The learning objectives and the final project matter more than the exact session a topic lands on.

| Session | Module / Topic | Core Hands-on Focus |
|:---:|---|---|
| 1 | [Module 1 — Introduction & Local-First Foundations](./modules/01-introduction-and-local-first.md) | How the class works, then SQLite vs. server overkill: stand up an embedded DB in-process, load edge telemetry, and audit an LLM's first query. |
| 2 | [Module 2 — Data Contracts & Reading Legacy Schemas](./modules/02-data-contracts-and-legacy-schemas.md) | Reconstruct an ER model from a legacy schema, find integrity bugs, draft a code-first data contract. |
| 3 | [Module 3 — LLM-Assisted SQL & Query Profiling](./modules/03-llm-assisted-sql-and-query-profiling.md) | Generate complex SQL with an LLM, then read `EXPLAIN QUERY PLAN`, test parameterization, benchmark an index, and drill injection. |
| 4 | [Module 4 — Data Integrity, Constraints & Edge Triggers](./modules/04-integrity-constraints-and-triggers.md) **+ Checkpoint 1 (feedback)** | *Peer-pod feedback round first (Modules 1–3), then:* `CHECK`/`UNIQUE`/`FK`, `STRICT` tables, generated columns, and a trigger that enforces edge telemetry rules. |
| 5 | [Module 5 — Normalization vs. Denormalization](./modules/05-normalization-vs-denormalization.md) | Normalize to 3NF, denormalize on purpose, and measure read/write/storage trade-offs in SQLite. |
| 6 | Modules 5–6 — finish the normalization benchmark, start polyglot persistence | Complete the Module 5 benchmark table, then JSON documents in SQLite. |
| 7 | [Module 6 — Polyglot & Embedded Persistence](./modules/06-polyglot-embedded-persistence.md) **+ Checkpoint 2 (feedback)** | DuckDB analytics over Parquet/CSV, a key-value comparison, and a feedback round on Modules 4–6. |
| 8 | [Module 7 — Project Studio — story, architecture, plan](./modules/07-final-project-studio.md) | Teams merge; story, one-page plan with your own dates, first vertical slice. |
| 9 | [Module 7 — Project Studio — build & integrate](./modules/07-final-project-studio.md) | Build the slice out: ingestion, headline query, interface. |
| 10 | [Module 7 — Project Studio — harden, review, rehearse](./modules/07-final-project-studio.md) | Constraints, parameterization, index proof, peer review, timed rehearsal. |
| 11 | [Module 8 — Live Demos & Oral Defenses](./modules/08-final-project.md) | 15-minute Project Team demo + individual oral defense; retrospective. |

> [!TIP]
> **Buffer, pacing, and tutorials:** Sessions 8–10 are project studios, and at least one of them is deliberately loose — it can absorb spill-over from earlier labs, be released as flexible time, or be used for stretcher tasks and peer mentoring. The optional tutorial sessions (times announced via the LMS) are the natural home for catch-up and deeper deep dives. Announce the concrete use of each date in the LMS as the course progresses.

## Final Project Requirements (5 Points)

The final project is a local-first, embedded database application built by **Project Teams of 4–6 students** — the project merges two of the Task Pods from Modules 1–6, so you keep your pod and gain one or two more. Project Teams form and pitch a stakeholder story during the project kickoff (Module 7), then map their requirements onto the criteria below. A Project Team may, by agreement with the instructor, continue a project from another course — this is a possibility, not a requirement; the default is a self-contained database application.

### Must-Have System Criteria:

1. **Embedded database with a real schema**: SQLite (or DuckDB where the workload justifies it) with a documented schema and at least one enforced relationship.
2. **Real-world data ingestion**: actual data (sensor/telemetry logs, machine states, an export, or a public dataset) loaded reproducibly via a script — not hand-typed rows.
3. **Measured indexing proof**: you introduced at least one index and showed its effect with `EXPLAIN QUERY PLAN` and a before/after timing on a non-trivial dataset.
4. **Parameterization and security**: every query that touches user or external input uses bound parameters; you demonstrate that a naive string-built query would be injectable.
5. **Integrity and automation at the edge**: at least one constraint and one trigger (or generated column) that enforce a domain rule.
6. **Evaluation**: documented performance and integrity evidence — query timings, plan output, storage size, or load throughput.
7. **Reliability and a reachable interface**: the app recovers from a corrupt/missing row gracefully and exposes the data through an interface a human can use (Datasette, a CLI, a small app, or a dashboard).

These seven are the **content criteria behind the architecture point** — they are not graded one by one. Meet them inside the three artefacts (story, architecture, plan) and the demo.

### Assessment Criteria (5 points)

- **Story (1 point):** a named person, a real problem, and the data that answers it.
- **Architecture (1 point):** a schema with at least one enforced relationship, reproducible ingestion, the headline query, and an interface a human can use.
- **Plan (1 point):** a one-page list of what you will deliver with the dates **you** chose — and evidence that you followed or revised it.
- **Demo and individual defense (2 points):** a live end-to-end run in week 11, and one question per team member about the part they own.

See the full [final project specification](./modules/08-final-project.md) for the demo script, documentation template, and the detailed rubric.

## Portfolio & Documentation Standards

All assessments are based on your personal GitHub Portfolio (created from the [iot-portfolio-template](https://github.com/iotempire/iot-portfolio-template) with **“Use this template”**, then made your own); the [Git & GitHub primer](./modules/Z-resources-bank.md#git--github-primer-template-editor-markdown-conflicts) covers the template workflow, your editor, Markdown, and resolving conflicts.

Each module lists **suggested portfolio evidence** — suggestions, not a checklist. You may prove the same learning goals another way; if you do, say so in the module entry.

- Maintain a clean Git log with descriptive commit messages.
- For each module, include:
  - Schema artifacts: ER diagrams (hand-drawn or tool-generated), `CREATE TABLE` DDL, and migration or contract files (Pydantic/SQLAlchemy).
  - The SQL you used and the Python that drove it, always with bound parameters.
  - Benchmark tables and plots: query timings, index before/after, storage sizes, load times.
  - `EXPLAIN QUERY PLAN` output (screenshots or saved text) for the queries you optimized.
  - Screenshots of Datasette views, DuckDB results, CLI sessions, and error messages you fixed.
  - Reflection logbook entries in `Reflections/`, using the template.
- In database work, a measured trade-off and an honest "the index did not help, here is why" beat a single lucky query. Showing how you caught an LLM inventing a column, or a missing foreign key, is worth more than a superficial "it worked" report.

## Classroom Policies & Success Strategies

1. **Active participation:** Bring your laptop with the [uv-managed toolchain](./modules/01-introduction-and-local-first.md) set up (Python 3.14, SQLite, DuckDB, Datasette). The checkpoints and demos happen live on your machine.
2. **Data hygiene:** Never commit databases, credentials, or personal data. Use the provided `.gitignore`. Generate ingestion reproducibly from a script so a reviewer can rebuild your database.
3. **Collaborate within your pod:** Two sets of eyes on a silent `NULL` or a broken join save the afternoon. Debug together, review each other's query plans, and share discoveries.
4. **Measurement mindset:** A performance claim without a number, a dataset size, and a plan is an opinion. Write down *what* you measured, *with what*, and *under what conditions*.
5. **AI with responsibility:** Use AI co-pilots enthusiastically — and verify relentlessly. You are accountable for every query you ship, whether you or a model wrote it.
6. **Open-source mindset:** Share discoveries and help other pods (and, later, other Project Teams). Accepted pull requests to IoTempower, this course repository, or open-source tools qualify for bonus points.

## Contacts & Support

- Primary Communication Channel: Course LMS. Check regularly for updates and announcements.
- Main Instructor: Prof. Dr. Ulrich Norbisrath (Ulno) — [ulno.net](https://ulno.net/)
- Module Coordinator (module 3386): Prof. Dr. rer. nat. Alexander Maier
- IoTempire Community: [iotempire.net](https://iotempire.net/)
