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

### Where to run the labs: your editor's terminal

Run the module commands in your **editor's integrated terminal** (VS Code or Zed) — you are already inside your portfolio repo, and you can run Python on demand from there.

- **macOS / Linux:** the built-in terminal is already a Unix shell (bash/zsh). Nothing to set up.
- **Windows:** it defaults to **PowerShell**, which cannot run the heredoc (`<<'SQL'`) or `<` redirection commands used in these labs. Point it at **Git Bash** once — **no extra install**, because Git Bash ships with Git for Windows (installed in Module 1):
  - **VS Code:** in the terminal, click the **⌄** beside **+** → *Select Default Profile* → **Git Bash** (auto-detected). New terminals then use bash.
  - **Zed (Windows):** the terminal follows your default system shell — set **Git Bash** (e.g. via Windows Terminal) as the default, or open the standalone **Git Bash** app.
  - **Also fine:** run the labs in **WSL** (`wsl`) for a full Linux shell.

- **If you must stay in PowerShell**, translate only these forms:

| The modules use (bash) | PowerShell equivalent |
|---|---|
| `mkdir -p Module02` | `New-Item -ItemType Directory -Force Module02` |
| `sqlite3 Module02/legacy.db < setup.sql` | `Get-Content setup.sql \| sqlite3 Module02/legacy.db` |
| `sqlite3 db <<'SQL' … SQL` | save the block to `setup.sql`, then `Get-Content setup.sql \| sqlite3 db` (or, in the shell: `sqlite3 db ".read setup.sql"`) |
| `time sqlite3 db "SELECT …"` | `Measure-Command { sqlite3 db "SELECT …" }` |

> PowerShell is fine for `uv`, `git`, and one-liners like `sqlite3 db "SELECT …"` — but the heredoc/`<` labs want **Git Bash** or **WSL**.

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
sqlite3 -cmd ".mode csv" -cmd ".import --skip 1 file.csv tbl" app.db   # bulk import, skipping a header row (-cmd runs a dot-command for one-shot calls)
sqlite3 -cmd ".timer on" app.db "SELECT ..."   # time one statement (dot-commands are settings, not SQL)
sqlite3 app.db "EXPLAIN QUERY PLAN SELECT ..."
sqlite3 app.db < script.sql              # run a whole script (SQL + dot-commands) at once
datasette app.db -o                      # browse in the browser; add ?_size=100 to page
sqlite-utils insert app.db tbl data.csv --csv
sqlite-utils memory data.csv "SELECT count(*) FROM data"   # query a CSV in one command
```

### Pasting a block into the `sqlite3` prompt

The `sqlite>` prompt reads **one line at a time**; a multi-line **paste** fails (`.mode … bad argument`, or the whole block is parsed as one SQL statement) because readline uses **bracketed paste** — the terminal hands the whole paste over as a single line.

```sh
sqlite3 app.db < script.sql                          # run a whole file of SQL + dot-commands
# or, inside the prompt:   .read script.sql
echo 'set enable-bracketed-paste off' >> ~/.inputrc  # fix pasting once, then open a new terminal
```

Prefer the file; otherwise enter commands **one line at a time**.

### Measuring query time

`EXPLAIN QUERY PLAN` shows *what* the planner will do; timing shows *how long* it took. You want both. There is no single command that works everywhere — use the one that fits where you are:

| Where you are | How to time it |
|---|---|
| **`sqlite3` shell** | `.timer on` on its own line. In the **interactive** shell it prints a `Run Time: real … user … sys …` line after each statement; in a **one-shot** run (`sqlite3 db "stmt1; stmt2;"`) it prints **one** line at the end, so time one statement per invocation when scripting. The line goes to normal output, so `.output` and redirects capture it. Read **`real`** (wall clock) for "how long did it take"; `user` + `sys` (CPU) tells you how much of that was actual computing. |
| **One-shot `sqlite3`** | Dot-commands are *settings*, not SQL — pass them with `-cmd`: `sqlite3 -cmd ".timer on" app.db "SELECT …"`. |
| **macOS / Linux CLI** | `time sqlite3 app.db "SELECT …"` (wall-clock — but see **Trap 1** below). |
| **Windows PowerShell** | `Measure-Command { sqlite3 app.db "SELECT …" }`. |
| **Python (portable, recommended)** | `time.perf_counter()` around the query — wall-clock, works on every OS and everywhere. |
| **Datasette** | No built-in timer. Use the `/-/query` page plus your own stopwatch, or time the same query from Python. |

**Trap 1 — `time` measures a whole process, not your query.** `time sqlite3 app.db "SELECT …"` includes the shell fork, SQLite start-up, opening the file, **and formatting the output**. Find your floor with `time sqlite3 app.db ".exit"` — on an ordinary laptop that alone is about **1 ms**, so a 0.3 ms query "measures" 1.3 ms. Printing 120 rows instead of one changes the number again. Use `time` for queries in the **hundreds of milliseconds** and up, where that fixed cost disappears into the noise.

**Trap 2 — one reading is not a measurement.** Run each query **three times** and report the **median**; the first run pays for the disk cache and the plan warm-up.

The portable timer:

```python
import sqlite3, time

conn = sqlite3.connect("Module03/warehouse.db")
sql = "SELECT city, COUNT(*) FROM customer GROUP BY city"

t0 = time.perf_counter()
rows = conn.execute(sql).fetchall()
print(f"{time.perf_counter() - t0:.4f}s  ({len(rows)} rows)")
```

### Timing a query that is too fast to time

When the effect you are chasing is smaller than your timer's floor, do not buy a better stopwatch — **measure a batch and divide**. One process, one connection, `n` repetitions:

```python
import sqlite3, time

conn = sqlite3.connect("Module03/warehouse.db")
sql = "SELECT COUNT(*) FROM orders WHERE ordered_on='2026-02-14'"

conn.execute(sql).fetchone()            # warm-up — never measured
n = 1000
t0 = time.perf_counter()
for _ in range(n):
    conn.execute(sql).fetchone()
print(f"{(time.perf_counter() - t0) / n * 1000:.4f} ms per query")
```

On the Module 3 dataset this separates the indexed lookup (≈0.005 ms) from the unindexed one (≈2 ms) — a ~400× difference that `time sqlite3 …` reports as "1 ms" **either way**, because process start-up dominates. Dividing a batch is the oldest trick in benchmarking, and it is the only honest way to time something that finishes before your timer can blink.

## Watching instead of reading

The studio is where the learning happens, so none of this is required. But some people think better with someone talking at a whiteboard — here are the clearest explainers we found, grouped by module. Watch at 1.5×, and come back with **one question** for your pod.

| Module | Watch | Why this one |
|---|---|---|
| 3 | [Relational Algebra Explained: The Foundation of Databases!](https://www.youtube.com/watch?v=z9IceBT2_ws) | ~9 min; selection, projection, join, union, difference — and each one mapped to its SQL form |
| 3 | [Relational Algebra — Select Operation (Neso Academy)](https://www.youtube.com/watch?v=Givp56x6vbg) | slower and more formal; good if σ/π notation still looks like noise |
| 3 | [SQLite index and `EXPLAIN QUERY PLAN`](https://www.youtube.com/watch?v=OY6sB91-OE4) | the one video that shows `SCAN` turning into `SEARCH` on a real SQLite file |
| 3 | [CMU Database Systems — Query Optimization](https://www.youtube.com/watch?v=uLKzlSO6O1M) | a real lecture (45 min): why planners reorder joins. Optional depth |
| 4 | [Primary Key and Foreign Key Constraints in SQL (Neso Academy)](https://www.youtube.com/watch?v=MR0PK0qkCD8) | the constraint vocabulary, with inserts that fail on camera |
| 4 | [SQLite: foreign key constraints](https://www.youtube.com/watch?v=22LS5AGGT7s) | short and SQLite-specific; shows the `sensor 99`-style rejection |
| 5 | [Learn Database Normalization — 1NF to 5NF (Decomplexify)](https://www.youtube.com/watch?v=GFQaEYEc8_8) | the best-structured normalization walkthrough; chapter markers per normal form |
| 5 | [Database Normalization 1NF 2NF 3NF (Jesper Lowgren)](https://www.youtube.com/watch?v=SK4H5tTT6-M) | starts from a spreadsheet, which is how the anomaly actually feels |
| 6 | [OLAP vs OLTP (IBM)](https://www.youtube.com/watch?v=iw-5kFzIdgY) | six minutes on row-oriented vs analytical, from people who sell both |
| 6 | [Parquet: row-based vs columnar storage](https://www.youtube.com/watch?v=f0frVLA5OBc) | visualizes *why* a column store reads less data |
| 6 | [ACID properties in data, explained](https://www.youtube.com/watch?v=vNbslx32izM) | the four letters, with the bank-transfer example |

> Videos are external and can be renamed, region-locked, or taken down. If one is gone, say so in `#sql-questions` and we will find a replacement. **Watching is never a substitute for running the query** — each of these ends with something you should reproduce on your own database.

## Visualizing an ER model (Mermaid, diagrams.net)

LLMs usually hand you a diagram as **Mermaid** text — a code fence tagged `mermaid` that contains an `erDiagram`. Mermaid is text-to-diagram; paste it where Mermaid renders:

- **Fastest — [mermaid.live](https://mermaid.live/):** paste the code, see the diagram, then *Actions → PNG/SVG* to download it for your portfolio.
- **On GitHub:** put the code in a code fence tagged `mermaid` inside a `.md` file — GitHub renders it on the page (handy for your portfolio).
- **VS Code:** the *Markdown Preview Mermaid Support* extension renders `mermaid` fences in the preview.
- **From the CLI:** `npx -y @mermaid-js/mermaid-cli -i diagram.mmd -o diagram.svg`.
- **Design or repair it yourself:** [diagrams.net](https://www.diagrams.net/) (draw.io) is the course's ER tool.

Mermaid's `erDiagram` uses **crow's-foot** cardinality — `||--o{` is one-to-many, `}o--o{` is many-to-many — a fast way to *see* the intended model.

> **Sanity-check any LLM diagram.** A model will happily *draw* relationships the schema never declared — that is exactly Module 2's point. The diagram shows what the tables are *meant* to mean; verify each relationship against the data with a `COUNT`.

## Git & GitHub primer (template, editor, Markdown, conflicts)

In class we work with **GitHub on the web** and the **Git UI inside your editor** (VS Code or Zed) — commit, fetch, pull, and push from the buttons, not the terminal. **`gh` is used exactly once: to clone your new repository.** Command-line `git`/`gh` and SSH keys are *optional* — links at the end.

### Install Git and GitHub tools (Windows, macOS, Linux)

**The in-class flow:**

**1. Create the repo on GitHub (web).** Open [iot-portfolio-template](https://github.com/iotempire/iot-portfolio-template) → **Use this template → Create a new repository**. Name it `databases-portfolio` and make it **public** (or at least readable by the instructor). (A **template** gives you a fresh repo with one clean commit and no upstream link; a **fork** keeps a link to the original and the full history — not what a personal portfolio wants.) [Docs](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template).

**Reflections:** copy `Reflections/TEMPLATE.md` to `Reflections/refNN.md`; `ref02.md` is the worked example.

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
uv python install 3.14
uv python pin 3.14
uv add duckdb datasette sqlite-utils pydantic sqlalchemy
uv tool install litecli          # install ONE tool per command (repeat for the others)
uv tool install datasette
uv tool install sqlite-utils
uv run python -c "import sys, sqlite3, duckdb; print(sys.version.split()[0], sqlite3.sqlite_version, duckdb.__version__)"
```

If you cannot use **`uv`**, install the same libraries with your platform's own tooling (for example `conda`), and manage the Python version and environment yourself — that is exactly the work `uv` does for you in one step, which is why this course uses it.

> [!TIP]
> Datasette Lite runs entirely in the browser (WASM) — useful if you cannot install anything: [lite.datasette.io](https://lite.datasette.io/).

---

[← Back to front page](../README.md) | [← Resource Prompts](./Y-resources-prompt-bank.md)
