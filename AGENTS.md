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

## Edits: reviewable by default

- Change file content with `edit_file` or `write_file`, not with shell writes (`python3 - <<...`, `sed -i`, `tee`, redirection).
- One logical change per edit; keep the diff reviewable.
- No mass renames, bulk rewrites, or scripted edits across many files without explicit approval.
- Read a file before editing it; verify the result with `read_file` or `grep`, not by assuming the edit applied.

Terminal file writes bypass the editor's change review; that is why the editor's tool permissions treat them as a separate, confirmable action.

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
- Groups: `Task Pod` (2–3), `Project Team` (4–6). Tiers: `★ Core`, `◇ Stretcher`, `Excellence Stretcher`. Do not introduce synonyms.
- Do not reintroduce Stage/Round/Studio as activity names in `hsbi-*`; the reasoning is Sensors [D21](full-classes/hsbi-sensors-actuators-10d/instructor-notes/00-architecture-decisions.md#d21).

## One fact, one home

- Assessment → syllabus. Design rationale → class ADR. Technical reference → `modules/Z-resources-bank.md`. Teaching hints and answer keys → `instructor-notes/`. Student text → module.
- Link instead of duplicating. If a fact belongs elsewhere, move it and leave a link.

## Stories and canon

- Keep the recurring cast consistent with the canon table in the class resource bank. Record new recurring names there before reusing them.
- Stories may be extended by what students observe; do not invent a second canon.

## Definition of done

- Run the class link/anchor/fence checker and `git diff --check`; every relative link resolves and every fence is balanced.
- Do not claim validation you did not run. Report the command and its output.
- Report what changed (file and section), what you deliberately did not change, and open questions.
- Do not fix unrelated problems silently; list them separately.

## Memory

- Decisions and their rationale go in the class ADR; next-run actions go in the class `TODO.md`. Do not put decisions in the TODO or next-run chores in the ADR.
- When a cross-class rule changes, update this file and link the ADR record that owns it.

## Class-specific rules

- Board IDs, hardware, story canon, and class-specific agent notes live in `full-classes/<class>/instructor-notes/00-architecture-decisions.md`.
- Operative rules are not repeated there; each ADR records the decision and links here.
