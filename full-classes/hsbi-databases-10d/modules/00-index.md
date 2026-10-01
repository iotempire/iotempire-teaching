# Databases (DBS) — Module Index & Roadmap

[← Course workbook](../README.md) | [Pre-study guide](../pre-study.md) | [Syllabus](../syllabus.md)

> **One question for the whole course:** *How does raw data become a trustworthy, fast, and safe answer — on a machine you actually own?*

This page maps the legacy 7-chapter Databases lecture onto the 12 active studios of this redesign. Each row shows what the studio is *about* and what you will *build and measure*.

| Module | Session(s) | Modern studio | Legacy topics it reframes | Hands-on focus |
|:---:|:---:|---|---|---|
| [Pre-Study](../pre-study.md) | — | Module 0 — Portfolio Setup & Local-First Paradigm | *Intro: digitization, file-based storage flaws, DB taxonomy* | Environment check, embedded SQLite vs. server overkill, first LLM-assisted SQL profiling task. |
| [Module 1](./01-data-contracts-and-legacy-schemas.md) | 2–3 | Data Contracts & Reading Legacy Schemas (ERD Audits) | *Conceptual Database Design (ERM/EERM), requirements analysis* | Reconstruct an ER model from a legacy schema, hunt integrity bugs, draft a code-first data contract. |
| [Module 2](./02-llm-assisted-sql-and-query-profiling.md) | 4–5 | LLM-Assisted SQL & Query Profiling | *Standard SQL (DQL), relational algebra, query optimization* | Generate complex SQL with an LLM, read `EXPLAIN QUERY PLAN`, benchmark indexes, drill SQL injection. |
| [Module 3](./03-integrity-constraints-and-triggers.md) | 6–7 | Data Integrity, Constraints & Edge Triggers | *Standard SQL (DDL/DML/DCL), data integrity, triggers/procedures* | `CHECK`/`UNIQUE`/`FK`, `STRICT` tables, generated columns, a trigger enforcing edge-telemetry rules. |
| [Module 4](./04-normalization-vs-denormalization.md) | 8 | Normalization vs. Denormalization Benchmarking Studio | *Relational model, functional dependencies, 1NF–3NF* | Normalize to 3NF, denormalize on purpose, measure read/write/storage trade-offs in SQLite. |
| [Module 5](./05-polyglot-embedded-persistence.md) | 9 | Polyglot & Embedded Persistence | *NoSQL, ACID vs. BASE, CAP theorem, DB within applications* | JSON documents in SQLite, DuckDB analytics over Parquet/CSV, a key-value comparison. |
| [Module 6](./06-final-project-hackathon.md) | 10–11 | Final Project Hackathon | *Project planning and implementation* | Kickoff and story, requirement mapping, build, integrate, peer review. |
| [Module 7](./07-final-project.md) | 12 | Final Project Specification, Demos & Oral Defenses | *Assessment* | 15-minute live demo + individual oral defense; retrospective. |
| [Resource Prompts](./Y-resources-prompt-bank.md) | — | Supplementary | — | Reflection prompts, LLM-verification drills, quick references. |
| [Resource Bank](./Z-resources-bank.md) | — | Supplementary | — | Cheat sheets, troubleshooting, datasets, extended reading. |

## What changed, and why

| Legacy emphasis | This course's emphasis | Reason |
|---|---|---|
| Install MySQL Server + Workbench | Embedded SQLite (+ DuckDB) | The database is a library inside your process; no server to administer for a local app. |
| Memorize SQL syntax | Generate with AI, then profile and secure | Syntactic recall is obsolete; reading a query plan and preventing injection is not. |
| ER diagrams as an end product | Schema audits and code-first data contracts | Real work is reading someone else's schema and expressing its meaning in code. |
| Normalization as a rule to obey | Normalization as a measured trade-off | Read/write/storage costs are empirical facts you can benchmark. |
| Relational = the only option | Polyglot persistence, chosen deliberately | Edge and analytical workloads sometimes want JSON, columns, or key-value. |
| 75 % written exam | Portfolio + project + oral defense | Section 6 of the module handbook permits the Kombinationsprüfung; active work proves competence better. |

## Assessment map

| Component | Points | Earned in |
|---|---|---|
| Module 0 (Pre-Study) | 1 | Session 1–2, assessed in Session 2 |
| Modules 1–3 | 6 (2 each) | Checkpoint 1, Session 7 |
| Modules 4–5 | 4 (2 each) | Checkpoint 2, Session 11 |
| Reflections | 4 | One per teaching block, throughout |
| Final Project | 5 | Session 12 demo + defense |
| **Base total** | **20** | Passing mark: **14 / 20** |
| Bonus | up to +3 | Benchmarks, upstream PRs, peer help |

See the [syllabus](../syllabus.md#assessment-kombinationsprüfung-20-base-points--bonus) for the full rules and the [grade scale](../syllabus.md#grade-scale).
