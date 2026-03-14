--Top N + Others" logic

WITH  category_sales AS (
SELECT 
	p.product_category,
	SUM(f.price)	AS total_sales_value

FROM gold.dim_products AS p
LEFT JOIN gold.fact_sales AS f
	ON p.product_id = f.product_id
GROUP BY p.product_category
)
, rank_category_sales AS (

SELECT 
	
	product_category,
	total_sales_value,
	SUM(total_sales_value) OVER()	AS overall_sales_value,

	--Cast to DECIMAL to eliminate trailing zeros for clean percentage formatting
	CAST((COALESCE(total_sales_value, 0.0)/SUM(total_sales_value) OVER())  * 100  AS DECIMAL(10,2))	AS percentage_of_total


FROM category_sales

)


SELECT 
	product_category,
	total_sales_value,
	overall_sales_value,
	percentage_of_total,
	--Strategy for the visualisation part
	DENSE_RANK() OVER(ORDER BY percentage_of_total DESC )	AS [rank],
	CASE 
	WHEN DENSE_RANK() OVER(ORDER BY percentage_of_total DESC ) > 4 THEN 'Others'
	ELSE product_category  -- Shows the acutal category name in Top 5
	END category_segment
	
FROM rank_category_sales

--=======================================================================================================

/*States' Market Share Analyses
Purpose: To identify the states contributing most to the sales_value

*/

WITH sales_by_state AS (
SELECT 
	c.[state] ,
	SUM(f.price) AS total_sales
FROM gold.dim_customers		AS  c
INNER JOIN gold.fact_sales  AS  f
ON c.customer_session_id = f.customer_session_id
GROUP BY c.[state]
)
, rank_state_sales AS (
SELECT 
	[state],
	total_sales,
	SUM(total_sales) OVER() AS overall_total_sales,
	CAST((total_sales/SUM(total_sales) OVER() ) * 100 AS DECIMAL(10,2)) AS percentage_of_total
FROM sales_by_state
)

SELECT 
	[state],
	total_sales,
	overall_total_sales,
	percentage_of_total,
	DENSE_RANK() OVER( ORDER BY percentage_of_total DESC)  AS state_rank,
	CASE 
	WHEN DENSE_RANK() OVER( ORDER BY percentage_of_total DESC)  > 4 THEN 'Others'
	ELSE [state]
	END sate_segment
FROM rank_state_sales 


