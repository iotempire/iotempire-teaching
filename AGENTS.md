# AGENTS.md — repository working agreement

This file is the operative contract for agents working in this repository. It is kept short and imperative; the reasoning behind a rule lives in the class architecture log, not here.

**Scope.** The git, privacy, editing, validation, and language rules apply to the whole repository. The vocabulary rules apply to `full-classes/hsbi-*`; other workbooks keep their own vocabulary until they are migrated.

**Precedence.** Assessment rules: the class `syllabus.md` wins. Design rationale: the class `instructor-notes/00-architecture-decisions.md`. Teaching material: the module. Agent behavior: this file.

## Git: never commit

- Never run `git commit`, `git commit --amend`, `git rebase`, `git tag`, `git reset`, or `git push` unless the instructor explicitly asks for it in the current conversation.
- Leave every change in the working tree. The instructor reviews the diff and commits.
- If a commit is explicitly requested, scope it to the files named in that request; do not fold in other work.
- Never write Git metadata.

Rationale: Sensors [D22](full-classes/hsbi-sensors-actuators-10d/instructor-notes/00-architecture-decisions.md#d22), Databases [D20](full-classes/hsbi-databases-10d/instructor-notes/00-architecture-decisions.md#d20), Networking [D18](full-classes/hsbi-networking-iot-10d/instructor-notes/00-architecture-decisions.md#d18).

## Commit messages

The instructor commits; the rules above still apply. When you are asked to write a commit message, use this shape for anything larger than a one-line fix:

```text
<area>: <imperative summary>

<What changed, grouped by area: two to four bullets or one short paragraph.>
<Why it changed: the decision, the run evidence, or the constraint.>

Decisions: <class D-numbers, if any>
```

- **Subject:** `<area>: <summary>`, at most 72 characters, imperative, no trailing period. Use `sensors`, `databases`, `networking`, `repo`, `tools`, or `instructor-notes` as the area.
- **Body:** lead with the student-facing change, then the design or assessment change, then the tooling. Do not list every file.
- **Big changes:** one bullet per coherent area; name the decision IDs and where the binding text lives. State migrations, follow-ups, and known gaps.
- **Validation is not part of the message.** Run `./tools/check-all.sh` before you commit and report the result in the conversation; the commit body carries decisions and context, not check output.
- **Do not add AI attribution** unless the repository asks for it.
- **Never amend, squash, or rewrite history** unless the instructor explicitly asks.

Example:

```text
sensors: make Module 6 a two-controller panel studio

- Module 6 uses an ESP32 Dev Module for the 32×32 HUB75 panel and an
  M5StickC-S3 for microphone/IMU, linked over UART (ESP-NOW optional).
- Task 1 is first light without AI; Task 2 is AI-scaffolded; Task 3 is a
  mandatory play task that starts with a story hook and stays open.
- Adds the tracked reference lab in instructor-notes/module6-panel-lab/.

Why: Module 5's evaluation showed that a no-AI first win plus an open end
produces both confidence and creativity; the panel needs two boards.

Decisions: Sensors D19 (accepted), D24 (provisional)
```

## Edits: reviewable by default

- Change file content with `edit_file` or `write_file`, not with shell writes (`python3 - <<...`, `sed -i`, `tee`, redirection).
- One logical change per edit; keep the diff reviewable.
- No mass renames, bulk rewrites, or scripted edits across many files without explicit approval.
- Read a file before editing it; verify the result with `read_file` or `grep`, not by assuming the edit applied.

Terminal file writes bypass the editor's change review; that is why the editor's tool permissions treat them as a separate, confirmable action.

## Validation: only the repository scripts

- After any edit run `./tools/check-all.sh`. It checks relative links, anchors, code fences, slide-deck page counts, and `git diff --check`.
- Targeted runs: `./tools/check-docs.sh [PATH ...]` and `./tools/check-slides.sh`.
- These three commands are the **only** pre-approved validation commands. Do not run `git`, `python3`, or ad-hoc link/fence one-liners for validation; extend `tools/check-docs.py` instead.
- The scripts are read-only. They never write to the working tree and never touch Git metadata.
- Known issues go in `tools/check-docs-baseline.txt`, each tied to a TODO that tracks it. Do not silence a new issue by adding it to the baseline without a tracker.

## Private material

- `untracked/` is private and git-ignored. Never read it into tracked files and never reference it in course documents.

## Assessment

- Assessment lives only in the class `syllabus.md`.
- Never add points, grades, checkpoint rules, tier explanations, or time estimates to a module.
- Module evidence is suggested, not prescribed: students may prove the same goal another way.

## Language

- Written material is English. German may be spoken in class; German technical terms in parentheses are fine.
- Do not write new student-facing material in German.

## Vocabulary

- Activity structure: Task → Subtask → Evidence.
- Groups: `Task Pod` (2–3), `Project Team` (4–6; up to 9 when the cohort forces three pods). Tiers: `★ Core`, `◇ Stretcher`, `Excellence Stretcher`. Do not introduce synonyms.
- The study→practice moment is an **Exchange**, not a gate: a short peer share that opens the next move. The final-project check is the **Story test**, and the shared progress list is the **progress board**. Do not use “gate” as an activity name.
- Do not reintroduce Stage/Round/Studio as activity names in `hsbi-*`; the reasoning is Sensors [D21](full-classes/hsbi-sensors-actuators-10d/instructor-notes/00-architecture-decisions.md#d21).

## Typography: use markers sparingly

- `★` and `◇` are **tier markers on task headings**, nothing else. Use them on `★ Task N` / `◇ Task N` where the tier matters; do not put them on subtasks, log lines, evidence lines, emphasis, or status labels. `Log it`, `Done when`, `Proves`, and `Produces` are plain text.
- **One marker per heading.** If a heading already carries a semantic marker — a `★`/`◇` tier, a `**Challenging**`/`**Short and Dry**` difficulty label, or a navigation emoji such as 🎯 — do not add a decorative emoji in front of it. Keep the marker that has a function and drop the other.
- **No AI markers.** Do not use ✨, 🤖, 🧠, 🚀, 🔥, or similar symbols. A heading, a task, or a prompt says what it is in words; the sparkle and robot make the material feel generated and hollow, and they distract from the learning.
- A single emoji is allowed only when it helps scanning (for example 🎯 for Learning Goals or ✅ for the evidence list). Otherwise, plain text.
- Apply this to every workbook under `full-classes/`, not only `hsbi-*`.
- Existing marker clusters are legacy. Do not add new ones; do not mass-remove single navigation emoji without an explicit request.

## One fact, one home

- Assessment → syllabus. Design rationale → class ADR. Technical reference → `modules/Z-resources-bank.md`. Teaching hints and answer keys → `instructor-notes/`. Student text → module. Cross-class patterns and the new-class checklist → [`instructor-notes/`](./instructor-notes/README.md).
- Link instead of duplicating. If a fact belongs elsewhere, move it and leave a link.

## Stories and canon

- Keep the recurring cast consistent with the canon table in the class resource bank. Record new recurring names there before reusing them.
- Stories may be extended by what students observe; do not invent a second canon.

## Definition of done

- Run `./tools/check-all.sh`; every relative link resolves and every fence is balanced. It also reports slide page counts and `git diff --check`.
- Do not claim validation you did not run. Report the command and its output.
- Report what changed (file and section), what you deliberately did not change, and open questions.
- Do not fix unrelated problems silently; list them separately.

## Memory

- Decisions and their rationale go in the class ADR; next-run actions go in the class `TODO.md`. Do not put decisions in the TODO or next-run chores in the ADR.
- When a cross-class rule changes, update this file and link the ADR record that owns it.

## Class-specific rules

- Board IDs, hardware, story canon, and class-specific agent notes live in `full-classes/<class>/instructor-notes/00-architecture-decisions.md`.
- Operative rules are not repeated there; each ADR records the decision and links here.
