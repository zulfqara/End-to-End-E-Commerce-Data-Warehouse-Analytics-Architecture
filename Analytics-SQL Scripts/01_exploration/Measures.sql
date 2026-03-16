--Gross Merchant Value (GVM):
SELECT 
	'GVM' AS measure_name,
	CAST(SUM(price) AS INT) AS measure_value
FROM gold.fact_sales

UNION ALL

--Total orders
SELECT
	'Total Orders',
	COUNT(DISTINCT order_id)
FROM gold.fact_sales

UNION ALL

--Total Customers
SELECT
'Total Unique Customers',
COUNT( DISTINCT  customer_id)
FROM gold.dim_customers

UNION ALL

		--Total Returning Customers
SELECT 
'Returning Customer',
COUNT(*)
FROM
(
SELECT 
	customer_id,
	COUNT(customer_session_id) AS total_visits
FROM gold.dim_customers
GROUP BY customer_id
HAVING COUNT(customer_session_id) > 1
)t

UNION ALL

--Unsuccessfull Orders


SELECT 
	'Unsuccessfull Orders',
	 COUNT(c.customer_session_id) - COUNT(f.customer_session_id)
FROM gold.dim_customers as c
LEFT JOIN gold.fact_sales as f
	ON c.customer_session_id = f.customer_session_id

UNION ALL

--Average Price

SELECT 
	'Average Price',
	CAST(AVG(price) AS INT)
FROM gold.fact_sales

UNION ALL

--Average Shipping Charges
SELECT 
	'Average Shipping Charges',
	CAST(AVG(shipping_charges) AS INT)
FROM gold.fact_sales

UNION ALL

SELECT 
	'Lowest Price',
	CAST(MIN(price) AS INT)
FROM gold.fact_sales

UNION ALL

SELECT 
	'Highest Price',
	CAST(MAX(price) AS INT)
FROM gold.fact_sales

