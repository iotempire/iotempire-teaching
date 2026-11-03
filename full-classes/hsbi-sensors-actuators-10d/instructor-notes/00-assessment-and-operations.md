# Instructor Notes — Assessment & Operations (Sensors and Actuators)

> **These notes are kept in the open.** Students may read how the course is run, and
> co-teachers can reuse it. The **binding** rules are the RPO/SPO, the module handbook,
> and the decisions of the Prüfungsausschuss; where this page and those documents
> disagree, the documents win. Confirm deadlines and wording with the Prüfungsamt
> before you communicate them.

[All instructor notes](./README.md) · [Syllabus](../syllabus.md) · [Module index](../modules/00-index.md)

## 1. Assessment form

- **Official form:** **Kombinationsprüfung**.
- **Part 1 — written portfolio documentation (75% / 15 points):** 11 points core
  technologies and lab challenges + 4 points reflection and engineering decision log.
- **Part 2 — project documentation and presentation materials (25% / 5 points):**
  3 points code and system documentation + 2 points slide deck and demo artifacts.
- **Pass mark:** 14/20. **No other point categories** — mastery recovery runs through
  the syllabus's **Excellence Stretcher** clause.
- **The presentation is artifact-based.** Part 2 is assessed from what was submitted:
  documentation, code/system artifacts, slide deck, demo artifacts. The final session
  is an **artifact presentation, not an oral examination**.
- The full statement — including the grade scale — lives **only** in the
  [syllabus](../syllabus.md).

## 2. Milestone plan

Publish every date in the LMS at the start of the term, and repeat it at least two
weeks before the cut-off. The LMS submission record is the receipt.

| Milestone | What is due | Cut-off | If it is missing |
|---|---|---|---|
| M1 — portfolio skeleton | Portfolio created from the template, instructor added, Module 0/1 evidence and first reflection committed | End of week 1, 23:59 | Written reminder via the LMS, with the remaining dates |
| M2 — Part 1 foundations | Modules 1–3 evidence + reflection 1 | Start of day 4 | Feedback at the checkpoint; no points decision |
| M3 — Part 1 core | Modules 4–6 evidence + reflections 2–3 | Start of day 8 | Written reminder; the evidence must exist before the final cut-off |
| M4 — Part 1 final | Complete written portfolio documentation (Modules 0–8 + four reflections) | At least 24 h before day 10 | See §5 — this is an examination-law question, not a judgement call |
| M5 — Part 2 code/system docs | Project repository, code, wiring/architecture, characterization, measurement evidence | At least 24 h before day 10 | See §5 |
| M6 — Part 2 slide deck/demo artifacts | Slide deck and demo artifacts for the artifact presentation | At least 24 h before day 10 | See §5 |

> **Do not invent informal extensions.** Documented illness and force majeure follow
> the RPO/SPO procedure; anything else is a decision for the Prüfungsausschuss.

## 3. Submission hygiene

- Require a Git commit hash, a repository URL, and the LMS receipt for Part 1.
- Keep a separate Part 2 submission record for documentation, slide deck, and demo
  artifacts.
- Do not grade email attachments or links that are not reachable at the cut-off.
- Keep the submitted commit hash and a local clone for the record.

## 4. Group accountability

Part 2 is a **Project Team** grade, but contribution must be attributable
individually. Require at least two of:

- **Git commit author history** showing each member's commits and the areas they own.
- **Marked report sections** naming the author of each section.
- A signed **contributor sign-off** (template below).

If a member does not contribute, record an individual note and assess that member
separately — do not penalise the rest of the team. If one member carries the team,
record that too. Document non-contribution early in the LMS, not at the presentation.

### Contributor sign-off

| Member | Report sections | Sensors / actuators | Code / firmware | Measurements | Slides / demo artifacts | Date / signature |
|---|---|---|---|---|---|---|
|  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |

## 5. Missed cut-offs and re-examination

- Re-examinations take place in the **next regular examination window**; the
  Prüfungsamt sets registration and dates.
- A retake of Part 2 must be a **substantially new project scope** — a new stakeholder
  question or application, a materially different sensor/actuator architecture or
  characterization, and new measurement evidence. Reusing generic libraries, the
  course template, or standard lab techniques is fine. Confirm the exact
  admissibility rule with the Prüfungsamt before you state it.
- Ask for a one-page **new-scope proposal** before the retake and keep it with the
  examination record.
- Never convert the artifact presentation into an ad-hoc oral examination to
  compensate for missing artifacts.

## 6. Records, communication, privacy

- Keep the LMS announcement, submission receipts, commit hash, sign-off, and
  checkpoint notes in the course record.
- Use the LMS for official communication; chat screenshots are not a record.
- Do not publish student names, repositories, grades, or health information. The
  public course repository contains teaching material only.

## 7. AI assistance

AI is a drafting tool; verification is the skill (see the syllabus). In a lab course
the measurement, the calibration, and the working circuit come first. If the RPO/SPO
requires a declaration of AI assistance, help the student write an accurate one —
never a placeholder that hides it.

## 8. Instructor checklist

- [ ] Dates entered in the LMS and repeated two weeks before each cut-off.
- [ ] Part 1 and Part 2 cut-off rules stated in writing, with the RPO/SPO as reference.
- [ ] Artifact-presentation rule stated in writing: assessed from the submitted artifacts.
- [ ] Retake-scope rule confirmed with the Prüfungsamt.
- [ ] Contributor sign-off collected before the artifact presentation.
- [ ] Late and missing cases documented and escalated via the LMS.
- [ ] No informal extra-point promises.
