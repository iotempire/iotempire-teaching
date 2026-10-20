# Module 2 — Data Contracts & Reading Legacy Schemas (ERD Audits)

[← Back to front page](../README.md) | [Quick module index](./00-index.md) | [Next: Module 3 →](./03-llm-assisted-sql-and-query-profiling.md)

**Course placement:** Session 2. This module covers the legacy *Conceptual Database Design* and *requirements analysis* chapters — but from the direction real engineers meet them: you inherit a schema that already exists and must reconstruct what it *means*.

## 🎯 Learning Goals

This module gives you the opportunity to explore conceptual data modeling and requirements analysis and achieve competency in reading, critiquing, and formalizing a data model.

By the end of this module, you can:
1. Reconstruct an **ER/EER model** (entities, attributes, keys, relationships, cardinalities) from an undocumented SQL schema.
2. Identify **integrity defects** — missing foreign keys, orphan rows, redundant data, normalization violations — with queries, not intuition.
3. Distinguish an **entity relationship** from an attribute, and a **surrogate key** from a natural key, and justify the choice.
4. Express a schema as a **code-first data contract** (Pydantic / SQLAlchemy) that an application can enforce.
5. Write the **requirements the schema forgot**: the business rules nobody encoded.

**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 📖 Story — The Maintenance Database With No Diagram

You join a mechatronics team at **Kortmann Kunststofftechnik GmbH**, a plastics injection-molding plant. A tool from 2011 tracks maintenance. It works, so nobody touches it. Then a machine fails and the maintenance planner, **Anke Reuter**, asks a simple question — *"which parts did we replace on this machine in the last year, and how often?"* — and it takes a specialist a whole afternoon, because the schema is a pile of TEXT columns with no relationships.

You are the database engineer now. Your job is to **audit the schema**, reconstruct the ER model it should have had, find the integrity bugs, and write a data contract the next application can rely on. You will meet this exact task in real industry: most professional database work is not greenfield design — it is *reading and repairing somebody else's data model.*

## 📖 Pod Study: From Rows to Meaning

This is **self/pod study, not a lecture.** Work through the concepts below with your Task Pod, look things up, ask an LLM, and keep notes — the goal is a shared mental model you can defend in the checkpoint.

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

### Pointers (start here, then keep looking)

- ER model — entities, attributes, relationships, cardinality — [Wikipedia: Entity–relationship model](https://en.wikipedia.org/wiki/Entity%E2%80%93relationship_model)
- Crow's-foot / IE notation — how each cardinality is drawn — see the *Cardinality* and *Notation* sections of the article above
- EER — inheritance and generalization — [Wikipedia: Enhanced entity–relationship model](https://en.wikipedia.org/wiki/Enhanced_entity%E2%80%93relationship_model)
- Keys — [Natural key](https://en.wikipedia.org/wiki/Natural_key) vs [Surrogate key](https://en.wikipedia.org/wiki/Surrogate_key)
- Why a comma-separated list breaks 1NF — [Wikipedia: First normal form](https://en.wikipedia.org/wiki/First_normal_form)
- Why SQLite foreign keys are off by default — [sqlite.org/foreignkeys.html](https://sqlite.org/foreignkeys.html)
- The code side — [Pydantic](https://docs.pydantic.dev/) and [SQLAlchemy](https://docs.sqlalchemy.org/)
- Draw the diagram — [diagrams.net](https://www.diagrams.net/)

### Questions to ask an LLM (then verify against your data)

Ask your co-pilot — but treat every answer as a **claim to test**, not a fact. Good starting prompts:

- "I am a student in a 3rd-semester database class. Explain **very briefly** what entity–relationship models are, with **simple examples** — highlight the main concepts — and tell me **how I can best explain this to one of my peers**."
- "Here is a legacy schema: `<paste the CREATE TABLEs>`. What entities, attributes, and relationships does it *intend*? What cardinalities are hidden in it, and how would I prove each with a `COUNT` query?"
- "Explain the difference between a natural key and a surrogate key, and give one real scenario where choosing the wrong one causes a data bug."
- "A column holds a comma-separated list: `parts_used = 'P-1001,P-1002'`. Why does that violate 1NF, and what would the corrected schema look like?"
- "Where exactly is the line between an *entity* and an *attribute*? Give a case where it is ambiguous, and say who decides."
- "Draw the Crow's-foot notation for 1:1, 1:n, and m:n in text, and explain what the 'crow's foot' end means."
- "Give three real-world incidents caused by missing foreign keys or orphan rows."

> Ask each prompt **against your own `legacy.db`**, and record where the model is wrong, vague, or over-confident.

### ★ Task A: Study in your pod (~30 minutes)

Spend about **30 minutes** exploring the concepts above with your Task Pod and filling in `Module02/study-log.md`:

1. **The references you used** — the source (book, site, video, doc) and, for each, **the one concept you understood best from it**. (This comes first: credit where your understanding came from.)
2. **Things you googled** — the term/question, what you found, and the source (URL). One line each.
3. **Remarkable things** — surprises, "aha"s, and counterexamples (e.g. "a *name* looked like a key but had duplicates").
4. **LLM Q&A** — for each prompt you tried: the prompt, a 2–3 line summary of the answer, and **how you verified it** (and where it was wrong).
5. **Your two best found ER sketches** — hunt down ER/EER **example sketches** that teach you the most, then **compile down to the best two** (this is a small **sport** — the clearest examples win the Discord share in Task C). For each: the source (link or credit), a screenshot or your own redraw, and **what exactly you learned from it** that the others did not show.

*Portfolio evidence:* `Module02/study-log.md`.

### ★ Task B: From words to sketch (part of your study)

Working from a plain-text description to a diagram is the core skill. For **each** description below, decide the **entities**, their **attributes**, and the **relationships with cardinality**, then **sketch it** — hand-drawn, or in [Mermaid or diagrams.net](./Z-resources-bank.md#visualizing-an-er-model-mermaid-diagramsnet).

1. **1:1** — *A workshop keeps **machines**. Each machine has exactly one **nameplate** (serial number, manufacturer), and each nameplate belongs to exactly one machine.* → Where does the key go? Is the nameplate a separate entity or an attribute of the machine?
2. **1:n** — *Each machine carries many **sensors**; every sensor is installed on exactly one machine.* → Which side holds the foreign key?
3. **m:n** — ***Work orders** use many **parts**, and a part is used by many work orders; an order can list a given part only once.* → What extra table do you need, and what is its key?
4. **Entity vs. attribute vs. relationship** — *A maintenance **job** happens on one **machine**, is done by one **technician** on one **date**; a technician performs many jobs.* → Is the job a *relationship* or an *entity*? Is the technician an entity or just a name?

Then prove one: write the `CREATE TABLE` for your favourite sketch, insert two rows, and show the `COUNT` query that demonstrates its cardinality.

*Portfolio evidence:* your **four sketches** in `Module02/study-log.md` (or `er-examples.md`) plus the one `CREATE TABLE` + `COUNT` proof.

### ★ Task C: Explain & share with another pod (~15 minutes)

Pair with a **neighbouring pod** for about **15 minutes**:

1. **Explain to each other** — each pod walks the other through its study log and its four sketches; ask questions and fill each other's gaps.
2. Agree on the **3–5 most noteworthy points** and the **learning you jointly stand behind** (e.g. *"a natural key without `UNIQUE` is not a key"*).
3. **Clean up your documentation** — update your `study-log.md` with what you learned from the other pod.
4. Agree on **one image** — the best example from either pod, or a **new drawing the two pods make together** — and **post that one in our Discord channel**, with a one-sentence note on why you chose it.
5. Each member adds a short **“Agreed learning (pod discussion)”** section — the shared points, plus any disagreement you left open — to *their own* `Module02/study-log.md`.

*Portfolio evidence:* your cleaned-up `study-log.md` (with the **“Agreed learning (pod discussion)”** section), and your pod-pair's single shared image posted in Discord.

## 🛠️ Studio Lab: Audit a Legacy Schema — **Challenging**

*Software:* the `sqlite3` CLI and Python 3.14. Everything runs locally on a file you create.

### Setup

Create `Module02/legacy.db` and load this deliberately flawed schema. It is a realistic *mess*: text where foreign keys should be, a comma-separated list in a "column", and no constraints.

```sh
mkdir -p Module02
sqlite3 Module02/legacy.db <<'SQL'
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

**1. List the entities you can see** and, for each, the attributes and the *intended* primary key. Write these down in `Module02/er-audit.md`.

**2. Draw the ER diagram** (hand-drawn and photographed, or in a tool such as [diagrams.net](https://www.diagrams.net/)) showing the entities you believe the designer *meant* to model: `Machine`, `Part`, `MaintenanceJob`, `Technician`, and the relationships between them. *(If you ask an LLM to sketch this, it usually answers in **Mermaid** `erDiagram` syntax — see [Visualizing an ER model](./Z-resources-bank.md#visualizing-an-er-model-mermaid-diagramsnet) for how to render it.)*

**3. Determine the cardinalities** with counts, not guesses. For example, to prove that `parts_used` is really a many-to-many list hidden in a column:

```sql
.timer on
-- How many jobs reference more than one part? (the m:n hiding in a text column)
SELECT job_id, parts_used,
       LENGTH(parts_used) - LENGTH(REPLACE(parts_used, ',', '')) + 1 AS n_parts
FROM maint_job;
```

**4. State**, in one sentence each, which of these the legacy schema models and which it hides: 1:1, 1:n, m:n.

*Portfolio evidence:* `er-audit.md` with the entity list, the reconstructed ER diagram, and the cardinality findings.

### ★ Task 2: Find the integrity defects with queries

Do not describe defects — **prove** them. Save each query and its result.

> An LLM can *list* these defects for you in seconds — and the expected ones are no secret. That listing is **not** the skill; **proving** each defect with a query, and repairing the model, is.

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

-- Defect 5: the m:n list only "joins" when it holds exactly one part
SELECT j.job_id, p.description
FROM maint_job j
JOIN part p ON p.part_no = j.parts_used;   -- the list is not a key
-- Watch what happens: job 2 ('P-1003') and job 3 ('P-1001') match, but job 1
-- ('P-1001,P-1002') silently disappears. A naive join on the list loses every
-- multi-part job — and reports success while doing it. That silence is the defect.
```

For each defect, write one line: **what breaks in production because of it** (e.g. "an orphan job cannot be attributed to a site; a text price comparison produces wrong invoices").

*Portfolio evidence:* the five queries, their results, and your one-line production-impact note for each.

### ★ Task 3: Write the data contract in code

An ER diagram is documentation; a **contract** is executable. Express the *corrected* schema as a Pydantic model and a SQLAlchemy table so an application can enforce it. Save as `Module02/contract.py`.

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

Run it with `uv run python Module02/contract.py` (your Module 1 environment already has `pydantic` and `sqlalchemy`) and save the emitted DDL. This is the schema you would migrate to.

*Portfolio evidence:* `contract.py`, a note on which constraint you chose to enforce **in the model** versus **in the database** (and why), and the emitted DDL.

### ◇ Task 4 (Stretcher): Model inheritance and prove it

The plant also has *machines* that are *CNC mills* and *injection molders*, each with extra attributes. Model the EER generalization/disjointness two ways — one table with a discriminator column, versus separate tables — and write one sentence on which you would ship and why.

*Portfolio evidence:* both schema alternatives plus your decision and rationale.

### ◇ Task 5 (Stretcher): Mermaid ER diagrams — collect, convert, and critique

Turn Mermaid into your ER notebook: hunt good and strange diagrams, move between diagrams and schemas with AI, and pick fights with the classics.

**1. Collect curiosities.** Find ER diagrams that are *good*, *strange*, or *famous*, and **redraw each in Mermaid** `erDiagram`. Search terms to start from:
- `entity relationship diagram examples` · `interesting ER diagram` · `ER diagram best practices` / `worst practices`
- `ternary relationship ER` · `weak entity ER` · `recursive relationship ER` · `associative entity`
- `ER diagram notation comparison` (Chen vs Crow's-foot vs UML) · `dbdiagram.io examples` · `mermaid erDiagram examples`

Pick **three** — one *good*, one *strange*, one *wrong or confusing* — and say what makes each so.

**2. Move schema ↔ diagram (with AI).**
- **Schema → diagram:** paste a `CREATE TABLE` set to an LLM, ask for the Mermaid `erDiagram`, then render it ([mermaid.live](https://mermaid.live/) or GitHub). **Verify every cardinality against the data** with `COUNT`s — a model will happily *draw* a relationship the schema never declared.
- **Diagram → schema:** paste a Mermaid `erDiagram` back and ask for the equivalent `CREATE TABLE`s with foreign keys; run them in SQLite and re-derive the diagram from `.schema`. **What survived the round-trip, and what did the model invent?**

**3. Argue about cardinality overuse.** Real ER diagrams are almost always **1:1, 1:n, or m:n**. Numbers like **1:4** (*“a car has exactly four wheels”*) are *business rules*, not cardinalities — they belong in a `CHECK`/validation, not the model. That textbook example is overused and misleading. **Try to break it** (a spare wheel? a trailer? a six-wheel truck?) and write when “exactly N” is a genuine cardinality and when it is just a constraint.

**4. Inheritance — wrong or overused.** Mermaid `erDiagram` **cannot** express EER inheritance — use a `classDiagram` or plain notes for that. Sketch a *Vehicle → Car/Truck* hierarchy, then argue *against* it: when is a `type` column enough? When does inheritance explode (the `Customer`/`Employee`/`Student` tangle)? Ask an LLM: *“Give me a schema where inheritance is classic over-engineering, and a simpler alternative.”* Compare with the inheritance stretcher above.

**5. Share your best find.** Post the most interesting good/strange diagram (with its Mermaid source) in Discord, with one line on what it teaches.

*Portfolio evidence:* `Module02/mermaid-lab.md` (or a section in `study-log.md`) with your **three curated diagrams + Mermaid source**, the schema↔diagram round-trip findings, and one paragraph each on **cardinality** and **inheritance** overuse.

## ✅ Suggested portfolio evidence (proofs of the learning goals)


- [ ] `study-log.md` — the references you used (and the concept each taught you), what you googled, remarkable findings, LLM Q&A (with how you verified each), your **two best found ER sketches** and your **four drawn examples** (with the one `CREATE TABLE` + `COUNT` proof), and your **“Agreed learning (pod discussion)”** — plus the single image your pod pair shared in Discord.
- [ ] `legacy.db` setup script (the `CREATE`/`INSERT` block) — so a reviewer can rebuild it.
- [ ] `er-audit.md` with the entity/attribute list, the reconstructed ER diagram, and cardinalities.
- [ ] The five integrity-defect queries **with results** and one-line production-impact notes.
- [ ] `contract.py` (Pydantic + SQLAlchemy) and the emitted corrected DDL.
- [ ] `Reflections/ref02.md` — the logbook entry for this block, using the reflection template.
- [ ] (Stretcher) the two inheritance models and your decision.
- [ ] (Stretcher) `mermaid-lab.md` — three curated ER diagrams + Mermaid source, the schema↔diagram round-trip, and your notes on cardinality and inheritance overuse.

## 📚 If you want to go deeper

- SQLite — foreign keys and why they are off by default — [sqlite.org/foreignkeys.html](https://www.sqlite.org/foreignkeys.html)
- Pydantic — data validation — [docs.pydantic.dev](https://docs.pydantic.dev/)
- SQLAlchemy — declarative ORM and Core — [docs.sqlalchemy.org](https://docs.sqlalchemy.org/)
- diagrams.net (draw.io) — free ER diagramming — [diagrams.net](https://www.diagrams.net/)
- Mermaid — `erDiagram` syntax — [mermaid.js.org/syntax/entityRelationshipDiagram.html](https://mermaid.js.org/syntax/entityRelationshipDiagram.html)
- dbdiagram.io — a text-to-ER playground — [dbdiagram.io](https://dbdiagram.io/)

---

[← Previous: Module 1](./01-introduction-and-local-first.md) | [Back to front page](../README.md) | [Next: Module 3 →](./03-llm-assisted-sql-and-query-profiling.md)
