# New Class Template

A fill-in skeleton for a new workbook. Read [`00-best-practices.md`](./00-best-practices.md) first; this page is the file layout and the headings, not the reasoning.

## 1. Folder layout

```text
full-classes/<class>/
├── README.md                     front door: what the class is, how it runs, links
├── syllabus.md                   binding assessment, schedule, policies
├── pre-study.md                  work before Day 1
├── modules/
│   ├── 00-index.md               module index and session roadmap
│   ├── NN-<topic>.md             one module per teaching day or block
│   ├── Y-resources-prompt-bank.md
│   └── Z-resources-bank.md       datasheets, cheat sheets, canon, troubleshooting
├── instructor-notes/
│   ├── README.md                 index of the class notes
│   ├── 00-architecture-decisions.md
│   ├── 00-assessment-and-operations.md
│   ├── TODO.md
│   ├── NN-<module>-studio.md     run sheet for a risky or guided module
│   └── NN-<module>-student-email.md
├── slides/
│   ├── 01-introduction.md
│   ├── render-slides.sh
│   ├── slides.typ
│   └── pagebreak.lua
└── generate-lms-pdfs.sh          thin wrapper around tools/generate-lms-pdfs.sh
```

## 2. One job per file

| File | Job | Must not contain |
|---|---|---|
| `README.md` | Front door: audience, format, module list, navigation | Assessment rules, task steps |
| `syllabus.md` | The binding assessment, schedule, policies | Task recipes, design rationale |
| `pre-study.md` | Preparation before Day 1 | Graded tasks |
| `modules/00-index.md` | Map: module → day → focus | Points, deadlines |
| `modules/NN-*.md` | The student path for one module | Points, grades, time estimates, checkpoint rules |
| `modules/Z-resources-bank.md` | Reference material and troubleshooting | Assessment, story-only content |
| `modules/Y-resources-prompt-bank.md` | Reflection and verification prompts | Reference tables that belong in Z |
| `instructor-notes/00-architecture-decisions.md` | Decisions, rejected alternatives, open questions | Todo chores, task steps |
| `instructor-notes/TODO.md` | Next-run actions and observations | Decisions |
| `instructor-notes/00-assessment-and-operations.md` | The instructor's runbook: milestones, submissions, templates | The binding assessment text |
| `instructor-notes/NN-*-studio.md` | Room setup, timing, failure modes, answer keys | Binding rules |
| `instructor-notes/NN-*-student-email.md` | Prep mail for toolchain- or material-heavy modules | The whole resource bank |
| `slides/01-introduction.md` | First-session deck, one `---` per page | Assessment detail beyond the syllabus |

## 3. Syllabus skeleton

```md
# Syllabus: <Class> (<German module name>)

## Class Times and Locations
## Instructors & Teaching Team
## Language, Communication & Course Material
## Course Description & Philosophy
  ### The one question this course answers
  ### How we teach
## Learning Objectives
## Course Load & Credits
  ### Where the <N> hours come from
  ### Prerequisites
## Assessment: <form fixed by the handbook>
  ### Part 1 — <artefact> (<points>)
  ### Part 2 — <artefact> (<points>)
  ### Submission
  ### How module points are earned: feedback checkpoints
  ### Task tiers: ★ Core and ◇ Stretcher
  ### Reflection format
  ### Grade Scale
## Tools & Environment
## Hardware Kit & Laboratory Equipment
## <N>-Day Course Schedule
## Final Project Requirements (<points>)
  ### Must-have system criteria
  ### Assessment criteria
## Portfolio & Documentation Standards
## Classroom Policies & Success Strategies
## Contacts & Support
```

Fill the schedule from the real calendar in school hours, not from a block count. Put every point, tier, checkpoint, and deadline in this file only.

## 4. Module skeleton

```md
# Module NN – <Title>

[← Back to Module NN-1](./NN-1-*.md) | [Quick module index](./00-index.md) | [Next: Module NN+1 →](./NN+1-*.md)

**Course placement:** <day, slot, what comes before and after>

## 🎯 Learning Goals
1. …

## 📖 Story — <hook>
<one named cast, one problem, one failure>

## 🧭 How to follow along            <!-- only when the module is presented live -->
<what "follow along" means: build, ask, report problems, slow the instructor down>

## 🔌 ★ Task 1 — <outcome>
**Proves:** <learning goal>
**Produces:** <artefact>
<subtasks>

> **Follow along** if the instructor presents this at the front.

## ✨ ◇ Task 2 (Stretcher) — <outcome>
…

## 🔗 Task N — Exchange and evidence
<peer review, sharing, logging>

## ✅ Suggested portfolio evidence
## 📚 If you want to go deeper
## 📎 Appendix — Hints, resources, prompts
```

Rules: four to six learning goals; `★`/`◇` on every task; no points, no time estimates, no checkpoint rules; the `DRAFT BOUNDARY` sits at the first genuinely provisional section.

## 5. ADR skeleton

```md
# Instructor Notes — Architecture Decisions (<Class>)

> **What this document is.** The design memory of the class: why it has this shape, what was tried and rejected, what a new instructor needs to rebuild it.
> **What it is not.** Not the syllabus, not the module content, not the operations checklist.
> **Precedence.** The syllabus wins for assessment; the module wins for teaching material; `AGENTS.md` wins for agent behaviour.

## How to use this log
### Decision index
| ID | Decision | Status | Encoded in |
|---|---|---|---|

## 1. Provenance — how this class came to be
### 1.1 Three lineages, one class
### 1.2 Timeline
### 1.3 The constraints that shaped the class
### 1.4 What was learned from the sibling classes
### 1.5 How these decisions relate to the sibling logs

## 2. Decision records
<a id="d1"></a>
### D1 — <title>
**Status:** accepted
**Context.** …
**Decision.** …
**Consequences.** …
**Alternatives rejected.** …
**Evidence.** …
**Revisit if.** …

## 3. Rejected alternatives
## 4. Open questions
## 5. Recreation checklist
## Appendix A — Module handbook coverage
## Appendix B — Where the source material lives
## Appendix C — Change log of this document
```

Keep the four statuses (`accepted`, `provisional`, `open`, `rejected`) and the record shape. Add a record when a choice constrains future material, when a plausible alternative is declined, or when a first-run improvisation becomes the pattern.

## 6. TODO skeleton

```md
# Future work — TODOs for the next run

> Working list, written during the run. Nothing here is a promise. Decisions are not made here;
> the reasoning lives in the architecture log.

## Discrepancy watch
| # | Discrepancy | Owner | Meanwhile |
|---|---|---|---|

## Before the next semester (reset)
- [ ] **<action>.** <reason, decision that owns it>

## Format and pedagogy
## Module <n> carry-over
## Infrastructure
## Communication
## Shared vocabulary with <sibling>
## Observations, not decisions
```

## 7. Pre-flight checklist

- [ ] Handbook outcomes and the examination form extracted into a table.
- [ ] Real calendar counted in school hours; day count and project split verified.
- [ ] One-sentence course question written.
- [ ] Syllabus written before the modules; every point, tier, and deadline lives there.
- [ ] Learning goals per module (4–6); `★`/`◇` on every task.
- [ ] `DRAFT BOUNDARY` placed at the first provisional section.
- [ ] Story canon recorded in the resource bank.
- [ ] Hardware chosen per pod, with one known-good spare; the risky path tested by the instructor.
- [ ] ADR and TODO created with the shared shape and statuses.
- [ ] Project artefact chosen, and it survives leaving the room.
- [ ] Reflection rule: one entry per teaching day; the syllabus states the count.
- [ ] Grade table with intermediate steps; exceptions documented before the term.
- [ ] Project `AGENTS.md` with board, pinout, library, and power guardrails.
- [ ] Prep email drafted for every toolchain-heavy module.
- [ ] `./tools/check-all.sh` passes; slides rendered and page-checked.
- [ ] LMS PDFs generated with `./generate-lms-pdfs.sh`.
