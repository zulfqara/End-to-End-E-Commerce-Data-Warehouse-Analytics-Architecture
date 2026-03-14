
--YTD (Year-To-Date) cumulative analysis

WITH cummulative_analysis AS 
(
SELECT	
	YEAR(f.purchased_date) AS [year],
	MONTH(f.purchased_date) AS [month],
	COUNT(DISTINCT order_id) AS total_orders,
	CAST(SUM(f.price) AS INT) AS gross_merchandise_value,
	CAST(SUM(f.price)/COUNT(DISTINCT order_id) AS INT) AS average_order_value
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c
	ON f.customer_session_id = c.customer_session_id
GROUP BY YEAR(f.purchased_date),
	MONTH(f.purchased_date)
)

SELECT 
	[year],
	[month],
	total_orders,
	SUM(total_orders) OVER( PARTITION BY [year] ORDER BY [month]) AS running_total_orders,
	gross_merchandise_value,
	SUM(gross_merchandise_value) OVER( PARTITION BY [year] ORDER BY [month]) AS running_total_GMV,
	average_order_value
FROM cummulative_analysis

