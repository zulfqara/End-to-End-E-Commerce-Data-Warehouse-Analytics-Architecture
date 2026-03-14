
--Top 10 Sellers By Orders
WITH seller_orders AS (
SELECT 
	seller_id,
	COUNT(DISTINCT order_id) AS total_orders
FROM gold.fact_sales 
GROUP BY seller_id
)
SELECT * FROM (
SELECT
	DENSE_RANK() OVER( ORDER BY total_orders DESC) as ranking,
	seller_id,
	total_orders
FROM seller_orders
)t
WHERE ranking <=10


--==========================================================

--Top 10 Sellers with highest revenue
WITH top_sellers_revenue  AS (
SELECT 
	s.seller_id,
	s.seller_city,
	CAST(SUM(f.price) AS INT) as total_revenue
FROM gold.dim_sellers AS s
LEFT JOIN gold.fact_sales AS f
	ON s.seller_id = f.seller_id
GROUP BY s.seller_id,
	s.seller_city
)

SELECT *
FROM (
SELECT 
	DENSE_RANK() OVER( ORDER BY total_revenue DESC) AS ranking,
	seller_id,
	seller_city,
	total_revenue
FROM top_sellers_revenue
)t
WHERE ranking <= 100

--================================================================================================


	--Top 10 expensive products sorted by price
SELECT *
FROM (
SELECT 
	DENSE_RANK() OVER( ORDER BY f.price DESC)  AS ranking,
	f.product_id,
	p.product_category,
	f.price
FROM gold.fact_sales as f
LEFT JOIN gold.dim_products as p
	ON f.product_id = p.product_id
)expensive_products
WHERE ranking <=10


--Top 10 Selling Products
WITH top_selling_products AS (
SELECT 
	p.product_id,
	p.product_category,
	COUNT(f.order_id) AS total_orders
FROM gold.dim_products AS P
LEFT JOIN gold.fact_sales AS f
	ON p.product_id = f.product_id
GROUP BY p.product_id, p.product_category
) 

SELECT *
FROM (
SELECT 
	DENSE_RANK() OVER( ORDER BY total_orders DESC) AS ranking,
	product_id,
	product_category,
	total_orders
FROM top_selling_products
)t
WHERE ranking <= 15

	--RANKING STATES BY ORDERS (TOP 5):
SELECT * 
FROM(
SELECT 
	c.[state],
	COUNT(DISTINCT order_id) AS total_orders,
	DENSE_RANK() OVER(ORDER BY COUNT(DISTINCT order_id) DESC) AS Ranking
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers as c
	ON f.customer_session_id = c.customer_session_id
GROUP BY c.[state]
)t
WHERE Ranking <=5



--Top 5 Customers with highest orders
SELECT *
FROM (
SELECT
	DENSE_RANK() OVER( ORDER BY COUNT(f.order_id) DESC ) AS ranking,
	c.customer_id,
	c.city,
	COUNT(f.order_id) AS  total_orders
FROM gold.dim_customers AS c
INNER JOIN gold.fact_sales as f
	ON c.customer_session_id = f.customer_session_id
GROUP BY c.customer_id, c.city
)top_customers_ord
WHERE ranking <= 5



--Top 10 Spending Customers
SELECT *
FROM (
SELECT 
	DENSE_RANK() OVER( ORDER BY CAST(SUM(f.price) AS INT) DESC ) AS ranking,
	c.customer_id,
	c.city,
	CAST(SUM(f.price) AS INT) as total_spend
FROM gold.dim_customers AS c
INNER JOIN gold.fact_sales as f
	ON c.customer_session_id = f.customer_session_id
GROUP BY c.customer_id, c.city
) top_spending_customers
WHERE ranking <= 10

--Top 10 most reviewed categories and their average ratings 
SELECT *
FROM (
SELECT 
	DENSE_RANK() OVER( ORDER BY COUNT(f.review_score)DESC) AS ranking, 
	product_category,
	COUNT(f.review_score) AS total_reviews,
	AVG(f.review_score) AS  aveage_rating
FROM gold.dim_products AS p 
LEFT JOIN gold.fact_sales  as f
	ON p.product_id = f.product_id
GROUP BY product_category
)most_reviwed_categories
WHERE ranking <= 10

--Top 10 most reviewed products with their average ratings
SELECT *
FROM (
SELECT 
	DENSE_RANK() OVER( ORDER BY COUNT(f.review_score) DESC) AS Ranking,
	f.product_id,
	p.product_category,
	COUNT(f.review_score) AS total_reviews,
	AVG(f.review_score) AS  aveage_rating
FROM gold.dim_products AS p 
LEFT JOIN gold.fact_sales  as f
	ON p.product_id = f.product_id
GROUP BY f.product_id, p.product_category
)most_reviewed_products
WHERE ranking <= 10

--Top 10 most reviewed seller's average ratings

SELECT *
FROM (
SELECT 
	DENSE_RANK() OVER(ORDER BY COUNT(f.review_score) DESC ) AS ranking,
	f.seller_id,
	s.seller_city,
	COUNT(f.review_score) as total_reviews,
	AVG(f.review_score) as average_ratings
FROM gold.fact_sales as f
LEFT JOIN gold.dim_sellers as s
	ON f.seller_id = s.seller_id
GROUP BY f.seller_id,s.seller_city
)seller_reviews
WHERE ranking <= 10



