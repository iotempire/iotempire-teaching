# Instructor Notes — Architecture Decisions (Databases)

> **What this document is.** The design memory of the Databases class (module 3386). It records *why*
> the course has this shape, *what was tried and rejected*, and *what a new instructor or an agent
> needs to know to rebuild it*. It is written for the people who teach and maintain the class, not
> for students looking for the schedule.
>
> **What it is not.** It is not the syllabus, not the module content, not the operations checklist,
> and not a changelog. The binding assessment rules — points, checkpoints, grade scale — live
> **only** in the [syllabus](../syllabus.md); the operational view is in
> [Assessment & operations](./00-assessment-and-operations.md). Teaching material lives in the
> [modules](../modules/00-index.md). If this page and those disagree, those win.
>
> **Status.** First version, 2026-11-11. Reconstructed from the Git history, the session notes, and
> the instructor's decisions during the first offering. It will be incomplete or wrong in places:
> correct the record rather than replace it, and keep the old reasoning visible.

[← Course workbook](../README.md) · [Syllabus](../syllabus.md) · [Module index](../modules/00-index.md) · [All instructor notes](./README.md) · [Networking ADR](../../hsbi-networking-iot-10d/instructor-notes/00-architecture-decisions.md)

## How to use this log

Each record has the same shape:

**Context** (the forces) → **Decision** (what we do) → **Consequences** (what it
costs) → **Alternatives rejected** (what we did not do) → **Evidence** (where it
lives) → **Revisit if** (the trigger that would change the decision).

The status vocabulary is deliberately small:

| Status | Meaning |
|---|---|
| **accepted** | In force, encoded in the current files. Change it only with a new record. |
| **provisional** | In force for this offering, expected to move after the first run. |
| **open** | Not decided; recorded in §4 so it does not get decided by accident. |
| **rejected** | Considered and declined; kept in §3 so it does not come back disguised as a new idea. |

**What belongs here.** Forces that constrain future material; a decision and what it costs;
alternatives that looked plausible; the trigger that would reverse the decision; links to the
artefact. **What does not.** Task steps (module), point values and checkpoints (syllabus),
operational checklists (`00-assessment-and-operations.md`), troubleshooting recipes (resource bank),
routine edits (Git log). If a sentence would fit better in one of those, it is in the wrong document.

**For an agent.** Read §1 and the decision index, then only the records that touch your task. Do not
re-introduce a rejected alternative because it looks simpler in isolation; the reasons are in §3. Do
not move assessment text out of the syllabus. Do not add points, tiers or a separate "reflection
logbook" to a module. When you change a decision, update its record and status; do not silently
rewrite history.

**Maintenance rule.** Add a record when a choice constrains future material, when you reject a
plausible alternative, or when a first-offering improvisation becomes the pattern. Keep records
short; link to the artefact instead of pasting it.

### Decision index

| ID | Decision | Status | Encoded in |
|---|---|---|---|
| [D1](#d1) | The module handbook is the constraint; Projektarbeit is the form | accepted | syllabus, Appendix A |
| [D2](#d2) | Local-first is the spine; the server is the control group | accepted | Modules 1, 6b; README |
| [D3](#d3) | Measurement is the evidence — plans, warm-up, median, spread | accepted | Modules 3, 5, 6a |
| [D4](#d4) | Learning goals are the contract; tasks are negotiable | accepted | every module, syllabus |
| [D5](#d5) | Assessment is portfolio → Projektarbeit | accepted | syllabus, `00-assessment-and-operations.md` |
| [D6](#d6) | Stories carry the why; the canon keeps them consistent | accepted | modules, resource bank `#story-canon` |
| [D7](#d7) | Stage-and-gate: the study is folded into the practice | accepted | Modules 5, 6a, 6b |
| [D8](#d8) | Each document has exactly one job | accepted | whole class folder |
| [D9](#d9) | The class is a draft in motion, with a visible boundary | accepted | every module |
| [D10](#d10) | One toolchain: `uv`, Python 3.14, SQLite/DuckDB — no pip, no extensions | accepted | syllabus, Module 1 |
| [D11](#d11) | Module 6 is two studios: analytical engine + polyglot decision | provisional | Modules 6a/6b |
| [D12](#d12) | Module 5 is one session; its homework is gated by a recap | provisional | Module 5, Module 6a |
| [D13](#d13) | Checkpoints are feedback, spread over sessions | accepted | syllabus, `feedback-rounds.md` |
| [D14](#d14) | The project is three studios + demos, in merged teams | accepted | Modules 7–8, syllabus |
| [D15](#d15) | Eleven sessions; sessions 6–7 teach, 8–10 build, 11 demos | provisional | syllabus schedule |
| [D16](#d16) | The class must survive leaving the room | accepted | all modules, resource bank |
| [D17](#d17) | English material, bilingual delivery | accepted | syllabus language section |
| [D18](#d18) | Attendance is thin; online pods are the fallback | provisional | syllabus, email template |
| [D19](#d19) | Prep and expectation emails, three days ahead | accepted | `email-template.md` |

## 1. Provenance — how this class came to be

### 1.1 Three lineages, one class

| Lineage | Where it lives | What it contributed | What it could not provide |
|---|---|---|---|
| **HSBI legacy lecture** *Datenbanken* (3386) | Local `class-design/ingest-dest/` workspace (not tracked here) | The module handbook: DB architecture, ERM, relational model, normalization, SQL (DDL/DML/DQL/DCL), triggers/procedures, NoSQL, ACID/BASE/CAP; the exam form | Student labs; local-first; anything measured |
| **Tartu IoT introduction** (15–16 weeks) | [`full-classes/unitartu-IoT-intro-15d/`](../../unitartu-IoT-intro-15d/README.md) | The practical thread: modules, portfolio, storytelling, final project, "tasks are a path, not a checklist" | Database depth; the HSBI examination form |
| **HSBI 11-session studio format** | This folder | Compression to one module per session, 2 × 90 minutes, ~60 students, project arc, checkpoints | — (this is the new constraint) |

The merge was not clean. The first draft (commit `03cd14c`, 2026-10-01) was a local-first workbook
with a complete module list; the first offering then compressed, split and reordered it while
teaching. This log records the result, including the parts that were improvised in class.

### 1.2 Timeline

Dates are commit dates where available; the rest are session dates from the first offering.

| Date | Commit / event | What happened | Why it matters |
|---|---|---|---|
| 2026-10-01 | `03cd14c` | Databases class, first draft | The third sibling; the style starts from the networking and sensors classes. |
| 2026-10-20 | `b5c510d`, `d4fcb7b` | Structural dedup; assessment storytelling standardised | "One job per document" becomes real. |
| 2026-11-02 | `59d367d` | Learning-goal argumentation clarified | Assessment moves from tasks to evidence for goals. |
| 2026-11-03 | `2dee0f7` | Topic organisation; Module 1 slides | The only slide deck in the class. |
| 2026-11-04…05 | first sessions | Modules 1–4 delivered; checkpoints 1 | The studio format works; the room is thinner than expected. |
| 2026-11-05 | `1bfbc23` | Module 5 timing and scope; seven rounds | Module 5 becomes one session, not two. |
| 2026-11-10 | `6c5595c` | Module 6 split into 6a (DuckDB) and 6b (polyglot) | The analytical engine gets its own day. |
| 2026-11-10 | `bdca841`, `9cf7e58` | Server options; `postgres-tunnel.sh` | The server contrast becomes a prepared, optional bench. |
| 2026-11-11 | this file (uncommitted) | Decision log reconstructed | The design memory is written down before it is lost. |

### 1.3 Why this class was the trickiest of the three

The siblings share the didactic pattern, but databases carried three extra forces at once:

1. **An assessment change mid-stream.** The class started as a *Kombinationsprüfung* idea and became
   **Projektarbeit** (project work) under the module handbook. The points, the role of checkpoints,
   and the final review had to be rebuilt without breaking what students had already been told.
2. **A content split that was not planned.** The old Module 6 (DuckDB + polyglot) did not fit one
   session, and the analytical engine needed a full day. It became 6a/6b **during the run** — the
   right shape, discovered late.
3. **An attendance collapse.** Two-thirds of the class missing without notice forced a policy
   (online pods, asynchronous assessment) that no design document had anticipated (D18).

The networking class is at Day 1; it inherits the pattern without these scars. That is why a
[gift file](../../hsbi-networking-iot-10d/instructor-notes/from-databases.md) exists next to its
notes.

### 1.4 The style was learned on sibling classes

| Class | What it taught this class | What did **not** travel |
|---|---|---|
| [Networking & IoT](../../hsbi-networking-iot-10d/README.md) | Studio rhythm, decision-log form, "one job per document" | Hardware, OSI, overlays, the 10-day format |
| [Sensors & Actuators](../../hsbi-sensors-actuators-10d/README.md) | Rounds with brief/bench/explain; measurement as evidence; the neighbour exchange | Sensor physics, calibration, the lab kit |
| Tartu IoT | Portfolio, stories, CBL/PBL, final project | The 15-week pace |

### 1.5 How these decisions relate to the Networking and IoT log

The two logs are deliberately parallel. This table is the map; the gift file lists what is worth
copying and what is not.

| Databases | Networking | Relationship |
|---|---|---|
| D1 handbook constraint | D1 | Same rule: handbook is outer, didactics are ours. **Divergence:** DB uses *Projektarbeit*; networking uses *Hausarbeit* and recommends *Projektarbeit* for the next run. |
| D2 local-first spine | D2 practice spine, D10 local broker first | Same instinct: start with what the student owns; add the network/server once the local thing works. |
| D3 measurement is evidence | D2 build → capture → explain | Same evidence principle; DB adds the warm-cache and spread rules. |
| D4 goals contract | D3 | Same. **Discrepancy:** networking says "no time estimates"; DB rounds carry block times (see §4). |
| D5 portfolio → Projektarbeit | D4 portfolio → Hausarbeit | Same pipeline, different exam form. |
| D6 stories + canon | D5 | Same; each course keeps its own cast. |
| D7 stage-and-gate | D6 studio rhythm | Same, but DB removed the study phase earlier (Module 5). |
| D8 one document, one job | D13 | Same. |
| D9 draft boundary | D14 | Same; DB moves boundaries to the end once a module is delivered. |
| D10 toolchain | — | DB-specific (software-only class). |
| D11 6a/6b split | D12 fieldbuses compressed | Both compress or split content to fit the days; DB's split was mid-run. |
| D12 M5 one session | D12 | Compression in both. |
| D13 checkpoints | D4 | Same feedback principle; DB spreads checkpoint 2 over two sessions. |
| D14 project arc | D4, D15 | Same. |
| D15 eleven sessions | — | The 10-day format has no equivalent. |
| D16 survive leaving the room | D15 | Same. |
| D17 English | D16 | Same. |
| D18 attendance/online pods | — | DB is ahead because of the crisis; networking can reuse the policy. |
| D19 prep emails | — | Newer than the networking log; candidate gift. |

## 2. Decision records

<a id="d1"></a>
### D1 — The module handbook is the constraint; Projektarbeit is the form

**Status:** accepted.

**Context.** Module 3386 fixes 150 h, 5 ECTS, the learning outcomes (DB architecture, ERM, relational
model, normalization, SQL, triggers/procedures, NoSQL, ACID/BASE/CAP) and the possible examination
forms. The class started from a *Kombinationsprüfung* idea; the handbook permits **project work**.

**Decision.** Treat the handbook as the outer constraint and the didactics as ours. Map every outcome
to a module (Appendix A). Choose **Projektarbeit** — continuous portfolio work plus a final project —
rather than a combination exam.

**Consequences.** The class can be local-first, measured and project-based without becoming
non-compliant. Some outcomes are covered at "can explain and place" depth (e.g., DCL, procedures),
not "can build"; that trade must be defensible in the final project discussion.

**Alternatives rejected.** Kombinationsprüfung; written exam; teaching the handbook line by line.

**Evidence.** [Syllabus assessment](../syllabus.md#assessment-project-work-20-points); Appendix A.

**Revisit if.** The handbook or the examination form changes, or the Prüfungsausschuss asks for
stronger coverage of a specific outcome.

<a id="d2"></a>
### D2 — Local-first is the spine; the server is the control group

**Status:** accepted.

**Context.** Students meet databases through a three-tier cloud stack in most curricula, then never
run one locally. The class argues the opposite default, but must not turn it into dogma.

**Decision.** SQLite and DuckDB run **inside the process**; the default app ships a file, not a
deployment. A real PostgreSQL server appears once, in Module 6b, as the **control group** — so
students feel what a server adds (and costs) before deciding.

**Consequences.** Every lab runs offline. The server is optional infrastructure; the lesson survives
without it. The comparison makes local-first a measured choice, not a slogan.

**Alternatives rejected.** MySQL/PostgreSQL-first; a mandatory server day; no server at all (the
contrast would stay abstract).

**Evidence.** Modules 1, 6b; README "Why this course looks different"; `postgres-tunnel.sh`.

**Revisit if.** The room cannot run the server, or the module moves to a different semester.

<a id="d3"></a>
### D3 — Measurement is the evidence — plans, warm-up, median, spread

**Status:** accepted.

**Context.** Performance intuition is wrong often enough to be dangerous; AI-generated SQL makes it
worse. Students arrive believing "denormalized is faster" or "columnar is faster" as slogans.

**Decision.** Every performance claim ends in a **plan** and a **number**. `EXPLAIN QUERY PLAN` for
access, `EXPLAIN ANALYZE` for the physical plan; benchmarks warm both sides, alternate the engines,
take a median of an odd number of runs, and print the min–max spread. The ratio is reported as a
range, not a constant.

**Consequences.** Students see their own predictions fail (Module 5's cold cache; Module 6a's
`strftime`). The number is contextual: engine + query + data + cache. This is the point.

**Alternatives rejected.** Timing a single run; comparing means; trusting a slide; "DuckDB is 100×
faster" as a fact.

**Evidence.** Modules 3, 5, 6a; `race.py`; the warm-up text in Module 5.

**Revisit if.** The toolchain changes enough that the measurement loop becomes unreliable.

<a id="d4"></a>
### D4 — Learning goals are the contract; tasks are negotiable

**Status:** accepted.

**Context.** New class, mixed cohort, AI co-pilots, first offering. Fixed step-by-step tasks break
on the first missing file or changed tool version.

**Decision.** Every module opens with measurable "you can …" goals, then a visible DRAFT BOUNDARY.
Tasks carry ★ (core) or ◇ (stretcher); long blocks say "Challenging". Students may replace or skip a
task if they can still demonstrate the goals.

**Consequences.** The instructor can swap a task mid-session and still assess. The portfolio argues
goals, not task completion. The room can run at different speeds.

**Alternatives rejected.** Per-step lab sheets; points for completion; minute-by-minute plans.

**Evidence.** Every module; [syllabus task tiers](../syllabus.md#task-tiers--core-and--stretcher).

**Revisit if.** Accreditation requires evidence of specific task completion.

<a id="d5"></a>
### D5 — Assessment is portfolio → Projektarbeit

**Status:** accepted.

**Context.** The project-work form allows continuous assessment. The class is CBL/PBL; we want
process evidence, not a final exam.

**Decision.** One portfolio repository per student; module evidence and reflections live there; the
final project is its closing section. Points: **modules 1–6 = 11** (1 for M1, 2 each for M2–6),
**reflections 4**, **project 5** (3 work + 2 demo/discussion); pass at **14/20**. The binding rules
live only in the syllabus.

**Consequences.** Documentation is part of the lab. Checkpoints are **feedback**, not graded events;
the graded assessment happens at the end. Module files never restate points.

**Alternatives rejected.** Kombinationsprüfung; written exam; per-task points; grading the portfolio
as a file dump.

**Evidence.** [Syllabus](../syllabus.md); `00-assessment-and-operations.md`.

**Revisit if.** The examination form changes or the Prüfungsamt requires a different artefact.

<a id="d6"></a>
### D6 — Stories carry the why; the canon keeps them consistent

**Status:** accepted.

**Context.** Database topics are abstract; a named person with a problem makes requirements real.
The class has four stories (Wittkamp, Kortmann, Frachtflow, Füllwerk).

**Decision.** Each module starts from a story with a named organisation, a named person, and a
moment of pain. A **story canon** table in the resource bank keeps names, places and roles
consistent. Stories must be pitchable and/or playable; the method is Story Driven Modeling.

**Consequences.** Modules are self-contained but share a cast. New material must check the canon.
The project kickoff uses the same test for student stories.

**Alternatives rejected.** Generic topics ("a library"); one giant story for the whole term;
continuity that forces students to read another module to understand a hook.

**Evidence.** Modules 1–6b; [story canon](../modules/Z-resources-bank.md#story-canon-the-recurring-cast).

**Revisit if.** A story stops carrying the technical content, or the canon becomes a barrier.

<a id="d7"></a>
### D7 — Stage-and-gate: the study is folded into the practice

**Status:** accepted.

**Context.** In Modules 2–4 the scheduled 20–30 minute pod study took 60–90 minutes and crowded out
the lab. The same happened in the first Module 5 attempt.

**Decision.** From Module 5 on, remove the separate study phase. Each round: a small task, a theory
box read only when the task demands it, and a two-minute **discussion** with the nearest pod. The
instructor walks and listens; no lecture. The format spreads to 6a/6b.

**Consequences.** The room runs at different speeds on purpose; a shared progress list replaces
synchronisation. The theory is discovered, not pre-loaded. Some students will skip the box and learn
from the gate discussion instead — acceptable.

**Alternatives rejected.** Keeping the study and shortening the lab; a lecture to "save time"; a
synchronised share.

**Evidence.** Module 5 primer; Modules 6a/6b; [study formats](./study-formats.md).

**Revisit if.** A module needs a shared vocabulary before anyone can act.

<a id="d8"></a>
### D8 — Each document has exactly one job

**Status:** accepted.

**Context.** The first draft repeated assessment text in every module, points in the README, and
schedules in three places. Students and instructors could not tell which page was binding.

**Decision.** README = invitation; syllabus = rules and assessment; modules = studios; instructor
notes = runbook and design memory; resource bank = reference; prompt bank = reflection and LLM
drills. Assessment text appears **once**, in the syllabus.

**Consequences.** Modules link instead of restating. A change to points is a one-file change. The
cost is more links and a stricter review when editing.

**Alternatives rejected.** One giant workbook; per-module assessment sections; a separate "rules"
document beside the syllabus.

**Evidence.** The whole folder; `validate-all.py` checks links and anchors.

**Revisit if.** The number of documents starts to hide the entry point.

<a id="d9"></a>
### D9 — The class is a draft in motion, with a visible boundary

**Status:** accepted.

**Context.** The class is new and taught by an instructor learning databases alongside the students.
Pretending it is settled would be dishonest; an invisible draft makes students distrust the plan.

**Decision.** Every module carries a visible `DRAFT BOUNDARY`. While a module is being designed the
boundary sits near the top; once it has been taught and revised it moves to the **end**. The reset
procedure is in the TODO. The syllabus says the plan may shift.

**Consequences.** Students know what is provisional. The instructor can change a task without
breaking a promise. The boundary becomes a maintenance ritual at the start of each term.

**Alternatives rejected.** A polished but fictional plan; a separate "beta" label; no boundary.

**Evidence.** Modules 1–8; [TODO](./TODO.md).

**Revisit if.** The class stabilises for two offerings and the boundary becomes noise.

<a id="d10"></a>
### D10 — One toolchain: `uv`, Python 3.14, SQLite/DuckDB — no pip, no extensions

**Status:** accepted.

**Context.** Students install tools on Windows, macOS and Linux; older instructions used `pip` and
`INSTALL sqlite`, which broke behind proxies and on locked-down machines.

**Decision.** `uv` installs and pins Python 3.14 and all libraries (`duckdb`, `datasette`,
`sqlite-utils`, `pydantic`, `sqlalchemy`). No `pip install`. No DuckDB `INSTALL sqlite`; export CSV
with Python and let DuckDB read it. The `sqlite3` shell is optional for students; Python's `sqlite3`
is the portable path.

**Consequences.** One command, three platforms, offline after setup. The CSV bridge adds a step but
removes the network dependency. The `scratch/` demo portfolio mirrors the student environment.

**Alternatives rejected.** pip + requirements; Docker for students; the DuckDB SQLite extension;
native server installs.

**Evidence.** [Syllabus tools](../syllabus.md#tools--environment); Module 1; `scratch/pyproject.toml`.

**Revisit if.** `uv` changes its project model, or the university provides a standard environment.

<a id="d11"></a>
### D11 — Module 6 is two studios: analytical engine + polyglot decision

**Status:** provisional.

**Context.** The old Module 6 (DuckDB + JSON + key-value + ACID/CAP) did not fit one session and
made every task shallow. The analytical engine alone needs a day of installation, data and
profiling.

**Decision.** Split into **6a — The Analytical Engine (DuckDB)** and **6b — Polyglot Persistence &
the Decision**, under one assessment module (2 points, two reflections). 6a carries the G2 story
("the report outgrew SQLite"); 6b ends with the one-page decision record and a peer defence.

**Consequences.** An extra session is spent, but both engines get depth and the project inherits an
architecture argument. The split happened mid-run; the numbering 6a/6b preserves the points and
reflection structure.

**Alternatives rejected.** One compressed module; a full seventh module number (would change the
points); DuckDB as a stretcher only.

**Evidence.** Modules 6a/6b; syllabus sessions 6–7.

**Revisit if.** A future cohort needs the polyglot material earlier, or the points are rebalanced.

<a id="d12"></a>
### D12 — Module 5 is one session; its homework is gated by a recap

**Status:** provisional.

**Context.** Module 5 (normalization/denormalization) was planned for two sessions; the first run
showed the measured rounds fit one. The leftover homework (Rounds 5–7) would otherwise be forgotten.

**Decision.** Module 5 is **one session** (Rounds 1–4); Rounds 5–7 are homework. Session 6 opens
with a **15-minute instructor recap** of the numbers and findings, not a student gate. Students
without homework take the generated recap numbers and note that they copied them.

**Consequences.** The recap starts the next session with shared numbers and identifies the cold-cache
surprise; it costs 15 minutes of Module 6a. The gate-as-test ritual is removed.

**Alternatives rejected.** Two sessions; a student gate; skipping the homework entirely.

**Evidence.** Module 5 primer; Module 6a "How this studio works"; instructor notes 06a.

**Revisit if.** The cohort arrives prepared and the recap becomes redundant.

<a id="d13"></a>
### D13 — Checkpoints are feedback, spread over sessions

**Status:** accepted.

**Context.** The class has ~20 pods and a 2 × 90 minute session. A 12-minute slot per pod is 4 hours;
one session cannot hold it. Grading mid-term is not permitted for the chosen form.

**Decision.** Checkpoints are **feedback rounds**, never graded. Checkpoint 1 sits in session 4;
**Checkpoint 2 is spread over sessions 8 and 9** (ten pods each, ~10 minutes), while the project
runs. The round opens with a peer practice (portfolio gate, one artefact, one reflection); "not yet"
is a complete answer. A TA can run a second lane.

**Consequences.** Feedback lands while it is cheap to fix. The instructor sees every portfolio at
least once. The project loses ~100 minutes per session to the round; that is the price.

**Alternatives rejected.** One 4-hour checkpoint; grading in the checkpoint; a written mid-term; no
mid-term feedback.

**Evidence.** Syllabus; `feedback-rounds.md`; `feedback-template.md`.

**Revisit if.** The pod count drops below ~10, or the TA model changes.

<a id="d14"></a>
### D14 — The project is three studios + demos, in merged teams

**Status:** accepted.

**Context.** The project is the graded artefact; students need time to build, review and rehearse.
Two pods of 2–3 merge into a team of 4–6.

**Decision.** Sessions 8–10 are project studios (story/architecture/plan → build/integrate →
harden/review/rehearse); session 11 is demo + individual discussion. The work is 3 points (story,
architecture, plan) and the demo/discussion 2 points. Milestones are proposed as a menu; teams set
their own dates.

**Consequences.** The project gets three weeks; checkpoints share the first two. A team that starts
late cannot compress the rehearsal. The demo is a conversation, not a slide show.

**Alternatives rejected.** Four project weeks; a written project report only; grading the repository
without a discussion.

**Evidence.** Modules 7–8; syllabus.

**Revisit if.** The cohort needs more build time or the demo format changes.

<a id="d15"></a>
### D15 — Eleven sessions; sessions 6–7 teach, 8–10 build, 11 demos

**Status:** provisional.

**Context.** The class has 11 sessions, not 10 days like networking. The first offering lost time to
study overruns and attendance.

**Decision.** Sessions 1–5 teach Modules 1–5; 6–7 teach 6a/6b; 8–10 are project studios (with
checkpoint 2 in 8–9); 11 is demos. The schedule is indicative and may shift.

**Consequences.** Module 5 becomes one session, Module 6 two. If a module overruns, the project
absorbs it. Session 10 stays partly loose as buffer.

**Alternatives rejected.** Two sessions for Module 5; one for Module 6; a fourth project week.

**Evidence.** [Syllabus schedule](../syllabus.md#11-session-course-schedule).

**Revisit if.** The semester calendar changes or a module needs more time.

<a id="d16"></a>
### D16 — The class must survive leaving the room

**Status:** accepted.

**Context.** Students work on their own laptops, often offline, with different operating systems.
The first run had installation failures and network-dependent steps.

**Decision.** Every core lab runs offline with `uv`, SQLite/DuckDB and files. Downloads are optional
and cached. The server contrast is instructor-hosted and has a fallback demo. The scratch demo
portfolio is built from the module text, so demos never depend on a student repository.

**Consequences.** The class works at home and in a room with a bad network. The cost is the CSV
bridge and the absence of a "real" server until 6b.

**Alternatives rejected.** Cloud databases; a required lab server; Docker for every student.

**Evidence.** Modules 1–6b; `scratch/README-demo.md`; `postgres-tunnel.sh`.

**Revisit if.** The university provides a reliable lab environment.

<a id="d17"></a>
### D17 — English material, bilingual delivery

**Status:** accepted.

**Context.** The cohort is international; the instructor and the institution are German.

**Decision.** All material is in English; explanations, questions and feedback may be German or
English. Assessment artefacts are accepted in either language.

**Consequences.** The workbook is reusable; students are not penalised for language. The instructor
must keep the two registers consistent.

**Alternatives rejected.** German-only material; English-only delivery.

**Evidence.** Syllabus language section.

**Revisit if.** The cohort or the programme language changes.

<a id="d18"></a>
### D18 — Attendance is thin; online pods are the fallback

**Status:** provisional.

**Context.** In the first offering, two-thirds of the class missed a session without notice; ten
students replied (illness, one remote pod), thirty did not. The studio format depends on pods being
present.

**Decision.** Keep pods where everyone is accounted for; re-form around who is present. Students who
have not attended for a while are assigned to an **online pod** with an **asynchronous assessment**
(a personal video and a written report per module). The graded format is reviewed against the
Leistungsnachweis options. Random individual portfolio spot-checks may be used in checkpoint rounds.

**Consequences.** The policy is firm but preserves a route for remote learners. It multiplies the
assessment and feedback work roughly five-fold; it is a last resort, not a design goal. It is
legally sensitive: confirm with the Prüfungsamt.

**Alternatives rejected.** Ignoring attendance; grading attendance; cancelling the studio format;
forcing everyone into one online mode.

**Evidence.** Syllabus; [email template](./email-template.md); private attendance follow-up.

**Revisit if.** Attendance recovers, or the Prüfungsamt rejects the asynchronous form.

<a id="d19"></a>
### D19 — Prep and expectation emails, three days ahead

**Status:** accepted.

**Context.** Students arrive without the previous module's data, without the environment, and
sometimes without knowing what the session expects. The first run improvised emails.

**Decision.** Send a **content mail** at least three days before each session: where we are, what to
do before, what the session looks like, homework. Use the template; keep it under ~400 words. A
separate, cohort-specific mail handles attendance (D18).

**Consequences.** Less time lost to setup; clearer expectations. The cost is one mail per session and
a template to maintain.

**Alternatives rejected.** LMS announcements only; a long syllabus summary; no prep.

**Evidence.** [`email-template.md`](./email-template.md); `PREP EMAIL` markers in the modules.

**Revisit if.** The LMS can carry the same information reliably.

## 3. Deliberately rejected or retired

| Idea | Why it was rejected / retired |
|---|---|
| **Kombinationsprüfung** | The handbook permits project work; the combination exam added grading without adding learning. |
| **Written exam** | Contradicts CBL/PBL and the portfolio pipeline. |
| **Per-task or attendance points** | Rewards compliance, not learning; breaks when a task fails. |
| **Grading checkpoints** | Mid-term grading is not permitted for the form; feedback must stay cheap. |
| **A separate reflection logbook with its own points** | Reflections live in the portfolio; a second artefact duplicates work. |
| **MySQL/PostgreSQL-first** | A server install is the wrong default for a local-first class; the server is a contrast, not the spine. |
| **`pip install` / `requirements.txt`** | The `uv` workflow is one command on three platforms. |
| **DuckDB `INSTALL sqlite`** | Downloads an extension; fails behind proxies and on read-only homes. CSV is the bridge. |
| **Slides as the default** | Students should type, not watch; only the Session 1 deck survives. |
| **Separate module numbers for 6a/6b** | Would change the points and reflection structure mid-run; 6a/6b preserve them. |
| **30 containers on the instructor laptop** | One cluster with per-pod databases and one pgweb is simpler and enough. |
| **Regrouping pods mid-session** | Tried once in Module 5; it destroyed the flow. Re-form between sessions, with notice. |
| **A mandatory server day** | Infrastructure becomes the lesson; the contrast must stay optional. |
| **Time predictions in modules** | The estimates were always too low. The current compromise is block targets (see §4). |

## 4. Open questions

- **Partial grades (A-, B+, B-).** The 20-point table jumps in whole points. Should the report and
  project discussion produce finer bands? Shared with the Networking class; decide together.
- **Block times vs "no time estimates".** The Networking ADR (D3) bans estimates; the Databases
  rounds carry "~25 minutes" targets. Are these pacing aids or predictions? Pick one vocabulary.
- **Points split M5 / 6a+6b.** Module 5 is one session but still 2 points; 6a+6b are two sessions for
  2 points. Should one point move from M5 to the 6s?
- **Checkpoint slot length.** The manual says 12 minutes; the syllabus says 10. With 20 pods and a
  TA, is a second lane the permanent model?
- **Online pods and the asynchronous form.** Is D18 a one-off crisis policy or a permanent route?
  Confirm with the Prüfungsamt before publishing it as an option.
- **Random portfolio spot-checks.** Do they fit the examination law, and are they worth the trust
  cost?
- **Module 6 numbering next term.** Keep 6a/6b under Module 6, or make them two modules with a
  rebalanced points table?
- **"Gate" vs "discussion".** Modules 6a/6b say discussion; Module 5 still says gate. Rename the
  remaining ones or keep the historical term?
- **Server contrast.** Permanent in 6b or optional? Should the server stay up through the project?
- **Project team size.** 4–6 is the current rule; is 6 too large for an individual defence?
- **Recap in every module.** Should every session open with a 15-minute recap of the previous one,
  or only when homework spans sessions?
- **Warm-cache method everywhere.** Module 5 and 6a now warm up; should every benchmark in the
  course (and the sibling classes) use the same sentence?
- **Attendance threshold.** The "more than 50 in the room" test is a one-off; is a written threshold
  useful or divisive?
- **Reflections per block.** Four points for four blocks; Module 6 now has two entries. Does the
  block count still match the workload?

## 5. Recreation checklist

To rebuild this class from the repository:

1. Read the [README](../README.md), [syllabus](../syllabus.md), [module index](../modules/00-index.md),
   and this log's §1 and decision index.
2. Install `uv`, `sqlite3`, and (optionally) Datasette; clone the workbook.
3. Build the demo data: `sh scratch/smoke-test.sh all` (from `scratch/`), then `uv sync` once.
4. Open Module 1 and the corresponding instructor note; run the first session.
5. Before each session: send the [content mail](./email-template.md) three days ahead; check the
   `PREP EMAIL` markers in the module.
6. Before each checkpoint: publish the pod order and slot length; print the
   [template](./feedback-template.md).
7. If the server contrast is on: `./postgres-tunnel.sh up --quick` (or with a domain), test from a
   student device, and keep the teardown ready.
8. After each session: record observations in [`study-formats.md`](./study-formats.md) and
   [`TODO.md`](./TODO.md); move the DRAFT BOUNDARY when a module is settled.

## Appendix A — Module handbook coverage

The legacy chapter names are deliberately kept in the module index; this table shows where each
lives now.

| Handbook topic | Where it is covered | Depth |
|---|---|---|
| DB architecture, DBMS components | Module 1 (embedded vs client/server) | explain and place |
| ERM / EERM, conceptual design | Module 2 (schema audit, ER reconstruction) | build |
| Relational model, keys, integrity | Modules 2, 4 | build |
| Normalization (1NF–3NF), FDs | Module 5 | build and measure |
| SQL DDL / DML | Modules 4, 5 | build |
| SQL DQL, relational algebra | Module 3 | build and profile |
| Query optimization, indexes | Modules 3, 5, 6a | build and measure |
| Triggers, procedures | Module 4 (triggers; procedures at reference depth) | build / explain |
| Transactions, ACID | Modules 4, 6b | explain and demonstrate |
| NoSQL, CAP, BASE | Module 6b | explain and compare |
| DB in applications, polyglot | Modules 6a/6b | build and decide |

## Appendix B — Where the source material lives

- **Legacy lecture** *Datenbanken*: local `class-design/ingest-dest/` workspace (not tracked here).
- **Practical ancestor**: [`full-classes/unitartu-IoT-intro-15d/`](../../unitartu-IoT-intro-15d/README.md).
- **This class**: `full-classes/hsbi-databases-10d/`.
- **Demo portfolio and rehearsal material**: `scratch/` (untracked; see `scratch/README-demo.md`).
- **Private solutions and cohort-specific mail**: `untracked/instructor-notes-private/hsbi-databases-10d/`.

## Appendix C — Change log of this document

| Date | Change |
|---|---|
| 2026-11-11 | First version: provenance, 19 decisions, rejected list, open questions, recreation checklist, handbook map. |
