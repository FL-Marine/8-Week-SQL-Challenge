SELECT 
  coc.customer_id,
  SUM(CASE WHEN exlcusions IS NOT NULL OR extras IS NOT NULL THEN 1 ELSE 0 END) AS changes,
  SUM(CASE WHEN exlcusions IS NULL AND extras IS NULL THEN 1 ELSE 0 END) AS no_changes
FROM customer_orders_table_cleaned AS coc
INNER JOIN runner_orders_table_cleaned AS roc 
  ON coc.order_id = roc.order_id
WHERE roc.cancellation IS NULL
  OR roc.cancellation NOT IN  ('Restaurant Cancellation', 'Customer Cancellation')
GROUP BY coc.customer_id
ORDER BY coc.customer_id;
