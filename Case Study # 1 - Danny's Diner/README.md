# Case Study #1 - Danny's Diner 
1st Case Study from Danny Ma's Serious SQL Course

![image](https://user-images.githubusercontent.com/74512335/130088045-01bbd3aa-7619-437e-bcb8-cf19e95ccfba.png)

## **Datasets**

Danny has shared 3 key datasets for this case study: **Sales | Menu | Members**

## Entity Relationship Diagram
![image](https://user-images.githubusercontent.com/74512335/129699208-a6703c22-b8af-443b-bb1c-ab924560bf88.png)

**Link to ERD**: https://dbdiagram.io/d/608d07e4b29a09603d12edbd/?utm_source=dbdiagram_embed&utm_medium=bottom_open

## **Table 1: Sales**
The sales table captures all customer_id level purchases with an corresponding order_date and product_id information for when and what menu items were ordered.

![image](https://user-images.githubusercontent.com/74512335/129871895-6a2283d1-6f70-4dfa-acbf-de7db46842a6.png)

## **Table 2: Menu**
The menu table maps the product_id to the actual product_name and price of each menu item.

![image](https://user-images.githubusercontent.com/74512335/129872863-4415d888-a599-4699-a71f-fc8e65582fc6.png)

## **Table 3: Members**
The final members table captures the join_date when a customer_id joined the beta version of the Danny’s Diner loyalty program.

![image](https://user-images.githubusercontent.com/74512335/129873255-d73f810e-296b-4d51-aff9-5e4424769d0e.png)

# Case Study Questions & Solutions
**1. What is the total amount each customer spent at the restaurant?**

LEFT JOIN was conducted to marry up the sales amounts for each menu item. GROUP BY used to show what each customer purchased & how much.
```sql
SELECT
  sales.customer_id,
  SUM(menu.price) AS total_customer_sales
FROM
  dannys_diner.sales
  LEFT JOIN dannys_diner.menu ON sales.product_id = menu.product_id
GROUP BY
  customer_id
ORDER BY
  customer_id;
```
**Result:**
| customer\_id | total\_customer\_sales |
| ------------ | ---------------------- |
| A            | 76                     |
| B            | 74                     |
| C            | 36                     |

**2. How many days has each customer visited the restaurant?**

COUNT DISTINCT was needed in order to filter out duplicates and just get the days each customer visited the restaurant.
```sql
SELECT
  customer_id,
  COUNT(DISTINCT order_date) AS customer_visit_days
FROM
  dannys_diner.sales
GROUP BY
  sales.customer_id
ORDER BY
  sales.customer_id;
```
**Result:**
| customer\_id | customer\_visit\_days |
| ------------ | --------------------- |
| A            | 4                     |
| B            | 6                     |
| C            | 2                     |

**3. What was the first item from the menu purchased by each customer?**

Query result from order_date just gives dates, determining what was the first menu item purchase by the customer is not possible. Filtering to product_id gives a better idea of what the first purchase for the customer could be.
```sql
WITH customer_first_purchase AS (
  SELECT
    sales.customer_id,
    menu.product_name,
    ROW_NUMBER() OVER (
      PARTITION BY sales.customer_id
      ORDER BY
        sales.order_date,
        sales.product_id
    ) AS first_item_order
  FROM
    dannys_diner.sales
    LEFT JOIN dannys_diner.menu ON sales.product_id = menu.product_id
)
SELECT
  *
FROM
  customer_first_purchase
WHERE
  first_item_order = 1;
  ```
  **Result:**
| customer\_id | product\_name | first\_item\_order |
| ------------ | ------------- | ------------------ |
| A            | sushi         | 1                  |
| B            | curry         | 1                  |
| C            | ramen         | 1                  |

**4. What is the most purchased item on the menu and how many times was it purchased by all customers?**

Most purchased item is ramen.
``` sql
SELECT
  menu.product_name,
  COUNT(sales.product_id) AS most_purchased_item_count
FROM
  dannys_diner.sales
  INNER JOIN dannys_diner.menu ON sales.product_id = menu.product_id
GROUP BY
  menu.product_name
ORDER BY
  most_purchased_item_count DESC
LIMIT
  1;
  ```
  **Result:**
  | product\_name | most\_purchased\_item\_count |
| ------------- | --------------------- |
| ramen         | 8                     |

**5. Which item was the most popular for each customer?**

Two ctes were used to better split up queries by order count and popularity. 

Customers Favorite Food:

- Customer A - Ramen

- Customer B - 3 way tie

- Customer C - Ramen
 ``` sql
 WITH cte_most_popular_item AS (
  SELECT
    menu.product_name,
    sales.customer_id,
    COUNT(*) AS order_count
  FROM dannys_diner.sales
  LEFT JOIN dannys_diner.menu
    ON sales.product_id = menu.product_id
    GROUP BY 
    customer_id,
    product_name
    ORDER BY
    customer_id,
    order_count DESC
  ),
  cte_pop_rank AS (
  SELECT *,
  RANK () OVER(PARTITION BY customer_id ORDER BY order_count DESC) AS popular_rank
  FROM cte_most_popular_item
  )
  SELECT * FROM cte_pop_rank
  WHERE popular_rank = 1;
  ```
 **Result:**
| product\_name | customer\_id | order\_count | popular\_rank |
| ------------- | ------------ | ------------ | ------------- |
| ramen         | A            | 3            | 1             |
| sushi         | B            | 2            | 1             |
| curry         | B            | 2            | 1             |
| ramen         | B            | 2            | 1             |
| ramen         | C            | 3            | 1             |

**6. Which item was purchased first by the customer after they became a member?**

RANKED () was used in the window function to assign each row within the partition. Rows of exact value will receive the same rank, this query shows which item was first purchase by customers when they became members.
``` sql
WITH first_customer_member_purchase AS (
  SELECT
    RANK () OVER(
      PARTITION BY members.customer_id
      ORDER BY
        order_date
    ) AS ranked,
    members.customer_id,
    menu.product_name
  FROM
    dannys_diner.sales
    LEFT JOIN dannys_diner.members ON sales.customer_id = members.customer_id
    LEFT JOIN dannys_diner.menu ON menu.product_id = sales.product_id
  WHERE
    order_date >= join_date
)
SELECT
  *
FROM
  first_customer_member_purchase
WHERE
  ranked = 1;
```
 **Result:**
| ranked | customer\_id | product\_name |
| ------ | ------------ | ------------- |
| 1      | A            | curry         |
| 1      | B            | sushi         |

**7. Which item was purchased just before the customer became a member?**

Basically the same query as above but >= (Greater Than or Equal To) is changed < (Less Than) to show what items customers purchased before becoming a member. Customer A purchased  2 items sushi and curry before they became a members vs customer B only bought one item curry.
``` sql
WITH first_customer_member_purchase AS (
  SELECT
    RANK () OVER(
      PARTITION BY members.customer_id
      ORDER BY
        order_date
    ) AS ranked,
    members.customer_id,
    menu.product_name
  FROM
    dannys_diner.sales
    LEFT JOIN dannys_diner.members ON sales.customer_id = members.customer_id
    LEFT JOIN dannys_diner.menu ON menu.product_id = sales.product_id
  WHERE
    order_date < join_date
)
SELECT
  *
FROM
  first_customer_member_purchase
WHERE
  ranked = 1;
```
 **Result:**
 | ranked | customer\_id | product\_name |
| ------ | ------------ | ------------- |
| 1      | A            | sushi         |
| 1      | A            | curry         |
| 1      | B            | curry         |

**8. What is the number of unique menu items and total amount spent for each member before they became a member?**

Used DISTINCT because the question states **unique menu items**. This translates to how many items did the customer buy each item for the first time prior to membership including amount spent.
``` sql
SELECT
  sales.customer_id,
  COUNT(DISTINCT menu.product_id) AS unique_menu_total_items,
  SUM(menu.price) AS amount
FROM
  dannys_diner.sales
  LEFT JOIN dannys_diner.members on sales.customer_id = members.customer_id
  INNER JOIN dannys_diner.menu ON sales.product_id = menu.product_id
WHERE
  order_date < join_date
GROUP BY
  sales.customer_id
ORDER BY
  sales.customer_id
  ```
   **Result:**
  | customer\_id | unique\_menu\_total\_items | amount |
| ------------ | -------------------------- | ------ |
| A            | 2                          | 25     |
| B            | 2                          | 40     | 
  

**9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?**

SUM with CASE WHEN clauses were used to only identify the menu item 'sushi' then multiply only sushi by x2 points every other item does not fit this criteria. This is similar to a IF ELSE statement seen in other tools.
``` sql
SELECT
  sales.customer_id,
  SUM(
    CASE
      WHEN product_name = 'sushi' THEN 20 * price
      ELSE 10 * PRICE
    END
  ) AS total_points
FROM
  dannys_diner.sales
  LEFT JOIN dannys_diner.menu ON sales.product_id = menu.product_id
GROUP BY
  sales.customer_id
ORDER BY
  total_points DESC;
  ```
   **Result:**
   | customer\_id | total\_points |
| ------------ | ------------- |
| B            | 940           |
| A            | 860           |
| C            | 360           |

**10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?**

Needed to look at 2 different dates the initial join date and a week later. To get 7 days past the join_date a + 7 was used after the AND clause. A second WHEN clause was used to clarify that the 2x points was only earned during that time period betwwen join_date and a week later. To ensure points we're only searching for points counted in January a WHERE order_date with a <= less then or equal sign.
``` sql
SELECT
  sales.customer_id,
  SUM(
    CASE
      WHEN product_name = 'sushi' THEN 20 * price
      WHEN order_date BETWEEN join_date
      AND join_date + 7 THEN 20 * price
      ELSE 10 * PRICE
    END
  ) AS total_points
FROM
  dannys_diner.members
  LEFT JOIN dannys_diner.sales ON sales.customer_id = members.customer_id
  LEFT JOIN dannys_diner.menu ON menu.product_id = sales.product_id
WHERE
  order_date <= '2021-01-31'
GROUP BY
  sales.customer_id;
  ```
  **Result:**
  | customer\_id | total\_points |
| ------------ | ------------- |
| A            | 1370          |
| B            | 940           |
