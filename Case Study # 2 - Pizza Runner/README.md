# Case Study #2 - Pizza Runner
2nd Case Study from Danny Ma's Serious SQL Course

![image](https://user-images.githubusercontent.com/74512335/131251748-01b76a8a-4e4b-415c-83e0-e27348b0ffba.png)

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
