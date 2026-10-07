# Module 5 — Normalization vs. Denormalization Benchmarking Studio

[← Back to front page](../README.md) | [Quick module index](./00-index.md) | [Next: Module 6 →](./06-polyglot-embedded-persistence.md)

> **One question for the whole course:** *How does raw data become a trustworthy, fast, and safe answer — on a machine you actually own?*

**Course placement:** Session 5. This module covers the legacy *Relational Model* and *Normalization (1NF–3NF)* chapters — reframed as an empirical performance-and-storage trade-off you measure yourself.

## 🎯 Learning Goals

> **How these are assessed:** You show that you have reached these goals in a short (~10-minute) checkpoint presentation in Session 8 — based on your portfolio and reflections, not on completing every task. See the [syllabus](../syllabus.md#how-module-points-are-earned-checkpoint-presentations) for the assessment rules. **These learning goals are the contract between you and the instructor: demonstrate them, and you have met the module.** The tasks in this module are a draft — you are encouraged to modify, replace, or extend them as long as your alternative reaches the same goals. You may skip tasks, fail at some, or add your own; documented exploration and demonstrated deep understanding both count in your favor.

This module gives you the opportunity to explore functional dependencies and normalization and achieve competency in trading schema design against real, measured performance.

By the end of this module, you can:
1. Derive **functional dependencies** from a relation and identify candidate keys.
2. Normalize a relation to **1NF, 2NF, and 3NF**, explaining the anomaly each step removes.
3. **Denormalize deliberately** to speed up a hot read path, and predict what it costs on writes and storage.
4. **Measure** the trade-off: query latency, insert throughput, and database size — before and after.
5. Decide, and *defend*, where a schema should sit on the normalization spectrum for a given workload.

> [!NOTE]
> Task tiers. Tasks marked ★ Core must be completed by everyone. Tasks marked ◇ Stretcher are optional and are the natural trim point if time runs short — they are excellent bonus-task material.

> [!WARNING]
> DRAFT — first taught in WS 2026/27 by an instructor who is **also teaching databases for the first time** and is learning this material alongside you. Everything below this line is a working draft and will likely change as we refine it together in class; the line moves down as we approve content. Different deep dives and stretchers are welcome — your input can shape this module.

**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 📖 Story — The Dashboard That Took 40 Seconds

Kortmann's plant now has a machine-health dashboard. Every 30 seconds it asks a hard question: *"for each machine, show its site, its technician's name, and the total cost of parts used in the last 90 days."* Against the normalized schema you repaired in Module 2, that query joins four tables and scans the whole `job_part` history. On the production dataset it takes **40 seconds** — and it blocks the single writer while it runs.

The operations lead, **Yasmin Kaya**, offers the classic shortcut: *"just copy the site and the technician name onto every job row and add a total-cost column. Then the dashboard reads one table."* She is right about the read. She is also about to introduce update anomalies. Your job in this studio is to **do both**: keep the schema correct, add the denormalized reporting path *on purpose*, and **measure** what it buys and what it costs, so the team makes the decision with numbers.

## 📖 Part A — Mini-Lecture: Dependencies, Anomalies, and the Spectrum

**Functional dependency.** `X → Y` means: for any two rows, if they agree on `X`, they must agree on `Y`. In a maintenance table, `job_id → technician`, `machine_id → site`, `part_no → unit_price`. Dependencies are the *reason* normalization is possible — they are the redundancy you can remove.

**Candidate keys.** The minimal set of attributes that determines all others. From the dependencies above, `(job_id, part_no) → everything` is a candidate key for a job-part row.

**The normal forms — and the anomaly each one removes:**

| Form | Rule | Anomaly it removes |
|---|---|---|
| **1NF** | Atomic values only; no repeating groups or comma-lists | The `parts_used = 'P-1001,P-1002'` mess from Module 2 |
| **2NF** | 1NF **and** no partial dependency on part of a composite key | `part_no → unit_price` stored on a `(job_id, part_no)` row — price duplicates and drifts |
| **3NF** | 2NF **and** no transitive dependency (non-key → non-key) | `machine_id → site` stored on job rows — change a site once, update a thousand rows |

**The three anomalies** (be ready to name them at the checkpoint):
- **Update anomaly:** the same fact stored in many places can disagree after one edit.
- **Insert anomaly:** you cannot record a fact because an unrelated fact is missing.
- **Delete anomaly:** deleting one row silently destroys another fact.

**The spectrum.** Normalization minimizes redundancy and anomalies; denormalization trades redundancy back for read speed. There is no "correct" level — there is a **workload**, and a level that fits it. That is what you will prove.

> [!TIP]
> 3NF is the default, not the law. Analytically heavy read paths (dashboards, reports) are exactly where deliberate denormalization — or a separate columnar engine like DuckDB (Module 6) — earns its keep.

## 🛠️ Studio Lab: Normalize, Denormalize, and Measure — **Challenging**

*Software:* the `sqlite3` CLI and Python 3.11+. Use `.timer on` in SQLite or Python's `time.perf_counter()`.

### Setup

Build a deliberately unnormalized table with real volume so the benchmark means something.

```sh
mkdir -p module-05
sqlite3 module-05/normalize.db <<'SQL'
DROP TABLE IF EXISTS flat_jobpart;
CREATE TABLE flat_jobpart (
    job_id      INTEGER,
    machine_id  TEXT,
    site        TEXT,           -- transitive dependency machine_id -> site
    technician  TEXT,
    part_no     TEXT,
    part_price  TEXT,           -- partial dependency part_no -> part_price, and TEXT!
    done_on     TEXT
);

-- ~200k rows: 20k jobs x on average 10 parts
WITH RECURSIVE j(n) AS (SELECT 1 UNION ALL SELECT n+1 FROM j WHERE n < 20000),
               p(k) AS (SELECT 1 UNION ALL SELECT k+1 FROM p WHERE k < 10)
INSERT INTO flat_jobpart
SELECT n,
       'cnc-' || printf('%02d', (n % 50) + 1),
       CASE (n % 50) WHEN 0 THEN 'Bielefeld' ELSE 'Gütersloh' END,
       'tech-' || (n % 7),
       'P-' || printf('%04d', (k % 40) + 1),
       printf('%.2f', 5 + (k % 40)),
       date('2026-01-01', '+' || (n % 90) || ' days')
FROM j CROSS JOIN p;

CREATE INDEX ix_flat_machine ON flat_jobpart(machine_id);
SQL
sqlite3 module-05/normalize.db "SELECT COUNT(*) AS rows FROM flat_jobpart;"
```

### ★ Task 1: Name the dependencies and the anomalies

1. Write down the functional dependencies you can see: `machine_id → site`, `part_no → part_price`, `job_id → machine_id`, `job_id → technician`, `job_id → done_on`.
2. For each of the three anomalies (update, insert, delete), write **one concrete example** that this flat table makes possible. Save to `module-05/normalization-notes.md`.

*Portfolio evidence:* the dependency list and the three anomaly examples.

### ★ Task 2: Normalize to 3NF

Decompose `flat_jobpart` into `machine`, `part`, `job`, and `job_part`. Keep the derived tables, then verify that a join reproduces the original facts.

```sql
DROP TABLE IF EXISTS machine, part, job, job_part;

CREATE TABLE machine(machine_id TEXT PRIMARY KEY, site TEXT NOT NULL);
CREATE TABLE part(part_no TEXT PRIMARY KEY, part_price REAL NOT NULL);
CREATE TABLE job(job_id INTEGER PRIMARY KEY, machine_id TEXT NOT NULL
                 REFERENCES machine(machine_id), technician TEXT NOT NULL, done_on TEXT NOT NULL);
CREATE TABLE job_part(job_id INTEGER REFERENCES job(job_id),
                      part_no TEXT REFERENCES part(part_no),
                      PRIMARY KEY (job_id, part_no));

INSERT INTO machine SELECT DISTINCT machine_id, site FROM flat_jobpart;
INSERT INTO part    SELECT DISTINCT part_no, CAST(part_price AS REAL) FROM flat_jobpart;
INSERT INTO job     SELECT DISTINCT job_id, machine_id, technician, done_on FROM flat_jobpart;
INSERT INTO job_part SELECT DISTINCT job_id, part_no FROM flat_jobpart;

-- integrity check: the join must reproduce the row count of the flat table
SELECT (SELECT COUNT(*) FROM flat_jobpart)  AS flat_rows,
       (SELECT COUNT(*) FROM job_part)      AS normalized_rows;
```

*Portfolio evidence:* the DDL, the insert statements, and the row-count integrity check (the two numbers must match).

### ★ Task 3: The benchmark — the anomaly the operations lead likes

Now build the **denormalized reporting table** the operations lead asked for — site and technician copied onto every row, plus a pre-computed `total_cost` — and race the two designs on the dashboard query.

```sql
DROP TABLE IF EXISTS report_jobpart;
CREATE TABLE report_jobpart AS
SELECT j.job_id, m.machine_id, m.site, j.technician, jp.part_no,
       p.part_price, j.done_on
FROM job j
JOIN machine m  ON m.machine_id = j.machine_id
JOIN job_part jp ON jp.job_id = j.job_id
JOIN part p     ON p.part_no = jp.part_no;
CREATE INDEX ix_report_machine ON report_jobpart(machine_id);
```

Run the same analytical query on both and compare the plans and the wall-clock time:

```sql
.timer on

-- A) normalized: a four-way join
SELECT m.machine_id, m.site, j.technician, SUM(p.part_price) AS cost
FROM job j
JOIN machine m   ON m.machine_id = j.machine_id
JOIN job_part jp ON jp.job_id = j.job_id
JOIN part p      ON p.part_no = jp.part_no
WHERE j.done_on >= date('2026-03-01')
GROUP BY m.machine_id, j.technician;

-- B) denormalized: a single-table scan
SELECT machine_id, site, technician, SUM(part_price) AS cost
FROM report_jobpart
WHERE done_on >= date('2026-03-01')
GROUP BY machine_id, technician;
```

Then measure the **cost of the shortcut** — writes and storage:

```sql
.timer on
-- Write cost: insert one new part usage into both designs
INSERT INTO job_part  VALUES (1, 'P-0399');
INSERT INTO report_jobpart VALUES (1,'cnc-01','Gütersloh','tech-0','P-0399',9.99,'2026-03-01');

-- Storage cost (measure the same way for each design, using the dbstat virtual table)
SELECT 'normalized (job + job_part + part + machine)' AS design,
       (SELECT SUM(pgsize) FROM dbstat WHERE name IN ('job','job_part','part','machine')) AS bytes;
SELECT 'denormalized (report_jobpart)' AS design,
       (SELECT SUM(pgsize) FROM dbstat WHERE name = 'report_jobpart') AS bytes;
```

Record, in a table like the one below, every number you measured:

| Design | Dashboard query (ms) | Insert 1 row (ms) | Storage (KB) | Redundancy? |
|---|---|---|---|---|
| Normalized (3NF) | | | | none |
| Denormalized (report) | | | | site/technician repeated |

*Portfolio evidence:* the `report_jobpart` DDL, both query plans (`EXPLAIN QUERY PLAN`), both timings, the write/storage numbers, and your filled table.

### ★ Task 4: Decide and defend

Write a short recommendation (5–8 sentences) to the operations lead: which design should serve the dashboard, what the normalization of the transactional tables must stay at, and — crucially — **how you would keep the denormalized table from going stale** (a trigger from Module 4, a scheduled rebuild, or a materialized view). Cite your own numbers.

*Portfolio evidence:* the recommendation memo, referencing your benchmark table.

### ◇ Task 5 (Stretcher): Push the frontier

Load the same data into DuckDB and run the dashboard query there. Capture wall-clock time and note whether DuckDB's columnar engine removes the need for the denormalized table entirely. This is a natural bridge into Module 6.

## ✅ What must be committed to your portfolio

Commit under `module-05/`:

- [ ] The setup script that builds `flat_jobpart` with ~200k rows (so the benchmark is reproducible).
- [ ] `normalization-notes.md` — functional dependencies and one example of each anomaly.
- [ ] The 3NF DDL, the inserts, and the integrity row-count check.
- [ ] The denormalized `report_jobpart` DDL and the benchmark table with all measured numbers.
- [ ] `EXPLAIN QUERY PLAN` output for both designs.
- [ ] The recommendation memo citing your numbers, including the staleness strategy.
- [ ] `reflection.md` — the logbook entry for this block.
- [ ] (Stretcher) the DuckDB comparison.

## 📚 If you want to go deeper

- SQLite — `PRAGMA optimize`, `ANALYZE`, and planner statistics — [sqlite.org/pragma.html#pragma_optimize](https://www.sqlite.org/pragma.html#pragma_optimize)
- SQLite — the `dbstat` virtual table for measuring storage per object — [sqlite.org/dbstat.html](https://www.sqlite.org/dbstat.html)
- Markus Winand — *Use The Index, Luke* (indexing and pagination) — [use-the-index-luke.com](https://use-the-index-luke.com/)
- DuckDB — why columnar and vectorized engines win on aggregations — [duckdb.org/why_duckdb](https://duckdb.org/why_duckdb.html)

---

[← Previous: Module 4](./04-integrity-constraints-and-triggers.md) | [Back to front page](../README.md) | [Next: Module 6 →](./06-polyglot-embedded-persistence.md)
