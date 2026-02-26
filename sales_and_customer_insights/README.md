# Sales & Customer Insights – SQL Case Study

This project explores an e‑commerce customer dataset to understand revenue, churn, and growth opportunities in North and South America. The analysis is done in MySQL on the table `sales_and_customer_insights`.

## Dataset

Main fields used:

- Region
- Lifetime_Value
- Average_Order_Value
- Purchase_Frequency
- Most_Frequent_Category
- Season
- Retention_Strategy
- Churn_Probability
- Preferred_Purchase_Times
- Time_Between_Purchases
- Peak_Sales_Date
- Customer_ID

I first create a view `insight_table` that keeps only American customers (North and South America).

---

## Section 1 – Customer Value & Revenue

### Business questions

1. How do Lifetime Value and Average Order Value differ by category (Home, Electronics, Clothing, Sports)?
2. Are there categories where customers buy often but spend little per order, or the opposite?
3. How does Lifetime Value differ by the season of peak sales (Spring, Summer, Fall, Winter)?
4. Which region (North vs South America) has higher average and total Lifetime Value?
5. Which retention strategy (Discount, Loyalty Program, Email Campaign) performs best in each region?

### SQL techniques

- View creation to filter American customers
- Aggregations with `AVG`, `SUM`, `COUNT`
- CTEs and `CASE` statements for segmentation
- Grouping and ordering by category and region

### Findings

- Sports customers have the highest average Lifetime Value, but Home customers generate the highest total Lifetime Value because of volume.
- There are two main valuable patterns:
  - High frequency, low basket size
  - Low frequency, high basket size
- Spring and Summer customers show the highest Lifetime Value.
- North America has slightly higher value per customer; South America drives higher total revenue due to more customers and higher frequency.
- Loyalty Programs tend to create higher‑value, lower‑churn customers than Discounts or Email alone.

---

## Section 2 – Churn and Retention Risk

### Business questions

1. What is the average churn probability in North and South America?
2. For American customers, which category + retention strategy combinations have the lowest churn?
3. Does higher Purchase Frequency or higher Average Order Value correlate more with lower churn?
4. Are there seasons where churn is systematically higher?

### SQL techniques

- CTEs to create buckets based on average Purchase Frequency and Average Order Value
- Aggregations by region, category, and retention strategy
- Comparison of churn across different dimensions

### Findings

- The average churn probability is around 0.5 in both North and South America.
- Loyalty Programs show the lowest churn, especially for Sports customers.
- The difference in churn between “high” and “low” frequency/AOV buckets is very small, so churn seems more influenced by strategy and category than by a single metric.
- Electronics has the highest churn among categories, suggesting a need for stronger post‑purchase and loyalty tactics.

---

## Section 3 – Segment Behaviour & Timing

### Business questions

1. Which combinations of region, category, and time of day (Morning/Afternoon/Evening) generate the most Lifetime Value?
2. How does Time Between Purchases differ between regions, and how does it relate to Lifetime Value and churn?
3. Which categories are more popular in North vs South America, and how does that relate to value and churn?

### SQL techniques

- Window functions: `RANK()` and `NTILE()`
- Segmentation by Region × Category × Preferred_Purchase_Times
- Aggregations across Lifetime Value, churn, and number of customers

### Findings

- In North America, Evening purchases generate the most revenue; Morning is usually the weakest time of day.
- In South America, peak times differ by category (for example, Electronics and Sports perform better in the Afternoon, while Clothing and Home lean more towards Evening).
- When splitting customers into three “speed tiers” based on Time Between Purchases, some slower segments still have high Lifetime Value and low churn, so faster is not always better.
- North America has many Electronics customers with high churn and lower value per customer, while South America’s Clothing segment has higher value and lower churn.

---

## Section 4 – Growth & Optimization Opportunities

### Business questions

1. Which Season × Category × Region segments have high churn but decent revenue (good retention opportunities)?
2. Which segments have high Lifetime Value but small customer bases (good acquisition opportunities)?
3. Among Discount, Loyalty Program, and Email Campaign, which strategy balances Lifetime Value and churn the best?

### SQL techniques

- Multi‑step CTEs for segment‑level statistics
- `NTILE()` to classify segments by value and size
- Filters to highlight:
  - High churn + decent revenue segments
  - High value + low size segments

### Findings

- Several Season × Category segments produce good revenue despite high churn, so targeted retention campaigns on these groups could have strong impact.
- Some small segments (for example, certain Spring categories in South America and Spring Sports in North America) have very high Lifetime Value and are good acquisition targets.
- Overall, Loyalty Programs give slightly higher Lifetime Value and lower churn than Discounts and Email Campaigns, making them the most efficient strategy in this dataset.

---

## How to Run the Queries

1. Load the `sales_and_customer_insights` table into MySQL.
2. Open the SQL script in MySQL Workbench.
3. Run the `CREATE VIEW insight_table` statement first.
4. Execute each section’s queries to reproduce the results and insights.

---

## Skills Demonstrated

- Turning business questions into SQL queries
- Working with aggregations, CTEs, views, and window functions
- Customer analytics: Lifetime Value, churn, purchase frequency, seasonal patterns, retention strategy evaluation
