# Module 3 — LLM-Assisted SQL & Query Profiling

[← Back to front page](../README.md) | [Quick module index](./00-index.md) | [Next: Module 4 →](./04-integrity-constraints-and-triggers.md)

**Course placement:** Session 3. This module covers the legacy *Standard SQL (DQL)*, *Relational Algebra*, and *Query Optimization* chapters — reframed around the modern reality: you generate SQL with AI and then prove it correct, fast, and safe.

> [!TIP]
> **SQL Island has replay value.** You met it in [Module 1](./01-introduction-and-local-first.md) — if you did not get far, or stopped at home, another hour before this studio pays off: the later chapters drill exactly the `JOIN` and aggregate patterns you are about to profile. Free, browser-based, no account: [sql-island.informatik.uni-kl.de](https://sql-island.informatik.uni-kl.de/). Other practice games are in the [resource bank](./Z-resources-bank.md#goody-sql-practice-games).

## 🎯 Learning Goals

This module gives you the opportunity to explore complex querying and query optimization and achieve competency in writing, profiling, and securing SQL.

By the end of this module, you can:
1. Build complex **DQL** queries: joins, aggregation with `GROUP BY`/`HAVING`, subqueries, and window functions.
2. Read **`EXPLAIN QUERY PLAN`** as *primary evidence*: say what the engine will do for a given query, tell a `SCAN` from a `SEARCH`, and a table lookup from a covering index.
3. **Benchmark** the effect of an index and explain when the planner ignores one.
4. Generate a query with an **LLM**, then **verify** it: correctness, performance, and edge cases.
5. **Prevent SQL injection** with bound parameters and demonstrate why string concatenation is exploitable.

**⬇︎ ===== DRAFT BOUNDARY — content below is a provisional draft ===== ⬇︎**

## 📖 Story — "The LLM Wrote It, It Ran, Ship It?"

**Frachtflow**, a logistics startup, runs its order-tracking on a local SQLite file synced from the warehouse. The lead developer, **Nils Bergmann**, confesses the team's workflow: *"when we need a new report, we describe it to Claude, paste the SQL into the code, and if the number looks about right, we ship it."* It worked — until a report for customer service quietly returned the **wrong** list of late orders for a month, and a support agent typed a customer name containing an apostrophe that took the whole order page down.

Both failures have the same root: **nobody profiled or parameterized the generated SQL**. In this studio you become the person who does. You will write real analytics against a warehouse dataset, let an LLM draft the hard parts, and then put every query through three gates: does it **run**, is it **right**, is it **fast and safe**.

## 📖 Pod Study: The Six Clauses and the Plan

This is **self/pod study, not a lecture** — **30 minutes** in your pod, then **15 minutes** with a neighbouring pod. Keep everything in `Module03/sql-notes.md`, with the same discipline as [Module 2](./02-data-contracts-and-legacy-schemas.md): references first, then what you googled, then surprises, then the LLM answers you actually verified.

### Divide and conquer (do not read this alone, front to back)

There is more material here than one person reads well in 30 minutes. Split it: each pod member takes a **workstream**, works through it, and brings back one sentence per item. In a pair, double up; in a pod of three, double up the last row.

| Workstream | Read and do | Bring back |
|---|---|---|
| **1 · Algebra ↔ SQL** | the mapping table, then ask an LLM to translate one query into algebra and check it | one query with its σ/π/⋈ form |
| **2 · Clause order** | written vs. evaluated order; then find a query that breaks if you assume the written order | one counterexample |
| **3 · Plan vocabulary** | the plan lines, then run the two-line covering demo below | one-line definitions of `SCAN`, `SEARCH`, `COVERING` |
| **4 · Tuning & security** | the 90/10 rule and the injection note | one query that defeats an index, and one payload |

**The rule that makes this work: interrupt each other.** Every six minutes, whoever is furthest along stops the pod for a **one-minute update** — what I found, what surprised me, what I still cannot explain. Nobody finishes in silence; the update is where the shared model forms.

| Minute | What happens |
|---|---|
| 0:00 | split the workstreams and start |
| 0:06 | update 1 — one minute each |
| 0:13 | update 2 — one minute each |
| **0:20** | **Task A — plan safari** |
| **0:25** | **Task B — algebra check** |
| **0:30** | **Task C — share with a neighbouring pod (15 min)** |

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

**What a query plan tells you — and why this is the command that matters.** `EXPLAIN QUERY PLAN` is the most useful command in this course. Timing tells you *how long*; the plan tells you *what the engine actually did* — and only the second one is explainable. A stopwatch says "40 ms"; the plan says "it read 240,000 rows to answer a question about 120 of them". You will meet this command in every remaining module, and the final project requires a before/after plan as evidence.

It prints one line per table read, in execution order. Read it as a **loop nest**: the top line is the outer loop, and each line below runs once per row of the one above it. (The `|--` characters are list formatting — they do not mean "deeper work".)

- `SCAN table` — every row is read. Fine for small tables, fatal for large ones.
- `SEARCH table USING INDEX idx (col=?)` — the index narrows the rows, but SQLite still fetches each match from the table.
- `SEARCH table USING COVERING INDEX idx` — the index holds *everything the query needs*, so the table itself is never opened.
- `SCAN table USING COVERING INDEX idx` — the whole index is walked (typical for `COUNT(*)`): linear, but over a much smaller structure than the table.
- `USE TEMP B-TREE FOR ORDER BY` / `FOR GROUP BY` — the engine had to sort or group, because no index supplied the order.

**Why "covering" is worth knowing.** An index entry is the indexed column(s) plus the rowid. If the query needs nothing else, there is no reason to open the table:

```sql
CREATE TABLE t(a INTEGER, b TEXT);
CREATE INDEX i ON t(a);

EXPLAIN QUERY PLAN SELECT a    FROM t WHERE a = 1;   -- SEARCH t USING COVERING INDEX i (a=?)
EXPLAIN QUERY PLAN SELECT a, b FROM t WHERE a = 1;   -- SEARCH t USING INDEX i (a=?)
```

Ask for `b` and the index stops covering the query. An ordinary index search costs **two** B-tree descents per matching row (index, then table); a covering search costs **one**. On a query that matches 100,000 rows, that is 100,000 table seeks you never pay.

> [!IMPORTANT]
> **The plan is evidence; the clock is a symptom.** A `SCAN` over a large table explains a slow query before any stopwatch does. And after you add an index, the plan tells you whether the engine *used* it: a timing change with no plan change is usually noise, while a plan change with no timing change is still a real result — and often the more interesting one.

**The 90/10 of tuning.** Most slow queries are slow because a filtered column has no index, or because a function wraps the column (`WHERE date(done_on) > ...` prevents index use — compare `done_on > '...'` instead).

**Security is not optional.** SQL injection is not a historical curiosity; it is #3 in the OWASP Top 10 (Injection). The fix is one habit: **bound parameters**, never string formatting.

> [!TIP]
> When an LLM gives you SQL, ask it for the *relational algebra* too, then check the two against each other. Models are much worse at being consistent across two representations than at producing one plausible answer.

### Pointers (start here, then keep looking)

- Relational algebra — the operators and how each maps to SQL — [Wikipedia: Relational algebra](https://en.wikipedia.org/wiki/Relational_algebra)
- Reading a plan — [sqlite.org/eqp.html](https://www.sqlite.org/eqp.html) (the reference) and [SQLite execution plan operations](https://use-the-index-luke.com/sql/explain-plan/sqlite/operations) (a glossary of what each line means)
- Why an index gets ignored — [Use The Index, Luke](https://use-the-index-luke.com/)
- SQL injection — [OWASP cheat sheet](https://cheatsheetseries.owasp.org/cheatsheets/SQL_Injection_Prevention_Cheat_Sheet.html)
- **Prefer watching?** [Lecture-style videos for this module](./Z-resources-bank.md#watching-instead-of-reading)

### Questions to ask an LLM (then verify by running it)

- "I am a student in a 3rd-semester database class. Explain **very briefly** relational algebra with **simple examples**, highlight the main concepts, and tell me **how to explain it best to a peer**."
- "Translate this SQL into relational algebra and justify each step: `<your query>`." Do it **yourself first**, then compare — where do you disagree?
- "Why does SQL evaluate `FROM` before `SELECT`? Give me a query that fails because someone assumed the written order."
- "Here is a query plan: `<paste your EXPLAIN QUERY PLAN output>`. What is the engine doing, line by line? What would make it choose a different plan?"
- "When does SQLite use a *covering* index, and when does it still have to visit the table?"
- "Why can't an index help `WHERE technician LIKE '%ei%'`? What could?"

> Every one of these is a **claim to test**. Run it against a real database before you believe it.

### ★ Task A: Plan safari (~10 minutes — start at minute 20)

All together, on one screen, on last session's `Module02/legacy.db` (it should still be there; if not, rebuild it from [Module 2](./02-data-contracts-and-legacy-schemas.md)):

1. **Predict, then run.** For each query, write down `SCAN` or `SEARCH` *before* you prefix it with `EXPLAIN QUERY PLAN`:
   - `SELECT * FROM maint_job WHERE technician = 'Beier';`
   - `SELECT * FROM machine WHERE machine_name = 'cnc-02';`
   - `SELECT * FROM maint_job WHERE technician LIKE '%ei%';`
2. **Add one index** — `CREATE INDEX ix_job_tech ON maint_job(technician);` — and re-run all three. Which plan changed, which did not, and why?
3. **Break it on purpose.** Find a `WHERE` that defeats that index anyway (wrap the column in a function, or use a leading-wildcard `LIKE`). The negative result is the valuable one.

A prediction you got **wrong** is the most useful line in `sql-notes.md`. Keep the predictions next to the real plans.

### ★ Task B: Algebra check (~5 minutes — start at minute 25)

Take the query your pod understands best from the safari and write its σ/π/⋈ form **yourself**. Then ask an LLM to translate the same query and diff the two answers.

Where you disagree, you have found either your own gap or the model's — both are worth a line in `sql-notes.md`.

### ★ Task C: Explain & share with another pod (~15 minutes — from minute 30)

1. **Compare plans.** Did both pods get the *same* plan for the same query? Check `sqlite3 --version` first — Windows, macOS and Linux do not always ship the same one. If the plans differ, find out why; that difference is the discussion.
2. **Explain the surprise.** Each pod names the plan that surprised it most, and what it now believes about indexes.
3. **Harvest.** Add the agreed highlights to both pods' `sql-notes.md`; anything still unresolved goes to `#sql-questions`.

## 🛠️ Studio Lab: Generate, Profile, and Secure — **Challenging**

*Software:* `sqlite3` CLI and Python 3.14. Keep `.timer on` in the shell (see [Measuring query time](./Z-resources-bank.md#measuring-query-time)). **Prefix every query you tune with `EXPLAIN QUERY PLAN` before you measure it** — here and for the rest of the course.

### Setup

Build a small warehouse/order dataset with enough rows to make plans meaningful. Run every command from the folder that contains `Module03/` (your repository root).

```sh
mkdir -p Module03
```

Save the block below as **`Module03/setup.sql`**. A file replays cleanly in every shell and avoids the [multi-line paste problem](./Z-resources-bank.md#pasting-a-block-into-the-sqlite3-prompt):

```sql
DROP TABLE IF EXISTS order_line;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS customer;

CREATE TABLE customer(customer_id INTEGER PRIMARY KEY, name TEXT NOT NULL, city TEXT NOT NULL);
CREATE TABLE product (product_id INTEGER PRIMARY KEY, sku TEXT NOT NULL, price REAL NOT NULL);
CREATE TABLE orders  (order_id INTEGER PRIMARY KEY, customer_id INTEGER NOT NULL,
                      ordered_on TEXT NOT NULL, status TEXT NOT NULL);
CREATE TABLE order_line(order_id INTEGER NOT NULL, product_id INTEGER NOT NULL, qty INTEGER NOT NULL);

-- 2,000 customers, 500 products, 60,000 orders, ~240,000 lines
WITH RECURSIVE n(x) AS (SELECT 1 UNION ALL SELECT x+1 FROM n WHERE x < 60000)   -- (1)
INSERT INTO customer(customer_id, name, city)                                    -- (2)
  SELECT x, 'Customer ' || x, CASE x % 4 WHEN 0 THEN 'Gütersloh' WHEN 1 THEN 'Bielefeld'
                                    WHEN 2 THEN 'Paderborn' ELSE 'Münster' END FROM n WHERE x <= 2000;

WITH RECURSIVE n(x) AS (SELECT 1 UNION ALL SELECT x+1 FROM n WHERE x < 500)
INSERT INTO product(product_id, sku, price)
  SELECT x, 'SKU-' || printf('%05d', x), 5 + (x % 90) * 1.5 FROM n;              -- (5)

WITH RECURSIVE n(x) AS (SELECT 1 UNION ALL SELECT x+1 FROM n WHERE x < 60000)
INSERT INTO orders(order_id, customer_id, ordered_on, status)
  SELECT x, (x % 2000) + 1,                                                      -- (3)
         date('2025-01-01', '+' || (x % 540) || ' days'),                        -- (4)
         CASE x % 5 WHEN 0 THEN 'late' WHEN 1 THEN 'open' ELSE 'shipped' END FROM n;

WITH RECURSIVE n(x) AS (SELECT 1 UNION ALL SELECT x+1 FROM n WHERE x < 240000)
INSERT INTO order_line(order_id, product_id, qty)
  SELECT (x % 60000) + 1, (x % 500) + 1, 1 + (x % 4) FROM n;
```

> [!NOTE]
> **Read the scaffolding before you run it.** This is a lot of SQL for a setup step, and none of it is disposable — every construct here is something you may be asked to explain later. Five lines are marked:
>
> 1. **`WITH RECURSIVE n(x) AS (SELECT 1 UNION ALL SELECT x+1 …)`** — there is no table anywhere with 240,000 rows. So where do the rows come from?
> 2. **`INSERT INTO customer … SELECT …`** — you are inserting the *result of a query*. What happens if that query returns zero rows? (Try it: change `x <= 2000` to `x <= 0`.)
> 3. **`customer_id` is literally `(x % 2000) + 1`** — what guarantees that this customer exists? Nothing does yet. Module 4 turns that hope into a real `FOREIGN KEY`.
> 4. **`date('2025-01-01', '+' || (x % 540) || ' days')`** — why is the date modifier a *string* built with `||`? And what date appears when `x = 540`?
> 5. **`printf('%05d', x)`** — remove it and compare the `sku` column. What does zero-padding buy you when those values are sorted or compared?
>
> One more, outside the block: the four `DROP TABLE`s run **children first**. That order is irrelevant today — it starts mattering the moment Module 4 adds foreign keys.

Then build the database — use the line that fits your shell:

```sh
# bash, zsh, Git Bash (macOS, Linux, or the Git Bash profile of your editor)
sqlite3 Module03/warehouse.db < Module03/setup.sql

# any shell, including PowerShell (no redirect needed)
sqlite3 Module03/warehouse.db ".read Module03/setup.sql"
```

Check the row counts:

```sh
sqlite3 Module03/warehouse.db "SELECT 'orders', COUNT(*) FROM orders UNION ALL
                                SELECT 'lines', COUNT(*) FROM order_line;"
```

Expected: `60000` orders and `240000` order lines. If the numbers are lower, the script stopped early — delete `Module03/warehouse.db` and run it again from the repository root.

### ★ Task 1: Ask the LLM, then check the plan

Use the prompt below with your LLM. **Before running the answer**, predict the plan you expect (which tables will be `SCAN`, which will `SEARCH`).

> [!NOTE]
> **No LLM at hand, or it is temporarily unavailable?** Use the reference query in step 2 as though the model had produced it, and critique it: is the year filter in the right place? Is the customer count really *distinct*? Does the query still answer the question when a customer has no orders? The verification work — which is the actual skill — is identical, and a podmate's model output works just as well.

> "SQLite schema: `customer(customer_id, name, city)`, `product(product_id, sku, price)`, `orders(order_id, customer_id, ordered_on, status)`, `order_line(order_id, product_id, qty)`. Write a query that returns, for each city, the number of distinct customers and the total revenue (sum of `qty*price`) of orders placed in 2025, ordered by revenue descending."

**1. Run the LLM's query.** Record whether it matched your prediction and whether it is even correct (does it count *distinct* customers? does it include the year filter in the right place?).

**2. Profile it:**

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

**3. Note every `SCAN` and every `USE TEMP B-TREE`.** Save the raw plan output.

*Portfolio evidence:* the exact prompt, the LLM's SQL, your predicted plan, the actual `EXPLAIN QUERY PLAN` output, and a sentence on correctness.

### ★ Task 2: Index benchmark — prove it or disprove it

**1. Ask the LLM to *optimize* the query** and tell you which indexes to add. Do not accept the list — test each index independently, **one at a time**.

**2. Measure in a way that the numbers mean something.** The dashboard takes tens of milliseconds, so `.timer on` inside one `sqlite3` session fits it — but a single reading is noise, and a *different* tool will report a different number for the same query (see the [two traps in Measuring query time](./Z-resources-bank.md#measuring-query-time)). So:

- Run each query **at least three times** and report the **median** (the first run pays for the file cache).
- Use the same machine, the same shell, and the same session; close whatever else is compiling.
- **Match the timer to the size of the effect.** `.timer` for the dashboard; for the single-day lookup in step 4, which lands near or below the ~1 ms floor of `time sqlite3 …`, use an [amortized batch](./Z-resources-bank.md#timing-a-query-that-is-too-fast-to-time) instead.
- **A changed plan is stronger evidence than a millisecond delta.** `SCAN orders` → `SEARCH orders USING INDEX ix_orders_ordered_on` proves the index is used, regardless of what the clock says. Record **both**: plan and timing.

Expect this up front: the dashboard is **aggregate-heavy** — it aggregates ~240,000 `order_line` rows — so "faster" is not guaranteed. Depending on your SQLite version and machine, `ix_orders_ordered_on` may leave this query's plan completely unchanged while `ix_orderline_order` flips it to an index-driven join that is measurably **slower** than the scan. **If your timing gets worse, that is not a failed experiment** — it is the most valuable result in this task. An index changes the plan; it does not guarantee a speedup. Never bend the measurement to fit the expectation.

**3. Baseline, then one index at a time.** Time the dashboard query from Task 1 (three runs, median, and save the `EXPLAIN QUERY PLAN`), then add the indexes **one by one**, re-running the query and the plan after each:

```sql
-- re-running the lab in a fresh session? reset the benchmark state first:
DROP INDEX IF EXISTS ix_orders_ordered_on;
DROP INDEX IF EXISTS ix_orderline_order;
DROP INDEX IF EXISTS ix_orderline_product;

CREATE INDEX ix_orders_ordered_on ON orders(ordered_on);
-- re-run the dashboard query 3x: median time + EXPLAIN QUERY PLAN

CREATE INDEX ix_orderline_order ON order_line(order_id);
-- re-run the dashboard query 3x: median time + EXPLAIN QUERY PLAN

CREATE INDEX ix_orderline_product ON order_line(product_id);
-- re-run the dashboard query 3x: median time + EXPLAIN QUERY PLAN
```

Record **two** observations per step: did the *plan* change, and did the *time* change? They are not the same question, and the interesting cases are the ones where they disagree.

**4. Now the query an index can actually win.** A single-day lookup reads a tiny slice of `orders`, so the plan change here is unambiguous:

```sql
.timer on
SELECT o.order_id, o.ordered_on, c.name
FROM orders o JOIN customer c ON c.customer_id = o.customer_id
WHERE o.ordered_on = '2026-02-14';      -- a single day: an index helps a lot here
```

Run it **before** and **after** `ix_orders_ordered_on` exists — compare the timing *and* the plan (no index: `SCAN orders`; with index: `SEARCH orders USING INDEX ix_orders_ordered_on`). This is the case where the index is unambiguous: an order-of-magnitude speedup and a plan you can point at.

**5. Name the index that does *not* help — and be precise about *which query* it does not help.** `ix_orderline_product` is never used by the dashboard query: the planner reaches `product` through its **primary key**. But try it against a query that filters on `ol.product_id` directly — suddenly the index *is* used. So "useless index" was the wrong conclusion; "useless *for this query*" was the right one. Two more honest negatives: `ix_orders_ordered_on` leaves this dashboard's plan untouched, and *any* index on `ordered_on` is ignored once a function wraps the column (`WHERE date(ordered_on) = …` still `SCAN`s — compare `ordered_on = …`).

> [!TIP]
> Put the measurement in a script (`Module03/bench.py`): loop over the queries, repeat each three times, print the medians. Then re-running the whole benchmark after every index is one command, the numbers stay comparable, and the file itself becomes your portfolio evidence.

*Portfolio evidence:* the before/after table (median of ≥3 runs per cell), the plan output that proves the index is used (`SEARCH ... USING INDEX`), the plan for the negative result, and your explanation of why that index does not help.

### ★ Task 3: The injection drill

Reproduce the support agent's apostrophe crash and then fix it. Save as `Module03/injection_demo.py`.

```python
"""Demonstrate SQL injection and its one correct fix: bound parameters."""
import sqlite3
from pathlib import Path

DB = Path(__file__).with_name("warehouse.db")
if not DB.exists():
    raise SystemExit(f"{DB} not found — run the Module 3 setup first")

conn = sqlite3.connect(DB)

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

*Portfolio evidence:* `Module03/injection_demo.py` output, the payload you used, and your answer about escaping-vs-parameterizing.

### ★ Task 4: One query, from algebra to plan

Take any query you wrote above and write its **relational algebra** expression (σ, π, ⋈, γ). Confirm the SQL matches the algebra. This is the checkpoint-ready skill: explaining a query in two representations.

### ◇ Task 5 (Stretcher): Window functions and a subquery rewrite

Start from this report — late orders per customer:

```sql
SELECT c.customer_id, c.name, COUNT(*) AS late_orders
FROM orders o
JOIN customer c ON c.customer_id = o.customer_id
WHERE o.status = 'late'
GROUP BY c.customer_id, c.name
ORDER BY late_orders DESC;
```

Rewrite it once with a correlated subquery and once with a window function (`COUNT(*) OVER (PARTITION BY ...)`). Compare the plans and the readability. Note which the LLM produced by default.

## 🔁 The harvest — two rounds per session

Our sessions run in **two 90-minute blocks with a 15-minute break**. Both halves end with the same five-minute habit; neither round is a task you can pass or fail.

### ☕ Round 1 — at the break (5 minutes, on the *previous* module)

Coffee in hand, one question per pod: **what from last time can you still explain without looking?**

Pick one item from the previous module — a construct, a definition, a query — and say it out loud to your pod. Today that means **Module 2**: take one line of that deliberately broken legacy schema and answer *what did this `CREATE TABLE` fail to guarantee, and what did that cost us later?* If there was a Python or SQL statement you nodded along to without really following it, this is the moment to ask.

- No writing, no slides, no points. This round should feel like a conversation, not a quiz.
- "Nobody in the pod can answer" is a perfectly good outcome — post it (see step 3 below).
- When we restart, one pod gives its best answer from memory in sixty seconds. That is the whole round.

### 🧺 Round 2 — at the end (5 minutes, on *today*)

1. **Each pod names two constructs:** one piece of SQL it now understands well enough to explain in a single sentence, and one it still finds opaque. Write both into `Module03/sql-notes.md`. The one sentence that made it click is the valuable half.
2. **Pair with a neighbouring pod** and try to answer each other's opaque one. Very often the answer is already in the other pod's notes — that is the point of asking someone who read the same scaffolding differently.
3. **Anything still open goes on the running list** in our Discord channel (`#sql-questions`), tagged with the module number.
4. **The next session opens by answering two of them** — not by the instructor, but by whoever put them there, or whoever thinks they know.

Why two rounds: retrieval works better **spaced**. Round 1 pulls the previous session back out of memory while it is starting to fade; Round 2 consolidates what just went in. Same five minutes each, very different job.

Why bother at all: this course hands you *generated* data all the time (here, in Module 5, and in the final project), and reading generated data is the same skill as reading somebody else's legacy schema in Module 2. A construct you can explain in one sentence is a construct you can also debug; one you skim past becomes the line you cannot fix at two in the morning. Your `sql-notes.md` is also exactly the kind of concise evidence that makes a checkpoint conversation easy.

## ✅ Suggested portfolio evidence (proofs of the learning goals)

- [ ] `Module03/setup.sql` — the setup script that builds `warehouse.db` (~240k order lines).
- [ ] The LLM prompt(s), the generated SQL, your predicted plan, and the actual `EXPLAIN QUERY PLAN` output.
- [ ] The index before/after benchmark table (median of ≥3 runs), `Module03/bench.py` if you wrote one, and the negative result with your explanation.
- [ ] `Module03/injection_demo.py` and its output, plus your escaping-vs-parameterizing answer.
- [ ] The relational-algebra expression for one query of your choice.
- [ ] `Module03/sql-notes.md` — your harvest notes: the construct you can explain, the one you cannot (yet), and the questions you posted.
- [ ] `Reflections/ref03.md` — the logbook entry for this block, using the [reflection template](https://github.com/iotempire/iot-portfolio-template/blob/main/Reflections/TEMPLATE.md) and explicitly addressing AI verification.
- [ ] (Stretcher) the window-function rewrite and its plan.

## 📚 If you want to go deeper

- **Goody — build SQL intuition:** the [SQL Island](https://sql-island.informatik.uni-kl.de/) game from the reminder above (you started it in Module 1) — an hour there makes you far better at spotting generated queries that “run but are wrong”. Siblings in the [resource bank](./Z-resources-bank.md#goody-sql-practice-games).
- SQLite — `EXPLAIN QUERY PLAN` reference — [sqlite.org/eqp.html](https://www.sqlite.org/eqp.html)
- Markus Winand — *Use The Index, Luke* — [use-the-index-luke.com](https://use-the-index-luke.com/)
- OWASP — *SQL Injection Prevention Cheat Sheet* — [cheatsheetseries.owasp.org](https://cheatsheetseries.owasp.org/cheatsheets/SQL_Injection_Prevention_Cheat_Sheet.html)
- Python — the `sqlite3` module and parameter binding — [docs.python.org/3/library/sqlite3.html](https://docs.python.org/3/library/sqlite3.html)

---

[← Previous: Module 2](./02-data-contracts-and-legacy-schemas.md) | [Back to front page](../README.md) | [Next: Module 4 →](./04-integrity-constraints-and-triggers.md)
