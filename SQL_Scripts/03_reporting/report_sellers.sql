CREATE VIEW gold.report_sellers AS 

WITH max_date_dateset AS  (
SELECT 
	MAX(purchased_date) AS global_max_date
FROM gold.fact_sales
)
, seller_summary AS (
SELECT 
	s.seller_id,
	s.seller_zipcode,
	s.seller_city,
	s.seller_state,
	MIN(f.purchased_date) AS first_order,
	MAX(f.purchased_date) AS last_order,
	DATEDIFF( DAY , MIN(f.purchased_date), MAX(f.purchased_date)) AS lifespan_days,
	DATEDIFF( MONTH,  MAX(f.purchased_date), (SELECT global_max_date FROM max_date_dateset) ) AS recency_months,
	COUNT(DISTINCT f.order_id) AS distinct_orders,
	COUNT(f.order_id) AS total_products_sold,
	COUNT(DISTINCT product_id) AS unique_products_sold,
	SUM(f.price) AS seller_gmv,									--Delivered Only
	AVG(review_score) AS average_ratings
	
FROM gold.dim_sellers AS s
LEFT JOIN  gold.fact_sales AS f
ON	s.seller_id = f.seller_id
GROUP BY s.seller_id,
		s.seller_zipcode,
		s.seller_city,
		s.seller_state
)
, seller_segmentation AS (
SELECT
	seller_id,
	seller_zipcode,
	seller_city,
	seller_state,
	first_order,
	last_order,
	lifespan_days,
	recency_months,
	distinct_orders,
	total_products_sold,
	unique_products_sold,
	COALESCE(seller_gmv, 0 ) AS seller_gmv,        --Delivered Only
	average_ratings,
	CASE 
		WHEN total_products_sold = 0 THEN total_products_sold
		ELSE CAST( COALESCE(seller_gmv/total_products_sold , 0 )  AS DECIMAL(10,2) ) 
	END AS average_selling_price,
	CASE 
		WHEN distinct_orders = 0 THEN total_products_sold
		ELSE CAST( COALESCE(seller_gmv/distinct_orders , 0 )  AS DECIMAL(10,2) ) 
	END AS average_order_value,
	
	CASE 
		WHEN last_order is NULL THEN 'Inactive_throughout_period'
		ELSE 
			CASE 
					WHEN seller_gmv >=9000 AND distinct_orders > 39 THEN 'Premium Seller'
					WHEN seller_gmv >=4700 AND distinct_orders > 39 THEN 'Above Average Seller'
					ELSE 'Regular Sellers'
			END
	END seller_type,
	CASE 
		WHEN last_order is NULL THEN 'Inactive_throughout_period'
		ELSE 
			CASE
				WHEN recency_months = 0 THEN 'Active'
				WHEN recency_months BETWEEN 1 AND 2 THEN 'Slipping'
				ELSE 'Inactive'
			END
	END seller_activity_status,

	CASE 
		WHEN last_order is NULL THEN 'N/A'				--To show inactive sellers throughout the periods
		WHEN average_ratings is NULL THEN 'Unrated'  --Explicitly checked for unrated seller's product,though there were no unrated sellers'product
		ELSE 
			CASE
				WHEN average_ratings > 4 THEN 'Gold'
				WHEN average_ratings BETWEEN 3 AND 4 THEN  'Silver'
			ELSE 'Bronze'
			END
	END seller_tier

FROM seller_summary
)

SELECT 
	seller_id,
	seller_zipcode,
	seller_city,
	seller_state,
	first_order,
	last_order,
	lifespan_days,
	recency_months,
	distinct_orders,
	total_products_sold,
	unique_products_sold,
	seller_gmv,									--Delivered Only
	average_ratings,
	average_order_value,
	seller_type,
	seller_activity_status,
	seller_tier

FROM seller_segmentation

sel