# Module 7 — Final Project

[← Previous: Module 6b](./06b-polyglot-persistence.md) | [Quick module index](./00-index.md) | [Back to front page](../README.md)

**Course placement:** Sessions 8–11. One project, one Task. Session 8 is the kickoff, Sessions 9–10 are build and rehearsal, Session 11 is the fair. Read this page once; the appendix is optional.

## 🎬 The Course in One Page

The project is the synthesis, not a new topic. You have learned to keep data local, model it, query it, protect it, normalize it, copy it for analytics, and decide where it lives. Use at least four of those in one small system.

| Module | What it gave you |
|---|---|
| 1 | A local SQLite file and a first ingestion pipeline |
| 2 | A schema, an ER model, and a data contract |
| 3 | Queries, `EXPLAIN QUERY PLAN`, index evidence, injection safety |
| 4 | Constraints, triggers, and idempotent `UPSERT` |
| 5 | Normalization and measured denormalization |
| 6a | An analytical copy in Parquet/DuckDB |
| 6b | A deliberate engine decision |

## 🎯 Learning Goals

By the end, you can:
1. Turn a named person's problem into a schema, a first query, and an interface.
2. Build a reproducible, idempotent ingestion pipeline.
3. Prove one performance decision with `EXPLAIN QUERY PLAN` and a timing.
4. Enforce one domain rule in the database and secure every external input.
5. Demo the system live and defend the part you own.

## 🛠️ Task — Find and build the final project

### 1. Find the story

Bring the project tickets from 6b. A **Project Team of 4–6** (two merged Task Pods) picks one story and answers:
- **Who** is the person, and where do they work?
- **What decision** does the data change?
- **What is the first query** the database must answer?
- **Where does the data come from** — or how will you generate it reproducibly?

If you cannot name the person and the first query, it is a topic, not a project. Use the [project idea bank](../instructor-notes/project-ideas.md) if you are stuck, but choose a direction, not a topic. Record the story and roles in `docs/team.md`.

### 2. Map the evidence

Write a one-page plan in `docs/requirements.md`: one line per must-have, who owns it, and your own dates. The seven must-haves are in the [syllabus project requirements](../syllabus.md#final-project-requirements-5-points); they are the contract, not a menu of extra features.

### 3. Build the vertical slice

One path end-to-end, not five half-features:
- `schema.sql` with one foreign key and one `CHECK`;
- `ingest.py` that runs twice without duplicating rows;
- the headline query in `queries.sql`;
- the smallest interface that shows the answer — `datasette yourdb.db -o` counts.

### 4. Prove and harden

- Add one index and save `EXPLAIN QUERY PLAN` before/after plus a timing.
- Replace every string-built query with bound parameters and run an injection self-test.
- Add one constraint and one trigger or generated column; show it rejecting bad data.

<a id="the-fair-demo--project-discussion"></a>
### 5. Rehearse and present

Session 11 is a **table fair**: each team presents repeatedly at its table while the rest of the room visits, reflects, praises one thing, and gives one concrete suggestion. The instructor and TA circulate; the discussion is individual. Bring a short recorded fallback. Rehearse the live path, not slides; the segment order is in [Appendix E](#e-demo-preparation).

## ✅ Evidence checklist

- [ ] `docs/team.md`: story, members, and who owns what.
- [ ] `docs/requirements.md`: one-page plan with your dates.
- [ ] `schema.sql`: one FK, one `CHECK`, one trigger or generated column.
- [ ] `ingest.py`: repeatable from raw data or a download script; no duplicates.
- [ ] `queries.sql` + `app.py`: the first query and an interface.
- [ ] `docs/benchmarks/`: plan output and timings.
- [ ] Injection self-test note: malicious input rejected.
- [ ] `README.md`: rebuild in three commands; no `.db`, credentials, or personal data in Git.
- [ ] `docs/report.md`: the Projektbericht with the five headings in Appendix C.
- [ ] `docs/demo-plan.md`: table setup, fallback video, who answers what.
- [ ] `Reflections/ref07.md` (and further project entries as needed).

**Assessment:** the [syllabus](../syllabus.md#assessment-project-work-20-points) is the only source for points and grading. This page is the brief; it is not the rubric.

## 📚 Appendix — optional reading

### A. Story coaching

A story is concrete enough when it is **pitchable** in a minute and/or **playable** as a short scene. One named person, one place, one moment of pain, and something at stake are enough. The test that matters: *can you name the first query?* If not, it is still a topic.

The method is *Story Driven Modeling* (Norbisrath, Zündorf & Jubeh, 2013) — start from concrete scenarios, not class diagrams. The [resource bank](./Z-resources-bank.md#story-craft-is-it-concrete-enough) has more.

### B. Case studies: systems that broke the classic stack

<a id="read-before-the-kickoff-systems-that-broke-the-classic-stack"></a>
Two real systems are the existence proof for the local-first bet:

- **[GoToSocial](https://gotosocial.org)** — an ActivityPub/Fediverse server in Go, API-compatible with Mastodon. Where Mastodon runs PostgreSQL + Redis + Sidekiq + a frontend, GoToSocial ships as a **single binary** and uses **SQLite by default** (Postgres optional).
- **[Chatto](https://www.hmans.dev/blog/chatto)** — a team-chat platform that is a **single executable serving its own web frontend**: no reverse proxy, no external database. Its embedded store is NATS JetStream — the same bet with a different engine.

For each: what did it remove, what did it trade away, and what did it gain? One sentence per team in `docs/requirements.md` is enough.

### C. Repository and report template

A reproducible skeleton:

```text
myproject/
├── data/            # raw input or a download script (gitignored if large)
├── schema.sql       # CREATE TABLE ... with constraints
├── ingest.py        # idempotent UPSERT loader
├── queries.sql      # the named queries your app needs
├── app.py           # parameterized access + interface
├── docs/
│   ├── team.md
│   ├── requirements.md
│   ├── schema.md
│   └── benchmarks/
└── README.md        # rebuild in three commands
```

The portfolio's *Projektbericht* uses `docs/report.md` with five headings: story and contributions; schema; ingestion; queries/index evidence; security/integrity and evaluation. The repository and README are the primary evidence; the report is a summary, not a separate deliverable.

### D. Pointers

- [Project idea bank](../instructor-notes/project-ideas.md) — directions, not assignments.
- [Story canon](./Z-resources-bank.md#story-canon-the-recurring-cast) — the recurring cast, if you want to borrow it.
- [Resource bank](./Z-resources-bank.md) — datasets, visualization, tooling.
- [Syllabus assessment](../syllabus.md#assessment-project-work-20-points) — points, grade scale, Excellence Stretcher.

### E. Demo preparation

At your table, cover the whole story in this order:

| Segment | What visitors see | Who |
|---|---|---|
| **The story** | The named person, the problem, where the data comes from | Any member |
| **Live end-to-end** | Raw data → ingestion → database → headline query → interface. Run it live; slides may support, never replace it | Rotating |
| **The proof** | One `EXPLAIN QUERY PLAN` before/after, the timings, the injection self-test | Query owner |
| **Integrity** | Trigger the constraint/trigger live — show it rejecting bad data | Integrity owner |
| **Discussion** | Individual questions on the design decisions each member owns | All |

Keep the poster or slides short. Bring a short recorded fallback of the live flow. Be ready to explain the part you own. If you are visiting, take notes, name one thing that impressed you, and give one concrete suggestion.

---

[← Previous: Module 6b](./06b-polyglot-persistence.md) | [Back to front page](../README.md) | [Quick module index](./00-index.md)
