CREATE TABLE customer(customer_id INTEGER PRIMARY KEY, name TEXT NOT NULL, city TEXT NOT NULL);
CREATE TABLE product (product_id INTEGER PRIMARY KEY, sku TEXT NOT NULL, price REAL NOT NULL);
CREATE TABLE orders  (order_id INTEGER PRIMARY KEY, customer_id INTEGER NOT NULL, ordered_on TEXT NOT NULL, status TEXT NOT NULL);
CREATE TABLE order_line(order_id INTEGER NOT NULL, product_id INTEGER NOT NULL, qty INTEGER NOT NULL);
WITH RECURSIVE n(x) AS (SELECT 1 UNION ALL SELECT x+1 FROM n WHERE x < 60000)
INSERT INTO customer(customer_id, name, city)
  SELECT x, 'Customer ' || x, CASE x % 4 WHEN 0 THEN 'Gütersloh' WHEN 1 THEN 'Bielefeld' WHEN 2 THEN 'Paderborn' ELSE 'Münster' END FROM n WHERE x <= 2000;
WITH RECURSIVE n(x) AS (SELECT 1 UNION ALL SELECT x+1 FROM n WHERE x < 500)
INSERT INTO product(product_id, sku, price) SELECT x, 'SKU-' || printf('%05d', x), 5 + (x % 90) * 1.5 FROM n;
WITH RECURSIVE n(x) AS (SELECT 1 UNION ALL SELECT x+1 FROM n WHERE x < 60000)
INSERT INTO orders(order_id, customer_id, ordered_on, status)
  SELECT x, (x % 2000) + 1, date('2025-01-01', '+' || (x % 540) || ' days'),
         CASE x % 5 WHEN 0 THEN 'late' WHEN 1 THEN 'open' ELSE 'shipped' END FROM n;
WITH RECURSIVE n(x) AS (SELECT 1 UNION ALL SELECT x+1 FROM n WHERE x < 240000)
INSERT INTO order_line(order_id, product_id, qty) SELECT (x % 60000) + 1, (x % 500) + 1, 1 + (x % 4) FROM n;
SELECT 'orders', COUNT(*) FROM orders UNION ALL SELECT 'lines', COUNT(*) FROM order_line;
EXPLAIN QUERY PLAN
SELECT c.city, COUNT(DISTINCT c.customer_id) AS customers, SUM(ol.qty * p.price) AS revenue
FROM customer c JOIN orders o ON o.customer_id=c.customer_id JOIN order_line ol ON ol.order_id=o.order_id
JOIN product p ON p.product_id=ol.product_id
WHERE o.ordered_on >= '2025-01-01' AND o.ordered_on < '2026-01-01'
GROUP BY c.city ORDER BY revenue DESC;
