# Case Study #3 - Foodie-Fi
3rd Case Study from Danny Ma's Serious SQL Course - https://8weeksqlchallenge.com/case-study-3/

![image](https://user-images.githubusercontent.com/74512335/147102005-f738615f-7393-4269-b082-7fd306fd8de9.png)

## Entity Relationship Diagram
![image](https://user-images.githubusercontent.com/74512335/147102131-8fb5d455-658e-47d5-886d-b318b28324fb.png)

## Schema Link
https://www.db-fiddle.com/f/rHJhRrXy5hbVBNJ6F6b9gJ/16

## **Datasets** - The required datasets reside within the foodie_fi schema on the PostgreSQL Docker setup

**Table 1: plans**
- Customers can choose which plans to join Foodie-Fi when they first sign up.

- Basic plan customers have limited access and can only stream their videos and is only available monthly at $9.90

- Pro plan customers have no watch time limits and are able to download videos for offline viewing. Pro plans start at $19.90 a month or $199 for an annual subscription.

- Customers can sign up to an initial 7 day free trial will automatically continue with the pro monthly subscription plan unless they cancel, downgrade to basic or upgrade to an annual pro plan at any point during the trial.

- When customers cancel their Foodie-Fi service - they will have a churn plan record with a null price but their plan will continue until the end of the billing period.

![image](https://user-images.githubusercontent.com/74512335/147103867-e44c3e58-0629-48dd-ad12-8b5dff43cafc.png)

**Table 2: subscriptions**

- Customer subscriptions show the exact date where their specific plan_id starts.

- If customers downgrade from a pro plan or cancel their subscription - the higher plan will remain in place until the period is over - the start_date in the subscriptions table will reflect the date that the actual plan changes.

- When customers upgrade their account from a basic plan to a pro or annual pro plan - the higher plan will take effect straightaway.

- When customers churn - they will keep their access until the end of their current billing period but the start_date will be technically the day they decided to cancel their service.

![image](https://user-images.githubusercontent.com/74512335/147104193-3559e72f-136e-4c30-9c87-bf230e911d6b.png)
