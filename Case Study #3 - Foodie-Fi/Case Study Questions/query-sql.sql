
SELECT
  SUM(
    CASE
      WHEN pizza_id = 1 THEN 12
      ELSE 10
    END
  ) AS revenue
FROM
  customer_orders_table_cleaned;
