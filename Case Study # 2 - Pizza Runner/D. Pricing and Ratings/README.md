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

**1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?**
```sql
SELECT
  SUM(
    CASE
      WHEN pizza_id = 1 THEN 12
      ELSE 10
    END
  ) AS revenue
FROM
  customer_orders_table_cleaned;
  ```
**Result:**
| revenue |
| ------- |
| 160     |

**2. What if there was an additional $1 charge for any pizza extras?**
 - Add cheese is $1 extra
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
    ROW_NUMBER() OVER () AS original_row_number
  FROM pizza_runner.customer_orders
  WHERE EXISTS (
    SELECT 1 FROM pizza_runner.runner_orders
    WHERE customer_orders.order_id = runner_orders.order_id
      AND runner_orders.pickup_time  IS NOT NULL
      -- Changed = 'null' to IS NOT NULL--
  )
)
SELECT
  SUM(
    CASE
      WHEN pizza_id = 1 THEN 12
      WHEN pizza_id = 2 THEN 10
      END -
    -- we can use CARDINALITY to find the length of array of extras
    COALESCE(
      CARDINALITY(REGEXP_SPLIT_TO_ARRAY(extras, '[,\s]+')),
      0
    )
  ) AS cost
FROM cte_cleaned_customer_orders;

# There are 2 errors but I only found 1.
```
**Result:**
| cost |
| ------- |
| 154     |

**3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.**

**4. Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?**

- customer_id
- order_id
- runner_id
- rating
- order_time
- pickup_time
- Time between order and pickup
- Delivery duration
- Average speed
- Total number of pizzas

**5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?**
