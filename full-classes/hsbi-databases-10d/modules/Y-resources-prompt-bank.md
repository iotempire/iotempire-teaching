# Resource Prompts — Databases (DBS)

[← Back to front page](../README.md) | [Quick module index](./00-index.md)

Supplementary material: reflection prompts, LLM-verification drills, and quick references used across the modules.

## Reflection logbook prompts

Each teaching block, write one entry answering these four questions in your own words. Keep it short — a paragraph per question is plenty.

1. **What worked?** The thing you built or measured that functioned. Include the evidence (a number, a plan, a screenshot).
2. **What broke?** The failure, the wrong assumption, the crash. State the *root cause*, not just the symptom.
3. **How did my mental model shift?** What you believed before, and what you understand now. "I thought an index always helps; I measured a case where it did not" is a strong entry.
4. **How did I verify AI suggestions?** The query, schema, or claim an LLM gave you, and the step that confirmed or refuted it.

## LLM-verification drills

SQL syntax is a solved problem for a model; **judgment is not**. Use these drills to practice the verification habit that this course grades.

| Drill | What to do | What you learn |
|---|---|---|
| **Plan literacy** | Ask an LLM for a query, then predict the `EXPLAIN QUERY PLAN` output *before* running it. | Whether you understand how the planner thinks. |
| **The invented column** | Give the model a schema, ask for a query, and check every column name against `PRAGMA table_info`. | Models hallucinate schema confidently. |
| **Alias in `WHERE`** | Ask for a query that filters on a computed `SELECT` alias. | Logical evaluation order (`WHERE` runs before `SELECT`). |
| **Off-by-one window** | Ask for a "night shift 18:00–06:00" filter and test the boundaries. | Time-boundary errors are the most common reporting bug. |
| **The injection prompt** | Ask the model to build a query from a user-supplied string, then check for `f"..."` and `%`. | Generation without parameterization is the default trap. |
| **Two representations** | Ask for both SQL and relational algebra; check they agree. | Consistency across representations is harder than plausibility. |
| **Null semantics** | Ask for a query with `NOT IN` over a nullable column. | `NULL` in `NOT IN` yields no rows — a classic silent bug. |

## Quick references

- **Clause evaluation order:** `FROM` → `WHERE` → `GROUP BY` → `HAVING` → `SELECT` → `ORDER BY` → `LIMIT`.
- **Plan keywords:** `SCAN` (full read) · `SEARCH ... USING INDEX` (narrowed) · `USING COVERING INDEX` (no table access) · `USE TEMP B-TREE` (a sort the planner could not avoid).
- **Integrity layers:** entity (`PRIMARY KEY`, `NOT NULL`, `UNIQUE`) · referential (`FOREIGN KEY`) · semantic (`CHECK`, generated columns, triggers).
- **Normal forms:** 1NF = atomic; 2NF = no partial dependency; 3NF = no transitive dependency.
- **Engines:** SQLite = transactional/row; DuckDB = analytical/columnar; JSON-in-SQLite = flexible documents; key-value = one-key lookups.

## Prompt patterns that work well

- **For schema review:** *"Here is my SQLite DDL. Identify missing constraints, unenforced relationships, and any column that could store nonsense. For each, propose the exact fix."*
- **For tuning:** *"Here is a query and its `EXPLAIN QUERY PLAN` output. Propose one index and predict whether the plan will change to `SEARCH ... USING INDEX`. Explain why or why not."*
- **For security review:** *"Find every place in this Python file where a string is concatenated into SQL. Rewrite each to use bound parameters and explain the injection risk."*

> [!TIP]
> Always paste **real** output back to the model — the actual error, the actual plan. A model iterating on real evidence is far more useful than one guessing.

---

[← Back to front page](../README.md) | [Next: Resource Bank →](./Z-resources-bank.md)
