-- SECTION 1 : CUSTOMER VALUE & REVENUE 
-- Problem 1:How do LifetimeValue and Average_Order_Value differ by Most_Frequent_Category (Home, Electronics, Clothing, Sports)?
​-- Problem 2:Are there categories where customers have high Purchase_Frequency but low Average_Order_Value (or the opposite)?
​-- Problem 3:How does LifetimeValue differ by Season of Peak_Sales_Date (Spring, Summer, Fall, Winter)?
-- Problem 4: Which region (North vs South America) has higher average LifetimeValue and total LifetimeValue?
-- Problem 5: Which RetentionStrategy (Discount, Loyalty Program, Email Campaign) yields the highest LifetimeValue in North vs South America?
-- -----------------------------------------------------------------------------------

-- ----------
-- Problem 1: How do LifetimeValue and Average_Order_Value differ by Most_Frequent_Category (Home, Electronics, Clothing, Sports)?
-- ----------
CREATE VIEW insight_table AS 
  SELECT * 
    FROM sales_and_customer_insights
   WHERE Region LIKE "%America%";

Select * 
from insight_table;

SELECT 
	Most_Frequent_Category, 
    ROUND(AVG(Purchase_Frequency),2)  AS avg_purchase_frequency,
    ROUND(AVG(Average_Order_Value),2) AS avg_order_value ,
    ROUND(AVG(Lifetime_Value),2) AS avg_lifetime_value ,
    ROUND(SUM(Lifetime_Value),2) AS total_lifetime_value 
FROM insight_table 
GROUP BY Most_Frequent_Category 
ORDER BY avg_lifetime_value DESC; 
-- customer spend roughly the same per order for all categories, by then the difference come from purchase frequency and lifetime 
-- Sport have the highest average lifetime value, mean each sport customer valuable individually 
-- home have the highest total_lifetime value and lowest purchase frequency, mean home-focused customer spend more than others

-- ----------
-- Problem 2:Are there categories where customers have high Purchase_Frequency but low Average_Order_Value (or the opposite)?
-- ----------
WITH avg_value AS (
	SELECT 
		ROUND(AVG(Purchase_Frequency),2) AS avg_frequency, 
        ROUND(AVG(Average_Order_Value),2) AS avg_order_value
    FROM insight_table
), 
identify AS(
	SELECT 
		i.*,
        CASE 
			WHEN Purchase_Frequency >= a.avg_frequency
				AND Average_Order_Value < a.avg_order_value 
			THEN 'highFreq / lowOrderValue' 
            WHEN Purchase_Frequency < a.avg_frequency
				AND Average_Order_Value >= a.avg_order_value 
			THEN 'lowFreq / highOrderValue'
            WHEN Purchase_Frequency >= a.avg_frequency
				AND Average_Order_Value >= a.avg_order_value 
			THEN 'highFreq / highOrderValue'
            ELSE 'lowFreq / lowOrderValue'
		END AS segment_identify
	FROM insight_table as i 
    CROSS JOIN avg_value as a
)
SELECT 
	Most_Frequent_Category,
    segment_identify,
    count(*) as total_customer,
    ROUND(AVG(Purchase_Frequency),2) AS avg_frequency, 
	ROUND(AVG(Average_Order_Value),2) AS avg_order_value,
    ROUND(AVG(Lifetime_value),2) AS avg_lifetime_value
FROM identify 
WHERE segment_identify IN ('highFreq / lowOrderValue', 'lowFreq / highOrderValue')
GROUP BY Most_Frequent_Category, segment_identify
ORDER BY Most_Frequent_Category, segment_identify;
-- Many customers who buy often but small baskets.
-- Almost as many who buy rarely but with big baskets, and who end up at least as valuable over their lifetime.
-- That means the business should design two strategies per category:
-- For highFreq / lowOrderValue: focus on increasing basket size (bundles, add-ons, volume discounts).
-- For lowFreq / highOrderValue: focus on retention/reactivation (VIP perks, reminders, targeted offers) since every extra purchase from them is very profitable.

-- ----------
-- Problem 3:How does LifetimeValue differ by Season of Peak_Sales_Date (Spring, Summer, Fall, Winter)?
-- ----------
SELECT
	Season, 
    Count(*) AS total_customer,
	ROUND(AVG(Lifetime_Value),2) AS avg_lifetime_value,
    ROUND(SUM(Lifetime_value),2) AS total_lifetime_value,
    ROUND(AVG(Average_Order_Value),2) AS avg_order_value, 
    ROUND(AVG(Purchase_Frequency),2) AS avg_purchase_frequency 
FROM insight_table 
GROUP BY Season;
-- Spring and Summer are the most valuable customer, the summer is the peak with the highest of total_lifetime value 
-- Fall spend slightly more on order per value but the total lifetime value is the lowest, this could mean high percentage of churn 
-- the purchase frequency is stable 
-- Recommendation: 
-- prioritize acquisition and retention campaign in Spring and Summer, since these seasons can get highest return 
-- about Fall and Winter, focus on loyalty program such as off-season offers or something similar to gain engagement. 

-- ----------
-- Problem 4: Which region (North vs South America) has higher average LifetimeValue and total LifetimeValue?
-- ----------
SELECT 
	Region, 
    COUNT(*) AS total_customer,
    ROUND(AVG(Lifetime_Value),2) AS avg_lifetime_value, 
    ROUND(SUM(Lifetime_Value),2) AS total_lifetime_value, 
    ROUND(AVG(Average_Order_Value),2) AS avg_order_value,
    ROUND(AVG(Purchase_Frequency),2) AS avg_purchase_frequency
FROM insight_table 
GROUP BY Region;
-- South has higher total revenue due to higher customer and purchase frequency
-- the North customer is a bit more valuable 
-- recommendation: The North focus on inceasing the number of customer since each customer is already high value, the South focusing on retention and upsell to optimise the revenue. 

-- ----------
-- Problem 5: Which RetentionStrategy (Discount, Loyalty Program, Email Campaign) yields the highest LifetimeValue in North vs South America?
-- ----------
SELECT 
	Region, 
    COUNT(*) AS total_customer,
    Retention_Strategy, 
    ROUND(AVG(Lifetime_Value),2) AS avg_lifetime_value, 
    ROUND(SUM(Lifetime_Value),2) AS total_lifetime_value
FROM insight_table 
GROUP BY Region, Retention_Strategy
ORDER BY Region, Retention_Strategy DESC;
-- North, Email campaign has highest revenue due to large customer base, eventhough Loyalty program has highest customer value 
-- South, Loyalty program outperform email and Discount on total Revenue, but the customer value is highest from Email campaign 
-- Recommendation: North, Prioritize Loyalty campaign since the customer value from loyalty is high, invest in Email campaign to convert potential customer to loyalty program to lift their value. 
-- Recommendation: South, keep invest in Email campaign since they generate highest customer value. strengthen Loyalty program with email campaign to leverage the large base of customer and push total revenue. 
