
-- MoM-Change Over Time Analysis

WITH change_over_time_analysis AS (
    SELECT
        DATETRUNC(MONTH, purchased_date) AS order_date,
        COUNT(DISTINCT order_id) AS total_orders,
        CAST(SUM(f.price) AS INT) AS gross_merchandise_value,
        CAST(SUM(f.price)/COUNT(DISTINCT order_id) AS INT) AS average_order_value
    FROM gold.fact_sales AS f
    GROUP BY DATETRUNC(MONTH, purchased_date)
)

SELECT
    order_date,
    total_orders,
    CAST(100.0 * (total_orders - LAG(total_orders) OVER(ORDER BY order_date)) / NULLIF(LAG(total_orders) OVER(ORDER BY order_date), 0) AS DECIMAL(10,2)) AS [mom_orders_growth_%],
    gross_merchandise_value,
    CAST( 100.0 * (gross_merchandise_value - LAG(gross_merchandise_value) OVER(ORDER BY order_date)) / 
			NULLIF(LAG(gross_merchandise_value) OVER(ORDER BY order_date), 0) AS DECIMAL(10,2)) AS [mom_gmv_growth-%],
    average_order_value,
    CAST(100.0 * (average_order_value - LAG(average_order_value) OVER(ORDER BY order_date)) / NULLIF(LAG(average_order_value) OVER(ORDER BY order_date), 0) AS DECIMAL(10,2)) AS [mom_aov_growth_%]
FROM change_over_time_analysis
ORDER BY order_date;
