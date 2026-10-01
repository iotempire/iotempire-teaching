# Syllabus: Databases (DBS) — Local-First Edition

> Important: This syllabus is a living document and will evolve throughout the semester. Minor updates may apply based on class progress, tool availability, and student feedback.
>
> **Canonical source:** [IoTempire Teaching repository — HSBI/GT Databases](https://github.com/iotempire/iotempire-teaching/tree/main/full-classes/hsbi-databases-10d)

> [!NOTE]
> Work in progress — this is a full redesign of the legacy Databases course, first taught in WS 2026/27. Expect this syllabus to keep changing before and during the semester. Each module marks unsettled content with a *DRAFT BOUNDARY* that moves down as we approve sections together. Your input is valued: if something does not fit your program, say so early and we will adapt.

## Class Times and Locations

- Schedule, location, and room: Published in the official HSBI timetable and course LMS before teaching begins.
- Official announcements and course contact: Course LMS (ILIAS).
- Languages of Instruction: English and German.
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

This class is taught in English and German. The shared workbook, schemas, code, documentation, and technical exercises are in English to ensure reusability and align with modern engineering practice.

Ulno is fully bilingual. You are welcome to speak with the teaching team and collaborate with your peers in German, English, or a mixture of both. Notes, portfolio documentation, reports, and presentations may likewise be submitted in German, English, or mixed language. Ask whenever technical vocabulary or a task formulation needs clarification in either language.

**Für deutschsprachige Studierende:** Diese Lehrveranstaltung findet auf Englisch und Deutsch statt. Das gemeinsame Workbook, der Code, die Dokumentation und die Übungen bleiben auf Englisch, damit sie einheitlich genutzt werden können. Ulno ist zweisprachig; Sie können mit dem Lehrteam und untereinander auf Deutsch, Englisch oder in einer Mischung aus beiden Sprachen sprechen und arbeiten. Notizen, Portfolio-Dokumentation und Präsentationen dürfen ebenfalls auf Deutsch, Englisch oder gemischt verfasst werden. Fragen Sie jederzeit nach, wenn Fachbegriffe oder Aufgabenstellungen geklärt werden sollen.

## Course Description & Philosophy

### Databases — From Schema Audits to Measured, Embedded Persistence

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

- Format: 12 sessions across the semester; each session combines the officially allotted 2 SWS lecture and 2 SWS seminar/lab into one ~4–5 h active studio block.
- Target Audience: Bachelor students in *Mechatronics and Automation* and *Industrial Engineering* (3rd semester, Campus Gütersloh).
- Module Number: 3386 (*Databases*), 5 ECTS.
- Total Workload: 150 hours.
  - Contact time: 60 hours (30 h lecture component + 30 h seminar/lab component).
  - Independent preparation and pre-study (Module 0): approx. 20 hours allocated (3–6 hours for the compulsory core).
  - Guided self-study, portfolio documentation, benchmarking, and final project: approx. 70 hours.

### Prerequisites & Relationship to Other Modules

- **Formal:** none (module handbook Section 5).
- **Content:** none required (module handbook Section 5). Basic Python, a terminal, and Git help and are scaffolded in Module 0.
- **Relationship to other modules:** *Databases* is a standalone 3rd-semester module. It pairs naturally with the IoT course family (MCU programming, networking, sensors/actuators): the data those courses produce on the edge is exactly the data you will store, query, and analyze here — but there is no required prior course.

## Assessment: Kombinationsprüfung (20 Base Points + Bonus)

Assessment is conducted as a *Kombinationsprüfung* combining continuous portfolio documentation, studio lab work, reflection logbook entries, and a final project with an individual oral defense. Section 6 of the module handbook permits exactly this combination of project work and oral examination; the legacy 75 % written examination is not used.

> [!IMPORTANT]
> Module 0 is required and worth 1 module point. Before the first session, set up your personal GitHub portfolio from the course template and complete the pre-study tasks in [pre-study.md](./pre-study.md), including the local-first environment check and the first LLM-assisted SQL profiling task. Module 0 is assessed during the second session.

### Points Breakdown

| Component | Points | Details |
|---|---|---|
| Module 0 (Pre-Study) | 1 point | Portfolio repository from the Git template, environment check (Python, SQLite, Datasette), initial LLM-assisted SQL profiling task. |
| Modules 1–5 (Studio lab reports) | 10 points | 2 points each, earned through checkpoint presentations proving the module learning goals from your portfolio: schema trade-off benchmarks, trigger and constraint implementations, and query-optimization evidence. |
| Reflection Points | 4 points | One reflection for each teaching block, captured in your personal logbook. |
| Final Personal Meaningful Challenge Project | 5 points | 25 % of the base score. Story-driven local-first embedded database application in teams of 3–4, evaluated via a working GitHub repository, 5-page documentation, and a 15-minute live demo + individual oral defense. |
| **Base Total** | **20 points** | 100 % base score. |
| Extra / Bonus Points | up to +3 | Exceptional benchmarking, accepted open-source pull requests to IoTempower or class repositories, or peer debugging assistance. |

- **Score cap:** The final score is capped at 20 points, even if bonus points are earned. Bonus points compensate for minor weaknesses in regular deliverables, but all compulsory components must still be attempted.
- **Passing threshold:** Minimum **14 out of 20 points** (~70 %) to pass (*bestanden*).

### How module points are earned: checkpoint presentations

You do not submit and grade every task. Instead, you earn a module's points in a short, personal checkpoint presentation (about 10 minutes) with the instructor, based on your portfolio and reflection logbook. Checkpoints happen in class and cover 2–3 modules at a time (Module 1–3 in Session 7, Modules 4–5 in Session 11); the schedule is announced through the LMS.

In a checkpoint, you:

1. **Show your evidence** — portfolio entries, benchmark tables, SQL, `EXPLAIN QUERY PLAN` screenshots, and reflections for the modules being checked.
2. **Prove the learning goals** — the goals listed at the top of each module. Walk the instructor through how your work shows you reached them, and answer questions about them (expect to run a query or read a plan live).

Because assessment targets the learning goals, not task completion, you are free to skip tasks, fail at tasks, or add your own. An honest, documented failure counts as exploration, not as a loss, and a convincing demonstration of deep understanding or analysis is rewarded generously.

Practical notes:

- Bring your portfolio (and your laptop with the SQLite/DuckDB databases open) to the checkpoint.
- Expect to explain a design choice, justify an index, or debug a broken constraint live.
- If you cannot attend a checkpoint, talk to the instructor early; a missed checkpoint is handled like a missed deadline.

### Reflection format

For each teaching block, write one logbook entry answering these four questions:

1. **What worked?** — the thing you built or measured that actually functioned.
2. **What broke?** — the failure, the wrong assumption, the crash.
3. **How did my mental model shift?** — what you thought before and understand now.
4. **How did I verify AI suggestions?** — the query, schema, or claim an LLM gave you, and how you checked it.

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
| Language | **Python 3.11+** | Labs and the final project are Python-based; `sqlite3` is in the standard library. |
| Transactional DB | **SQLite 3.38+** | JSON1 built in; use `STRICT` tables and generated columns. Ships as the `sqlite3` CLI and the Python `sqlite3` module. |
| Analytical DB | **DuckDB** | In-process columnar engine; reads Parquet/CSV directly and can attach a SQLite file. |
| Exploration & publishing | **Datasette** + **sqlite-utils** | One command turns a `.db` into an explorable site and JSON API. Datasette Lite runs in the browser. |
| Editor | **VSCode** or **Zed** | With an SQLite/DuckDB extension for browsing and SQL execution. |
| Version control | **Git + GitHub** | Your portfolio is the assessment artifact. |
| AI co-pilots | **ChatGPT / Claude / DeepSeek / local models** | Used to *draft*, never to *decide*. Verification is the graded skill. |

> [!WARNING]
> **No server required, and no secrets in Git.** SQLite and DuckDB are embedded — there is no MySQL server to install and no root password to manage. Never commit API keys, credentials, or personal data; a `.gitignore` for `*.db`, `*.duckdb`, and `.env` is provided in the template.

## 12-Session Course Schedule

The 12 sessions deliver the technical foundations (Modules 1–5), the final project arc (Modules 6–7), and two checkpoint sessions. Sessions 1–9 are active studios; Sessions 10–12 are dedicated project time.

> Indicative plan. The session-by-session mapping below is a planning draft and may shift — including during the semester — as we refine this class together. The learning objectives and the final project matter more than the exact session a topic lands on.

| Session | Module / Topic | Core Hands-on Focus |
|:---:|---|---|
| — | [Pre-Study](./pre-study.md) (Module 0) | Portfolio setup, environment check, first LLM-assisted SQL profiling task. |
| 1 | [Module 0 — Portfolio Setup & Local-First Paradigm](./pre-study.md) | SQLite vs. server overkill: stand up an embedded DB in-process, load edge telemetry, and audit an LLM's first query. |
| 2 | [Module 1 — Data Contracts & Reading Legacy Schemas](./modules/01-data-contracts-and-legacy-schemas.md) | Reconstruct an ER model from a legacy schema, find integrity bugs, draft a code-first data contract. |
| 3 | [Module 1 — continued](./modules/01-data-contracts-and-legacy-schemas.md) | ERD audit workshop: cardinalities, surrogate keys, and writing the requirements the schema forgot. |
| 4 | [Module 2 — LLM-Assisted SQL & Query Profiling](./modules/02-llm-assisted-sql-and-query-profiling.md) | Generate complex SQL with an LLM, then read `EXPLAIN QUERY PLAN` and test parameterization. |
| 5 | [Module 2 — continued](./modules/02-llm-assisted-sql-and-query-profiling.md) | Index benchmarking studio: prove or disprove the index the AI recommended; injection drill. |
| 6 | [Module 3 — Data Integrity, Constraints & Edge Triggers](./modules/03-integrity-constraints-and-triggers.md) | `CHECK`/`UNIQUE`/`FK`, `STRICT` tables, generated columns, and a trigger that enforces edge telemetry rules. |
| 7 | [Module 3 + Checkpoint 1](./modules/03-integrity-constraints-and-triggers.md) | Finish the trigger lab, then checkpoint presentations for Modules 1–3. |
| 8 | [Module 4 — Normalization vs. Denormalization Benchmarking Studio](./modules/04-normalization-vs-denormalization.md) | Normalize to 3NF, denormalize on purpose, and measure read/write/storage trade-offs in SQLite. |
| 9 | [Module 5 — Polyglot & Embedded Persistence](./modules/05-polyglot-embedded-persistence.md) | JSON documents in SQLite, DuckDB analytics over Parquet/CSV, and a key-value comparison. |
| 10 | [Module 6 — Final Project Hackathon](./modules/06-final-project-hackathon.md) | Project kickoff and story, requirement mapping, schema and ingestion build. |
| 11 | [Module 6 + Checkpoint 2](./modules/06-final-project-hackathon.md) | Build and integrate, peer review, then checkpoint presentations for Modules 4–5. |
| 12 | [Module 7 — Live Demos & Oral Defenses](./modules/07-final-project.md) | 15-minute team demo + individual oral defense; retrospective. |

> [!TIP]
> **Buffer and pacing:** Sessions 10–12 provide the studio tail. At least one block is deliberately loose and can absorb spill-over from earlier labs, be released as flexible time, or be used for stretcher tasks and peer mentoring. Announce the concrete use of each studio session in the LMS as the course progresses.

## Final Project Requirements (5 Points)

The final project is a local-first, embedded database application built by teams of **3–4 students**. Teams form and pitch a stakeholder story during the project kickoff (Module 6), then map their requirements onto the criteria below. A team may, by agreement with the instructor, continue a project from another course — this is a possibility, not a requirement; the default is a self-contained database application.

### Must-Have System Criteria:

1. **Embedded database with a real schema**: SQLite (or DuckDB where the workload justifies it) with a documented schema and at least one enforced relationship.
2. **Real-world data ingestion**: actual data (sensor/telemetry logs, machine states, an export, or a public dataset) loaded reproducibly via a script — not hand-typed rows.
3. **Measured indexing proof**: you introduced at least one index and showed its effect with `EXPLAIN QUERY PLAN` and a before/after timing on a non-trivial dataset.
4. **Parameterization and security**: every query that touches user or external input uses bound parameters; you demonstrate that a naive string-built query would be injectable.
5. **Integrity and automation at the edge**: at least one constraint and one trigger (or generated column) that enforce a domain rule.
6. **Evaluation**: documented performance and integrity evidence — query timings, plan output, storage size, or load throughput.
7. **Reliability and a reachable interface**: the app recovers from a corrupt/missing row gracefully and exposes the data through an interface a human can use (Datasette, a CLI, a small app, or a dashboard).

### Assessment Criteria:

- **System functionality & measurement quality (2 points):** Meets specifications; ingestion, query, and integrity behavior are credible and reproducible.
- **Architecture, documentation & evaluation (1.5 points):** Clear schema/data-flow diagram, schema and index documentation, benchmark evidence, and the 5-page report.
- **Live demonstration & oral defense (1.5 points):** A clear 15-minute team demo showing the data flowing end-to-end, plus individual answers on the underlying design decisions and trade-offs.

See the full [final project specification](./modules/07-final-project.md) for the demo script, documentation template, and the detailed rubric.

## Portfolio & Documentation Standards

All assessments are based on your personal GitHub Portfolio (forked from [iot-portfolio-template](https://github.com/iotempire/iot-portfolio-template)):

- Maintain a clean Git log with descriptive commit messages.
- For each module, include:
  - Schema artifacts: ER diagrams (hand-drawn or tool-generated), `CREATE TABLE` DDL, and migration or contract files (Pydantic/SQLAlchemy).
  - The SQL you used and the Python that drove it, always with bound parameters.
  - Benchmark tables and plots: query timings, index before/after, storage sizes, load times.
  - `EXPLAIN QUERY PLAN` output (screenshots or saved text) for the queries you optimized.
  - Screenshots of Datasette views, DuckDB results, CLI sessions, and error messages you fixed.
  - Reflection logbook entries (what worked, what broke, mental-model shift, AI verification).
- In database work, a measured trade-off and an honest "the index did not help, here is why" beat a single lucky query. Showing how you caught an LLM inventing a column, or a missing foreign key, is worth more than a superficial "it worked" report.

## Classroom Policies & Success Strategies

1. **Active participation:** Bring your laptop with Python 3.11+, SQLite, DuckDB, and Datasette installed. The checkpoints and demos happen live on your machine.
2. **Data hygiene:** Never commit databases, credentials, or personal data. Use the provided `.gitignore`. Generate ingestion reproducibly from a script so a reviewer can rebuild your database.
3. **Pair and collaborate:** Two sets of eyes on a silent `NULL` or a broken join save the afternoon. Pair-debug, review each other's query plans, and share discoveries.
4. **Measurement mindset:** A performance claim without a number, a dataset size, and a plan is an opinion. Write down *what* you measured, *with what*, and *under what conditions*.
5. **AI with responsibility:** Use AI co-pilots enthusiastically — and verify relentlessly. You are accountable for every query you ship, whether you or a model wrote it.
6. **Open-source mindset:** Share discoveries and help peer teams. Accepted pull requests to IoTempower, this course repository, or open-source tools qualify for bonus points.

## Contacts & Support

- Primary Communication Channel: Course LMS (ILIAS). Check regularly for updates and announcements.
- Main Instructor: Prof. Dr. Ulrich Norbisrath (Ulno) — [ulno.net](https://ulno.net/)
- Module Coordinator (module 3386): Prof. Dr. rer. nat. Alexander Maier
- IoTempire Community: [iotempire.net](https://iotempire.net/)
