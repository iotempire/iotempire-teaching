# Module 6a — The Analytical Engine (DuckDB)

[← Previous: Module 5](./05-normalization-vs-denormalization.md) | [Quick module index](./00-index.md) | [Next: Module 6b →](./06b-polyglot-persistence.md)

> **One line:** move the monthly report out of the operational database — and prove the move with numbers.

**Course placement:** Session 6. This is the analytical half of the old *Databases within Applications* chapter, split off because the engine deserves its own day. Module 6b continues the same story with flexible schemas, point lookups, and the decision.

## 🎯 Learning Goals

This module gives you the opportunity to explore analytical (columnar) engines and achieve competency in moving a workload to the right engine.

By the end of this module, you can:
1. Move a table out of SQLite into **Parquet** reproducibly, from a script.
2. Run the **same aggregate** in SQLite and DuckDB and report the difference honestly (interleaved runs, median).
3. Read **`EXPLAIN ANALYZE`** and name the operator and row count that dominate.
4. State, with a number, **where DuckDB is the wrong engine**.
5. Recommend **what moves to the analytical copy** and how that copy stays fresh.

**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 📖 Story — The Report That Outgrew SQLite

The dashboard is fast now. Yasmin Kaya's denormalized report table did what it promised in Module 5, and the operations team stopped complaining.

Then **controlling** asked for the month-end report.

**Lea Winter** runs it: revenue per machine and technician, weekly and monthly, **over two years of history**. It still runs against the operational database — and it takes **40 minutes**, because it scans the whole `job_part` history while the line keeps writing new jobs. For forty minutes, the single writer waits. The night shift has learned to start the report at 02:00.

Lea's question is not "which database is faster?" It is: *"Can the report live somewhere else, without the numbers changing — and how do I know the copy is still right?"*

In this studio you answer her with a file and a measurement.

## 🧭 How this studio works

**Starts with the Module 5 gate (15 minutes).** Before anything new: show a neighbouring pod your Module 5 homework — the storage numbers, the rows touched by one site update, and your memo. Two minutes each. If you are missing one, say "not yet" and start Round 1; it does not block you.

**Then six rounds.** No lecture. Every round gives you one thing to do, a short **theory box** you read only when the task makes you want it, and a **gate** at the end: show the artefact to the nearest pod and ask them the gate question. Tick the round on the gate board when you pass it.

**Rough timing (180 minutes):** gate 15 → story 10 → **1 Build** 20 → **2 Convert** 20 → **3 Race** 25 → break 15 → **4 Plan** 20 → **5 Boundary** 30 → **6 Decide** 15 → buffer 10.

**Keep your notes in `Module06a/duckdb-notes.md`.** Everything else goes next to your scripts; do not commit the database, the CSV, or the Parquet file.

| # | Round | You produce | Gate question for a neighbour |
|---|---|---|---|
| 1 | **Build** | `history.db` with 2,000,000 rows | "Why does the row count match 10 × the old table?" |
| 2 | **Convert** | `report_history.parquet` + a matching row count | "Is the Parquet the same data, or just the same size?" |
| 3 | **Race** | a timing table for two queries | "Which run did you trust, and why?" |
| 4 | **Plan** | an `EXPLAIN ANALYZE` line that explains the gap | "Which operator dominates, and how many rows did it see?" |
| 5 | **Boundary** | insert/lookup numbers for both engines | "Where is DuckDB the wrong tool — in one sentence?" |
| 6 | **Decide** | a memo to Lea and Yasmin | "What happens the day the Parquet is stale?" |

---

## 1 · Build the history (~20 minutes)

Module 5 left you with `Module05/normalize.db` and the `report_jobpart` table — 200,000 rows covering 90 days. Lea needs **two years**. Rather than invent a new dataset, stretch the one you have: ten copies of the same 90 days, shifted by a quarter each.

```python
# Module06a/prepare.py — run with:  uv run python Module06a/prepare.py
"""Stretch Module 5's report table to ten quarters (2,000,000 rows)."""
import csv
import sqlite3
from pathlib import Path

here = Path(__file__).parent
src = here.parent / "Module05" / "normalize.db"
db = here / "history.db"
csv_path = here / "report_jobpart.csv"
QUARTERS = 10

if not src.exists():
    raise SystemExit("Module05/normalize.db is missing — rebuild it with the Module 5 Setup block first.")

db.unlink(missing_ok=True)
conn = sqlite3.connect(db)
conn.execute("ATTACH DATABASE ? AS m5", (str(src),))
conn.execute("""CREATE TABLE report_history(
    job_id INTEGER, machine_id TEXT, site TEXT, technician TEXT,
    part_no TEXT, part_price REAL, done_on TEXT)""")
conn.execute(f"""
    INSERT INTO report_history
    SELECT r.job_id + k * 1000000, r.machine_id, r.site, r.technician,
           r.part_no, r.part_price,
           date(r.done_on, '+' || (k * 91) || ' days')
    FROM m5.report_jobpart r, (WITH RECURSIVE n(k) AS (
         SELECT 0 UNION ALL SELECT k + 1 FROM n WHERE k < {QUARTERS - 1})
         SELECT k FROM n)""")
conn.commit()

with csv_path.open("w", newline="") as f:
    writer = csv.writer(f)
    writer.writerow(["job_id", "machine_id", "site", "technician",
                     "part_no", "part_price", "done_on"])
    writer.writerows(conn.execute("SELECT * FROM m5.report_jobpart"))

print("history rows:", conn.execute("SELECT COUNT(*) FROM report_history").fetchone()[0])
print("csv bytes   :", csv_path.stat().st_size)
```

Run it. Expect **2,000,000** rows and a CSV of roughly 11 MB.

> [!NOTE]
> **Why duplicate instead of generating new data?** Because the comparison has to be honest: both engines must answer the *same* question over the *same* rows. Keeping the 90-day pattern and shifting the dates gives you volume without inventing a different distribution. It also makes the check easy: every aggregate over the whole history should be exactly ten times the 90-day value.

**Gate.** Show a neighbour your row count and explain the `k * 91` — what does the 91 do to the dates?

---

## 2 · Convert to Parquet (~20 minutes)

```python
# Module06a/to_parquet.py — run with:  uv run python Module06a/to_parquet.py
"""200k CSV -> 2M-row Parquet. DuckDB does the expansion, no database server involved."""
import duckdb
from pathlib import Path

here = Path(__file__).parent
csv_path = here / "report_jobpart.csv"
parquet = here / "report_history.parquet"

con = duckdb.connect()          # in-process, embedded — nothing to start
con.execute(f"""
    COPY (
      SELECT r.job_id + k * 1000000 AS job_id, r.machine_id, r.site,
             r.technician, r.part_no, r.part_price,
             CAST(r.done_on AS DATE) + CAST(k * 91 AS INTEGER) AS done_on
      FROM read_csv_auto('{csv_path}', header = true) r,
           range(0, 10) t(k)
    ) TO '{parquet}' (FORMAT parquet)
""")

print("parquet rows:", con.execute(
    f"SELECT COUNT(*) FROM read_parquet('{parquet}')").fetchone()[0])
print("parquet MB  :", round(parquet.stat().st_size / 1e6, 2))
```

Check both sides agree before you time anything:

```python
# append to to_parquet.py, or run in a REPL
print(con.execute(f"""SELECT ROUND(SUM(part_price), 2) FROM read_parquet('{parquet}')""").fetchone())
```

...and the same sum in SQLite (`SELECT ROUND(SUM(part_price), 2) FROM report_history;`). **The two numbers must be identical.** If they are not, you are not comparing engines — you are comparing two datasets.

> **Theory you need — why a file can be faster than a table.**
> Parquet is **columnar**: values of one column are stored together, compressed per column, with statistics per block. A query that needs four of seven columns reads four. SQLite is **row-oriented**: to get `part_price` it reads whole rows. On an aggregation over millions of rows, the column store moves less data — which is most of the gap you are about to measure. The file is also immutable in practice: you write a new one, you do not update rows in place.

**Gate.** "Same data or just same size?" Show the two checksums, not the row counts.

---

## 3 · The race (~25 minutes)

```python
# Module06a/race.py — run with:  uv run python Module06a/race.py
"""Same two queries, two engines, interleaved, median of three."""
import sqlite3
import statistics
import time
from pathlib import Path

import duckdb

here = Path(__file__).parent
sq = sqlite3.connect(here / "history.db")
duck = duckdb.connect()
pq = str(here / "report_history.parquet")

DASHBOARD = """SELECT machine_id, site, technician, SUM(part_price) AS cost
FROM {src} WHERE done_on >= '2026-01-01'
GROUP BY machine_id, site, technician"""

MONTHLY = """SELECT strftime(done_on, '%Y-%m') AS month, machine_id,
       COUNT(*) AS jobs, SUM(part_price) AS cost
FROM {src} GROUP BY month, machine_id ORDER BY month, machine_id"""


def median_ms(fn, runs=3):
    times = []
    for _ in range(runs):
        t0 = time.perf_counter()
        fn()
        times.append((time.perf_counter() - t0) * 1000)
    return statistics.median(times)


for name, sql in (("dashboard", DASHBOARD), ("monthly", MONTHLY)):
    s = median_ms(lambda: sq.execute(sql.format(src="report_history")).fetchall())
    d = median_ms(lambda: duck.execute(sql.format(src=f"read_parquet('{pq}')")).fetchall())
    print(f"{name:10s} sqlite {s:8.1f} ms   duckdb {d:6.1f} ms   {s / d:6.1f}x")
```

Run it **interleaved** (the script does), three times, and record the medians.

On this machine, with this dataset: the dashboard takes about **600 ms in SQLite** and **7 ms in DuckDB**; the monthly report about **540 ms** and **7 ms**. Your numbers will differ — a slow laptop makes SQLite worse, a warm cache makes both faster. What travels is the **ratio** and the **plan**.

> [!IMPORTANT]
> **Do not trust a single run.** First runs include file-cache effects; a single timing is a coin flip. Three interleaved runs and a median is the minimum. If your two engines are within 20 %, say so — that is a finding, not a failure.

**Gate.** "Which run did you trust, and why?" If the answer is "the fastest one", do it again.

---

## 4 · The plan (~20 minutes)

```python
# Module06a/plan.py — run with:  uv run python Module06a/plan.py
"""The DuckDB physical plan: rows and time per operator (this runs the query)."""
import duckdb
from pathlib import Path

here = Path(__file__).parent
pq = here / "report_history.parquet"

con = duckdb.connect()
plan = con.execute(f"""
    EXPLAIN ANALYZE
    SELECT machine_id, site, technician, SUM(part_price) AS cost
    FROM read_parquet('{pq}')
    GROUP BY machine_id, site, technician
""").fetchall()[0][1]
print(plan)
```

And for comparison, the access plan SQLite gives you (no timings):

```sh
sqlite3 Module06a/history.db "EXPLAIN QUERY PLAN
  SELECT machine_id, site, technician, SUM(part_price) AS cost
  FROM report_history WHERE done_on >= '2026-01-01'
  GROUP BY machine_id, site, technician"
```

Read the DuckDB output bottom-up. You will see something like:

```text
TABLE_SCAN      Function: READ_PARQUET
                Projections: machine_id, site, technician, part_price
                2,000,000 rows
PROJECTION      2,000,000 rows
HASH_GROUP_BY   Groups: #0 #1 #2   Aggregates: sum(#3)   350 rows
```

Three things to notice, and they are the whole lesson:

1. **`Projections:` lists four columns, not seven.** The engine never touched `job_id`, `part_no`, or the rest.
2. **`2,000,000 rows` at the scan and again at the projection** — the work is in moving rows, not in grouping (350 output rows).
3. **SQLite's plan says `SCAN report_history`** — one sequential pass over full rows, plus `USE TEMP B-TREE FOR GROUP BY`.

> **Theory you need — two kinds of plan.** `EXPLAIN QUERY PLAN` (SQLite) tells you **how** a table is accessed: `SCAN`, `SEARCH … USING INDEX`, temp B-tree. `EXPLAIN ANALYZE` (DuckDB) actually **runs the query** and reports rows and time per operator. One is a prediction, the other is a measurement. When you need to explain a 90× gap, the measurement is the better witness.

**Gate.** Point at the line that proves the column store read less, and read the row count out loud.

---

## 5 · The boundary (~30 minutes)

DuckDB is not "better". Measure the other side.

```python
# Module06a/boundary.py — run with:  uv run python Module06a/boundary.py
"""1,000 single-row writes and lookups: the workload DuckDB is not built for."""
import sqlite3
import time

import duckdb

N = 1_000


def run_sqlite():
    con = sqlite3.connect(":memory:")
    con.execute("CREATE TABLE s(id INTEGER PRIMARY KEY, k TEXT, v REAL)")
    t0 = time.perf_counter()
    for i in range(N):
        con.execute("INSERT INTO s VALUES (?, ?, ?)", (i, f"k{i}", i * 1.5))
    con.commit()
    insert = (time.perf_counter() - t0) * 1000
    t0 = time.perf_counter()
    for i in range(N):
        con.execute("SELECT v FROM s WHERE id = ?", (i,)).fetchone()
    lookup = (time.perf_counter() - t0) * 1000
    return insert, lookup


def run_duckdb():
    con = duckdb.connect()
    con.execute("CREATE TABLE s(id INTEGER PRIMARY KEY, k TEXT, v DOUBLE)")
    t0 = time.perf_counter()
    for i in range(N):
        con.execute("INSERT INTO s VALUES (?, ?, ?)", (i, f"k{i}", i * 1.5))
    insert = (time.perf_counter() - t0) * 1000
    t0 = time.perf_counter()
    for i in range(N):
        con.execute("SELECT v FROM s WHERE id = ?", (i,)).fetchone()
    lookup = (time.perf_counter() - t0) * 1000
    return insert, lookup


si, sl = run_sqlite()
di, dl = run_duckdb()
print(f"inserts sqlite {si:8.1f} ms | duckdb {di:8.1f} ms")
print(f"lookups sqlite {sl:8.1f} ms | duckdb {dl:8.1f} ms")
```

Expect a dramatic reversal: SQLite does both in **under a millisecond**, DuckDB needs **a fraction of a second** for the same 1,000 statements. That is not a bug — DuckDB pays a per-statement cost and is built for scanning millions of rows, not for a request-per-row application.

Try the fix a thoughtful student will propose: `con.executemany("INSERT INTO s VALUES (?, ?, ?)", rows)`. It gets faster (roughly 3×) and **still does not close the gap**. Batching helps; the engine's design does not change.

> **Theory you need — OLTP vs OLAP in one sentence.** OLTP asks "one row, now, repeatedly" and is dominated by per-statement overhead, locks, and indexes. OLAP asks "all rows, rarely, in bulk" and is dominated by how much data must be moved. SQLite optimizes the first; DuckDB optimizes the second. Most systems need one, not both.

**Gate.** Finish this sentence without hedging: *"For Kortmann, DuckDB is the wrong engine when …"*

---

## 6 · Decide (~15 minutes)

Write a short memo to **Lea Winter** and **Yasmin Kaya** (6–8 sentences):

- What moves to Parquet, and what stays in SQLite.
- Your two numbers (before/after) and the size of the file.
- **How the Parquet is refreshed** — a nightly `COPY`, a script after the shift, a manual export — and what breaks if it goes stale.
- One workload you would *not* move, and why.

*Portfolio evidence:* the memo, referencing your own timing table.

**Gate.** Read the memo aloud to a neighbour. They ask one *"what if the copy is a day old?"* question, and you answer without notes.

---

## ✅ Suggested portfolio evidence (proofs of the learning goals)

- [ ] `prepare.py`, `to_parquet.py`, and the matching row counts/checksums for both sides.
- [ ] The Parquet file size next to the SQLite file size.
- [ ] `race.py` and the timing table (median of three, interleaved).
- [ ] One `EXPLAIN ANALYZE` output with the dominating operator marked.
- [ ] `boundary.py` and the insert/lookup numbers, including the `executemany` variant.
- [ ] The memo to Lea and Yasmin.
- [ ] `Reflections/ref06a.md` — the logbook entry for this block.

## 📚 If you want to go deeper

- DuckDB — *Why DuckDB* (columnar, vectorized, in-process) — [duckdb.org/why_duckdb.html](https://duckdb.org/why_duckdb.html)
- DuckDB — reading Parquet and CSV, `read_parquet`/`read_csv_auto` — [duckdb.org/docs/data/overview](https://duckdb.org/docs/data/overview)
- Apache Parquet — format overview — [parquet.apache.org/docs/overview](https://parquet.apache.org/docs/overview/)
- `EXPLAIN ANALYZE` in DuckDB — [duckdb.org/docs/guides/meta/explain_analyze](https://duckdb.org/docs/guides/meta/explain_analyze)
- If you prefer watching: the [video list](./Z-resources-bank.md#watching-instead-of-reading).

---

[← Previous: Module 5](./05-normalization-vs-denormalization.md) | [Back to front page](../README.md) | [Next: Module 6b →](./06b-polyglot-persistence.md)
