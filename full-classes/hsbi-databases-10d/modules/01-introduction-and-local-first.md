<!--# Module 1 — Introduction & Local-First Foundations-->

[← Course workbook](../README.md) | [Quick module index](./00-index.md) | [Next: Module 2 →](./02-data-contracts-and-legacy-schemas.md)

**Course placement:** Session 1 — the first class. We open with a short introduction to **how this class works** (Part A), then run this module's studio in the same session, together and in person.

## 🎯 Learning Goals

By the end of this module, you can:
1. Explain how this class works — the CBL/PBL philosophy, the portfolio-based *Kombinationsprüfung*, and the "moving bar" of a first-time course.
2. Set up your personal GitHub portfolio from the course template, with a clean first commit and a `.gitignore` that keeps databases and secrets out of Git.
3. Set up the entire toolchain reproducibly with **`uv`** — one fixed Python plus SQLite, DuckDB, Datasette, and more — on Windows, macOS, or Linux, and verify it.
4. Explain — with a measurement, not a slide — the difference between an **embedded** database and a **client/server** database, and why most local apps should not run a server.
5. Load real rows into SQLite and query them from Python using **bound parameters**.
6. Take a first LLM-generated query, run it, and begin the habit that defines this course: **verify before you trust**.

**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 📖 Part A — Opening the Class (plain-Markdown slides)

**This session is presented from a plain-Markdown slide deck** — [`slides/01-introduction.md`](../slides/01-introduction.md). It opens in any Markdown viewer (Zed, GitHub, VS Code), and renders to a **16:9 PDF with `pandoc` + `typst`** — [`slides/render-slides.sh`](../slides/render-slides.sh) — which is presented fullscreen in **Okular**. Slides are separated by a `---` line, so the deck is just Markdown: easy to read, diff, and adapt. The opening runs in six beats:

1. **whoami — meet your lecturer.** Ulno: educator / consultant / mentor, researcher / inventor / maker / artist, YouTuber ([youtube.ulno.net](https://youtube.ulno.net/)); a globalist who has lived, taught, and researched in Estonia, the USA, Germany, Austria, Kazakhstan, Singapore, Indonesia, and Brazil; research in VR/AR, IoT, digital twins, software craftsmanship, and education; PhD on **home automation** (RWTH Aachen).
2. **Who are U? — a quick hand-count.** I ask, you raise a hand (and **note your answers — this is your first portfolio entry**): programming experience and languages; prior **SQL**; which **databases** you have used; **Python**; the **command line**; **Git/GitHub**; whether you have built a **web app** or run a **server**; and — the important one — **your expectations** from this class.
3. **"This is an experiment" — the deal.** We teach with modern, challenge- and project-based methods: you are here to learn and explore, you are front and center, and you bring a meaningful challenge. Logistics: usually **no dedicated homework** (but you finish lab work, module tasks, portfolio, and reflections); **you work in small Task Pods — two or three (three by default)** (a few pairs), and **two pods merge into a Project Team for the final project**; in-class exercises start individually; feedback is continuous in the lab; the final grade comes from **module points, the final project, and reflections**, all recorded in your **portfolio**.
4. **Everything lives in the online workbook.** We open the repository together: the **[module index & roadmap](./00-index.md)** (every module and session) and the **[syllabus](../syllabus.md)** (schedule, objectives, assessment, policies). This is where "how the class works" becomes concrete — see the contract below.
5. **Pod formation.** Last, we form **Task Pods** (see the pod note — three is the default for this cohort).
6. **Warm-up and discovery — the first pod exercise.** Right after you form pods: a quick warm-up (*what is a database?*, *why SQL?*, *a bit of local-first*) as a pod jigsaw, flowing straight into the Discovery exercise (*what two shapes can a database take?*). We collect your answers, then reveal the table.

### How the class works — the contract

**Here we open the [syllabus](../syllabus.md) together.** The full model lives there — the learning-goals contract, the *Kombinationsprüfung*, the ★/◇ task tiers, and the “draft in motion” boundary. The one-line version: each module **begins with its learning goals**, those goals are the *contract*, and the tasks are negotiable as long as you reach the goals.

**AI is a tool you must verify, not an oracle.** You will use Copilot/ChatGPT/Claude/DeepSeek (or a local model) throughout — to draft SQL, review schemas, and explain errors. What matters is your *judgment*: does it run, is it correct, is it fast, is it safe? Every module has a "how did I verify AI suggestions?" step in its reflection.

Practical note: the class has **11 four-hour sessions**, plus **optional tutorial sessions** run by a teaching assistant (times announced via the LMS).

### Form your Task Pod — who do you build with?

You will do the labs and the checkpoints in a **Task Pod** — two or three people (three by default for this cohort; a few **two-person pods** are welcome, since they cut the number of checkpoints the instructor must run; a fourth member only by arrangement). For the **final project, two pods merge into a Project Team of 4–6**. We do a short match-making round:

> **Why “Task Pod”?** In container orchestration (Kubernetes) a *pod* is the **smallest deployable unit** — a couple of tightly-coupled containers that are scheduled, run, and retired together. Your Task Pod is the same, for people: a tight little crew that owns one task end-to-end. Two pods later merge into a **Project Team**, the larger unit that ships the whole application.

1. On a note, write down **your skills** (languages, tools, hardware, design, …) and **your expectations / what you want to build**.
2. No pod yet? Find **two other unpaired people**, compare notes, and check whether you **complement** each other — not merely whether you are alike. A pod with complementary strengths beats a pod of clones.
3. Exchange contacts and a first idea today. If you already have a pod, still share your notes so the room knows who can help with what.

> [!TIP]
> **Checkpoints can run as a 2-pod practice round.** Two pods pair up: each presents its learning-goal proof while the other gives **free-style feedback and questions**, checking how well the goals were proven (the instructor assesses from the presentations and portfolios). See the [syllabus](../syllabus.md#how-module-points-are-earned-checkpoint-presentations). A pod you practise with is also a natural **Project Team partner** — the project merges two pods into a Project Team of 4–6.

> [!NOTE]
> **Instructor hint — presenting the deck.** The slides are plain Markdown ([`slides/01-introduction.md`](../slides/01-introduction.md)). Read them in any Markdown viewer (Zed, GitHub — `---` shows as a horizontal rule), or render a 16:9 PDF and present it fullscreen: `./slides/render-slides.sh slides/01-introduction.md` builds the PDF with **pandoc + Typst** and opens it in **Okular's presentation mode**. From Zed, use the task *“Slides → PDF (pandoc + Typst) + Okular”* (command palette → `task: spawn`) to render the current file. HTML comments (`<!-- Note: … -->`) are dropped from the PDF, so keep speaker hints there; the discovery answer sits on the slide *after* the prompt, so reveal it by advancing. There is no notebook runtime and no build step — run the Python on demand from your `uv` environment. Full hints in the [resource bank](./Z-resources-bank.md#instructor-hints-presenting-the-markdown-slide-deck).

## 📖 Story — The Server Nobody Needed

**Wittkamp Zerspanung GmbH** is a small machine shop in Gütersloh that wants to monitor its CNC milling machines. The vendor **Cirrus Cloud Systems** proposes the classic setup: a cloud server, a PostgreSQL instance, a REST backend, a React frontend, and a monthly invoice. The plant manager, **Kai Lehmann** — an HSBI Industrial Engineering alum — asks one question the vendor cannot answer cheaply: *"How many rows per day, and who else is reading this?"*

The answer: about **90,000 readings a day** (a temperature, a vibration RMS, and a spindle-load value every few seconds across three machines), read by **one** dashboard on the shop floor and **one** weekly shift report. That is a few hundred megabytes a year, touched by two readers, on a network that already exists. A three-tier cloud stack here is a **programming antipattern**: more moving parts, more failure modes, more cost, and no benefit. (For the industry consensus forming around this, see the [local-first manifesto](https://www.inkandswitch.com/essay/local-first/) and SQLite's own ["SQLite competes with `fopen()`"](https://www.sqlite.org/whentouse.html).)

What Wittkamp actually needs is a database that runs **inside the monitoring script** — an embedded engine that speaks SQL, needs no administrator, cannot go "down", and travels with the data file. That engine is **SQLite**. In this first studio you will meet it the same way: load a couple of days of machine telemetry, query it, and profile the AI's first suggestion.

## 📖 Part B — Discovery: Embedded vs. Client/Server

Instead of a slide that tells you the answer, we **figure it out together** — you may already know more than you think.

**In your pod, a few minutes:**

1. **Brainstorm.** When does a database live *inside* your program, and when does it live on a *separate server*? Give each shape a name.
2. **List trade-offs.** Write **one advantage and one cost** for each shape — think about installation, reliability, concurrency, cost, and who owns the data.
3. **Search (optional).** Look up two concrete engines for each shape — e.g. an embedded one and a client/server one — and one sentence on when to use each.
4. **Jigsaw.** One of you joins a neighbouring pod, the rest stay. **Merge your two lists**, drop duplicates, and mark whatever you disagree on.

Wait before you scroll on and do first soem thinking at your own.

Then the instructor reveals the table and we compare:

**Two shapes of a database:**

| | Embedded (SQLite, DuckDB) | Client/server (MySQL, PostgreSQL) |
|---|---|---|
| Where it runs | Inside your process, as a library | A separate server process you connect to |
| Admin needed | None | Users, auth, backups, tuning, upgrades |
| Reliability | "Down" is not a state — no server to fall over | Network + server + credentials are failure modes |
| Concurrency model | Many readers, **one writer** at a time | Many concurrent writers |
| Sweet spot | Local apps, edge devices, single-node analytics, tests | Many concurrent clients, networked multi-user apps |
| Cost | Zero infrastructure | A server, an operator, a bill |

**Did your version beat ours?** If your jigsaw found something the table misses — backup strategy, latency, offline work, or total cost of ownership — **add it**. The table is a draft, exactly like the tasks.

**The local-first principle.** Keep the data on the machine that produces and consumes it. Ship a file, not a deployment. Go to a server only when a *measured* requirement — concurrent writers, geographic distribution, or a shared multi-tenant service — forces you to. Real systems now bet on exactly this: an entire Fediverse server ([GoToSocial](https://gotosocial.org), SQLite by default) and a whole team-chat platform ([Chatto](https://www.hmans.dev/blog/chatto)) each ship as a **single binary**, no separate database service — see the [case-study side task in Module 6](./06-polyglot-embedded-persistence.md).

> [!TIP]
> **This is a documented industry shift, not a hobby opinion.** The [local-first manifesto](https://www.inkandswitch.com/essay/local-first/) named the movement; [Rails 8 made SQLite the production default and dropped the Redis/PaaS dependencies](https://rubyonrails.org/2024/11/7/rails-8-no-paas-required); and the hypermedia revival ([htmx's *Locality of Behaviour*](https://htmx.org/essays/locality-of-behaviour/)) is collapsing the front-end/back-end split for typical apps. The [resource bank](./Z-resources-bank.md#why-local-first-and-why-the-heavy-three-tier-default-is-questioned) has the full reading list — including when a server *is* the right tool.

**Why we still learn the "server" vocabulary.** The ANSI three-level architecture, transactions, ACID, and Codd's relational rules (the legacy introduction chapter) describe *all* relational systems. SQLite implements transactions and ACID perfectly well; understanding them here transfers directly to any server you meet later. And when a workload genuinely needs a server (Module 6), you will recognize it because you will have the measurement that proves it.

> [!TIP]
> SQLite is the most widely deployed database engine in the world — it is inside every phone, browser, and aircraft you use. "Embedded" is not "toy".

## 🛠️ In-Class Studio: Your First Local-First Database — **Challenging**

*Software:* a laptop with Python 3.11+ and Git. You will use a terminal for the SQL labs, but you can do the Git work from your editor or the browser. No server, no admin rights required.

### ★ Task 1: Form your pod and create your portfolio

1. **Team up first.** Form your **Task Pod** (two or three people — see *Form your Task Pod* above). Exchange contacts and agree how you will keep in touch.
2. **Create your own repo from the template — “Use this template”, not “Fork”.** On GitHub, open the [iot-portfolio-template](https://github.com/iotempire/iot-portfolio-template) and click **Use this template → Create a new repository**. Name it e.g. `databases-portfolio`, and make it **public** (or at least readable by the instructor). *(A template gives you a fresh repo with one clean commit and no upstream link; a fork keeps a link and the full history — not what a personal portfolio wants. See the [Git & GitHub primer](./Z-resources-bank.md#git--github-primer-template-editor-markdown-conflicts).)*
3. **Make it yours — turn the generic template into your own HSBI Databases portfolio.** Change everything directly visible: the README title and description, your name, the links, and any template placeholders. It should read as *your* HSBI Databases portfolio, not the stock `iot-portfolio-template` copy.
4. **Add your instructor as a collaborator** (repo → *Settings → Collaborators → Add people*). Use the address your instructor posts in the LMS.
5. **Add this module's learning goals.** Create `module-01/README.md` and copy the *Learning Goals* from the top of this page into it, with a one-line note of what you plan to explore.
6. **Verify the `.gitignore`** keeps data and secrets out of Git. If needed, add:
   ```gitignore
   # local data and secrets stay out of the repository
   .venv/
   *.db
   *.db-journal
   *.duckdb
   *.parquet
   .env
   __pycache__/
   ```
7. **Commit and check in** with a message like `Add module 01 learning goals`.

*Portfolio evidence:* the link to **your** repository, the instructor listed as a collaborator, and your first commit.

### ★ Task 2: Git & Markdown proficiency in the pod

Git here is a *habit*, not a command list — and you can do all of it from your editor or the browser (see the [Git & GitHub primer](./Z-resources-bank.md#git--github-primer-template-editor-markdown-conflicts)).

1. **Several small commits** across the session, each message saying *what* changed (e.g. `Add uv-check output`, `Fix telemetry query`).
2. **Write Markdown with interlinks.** In `module-01/README.md`, link to your pod mates' portfolios, the [syllabus](../syllabus.md), the module you are working on, and any shared artifact. Markdown — headings, lists, tables, links — *is* the deliverable.
3. **Work as a pod, and say who did what.** Split tasks; if you did **not** do something entirely on your own, **link** the pod mate or source you worked with. **Audit each other** (run their query, read their plan) and **change roles often** — take turns being the one who commits, checks, and explains.

*Portfolio evidence:* a short commit history, and a Markdown page with at least three working interlinks (including one to a pod mate's portfolio).

### ★ Task 3: Install your whole toolchain with `uv`

One tool, three platforms. **`uv`** (from Astral) installs a **fixed Python version**, creates an isolated environment, and installs every library and command-line tool this course uses — SQLite tooling, DuckDB, Datasette, and more — with the *same commands* on Windows, macOS, and Linux. Do this inside your portfolio repo, so your environment is part of your reproducible evidence.

**1. Install `uv` (once per machine).**

- **macOS / Linux:**
  ```sh
  curl -LsSf https://astral.sh/uv/install.sh | sh
  ```
- **Windows (PowerShell):**
  ```powershell
  powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
  ```
- Or via a package manager: `brew install uv` (macOS), `winget install --id=astral-sh.uv -e` (Windows), `scoop install uv` (Windows).

Open a **new** terminal and confirm: `uv --version`.

**2. Pin the Python we use and add every library at once.** Run this at the root of your portfolio repo:

```sh
uv init --name databases-portfolio     # skip if a pyproject.toml already exists
uv python install 3.14                 # uv downloads and manages the fixed Python
uv python pin 3.14                     # writes .python-version
uv add duckdb datasette sqlite-utils pydantic sqlalchemy
```

`uv` resolves everything, writes `pyproject.toml`, creates an isolated `.venv/`, and locks exact versions in `uv.lock`.

**3. Install the command-line tools globally** (isolated, available from any folder):

```sh
uv tool install litecli       # a friendly interactive SQLite shell
uv tool install datasette     # explore/publish SQLite databases
uv tool install sqlite-utils  # SQLite from the command line
```

**4. Verify everything with one script (your first Python test).** Save this as `uv-check.py` in your portfolio and run it *inside the project*:

```python
import sys, platform, sqlite3
from importlib.metadata import version, PackageNotFoundError

print("uv-managed Python:", sys.executable)
print("python            ", platform.python_version())
print("sqlite (stdlib)   ", sqlite3.sqlite_version)
for pkg in ("duckdb", "datasette", "sqlite-utils", "pydantic", "sqlalchemy"):
    try:
        print(f"{pkg:18s}", version(pkg))
    except PackageNotFoundError:
        print(f"{pkg:18s}", "NOT INSTALLED")
```

```sh
uv run uv-check.py
```

> [!NOTE]
> **Run Python through `uv run`.** From here on, run Python as `uv run python yourscript.py` (or `uv run uv-check.py`) instead of `python3`. That guarantees everyone uses the same fixed Python and the pinned libraries — no “works on my machine”.
>
> **The `sqlite3` command-line shell.** macOS and most Linux distributions ship a `sqlite3` shell; Windows does not. Install it (`winget install SQLite.SQLite` or `scoop install sqlite` on Windows), or use the `litecli` / `sqlite-utils` tools `uv` just installed — they cover the same ground. Everything also works through Python's built-in `sqlite3` module with no shell at all.
>
> **`uvx` (run without installing).** `uvx datasette module-01/telemetry.db` runs a tool on the fly — handy for a quick look without a permanent install.

*Portfolio evidence:* the `uv run uv-check.py` output, plus committed `pyproject.toml` and `uv.lock` files (do **not** commit `.venv/`).

> [!NOTE]
> **Prefer Anaconda? (we mention this once.)** We use [**`uv`**](https://docs.astral.sh/uv/) in this class because it is modern, fast, and a single tool for the whole job — the Python version, the isolated environment, and the packages. If you already live in **Anaconda**, you can translate every `uv` step in this course to `conda`/`pip`; nothing later depends on `uv` specifically.
>
> | `uv` (this class) | Anaconda equivalent |
> |---|---|
> | `uv python install 3.12` | `conda create -n databases python=3.12` |
> | `uv python pin 3.12` | (the environment pins the version for you) |
> | `uv add duckdb datasette sqlite-utils pydantic sqlalchemy` | `conda activate databases` then `pip install duckdb datasette sqlite-utils pydantic sqlalchemy` |
> | `uv tool install litecli` | `pip install litecli` (or `pipx install litecli`) |
> | `uv run python script.py` | `python script.py` (with the environment activated) |
>
> Read every `uv run python …` below as “run Python inside your course environment” — in Anaconda, activate the environment and run `python …` instead.

### ★ Task 4: Play SQL Island (~30 minutes)

Before you write any generated SQL, build some *intuition* by playing a game. [SQL Island](https://sql-island.informatik.uni-kl.de/) is a free, browser-based text adventure that teaches the basics of SQL — no install, no account. (It defaults to German; switch the language in the menu.)

Play for about **30 minutes**, then answer these **tutorial questions** in `module-01/sql-island.md` — your first “what have I learned?” reflection:

1. **What have you learned about databases and SQL so far, just by playing?** (Answer from the game alone — no looking things up.)
2. Which SQL commands and patterns did you actually use (`SELECT`, `WHERE`, `ORDER BY`, joins, aggregate functions, …)?
3. In your own words — after playing — what is a table, a row, a column, and a query?
4. What surprised you? What is still confusing?

Then continue with the next tasks — but **leave the SQL Island tab open and finish the game at home**; you do not have to reach the end in class.

*Portfolio evidence:* `module-01/sql-island.md` with your answers. (More practice games are in the [resource bank](./Z-resources-bank.md#goody-sql-practice-games).)

### ★ Task 5: Load real telemetry and query it from Python

1. Save the following as `module-01/generate_telemetry.py`. It manufactures a few days of machine-shop readings from the Wittkamp story — one reading every few seconds, three machines.

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
   uv run python module-01/generate_telemetry.py
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

### ★ Task 6: The first LLM-assisted SQL profiling task

This is the habit the whole course is built on.

1. Ask your preferred LLM (ChatGPT, Claude, DeepSeek, or a local model) for a query **against your schema**. Use a prompt like:

   > "Here is my SQLite table: `readings(ts TEXT, machine TEXT, temp_c REAL, vib_rms REAL, spindle_load REAL)`. Write a query that returns, for each machine, the average spindle load for readings taken overnight (after 18:00), ordered by average load descending."

2. **Do not trust the answer yet.** Do all three of the following and record what happened:
   - **Run it.** Does it execute? If it errors, paste the error back to the model and iterate.
   - **Profile it.** Prefix it with `EXPLAIN QUERY PLAN` and note whether you see `SCAN readings` (full-table scan).
   - **Break it.** Find a way the generated query could be wrong — a wrong time boundary, a missing `GROUP BY`, a column typo, or (most instructive) a string-vs-datetime comparison mistake (`ts` is text; `ts > '2026-01-05 18:00:00'` works, but a sloppy `LIKE '%18%'` does not).

3. Write down, in one short paragraph: **what the model got right, what it got wrong, and how you verified it.** This paragraph is a miniature of your reflection logbook and is your Module 1 AI-verification evidence.

*Portfolio evidence:* the exact prompt you used, the generated SQL, the `EXPLAIN QUERY PLAN` output, and your verification paragraph.

### ◇ Task 7 (Stretcher): Publish your data with Datasette

Turn the database into something a colleague can browse in a browser:

```sh
datasette module-01/telemetry.db -o
```

Explore the table, filter by machine, and export one filtered view as CSV. Note the URL of a single row.
*Portfolio evidence:* a screenshot of the Datasette table view and the exported CSV.

## ✅ What must be committed to your portfolio

Commit the following after Session 1 (the `uv` project files sit at the repository root; the rest under `module-01/`):

- [ ] Your own repo **created from the template** (public / instructor-readable) with the **instructor added as a collaborator**.
- [ ] A clean `.gitignore` (database and secret files stay out of Git).
- [ ] A short **commit history** with descriptive messages, and a Markdown page with working **interlinks** (including one to a pod mate's portfolio).
- [ ] `module-01/README.md` with this module's **learning goals**.
- [ ] `module-01/sql-island.md` — your answers to the tutorial questions.
- [ ] `pyproject.toml` and `uv.lock` (reproducible `uv` environment; **`.venv/` stays out of Git**).
- [ ] `uv-check.py` and its `uv run uv-check.py` output.
- [ ] `generate_telemetry.py` — the telemetry generator.
- [ ] `telemetry.db` size + row count (a screenshot or text file; **do not commit the `.db` file itself**).
- [ ] Query outputs for Tasks 5 and 6, with timings.
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
- **A fun side read:** [Fossil vs Git — the architectural irony](./Z-resources-bank.md#side-reading-fossil-vs-git--the-architectural-irony) — why SQLite's author doesn't use Git, and why that mirrors SQLite-vs-PostgreSQL.
- More (and the counter-arguments) in the [resource bank](./Z-resources-bank.md#why-local-first-and-why-the-heavy-three-tier-default-is-questioned)

---

[← Course workbook](../README.md) | [Quick module index](./00-index.md) | [Next: Module 2 — Data Contracts & Reading Legacy Schemas →](./02-data-contracts-and-legacy-schemas.md)
