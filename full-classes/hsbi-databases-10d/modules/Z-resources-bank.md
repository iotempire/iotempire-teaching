# Resource Bank — Databases (DBS)

[← Back to front page](../README.md) | [Quick module index](./00-index.md)

Cheat sheets, troubleshooting, datasets, and extended reading. Everything here runs **locally and offline** unless noted.

## Command cheat sheet

### Toolchain setup with `uv` (Windows / macOS / Linux)

```sh
# install uv (once): macOS/Linux
curl -LsSf https://astral.sh/uv/install.sh | sh
# Windows (PowerShell):
#   powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"

uv python install 3.12           # download + manage a fixed Python
uv python pin 3.12               # pin it for this project (.python-version)
uv init --name databases-portfolio    # create the project (skip if pyproject.toml exists)
uv add duckdb datasette sqlite-utils pydantic sqlalchemy
uv tool install litecli          # global CLI tools (isolated)
uv tool install datasette
uv tool install sqlite-utils
uv sync                          # rebuild the environment from uv.lock (after a fresh clone)
uv run python script.py          # run anything inside the pinned environment
uvx datasette app.db             # run a tool without installing it
```

> Commit `pyproject.toml` and `uv.lock`; never commit `.venv/`. On Windows, get the `sqlite3` shell with `winget install SQLite.SQLite`, or just use the `litecli` / `sqlite-utils` tools.

### Python — SQLite (standard library)

```python
import sqlite3

conn = sqlite3.connect("app.db")
conn.row_factory = sqlite3.Row                 # access columns by name
conn.execute("PRAGMA foreign_keys = ON")       # OFF by default — turn it on every connection!
conn.execute("PRAGMA journal_mode = WAL")      # better read/write concurrency for local apps

# ALWAYS use bound parameters — never f-strings or %
conn.execute("INSERT INTO reading(sensor_id, ts, value) VALUES (?, ?, ?)", (1, "2026-03-01", 41.5))
rows = conn.execute("SELECT * FROM reading WHERE sensor_id = ?", (1,)).fetchall()
conn.commit()
```

### Python — DuckDB

```python
import duckdb

con = duckdb.connect()                          # in-process, no server
# Read a Parquet file directly (no import step):
con.execute("SELECT machine_id, SUM(cost) FROM 'jobpart.parquet' GROUP BY 1").fetchall()
# Attach a SQLite file as if it were native (and export it to Parquet):
con.execute("INSTALL sqlite")
con.execute("LOAD sqlite")
con.execute("ATTACH 'edge.db' AS edge (TYPE sqlite)")
con.execute("SELECT COUNT(*) FROM edge.reading").fetchall()
con.execute("COPY (SELECT * FROM edge.reading) TO 'readings.parquet' (FORMAT parquet)")
```

### CLI — SQLite & Datasette

```sh
sqlite3 app.db ".tables"                 # list tables
sqlite3 app.db ".schema reading"         # show DDL
sqlite3 app.db ".mode csv" ".import file.csv tbl"   # bulk import
sqlite3 app.db ".timer on"               # time each statement
sqlite3 app.db "EXPLAIN QUERY PLAN SELECT ..."
datasette app.db -o                      # browse in the browser; add ?_size=100 to page
sqlite-utils insert app.db tbl data.csv --csv
sqlite-utils memory data.csv "SELECT count(*) FROM data"   # query a CSV in one command
```

## Troubleshooting

| Symptom | Likely cause | Fix |
|---|---|---|
| `FOREIGN KEY constraint failed` never happens / orphans allowed | `PRAGMA foreign_keys` is **off** (default) | Run `PRAGMA foreign_keys = ON` on every connection. |
| `IntegrityError: NOT NULL` on a column you think is optional | Schema declares `NOT NULL` you forgot | Check `PRAGMA table_info(table)`. |
| Index exists but plan still says `SCAN` | Function wraps the column, or low cardinality, or the index expression does not match the query | Compare index expression to `WHERE`; remove the function (`done_on > '...'`, not `date(done_on) > '...'`). |
| `json_extract` returns the whole text | Path typo, or a single path returning a scalar in older builds | Check the path; use `meta ->> '$.key'` for a scalar. |
| A query with `NOT IN (subquery)` returns nothing | The subquery contains a `NULL` | Filter the `NULL`s or use `NOT EXISTS`. |
| Very slow ingest of many rows | One `INSERT` per row, commit per row | Wrap in a transaction; use `executemany`. |
| `database is locked` | Another writer holds the file; SQLite allows one writer | Enable WAL, shorten transactions, or serialize writers. |
| Wrong numbers after a join | Fan-out: a 1:n join multiplied rows before aggregation | Aggregate in a subquery first, then join. |

## Suggested practice datasets

- **The course's own generators** (Modules 1, 3, 5) — self-contained, no network needed.
- **NYC Taxi trips (Parquet)** — a standard analytical dataset for DuckDB Parquet demos (network required to download).
- **Sakila** — a classic sample relational schema (film rental), useful for join/aggregation practice.
- **The plant telemetry** you generate in Module 1 — extend it for the final project.
- **Your own data** — a study log, a budget, sensor readings from another course. The most meaningful datasets are the ones that matter to you.

## Extended reading

### Why local-first (and why the heavy three-tier default is questioned)

The claim that a full three-tier frontend/backend/cloud stack is overkill for a local app is not fringe — it is a documented industry shift. Key reading:

- Martin Kleppmann, Adam Wiggins, Peter van Hardenberg, Mark McGranaghan — *Local-First Software: You Own Your Data, in spite of the Cloud* (Ink & Switch, 2019) — [inkandswitch.com/essay/local-first](https://www.inkandswitch.com/essay/local-first/). The essay that named the movement and critiqued server-as-source-of-truth apps.
- SQLite — *Appropriate Uses For SQLite* — [sqlite.org/whentouse.html](https://www.sqlite.org/whentouse.html). The official framing: *“SQLite does not compete with client/server databases. SQLite competes with `fopen()`. ”*
- Ruby on Rails — *Rails 8.0: No PaaS Required* (2024) — [rubyonrails.org](https://rubyonrails.org/2024/11/7/rails-8-no-paas-required). A mainstream framework making SQLite the production default and removing the Redis / Postgres / PaaS dependencies for typical apps.
- htmx — *Locality of Behaviour* (Carson Gross) — [htmx.org/essays/locality-of-behaviour](https://htmx.org/essays/locality-of-behaviour/). The hypermedia revival that narrows the front-end/back-end split.
- Simon Willison — *Datasette: an ecosystem of tools for working with small data* (2021) — [simonwillison.net](https://simonwillison.net/2021/Jul/22/small-data/). *“Almost every data problem you have should be solved using SQLite.”*
- Martin Fowler — *MonolithFirst* (2015) — [martinfowler.com](https://martinfowler.com/bliki/MonolithFirst.html). Start simple; distribute only when a real need forces it.
- Anton Zhiyanov — *SQLite is not a toy database* (2021) — [antonz.org](https://antonz.org/sqlite-is-not-a-toy-database/).

> **For balance — when a server *is* the right tool.** The same SQLite guide lists the cases where [a client/server database is a better fit](https://www.sqlite.org/whentouse.html) (data on a separate device, high write concurrency, shared multi-user access), and [DuckDB's *Why DuckDB*](https://duckdb.org/why_duckdb.html) covers embedded analytics. Rule of thumb: choose the server when a *measured* requirement demands it — not by default.

### Embedded & local-first tooling
- SQLite — *Appropriate Uses For SQLite* — [sqlite.org/whentouse.html](https://www.sqlite.org/whentouse.html)
- DuckDB — *Why DuckDB* — [duckdb.org/why_duckdb.html](https://duckdb.org/why_duckdb.html)
- Simon Willison — *Datasette* — [simonwillison.net](https://simonwillison.net/2021/Jul/22/small-data/) · [datasette.io](https://datasette.io/)
- Local-first community — [localfirst.fm](https://localfirst.fm/)

**Modeling, normalization, integrity**
- SQLite — foreign keys · `STRICT` tables · generated columns — [sqlite.org/foreignkeys.html](https://www.sqlite.org/foreignkeys.html) · [stricttables.html](https://www.sqlite.org/stricttables.html) · [gencol.html](https://sqlite.org/gencol.html)
- Pydantic data validation — [docs.pydantic.dev](https://docs.pydantic.dev/) · SQLAlchemy — [docs.sqlalchemy.org](https://docs.sqlalchemy.org/)

**Querying & performance**
- SQLite — `EXPLAIN QUERY PLAN` — [sqlite.org/eqp.html](https://www.sqlite.org/eqp.html)
- Markus Winand — *Use The Index, Luke* — [use-the-index-luke.com](https://use-the-index-luke.com/)
- DuckDB — *Why DuckDB* — [duckdb.org/why_duckdb.html](https://duckdb.org/why_duckdb.html)

**Security & theory**
- OWASP — *SQL Injection Prevention Cheat Sheet* — [cheatsheetseries.owasp.org](https://cheatsheetseries.owasp.org/cheatsheets/SQL_Injection_Prevention_Cheat_Sheet.html)
- Martin Kleppmann — *Designing Data-Intensive Applications* (ACID, BASE, CAP)

### Goody: SQL practice games

A little fun on the side — no install, no account, purely in the browser. Perfect for building the **intuition** you need to sanity-check the SQL an LLM writes for you.

- **SQL Island** — [sql-island.informatik.uni-kl.de](https://sql-island.informatik.uni-kl.de/). A free, browser-based **text-adventure game** from the University of Kaiserslautern: you crash-land on an island and use SQL to survive — find food, get a job, make friends, and eventually escape. Along the way you practice `SELECT`, `WHERE`, `ORDER BY`, aggregates, and joins in about 1–2 hours. It is deliberately simplistic and its interface looks dated, but it is a genuinely effective, low-pressure way to get the SQL basics. Available in **English, German, Portuguese, and Spanish** (it defaults to German — switch the language in the settings or via the English link on the course page).
- **SQL Murder Mystery** — [mystery.knightlab.com](https://mystery.knightlab.com/). Solve a crime with SQL; a great follow-up once the island is behind you.
- **Lost at SQL** — [lost-at-sql.therobinlord.com](https://lost-at-sql.therobinlord.com/). A more modern, progressively harder learning game (beginner lessons plus “expert” challenges).

> **Suggested moment to play:** during or just after the SQL module. Spending an hour on SQL Island before wrestling with generated queries makes you much better at spotting a query that “runs but is wrong”.

## Software install (offline-friendly)

The course sets everything up with **`uv`** — see [Module 1](./01-introduction-and-local-first.md) for the step-by-step version:

```sh
uv python install 3.12
uv python pin 3.12
uv add duckdb datasette sqlite-utils pydantic sqlalchemy
uv tool install litecli datasette sqlite-utils
uv run python -c "import sys, sqlite3, duckdb; print(sys.version.split()[0], sqlite3.sqlite_version, duckdb.__version__)"
```

If you prefer plain pip, the same libraries install with:

```sh
pip install duckdb datasette sqlite-utils pydantic sqlalchemy
```

> [!TIP]
> Datasette Lite runs entirely in the browser (WASM) — useful if you cannot install anything: [lite.datasette.io](https://lite.datasette.io/).

---

[← Back to front page](../README.md) | [← Resource Prompts](./Y-resources-prompt-bank.md)
