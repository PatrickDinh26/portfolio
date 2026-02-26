-- SECTION 3: SEGMENT BEHAVIOR & TIMING 
-- Problem 1:  the PreferredPurchaseTimes (Morning/Afternoon/Evening) by region and category in the Americas, and which segments generate the most LifetimeValue?
-- Problem 2: How does TimeBetweenPurchases vary between North and South America, and how is it related to LifetimeValue?
-- Problem 3: For American customers, which product categories are more popular in North vs South America, and how does that relate to LifetimeValue and churn?

-- ----------
-- Problem 1: 
-- ----------
WITH segment_rank as(
SELECT 
	Region, Most_Frequent_Category, Preferred_Purchase_Times, 
    ROUND(AVG(Lifetime_Value),2) AS avg_LTV, 
	ROUND(SUM(Lifetime_Value),2) AS total_LTV, 
    RANK () OVER(
		PARTITION BY Region, Most_Frequent_Category
        ORDER BY SUM(Lifetime_Value) DESC
        ) AS ranks 
FROM insight_table
GROUP BY Region, Most_Frequent_Category, Preferred_Purchase_Times
)
SELECT * 
FROM segment_rank 
WHERE ranks = 1 
; 
-- in the North, regarding Category, Evening is the time of day where generate the highest revenue while Morning is the lowest
-- in the South, there are difference amongs categories, Clothing and Home customer mainly focus on Evening time, while Electronic and Sports highest at Afternoon time. 

-- ----------
-- Problem 2:  
-- ----------

WITH speed_bucket AS (
    SELECT
        Customer_ID,
        Region,
        Most_Frequent_Category,
        Preferred_Purchase_Times,
        Time_Between_Purchases,
        Lifetime_Value,
        Churn_Probability,
        NTILE(3) OVER (
            PARTITION BY Region, Most_Frequent_Category
            ORDER BY Time_Between_Purchases
        ) AS speed_tier
    FROM insight_table
),
agg AS (
    SELECT
        Region,
        Most_Frequent_Category,
        speed_tier,
        ROUND(AVG(Lifetime_Value),2)        AS avg_ltv,
        ROUND(AVG(Churn_Probability),2)     AS avg_churn,
        COUNT(*)                   AS customers
    FROM speed_bucket
    GROUP BY Region, Most_Frequent_Category, Preferred_Purchase_Times, speed_tier
)
SELECT *
FROM agg
ORDER BY Region, Most_Frequent_Category, speed_tier, avg_ltv DESC;
-- when we split customers into 3 segments regards time between purchases (or speed tier), we observe modest differences 
-- in some category, such as North American Sport, South American Home, slower the purchase but have higher LTV and low churn rate, by then we can decide speeding everyone is not always better. 

-- ----------
-- Problem 3: 
-- ----------
SELECT
    Region,
    Most_Frequent_Category,
    COUNT(DISTINCT Customer_ID) AS customers,
    ROUND(AVG(Lifetime_Value),2)  AS avg_ltv,
	ROUND(SUM(Lifetime_Value),2)  AS total_ltv,
    ROUND(AVG(Churn_Probability),2) AS avg_churn
FROM insight_table
GROUP BY Region,Most_Frequent_Category
ORDER BY Region, customers DESC;
-- North, most popular is Electronics, but this category generate lowest per customer value and 2nd high of revenue due to the large customer base, eventhough the churn rate is highest
-- South, Clothing and Electronics are most popular, but Clothing has higher per customer value and lower churn rate than Electronics 
