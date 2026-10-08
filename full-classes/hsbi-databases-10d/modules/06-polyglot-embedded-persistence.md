# Module 6 — Polyglot & Embedded Persistence

[← Back to front page](../README.md) | [Quick module index](./00-index.md) | [Next: Module 7 →](./07-final-project-studio.md)

**Course placement:** Session 6. This module covers the legacy *Databases within Applications*, *NoSQL*, *ACID vs. BASE*, and *CAP theorem* chapters — reframed as a deliberate choice between several embedded engines.

## 🎯 Learning Goals

This module gives you the opportunity to explore polyglot persistence and achieve competency in matching a workload to a storage engine.

By the end of this module, you can:
1. Store **semi-structured data (JSON)** inside SQLite and query it with `json_extract`/`json_each` and an expression index.
2. Use **DuckDB** for analytical queries directly over **Parquet and CSV**, and explain why a columnar engine wins.
3. Implement and evaluate a **key-value store** for a simple access pattern.
4. Explain **ACID vs. BASE** and the **CAP theorem** in terms of the systems you actually ran.
5. Choose an engine for a workload and *defend the choice with a measurement*.

**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 📖 Story — Three Questions, Three Engines

Wittkamp's machine-shop data now has three different shapes of problem, and the team keeps trying to solve all three with the same tool. The plant manager, **Kai Lehmann**, pushes back:

1. *"Each sensor has different metadata — some have a calibration date, some have a firmware version, some have nothing. I don't want a schema migration every time a vendor adds a field."* → **flexible documents**
2. *"I have two years of stored readings in files. I want a weekly report and a histogram across all of them, fast."* → **analytical scan**
3. *"The dashboard needs to remember who logged in and what their last filter was. It is a simple lookup by one key."* → **key-value access**

Trying to force all three into one relational schema is the same mistake as Cirrus's cloud-server impulse in Module 1 — the wrong tool for the workload. In this studio you reach for three engines that all run **embedded, locally**, and you measure why each fits.

## 📖 Part A — Mini-Lecture: Pick the Engine for the Workload

**ACID vs. BASE.** A transactional engine guarantees **Atomicity, Consistency, Isolation, Durability** — your writes either fully happen or fully do not. BASE ("**B**asically **A**vailable, **S**oft state, **E**ventually consistent") relaxes consistency for availability and scale, which is a trade you only need when you distribute across machines. **All of Module 1–4 was ACID, and that was correct** because the data lived on one machine.

**The CAP theorem.** A distributed system can guarantee at most two of **C**onsistency, **A**vailability, and **P**artition tolerance. Since partitions *will* happen on a network, real systems choose **CP** (refuse to answer rather than answer wrong) or **AP** (answer, possibly stale). An embedded database sidesteps CAP by not distributing — and that is a legitimate engineering choice, not a limitation to apologize for.

**The polyglot palette (all embedded):**

| Engine | Model | Best at | Cost |
|---|---|---|---|
| **SQLite** | Relational rows (+ JSON1) | Transactions, integrity, point queries, small-to-medium data | One writer at a time |
| **DuckDB** | Columnar relational | Aggregations, scans, joins over large files (Parquet/CSV) | Not for many small writes |
| **Key-value (dict/`shelve`/LMDB)** | One key → one value | Trivial lookups by key, caches, sessions | No queries, no relationships |
| **Document (JSON in SQLite)** | JSON blobs + paths | Evolving metadata, vendor-specific fields | Weaker typing, needs expression indexes |

> [!TIP]
> "NoSQL" does not mean "no schema". A JSON column with a `CHECK(json_valid(...))` and an index on the paths you actually query is a *designed* schema — just a flexible one.

## 🛠️ Studio Lab: Three Engines, One Workload Each — **Challenging**

*Software:* `sqlite3` CLI, Python 3.14 with `duckdb` (installed via `uv`).

### ★ Task 1: JSON metadata inside SQLite

Vendors keep adding fields. Store the metadata as JSON and query it without migrating the table.

```sh
mkdir -p module-06
sqlite3 module-06/polyglot.db <<'SQL'
DROP TABLE IF EXISTS device;
CREATE TABLE device(
    device_id INTEGER PRIMARY KEY,
    name      TEXT NOT NULL,
    meta      TEXT NOT NULL CHECK (json_valid(meta))   -- enforce that it *is* JSON
) STRICT;

INSERT INTO device(name, meta) VALUES
  ('cnc-01', '{"vendor":"Siemens","firmware":"4.2","calibrated":"2026-01-10"}'),
  ('cnc-02', '{"vendor":"Fanuc","firmware":"3.9"}'),
  ('molder-07', '{"vendor":"Arburg","firmware":"8.1","calibrated":"2025-11-02","nozzle_mm":2.5}');

-- Query a path like a column:
SELECT name, json_extract(meta, '$.vendor') AS vendor FROM device;

-- The -> and ->> operators are shorthand:
SELECT name, meta ->> '$.firmware' AS fw FROM device;

-- Expand an object into rows:
SELECT d.name, j.key, j.value FROM device d, json_each(d.meta) j WHERE d.name = 'cnc-01';

-- Index the path you filter on (an expression index), then prove it with a plan:
CREATE INDEX ix_device_vendor ON device(json_extract(meta, '$.vendor'));
EXPLAIN QUERY PLAN SELECT name FROM device WHERE json_extract(meta, '$.vendor') = 'Fanuc';
SQL
```

Note the plan: if the expression in the index matches the expression in the `WHERE`, you get `SEARCH ... USING INDEX`. If they differ (a classic LLM mistake), you get `SCAN`.

*Portfolio evidence:* the DDL, the `json_extract`/`json_each` results, and the `EXPLAIN QUERY PLAN` output proving the expression index is used.

### ★ Task 2: DuckDB analytics over files

Move the readings into a Parquet file and analyze them with DuckDB — the analytical workload from the story. This reuses the `telemetry.db` you built in Module 1.

```python
# module-06/analytics.py — run from anywhere:  uv run python module-06/analytics.py
import time
from pathlib import Path
import duckdb

root = Path(__file__).resolve().parent.parent          # the portfolio repo root
sqlite_db = root / "module-01" / "telemetry.db"        # built in Module 1
parquet = root / "module-06" / "readings.parquet"

con = duckdb.connect()                       # in-process, embedded, no server

# 1. Attach the SQLite file from Module 1 (the sqlite extension reads it in place):
con.execute("INSTALL sqlite")                # first run downloads + caches this extension
con.execute("LOAD sqlite")
con.execute(f"ATTACH '{sqlite_db}' AS edge (TYPE sqlite)")

# 2. Materialize an analytical copy to Parquet at the edge — one file, no server:
con.execute(f"COPY (SELECT * FROM edge.readings) TO '{parquet}' (FORMAT parquet)")

# 3. Query the Parquet file directly — no import step, no server:
t0 = time.perf_counter()
from_parquet = con.execute(f"""
    SELECT machine, AVG(temp_c) AS avg_temp, MAX(vib_rms) AS peak_vib, COUNT(*) AS n
    FROM '{parquet}'
    GROUP BY machine
    ORDER BY peak_vib DESC
""").fetchall()
t_parquet = time.perf_counter() - t0

# 4. The same aggregation straight from the SQLite file, for comparison:
t0 = time.perf_counter()
from_sqlite = con.execute("""
    SELECT machine, AVG(temp_c) AS avg_temp, MAX(vib_rms) AS peak_vib, COUNT(*) AS n
    FROM edge.readings
    GROUP BY machine
    ORDER BY peak_vib DESC
""").fetchall()
t_sqlite = time.perf_counter() - t0

print("parquet:", from_parquet, f"{t_parquet:.3f}s")
print("sqlite :", from_sqlite,  f"{t_sqlite:.3f}s")
```

Run it. Record the two timings and the Parquet file size. Then answer: **why is the columnar Parquet path the right one for the weekly report, and the wrong one for recording a single new reading?**

*Portfolio evidence:* `analytics.py`, the Parquet file size, the two timings, and your one-paragraph engine-fit explanation.

### ★ Task 3: A key-value store for the dashboard

The dashboard only ever does "get by key" and "set key". Model that directly and measure it against SQLite.

```python
# module-06/kv_compare.py — run from anywhere:  uv run python module-06/kv_compare.py
import sqlite3, shelve, time
from pathlib import Path

here = Path(__file__).parent
N = 50_000

# --- key-value store (stdlib shelve: a persistent dict) ---
with shelve.open(str(here / "sessions")) as db:
    t0 = time.perf_counter()
    for i in range(N):
        db[f"session-{i}"] = f"user-{i%100}:filter=city:{i%4}"
    t_set = time.perf_counter() - t0
    t0 = time.perf_counter()
    for i in range(N):
        _ = db[f"session-{i}"]
    t_get = time.perf_counter() - t0

# --- the same access pattern in SQLite ---
conn = sqlite3.connect(here / "kv.db")
conn.execute("CREATE TABLE IF NOT EXISTS session(k TEXT PRIMARY KEY, v TEXT)")
t0 = time.perf_counter()
conn.executemany("INSERT OR REPLACE INTO session(k, v) VALUES (?, ?)",
                 ((f"session-{i}", f"user-{i%100}:filter=city:{i%4}") for i in range(N)))
conn.commit()
sq_set = time.perf_counter() - t0
t0 = time.perf_counter()
for i in range(N):
    conn.execute("SELECT v FROM session WHERE k = ?", (f"session-{i}",)).fetchone()
sq_get = time.perf_counter() - t0

print(f"shelve  set={t_set:.3f}s get={t_get:.3f}s")
print(f"sqlite  set={sq_set:.3f}s get={sq_get:.3f}s")
```

Run it and record the four numbers. Then state which you would ship for dashboard sessions and why — and **one thing SQLite can do that the key-value store cannot** (hint: a query across sessions).

*Portfolio evidence:* `kv_compare.py`, the four timings, your choice, and the SQLite-only capability you named.

### ★ Task 4: Name the paradigm

In 4–6 sentences, map what you just ran onto the theory: where was this **ACID**, where did you accept eventual consistency (if anywhere), and why is the **CAP theorem barely relevant** to a single-machine, embedded setup? This is your checkpoint-ready argument for choosing embedded persistence.

### ◇ Task 5 (Stretcher / replacement): The same questions in Nushell — a table-native shell

*A different lens on “alternatives to SQL”.* When people hear “NoSQL”, they picture exotic stores (documents, key-value, graphs). But the closest practical alternative to SQL is often a tool that treats **tables as first-class data** — like [**Nushell**](https://www.nushell.sh/), a cross-platform shell where every pipeline carries structured tables and lists instead of text. It is a beautiful way to *see* that the relational view is the natural shape of data, and it can even query SQLite directly.

If you take this stretcher, you may use it **in place of** Task 3's key-value comparison — the point is to work with a non-SQL tool whose data model is *still tabular*.

**1. Install Nushell** (one command; it is a single binary):

```sh
brew install nushell          # macOS / Linux
# winget install nushell      # Windows
# scoop install nu            # Windows (Scoop)
# cargo install nu --locked   # via Rust
```

**2. Answer the Module 1 plant questions in Nu pipelines.** Nushell reads the SQLite file directly:

```nu
# the whole table, then a Nu pipeline: selection (where) + count
open module-01/telemetry.db | get readings | where vib_rms > 1.5 | length

# grouping, the Nu way
open module-01/telemetry.db | get readings
  | where vib_rms > 1.5
  | group-by machine --to-table
  | each {|g| {machine: $g.group, alarms: ($g.items | length)}}
```

> Command names are stable, but the exact `group-by` output columns differ slightly across Nu versions — run `help group-by` (or `help group-by --to-table`) if the shape surprises you.

**3. Now the same question in SQL, from inside Nu:**

```nu
open module-01/telemetry.db | query db "
  SELECT machine, COUNT(*) AS alarms
  FROM readings WHERE vib_rms > 1.5 GROUP BY machine"
```

**4. Compare, clause by clause.** Write a short table mapping the two:

| Nushell pipeline | SQL clause |
|---|---|
| `get readings` | `FROM readings` |
| `where vib_rms > 1.5` | `WHERE vib_rms > 1.5` |
| `group-by machine` | `GROUP BY machine` |
| `select name, price` | `SELECT name, price` |
| `sort-by ts` | `ORDER BY ts` |
| `join $parts machine` | `JOIN parts ON …` |

Then answer in 3–5 sentences: *Did switching tools change how you think about the data — or only the syntax? What does that say about framing the alternatives to SQL as “NoSQL”?*

*Portfolio evidence:* your Nu pipeline, the equivalent SQL, the identical results, the clause-mapping table, and your reflection.

> **Instructor demo hint.** Open a fresh CSV of the plant telemetry and run, live:
> ```nu
> open telemetry.csv | where vib_rms > 1.5 | length
> open telemetry.csv | where vib_rms > 1.5 | group-by machine --to-table | each {|g| {machine: $g.group, n: ($g.items | length)}}
> ```
> next to the same query in the `sqlite3` shell. The “aha” is that the pipeline *is* a relational query — projection, selection, grouping — with no schema, no import, and no server — and then `open telemetry.db | query db "…"` shows the very same shell reaching the embedded database. Use it to make the module's point that the alternatives to SQL here are about *engines*, not about abandoning the tabular view. (If Nu is not installed on the lab machines, a short screen recording or the [Nushell book](https://www.nushell.sh/book/) works too.)

### ◇ Task 6 (Stretcher): Full-text search

Use SQLite's FTS5 to build a searchable index over machine maintenance notes (`CREATE VIRTUAL TABLE notes USING fts5(body)`). This is another "NoSQL-flavored" capability living *inside* the relational engine — a good counter-example to "SQLite is only for tables".

### ◇ Task 7 (Stretcher / side reading): Case studies — systems that broke the classic stack

For ~15 years the “serious” way to build a networked app was the familiar three-tier stack: a frontend, a backend/API, a client/server database (PostgreSQL/MySQL), and usually a cache and a message broker beside it. A growing set of real systems deliberately throw that away. Read about two of them and take notes.

- **GoToSocial** — [gotosocial.org](https://gotosocial.org) · [docs.gotosocial.org](https://docs.gotosocial.org). An ActivityPub (“Fediverse”) server written in Go, API-compatible with Mastodon. Where Mastodon runs a stack of PostgreSQL + Redis + Sidekiq + a web frontend, GoToSocial ships as a **single binary** and uses **SQLite by default** (Postgres optional). It runs in roughly 250–350 MiB of RAM — on a single-board computer, an old laptop, or a $5/month VPS — with no separate database server to run. Its [database docs](https://docs.gotosocial.org/en/latest/configuration/database) call SQLite “great for small instances and single-board computers, where a dedicated database would be overkill,” and keep Postgres as the heavier option.
- **Chatto** — [hmans.dev/blog/chatto](https://www.hmans.dev/blog/chatto) · [docs.chatto.run](https://docs.chatto.run). An open-source Slack/Teams alternative that is a **single executable serving its own web frontend** — in its words, “no reverse proxy, no external database — just one process.” One `./data/` directory, an **embedded NATS/JetStream** store, no separate broker or cache, and it even terminates TLS itself.

> [!NOTE]
> **A small correction worth noticing.** Chatto's embedded store is **NATS JetStream, not SQLite** — the *architecture* is the same “one binary replaces the whole stack” bet, just with a different embedded engine. That is a good discussion point in itself: why might an app choose a log-structured message store (JetStream) versus a relational file (SQLite) as its embedded heart? Compare that to Module 6's own engine-fit reasoning.

**Write up (≈1 page), for each system:**

1. **What it removed** — which parts of the classic stack are gone (database server, cache, broker, reverse proxy, a separately deployed frontend).
2. **The trade-offs it accepted** — e.g. SQLite's single-writer model and horizontal-scale limits, or bespoke tooling; and when the authors recommend the heavier option (GoToSocial + Postgres).
3. **The advantages claimed** — deployment simplicity, resource use, privacy/data ownership, and lower maintenance/upgrade cost.
4. **The link to this course** — how these choices map onto Module 1's embedded-vs-client/server argument and this module's polyglot-persistence reasoning.

*Portfolio evidence:* the comparison notes, plus one sentence: *which of your own projects would benefit from a single-binary design — and which would not?*

> **Instructor demo/teaching hint.** Open GoToSocial's database page that states SQLite is the *default* with Postgres as the optional heavier path — it is this module's thesis running in production: an embedded database as the sensible default, a server only when a measured need forces it. Contrast the deployment shapes: Mastodon's multi-service diagram vs. GoToSocial's one binary + one `./data/`. If you want a third, SQLite-native example for the slide, **PocketBase** and **TrailBase** are single-binary backends built directly on SQLite.

## ✅ What must be committed to your portfolio

Commit under `module-06/`:

- [ ] The JSON device DDL, `json_extract`/`json_each` queries, and the expression-index plan.
- [ ] `analytics.py`, the Parquet artifact (or its size), the two timings, and the engine-fit paragraph.
- [ ] `kv_compare.py`, the four timings, your engine choice, and the SQLite-only capability.
- [ ] The ACID/BASE/CAP paragraph.
- [ ] `reflection.md` — the logbook entry for this block.
- [ ] (Stretcher) the FTS5 notes search **or** the Nushell-vs-SQL comparison (Task 5) **or** the case-study notes (Task 7).

## 📚 If you want to go deeper

- SQLite — JSON functions and the `->`/`->>` operators — [sqlite.org/json1.html](https://sqlite.org/json1.html)
- DuckDB — reading Parquet and CSV directly; the SQLite extension — [duckdb.org/docs/data/parquet](https://duckdb.org/docs/data/parquet/overview) · [duckdb.org/docs/extensions/sqlite](https://duckdb.org/docs/core_extensions/sqlite.html)
- DuckDB — *Why DuckDB* (columnar, vectorized OLAP) — [duckdb.org/why_duckdb.html](https://duckdb.org/why_duckdb.html)
- **Nushell** — a table-native shell: pipelines over structured data that read SQLite/CSV/JSON directly — [nushell.sh](https://www.nushell.sh/) · [Loading Data](https://www.nushell.sh/book/loading_data.html) · [Working with Tables](https://www.nushell.sh/book/working_with_tables.html)
- **Real-world single-binary systems** — [GoToSocial](https://gotosocial.org) (ActivityPub server, SQLite by default) · [Chatto](https://www.hmans.dev/blog/chatto) (chat platform as one binary) · [PocketBase](https://pocketbase.io/) (backend-in-a-file on SQLite) · Wafris, *Rearchitecting: Redis to SQLite* — [wafris.org/blog/rearchitecting-for-sqlite](https://wafris.org/blog/rearchitecting-for-sqlite)
- **Why embedded, local-first persistence is surging** — the [local-first manifesto](https://www.inkandswitch.com/essay/local-first/) (Ink & Switch) and [Rails 8 making SQLite the production default](https://rubyonrails.org/2024/11/7/rails-8-no-paas-required); more in the [resource bank](./Z-resources-bank.md#why-local-first-and-why-the-heavy-three-tier-default-is-questioned)
- Martin Kleppmann — *Designing Data-Intensive Applications* (ACID, BASE, CAP) — the standard reference for this module's theory

---

[← Previous: Module 5](./05-normalization-vs-denormalization.md) | [Back to front page](../README.md) | [Next: Module 7 →](./07-final-project-studio.md)
