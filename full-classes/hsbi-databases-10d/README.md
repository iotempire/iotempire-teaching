# HSBI/GT Databases (DBS) — Local-First Edition

## Contents

| Start here | What it contains |
|---|---|
| [Module 1 — Introduction & Local-First Foundations](./modules/01-introduction-and-local-first.md) | Session 1 — how this class works, portfolio setup, the local-first paradigm, and your first LLM-assisted SQL profiling task |
| [Syllabus](./syllabus.md) | Course schedule, learning objectives, assessment rules, tools, and policies |
| [Module 2 — Data Contracts & Reading Legacy Schemas](./modules/02-data-contracts-and-legacy-schemas.md) | ERD audits, code-first contracts (Pydantic/SQLAlchemy), requirements from messy reality |
| [Module 3 — LLM-Assisted SQL & Query Profiling](./modules/03-llm-assisted-sql-and-query-profiling.md) | Generating queries with AI, then proving them with `EXPLAIN QUERY PLAN`, indexes, and injection tests |
| [Module 4 — Data Integrity, Constraints & Edge Triggers](./modules/04-integrity-constraints-and-triggers.md) | `CHECK`, `UNIQUE`, foreign keys, `STRICT` tables, generated columns, and triggers for edge telemetry |
| [Module 5 — Normalization vs. Denormalization Benchmarking Studio](./modules/05-normalization-vs-denormalization.md) | Functional dependencies and read/write trade-offs measured with real SQLite benchmarks |
| [Module 6 — Polyglot & Embedded Persistence](./modules/06-polyglot-embedded-persistence.md) | JSON in SQLite, DuckDB analytics over Parquet/CSV, key-value stores, when to leave the RDBMS |
| [Module 7 — Final Project Studio](./modules/07-final-project-studio.md) | Kickoff, build, peer review, and dry-run studios for the meaningful challenge project |
| [Module 8 — Final Project Specification](./modules/08-final-project.md) | Teams, technical must-haves, documentation, and the 15-minute demo + oral-defense rubric |
| [Resource Prompts](./modules/Y-resources-prompt-bank.md) | Reflection prompts, LLM-verification drills, and quick references |
| [Resource Bank](./modules/Z-resources-bank.md) | Cheat sheets, troubleshooting, datasets, and extended reading |

This README is the course workbook and front page for **Databases (DBS)** taught at Hochschule Bielefeld University of Applied Sciences and Arts (HSBI), Campus Gütersloh. Module number 3386, 5 ECTS, 3rd semester. It is delivered as a semester-long active studio: **11 four-hour sessions (44 contact hours)**, plus **optional tutorial sessions** run by a teaching assistant (dates and times announced via the LMS). The official timetable, room, and announcements are published through the course LMS.

> [!NOTE]
> **Every module begins with its learning goals.** Those goals are the agreement between you and me: you earn a module's points by *demonstrating the goals* — in a short checkpoint conversation and through your portfolio — not by ticking off every task. That is the whole contract. It is also why the tasks are negotiable and the goals are not: reach the goals your own way, and you have met the module.

> [!NOTE]
> **This class is a draft in motion.** It is taught for the first time in WS 2026/27, by an instructor who is *also* new to teaching databases and is learning the material alongside you. In every module, a ***DRAFT BOUNDARY*** marks the part that is not settled yet. The boundary moves down as we approve content together. Expect the plan, the tasks, and even this syllabus to change — and bring your own deep dives and stretchers; your input genuinely shapes the class.

## Course Overview

- Duration: 11 four-hour sessions (44 contact hours), plus optional tutorial sessions with the teaching assistant (times announced via the LMS).
- Target Group: Bachelor students in *Mechatronics and Automation* and *Industrial Engineering* (3rd semester, 40–70 students). Module number 3386.
- Workload: 150 hours (5 ECTS) — 44 h core studio contact (plus tutorial sessions), and the remainder in self-study, portfolio documentation, and the final project.
- Format: Practical, studio-style, peer-driven course. A short introduction to the class in Session 1, then one technical module per session (Modules 2–6), then the final-project studio (Modules 7–8). We keep the classical foundations the module handbook requires — database architecture, ERM, the relational model, normalization, SQL (DDL/DML/DQL/DCL), triggers and procedures, NoSQL — but we teach them the way data systems are actually built today: locally, hands-on, measured, and AI-assisted.
- Language of Instruction: English. This class is taught in English for our international students.
- Assessment: *Kombinationsprüfung/combination exam* => continuous portfolio + project work combined with a final oral examination (as permitted by Section 6 of the module handbook).

### The version of databases we actually build today

Most "database applications" taught in introductory courses follow a pattern we now consider a **programming antipattern**: a full three-tier frontend/backend/cloud stack for something that needs to store a few thousand rows on a machine that already runs the code. This course flips that.

> [!IMPORTANT]
> **Local-first, embedded, and measured.** We treat the database as an embedded library inside the process, not a server you must host. Our default engines are **SQLite** (transactional, row-oriented, embedded relational) and **DuckDB** (analytical, columnar OLAP). We connect them to real **edge telemetry** — sensor readings, machine states, industrial logs — and we *prove* every performance claim with a benchmark instead of a slide.

You will:

- **Understand the schema before the query.** We start from *legacy schema audits*: reading somebody else's ER diagram and SQL, then writing a *data contract* that documents what the data really means.
- **Let AI write the SQL, but keep the responsibility.** Syntactic SQL memory is no longer a job skill. You will use LLM co-pilots to generate queries, then **profile them (`EXPLAIN QUERY PLAN`), benchmark the index impact, and prove they are injection-safe** — because shipping unreviewed generated SQL is how you get a data breach.
- **Trade normalization against speed with numbers.** Instead of memorizing 1NF–3NF, you will normalize, denormalize, and *measure* the read/write/storage consequences in SQLite.
- **Go polyglot on purpose.** You will store JSON in SQLite, run DuckDB analytics straight over Parquet and CSV, try a key-value store, and reason about when a relational engine is the wrong tool.

Read the [syllabus](./syllabus.md) for the complete language arrangement, learning objectives, assessment rules, toolchain, and policies.

## Assessment: Kombinationsprüfung (20 Points Base + Bonus)

Your grade comes from continuous portfolio evidence, checkpoint presentations, reflections, and a final project — there is no written exam.

| Component | Points | How it is earned |
|---|---|---|
| Modules 1–6 (Learning goals) | 11 points | Proven in short checkpoint presentations: portfolio setup and the first profiling task (Module 1, 1 point), then schema trade-off benchmarks, trigger/constraint implementations, and query-optimization evidence from your portfolio (Modules 2–6, 2 points each). |
| Reflection Points | 4 points | One continuous reflection per teaching block in your personal logbook. |
| Final Personal Meaningful Challenge Project | 5 points (25 %) | A story-driven, local-first embedded database application (teams of 3–4), evaluated via a working GitHub repository, 5-page documentation, and a 15-minute live demo + individual oral defense. |
| Extra / Bonus Points | up to +3 | Exceptional benchmarking, accepted open-source pull requests to IoTempower or class repositories, or peer debugging assistance. |
| **Base Total** | **20 points** | Passing mark: **minimum 14 / 20** (~70 %). |

- **Score cap:** The final score is capped at 20, even if bonus points are earned. Bonus points can compensate for minor weaknesses, but all compulsory components must still be attempted.
- **Reflection format (each block):** *What worked? What broke? How did my mental model shift? How did I verify AI suggestions?*
- **The module points (Modules 1–6) are earned by checkpoint presentations, not by task completion.** Every module begins with its learning goals, and those goals are your contract with the instructor: demonstrate them and you earn the points. The tasks are negotiable — modify, replace, or extend them as long as you still reach the goals — so you may skip tasks, fail at some, or add your own. A documented, honest failure is exploration, not a loss.

The full points breakdown, checkpoint rules, and grade scale live in the [syllabus](./syllabus.md#assessment-kombinationsprüfung-20-base-points--bonus).

## Tools & Environment

| Layer | Tool | Why |
|---|---|---|
| Language | **Python 3.11+** | The glue for every lab; `sqlite3` and `duckdb` ship as libraries. |
| Transactional DB | **SQLite 3.38+** (CLI + Python stdlib `sqlite3`) | Embedded, zero-admin, JSON1 built in, `STRICT` tables, generated columns. |
| Analytical DB | **DuckDB** | In-process columnar OLAP; queries Parquet/CSV directly, can attach SQLite files. |
| Exploration & publishing | **Datasette** (+ `sqlite-utils`, Datasette Lite) | Turn any SQLite file into an explorable site and JSON API in one command. |
| Editor | **VSCode** or **Zed** (SQLite/DuckDB extensions) | SQL editing, DB browsing, Git integration. |
| Version control | **Git + GitHub** | Your portfolio *is* the deliverable. |
| AI co-pilots | ChatGPT / Claude / DeepSeek / local models | Query generation, schema review, and — critically — the object of your verification. |

> [!TIP]
> Everything core runs offline on your laptop. Cloud services are optional and never required for a passing grade. If an AI tool is unavailable, the tasks still work with a search engine and the SQLite/DuckDB documentation.

## Portfolio & Getting Started

Maintain a personal GitHub portfolio, forked from the [portfolio template](https://github.com/iotempire/iot-portfolio-template), containing schemas, SQL, scripts, benchmark tables, `EXPLAIN QUERY PLAN` screenshots, reflection logbook entries, and your final project.

**Module 1 happens in class (Session 1).** We introduce how the class works, then fork your personal GitHub portfolio from the template and complete the [Module 1 studio](./modules/01-introduction-and-local-first.md) together. In database work, a documented benchmark and an honest "the index didn't help, here is why" beat a single lucky query — showing how you caught an LLM hallucinating a column is exactly the engineering skill this course builds.

## Navigation & Resources

- [Module index](./modules/00-index.md) — compact navigation and the 11-session roadmap
- [Module 1 — Introduction & Local-First Foundations](./modules/01-introduction-and-local-first.md) — start here; done together in Session 1
- [Syllabus](./syllabus.md) — official course rules, assessment, and policies
- [SQLite documentation](https://www.sqlite.org/docs.html) · [`EXPLAIN QUERY PLAN`](https://www.sqlite.org/eqp.html) · [JSON functions](https://sqlite.org/json1.html) · [STRICT tables](https://www.sqlite.org/stricttables.html)
- [DuckDB documentation](https://duckdb.org/docs/) · [Datasette](https://datasette.io/) · [sqlite-utils](https://datasette.io/tools/sqlite-utils)
- [IoTempire](https://iotempire.net/) — organization, teaching tools, and community

### LMS PDF Exports

Generate a dated, upload-ready PDF of the syllabus using LibreOffice (default), Chromium, or LaTeX:

```sh
./generate-lms-pdfs.sh 2026-27
```

## Contacts & Support

- Questions, schedule, and technical support: Use the course LMS (ILIAS), the authoritative communication channel.
- Main Instructor: Prof. Dr. Ulrich Norbisrath (Ulno) — [ulno.net](https://ulno.net/)
- Legacy course material: Prof. Dr. Alexander Maier (module coordinator, module 3386) · modernized in German by Prof. Dr. Dominic Becking
- Community: [IoTempire](https://iotempire.net/)
