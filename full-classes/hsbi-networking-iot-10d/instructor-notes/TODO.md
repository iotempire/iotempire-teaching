# Future work — TODOs for the next run

> Working list, written during the first run (WS 2026/27). Nothing here is a promise; it is the
> memory of what we noticed and did not have time to fix. Tick items as they land, and add the
> observation that motivated them — a TODO without a reason gets dropped.
>
> **Decisions are not made here.** The reasoning belongs in the
> [architecture log](./00-architecture-decisions.md). If an item turns out to be a design choice,
> write the record there and leave only the action here.

## The main design debt: over-specification and bloat

- [ ] **Relieve the whole class from AI over-specification and bloat.** Module 2 was far too
      detailed. It read like a generated checklist: every step was pre-decided, the text explained
      conclusions before students could reach them, and the volume crowded out engagement, own
      research, and the discovery of *why* something works. The result was a module students could
      execute without learning to think like the person who has to debug it.

      **Do not fix Module 2 during this run.** Use the observation as the design constraint for
      everything that follows, starting with Module 3 (Nebula). After the run, audit Module 2 and
      the other modules against it.

      **Keep explicit:** safety-critical commands, credential handling, recovery paths, and the
      minimum hardware facts that prevent damage. **Cut or convert:** step-by-step recipes that
      pre-empt a decision, explanations that arrive before the task creates the need, repeated
      warnings, reference tables that belong in the resource bank, and “do this” instructions where
      a question plus two sources would teach more.

- [ ] **Before Module 3 (Nebula): apply the constraint, do not repeat the pattern.** Keep the
      bundle/credential rules, the working install path, and the cross-NAT proof. Let students
      discover the lighthouse's role, choose router vs. laptop, and debug one failed path. Do not
      write another exhaustive recipe that leaves no room for the why.

- [ ] **Audit Module 2 after the run.** Count the prescribed steps against the actual student
      decisions. For each step ask: *does this prevent damage, or does it prevent thought?* Keep
      the former; rewrite the latter as a decision, a source, or a failure to investigate. Keep the
      story, the discussion map, and the portfolio structure — the problem is the bloat, not the
      studio pattern.

## How to recognise the same problem in another module

- [ ] **A step tells the student what to conclude.** Replace the conclusion with the evidence and
      the question.
- [ ] **A theory box answers a question the task has not raised yet.** Move it after the attempt,
      or turn it into a study break.
- [ ] **There are more commands than decisions.** The module is a runbook, not a studio.
- [ ] **The instructor could read the module aloud and students would never need to look anything
      up.** That is the clearest sign that discovery has been designed out.
- [ ] **Safety and exploration are mixed in the same list.** Separate the non-negotiable guardrails
      from the part students are allowed to own.

## Before the next semester (reset)

- [ ] **Re-run the link/anchor/fence checker and `git diff --check`** from the repository root
      before the first session.
- [ ] **Check the DRAFT BOUNDARY positions** against what was actually taught. Move each boundary
      to the first genuinely provisional section, not to the end by habit.
- [ ] **Re-check the session mapping and hardware assumptions** against the real semester calendar
      and the router/node count that was actually available.
- [ ] **Review the discussion map after the de-bloat.** Every round should still name the learning
      goal and theory box its discussion checks; fewer steps must not mean fewer checks on
      understanding.
- [ ] **Keep the safety net visible.** The de-bloated version may leave more room for failure, but
      flashing, extroot, credential handling, and recovery must remain explicit and demonstrable.

## Shared vocabulary with Sensors

- [ ] **Adopt Task → Subtask → Evidence when the modules are next revised.** The Sensors workbook
      settled the student-facing naming in
      [ADR D21](../../hsbi-sensors-actuators-10d/instructor-notes/00-architecture-decisions.md#d21):
      every main divider is `Task N — <outcome>` with `Proves:`/`Produces:`, subtasks are short
      unnumbered moves (max four), every task ends with a standing `★ Log it`, and the module
      closes with an exchange/evidence task. “Stage”, “Round”, and “Studio” retire as activity
      names. Do not rename by hand mid-run; fold it into the next module revision so students meet
      one vocabulary across the three workbooks.

## Deliberately not in this TODO

- A Module 2 rewrite during the run. Module 3 is next; the redesign waits.
- Removing the story, the discussion log, or the portfolio sections. Those are working parts of the
  format.
- Replacing safety-critical instructions with “let students discover it”. A bricked router is not a
  learning outcome.
- Copying the Databases assessment or module numbers. This class has its own syllabus.
