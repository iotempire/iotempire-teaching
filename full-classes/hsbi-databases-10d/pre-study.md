# Module 0 — Pre-Study: Portfolio Setup & the Local-First Paradigm

[← Course workbook](./README.md) | [Quick module index](./modules/00-index.md) | [Next: Module 1 →](./modules/01-data-contracts-and-legacy-schemas.md)

> **One question for the whole course:** *How does raw data become a trustworthy, fast, and safe answer — on a machine you actually own?*

> **Canonical source:** [IoTempire Teaching repository — HSBI/GT Databases](https://github.com/iotempire/iotempire-teaching/tree/main/full-classes/hsbi-databases-10d)

## 🎯 Learning Goals

> **How these are assessed:** Module 0 is worth **1 module point**, assessed in Session 2. You show the instructor your portfolio, your environment check, and your first LLM-assisted profiling task. Incomplete-but-honest work beats a copied screenshot.

By the end of this module, you can:
1. Set up your personal GitHub portfolio from the course template, with a clean first commit and a `.gitignore` that keeps databases and secrets out of Git.
2. Verify a working local-first data environment: Python 3.11+, the `sqlite3` CLI, DuckDB, and Datasette.
3. Explain — with a measurement, not a slide — the difference between an **embedded** database and a **client/server** database, and why most local apps should not run a server.
4. Load real rows into SQLite and query them from Python using **bound parameters**.
5. Take a first LLM-generated query, run it, and begin the habit that defines this course: **verify before you trust**.

> [!NOTE]
> Task tiers. Tasks marked ★ Core must be completed by everyone. Tasks marked ◇ Stretcher are optional and are the natural trim point if time runs short — they are excellent bonus-task material.

> [!WARNING]
> DRAFT — first taught in WS 2026/27. Everything below the draft boundary is a working draft and will likely change as we refine it together in class; the line moves down as we approve content. Your input is welcome and can shape this module.

## 📖 Story — The Server Nobody Needed

A small Gütersloh machine shop wants to monitor its CNC milling machines. A vendor proposes the classic setup: a cloud server, a PostgreSQL instance, a REST backend, a React frontend, and a monthly invoice. The plant manager — an HSBI Industrial Engineering alum — asks one question the vendor cannot answer cheaply: *"How many rows per day, and who else is reading this?"*

The answer: about **90,000 readings a day** (a temperature, a vibration RMS, and a spindle-load value every few seconds across three machines), read by **one** dashboard on the shop floor and **one** weekly shift report. That is a few hundred megabytes a year, touched by two readers, on a network that already exists. A three-tier cloud stack here is a **programming antipattern**: more moving parts, more failure modes, more cost, and no benefit.

What that plant actually needs is a database that runs **inside the monitoring script** — an embedded engine that speaks SQL, needs no administrator, cannot go "down", and travels with the data file. That engine is **SQLite**. In this pre-study you will meet it the same way: load a couple of days of machine telemetry, query it, and profile the AI's first suggestion.

## 📖 Part A — Mini-Lecture: Embedded vs. Client/Server (15 min)

This is the conceptual core of the whole course, so read it before Session 1.

**Two shapes of a database:**

| | Embedded (SQLite, DuckDB) | Client/server (MySQL, PostgreSQL) |
|---|---|---|
| Where it runs | Inside your process, as a library | A separate server process you connect to |
| Admin needed | None | Users, auth, backups, tuning, upgrades |
| Reliability | "Down" is not a state — no server to fall over | Network + server + credentials are failure modes |
| Concurrency model | Many readers, **one writer** at a time | Many concurrent writers |
| Sweet spot | Local apps, edge devices, single-node analytics, tests | Many concurrent clients, networked multi-user apps |
| Cost | Zero infrastructure | A server, an operator, a bill |

**The local-first principle.** Keep the data on the machine that produces and consumes it. Ship a file, not a deployment. Go to a server only when a *measured* requirement — concurrent writers, geographic distribution, or a shared multi-tenant service — forces you to.

**Why we still learn the "server" vocabulary.** The ANSI three-level architecture, transactions, ACID, and Codd's relational rules (Module 0–1 reading) describe *all* relational systems. SQLite implements transactions and ACID perfectly well; understanding them here transfers directly to any server you meet later. And when a workload genuinely needs a server (Module 5), you will recognize it because you will have the measurement that proves it.

> [!TIP]
> SQLite is the most widely deployed database engine in the world — it is inside every phone, browser, and aircraft you use. "Embedded" is not "toy".

## 📖 Part B — The Four Facts to Take Away

1. **A database is a program, not a place.** Embedded engines prove it: the engine is a library, the data is one file.
2. **Measure before you architect.** "90k rows/day, two readers" is enough to reject a cloud stack. A benchmark is cheaper than a server.
3. **SQL is the portable skill.** The same `SELECT`, `JOIN`, and `GROUP BY` you write against SQLite run against PostgreSQL, DuckDB, and SQL Server.
4. **AI proposes, you dispose.** An LLM will happily write SQL for columns that do not exist. Your verifier — the query plan and the row count — is the real deliverable.

## 🛠️ Studio Lab (60 min, complete before Session 1)

*Software:* a laptop with Python 3.11+, Git, and a terminal. No server, no admin rights required.

### ★ Task 1: Fork your portfolio (15 min)

1. Fork the [iot-portfolio-template](https://github.com/iotempire/iot-portfolio-template) into your own GitHub account and clone it locally.
2. Confirm the `.gitignore` keeps data and secrets out of Git. If it does not, add (or verify) these lines:
   ```gitignore
   # local data and secrets stay out of the repository
   *.db
   *.db-journal
   *.duckdb
   *.parquet
   .env
   __pycache__/
   ```
3. Create a folder `module-00/` in your portfolio. This is where all Module 0 evidence goes.

*Portfolio evidence:* the link to your forked repository and a screenshot of `git log --oneline` showing your first commit.

### ★ Task 2: Environment check (15 min)

Run each of the following and save the output. If a tool is missing, install it (`pip install duckdb datasette`) and note what you did.

```sh
python3 --version          # expect 3.11 or newer
sqlite3 --version          # expect 3.38 or newer (JSON1 built in)
python3 -c "import sqlite3; print('sqlite3 module', sqlite3.sqlite_version)"
python3 -c "import duckdb; print('duckdb', duckdb.__version__)"
datasette --version
git --version
```

Then prove the embedded engine needs no server by creating and reading a database **with no server running**:

```sh
sqlite3 edge.db "CREATE TABLE ping(t TEXT); INSERT INTO ping VALUES (datetime('now'));"
sqlite3 edge.db "SELECT 'hello from ' || sqlite_version() || ' at ' || t FROM ping;"
rm -f edge.db   # clean up
```

*Portfolio evidence:* a `module-00/environment-check.txt` with the command outputs, plus one sentence stating which engines you have working.

### ★ Task 3: Load real telemetry and query it from Python (20 min)

1. Save the following as `module-00/generate_telemetry.py`. It manufactures a few days of the machine-shop readings from the story — one reading every few seconds, three machines.

   ```python
   import csv, math, random
   from datetime import datetime, timedelta

   random.seed(42)
   machines = ["cnc-01", "cnc-02", "cnc-03"]
   start = datetime(2026, 1, 5, 6, 0, 0)          # Monday 06:00, shift start
   days = 2
   step = 3                                        # one reading every 3 s per machine
   points = days * 24 * 60 * 60 // step            # ~57,600 points x 3 machines

   with open("module-00/telemetry.csv", "w", newline="") as f:
       w = csv.writer(f)
       w.writerow(["ts", "machine", "temp_c", "vib_rms", "spindle_load"])
       for i in range(points):
           ts = (start + timedelta(seconds=i * step)).isoformat(sep=" ")
           for mach in machines:
               temp = 42 + 3 * math.sin(i / 500.0) + random.gauss(0, 0.6)
               vib = 1.2 + 0.4 * math.sin(i / 90.0) + random.gauss(0, 0.08)
               load = 60 + 15 * math.sin(i / 300.0) + random.gauss(0, 3)
               w.writerow([ts, mach, f"{temp:.2f}", f"{vib:.3f}", f"{load:.1f}"])
   print("wrote module-00/telemetry.csv")
   ```

2. Load it into SQLite. This is your first taste of an **ingestion pipeline** — the same pattern your final project will use:

   ```sh
   python3 module-00/generate_telemetry.py
   sqlite3 module-00/telemetry.db <<'SQL'
   DROP TABLE IF EXISTS readings;
   CREATE TABLE readings(
       ts           TEXT    NOT NULL,
       machine      TEXT    NOT NULL,
       temp_c       REAL    NOT NULL,
       vib_rms      REAL    NOT NULL,
       spindle_load REAL    NOT NULL
   );
   .mode csv
   .import --skip 1 module-00/telemetry.csv readings
   SQL
   ```

3. Answer the shop manager's real questions. Run each query in the `sqlite3` shell and save the output. Note how long each takes by wrapping it with `.timer on`:

   ```sql
   .timer on
   -- 1. How many readings per machine?
   SELECT machine, COUNT(*) AS n FROM readings GROUP BY machine;

   -- 2. What was the peak vibration per machine in these two days?
   SELECT machine, MAX(vib_rms) AS peak_vib FROM readings GROUP BY machine;

   -- 3. How many readings exceeded a 2.0 mm/s vibration alarm?
   SELECT COUNT(*) FROM readings WHERE vib_rms > 2.0;
   ```

4. Now prove the "embedded, no server" claim numerically: report how big `telemetry.db` is and how many rows it holds.

   ```sh
   ls -lh module-00/telemetry.db
   sqlite3 module-00/telemetry.db "SELECT COUNT(*) FROM readings;"
   ```

*Portfolio evidence:* the generator script, the `.db` file size and row count, and the three query results. One sentence: *what would this dataset cost to run in the cloud, and who would pay for it?*

### ★ Task 4: The first LLM-assisted SQL profiling task (10 min)

This is the habit the whole course is built on.

1. Ask your preferred LLM (ChatGPT, Claude, DeepSeek, or a local model) for a query **against your schema**. Use a prompt like:

   > "Here is my SQLite table: `readings(ts TEXT, machine TEXT, temp_c REAL, vib_rms REAL, spindle_load REAL)`. Write a query that returns, for each machine, the average spindle load for readings taken overnight (after 18:00), ordered by average load descending."

2. **Do not trust the answer yet.** Do all three of the following and record what happened:
   - **Run it.** Does it execute? If it errors, paste the error back to the model and iterate.
   - **Profile it.** Prefix it with `EXPLAIN QUERY PLAN` and note whether you see `SCAN readings` (full-table scan).
   - **Break it.** Find a way the generated query could be wrong — a wrong time boundary, a missing `GROUP BY`, a column typo, or (most instructive) a string-vs-datetime comparison mistake (`ts` is text; `ts > '2026-01-05 18:00:00'` works, but a sloppy `LIKE '%18%'` does not).

3. Write down, in one short paragraph: **what the model got right, what it got wrong, and how you verified it.** This paragraph is a miniature of your reflection logbook and is your Module 0 AI-verification evidence.

*Portfolio evidence:* the exact prompt you used, the generated SQL, the `EXPLAIN QUERY PLAN` output, and your verification paragraph.

### ◇ Task 5 (Stretcher): Publish your data with Datasette

Turn the database into something a colleague can browse in a browser:

```sh
datasette module-00/telemetry.db -o
```

Explore the table, filter by machine, and export one filtered view as CSV. Note the URL of a single row.
*Portfolio evidence:* a screenshot of the Datasette table view and the exported CSV.

## ✅ What must be committed to your portfolio

Commit all of the following under `module-00/` before Session 1:

- [ ] Forked portfolio repository, with a clean `.gitignore` and a first descriptive commit.
- [ ] `environment-check.txt` — versions of Python, SQLite, DuckDB, Datasette, Git.
- [ ] `generate_telemetry.py` — the telemetry generator.
- [ ] `telemetry.db` size + row count (a screenshot or a text file; **do not commit the `.db` file itself**).
- [ ] Query outputs for Tasks 3 and 4, with timings.
- [ ] Your one-paragraph **AI verification** note (what the model got right/wrong and how you checked).
- [ ] `reflection.md` — your first logbook entry in the course format: *What worked? What broke? How did my mental model shift? How did I verify AI suggestions?*
- [ ] (Stretcher) Datasette screenshot and exported CSV.

> [!IMPORTANT]
> Never commit `*.db`, `*.duckdb`, or `.env` files. A reviewer must be able to rebuild your database from your scripts — that reproducibility is part of the assessment.

## 📚 If you want to go deeper

- SQLite — *When to use SQLite* — [sqlite.org/whentouse.html](https://www.sqlite.org/whentouse.html)
- SQLite — *Appropriate uses for SQLite* (the "client/server" contrast) — [sqlite.org/whentouse.html](https://www.sqlite.org/whentouse.html)
- Simon Willison — *Datasette: an ecosystem of tools for working with small data* — [simonwillison.net/2021/Jul/22/small-data](https://simonwillison.net/2021/Jul/22/small-data)
- Local-first software — [inkandswitch.com/local-first](https://www.inkandswitch.com/local-first/)

---

[← Course workbook](./README.md) | [Next: Module 1 — Data Contracts & Reading Legacy Schemas →](./modules/01-data-contracts-and-legacy-schemas.md)
