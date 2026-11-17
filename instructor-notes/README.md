# Instructor Notes (Repository Level)

This folder holds the material that applies to **every** class. Class-specific notes stay in
`full-classes/<class>/instructor-notes/`.

## Start here

- **[Best practices across the HSBI classes](./00-best-practices.md)** — the invariants, the
  defaults, the patterns, the anti-patterns, the retrofit checklist, and the decision-record
  template. Distilled from the three class ADRs and the repository working agreement.
- **[New class template](./01-class-template.md)** — folder layout, one job per file, the syllabus,
  module, ADR, and TODO skeletons, and the pre-flight checklist.

## Repository rules and tools

- **[`AGENTS.md`](../AGENTS.md)** — the operative agreement for agents: commits, edit tools,
  privacy, assessment boundaries, language, vocabulary, and the validation commands.
- **[`tools/README.md`](../tools/README.md)** — `check-all.sh`, `check-docs.sh`, `check-slides.sh`,
  and the LMS PDF generator.

## Class architecture logs

| Class | Decisions | Notes |
|---|---|---|
| [Sensors and Actuators](../full-classes/hsbi-sensors-actuators-10d/README.md) | [ADR](../full-classes/hsbi-sensors-actuators-10d/instructor-notes/00-architecture-decisions.md) | 9 days, Kombinationsprüfung, project video |
| [Databases](../full-classes/hsbi-databases-10d/README.md) | [ADR](../full-classes/hsbi-databases-10d/instructor-notes/00-architecture-decisions.md) | 11 sessions, Projektarbeit |
| [Networking and IoT Solutions](../full-classes/hsbi-networking-iot-10d/README.md) | [ADR](../full-classes/hsbi-networking-iot-10d/instructor-notes/00-architecture-decisions.md) | 10 days, Hausarbeit |
| [Microcontroller Programming](../full-classes/hsbi-MCU-programming-10d/README.md) | — | 10-week edition; no ADR yet |
| [Microcontroller Programming (4-day)](../full-classes/hsbi-MCU-programming-blocked-4d/README.md) | — | Block format |
| [Tartu IoT Introduction](../full-classes/unitartu-IoT-intro-15d/README.md) | — | 15–16 weeks; the practical ancestor |

## How this folder stays current

- A pattern is promoted here only after it has survived **two** classes, or when it is a hard
  repository rule.
- The class ADR remains the binding record for that class. If this folder and a class ADR
  disagree, the class ADR wins; if the disagreement is about assessment, the syllabus wins.
- When a cross-class rule changes, update [`AGENTS.md`](../AGENTS.md) first, then the entry here,
  then the class ADRs that encode it.
