WITH product_category_performance AS (
    SELECT 
        p.product_category,
        COUNT(f.order_id)           AS total_orders,
        CAST(SUM(f.price) AS INT)   AS total_revenue,
        MAX(f.purchased_date)       AS last_order
    FROM gold.dim_products AS p
    LEFT JOIN gold.fact_sales AS f
        ON p.product_id = f.product_id
    GROUP BY p.product_category
)

SELECT 
    (SELECT COUNT(DISTINCT p.product_category) FROM gold.dim_products AS p)                            AS total_categories,
    COUNT(product_category)                                                                   AS period_active_categories,
    (SELECT COUNT(p.product_category) FROM gold.dim_products AS p) - COUNT(product_category) AS period_inactive_categories,

    -- Volume Stats
    MIN(total_orders)   AS min_orders,
    AVG(total_orders)   AS avg_orders,
    MAX(total_orders)   AS max_orders,

    -- Revenue Stats
    MIN(total_revenue)  AS min_revenue,
    AVG(total_revenue)  AS avg_revenue,
    MAX(total_revenue)  AS max_revenue

FROM product_category_performance;



--=======================================================================================================================================================================

/* Seller Performance Distribution
   Purpose: Find the baseline averages for Revenue and Orders to build our matrix.
*/

WITH seller_performance AS (
    SELECT 
        seller_id,
        COUNT(order_id) AS total_orders,
        CAST(SUM(price) AS INT) AS total_revenue,
		MAX(purchased_date) AS last_order
    FROM gold.fact_sales
    GROUP BY seller_id
)

SELECT 

	(SELECT COUNT(seller_id) FROM gold.dim_sellers) AS total_registered_sellers,
    COUNT(seller_id) AS period_active_sellers,
	(SELECT COUNT(seller_id) FROM gold.dim_sellers)- COUNT(seller_id) AS period_inactive_sellers,
    
	--Average Order Gap

    -- Volume Stats
    MIN(total_orders) AS min_orders,
    AVG(total_orders) AS avg_orders,
    MAX(total_orders) AS max_orders,
    
    -- Revenue Stats
    MIN(total_revenue) AS min_revenue,
    AVG(total_revenue) AS avg_revenue,
    MAX(total_revenue) AS max_revenue

FROM seller_performance;


--seller performance 

WITH seller_monthly_performance AS (
    SELECT
        DATETRUNC(MONTH, purchased_date) AS performance_month,
        seller_id,
        SUM(price) AS monthly_sales_value,
        COUNT(order_id) AS monthly_orders,
        CAST(SUM(price) / NULLIF(COUNT(order_id), 0) AS INT) AS monthly_avg_order_value
    FROM gold.fact_sales
    GROUP BY
        seller_id,
        DATETRUNC(MONTH, purchased_date)
),

previous_month_seller_performance AS (
    SELECT
        performance_month,
        seller_id,
        monthly_orders,
        monthly_sales_value,
        monthly_avg_order_value,

        LAG(monthly_orders)
            OVER (ORDER BY performance_month) AS prv_monthly_orders,

        LAG(monthly_sales_value)
            OVER (ORDER BY performance_month) AS prv_month_sales_value,

        LAG(monthly_avg_order_value)
            OVER (ORDER BY performance_month) AS prv_month_aov

    FROM seller_monthly_performance
)

SELECT
    performance_month,
    seller_id,
    monthly_orders,
    prv_monthly_orders,
    monthly_orders - prv_monthly_orders          AS monthly_order_diff,

    monthly_sales_value,
    prv_month_sales_value,

    CAST(
        100.0 * (monthly_sales_value - prv_month_sales_value)
        / NULLIF(prv_month_sales_value, 0)
        AS DECIMAL(10, 2)
    ) AS [monthly_sales_growth_%],

    monthly_avg_order_value,
    prv_month_aov,
    monthly_avg_order_value - prv_month_aov      AS diff_prv_aov

FROM previous_month_seller_performance
ORDER BY
    performance_month;  -- Explicitly ordered by performance_month for clarity, even though LAG already imposes ordering
