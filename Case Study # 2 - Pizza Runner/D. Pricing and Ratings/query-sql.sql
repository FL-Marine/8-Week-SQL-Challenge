SELECT
  table_name,
  column_name,
  data_type
FROM information_schema.columns
WHERE table_name = 'customer_orders';

--Result:
+──────────────────+──────────────+──────────────────────────────+
| table_name       | column_name  | data_type                    |
+──────────────────+──────────────+──────────────────────────────+
| customer_orders  | order_id     | integer                      |
| customer_orders  | customer_id  | integer                      |
| customer_orders  | pizza_id     | integer                      |
| customer_orders  | exclusions   | character varying            |
| customer_orders  | extras       | character varying            |
| customer_orders  | order_time   | timestamp without time zone  |
+──────────────────+──────────────+──────────────────────────────+
