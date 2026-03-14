	--Total Products in each category Category

SELECT 
	product_category,
	COUNT(product_id) as total_products 
FROM gold.dim_products
GROUP BY product_category 
ORDER BY COUNT(product_id) DESC

-- Average price in each category
SELECT 
	product_category,
	CAST(AVG(price) AS INT) as average_price
FROM gold.dim_products as p
LEFT JOIN gold.fact_sales as f
	ON  p.product_id = f.product_id
GROUP BY product_category 
ORDER BY AVG(price) DESC

-- Average shippingc charges in each category
SELECT 
	product_category,
	CAST(AVG(shipping_charges) AS INT) as average_shipping_charges
FROM gold.dim_products as p
LEFT JOIN gold.fact_sales as f
	ON  p.product_id = f.product_id
GROUP BY product_category 
ORDER BY AVG(shipping_charges) DESC

	--Total Orders by Categories
SELECT 
	p.product_category,
	COUNT(DISTINCT order_id) as total_orders

FROM gold.fact_sales f
	LEFT JOIN gold.dim_products as p
ON f.product_id = p.product_id
	GROUP BY product_category
	ORDER BY COUNT(DISTINCT order_id) DESC


	

	--Purchased value by category
select 
	product_category,
	SUM(payment_value) purchased_value

from gold.fact_sales as f
LEFT JOIN gold.dim_products as p
	ON f.product_id = p.product_id
GROUP BY product_category
ORDER BY SUM(payment_value) DESC

--Total Customers by state

SELECT 
	c.state,
	COUNT(c.customer_id) as total_orders
FROM gold.dim_customers as c
INNER JOIN gold.fact_sales as f
	ON c.customer_session_id = f.customer_session_id
GROUP BY c.state
ORDER BY COUNT(c.customer_id) DESC

--Total sellers by state
SELECT 
	seller_state,
	COUNT(seller_id)
FROM gold.dim_sellers
GROUP BY seller_state
ORDER BY seller_state


			--Ratings
SELECT DISTINCT
	review_score,
	COUNT(review_score) total
FROM gold.fact_sales
GROUP BY review_score
ORDER BY COUNT(review_score) DESC


		--Most Used Payment Methods
SELECT DISTINCT
	payment_type,
	COUNT(payment_type) total_payments
FROM gold.fact_sales

WHERE payment_type IS NOT NULL
	GROUP BY payment_type
	ORDER BY COUNT(payment_type) DESC


--Total Purchased Value by Each Customer

SELECT 
	 c.customer_id,
	CAST(SUM(f.price) AS INT) as total_spend

FROM gold.dim_customers as c
INNER JOIN gold.fact_sales as f
	ON c.customer_session_id = f.customer_session_id
GROUP BY  customer_id
ORDER BY SUM(f.price) DESC


--Average weight, height, lenth, width of products by category

SELECT 
	product_category,
	AVG(product_weight_g) AS average_weight_g ,
	AVG(product_height_cm) AS average_height_cm,
	AVG(product_length_cm)AS average_length_cm,
	AVG(product_width_cm) AS average_width_cm
FROM gold.dim_products
GROUP BY product_category
ORDER BY AVG(product_weight_g) DESC


