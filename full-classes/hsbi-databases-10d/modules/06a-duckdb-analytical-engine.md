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

**It starts with a 15-minute recap, not a test.** Your instructor walks through what Module 5 produced — the flat table, the 3NF decomposition, the denormalized report table — and the three numbers you should have measured: storage (**≈4.1 MB normalized vs ≈11.1 MB denormalized**), rows touched by one site update (**1 vs 4,000**), and the surprise that *dropping* the index on the report table made the query faster. Then the bridge: that report table is 200,000 rows and 90 days old, and Lea wants two years.

If you do not have your own numbers, take the ones on the board and say so in your notes. The recap is input, not evidence — the evidence is what you measure today.

<!-- PREP EMAIL (before Session 6): finish Module 5 Rounds 5–7 — the storage numbers, the rows touched by one site update, and the memo — and keep Module05/normalize.db. If the database is gone, rebuild it with the Module 5 Setup block (~1 minute). Bring the memo; we use it in the recap. -->

**Then six rounds.** No lecture. Every round gives you one thing to do, a short **theory box** you read only when the task makes you want it, and a **discussion** with the nearest pod at the end: two minutes to say out loud what happened, why it happened, and what you would predict next time. A discussion is **not a checkpoint and not a test** — it is where the round's learning goal turns into words. Tick the round on the board when you have had it.

**Rough timing (180 minutes):** recap 15 → story 10 → **1 Build** 25 → **2 Convert** 20 → **3 Race** 30 → break 15 → **4 Plan** 20 → **5 Boundary** 30 → **6 Decide** 15 = 180. Faster pods take the **stretchers** at the end of this module; slower pods finish the core rounds and do the **homework** in §7.

**Keep your notes in `Module06a/duckdb-notes.md`.** Everything else goes next to your scripts; do not commit the database, the CSV, or the Parquet file.

| # | Round | You produce | Talk it through with a neighbour |
|---|---|---|---|
| 1 | **Build** | `history.db` with 2,000,000 rows | "Predict the count before you run. Wrong? Where?" |
| 2 | **Convert** | `report_history.parquet` + a matching row count | "Same data or just same size — how would you know?" |
| 3 | **Race** | a timing table for two queries | "What would make SQLite win this race?" |
| 4 | **Plan** | an `EXPLAIN ANALYZE` line that explains the gap | "Which operator dominates, and why 2M rows?" |
| 5 | **Boundary** | insert/lookup numbers for both engines | "Where is DuckDB the wrong tool — and what would fix it?" |
| 6 | **Decide** | a memo to Lea and Yasmin | "What if the copy is a day old?" |

---

## 1 · Build the history (~25 minutes)

Module 5 left you with `Module05/normalize.db` and the `report_jobpart` table — 200,000 rows covering 90 days. **We reuse that database on purpose.**

> [!NOTE]
> **Why not start from a fresh dataset?** Three reasons, and they are the method:
> - **The comparison must be honest.** Both engines have to answer the *same* question over the *same* rows with the *same* distribution. A new generator would change the data and the engine at the same time, and the measurement would prove nothing.
> - **The artefact is the story.** `report_jobpart` is exactly the table Yasmin promised Lea in Module 5. The report outgrew *that* table, not a hypothetical one.
> - **You already paid for it.** The 3NF decomposition and the denormalization were last week's work; rebuilding them here would eat the session and teach nothing new.
>
> The only thing we add is **time**.

<!-- PREP EMAIL (before Session 6): keep Module05/normalize.db — you need it at the start of the DuckDB session. If it is gone, rebuild it with the Module 5 Setup block (~1 minute) and bring it. -->

**91 days is one quarter** (13 weeks — 4 × 91 = 364 days, one short of a year). Ten copies therefore give about **two and a half years**, a little more than Lea asked for, so the numbers have room.

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

> **Discuss (nearest pod, 2 minutes).**
> - **Why** is the row count exactly 10 × 200,000? If you cannot explain that before running, the multiplier is not understood yet — that is **goal 1**.
> - **What if** you shifted by 90 days instead of 91? Predict the effect on the dates, then change it — it is cheap to try.
> - **Find one more thing:** `date()` accepts `'+91 days'`; what would `'+1 month'` do differently? (Months are not all the same length — this matters the day you extend the dataset again.)

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

> **Discuss (nearest pod, 2 minutes).**
> - **How would you prove** the Parquet is the same data if `history.db` disappeared? You have the file, a checksum, and a row count — which one would convince you, and which would not?
> - **Why** is the Parquet roughly 50× smaller than the database? (Hint: columns repeat, and compression loves repetition.) If that sounds interesting, run `SELECT * FROM parquet_metadata('report_history.parquet');` — it is also the door to stretcher S2 at the end of this module.
> - **This is goal 1** — reproducibility. Could a podmate rebuild your file from your script alone, on a different machine?

---

## 3 · The race (~30 minutes)

```python
# Module06a/race.py — run with:  uv run python Module06a/race.py
"""Same two queries, two engines, interleaved, median of RUNS runs."""
import sqlite3
import statistics
import time
from pathlib import Path

import duckdb

RUNS = 5        # odd on purpose: the median is then a real run. Try 3, 7, 9.

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


def timed_ms(fn):
    t0 = time.perf_counter()
    fn()
    return (time.perf_counter() - t0) * 1000


def spread(times):
    return f"{min(times):.1f}-{max(times):.1f}"


for name, sql in (("dashboard", DASHBOARD), ("monthly", MONTHLY)):
    run_sqlite = lambda: sq.execute(sql.format(src="report_history")).fetchall()
    run_duckdb = lambda: duck.execute(sql.format(src=f"read_parquet('{pq}')")).fetchall()

    run_sqlite()          # warm-up: load the pages, discard the timing
    run_duckdb()

    sqlite_times, duckdb_times = [], []
    for _ in range(RUNS):  # interleaved: alternate the engines
        sqlite_times.append(timed_ms(run_sqlite))
        duckdb_times.append(timed_ms(run_duckdb))

    s = statistics.median(sqlite_times)
    d = statistics.median(duckdb_times)
    print(f"{name:10s} sqlite {s:7.1f} ms [{spread(sqlite_times)}]"
          f"   duckdb {d:6.1f} ms [{spread(duckdb_times)}]   {s / d:6.1f}x")
```

Run it. The script **warms both engines with one untimed run**, then alternates SQLite and DuckDB **`RUNS` times** and reports the median plus the min–max spread. `RUNS = 5` is the default; 3 is the minimum, and 7–11 (odd) is what you would use if you had to publish the number.

> **Why the median, and why an odd count?** The distribution has a slow tail — one cache miss or CPU hiccup drags the mean. The median ignores that tail: with three runs it is simply the middle one, so nothing is averaged and one outlier on each side is discarded. With an **even** count Python would average the two middle values; that is why `RUNS` is odd. The `[min–max]` spread is printed next to it so you can see how noisy your machine is. If the spread is wide, the median is the number to trust — and the first run of either engine is a cache warm-up, not a result.

On this machine, with this dataset: the dashboard takes about **600 ms in SQLite** and **6 ms in DuckDB** (≈100×); the monthly report about **540 ms** and **9–18 ms** (≈30–60×). **The monthly ratio is lower for an interesting reason:** `strftime(done_on, '%Y-%m')` runs once per row, and that per-row work now dominates DuckDB's 6 ms scan. SQLite's 540 ms scan hides it. Your numbers will differ — a slow laptop makes SQLite worse, a warm cache makes both faster. What travels is the **ratio** and the **plan**.

> [!IMPORTANT]
> **Do not trust a single run.** First runs include file-cache effects; a single timing is a coin flip. Five interleaved runs and a median is the default; three is the minimum. If your two engines are within 20 %, say so — that is a finding, not a failure.

> **Discuss (nearest pod, 2 minutes).**
> - **Was the ratio what you predicted?** If not, name the assumption that was wrong — data size, cache, or number of columns. This is **goal 2**.
> - **Why is the monthly ratio lower?** `strftime` is per-row work; the scan is no longer the bottleneck. Try `date_trunc('month', done_on)` in DuckDB — the ratio improves, the result is identical. Same query shape, different function, different number.
> - **What would make SQLite win this race?** Try it: filter to one day (`WHERE done_on = '2026-02-14'`) or to one machine. A point query on an index can beat a column scan; a full aggregate over 2M rows cannot.
> - **Find one more thing:** why does the first run of each engine differ from the next two? Run the script twice and compare — the answer is the file cache, and it is why we take a median.

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

> **Discuss (nearest pod, 2 minutes).**
> - **Point at the line** that proves the column store read less, and read the row count out loud. If you cannot find it, you have the output but not yet **goal 3**.
> - **Why four columns and not seven?** Predict what the plan says if the query were `SELECT *`, then run it. (The row count stays; the projections change.)
> - **Find one more thing:** SQLite's plan is a *prediction*; DuckDB's `EXPLAIN ANALYZE` is a *measurement* that runs the query. When would you use each — and which one would you show a manager?

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

> **Discuss (nearest pod, 2 minutes).**
> - **Finish the sentence** without hedging: *"For Kortmann, DuckDB is the wrong engine when …"* This is **goal 4** — a number and a boundary, not an opinion.
> - **Why** does a per-statement cost dominate? What actually happens on each `INSERT` that does not happen in a scan?
> - **What if** the application batched its writes? `executemany` improves the number but does not close the gap — explain why not, and what would have to change in the *application*, not the engine.
> - **Find one more thing:** which workload in your own final project sits closest to this boundary? Name it now — it is a design decision you will have to defend in the project discussion.

---

## 6 · Decide (~15 minutes)

Write a short memo to **Lea Winter** and **Yasmin Kaya** (6–8 sentences):

- What moves to Parquet, and what stays in SQLite.
- Your two numbers (before/after) and the size of the file.
- **How the Parquet is refreshed** — a nightly `COPY`, a script after the shift, a manual export — and what breaks if it goes stale.
- One workload you would *not* move, and why.

*Portfolio evidence:* the memo, referencing your own timing table.

> **Discuss (nearest pod, 3 minutes).**
> - **Read the memo aloud.** Your neighbour asks one question: *"What if the copy is a day old?"* Answer without notes. This is **goal 5**.
> - **Who owns the refresh** — a cron job, the shift lead, a script after the shift? What happens when it fails silently, and how would you *detect* that it did?
> - **Which is worse for Kortmann:** a stale report or a slow one? Defend your answer with your own numbers.

---

## ◇ Stretchers (if you are ahead)

Three optional extensions, 15–25 minutes each. Pick the one that answers a question you actually have.

### ◇ S1 — Let DuckDB read the JSON (15 min)

In Module 6b the vendor metadata will live *inside* SQLite. DuckDB can read it as a file instead:

```python
# Module06a/json_read.py — run with:  uv run python Module06a/json_read.py
import json
from pathlib import Path

import duckdb

here = Path(__file__).parent
devices = [
    {"machine_id": "cnc-01", "vendor": "Siemens", "firmware": "4.2"},
    {"machine_id": "cnc-02", "vendor": "Fanuc", "firmware": "3.9"},
    {"machine_id": "cnc-03", "vendor": "Siemens", "firmware": "4.0"},
]
(here / "devices.json").write_text(json.dumps(devices))

con = duckdb.connect()
print(con.execute(f"""
    SELECT d.vendor, r.machine_id, SUM(r.part_price) AS cost
    FROM read_json_auto('{here / 'devices.json'}') d
    JOIN read_parquet('{here / 'report_history.parquet'}') r USING (machine_id)
    GROUP BY d.vendor, r.machine_id ORDER BY cost DESC
""").fetchall())
```

**Ask yourself:** which would you rather update — a JSON file, or a JSON column inside the database that already guarantees `json_valid`? You do not have to decide yet; 6b is where it gets settled.

### ◇ S2 — Why analytics might not need an index (20 min)

Look at the Parquet's **row-group statistics** — the columnar cousin of an index:

```sql
SELECT row_group_id, stats_min, stats_max
FROM parquet_metadata('Module06a/report_history.parquet')
WHERE path_in_schema = 'done_on'
ORDER BY row_group_id LIMIT 5;
```

Every row group spans the whole date range, because the file was written in job order, not in date order. So the reader cannot skip anything. Now write a sorted copy and look again:

```sql
COPY (SELECT * FROM read_parquet('Module06a/report_history.parquet') ORDER BY done_on)
TO 'Module06a/sorted.parquet' (FORMAT parquet);

SELECT row_group_id, stats_min, stats_max
FROM parquet_metadata('Module06a/sorted.parquet')
WHERE path_in_schema = 'done_on'
ORDER BY row_group_id LIMIT 5;
```

Now each group covers about two months. **The honest result:** at 2M rows the timing barely moves (≈1.2 ms vs ≈1.5 ms for a one-month query); at 200M it decides the query. Statistics only help if you write the data in the order you filter on — the same lesson as an index, without the index.

### ◇ S3 — Compression is a storage trade (15 min)

```sql
COPY (SELECT * FROM read_parquet('Module06a/report_history.parquet'))
TO 'Module06a/report_zstd.parquet' (FORMAT parquet, COMPRESSION zstd);
```

Reference numbers on this dataset: **2.32 MB (snappy) → 1.37 MB (zstd)**, with the same dashboard query time (≈6.9 ms both, warm cache). Smaller file, same speed — until the file stops fitting in memory, and then the smaller one wins. Say that sentence out loud; it is the whole trade.

---

## 7 · (probably homework) — choose your level

**Core (everyone, ~20 minutes).** Produce the zstd copy from S3, record the size difference, and add a paragraph to the memo: **how** the refresh runs, and what would break if it silently stopped. Bring the updated memo to Module 6b — the decision record starts from these numbers.

**◇ Intense track (opt in, ~45–60 minutes).** This is the task that turns the memo into a pipeline — the difference between *"we would refresh it"* and *"here is the script"*. Take it if you want the strongest evidence for **goal 5**, or if your final project will need a rebuild step anyway (most will).

Write `Module06a/refresh.py` that:

1. rebuilds `report_history.parquet` from `history.db` (reuse the `COPY` from Round 2);
2. supports `--check`: compare **row count** and `SUM(part_price)` between SQLite and the Parquet, print both, and exit with status 1 on a mismatch;
3. prints one line — rows, checksum, Parquet size, elapsed milliseconds;
4. is **idempotent**: run it twice and the numbers must match (the bytes may differ; say so).

Then run it twice, paste both outputs into `duckdb-notes.md`, and add the harder half to the memo: what `--check` protects you from, and what it does **not** protect you from.

Why it is worth it: a refresh you can run and verify is the difference between a report and a rumour — and it is the smallest honest version of the ingestion pipeline your project needs.

<!-- PREP EMAIL (before Session 7): bring the updated memo; if you took the intense track, also `refresh.py` and one `--check` output, and the decision record starts from those numbers. -->

*Portfolio evidence:* the updated memo (core), plus `refresh.py` and two `--check` runs if you took the intense track.

---

## ✅ Suggested portfolio evidence (proofs of the learning goals)

- [ ] `prepare.py`, `to_parquet.py`, and the matching row counts/checksums for both sides.
- [ ] The Parquet file size next to the SQLite file size.
- [ ] `race.py` and the timing table (median of RUNS, interleaved, with the min–max spread).
- [ ] One `EXPLAIN ANALYZE` output with the dominating operator marked.
- [ ] `boundary.py` and the insert/lookup numbers, including the `executemany` variant.
- [ ] The memo to Lea and Yasmin, including the refresh paragraph (core homework).
- [ ] (Intense track) `refresh.py` and two `--check` runs.
- [ ] (Stretcher) your notes from S1, S2 or S3 — whichever you took.
- [ ] `Reflections/ref06a.md` — the logbook entry for this block.

## 📚 If you want to go deeper

- DuckDB — *Why DuckDB* (columnar, vectorized, in-process) — [duckdb.org/why_duckdb.html](https://duckdb.org/why_duckdb.html)
- DuckDB — reading Parquet and CSV, `read_parquet`/`read_csv_auto` — [duckdb.org/docs/data/overview](https://duckdb.org/docs/data/overview)
- Apache Parquet — format overview — [parquet.apache.org/docs/overview](https://parquet.apache.org/docs/overview/)
- `EXPLAIN ANALYZE` in DuckDB — [duckdb.org/docs/guides/meta/explain_analyze](https://duckdb.org/docs/guides/meta/explain_analyze)
- If you prefer watching: the [video list](./Z-resources-bank.md#watching-instead-of-reading).

---

[← Previous: Module 5](./05-normalization-vs-denormalization.md) | [Back to front page](../README.md) | [Next: Module 6b →](./06b-polyglot-persistence.md)
