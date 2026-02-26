-- SECTION 2: CHURN AND RETENTION RISK 
-- Problem 1: What is the average Churn rate in NOrth and South 
-- Problem 2: For American customer, which retention strategy and category have the lowest churn rate? 
-- Prblem 3: does higher Purchase Frquency or higher Average Order Value correlate more strongly with lower Churn Rate ? 
-- Problem 4: Are there Seasons where churn is systematically higher for American customers after their PeakSalesDate?

-- ----------
-- Problem 1:
-- ----------
SELECT 
	Region, 
    ROUND(AVG(Churn_Probability),2) AS avg_churn_rate 
FROM insight_table
GROUP BY Region;
-- the average rate is 0.5 in both North and South Region 

-- ----------
-- Problem 2:
-- ----------
SELECT
	Most_Frequent_Category, 
    Retention_Strategy, 
    COUNT(*) AS Total_customer, 
    ROUND(AVG(Churn_Probability),2) AS avg_churn_rate
FROM insight_table 
GROUP BY Most_Frequent_Category, Retention_Strategy
ORDER BY avg_churn_rate DESC; 
-- Loyalty Program has the lowest churn rate, lower then 50% 
-- Sports and loyalty program has the lowest churn rate at 46% 
-- recommendation: move customer Electronics and Sport from Discount offer to Loyalty Program since they show the biggest churn risk 
-- for Clothing and Home, prioritize Loyalty Program since they keep churn below 50% rate. 

-- ----------
-- Problem 3: does higher Purchase Frquency or higher Average Order Value correlate more strongly with lower Churn Rate ? \
-- ----------
WITH avg_value AS(
	SELECT 
		ROUND(AVG(Purchase_Frequency),2) AS avg_pf,
        ROUND(AVG(Average_Order_Value),2) AS avg_aov 
	FROM insight_table
),	
avg_buckets AS (
	SELECT 
		i.Purchase_Frequency, 
        i.Average_Order_Value,
        i.Churn_Probability, 
        CASE 
			WHEN i.Purchase_Frequency >= a.avg_pf THEN 'High PF' 
            ELSE 'Low PF' 
		END AS frequency_bucket, 
        CASE 
			WHEN i.Average_Order_Value >= a.avg_aov THEN 'High AOV'
            ELSE 'Low AOV' 
		END AS aov_bucket
	FROM insight_table as i
    CROSS JOIN avg_value as a
)
SELECT 
	frequency_bucket,
    aov_bucket,
    AVG(Churn_Probability) AS avg_churn 
FROM avg_buckets
GROUP BY frequency_bucket,aov_bucket;
-- neither purchase frquency nor aov correlate strongly with the lower churn rate, since all the value sit at 0.49 - 0.51, the differences are so small that not indicate a strong relationship 

-- churn by Retention Strategy
SELECT
    Retention_Strategy,
    AVG(Churn_Probability) AS avg_churn
FROM insight_table
GROUP BY Retention_Strategy
ORDER BY avg_churn;
-- Loyalty program is the retention with lowest churn rate 
-- Discount and Email have above avg churn rate, focus on offer to convert customer to Loyalty Program to optimise the customer pool. 

-- churn by Category
SELECT
    Most_Frequent_Category,
    AVG(Churn_Probability) AS avg_churn
FROM insight_table
GROUP BY Most_Frequent_Category
ORDER BY avg_churn;
-- Electronics segment have the highest churn rate, it's better to focus on the post-purchase program for electronic product 
-- home and clothing have the avg rate, but still need to be keep in mind 
-- Sport has the below average rate churn 

-- ----------
-- Problem 4: Are there Seasons where churn is systematically higher for American customers after their PeakSalesDate?\
-- ----------
SELECT
    Region,
    Season,
    AVG(Churn_Probability) AS avg_churn,
    COUNT(*)              AS total_customers
FROM insight_table
GROUP BY Region, Season
ORDER BY Region, avg_churn DESC;
