# From Databases — a gift of decisions and TODOs

> **What this is.** The Databases class finished its first run (WS 2026/27) while the Networking
> class was still at Day 1. Both classes share the studio pattern, the portfolio pipeline and most
> of their didactic decisions — but Databases hit the problems first: an assessment form that
> changed mid-stream, a module that had to be split during the run, and an attendance collapse.
> This file lists what held, what it cost, and what the Networking class should copy, adapt or
> avoid. It is a gift, not a template: take what fits and change what does not.
>
> **Where the reasoning lives.** The full records are in the
> [Databases architecture log](../../hsbi-databases-10d/instructor-notes/00-architecture-decisions.md).
> Its §1.5 maps the DB decisions onto the Networking ones; this file only repeats what is
> *actionable*.

[← Instructor notes](./README.md) · [Networking ADR](./00-architecture-decisions.md) · [Databases ADR](../../hsbi-databases-10d/instructor-notes/00-architecture-decisions.md)

## 1. Copy these first

Six items, roughly in order of payoff. Each one is small, and each one was learned the hard way.

| # | What to copy | Where it lives in Databases | Why it matters in Networking |
|---|---|---|---|
| 1 | **Prep mail three days ahead, with `PREP EMAIL` markers in the modules** | D19; [email template](../../hsbi-databases-10d/instructor-notes/email-template.md); `grep "PREP EMAIL"` in the module files | The only lever that consistently changed attendance and preparation. Say what to bring, what to finish, and what happens in the room — not a content summary. |
| 2 | **Warm-up before timing; median and spread, never a single run** | D3; Module 5 warm-up; `race.py` (warm-up run, interleaved engines, median, `[min–max]`) | Network timings are noisier than database timings — Wi-Fi, DHCP, DNS, ARP. “Cold cache is not a result” applies to ARP and DNS caches too. |
| 3 | **A local `scratch/` demo project, a smoke test and a link validator** | D8/D16; `scratch/README-demo.md`, `smoke-test.sh`, `validate-all.py` (**git-ignored — ask the Databases instructor for a copy**) | Demo without borrowing a student portfolio; catch broken code blocks and dead links before the room does. The smoke test extracts commands from the module text, so docs and reality cannot drift silently. |
| 4 | **The checkpoint run sheet: peer practice, published order, TA lane** | D13; [feedback rounds](../../hsbi-databases-10d/instructor-notes/feedback-rounds.md); [template](../../hsbi-databases-10d/instructor-notes/feedback-template.md) | 20 pods × 10 minutes = 200 minutes. The practice round (two pods, 12 minutes each way) buys quiet time before the instructor lane; a second lane halves the queue. |
| 5 | **One command as the spine of the course** | Databases: `EXPLAIN QUERY PLAN`, said out loud in every module from 3 onward | Pick the Networking equivalent — `ip route`, `tcpdump -i any -n`, or `mosquitto_sub -v -t '#'` — and make it the reflex students copy. One command beats ten slides. |
| 6 | **An online-pod / asynchronous fallback, written down before it is needed** | D18 (provisional); attendance paragraph in the syllabus and the private follow-up mail | Attendance collapses are not predictable. Decide the fallback while the room is full, not in the week it happens; confirm the examination-law question first. |

## 2. Decisions that Networking does not have yet

The remaining DB decisions all have a Networking counterpart — use the map in the
[DB ADR §1.5](../../hsbi-databases-10d/instructor-notes/00-architecture-decisions.md#15-how-these-decisions-relate-to-the-networking-and-iot-log)
instead of copying them again. Five are genuinely new:

1. **D19 — prep and expectation emails.** Adopt the template and the marker convention.
2. **D18 — online pods as the fallback.** Provisional in Databases; the public text is deliberately
   minimal, the cohort-specific detail stays in the private repo.
3. **D13 — spread checkpoints + TA lane + peer practice.** Networking already treats checkpoints
   as feedback (D4); the *arithmetic* and the run sheet are the gift.
4. **D3 — warm-cache measurement discipline.** Add the sentence to every benchmark, including
   captures and throughput tests.
5. **D8/D16 — the `scratch/` demo project.** A concrete way to make “survive leaving the room”
   testable by the instructor.

## 3. TODO backlog to adopt

Concrete actions, copied from the Databases list and re-phrased for Networking. Tick them as they
land; the reasoning is in the DB ADR or in the linked artefact.

- [ ] **Write the prep-mail template and add `PREP EMAIL` markers** to every module (D19).
- [ ] **Add one sentence to every benchmark**: warm-up run, repeated/interleaved runs, median and
      spread; state that a cold cache is not a result (D3).
- [ ] **Mirror the `scratch/` demo project**: one `pyproject.toml`, one refresh script, one smoke
      test, one link validator (D8/D16).
- [ ] **Build the checkpoint run sheet**: peer practice (12 minutes each way), a published order,
      a second lane with the TA, and the fill-in template (D13).
- [ ] **Announce all project milestones at once** in the planning session and let teams set their
      own dates; publish the demonstration date early (D14).
- [ ] **Write down the online-pod fallback** — what a missing student does, how the pod includes
      them, how the assessment changes — before it is needed (D18).
- [ ] **Audit “one job per document”** at the end of term: README, syllabus, modules, instructor
      notes, resource bank (D8/D13 in the Networking log).
- [ ] **Move the draft boundary to the end** of each module once it has been taught (D9/D14).
- [ ] **Split an oversized module on paper before the run.** Databases split Module 6 into 6a/6b
      *during* the term; it worked, but it cost a week of confusion and a points-table discussion.
- [ ] **Revisit the grading table for partial grades** — *shared thought, no implementation yet*.

## 4. What not to copy

| Not this | Why |
|---|---|
| The 11-session structure, the 20-point table, *Projektarbeit* | Different day count and examination form. Copy the pipeline, not the numbers. |
| SQL, DuckDB, normalization content | Belongs to Databases; the didactic shape is what travels. |
| Minute-by-minute estimates inside tasks | Networking rejected them for good reasons (its ADR §3). Keep the ban; Databases is still deciding (see §5). |
| The cohort-specific attendance mail | It lives in the private repo and names a specific room. Write your own when you need it. |
| “Gate” as the standard term | Databases is renaming it to **discussion**; do not introduce the old word in new material. |
| A second reflection logbook per module | Reflections are block-based; a second copy drifts and inflates the workload. |

## 5. Shared questions — close them together

| Question | Current state | Suggested path |
|---|---|---|
| **Partial grades (A-, B+, B-)** | Databases ADR §4: the 20-point table moves in whole points. | First a thought experiment for both classes: define what separates an A- from a B+ in the evidence, then see whether the table can express it without inventing half points. Do not put it in a module. |
| **Time vocabulary** | Networking bans estimates; Databases uses block targets. | Pick one vocabulary for both classes before the next offering. |
| **“Gate” vs “discussion”** | Databases uses *discussion* in 6a/6b, *gate* in Module 5. | Pick one term and rename in one pass; link each discussion to the learning goal it tests. |
| **Checkpoint slot length** | 10 minutes in the syllabus, 12 in the run sheet. | Fix one number in both documents; record actual slot times for a term. |
| **Big pods / TA** | Databases: 20 pods, one TA lane. | Measure one term before making the TA a permanent requirement. |
| **Online pods** | Databases D18 is provisional. | Ask the Prüfungsamt together; publish only what is allowed. |

## 6. Suggested adoption order

1. **Before Day 1:** prep-mail template + markers, the `scratch/` project skeleton, and the
   checkpoint arithmetic (pods × minutes). These three prevent the most common first-run panic.
2. **Week 1:** the warm-up/median/spread sentence in every benchmark; one scripted harvest round
   so the format becomes normal early.
3. **Before the first checkpoint:** run sheet, peer practice, published order, TA lane.
4. **End of term:** write the Networking architecture log; compare it with the
   [DB log](../../hsbi-databases-10d/instructor-notes/00-architecture-decisions.md) §1.5 and close
   the shared questions in §5 above. Then hand the next sibling class its own gift file.

## 7. Pointers

- [Databases architecture log](../../hsbi-databases-10d/instructor-notes/00-architecture-decisions.md) —
  D1–D19 with context, consequences, alternatives and reversal triggers.
- [Databases TODO](../../hsbi-databases-10d/instructor-notes/TODO.md) — the discrepancy watch and
  the actionable leftovers.
- [Databases study formats](../../hsbi-databases-10d/instructor-notes/study-formats.md) — the
  catalogue of pod-study and stage-and-gate variants.
- [Databases module index](../../hsbi-databases-10d/modules/00-index.md) — Modules 5, 6a and 6b are
  the current stage-and-gate examples.
- [Databases PostgreSQL tunnel](../../hsbi-databases-10d/instructor-notes/postgres-tunnel.sh) — a
  reusable pattern for putting one optional service in front of the room.
