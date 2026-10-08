# Databases (DBS) — Local-First Edition

> **Databases for people who build things.** Model real data, query it with an AI copilot at your side, and prove every performance claim with a benchmark — on a machine you actually own.

This is the course workbook for **Databases (DBS)**, a hands-on, studio-style database course for engineering students. It was originally designed for the Databases module (3386, 5 ECTS) in the Bachelor programmes *Mechatronics and Automation* and *Industrial Engineering* at Hochschule Bielefeld (HSBI), Campus Gütersloh — but it is written to be reused. The labs run offline on a laptop with open-source tools, and the material works as a standalone database course or as the data layer of an IoT / engineering curriculum.

- **[Module index & roadmap](./modules/00-index.md)** — the course at a glance: every module and the session-by-session plan.
- **[Syllabus](./syllabus.md)** — the official rules: schedule, learning objectives, assessment, tools, and policies.
- **Resource pages** — [reflection prompts & LLM-verification drills](./modules/Y-resources-prompt-bank.md) and a [cheat-sheet & troubleshooting bank](./modules/Z-resources-bank.md).

## Why this course looks different

Most "database applications" taught in introductory courses follow a pattern we now consider a **programming antipattern**: a full three-tier frontend/backend/cloud stack for something that needs to store a few thousand rows on a machine that already runs the code. This course flips that.

> [!TIP]
> **Is the heavy stack really overkill?** For local, single-user, and edge applications, a growing body of industry practice says yes. The movement was named by Kleppmann & Ink & Switch's [*Local-First Software*](https://www.inkandswitch.com/essay/local-first/) (2019); SQLite's own guide puts it bluntly — ["SQLite does not compete with client/server databases. SQLite competes with `fopen()`"](https://www.sqlite.org/whentouse.html); and mainstream frameworks have followed, with [Rails 8 shipping SQLite in production and dropping the Redis/PaaS dependencies](https://rubyonrails.org/2024/11/7/rails-8-no-paas-required). It is not wrong *everywhere* — but as a default for a local app, it is increasingly questioned. The [resource bank](./modules/Z-resources-bank.md#why-local-first-and-why-the-heavy-three-tier-default-is-questioned) collects the full reading list.

> [!IMPORTANT]
> **Local-first, embedded, and measured.** We treat the database as an embedded library inside the process, not a server you must host. Our default engines are **SQLite** (transactional, row-oriented, embedded relational) and **DuckDB** (analytical, columnar OLAP). We connect them to real **edge telemetry** — sensor readings, machine states, industrial logs — and we *prove* every performance claim with a benchmark instead of a slide.

You will:

- **Understand the schema before the query.** We start from *legacy schema audits*: reading somebody else's ER diagram and SQL, then writing a *data contract* that documents what the data really means.
- **Let AI write the SQL, but keep the responsibility.** Syntactic SQL memory is no longer a job skill. You will use LLM co-pilots to generate queries, then **profile them (`EXPLAIN QUERY PLAN`), benchmark the index impact, and prove they are injection-safe** — because shipping unreviewed generated SQL is how you get a data breach.
- **Trade normalization against speed with numbers.** Instead of memorizing 1NF–3NF, you will normalize, denormalize, and *measure* the read/write/storage consequences in SQLite.
- **Go polyglot on purpose.** You will store JSON in SQLite, run DuckDB analytics straight over Parquet and CSV, try a key-value store, and reason about when a relational engine is the wrong tool.
- **Build something meaningful.** In a **Project Team** of 4–6, you turn a real stakeholder story into a working local-first database application — and you defend the design decisions you own.

## How we teach — challenge- and project-based, in person, and always in flux

This course is taught as Challenge-Based and Project-Based Learning (CBL/PBL): you learn by investigating an authentic challenge and building a real solution, not by reproducing a lecture. We begin from stories — a real problem that matters to a person — because you learn best what connects to something meaningful for your own life, studies, or community.

It also matters that we do this in person, together. A university class is at its best where we actually meet, and you will learn a great deal from direct interaction with your peers: explaining, questioning, debugging, and demoing to one another, while the instructor learns alongside you.

And this class is always in flux — that is a feature, not a bug. No course is ever finished: every offering is adjusted while it runs, and each class teaches us as much as it teaches you.

> [!NOTE]
> **How the modules work.** Each module opens with its **learning goals** and a ***DRAFT BOUNDARY***; the tasks are negotiable as long as the goals are met. The [syllabus](./syllabus.md) is the single source of truth for the learning-goals contract, assessment, and the “draft in motion” model.

## How the course is organized

- **11 four-hour studio sessions (44 contact hours)**, plus optional tutorial sessions (times announced via the LMS).
- **Modules 1–6:** one technical module per session — the local-first paradigm, legacy schema audits and data contracts, LLM-assisted SQL and query profiling, integrity and edge triggers, normalization benchmarking, and polyglot embedded persistence.
- **Modules 7–8:** the final-project arc — a story-driven, local-first database application, built, documented, and defended in a merged **Project Team** of 4–6 (two Task Pods).

The full module list, one-line summaries, and the session roadmap live in the **[module index](./modules/00-index.md)**.

## Get started

1. Fork your personal portfolio from the [IoTempire portfolio template](https://github.com/iotempire/iot-portfolio-template).
2. Read the **[module index](./modules/00-index.md)**, then start with **[Module 1 — Introduction & Local-First Foundations](./modules/01-introduction-and-local-first.md)**.
3. Keep the **[syllabus](./syllabus.md)** handy for the schedule, assessment, and policies.

## What you will work with

You set the whole toolchain up with one command using **[`uv`](https://docs.astral.sh/uv/)** — a fixed Python plus SQLite, DuckDB, Datasette, and more, with the same commands on Windows, macOS, and Linux. Everything is open-source and runs offline on your laptop: **Python 3.14** (uv-managed), **SQLite**, **DuckDB**, **Datasette**, **Git/GitHub**, and an editor such as **VSCode** or **Zed**. You will use AI copilots (ChatGPT, Claude, DeepSeek, or a local model) to *draft* SQL — and then verify it, which is exactly the skill this course builds. The [syllabus](./syllabus.md#tools--environment) lists the exact toolchain, and [Module 1](./modules/01-introduction-and-local-first.md) sets it up step by step.

## For instructors

The workbook is meant to be reused and adapted. It relies only on open-source, permissively licensed tools; the labs are self-contained and run offline; and each module keeps its learning goals separate from the (draft) tasks, so you can swap exercises without breaking the course. Fork it, translate it, and change the stories to your own context — and please keep the attribution to IoTempower and Ulrich Norbisrath. Feedback and pull requests are welcome.

**Presenting the class:** Session 1 has a plain-Markdown slide deck — [`slides/01-introduction.md`](./slides/01-introduction.md) — that opens in any Markdown viewer (Zed preview, GitHub, VS Code) and renders to a 16:9 PDF with **pandoc + Typst** ([`slides/render-slides.sh`](./slides/render-slides.sh)), presented fullscreen in **Okular**. Slides are separated by a `---` line; there is no notebook runtime and no build step — the live Python is run on demand from the workbook. See the [resource bank's instructor hints](./modules/Z-resources-bank.md#instructor-hints-presenting-the-markdown-slide-deck) for the full workflow.

## Navigation & resources

- [Module index & roadmap](./modules/00-index.md)
- [Syllabus](./syllabus.md)
- [Reflection prompts & LLM-verification drills](./modules/Y-resources-prompt-bank.md)
- [Cheat sheets, troubleshooting & datasets](./modules/Z-resources-bank.md)
- [SQLite documentation](https://www.sqlite.org/docs.html) · [`EXPLAIN QUERY PLAN`](https://www.sqlite.org/eqp.html) · [JSON functions](https://sqlite.org/json1.html) · [STRICT tables](https://www.sqlite.org/stricttables.html)
- [DuckDB documentation](https://duckdb.org/docs/) · [Datasette](https://datasette.io/) · [sqlite-utils](https://datasette.io/tools/sqlite-utils)
- [IoTempire](https://iotempire.net/) — organization, teaching tools, and community

### LMS PDF exports

Generate a dated, upload-ready PDF of the syllabus using LibreOffice (default), Chromium, or LaTeX:

```sh
./generate-lms-pdfs.sh 2026-27
```

## Contacts & support

- Questions, schedule, and technical support: use the course LMS (ILIAS), the authoritative communication channel.
- Main instructor: Prof. Dr. Ulrich Norbisrath (Ulno) — [ulno.net](https://ulno.net/)
- Community: [IoTempire](https://iotempire.net/)

> Origin: originally based on the legacy Databases module by Prof. Dr. Alexander Maier; a modern German-language variant exists by Prof. Dr. Dominic Becking. Redesigned here for local-first, AI-era teaching.
