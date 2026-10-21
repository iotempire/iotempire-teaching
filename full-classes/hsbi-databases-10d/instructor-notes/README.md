# Instructor Notes — Databases (DBS)

These notes are for whoever teaches this class next. That may be you, with three weeks' notice and a memory of databases that is mostly `CREATE TABLE`. This course is often handed to a new professor, and the default reaction is to rebuild the lecture you were taught: 60 students in rows, 90 minutes of slides, an exam that sieves. **This class is not that**, and these notes exist so you can run it anyway.

Content lives in [`../modules/`](../modules/00-index.md). Rules and assessment live in [`../syllabus.md`](../syllabus.md). Logistics (rooms, dates, announcements) are the LMS's job.

## Five commitments that make the format work

1. **Students work in Task Pods of 2–3 for most of the term.** Default to 3 when the cohort is above ~40; keep a handful of pairs so the checkpoint schedule survives. *You never teach a room of 60 individuals — you teach 20–30 pods.*
2. **Learning goals are the contract; tasks are negotiable.** Every module opens with its goals. Students may replace or skip tasks if they can still demonstrate the goals. That is why you assess conversations, not submissions.
3. **You rarely lecture.** Most "input" is a pod study (20–30 min) with references and LLM prompts, followed by a concrete exercise and a share with a neighbouring pod. Your job is to walk, listen, and correct.
4. **Every session has two harvests.** At the break, five minutes of retrieval on the *previous* module; at the end, five minutes on what was learned today. Details in [Module 3](../modules/03-llm-assisted-sql-and-query-profiling.md), and one paragraph in the [syllabus](../syllabus.md#how-we-teach--challenge--and-project-based-in-person-and-always-in-flux).
5. **Checkpoints, not an exam.** A short conversation per pod against the goals. Treated as *project work* in the module handbook — see the [syllabus](../syllabus.md) for the binding version.

> [!IMPORTANT]
> **If you teach one technical habit, make it `EXPLAIN QUERY PLAN`.** It is the spine of the second half of this course: it turns "it feels slow" into a claim you can check, it is the only performance skill that still matters when a model writes the SQL, and it appears in every module from 3 to 8 — the final project requires a before/after plan as evidence. Say the command out loud, prefix queries with it in front of the room, and ask "what does the plan say?" before "how long did it take?". Students copy that reflex faster than any slide can teach it.

## The session shape

| Minutes | What happens |
|---|---|
| 0–5 | Story or a one-slide hook. Not a lecture. |
| 5–25 | **Pod study**: read, google, ask an LLM, take notes. |
| 25–35 | A concrete probe (predict-then-run, acceptance test, card sort). |
| 35–45 | **Harvest round 1 at the break** — retrieve the previous module out loud. |
| 45–90 | Studio lab: the core tasks. You circulate; pods ask for checkpoints. |
| 90–95 | **Harvest round 2** — one thing you can explain, one you cannot. |

Rooms: the schedule is 90 minutes, a 15-minute break, 90 minutes. Protect the break — it is part of the method, not slack.

## Checkpoints (tentative: session 4 and session 8)

- 10–12 minutes per pod, including questions and feedback — **in person** wherever possible.
- The pod presents from its **existing portfolios**, not from slides prepared for the occasion.
- Students who miss it send a **7–10 minute video plus a 3–5 page excerpt** from the portfolio; expect to give less feedback than in person.
- At the start of session 4, give two pods ~15 minutes each to present to **each other** first (free-style feedback). This proves the goals to a peer before they prove them to you, and halves your load.

## Before your first session (about two hours)

- [ ] Read [Module 1](../modules/01-introduction-and-local-first.md) and [Module 2](../modules/02-data-contracts-and-legacy-schemas.md) — you need to be one module ahead, not six.
- [ ] Create a GitHub account you will demo from, and check the [portfolio template](https://github.com/iotempire/iot-portfolio-template) still exists.
- [ ] Install `uv`, `sqlite3` and (optionally) `duckdb` + `datasette` on your own machine — you should feel where students get stuck.
- [ ] Run one module's **Setup** block by hand, end to end, on a fresh terminal.
- [ ] If the repo came with a `scratch/` folder (it is git-ignored), run `sh scratch/smoke-test.sh` — it extracts the documented SQL/Python out of each module and checks it still works. If you do not have it, ask the previous instructor; it catches broken code blocks before your students do.

## Slides

There is one deck: [`../slides/01-introduction.md`](../slides/01-introduction.md), plain Markdown, rendered to 16:9 PDF with pandoc + Typst via [`../slides/render-slides.sh`](../slides/render-slides.sh). It is written for session 1 only, on purpose — the rest of the term is not a slide course.

You may of course build more slides. Two honest options:

- **Reuse and edit** the existing deck. It is short, and the notes in [`../slides/01-introduction.md`](../slides/01-introduction.md) are written to be spoken over.
- **Generate a deck with an LLM**, then fix it. A prompt that works:

  > "You are preparing a 20-minute talk for 3rd-semester engineering students in a databases class. Use **only** the following Markdown as your source: `<paste a module section>`. Produce a Markdown slide deck: one idea per slide, at most 5 bullets, at most 12 words per bullet, no code block longer than 6 lines, and speaker notes for every slide. Mark any claim that is not in the source as `[UNVERIFIED]`."

  Then **run every code block and every error message** in the generated deck. Models invent SQLite error strings, version numbers, and flags with total confidence. A wrong error message on a slide will cost you more credibility than a plain slide ever will.

> [!WARNING]
> Slides are the crutch this course exists to remove. If you find yourself preparing 60 slides for a studio session, stop: the students should be typing, not watching. Use slides for the story, the goals, and the one table you want everyone to see — nothing else.

## Assessment: do not invent points

Everything about points, checkpoints, reflections, the grade scale, and the project rubric lives in the [syllabus](../syllabus.md). It is the single source of truth; the modules deliberately do not restate it. If a student asks "how many points is this?", the answer is a link, not a number you improvise.

## If you are drowning: the minimum viable session

Run only these four things and the session still works:

1. The **story** (3 min).
2. The **pod study** (20 min) — even if you do not fully understand the material yet; the pointers and LLM prompts carry it, and you learn by walking around.
3. **One** core task, not all of them (rest of the time).
4. **Harvest round 2** (5 min), and note what they could not explain.

Then read that module's instructor note before the next session. Nobody expects a first run to be polished; the syllabus says as much, in public.

## What to read if you are new to databases

A short path, in this order: [SQLite "Appropriate Uses"](https://www.sqlite.org/whentouse.html) (30 min, resets your instincts about servers) → [Use The Index, Luke](https://use-the-index-luke.com/) (skim the first three chapters) → the [local-first essay](https://www.inkandswitch.com/essay/local-first/) (1 h) → [Story Driven Modeling](https://en.wikipedia.org/wiki/Story-driven_modeling) (the method behind the project) → whatever module you teach next.

## Per-session notes

| Session | Note | Focus |
|---|---|---|
| 1 | [01](./01.md) | Pods, portfolio, toolchain. The session most likely to overrun. |
| 2 | [02](./02.md) | Pod study, legacy schema audit, ER reconstruction. |
| 3 | [03](./03.md) | Plan safari, LLM-generated SQL, index benchmarks, injection. |
| 4 | [04](./04.md) | Constraints, triggers, UPSERT — *and checkpoint 1*. |
| 5 | [05](./05.md) | Dependencies, normalization, measured denormalization. |
| 6 | [06](./06.md) | JSON, DuckDB/Parquet, key-value. |
| 7 | [07](./07.md) | Four project-studio sessions: story → vertical slice → review → rehearsal. |
| 8 | [08](./08.md) | Demo day and individual defenses. |
