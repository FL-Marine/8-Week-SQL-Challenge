## Entity Relationship Diagram
![image](https://user-images.githubusercontent.com/74512335/131252005-8a5091d2-527b-4395-8334-a45c0331d022.png)

**Link to ERD**: https://dbdiagram.io/d/5f3e085ccf48a141ff558487/?utm_source=dbdiagram_embed&utm_medium=bottom_open

## **Datasets** - All datasets exist within the pizza_runner database schema

**Table 1: runners**
The runners table shows the registration_date for each new runner

![image](https://user-images.githubusercontent.com/74512335/131252153-17bfd9ab-827f-427f-bb48-00a2fb72199e.png)

**Table 2: customer_orders**

- Customer pizza orders are captured in the customer_orders table with 1 row for each individual pizza that is part of the order.

- The pizza_id relates to the type of pizza which was ordered whilst the exclusions are the ingredient_id values which should be removed from the pizza and the extras are the ingredient_id values which need to be added to the pizza.

- Note that customers can order multiple pizzas in a single order with varying exclusions and extras values even if the pizza is the same type!

- The exclusions and extras columns will need to be cleaned up before using them in your queries.

![image](https://user-images.githubusercontent.com/74512335/131252232-fac52941-df94-418b-9f06-68b7bec50e92.png)

**Table 3: runner_orders**

 - After each orders are received through the system - they are assigned to a runner - however not all orders are fully completed and can be cancelled by the restaurant or the customer.

- The pickup_time is the timestamp at which the runner arrives at the Pizza Runner headquarters to pick up the freshly cooked pizzas. The distance and duration fields are related to how far and long the runner had to travel to deliver the order to the respective customer.

![image](https://user-images.githubusercontent.com/74512335/131252289-56aa57c9-b346-4c66-b8d2-d1f1c54375cf.png)

**Table 4: pizza_names**
At the moment - Pizza Runner only has 2 pizzas available the Meat Lovers or Vegetarian!

![image](https://user-images.githubusercontent.com/74512335/131252340-3b77436b-58cc-4783-9fd4-47455af3c7f8.png)

**Table 5: pizza_recipes**
Each pizza_id has a standard set of toppings which are used as part of the pizza recipe.

![image](https://user-images.githubusercontent.com/74512335/131252356-aac99096-cc55-474a-8bd2-0b158c146a66.png)

**Table 6: pizza_toppings**
This table contains all of the topping_name values with their corresponding topping_id value

![image](https://user-images.githubusercontent.com/74512335/131252371-a90175c7-7bbb-4979-a989-225fb9e003f8.png)

## Word of caution from Danny - "Before you start writing your SQL queries however - you might want to investigate the data, you may want to do something with some of those null values and data types in the customer_orders and runner_orders tables."

## Key tables to investigate need to check data types for each table
- **customer_orders**
- **runner_orders**

### Data type check - customer_orders
```sql
SELECT
  table_name,
  column_name,
  data_type
FROM information_schema.columns
WHERE table_name = 'customer_orders';
```
**Result:**
| table\_name      | column\_name | data\_type                  |
| ---------------- | ------------ | --------------------------- |
| customer\_orders | order\_id    | integer                     |
| customer\_orders | customer\_id | integer                     |
| customer\_orders | pizza\_id    | integer                     |
| customer\_orders | exclusions   | character varying           |
| customer\_orders | extras       | character varying           |
| customer\_orders | order\_time  | timestamp without time zone |

### Data type check - runner_orders
```sql
SELECT
  table_name,
  column_name,
  data_type
FROM information_schema.columns
WHERE table_name = 'runner_orders';
```
**Result:**
| table\_name    | column\_name | data\_type        |
| -------------- | ------------ | ----------------- |
| runner\_orders | order\_id    | integer           |
| runner\_orders | runner\_id   | integer           |
| runner\_orders | pickup\_time | character varying |
| runner\_orders | distance     | character varying |
| runner\_orders | duration     | character varying |
| runner\_orders | cancellation | character varying |

___

## Cleaning Tables
 ###  **1. customer_orders**
- exclusions & extras columns need to be cleaned 
- Need to update null values to be empty to indicate customers ordered no extras/exclusions
- Current 'null' results in exclusions & extras are not truly null they are be interpreted as strings.
```sql
DROP TABLE IF EXISTS customer_orders_table_cleaned;
CREATE TEMP TABLE customer_orders_table_cleaned AS (
  SELECT
    order_id,
    customer_id,
    pizza_id,
    CASE
      WHEN exclusions = '' THEN NULL
      WHEN exclusions = 'null' THEN NULL
      ELSE exclusions
    END AS exlcusions,
    CASE
      WHEN extras = '' THEN NULL
      WHEN extras = 'null' THEN NULL
      WHEN extras = 'Nan' THEN NULL
      ELSE extras
    END AS extras,
    order_time
  FROM
    pizza_runner.customer_orders
);

SELECT * FROM customer_orders_table_cleaned;
```
**New Table Result:**
| order\_id | customer\_id | pizza\_id | exlcusions | extras | order\_time              |
| --------- | ------------ | --------- | ---------- | ----- | ------------------------ |
| 1         | 101          | 1         |            |       | 2021-01-01T18:05:02.000Z |
| 2         | 101          | 1         |            |       | 2021-01-01T19:00:52.000Z |
| 3         | 102          | 1         |            |       | 2021-01-02T23:51:23.000Z |
| 3         | 102          | 2         |            |       | 2021-01-02T23:51:23.000Z |
| 4         | 103          | 1         | 4          |       | 2021-01-04T13:23:46.000Z |
| 4         | 103          | 1         | 4          |       | 2021-01-04T13:23:46.000Z |
| 4         | 103          | 2         | 4          |       | 2021-01-04T13:23:46.000Z |
| 5         | 104          | 1         |            | 1     | 2021-01-08T21:00:29.000Z |
| 6         | 101          | 2         |            |       | 2021-01-08T21:03:13.000Z |
| 7         | 105          | 2         |            | 1     | 2021-01-08T21:20:29.000Z |
| 8         | 102          | 1         |            |       | 2021-01-09T23:54:33.000Z |
| 9         | 103          | 1         | 4          | 1, 5  | 2021-01-10T11:22:59.000Z |
| 10        | 104          | 1         |            |       | 2021-01-11T18:34:49.000Z |
| 10        | 104          | 1         | 2, 6       | 1, 4  | 2021-01-11T18:34:49.000Z |

### **2. runner_orders**
- **Need to convert pickup_time, distance, and duration from character varying to integer**
- **Remove nulls where orders are cancelled**
- **null text needs to be null values**
- **distance and duration metrics need to be removed not consistent these columns are to be integers**
```sql
DROP TABLE IF EXISTS runner_orders_table_cleaned;
CREATE TEMP TABLE runner_orders_table_cleaned AS (
  SELECT
    order_id,
    runner_id,
    CASE
      WHEN pickup_time = 'null' THEN null
      ELSE pickup_time
    END :: timestamp AS pickup_time,
    --use NULLIF to handle blank string '' turns NULL if two expressions are equal, otherwise it returns the first expression.--
    NULLIF(REGEXP_REPLACE(distance, '[^0-9.]', '', 'g'), '') :: numeric AS distance,
    NULLIF(REGEXP_REPLACE(duration, '[^0-9.]', '', 'g'), '') :: numeric AS duration,
    /* ' to specify the regex
        [] generates any character inside range
        '' removes empty string
        'g' means global match and removes all matches*/
    CASE
      WHEN cancellation IN ('null', 'NaN', '') THEN null
      ELSE cancellation
    END AS cancellation
  FROM
    pizza_runner.runner_orders
);
SELECT * FROM runner_orders_table_cleaned;
  ```
**New Table Result:**
| order\_id | runner\_id | pickup\_time             | distance | duration | cancellation            |
| --------- | ---------- | ------------------------ | -------- | -------- | ----------------------- |
| 1         | 1          | 2021-01-01T18:15:34.000Z | 20       | 32       |                         |
| 2         | 1          | 2021-01-01T19:10:54.000Z | 20       | 27       |                         |
| 3         | 1          | 2021-01-03T00:12:37.000Z | 13.4     | 20       |                         |
| 4         | 2          | 2021-01-04T13:53:03.000Z | 23.4     | 40       |                         |
| 5         | 3          | 2021-01-08T21:10:57.000Z | 10       | 15       |                         |
| 6         | 3          |                          |          |          | Restaurant Cancellation |
| 7         | 2          | 2021-01-08T21:30:45.000Z | 25       | 25       |                         |
| 8         | 2          | 2021-01-10T00:15:02.000Z | 23.4     | 15       |                         |
| 9         | 2          |                          |          |          | Customer Cancellation   |
| 10        | 1          | 2021-01-11T18:50:20.000Z | 10       | 10       |                         |

___
# Verifying data types changes
 ###  **1. customer_orders**
 ```sql
 SELECT
  table_name,
  column_name,
  data_type
FROM information_schema.columns
WHERE table_name = 'customer_orders_table_cleaned';
```
**Result: No data types were changed**
| table\_name                      | column\_name | data\_type                  |
| -------------------------------- | ------------ | --------------------------- |
| customer\_orders\_table\_cleaned | order\_id    | integer                     |
| customer\_orders\_table\_cleaned | customer\_id | integer                     |
| customer\_orders\_table\_cleaned | pizza\_id    | integer                     |
| customer\_orders\_table\_cleaned | exlcusions   | character varying           |
| customer\_orders\_table\_cleaned | extras       | character varying           |
| customer\_orders\_table\_cleaned | order\_time  | timestamp without time zone |
 
 ### **2. runner_orders**
 ```sql
 SELECT
  table_name,
  column_name,
  data_type
FROM information_schema.columns
WHERE table_name = 'runner_orders_table_cleaned';
```
**Result: Changes below**
| table\_name                    | column\_name | data\_type                  |
| ------------------------------ | ------------ | --------------------------- |
| runner\_orders\_table\_cleaned | order\_id    | integer                     |
| runner\_orders\_table\_cleaned | runner\_id   | integer                     |
| runner\_orders\_table\_cleaned | pickup\_time | timestamp without time zone | 
| runner\_orders\_table\_cleaned | distance     | numeric                     |
| runner\_orders\_table\_cleaned | duration     | numeric                     |
| runner\_orders\_table\_cleaned | cancellation | character varying           |

- Changed from character varying to timestamp without time zone
- Changed from character varying to numeric
- Changed from character varying to numeric
___

# Case Study Questions & Solutions

**1. How many pizzas were ordered?**
```sql
SELECT COUNT(*) as pizza_orders
FROM customer_orders_table_cleaned;
```
**Result:**
| pizza\_orders |
| ------------- |
| 14            |

 **2. How many unique customer orders were made?**
 ```sql
 SELECT COUNT (DISTINCT order_id) AS order_count
FROM customer_orders_table_cleaned;
```
**Result:**
| order\_count  |
| ------------- |
| 10            |

**3.How many successful orders were delivered by each runner?**
```sql
SELECT
  runner_id,
  COUNT(order_id) AS successful_orders
FROM runner_orders_table_cleaned
WHERE cancellation IS NULL
OR cancellation NOT IN ('Restaurant Cancellation', 'Customer Cancellation')
GROUP BY runner_id
ORDER BY successful_orders DESC;
```
**Result:**
| runner\_id | successful\_orders |
| ---------- | ------------------ |
| 1          | 4                  |
| 2          | 3                  |
| 3          | 1                  |

**4. How many of each type of pizza was delivered?**
```sql
/*Need 3 tables 
1. customer_orders_table_cleaned AS t1
    Column - order_id
2. pizza_runner.pizza_names AS t2
    Column - pizza_id
3. runner_orders_table_cleaned AS t3
    Column - order_id*/
SELECT
  t2.pizza_name,
  COUNT(t1.*) AS delivered_pizza_counts
FROM
  customer_orders_table_cleaned AS t1
  INNER JOIN pizza_runner.pizza_names AS t2 ON t1.pizza_id = t2.pizza_id
  INNER JOIN runner_orders_table_cleaned AS t3 ON t3.order_id = t1.order_id
WHERE
  cancellation IS NULL
  OR cancellation NOT IN (
    'Restaurant Cancellation',
    'Customer Cancellation'
  )
GROUP BY
  t2.pizza_name
ORDER BY
  t2.pizza_name;
  ```
  **Result:**
  | pizza\_name | delivered\_pizza\_counts |
| ----------- | ------------------------ |
| Meatlovers  | 9                        |
| Vegetarian  | 3                        |

**5. How many Vegetarian and Meatlovers were ordered by each customer?**
```sql
SELECT 
customer_id,
  SUM(CASE WHEN pizza_id = 1 THEN 1 ELSE 0 END) AS meatlovers,
  SUM(CASE WHEN pizza_id = 2 THEN 2 ELSE 0 END) AS vegetarian
FROM  customer_orders_table_cleaned
GROUP BY customer_id
ORDER BY customer_id;
```
  **Result:**
  | customer\_id | meatlovers | vegetarian |
| ------------ | ---------- | ---------- |
| 101          | 2          | 2          |
| 102          | 2          | 2          |
| 103          | 3          | 2          |
| 104          | 3          | 0          |
| 105          | 0          | 2          |

**6. What was the maximum number of pizzas delivered in a single order?**
```sql
WITH max_pizza_order AS (
  SELECT
      t1.order_id,
    COUNT(pizza_id) AS max_count
  FROM customer_orders_table_cleaned AS t1
  INNER JOIN runner_orders_table_cleaned AS t2
    ON t1.order_id = t2.order_id
  WHERE 
    t2.cancellation is NULL
  OR
    t2.cancellation NOT IN ('Restaurant Cancellation', 'Customer Cancellation')
  GROUP BY t1.order_id
  ORDER BY max_count DESC
  LIMIT 1
)
SELECT order_id, max_count FROM max_pizza_order WHERE max_count > 1;
```
 **Result:**
| order\_id | max\_count |
| --------- | ---------- |
| 4         | 3          |

**7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?**
```sql
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
```
 **Result:**
 | customer\_id | changes | no\_changes |
| ------------ | ------- | ----------- |
| 101          | 0       | 2           |
| 102          | 0       | 3           |
| 103          | 3       | 0           |
| 104          | 2       | 1           |
| 105          | 1       | 0           |

**8. How many pizzas were delivered that had both exclusions and extras?**
```sql
SELECT COUNT(*) AS delievered_exclusions_extras
  FROM customer_orders_table_cleaned AS co
  INNER JOIN runner_orders_table_cleaned as ro
  ON
  co.order_id = ro.order_id
WHERE cancellation is NULL
  AND (extras IS NOT NULL AND exlcusions IS NOT NULL);
  ```
  **Result:**
| delievered\_exclusions\_extras |
| ------------------------------ |
| 1                              |

**9. What was the total volume of pizzas ordered for each hour of the day?**
```sql
SELECT
  DATE_PART('HOUR', order_time::TIMESTAMP) AS hour_of_the_day,
  COUNT(*) AS pizza_count
FROM customer_orders_table_cleaned
GROUP BY hour_of_the_day
ORDER BY hour_of_the_day;
```
**Result:**
| hour\_of\_the\_day | pizza\_count |
| ------------------ | ------------ |
| 11                 | 1            |
| 13                 | 3            |
| 18                 | 3            |
| 19                 | 1            |
| 21                 | 3            |
| 23                 | 3            |

**10. What was the volume of orders for each day of the week**
```sql
SELECT
  TO_CHAR(order_time, 'Day') AS day_of_week,
  COUNT(*) AS pizza_count
FROM
  customer_orders_table_cleaned
GROUP BY
  day_of_week,
  DATE_PART('dow', order_time)
ORDER BY
  day_of_week;
  ```
  **Result:**
  | day\_of\_week | pizza\_count |
| ------------- | ------------ |
| Friday        | 5            |
| Monday        | 5            |
| Saturday      | 3            |
| Sunday        | 1            |
