# Project catalogue and self-check

[Module 7 — Final Project](./07-final-project-studio.md) | [Module index](./00-index.md) | [Syllabus](../syllabus.md)

This page is optional reading for the project kickoff. It gives you **project shapes**, **seven
families** to start from, **where the data can live**, and a **self-check** you can run before you
commit. You do not have to pick a family — bring your own and check it against §4.

## 1. What "big enough" means

| Level | Shape | When it is right |
|---|---|---|
| L1 | one actor, one workflow, 4–6 tables | a slice, or a first week |
| **L2** | **3–4 actors, 2–3 workflows, 7–10 tables, one thing that changes state** | the target for a Project Team (6–8 people in this run) |
| L3 | L2 plus a second site, or an analytical copy | a team that already has the slice running |

Bigger means **more actors and states**, not more screens. A warehouse is big because goods move
through six states and a bin must never go negative — not because it has fifty pages.

## 2. Families

Each family gives you actors, workflows, a first query, and a starting point. Change the names and
the details; the shape is what matters.

### 2.1 Student FabLab and entrepreneurship community

- **Actors:** student maker, lab manager, mentor, treasurer.
- **Business areas:** membership and access; machine operations; projects and mentoring; billing.
- **Workflows:** training → certification → reservation → usage → charge; project → mentor → showcase.
- **First query:** which certified member has not used the laser in 60 days?
- **Decision:** which machine to buy, maintain, or retire; who keeps access; what to bill.
- **Data:** the lab's booking export, or a reproducible generated usage log.
- **Where it runs:** one file on the front-desk laptop; a tablet or Node-RED reads it. A second site
  or a treasurer downtown is the natural reason for a remote copy.
- **Stretch:** a billing run from usage; a DuckDB utilisation report.
- **Watch out:** a reservation table with no double-booking rule.

### 2.2 Warehouse and logistics

- **Actors:** supplier, goods-in clerk, picker, planner, customer.
- **Business areas:** inbound; inventory; outbound; cycle counting.
- **Workflows:** receiving → putaway → storage → picking → packing → shipping; cycle count →
  discrepancy → adjustment.
- **First query:** which SKU is below its reorder point and has open orders?
- **Decision:** what to reorder today; whether the ledger can be trusted.
- **Data:** generated order and receipt logs, or an anonymised export from a real business.
- **Where it runs:** one file at the goods-in desk; handheld scanners write over the LAN. A remote
  dashboard for a business student is a declared second copy.
- **Stretch:** a fill-rate report in DuckDB; a trigger that refuses negative stock.
- **Watch out:** storing stock as a number in an item row instead of a ledger of moves.

### 2.3 Public infrastructure and emergency services

- **Actors:** technician, station, work order, office; equipment officer.
- **Business areas:** measurement; maintenance; inspections; reporting.
- **Workflows:** reading → gap or threshold breach → work order → repair → close; inspection → due
  date → overdue → done.
- **First query:** which station has the longest gap and an open work order?
- **Decision:** which technician to send first; what to replace; what to report.
- **Data:** a DWD or Open-Meteo snapshot plus generated logger CSVs, or the brigade's inventory list.
- **Where it runs:** the technician's laptop, synced by copying the file; a council report can be
  exported to DuckDB.
- **Stretch:** a monthly report in DuckDB; a trigger for a threshold breach; a QR check-in.
- **Watch out:** one table for "measurement" and "alert" — they have different lifecycles.

### 2.4 Campus food co-op and cafeteria

- **Actors:** kitchen, supplier, student, allergen officer.
- **Business areas:** menu; procurement; service; waste.
- **Workflows:** menu plan → order → delivery → service → waste log; allergen check.
- **First query:** which dish wastes most and contains a given allergen?
- **Decision:** what to cook less; what to reorder; what to label.
- **Data:** POS counts, menu exports, the waste sheet.
- **Where it runs:** the kitchen tablet. The supplier gets a report, not access.
- **Stretch:** cost per portion; a trigger that blocks a dish without an allergen record.
- **Watch out:** free-text allergens.

### 2.5 Research lab and measurement series

- **Actors:** student, instrument, batch, supervisor.
- **Business areas:** samples; measurement; release.
- **Workflows:** sample → batch → measurement → deviation → hold or release.
- **First query:** which batch deviates most from its target?
- **Decision:** release or re-measure; which instrument needs calibration.
- **Data:** instrument CSV exports, or a generated series with a known anomaly.
- **Where it runs:** the data stays on the lab machine; the supervisor gets a snapshot.
- **Stretch:** provenance columns; a series comparison in DuckDB.
- **Watch out:** no units. A measurement table without a unit holds numbers, not measurements.

### 2.6 Festival, club, and event operations

- **Actors:** organiser, volunteer, act, venue, equipment.
- **Business areas:** programme; staffing; equipment; safety.
- **Workflows:** schedule → assign → check-in; equipment loan → return → damage.
- **First query:** which volunteer is double-booked?
- **Decision:** who to call; what to rent; which stage to move.
- **Data:** the sign-up sheet as CSV, the schedule as generated data.
- **Where it runs:** the organiser's laptop, offline at the venue; the crew gets a read-only report.
- **Stretch:** a trigger that refuses overlapping shifts; a printable run sheet from a view.
- **Watch out:** dates without times, and times without timezones.

### 2.7 Greenhouse and hydroponics

- **Actors:** grower, maintenance technician, buyer, compliance.
- **Business areas:** crop batches; climate and dosing; harvest and sales; compliance.
- **Workflows:** batch seeded → growing → harvested → shipped; alert open → acknowledged →
  resolved; dosing planned → applied → verified.
- **First query:** which bed has the largest EC drift from its setpoint in the last 24 hours?
- **Decision:** which bed to dose or flush before the next cut; whether to delay a harvest.
- **Data:** 5-minute logger CSVs (EC, pH, temperature, humidity), or a generator with drift,
  failures, and seasonality — 20 beds × 4 sensors × 288 per day is about 8 million rows a year.
- **Where it runs:** the greenhouse Wi-Fi is unreliable; one Raspberry Pi on site holds the file.
  The buyer gets a daily report; a cloud copy is optional and declared.
- **Stretch:** a seasonal comparison in DuckDB; a trigger blocking a harvest while an alert is open.
- **Watch out:** storing only the latest reading per sensor. Then the drift query is impossible.

## 3. Where your data lives

**Default: one SQLite file next to your code.** It is fast, it is yours, it works offline, and it is
what this course teaches you to defend.

Three shapes are fine:

1. **One local file.** Everything reads and writes the same `.db` or `.duckdb`.
2. **Local plus an exchange.** The operational SQLite is the source of truth; a script exports a
   report or snapshot (CSV/Parquet) into a second database — DuckDB, another SQLite, or PostgreSQL.
   One direction, on a schedule. This is a report, not "sync".
3. **Hybrid with a declared remote.** One database is local, one is remote — PostgreSQL, or a
   shared file. Say in the charter why the split exists (two users? a report for someone else? a
   demo from two machines?) and what may be stale.

Two rules:

- **Do not turn SQLite into a server.** A network share or an HTTP wrapper around the file is
  fragile and teaches the wrong thing. If you need a network interface, put **Node-RED** with
  `node-red-node-sqlite` in front of the local file: a cheap UI and API with one writer.
- **Declare the remote component.** A PostgreSQL server is available for the class
  (`hsbi-dbs.ulno.net`; credentials from the TA). Using it is allowed and can be the right call —
  say in the charter what it is for and why the local file is not enough.

## 4. Does your project pass?

Three questions first:

1. **Who is the person, and what do they do differently on Monday because of your answer?**
2. **Say the first query out loud — what does it return today?**
3. **Why does it matter — to them, and to at least one of you?**

If any answer is vague, you have a topic. Then check the ten qualities:

| # | Quality | Ask yourself | Green | Red |
|---|---|---|---|---|
| 1 | **Named and felt** | Who is the person, and why does it matter to them — or to one of you? | a role, a moment, and a stake | "users", "a company", "it is only an exercise" |
| 2 | **Consequential** | What action changes because of the answer? | stop, order, dose, send, replace | "they get insights" |
| 3 | **Computable** | Say the first query; what number comes back today? | a query and the shape of its answer | "a dashboard" |
| 4 | **Grounded** | Where is one real row right now? | a file, an export, a snapshot, or a generator written today | "we will find data" |
| 5 | **Scaled** | How many rows after ingestion? | 10^5 or more, or 10^4 with joins | a few hundred |
| 6 | **Shared** | Who else needs this data, and what do they need that the first person does not? | a second actor with a different view | one user only |
| 7 | **Stateful** | Name one thing that moves through three states; what moves it? | reservation, batch, work order, stock move | append-only readings |
| 8 | **Risky** | What does it cost when the answer is wrong or a row is duplicated? | money, crop, safety, trust | "nothing, it is a demo" |
| 9 | **Local or justified** | Why does this live on a laptop or tablet — or why is part of it remote? | offline, privacy, one user, or a stated reason for a hybrid | "because it is modern" |
| 10 | **Sliceable** | What can one member demo end-to-end in week one? | one workflow, one query, one interface | "the whole farm" |

If you cannot answer **1–4**, pick a family. If **5–10** fail, start at L1 and fix them as you go:
the missing qualities become your first work packages.

## 5. The charter

Write `docs/charter.md` in Session 8. One page:

```md
docs/charter.md
1. Organisation and case study — three sentences
2. Actors (3–4) — who they are and what each needs
3. Business areas (2–3) — the departments that share the data
4. Workflows (2–3) — each with the states it moves through
5. Use cases → named queries (5–8) — each with the decision it supports
6. The slice — the one workflow you build end-to-end, and where each database lives (local,
   hybrid, or remote — with the reason)
7. Cut list — what you will not build this term
8. Roles — Product Owner, process keeper, pod leads, and the owner of each work package
```

**Two pods of 3–4?** Keep the Task Pods as working units inside the team. Each pod owns one or
two deliveries — the slice, the proof, or the surface — and names a pod lead. The pod is the unit
for the stand-up; the leads sync for two minutes afterwards.

**The story test:** no actor, no query, no project. If it grows past one page, you are writing a
requirements document instead of choosing a story.

---

[← Module 7](./07-final-project-studio.md) | [Module index](./00-index.md) | [Syllabus](../syllabus.md)
