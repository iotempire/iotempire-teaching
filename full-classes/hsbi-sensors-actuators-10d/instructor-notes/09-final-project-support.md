# Final Project Support — Modules 8–10 (Days 8–9)

[Module 8](../modules/08-sensor-to-system-and-integration.md) · [Module 9](../modules/09-final-project-studio.md) · [Module 10](../modules/10-demonstration-and-presentation.md) · [Architecture decisions](./00-architecture-decisions.md) · [All instructor notes](./README.md)

**No new points and no new content.** Everything on these two days feeds the 5 project points, and the assessed artifacts are the submitted documentation, video, and slide deck. These days are **support**, not teaching: hardware, cardboard, cable ties, and the question that unblocks a team.

| | |
|---|---|
| **Prepare** | Spare servos, motors, drivers, jumpers, USB cables, 5 V supplies, a knife and cardboard; CP3 lanes; the syllabus rubric at hand |
| **Practice** | One timed 15-minute walkthrough from the projector before the first team presents |
| **Students leave with** | Day 8: a system that works end to end and is measured. Day 9: a stable demo, one rehearsal, and feedback |
| **Must run** | Day 8: CP3, boundary document, one end-to-end path. Day 9: one rehearsal, three walkthroughs |
| **Cut first** | Beautifying, slides, stretch goals — never the measurement, never the rehearsal |

## Day 8 — 2026-12-09 · 6 school hours (2 sessions)

| Session | What happens |
|---|---|
| 08:30–11:30 (Praktikum) | CP3 first (Module 7, ~30 min, two lanes if possible), then the Module 8 clinic: draw the boundary, close the loop with one filter and a safe state, run the sensor-disconnect and actuator-stall tests. Track B teams add MQTT in parallel — never as a prerequisite. |
| 12:30–14:00 (supervised self-study) | Build. Goal: **one end-to-end path** — sensor → filter → rule → actuator → visible output. Log it, commit it. |

**The freeze rule, said at the start of the day:** by the end of Day 8 the system works end to end and at least one sensor is measured. Everything after that is polish. Teams that arrive on Day 8 without a story from Day 7 get five minutes to pick one, then build.

**What to do while they build.** You are the runner: a spare jumper, a spare driver, another USB cable, and a knife. Sit with the team that is behind, not the one that is ahead. Ask two questions of every team before they leave: *what is measured,* and *what breaks.*

## Day 9 — 2026-12-16 · 8 school hours (3 sessions)

| Session | What happens |
|---|---|
| 08:30–11:30 (Praktikum) | Finish and beautify: cable routing, a cardboard or diffuser mount, a power connection that survives a bump, and a README that another team can rebuild from. **No new features.** One timed rehearsal done by 11:15. |
| 11:30–12:30 | Break. Teams may keep practising; nothing new is introduced and no new hardware is handed out. |
| 12:30–14:00 (supervised self-study) | Demo preparation and a second full rehearsal: the 15–20 minute walkthrough, the 2-minute fallback clip, and who answers which question. |
| 14:15–15:45 (supervised self-study) | The three walkthroughs, 30 minutes each: 15–20 minutes presentation, 10–15 minutes feedback from the instructor and the other teams. |

## The 30-minute slot

- **15–20 minutes:** story, architecture, one live measurement, one actuator response, one fault test, and the plan for the video.
- **10–15 minutes:** feedback. One thing that impressed, then the question that matters. The other teams ask first; the instructor closes.
- **Not assessed live.** Say it out loud at the start of the block: the graded artifacts are the documentation, the video, and the deck. This is a feedback rehearsal, so a crashed demo costs nothing.

Two rounds are not scheduled. Teams that want a second attempt record it after class as the submitted video — that is the second round, and it is better than a live retry.

## After class

- Teams record and edit the 5–10 minute video and submit it with the deck and documentation by the **last day of the examination period**, announced in the LMS.
- The Part 1 portfolio is due the same day. The Day 9 reflection may be written that evening or the next morning; it only has to be in the portfolio by the deadline.
- Nothing is collected on paper. If a team's only copy is on one laptop, make them push before they leave.

## What goes wrong

- **A new feature starts on Day 9.** The freeze rule; repeat it, do not negotiate.
- **The demo depends on the room Wi-Fi.** Track B needs a local fallback or a recorded clip. A hotspot is a fallback, not an architecture.
- **Twenty minutes of slides, no live path.** Rehearse the live path; cut slides.
- **One member cannot explain their part.** Name the parts at the Day 9 rehearsal, not at the walkthrough.
- **The team is still assembling at 14:15.** Accept the smaller demo; a working half-system with evidence beats a broken whole one.
- **You start teaching again.** Do not. There is no new content on these days, and every minute you talk is a minute a team is not building.
