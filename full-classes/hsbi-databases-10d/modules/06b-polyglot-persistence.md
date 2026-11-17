# Module 6b — Polyglot Persistence & the Decision

[← Previous: Module 6a](./06a-duckdb-analytical-engine.md) | [Quick module index](./00-index.md) | [Next: Module 7 →](./07-final-project-studio.md)

> **One line:** Kortmann has three storage shapes and a shared server. Write the one-page decision that says which workload lives where — and defend it to another pod.

**Course placement:** Session 7. The second half of the old *NoSQL / ACID vs. BASE / CAP* chapter, taught as a decision rather than a tour. Module 6a moved the report to Parquet; this studio tests the boundary, chooses the shapes, and writes the decision.

## 🎯 Learning Goals

By the end of this module, you can:
1. Store **semi-structured data (JSON)** in SQLite and query it with `json_extract`/`json_each` and an **expression index**.
2. Implement and evaluate a **key-value access pattern** against SQLite.
3. Explain **ACID vs. BASE** and the **CAP theorem** in terms of the systems you actually ran.
4. Choose an engine per workload and **defend the choice with a measurement**.
5. Say what changes — and what gets harder — when the same data lives on a **server**.

**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 🎬 Opening the Challenge

The month-end report is solved: 6a moved it to Parquet + DuckDB, and it got roughly **100× faster**. The rest of the plant is still local, still relational, and still undecided.

Kortmann has four workloads:

- append-only machine ingest,
- a two-year month-end report,
- vendor metadata that keeps growing,
- dashboard session lookups.

One engine can serve all four — but not equally well. A database engineer is not the person who knows the most engines; it is the person who can make a trade-off explicit and defend it with evidence. That argument is the **one-page decision record**.

> **If Kortmann could run only one engine, which would it be — and what would break first?**

The report row is already filled from 6a. The ingest row comes from Modules 1 and 4. You will fill the other rows today.

**Today's arc:** test the boundary → choose the shape → defend the decision. You start with the shared server because it is the control group: it shows what changes when the same data lives on another machine.

## 🧭 How this studio works

Two content tasks and one decision. Each task gives you a small thing to do, a short **Theory you need** box you read only when it helps, and a discussion with the nearest pod.

Some work at the end can become homework: the key-value benchmark, the project ticket, the reflection, and finishing the decision record.

The decision record is the spine. Fill it as you go; do not wait until the end.

Keep your notes and evidence in the `Module06b/` section of your portfolio — one section per task, not a separate file unless a section runs over.

| Task | You produce (a section in `Module06b/`) | Decision-record row |
|---|---|---|
| **Task 1 — The boundary** | three observations and a concurrency result | concurrent users (optional) |
| **Task 2 — The shape** | two JSON plans and a key-value choice | vendor metadata, dashboard session state |
| **Task 3 — The decision** | one page + a defence | all rows |

---

## 🛠️ Task 1 — The Boundary (local vs. remote)

You have spent six sessions hearing that an embedded database is enough. Before you decide, test the boundary: **same SQL, same data, different machine. What changes?**

Your pod has one database and one role on the shared PostgreSQL server. The instructor has pre-created a small `machine` table with one row:

```sql
CREATE TABLE machine(
    machine_id      INTEGER PRIMARY KEY,
    site            TEXT NOT NULL,
    parts_produced  INTEGER NOT NULL DEFAULT 0
);
INSERT INTO machine VALUES (1, 'guetersloh', 0);
```

Do not run the `CREATE TABLE` again. The table is already there.

1. **Connect and query.** Open the pgweb URL and log in with the shared class credentials from the LMS. In the connection form, use the host and port from the credential sheet (native server: `127.0.0.1`, port `5432`; container fallback: `db`, port `5432`), database/user `podNN`, your pod password, and **SSL mode `disable`** — pgweb talks to PostgreSQL on the same machine; Cloudflare's TLS is between your browser and pgweb. Run a `SELECT`, then insert one row with an explicit `machine_id` (for example `2`).
   The DML is the same SQL you used in SQLite. The DDL is not: PostgreSQL has no `STRICT` or `PRAGMA`, and an `INTEGER PRIMARY KEY` does not auto-increment.
2. **Two writers, one row.** Use **two different browsers or two student devices** — two tabs in the same browser may share one pgweb session. Both run:
   ```sql
   UPDATE machine SET parts_produced = parts_produced + 1 WHERE machine_id = 1;
   ```
   Watch which one waits. Your instructor will also project a `psql` demo of the lock and of a lost update; you do not need to install anything.
3. **Lose the server.** The instructor stops only the database process; pgweb stays up. Every client fails at once, and nothing in your SQL can fix it. After the restart, reload pgweb and run the query again.
4. **Write three observations** in your `Module06b/` portfolio section: one thing that got **easier**, one that got **harder**, and one failure mode that an embedded database does not have.

> **Discuss (nearest pod).**
> - **What got harder, and what got easier?** One sentence each.
> - **Which failure mode** did the server add that an embedded database does not have? That is **goal 5**.

> **Theory you need — the vocabulary.** **ACID** is one transaction's guarantees: all or nothing, constraints hold, concurrent transactions do not see half-work, and a commit survives a crash. **BASE** is a deliberate distributed trade: basically available, soft state, eventually consistent. During a network partition, a distributed system must choose **consistency** or **availability** — **CP** or **AP**; partition tolerance is not optional. SQLite is ACID on one machine because it does not distribute. The full mnemonic, the traps, and the reading pointers are in [Appendix A](#a-acid-base-cap).

> **If the server is unavailable:** the instructor runs the SQLite two-writer comparison — two connections, one `BEGIN IMMEDIATE`, the second write gets `database is locked`. That is the local version of the same lesson; the three observations still apply.

*Evidence:* the three observations and the concurrency result. This fills the optional "concurrent users" row of the decision record.

---

## 🛠️ Task 2 — The Shape (schemaless)

**Anke Reuter** maintains the machine records. Every vendor update brings new fields — a calibration date here, a firmware string there, sometimes nothing — and every new field has meant a schema migration and a maintenance window. *"I don't need a schema for fields I don't know yet."*

**Yasmin Kaya** has the other end: the dashboard remembers who logged in and which filter they used last. It is a lookup by one key, nothing else. *"Do we really run that through a relational engine?"*

Both are "not a table." **Are they the same problem?**

Store the vendor metadata as JSON and query it without migrating the table.

> **Why this task.** This is not a JSON syntax lesson. It is the **metadata row** of the decision record. A wide table with one column per vendor field is mostly `NULL` and needs a migration every time a vendor adds something. A separate document database loses the cheap join to `machine` ("which devices at this site are due for calibration?"). A JSON column in SQLite is the middle path: the document stays next to the relational row, `json_valid` rejects non-JSON, and an expression index makes the one path you filter on fast. The price is real: no column-level typing, no cheap joins on JSON values, and the index only matches the exact expression. That price is what you are here to see.

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

The first plan says `SEARCH device USING INDEX ix_device_vendor`; the second says `SCAN device`. **Same question, same result, different expression — and the index is ignored.** That is the single most common LLM mistake with JSON columns, and now you can see it.

1. **Compare the plans.** Say in one sentence why `->>` loses the index. That is **goal 1**.
2. **Choose the session-state shape.** The dashboard is a key lookup, not a document. Your instructor will brief the key-value comparison and show the reference order of magnitude. Use the reference numbers in today's decision record; run the benchmark at home and replace the row with your own numbers.
3. **Discuss the contrast.** Document vs. key-value vs. relational: what did each buy, and what did it cost? That is **goals 1 and 2**.

> **Theory you need — "NoSQL" does not mean "no schema".** A JSON column with `json_valid`, an expression index on the paths you actually filter, and a documented set of keys **is** a designed schema — just a flexible one. What you gave up is column-level typing and cheap `JOIN`s; what you gained is not migrating a table every time a vendor adds a field. The native XML database wave made the same promise; [Appendix B](#b-schemaless-is-not-schema-free) has the history and the pointers.

> **Module 4 callback.** `CHECK (json_valid(meta))` is exactly the constraint idea from Module 4, applied to a column whose shape you do not know yet. If Module 4 felt rushed, this is the cheapest way back in: a constraint is a promise the database keeps for you, and here it promises "this column is JSON". The project needs one constraint and one trigger or generated column; this is a legitimate candidate.

*Evidence:* the two `EXPLAIN QUERY PLAN` outputs and your one-sentence explanation. The key-value numbers join the record after the homework.

---

## 🛠️ Task 3 — The Decision (record + defence)

Fill in one page for Kortmann. Every row needs a **measurement or an observation from this course**, not an opinion. The first row is an example of the depth expected.

| Workload | Engine | Why | Evidence | Cost accepted | What breaks if stale/missing? |
|---|---|---|---|---|---|
| Month-end report over two years | Parquet + DuckDB | A 2M-row scan is ~100× faster than the operational SQLite; the writer stays free | 6a: ~600 ms → ~6 ms; Parquet 2.3 MB | A nightly export; one day of staleness | Rebuild the Parquet; the report shows the last complete day |
| Sensor/job ingest, every 30 s, crash must not lose rows | | | | | |
| Vendor metadata that gains fields | | | | | |
| Dashboard session state | | | | | |
| *(optional)* Concurrent users on the network | | | | | |

If you have not run the key-value benchmark yet, write **`reference`** in the session-state `Evidence` cell; replace it at home and note what changed. The report row comes from 6a; the ingest row uses your Module 4 idempotent `UPSERT`, the double-run row count, and the Module 4 constraint as evidence.

Then the last line, which is the whole point:

> **If Kortmann could run only one engine, which would it be — and what would break first?**

There is no correct answer. There is only an answer you can defend with the numbers you produced in 6a and 6b.

1. **Fill the record.** Use the evidence from Tasks 1 and 2, 6a, and Modules 1/4. Do not leave a row without a measurement or a concrete observation.
2. **Defend it.** Swap records with another pod. Each pod presents while the other asks the questions; then write down what changed and why. The listening pod asks:
   - "Which row has no measurement behind it?"
   - "Where does your choice duplicate data — and who updates it?"
   - "What breaks if two people write at the same time?"
   - "Why is this a database and not three spreadsheets?"
3. **Change one row.** The defending pod may change one row after the conversation. Write down what changed and why — that is the learning, not the original choice.

*Evidence:* the decision record (one page), the defence notes, and the "only one engine" line.

---

## ✅ Evidence

- [ ] `json_bench.py`, its output, and the two `EXPLAIN QUERY PLAN` outputs.
- [ ] Three observations from the shared-server task (or the SQLite two-writer fallback).
- [ ] The one-page decision record, including the "only one engine" line and the defence notes.
- [ ] `kv_compare.py`, the four timings, and your choice — **homework, see below**.
- [ ] `Module06b/project-ticket.md` — **homework, see below**.
- [ ] `Reflections/ref06b.md` — **homework, see below**.

---

## 📖 After the studio (potentially homework)

The main flow is finished. These are the extensions. The project ticket is for Session 8; the rest finish this module's evidence. Replace the session-state row with your own numbers before you submit the record.

### Key-value benchmark

Run this at home. Record the four numbers, then replace the session-state row in your decision record with your own numbers and note what changed.

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
- **Name one thing SQLite can do that `shelve` cannot.** (Hint: a query across sessions — "how many users filtered by city last week?")
- `shelve`'s backend differs between platforms. Report **orders of magnitude**, not decimals.

> **Before you commit:** on some platforms, `shelve` writes `sessions.bak`, `sessions.dat`, and `sessions.dir`; `*.db` does not catch those. Add `Module06b/sessions*` to your `.gitignore`.

### Project ticket

The final project starts from a **person and a first query**, not from a technology. Before the project kickoff, write one paragraph in `Module06b/project-ticket.md`:

1. **The person** — a named person or role with the problem.
2. **The problem** — the decision the data changes.
3. **The first query** — the one question the database must answer.
4. **The data source** — where the data comes from; if it does not exist, how you will generate it reproducibly.

Bring it to the project kickoff. Do not form teams yet — the Task Pods merge there. One good paragraph is enough; three candidates are better.

### Reflection

Write `Reflections/ref06b.md` after the session. It is the last piece of evidence for this module.

---

## 📚 Theory appendix (optional)

Read this when you want the full picture, not before you start. The resource bank has the longer versions and the external links.

### A. ACID, BASE, CAP

**ACID** is one transaction's guarantees: *atomicity* (all or nothing), *consistency* (constraints hold), *isolation* (concurrent transactions do not see half-work), *durability* (a commit survives a crash). Picture a bank transfer.

**BASE** is a deliberate distributed trade: *basically available*, *soft state*, *eventually consistent*. Picture a social feed: a like may show late, then catch up.

**CAP** is the choice during a network partition. A partition is a fact, not a choice; while it lasts, a distributed system must choose **consistency** (answer correctly, or refuse) or **availability** (answer, possibly stale). It is not "pick two of three" all the time. SQLite is ACID on one machine because it does not distribute.

**One sentence to remember:** *ACID is a bank transfer, BASE is a social feed, CAP is the choice when the network breaks — and SQLite is ACID on one machine because it does not distribute.*

### B. Schemaless is not schema-free

A JSON column with `json_valid`, an expression index on the paths you filter, and a documented set of keys **is** a schema. The schema has moved from the table definition into the application and the indexes. That is why `json_extract(meta, '$.vendor')` uses the index and `meta ->> 'vendor'` does not: they are different expressions.

The native XML database wave made the same promise: store documents as they arrive, let the schema evolve, query the structure with XPath/XQuery. It was real for document-centric publishing, archives, and catalogues; the overreach was treating XML as the universal data model for every API and integration, which produced SOAP/WS-* and what critics called **"XML fever"** and the **"angle bracket tax."** Native XML databases never took over the market; relational vendors added XML columns, JSON won the browser/API layer, and the document idea survived in MongoDB/CouchDB and in JSON columns like the one you just indexed. XML still runs where the document is the product: publishing, archives, government, SVG, Office Open XML, and XBRL.

The lesson is not "XML bad" — it is that **the format is not the schema**. For the history and the counter-arguments, see the [XML-database reading list](./Z-resources-bank.md#xml-databases-and-the-schema-debate).

### C. Local vs. remote

The same SQL can behave differently when the database is on another machine. A server adds **concurrent connections** (good), **network failure** (new), **credentials and operations** (new), and **latency** (new). It serializes conflicting writes; it does not fix a read-modify-write race. A single server is also a single point of failure. The local-first default is a decision, not a dogma: choose the server when a measured requirement demands it.

### D. Further reading

- SQLite — JSON functions and the `->`/`->>` operators — [sqlite.org/json1.html](https://sqlite.org/json1.html)
- SQLite — expression indexes — [sqlite.org/expridx.html](https://sqlite.org/expridx.html)
- DuckDB — *Why DuckDB* — [duckdb.org/why_duckdb.html](https://duckdb.org/why_duckdb.html)
- Martin Kleppmann — *Designing Data-Intensive Applications* (ACID, BASE, CAP) — the standard reference
- **Nushell** — a table-native shell that reads SQLite/CSV/JSON directly — [nushell.sh](https://www.nushell.sh/)
- Why the heavy three-tier default is being questioned — [local-first manifesto](https://www.inkandswitch.com/essay/local-first/) · [Rails 8 and SQLite](https://rubyonrails.org/2024/11/7/rails-8-no-paas-required)
- If you prefer watching: the [video list](./Z-resources-bank.md#watching-instead-of-reading).

---

[← Previous: Module 6a](./06a-duckdb-analytical-engine.md) | [Back to front page](../README.md) | [Next: Module 7 →](./07-final-project-studio.md)
