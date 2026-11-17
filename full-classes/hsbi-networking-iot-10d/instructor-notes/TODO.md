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

- [x] **Before Module 3 (Nebula): apply the constraint, do not repeat the pattern.** Module 3 was
      rewritten for WS 2026/27 as five Task/Subtask/Evidence tasks: Nebula only, router gateway by
      default, direct laptop as a stretcher, Node-RED on the Optiplex cluster, and MQTT through the
      overlay. Yggdrasil is deferred; B.A.T.M.A.N. is an optional showcase. Keep the de-bloat
      constraint for Modules 4–7.

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

## Module 2 — after the first run

- [ ] **Unify the pod SSID naming next run.** Module 2 allows both `pod<NN>` (this workbook) and
      `iotempire<NN>` (the German OpenWrt guide distributed in class, e.g. `iotempire07`). The split
      caused confusion in the room; the damage is done for WS 2026/27, so keep the dual naming for
      now. Next run, pick one scheme before the routers are handed out — likely `iotempire<NN>` to
      match the German guide — and update the module, the resource bank, and the slides together.
      Do not confuse either with the class uplink `iotempire-b1300-5g`.
- [ ] **Revisit the extroot/uplink order.** This run extroots before the uplink (Round 2 before
      Round 3), which works because the class image already contains the extroot packages. The
      German guide joins eduroam first because its script may download packages. With the script now
      in `resources/`, decide next run whether to keep extroot-first (fewer moving parts before
      Round 3) or switch to uplink-first (works on a plain upstream image and matches the German
      guide). If you switch, update Round 2 and the resource-bank recipe.

## Before the next semester (reset)

- [ ] **Re-run `./tools/check-all.sh`** from the repository root before the first session.
- [ ] **Check the DRAFT BOUNDARY positions** against what was actually taught. Move each boundary
      to the first genuinely provisional section, not to the end by habit.
- [ ] **Re-check the session mapping and hardware assumptions** against the real semester calendar
      and the router/node count that was actually available.
- [ ] **Build the slot-by-slot time breakdown from the real calendar.** For every date record the
      time, the type (Übung / Praktikum / betreutes Selbststudium), the minutes, and the school
      hours (45-minute units); sum by type and by day, and check the total against the module
      handbook. Then check that the number of days still fits the module and project distribution.
      The Sensors class needed this in 2026-11: a 90-minute slot is **two** school hours and a
      180-minute slot is four, so a block-count model silently undercounted the term by four hours.
      Keep the breakdown in the instructor notes, not in the student-facing syllabus.
- [ ] **Switch to one reflection per teaching day.** The instructor's rule across all classes is one
      logbook entry after each teaching day or session, whether the class is taught as a block or
      spread over weeks. This class currently specifies one entry per teaching block. Align the
      points table, the reflection-format section, and the `Reflections/refNN.md` evidence in every
      module (ten entries for ten days). The Sensors class made the change in 2026-11: nine entries
      for nine days, still 4 points.
- [x] **Adopt the intermediate German grades (1.3, 1.7, 2.3).** The grade-scale table bands points
      (14–15 = 4.0, 16–17 = 3.0, 18–19 = 2.0, 20 = 1.0) and never awards 1.3, 1.7, or 2.3. The
      Sensors class uses the fine 20-point table (20 = 1.0, 19 = 1.3, 18 = 1.7, 17 = 2.0,
      16 = 2.3, 15 = 3.0, 14 = 4.0, below 14 = 5.0) plus a documented 2.7 case for an overall 3.0
      with an exceptionally shaped portfolio. Change the syllabus only — assessment is
      examination-law territory (D4).
      **Done 2026-11-17:** the fine table, the 2.7 case, and the “orientation, assessed as a whole”
      note are in the syllabus. Keep the tone descriptive; do not turn the table into a task-point
      calculator.
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
