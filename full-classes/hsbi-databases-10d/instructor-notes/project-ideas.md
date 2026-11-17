# Project idea bank — directions, not assignments

[All instructor notes](./README.md) · [Project notes](./07.md) · [Project module](../modules/07-final-project-studio.md)

**How to use this.** This is a seed bank for the project kickoff, not a menu students must choose
from. Show three directions, then ask every pod to bring its own story. The best project is one a
student can explain to a real person without reading a slide.

**The one rule:** *a project is a person with a problem and data that answers it.* If a team cannot
name the person and the first query, it has a topic, not a project.

## Kickoff talk track (about five minutes)

1. **Start with the person.** “Do not start with a technology or a topic. Name one person who has
   the problem. If you cannot name them, you are not ready.”
2. **Name the first query.** “What is the one question this database must answer? Not a dashboard,
   not a list of features — one query.”
3. **Show the data.** “Where does it come from? A sensor log, a machine export, a CSV, a public
   dataset, a notebook? If it does not exist, can you generate it reproducibly and say so?”
4. **Pick the local-first default.** “One SQLite file next to the data. Add DuckDB, JSON, or a
   key-value store only when you can name the workload reason and measure it.”
5. **Name the stretch.** “What will you prove beyond CRUD? An index with a plan, a trigger that
   rejects a bad row, a Parquet export, a JSON metadata column, a recovery path.”
6. **Bring three, choose one.** “Bring three candidate stories to the kickoff. The team picks one;
   the others become backup.”

## The story test

A story is ready when all four answers are concrete:

| Question | Good answer | Bad answer |
|---|---|---|
| Who is the person? | “Marta, the night-shift supervisor at a bottling plant” | “A company” |
| What decision does the data change? | “Which line to stop first when pressure drops” | “They want insights” |
| What is the first query? | “Which machine had the most unplanned stops last week?” | “A dashboard” |
| Where does the data come from? | “A CSV export from the line controller” | “We will find data later” |

## Directions

Each direction gives a **person**, a **problem**, a **first query**, a **data source**, a
**local-first twist**, and a **stretch**. Change the names and details; the point is the shape.

### 1. Bakery — daily production and waste

- **Person:** the owner of a small bakery with two shops.
- **Problem:** production is guessed; some products are sold out by 10:00, others are thrown away.
- **First query:** which product had the highest waste cost per day last month?
- **Data:** daily POS export (CSV), production notes.
- **Local-first twist:** a tablet in the shop writes to one SQLite file; no cloud account.
- **Stretch:** a view that compares production to sales for the last seven days.

### 2. Bike workshop — repairs, parts, and promises

- **Person:** the mechanic who runs a two-person bike workshop.
- **Problem:** promised repair dates slip because parts are missing and nobody sees the queue.
- **First query:** which repair job is waiting longest for a part?
- **Data:** job sheets, parts invoices, a hand-written queue.
- **Local-first twist:** the workshop laptop is the server; the database is a file on it.
- **Stretch:** a trigger that flags a job when its promised date passes.

### 3. Water and rain gauges — a municipal measuring network

- **Person:** the technician who maintains five rain gauges for a small municipality.
- **Problem:** readings arrive as CSV files; a blocked gauge is noticed weeks later.
- **First query:** which station had the longest gap between readings this month?
- **Data:** logger exports, station list.
- **Local-first twist:** the file lives on the technician’s laptop; no central server.
- **Stretch:** a generated column for rainfall per hour, or a gap detector.

### 4. PV roof — yield and consumption

- **Person:** the caretaker of a school with a photovoltaic roof.
- **Problem:** the inverter app shows energy, but nobody can answer “did we use what we produced?”
- **First query:** on which days did production exceed consumption by more than 20%?
- **Data:** inverter CSV, meter readings.
- **Local-first twist:** one SQLite file in the caretaker’s office; monthly export for the board.
- **Stretch:** a DuckDB/Parquet report over a year of 15-minute readings.

### 5. 3D-printing farm — jobs, filament, failures

- **Person:** the student who runs a small 3D-printing farm for a makerspace.
- **Problem:** failed prints are not tracked, so material cost and failure rates are guesses.
- **First query:** which filament colour has the highest failure rate?
- **Data:** printer logs, job notes, spool labels.
- **Local-first twist:** a Raspberry Pi next to the printers writes to SQLite; no cloud.
- **Stretch:** cost per successful part, or a trigger that records a failed job.

### 6. Lab freezer — samples and temperature

- **Person:** the lab technician responsible for a −80 °C freezer.
- **Problem:** samples are stored in boxes; a temperature excursion is noticed too late.
- **First query:** which samples were in the freezer during the last excursion?
- **Data:** temperature logger CSV, sample inventory.
- **Local-first twist:** the logger and database live in the lab; no sample data leaves the room.
- **Stretch:** an alert when a reading is above the threshold for ten minutes.

### 7. Sports club — attendance, injuries, equipment

- **Person:** the coach of an amateur handball team.
- **Problem:** attendance and injury notes are scattered; nobody sees who is overloaded.
- **First query:** which player missed the most sessions in the last eight weeks?
- **Data:** attendance sheets, training notes.
- **Local-first twist:** the coach’s laptop holds the file; players do not need accounts.
- **Stretch:** a view joining attendance and injury notes, with a clear privacy statement.

### 8. Campus cafeteria — menus, allergens, waste

- **Person:** the cafeteria manager.
- **Problem:** allergen information is in PDFs; waste is estimated per day.
- **First query:** which meal has the highest waste and contains a given allergen?
- **Data:** menu export, POS counts, waste log.
- **Local-first twist:** one file in the kitchen; the interface is a tablet.
- **Stretch:** a parameterized allergen search that cannot be injected.

### 9. Beekeeping — hives and yields

- **Person:** a beekeeper with twelve hives.
- **Problem:** inspections are in a paper notebook; yield and behaviour are hard to compare.
- **First query:** which hive had the lowest honey yield and the most varroa counts?
- **Data:** inspection notes, scale readings.
- **Local-first twist:** a phone-sized SQLite file; works offline in the field.
- **Stretch:** a view joining hive, inspection, and weather data.

### 10. Machine shop — maintenance and parts

- **Person:** the maintenance planner at a small CNC shop (the course’s Wittkamp story).
- **Problem:** the maintenance log is a spreadsheet; nobody sees which machine is due.
- **First query:** which machine has the highest parts cost in the last year?
- **Data:** maintenance log, parts invoices.
- **Local-first twist:** the planner’s laptop is the database; no server in the shop.
- **Stretch:** a trigger that creates an overdue-maintenance row.

### 11. Fire brigade / THW equipment — inspections

- **Person:** the equipment officer of a volunteer fire brigade.
- **Problem:** inspection dates and equipment locations are on paper; a missing item is found at the wrong moment.
- **First query:** which piece of equipment is overdue for inspection?
- **Data:** inventory list, inspection sheets.
- **Local-first twist:** one file on the station laptop; no personal data.
- **Stretch:** a QR-code check-in that writes a row, or a trigger that blocks a bad inspection date.

### 12. Research data — batches and measurements

- **Person:** a master’s student running a measurement series.
- **Problem:** instrument files are named by hand; a batch can be out of spec without anyone noticing.
- **First query:** which batch has the highest deviation from the target value?
- **Data:** instrument CSV, batch notes.
- **Local-first twist:** the data stays on the student’s machine; the database is a file in the project.
- **Stretch:** provenance columns and a reproducible ingest script.

### 13. Local weather station — real data

- **Person:** an allotment association or a school with a weather station.
- **Problem:** the station logs data, but nobody queries it; frost and rain decisions are guesses.
- **First query:** which nights last month dropped below 3 °C?
- **Data:** a DWD, Open-Meteo, or Meteostat snapshot; record the station ID, retrieval date, and licence.
- **Local-first twist:** the CSV snapshot lives in SQLite on the school laptop; no API dependency at the demo.
- **Stretch:** a Node-RED dashboard over the SQLite file, or a comparison with your own sensor.

## If your project uses weather data

- Start from the [weather datasets in the resource bank](../modules/Z-resources-bank.md#weather-and-environmental-data). Search for a station near your story; the list is a starting point, not the only source.
- Download a **snapshot** (CSV/JSON), keep the station ID, retrieval date, and licence, and load it with a repeatable script. The demo uses the snapshot, not a live API.
- Good first queries: the longest gap between readings, nights below a threshold, a monthly comparison, or a station vs. your own sensor.
- Visualization: Datasette first; **Node-RED** with `node-red-node-sqlite` for a local dashboard; **Grafana** only if the team already runs PostgreSQL/MySQL or accepts a community plugin — it has no core SQLite data source.

## Anti-patterns and how to rescue them

| The pitch | Why it stalls | Rescue |
|---|---|---|
| “A Mars colony database” | Fun, but no real person, no real data, no decision. | Name the colonist, the decision, and the data. If you cannot, pick a local story. |
| “A library system” | The topic is generic; every team builds the same CRUD. | Name the librarian, the overdue problem, and the first query. |
| “A social network” | Scope explodes; no local-first reason. | Cut it to one person’s problem, one query, one file. |
| “A dashboard for everything” | No first query; the interface becomes the project. | One query, one number, one decision; the dashboard comes later. |
| “We will find data later” | The project stalls in week two. | Generate reproducible fake data now, or pick a dataset you can obtain. |

## Mapping to the must-haves

Every direction can hit the Module 7 criteria; make the mapping explicit in `docs/requirements.md`:

| Must-have | In a direction |
|---|---|
| Schema + enforced relationship | machine → job, hive → inspection, batch → measurement |
| Reproducible ingestion | CSV/export → `ingest.py`, run twice without duplicates |
| Index proof | filter by date/machine; `EXPLAIN QUERY PLAN` before/after |
| Parameterization | every user-facing search or filter uses bound parameters |
| Constraint + trigger/generated column | reject a bad temperature, flag an overdue job, derive a cost |
| Interface | Datasette, CLI, or a small tablet app |
| Recovery | missing row or corrupt input handled without a crash |

## Homework prompt

> Bring **three candidate stories** to the project kickoff. For each, write one paragraph:
> the person, the problem, the first query, and the data source. Do not build anything yet.
> The team will choose one and write the charter in Session 8.

**Instructor note:** do not assign a direction. Ask the team to choose and defend one. The bank is
there for teams that arrive without a story, not to narrow the room.
