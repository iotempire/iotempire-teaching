# What the seven modules gave you

| Module | You can now |
|---|---|
| 1 | Open a local SQLite file and load raw data reproducibly |
| 2 | Read a schema, draw the ER model, write a data contract |
| 3 | Write SQL, read `EXPLAIN QUERY PLAN`, prove an index, block injection |
| 4 | Enforce rules with `CHECK`, `UNIQUE`, `FK`, triggers, idempotent upserts |
| 5 | Normalize to 3NF, denormalize on purpose, and measure the trade-off |
| 6a | Move a report to Parquet/DuckDB and find where the engine loses |
| 6b | Choose an engine for a workload and defend it with numbers |

**The point:** you can take a messy question and build a small, measured, safe system around it.

<!-- Note: 3–4 minutes. Do not re-teach. Point at the portfolio: the evidence is already there. -->

---

# What the project asks of you

- **One person, one decision, one first query — and a reason it matters to one of you.** No named person and first query = a topic, not a project.
- **Use at least four of the seven modules** — not all.
- **The seven must-haves** are the contract:
  1. a schema with an enforced relationship
  2. reproducible ingestion, not hand-typed rows
  3. one index proved with `EXPLAIN QUERY PLAN` and a timing
  4. bound parameters, plus a demonstrated injection attempt
  5. one constraint and one trigger or generated column
  6. evaluation: timings, plans, storage, throughput
  7. an interface a human can use, and graceful recovery
- **The story test:** a named person + a first query — or we pick a family together.

<!-- Note: 3–4 minutes. The must-haves are in the syllabus; do not read them twice. -->

---

# Today: from modules to one project

1. **Merge two pods** → a Project Team of 6–8.
2. **Pitch two candidate families** (2 minutes per pod). Each member may bring one idea to the pod chat first.
3. **Choose one** and pass the **story test**.
4. **Write `docs/charter.md`** — one page: actors, workflows with states, use cases → queries, the slice, where the data lives, the cut list.
5. **Elect a Product Owner and a process keeper**; name the pod leads.
6. **Split the slice into work packages** (≤ half a day, owner + acceptance line) in `docs/backlog.md`.
7. **Start the slice before the break:** schema → ingest → query → interface.

**Second block:** Checkpoint 2, first half (all modules), while the rest build.
**Next:** 3 December checkpoint second half · 17 December fair.

<!-- Note: 3 minutes, then hand off. End on step 1: merge pods and pitch. -->
