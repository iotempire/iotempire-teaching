# Future work — TODOs for the next run

> Working list, written during the first run (WS 2026/27). Nothing here is a promise; it is the
> memory of what we noticed and did not have time to fix. Tick items as they land, and add the
> observation that motivated them — a TODO without a reason gets dropped.

## Before the next semester (reset)

- [ ] **Move every `DRAFT BOUNDARY` back to its start position.** At the end of this run the
      boundary sits at the *end* of Modules 1–5 (everything was taught and revised); Modules 6a,
      6b, 7 and 8 still start with it near the top. Reset all of them to the first section that is
      genuinely provisional, and keep the sentence that explains what the boundary means.
- [ ] **Re-check the dates and the session mapping** in the syllabus against the real semester
      calendar — the 11-session plan moved twice during the run.
- [ ] **Re-run the smoke test and validation** on the machines you will teach from before the
      first session: `sh scratch/smoke-test.sh all` and `python scratch/validate-all.py`.
- [ ] **Refresh the numbers** in the module stories (M5 4.07/11.09 MB, M6a 2M rows and the warm
      timings) if you change the datasets or the SQLite/DuckDB versions.

## Format and pedagogy

- [ ] **Intersperse theory and practice more.** Modules 2–4 still run as *study → lab*; the
      stage-and-gate format in Modules 5, 6a and 6b works better. Convert one module per term,
      not all at once, and write down what changed.
- [ ] **Rename all remaining “gates” to “discussions”** and link each discussion explicitly to
      the module's **learning goal** and the **theory box** it tests. Modules 5, 6a and 6b already
      do this in different degrees; Modules 1–4 still say “gate” and some prompts only check
      completion, not understanding.
- [ ] **Make intensity opt-in everywhere it is possible.** Module 6a now has a core homework and
      an optional intense track; check whether the same shape fits Modules 3–5 (a small core proof
      plus one ambitious task), and whether students actually take the intense track when it is
      not required.
- [ ] **Handle big pods deliberately.** With more than ~40 students, 20 pods of three means the
      instructor is the bottleneck at every checkpoint. Options that were discussed:
      pair-pods that pre-verify each other; a TA lane at checkpoints; one captain per pod on a
      rotating schedule; jigsaw inside the pod so one member teaches the others; and grading the
      portfolio once at the end instead of per module. Pick **one** per term and measure the time.
- [ ] **Get a TA if the cohort is above ~30 students.** Not for grading — for the room: restarting
      containers, finding lost files, and taking a second feedback lane. The checkpoint arithmetic
      is the argument: 20 pods × 10 minutes is 200 minutes.
- [ ] **Record the stage-and-gate observations** in [`study-formats.md`](./study-formats.md) for
      Modules 5, 6a and 6b while they are fresh — especially whether the theory boxes get read
      *when needed* and whether the discussions are real or performative.
- [ ] **Watch the checkpoint split** across Sessions 8–9: ten pods each, or two lanes with the TA?
      Write down which one actually happened and how long each slot took.

## Infrastructure

- [ ] **Keep one deliberately slow PostgreSQL database running** as a reference for “slow”. The
      idea: a server with small buffers, a network hop, and a genuinely unindexed query, so a
      live comparison (“this is what 40 minutes feels like”) exists beyond the story. The
      [`postgres-tunnel.sh`](./postgres-tunnel.sh) setup is the starting point; add a
      “slow-mode” profile with tiny `shared_buffers` and `work_mem=64kB`.
- [ ] **Standardise the warm-cache methodology.** Module 5 now tells students to run each query
      once untimed before measuring, and Module 6a's `race.py` does a warm-up run per engine.
      Apply the same sentence to every benchmark in the course, and say explicitly that **cold
      cache is not a result** — it is the reason denormalization looked useless to half the room.
- [ ] **Re-test the Cloudflare/Podman script** from a student-like network before relying on it;
      the quick-tunnel mode is the fallback for instructors without a domain.
- [ ] **Check the DuckDB/Parquet path on Windows** once (the course assumes Git Bash or WSL for
      heredocs; the Python path should work everywhere).

## Communication

- [ ] **Send prep and expectation emails at least three days before each session.** The module
      files carry `PREP EMAIL` markers (grep for them); the email should say what to bring, what
      to finish, and what will happen in the room — not a summary of the content.
- [ ] **Announce the checkpoint order and the slot length a week ahead**, with the template
      pre-filled. The “book the order” step is the one that always slips.
- [ ] **Announce the project milestone dates in Session 8**, not week by week — students plan
      better when the whole arc is visible, and the course promised them their own dates.

## Open questions from the first run

- Did the case studies at the project kickoff (GoToSocial/Chatto) change the architecture choices,
  or were they forgotten by Session 10?
- Did the performance clinic in Session 9 catch teams early enough to change a schema?
- Did the two-studio Module 6 reduce the “pod study ate the session” problem, or just move it?
- Did the optional intense homework get taken, and by whom — the strong students or the ones who
  need the practice?
