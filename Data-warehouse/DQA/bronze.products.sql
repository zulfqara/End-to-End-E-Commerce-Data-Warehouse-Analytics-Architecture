



select 
'bronze.products' as table_name,
COUNT(*) AS total_rows,

count(product_id) - count(distinct product_id) as dup_prd,
SUM( CASE WHEN product_id is null or TRIM(product_id)  = '' THEN 1 ELSE 0 END) AS missing_prd_id,
SUM( CASE WHEN product_id != TRIM(product_id) THEN 1 ELSE 0 END) AS whitespace_prd_id,

SUM( CASE WHEN product_category is null or TRIM(product_category)  = '' THEN 1 ELSE 0 END) AS missing_prd_category,
SUM( CASE WHEN product_category != TRIM(product_category) THEN 1 ELSE 0 END) AS whitespace_prd_category,

SUM( CASE WHEN product_weight_g is null or TRIM(CAST(product_category AS VARCHAR))  = '' THEN 1 ELSE 0 END) AS missing_prd_weight,
SUM( CASE WHEN product_weight_g < =0 THEN 1 ELSE 0 END) AS invalid_prd_weight,

SUM( CASE WHEN product_length_cm is null or TRIM(CAST(product_length_cm AS VARCHAR))  = '' THEN 1 ELSE 0 END) AS missing_prd_length,
SUM( CASE WHEN product_length_cm < =0 THEN 1 ELSE 0 END) AS invalid_prd_length,

SUM( CASE WHEN product_height_cm is null or TRIM(CAST(product_height_cm AS VARCHAR))  = '' THEN 1 ELSE 0 END) AS missing_prd_height,
SUM( CASE WHEN product_height_cm < =0 THEN 1 ELSE 0 END) AS invalid_prd_height,

SUM( CASE WHEN product_width_cm is null or TRIM(CAST(product_width_cm AS VARCHAR))  = '' THEN 1 ELSE 0 END) AS missing_prd_width,
SUM( CASE WHEN product_width_cm < =0 THEN 1 ELSE 0 END) AS invalid_prd_width


FROM bronze.products





