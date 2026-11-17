# Module 6b — Polyglot Persistence & the Decision

[← Previous: Module 6a](./06a-duckdb-analytical-engine.md) | [Quick module index](./00-index.md) | [Next: Module 7 →](./07-final-project-studio.md)

> **One line:** Kortmann now has three engines in the building. Write the one-page decision that says which workload lives where — and defend it to another pod.

**Course placement:** Session 7. The second half of the old *NoSQL / ACID vs. BASE / CAP* chapter, taught as a decision rather than a tour. Module 6a moved the report to Parquet; this studio decides what to do with everything else.

## 🎯 Learning Goals

By the end of this module, you can:
1. Store **semi-structured data (JSON)** in SQLite and query it with `json_extract`/`json_each` and an **expression index**.
2. Implement and evaluate a **key-value access pattern** against SQLite.
3. Explain **ACID vs. BASE** and the **CAP theorem** in terms of the systems you actually ran.
4. Choose an engine per workload and **defend the choice with a measurement**.
5. Say what changes — and what gets harder — when the same data lives on a **server**.

**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 📖 Story — Three Engines and a Plant Manager

Kortmann's month-end report now runs against a Parquet file, and Lea Winter is off your back. The plant has three storage shapes and nobody has written down why.

**Anke Reuter** maintains the machine records. Every vendor update brings new fields — a calibration date here, a firmware string there, sometimes nothing — and every new field has meant a schema migration and a maintenance window. *"I don't need a schema for fields I don't know yet."*

**Yasmin Kaya** has the other end: the dashboard remembers who logged in and which filter they used last. It is a lookup by one key, nothing else. *"Do we really run that through a relational engine?"*

And the report you built in 6a is a third shape: a file that is rewritten and scanned, never updated.

*"So do we need three engines?"* Yasmin asks. *"Or is this still one database with a bad schema?"*

Your answer is a **one-page engine decision record** — and a defence of it.

## 🧭 Why this is the job

A database engineer is not the person who knows the most engines. It is the person who can make a
trade-off explicit and defend it with evidence. The decision record is that argument. It is also
the rehearsal for your project's architecture point: in three weeks you will make the same choice
for a different story.

**The challenge.** Kortmann has four workloads: append-only machine ingest, a two-year month-end
report, vendor metadata that keeps growing, and dashboard session lookups. One engine can serve all
four — but not equally well. Your job is not to learn four tools. Your job is to decide where each
workload lives, what the choice costs, and what breaks when the copy is stale. Then defend it.

**The artefact.** One page, four rows, evidence in every cell, and one final line:

> **If Kortmann could run only one engine, which would it be — and what would break first?**

## 🛠️ How this studio works

Four **Tasks**, one artefact. No lecture and no pod study. Every task ends with a short
**discussion** with the nearest pod; the decision record is filled in as you go and defended at the
end. Some tasks continue as homework — the key-value comparison and the project ticket are
deliberate homework.

<!-- TODO: remove the timing notes after the run; the instructor note is the source of truth. -->
**Rough timing (180 minutes):** opening + 6a recap 10 → Task 1 25 → Task 2 briefing 5 → break 15 →
Task 3 25 → Task 4 30 → peer defence 35 → harvest + wrap 15 = **160**, with **20 minutes buffer**
for the server setup.

Keep your notes in `Module06b/engine-notes.md`.

| # | Task | You produce | Talk it through |
|---|---|---|---|
| 1 | **Metadata** | a JSON column, an expression index, and the plan that proves it | "Why does `->>` give you a `SCAN`?" |
| 2 | **Session state** | four timings and a choice (homework) | "Name one thing SQLite can do that `shelve` cannot." |
| 3 | **The server** | three observations from a shared PostgreSQL server | "What got harder, and what got easier?" |
| 4 | **The record** | one page + a defence | "If only one engine were allowed, which — and what breaks?" |

---

## 🛠️ Task 1 — Metadata that will not sit still

Store the vendor metadata as JSON and query it without migrating the table.

> **Why this task.** Anke’s vendor metadata changes shape. A new column per field means a schema
> migration and a maintenance window every time a vendor adds something. A JSON column lets you
> store the fields you know now and add fields later without a migration; `json_valid` keeps it
> honest, and an expression index keeps the queries you actually run fast. The price is real: no
> column-level typing, no cheap joins, and the index only works for the exact expression you index.
> This task proves both sides — flexibility and the index trap — and gives the metadata row of the
> decision record its evidence. A separate key-value store would make “find every device by
> vendor” hard; JSON inside SQLite keeps the relational query and the flexible field together.

```python
# Module06b/json_bench.py — run with:  uv run python Module06b/json_bench.py
"""A JSON column in SQLite: store flexibly, query precisely, index deliberately."""
import json
import sqlite3
from pathlib import Path

here = Path(__file__).parent
con = sqlite3.connect(here / "polyglot.db")

con.executescript("""
DROP TABLE IF EXISTS device;
CREATE TABLE device(
    device_id INTEGER PRIMARY KEY,
    name      TEXT NOT NULL,
    meta      TEXT NOT NULL CHECK (json_valid(meta))   -- it *is* JSON, enforced
) STRICT;
""")

rows = [
    ("cnc-01",    '{"vendor":"Siemens","firmware":"4.2","calibrated":"2026-01-10"}'),
    ("cnc-02",    '{"vendor":"Fanuc","firmware":"3.9"}'),
    ("molder-07", '{"vendor":"Arburg","firmware":"8.1","calibrated":"2025-11-02","nozzle_mm":2.5}'),
]
for i in range(4, 1001):
    meta = json.dumps({
        "vendor": ("Siemens", "Fanuc", "Arburg")[i % 3],
        "firmware": f"{i % 5}.{i % 10}",
    })
    rows.append((f"device-{i:04d}", meta))
con.executemany("INSERT INTO device(name, meta) VALUES (?, ?)", rows)

print("-- a path behaves like a column (first five rows)")
for row in con.execute(
        "SELECT name, json_extract(meta, '$.vendor') FROM device LIMIT 5"):
    print(row)

print("-- the ->> shorthand returns a scalar (first five rows)")
for row in con.execute("SELECT name, meta ->> '$.firmware' FROM device LIMIT 5"):
    print(row)

print("-- an object becomes rows")
for row in con.execute(
        "SELECT d.name, j.key, j.value FROM device d, json_each(d.meta) j "
        "WHERE d.name = 'cnc-01'"):
    print(row)

print("-- index the path you filter on, then prove it")
con.executescript("""
CREATE INDEX ix_device_vendor ON device(json_extract(meta, '$.vendor'));
""")
print(con.execute(
    "EXPLAIN QUERY PLAN SELECT name FROM device "
    "WHERE json_extract(meta, '$.vendor') = 'Fanuc'").fetchall())

print("-- now break it: the shorthand is a different expression")
print(con.execute(
    "EXPLAIN QUERY PLAN SELECT name FROM device "
    "WHERE meta ->> 'vendor' = 'Fanuc'").fetchall())
```

The first plan says `SEARCH device USING INDEX ix_device_vendor`; the second says `SCAN device`.
**Same question, same result, different expression — and the index is ignored.** That is the single
most common LLM mistake with JSON columns, and now you can see it.

> **Module 4 callback.** `CHECK (json_valid(meta))` is exactly the constraint idea from Module 4,
> applied to a column whose shape you do not know yet. If Module 4 felt rushed, this is the cheapest
> way back in: a constraint is a promise the database keeps for you, and here it promises "this
> column is JSON". The project needs one constraint and one trigger or generated column; this is a
> legitimate candidate.

> **Theory you need — "NoSQL" does not mean "no schema".** A JSON column with `json_valid`, an
> expression index on the paths you actually filter, and a documented set of keys **is** a designed
> schema — just a flexible one. What you gave up is column-level typing and cheap `JOIN`s; what you
> gained is not migrating a table every time a vendor adds a field.

> **Discuss (nearest pod).**
> - **Why** is the index ignored for `->>`? Say it in one sentence — that is **goal 1**.
> - **What if** the vendor field moved into a real column? What do you gain, and what do you lose
>   the next time a vendor adds a field?

---

## 🛠️ Task 2 — Session state (homework)

The dashboard only ever does "get by key" and "set by key". Model that directly and measure it
against SQLite. Run this at home; bring the four numbers and your choice to the next session.

```python
# Module06b/kv_compare.py — run with:  uv run python Module06b/kv_compare.py
"""The same access pattern in a key-value store and in SQLite."""
import shelve
import sqlite3
import time
from pathlib import Path

here = Path(__file__).parent
N = 20_000

with shelve.open(str(here / "sessions")) as db:
    t0 = time.perf_counter()
    for i in range(N):
        db[f"session-{i}"] = f"user-{i % 100}:filter=city:{i % 4}"
    t_set = time.perf_counter() - t0
    t0 = time.perf_counter()
    for i in range(N):
        _ = db[f"session-{i}"]
    t_get = time.perf_counter() - t0

conn = sqlite3.connect(here / "sessions.db")
conn.execute("CREATE TABLE IF NOT EXISTS session(k TEXT PRIMARY KEY, v TEXT)")
conn.execute("DELETE FROM session")
t0 = time.perf_counter()
conn.executemany("INSERT OR REPLACE INTO session(k, v) VALUES (?, ?)",
                 ((f"session-{i}", f"user-{i % 100}:filter=city:{i % 4}") for i in range(N)))
conn.commit()
sq_set = time.perf_counter() - t0
t0 = time.perf_counter()
for i in range(N):
    conn.execute("SELECT v FROM session WHERE k = ?", (f"session-{i}",)).fetchone()
sq_get = time.perf_counter() - t0

print(f"shelve  set={t_set:8.3f}s get={t_get:8.3f}s")
print(f"sqlite  set={sq_set:8.3f}s get={sq_get:8.3f}s")
```

Record the four numbers and answer:

- Which would you ship for dashboard sessions, and why?
- **Name one thing SQLite can do that `shelve` cannot.** (Hint: a query across sessions — "how many
  users filtered by city last week?")
- `shelve`'s backend differs between platforms. Report **orders of magnitude**, not decimals.

> **Discuss (nearest pod).**
> - **Reads tie, writes do not.** Which number decides your choice, and why?
> - **Name one query** SQLite can answer across sessions that `shelve` cannot — that is **goal 2**.

---

## 🛠️ Task 3 — The shared server

This is the control group for everything this course has argued. Your instructor hosts a
PostgreSQL server on the classroom network; each pod gets one database and one role. You connect
through the browser UI (pgweb) — nothing to install. The URL and credentials are in the LMS.

1. **Connect.** Open pgweb, enter your pod's database, user, and password.
2. **Create and query.** Create the same small `machine` table you used in Module 4; insert three
   rows; run one query you already know from SQLite. The SQL is the same.
3. **Write concurrently.** Open a second tab, or ask a podmate to update the same row at the same
   time. Watch what happens.
4. **Name the moving parts.** A connection is a host, a port, a user, a password, and a database.
   Count them.
5. **Lose the server.** The instructor stops the server. Every client fails at once, and nothing in
   your SQL can fix it. Then it restarts.

Write three observations in `engine-notes.md`: one thing that got **easier**, one that got
**harder**, and one failure mode that an embedded database does not have.

> **If the server is unavailable:** the instructor runs the SQLite two-writer comparison — two
> connections, one `BEGIN IMMEDIATE`, the second write gets `database is locked`. That is the local
> version of the same lesson; the three observations still apply.

> **Theory you need — CAP in one paragraph.** A distributed system can keep at most two of
> **consistency**, **availability**, and **partition tolerance**. Since networks partition, real
> systems choose **CP** (answer correctly or not at all) or **AP** (answer, possibly stale). An
> embedded database sidesteps the choice by not distributing — a legitimate engineering decision,
> not a limitation to apologise for. **ACID** is about one transaction's guarantees; **BASE**
> relaxes consistency for availability at scale. You have now run both sides.

> **Discuss (nearest pod).**
> - **What got harder, and what got easier?** One sentence each.
> - **Which failure mode** did the server add that an embedded database does not have? That is
>   **goal 5**.

---

## 🛠️ Task 4 — The decision record

Fill in one page for Kortmann. Every row needs a **measurement or an observation from this course**,
not an opinion. The first row is an example of the depth expected.

| Workload | Engine | Why | Evidence | Cost accepted | What breaks if stale/missing? |
|---|---|---|---|---|---|
| Month-end report over two years | Parquet + DuckDB | A 2M-row scan is ~100× faster than the operational SQLite; the writer stays free | 6a: ~600 ms → ~6 ms; Parquet 2.3 MB | A nightly export; one day of staleness | Rebuild the Parquet; the report shows the last complete day |
| Sensor/job ingest, every 30 s, crash must not lose rows | | | | | |
| Vendor metadata that gains fields | | | | | |
| Dashboard session state | | | | | |
| *(optional)* Concurrent users on the network | | | | | |

Then the last line, which is the whole point:

> **If Kortmann could run only one engine, which would it be — and what would break first?**

There is no correct answer. There is only an answer you can defend with the numbers you produced in
6a and 6b.

**Peer defence.** Swap records with another pod; each pod presents its record while the other asks
the questions. Then write down what changed and why. The listening pod asks:

- "Which row has no measurement behind it?"
- "Where does your choice duplicate data — and who updates it?"
- "What breaks if two people write at the same time?"
- "Why is this a database and not three spreadsheets?"

The defending pod may change one row after the conversation. Write down what changed and why — that
is the learning, not the original choice.

*Portfolio evidence:* the decision record (one page), the defence notes, and `Reflections/ref06b.md`.

---

## 📖 Before the project kickoff (homework)

The final project starts from a **person and a first query**, not from a technology. Before the
project kickoff, write one paragraph in `Module06b/project-ticket.md`:

1. **The person** — a named person or role with the problem.
2. **The problem** — the decision the data changes.
3. **The first query** — the one question the database must answer.
4. **The data source** — where the data comes from; if it does not exist, how you will generate it
   reproducibly.

Bring it to the project kickoff. Do not form teams yet — the Task Pods merge there. One good
paragraph is enough; three candidates are better.

## ✅ Suggested portfolio evidence (proofs of the learning goals)

- [ ] `json_bench.py`, its output, and the two `EXPLAIN QUERY PLAN` outputs.
- [ ] `kv_compare.py`, the four timings, your choice, and the SQLite-only capability you named.
- [ ] Three observations from the shared-server task (or the SQLite two-writer fallback).
- [ ] The one-page decision record, including the "only one engine" line.
- [ ] Your defence notes and what you changed afterwards.
- [ ] `Module06b/project-ticket.md`.
- [ ] `Reflections/ref06b.md`.

## 📚 If you want to go deeper

- SQLite — JSON functions and the `->`/`->>` operators — [sqlite.org/json1.html](https://sqlite.org/json1.html)
- SQLite — expression indexes — [sqlite.org/expridx.html](https://sqlite.org/expridx.html)
- DuckDB — *Why DuckDB* — [duckdb.org/why_duckdb.html](https://duckdb.org/why_duckdb.html)
- Martin Kleppmann — *Designing Data-Intensive Applications* (ACID, BASE, CAP) — the standard reference
- **Nushell** — a table-native shell that reads SQLite/CSV/JSON directly — [nushell.sh](https://www.nushell.sh/)
- Why the heavy three-tier default is being questioned — [local-first manifesto](https://www.inkandswitch.com/essay/local-first/) · [Rails 8 and SQLite](https://rubyonrails.org/2024/11/7/rails-8-no-paas-required)
- If you prefer watching: the [video list](./Z-resources-bank.md#watching-instead-of-reading).

---

[← Previous: Module 6a](./06a-duckdb-analytical-engine.md) | [Back to front page](../README.md) | [Next: Module 7 →](./07-final-project-studio.md)
