# Module 4 — Data Integrity, Constraints & Edge Triggers

[← Back to front page](../README.md) | [Quick module index](./00-index.md) | [Next: Module 5 →](./05-normalization-vs-denormalization.md)

> **One question for the whole course:** *How does raw data become a trustworthy, fast, and safe answer — on a machine you actually own?*

**Course placement:** Session 4. This module covers the legacy *Standard SQL (DDL/DML/DCL)*, *data integrity*, and *triggers and procedures* chapters — reframed as integrity that runs **at the edge**, next to the data, without a server.

## 🎯 Learning Goals

> **How these are assessed:** You show that you have reached these goals in a short (~10-minute) checkpoint presentation in Session 6 — based on your portfolio and reflections, not on completing every task. See the [syllabus](../syllabus.md#how-module-points-are-earned-checkpoint-presentations) for the assessment rules. **These learning goals are the contract between you and the instructor: demonstrate them, and you have met the module.** The tasks in this module are a draft — you are encouraged to modify, replace, or extend them as long as your alternative reaches the same goals. You may skip tasks, fail at some, or add your own; documented exploration and demonstrated deep understanding both count in your favor.

This module gives you the opportunity to explore data-definition, manipulation, and integrity and achieve competency in enforcing rules where the data lives.

By the end of this module, you can:
1. Create tables with the full constraint toolkit: `NOT NULL`, `UNIQUE`, `CHECK`, `PRIMARY KEY`, `FOREIGN KEY`, and `STRICT` typing.
2. Use **generated columns** to derive values at the engine instead of in application code.
3. Write **triggers** that enforce domain rules and maintain audit/rollup tables automatically.
4. Use **DML** correctly — including `UPSERT` (`ON CONFLICT`) for idempotent edge ingestion.
5. Reason about **access control (DCL)**: who may read or write, and how that maps from server `GRANT`s to an embedded, local-first world.

> [!NOTE]
> Task tiers. Tasks marked ★ Core must be completed by everyone. Tasks marked ◇ Stretcher are optional and are the natural trim point if time runs short — they are excellent bonus-task material.

> [!WARNING]
> DRAFT — first taught in WS 2026/27 by an instructor who is **also teaching databases for the first time** and is learning this material alongside you. Everything below this line is a working draft and will likely change as we refine it together in class; the line moves down as we approve content. Different deep dives and stretchers are welcome — your input can shape this module.

**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 📖 Story — Trusting the Edge

Your machine-shop telemetry used to run through the cloud, until the plant lost its internet connection for two days and lost two days of data with it. The fix is local-first: an **edge gateway** (a small Linux box or an OpenWrt router) writes readings straight into a SQLite file next to the machines. The data never leaves the plant unless someone decides it should.

But "at the edge, without a server" raises the stakes on integrity: there is no DBA to fix a bad row, and no backend to re-validate. The **database itself** must refuse garbage. A temperature of 9,000 °C from a disconnected sensor must be rejected by a `CHECK`. A spindle that overheats must raise an alarm **the moment the row is written**, by a trigger. Replayed readings after a network hiccup must not create duplicates, which is what `UPSERT` is for. In this studio, you make SQLite enforce the rules so the application cannot forget them.

## 📖 Part A — Mini-Lecture: Integrity Has Layers (15 min)

The module handbook lists integrity as a first-class topic. In relational terms there are three layers, and each maps to a concrete SQL feature:

| Layer | Question it answers | SQL mechanism |
|---|---|---|
| **Entity integrity** | Is every row identifiable and complete? | `PRIMARY KEY`, `NOT NULL`, `UNIQUE` |
| **Referential integrity** | Do relationships point at things that exist? | `FOREIGN KEY` (+ `ON DELETE`/`ON UPDATE`) |
| **Semantic (domain) integrity** | Does the value make sense? | `CHECK`, generated columns, triggers |

**`STRICT` tables (SQLite 3.37+).** SQLite is famously dynamically typed. A `STRICT` table forces every column to hold its declared type, so `'abc'` can never land in a `REAL` column. For edge data you do not control, this is the cheapest bug filter you have.

**Generated columns.** A `VIRTUAL` or `STORED` column computed from other columns by an expression. Use one to derive `energy_kwh = power_w * interval_s / 3.6e6` at the engine, so every reader agrees and no application can compute it wrong.

**Triggers.** `AFTER INSERT`/`UPDATE`/`DELETE` procedures that fire automatically. They are how you keep a derived fact consistent (an alarm, a rollup, an audit trail) without trusting the writer.

**DCL and the embedded twist.** On a server, access control is `CREATE ROLE` + `GRANT SELECT ON ... TO ...`. SQLite has no users or roles — so access control shifts to the **file system** (Unix permissions), **views** that expose a safe subset, and read-only connections (`file:...?mode=ro` or `PRAGMA query_only`). Be ready to explain that trade-off: embedded means fewer knobs, but also a smaller attack surface.

> [!TIP]
> Trigger bodies must be *declared* in the DDL but *run* on every write. Test their cost: a trigger on a hot ingest path is a design decision, not a free lunch.

## 🛠️ Studio Lab: Make the Database Refuse to Lie (60 min)

*Software:* `sqlite3` CLI and Python 3.11+.

### Setup (5 min)

```sh
mkdir -p module-04
sqlite3 module-04/edge.db <<'SQL'
PRAGMA foreign_keys = ON;        -- per-connection, and OFF by default: remember this.
DROP TABLE IF EXISTS reading, sensor, alarm, audit;

CREATE TABLE sensor(
    sensor_id   INTEGER PRIMARY KEY,
    machine_id  TEXT    NOT NULL,
    metric      TEXT    NOT NULL CHECK (metric IN ('temp_c','vib_rms','spindle_load')),
    unit        TEXT    NOT NULL,
    UNIQUE (machine_id, metric)
) STRICT;

CREATE TABLE reading(
    reading_id  INTEGER PRIMARY KEY,
    sensor_id   INTEGER NOT NULL REFERENCES sensor(sensor_id),
    ts          TEXT    NOT NULL,
    value       REAL    NOT NULL,
    interval_s  INTEGER NOT NULL CHECK (interval_s > 0),
    energy_j    REAL    GENERATED ALWAYS AS (value * interval_s) VIRTUAL,
    CHECK (value >= -273.15 AND value <= 5000)        -- reject physically impossible values
) STRICT;
SQL
```

### ★ Task 1: Prove the constraints work (15 min)

Constraints are only real if you have *seen them reject* something. Run each of these and record the exact error.

```sql
-- valid
INSERT INTO sensor VALUES (1,'cnc-01','temp_c','degC'), (2,'cnc-01','vib_rms','mm/s');
INSERT INTO reading(sensor_id, ts, value, interval_s) VALUES (1,'2026-03-01 08:00:00', 41.5, 1);

-- rejected: domain check (impossible temperature)
INSERT INTO reading(sensor_id, ts, value, interval_s) VALUES (1,'2026-03-01 08:00:01', 9000, 1);
-- rejected: STRICT type (text into a REAL)
INSERT INTO reading(sensor_id, ts, value, interval_s) VALUES (1,'2026-03-01 08:00:02', 'hot', 1);
-- rejected: referential integrity (sensor 99 does not exist)
INSERT INTO reading(sensor_id, ts, value, interval_s) VALUES (99,'2026-03-01 08:00:03', 40, 1);
-- rejected: entity integrity (duplicate sensor for the same machine+metric)
INSERT INTO sensor VALUES (3,'cnc-01','temp_c','degC');
```

*Portfolio evidence:* each rejected statement and its error message, plus the generated `energy_j` value for the valid row — proof the virtual column computes.

### ★ Task 2: Idempotent edge ingestion with UPSERT (15 min)

After a network outage, the gateway replays readings. Replayed rows must not duplicate.

```sql
-- Make (sensor_id, ts) a genuine natural key so replays collide:
CREATE UNIQUE INDEX ux_reading_sensor_ts ON reading(sensor_id, ts);

-- Replay-safe ingest: insert, or update if the exact reading already exists.
INSERT INTO reading(sensor_id, ts, value, interval_s)
VALUES (1,'2026-03-01 08:00:00', 41.7, 1)          -- same key, corrected value (sensor retried)
ON CONFLICT(sensor_id, ts) DO UPDATE SET value = excluded.value;

-- Show that there is still exactly one row for that key:
SELECT sensor_id, ts, value FROM reading WHERE sensor_id = 1;
```

Then write the ingestion loop in Python (`module-04/ingest.py`) that takes a CSV of readings and uses `executemany` with the same `UPSERT`, and run it **twice** on the same file.

*Portfolio evidence:* the `UPSERT` SQL, the Python ingest script, and the row count proving a double run did not duplicate data.

### ★ Task 3: Triggers for alarms and audit (20 min)

Two triggers: one raises an alarm when a threshold is crossed, one writes an immutable audit trail of every value change.

```sql
CREATE TABLE alarm(
    alarm_id  INTEGER PRIMARY KEY,
    sensor_id INTEGER NOT NULL REFERENCES sensor(sensor_id),
    ts        TEXT NOT NULL,
    value     REAL NOT NULL,
    reason    TEXT NOT NULL
) STRICT;

CREATE TABLE audit(
    audit_id  INTEGER PRIMARY KEY,
    reading_id INTEGER NOT NULL,
    old_value REAL,
    new_value REAL,
    changed_at TEXT NOT NULL DEFAULT (datetime('now'))
) STRICT;

-- 1. Semantic rule enforced at write time: vibration above 2.0 mm/s raises an alarm.
CREATE TRIGGER trg_vib_alarm
AFTER INSERT ON reading
FOR EACH ROW
WHEN NEW.value > 2.0 AND (SELECT metric FROM sensor WHERE sensor_id = NEW.sensor_id) = 'vib_rms'
BEGIN
    INSERT INTO alarm(sensor_id, ts, value, reason)
    VALUES (NEW.sensor_id, NEW.ts, NEW.value, 'vibration over 2.0 mm/s');
END;

-- 2. Audit every update, automatically.
CREATE TRIGGER trg_reading_audit
AFTER UPDATE OF value ON reading
FOR EACH ROW
BEGIN
    INSERT INTO audit(reading_id, old_value, new_value)
    VALUES (NEW.reading_id, OLD.value, NEW.value);
END;
```

Now exercise them:

```sql
INSERT INTO reading(sensor_id, ts, value, interval_s) VALUES (2,'2026-03-01 09:00:00', 2.7, 1);  -- alarm!
UPDATE reading SET value = 1.4 WHERE sensor_id = 2;                                              -- audit!
SELECT * FROM alarm;
SELECT * FROM audit;
```

*Portfolio evidence:* the trigger DDL, the alarm row and audit row they produced, and a measured note on trigger cost (time an ingest of 10,000 rows with and without the alarm trigger).

### ★ Task 4: Access control without a server (10 min)

There is no `GRANT` in SQLite, so demonstrate the embedded substitute. **Create the view first** (while the file is still writable), then lock the file down.

```sh
# 1. Expose a safe subset with a view, and hand *that* to report readers:
sqlite3 module-04/edge.db "CREATE VIEW machine_health AS
  SELECT s.machine_id, s.metric, MAX(r.value) AS peak, COUNT(*) AS n
  FROM sensor s JOIN reading r USING(sensor_id) GROUP BY s.machine_id, s.metric;"

# 2. Read-only at the file level (the strongest, simplest control):
chmod 444 module-04/edge.db

# 3. Read-only at the connection level:
sqlite3 "file:module-04/edge.db?mode=ro" "SELECT COUNT(*) FROM reading;"
sqlite3 "file:module-04/edge.db?mode=ro" "DELETE FROM reading;"   # must fail

# 4. Restore write access for your own further work:
chmod 644 module-04/edge.db
```

Write 3–4 sentences: **how would this differ with a PostgreSQL server, and why is file-permission-based control acceptable here but not for a multi-tenant web app?**

*Portfolio evidence:* the `chmod`/`mode=ro` commands and their outcomes, the `machine_health` view, and your comparison note.

### ◇ Task 5 (Stretcher): Break your own alarm

Switch the alarm trigger to `BEFORE INSERT` and observe the difference; or add an `INSTEAD OF` trigger on a view. Document what changes and why `AFTER` was the right default here.

## ✅ What must be committed to your portfolio

Commit under `module-04/`:

- [ ] The setup script (`STRICT` tables, generated column, constraints).
- [ ] The rejected-statement evidence for each constraint with its exact error message.
- [ ] The `UPSERT` SQL, `ingest.py`, and the double-run row-count proof.
- [ ] The alarm and audit trigger DDL plus the rows they produced, and the trigger-cost measurement.
- [ ] The access-control demonstration (`mode=ro`, `chmod`, a view) and your comparison note.
- [ ] `reflection.md` — the logbook entry for this block.
- [ ] (Stretcher) the trigger-timing variant and what it changed.

## 📚 If you want to go deeper

- SQLite — `STRICT` tables — [sqlite.org/stricttables.html](https://www.sqlite.org/stricttables.html)
- SQLite — generated columns — [sqlite.org/gencol.html](https://sqlite.org/gencol.html)
- SQLite — `UPSERT` and triggers — [sqlite.org/lang_upsert.html](https://www.sqlite.org/lang_upsert.html) · [sqlite.org/lang_createtrigger.html](https://www.sqlite.org/lang_createtrigger.html)
- SQLite — foreign key support (and why it is off by default) — [sqlite.org/foreignkeys.html](https://www.sqlite.org/foreignkeys.html)

---

[← Previous: Module 3](./03-llm-assisted-sql-and-query-profiling.md) | [Back to front page](../README.md) | [Next: Module 5 →](./05-normalization-vs-denormalization.md)
