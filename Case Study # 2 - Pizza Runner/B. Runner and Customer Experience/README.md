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

# Case Study Questions & Solutions

**1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)**
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
/* I noticed that the beginning of the target date is 2020-12-28
which tells me that 2021-01-01 does not start on a Monday. */

SELECT DATE_TRUNC('week', DATE '2021-01-01'),
COUNT(*) AS runners
FROM pizza_runner.runners;
```
**Result:**
| date\_trunc              | runners |
| ------------------------ | ------- |
| 2020-12-28T00:00:00.000Z | 4       |

```sql
/* I could of easily just went to the calender on my laptop and figured out what day of week
2020-12-28 & and 2021-01-01 fall on but I wanted to practied extracting the day of the week  */

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
  DATE_TRUNC('week', registration_date)::DATE + 4   AS registration_week,
  COUNT(*) AS runners
FROM pizza_runner.runners
GROUP BY registration_week
ORDER BY registration_week;
```
**Result:**
| registration\_week       | runners |
| ------------------------ | ------- |
| 2021-01-01T00:00:00.000Z | 2       |
| 2021-01-08T00:00:00.000Z | 1       |
| 2021-01-15T00:00:00.000Z | 1       |

**2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?**

**3. Is there any relationship between the number of pizzas and how long the order takes to prepare?**

**4. What was the average distance travelled for each customer?**

**5. What was the difference between the longest and shortest delivery times for all orders?**

**6. What was the average speed for each runner for each delivery and do you notice any trend for these values?** 

**7. What is the successful delivery percentage for each runner?**
 
