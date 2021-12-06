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



+───────────+──────────────+───────────+───────────────────────────+─────────────+
| order_id  | customer_id  | pizza_id  | order_time                | pizza_name  |
+───────────+──────────────+───────────+───────────────────────────+─────────────+
| 1         | 101          | 1         | 2021-01-01T18:05:02.000Z  | Meatlovers  |
| 2         | 101          | 1         | 2021-01-01T19:00:52.000Z  | Meatlovers  |
| 3         | 102          | 1         | 2021-01-02T23:51:23.000Z  | Meatlovers  |
| 3         | 102          | 2         | 2021-01-02T23:51:23.000Z  | Vegetarian  |
| 4         | 103          | 1         | 2021-01-04T13:23:46.000Z  | Meatlovers  |
| 4         | 103          | 1         | 2021-01-04T13:23:46.000Z  | Meatlovers  |
| 4         | 103          | 2         | 2021-01-04T13:23:46.000Z  | Vegetarian  |
| 5         | 104          | 1         | 2021-01-08T21:00:29.000Z  | Meatlovers  |
| 6         | 101          | 2         | 2021-01-08T21:03:13.000Z  | Vegetarian  |
| 7         | 105          | 2         | 2021-01-08T21:20:29.000Z  | Vegetarian  |
| 8         | 102          | 1         | 2021-01-09T23:54:33.000Z  | Meatlovers  |
| 9         | 103          | 1         | 2021-01-10T11:22:59.000Z  | Meatlovers  |
| 9         | 103          | 1         | 2021-01-10T11:22:59.000Z  | Meatlovers  |
| 10        | 104          | 1         | 2021-01-11T18:34:49.000Z  | Meatlovers  |
| 10        | 104          | 1         | 2021-01-11T18:34:49.000Z  | Meatlovers  |
| 10        | 104          | 1         | 2021-01-11T18:34:49.000Z  | Meatlovers  |
+───────────+──────────────+───────────+───────────────────────────+─────────────+



| order_id | customer_id | pizza_id | order_time               | pizza_name |
|----------|-------------|----------|--------------------------|------------|
| 1        | 101         | 1        | 2021-01-01T18:05:02.000Z | Meatlovers |
| 2        | 101         | 1        | 2021-01-01T19:00:52.000Z | Meatlovers |
| 3        | 102         | 1        | 2021-01-02T23:51:23.000Z | Meatlovers |
| 3        | 102         | 2        | 2021-01-02T23:51:23.000Z | Vegetarian |
| 4        | 103         | 1        | 2021-01-04T13:23:46.000Z | Meatlovers |
| 4        | 103         | 1        | 2021-01-04T13:23:46.000Z | Meatlovers |
| 4        | 103         | 2        | 2021-01-04T13:23:46.000Z | Vegetarian |
| 5        | 104         | 1        | 2021-01-08T21:00:29.000Z | Meatlovers |
| 6        | 101         | 2        | 2021-01-08T21:03:13.000Z | Vegetarian |
| 7        | 105         | 2        | 2021-01-08T21:20:29.000Z | Vegetarian |
| 8        | 102         | 1        | 2021-01-09T23:54:33.000Z | Meatlovers |
| 9        | 103         | 1        | 2021-01-10T11:22:59.000Z | Meatlovers |
| 9        | 103         | 1        | 2021-01-10T11:22:59.000Z | Meatlovers |
| 10       | 104         | 1        | 2021-01-11T18:34:49.000Z | Meatlovers |
| 10       | 104         | 1        | 2021-01-11T18:34:49.000Z | Meatlovers |
| 10       | 104         | 1        | 2021-01-11T18:34:49.000Z | Meatlovers |

