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

uv python install 3.14           # download + manage a fixed Python (3.14 = tested with this stack)
uv python pin 3.14               # pin it for this project (.python-version)
uv init --name databases-portfolio    # create the project (skip if pyproject.toml exists)
uv add duckdb datasette sqlite-utils pydantic sqlalchemy
uv tool install litecli          # global CLI tools (isolated)
uv tool install datasette
uv tool install sqlite-utils
uv sync                          # rebuild the environment from uv.lock (after a fresh clone)
uv run python script.py          # run anything inside the pinned environment
uvx datasette app.db             # run a tool without installing it
```

> Commit `pyproject.toml` and `uv.lock`; never commit `.venv/`. The **`sqlite3` shell** is built into macOS and most Linux distros; on Windows install it (`winget install SQLite.SQLite`, `scoop install sqlite`, or use WSL/Git Bash). Pin the Python by hand (`uv python pin 3.14`); let `uv.lock` pin the libraries.

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
sqlite3 -cmd ".mode csv" -cmd ".import file.csv tbl" app.db   # bulk import (dot-commands need -cmd for one-shot runs)
sqlite3 -cmd ".timer on" app.db "SELECT ..."   # time one statement (dot-commands are settings, not SQL)
sqlite3 app.db "EXPLAIN QUERY PLAN SELECT ..."
datasette app.db -o                      # browse in the browser; add ?_size=100 to page
sqlite-utils insert app.db tbl data.csv --csv
sqlite-utils memory data.csv "SELECT count(*) FROM data"   # query a CSV in one command
```

### Measuring query time

`EXPLAIN QUERY PLAN` shows *what* the planner will do; timing shows *how long* it took. You want both. There is no single command that works everywhere — use the one that fits where you are:

| Where you are | How to time it |
|---|---|
| **`sqlite3` shell** | `.timer on` on its own line. Prints a `Run Time: real … user … sys …` line after each statement (it goes to the normal output, so `.output` and redirects capture it). It is **CPU** time, not wall-clock. |
| **One-shot `sqlite3`** | Dot-commands are *settings*, not SQL — pass them with `-cmd`: `sqlite3 -cmd ".timer on" app.db "SELECT …"`. |
| **macOS / Linux CLI** | `time sqlite3 app.db "SELECT …"` (wall-clock; includes a few ms of process start-up). |
| **Windows PowerShell** | `Measure-Command { sqlite3 app.db "SELECT …" }`. |
| **Python (portable, recommended)** | `time.perf_counter()` around the query — wall-clock, works on every OS and everywhere. |
| **Datasette** | No built-in timer. Use the `/-/query` page plus your own stopwatch, or time the same query from Python. |

The portable timer (use this for the Module 3 index benchmarks):

```python
import sqlite3, time

conn = sqlite3.connect("module-03/warehouse.db")
sql = "SELECT city, COUNT(*) FROM customer GROUP BY city"

t0 = time.perf_counter()
rows = conn.execute(sql).fetchall()
print(f"{time.perf_counter() - t0:.4f}s  ({len(rows)} rows)")
```

> **Tips for numbers you can trust.** Run each query several times and report the **median** — the first run pays for disk cache and plan warm-up. A very fast query can be *faster* than the timer's resolution, so `.timer on`'s CPU figure or a repeat-in-a-loop makes the signal visible. And time it in the client you actually ship.

## Git & GitHub primer (template, editor, Markdown, conflicts)

In class we work with **GitHub on the web** and the **Git UI inside your editor** (VS Code or Zed) — commit, fetch, pull, and push from the buttons, not the terminal. **`gh` is used exactly once: to clone your new repository.** Command-line `git`/`gh` and SSH keys are *optional* — links at the end.

### Install Git and GitHub tools (Windows, macOS, Linux)

**The in-class flow:**

**1. Create the repo on GitHub (web).** Open [iot-portfolio-template](https://github.com/iotempire/iot-portfolio-template) → **Use this template → Create a new repository**. Name it `databases-portfolio` and make it **public** (or at least readable by the instructor). (A **template** gives you a fresh repo with one clean commit and no upstream link; a **fork** keeps a link to the original and the full history — not what a personal portfolio wants.) [Docs](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template).

**2. Clone it once with `gh` — the only `gh` command you need.**

```sh
gh auth login                              # GitHub.com → HTTPS → "Login with a web browser"
gh repo clone <you>/databases-portfolio    # clone the repo you just created on the web
```

**3. Open the folder in VS Code or Zed** and do everything else in the editor's Git UI.

`gh` drives `git` underneath, so install **both**. Install `gh`:

| OS | Install `gh` |
|---|---|
| **Windows** | `winget install --id GitHub.cli`, or `scoop install gh` |
| **macOS** | `brew install gh` |
| **Linux (Debian/Ubuntu)** | `sudo apt install gh` — older releases: [cli.github.com](https://cli.github.com/) |
| **Linux (Fedora/RHEL)** | `sudo dnf install gh` |

Install **Git**:

| OS | Install Git |
|---|---|
| **Windows** | **Git for Windows** from [git-scm.com/download/win](https://git-scm.com/download/win), or `winget install --id Git.Git -e` (also installs **Git Bash**) |
| **macOS** | `xcode-select --install` (Apple's Git), or `brew install git` |
| **Linux** | `sudo apt install git` · `sudo dnf install git` |

Check both: `gh --version` and `git --version`.

**Set your identity once** (so commits are attributed to you):

```sh
git config --global user.name  "Your Name"
git config --global user.email "you@example.com"
```

### Day-to-day commits — in your IDE (recommended)

- **VS Code** — the **Source Control** view: stage, write a message, **Commit**, then **Sync/Push**; **Pull** when you sit down. ([docs](https://code.visualstudio.com/docs/sourcecontrol/overview))
- **Zed** — the **Git panel**: stage, commit, push/pull. ([docs](https://zed.dev/docs/git))
- **GitHub on the web** — edit any file and commit right in the browser; ideal for a quick fix or pasting a query result.

> **The only `gh` used in class is the one-time clone.** Everything after that is IDE buttons or the GitHub website.

### Optional: command line, SSH, and other tools (external reading)

None of this is required — the IDE and the web cover the whole course:

- **`git` CLI** — [Pro Git book](https://git-scm.com/book/en/v2) · [git reference](https://git-scm.com/docs)
- **`gh` CLI** — [cli.github.com/manual](https://cli.github.com/manual/)
- **SSH keys / key exchange** — [GitHub: Connecting with SSH](https://docs.github.com/en/authentication/connecting-to-github-with-ssh) — *not used here; we stay on HTTPS, so there is no key exchange to set up.*
- **Plain `git` over HTTPS** — `git clone https://github.com/<you>/<repo>.git`, and paste a [Personal Access Token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens) when asked for a password.
- **GitHub Desktop** — [desktop.github.com](https://desktop.github.com/) (Windows & macOS); a point-and-click alternative.

**What “Git proficiency” means here.** You prove it by **edits and check-ins**, not by memorizing commands:

- **Several commits** with messages that say what changed — a clean history is itself evidence.
- **Markdown proficiency** — headings, lists, tables, code fences, and above all **links**, including **interlinks across portfolios**: link your pod mates' evidence, and any task or source you did not produce entirely on your own.
- **Working in your pod** — split the work, **audit each other**, and **change roles often**, so nobody is the only “Git person”.

**Learning the pieces (all free and official):** [Hello World / your first commit](https://docs.github.com/en/get-started/start-your-journey/hello-world) · [create from a template](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template) · [Markdown: basic syntax](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax) · [Markdown quickstart](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/quickstart-for-writing-on-github) · [resolve a merge conflict (GitHub editor)](https://docs.github.com/en/pull-requests/how-tos/merge-and-close-pull-requests/resolving-a-merge-conflict-on-github) · [command line](https://docs.github.com/en/pull-requests/how-tos/merge-and-close-pull-requests/resolving-a-merge-conflict-using-the-command-line) · [GitHub Skills (hands-on)](https://skills.github.com/) · [Pro Git book](https://git-scm.com/book/en/v2)

> [!TIP]
> Keep your portfolio **public** (or at least readable by the instructor) and build it up with **many small commits**, each message saying what changed — a clean `git log` is itself part of the evidence.

## Instructor hints: presenting the Markdown slide deck

The Session 1 slides are **plain Markdown** — no notebook runtime. The deck is [`slides/01-introduction.md`](../slides/01-introduction.md); slides are separated by a lone `---` line, so it reads correctly in *any* Markdown viewer (Zed, GitHub, VS Code — where `---` shows as a horizontal rule between slides).

**Render it to a PDF with pandoc + Typst, then present in Okular.** From the class directory:

```sh
./slides/render-slides.sh slides/01-introduction.md
```

This runs **pandoc** (Markdown → Typst: [`slides/slides.typ`](../slides/slides.typ) sets a 16:9 presentation page and slide-sized type, and [`slides/pagebreak.lua`](../slides/pagebreak.lua) turns every `---` into a Typst page break) and then **Typst**, producing `slides/01-introduction.pdf`. The PDF opens in **Okular's presentation mode** — fullscreen, one slide per page; arrow keys navigate, `Esc` exits. Add `--no-open` to render without launching the viewer.

**Presenting from Zed.** A ready-made task renders the *current* Markdown file and opens it in Okular: command palette → **`task: spawn`** → *“Slides → PDF (pandoc + Typst) + Okular”*. It lives in the repository's `.zed/tasks.json` and passes the current file (`$ZED_FILE`) to the script.

> [!NOTE]
> **Requirements and edit-time gotchas.** You need `pandoc` (≥ 3.1, for the Typst writer), `typst`, and `okular` — check with `pandoc --version`, `typst --version`, `okular --version`. Keep `---` as the only slide separator (a `---` inside a table, i.e. the `|---|` row, is fine), and remember that HTML comments like `<!-- Note: … -->` are dropped from the PDF — a safe place for instructor notes. If a slide overflows onto a second page, lower the base size in [`slides/slides.typ`](../slides/slides.typ).

**Run the Python on demand.** The deck is *only* slides. The live coding and the labs live in the workbook modules (start with [Module 1](./01-introduction-and-local-first.md)); run them whenever you like, from the same `uv` environment the Module 1 studio sets up:

- from Zed — a scratch `.py`, the built-in terminal, or your portfolio scripts;
- from the terminal — `uv run python …` (all `uv` commands are in [Module 1](./01-introduction-and-local-first.md)).

**Tips for the room**

- One idea per slide; the deck is already split that way.
- Reveal answers by *advancing* a slide — students answer first, the next slide confirms.
- Anything long lives in the workbook; the deck links to it.

Docs: [pandoc manual](https://pandoc.org/MANUAL.html) · [Typst documentation](https://typst.app/docs/) · [pandoc `pagebreak` filter](https://github.com/pandoc/lua-filters/tree/master/pagebreak) · [Zed tasks](https://zed.dev/docs/tasks)

## Story craft: is it concrete enough?

Hitting the right level of abstraction in a story is genuinely difficult. The balance between *too abstract* ("a database for a warehouse") and *too precise* (an already-finished specification) **is** the skill, and it is normal to overshoot or undershoot on the first tries. The test to teach: a story is concrete enough when it is **pitchable** (you can pitch it in a minute) and/or **playable** (it could carry a short film or a stage scene) — one named person, one place, one moment of pain, and something at stake. See [Module 7](./07-final-project-studio.md) for the student-facing checklist. The underlying method is *Story Driven Modeling* — Norbisrath, Zündorf & Jubeh, **Story Driven Modeling** (CreateSpace, 2013, ISBN 978-1483949253), [en.wikipedia.org/wiki/Story-driven_modeling](https://en.wikipedia.org/wiki/Story-driven_modeling).

## Story canon: the recurring cast

The module stories share a small cast of named (fictional) organizations and people. New material should stay consistent with them — the stories are deliberately kept as separate case studies for now.

| Module(s) | Organization | People | Place |
|---|---|---|---|
| 1, 4, 6 | **Wittkamp Zerspanung GmbH** — a small machine shop (CNC milling) | **Kai Lehmann** (plant manager) | Gütersloh |
| 1, 6 | **Cirrus Cloud Systems** — the vendor pitching the three-tier cloud stack | — | — |
| 2, 5 | **Kortmann Kunststofftechnik GmbH** — a plastics injection-molding plant | **Anke Reuter** (maintenance planner), **Yasmin Kaya** (operations lead) | — |
| 3 | **Frachtflow** — a logistics startup | **Nils Bergmann** (lead developer) | — |
| 7 (worked example) | **Füllwerk Gütersloh** — a bottling plant | **Marta** (night shift) | Gütersloh |

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

### Story-driven modeling (the method behind this course)

- Ulrich Norbisrath, Albert Zündorf, Ruben Jubeh — *Story Driven Modeling* (CreateSpace, 2013; ISBN 978-1483949253). The textbook behind this course's story-first approach: model a system by walking concrete object scenarios instead of starting from class diagrams. See also [Story-driven modeling — Wikipedia](https://en.wikipedia.org/wiki/Story-driven_modeling).

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
- **Nushell** — a table-native shell: pipelines over structured data that read SQLite/CSV/JSON directly (see Module 6, Task 5) — [nushell.sh](https://www.nushell.sh/)
- Local-first community — [localfirst.fm](https://localfirst.fm/)

### Real-world case studies (single-binary, embedded)

- **GoToSocial** — [gotosocial.org](https://gotosocial.org) · [docs.gotosocial.org](https://docs.gotosocial.org). A full ActivityPub (“Fediverse”) server in a single Go binary, with **SQLite as the default** (Postgres optional), running in ~250–350 MiB of RAM on low-power hardware. The clearest production example of “embedded database by default.”
- **Chatto** — [hmans.dev/blog/chatto](https://www.hmans.dev/blog/chatto) · [docs.chatto.run](https://docs.chatto.run). A team-chat platform shipped as one executable that serves its own frontend, with an **embedded NATS/JetStream** store — no external database, broker, or cache. *(Same architectural bet as GoToSocial; a different embedded engine.)*
- **PocketBase** — [pocketbase.io](https://pocketbase.io/). A backend-in-a-single-file built directly on SQLite.
- **Wafris** — *Rearchitecting: Redis to SQLite* — [wafris.org/blog/rearchitecting-for-sqlite](https://wafris.org/blog/rearchitecting-for-sqlite). A production story of **replacing Redis with SQLite** (≈3× faster locally, and no network round-trips).

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

- **SQL Island** — [sql-island.informatik.uni-kl.de](https://sql-island.informatik.uni-kl.de/). A free, browser-based **text-adventure game** created by Johannes Schildgen at the **RPTU Kaiserslautern-Landau** (formerly TU Kaiserslautern): you crash-land on an island and use SQL to survive — find food, get a job, make friends, and eventually escape. Along the way you practice `SELECT`, `WHERE`, `ORDER BY`, aggregates, and joins in about 1–2 hours. It is deliberately simplistic and its interface looks dated, but it is a genuinely effective, low-pressure way to get the SQL basics. Available in **German, English, and Portuguese** (it defaults to German — switch the language via the menu at the top left).
- **SQL Murder Mystery** — [mystery.knightlab.com](https://mystery.knightlab.com/). Solve a crime with SQL; a great follow-up once the island is behind you.
- **Lost at SQL** — [lost-at-sql.therobinlord.com](https://lost-at-sql.therobinlord.com/). A more modern, progressively harder learning game (beginner lessons plus “expert” challenges).

> **Suggested moment to play:** during or just after the SQL module. Spending an hour on SQL Island before wrestling with generated queries makes you much better at spotting a query that “runs but is wrong”.

## Side reading: Fossil vs Git — the architectural irony

A delightful footnote to this course's whole philosophy. **SQLite's own author, D. Richard Hipp, does not use Git** — he wrote a different version control system, **Fossil**, specifically to develop SQLite.

| | Git | Fossil |
|---|---|---|
| **Shape** | A set of tools; the repository is a `.git/` folder of loose files + pack-files | **One self-contained binary**; the repository is **a single SQLite database file** |
| **Collaboration** | Needs a hosting service (GitHub/GitLab) for issues, wiki, PRs | **Batteries included** — wiki, bug tracker, forum, chat, and a web UI, all served by the same binary |
| **Designed for** | Linus Torvalds, for the **Linux kernel** (distributed; “dictator and lieutenants”) | Hipp, for **SQLite** (a small trusted team; “sync everything up”) |
| **Durability** | Content-addressed objects (SHA-1 historically) | Content committed in an **ACID SQLite transaction** (SHA3-256) |

**The irony ties straight back to this course: Git is to Fossil as PostgreSQL/MySQL is to SQLite.** Git, like a client/server database, is a collection of parts that expects a server (GitHub) around it; Fossil, like SQLite, is a *single file* and a *single binary* — embedded, local-first, batteries-included, no infrastructure to stand up. The very philosophy you are applying to your data (embed it, keep it local, ship a file rather than a deployment) is the philosophy Hipp applied to version control. The tool that manages the most widely deployed database on Earth is built the way that database tells you to build things — and SQLite itself is developed using Fossil, whose repository format *is* SQLite.

**Read more:**

- Fossil — *Fossil Versus Git* — [fossil-scm.org/home/doc/trunk/www/fossil-v-git.wiki](https://fossil-scm.org/home/doc/trunk/www/fossil-v-git.wiki) — the definitive comparison, from the author. (“Fossil stores its objects in a SQLite database file which provides ACID transactions and a high-level query language.”)
- SQLite — *Why SQLite Does Not Use Git* — [sqlite.org/whynotgit.html](https://www.sqlite.org/whynotgit.html) — essays exactly the irony above.
- Fossil home page — [fossil-scm.org](https://fossil-scm.org/) — single-binary, self-hostable, “stores content using an enduring file format in an SQLite database”.
- InfoWorld — *3 great Git alternatives: Fossil, Mercurial, and Subversion* — [infoworld.com](https://www.infoworld.com/article/2338598/3-great-git-alternatives-fossil-mercurial-and-subversion.html)
- Hacker News discussion — *Git vs. Fossil* — [news.ycombinator.com/item?id=27736980](https://news.ycombinator.com/item?id=27736980)

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
