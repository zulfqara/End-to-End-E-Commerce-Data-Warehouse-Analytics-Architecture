
/* Exploratory Query: Buying Behavior Segmentation
Goal: Test if our customer base is dominated by one-time buyers.
*/


--List of sellers who remianed inactive throughout the period:

SELECT d.seller_id
FROM gold.dim_sellers AS d
WHERE NOT EXISTS (
    -- Correlated subquery to ensure the seller has no recorded sales
    SELECT 1
    FROM gold.fact_sales AS f
		WHERE f.seller_id = d.seller_id
)

--=================================================================================================


WITH customer_behavior AS (
    SELECT 
        c.customer_id,
        COUNT(DISTINCT f.order_id) AS total_orders,
        CAST(SUM(f.price) AS INT) AS total_spend
    FROM gold.dim_customers c
    INNER JOIN gold.fact_sales f 
        ON c.customer_session_id = f.customer_session_id
    GROUP BY c.customer_id
)

SELECT 
    CASE 
        WHEN total_orders >= 3 THEN '3. Highly Frequent (3+ Orders)'
        WHEN total_orders = 2 THEN '2. Repeat Buyer (2 Orders)'
        ELSE '1. One-Time Buyer (1 Order)'
    END AS buying_segment,
    
    COUNT(customer_id) AS total_customers,
    SUM(total_spend) AS segment_revenue

FROM customer_behavior
GROUP BY 
    CASE 
        WHEN total_orders >= 3 THEN '3. Highly Frequent (3+ Orders)'
        WHEN total_orders = 2 THEN '2. Repeat Buyer (2 Orders)'
        ELSE '1. One-Time Buyer (1 Order)'
    END
ORDER BY buying_segment DESC;



WITH seller_behavior AS (
    SELECT 
        seller_id,
        COUNT(DISTINCT order_id) AS total_orders,
        CAST(SUM(price) AS INT) AS total_spend
    FROM gold.fact_sales
	GROUP BY seller_id
)
SELECT 

    CASE 
        WHEN total_orders >= 3 THEN '3. Highly Frequent (3+ Orders)'
        WHEN total_orders = 2 THEN '2. Repeat orders (2 Orders)'
        ELSE 'Single Orders'
    END AS buying_segment,
    
    COUNT(seller_id) AS total_customers,
    SUM(total_spend) AS segment_revenue

FROM seller_behavior
GROUP BY 
    CASE 
        WHEN total_orders >= 3 THEN '3. Highly Frequent (3+ Orders)'
        WHEN total_orders = 2 THEN '2. Repeat orders (2 Orders)'
        ELSE 'Single Orders'
    END 
ORDER BY buying_segment DESC;


--How many days usually pass between orders for active customers?

SELECT
AVG(duration) AS average_repurchase_cycle
FROM (
SELECT
    DATEDIFF(day,
        LAG(f.purchased_date) OVER (PARTITION BY c.customer_id ORDER BY f.purchased_date),
        purchased_date) as duration
FROM gold.dim_customers as c
INNER JOIN gold.fact_sales as f
ON c.customer_session_id = f.customer_session_id
)t
WHERE duration != 0

--How many days usually pass between orders for active sellers?

SELECT
AVG(duration) 
FROM (
SELECT
    DATEDIFF(day,
        LAG(f.purchased_date) OVER (PARTITION BY f.seller_id ORDER BY f.purchased_date),
        purchased_date) as duration
FROM gold.fact_sales as f

)t
where duration != 0



