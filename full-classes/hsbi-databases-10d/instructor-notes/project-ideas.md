# Project idea bank — instructor companion

[Student catalogue](../modules/07-project-catalogue.md) · [Project notes](./07.md) · [Module 7](../modules/07-final-project-studio.md)

**One fact, one home.** Students read the [catalogue](../modules/07-project-catalogue.md): the
families, where the data lives, the ten-quality self-check, and the charter. This file keeps what is
not for them — the verdict rules, the traps, the kickoff sheet, and the rescues. Do not duplicate
the catalogue here; link to it.

## 1. The gate — fifteen seconds per pitch

1. *Who is the person, and what do they do differently on Monday because of your answer?*
2. *Say the first query out loud — what does it return today?*

If either is vague, the team has a topic. Send them to the catalogue; do not let them browse.

## 2. Verdicts

The ten qualities and the green/red answers are in the
[catalogue §4](../modules/07-project-catalogue.md#4-does-your-project-pass). The instructor adds the
verdict:

- **Green, 8–10:** run it at L2.
- **Amber, 5–7:** build the L1 slice first; every missing quality becomes a work package for
  Session 9. If 6 (second actor) or 7 (state) is still missing then, the project stays L1 and the
  charter says so.
- **Red, 4 or less, or any of 1–4 missing:** pick a family. Those four are the non-negotiables.

Record one line per team on the kickoff sheet: *team, person, decision, query, rows, second actor,
state, verdict*. The TA can run the screen for a team that arrives late or undecided.

## 3. What each family is teaching — the traps

| Family | The trap | Ask |
|---|---|---|
| FabLab | a reservation with no double-booking rule | “Show me two active reservations for one machine.” |
| Warehouse | stock as a number, not a ledger of moves | “Show me the move that produced this balance.” |
| Public infrastructure | measurement and alert in one table | “What is the lifecycle of an alert?” |
| Food co-op | free-text allergens | “Show the join that proves this dish is safe.” |
| Research lab | no units | “What unit is this number?” |
| Festival/club | dates without times, times without timezones | “Two shifts, same volunteer, 30-minute overlap.” |
| Greenhouse | only the latest reading, no series | “Show me this sensor's series for yesterday.” |

## 4. Two worked examples

**Hydroponic lettuce farm — green, 10/10** (catalogue §2.7).

- Grower on a 400 m² rooftop farm, every morning before the first cut.
- Query: which bed has the largest EC drift from its setpoint in the last 24 hours?
- 20 beds × 4 sensors × 288 per day ≈ 8 million rows a year; technician and buyer as second actors;
  batch and alert as state machines; a wrong dose loses a batch.
- The Wi-Fi is unreliable, so a Pi on site holds the file.

**Mars colony — amber, 6/10, unless it changes.**

- No real person, fictional cost, no local-first reason — unless it is a documented simulation with
  a named operator and a model that produces drift, failures, and seasonality.
- Generated data is allowed, but uniform random rows make every measurement circular.
- Verdict: redirect to a local greenhouse (same decisions, real rows) or run it at L1 and accept
  that the story and local-first points will be thin.
- The line for the room: *the Mars colony is a good test of your imagination and a weak test of
  your database, because nothing can contradict you.*

## 5. Anti-patterns and how to rescue them

| The pitch | Why it stalls | Rescue |
|---|---|---|
| “A Mars colony database” | Fun, but no real person, no real data, no decision. | Run the self-check; redirect to a local greenhouse or another family. |
| “A library system” | The topic is generic; every team builds the same CRUD. | Name the librarian, the overdue problem, and the first query. |
| “A social network” | Scope explodes; no local-first reason. | Cut it to one person's problem, one query, one file. |
| “A dashboard for everything” | No first query; the interface becomes the project. | One query, one number, one decision; the dashboard comes later. |
| “We will find data later” | The project stalls in week two. | Generate reproducible fake data now, or pick a dataset you can obtain. |
| “We will write the backlog later” | There is no plan to revise, so the plan point has no evidence. | Board in Session 8, before the first line of code. |
| “The AI wrote it” | Nothing to defend at the table. | `docs/ai-log.md` with a rejected suggestion and the repair. |
| “The committee decided” | Everyone owns it, nobody answers for it. | One Product Owner, one name per work package. |
| “We will integrate at the end” | Five half-features, no demo. | One vertical slice in Session 8; everything else is a work package after it. |

## 6. Seeds that grow

Every one-actor idea from the first edition is a good **slice** inside a family. Grow it by adding
the second actor and the state it moves through.

| Old direction | Family | Grow it by |
|---|---|---|
| Bakery | Warehouse | add the supplier and the delivery: one product becomes an order line |
| Bike workshop | FabLab | add the member and the promised date: a job becomes a reservation |
| Water and rain gauges | Public infrastructure | add the technician and the work order |
| PV roof | Public infrastructure | add the maintenance visit and the monthly report |
| 3D-printing farm | FabLab | add the member, the certification and the charge |
| Lab freezer | Research lab | add the batch and the release decision |
| Sports club | Festival/club | add the venue and the equipment loan |
| Cafeteria | Food co-op | add the supplier and the allergen officer |
| Beekeeping | Food co-op | add the harvest sale and the weather snapshot |
| Machine shop | FabLab / Warehouse | add the parts ledger and the overdue job |
| Fire brigade | Public infrastructure | add the deployment and the equipment loan |
| Research data | Research lab | add the instrument calibration and the hold |
| Weather station | Public infrastructure | add the station list and the gap alert |

## 7. Homework prompt

> Read the [project catalogue](../modules/07-project-catalogue.md) and bring **two candidate
> families** to the kickoff. For each, write one paragraph: the organisation, three actors, one
> workflow with its states, the first query, where the data comes from, and roughly how many rows
> you expect after ingestion. Do not form teams and do not build anything yet.

## 8. Process guards

The roles, the board, and the cadence are student-facing in
[Module 7](../modules/07-final-project-studio.md) and the [run sheet](./07.md). The instructor adds
only the limits:

- the board holds at most 20 items, each at most half a day;
- the stand-up stops at five minutes;
- the Product Owner prioritises but does not assign;
- a work package in *doing* with no commit for 48 hours goes to the TA the same day;
- nothing about the process is graded.

A team that arrives in Session 8 without roles gets five minutes to elect them, then you move on.
