# Module 8 — Final Project Specification (Local-First Meaningful Challenge)

[← Back to front page](../README.md) | [Quick module index](./00-index.md) | [Previous: Module 7 →](./07-final-project-studio.md)

**Course placement:** Session 11 (demo + defense), built during Sessions 7–10. Worth **5 points (25 % of the base score)**.

> **One question for the whole course:** *How does raw data become a trustworthy, fast, and safe answer — on a machine you actually own?*

> [!IMPORTANT]
> **The syllabus is the single source of truth for assessment.** This page is the detailed specification and rubric. If this page and the [syllabus](../syllabus.md#final-project-requirements-5-points) ever disagree, the syllabus wins; this page is the working detail behind those requirements.

## 🎯 Learning Goals

> **How these are assessed:** You earn credit through the project repository, a 5-page report, and a 15-minute live demo with an **individual oral defense** in Session 11 (see the [syllabus](../syllabus.md#final-project-requirements-5-points) for the assessment rules). **The learning goals, must-have criteria, and rubric are the contract: meet them, and you have met the module.** The studio guidance around them is a draft you may adapt with your team, as long as the must-haves and evidence remain covered.

By the end of the final project, you can:
1. Turn a stakeholder story into a data model, a schema, and named queries that answer a real question.
2. Build a reproducible ingestion pipeline that loads real data into an embedded database idempotently.
3. Prove a performance decision with `EXPLAIN QUERY PLAN` and a before/after measurement.
4. Secure every external input with bound parameters and demonstrate why the naive alternative is injectable.
5. Enforce domain rules in the database (constraints, triggers, or generated columns), not just in application code.
6. Document and **defend** the design decisions and trade-offs you own as an individual.

> [!WARNING]
> DRAFT — first taught in WS 2026/27. The studio guidance and logistics around the fixed criteria may still change as we refine the class together; the must-have criteria and rubric are settled. Different project scopes and deep dives are welcome — talk to the instructor early.

**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft (the must-have criteria and rubric are settled) ===== ⬇︎**

## 🎯 The Challenge

Build a **story-driven, local-first, embedded database application** that solves a real mechatronics, IoT, or industrial-automation problem — for a real person you can name.

You are not building "a database for a library because the topic list said so." You are building the data layer that answers a specific person's specific question, runs on a machine you own, and stores its data next to the thing that produces it. The full CBL/PBL philosophy lives in the [syllabus](../syllabus.md#how-we-teach--challenge--and-project-based-in-person-and-always-in-flux); this page turns it into deliverables.

**Project Teams of 4–6** — the final project merges two Task Pods, so you keep your pod and gain one or two more. Every member owns a piece that they can defend individually. You may, by agreement with the instructor, continue a project from another course — the default is a fresh, self-contained application.

## 🧩 Must-Have System Criteria

These are the requirements every project must meet. They are deliberately mapped to the five modules, so nothing here is a surprise:

| # | Requirement | Why it exists | Where it comes from |
|---|---|---|---|
| 1 | **Embedded database with a documented schema** — SQLite by default (DuckDB/JSON only with a stated workload reason); at least one enforced relationship (`FOREIGN KEY`) | The core local-first choice; and modeling is not optional | Modules 1–2 |
| 2 | **Reproducible real-world data ingestion** — a script loads actual data (sensor/telemetry logs, an export, or a public dataset) and can be re-run without duplicating rows | Hand-typed rows are not data engineering | Modules 1, 4 |
| 3 | **Measured indexing proof** — at least one index whose effect is shown with `EXPLAIN QUERY PLAN` and a before/after timing on a non-trivial dataset | A performance claim needs evidence | Module 3 |
| 4 | **Parameterization & security** — every query touching external input uses bound parameters; you demonstrate that a string-built equivalent would be injectable | Shipping injection is a professional failure | Module 3 |
| 5 | **Integrity & automation at the edge** — at least one constraint and one trigger or generated column that enforce a domain rule | Integrity must live in the database, not the app's good intentions | Module 4 |
| 6 | **Evaluation evidence** — query timings, plan output, storage size, and/or load throughput | Decisions are made with numbers | Module 5 |
| 7 | **Reachable interface** — the data is shown through something a human uses (Datasette, a CLI, a small app, or a dashboard), and the app recovers gracefully from a missing/corrupt row | The story has to reach the person it is for | Modules 6–7 |

> [!NOTE]
> **Stretchers (optional, bonus-worthy).** A normalized-read vs. denormalized-read comparison (Module 5); a DuckDB analytics view over a Parquet export (Module 6); a key-value or JSON component with a measured justification (Module 6); an accepted upstream pull request (any module).

## 📄 Documentation — 5 Pages, Concise

Submit a **5-page** report (Markdown or PDF) in the project repository under `docs/report.md`. Five pages, not five pages *minimum* — conciseness is graded. Use this exact structure:

1. **Story & stakeholders (≈½ page).** The person, the pain, the data. Why this matters.
2. **Schema & data model (≈1 page).** One ER diagram, the `CREATE TABLE` essentials, and the relationship(s) you enforce. State your normalization level and *why*.
3. **Ingestion & pipeline (≈¾ page).** Where the data comes from, how it is loaded, how re-runs stay idempotent.
4. **Queries, indexes & evidence (≈1¼ pages).** The headline query, its `EXPLAIN QUERY PLAN` before and after your index, and the timings. Include one negative or surprising result.
5. **Security, integrity & evaluation (≈1 page).** Your parameterization proof, your constraint/trigger, the measured evaluation numbers, and one honest limitation.
6. **Project Team & contributions (≈½ page).** One line per member: what they owned.

<a id="the-15-minute-demo--oral-defense"></a>
## 🎤 The 15-Minute Demo & Oral Defense

The assessment combines a **Project Team demo** with an **individual oral defense**. Budget your time like this:

| Minutes | Segment | Who |
|---|---|---|
| 0–2 | **The story.** Name the stakeholder and the problem; show where the data comes from. | Any member |
| 2–8 | **Live end-to-end demo.** Raw data → ingestion → database → the headline query → the interface. Run it live; do not show only slides. | Rotating |
| 8–10 | **The proof.** Show one `EXPLAIN QUERY PLAN` before/after, the timings, and the injection self-test. | Query owner |
| 10–12 | **Integrity.** Trigger the constraint/trigger live — show it rejecting bad data. | Integrity owner |
| 12–15 | **Defense.** Individual questions to specific members on the design decisions they own; one "what would you change and why?" | All |

**Preparation rules:**
- Rehearse to the clock (see the Module 7 rehearsal). Slides may support, never replace, the live run.
- Have a **fallback**: a recorded 2-minute capture of the live flow in case the machine misbehaves. A crash you handle calmly and explain is fine; a crash you cannot explain is a lost point.
- Every member answers at least one question. "That was my teammate's part" is not an answer.

## 📊 Evaluation Rubric (5 Points)

| Criterion | Points | Excellent (full) | Sufficient (partial) | Weak / missing |
|---|---|---|---|---|
| **System functionality & measurement quality** | **2.0** | Meets all 7 must-haves; ingestion is reproducible; index proof is convincing; integrity rules fire correctly; evaluation numbers are credible | Meets most must-haves; one gap (e.g. weak benchmark) | Server/hand-loaded data, no measured index, missing integrity, or non-reproducible build |
| **Architecture, documentation & evaluation** | **1.5** | Clear schema/data-flow diagram; ≤5-page report with real before/after evidence and an honest limitation; clean Git history; rebuildable in three commands | Report present and mostly complete; evidence thin in one section | Missing diagram, report over/under length, or no evidence |
| **Live demonstration & oral defense** | **1.5** | End-to-end live demo runs; each member defends their decisions and trade-offs fluently; handles an injected fault | Demo runs but is partly slide-based, or defense is uneven across members | Demo fails without explanation, or members cannot defend their parts |

**Distribution of the 5 points across the Project Team.** The project score is a Project Team score, but the *oral defense* is individual. A member who cannot defend their contribution does not automatically fail the Project Team — the instructor records an individual note, and the bonus/reflection components (4 + up to 3 points) can offset it. Speak to the instructor **early** if a Project Team member is not contributing; that is a project-management problem we solve together, not a reason to wait until the demo.

### What earns bonus points (up to +3 overall for the course)

- A benchmark that goes beyond the requirement (e.g. a before/after/after-three-indexes sweep with a plotted curve).
- An accepted pull request to IoTempower, this course repository, or an open-source tool used in the project.
- Substantial, verifiable peer-debugging assistance to another Project Team (documented in your reflection and confirmed by the helped Project Team).

## ✅ Submission Checklist

Before Session 11, the project repository must contain:

- [ ] `README.md` with "rebuild in three commands" and a `requirements.txt`.
- [ ] `schema.sql` with the enforced relationship(s), at least one constraint, and a trigger/generated column.
- [ ] `ingest.py` that re-runs idempotently from committed or scripted raw data.
- [ ] `queries.sql` and `app.py` (all external input via bound parameters).
- [ ] `docs/schema.md` + ER diagram, `docs/report.md` (≤5 pages), `docs/team.md`, `docs/requirements.md`.
- [ ] `docs/benchmarks/` with `EXPLAIN QUERY PLAN` output and timings.
- [ ] A working interface runnable from the README (Datasette, CLI, or app).
- [ ] Each member's **personal** portfolio links the project repo and contains their own contribution + `reflection.md`.

> [!WARNING]
> Do not commit `*.db`, `*.duckdb`, `*.parquet`, `.env`, credentials, or personal data. A reviewer must rebuild your database from your scripts. Committing a database file instead of the script that builds it is an automatic documentation deduction.

## 🗓️ Where this fits in the course

- Build time: [Module 7 — Final Project Studio](./07-final-project-studio.md) (Sessions 7–10).
- Demo & defense: Session 11.
- Points: 5 of the 20 base points (25 %). See the [syllabus assessment rules](../syllabus.md#assessment-kombinationsprüfung-20-base-points--bonus) and the [grade scale](../syllabus.md#grade-scale).

---

[← Previous: Module 7](./07-final-project-studio.md) | [Back to front page](../README.md) | [Quick module index](./00-index.md)
