# Email template — prep and expectations

> Send the **content mail** at least three days before each session; a one-line reminder the day
> before is enough. Keep it under ~400 words, one action per bullet, links instead of explanations.
> Do **not** put points, grades, or assessment rules in the email — link the [syllabus](../syllabus.md).

## The core (four blocks)

1. **Where we are** — one sentence: what the last session produced.
2. **Before the session** — 2–4 concrete actions (finish X, keep file Y, run `uv sync`, bring Z).
3. **What happens** — the shape of the session, not the content (recap, rounds, terminal not slides).
4. **Homework** — core and optional intense track, one line each.

## Content mail (to everyone)

```text
Subject: Session [N] — [module name]: what to bring and what to expect

Hi all,

Thank you to everyone who was in the room for [last session] — [one concrete
thing that happened]. This mail is about the next session.

[Where we are — one sentence, ending in the problem the next session solves.]

Before the session (10–20 minutes):
1. [Finish X — the previous module's homework rounds.]
2. [Keep file Y; here is how to rebuild it if it is gone.]
3. [Bring Z — the artefact used in the recap.]
4. [Run `uv sync` once / install nothing else.]

What the session looks like:
- [Recap — not a test; what it covers.]
- [Shape: N rounds; what they produce.]
- Terminal, not slides. You run everything yourself.

Homework after:
- Core (everyone, ~[time]): [one line].
- Optional intense track (~[time]): [one line — sell it, do not require it].

See you [day].

Best regards,
Ulno
```

## Session 8 example — the project kickoff (Thu 26 Nov 2026)

> The kickoff mail is the one place where the “one action per bullet” rule bends: the team has to
> make a decision in the room, so the gate is stated. It still carries no points; assessment stays
> in the [syllabus](../syllabus.md).

```text
Subject: Databases — Thu 26 Nov: project kickoff (what to bring)

Hi all,

Thursday 26 November, 08:30–11:45 in G005, is the project kickoff. The modules are
over; the rest of the term is your project.

Before you come
Bring two candidate project families, one paragraph each: the organisation, three
actors, one workflow with its states, the first query, where the data comes from,
and roughly how many rows you expect. The project catalogue on the course page
has seven families and a ten-question self-check — run it on your candidates. If you already wrote the Module 6b project ticket, it counts as
one candidate. Do not build anything yet and do not form teams in advance; you
merge pods in the room.

What happens
- Merge two pods into a Project Team (4–6).
- Pitch your candidates and choose one. The gate is a named person and a first
  query; if a candidate cannot clear it, we pick a family together — that is the
  kickoff working, not a penalty.
- Write docs/charter.md (one page), elect a Product Owner and a process keeper,
  and split the slice into work packages on a small board.
- Start the vertical slice before the break: schema → ingest → query → interface.
- Second block: Checkpoint 2, part 1 (Modules 4–5) for ten pods. Register for a
  slot at the start of the day; there are two lanes (me and Shruthi).

Where the data lives
Default is one SQLite file. A second database, a report export, or a PostgreSQL
peer is fine if your charter says why. Do not turn SQLite into a server; if you
need a network UI, put Node-RED in front of the file. The catalogue lists the
three allowed shapes.

AI
Allowed, as always: draft with it, verify it, and keep docs/ai-log.md — what it
produced, what was wrong, what you changed. A log with no rejected suggestion is
not a log.

Checkpoint 2, part 2 is Thursday 3 December (Modules 6a–6b). The fair is Thursday
17 December.

See you Thursday.
Ulno
```

## Current expectations (WS 2026/27)

- **Module 5 is one session.** Its homework (Rounds 5–7: storage numbers, rows touched, memo) is
  gated by a **15-minute recap** at the start of Module 6a — no test, and no penalty for "not yet".
- **Module 6 is two studios:** 6a DuckDB (session 6), 6b polyglot + decision record (session 7).
- **Checkpoint 2 is spread over sessions 8 and 9**, ten pods each, while the project runs.
- **Project:** three studios (8–10) + the fair (11) — no extra project week. Session 8 is the kickoff: teams arrive with two candidate families, merge in the room, and leave with a charter, a board, and a running slice.
- **Homework has two levels:** a small core for everyone, an optional intense track (Module 6a:
  `refresh.py`; sell it, do not require it).
- **Pods:** 20 pods of 2–3; a TA helps.

## Per-session prep (current run)

| Session | Prep to ask for |
|---|---|
| 6 (6a) | Finish M5 Rounds 5–7; keep `Module05/normalize.db`; bring the memo; `uv sync` once |
| 7 (6b) | Bring `refresh.py` + one `--check` output **if** the intense track was taken; the updated memo |
| 8 | Read the [project catalogue](../modules/07-project-catalogue.md); bring **two candidate families** (one paragraph each); do not form teams — they merge in the room |
| 9–11 | Bring the repository and the current slice; nothing new to install |

> The module files carry `PREP EMAIL` markers. Grep them before writing the mail:
> `grep -rn 'PREP EMAIL' modules/`.
