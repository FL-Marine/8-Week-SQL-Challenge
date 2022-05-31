## Entity Relationship Diagram
![image](https://user-images.githubusercontent.com/74512335/166221684-67389783-3a0a-4963-b435-9cc6bcbdf730.png)

<details>
<summary>Table 1: plans</summary>

- Customers can choose which plans to join Foodie-Fi when they first sign up.

- Basic plan customers have limited access and can only stream their videos and is only available monthly at $9.90

- Pro plan customers have no watch time limits and are able to download videos for offline viewing. Pro plans start at $19.90 a month or $199 for an annual subscription.

- Customers can sign up to an initial 7 day free trial will automatically continue with the pro monthly subscription plan unless they cancel, downgrade to basic or upgrade to an annual pro plan at any point during the trial.

- When customers cancel their Foodie-Fi service - they will have a churn plan record with a null price but their plan will continue until the end of the billing period.

![image](https://user-images.githubusercontent.com/74512335/166221976-a5cbd09f-fb25-4a29-9607-0ab67cdc8a9c.png)
 </details>

<details>
<summary>Table 2: subscriptions</summary>

Customer subscriptions show the exact date where their specific plan_id starts.

If customers downgrade from a pro plan or cancel their subscription - the higher plan will remain in place until the period is over - the start_date in the subscriptions table will reflect the date that the actual plan changes.

When customers upgrade their account from a basic plan to a pro or annual pro plan - the higher plan will take effect straightaway.

When customers churn - they will keep their access until the end of their current billing period but the start_date will be technically the day they decided to cancel their service.

 ![image](https://user-images.githubusercontent.com/74512335/166222305-f89eb62b-0d4b-4584-a7c4-4d6010ae3344.png)

</details>

# Case Study Questions & Solutions

## Part A
 <details>
<summary>Customer Journey</summary>
Based off the 8 sample customers provided in the sample from the subscriptions table, write a brief description about each customer’s onboarding journey.

"Try to keep it as short as possible - you may also want to run some sort of join to make your explanations a bit easier!"
```sql
SELECT
  customer_id,
  subscriptions.plan_id,
  plan_name,
  start_date
FROM foodie_fi.subscriptions
INNER JOIN foodie_fi.plans
ON subscriptions.plan_id = plans.plan_id
WHERE customer_id IN (1, 2, 13, 15, 16, 18, 19, 25, 39, 42);
```
**Result:**
| customer\_id | plan\_id | plan\_name    | start\_date |
| ------------ | -------- | ------------- | ----------- |
| 1            | 0        | trial         | 2020-08-01  |
| 1            | 1        | basic monthly | 2020-08-08  |
| 2            | 0        | trial         | 2020-09-20  |
| 2            | 3        | pro annual    | 2020-09-27  |
| 13           | 0        | trial         | 2020-12-15  |
| 13           | 1        | basic monthly | 2020-12-22  |
| 13           | 2        | pro monthly   | 2021-03-29  |
| 15           | 0        | trial         | 2020-03-17  |
| 15           | 2        | pro monthly   | 2020-03-24  |
| 15           | 4        | churn         | 2020-04-29  |
| 16           | 0        | trial         | 2020-05-31  |
| 16           | 1        | basic monthly | 2020-06-07  |
| 16           | 3        | pro annual    | 2020-10-21  |
| 18           | 0        | trial         | 2020-07-06  |
| 18           | 2        | pro monthly   | 2020-07-13  |
| 19           | 0        | trial         | 2020-06-22  |
| 19           | 2        | pro monthly   | 2020-06-29  |
| 19           | 3        | pro annual    | 2020-08-29  |
| 25           | 0        | trial         | 2020-05-10  |
| 25           | 1        | basic monthly | 2020-05-17  |
| 25           | 2        | pro monthly   | 2020-06-16  |
| 39           | 0        | trial         | 2020-05-28  |
| 39           | 1        | basic monthly | 2020-06-04  |
| 39           | 2        | pro monthly   | 2020-08-25  |
| 39           | 4        | churn         | 2020-09-10  |
| 42           | 0        | trial         | 2020-10-27  |
| 42           | 1        | basic monthly | 2020-11-03  |
| 42           | 2        | pro monthly   | 2021-04-28  |
 </details>


## Part B. Data Analysis Questions
**1. How many customers has Foodie-Fi ever had?**
```sql
SELECT
  COUNT(DISTINCT customer_id) AS total_customers
FROM foodie_fi.subscriptions;
```
**Result:**
| total\_customers |
| ---------------- |
| 1000             |

**2. What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value**
```sql
SELECT
  DATE_TRUNC('MONTH', start_date)::DATE AS month_start,
  COUNT(*) AS trial_customers
FROM foodie_fi.subscriptions
WHERE plan_id = 0
GROUP BY month_start
ORDER BY month_start;
```
**Result:**
| month\_start | trial\_customers |
| ------------ | ---------------- |
| 2020-01-01   | 88               |
| 2020-02-01   | 68               |
| 2020-03-01   | 94               |
| 2020-04-01   | 81               |
| 2020-05-01   | 88               |
| 2020-06-01   | 79               |
| 2020-07-01   | 89               |
| 2020-08-01   | 88               |
| 2020-09-01   | 87               |
| 2020-10-01   | 79               |
| 2020-11-01   | 75               |
| 2020-12-01   | 84               |

**3. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name**
```sql
SELECT 
  plans.plan_id,
  plan_name,
  COUNT(*) AS count
FROM foodie_fi.subscriptions
INNER JOIN foodie_fi.plans
  ON subscriptions.plan_id = plans.plan_id
WHERE start_date > '2020-01-01'::DATE
GROUP BY plans.plan_id, plan_name
ORDER BY plans.plan_id;
```
**Result:**
| plan\_id | plan\_name    | count |
| -------- | ------------- | ----- |
| 0        | trial         | 997   |
| 1        | basic monthly | 546   |
| 2        | pro monthly   | 539   |
| 3        | pro annual    | 258   |
| 4        | churn         | 307   |

**4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?**
```sql
SELECT
  SUM(CASE WHEN plan_id = 4 THEN 1 ELSE 0 END) AS churn_customers,
  ROUND(
    100 * SUM(CASE WHEN plan_id = 4 THEN 1 ELSE 0 END):: NUMERIC /
      COUNT(DISTINCT customer_id), 1
  ) AS percentage
FROM foodie_fi.subscriptions;
```
**Result:**
| churn\_customers | percentage |
| ---------------- | ---------- |
| 307              | 30.7       |


**5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?**
```sql
WITH ranked_plans AS (
  SELECT
    subscriptions.customer_id,
    subscriptions.plan_id,
    plans.plan_name,
    ROW_NUMBER() OVER (
      PARTITION BY subscriptions.customer_id
      ORDER BY subscriptions.plan_id) AS plan_rank
  FROM foodie_fi.subscriptions
  INNER JOIN foodie_fi.plans 
    ON subscriptions.plan_id = plans.plan_id)

SELECT
 COUNT(*) as churn_count,
 ROUND(100 * COUNT(*) / (
  SELECT COUNT(DISTINCT customer_id)
  FROM foodie_fi.subscriptions),0) AS churn_percentage
FROM ranked_plans
WHERE plan_id = 4
  AND plan_rank = 2;
  ```
  **Result:**
  | churn\_count | churn\_percentage |
| ------------ | ----------------- |
| 92           | 9                 |

**6. What is the number and percentage of customer plans after their initial free trial?**
```sql
--Need to debug this--
WITH ranked_plans AS (
  SELECT
    customer_id,
    plan_id,
    ROW_NUMBER() OVER (
      PARTITION BY customer_id
      ORDER BY start_date DESC
    ) AS plan_rank
  FROM foodie_fi.subscriptions
)
SELECT
  plans.plan_id,
  plans.plan_name,
  COUNT(*) AS customer_count,
  ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER ()) AS percentage
FROM ranked_plans
INNER JOIN foodie_fi.plans
  ON ranked_plans.plan_id = plans.plan_id
WHERE plan_rank = 1
GROUP BY plans.plan_id, plans.plan_name
ORDER BY plans.plan_id;

--Debugged code--
WITH ranked_plans AS (
  SELECT
    customer_id,
    plan_id,
    ROW_NUMBER() OVER (
      PARTITION BY customer_id
      ORDER BY plan_id ASC --plan_id ASC replaced start_date DESC--
    ) AS plan_rank
  FROM foodie_fi.subscriptions
)
SELECT
  plans.plan_id,
  plans.plan_name,
  COUNT(*) AS customer_count,
  ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER ()) AS percentage
FROM ranked_plans
INNER JOIN foodie_fi.plans
  ON ranked_plans.plan_id = plans.plan_id
WHERE plan_rank = 2 --plan_rank = 1 was replaced with plan_rank = 2--
GROUP BY plans.plan_id, plans.plan_name
ORDER BY plans.plan_id;
```
**Result:**
| plan\_id | plan\_name    | customer\_count | percentage |
| -------- | ------------- | --------------- | ---------- |
| 1        | basic monthly | 546             | 55         |
| 2        | pro monthly   | 325             | 33         |
| 3        | pro annual    | 37              | 4          |
| 4        | churn         | 92              | 9          |


**7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?** 
``` sql
WITH valid_subscriptions AS (
  SELECT
    customer_id,
    plan_id,
    start_date,
    ROW_NUMBER() OVER (
      PARTITION BY customer_id
      ORDER BY start_date DESC
    ) AS plan_rank
  FROM foodie_fi.subscriptions
  WHERE start_date <= '2020-12-31'
)
SELECT
  plan_id,
  COUNT(DISTINCT customer_id) AS customers,
  ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER(), 1) AS percentage
FROM 
  valid_subscriptions
WHERE
  plan_rank = 1
GROUP BY
  plan_id;
  ```
  **Result:**
  | plan\_id | customers | percentage |
| -------- | --------- | ---------- |
| 0        | 19        | 1.9        |
| 1        | 224       | 22.4       |
| 2        | 326       | 32.6       |
| 3        | 195       | 19.5       |
| 4        | 236       | 23.6       |

**8. How many customers have upgraded to an annual plan in 2020?**
```sql
SELECT
  COUNT(DISTINCT customer_id) AS annual_customers
FROM foodie_fi.subscriptions
WHERE plan_id = 3
  AND start_date BETWEEN '2020-01-01' AND '2020-12-31';
  ```
**Result:**
| annual\_customers |
| ----------------- |
| 195               |

**9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?**
```sql
WITH trial AS (
  SELECT
    customer_id,
    start_date AS trial_date
  FROM foodie_fi.subscriptions
  WHERE plan_id = 0
),
annual AS (
  SELECT
    customer_id,
    start_date AS annual_date
  FROM foodie_fi.subscriptions
  WHERE plan_id = 3
)
SELECT
  ROUND(AVG(annual_date - trial_date), 0) AS avg
FROM annual
INNER JOIN trial
  ON trial.customer_id = annual.customer_id;
  ```
  **Result:**
  | avg |
| --- |
| 105 |

**10. Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)**

**11. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?**
