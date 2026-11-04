# Module 5 — Normalization vs. Denormalization Benchmarking Studio

[← Back to front page](../README.md) | [Quick module index](./00-index.md) | [Next: Module 6 →](./06-polyglot-embedded-persistence.md)

**Course placement:** Session 5. This module covers the legacy *Relational Model* and *Normalization (1NF–3NF)* chapters — reframed as an empirical performance-and-storage trade-off you measure yourself.

## 🎯 Learning Goals

This module gives you the opportunity to explore functional dependencies and normalization and achieve competency in trading schema design against real, measured performance.

By the end of this module, you can:
1. Derive **functional dependencies** from a relation and identify candidate keys.
2. Normalize a relation to **1NF, 2NF, and 3NF**, explaining the anomaly each step removes.
3. **Denormalize deliberately** to speed up a hot read path, and predict what it costs on writes and storage.
4. **Measure** the trade-off: query latency, write cost, and database size — before and after.
5. Decide, and *defend*, where a schema should sit on the normalization spectrum for a given workload.

**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 📖 Story — The Dashboard That Took 40 Seconds

Kortmann's plant now has a machine-health dashboard. Every 30 seconds it asks a hard question: *"for each machine, show its site, its technician's name, and the total cost of parts used in the last 90 days."* Against the normalized schema you repaired in Module 2, that query joins four tables and scans the whole `job_part` history. On the production dataset it takes **40 seconds** — and it blocks the single writer while it runs.

The operations lead, **Yasmin Kaya**, offers the classic shortcut: *"just copy the site and the technician name onto every job row and add a total-cost column. Then the dashboard reads one table."* She is right about the read. She is also about to introduce update anomalies. Your job in this studio is to **do both**: keep the schema correct, add the denormalized reporting path *on purpose*, and **measure** what it buys and what it costs, so the team makes the decision with numbers.

## 📖 Pod Study: Dependencies, Anomalies, and the Spectrum

This is **self/pod study, not a lecture** — **30 minutes** in your pod, then **15 minutes** with a neighbouring pod. **Hard stop at minute 30**, even if you have not finished: the lab continues the same material, and starting it with half an answer beats running out of time. Notes go in `Module05/normalization-notes.md`, same discipline as [Module 2](./02-data-contracts-and-legacy-schemas.md).

### Divide and conquer (do not read this alone, front to back)

| Workstream | Read and do | Bring back |
|---|---|---|
| **1 · FDs and keys** | the first two blocks, then the five-row table in Task A | the FD list, marked *domain* vs *observed* |
| **2 · Normal forms** | the 1NF–3NF table; find one table in this course for each form | one example per form |
| **3 · Anomalies** | the three anomalies; cause the update, insert, and delete by hand | the three SQL statements and the inconsistent row |
| **4 · Examples** | the “Where you have already met both designs” table and the star schema below | one normalized and one denormalized example from your own project |

Every six minutes, interrupt each other for a **one-minute update** — found, surprised, still unclear. At minute 30 you stop, whatever state you are in.

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

### Where you have already met both designs

| Design | In this course | What is duplicated | What it buys |
|---|---|---|---|
| **Normalized** | Module 2's repaired schema; Module 3's `customer` / `orders` / `order_line`; this module's 3NF tables | nothing | change a fact once; integrity |
| **Denormalized — accidental** | Module 2's `parts_used = 'P-1001,P-1002'` | a list of parts per job | “one column instead of a junction table” |
| **Denormalized — mild** | Module 1's `readings` — the machine name on every reading | machine name per row | no join to a machine table |
| **Denormalized — deliberate** | This module's `report_jobpart`; your final project | site, technician, price on every fact row | one table for the dashboard |
| **Semi-structured** | Module 6's `device.meta` JSON | vendor fields per device | schema flexibility |
| **Star schema** | analytics in general; Module 6's Parquet export | dimensions copied into the fact table | fast aggregates |

**The star schema is the standard analytics denormalization.** A fact table stores keys and measures; the dimensions store the descriptive attributes once:

| Table | Columns |
|---|---|
| `fact_sales` | `date_key, product_key, store_key, qty, revenue` |
| `dim_product` | `product_key, name, category, brand` |
| `dim_date` | `date_key, day, week, month, quarter, year` |

A *fully* denormalized variant would copy `name, category, brand` onto every fact row — fastest to read, and painful the day a product is renamed. That is the same trade-off as `report_jobpart`, one level up.

Concretely, one row of `report_jobpart` is `(1, 'cnc-02', 'Gütersloh', 'tech-1', 'P-0002', 6.0, '2026-01-02')` — the site and the technician that the 3NF design stores **once** are now repeated on all 4,000 rows for that machine.

### Pointers (start here, then keep looking)

- Functional dependency — [Wikipedia](https://en.wikipedia.org/wiki/Functional_dependency)
- The normal forms, formally — [3NF](https://en.wikipedia.org/wiki/Third_normal_form) · [BCNF](https://en.wikipedia.org/wiki/Boyce%E2%80%93Codd_normal_form)
- Denormalization as a decision, not a sin — [Wikipedia](https://en.wikipedia.org/wiki/Denormalization)
- **Prefer watching?** [Lecture-style videos for this module](./Z-resources-bank.md#watching-instead-of-reading)

### Questions to ask an LLM (then verify against the data)

- "Here is a flat table: `<paste the columns and three sample rows>`. List the functional dependencies you can infer, and mark which are **domain facts** and which are only **observed** in these rows."
- "Explain 2NF vs 3NF with a table where 2NF holds but 3NF fails."
- "Give me a concrete update anomaly in this table, with the SQL statements and the inconsistent rows afterwards."
- "When is denormalization the right call? Give a workload where 3NF is measurably slower, and say what the cost is."

> The first prompt is the trap. An LLM will happily promote an accident in three sample rows into a "dependency". Decide for yourself which FDs the **domain** guarantees.

### ★ Task A: Study in your pod (~30 minutes — hard stop)

**Find the dependencies, then break the table.** Here is a five-row extract of the kind of table this studio starts from:

| job_id | machine_id | site | technician | part_no | part_price |
|---|---|---|---|---|---|
| 1 | cnc-01 | Gütersloh | tech-0 | P-0001 | 6.00 |
| 1 | cnc-01 | Gütersloh | tech-0 | P-0002 | 7.00 |
| 2 | cnc-02 | Gütersloh | tech-1 | P-0001 | 6.00 |
| 2 | cnc-02 | Gütersloh | tech-1 | P-0003 | 8.50 |
| 3 | cnc-01 | Gütersloh | tech-0 | P-0003 | 8.50 |

1. **Name the FDs** (`X → Y`) you believe hold, and mark each as *guaranteed by the domain* or *merely observed here*.
2. **Cause an update anomaly in SQL.** Put the five rows in a table, then move `cnc-01` to Bielefeld and count how many rows you had to touch. Then argue what happens when two people do it in two sessions.
3. **Cause an insert and a delete anomaly.** Add a new part that no job has used yet — without inventing a job. Then delete the last job that used a part and ask what fact just vanished with it.
4. **Then check yourself.** Ask the LLM for the FDs of the same table (prompt 1 above) and diff its list against yours. Where it disagrees, decide who is right and why.

Keep the FD list and the three anomaly examples in `normalization-notes.md` — the lab asks for exactly this on the real 200,000-row table.

### ★ Task B: Share with another pod (~15 minutes)

1. Compare FD lists. **Every pod will have one FD the others do not** — argue it out; the disagreement is the lesson.
2. Agree on the 3–5 points you jointly stand behind (e.g. *"a price is a property of the part, not of the job"*).
3. Add an **“Agreed learning (pod discussion)”** section to your own `normalization-notes.md`; unresolved points go to `#sql-questions`.

## 🛠️ Studio Lab: Normalize, Denormalize, and Measure — **Challenging**

*Software:* the `sqlite3` CLI and Python 3.14. Use `.timer on` in SQLite, or Python's `time.perf_counter()` — see [Measuring query time](./Z-resources-bank.md#measuring-query-time).

### Setup

Build a deliberately unnormalized table with real volume so the benchmark means something.

```sh
mkdir -p Module05
sqlite3 Module05/normalize.db <<'SQL'
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

-- ~200k rows: 20k jobs x exactly 10 parts
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
sqlite3 Module05/normalize.db "SELECT COUNT(*) AS rows FROM flat_jobpart;"
```

> [!NOTE]
> **Same harvest habit as [Module 3](./03-llm-assisted-sql-and-query-profiling.md)** (collect curiosities, swap lists — at the break and at the end). Three things here are worth marking in your `Module05/sql-notes.md`: the **`CROSS JOIN`** of two generated sequences (why 20,000 × 10 = 200,000 rows — and why that is not a join in the relational sense at all), **`printf('%.2f', …)`**, which stores a price as *text* (what does that cost you when you sort or compare it?), and the `dbstat` numbers (why is the denormalized copy so much bigger?). Bring whatever else surprises you to the swap.

### ★ Task 1: Name the dependencies and the anomalies

1. Write down the functional dependencies you can see: `machine_id → site`, `part_no → part_price`, `job_id → machine_id`, `job_id → technician`, `job_id → done_on`.
2. For each of the three anomalies (update, insert, delete), write **one concrete example** that this flat table makes possible. Save to `Module05/normalization-notes.md`.

*Portfolio evidence:* the dependency list and the three anomaly examples.

### ★ Task 2: Normalize to 3NF

Decompose `flat_jobpart` into `machine`, `part`, `job`, and `job_part`. Keep the derived tables, then verify that a join reproduces the original facts.

```sql
DROP TABLE IF EXISTS job_part;
DROP TABLE IF EXISTS job;
DROP TABLE IF EXISTS part;
DROP TABLE IF EXISTS machine;

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

> [!NOTE]
> `PRAGMA foreign_keys` is **off** by default (Module 4), so the `REFERENCES` clauses here are documentation unless you switch it on. The data in this generator is consistent, so the inserts succeed either way — but turn the pragma on once and re-run to see whether your decomposition really respects the relationships.

### ★ Task 3: The benchmark — the anomaly the operations lead likes

Now build the **denormalized reporting table** the operations lead asked for — site, technician, and the part price copied onto every row — and race the two designs on the dashboard query.

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

> Your numbers will be in the **milliseconds**, not the 40 seconds from the story — that story is about the production dataset. What matters is the **ratio**, the **plan**, and the **rows touched**, not the absolute value. If the difference is small on 200,000 rows, that is itself a finding.

Then measure the **cost of the shortcut** — the duplicated fact and the storage. Do not time a single-row insert: both designs do that in well under a millisecond. The cost of denormalization is *changing a duplicated fact*.

```sql
.timer on

-- Run the two updates one at a time so each gets its own Run Time line.
-- Change one machine's site. In 3NF that is one row; in the report table it is
-- every row for that machine (4,000 here).
UPDATE machine        SET site = 'Bielefeld' WHERE machine_id = 'cnc-02';
UPDATE report_jobpart SET site = 'Bielefeld' WHERE machine_id = 'cnc-02';

-- Storage (dbstat: pages per object)
SELECT 'normalized (job + job_part + part + machine)' AS design,
       (SELECT SUM(pgsize) FROM dbstat WHERE name IN ('job','job_part','part','machine')) AS bytes;
SELECT 'denormalized (report_jobpart)' AS design,
       (SELECT SUM(pgsize) FROM dbstat WHERE name = 'report_jobpart') AS bytes;
```

Record the **number of rows touched**, not only the milliseconds: **1 versus 4,000** is the number that scales — and it is the update anomaly you caused by hand in Task A, now with a price tag.

> [!NOTE]
> **Try dropping the index.** `DROP INDEX ix_report_machine;` and re-run the dashboard query. On this dataset it usually gets *faster*: the planner was walking the whole index and then fetching each row from the table, which costs more than one sequential scan. That is a second negative result, and a good one to keep.

Record, in a table like the one below, every number you measured:

| Design | Dashboard query (ms) | Rows changed by one site update | Storage (KB) | Redundancy? |
|---|---|---|---|---|
| Normalized (3NF) | | | | none |
| Denormalized (report) | | | | site/technician/price repeated |

*Portfolio evidence:* the `report_jobpart` DDL, both query plans (`EXPLAIN QUERY PLAN`), both timings, the write/storage numbers, and your filled table.

### ★ Task 4: Decide and defend

Write a short recommendation (5–8 sentences) to the operations lead: which design should serve the dashboard, what the normalization of the transactional tables must stay at, and — crucially — **how you would keep the denormalized table from going stale** (a trigger from Module 4, a scheduled rebuild, or a materialized view). Cite your own numbers.

*Portfolio evidence:* the recommendation memo, referencing your benchmark table.

### ◇ Task 5 (Stretcher): Push the frontier

Load the same data into DuckDB and run the dashboard query there. Capture wall-clock time and note whether DuckDB's columnar engine removes the need for the denormalized table entirely. This is a natural bridge into Module 6.

## ✅ Suggested portfolio evidence (proofs of the learning goals)


- [ ] The setup script that builds `flat_jobpart` with ~200k rows (so the benchmark is reproducible).
- [ ] `normalization-notes.md` — functional dependencies and one example of each anomaly.
- [ ] The 3NF DDL, the inserts, and the integrity row-count check.
- [ ] The denormalized `report_jobpart` DDL and the benchmark table with all measured numbers.
- [ ] `EXPLAIN QUERY PLAN` output for both designs.
- [ ] The recommendation memo citing your numbers, including the staleness strategy.
- [ ] `Reflections/ref05.md` — the logbook entry for this block, using the [reflection template](https://github.com/iotempire/iot-portfolio-template/blob/main/Reflections/TEMPLATE.md).
- [ ] (Stretcher) the DuckDB comparison.

## 📚 If you want to go deeper

- SQLite — `PRAGMA optimize`, `ANALYZE`, and planner statistics — [sqlite.org/pragma.html#pragma_optimize](https://www.sqlite.org/pragma.html#pragma_optimize)
- SQLite — the `dbstat` virtual table for measuring storage per object — [sqlite.org/dbstat.html](https://www.sqlite.org/dbstat.html)
- Markus Winand — *Use The Index, Luke* (indexing and pagination) — [use-the-index-luke.com](https://use-the-index-luke.com/)
- DuckDB — why columnar and vectorized engines win on aggregations — [duckdb.org/why_duckdb](https://duckdb.org/why_duckdb.html)

---

[← Previous: Module 4](./04-integrity-constraints-and-triggers.md) | [Back to front page](../README.md) | [Next: Module 6 →](./06-polyglot-embedded-persistence.md)
