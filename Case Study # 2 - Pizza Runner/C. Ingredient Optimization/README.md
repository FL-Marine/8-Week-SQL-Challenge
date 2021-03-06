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

**1. What are the standard ingredients for each pizza?**
```sql
--Original Code--
WITH cte_split_pizza_names AS (
  SELECT
    pizza_id,
    REGEXP_SPLIT_TO_TABLE(toppings, '[,\s]+') :: INTEGER AS topping_id
  FROM
    pizza_runner.pizza_recipes
)
SELECT
  pizza_id,
  STRING_AGG(t1.topping_id :: TEXT, '') AS standard_ingredients
FROM
  cte_split_pizza_names AS t1
  INNER JOIN pizza_runner.pizza_toppings AS t2 ON t1.topping_id = t2.topping_id
GROUP BY
  pizza_id
ORDER BY
  pizza_id;

--Debugged Code--
  WITH cte_split_pizza_names AS (
    SELECT
      pizza_id,
      REGEXP_SPLIT_TO_TABLE(toppings, '[,\s]+') :: INTEGER AS topping_id
    FROM
      pizza_runner.pizza_recipes
  )
SELECT
  t1.pizza_id,
  t3.pizza_name,
  STRING_AGG(t2.topping_name :: TEXT, ', ') AS standard_ingredients
FROM
  cte_split_pizza_names AS t1
  INNER JOIN pizza_runner.pizza_toppings AS t2 ON t1.topping_id = t2.topping_id
  INNER JOIN pizza_runner.pizza_names AS t3 ON t1.pizza_id = t3.pizza_id
GROUP BY
  t1.pizza_id,
  t3.pizza_name
ORDER BY
  t1.pizza_id;
--Code debugging changes--
  /*
  - INNER JOIN pizza_names table (t3) to get the names 
  - Changed STRING_AGG(t1.topping_id::TEXT, '') 
  to  STRING_AGG(t2.topping_name::TEXT, ',') /*
  ```
**Result:**
  | pizza\_id | pizza\_name | standard\_ingredients                                               |
| --------- | ----------- | --------------------------------------------------------------------- |
| 1         | Meatlovers  | BBQ Sauce, Pepperoni, Cheese, Salami, Chicken, Bacon, Mushrooms, Beef |
| 2         | Vegetarian  | Tomato Sauce, Cheese, Mushrooms, Onions, Peppers, Tomatoes            |

**2. What was the most commonly added extra?**
```sql
--Original Code--
WITH cte_extras AS (
SELECT
  REGEXP_SPLIT_TO_TABLE(extras, '[,\s]+')::INTEGER AS topping_id
FROM pizza_runner.customer_orders
WHERE extras IS NULL AND extras IN ('null', '')
)
SELECT
  topping_name,
  COUNT(*) AS extras_count
FROM cte_extras
INNER JOIN pizza_runner.pizza_toppings
  ON cte_extras.topping_id = pizza_toppings.topping_id
GROUP BY topping_name
ORDER BY extras_count DESC;

--Debugged Code--
WITH cte_extras AS (
SELECT
  REGEXP_SPLIT_TO_TABLE(extras, '[,\s]+')::INTEGER AS topping_id
FROM pizza_runner.customer_orders
WHERE extras IS NOT NULL AND extras NOT IN ('null', '')
)
SELECT
  topping_name,
  COUNT(*) AS extras_count
FROM cte_extras
INNER JOIN pizza_runner.pizza_toppings
  ON cte_extras.topping_id = pizza_toppings.topping_id
GROUP BY topping_name
ORDER BY extras_count DESC;
  /*
  - Original code has no ouput
  - Changed the WHERE clause to IS NOT NULL AND extras NOT IN*/
  ```
**Result:**
| topping\_name | extras\_count |
| ------------- | ------------- |
| Bacon         | 4             |
| Chicken       | 1             |
| Cheese        | 1             |

**3. What was the most common exclusion?**
``` sql
--Original Code--
WITH cte_exclusions AS (
SELECT
  REGEXP_SPLIT_TO_TABLE(exclusions, '[,\s]+')::INTEGER AS topping_id
FROM pizza_runner.customer_orders
WHERE exclusions IS NULL AND exclusions NOT IN ('null', '')
)
SELECT
  topping_name,
  COUNT(*) AS exclusions_count
FROM cte_exclusions
INNER JOIN pizza_runner.pizza_toppings
  ON cte_exclusions.topping_id = pizza_toppings.topping_id
GROUP BY topping_name
ORDER BY exclusions_count;

--Debugged Code--
WITH cte_exclusions AS (
SELECT
  REGEXP_SPLIT_TO_TABLE(exclusions, '[,\s]+')::INTEGER AS topping_id
FROM pizza_runner.customer_orders
WHERE exclusions IS NOT NULL AND exclusions NOT IN ('null', '')
)
SELECT
  topping_name,
  COUNT(*) AS exclusions_count
FROM cte_exclusions
INNER JOIN pizza_runner.pizza_toppings
  ON cte_exclusions.topping_id = pizza_toppings.topping_id
GROUP BY topping_name
ORDER BY exclusions_count DESC;
  /*
  - Original code has no ouput
  - Changed the WHERE clause to IS NOT NULL
  - Added DESC to the ORDER BY clause to see the most excluded topping*/
  ```
 **Result:** 
| topping\_name | exclusions\_count |
| ------------- | ----------------- |
| Cheese        | 4                 |
| Mushrooms     | 1                 |
| BBQ Sauce     | 1                 |

**4. Generate an order item for each record in the customers_orders table in the format of one of the following:**

- Meat Lovers

- Meat Lovers - Exclude Beef

- Meat Lovers - Extra Bacon

- Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
```sql
WITH order_item_table AS (
SELECT 
  order_id, 
  customer_id,
  pizza_id,
  order_time,
  REGEXP_SPLIT_TO_TABLE(extras, '[,\s]+') :: text AS topping_id,
  REGEXP_SPLIT_TO_TABLE(exclusions, '[,\s]+') :: text AS exclusions
FROM pizza_runner.customer_orders
ORDER BY order_id
)
SELECT
  order_id,
  customer_id,
  oit2.pizza_id,
  order_time,
 pizza_name 
 --|| exclusions || oit2.topping_id AS order_item--
  --topping_name--
 -- oit2.topping_id,--
 -- exclusions--,
FROM order_item_table AS oit2
INNER JOIN pizza_runner.pizza_names AS PN
  ON oit2.pizza_id = PN.pizza_id
LEFT JOIN pizza_runner.pizza_toppings AS PT
  ON oit2.topping_id = pt.topping_id::text
  ```
 **Result:** 
 | order\_id | customer\_id | pizza\_id | order\_time              | pizza\_name |
| --------- | ------------ | --------- | ------------------------ | ----------- |
| 1         | 101          | 1         | 2021-01-01T18:05:02.000Z | Meatlovers  |
| 2         | 101          | 1         | 2021-01-01T19:00:52.000Z | Meatlovers  |
| 3         | 102          | 1         | 2021-01-02T23:51:23.000Z | Meatlovers  |
| 3         | 102          | 2         | 2021-01-02T23:51:23.000Z | Vegetarian  |
| 4         | 103          | 1         | 2021-01-04T13:23:46.000Z | Meatlovers  |
| 4         | 103          | 1         | 2021-01-04T13:23:46.000Z | Meatlovers  |
| 4         | 103          | 2         | 2021-01-04T13:23:46.000Z | Vegetarian  |
| 5         | 104          | 1         | 2021-01-08T21:00:29.000Z | Meatlovers  |
| 6         | 101          | 2         | 2021-01-08T21:03:13.000Z | Vegetarian  |
| 7         | 105          | 2         | 2021-01-08T21:20:29.000Z | Vegetarian  |
| 8         | 102          | 1         | 2021-01-09T23:54:33.000Z | Meatlovers  |
| 9         | 103          | 1         | 2021-01-10T11:22:59.000Z | Meatlovers  |
| 9         | 103          | 1         | 2021-01-10T11:22:59.000Z | Meatlovers  |
| 10        | 104          | 1         | 2021-01-11T18:34:49.000Z | Meatlovers  |
| 10        | 104          | 1         | 2021-01-11T18:34:49.000Z | Meatlovers  |
| 10        | 104          | 1         | 2021-01-11T18:34:49.000Z | Meatlovers  |
 
**5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients**

- For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"

**6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?**
```sql
WITH cte_cleaned_customer_orders AS (
  SELECT
    order_id,
    customer_id,
    pizza_id,
    CASE
      WHEN exclusions IN ('', 'null') THEN NULL
      ELSE exclusions
    END AS exclusions,
    CASE
      WHEN extras IN ('', 'null') THEN NULL
      ELSE extras
    END AS extras,
    order_time,
    RANK() OVER () AS original_row_number
  FROM pizza_runner.customer_orders
),
-- split the toppings using our previous solution
cte_regular_toppings AS (
SELECT
  pizza_id,
  REGEXP_SPLIT_TO_TABLE(toppings, '[,\s]+')::INTEGER AS topping_id
FROM pizza_runner.pizza_recipes
),
-- now we can should left join our regular toppings with all pizzas orders
cte_base_toppings AS (
  SELECT
    cte_cleaned_customer_orders.order_id,
    cte_cleaned_customer_orders.customer_id,
    cte_cleaned_customer_orders.pizza_id,
    cte_cleaned_customer_orders.order_time,
    cte_cleaned_customer_orders.original_row_number,
    cte_regular_toppings.topping_id
  FROM cte_cleaned_customer_orders
  LEFT JOIN cte_regular_toppings
    ON cte_cleaned_customer_orders.pizza_id = cte_regular_toppings.pizza_id
),
-- now we can generate CTEs for exclusions and extras by the original row number
cte_exclusions AS (
  SELECT
    order_id,
    customer_id,
    pizza_id,
    order_time,
    original_row_number,
    REGEXP_SPLIT_TO_TABLE(exclusions, '[,\s]+')::INTEGER AS topping_id
  FROM cte_cleaned_customer_orders
  WHERE exclusions IS NOT NULL
),
-- check this one!
cte_extras AS (
  SELECT
    order_id,
    customer_id,
    pizza_id,
    order_time,
    original_row_number,
    REGEXP_SPLIT_TO_TABLE(extras, '[,\s]+')::INTEGER AS topping_id
  FROM cte_cleaned_customer_orders
  WHERE extras IS NOT NULL
  
  --Changed from NULL to IS NOT NULL--
),
-- now we can perform an except and a union all on the respective CTEs
-- also check this one!
cte_combined_orders AS (
  SELECT * FROM cte_base_toppings
  UNION ALL
  SELECT * FROM cte_exclusions
  UNION ALL
  SELECT * FROM cte_extras
)
-- perform aggregation on topping_id and join to get topping names
SELECT
  t2.topping_name,
  COUNT(*) AS topping_count
FROM cte_combined_orders AS t1
INNER JOIN pizza_runner.pizza_toppings AS t2
  ON t1.topping_id = t2.topping_id
GROUP BY t2.topping_name
ORDER BY topping_name;

-- Changed from ORDER BY topping_count to topping_name--

--Was only able to find 2 errors--
```
 **Result:** 
 | topping\_name | topping\_count |
| ------------- | -------------- |
| Bacon         | 14             |
| BBQ Sauce     | 11             |
| Beef          | 10             |
| Cheese        | 19             |
| Chicken       | 11             |
| Mushrooms     | 15             |
| Onions        | 4              |
| Pepperoni     | 10             |
| Peppers       | 4              |
| Salami        | 10             |
| Tomatoes      | 4              |
| Tomato Sauce  | 4              |
