# Module 1 — Introduction & Local-First Foundations

[← Course workbook](../README.md) | [Quick module index](./00-index.md) | [Next: Module 2 →](./02-data-contracts-and-legacy-schemas.md)

> **One question for the whole course:** *How does raw data become a trustworthy, fast, and safe answer — on a machine you actually own?*

**Course placement:** Session 1 — the first class. We open with a short introduction to **how this class works** (Part A), then run this module's studio in the same session, together and in person.

## 🎯 Learning Goals

> **How these are assessed:** You show that you have reached these goals in a short (~10-minute) checkpoint conversation with the instructor — based on your portfolio, not on completing every task. See the [syllabus](../syllabus.md#how-module-points-are-earned-checkpoint-presentations) for the assessment rules. **These learning goals are the contract between you and the instructor: demonstrate them, and you have met the module.** The tasks in this module are a draft — you are encouraged to modify, replace, or extend them as long as your alternative reaches the same goals. You may skip tasks, fail at some, or add your own; documented exploration and demonstrated deep understanding both count in your favor.

By the end of this module, you can:
1. Explain how this class works — the CBL/PBL philosophy, the portfolio-based *Kombinationsprüfung*, and the "moving bar" of a first-time course.
2. Set up your personal GitHub portfolio from the course template, with a clean first commit and a `.gitignore` that keeps databases and secrets out of Git.
3. Verify a working local-first data environment: Python 3.11+, the `sqlite3` CLI, DuckDB, and Datasette.
4. Explain — with a measurement, not a slide — the difference between an **embedded** database and a **client/server** database, and why most local apps should not run a server.
5. Load real rows into SQLite and query them from Python using **bound parameters**.
6. Take a first LLM-generated query, run it, and begin the habit that defines this course: **verify before you trust**.

> [!NOTE]
> Task tiers. Tasks marked ★ Core must be completed by everyone. Tasks marked ◇ Stretcher are optional and are the natural trim point if time runs short — they are excellent bonus-task material.

> [!WARNING]
> DRAFT — first taught in WS 2026/27 by an instructor who is **also teaching databases for the first time** and is learning this material alongside you. This class is deliberately in flux: it will change as we go, and different deep dives, alternative tasks, and stretchers are genuinely welcome — your input can shape this module.

**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 📖 Part A — How This Class Works (20 min, in the room)

Before any SQL, we agree on how we learn here. Three things:

**1. This is Challenge- and Project-Based Learning, not a lecture series.** We start from stories — a real problem that matters to a person — and build the data layer that solves it. You learn by doing, debugging, and demoing to one another. There is **no written exam**; your grade comes from a portfolio, short checkpoint conversations, reflections, and one meaningful team project (the *Kombinationsprüfung* from the module handbook).

**2. The "moving bar" — and why this course is in flux.** This is the first time I teach Databases, and it is being taught in the age of AI. So we do it honestly: the **learning goals at the top of each module are fixed** (they are what you are assessed on), but the **tasks below the draft boundary are a draft**. The boundary moves down as we approve content together. If you have a better way to reach a goal — a different dataset, a different engine, a deeper stretch — propose it. "I did it differently and here is the evidence" is a first-class answer in this class.

**3. AI is a tool you must verify, not an oracle.** You will use ChatGPT/Claude/DeepSeek (or a local model) throughout — to draft SQL, review schemas, and explain errors. What is graded is your *judgment*: does it run, is it correct, is it fast, is it safe? Every module has a "how did I verify AI suggestions?" step in its reflection.

> **The reward structure in one line:** documented, honest engineering — including failure — beats a neat but unexamined "it works".

Finally, a practical note: the class has **11 four-hour sessions**, plus **optional tutorial sessions** run by a teaching assistant (times announced via the LMS). Use them for catch-up, deeper practice, and project support.

## 📖 Story — The Server Nobody Needed

A small Gütersloh machine shop wants to monitor its CNC milling machines. A vendor proposes the classic setup: a cloud server, a PostgreSQL instance, a REST backend, a React frontend, and a monthly invoice. The plant manager — an HSBI Industrial Engineering alum — asks one question the vendor cannot answer cheaply: *"How many rows per day, and who else is reading this?"*

The answer: about **90,000 readings a day** (a temperature, a vibration RMS, and a spindle-load value every few seconds across three machines), read by **one** dashboard on the shop floor and **one** weekly shift report. That is a few hundred megabytes a year, touched by two readers, on a network that already exists. A three-tier cloud stack here is a **programming antipattern**: more moving parts, more failure modes, more cost, and no benefit. (For the industry consensus forming around this, see the [local-first manifesto](https://www.inkandswitch.com/essay/local-first/) and SQLite's own ["SQLite competes with `fopen()`"](https://www.sqlite.org/whentouse.html).)

What that plant actually needs is a database that runs **inside the monitoring script** — an embedded engine that speaks SQL, needs no administrator, cannot go "down", and travels with the data file. That engine is **SQLite**. In this first studio you will meet it the same way: load a couple of days of machine telemetry, query it, and profile the AI's first suggestion.

## 📖 Part B — Mini-Lecture: Embedded vs. Client/Server (15 min)

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

> [!TIP]
> **This is a documented industry shift, not a hobby opinion.** The [local-first manifesto](https://www.inkandswitch.com/essay/local-first/) named the movement; [Rails 8 made SQLite the production default and dropped the Redis/PaaS dependencies](https://rubyonrails.org/2024/11/7/rails-8-no-paas-required); and the hypermedia revival ([htmx's *Locality of Behaviour*](https://htmx.org/essays/locality-of-behaviour/)) is collapsing the front-end/back-end split for typical apps. The [resource bank](./Z-resources-bank.md#why-local-first-and-why-the-heavy-three-tier-default-is-questioned) has the full reading list — including when a server *is* the right tool.

**Why we still learn the "server" vocabulary.** The ANSI three-level architecture, transactions, ACID, and Codd's relational rules (the legacy introduction chapter) describe *all* relational systems. SQLite implements transactions and ACID perfectly well; understanding them here transfers directly to any server you meet later. And when a workload genuinely needs a server (Module 6), you will recognize it because you will have the measurement that proves it.

> [!TIP]
> SQLite is the most widely deployed database engine in the world — it is inside every phone, browser, and aircraft you use. "Embedded" is not "toy".

## 🛠️ In-Class Studio: Your First Local-First Database (60 min)

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
3. Create a folder `module-01/` in your portfolio. This is where all Module 1 evidence goes.

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

*Portfolio evidence:* a `module-01/environment-check.txt` with the command outputs, plus one sentence stating which engines you have working.

### ★ Task 3: Load real telemetry and query it from Python (20 min)

1. Save the following as `module-01/generate_telemetry.py`. It manufactures a few days of the machine-shop readings from the story — one reading every few seconds, three machines.

   ```python
   import csv, math, random
   from datetime import datetime, timedelta

   random.seed(42)
   machines = ["cnc-01", "cnc-02", "cnc-03"]
   start = datetime(2026, 1, 5, 6, 0, 0)          # Monday 06:00, shift start
   days = 2
   step = 3                                        # one reading every 3 s per machine
   points = days * 24 * 60 * 60 // step            # ~57,600 points x 3 machines

   with open("module-01/telemetry.csv", "w", newline="") as f:
       w = csv.writer(f)
       w.writerow(["ts", "machine", "temp_c", "vib_rms", "spindle_load"])
       for i in range(points):
           ts = (start + timedelta(seconds=i * step)).isoformat(sep=" ")
           for mach in machines:
               temp = 42 + 3 * math.sin(i / 500.0) + random.gauss(0, 0.6)
               vib = 1.2 + 0.4 * math.sin(i / 90.0) + random.gauss(0, 0.08)
               load = 60 + 15 * math.sin(i / 300.0) + random.gauss(0, 3)
               w.writerow([ts, mach, f"{temp:.2f}", f"{vib:.3f}", f"{load:.1f}"])
   print("wrote module-01/telemetry.csv")
   ```

2. Load it into SQLite. This is your first taste of an **ingestion pipeline** — the same pattern your final project will use:

   ```sh
   python3 module-01/generate_telemetry.py
   sqlite3 module-01/telemetry.db <<'SQL'
   DROP TABLE IF EXISTS readings;
   CREATE TABLE readings(
       ts           TEXT    NOT NULL,
       machine      TEXT    NOT NULL,
       temp_c       REAL    NOT NULL,
       vib_rms      REAL    NOT NULL,
       spindle_load REAL    NOT NULL
   );
   .mode csv
   .import --skip 1 module-01/telemetry.csv readings
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
   ls -lh module-01/telemetry.db
   sqlite3 module-01/telemetry.db "SELECT COUNT(*) FROM readings;"
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

3. Write down, in one short paragraph: **what the model got right, what it got wrong, and how you verified it.** This paragraph is a miniature of your reflection logbook and is your Module 1 AI-verification evidence.

*Portfolio evidence:* the exact prompt you used, the generated SQL, the `EXPLAIN QUERY PLAN` output, and your verification paragraph.

### ◇ Task 5 (Stretcher): Publish your data with Datasette

Turn the database into something a colleague can browse in a browser:

```sh
datasette module-01/telemetry.db -o
```

Explore the table, filter by machine, and export one filtered view as CSV. Note the URL of a single row.
*Portfolio evidence:* a screenshot of the Datasette table view and the exported CSV.

## ✅ What must be committed to your portfolio

Commit all of the following under `module-01/` after Session 1:

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

- Martin Kleppmann, Adam Wiggins, Peter van Hardenberg, Mark McGranaghan — *Local-First Software: You Own Your Data, in spite of the Cloud* (Ink & Switch, 2019) — [inkandswitch.com/essay/local-first](https://www.inkandswitch.com/essay/local-first/)
- SQLite — *Appropriate Uses For SQLite* — [sqlite.org/whentouse.html](https://www.sqlite.org/whentouse.html)
- Ruby on Rails — *Rails 8.0: No PaaS Required* (2024) — [rubyonrails.org](https://rubyonrails.org/2024/11/7/rails-8-no-paas-required)
- htmx — *Locality of Behaviour* — [htmx.org/essays/locality-of-behaviour](https://htmx.org/essays/locality-of-behaviour/)
- Simon Willison — *Datasette: an ecosystem of tools for working with small data* — [simonwillison.net/2021/Jul/22/small-data](https://simonwillison.net/2021/Jul/22/small-data)
- Anton Zhiyanov — *SQLite is not a toy database* (2021) — [antonz.org](https://antonz.org/sqlite-is-not-a-toy-database/)
- More (and the counter-arguments) in the [resource bank](./Z-resources-bank.md#why-local-first-and-why-the-heavy-three-tier-default-is-questioned)

---

[← Course workbook](../README.md) | [Quick module index](./00-index.md) | [Next: Module 2 — Data Contracts & Reading Legacy Schemas →](./02-data-contracts-and-legacy-schemas.md)
