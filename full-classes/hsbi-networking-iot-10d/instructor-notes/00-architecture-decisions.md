# Instructor Notes — Architecture Decisions (Networking and IoT Solutions)

> **What this document is.** The design memory of the 10-day class. It records
> *why* the course has this shape, *what we tried and rejected*, and *what a new
> instructor or an agent needs to know to rebuild it*. It is written for the
> people who teach and maintain the class, not for students looking for the
> schedule.
>
> **What it is not.** It is not the syllabus, not the module content, not the
> operations checklist, and not a changelog. The binding assessment rules —
> points, checkpoints, grade scale — live **only** in the [syllabus](../syllabus.md);
> the operational view is in [Assessment & operations](./00-assessment-and-operations.md).
> The teaching material lives in the [modules](../modules/00-index.md). If this
> page and those disagree, those win.
>
> **Status.** First version, 2026-11-10. Reconstructed from the Git history, the
> current module files, and the instructor's decisions during the first offering.
> It will be incomplete or wrong in places: correct the record rather than replace
> it, and keep the old reasoning visible.

[← Course workbook](../README.md) · [Syllabus](../syllabus.md) · [Module index](../modules/00-index.md) · [All instructor notes](./README.md)

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

**What belongs here.** Forces that constrain future material; a decision and what it costs; alternatives that looked plausible; the trigger that would reverse the decision; links to the artefact. **What does not.** Task steps (they belong in a module), point values and checkpoints (syllabus), operational checklists (`00-assessment-and-operations.md`), troubleshooting recipes (resource bank), routine edits (the Git log). If a sentence would fit better in one of those, it is in the wrong document.

**For an agent.** Read §1 and the decision index, then only the records that touch
your task. Do not re-introduce a rejected alternative because it looks simpler in
isolation; the reasons are in §3. Do not move assessment text out of the syllabus.
Do not add time estimates, points, tiers or a "reflection logbook" to a module.
When you change a decision, update its record and status; do not silently rewrite
history.

**Maintenance rule.** A decision log that is only written once is a museum. Add a
record when a choice constrains future material, when you reject a plausible
alternative, or when a first-offering improvisation becomes the pattern. Keep
records short; link to the artefact instead of pasting it.

### Decision index

| ID | Decision | Status | Encoded in |
|---|---|---|---|
| [D1](#d1) | The module handbook is the constraint; the didactics are ours | accepted | syllabus, Appendix A |
| [D2](#d2) | Practice is the spine; OSI is the reference dictionary | accepted | Modules 1, 2, 4, 6 |
| [D3](#d3) | Learning goals are the contract; tasks are negotiable | accepted | every module, syllabus |
| [D4](#d4) | Assessment is a portfolio-to-report pipeline | accepted | syllabus, `00-assessment-and-operations.md` |
| [D5](#d5) | Stories carry the why; the canon keeps them consistent | accepted | modules, resource bank `#story-canon` |
| [D6](#d6) | Studio rhythm: challenge → practice → theory on demand → discussion | accepted | Modules 2–7; Module 1 remains the exception |
| [D7](#d7) | Capture at the choke point; analyse offline | accepted | Module 1 Task 8, Module 2 Round 5 |
| [D8](#d8) | One router per pod, factory to gateway; extroot is the escape hatch | accepted | Module 2, syllabus hardware |
| [D9](#d9) | Uplinks are plural; the LAN is the constant | provisional | Module 2 Round 3/7 |
| [D10](#d10) | Local broker first; overlay after the LAN works | accepted | Modules 2–3 |
| [D11](#d11) | Node-RED is a class service today and an own install later; never on the router | provisional | Modules 1, 4; workshop README |
| [D12](#d12) | Fieldbuses are compressed into one short module | provisional | Module 6 |
| [D13](#d13) | Each document has exactly one job | accepted | whole class folder |
| [D14](#d14) | The class is a draft in motion, with a visible boundary | provisional | every module |
| [D15](#d15) | The class must survive leaving the room | accepted | Module 2 Round 8, Module 3 |
| [D16](#d16) | English material, bilingual delivery | accepted | syllabus language section |
| [D17](#d17) | Sequence the semester: databases → sensors/actuators → networking | accepted | syllabus prerequisites, sibling classes |

## 1. Provenance — how this class came to be

### 1.1 Two lineages, one class

The class is a merge of two very different teaching traditions. Neither source
fits the 10-day HSBI format unchanged, and that mismatch is the reason most
decisions below exist.

| Lineage | Where it lives | What it contributed | What it could not provide |
|---|---|---|---|
| **Tartu IoT introduction** (15–16 weeks) | [`full-classes/unitartu-IoT-intro-15d/`](../../unitartu-IoT-intro-15d/README.md) | The practical thread: modules, portfolio, storytelling, M5Stack/IoTempower, final project, "tasks are a path, not a checklist" | Networking depth; OSI/fieldbus vocabulary; the HSBI examination form |
| **HSBI legacy lecture** *Vernetzung und IoT-Lösungen* | Local `class-design/ingest-dest/Vernetzung-IoT/` workspace (not tracked here) | The module handbook: OSI layers, interfaces, fieldbuses, wireless principles, application protocols; the Hausarbeit form | Student hardware, labs, overlays, anything hands-on |
| **The 10-day HSBI format** | This folder | Compression to one module per day, a lab per day, a project arc, a cohort that splits after class | — (this is the new constraint) |

The merge happened in the open. The first 10-day draft (commit `899e761`,
2026-08-28) already had the practical modules — MQTT, wireless, routing,
industrial protocols, power/latency, final-project rehearsal — but ordered them
MQTT-first and treated routing as one topic among many. The current order puts the
edge router on Day 2, because everything else depends on a network the students
own.

### 1.2 Timeline

Dates are commit dates. The row is what changed in the course design, not every
edit.

| Date | Commit / event | What happened | Why it matters |
|---|---|---|---|
| 2025-01-27 | `433f532`, `e597e78` | Repository re-initialised without binary blobs | The base for everything below. |
| 2026-05-15 | `8470580` | Google workbook exported; split into `full-classes/hsbi/` and `full-classes/unitartu/` | The Tartu course becomes the practical ancestor; the HSBI copy starts as a duplicate. |
| 2026-05-21 | `f9a1d72` | `workbook.orig.md` kept | The original export stays available for provenance. |
| 2026-05-23 – 05-29 | `a846b44` … `12d3d43` | HSBI copy adapted: order in Module 6, instructor notes, first localization | The first attempts to make the Tartu material fit HSBI. |
| 2026-08-28 | `899e761` | First `hsbi-networking-iot-10d` workbook, seven modules, syllabus | **The merge point.** Practical thread + handbook vocabulary, still MQTT-first. |
| 2026-09-03 | `57dc4f9` | Workbooks → `README.md`; modules restructured | One entry point per class; module files become chapters. |
| 2026-09-17 | `3bfec09` | Sensors & Actuators class added; LMS PDF export | The style starts travelling across sibling classes. |
| 2026-09-23 | `b6f9d96` | DRAFT BOUNDARY introduced | "The class is in flux" becomes visible instead of implicit. |
| 2026-09-24 | `4f9579c` | Shared "How we teach" section in all syllabi | The didactic model becomes a family statement. |
| 2026-09-25 | `eb4af8d` | Router sourcing notes; packet-journey clarifications | Hardware constraints enter the material. |
| 2026-10-01 | `03cd14c` | Databases class, first draft | The third sibling; the style is refined further. |
| 2026-10-20 | `b5c510d`, `d4fcb7b` | Structural dedup, ILIAS removed, reflection handling, module folder names; assessment storytelling standardised | The "one job per document" rule becomes real. |
| 2026-11-02 | `59d367d` | Learning-goal argumentation clarified in the syllabus | Assessment moves from "tasks" to "evidence for goals". |
| 2026-11-03 | `2dee0f7`, `e7de39e`, `85ad6b5`, `4f0ebbc`, `873e4ab` | Topic organisation + Module 1 slides; router-side capture; Nebula bundles; shared study log; assessment & operations notes | The operating model of the current offering. |
| 2026-11-10 | `7017adb`, `f52a5fb`, `82c4704` | Module 2 rewritten as factory-to-gateway; Nebula/Node-RED/SSH clarifications | The edge router becomes the spine of Day 2. |
| 2026-11-10 | this file (uncommitted) | Decision log reconstructed | The design memory is written down before it is lost. |

### 1.3 The style was learned on sibling classes

The class did not invent its didactics. It inherited a pattern library that was
tested on the other HSBI classes, and each class changed the library a little.

| Class | What it taught this class | What did **not** travel |
|---|---|---|
| [Databases](../../hsbi-databases-10d/README.md) | Local-first defaults; LLM output as a claim to verify; the portfolio → report pipeline; "one job per document"; decided-first task design; the folded-study studio (theory boxes, rounds, nearest-pod discussions) | SQL content, DuckDB/SQLite, the 11-session structure |
| [Sensors & Actuators](../../hsbi-sensors-actuators-10d/README.md) | Rounds with brief/bench/explain; exchange with a neighbour; hardware realism; the draft boundary; characterisation and measurement as evidence | Sensor physics, calibration labs, the sensor chain |
| [Microcontroller Programming](../../hsbi-MCU-programming-10d/README.md) | Compact block formats; M5Stack/IoTempower hand-over; what a 4-day version looks like | Breadboard and firmware content |
| This class | Integration capstone: the devices from the other classes become a network | — |

Cross-course names (Wittkamp, Frachtflow, the local-first theme) are reused only
where the story is genuinely shared. Each course's story stays self-contained;
do not make students read another workbook to understand a hook.

### 1.4 What is reconstructed, and what is memory

Be honest about the source of each claim:

- **Reconstructed with confidence:** dates, file structure, commit messages, the
  two lineages, the content shifts visible in diffs.
- **Instructor decisions from the first offering (November 2026):** the eduroam
  agreement with the DVZ, one router per pod, no pre-flashing, the Node-RED
  placement, no Chatto, no bus survey in Module 2, the Optiplex cluster plan.
  These are recorded here for the first time; they are not in Git.
- **Inference:** the *reason* for some early edits. The diff shows what changed,
  not why. Where a record says "because", check whether it is a file fact or a
  reconstruction.
- **Unknown:** decisions taken orally before the repository existed (the original
  Tartu split rationale, the first story-canon choices). Add them if they matter.

## 2. Decision records

<a id="d1"></a>
### D1 — The module handbook is the constraint; the didactics are ours

**Status:** accepted.

**Context.** Module 3264 fixes 150 h, 5 ECTS, the learning outcomes (OSI layers,
interfaces, fieldbuses, wireless principles, IoT standards) and the possible
examination forms. It does not prescribe a didactic model, a tool stack, or a lab.

**Decision.** Treat the handbook as the outer constraint and the didactics as
ours. Satisfy every outcome somewhere, map it in [Appendix A](#appendix-a), and
let the practical thread determine the order. Where an outcome would otherwise
eat a lab day (fieldbuses, line codes), cover it at reference depth and say so.

**Consequences.** The class can be innovative without becoming non-compliant.
Some outcomes are covered at "can explain and place" depth, not "can build".
That is a deliberate trade and must be defensible in the report argumentation
(and the short presentation of the report section).

**Alternatives rejected.** Teaching the handbook line by line (the legacy course);
ignoring inconvenient outcomes; pretending the lab covers everything.

**Evidence.** Handbook (local `class-design/` workspace); [Appendix A](#appendix-a);
[syllabus learning objectives](../syllabus.md#learning-objectives).

**Revisit if.** The handbook is revised, the examination form changes, or the
Prüfungsausschuss asks for stronger coverage of a specific outcome.

<a id="d2"></a>
### D2 — Practice is the spine; OSI is the reference dictionary

**Status:** accepted.

**Context.** The legacy course was OSI-first and nearly hardware-free; the Tartu
course was practical but not networking-deep. Students need both the vocabulary
and the ability to build.

**Decision.** Build → capture → explain. OSI is the dictionary used to name what
happened, introduced in Module 1 (OSI vs. TCP/IP, RFC 3439), indexed in Module 2
§3 ("The Vocabulary the Module Handbook Expects"), extended in Module 4
(protocol/port table) and Module 6 (bus/OSI map). No standalone OSI lecture.

**Consequences.** Students meet the model repeatedly, attached to an artefact.
They can place a protocol when asked, but they will not recite header fields from
memory. The vocabulary table is the safety net for the handbook.

**Alternatives rejected.** "OSI first, then build"; a separate theory day; header
arithmetic on paper.

**Evidence.** Module 1 goal 5; Module 2 §3; Module 4 warm-up; Module 6 tables.

**Revisit if.** A cohort arrives with no networking vocabulary at all. Then add a
pre-study refresher, not a lecture.

<a id="d3"></a>
### D3 — Learning goals are the contract; tasks are negotiable

**Status:** accepted.

**Context.** New class, changing hardware, mixed cohort, first offering. Fixed
step-by-step tasks break on the first missing adapter.

**Decision.** The learning goals are the contract; the tasks are negotiable.
Every module opens with measurable "you can …" goals, then a visible DRAFT
BOUNDARY. Tasks carry ★ (core) or ◇ (stretcher); long/risky blocks say
**Challenging**. No time estimates.

**Consequences.** The instructor can swap a task mid-day and still assess.
Students can take a different route. The report argues goals, not task completion.

**Alternatives rejected.** Fixed lab sheet with per-step grading; points for
attendance or completion; minute-by-minute plans.

**Evidence.** Every module; [syllabus task tiers](../syllabus.md#task-tiers--core-and--stretcher).

**Revisit if.** Accreditation requires evidence of specific task completion.

<a id="d4"></a>
### D4 — Assessment is a portfolio-to-report pipeline

**Status:** accepted.

**Context.** The examination form is a Hausarbeit, and the class is CBL/PBL. We
want process evidence: what was built, what broke, how the model changed.

**Decision.** One portfolio repository per student; module entries are sections
in `ModuleNN/README.md`; evidence → reflection → learning-goal argumentation; the
report synthesizes it. One pod member keeps the shared study log; the others link
to it and add one sentence. Checkpoints are feedback, not separate examinations.
The binding rules live **only** in the syllabus.

The chosen Prüfungsform is the **Hausarbeit**. The portfolio is deliberately
structured so it can be turned into the report: the conversion is a synthesis and
formatting step, not a new project, and it is not taught as a separate unit. For a
future offering, recommend **Projektarbeit** as the Prüfungsform — the class is
project-based — but keep the 20-point learning-goal assessment unchanged.

**Consequences.** Documentation is part of the lab, not an afterthought. Linking
instead of copying keeps the pod honest and the evidence attributable. The
instructor reads evidence, not file trees. Module files never restate points.
Retakes are handled case by case with the Prüfungsamt and the student; no fixed
scope rule is published.

**Alternatives rejected.** Written exam; per-task points; grading the portfolio
as a file dump; a separate "reflection logbook" with its own rules.

**Evidence.** [Syllabus assessment](../syllabus.md#assessment-hausarbeit-20-points);
[Assessment & operations](./00-assessment-and-operations.md); Module 1 portfolio
sections; commit `4f0ebbc` (shared study log).

**Revisit if.** The examination form changes or the Prüfungsamt requires a
different artefact.

<a id="d5"></a>
### D5 — Stories carry the why; the canon keeps them consistent

**Status:** accepted.

**Context.** CBL/PBL needs a concrete problem. "A factory" does not motivate; a
named person with a bad Monday does.

**Decision.** Every module has one story with named people, a place, and something
at stake, plus a story hook per task. Stories stay in the canon (Stadtwerke
Gütersloh, Lumenwerk, Frachtflow, Klimapark, Brinkmann Maschinenbau); new material
must fit it. The story is unfinished on purpose: students add observations.

**Consequences.** Tasks have a reason and a failure mode. Students can pitch. The
canon prevents a thousand inconsistent examples. Cross-course names are reused
only where the story is shared; each course's story stays self-contained.

**Alternatives rejected.** Protocol-first labs; generic vendor case studies; a
story that explains the technology instead of motivating it.

**Evidence.** Resource bank
[`#story-canon-the-recurring-cast`](../modules/Z-resources-bank.md#story-canon-the-recurring-cast)
and [`#story-craft-is-it-concrete-enough`](../modules/Z-resources-bank.md#story-craft-is-it-concrete-enough);
Module 1/2 stories.

**Revisit if.** A real partner replaces a fictional one, or a story stops matching
the technology.

<a id="d6"></a>
### D6 — Studio rhythm: challenge → practice → theory on demand → discussion

**Status:** accepted for Modules 2–7; Module 1 remains the exception because its Master Class opening is the course introduction.

**Context.** The first version put a pod-study block before the lab. It ate a
large block of the session and crowded out the practice; the Databases and
Sensors & Actuators classes moved to folding the theory into the work and got
better results. The same cohort needs the theory at the point where the task
makes it relevant.

**Decision.** Open with a challenge brief, then work in rounds. Each round has a
short **Theory you need** box read only when the task needs it, and ends with a
short **discussion**: show the artefact to one person at the nearest pod, ask the
discussion question, and swap one question back if they are willing. The round
table names the learning goal and the theory box each discussion checks, so the
question tests understanding rather than completion. There is no separate
pod-study phase and no whole-pod hand-off. A theory box can become a study break:
read the source, then explain it to one person.

**Consequences.** Class time is for doing; the room teaches itself; a stuck pod
can switch rounds. The instructor demos risky steps live and floats. The exchange
is ad hoc and one-to-one, so it does not need the whole pod to stop. The risk is
that a pod skips the theory and copies steps; the discussion question — *what did you
choose, and what did it cost?* — is the check.

**Alternatives rejected.** A separate pod-study block; a scheduled whole-pod
hand-off; lecture + lab; a compulsory harvest.

**Evidence.** Modules 2–7 "How this studio works now" and their round tables;
Databases Module 5 "How this studio works now"; Sensors & Actuators Module 3
"Studio rhythm"; resource bank "Studio rhythm".

**Revisit if.** The rounds lose the theory or the weaker students; then add a compact
optional study block, not a return to the full pod study. Module 1 remains the
exception because it is the first contact with the format; migrate it only if a
future cohort needs the same studio rhythm from day one.

<a id="d7"></a>
### D7 — Capture at the choke point; analyse offline

**Status:** accepted.

**Context.** One Wi-Fi adapter per laptop, usually Windows, no monitor mode. A
laptop cannot see another station's unicast traffic; streaming into a GUI is
fragile; Wireshark may not be installed.

**Decision.** Capture at a point the traffic must cross: `tcpdump` on the router
(`br-lan`), an ESP32 tap, or an instructor-provided pcap. Copy the file and read
it offline with Wireshark, `tshark`, or `tcpdump -A`. A provided dump is full
evidence.

**Consequences.** Every capture lab needs a prepared dump and a router that can
capture. Students learn analysis, not sniffing. The router is the choke point by
design, which also motivates Module 2's topology.

**Alternatives rejected.** Requiring monitor mode or a second adapter; live GUI
streaming; phone tethering as the capture point; making Wireshark mandatory.

**Evidence.** Module 1 Task 8; Module 2 Round 5; resource bank
[`#packet-capture-without-a-second-wifi-card`](../modules/Z-resources-bank.md#packet-capture-without-a-second-wifi-card);
commit `e7de39e`.

**Revisit if.** Every student gets a supported capture adapter — unlikely on
company laptops.

<a id="d8"></a>
### D8 — One router per pod, factory to gateway; extroot is the escape hatch

**Status:** accepted.

**Context.** The Cudy TR1200 has 16 MB flash, 128 MB RAM, one USB 2.0 port, and
pure upstream OpenWrt. Students must own the edge. Flashing is easy; extroot is
where they struggle.

**Decision.** One router per Task Pod (2–3 students), factory firmware on
arrival, no pre-flash. Students flash the Cudy intermediate image, then the latest
stable upstream OpenWrt. Immediately after, extroot on a USB stick (> 4 GB) with a
mini hub. The stick travels with the router. 16 MB is a design constraint, not a
bug.

**Consequences.** Every pod has a real gateway and a WAN address. The instructor
demos flashing and extroot live. Nebula and `tshark` fit because the overlay is on
the stick. The pod must agree who carries the router.

**Alternatives rejected.** Instructor pre-flashes 15 routers; vendor forks such as
the GL-SFT1200 ("Opal"); one router per two students; SD-card-only extroot;
running everything from 16 MB.

**Evidence.** Module 2 Rounds 1–2; syllabus hardware; README router-sourcing note;
commit `7017adb`.

**Revisit if.** A router with more flash/RAM becomes affordable, or a cohort
cannot handle extroot — then pre-extroot the sticks, not the routers.

<a id="d9"></a>
### D9 — Uplinks are plural; the LAN is the constant

**Status:** provisional.

**Context.** Eduroam works and the DVZ approved one student routing a pod, but it
is 802.1X, may isolate clients, and needs a full `wpad` plus the right clock and
CA. Phone tethering is universal. The class B1300 Wi-Fi is deterministic and does
not isolate wireless clients by default; isolation can be enabled as an
experiment. At home, the uplink is different again.

**Decision.** Uplinks are plural: eduroam 5 GHz first, phone USB tether second,
`iotempire-b1300-5g` third, optional wired uplink. All end in a WAN default route
(`wwan` for Wi-Fi/tether, `wan` for Ethernet). The LAN is always
`192.168.14.0/24` with the router at `.1`; never the OpenWrt default
`192.168.1.0/24`. Credential ownership follows the router: the student who
provides the eduroam account owns and carries it. If the router moves to another
pod member, remove the credential before the handover.

**Consequences.** One topology, several WAN paths. The port-forward test uses the
B1300 as the outside network; it does not isolate clients by default, so the
outside laptop works directly. If you enable isolation as an experiment, use a
wired outside client. Students verify with
`ubus call network.interface.wwan status` and `ip route`.

**Alternatives rejected.** A single mandatory uplink; campus VLANs/overlays per
pod (a DVZ burden); the default `192.168.1.0/24`; calling the B1300 a "wire" — it
is a Wi-Fi network (`iotempire-b1300-5g`, `192.168.114.0/24`).

**Evidence.** Module 2 Rounds 3/7; instructor decision (DVZ agreement); syllabus.

**Revisit if.** Eduroam blocks the router, the B1300 is retired, or the DVZ
changes the agreement.

<a id="d10"></a>
### D10 — Local broker first; overlay after the LAN works

**Status:** accepted.

**Context.** Students need a shared service that works before they leave, and
captures need interesting traffic. Nebula needs extroot, a CA, and a lighthouse;
the local broker needs one package.

**Decision.** LAN first, then local Mosquitto on the router (anonymous, no TLS
inside the pod LAN), then the overlay in Module 3. The no-TLS broker is a lab
choice with a guardrail: it is reachable only from the pod LAN, and it is not a
model for production.

**Consequences.** Every pod has a broker by the end of Day 2. Captures show ARP,
DHCP, DNS and MQTT. The overlay is motivated by a real limitation (NAT, changing
WAN, pods split), not by a slide.

**Alternatives rejected.** Cloud broker as the default; Nebula on Day 2 before the
LAN works; TLS from the start (the certificate ceremony would eat the day).

**Evidence.** Module 2 Round 4; Module 3; Module 4; instructor decision.

**Revisit if.** A security review requires TLS, or the campus blocks broker
traffic — it does not inside the pod LAN.

<a id="d11"></a>
### D11 — Node-RED is a class service today and an own install later; never on the router

**Status:** provisional.

**Context.** Node-RED on a 16 MB/128 MB router is overkill. Locked-down company
laptops cannot install it or a Nebula client. The Master Class needs zero setup on
Day 1.

**Decision.** `classroom-nodered.sh` on the class host is the Master Class path
(Day 1 only). From Module 4, students install and use their own Node-RED on the
Optiplex cluster (once it exists and is in Nebula) or their laptop. Node-RED is
never on the router. The router runs Mosquitto and, optionally, small MicroPython
services; a MicroPython IoTknit port is planned, not supported.

**Consequences.** Day 1 has no install friction. Later modules need a browser-only
fallback (MQTT Explorer, `mosquitto_sub`). The Optiplex cluster is a preparation
dependency, not a given. Locked-down laptops depend on the class host.

**Alternatives rejected.** Node-RED on the router; recorded demo sessions as the
fallback; requiring every student to install Node-RED on Day 1; a cloud Node-RED.

**Evidence.** Module 1 Task 3; Module 4; workshop README; commits `82c4704` and
`f52a5fb`; instructor decision.

**Revisit if.** The Optiplex cluster is ready and can host Node-RED for the whole
week, or every student has admin rights.

<a id="d12"></a>
### D12 — Fieldbuses are compressed into one short module

**Status:** provisional.

**Context.** The handbook requires an overview of industrial fieldbuses and their
place in OSI. We have almost no industrial hardware, a few RS-485 devices, and
EtherCAT test devices upstairs. The legacy course over-weighted this; the sibling
courses cover low-level buses.

**Decision.** Compress fieldbuses into Module 6: one video + discussion, an
RS-485/Modbus demo if the hardware is there, an EtherCAT guest slot if we can get
one. The OSI map and comparison tables are reference, not lecture. Low-level buses
(UART, I²C, SPI, OneWire) are delegated to Sensors & Actuators and MCU
Programming. No bus survey in Module 2.

**Consequences.** The module runs without hardware. Students get the map and the
vocabulary; the lab is optional. A study log with the OSI map and the comparison
table is sufficient evidence for the fieldbus outcome; the demo is a bonus, not a
requirement. The class does not pretend to be an industrial lab.

**Alternatives rejected.** A full industrial lab; a second OSI-first lecture;
teaching UART/I²C/SPI here; mirroring the Sensors & Actuators bus survey into
Module 2 (the old `TODO(instructor)`).

**Evidence.** Module 6; resource bank "Bus and fieldbus coverage" and "Module 6
keep it short"; commit `4c5fc96`.

**Revisit if.** An industry partner provides a test rig, or a guest lecturer
becomes a regular slot.

<a id="d13"></a>
### D13 — Each document has exactly one job

**Status:** accepted.

**Context.** The first drafts duplicated assessment, schedule and tasks across
README, syllabus, modules, index and resource bank. Every copy drifted.

**Decision.** Each document has one job: syllabus = assessment/schedule/policies;
README = pitch and navigation; index = roadmap; modules = teaching material;
resource bank = recipes/canon/hints; instructor-notes = operations/design memory.
Link, don't copy.

**Consequences.** A point value changes once. A module never restates points. The
link checker enforces the links. The reader always knows where the binding text
is.

**Alternatives rejected.** A single monolithic workbook (the Tartu/initial
format); duplicating the schedule in every module; a second assessment page.

**Evidence.** Commit `b5c510d` (dedup, ILIAS removed, folder names); current
structure; the repository's link checker.

**Revisit if.** The LMS needs a self-contained export. Generate it from the
sources; do not hand-maintain a second copy.

<a id="d14"></a>
### D14 — The class is a draft in motion, with a visible boundary

**Status:** provisional.

**Context.** The class is new and changes while it runs. Students need to know
what is stable.

**Decision.** Every module has a visible DRAFT BOUNDARY after the learning goals.
Above the line is the contract; below is provisional. The syllabus states the
model.

**Consequences.** The instructor can change a task without renegotiating the
contract. Students see what is stable. The boundary is a promise, not an excuse
for an unfinished page.

**Alternatives rejected.** A frozen syllabus in the first offering; silent
changes; marking everything as draft.

**Evidence.** Commit `b6f9d96`; all modules.

**Revisit if.** The class is offered a third time and the modules stabilise. Then
remove the boundary per module, not globally.

<a id="d15"></a>
### D15 — The class must survive leaving the room

**Status:** accepted.

**Context.** Pods split after class. Campus Wi-Fi is not available at home.
Students may have dorm Ethernet or home Wi-Fi; some laptops are locked down.

**Decision.** Every pod takes its router home; Module 2 Round 8 verifies a home
uplink; Module 3's overlay makes the split pod reachable; the core does not depend
on campus infrastructure. The B1300 is a classroom fallback, not a take-home
requirement.

**Consequences.** The router is the student's edge; the extroot stick travels; the
pod agrees who carries it. The credential owner is the router owner; a handover to
another pod member requires removing the credential first. Students can meet in
person at home and continue. The overlay is not optional decoration; it is the
continuity mechanism.

**Alternatives rejected.** Campus-only labs; cloud-only services; assuming every
student has admin rights; a class that stops at the classroom door.

**Evidence.** Module 2 Round 8; Module 3; instructor decision.

**Revisit if.** The university provides a persistent lab network or a VPN for
every student.

<a id="d16"></a>
### D16 — English material, bilingual delivery

**Status:** accepted.

**Context.** The module is German-language at HSBI, the material is reused
internationally, and the IoTempower community is English-speaking.

**Decision.** Written material in English; German quotations and terms allowed in
parentheses; students may speak, write and submit in German, English, or mixed;
code and identifiers in English.

**Consequences.** One reusable material base, no translation fork. Instructors
must be bilingual or pair up. German terms appear where they help
(Bitübertragung, Vermittlung).

**Alternatives rejected.** German-only material; English-only communication;
translating the workbook per cohort.

**Evidence.** [Syllabus language section](../syllabus.md#language-communication--course-material).

**Revisit if.** The module is taught in a German-only program with no reuse.

<a id="d17"></a>
### D17 — Sequence the semester: databases → sensors/actuators → networking

**Status:** accepted.

**Context.** Three sibling classes share students and style: Databases, Sensors &
Actuators, Networking & IoT. Each depends on different prior knowledge.

**Decision.** Sequence the semester Databases → Sensors & Actuators → Networking &
IoT. Databases builds data contracts and local-first habits; Sensors builds
measurement and hardware; Networking integrates devices into systems. Networking
assumes basic Git/shell/Python, not prior networking.

**Consequences.** Networking can reference data and sensor evidence; students
arrive with portfolio habits; the class is the integration capstone of the trio.
The order is a timetable decision, not a hard prerequisite.

**Alternatives rejected.** Networking first; teaching the trio as one block; a
shared mega-course.

**Evidence.** Syllabus prerequisites/relationship; sibling READMEs; instructor
decision.

**Revisit if.** The timetable reorders the modules. Then adjust the prerequisites,
not the goals.

## 3. Deliberately rejected or retired

These are not "bad ideas we never had". They are alternatives that looked
plausible and were declined for a reason. Keep the reason; it is what stops the
idea from returning as a "simple fix".

| Alternative | Why rejected | What would bring it back |
|---|---|---|
| **OSI-first lecture course** | Students learn to name layers but not to build; the legacy version had almost no hardware and no student-owned network. | A cohort with no networking vocabulary at all — then add pre-study cards, not a lecture. |
| **A bus survey in Module 2** | Low-level buses belong to Sensors & Actuators / MCU Programming; repeating them in the networking lab eats the router day. The old `TODO(instructor)` about mirroring the survey was resolved this way. | Project wiring in Modules 7–8 needs a specific bus; teach that one, on the device, not a survey. |
| **Instructor pre-flashes every router** | Flashing is easy (intermediate image, then upstream OpenWrt); pre-flashing hides the only step students must be able to repeat. Extroot is the hard part, and it still needs the student. | A cohort cannot flash at all — then pre-extroot the USB sticks, not the routers. |
| **One router per two students** | A pod is the unit of work and the unit of assessment; a shared router across pods breaks the take-home path. | Never; the hardware count is per Task Pod. |
| **Node-RED on the router** | 16 MB flash / 128 MB RAM; the router is a gateway and broker, not an application server. | Never. If a service must run on the router, it is Mosquitto or a small MicroPython service. |
| **Recorded Master Class demo sessions** | The old recordings are locked away and do not match the current stack; a recording cannot answer the room's question. | Never as the primary path; a short clip is acceptable only as a pre-class teaser. |
| **Chatto / a class chat tool in Module 2** | It adds an account and a service before the network works; the class already uses Discord/LMS for sharing. | A cohort that needs a persistent chat from Day 1 — then decide it at class level, not in Module 2. |
| **Cloud broker as the default** | The class is local-first; a cloud broker turns a network lab into an account setup and hides NAT. | A project needs remote access before Module 3 — then use the overlay, not a public broker. |
| **Monitor mode / a second Wi-Fi adapter** | The room has one adapter per laptop, usually Windows, and no monitor-mode support; a lab that requires it fails for most students. | Every student is issued a supported adapter. |
| **Live capture streaming into a GUI** | Fragile, Windows-hostile, and it hides the analysis; the capture belongs on the router, the reading belongs offline. | Never; a live view can be a demo, not a lab step. |
| **A simulated industrial lab as the default** | No industrial hardware, and a simulation teaches the wrapper, not the bus; Module 6 is short and honest about it. | A test rig or a guest lecturer makes it real. |
| **A single monolithic workbook** | It duplicates assessment and schedule and drifts; the Tartu/initial format was replaced by README + modules. | The LMS demands one file — generate it from the sources. |
| **ILIAS as the material home** | Removed in `b5c510d`; the public repository is the material base and the LMS is the announcement channel. | The university mandates ILIAS for all course material. |
| **The container fleet as the course default** | `classroom-nodered.sh` is the Day-1 fast path, not the project environment; students need their own instance from Module 4. | The Optiplex cluster is ready and can host every pod all week. |
| **Time estimates in tasks** | They are wrong for a mixed cohort and turn a path into a timetable; the tier and **Challenging** carry the difficulty signal. | Never. |
| **Points, tiers or a "reflection logbook" in a module** | Assessment lives only in the syllabus; a second copy drifts and misleads. | Never. Link to the syllabus. |
| **Calling `iotempire-b1300-5g` a "wire"** | It is a Wi-Fi network (`192.168.114.0/24`), not an Ethernet run; the wording sent students looking for a cable. | Never; say "class Wi-Fi" or the SSID. |

## 4. Open questions

These are recorded so they are decided deliberately, not by drift. "Owner" is who
can close the question, not who is currently doing the work.

| Question | Why it matters | Current default | Owner |
|---|---|---|---|
| **Prüfungsform for the next offering**: should the class move from Hausarbeit to Projektarbeit? | The class is project-based, so Projektarbeit fits the workflow better. The current form works and the portfolio converts easily, so this is not urgent. | Hausarbeit; recommend Projektarbeit for a future offering; confirm with the Prüfungsausschuss. | Module coordinator / Prüfungsausschuss |
| **Handbook depth for line codes and spread spectrum**: is "name and place" enough? | The chosen form is a Hausarbeit, not a separate oral examination; the report argumentation can carry reference depth. If the form ever changes to a Klausur or mündliche Prüfung, this becomes a real gap. | Reference depth; no coding-theory arithmetic. | Module coordinator |
| **Optiplex cluster**: which OS, how many Node-RED instances, how is it added to Nebula, who powers it? | It is the intended home for the "own Node-RED" path and for browser-only students; without it, Module 4 falls back to laptops and the class host. | Keep as is: laptops and the class host are the fallback; the cluster is optional, not a dependency. | Instructor + IT |
| **Chat and sharing**: is Discord the official channel, or only peer sharing? | Modules ask pods to post a shared artefact; if the channel is not official, the evidence must still be reachable in the portfolio. | LMS for official communication; Discord for peer sharing. | Instructor |
| **MicroPython IoTknit port**: does it land, and does it replace the Mosquitto-only router story? | It would make the router a first-class node and change Module 2/7; until then it is "planned, not supported". | Mosquitto and small MicroPython services; no IoTknit on the router. | Developer / instructor |
| **EtherCAT guest slot**: who comes, when, and does the test device need a safety briefing? | The guest is the strongest part of Module 6, but it is not a dependency. | Optional slot; video + discussion if nobody comes. | Instructor |
| **Harvest assessment**: keep it ungraded and optional? | It works because it is low-stakes; grading it would turn curiosity into a task. | Ungraded, optional, never a quiz. | Instructor |

## 5. Recreation checklist

A compact path for rebuilding a similar class. Each step names the decision it
embodies, so the new instructor can see what is load-bearing.

**Before writing**

1. Get the binding module handbook and the examination regulations. Extract the
   outcomes and the examination form into a table (D1).
2. Choose the format: days, contact hours, cohort size, hardware per pod (D8).
3. Write the one question the course answers. For this class: *how do I connect
   devices that do not share a network, a provider, or a trust domain — and keep
   the system working when a link dies?*

**Assessment spine**

4. Choose the artefact (portfolio → report) and write the **syllabus first** (D4).
5. Define evidence → reflection → learning-goal argumentation. Decide the shared
   study-log rule (one keeper per pod, others link) (D4).
6. Put every point, tier and checkpoint in the syllabus only (D13).

**Module skeleton**

7. Write the learning goals per module, then add the DRAFT BOUNDARY (D3, D14).
8. Assign ★/◇; mark long/risky blocks **Challenging**; remove every time estimate
   (D3).
9. Build the story canon and one story per module; write a hook per round (D5).
10. Write the studio rhythm into the module template; make the challenge-and-rounds
    format the default and a separate pod study the exception (D6).

**Infrastructure**

11. Choose hardware per pod, not per student. Buy one known-good spare (D8).
12. Flash and extroot one router yourself before you write the steps. Write the
    recovery notes from the failure, not from the manual (D8).
13. Decide the uplink paths and the LAN standard; make the fallback visible in the
    task (D9).
14. Place services deliberately: broker on the router, Node-RED off the router,
    overlay after the LAN (D10, D11).

**Materials**

15. Write the capture/recipe page from the real failures; keep one home for each
    recipe (D7, D13).
16. Write instructor notes for the risky sessions (extroot, Nebula, port forward),
    not just for the happy path.
17. Run the link/anchor/fence checker and `git diff --check` before every review
    (D13).

**First offering**

18. Deliver Module 1, then adjust. Keep this log: add a record when a choice
    constrains future material or a rejected alternative resurfaces (D14).
19. Collect the harvest questions and turn two of them into the next revision.

<a id="appendix-a"></a>
## Appendix A — Module handbook coverage

The handbook is the binding constraint (D1). This is the working map; it is a
design aid, not a legal document. "Depth" means: **covered** = built or measured;
**reference** = explained and placed, not exercised; **partial** = named but not
practised; **delegated** = belongs to a sibling class.

### A.1 Learning outcomes

| Handbook outcome | Where it is covered | Depth | Note |
|---|---|---|---|
| Fundamentals and application areas of IoT | Module 1; Modules 7–9 | covered | Story-driven continuum, fleet, project. |
| Name and explain the ISO/OSI layers | Module 1 §1; Module 2 §3; Module 4 warm-up; Module 6 table | covered | OSI is the dictionary, not the spine (D2). |
| Interfaces between the layers; apply them | Module 1 Task 8; Module 2 Round 5; Module 4 | covered | Measured in captures and MQTT/TCP framing. |
| Processes between layers; name the data abstraction | Module 1 Task 8; Module 2 Round 5; Module 4 | covered | Encapsulation and overhead arithmetic. |
| Overview of industrial fieldbuses, protocols, and their place in OSI | Module 6 | reference | No industrial lab (D12). |
| IoT communication standards (OPC-UA, MQTT, CoAP) | Module 4 (MQTT, CoAP); Module 6 (OPC-UA) | covered | CoAP is a comparison, not a lab. |
| Evaluate bus technologies and use cases | Module 6 comparison table + discussion; optional lab | partial | No hands-on bus comparison unless hardware is present. |
| Principles of wireless communication and standards | Module 5 | covered | Spectrum, ISM, path loss, CSMA/CA; spread spectrum is not explicit. |
| Transfer to resource-efficient IoT solutions | Module 1 Task 8; Module 5; Modules 8–9 | covered | Overhead/power arithmetic, ESP-NOW, project. |

### A.2 Handbook content

| Handbook content | Where it is covered | Depth | Note |
|---|---|---|---|
| Introduction to IoT | Module 1 | covered | |
| Computer networking basics: terms, services, roles, media, protocols, serial/parallel, synchronous/asynchronous, direction, topologies | Module 2 §3; Module 1 | reference | The vocabulary table is the index; not every term is exercised. |
| Physical layer: media, collisions, line codes | Module 2 §3; Module 5 | partial | Line codes are named (NRZ, Manchester, OFDM), not calculated. |
| Data link: media access, addressing, error detection, rings, STP, collision domains | Module 2 §3; Module 5 | partial | STP is named and explicitly not used; rings appear as topology vocabulary. |
| Network layer: routing, broadcasting, network classes, fragmentation | Module 2 | covered | `ip route`, DHCP broadcast, MTU. |
| Transport layer: connection-oriented/connectionless, flow control | Module 4; Module 2 §3 | covered | TCP/UDP, QoS, flow control. |
| Session layer: setup/teardown, synchronisation | Module 4; Module 2 §3 | covered | MQTT session; no separate session lab. |
| Presentation layer: representation and formatting | Module 4; Module 2 §3 | covered | JSON, TLS; the layer is named, not engineered. |
| Application layer: DNS, DHCP, NTP, SSH, HTTP, SMTP, POP3, FTP | Module 2 (DNS/DHCP); Module 4 protocol/port table; resource bank SSH/tunnelling | reference | SMTP/POP3/FTP are table-only by design; SSH is exercised as a tunnel stretcher. |
| IoT standards and fieldbuses | Module 6 | reference | |
| Low-level device buses (UART, I²C, SPI, OneWire) | Sensors & Actuators; MCU Programming | delegated | Not part of the networking lab (D12). |
| Wireless: spectrum, fundamentals, ISM, propagation, spread spectrum, media access | Module 5 | partial | Spread spectrum is the one named-but-not-taught item. |

**What this means.** Every handbook outcome is covered at least at reference
depth, and the class is honest about the partials. The chosen form is a
Hausarbeit, so the learning-goal argumentation carries these partials rather than
overclaiming; if the form ever changes to a Klausur or mündliche Prüfung, add
pre-study cards for line codes, spread spectrum, STP/rings and the protocol/port
table. Do **not** take lab time from the router, capture or project days.

<a id="appendix-b"></a>
## Appendix B — Where the source material lives

For a re-creator with access to the instructor's workspace:

- **In this repository:** [`full-classes/unitartu-IoT-intro-15d/`](../../unitartu-IoT-intro-15d/README.md)
  (practical ancestor), [`hsbi-databases-10d`](../../hsbi-databases-10d/README.md),
  [`hsbi-sensors-actuators-10d`](../../hsbi-sensors-actuators-10d/README.md),
  [`hsbi-MCU-programming-10d`](../../hsbi-MCU-programming-10d/README.md),
  [`workshops/mastering-iot-solutions/`](../../../workshops/mastering-iot-solutions/README.md).
- **Local only, not tracked here:** the `2026 HSBI/class-design/` workspace with
  `ingest-dest/Vernetzung-IoT/` (legacy lecture, exercises, project documents,
  module handbook), the announcement, and `workbook.orig.md`. Do not link to
  these from public material; they are context for the instructor and the agent.
- **Key commits:** `8470580` (Tartu split), `899e761` (first 10-day networking
  workbook), `b5c510d` (dedup and folder structure), `2dee0f7` (topic
  organisation + Module 1 slides), `e7de39e` (router-side capture), `85ad6b5`
  (Nebula bundles), `7017adb` (Module 2 rewrite).

<a id="appendix-c"></a>
## Appendix C — Change log of this document

| Date | Change | By |
|---|---|---|
| 2026-11-10 | First version; provenance, 17 decision records, rejected alternatives, open questions, recreation checklist, handbook coverage map | Ulno + agent |
| 2026-11-10 | Closed the first-offering questions: Hausarbeit kept, Projektarbeit recommended for the next run; Module 6 evidence confirmed; B1300 isolation default and credential-ownership rule recorded; retakes handled case by case | Ulno + agent |
| 2026-11-10 | Flipped the Module 2 studio: challenge brief, theory on demand, round discussions with one person, no separate pod study; D6 revised, rollout to Modules 1 and 3–7 pending | Ulno + agent |
| 2026-11-10 | Converted Modules 3–7 to the studio rhythm; D6 accepted for Modules 2–7, Module 1 remains the exception; Module 7 fleet lab aligned with the current IoTempower `system.conf` / `node.conf` / `deploy` workflow | Ulno + agent |
| 2026-11-10 | Renamed the pedagogical gates to discussions in Modules 2–7; each round table now maps its discussion to a learning goal and theory box, following the Databases TODO | Ulno + agent |
