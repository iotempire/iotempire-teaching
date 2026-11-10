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

## Current expectations (WS 2026/27)

- **Module 5 is one session.** Its homework (Rounds 5–7: storage numbers, rows touched, memo) is
  gated by a **15-minute recap** at the start of Module 6a — no test, and no penalty for "not yet".
- **Module 6 is two studios:** 6a DuckDB (session 6), 6b polyglot + decision record (session 7).
- **Checkpoint 2 is spread over sessions 8 and 9**, ten pods each, while the project runs.
- **Project:** three studios (8–10) + demos (11) — no extra project week.
- **Homework has two levels:** a small core for everyone, an optional intense track (Module 6a:
  `refresh.py`; sell it, do not require it).
- **Pods:** 20 pods of 2–3; a TA helps.

## Per-session prep (current run)

| Session | Prep to ask for |
|---|---|
| 6 (6a) | Finish M5 Rounds 5–7; keep `Module05/normalize.db`; bring the memo; `uv sync` once |
| 7 (6b) | Bring `refresh.py` + one `--check` output **if** the intense track was taken; the updated memo |
| 8 | Read Module 8; form the Project Team; bring a one-paragraph story |
| 9–11 | Bring the repository and the current slice; nothing new to install |

> The module files carry `PREP EMAIL` markers. Grep them before writing the mail:
> `grep -rn 'PREP EMAIL' modules/`.
