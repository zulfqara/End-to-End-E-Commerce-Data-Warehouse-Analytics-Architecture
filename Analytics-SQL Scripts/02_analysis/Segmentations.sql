
/* ==============================================================================
   EXPLORATION: Customer Frequency & Retention
   Observation: Initial attempts to segment customers by a 12-month lifespan failed.
   Hypothesis: The business suffers from low retention / high one-time buyer rates.
   Result: Confirmed. 97% of the customer base are one-time buyers.
   Pivot: Proceeding to segment customers purely by Monetary Value (Spend) 
          rather than Frequency or Lifespan.
   ============================================================================== */



 /*Used Inner join instead of left, because there are few customers that do not have any transaction.
					Due to cancellation or something else*/

					
/*Deriving two types of insights from product_segmentation CTE. However, a CTE can only be used with single select statement.
So to use it, must remove one select statement temporarily
*/


WITH customer_segmentation As(
SELECT 
	c.customer_id,
	MIN(f.purchased_date) AS first_order,
	MAX(f.purchased_date) AS last_order,
	COUNT(DISTINCT order_id) AS total_orders,
	DATEDIFF(MONTH, MIN(f.purchased_date), MAX(f.purchased_date) ) AS lifespan,
	CAST(SUM(f.price) AS INT) AS total_spend,
	CASE
		WHEN CAST(SUM(f.price) AS INT) >=5000  THEN 'Premium'
		WHEN CAST(SUM(f.price) AS INT) >=2000  THEN 'High-Value'
		ELSE 'Regular'
	END customer_type,
	CASE 
		WHEN DATEDIFF( DAY, MAX(f.purchased_date), (SELECT MAX(purchased_date) FROM gold.fact_sales)) <120 THEN 'Active'
		WHEN DATEDIFF( DAY, MAX(f.purchased_date), (SELECT MAX(purchased_date) FROM gold.fact_sales)) BETWEEN 90 AND 180 THEN 'At Risk'
		ELSE 'Churned'
	END customer_status
FROM gold.dim_customers AS c
	INNER JOIN gold.fact_sales AS f
ON c.customer_session_id = f.customer_session_id
GROUP BY c.customer_id
)

--Customer Distribution based on Monetary Value:

SELECT
	customer_type,
	COUNT(customer_type)
FROM customer_segmentation
GROUP BY customer_type

-- Customer churn distribution by activity status

SELECT 
	customer_status,
	COUNT(customer_status)
FROM customer_segmentation
GROUP BY customer_status


--====================================================================================================================

-- Segmenting products by price and order volume

WITH product_segmentation AS (
SELECT 
	p.product_id,
	p.product_category,
	CAST(f.price AS INT) AS price,
	CASE 
		WHEN f.price >1000 THEN 'Premium'
		WHEN f.price BETWEEN 500 AND 1000 THEN 'High-Priced'
		WHEN f.price BETWEEN 100 AND 500 THEN 'Mid-Ranged'
		ELSE 'Low-Price'
	END price_category,
	COUNT(f.product_id) AS items_sold,
	CASE 
		WHEN COUNT(f.order_id) > 200 THEN 'Top Selling Products'
		WHEN COUNT(f.order_id) BETWEEN 150 AND 200 THEN 'Popular Products'
		WHEN COUNT(f.order_id) BETWEEN 100 AND 149 THEN 'Emerging Products'
		ELSE 'Low Demand'
	END performance

FROM gold.dim_products as p
LEFT JOIN gold.fact_sales AS f
	ON p.product_id = f.product_id
GROUP BY p.product_id, 
		p.product_category,
		price
)


-- Finding total number of products in each price category
SELECT 
	price_category,
	COUNT(price_category) AS total_products
FROM product_segmentation
GROUP BY price_category


--Finding total number of products sorting by performance level
SELECT 
	performance,
	COUNT(performance) AS total_products
FROM product_segmentation
GROUP BY performance

--==========================================================================================================================================

--1.Segmenting sellers based on their sales_value and order volume
--2.Segmenting sellers based on their recency days

WITH seller_segmentation AS (
SELECT
	seller_id,
	SUM(price) AS total_sales_value,
	COUNT(order_id) AS  completed_orders,
	MAX(purchased_date) AS last_order,

	CASE 
		WHEN SUM(price) >=9000 AND COUNT(order_id) > 39 THEN 'Premium Sellers'
		WHEN SUM(price) >=4700 AND COUNT(order_id) > 39 THEN 'Above Average Sellers'
		ELSE 'Regular Sellers'
	END seller_type,

	CASE
		WHEN DATEDIFF( DAY, MAX(purchased_date), (SELECT MAX(purchased_date) FROM gold.fact_sales)) <=10 THEN 'Active'
		WHEN DATEDIFF( DAY, MAX(purchased_date), (SELECT MAX(purchased_date) FROM gold.fact_sales)) BETWEEN 11 AND 20 THEN 'Slipping'
		ELSE 'Inactive'
	END seller_activity_status
 
FROM gold.fact_sales
	GROUP BY seller_id
)

--Seller activit distribution
SELECT
	seller_activity_status,
	COUNT(seller_activity_status)
FROM seller_segmentation
GROUP BY seller_activity_status

--Seller type distribution:

SELECT 
	seller_type,
	COUNT(seller_type)
FROM seller_segmentation
GROUP BY seller_type



