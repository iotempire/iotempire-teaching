# Module 5 — Normalization vs. Denormalization Benchmarking Studio

[← Back to front page](../README.md) | [Quick module index](./00-index.md) | [Next: Module 6a →](./06a-duckdb-analytical-engine.md)

**Course placement:** Session 5. This module covers the legacy *Relational Model* and *Normalization (1NF–3NF)* chapters — reframed as an empirical performance-and-storage trade-off you measure yourself.

## 🎯 Learning Goals

This module gives you the opportunity to explore functional dependencies and normalization and achieve competency in trading schema design against real, measured performance.

By the end of this module, you can:
1. Derive **functional dependencies** from a relation and identify candidate keys.
2. Normalize a relation to **1NF, 2NF, and 3NF**, explaining the anomaly each step removes.
3. **Denormalize deliberately** to speed up a hot read path, and predict what it costs on writes and storage.
4. **Measure** the trade-off: query latency, write cost, and database size — before and after.
5. Decide, and *defend*, where a schema should sit on the normalization spectrum for a given workload.

## 📖 Story — The Dashboard That Took 40 Seconds

Kortmann's plant now has a machine-health dashboard. Every 30 seconds it asks a hard question: *"for each machine, show its site, its technician's name, and the total cost of parts used in the last 90 days."* Against the normalized schema you repaired in Module 2, that query joins four tables and scans the whole `job_part` history. On the production dataset it takes **40 seconds** — and it blocks the single writer while it runs.

The operations lead, **Yasmin Kaya**, offers the classic shortcut: *"just copy the site and the technician name onto every job row and add a total-cost column. Then the dashboard reads one table."* She is right about the read. She is also about to introduce update anomalies. Your job in this studio is to **do both**: keep the schema correct, add the denormalized reporting path *on purpose*, and **measure** what it buys and what it costs, so the team makes the decision with numbers.

## 🧭 How this studio works now

**The study is folded into the practice.** In the earlier modules the pod study ate 60–90 minutes and crowded out the lab, so from here on there is **no separate study phase and no scheduled hand-off to another pod**. Each round below gives you a small thing to do, and a short **“Theory you need”** box you read only when the task makes you want it. Keep your notes in `Module05/normalization-notes.md`.

**First 15 minutes: skim, do not start.** Read this primer (2 minutes), then skim the whole module — the seven rounds, the theory boxes, the evidence list at the end. You are looking for two things: **where the numbers come from**, and **where you will be asked to draw something**. After that, start Round 1 and work at your pod's pace.

**Rough timing — Rounds 1–4 fill the two blocks of 90.** skim 15 → **1 See it** 25 → **2 Break it** 20 → **3 Build it** 50 → **4 Race it** 70 = 180 minutes. The break falls somewhere inside Round 3; take it when the build is running.

**Rounds 5–7 are homework.** If your pod is faster, start Round 5 in class; if you are slower, finish Round 4 at home — but do not skip it. **Bring the homework rounds to Session 6:** the first 15 minutes of Module 6a are the Module 5 gate. No artefact? Say "not yet" and start the DuckDB studio — it does not block you.

**Every round ends with a gate.** Show the round's artefact to the **nearest pod** and ask them the gate question. Two minutes, no instructor, no schedule. Tick the round on the gate board (or in your notes) when you have passed it. If a neighbour cannot answer your question, that is a better use of five minutes than reading the box again.

| # | Round | You produce | Gate question for a neighbour |
|---|---|---|---|
| 1 | **See it** | an FD list and two ER sketches | “Which arrow disappears in the second diagram?” |
| 2 | **Break it** | three SQL statements and the broken row | “Try to break one of my three statements.” |
| 3 | **Build it** | the 200k table, the 3NF schema, matching row counts | “Why does `part` have 10 rows?” |
| 4 | **Race it** | the report table, two plans, two timings | “Did you get the same plan? If not, why?” |
| 5 | **Price it** | rows touched, storage, the index experiment | “Guess my numbers before I show you.” |
| 6 | **Decide** | the memo to the operations lead | “Read it aloud — I will ask one *what if*.” |
| 7 | **Harvest** | your curiosities, swapped | “I collected these — which did you find?” |

> [!NOTE]
> **This format is an experiment — like everything in this class.** You have been through four pod studies by now, so you know what they cost. If the rounds work better (or worse), say so: what was confusing, what was missing, what you would cut. Your feedback decides whether Modules 6a and 6b keep this shape or go back to a study phase. Two minutes in the harvest, or a message in `#sql-questions`, is enough — and it counts as a contribution.

---

## 1 · See it — dependencies and two pictures (~25 minutes)

Take this five-row extract of the kind of table this studio starts from:

| job_id | machine_id | site | technician | part_no | part_price |
|---|---|---|---|---|---|
| 1 | cnc-01 | Gütersloh | tech-0 | P-0001 | 6.00 |
| 1 | cnc-01 | Gütersloh | tech-0 | P-0002 | 7.00 |
| 2 | cnc-02 | Gütersloh | tech-1 | P-0001 | 6.00 |
| 2 | cnc-02 | Gütersloh | tech-1 | P-0003 | 8.50 |
| 3 | cnc-01 | Gütersloh | tech-0 | P-0003 | 8.50 |

**Do.**
1. **Name the FDs** (`X → Y`) you believe hold, and mark each as *guaranteed by the domain* or *merely observed in these rows*.
2. **Draw two ER sketches side by side:** one for the table as it is, one for the schema you think it *should* be.
3. **Ask an LLM for its FD list** and diff it against yours — prompt below. Where you disagree, decide who is right and why.

**Theory you need (read only if the task is unclear).**
- **Functional dependency.** `X → Y` means: for any two rows, if they agree on `X`, they must agree on `Y`. Here: `job_id → technician`, `machine_id → site`, `part_no → part_price`.
- **Candidate key.** The minimal set of attributes that determines all others. Here `(job_id, part_no)` is the candidate key for a job-part row.
- Dependencies are the *reason* normalization is possible — they are the redundancy you can remove.

**If you are stuck, ask:** *“Here is a flat table: `<columns and the five rows>`. List the functional dependencies you can infer, and mark which are domain facts and which are only observed in these rows.”* The model will promote an accident in five rows into a “dependency”. Deciding for yourself is the skill.

**Gate.** Show your two diagrams to the nearest pod and ask: *“Which arrow disappears in the second one?”*

---

## 2 · Break it — cause the anomalies (~20 minutes)

Put the five rows in a table and break it on purpose:

```sql
CREATE TABLE flat5(
  job_id INTEGER, machine_id TEXT, site TEXT,
  technician TEXT, part_no TEXT, part_price REAL
);
INSERT INTO flat5 VALUES
  (1,'cnc-01','Gütersloh','tech-0','P-0001',6.00),
  (1,'cnc-01','Gütersloh','tech-0','P-0002',7.00),
  (2,'cnc-02','Gütersloh','tech-1','P-0001',6.00),
  (2,'cnc-02','Gütersloh','tech-1','P-0003',8.50),
  (3,'cnc-01','Gütersloh','tech-0','P-0003',8.50);
```

**Do.** Write and run one statement for each:
1. **Update anomaly** — move `cnc-01` to Bielefeld. How many rows did you touch? What happens when two people do it in two sessions?
2. **Insert anomaly** — add a new part that no job has used yet, without inventing a job.
3. **Delete anomaly** — delete the last job that used a part. What fact just vanished with it?

**Theory you need.**
- **Update anomaly:** the same fact stored in many places can disagree after one edit.
- **Insert anomaly:** you cannot record a fact because an unrelated fact is missing.
- **Delete anomaly:** deleting one row silently destroys another fact.

**If you are stuck, ask:** *“Give me a concrete update anomaly in this table, with the SQL statements and the inconsistent rows afterwards.”*

**Gate.** Show your three statements to a neighbour and say: *“Try to break one of them.”*

---

## 3 · Build it — the 200k table and 3NF (~50 minutes)

Build a deliberately unnormalized table with real volume, so the benchmark in Round 4 means something.

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

Then decompose it into `machine`, `part`, `job`, and `job_part`:

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

**Theory you need — the normal forms and the anomaly each removes:**

| Form | Rule | Anomaly it removes |
|---|---|---|
| **1NF** | Atomic values only; no repeating groups or comma-lists | The `parts_used = 'P-1001,P-1002'` mess from Module 2 |
| **2NF** | 1NF **and** no partial dependency on part of a composite key | `part_no → part_price` stored on a `(job_id, part_no)` row — price duplicates and drifts |
| **3NF** | 2NF **and** no transitive dependency (non-key → non-key) | `machine_id → site` stored on job rows — change a site once, update a thousand rows |

> [!NOTE]
> `PRAGMA foreign_keys` is **off** by default (Module 4), so the `REFERENCES` clauses are documentation unless you switch it on. Turn it on once and re-run the decomposition — does it still load?
>
> And watch `SELECT DISTINCT`: it silently assumes a job has exactly one technician. If that assumption were false, the `job` primary key would reject the insert. That is the decomposition checking your model.

**If you are stuck, ask:** *“Explain 2NF vs 3NF with a table where 2NF holds but 3NF fails.”*

**Gate.** Show your two row counts to a neighbour and ask: *“Why does `part` have 10 rows, not 40?”*

---

## 4 · Race it — normalized vs denormalized (~70 minutes)

Build the **denormalized reporting table** the operations lead asked for — site, technician, and the part price copied onto every row:

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

**Warm the cache first — this step changes the answer.** Run each query once with `.timer off` and throw the number away: that run loads the pages. Then run the timed block below. Cold-cache measurements are exactly why a pod concludes "denormalization buys nothing": the first scan pays for disk or page-cache misses, and the second engine either inherits a warm cache or pays again. Compare warm with warm, or you are measuring the order of your commands.

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

> Your numbers will be in the **milliseconds**, not the 40 seconds from the story — that story is about the production dataset. What matters is the **ratio**, the **plan**, and the **rows touched**. If the difference is small on 200,000 rows, that is itself a finding.

> [!IMPORTANT]
> **What should happen — and what actually happens.** The denormalized query *should* win: it reads one table instead of joining four. If your numbers say otherwise, you have found something more interesting than a speedup. Three things flip the result here:
>
> - **The index on `report_jobpart`.** `SCAN … USING INDEX` walks the whole index and *then* fetches every row from the table. Dropping it is often faster.
> - **Row width.** `report_jobpart` carries site, technician, price, and date on every row — roughly three times the bytes of `job_part`.
> - **Warm cache.** At tens of milliseconds the order of measurement decides. Warm both sides with one untimed run, then alternate A and B three times and compare medians.
>
> **Discussion point.** Denormalization pays when the **join** is the expensive part. Here the joins hit 50 machines, 10 parts and 20,000 jobs — all in cache — so the join is cheap and the scan dominates. Make the join expensive (more dimensions, bigger dimensions, data that does not fit in memory) and the picture changes. Your memo has to say *which cost* the denormalized table removes.

> [!NOTE]
> **◇ Optional try — make the join hurt.** Add two dimensions, rebuild the report table with their columns, and run both queries again. They still return the same rows — 3,500 rows and a total of 722,610.0, if you want to check:
>
> ```sql
> CREATE TABLE vendor(part_no TEXT PRIMARY KEY, vendor TEXT NOT NULL, country TEXT NOT NULL);
> INSERT INTO vendor
> SELECT part_no, 'vendor-' || (rowid % 12),
>        CASE rowid % 3 WHEN 0 THEN 'DE' WHEN 1 THEN 'CN' ELSE 'US' END
> FROM part;
>
> CREATE TABLE site_dim(site TEXT PRIMARY KEY, region TEXT NOT NULL, manager TEXT NOT NULL);
> INSERT INTO site_dim
> SELECT site, 'region-' || (row_number() OVER () % 5), 'mgr-' || row_number() OVER ()
> FROM (SELECT DISTINCT site FROM machine);
>
> DROP TABLE IF EXISTS report_jobpart;
> CREATE TABLE report_jobpart AS
> SELECT j.job_id, m.machine_id, m.site, sd.region, j.technician, jp.part_no,
>        p.part_price, v.vendor, j.done_on
> FROM job j
> JOIN machine m   ON m.machine_id = j.machine_id
> JOIN site_dim sd ON sd.site = m.site
> JOIN job_part jp ON jp.job_id = j.job_id
> JOIN part p      ON p.part_no = jp.part_no
> JOIN vendor v    ON v.part_no = p.part_no;
> ```
>
> Then compare a **six-join** A against B on the wider table:
>
> ```sql
> -- A: two extra joins
> SELECT m.machine_id, m.site, sd.region, j.technician, v.vendor, SUM(p.part_price) AS cost
> FROM job j
> JOIN machine m   ON m.machine_id = j.machine_id
> JOIN site_dim sd ON sd.site = m.site
> JOIN job_part jp ON jp.job_id = j.job_id
> JOIN part p      ON p.part_no = jp.part_no
> JOIN vendor v    ON v.part_no = p.part_no
> WHERE j.done_on >= date('2026-03-01')
> GROUP BY m.machine_id, m.site, sd.region, j.technician, v.vendor;
>
> -- B: the same facts, one wide table
> SELECT machine_id, site, region, technician, vendor, SUM(part_price) AS cost
> FROM report_jobpart
> WHERE done_on >= date('2026-03-01')
> GROUP BY machine_id, site, region, technician, vendor;
> ```
>
> On this dataset A grows from ~30 ms to ~45 ms and B lands at ~29 ms — B now wins clearly. **Honest caveat:** the rebuild drops `ix_report_machine`, and 200,000 rows still fit in cache, so this is a direction, not a production number. The point is that the win comes from removing **row-level work**, not from “one table” as a slogan.
>
> Done experimenting? Put the index back before Round 5, which drops it on purpose:
> `CREATE INDEX ix_report_machine ON report_jobpart(machine_id);`

**Theory you need — the spectrum, and where you have already met both ends of it.**

Normalization minimizes redundancy and anomalies; denormalization trades redundancy back for read speed. There is no “correct” level — there is a **workload**, and a level that fits it.

| Design | In this course | What is duplicated | What it buys |
|---|---|---|---|
| **Normalized** | Module 2's repaired schema; Module 3's `customer` / `orders` / `order_line`; this module's 3NF tables | nothing | change a fact once; integrity |
| **Denormalized — accidental** | Module 2's `parts_used = 'P-1001,P-1002'` | a list of parts per job | “one column instead of a junction table” |
| **Denormalized — mild** | Module 1's `readings` — the machine name on every reading | machine name per row | no join to a machine table |
| **Denormalized — deliberate** | This module's `report_jobpart`; your final project | site, technician, price on every fact row | one table for the dashboard |
| **Semi-structured** | Module 6b's `device.meta` JSON | vendor fields per device | schema flexibility |
| **Star schema** | analytics in general; Module 6a's Parquet export | dimensions copied into the fact table | fast aggregates |

**The star schema is the standard analytics denormalization.** A fact table stores keys and measures; dimensions store the descriptive attributes once:

| Table | Columns |
|---|---|
| `fact_sales` | `date_key, product_key, store_key, qty, revenue` |
| `dim_product` | `product_key, name, category, brand` |
| `dim_date` | `date_key, day, week, month, quarter, year` |

A *fully* denormalized variant would copy `name, category, brand` onto every fact row — fastest to read, painful the day a product is renamed. Concretely, one row of `report_jobpart` is `(1, 'cnc-02', 'Gütersloh', 'tech-1', 'P-0002', 6.0, '2026-01-02')` — the site and technician that 3NF stores **once** are repeated on all 4,000 rows for that machine.

**If you are stuck, ask:** *“When is denormalization the right call? Give a workload where 3NF is measurably slower, and say what the cost is.”*

**Gate.** Compare plans with a neighbour: *“Did you get the same plan? If not, why?”* (Check `sqlite3 --version` first.)

---

## 5 · Price it — writes and storage (homework, ~30 minutes; start in class if you are ahead)

Do not time a single-row insert: both designs do that in well under a millisecond. The cost of denormalization is *changing a duplicated fact*.

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

Record the **number of rows touched**, not only the milliseconds: **1 versus 4,000** is the number that scales — and it is the update anomaly you caused by hand in Round 2, now with a price tag.

If `dbstat` is missing in your SQLite build, say so and keep the row counts; the storage number is a bonus, not the lesson.

> [!NOTE]
> **Try dropping the index.** `DROP INDEX ix_report_machine;` and re-run the dashboard query. On this dataset it usually gets *faster*: the planner was walking the whole index and then fetching each row from the table, which costs more than one sequential scan. That is a second negative result, and a good one to keep.

Fill in every number you measured:

| Design | Dashboard query (ms) | Rows changed by one site update | Storage (KB) | Redundancy? |
|---|---|---|---|---|
| Normalized (3NF) | | | | none |
| Denormalized (report) | | | | site/technician/price repeated |

**Gate.** Tell a neighbour your two storage numbers and your two row counts, and ask: *“Guess my query timings before I show you.”*

---

## 6 · Decide and defend (homework, ~20 minutes)

Write a short recommendation (5–8 sentences) to the operations lead: which design should serve the dashboard, what the normalization of the transactional tables must stay at, and — crucially — **how you would keep the denormalized table from going stale** (a trigger from Module 4, a scheduled rebuild, or a materialized view). Cite your own numbers.

**Gate.** Read the memo aloud to a neighbour. They ask one *“what if…”* question, and you answer it without notes.

*Portfolio evidence:* the recommendation memo, referencing your benchmark table.

---

## 7 · Harvest and stretch (homework, ~15 minutes + optional)

**Collect curiosities, swap lists — no explaining.** Scan the material you just worked through and mark the bits that looked strange, hard, or worth arguing about: the `CROSS JOIN` that turns 20,000 × 10 into 200,000 rows, `printf('%.2f', …)` storing money as *text*, the `dbstat` numbers, the plan for the report table, the `DISTINCT` assumption. Bring them to the nearest pod: *“I collected these — which did you find?”* Anything nobody can place goes to `#sql-questions` with the module number.

**◇ Stretcher — push the frontier.** Load the same data into DuckDB and run the dashboard query there. Capture wall-clock time and note whether the columnar engine removes the need for the denormalized table entirely. This is the bridge into Module 6a.

---

## ✅ Suggested portfolio evidence (proofs of the learning goals)

- [ ] The setup script that builds `flat_jobpart` with ~200k rows (so the benchmark is reproducible).
- [ ] `normalization-notes.md` — your FD list, the two ER sketches, and one example of each anomaly.
- [ ] The 3NF DDL, the inserts, and the integrity row-count check.
- [ ] The `report_jobpart` DDL and the benchmark table with all measured numbers.
- [ ] `EXPLAIN QUERY PLAN` output for both designs.
- [ ] The recommendation memo citing your numbers, including the staleness strategy.
- [ ] `Reflections/ref05.md` — the logbook entry for this block, using the [reflection template](https://github.com/iotempire/iot-portfolio-template/blob/main/Reflections/TEMPLATE.md).
- [ ] Your curiosities from the harvest, with sources.
- [ ] (Stretcher) the DuckDB comparison.

## 📚 If you want to go deeper

- Functional dependencies — [Wikipedia](https://en.wikipedia.org/wiki/Functional_dependency)
- The normal forms, formally — [3NF](https://en.wikipedia.org/wiki/Third_normal_form) · [BCNF](https://en.wikipedia.org/wiki/Boyce%E2%80%93Codd_normal_form)
- Denormalization as a decision, not a sin — [Wikipedia](https://en.wikipedia.org/wiki/Denormalization)
- SQLite — `PRAGMA optimize`, `ANALYZE`, and planner statistics — [sqlite.org/pragma.html#pragma_optimize](https://www.sqlite.org/pragma.html#pragma_optimize)
- SQLite — the `dbstat` virtual table for measuring storage per object — [sqlite.org/dbstat.html](https://www.sqlite.org/dbstat.html)
- Markus Winand — *Use The Index, Luke* (indexing and pagination) — [use-the-index-luke.com](https://use-the-index-luke.com/)
- DuckDB — why columnar and vectorized engines win on aggregations — [duckdb.org/why_duckdb](https://duckdb.org/why_duckdb.html)
- **Prefer watching?** [Lecture-style videos for this module](./Z-resources-bank.md#watching-instead-of-reading)

**⬆︎ ===== DRAFT BOUNDARY — everything above is settled for this run ===== ⬆︎**

---

[← Previous: Module 4](./04-integrity-constraints-and-triggers.md) | [Back to front page](../README.md) | [Next: Module 6a →](./06a-duckdb-analytical-engine.md)
