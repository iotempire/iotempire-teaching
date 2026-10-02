# Module 7 — Final Project Studio

[← Back to front page](../README.md) | [Quick module index](./00-index.md) | [Next: Module 8 →](./08-final-project.md)

**Course placement:** Sessions 7–10. Four project-studio sessions: kickoff and story, requirement mapping, build, integration, hardening, peer review, and rehearsal. The *specification* — teams, must-haves, documentation, and the demo rubric — lives in [Module 8](./08-final-project.md); this module is the **studio guide** for how you spend the time.

> [!IMPORTANT]
> This is where the 5 final-project points are built. Read [Module 8](./08-final-project.md) **before** Session 7 — you are expected to arrive with a team and a one-paragraph story.

## 🎯 Learning Goals

> **How these are assessed:** This studio builds the artifact for the **5 final-project points**, assessed in Session 11 through the team repository, the 5-page report, and the live demo with an **individual oral defense**. **The goals are the contract: demonstrate them and you earn the points.** The studio steps that follow are a draft you may adapt as a team.

By the end of these four sessions, your team has:

1. A **stakeholder story** that names a real person, a real problem, and the data that solves it.
2. A **mapped requirement set**: which must-have from Module 8 is covered by which deliverable.
3. A **schema and an ingestion pipeline** checked into the team repository, reproducible from scratch.
4. A **working vertical slice**: data goes in, one query comes out, one interface shows it.
5. A **peer-reviewed draft** and a rehearsal plan for the Session 11 demo.

> [!NOTE]
> Task tiers. Tasks marked ★ Core are required. Tasks marked ◇ Stretcher are optional and are excellent bonus material.

> [!WARNING]
> DRAFT — first taught in WS 2026/27 by an instructor who is **also teaching databases for the first time** and is learning this material alongside you. Everything below this line is a working draft and will likely change as we refine it together in class. Different deep dives and stretchers are welcome.

**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 📖 Story First, Schema Second

The legacy course assigned topics ("a library", "a restaurant"). We keep the *free choice* but change the starting point: **begin from a story, not a category.** A story forces the requirements to be real:

> *"Marta runs the night shift at a bottling line in Gütersloh. When a filler jams, she loses 20 minutes walking to a terminal to find out which sensor tripped and when it happened last. She needs a screen on the line that shows the last 10 stops, grouped by cause."*

That paragraph already implies entities (line, stop event, cause), a cardinality (a line has many stop events), a query (last 10 stops grouped by cause), and an interface (a line-side screen). You cannot get that from "make a database for a warehouse."

**Story checklist:**
- Names a person and a place (Marta, the bottling line).
- Names the pain (20 minutes lost, no immediate answer).
- Names the data that fixes it (stop events with causes and timestamps).
- Is **pitchable in 60 seconds**.

## 🛠️ Session 7 — Kickoff & Build (the "make it real" session)

### ★ Step 1: Story and team charter (30 min)

1. Form teams of **3–4**. Record, in `docs/team.md`: each member's name, the story, and **who owns what** (schema, ingestion, queries, interface, docs). Every member must own a piece that can be defended individually in Session 11.
2. Write the one-paragraph story. Get it reviewed by a neighboring team (5 minutes each way): they ask *"what is the first query this database must answer?"*
3. Choose the engine. **SQLite is the default.** Switch to DuckDB, JSON-in-SQLite, or a key-value store only if you can name the workload reason — and write that reason down.

*Evidence:* `docs/team.md` committed.

### ★ Step 2: Map requirements to deliverables (30 min)

Fill in this table in `docs/requirements.md` — it is your checklist and your demo script in one:

| Module 8 must-have | Your deliverable | Status |
|---|---|---|
| Embedded DB with documented schema + one enforced relationship | `schema.sql` + `docs/schema.md` + an ER diagram | |
| Reproducible real-world ingestion | `ingest.py` (CSV/JSON/API export → DB) | |
| Measured indexing proof | benchmark + `EXPLAIN QUERY PLAN` before/after | |
| Parameterized, injection-safe queries | all reads/writes in `app.py` use bound params | |
| Constraint + trigger/generated column enforcing a rule | in `schema.sql` | |
| Evaluation evidence | timings, plan output, storage size, load time | |
| Reachable interface + graceful recovery | Datasette / CLI / small app | |

*Evidence:* `docs/requirements.md` with the table filled in.

### ★ Step 3: Build the vertical slice (rest of Session 7)

Do not build breadth first — build **one path end-to-end**:

```sh
# A reproducible project skeleton (adjust to your story)
myproject/
├── data/            # raw input (gitignored if large) or a download script
├── schema.sql       # CREATE TABLE ... with constraints
├── ingest.py        # loads raw data into the DB, idempotently (UPSERT)
├── queries.sql      # the named queries your app needs
├── app.py           # parameterized access + interface
├── docs/
│   ├── team.md
│   ├── requirements.md
│   └── schema.md
└── README.md        # how to rebuild from scratch in 3 commands
```

1. Write `schema.sql` with at least one foreign key and one `CHECK`.
2. Write `ingest.py` so that `python ingest.py` builds the database from raw input **twice without duplicating rows** (reuse the `UPSERT` pattern from Module 4).
3. Write the story's headline query in `queries.sql` and confirm it returns sensible rows.
4. Wire the smallest possible interface: even `datasette yourdb.db -o` counts.

*Evidence:* commits for `schema.sql`, `ingest.py`, `queries.sql`, and a first interface.

## 🛠️ Sessions 8–10 — Build, Review, and Rehearse

### ★ Step 4: Benchmark and harden (first half)

1. Add at least one index and **prove its effect** with `EXPLAIN QUERY PLAN` and a timing on a non-trivial row count. Save the evidence under `docs/benchmarks/`.
2. Run the **injection self-test**: search your code for any f-string or `%`-formatted SQL and replace it with bound parameters. Paste a deliberately malicious input into every user-facing field and confirm the app survives.
3. Add the trigger or generated column that enforces your domain rule, and demonstrate it firing (and rejecting) something.

*Evidence:* benchmark files, the injection self-test note, and the trigger demonstration output.

### ★ Step 5: Peer review (30 min)

Trade repositories with another team. Reviewers fill in `docs/peer-review.md`:

- Can you rebuild their database from their README **in three commands**? Try it on a clean checkout.
- Find one query that is **not** parameterized, or confirm none are.
- Find one place where the schema could record **wrong data** (a missing constraint) and propose the fix.
- Is the story still visible in the interface?

Give your notes to the other team; they commit the fixes.

*Evidence:* `docs/peer-review.md` (both as reviewer and as reviewee, with fixes linked).

### ★ Step 6: Rehearse the demo (rest of Session 10)

Run a timed **15-minute dry run** of the Session 11 demo (format in [Module 8](./08-final-project.md#the-15-minute-demo--oral-defense)). Time it. The most common failure is running long on slides and short on the live demo — fix that now. Assign who answers which categories of questions.

*Evidence:* `docs/demo-plan.md` with timings and speaker assignments.

### ◇ Step 7 (Stretcher): Ship something back

Open a pull request to IoTempower, this course repository, or an open-source tool that helped you — a fixed typo in a doc, a sample script, a driver tweak. Accepted contributions qualify for bonus points.

## ✅ What must be committed to your portfolio (per member)

Each team member commits their **own** portfolio entry that:
- Links to the shared team repository.
- States **their** contribution and the design decision **they** own.
- Includes the evidence for that piece (their query, their benchmark, their ingestion module).
- Contains a `reflection.md` for the project-studio blocks in the standard format: *What worked? What broke? How did my mental model shift? How did I verify AI suggestions?*

A team repository alone is not enough: the 5 project points include an **individual oral defense**, and your personal portfolio is what you defend from.

## 📚 Team hygiene that saves the demo

- Commit early and often with descriptive messages; a clean Git log is itself evidence of collaboration.
- Keep raw data out of Git; commit the **script** that fetches or generates it.
- Pin your dependencies (`requirements.txt`) so a reviewer can rebuild your environment.
- Write the README's "rebuild in three commands" section **before** you think you are done — you will thank yourself at review time.

---

[← Previous: Module 6](./06-polyglot-embedded-persistence.md) | [Back to front page](../README.md) | [Next: Module 8 — Final Project Specification →](./08-final-project.md)
