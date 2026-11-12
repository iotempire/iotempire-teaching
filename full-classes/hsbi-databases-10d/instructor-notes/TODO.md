# Future work — TODOs for the next run

> Working list, written during the first run (WS 2026/27). Nothing here is a promise; it is the
> memory of what we noticed and did not have time to fix. Tick items as they land, and add the
> observation that motivated them — a TODO without a reason gets dropped.
>
> **Decisions are not made here.** The reasoning, the rejected alternatives and the reversal
> triggers live in the [architecture log](./00-architecture-decisions.md). Each item below names
> the decision that owns it (`D…`) or the open question in §4. If a TODO turns out to be a design
> choice, write the record there and leave only the action here. Ideas worth handing to the
> Networking class are collected in its
> [gift file](../../hsbi-networking-iot-10d/instructor-notes/from-databases.md).

## Discrepancy watch

Read this before the next redesign. These are places where this file, the architecture log, the
module files or the sibling classes disagree. Do not fix one side locally; close the question in
the architecture log first.

| # | Discrepancy | Owner | Meanwhile |
|---|---|---|---|
| 1 | **Time vocabulary.** Networking ADR D3 bans time estimates; this class's rounds carry "~25 minutes" targets. | [ADR §4](./00-architecture-decisions.md#4-open-questions) | Keep block targets for this run; add no new minute-by-minute predictions. Agree one vocabulary with Networking before the next offering. |
| 2 | **“Gate” vs “discussion”.** §4 records it open; Modules 6a/6b say *discussion*, Module 5 still says *gate*. | ADR §4 | Do not rename by hand until §4 closes; if it closes as “discussion”, rename in one pass. |
| 3 | **Checkpoint slot length.** This README and `feedback-rounds.md` say 10 minutes; the manual's run sheet says 12. | ADR §4, [feedback manual](./feedback-rounds.md) | Use 10 in the room (the syllabus wins) and record the actual slot times. |
| 4 | **Points split M5 vs 6a+6b.** One session for 2 points vs two sessions for 2 points. | ADR §4, syllabus | No point values in module files. Change only in the syllabus, and only with the Prüfungsausschuss. |
| 5 | **Intensity opt-in** is a working TODO here but has no decision record. | this file | Treat it as provisional; if it survives a second run, write the record. |
| 6 | **Online pods / async assessment** were born from an attendance crisis (D18) and depend on an unanswered Prüfungsamt question. | ADR §4 | Keep the public text minimal; cohort-specific detail stays in the private repo. |
| 7 | **Partial grades (A-, B+, B-).** The 20-point table moves in whole points; both classes need a shared answer. | ADR §4, [gift file](../../hsbi-networking-iot-10d/instructor-notes/from-databases.md) | Thought experiment only for now — do not invent half points in the syllabus. |

## Before the next semester (reset)

- [ ] **Move every `DRAFT BOUNDARY` back to its start position** (D9). At the end of this run the
      boundary sits at the *end* of Modules 1–5 (everything was taught and revised); Modules 6a,
      6b, 7 and 8 still start with it near the top. Reset all of them to the first section that is
      genuinely provisional, and keep the sentence that explains what the boundary means.
- [ ] **Re-check the dates and the session mapping** in the syllabus against the real semester
      calendar (D15) — the 11-session plan moved twice during the run.
- [ ] **Re-run the smoke test and validation** on the machines you will teach from before the
      first session (D16): `sh scratch/smoke-test.sh all` and `python3 scratch/validate-all.py`.
- [ ] **Refresh the numbers** in the module stories (D3) — M5 4.07/11.09 MB, M6a 2M rows and the
      warm timings — if you change the datasets or the SQLite/DuckDB versions.

## Format and pedagogy

- [ ] **Intersperse theory and practice more** (D7). Modules 2–4 still run as *study → lab*; the
      stage-and-gate format in Modules 5, 6a and 6b works better. Convert one module per term,
      not all at once, and write down what changed.
- [ ] **Remove the remaining board assumptions.** The room has no board. In the instructor notes for
      Modules 2, 4 and 5 (and anywhere else the text says “write it on the board”), replace it with
      terminal output, a projected document, or a saved file. Module 6a now uses
      `scratch/warmup-portfolio/06a-recap-output.txt`; use that as the pattern.
- [ ] **Rename all remaining “gates” to “discussions”** — **blocked**, see discrepancy 2 and
      ADR §4. If the question closes as “discussion”, link each one explicitly to the module's
      **learning goal** and the **theory box** it tests. Modules 5, 6a and 6b already do this in
      different degrees; Modules 1–4 still say “gate” and some prompts only check completion, not
      understanding.
- [ ] **Make intensity opt-in everywhere it is possible** (D4; provisional, see discrepancy 5).
      Module 6a now has a core homework and an optional intense track; check whether the same
      shape fits Modules 3–5 (a small core proof plus one ambitious task), and whether students
      actually take the intense track when it is not required.
- [ ] **Handle big pods deliberately** (D13). With more than ~40 students, 20 pods of three means
      the instructor is the bottleneck at every checkpoint. Options that were discussed:
      pair-pods that pre-verify each other; a TA lane at checkpoints; one captain per pod on a
      rotating schedule; jigsaw inside the pod so one member teaches the others; and grading the
      portfolio once at the end instead of per module. Pick **one** per term and measure the time.
- [ ] **Get a TA if the cohort is above ~30 students** (D13). Not for grading — for the room:
      restarting containers, finding lost files, and taking a second feedback lane. The checkpoint
      arithmetic is the argument: 20 pods × 10 minutes is 200 minutes.
- [ ] **Record the stage-and-gate observations** in [`study-formats.md`](./study-formats.md) for
      Modules 5, 6a and 6b while they are fresh (D7) — especially whether the theory boxes get read
      *when needed* and whether the discussions are real or performative.
- [ ] **Watch the checkpoint split** across Sessions 8–9 (D13, ADR §4): ten pods each, or two
      lanes with the TA? Write down which one actually happened and how long each slot took.
- [ ] **Decide the two-studio split** (D11). 6a/6b were invented during the run and worked; make
      the split permanent in the module index and the points table, or merge them back after
      recording why the two-session version failed.
- [ ] **Check the one-session bet in Module 5** (D12). Did pods actually do the recap-gated
      homework before 6a, or did 6a lose its first 15 minutes to a recap anyway? One observation
      sentence decides whether the compression holds.

## Module 5 — carry-over from this run

Many pods concluded that denormalization “buys nothing” — they were measuring a **cold cache**
(D3). The module now warms both sides before timing (two sentences; leave them in), but the
instructor's recap board still shows only storage and row counts. Fix that next time:

- [ ] **Re-measure the A/B race warm** on the teaching laptop before Session 5 and put the medians
      on the recap board next to the storage numbers (≈4.07/11.09 MB) and the row counts (1 vs
      4,000). The timing is what students argue about.
- [ ] **Show cold vs warm side by side** for one query — first run, then second run. It turns
      “denormalization buys nothing” into “I measured the cache”, which was the most common
      finding of the first run.
- [ ] **Update the reference timings** in the private Module 5 solutions file with the warm
      numbers, so the discussion answers and the board agree.
- [ ] Keep the recap at 15 minutes. If the warm numbers start a discussion, take the time from
      Round 1 of Module 6a, not from the story.

## Infrastructure

- [ ] **Keep one deliberately slow PostgreSQL database running** as a reference for “slow”
      (D2, D16). The idea: a server with small buffers, a network hop, and a genuinely unindexed
      query, so a live comparison (“this is what 40 minutes feels like”) exists beyond the story.
      The [`postgres-tunnel.sh`](./postgres-tunnel.sh) setup is the starting point; add a
      “slow-mode” profile with tiny `shared_buffers` and `work_mem=64kB`.
- [ ] **Standardise the warm-cache methodology** (D3). Module 5 now tells students to run each
      query once untimed before measuring, and Module 6a's `race.py` does a warm-up run per engine.
      Apply the same sentence to every benchmark in the course, and say explicitly that **cold
      cache is not a result** — it is the reason denormalization looked useless to half the room.
- [ ] **Re-test the Cloudflare/Podman script** from a student-like network before relying on it
      (D16); the quick-tunnel mode is the fallback for instructors without a domain.
- [ ] **Check the DuckDB/Parquet path on Windows** once (D16) — the course assumes Git Bash or WSL
      for heredocs; the Python path should work everywhere. Note the one shell students can use
      (Zed or VS Code terminal) explicitly in the setup block instead of assuming one.
- [ ] **Carry the “scratch demo portfolio” pattern into the other classes** (D8, D16). `scratch/`
      is a uv project whose scripts and data are generated by the smoke test, so demos run with
      `uv run python Module06a/…` without opening a student portfolio. Mirror it in Sensors and
      Networking (a `pyproject.toml` plus a refresh script per class) and mention it in the
      instructor onboarding. The Networking variant is written down in its
      [gift file](../../hsbi-networking-iot-10d/instructor-notes/from-databases.md).

## Communication

- [ ] **Send prep and expectation emails at least three days before each session** (D19). Use the
      [email template](./email-template.md); the module files carry `PREP EMAIL` markers for the
      content. The email should say what to bring, what to finish, and what will happen in the
      room — not a summary of the content.
- [ ] **Announce the checkpoint order and the slot length a week ahead** (D13), with the template
      pre-filled. The “book the order” step is the one that always slips.
- [ ] **Announce the project milestone dates in Session 8**, not week by week (D14) — students
      plan better when the whole arc is visible, and the course promised them their own dates.

## Observations, not decisions

These came out of the first run and were not resolved. Anything that becomes a decision moves to
the architecture log §4 and gets a record; do not leave it here as a permanent question.

- Did the case studies at the project kickoff (GoToSocial/Chatto) change the architecture choices,
  or were they forgotten by Session 10?
- Did the performance clinic in Session 9 catch teams early enough to change a schema?
- Did the two-studio Module 6 reduce the “pod study ate the session” problem, or just move it?
- Did the optional intense homework get taken, and by whom — the strong students or the ones who
  need the practice?
