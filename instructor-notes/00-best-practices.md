# Best Practices Across the HSBI Classes

> **What this is.** The cross-class distillation of the architecture decisions recorded in the [Sensors](../full-classes/hsbi-sensors-actuators-10d/instructor-notes/00-architecture-decisions.md), [Databases](../full-classes/hsbi-databases-10d/instructor-notes/00-architecture-decisions.md), and [Networking](../full-classes/hsbi-networking-iot-10d/instructor-notes/00-architecture-decisions.md) workbooks, plus the repository working agreement in [`AGENTS.md`](../AGENTS.md). It is the reference for building a new class and the checklist for repairing an existing one.
>
> **What it is not.** It is not a second ADR and it does not bind a class. The **class ADR wins** for that class; the class **syllabus wins** for assessment. This document only records what travelled well between classes and why.
>
> **Status.** First extraction, 2026-11-16, from the three HSBI logs and the first run of the Sensors class. Add a record here only when a pattern has survived at least two classes or is a hard repository rule.

## How to read this

Every entry names its **strength**:

| Strength | Meaning |
|---|---|
| **Invariant** | Held in every current class. Changing it is a repository-level decision, not a class decision. |
| **Default** | Held in at least two classes. Deviate only with a record in the class ADR. |
| **Pattern** | Works when the conditions match. Copy deliberately, not by habit. |

Sources use the class name and the decision number, linked to the record: `Sensors D1` means the `d1` record in that class's architecture log.

## 1. The invariants

| # | Invariant | Where it comes from |
|---|---|---|
| I1 | **The module handbook is the outer constraint; the didactics are ours.** Extract outcomes and the examination form first, then design the studio inside them. | [Sensors D1](../full-classes/hsbi-sensors-actuators-10d/instructor-notes/00-architecture-decisions.md#d1) · [Databases D1](../full-classes/hsbi-databases-10d/instructor-notes/00-architecture-decisions.md#d1) · [Networking D1](../full-classes/hsbi-networking-iot-10d/instructor-notes/00-architecture-decisions.md#d1) |
| I2 | **Learning goals are the contract; tasks are negotiable.** A student may skip, fail, or replace a task if the goals are proved another way. | [Sensors D3](../full-classes/hsbi-sensors-actuators-10d/instructor-notes/00-architecture-decisions.md#d3) · [Databases D4](../full-classes/hsbi-databases-10d/instructor-notes/00-architecture-decisions.md#d4) · [Networking D3](../full-classes/hsbi-networking-iot-10d/instructor-notes/00-architecture-decisions.md#d3) |
| I3 | **Assessment lives only in the syllabus.** Points, tiers, checkpoints, deadlines, and the grade scale never appear in a module. | [Sensors D4](../full-classes/hsbi-sensors-actuators-10d/instructor-notes/00-architecture-decisions.md#d4) · [Databases D5](../full-classes/hsbi-databases-10d/instructor-notes/00-architecture-decisions.md#d5) · [Networking D4](../full-classes/hsbi-networking-iot-10d/instructor-notes/00-architecture-decisions.md#d4) |
| I4 | **One fact, one home; one document, one job.** If a sentence fits better in another file, it belongs there. Link instead of duplicating. | [Sensors D14](../full-classes/hsbi-sensors-actuators-10d/instructor-notes/00-architecture-decisions.md#d14) · [Databases D8](../full-classes/hsbi-databases-10d/instructor-notes/00-architecture-decisions.md#d8) · [Networking D13](../full-classes/hsbi-networking-iot-10d/instructor-notes/00-architecture-decisions.md#d13) |
| I5 | **The class is a draft in motion, with a visible boundary.** Provisional material sits below a `DRAFT BOUNDARY`; the boundary moves as the material settles. | [Sensors D17](../full-classes/hsbi-sensors-actuators-10d/instructor-notes/00-architecture-decisions.md#d17) · [Databases D9](../full-classes/hsbi-databases-10d/instructor-notes/00-architecture-decisions.md#d9) · [Networking D14](../full-classes/hsbi-networking-iot-10d/instructor-notes/00-architecture-decisions.md#d14) |
| I6 | **English material, bilingual delivery.** Written material is English; German may be spoken; German technical terms in parentheses are fine. | [Sensors D16](../full-classes/hsbi-sensors-actuators-10d/instructor-notes/00-architecture-decisions.md#d16) · [Databases D17](../full-classes/hsbi-databases-10d/instructor-notes/00-architecture-decisions.md#d17) · [Networking D16](../full-classes/hsbi-networking-iot-10d/instructor-notes/00-architecture-decisions.md#d16) |
| I7 | **Agents never commit; the instructor reviews.** No `commit`, `amend`, `rebase`, `tag`, `reset`, or `push` without an explicit instruction. | [Sensors D22](../full-classes/hsbi-sensors-actuators-10d/instructor-notes/00-architecture-decisions.md#d22) · [Databases D20](../full-classes/hsbi-databases-10d/instructor-notes/00-architecture-decisions.md#d20) · [Networking D18](../full-classes/hsbi-networking-iot-10d/instructor-notes/00-architecture-decisions.md#d18) · [`AGENTS.md`](../AGENTS.md) |
| I8 | **Validation is scripted, not improvised.** `./tools/check-all.sh` is the only pre-approved validation command; extend the tool instead of running ad-hoc `git` or `python3` checks. | [`AGENTS.md`](../AGENTS.md) · [`tools/README.md`](../tools/README.md) |

## 2. The design sequence for a new class

The order matters more than the artefacts. Each step names the decision it encodes.

1. **Read the binding handbook and the examination regulations.** Extract the outcomes and the examination form into a table. Do not design the studio before this table exists (I1).
2. **Fix the format from the real calendar.** Count the actual slots in school hours (45-minute units), not in "blocks"; verify the day count and the module/project split against that count. Record the pattern in the LMS; do not publish a block-count contract (D1, D2 below).
3. **Write the one question the course answers.** For Networking: *how do I connect devices that do not share a network, a provider, or a trust domain — and keep the system working when a link dies?* A course without one question becomes a catalogue.
4. **Choose the assessed artefact and write the syllabus first.** Portfolio → report, portfolio → project, or portfolio → Projektarbeit/Hausarbeit. Every point, tier, checkpoint, and deadline goes there (I3).
5. **Define the evidence chain.** Evidence → reflection → learning-goal argumentation. Decide the per-day reflection rule and the checkpoint rhythm (C1–C3).
6. **Write the learning goals per module, then the tasks.** Four to six goals per module. Mark each task `★ Core` or `◇ Stretcher`; put the provisional material below the `DRAFT BOUNDARY` (I2, I5).
7. **Build the story and the canon.** One named cast, one story per module, one hook per task. Record new recurring names in the resource bank before reuse (B3).
8. **Choose hardware per pod, and buy a spare.** Flash, wire, calibrate, and break the risky path yourself before writing the steps. Write the recovery note from the failure, not from the manual (B6).
9. **Write the studio rhythm and the vocabulary into the template.** Challenge → practice → theory on demand → discussion; Task → Subtask → Evidence (B1, B5).
10. **Write the ADR and the TODO, then run `./tools/check-all.sh`.** The ADR records the decisions; the TODO records the next-run actions (G1–G5).

## 3. The catalogue

### A. Governance and documents

#### A1. Keep the handbook's language, but design your own studio
**Practice.** Quote the handbook's outcomes in the syllabus, then translate them into what students will actually build, measure, and explain. Where the handbook says "z.B." (for example), it is a menu, not a checklist.
**Why.** The examination law binds the outcomes; the room binds the method. Confusing the two either flattens the class into a lecture catalogue or invents outcomes the exam cannot defend.
**Sources.** [Sensors D1](../full-classes/hsbi-sensors-actuators-10d/instructor-notes/00-architecture-decisions.md#d1) · [Databases D1](../full-classes/hsbi-databases-10d/instructor-notes/00-architecture-decisions.md#d1) · [Networking D1](../full-classes/hsbi-networking-iot-10d/instructor-notes/00-architecture-decisions.md#d1). **Strength:** invariant.

#### A2. Give every file exactly one job
**Practice.** Syllabus = assessment. Module = student path. ADR = decisions and rationale. TODO = next-run actions. Assessment-and-operations = the instructor's runbook. Resource bank = reference. Prompt bank = prompts. Instructor studio notes = preparation and answer keys. If a sentence fits another file, move it and leave a link.
**Why.** Duplication drifts silently. The first time two files disagree, the student is right to trust neither.
**Sources.** [Sensors D14](../full-classes/hsbi-sensors-actuators-10d/instructor-notes/00-architecture-decisions.md#d14) · [Databases D8](../full-classes/hsbi-databases-10d/instructor-notes/00-architecture-decisions.md#d8) · [Networking D13](../full-classes/hsbi-networking-iot-10d/instructor-notes/00-architecture-decisions.md#d13). **Strength:** invariant.

#### A3. Make the draft boundary explicit
**Practice.** Put `> **⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**` at the first genuinely provisional section. Move it up as material settles; move it back at the start of a new run.
**Why.** It lets the class ship before it is perfect without pretending that it is. It also tells students which tasks they may replace.
**Sources.** [Sensors D17](../full-classes/hsbi-sensors-actuators-10d/instructor-notes/00-architecture-decisions.md#d17) · [Databases D9](../full-classes/hsbi-databases-10d/instructor-notes/00-architecture-decisions.md#d9) · [Networking D14](../full-classes/hsbi-networking-iot-10d/instructor-notes/00-architecture-decisions.md#d14). **Strength:** invariant.

#### A4. Write for maintenance, not for the first offering
**Practice.** Every module names its learning goals; every decision record names its reversal trigger; every risky session has an instructor note; every repeated fact has one home. A new instructor should be able to rebuild the class from the repository.
**Why.** Classes outlive the person who designed them. The recreation checklist is the test of whether the repository is the source of truth.
**Sources.** [Sensors §5](../full-classes/hsbi-sensors-actuators-10d/instructor-notes/00-architecture-decisions.md#5-recreation-checklist) · [Databases §5](../full-classes/hsbi-databases-10d/instructor-notes/00-architecture-decisions.md#5-recreation-checklist) · [Networking §5](../full-classes/hsbi-networking-iot-10d/instructor-notes/00-architecture-decisions.md#5-recreation-checklist). **Strength:** invariant.

### B. Teaching rhythm

#### B1. Practice is the spine; theory arrives on demand
**Practice.** Start from a challenge, let students hit the need for the theory, then give the brief. Do not open with the lecture that answers questions the task has not raised yet.
**Why.** The class is assessed on what students can build, measure, and explain — not on what they can recite.
**Sources.** [Sensors D6](../full-classes/hsbi-sensors-actuators-10d/instructor-notes/00-architecture-decisions.md#d6) · [Databases D7](../full-classes/hsbi-databases-10d/instructor-notes/00-architecture-decisions.md#d7) · [Networking D6](../full-classes/hsbi-networking-iot-10d/instructor-notes/00-architecture-decisions.md#d6). **Strength:** invariant.

#### B2. One question, one story, one canon
**Practice.** Write the single question the course answers. Give each module one story with a named cast and a concrete failure. Keep the recurring names in one canon table in the resource bank.
**Why.** Stories carry the *why* that a task list cannot. A second canon is worse than no canon: students stop trusting both.
**Sources.** [Sensors D5](../full-classes/hsbi-sensors-actuators-10d/instructor-notes/00-architecture-decisions.md#d5) · [Databases D6](../full-classes/hsbi-databases-10d/instructor-notes/00-architecture-decisions.md#d6) · [Networking D5](../full-classes/hsbi-networking-iot-10d/instructor-notes/00-architecture-decisions.md#d5). **Strength:** invariant.

#### B3. Use one vocabulary, and retire the synonyms
**Practice.** Task → Subtask → Evidence. `Task Pod` (2–3), `Project Team` (4–6), `★ Core`, `◇ Stretcher`, `Excellence Stretcher`. Do not reintroduce Stage/Round/Studio as activity names in the `hsbi-*` workbooks.
**Why.** Students navigate by the words in the schedule. A second name for the same thing reads as a second requirement.
**Sources.** [Sensors D21](../full-classes/hsbi-sensors-actuators-10d/instructor-notes/00-architecture-decisions.md#d21) · [`AGENTS.md`](../AGENTS.md). **Strength:** default.

#### B4. Compress breadth into reading, not into the bench
**Practice.** When the handbook lists more principles than the days allow, keep the ones the kit can demonstrate on the bench and move the rest into a short lecture or a reading table with a check. Mark them as reading homework.
**Why.** A touched sensor teaches more than five recited ones; a named reading still covers the catalogue.
**Sources.** [Sensors D18](../full-classes/hsbi-sensors-actuators-10d/instructor-notes/00-architecture-decisions.md#d18) · [Networking D12](../full-classes/hsbi-networking-iot-10d/instructor-notes/00-architecture-decisions.md#d12). **Strength:** default.

#### B5. Match the hardware to the room, not to the catalogue
**Practice.** Build the lab around what the kit actually contains; if a part is missing, demote it to the story or to a comparison. Sharing equipment is normal; do not invent an allocation process for three multimeters.
**Why.** A lab that depends on hardware nobody has becomes a demo. Sharing is cheaper than pretending.
**Sources.** [Sensors D7](../full-classes/hsbi-sensors-actuators-10d/instructor-notes/00-architecture-decisions.md#d7) · [Sensors D12](../full-classes/hsbi-sensors-actuators-10d/instructor-notes/00-architecture-decisions.md#d12) · [Networking D8](../full-classes/hsbi-networking-iot-10d/instructor-notes/00-architecture-decisions.md#d8). **Strength:** default.

### C. Assessment and evidence

#### C1. Assess the artefact, not the performance
**Practice.** Choose the submitted artefact — portfolio, report, repository, video — and assess that. A live session may be a rehearsal or a defence, but it is not the only evidence.
**Why.** A performance on one afternoon measures nerves as much as competence; an artefact can be read, checked, and re-read.
**Sources.** [Sensors D4](../full-classes/hsbi-sensors-actuators-10d/instructor-notes/00-architecture-decisions.md#d4) · [Databases D5](../full-classes/hsbi-databases-10d/instructor-notes/00-architecture-decisions.md#d5) · [Networking D4](../full-classes/hsbi-networking-iot-10d/instructor-notes/00-architecture-decisions.md#d4). **Strength:** invariant.

#### C2. Make checkpoints feedback, not examinations
**Practice.** Short, in-person, formative reviews that tell a pod whether its evidence is convincing. A missed checkpoint is a missed feedback slot, not automatically a lost point. Record the slot length and the pod order.
**Why.** Feedback is cheap while the work can still change; an unannounced oral exam is neither fair nor legally the same instrument.
**Sources.** [Sensors D4](../full-classes/hsbi-sensors-actuators-10d/instructor-notes/00-architecture-decisions.md#d4) · [Databases D13](../full-classes/hsbi-databases-10d/instructor-notes/00-architecture-decisions.md#d13) · [Networking D4](../full-classes/hsbi-networking-iot-10d/instructor-notes/00-architecture-decisions.md#d4). **Strength:** invariant.

#### C3. One reflection per teaching day, as an engineering decision log
**Practice.** Every teaching day gets one short entry in `Reflections/refNN.md`: what was tried, what broke, how the mental model shifted, how AI suggestions were verified, and a self-assessment against the module goals. The syllabus states the count (9 for the 9-day Sensors class, 10 for Networking, 11 for Databases, 16 for the Tartu semester). The final entry may be written the same evening or the next morning.
**Why.** Daily entries preserve the reasoning while it is fresh; block entries arrive after the memory has already compressed itself. The AI-verification question is what turns the log into evidence of judgement rather than a diary.
**Sources.** [Sensors syllabus §Reflection format](../full-classes/hsbi-sensors-actuators-10d/syllabus.md#reflection-format) · [Databases syllabus §Reflection format](../full-classes/hsbi-databases-10d/syllabus.md#reflection-format) · [Networking syllabus §Reflection format](../full-classes/hsbi-networking-iot-10d/syllabus.md#reflection-format). **Strength:** invariant (Databases and Networking carry a TODO to replace their block entries).

#### C4. Use the fine 20-point table, and document exceptions
**Practice.** Map points to the German scale one step at a time: 20 = 1.0, 19 = 1.3, 18 = 1.7, 17 = 2.0, 16 = 2.3, 15 = 3.0, 14 = 4.0, below 14 = 5.0. Do not band two point values onto one grade. If an intermediate grade is awarded outside the table (for example a 2.7 for an overall 3.0 with an exceptionally shaped portfolio), write the rule into the syllabus before the term.
**Why.** A coarse table throws away the distinction between a good and a very good portfolio; an undocumented exception is not a rule.
**Sources.** [Sensors D23](../full-classes/hsbi-sensors-actuators-10d/instructor-notes/00-architecture-decisions.md#d23) · [Sensors syllabus §Grade Scale](../full-classes/hsbi-sensors-actuators-10d/syllabus.md#grade-scale). **Strength:** default (Databases and Networking carry a TODO to adopt it).

#### C5. Require the evidence to survive leaving the room
**Practice.** The submitted artefact must be self-contained: repository, report, video, wiring diagram, measurement table, and a reproducible build. If the class broke, the evidence should still stand.
**Why.** A grade that depends on the room, the network, or a demo that happened once is not reproducible for the student or for a second examiner.
**Sources.** [Databases D16](../full-classes/hsbi-databases-10d/instructor-notes/00-architecture-decisions.md#d16) · [Networking D15](../full-classes/hsbi-networking-iot-10d/instructor-notes/00-architecture-decisions.md#d15). **Strength:** default.

### D. Time and schedule

#### D1. Plan in school hours, never in block counts
**Practice.** A 90-minute slot is **two** 45-minute school hours; a 180-minute slot is **four**. Sum by slot type (Übung / Praktikum / betreutes Selbststudium) and by day; check the total against the handbook. Publish the annual slot pattern in the LMS, not a fixed block-count contract.
**Why.** A block-count model silently undercounted one term by four hours and produced a syllabus that could not be defended against the handbook.
**Sources.** [Sensors D20](../full-classes/hsbi-sensors-actuators-10d/instructor-notes/00-architecture-decisions.md#d20) · [Sensors D23](../full-classes/hsbi-sensors-actuators-10d/instructor-notes/00-architecture-decisions.md#d23). **Strength:** invariant.

#### D2. Verify the calendar slot by slot
**Practice.** Before writing the schedule, list every date with its time, type, and minutes. Check the day count, the module split, and the project arc against that list. Record the slot map in the instructor notes.
**Why.** The timetable changes between years; a day table that was true last year becomes a trap. The calendar is the only source that knows about the 180-minute Praktikum.
**Sources.** [Sensors D23](../full-classes/hsbi-sensors-actuators-10d/instructor-notes/00-architecture-decisions.md#d23) · [Databases TODO §Before the next semester](../full-classes/hsbi-databases-10d/instructor-notes/TODO.md) · [Networking TODO §Before the next semester](../full-classes/hsbi-networking-iot-10d/instructor-notes/TODO.md). **Strength:** invariant.

#### D3. Keep time estimates out of the modules
**Practice.** Module bodies carry no "about 20 minutes" targets; the run sheets in the instructor notes carry the timing. A module is a path, not a timetable.
**Why.** A time estimate in student text becomes a promise the room cannot keep, and it crowds out the exploration that makes the task worth doing.
**Sources.** [Sensors D20](../full-classes/hsbi-sensors-actuators-10d/instructor-notes/00-architecture-decisions.md#d20) · [Networking D3](../full-classes/hsbi-networking-iot-10d/instructor-notes/00-architecture-decisions.md#d3). **Strength:** default (Databases still carries block targets and records the divergence).

#### D4. Compress the schedule, not the learning goals
**Practice.** When the timetable shrinks, cut breadth first: merge studios, move catalogue material to reading, and protect the project arc, the checkpoints, and the final rehearsal. Do not quietly drop a learning goal to save a session.
**Why.** The exam is defended against the goals, not against the day count. A shorter class with the same goals is honest; a shorter class with fewer goals is a different module.
**Sources.** [Sensors D23](../full-classes/hsbi-sensors-actuators-10d/instructor-notes/00-architecture-decisions.md#d23) · [Networking D12](../full-classes/hsbi-networking-iot-10d/instructor-notes/00-architecture-decisions.md#d12). **Strength:** default.

### E. Project and artefacts

#### E1. Start the project early and rehearse it
**Practice.** Give the project its own module for kickoff and requirements, one for build and characterization, and one for hardening and rehearsal. The last session is a feedback rehearsal with real time for retries, not a stage exam.
**Why.** A project that starts in the last third produces a demo, not a system. A rehearsal produces the evidence the exam actually reads.
**Sources.** [Sensors D23](../full-classes/hsbi-sensors-actuators-10d/instructor-notes/00-architecture-decisions.md#d23) · [Databases D14](../full-classes/hsbi-databases-10d/instructor-notes/00-architecture-decisions.md#d14) · [Networking D15](../full-classes/hsbi-networking-iot-10d/instructor-notes/00-architecture-decisions.md#d15). **Strength:** default.

#### E2. Offer a self-contained default and one optional integration track
**Practice.** In a class that is not the networking class, make the self-contained project the default: local sensor, local loop, local UI or log, plus a **System Boundary Document** describing the interface it would expose. Offer the networked variant (broker, dashboard, broker-restart test) as an optional second track with the same points and the same must-haves.
**Why.** It keeps the class inside its own learning goals and stops a networking module from consuming the project time. It also gives strong students a stretch without making the network a prerequisite.
**Sources.** [Sensors D23](../full-classes/hsbi-sensors-actuators-10d/instructor-notes/00-architecture-decisions.md#d23). **Strength:** pattern.

#### E3. Merge pods into teams, but keep contribution attributable
**Practice.** Project Teams of 4–6 are two Task Pods. Require at least two of: commit-author history, marked report sections, and a signed contributor sign-off.
**Why.** Team work is the point; free-riding is not. Attribution is also what makes a team grade defensible.
**Sources.** [Databases D14](../full-classes/hsbi-databases-10d/instructor-notes/00-architecture-decisions.md#d14) · [Networking D15](../full-classes/hsbi-networking-iot-10d/instructor-notes/00-architecture-decisions.md#d15) · [Sensors syllabus §Part 2](../full-classes/hsbi-sensors-actuators-10d/syllabus.md#part-2--project-documentation--presentation-materials-25--5-points). **Strength:** default.

#### E4. Record the demonstration, do not only perform it
**Practice.** Use a 5–10 minute video as the assessed artefact when the live demo is a rehearsal. Record it after the feedback, with the fixes included, and submit it with the slides and documentation by the examination deadline.
**Why.** It survives a failed projector, a nervous team, and a second examiner; it also forces the team to explain the system without an audience to prompt them.
**Sources.** [Sensors D23](../full-classes/hsbi-sensors-actuators-10d/instructor-notes/00-architecture-decisions.md#d23) · [Sensors Module 10](../full-classes/hsbi-sensors-actuators-10d/modules/10-demonstration-and-presentation.md). **Strength:** pattern.

### F. Tooling, AI, and operations

#### F1. One toolchain, installed the same way on every OS
**Practice.** Standardize the command-line toolchain and install it with `uv` (or the class's single documented alternative). Pin the versions. Put the editor integration in the repository, not in a verbal briefing.
**Why.** Installation is the least valuable use of the first session; a single documented path removes a whole class of support questions.
**Sources.** [Databases D10](../full-classes/hsbi-databases-10d/instructor-notes/00-architecture-decisions.md#d10) · [Sensors Module 5](../full-classes/hsbi-sensors-actuators-10d/modules/05-leds-and-light-output.md). **Strength:** default.

#### F2. Keep the project editor-agnostic, with one AI context file
**Practice.** A plain folder plus `platformio.ini` / `pyproject.toml` / `package.json` opens in Zed, VS Code, or an IDE. Put editor tasks and settings in the repository. Use **one** `AGENTS.md` at the project root; do not add a second vendor-specific context file.
**Why.** Students choose their editor; the class should not. One context file means Copilot, Claude, and other agents read the same pinout, library, and power rules.
**Sources.** [Sensors Module 5](../full-classes/hsbi-sensors-actuators-10d/modules/05-leds-and-light-output.md) · [`AGENTS.md`](../AGENTS.md). **Strength:** default.

#### F3. AI drafts; verification is the graded skill
**Practice.** Ask the agent for a draft, a plan, or an explanation, then verify it against a datasheet, a measurement, a capture, or a live test. Put the verification question into the reflection template and the checkpoints.
**Why.** The model is a fast, confident, sometimes wrong collaborator. The class teaches judgement, not prompt recital.
**Sources.** [Sensors Module 5](../full-classes/hsbi-sensors-actuators-10d/modules/05-leds-and-light-output.md) · [Databases Module 3](../full-classes/hsbi-databases-10d/modules/03-llm-assisted-sql-and-query-profiling.md) · [Networking Module 1](../full-classes/hsbi-networking-iot-10d/modules/01-foundations-and-masterclass.md). **Strength:** invariant.

#### F4. Put hardware guardrails where the agent will read them
**Practice.** Record the board, pinout, library rule, power budget, and "never do this" list in the project `AGENTS.md`. For the ESP32 LED lab: `NeoPixelBus` with hardware DMA/RMT, never `FastLED`; `SetLuminance(80)` for an 8-LED USB-powered strip; never power a strip from a GPIO or the 3.3 V pin.
**Why.** An agent that has not been told will default to the most common library and the brightest setting. Both are wrong on this hardware.
**Sources.** [Sensors Module 5 §AGENTS.md](../full-classes/hsbi-sensors-actuators-10d/modules/05-leds-and-light-output.md#appendix-d--agentsmd-template). **Strength:** pattern.

#### F5. Keep private material private
**Practice.** Student data, grades, answer keys, and cohort-specific mail live outside the tracked workbooks (`untracked/`, private repositories, the LMS). Never link them from a tracked file.
**Why.** The workbooks are public. A link is a publication, even if the target is ignored by Git.
**Sources.** [`AGENTS.md`](../AGENTS.md). **Strength:** invariant.

### G. Memory and maintenance

#### G1. Keep two memories: decisions and chores
**Practice.** The ADR records decisions, alternatives, and reversal triggers. The TODO records next-run actions and observations. Never put a decision in the TODO or a chore in the ADR.
**Why.** A decision without its rationale gets re-litigated; a chore in the ADR looks permanent and never gets done.
**Sources.** [Sensors D17](../full-classes/hsbi-sensors-actuators-10d/instructor-notes/00-architecture-decisions.md#d17) · [Databases D9](../full-classes/hsbi-databases-10d/instructor-notes/00-architecture-decisions.md#d9) · [Networking D14](../full-classes/hsbi-networking-iot-10d/instructor-notes/00-architecture-decisions.md#d14). **Strength:** invariant.

#### G2. Use the same record shape and the same four statuses
**Practice.** Every record: **Context → Decision → Consequences → Alternatives rejected → Evidence → Revisit if.** Statuses: `accepted`, `provisional`, `open`, `rejected`.
**Why.** The shape forces the cost and the reversal trigger into the record; the status vocabulary keeps a first-run improvisation from looking permanent.
**Sources.** [Sensors §How to use this log](../full-classes/hsbi-sensors-actuators-10d/instructor-notes/00-architecture-decisions.md#how-to-use-this-log) · [Databases §How to use this log](../full-classes/hsbi-databases-10d/instructor-notes/00-architecture-decisions.md#how-to-use-this-log) · [Networking §How to use this log](../full-classes/hsbi-networking-iot-10d/instructor-notes/00-architecture-decisions.md#how-to-use-this-log). **Strength:** invariant.

#### G3. Keep the rejected alternatives visible
**Practice.** Record what looked plausible and why it was declined, with the conditions that would make it viable again. Do not delete it when the decision is accepted.
**Why.** Without the rejected list, the same idea returns every term disguised as a new one.
**Sources.** [Sensors §3](../full-classes/hsbi-sensors-actuators-10d/instructor-notes/00-architecture-decisions.md) · [Databases §3](../full-classes/hsbi-databases-10d/instructor-notes/00-architecture-decisions.md) · [Networking §3](../full-classes/hsbi-networking-iot-10d/instructor-notes/00-architecture-decisions.md). **Strength:** invariant.

#### G4. Map the parallel decisions across classes
**Practice.** When sibling classes share a decision, record the pair (or the triple) and note the divergence. Databases §1.5 is the model: a table of "same rule / different exam form / open discrepancy" with decision IDs.
**Why.** It is how a fix in one class becomes a fix in the others, and how a legitimate difference stops looking like an inconsistency.
**Sources.** [Databases §1.5](../full-classes/hsbi-databases-10d/instructor-notes/00-architecture-decisions.md#15-how-these-decisions-relate-to-the-networking-and-iot-log). **Strength:** pattern.

#### G5. Keep a recreation checklist
**Practice.** End the ADR with a short path for rebuilding the class: what to read, what to install, what to prepare, and what to run before the first session. Name the decision each step embodies.
**Why.** It is the acceptance test for "the repository is the source of truth". If the checklist cannot be followed, the material is not maintainable yet.
**Sources.** [Sensors §5](../full-classes/hsbi-sensors-actuators-10d/instructor-notes/00-architecture-decisions.md#5-recreation-checklist) · [Databases §5](../full-classes/hsbi-databases-10d/instructor-notes/00-architecture-decisions.md#5-recreation-checklist) · [Networking §5](../full-classes/hsbi-networking-iot-10d/instructor-notes/00-architecture-decisions.md#5-recreation-checklist). **Strength:** invariant.

## 4. Anti-patterns we have already paid for

- **The block-count schedule.** "22 blocks, 44 school hours, 33 clock hours" was a unit and block miscount. A 90-minute slot is two school hours; count the calendar, not the abstraction.
- **The 90-minute day.** Planning one block per day leaves half the timetable unplanned and makes every module look overfull.
- **Assessment leaking into modules.** A point value in a module will drift from the syllabus within one term.
- **Over-specification and bloat.** The Networking Module 2 problem: every step pre-decided, conclusions stated before the task creates the need. It produces students who can execute without being able to debug.
- **Reinventing the rejected alternative.** If the ADR says it was declined, read why before proposing it again.
- **A second canon, a second vocabulary, or a second AI context file.** Each one creates a silent contradiction.
- **Unverified AI output presented as evidence.** A pinout, a library name, or a timing claim from a model is a hypothesis until it is checked on hardware or in a datasheet.
- **Committing for the instructor.** The review step is the quality gate; an agent that commits removes it.
- **A validation command that exists only in a chat message.** Put it in `tools/` and in `AGENTS.md`, or it will not be run next term.

## 5. Retrofit check for an existing class

Run this before the next offering, and again after any major rewrite.

- [ ] The syllabus owns every point, tier, checkpoint, deadline, and the grade scale; no module repeats them.
- [ ] The learning goals are stated per module (4–6) and the tasks are marked `★`/`◇`.
- [ ] A `DRAFT BOUNDARY` exists, and it sits at the first genuinely provisional section.
- [ ] The schedule was re-derived from the real calendar in school hours; the day count and the project split still fit.
- [ ] The ADR has a decision index, statuses, rejected alternatives, open questions, and a recreation checklist.
- [ ] The TODO separates decisions from next-run chores and has a discrepancy watch.
- [ ] Every teaching day has a reflection entry in the syllabus; the count matches the days.
- [ ] The grade table uses the intermediate steps, and any exception (such as 2.7) is documented before the term.
- [ ] The project artefact can be assessed without the room: repository, report, video, and evidence are self-contained.
- [ ] The AI guardrails (board, pinout, library, power) live in one project `AGENTS.md`.
- [ ] `./tools/check-all.sh` passes; any known issue is in `tools/check-docs-baseline.txt` with a linked TODO.
- [ ] A prep email exists for every toolchain-heavy module.

## 6. Decision-record template

Copy this into a class ADR:

```md
<a id="dn"></a>
### DN — <short imperative title>

**Status:** accepted | provisional | open | rejected

**Context.** <the forces: handbook, calendar, hardware, cohort, previous run>

**Decision.** <what we do, in one or two sentences>

**Consequences.** <what it costs, what it enables, what must now be maintained>

**Alternatives rejected.** <what looked plausible, and why it lost>

**Evidence.** <links to the syllabus, module, run sheet, or data>

**Revisit if.** <the trigger that would change the decision>
```

And this into a class TODO:

```md
- [ ] **<action>.** <why it exists, what it unblocks, and the decision or open question that owns it>
```

## 7. Maintenance

- **A new class** starts from [`01-class-template.md`](./01-class-template.md) and this catalogue, in the order of §2.
- **A cross-class rule changes** in [`AGENTS.md`](../AGENTS.md) first, then in this file, then in each class ADR. Link the class record that owns the detail.
- **A class-specific decision changes** in that class's ADR; do not edit this file unless the pattern itself changed.
- **A pattern appears in a second class** promote it here with its new strength. A pattern that has not survived two classes is still a hypothesis.
- **Validation** is `./tools/check-all.sh`; the baseline is for tracked issues only.
