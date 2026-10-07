# Module 2 — Data Contracts & Reading Legacy Schemas (ERD Audits)

[← Back to front page](../README.md) | [Quick module index](./00-index.md) | [Next: Module 3 →](./03-llm-assisted-sql-and-query-profiling.md)

> **One question for the whole course:** *How does raw data become a trustworthy, fast, and safe answer — on a machine you actually own?*

**Course placement:** Session 2. This module covers the legacy *Conceptual Database Design* and *requirements analysis* chapters — but from the direction real engineers meet them: you inherit a schema that already exists and must reconstruct what it *means*.

## 🎯 Learning Goals

> **How these are assessed:** You show that you have reached these goals in a short (~10-minute) checkpoint presentation in Session 6 — based on your portfolio and reflections, not on completing every task. See the [syllabus](../syllabus.md#how-module-points-are-earned-checkpoint-presentations) for the assessment rules. **These learning goals are the contract between you and the instructor: demonstrate them, and you have met the module.** The tasks in this module are a draft — you are encouraged to modify, replace, or extend them as long as your alternative reaches the same goals. You may skip tasks, fail at some, or add your own; documented exploration and demonstrated deep understanding both count in your favor.

This module gives you the opportunity to explore conceptual data modeling and requirements analysis and achieve competency in reading, critiquing, and formalizing a data model.

By the end of this module, you can:
1. Reconstruct an **ER/EER model** (entities, attributes, keys, relationships, cardinalities) from an undocumented SQL schema.
2. Identify **integrity defects** — missing foreign keys, orphan rows, redundant data, normalization violations — with queries, not intuition.
3. Distinguish an **entity relationship** from an attribute, and a **surrogate key** from a natural key, and justify the choice.
4. Express a schema as a **code-first data contract** (Pydantic / SQLAlchemy) that an application can enforce.
5. Write the **requirements the schema forgot**: the business rules nobody encoded.

> [!NOTE]
> Task tiers. Tasks marked ★ Core must be completed by everyone. Tasks marked ◇ Stretcher are optional and are the natural trim point if time runs short — they are excellent bonus-task material.

> [!WARNING]
> DRAFT — first taught in WS 2026/27 by an instructor who is **also teaching databases for the first time** and is learning this material alongside you. Everything below this line is a working draft and will likely change as we refine it together in class; the line moves down as we approve content. Different deep dives and stretchers are welcome — your input can shape this module.

**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 📖 Story — The Maintenance Database With No Diagram

You join a mechatronics team at a plastics injection-molding plant. A tool from 2011 tracks maintenance. It works, so nobody touches it. Then a machine fails and the maintenance planner asks a simple question — *"which parts did we replace on this machine in the last year, and how often?"* — and it takes a specialist a whole afternoon, because the schema is a pile of TEXT columns with no relationships.

You are the database engineer now. Your job is to **audit the schema**, reconstruct the ER model it should have had, find the integrity bugs, and write a data contract the next application can rely on. You will meet this exact task in real industry: most professional database work is not greenfield design — it is *reading and repairing somebody else's data model.*

## 📖 Part A — Mini-Lecture: From Rows to Meaning

**Entities, attributes, relationships.** An **entity** is a thing of independent existence (a *Machine*, a *Part*, a *Technician*). An **attribute** describes an entity (a machine's *serial number* or *install date*). A **relationship** links entities (*a Technician performs a MaintenanceJob on a Machine*).

**Cardinality** is the property that most often goes wrong in a legacy schema:

| Cardinality | Example | How it becomes a table |
|---|---|---|
| 1 : 1 | A machine has exactly one nameplate record | Foreign key on either side (with `UNIQUE`) |
| 1 : n | A machine has many readings | Foreign key on the "many" side |
| m : n | Jobs use many parts; a part is used in many jobs | **A junction table** (`job_part`) — this is the one legacy schemas forget |

**Keys.** A **natural key** is real-world data that identifies a row (a machine's serial number). A **surrogate key** is a synthetic identifier (`INTEGER PRIMARY KEY`) with no business meaning. Use a surrogate key when the natural key is long, mutable, or composite — but keep a `UNIQUE` constraint on the natural key so the database still knows it is unique.

**What EER adds:** inheritance/generalization (a *Sensor* is a *Device*), and the disjoint/complete distinctions. In a relational schema these become either one table with a type column, or separate tables joined by key.

> [!TIP]
> The fastest way to find the *real* cardinality is to count distinct values. `SELECT COUNT(*), COUNT(DISTINCT machine) FROM ...` tells you more about a legacy schema than any documentation.

## 🛠️ Studio Lab: Audit a Legacy Schema — **Challenging**

*Software:* the `sqlite3` CLI and Python 3.11+. Everything runs locally on a file you create.

### Setup

Create `module-02/legacy.db` and load this deliberately flawed schema. It is a realistic *mess*: text where foreign keys should be, a comma-separated list in a "column", and no constraints.

```sh
mkdir -p module-02
sqlite3 module-02/legacy.db <<'SQL'
DROP TABLE IF EXISTS machine;
DROP TABLE IF EXISTS part;
DROP TABLE IF EXISTS maint_job;

CREATE TABLE machine (
    machine_name TEXT,          -- no PK, no NOT NULL
    serial_no    TEXT,
    site         TEXT,
    installed    TEXT           -- a date stored as free text
);

CREATE TABLE part (
    part_no      TEXT,          -- natural key, but not declared UNIQUE
    description  TEXT,
    unit_price   TEXT           -- a number stored as text!
);

CREATE TABLE maint_job (
    job_id       INTEGER,
    machine_name TEXT,          -- a *name*, not a foreign key
    technician   TEXT,
    done_on      TEXT,
    parts_used   TEXT           -- e.g. 'P-1001,P-1002'  <-- violates 1NF
);

INSERT INTO machine VALUES
  ('cnc-01','SN-88120','Gütersloh','2019-03-11'),
  ('cnc-02','SN-88121','Gütersloh','2019-03-11'),
  ('cnc-03','SN-88122','Bielefeld','2021-07-02'),
  ('RANDOM-NAME','SN-90000','Gütersloh','unknown');

INSERT INTO part VALUES
  ('P-1001','Ball bearing 6203','12.50'),
  ('P-1002','Spindle belt','48.00'),
  ('P-1003','Coolant filter','9.90'),
  ('P-1003','Coolant filter','9.90');   -- duplicate row!

INSERT INTO maint_job VALUES
  (1,'cnc-01','Beier','2026-01-08','P-1001,P-1002'),
  (2,'cnc-02','Klaas','2026-02-14','P-1003'),
  (3,'cnc-05','Beier','2026-02-20','P-1001'),  -- machine cnc-05 does not exist!
  (4,'cnc-01','Werther','2026-03-01',NULL);
SQL
```

### ★ Task 1: Reconstruct the ER model

1. **List the entities you can see** and, for each, the attributes and the *intended* primary key. Write these down in `module-02/er-audit.md`.
2. **Draw the ER diagram** (hand-drawn and photographed, or in a tool such as [diagrams.net](https://www.diagrams.net/)) showing the entities you believe the designer *meant* to model: `Machine`, `Part`, `MaintenanceJob`, `Technician`, and the relationships between them.
3. **Determine the cardinalities** with counts, not guesses. For example, to prove that `parts_used` is really a many-to-many list hidden in a column:

   ```sql
   .timer on
   -- How many jobs reference more than one part? (the m:n hiding in a text column)
   SELECT job_id, parts_used,
          LENGTH(parts_used) - LENGTH(REPLACE(parts_used, ',', '')) + 1 AS n_parts
   FROM maint_job;
   ```
4. State, in one sentence each, which of these the legacy schema models and which it hides: 1:1, 1:n, m:n.

*Portfolio evidence:* `er-audit.md` with the entity list, the reconstructed ER diagram, and the cardinality findings.

### ★ Task 2: Find the integrity defects with queries

Do not describe defects — **prove** them. Save each query and its result.

```sql
.timer on

-- Defect 1: orphan maintenance jobs (machine_name not in machine)
SELECT m.job_id, m.machine_name
FROM maint_job m
LEFT JOIN machine x ON m.machine_name = x.machine_name
WHERE x.machine_name IS NULL;

-- Defect 2: duplicate natural keys in part
SELECT part_no, COUNT(*) AS copies
FROM part GROUP BY part_no HAVING COUNT(*) > 1;

-- Defect 3: unit_price stored as text — a numeric comparison fails silently
SELECT part_no, unit_price FROM part WHERE unit_price < '15';   -- 'text ordering', not money!

-- Defect 4: installed dates that are not dates
SELECT machine_name, installed FROM machine
WHERE installed NOT GLOB '[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]';

-- Defect 5: the m:n list cannot be joined — show why
SELECT j.job_id, p.description
FROM maint_job j
JOIN part p ON p.part_no = j.parts_used;   -- matches nothing; the list is not a key
```

For each defect, write one line: **what breaks in production because of it** (e.g. "an orphan job cannot be attributed to a site; a text price comparison produces wrong invoices").

*Portfolio evidence:* the five queries, their results, and your one-line production-impact note for each.

### ★ Task 3: Write the data contract in code

An ER diagram is documentation; a **contract** is executable. Express the *corrected* schema as a Pydantic model and a SQLAlchemy table so an application can enforce it. Save as `module-02/contract.py`.

```python
"""Code-first data contract for the repaired maintenance schema."""
from datetime import date
from pydantic import BaseModel, Field, field_validator

from sqlalchemy import (Column, Date, ForeignKey, Integer, Numeric, String,
                        Table, MetaData, UniqueConstraint)

# --- 1. The contract the *application* validates against (Pydantic) ---
class Machine(BaseModel):
    machine_id: int = Field(ge=1)
    serial_no: str = Field(min_length=3)
    site: str
    installed: date                      # a real date, not free text

    @field_validator("serial_no")
    @classmethod
    def serial_has_prefix(cls, v: str) -> str:
        if not v.startswith("SN-"):
            raise ValueError("serial numbers must start with 'SN-'")
        return v

class MaintenanceJob(BaseModel):
    job_id: int
    machine_id: int                      # a foreign key, not a name
    technician: str
    done_on: date
    part_nos: list[str] = Field(default_factory=list)   # the m:n list, modeled properly

# --- 2. The contract the *database* enforces (SQLAlchemy DDL) ---
metadata = MetaData()

machine_t = Table("machine", metadata,
    Column("machine_id", Integer, primary_key=True),
    Column("serial_no", String, nullable=False),
    Column("site", String, nullable=False),
    Column("installed", Date, nullable=False),
    UniqueConstraint("serial_no", name="uq_machine_serial"),
)

part_t = Table("part", metadata,
    Column("part_no", String, primary_key=True),      # natural key, now enforced
    Column("description", String, nullable=False),
    Column("unit_price", Numeric(9, 2), nullable=False),   # NUMERIC, not TEXT
)

maint_job_t = Table("maint_job", metadata,
    Column("job_id", Integer, primary_key=True),
    Column("machine_id", Integer, ForeignKey("machine.machine_id"), nullable=False),
    Column("technician", String, nullable=False),
    Column("done_on", Date, nullable=False),
)

# the junction table that repairs the 1NF violation
job_part_t = Table("job_part", metadata,
    Column("job_id", Integer, ForeignKey("maint_job.job_id"), primary_key=True),
    Column("part_no", String, ForeignKey("part.part_no"), primary_key=True),
)

if __name__ == "__main__":
    # Emit the corrected DDL to prove the contract is buildable:
    from sqlalchemy.schema import CreateTable
    from sqlalchemy import create_engine
    engine = create_engine("sqlite://")
    metadata.create_all(engine)
    for t in (machine_t, part_t, maint_job_t, job_part_t):
        print(str(CreateTable(t).compile(engine)).strip(), ";\n")
```

Run it (`pip install pydantic sqlalchemy` if needed) and save the emitted DDL. This is the schema you would migrate to.

*Portfolio evidence:* `contract.py`, a note on which constraint you chose to enforce **in the model** versus **in the database** (and why), and the emitted DDL.

### ◇ Task 4 (Stretcher): Model inheritance and prove it

The plant also has *machines* that are *CNC mills* and *injection molders*, each with extra attributes. Model the EER generalization/disjointness two ways — one table with a discriminator column, versus separate tables — and write one sentence on which you would ship and why.

*Portfolio evidence:* both schema alternatives plus your decision and rationale.

## ✅ What must be committed to your portfolio

Commit under `module-02/`:

- [ ] `legacy.db` setup script (the `CREATE`/`INSERT` block) — so a reviewer can rebuild it.
- [ ] `er-audit.md` with the entity/attribute list, the reconstructed ER diagram, and cardinalities.
- [ ] The five integrity-defect queries **with results** and one-line production-impact notes.
- [ ] `contract.py` (Pydantic + SQLAlchemy) and the emitted corrected DDL.
- [ ] `reflection.md` — the logbook entry for this block: *What worked? What broke? How did my mental model shift? How did I verify AI suggestions?*
- [ ] (Stretcher) the two inheritance models and your decision.

## 📚 If you want to go deeper

- SQLite — foreign keys and why they are off by default — [sqlite.org/foreignkeys.html](https://www.sqlite.org/foreignkeys.html)
- Pydantic — data validation — [docs.pydantic.dev](https://docs.pydantic.dev/)
- SQLAlchemy — declarative ORM and Core — [docs.sqlalchemy.org](https://docs.sqlalchemy.org/)
- diagrams.net (draw.io) — free ER diagramming — [diagrams.net](https://www.diagrams.net/)

---

[← Previous: Module 1](./01-introduction-and-local-first.md) | [Back to front page](../README.md) | [Next: Module 3 →](./03-llm-assisted-sql-and-query-profiling.md)
