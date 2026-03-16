CREATE OR ALTER VIEW  gold.report_market_basket_analysis AS 

WITH product_combinations AS (

SELECT 
	
    p1.product_id AS product_1,
    p2.product_id AS product_2,
    COUNT(*) AS times_bought_together
FROM gold.fact_sales AS p1
JOIN gold.fact_sales AS p2
    ON p1.order_id = p2.order_id            --  Combine products from the SAME order
    AND p1.product_id < p2.product_id --  Avoid duplicates (Order A-B is same as B-A)

GROUP BY 
    p1.product_id, 
    p2.product_id
)


SELECT 
	DENSE_RANK() OVER( ORDER BY times_bought_together DESC ) AS ranking,
	prd1.product_category  AS product_1_category,
	pc.product_1,
	prd2.product_category	AS product_2_category,
	pc.product_2,
	pc.times_bought_together
FROM product_combinations AS pc
LEFT JOIN gold.dim_products AS prd1
	ON prd1.product_id = pc.product_1
LEFT JOIN gold.dim_products AS prd2
	ON prd2.product_id = pc.product_2

WHERE pc.times_bought_together > 1			--Excluding accidental combinations/rare combinations (computer accessories and socks )

SELECT 
DISTINCT 
times_bought_together
FROM gold.report_market_basket_analysis
order by times_bought_together asc


