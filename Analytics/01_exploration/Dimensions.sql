--Retreiving States

SELECT DISTINCT 
    state
FROM gold.dim_customers
ORDER BY state
  
SELECT DISTINCT
seller_state
FROM gold.dim_sellers
ORDER BY seller_state

  -- Retreiving product categories
SELECT DISTINCT
	product_category
FROM gold.dim_products
ORDER BY product_category

