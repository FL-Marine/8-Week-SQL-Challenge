# Case Study # 5 - Data Mart

![image](https://user-images.githubusercontent.com/74512335/181638642-ae8a2dc7-5ba5-44b9-849b-87e1748c4576.png)

## Link to Case Study

https://8weeksqlchallenge.com/case-study-5/

## Introduction

Data Mart is Danny’s latest venture and after running international operations for his online supermarket that specialises in fresh produce - Danny is asking for your support to analyse his sales performance.

In June 2020 - large scale supply changes were made at Data Mart. All Data Mart products now use sustainable packaging methods in every single step from the farm all the way to the customer.

Danny needs your help to quantify the impact of this change on the sales performance for Data Mart and it’s separate business areas.

The key business question he wants you to help him answer are the following:

- What was the quantifiable impact of the changes introduced in June 2020?

- Which platform, region, segment and customer types were the most impacted by this change?

- What can we do about future introduction of similar sustainability updates to the business to minimise impact on sales?

## Avaliable Data

![image](https://user-images.githubusercontent.com/74512335/181641003-ca261598-446e-40aa-ae34-2ac78dd25af6.png)

## Column Dictonary

The columns are pretty self-explanatory based on the column names but here are some further details about the dataset:

1. Data Mart has international operations using a multi-region strategy

2. Data Mart has both, a retail and online platform in the form of a Shopify store front to serve their customers

3. Customer segment and customer_type data relates to personal age and demographics information that is shared with Data Mart

4. transactions is the count of unique purchases made through Data Mart and sales is the actual dollar amount of purchases

Each record in the dataset is related to a specific aggregated slice of the underlying sales data rolled up into a week_date value which represents the start of the sales week.

## Example Rows

![image](https://user-images.githubusercontent.com/74512335/181641294-63f6eca8-3b12-491c-849a-4db16af369d4.png)

## Schema Link 

https://www.db-fiddle.com/f/2GtQz4wZtuNNu7zXH5HtV4/3

#  Case Study Questions and Solutions

## 1. Data Cleansing Steps

In a single query, perform the following operations and generate a new table in the data_mart schema named clean_weekly_sales:

- Convert the week_date to a DATE format

- Add a week_number as the second column for each week_date value, for example any value from the 1st of January to 7th of January will be 1, 8th to 14th will be 2 etc

- Add a month_number with the calendar month for each week_date value as the 3rd column

- Add a calendar_year column as the 4th column containing either 2018, 2019 or 2020 values

- Add a new column called age_band after the original segment column using the following mapping on the number inside the segment value

| segment | age\_band    |
| ------- | ------------ |
| 1       | Young Adults |
| 2       | Middle Aged  |
| 3 or 4  | Retirees     |

- Add a new demographic column using the following mapping for the first letter in the segment values:

| segment | demographic |
| ------- | ----------- |
| C       | Couples     |
| F       | Families    |

- Ensure all null string values with an "unknown" string value in the original segment column as well as the new age_band and demographic columns

- Generate a new avg_transaction column as the sales value divided by transactions rounded to 2 decimal places for each record

```sql
DROP TABLE IF EXISTS data_mart.clean_weekly_sales;
CREATE TABLE data_mart.clean_weekly_sales AS
SELECT
  TO_DATE(week_date, 'DD/MM/YY') AS week_date, --changed from 'MM/DD/YY'--
  DATE_PART('week', TO_DATE(week_date, 'DD/MM/YY')) AS week_number,
  DATE_PART('month', TO_DATE(week_date, 'DD/MM/YY')) AS month_number,
  DATE_PART('year', TO_DATE(week_date, 'DD/MM/YY')) AS calendar_year,
  region,
  platform,
  CASE
    WHEN segment = 'null' THEN 'Unknown'
    ELSE segment
    END AS segment,
  CASE
    WHEN RIGHT(segment, 1) = '1' THEN 'Young Adults' --Changed from WHEN LEFT--
    WHEN RIGHT(segment, 1) = '2' THEN 'Middle Aged'--Changed from WHEN LEFT--
    WHEN RIGHT(segment, 1) IN ('3', '4') THEN 'Retirees' --Changed from WHEN LEFT--
    ELSE 'Unknown'
    END AS age_band,
  CASE
    WHEN LEFT(segment, 1) = 'C' THEN 'Couples' --Changed from WHEN RIGHT--
    WHEN LEFT(segment, 1) = 'F' THEN 'Families'--Changed from WHEN RIGHT--
    ELSE 'Unknown'
    END AS demographic,
  customer_type,
  transactions,
  sales,
  ROUND(
      sales ::NUMERIC / transactions, --Casted sales as NUMERIC--
      2
   ) AS avg_transaction
FROM data_mart.weekly_sales;
SELECT *
FROM data_mart.clean_weekly_sales; --Added this SELECT statement--
LIMIT 10; --Limtied to show only 10 results as the final output is > 17k rows
```
**Result**
| week\_date | week\_number | month\_number | calendar\_year | region | platform | segment | age\_band    | demographic | customer\_type | transactions | sales    | avg\_transaction |
| ---------- | ------------ | ------------- | -------------- | ------ | -------- | ------- | ------------ | ----------- | -------------- | ------------ | -------- | ---------------- |
| 2020-08-31 | 36           | 8             | 2020           | ASIA   | Retail   | C3      | Retirees     | Couples     | New            | 120631       | 3656163  | 30.31            |
| 2020-08-31 | 36           | 8             | 2020           | ASIA   | Retail   | F1      | Young Adults | Families    | New            | 31574        | 996575   | 31.56            |
| 2020-08-31 | 36           | 8             | 2020           | USA    | Retail   | Unknown | Unknown      | Unknown     | Guest          | 529151       | 16509610 | 31.20            |
| 2020-08-31 | 36           | 8             | 2020           | EUROPE | Retail   | C1      | Young Adults | Couples     | New            | 4517         | 141942   | 31.42            |
| 2020-08-31 | 36           | 8             | 2020           | AFRICA | Retail   | C2      | Middle Aged  | Couples     | New            | 58046        | 1758388  | 30.29            |
| 2020-08-31 | 36           | 8             | 2020           | CANADA | Shopify  | F2      | Middle Aged  | Families    | Existing       | 1336         | 243878   | 182.54           |
| 2020-08-31 | 36           | 8             | 2020           | AFRICA | Shopify  | F3      | Retirees     | Families    | Existing       | 2514         | 519502   | 206.64           |
| 2020-08-31 | 36           | 8             | 2020           | ASIA   | Shopify  | F1      | Young Adults | Families    | Existing       | 2158         | 371417   | 172.11           |
| 2020-08-31 | 36           | 8             | 2020           | AFRICA | Shopify  | F2      | Middle Aged  | Families    | New            | 318          | 49557    | 155.84           |

## 2. Data Exploration

1. What day of the week is used for each week_date value?

2. What range of week numbers are missing from the dataset?

3. How many total transactions were there for each year in the dataset?

4. What is the total sales for each region for each month?

5. What is the total count of transactions for each platform

6. What is the percentage of sales for Retail vs Shopify for each month?

7. What is the percentage of sales by demographic for each year in the dataset?

8. Which age_band and demographic values contribute the most to Retail sales?

9. Can we use the avg_transaction column to find the average transaction size for each year for Retail vs Shopify? If not - how would you calculate it instead?

## 3. Before & After Analysis

This technique is usually used when we inspect an important event and want to inspect the impact before and after a certain point in time.

Taking the week_date value of 2020-06-15 as the baseline week where the Data Mart sustainable packaging changes came into effect.

We would include all week_date values for 2020-06-15 as the start of the period after the change and the previous week_date values would be before

Using this analysis approach - answer the following questions:

1. What is the total sales for the 4 weeks before and after 2020-06-15? What is the growth or reduction rate in actual values and percentage of sales?

2. What about the entire 12 weeks before and after?

3. How do the sale metrics for these 2 periods before and after compare with the previous years in 2018 and 2019?
