# Databases (DBS) — Module Index & Roadmap

[← Course workbook](../README.md) | [Module 1](./01-introduction-and-local-first.md) | [Syllabus](../syllabus.md)

> **One question for the whole course:** *How does raw data become a trustworthy, fast, and safe answer — on a machine you actually own?*

> [!NOTE]
> **How to read a module.** Every module opens with its **learning goals** — the contract between you and the instructor. You demonstrate those goals (in a conversation with the instructor and through your portfolio) rather than ticking off every task, so you may **modify, replace, or extend the tasks as long as you still reach the goals**: different datasets, different engines, deeper deep dives, and stretchers are all fair game.
>
> Each module also carries a ***DRAFT BOUNDARY*** — a moving line that marks the content still under construction. This class is taught for the first time, by an instructor who is also new to teaching databases, so the boundary moves down as we refine things together and your input genuinely shapes it.

## Session roadmap (11 sessions + tutorials)

| Module | Session | Modern studio | Legacy topics it reframes | Hands-on focus |
|:---:|:---:|---|---|---|
| [Module 1](./01-introduction-and-local-first.md) | 1 | Introduction & Local-First Foundations | *Intro: digitization, file-based storage flaws, DB taxonomy* | How the class works; environment check; embedded SQLite vs. server overkill; first LLM-assisted SQL profiling task. |
| [Module 2](./02-data-contracts-and-legacy-schemas.md) | 2 | Data Contracts & Reading Legacy Schemas (ERD Audits) | *Conceptual Database Design (ERM/EERM), requirements analysis* | Reconstruct an ER model from a legacy schema, hunt integrity bugs, draft a code-first data contract. |
| [Module 3](./03-llm-assisted-sql-and-query-profiling.md) | 3 | LLM-Assisted SQL & Query Profiling | *Standard SQL (DQL), relational algebra, query optimization* | Generate complex SQL with an LLM, read `EXPLAIN QUERY PLAN`, benchmark indexes, drill SQL injection. |
| [Module 4](./04-integrity-constraints-and-triggers.md) | 4 | Data Integrity, Constraints & Edge Triggers | *Standard SQL (DDL/DML/DCL), data integrity, triggers/procedures* | `CHECK`/`UNIQUE`/`FK`, `STRICT` tables, generated columns, a trigger enforcing edge-telemetry rules. |
| [Module 5](./05-normalization-vs-denormalization.md) | 5 | Normalization vs. Denormalization Benchmarking Studio | *Relational model, functional dependencies, 1NF–3NF* | Normalize to 3NF, denormalize on purpose, measure read/write/storage trade-offs in SQLite. |
| [Module 6](./06-polyglot-embedded-persistence.md) | 6 | Polyglot & Embedded Persistence | *NoSQL, ACID vs. BASE, CAP theorem, DB within applications* | JSON documents in SQLite, DuckDB analytics over Parquet/CSV, a key-value comparison. |
| [Module 7](./07-final-project-studio.md) | 7–10 | Final Project Studio | *Project planning and implementation* | Kickoff and story, requirement mapping, build, integrate, harden, peer review, rehearse. |
| [Module 8](./08-final-project.md) | 11 | Final Project Specification, Demos & Oral Defenses | *Assessment* | 15-minute live demo + individual oral defense; retrospective. |
| [Resource Prompts](./Y-resources-prompt-bank.md) | — | Supplementary | — | Reflection prompts, LLM-verification drills, quick references. |
| [Resource Bank](./Z-resources-bank.md) | — | Supplementary | — | Cheat sheets, troubleshooting, datasets, extended reading. |
| *Tutorial sessions* | dates TBA | Tutorial support (TA) | — | Catch-up, deeper practice, stretcher deep dives, project support. Times announced via the LMS. |

## What changed, and why

| Legacy emphasis | This course's emphasis | Reason |
|---|---|---|
| Install MySQL Server + Workbench | Embedded SQLite (+ DuckDB) | The database is a library inside your process; no server to administer for a local app. |
| Memorize SQL syntax | Generate with AI, then profile and secure | Syntactic recall is obsolete; reading a query plan and preventing injection is not. |
| ER diagrams as an end product | Schema audits and code-first data contracts | Real work is reading someone else's schema and expressing its meaning in code. |
| Normalization as a rule to obey | Normalization as a measured trade-off | Read/write/storage costs are empirical facts you can benchmark. |
| Relational = the only option | Polyglot persistence, chosen deliberately | Edge and analytical workloads sometimes want JSON, columns, or key-value. |
| A fixed, lecture-scripted syllabus | A moving bar with fixed learning goals | The class is brand new and taught by someone learning databases with you; goals stay stable, tasks can move. |

> **Sources for these shifts.** The move away from server-heavy defaults is documented — not opinion: the [local-first manifesto](https://www.inkandswitch.com/essay/local-first/), SQLite's ["Appropriate Uses For SQLite"](https://www.sqlite.org/whentouse.html) (*"SQLite competes with `fopen()`"*), and [Rails 8 shipping SQLite in production](https://rubyonrails.org/2024/11/7/rails-8-no-paas-required). Full list in the [resource bank](./Z-resources-bank.md#why-local-first-and-why-the-heavy-three-tier-default-is-questioned).

## Assessment

Assessment — how the points are earned, the checkpoints, the reflection format, and the grade scale — is defined in the [syllabus](../syllabus.md#assessment-kombinationsprüfung-20-base-points--bonus).
