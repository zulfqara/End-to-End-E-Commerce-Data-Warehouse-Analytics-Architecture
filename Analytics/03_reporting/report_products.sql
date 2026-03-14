CREATE OR ALTER VIEW gold.report_products AS 

WITH max_date_dateset AS  (
SELECT 
	MAX(purchased_date) AS max_date_dateset
FROM gold.fact_sales
)

, products_summary AS (

SELECT 
	p.product_id,
	p.product_category,
	f.seller_id,
	MIN(f.purchased_date) AS first_sale_date,
    MAX(f.purchased_date) AS last_sale_date,
	DATEDIFF(DAY, MIN(f.purchased_date), MAX(f.purchased_date) ) AS lifespan_days,
	DATEDIFF(MONTH, MAX(f.purchased_date), (SELECT max_date_dateset FROM max_date_dateset) ) AS recency_months,
	COUNT(DISTINCT f.order_id) AS total_orders, --distinct shopping carts
	COUNT(f.order_id) AS 	items_sold,
	SUM(f.price) AS product_gmv, --Delivered Only
	COUNT(DISTINCT c.customer_id) AS unique_customers,
	 AVG(review_score) AS average_ratings
	
FROM gold.dim_products AS p

LEFT JOIN gold.fact_sales AS f
	ON p.product_id = f.product_id

LEFT JOIN gold.dim_customers AS c
	ON	f.customer_session_id = c.customer_session_id

GROUP BY p.product_id,
		p.product_category,
		f.seller_id
		
)
, product_segmentation AS (
SELECT 
	product_id,
	product_category,
	COALESCE(seller_id , 'Unsold') AS seller_id,
	first_sale_date,
	last_sale_date,
	lifespan_days,
	recency_months,
	total_orders,
	items_sold,
	unique_customers,
	COALESCE(product_gmv , 0) AS product_gmv,
	average_ratings,

CASE 
    WHEN total_orders >= 500 THEN 'Hero'
    WHEN total_orders BETWEEN 100 AND 499 THEN 'Star'
    WHEN total_orders BETWEEN 20 AND 99 THEN 'Proven'
    WHEN total_orders BETWEEN 5 AND 19 THEN 'Emerging'
    WHEN total_orders BETWEEN 2 AND 4 THEN 'Tester'
    WHEN total_orders = 1 THEN 'One-Timer'
    ELSE 'Dead Stock' -- Orders = 0
END

		--Metric: AOV
	CASE 
		WHEN total_orders = 0 THEN CAST(total_orders AS DECIMAL(10,2)) 
		ELSE CAST(  product_gmv/(items_sold*1.0) AS DECIMAL(10,2) )
	END  average_selling_price,


	--Average duration for the order
	CASE 
		WHEN lifespan_days = 0 THEN CAST( total_orders AS DECIMAL(10,2))
		ELSE CAST( total_orders*1.0/lifespan_days AS DECIMAL(10,2) ) --Multiplied by 1.0 to convert the datatype to float to prevent integer division
	END daily_order_velocity

FROM products_summary
)




SELECT 
	product_id,
	product_category,
	seller_id,
	first_sale_date,
	last_sale_date,
	lifespan_days,
	recency_months,
	total_orders,
	performance,
	items_sold,
	unique_customers,
    average_ratings,
	CASE		
		WHEN average_ratings is NULL THEN 'Unrated'
		WHEN average_ratings <3 THEN 'Bronze'
		WHEN average_ratings BETWEEN 3 AND 4  THEN 'Silver'
		ELSE 'Gold'
	END customer_sentiment,

	 product_gmv,
	average_selling_price,

	COALESCE(daily_order_velocity, 0) AS daily_order_velocity,
	CASE 
		WHEN daily_order_velocity <=0.99 THEN 'Cold'
		WHEN daily_order_velocity BETWEEN 1 AND 3.99 THEN 'Consistent'
		ELSE 'Hot-Listings'
	END sales_momentum

FROM product_segmentation

select distinct performance
from gold.report_products