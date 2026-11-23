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
| 1 | **Time vocabulary.** Networking ADR D3 bans time estimates; this class's rounds carry "~25 minutes" targets. | [ADR §4](./00-architecture-decisions.md#4-open-questions) | 06a has none; 06b keeps a visible rough timing with a hidden TODO; Modules 2–5 and 7–8 still do. Keep the run sheets in the instructor notes and remove the remaining estimates in one pass. |
| 2 | **“Gate” vs “discussion”.** **Resolved 2026-11-19:** the activity is an **exchange** (D7); “gate” and “discussion” retire. | D7 | Renamed in one pass across modules, notes, templates and the kickoff mail. |
| 3 | **Checkpoint slot length.** Resolved for this run: README, `feedback-rounds.md` and the template use **10 minutes** for the instructor slot; the peer slot stays **12**. | ADR §4, [feedback manual](./feedback-rounds.md) | Record the actual slot times; if 10 is too tight, decide after the run. |
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
- [ ] **Build the slot-by-slot time breakdown from the real calendar.** For every date record the
      time, the type (Übung / Praktikum / betreutes Selbststudium), the minutes, and the school
      hours (45-minute units); sum by type and by day, and check the total against the module
      handbook. Then check that the number of sessions still fits the module and project
      distribution. The Sensors class needed this in 2026-11: a 90-minute slot is **two** school
      hours and a 180-minute slot is four, so a block-count model silently undercounted the term
      by four hours. Keep the breakdown in the instructor notes, not in the student-facing
      syllabus.
- [ ] **Re-run the smoke test and validation** on the machines you will teach from before the
      first session (D16): `sh scratch/smoke-test.sh all` and `python3 scratch/validate-all.py`.
- [ ] **Refresh the numbers** in the module stories (D3) — M5 4.07/11.09 MB, M6a 2M rows and the
      warm timings — if you change the datasets or the SQLite/DuckDB versions.
- [ ] **Remove time estimates from the student modules.** `AGENTS.md` forbids them. 06a has none;
      06b keeps a visible rough timing with a hidden TODO; Modules 2–5 and 7–8 still carry “~20
      minutes” headings and “Rough timing” blocks. Remove them in one pass after the planning is
      settled; keep the run sheets in the instructor notes.

- [x] **Fix the broken case-study anchor in Module 1.** Done 2026-11-17: an explicit
      `<a id="read-before-the-kickoff-systems-that-broke-the-classic-stack"></a>` now sits above the
      Module 7 heading, and the entry in `tools/check-docs-baseline.txt` is removed. The same pass
      fixed the Sensors `AGENTS.md` anchor used by `instructor-notes/00-best-practices.md`.

## Format and pedagogy

- [ ] **Switch to one reflection per teaching session.** The instructor's rule across all classes is
      one logbook entry after each teaching day or session, whether the class is taught as a block
      or spread over weeks. This class currently specifies four block entries. Align the points
      table, the reflection-format section, and the `Reflections/refNN.md` evidence in every module
      (eleven entries for eleven sessions). The Sensors class made the change in 2026-11: nine
      entries for nine days, still 4 points.
- [ ] **Adopt the intermediate German grades (1.3, 1.7, 2.3).** The grade-scale table bands points
      (14–15 = 4.0, 16–17 = 3.0, 18–19 = 2.0, 20 = 1.0) and never awards 1.3, 1.7, or 2.3. The
      Sensors class uses the fine 20-point table (20 = 1.0, 19 = 1.3, 18 = 1.7, 17 = 2.0,
      16 = 2.3, 15 = 3.0, 14 = 4.0, below 14 = 5.0) plus a documented 2.7 case for an overall 3.0
      with an exceptionally shaped portfolio. Change the syllabus only — assessment is
      examination-law territory (D5).
- [ ] **Intersperse theory and practice more** (D7). Modules 2–4 still run as *study → lab*; the
      study-and-exchange format in Modules 5, 6a and 6b works better. Convert one module per term,
      not all at once, and write down what changed.
- [ ] **Remove the remaining board assumptions.** The room has no board. In the instructor notes for
      Modules 2, 4 and 5 (and anywhere else the text says “write it on the board”), replace it with
      terminal output, a projected document, or a saved file. Module 6a now uses
      `scratch/warmup-portfolio/06a-recap-output.txt`; use that as the pattern.
- [x] **Rename all remaining “gates” to “exchanges”** (D7). Done 2026-11-19: modules, notes,
      templates and the kickoff mail use **exchange**; the project check is the **story test** and
      the board is the **progress board**. Next run, check that every exchange question is tied to a
      learning goal and a theory box, not only to completion.
- [ ] **Make intensity opt-in everywhere it is possible** (D4; provisional, see discrepancy 5).
      Module 6a now has a core homework and an optional intense track; check whether the same
      shape fits Modules 3–5 (a small core proof plus one ambitious task), and whether students
      actually take the intense track when it is not required.
- [ ] **Handle big pods deliberately** (D13). With more than ~40 students, 20 pods of three means
      the instructor is the bottleneck at every checkpoint. Options that were discussed:
      pair-pods that pre-verify each other; a TA lane at checkpoints; one captain per pod on a
      rotating schedule; jigsaw inside the pod so one member teaches the others; and grading the
      portfolio once at the end instead of per module. Pick **one** per term and measure the time.
- [x] **Get a TA if the cohort is above ~30 students** (D13). Not for grading — for the room:
      restarting containers, finding lost files, and taking a second feedback lane. The checkpoint
      arithmetic is the argument: 20 pods × 10 minutes is 200 minutes. The TA may **suggest points
      and readiness** and **mark individuals for recheck**; the instructor records the final points.
      See the [TA briefing](./TA-briefing.md).
- [ ] **Keep a prepared authentication-vs-authorization minute** (2026-11-19). A mis-owned table
      produced `permission denied for table machine` for the whole room; the 30-second framing
      (“your login worked, your query did not — privileges are per object, per role”) turned the
      failure into the lesson. Put that framing plus `SELECT current_user, session_user;` and
      `\dp` into the 6b instructor note so it is planned, not improvised, and demo one deliberate
      failure next run.
- [ ] **Record the study-and-exchange observations** in [`study-formats.md`](./study-formats.md) for
      Modules 5, 6a and 6b while they are fresh (D7) — especially whether the theory boxes get read
      *when needed* and whether the exchanges are real or performative.
- [ ] **Watch the checkpoint split** across Sessions 8–9 (D13, ADR §4): ten pods each, or two
      lanes with the TA? Write down which one actually happened and how long each slot took.
- [ ] **Decide the two-studio split** (D11). 6a/6b were invented during the run and worked; make
      the split permanent in the module index and the points table, or merge them back after
      recording why the two-session version failed.
- [ ] **Check the one-session bet in Module 5** (D12). Did pods actually do the recap-closed
      homework before 6a, or did 6a lose its first 15 minutes to a recap anyway? One observation
      sentence decides whether the compression holds.
- [ ] **Decide after 17 Dec whether the family shape becomes a syllabus criterion** (D21). This run
      asks for 3–4 actors, 2–3 workflows, one state transition and one cross-entity report as
      *plan quality*, not assessment. Measure: how many teams chose L2, whether the extra actors
      produced evidence or confusion, and whether the individual discussion distinguished
      contributors from passengers.

## Module 5 — carry-over from this run

Many pods concluded that denormalization “buys nothing” — they were measuring a **cold cache**
(D3). The module now warms both sides before timing (two sentences; leave them in), but the
instructor's recap output still shows only storage and row counts. Fix that next time:

- [ ] **Re-measure the A/B race warm** on the teaching laptop before Session 5 and put the medians
      in the recap file next to the storage numbers (≈4.07/11.09 MB) and the row counts (1 vs
      4,000). The timing is what students argue about.
- [ ] **Show cold vs warm side by side** for one query — first run, then second run. It turns
      “denormalization buys nothing” into “I measured the cache”, which was the most common
      finding of the first run.
- [ ] **Update the reference timings** in the private Module 5 solutions file with the warm
      numbers, so the discussion answers and the recap agree.
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
- [x] **Test the native Debian Trixie server guide** ([`postgres-server-setup.md`](./postgres-server-setup.md))
      end to end on the Optiplex. Done 2026-11-19: PostgreSQL 17, pgweb 0.17.0, the named tunnel and
      the credential sheet all worked. The run found one real defect — `machine` was created **as
      `postgres`**, so every pod got `permission denied for table machine` in the room. Section 5
      now creates the table as the pod role and documents the repair; Section 4 revokes `CONNECT`
      from `PUBLIC` so pods cannot open each other's databases.

- [ ] **Preflight the server programmatically before the session** (2026-11-19). Manual checklists
      were read as “done” while the ACL was wrong. A `tools/check-06b-server.sh` must, in under a
      minute and without a browser: create the role and database; create the table **as that role**;
      connect as that role over `127.0.0.1:5432`; run `SELECT`, `UPDATE` and `\dp`; assert
      `pg_get_userbyid(relowner)` is the pod role; assert `CONNECT` is not granted to `PUBLIC`; print
      one PASS/FAIL line per pod and exit non-zero on the first failure. Run it after every rebuild
      and once from a student-like network. The guide's checklist stays as the fallback.

- [ ] **Decide the local/remote strategy for 6b** (D2, D16). Reported after the 2026-11-19 run: the
      shared server was the strongest moment of the session, but the task itself was too shallow —
      once the connection worked it was one `SELECT` and one concurrent `UPDATE`. Options: (a) keep
      local-first as the spine and make the server a genuine **second workload** (many writers,
      sessions, a connection string, a recovery), not a demo; (b) run a local PostgreSQL in the same
      session so the comparison is server-vs-server; (c) move the server work into the project phase
      where team concurrency is real. Pick one and **replace** something — do not add a second
      server lesson on top.
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

## Shared vocabulary with Sensors

- [ ] **Adopt Task → Subtask → Evidence when the modules are next revised.** The Sensors workbook
      settled the student-facing naming in
      [ADR D21](../../hsbi-sensors-actuators-10d/instructor-notes/00-architecture-decisions.md#d21):
      every main divider is `Task N — <outcome>` with `Proves:`/`Produces:`, subtasks are short
      unnumbered moves (max four), every task ends with a standing `Log it`, and the module
      closes with an exchange/evidence task. “Stage”, “Round”, and “Studio” retire as activity
      names. Do not rename by hand mid-run; fold it into the next module revision so students meet
      one vocabulary across the three workbooks.

## Observations, not decisions

These came out of the first run and were not resolved. Anything that becomes a decision moves to
the architecture log §4 and gets a record; do not leave it here as a permanent question.

- Did the case studies at the project kickoff (GoToSocial/Chatto) change the architecture choices,
  or were they forgotten by Session 10?
- Did the performance clinic in Session 9 catch teams early enough to change a schema?
- Did the two-studio Module 6 reduce the “pod study ate the session” problem, or just move it?
- Did the optional intense homework get taken, and by whom — the strong students or the ones who
  need the practice?
- **Is the SQLite concurrency claim measured?** (2026-11-19) The 6b story implies that concurrent
  writers on a file database are slow, but that day neither proved nor disproved it: nobody ran two
  writers with a fixed `busy_timeout`, WAL on and off, and enough contention to move a number.
  Either measure it (N writers, p50/p99 lock wait, WAL vs rollback journal) and put the reference
  table in the instructor note, or stop implying it in the story.
- **Did the announced-absence route carry the day?** (2026-11-19) A large share of the cohort was
  ill but announced it. Did the pod know, did anyone use the video/recording option, and did the
  checkpoint arithmetic survive? One sentence decides whether D18's fallback is real or theoretical.
