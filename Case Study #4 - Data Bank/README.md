# Case Study # 4 - Data Bank

![image](https://user-images.githubusercontent.com/74512335/178159334-16cebf50-d2ac-4772-8381-5e01ace85a2f.png)

## **Link to Case Study**
https://8weeksqlchallenge.com/case-study-4/

## Introduction 

There is a new innovation in the financial industry called Neo-Banks: new aged digital only banks without physical branches.

Danny thought that there should be some sort of intersection between these new age banks, cryptocurrency and the data world…so he decides to launch a new initiative - Data Bank!

Data Bank runs just like any other digital bank - but it isn’t only for banking activities, they also have the world’s most secure distributed data storage platform!

Customers are allocated cloud data storage limits which are directly linked to how much money they have in their accounts. There are a few interesting caveats that go with this business model, and this is where the Data Bank team need your help!

The management team at Data Bank want to increase their total customer base - but also need some help tracking just how much data storage their customers will need.

This case study is all about calculating metrics, growth and helping the business analyse their data in a smart way to better forecast and plan for their future developments!

## Avaliable Data

![image](https://user-images.githubusercontent.com/74512335/178159445-72b5261e-2c60-4694-8384-6a63a7f6be1a.png)

![image](https://user-images.githubusercontent.com/74512335/178159490-752c686c-cced-4cee-914f-55abdc06f888.png)

![image](https://user-images.githubusercontent.com/74512335/178159561-6b50b97e-5d3d-45a3-92b3-53b8c9fe6d74.png)

![image](https://user-images.githubusercontent.com/74512335/178159574-718f5c8a-8877-4f1d-a563-b814005b59c8.png)

## Schema Link
https://www.db-fiddle.com/f/2GtQz4wZtuNNu7zXH5HtV4/3

# Case Study Questions and Solutions 

## Part A. Customer Nodes Exploration

1. How many unique nodes are there on the Data Bank system?
```sql
WITH unique_nodes AS (
SELECT 
  region_id,
  COUNT(DISTINCT node_id) AS unique_node_count
FROM data_bank.customer_nodes
GROUP BY region_id
)
SELECT 
  SUM(unique_node_count) AS DB_unique_node_count
FROM unique_nodes;
```
**Result**
| db\_unique\_node\_count |
| ----------------------- |
| 25                      |

2. What is the number of nodes per region?
```sql
SELECT
  regions.region_name,
  COUNT(DISTINCT customer_nodes.node_id) AS nodes
FROM data_bank.customer_nodes
INNER JOIN data_bank.regions
  ON  regions.region_id = customer_nodes.node_id
GROUP BY region_name;
```
**Result**
| region\_name | node\_counts |
| ------------ | ------------ |
| Africa       | 5            |
| America      | 5            |
| Asia         | 5            |
| Australia    | 5            |
| Europe       | 5            |

3. How many customers are allocated to each region?
```sql
--Original Code--
SELECT
  node_id,--remove node_id, replace with region_name--
  COUNT(customer_nodes.customer_id) AS nodes -- Add DISTINCT inside customer_id COUNT()
FROM data_bank.customer_nodes
INNER JOIN data_bank.regions
  ON customer_nodes.region_id = regions.region_id
GROUP BY region_name
ORDER BY region_name;

--Debugged Code--
SELECT
  region_name,
  COUNT(DISTINCT customer_nodes.customer_id) AS nodes
FROM data_bank.customer_nodes
INNER JOIN data_bank.regions
  ON customer_nodes.region_id = regions.region_id
GROUP BY region_name
ORDER BY region_name;
```
**Result**
| region\_name | nodes |
| ------------ | ----- |
| Africa       | 102   |
| America      | 105   |
| Asia         | 95    |
| Australia    | 110   |
| Europe       | 88    |

4. How many days on average are customers reallocated to a different node?

5. What is the median, 80th and 95th percentile for this same reallocation days metric for each region?

## B. Customer Transactions

1. What is the unique count and total amount for each transaction type?
```sql
SELECT
  txn_type,
  COUNT(*) AS txn_count,
  SUM(txn_amount) AS total_amount
FROM data_bank.customer_transactions
GROUP BY txn_type;
```
**Result**
| txn\_type  | txn\_count | total\_amount |
| ---------- | ---------- | ------------- |
| purchase   | 1617       | 806537        |
| withdrawal | 1580       | 793003        |
| deposit    | 2671       | 1359168       |

2. What is the average total historical deposit counts and amounts for all customers?
```sql
WITH cte_customer AS (
SELECT
  customer_id,
  COUNT(*) AS avg_customer_count,
  AVG(txn_amount) AS avg_customer_deposit
FROM 
  data_bank.customer_transactions
WHERE
  txn_type = 'deposit'
GROUP BY customer_id
)
SELECT
  ROUND(AVG(avg_customer_count)) AS avg_count,
  ROUND(AVG(avg_customer_deposit)) AS avg_deposit_amount
FROM 
  cte_customer;
  
  --Taking average of customer then calculating the final average from that--
  ```
  **Result** 
| avg\_count | avg\_deposit\_amount |
| ---------- | -------------------- |
| 5          | 509                  |

3. For each month - how many Data Bank customers make more than 1 deposit and either 1 purchase or 1 withdrawal in a single month?

4. What is the closing balance for each customer at the end of the month?

5. What is the percentage of customers who increase their closing balance by more than 5%?

- Have a negative first month balance?

- Have a positive first month balance?

- Increase their opening month’s positive closing balance by more than 5% in the following month?

- Reduce their opening month’s positive closing balance by more than 5% in the following month?

- Move from a positive balance in the first month to a negative balance in the second month?


