-- SECTION 4: GROWTH AND OPTIMIZATION OPPORTUNITIES 
-- Problem 1: In North and South America, which Season and Category combinations show high churn but decent revenue, indicating an opportunity for better retention tactics?
-- Problem 2: Which segments (Region + Category + Season) in the Americas have high LifetimeValue but low customer counts, indicating good targets for acquisition?
-- Problem 3: For American customers using Discount vs Loyalty Program vs Email Campaign, which strategy gives the best trade-off between LifetimeValue and churn?

-- ----------
-- Problem 1: 
-- ----------
WITH season_cat AS (
    SELECT
        Region,
        Season,
        Most_Frequent_Category,
        COUNT(*) AS customers,
        AVG(Lifetime_Value) AS avg_ltv,
        AVG(Churn_Probability) AS avg_churn
    FROM insight_table
    GROUP BY Region, Season, Most_Frequent_Category
)
SELECT *
FROM season_cat
WHERE avg_churn >= 0.5  -- “high” churn 
  AND avg_ltv = 5000   -- “decent” revenue 
ORDER BY Region, avg_churn DESC, avg_ltv DESC;
-- North, beside Summer, all Seasons have category that could generate Decent Revenue regardless of high Churn Rate 
-- South, all season have a category that could generate decent revenue even high churn rate 

-- ----------
-- Problem 2:
-- ---------- 
WITH segment_stats AS (
    SELECT
        Region,
        Season,
        Most_Frequent_Category,
        COUNT(*)           AS customers,
        ROUND(AVG(Lifetime_Value),2) AS avg_ltv
    FROM insight_table
    GROUP BY Region, Season, Most_Frequent_Category
),
ranked AS (
    SELECT
		*,
        NTILE(3) OVER (ORDER BY avg_ltv DESC)   AS ltv_bucket,
        NTILE(3) OVER (ORDER BY customers ASC) AS size_bucket
    FROM segment_stats
)
SELECT
    Region, Season, Most_Frequent_Category, customers, avg_ltv
FROM ranked
WHERE ltv_bucket = 1   -- top third LTV
  AND size_bucket = 1  -- smallest third by customers
ORDER BY avg_ltv DESC, customers ASC;
-- South, in Spring all Electronics, Sports and Clothing have high per customer value even low customer base 
-- North, only Spring with Sports Category that could have high per customer value with low customer base 

-- ----------
-- Problem 3:
-- ---------- 
SELECT
    Retention_Strategy,
    COUNT(*) AS customers,
    ROUND(AVG(Lifetime_Value),2) AS avg_ltv,
    ROUND(AVG(Churn_Probability),2) AS avg_churn
FROM insight_table
WHERE Retention_Strategy IN ('Discount','Loyalty Program','Email Campaign')
GROUP BY Retention_Strategy;
-- Loyalty Program customers spend slightly more and are a bit less likely to churn, making that strategy the most efficient in the America Region 
