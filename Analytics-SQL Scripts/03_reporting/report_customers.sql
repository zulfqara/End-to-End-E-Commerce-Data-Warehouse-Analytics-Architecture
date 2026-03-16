CREATE or alter VIEW gold.report_customers AS

WITH  customers_summary AS (
SELECT 
	c.customer_id, 
	c.city,
	c.zipcode,
	c.state,
	COUNT(DISTINCT order_id) AS total_orders,
	SUM(f.price) AS total_spend,
	MIN(f.purchased_date) AS first_order,
	MAX(purchased_date) AS last_order,
	DATEDIFF(month, MIN(f.purchased_date), MAX(f.purchased_date)) AS lifespan,
	DATEDIFF( MONTH, MAX(f.purchased_date), (SELECT MAX(purchased_date) FROM gold.fact_sales)) AS recency

FROM gold.dim_customers AS c
INNER JOIN gold.fact_sales AS f
ON c.customer_session_id = f.customer_session_id
GROUP BY customer_id,
	city,
	zipcode,
	state
)


SELECT 
	customer_id,
	city,
	zipcode,
	state,
	first_order,
	last_order,
	lifespan,
	recency,
	total_orders,
	total_spend,

	--Segmenting customers based on their spending
	CASE
		WHEN CAST(total_spend AS INT) >=5000  THEN 'Premium'
		WHEN CAST(total_spend AS INT) >=2000  THEN 'High-Value'
		ELSE 'Regular'
	END customer_type,

-- Categorize customers by retention status and churn risk
	CASE 
		WHEN recency <4 THEN 'Active'
		WHEN recency BETWEEN 4 AND 6 THEN 'At Risk'
		ELSE 'Churned'
		END customer_status,

	-- Compute average order value (AVO)
	CASE
		WHEN total_spend = 0 THEN 0
		ELSE CAST(total_spend / total_orders AS DECIMAL(10,2))
	END AS avg_order_value,

	--behavioral segmentation
	 CASE 
		WHEN total_orders = 1 THEN 'One-Time'
		WHEN total_orders BETWEEN 2 AND 4 THEN 'Ocassional Buyer'
		ELSE 'Frequent Customer'
	END customer_behavior,
	
-- Compute average monthly spend
	CASE
		WHEN lifespan = 0 THEN total_spend
		ELSE total_spend / lifespan
	END AS avg_monthly_spend

FROM customers_summary

