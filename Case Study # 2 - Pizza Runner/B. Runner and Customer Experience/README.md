## Entity Relationship Diagram
![image](https://user-images.githubusercontent.com/74512335/131252005-8a5091d2-527b-4395-8334-a45c0331d022.png)

**Link to ERD**: https://dbdiagram.io/d/5f3e085ccf48a141ff558487/?utm_source=dbdiagram_embed&utm_medium=bottom_open

## **Datasets** - All datasets exist within the pizza_runner database schema

<details>
<summary>Table 1: runners</summary>
The runners table shows the registration_date for each new runner

 ![image](https://user-images.githubusercontent.com/74512335/131252153-17bfd9ab-827f-427f-bb48-00a2fb72199e.png)
 </details>

 <details>
 <summary>Table 2: customer_orders</summary>
   
  1. Cutomer pizza orders are captured in the customer_orders table with 1 row for each individual pizza that is part of the order.
 
  2. The pizza_id relates to the type of pizza which was ordered whilst the exclusions are the ingredient_id values which should be removed from the pizza and the extras are the ingredient_id values which need to be added to the pizza.
 
  3. Note that customers can order multiple pizzas in a single order with varying exclusions and extras values even if the pizza is the same type!
 
  4. The exclusions and extras columns will need to be cleaned up before using them in your queries.
 
 ![image](https://user-images.githubusercontent.com/74512335/131252232-fac52941-df94-418b-9f06-68b7bec50e92.png)   
</details>


<details>
  <summary>Table 3: runner_orders</summary>
   
   1. After each orders are received through the system - they are assigned to a runner - however not all orders are fully completed and can be cancelled by the restaurant or the customer.
  
   2. The pickup_time is the timestamp at which the runner arrives at the Pizza Runner headquarters to pick up the freshly cooked pizzas. The distance and duration fields are related to how far and long the runner had to travel to deliver the order to the respective customer.

![image](https://user-images.githubusercontent.com/74512335/131252289-56aa57c9-b346-4c66-b8d2-d1f1c54375cf.png)
</details>
 
 <details>
<summary>Table 4: pizza_names</summary>

At the moment - Pizza Runner only has 2 pizzas available the Meat Lovers or Vegetarian!

![image](https://user-images.githubusercontent.com/74512335/131252340-3b77436b-58cc-4783-9fd4-47455af3c7f8.png)
</details>

<details>
<summary>Table 5: pizza_recipes</summary>

Each pizza_id has a standard set of toppings which are used as part of the pizza recipe.

![image](https://user-images.githubusercontent.com/74512335/131252356-aac99096-cc55-474a-8bd2-0b158c146a66.png)
</details>
 
<details>
<summary>Table 6: pizza_toppings</summary>

 This table contains all of the topping_name values with their corresponding topping_id value

![image](https://user-images.githubusercontent.com/74512335/131252371-a90175c7-7bbb-4979-a989-225fb9e003f8.png)
</details>

## Word of caution from Danny - "Before you start writing your SQL queries however - you might want to investigate the data, you may want to do something with some of those null values and data types in the customer_orders and runner_orders tables."

## Key tables to investigate need to check data types for each table
- **customer_orders**
- **runner_orders**

<details>
<summary> Data type check - customer_orders</summary>

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
 </details>

<details>
<summary> Data type check - runner_orders</summary>

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
 </details>
_________________________________________________________________________________________________________________________________________________

# Cleaning Tables

<details>
<summary>customer_orders</summary>

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
</details>

<details>
<summary> 2. runner_orders</summary>
 
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
</details>
_________________________________________________________________________________________________________________________________________________

# Verifying data types changes
 <details>
<summary>1. customer_orders</summary>
 
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
 </details>
 
 <details>
<summary> 2. runner_orders</summary>

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
</details>
 _________________________________________________________________________________________________________________________________________________


# Case Study Questions & Solutions

1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
```sql
/* Using 'month with DATE_TRUNC was not giving me the approriate output so I decided to try using 'week'*/

SELECT DATE_TRUNC('month', DATE '2021-01-01'),
COUNT(*) AS runners
FROM pizza_runner.runners;
```
**Result:**
| date\_trunc              | runners |
| ------------------------ | ------- |
| 2021-01-01T00:00:00.000Z | 4       |

```sql
/*I noticed that the beginning of the target date is 2020-12-28
which tells me that 2021-01-01 does not start on a Monday.*/

SELECT DATE_TRUNC('week', DATE '2021-01-01'),
COUNT(*) AS runners
FROM pizza_runner.runners;
```
**Result:**
| date\_trunc              | runners |
| ------------------------ | ------- |
| 2020-12-28T00:00:00.000Z | 4       |

```sql
/*I could of easily just went to the calender on my laptop and figured out what day of week
2020-12-28 & and 2021-01-01 fall on but I wanted to practied extracting the day of the week.*/

SELECT
  EXTRACT(DOW FROM DATE '2020-12-28'), 
  TO_CHAR(DATE '2020-12-28', 'Day') AS Dec_28_2020
  ```
**Result:**
| date\_part | dec\_28\_2020 |
| ---------- | ------------- |
| 1          | Monday        |

```sql
SELECT
  EXTRACT(DOW FROM DATE '2021-01-01'),
  TO_CHAR(DATE '2021-01-01', 'Day') AS Jan_01_2021
```
**Result:**
| date\_part | jan\_01\_2021 |
| ---------- | ------------- |
| 5          | Friday        |

```sql
SELECT 
  DATE_TRUNC('week', registration_date)::DATE + 4 AS registration_week,
  COUNT(*) AS runners
FROM pizza_runner.runners
GROUP BY registration_week
ORDER BY registration_week;
/*The issue was that with DATE_TRUNC the default day starts on Monday as 1 but 2021-01-01 is a Friday which is Day 5.*/
```
**Result:**
| registration\_week       | runners |
| ------------------------ | ------- |
| 2021-01-01T00:00:00.000Z | 2       |
| 2021-01-08T00:00:00.000Z | 1       |
| 2021-01-15T00:00:00.000Z | 1       |

**2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?**
```sql
WITH cte_pickup_minutes AS (
  SELECT DISTINCT
    runner_id,
    t1.order_id,
    DATE_PART('minute', AGE(t1.pickup_time::TIMESTAMP, t2.order_time::TIMESTAMP))::INTEGER AS pickup_minutes
  FROM pizza_runner.runner_orders AS t1
  INNER JOIN pizza_runner.customer_orders AS t2
    ON t1.order_id = t2.order_id
  WHERE t1.pickup_time != 'null'
)
SELECT
  runner_id,
  ROUND(AVG(pickup_minutes), 3) AS avg_pickup_minutes
FROM cte_pickup_minutes
GROUP by runner_id
ORDER BY runner_id ASC;
```
**Result:**
| runner\_id | avg\_pickup\_minutes |
| ---------- | -------------------- |
| 1          | 14.000               |
| 2          | 19.667               |
| 3          | 10.000               |

**3. Is there any relationship between the number of pizzas and how long the order takes to prepare?**
```sql
/*Original Code*/
SELECT DISTINCT
  t1.order_id,
  DATE_PART('min', AGE(t1.pickup_time::TIMESTAMP, t2.order_time))::INTEGER AS pickup_minutes,
  SUM(t2.order_id) AS pizza_count
FROM pizza_runner.runner_orders AS t1
INNER JOIN pizza_runner.customer_orders AS t2
  ON t1.runner_id = t2.order_id
WHERE t1.pickup_time != 'null'
GROUP BY t1.order_id, pickup_minutes
ORDER BY pizza_count;
```
**Result:**
| order\_id | pickup\_minutes | pizza\_count |
| --------- | --------------- | ------------ |
| 1         | 10              | 1            |
| 2         | 5               | 1            |
| 3         | 7               | 1            |
| 10        | 45              | 1            |
| 4         | 52              | 2            |
| 7         | 29              | 2            |
| 8         | 14              | 2            |
| 5         | 19              | 6            |

```sql
/*I decided to find the errors for the above code by changing the SUM to COUNT 
and the join from t1.pickup_time to t1.order_id.*/
SELECT DISTINCT
  t1.order_id,
  DATE_PART('min', AGE(t1.pickup_time::TIMESTAMP, t2.order_time))::INTEGER AS pickup_minutes,
  COUNT(t2.order_id) AS pizza_count
FROM pizza_runner.runner_orders AS t1
INNER JOIN pizza_runner.customer_orders AS t2
  ON t1.order_id = t2.order_id
WHERE t1.pickup_time != 'null'
GROUP BY t1.order_id, pickup_minutes
ORDER BY pizza_count, order_id;
```
**Result:**
| order\_id | pickup\_minutes | pizza\_count |
| --------- | --------------- | ------------ |
| 1         | 10              | 1            |
| 2         | 10              | 1            |
| 5         | 10              | 1            |
| 7         | 10              | 1            |
| 8         | 20              | 1            |
| 3         | 21              | 2            |
| 10        | 15              | 2            |
| 4         | 29              | 3            |

**4. What was the average distance travelled for each customer?**
```sql
SELECT
  co.customer_id,
  ROUND(AVG(distance), 1) AS avg_distance
FROM
  customer_orders_table_cleaned AS co
  INNER JOIN runner_orders_table_cleaned AS ro ON co.order_id = ro.order_id
GROUP BY
  customer_id
ORDER BY
   customer_id;
   ```
**Result:**
| customer\_id | avg\_distance |
| ------------ | ------------- |
| 101          | 20.0          |
| 102          | 16.7          |
| 103          | 23.4          |
| 104          | 10.0          |
| 105          | 25.0          |

**5. What was the difference between the longest and shortest delivery times for all orders?**
```sql
SELECT
 MAX(duration) - MIN(duration) AS max_difference
FROM
   runner_orders_table_cleaned AS ro;
```
**Result:**
| max\_difference |
| --------------- |
| 30              |

**6. What was the average speed for each runner for each delivery and do you notice any trend for these values?** 
```sql
SELECT
  co.customer_id,
  ro.runner_id,
  co.order_id,
  COUNT(co.order_id) AS pizza_count,
  DATE_PART('hour', pickup_time :: TIMESTAMP) AS hour_of_day,
  distance,
  duration,
  ROUND(AVG(distance / duration * 60), 2) AS avg_speed
FROM
  customer_orders_table_cleaned AS co
  INNER JOIN runner_orders_table_cleaned AS ro ON co.order_id = ro.order_id
WHERE
  pickup_time IS NOT NULL
GROUP BY
  co.customer_id,
  ro.runner_id,
  co.order_id,
  ro.pickup_time,
  distance,
  duration
ORDER BY
  runner_id, avg_speed DESC;

/*Observations
Runner 1 has the most orders qty 6
Runner 2 has 5 orders
Runner 3 has 1 order

Runner 1 most has orders late in the day
Runner 2 has late orders as well and the fastest being around midnight most
likely due to no traffic
Runner 3 needs to pick up more orders is not deliverying enough

Overall, most orders are ran in the evenings could potentially have marketing times during those hours
or make a delivery happy hour to increase the quantity of orders./*
```
**Result:**
| customer\_id | runner\_id | order\_id | pizza\_count | hour\_of\_day | distance | duration | avg\_speed |
| ------------ | ---------- | --------- | ------------ | ------------- | -------- | -------- | ---------- |
| 104          | 1          | 10        | 2            | 18            | 10       | 10       | 60.00      |
| 101          | 1          | 2         | 1            | 19            | 20       | 27       | 44.44      |
| 102          | 1          | 3         | 2            | 0             | 13.4     | 20       | 40.20      |
| 101          | 1          | 1         | 1            | 18            | 20       | 32       | 37.50      |
| 102          | 2          | 8         | 1            | 0             | 23.4     | 15       | 93.60      |
| 105          | 2          | 7         | 1            | 21            | 25       | 25       | 60.00      |
| 103          | 2          | 4         | 3            | 13            | 23.4     | 40       | 35.10      |
| 104          | 3          | 5         | 1            | 21            | 10       | 15       | 40.00      |

**7. What is the successful delivery percentage for each runner?**
 ```sql
 SELECT
  runner_id,
  COUNT(order_id) AS orders,
  COUNT(pickup_time) AS delivered,
  ROUND(100 * COUNT(pickup_time) / COUNT(order_id)) AS success_percentage
FROM
  runner_orders_table_cleaned
GROUP BY
  runner_id
ORDER BY
  runner_id;
  ```
  **Result:**
  | runner\_id | orders | delivered | success\_percentage |
| ---------- | ------ | --------- | ------------------- |
| 1          | 4      | 4         | 100                 |
| 2          | 4      | 3         | 75                  |
| 3          | 2      | 1         | 50                  |
