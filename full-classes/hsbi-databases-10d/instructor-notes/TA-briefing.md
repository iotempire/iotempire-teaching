# TA briefing — feedback, not grading

[All instructor notes](./README.md) · [Feedback rounds](./feedback-rounds.md) · [Syllabus](../syllabus.md)

**The short rule: the TA suggests points and readiness, and may mark an individual for recheck; the
instructor records every final point, grade, and pass/fail decision.** This is not a limitation to
apologise for — it is what keeps the assessment consistent and the TA free to ask the questions
that help.

## What the TA may do

- Run a **second feedback lane** at a checkpoint: same ten-minute script, same questions.
- Ask a pod to open its portfolio and show **one artefact**; listen, do not rescue.
- Write evidence notes: what was shown, what was missing, the next step.
- Suggest **“ready / not yet”** for a module or learning goal, with the evidence.
- Suggest a **point value** (for example 1/2 or 2/2) and mark an individual for **recheck**; the
  instructor confirms and records it.
- Help with setup and debugging: Postgres/pgweb credentials, Git, `uv`, Windows encoding, a broken
  database. Prefer asking a question over taking the keyboard.
- Run a lane at the demo fair and write feedback notes; suggest demo/discussion outcomes.
- Tell the instructor immediately when a pod is stuck, a student cannot explain their part, or a
  server/setup problem is eating the room.

## What the TA may not do

- Record the final points, grades, or pass/fail; promise that a module is “passed”. You may
  suggest; the instructor records.
- Change the syllabus, the rubric, or a deadline.
- Decide that a student’s contribution is insufficient; record the observation and escalate.
- Share one pod’s notes or portfolio with another pod.

## Checkpoint lane — the ten-minute script

1. **Portfolio gate (1 min).** The pod opens its own repository; can it edit, commit, and link an
   artefact? If not, stop and fix that first.
2. **One artefact (3 min).** “Show me the thing you are proudest of from Module X.” Ask what it
   proves, not how long it took.
3. **One question (3 min).** Pick the question for that module from the
   [feedback manual](./feedback-rounds.md). Listen for the reason, not the buzzword.
4. **One next step (2 min).** “What is the smallest thing you will add before the next session?”
5. **Write it down (1 min).** Fill the row below; do not rely on memory.

### Feedback record (hand to the instructor)

| Pod | Module / goal | Evidence seen | Missing | Suggested next step | Suggested points | Recheck? |
|---|---|---|---|---|---|---|
| | | | | | | |

“Not yet” is a complete answer. It is not a punishment, and it is not a grade.

## Demo fair — the TA lane

- The room is a fair: **five tables per 90-minute block**. Each team has a table, a live demo, a
  poster or slides, and a short recorded fallback.
- The TA joins the instructor for the **two training rounds** (both blocks), asks one question per
  member, and writes feedback. After this run the TA can take a table lane independently while the
  instructor takes the other.
- Write feedback for the instructor: what worked, what was hard to follow, one question the team
  could not answer, and a **suggested point value**. Do **not** record the final score.
- The instructor records the grade. Your notes are input, not a decision.

## Setup support

- **Postgres/pgweb:** the credential sheet is the TA’s; one database and role per pod. Test one
  student device before the room arrives. Never expose port 5432; only pgweb.
- **Windows CSV encoding:** `Invalid unicode … not utf-8 encoded` means `prepare.py` wrote cp1252.
  Add `encoding="utf-8"` to `open(...)`, rerun; do not switch DuckDB to `latin-1`.
- **Git/portfolio:** the pod must be able to edit, commit, and link. Fix that before anything else.
- **Do not debug one pod for the whole slot.** Ten minutes, then hand it to the instructor and keep
  the lane moving.

## Escalate immediately

- A pod has no working portfolio after the gate.
- A student says “that was my teammate’s part” and cannot explain their own piece.
- A team’s demo is slides only, or the live run fails twice.
- The server or the network is down and the room is waiting.
- Anything that sounds like a final grading decision.

## First-day checklist

- [ ] Read the syllabus assessment section and the [feedback manual](./feedback-rounds.md).
- [ ] Know the difference between **feedback** and **assessment**: you give the first, the
      instructor gives the second.
- [ ] Get the credential sheet and the pod/team list.
- [ ] Agree with the instructor who takes which lane and how notes are handed over.
- [ ] Keep a single notebook or file for feedback rows; no grades in shared documents.
