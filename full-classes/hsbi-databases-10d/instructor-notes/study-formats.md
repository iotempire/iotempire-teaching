# Study formats — design notes and options

**Status: living document, written during the first run (WS 2026/27).** Module 5 is the first outing of the **stage-and-gate** format. Module 6 followed: it was **split into two stage-and-gate studios (6a DuckDB, 6b polyglot)** rather than a study plus a lab. Fill in *Observations* for both before redesigning again.

This is not student-facing. It is the memory of *why* the format changed and what else we considered.

## Why this exists

In Modules 2–4 the pod study was scheduled for 15–30 minutes and took **60–90**. The reading crowded out the lab, and the synchronised share forced everyone to wait. Three levers were tried:

1. **Cut the content** — fewer concepts per study.
2. **Split the work** — divide-and-conquer with one-minute updates (Module 3).
3. **Remove the phase** — put the theory inside the exercises (Module 5).

Modules 2–4 use (1)+(2). Module 5 uses (3). **Module 6 now uses (3) as well — split into 6a (DuckDB) and 6b (polyglot), one session each, with the theory pushed into the rounds.**

## The formats tried so far

| Format | Where | Shape | What happened |
|---|---|---|---|
| **Mini-lecture** | original draft | 15 min of talking, then lab | Removed. Students stopped typing; it was the lecture the course replaces. |
| **Pod study + share** | Modules 2, 3, 4 | 30 + 15 or 20 + 10, then lab | 1.5–2× over estimate. Good discussions, but the lab started late. |
| **Divide and conquer** | Module 3 | Four workstreams, 1-minute interruptions, hard stop | Better: the interruption rule kept pods from reading in silence. Still overran. |
| **Stage-and-gate rounds** | Module 5 | Primer + 15-min skim, then 7 self-paced rounds with theory-on-demand and a peer gate each | **Running now** — observations below. |

## Six dials (they are independent)

Most "formats" are just settings of these:

1. **When does theory arrive?** before the work / during it / after a failed attempt.
2. **Who holds it?** instructor / text / LLM / a peer who read it.
3. **Fixed or chosen path?** one linear path / two tracks / free choice of order.
4. **What synchronises the room?** a timer / peer gates / nothing / two whole-room moments.
5. **Unit of work?** a concept / an artefact / a question / a broken thing.
6. **Where does the evidence land?** personal notes / the repo / the board / a peer's head.

The stage-and-gate format is: theory *during*, held by *text and LLM*, one path, gates as the only sync, artefacts as the unit, evidence in the repo.

## Option catalogue

### A. Study as reference (lowest cost)
Tasks come first; the concept text sits below them as a reference. Each task ends with "show a neighbour".
- **Best for:** material students can start without.
- **Watch out:** keen pods read everything anyway; quiet pods never open the reference.
- **Edit cost:** very low.

### B. Stage-and-gate rounds (Module 5)
Primer → skim → 5–7 small rounds, each with *Do / Theory you need / If stuck ask / Gate*.
- **Best for:** procedural, observable material with clear artefacts.
- **Watch out:** the room spreads out; you need a gate board; a pod can fake a tick.
- **Edit cost:** medium (one module rewrite).

### C. Two tracks, same destination
Pods choose *schema-first* (normalize, then measure) or *measurement-first* (denormalize, feel the pain, then normalize).
- **Best for:** mature cohorts; material with two legitimate entry points.
- **Watch out:** you support two sequences; one track can reach a wrong conclusion.
- **Edit cost:** high.

### D. Station rotation
Four corners: theory/LLM, sketching, playground, benchmark. Pods rotate on completion; the gate is the next station.
- **Best for:** restless rooms, lots of visualization, a big space.
- **Watch out:** queues; the slowest station becomes the bottleneck.
- **Edit cost:** high (materials + room).

### E. Jigsaw
Each pod member takes one section, reads it, and teaches the others in five minutes. The pod's notes are the artefact.
- **Best for:** several independent concepts (e.g. the four integrity layers).
- **Watch out:** a weak reader teaches a weak section; you need a checking question per section.
- **Edit cost:** low.

### F. Worked example → variation
Give a fully solved example (FDs derived, schema normalized), then change one fact and ask what breaks.
- **Best for:** students who freeze at a blank page.
- **Watch out:** can become copying; make the variation non-trivial.
- **Edit cost:** low.

### G. Error hunt
Ship a deliberately broken repo/schema; pods find and fix N defects, each with a query as proof.
- **Best for:** debugging skills; combines well with Module 2 and 4.
- **Watch out:** needs a carefully seeded bug set; too many bugs is discouraging.
- **Edit cost:** medium.

### H. Predict → observe → explain
Every pod writes a prediction (plan, timing, row count) before running; then reconciles.
- **Best for:** benchmarks and query plans; it is already embedded in Module 3.
- **Watch out:** pods that run first and write afterwards learn nothing — check the paper.
- **Edit cost:** very low (it is a rule, not a format).

### I. Card sort / matching
Cards with concepts, cards with examples; pods match and defend. Physical or in a shared doc.
- **Best for:** vocabulary-heavy material (ACID/BASE, normal forms, engine palettes).
- **Watch out:** feels like a game to some; connect it to an artefact afterwards.
- **Edit cost:** low.

### J. Flipped pre-work + in-class clinic
Read/watch before class; class time is only practice and questions. A two-question entry ticket proves the pre-work happened.
- **Best for:** motivated cohorts with reliable internet at home.
- **Watch out:** the ones who need it most do not do it; the entry ticket is the only lever.
- **Edit cost:** low (but changes homework expectations).

### K. Live walkthrough first (I do → we do → you do)
Ten minutes of instructor solving one instance at the keyboard, then pods repeat with a variation.
- **Best for:** tool-heavy material (the `sqlite3` shell, `EXPLAIN`).
- **Watch out:** it is a mini-lecture with a terminal; keep it under ten minutes.
- **Edit cost:** very low.

### L. Minimal theory card + open lab
One page of definitions, then the whole session is lab. The card is the only reading.
- **Best for:** revisions and catch-up sessions.
- **Watch out:** insufficient for first contact with a hard concept.
- **Edit cost:** very low.

## Choosing (rough guide)

| If the material is… | Try |
|---|---|
| vocabulary everyone needs before acting | Pod study, Jigsaw, Card sort |
| procedural and startable without theory | Stage-and-gate (B), Study as reference (A) |
| two legitimate approaches | Two tracks (C) |
| debugging / finding defects | Error hunt (G) |
| measurement and plans | Predict–observe–explain (H) |
| tool mechanics | Live walkthrough (K) |
| a revision or catch-up session | Minimal card + open lab (L) |

## Observations (fill in after the run)

### Module 5, first run (stage-and-gate)

- **Timing:** even after the block plan was made generous, the room did not reach the end of Round 4 in 180 minutes. **Double every estimate again** for the next run. Keep the **end of Round 4** as the class boundary; Rounds 5–7 are homework by design.
- **Attendance:** about **one third of the class** attended. The room was regrouped once; that regrouping is the last one — do not re-form pods again in the same session.
- Did the gates happen without the instructor? Did pods tick honestly?
- Did the gates happen without the instructor? Did pods tick honestly?
- Did anyone actually read the "Theory you need" boxes — and did the gate questions expose the ones who did not?
- Was the 15-minute skim enough? Too much?
- What did the instructor spend time on that was not teaching?

**Verdict:** _pending_

### Modules 2–4 (pod study + share)

- Typical duration vs estimate:
- Which tasks did pods skip because the study ran long?

**Verdict:** _pending_

## Revisit checklist for Modules 6a and 6b

Module 6 was split into two stage-and-gate studios mid-run, after Module 5 showed the format could carry a session. Do this *after* the two sessions have run:

1. Read the observations above. If the rounds worked, keep the split. If 6a ran long, move Round 5 (the boundary) to homework — do not shrink the race.
2. If the rounds worked but the room spread too far, add **one** whole-room checkpoint after Round 3 of 6a.
3. If the gates were gamed, switch the gate to a **question the neighbour asks from a fixed list** (see the [feedback-round manual](./feedback-rounds.md)).
4. If students skipped the theory boxes, move one box *before* its round instead of inside it — a single change, not a redesign.
5. If 6b had too many benches, cut to two (JSON + decision record) and move key-value and the server to reading.

> **Do not redesign on a hunch.** One data point (Module 5) is enough to adjust, not enough to rebuild. Change one dial at a time and write down what happened.

## Open questions

- Does the gate board change behaviour, or is it decoration?
- Is the 15-minute skim real, or do pods start at Round 1 and never look ahead?
- Do the theory boxes get read *when needed*, or only when a gate fails?
- What is the minimum viable primer? (Currently: why, skim, gate rule, round table.)
- Can the same pattern carry a **tool-heavy** module (6a with DuckDB), or does it need the live walkthrough (K) first? *Being observed now.*
