# Instructor Notes — Assessment & Operations (Networking and IoT Solutions)

> **These notes are kept in the open.** Students may read how the course is run, and
> co-teachers can reuse it. The **binding** rules are the RPO/SPO, the module handbook,
> and the decisions of the Prüfungsausschuss; where this page and those documents
> disagree, the documents win. Confirm deadlines and wording with the Prüfungsamt
> before you communicate them.

[All instructor notes](./README.md) · [Syllabus](../syllabus.md) · [Module index](../modules/00-index.md)

## 1. Assessment form

- **Official form:** **Hausarbeit** (*Term Paper / Technical Engineering Report*).
- **Graded artefact:** a formal **technical engineering report** synthesized from the
  challenge portfolio — continuous-text overview, architecture decisions, and
  learning-goal argumentation, with challenge logs, code, schematics, captures, and
  measurements as appendices.
- **Points:** 11 core technologies and lab challenges + 4 reflection and engineering
  decision log + 5 final project = **20**; pass at **14/20**.
- **No other point categories.** Mastery recovery and didactic contributions run
  through the syllabus's **Excellence Stretcher** clause, not through bonus points.
- **Presentation:** the final session presents the last section of the report. That is
  part of the submitted report materials, not a separate examination.
- **Future offering:** the class is project-based, so **Projektarbeit** is the better
  Prüfungsform; recommend the change to the Prüfungsausschuss. The current Hausarbeit
  works, and the portfolio converts to the report without a separate project. The
  20-point learning-goal assessment does not change either way. The rationale is in
  the [architecture decisions](./00-architecture-decisions.md#d4).
- The full statement — including the grade scale — lives **only** in the
  [syllabus](../syllabus.md). This page is the operational view, not a second source.

## 2. Milestone plan

Publish every date in the LMS at the start of the term, and repeat it at least two
weeks before the cut-off. The LMS submission record is the receipt.

| Milestone | What is due | Cut-off | If it is missing |
|---|---|---|---|
| M1 — portfolio skeleton | Portfolio created from the template, instructor added, Module 0/1 evidence and first reflection committed | End of week 1, 23:59 | Written reminder via the LMS, with the remaining dates |
| M2 — foundations | Modules 1–3 evidence + reflection 1 | Start of day 4 | Feedback at the checkpoint; no points decision |
| M3 — technical core | Modules 4–7 evidence + reflections 2–3 | Start of day 8 | Written reminder; the evidence must exist before the final cut-off |
| M4 — report draft | Continuous-text report draft with architecture decisions and appendices outline | Before the project studio | Written reminder; scope review with the team |
| M5 — final technical report | Report + appendices (challenge logs, code, schematics, captures, measurements) | At least 24 h before day 10 | See §5 — this is an examination-law question, not a judgement call |
| M6 — presentation materials | Slides/artifacts for the report-section presentation | At least 24 h before day 10 | See §5 |

> **Do not invent informal extensions.** Documented illness and force majeure follow
> the RPO/SPO procedure; anything else is a decision for the Prüfungsausschuss.
> A missed **feedback checkpoint** is not a graded event: it costs feedback, not points.

## 3. Submission hygiene

- Require a Git commit hash, a repository URL, and the LMS receipt.
- The report must be self-contained at the cut-off; appendices must be reachable from
  the report or the repository.
- Do not grade email attachments or links that are not reachable at the cut-off.
- Keep the submitted commit hash and a local clone for the record.

## 4. Group accountability

The final project is a **Project Team** grade, but contribution must be attributable
individually. Require at least two of:

- **Git commit author history** showing each member's commits and the areas they own.
- **Marked report sections** naming the author of each section and appendix.
- A signed **contributor sign-off** (template below).

If a member does not contribute, record an individual note and assess that member
separately — do not penalise the rest of the team. If one member carries the team,
record that too. Document non-contribution early in the LMS, not at the presentation.

### Contributor sign-off

| Member | Report sections | Network / protocol components | Code / configuration | Captures / measurements | Presentation parts | Date / signature |
|---|---|---|---|---|---|---|
|  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |

## 5. Missed cut-offs and re-examination

- Re-examinations take place in the **next regular examination window**; the
  Prüfungsamt sets registration and dates.
- A retake of the **Hausarbeit** must be a **substantially new project scope** — a new
  stakeholder question or network scenario, a materially different architecture or
  protocol mix, and new measurement/capture evidence. Reusing generic tooling,
  libraries, or the course template is fine. Confirm the exact admissibility rule with
  the Prüfungsamt before you state it.
- Ask for a one-page **new-scope proposal** before the retake and keep it with the
  examination record.

## 6. Records, communication, privacy

- Keep the LMS announcement, submission receipt, commit hash, sign-off, and checkpoint
  notes in the course record.
- Use the LMS for official communication; chat screenshots are not a record.
- Do not publish student names, repositories, grades, or health information. The
  public course repository contains teaching material only.

## 7. AI assistance

AI is a drafting tool; verification is the skill (see the syllabus). Students may use
a co-pilot to turn their **own verified portfolio evidence** into a report draft — the
evidence must exist first, and every claim must be checked. If the RPO/SPO requires a
declaration of AI assistance, help the student write an accurate one; never a
placeholder that hides it. The wording is a question for the Prüfungsamt, not for the
course.

## 8. Instructor checklist

- [ ] Dates entered in the LMS and repeated two weeks before each cut-off.
- [ ] M5/M6 cut-off rule stated in writing, with the RPO/SPO as the reference.
- [ ] Report/appendices submission rule stated in writing.
- [ ] Retake-scope rule confirmed with the Prüfungsamt.
- [ ] Contributor sign-off collected before the presentation.
- [ ] Late and missing cases documented and escalated via the LMS.
- [ ] No informal extra-point promises.
