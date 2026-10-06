# Module 3 — LLM-Assisted SQL & Query Profiling

[← Back to front page](../README.md) | [Quick module index](./00-index.md) | [Next: Module 4 →](./04-integrity-constraints-and-triggers.md)

> **One question for the whole course:** *How does raw data become a trustworthy, fast, and safe answer — on a machine you actually own?*

**Course placement:** Session 3. This module covers the legacy *Standard SQL (DQL)*, *Relational Algebra*, and *Query Optimization* chapters — reframed around the modern reality: you generate SQL with AI and then prove it correct, fast, and safe.

> [!TIP]
> **Optional warm-up:** if you would like SQL to *feel* familiar before we start generating it with AI, play [SQL Island](https://sql-island.informatik.uni-kl.de/) — a free, browser-based text-adventure from the University of Kaiserslautern that teaches `SELECT`, `WHERE`, `ORDER BY`, aggregates, and joins in about an hour (no install, no account). More in the [resource bank](./Z-resources-bank.md#goody-sql-practice-games).

## 🎯 Learning Goals

> **How these are assessed:** You show that you have reached these goals in a short (~10-minute) checkpoint presentation in Session 6 — based on your portfolio and reflections, not on completing every task. See the [syllabus](../syllabus.md#how-module-points-are-earned-checkpoint-presentations) for the assessment rules. **These learning goals are the contract between you and the instructor: demonstrate them, and you have met the module.** The tasks in this module are a draft — you are encouraged to modify, replace, or extend them as long as your alternative reaches the same goals. You may skip tasks, fail at some, or add your own; documented exploration and demonstrated deep understanding both count in your favor.

This module gives you the opportunity to explore complex querying and query optimization and achieve competency in writing, profiling, and securing SQL.

By the end of this module, you can:
1. Build complex **DQL** queries: joins, aggregation with `GROUP BY`/`HAVING`, subqueries, and window functions.
2. Read **`EXPLAIN QUERY PLAN`** and tell a `SCAN` from a `SEARCH`, a table lookup from a covering index.
3. **Benchmark** the effect of an index and explain when the planner ignores one.
4. Generate a query with an **LLM**, then **verify** it: correctness, performance, and edge cases.
5. **Prevent SQL injection** with bound parameters and demonstrate why string concatenation is exploitable.

> [!NOTE]
> Task tiers. Tasks marked ★ Core must be completed by everyone. Tasks marked ◇ Stretcher are optional and are the natural trim point if time runs short — they are excellent bonus-task material.

> [!WARNING]
> DRAFT — first taught in WS 2026/27 by an instructor who is **also teaching databases for the first time** and is learning this material alongside you. Everything below this line is a working draft and will likely change as we refine it together in class; the line moves down as we approve content. Different deep dives and stretchers are welcome — your input can shape this module.

**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 📖 Story — "The LLM Wrote It, It Ran, Ship It?"

A logistics startup runs its order-tracking on a local SQLite file synced from the warehouse. The lead developer confesses the team's workflow: *"when we need a new report, we describe it to Claude, paste the SQL into the code, and if the number looks about right, we ship it."* It worked — until a report for customer service quietly returned the **wrong** list of late orders for a month, and a support agent typed a customer name containing an apostrophe that took the whole order page down.

Both failures have the same root: **nobody profiled or parameterized the generated SQL**. In this studio you become the person who does. You will write real analytics against a warehouse dataset, let an LLM draft the hard parts, and then put every query through three gates: does it **run**, is it **right**, is it **fast and safe**.

## 📖 Part A — Mini-Lecture: The Six Clauses and the Plan (15 min)

**From relational algebra to SQL.** Relational algebra is the *meaning*; SQL is the *syntax*. The mapping is mechanical, and knowing it is what lets you check an LLM's work:

| Algebra | SQL |
|---|---|
| Selection σ (filter rows) | `WHERE` |
| Projection π (choose columns) | `SELECT` list |
| Join ⋈ | `JOIN ... ON` |
| Union ∪ / Difference − | `UNION` / `EXCEPT` |
| Grouping γ (aggregate) | `GROUP BY` + aggregate functions |
| Rename ρ | `AS` aliases |

**The six clauses and their logical order.** SQL is *written* `SELECT ... FROM ... WHERE ... GROUP BY ... HAVING ... ORDER BY` but *evaluated* in the order `FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY`. Confusing the two is the single most common LLM error (using a `SELECT` alias in `WHERE`).

**What a query plan tells you.** `EXPLAIN QUERY PLAN` prints one line per table read:

- `SCAN table` — every row is read. Fine for small tables, fatal for large ones.
- `SEARCH table USING INDEX idx (col=?)` — the index narrows the rows.
- `SEARCH table USING COVERING INDEX idx` — the index contains *everything the query needs*, so the table itself is never touched. The fastest path.
- `USE TEMP B-TREE FOR ORDER BY` — the engine had to sort because no index supplied the order.

**The 90/10 of tuning.** Most slow queries are slow because a filtered column has no index, or because a function wraps the column (`WHERE date(done_on) > ...` prevents index use — compare `done_on > '...'` instead).

**Security is not optional.** SQL injection is not a historical curiosity; it is #3 in the OWASP Top 10 (Injection). The fix is one habit: **bound parameters**, never string formatting.

> [!TIP]
> When an LLM gives you SQL, ask it for the *relational algebra* too, then check the two against each other. Models are much worse at being consistent across two representations than at producing one plausible answer.

## 🛠️ Studio Lab: Generate, Profile, and Secure (60 min)

*Software:* `sqlite3` CLI and Python 3.11+. Keep `.timer on` in the shell.

### Setup (5 min)

Build a small warehouse/order dataset with enough rows to make plans meaningful.

```sh
mkdir -p module-03
sqlite3 module-03/warehouse.db <<'SQL'
DROP TABLE IF EXISTS orders, customer, order_line, product;

CREATE TABLE customer(customer_id INTEGER PRIMARY KEY, name TEXT NOT NULL, city TEXT NOT NULL);
CREATE TABLE product (product_id INTEGER PRIMARY KEY, sku TEXT NOT NULL, price REAL NOT NULL);
CREATE TABLE orders  (order_id INTEGER PRIMARY KEY, customer_id INTEGER NOT NULL,
                      ordered_on TEXT NOT NULL, status TEXT NOT NULL);
CREATE TABLE order_line(order_id INTEGER NOT NULL, product_id INTEGER NOT NULL, qty INTEGER NOT NULL);

-- 2,000 customers, 500 products, 60,000 orders, ~240,000 lines
WITH RECURSIVE n(x) AS (SELECT 1 UNION ALL SELECT x+1 FROM n WHERE x < 60000)
INSERT INTO customer(customer_id, name, city)
  SELECT x, 'Customer ' || x, CASE x % 4 WHEN 0 THEN 'Gütersloh' WHEN 1 THEN 'Bielefeld'
                                    WHEN 2 THEN 'Paderborn' ELSE 'Münster' END FROM n WHERE x <= 2000;

WITH RECURSIVE n(x) AS (SELECT 1 UNION ALL SELECT x+1 FROM n WHERE x < 500)
INSERT INTO product(product_id, sku, price)
  SELECT x, 'SKU-' || printf('%05d', x), 5 + (x % 90) * 1.5 FROM n;

WITH RECURSIVE n(x) AS (SELECT 1 UNION ALL SELECT x+1 FROM n WHERE x < 60000)
INSERT INTO orders(order_id, customer_id, ordered_on, status)
  SELECT x, (x % 2000) + 1, date('2025-01-01', '+' || (x % 540) || ' days'),
         CASE x % 5 WHEN 0 THEN 'late' WHEN 1 THEN 'open' ELSE 'shipped' END FROM n;

WITH RECURSIVE n(x) AS (SELECT 1 UNION ALL SELECT x+1 FROM n WHERE x < 240000)
INSERT INTO order_line(order_id, product_id, qty)
  SELECT (x % 60000) + 1, (x % 500) + 1, 1 + (x % 4) FROM n;
SQL
sqlite3 module-03/warehouse.db "SELECT 'orders', COUNT(*) FROM orders UNION ALL
                                SELECT 'lines', COUNT(*) FROM order_line;"
```

### ★ Task 1: Ask the LLM, then check the plan (20 min)

Use the prompt below with your LLM. **Before running the answer**, predict the plan you expect (which tables will be `SCAN`, which will `SEARCH`).

> "SQLite schema: `customer(customer_id, name, city)`, `product(product_id, sku, price)`, `orders(order_id, customer_id, ordered_on, status)`, `order_line(order_id, product_id, qty)`. Write a query that returns, for each city, the number of distinct customers and the total revenue (sum of `qty*price`) of orders placed in 2025, ordered by revenue descending."

1. Run the LLM's query. Record whether it matched your prediction and whether it is even correct (does it count *distinct* customers? does it include the year filter in the right place?).
2. Profile it:
   ```sql
   EXPLAIN QUERY PLAN
   SELECT c.city, COUNT(DISTINCT c.customer_id) AS customers,
          SUM(ol.qty * p.price) AS revenue
   FROM customer c
   JOIN orders o     ON o.customer_id = c.customer_id
   JOIN order_line ol ON ol.order_id = o.order_id
   JOIN product p    ON p.product_id = ol.product_id
   WHERE o.ordered_on >= '2025-01-01' AND o.ordered_on < '2026-01-01'
   GROUP BY c.city
   ORDER BY revenue DESC;
   ```
3. Note every `SCAN` and every `USE TEMP B-TREE`. Save the raw plan output.

*Portfolio evidence:* the exact prompt, the LLM's SQL, your predicted plan, the actual `EXPLAIN QUERY PLAN` output, and a sentence on correctness.

### ★ Task 2: Index benchmark — prove it or disprove it (20 min)

1. Ask the LLM to *optimize* the query and tell you which indexes to add. Do not accept the list — test each index independently. Time the dashboard query **once before adding any index**, then add **one index at a time** and re-time it after each step:
   ```sql
   .timer on
   -- 0. baseline: time the dashboard query with no new indexes

   CREATE INDEX ix_orders_ordered_on ON orders(ordered_on);
   -- 1. re-run and time the dashboard query

   CREATE INDEX ix_orderline_order ON order_line(order_id);
   -- 2. re-run and time the dashboard query

   CREATE INDEX ix_orderline_product ON order_line(product_id);
   -- 3. re-run and time the dashboard query
   ```
2. Build a small before/after table. To make the effect visible even on a fast machine, time repeated runs and/or use a filtered query that the planner can actually improve:

   ```sql
   .timer on
   SELECT o.order_id, o.ordered_on, c.name
   FROM orders o JOIN customer c ON c.customer_id = o.customer_id
   WHERE o.ordered_on = '2026-02-14';      -- a single day: an index helps a lot here
   ```

3. **Find one index that does *not* help** (or one the planner ignores) and explain *why* — a low-cardinality column like `status`, a function wrapping the column, or a table small enough that a scan is cheaper. This negative result is worth as much as a positive one.

*Portfolio evidence:* the before/after table, the plan output that proves the index is used (`SEARCH ... USING INDEX`), and your explanation of the index that did not help.

### ★ Task 3: The injection drill (15 min)

Reproduce the support agent's apostrophe crash and then fix it. Save as `module-03/injection_demo.py`.

```python
"""Demonstrate SQL injection and its one correct fix: bound parameters."""
import sqlite3

conn = sqlite3.connect("module-03/warehouse.db")

def vulnerable(name: str):
    """DON'T DO THIS. String-building the query is the bug."""
    sql = f"SELECT customer_id, name FROM customer WHERE name = '{name}'"
    return conn.execute(sql).fetchall()          # a quote in `name` breaks or hijacks this

def safe(name: str):
    """DO THIS. The value can never be parsed as SQL."""
    sql = "SELECT customer_id, name FROM customer WHERE name = ?"
    return conn.execute(sql, (name,)).fetchall()  # note the bound tuple

if __name__ == "__main__":
    print("normal   :", vulnerable("Customer 1"))
    try:
        # This is the classic payload: it returns ALL rows instead of none.
        print("injected :", vulnerable("' OR '1'='1")[:3], "...")
    except sqlite3.Error as e:
        print("injected : crashed with", e)
    print("safe     :", safe("' OR '1'='1"))       # returns [] — the payload is just data
```

Run it, then answer in your notes: **why is escaping or filtering `'` characters by hand *not* a real fix, whereas bound parameters are?** (Hint: think about identifiers, numeric contexts, encodings, and who is responsible for correctness.)

*Portfolio evidence:* `injection_demo.py` output, the payload you used, and your answer about escaping-vs-parameterizing.

### ★ Task 4: One query, from algebra to plan (5 min)

Take any query you wrote above and write its **relational algebra** expression (σ, π, ⋈, γ). Confirm the SQL matches the algebra. This is the checkpoint-ready skill: explaining a query in two representations.

### ◇ Task 5 (Stretcher): Window functions and a subquery rewrite

Rewrite the "late orders per customer" report once with a correlated subquery and once with a window function (`COUNT(*) OVER (PARTITION BY ...)`). Compare the plans and the readability. Note which the LLM produced by default.

## ✅ What must be committed to your portfolio

Commit under `module-03/`:

- [ ] The setup script that builds `warehouse.db` (~240k order lines).
- [ ] The LLM prompt(s), the generated SQL, your predicted plan, and the actual `EXPLAIN QUERY PLAN` output.
- [ ] The index before/after benchmark table and the negative result with your explanation.
- [ ] `injection_demo.py` and its output, plus your escaping-vs-parameterizing answer.
- [ ] The relational-algebra expression for one query of your choice.
- [ ] `reflection.md` — the logbook entry for this block, explicitly addressing *how you verified AI suggestions*.
- [ ] (Stretcher) the window-function rewrite and its plan.

## 📚 If you want to go deeper

- **Goody — build SQL intuition:** [SQL Island](https://sql-island.informatik.uni-kl.de/) is a free browser text-adventure that teaches the basics in ~1–2 hours; a good warm-up before you start judging generated queries. Siblings in the [resource bank](./Z-resources-bank.md#goody-sql-practice-games).
- SQLite — `EXPLAIN QUERY PLAN` reference — [sqlite.org/eqp.html](https://www.sqlite.org/eqp.html)
- Markus Winand — *Use The Index, Luke* — [use-the-index-luke.com](https://use-the-index-luke.com/)
- OWASP — *SQL Injection Prevention Cheat Sheet* — [cheatsheetseries.owasp.org](https://cheatsheetseries.owasp.org/cheatsheets/SQL_Injection_Prevention_Cheat_Sheet.html)
- Python — the `sqlite3` module and parameter binding — [docs.python.org/3/library/sqlite3.html](https://docs.python.org/3/library/sqlite3.html)

---

[← Previous: Module 2](./02-data-contracts-and-legacy-schemas.md) | [Back to front page](../README.md) | [Next: Module 4 →](./04-integrity-constraints-and-triggers.md)
