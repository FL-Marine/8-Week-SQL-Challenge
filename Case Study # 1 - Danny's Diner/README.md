# Case-Study-1 Danny's Diner 
1st Case Study from Danny Ma's Serious SQL Course

![image](https://user-images.githubusercontent.com/74512335/130088045-01bbd3aa-7619-437e-bcb8-cf19e95ccfba.png)

## **Example Datasets**

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

![image](https://user-images.githubusercontent.com/74512335/130072193-b736b614-f2ff-4552-82d4-3d02cc43be2b.png)

**2. How many days has each customer visited the restaurant?**

COUNT DISTINCT was needed in order to filter out duplicates and just get the days each customer visited the restaurant.

 ![image](https://user-images.githubusercontent.com/74512335/129976292-915675f8-75e5-4c8e-aced-179dbaed52c6.png)

**3. What was the first item from the menu purchased by each customer?**

Query result from order_date just gives dates, determining what was the first menu item purchase by the customer is not possible. Filtering to product_id gives a better idea of what the first purchase for the customer could be.

![image](https://user-images.githubusercontent.com/74512335/130518858-95b83715-243a-4268-8673-72baf9f23e1a.png)

**4. What is the most purchased item on the menu and how many times was it purchased by all customers?**

Most purchased item is ramen.

![image](https://user-images.githubusercontent.com/74512335/131182021-b8ae95c5-ff7e-4fdc-b300-7870acd0938f.png)

**5. Which item was the most popular for each customer?**

Two ctes were used to better split up queries by order count and popularity. 

Customers Favorite Food:

Customer A - Ramen

Customer B - 3 way time

Customer C - Ramen

![image](https://user-images.githubusercontent.com/74512335/131188041-7b1b7901-22bf-4ade-a2f9-80bd6a7191cc.png)

**6. Which item was purchased first by the customer after they became a member?**

RANKED () was used in the window function to assign each row within the partition. Rows of exact value will receive the same rank, this query shows which item was first purchase by customers when they became members.

![image](https://user-images.githubusercontent.com/74512335/131219625-5f4147b9-956e-41fb-96e8-be12d148daa8.png)


**7. Which item was purchased just before the customer became a member?**

Basically the same query as above but >= (Greater Than or Equal To) is changed < (Less Than) to show what items customers purchased before becoming a member. Customer A purchased  2 items sushi and curry before they became a members vs customer B only bought one item curry.

![image](https://user-images.githubusercontent.com/74512335/131220187-8b793b0b-9112-4f4e-8e09-3fbec10351ac.png)

**8. What is the number of unique menu items and total amount spent for each member before they became a member?**

Used DISTINCT because the question states **unique menu items**. This translates to how many items did the customer buy each item for the first time prior to membership including amount spent.

![image](https://user-images.githubusercontent.com/74512335/131228453-2133e04d-98bc-43ed-a5cc-419b748846cd.png)

**9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?**

SUM with CASE WHEN clauses were used to only identify the menu item 'sushi' then multiply only sushi by x2 points every other item does not fit this criteria. This is similar to a IF ELSE statement seen in other tools.

![image](https://user-images.githubusercontent.com/74512335/131232505-b8c9bb2b-8ef7-48f2-ba20-639602c9a9fa.png)


**10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?**

