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

 ## Part A. Customer Journey 
Based off the 8 sample customers provided in the sample from the subscriptions table, write a brief description about each customer’s onboarding journey.

"Try to keep it as short as possible - you may also want to run some sort of join to make your explanations a bit easier!"

## Part B. Data Analysis Questions
**1. How many customers has Foodie-Fi ever had?**

**2. What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value**

**3. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name**

**4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?**

**5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?**

**6. What is the number and percentage of customer plans after their initial free trial?**

**7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?** 

**8. How many customers have upgraded to an annual plan in 2020?**

**9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?**

**10. Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)**

**11. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?**
