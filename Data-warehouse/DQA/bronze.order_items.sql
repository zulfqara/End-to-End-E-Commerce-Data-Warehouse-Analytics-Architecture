

SELECT

'bronze.order_items' as table_name,
COUNT(*) AS total_rows,

count(order_id) - count(distinct order_id) as dup_ord,
SUM( CASE WHEN order_id is null or TRIM(order_id)  = '' THEN 1 ELSE 0 END) AS missing_ord_id,
SUM( CASE WHEN order_id != TRIM(order_id) THEN 1 ELSE 0 END) AS whitespace_ord_id,

count(product_id) - count(distinct product_id) as dup_prd,
SUM( CASE WHEN product_id is null or TRIM(product_id)  = '' THEN 1 ELSE 0 END) AS missing_prd_id,
SUM( CASE WHEN product_id != TRIM(product_id) THEN 1 ELSE 0 END) AS whitespace_prd_id,

SUM( CASE WHEN seller_id is null or TRIM(seller_id)  = '' THEN 1 ELSE 0 END) AS missing_seller_id,
SUM( CASE WHEN seller_id != TRIM(seller_id) THEN 1 ELSE 0 END) AS whitespace_seller_id,

SUM( CASE WHEN shipping_limit_date is null or TRIM(CAST( shipping_limit_date AS VARCHAR))  = '' THEN 1 ELSE 0 END) AS missing_shipping_limit_date,
SUM( CASE WHEN shipping_limit_date != TRIM(CAST(shipping_limit_date AS VARCHAR)) THEN 1 ELSE 0 END) AS whitespace_shipping_limit_date,

SUM( CASE WHEN price is null OR price = 0 THEN 1 ELSE 0 END) AS missing_price,
SUM( CASE WHEN ISNUMERIC(price) = 0 THEN 1 ELSE 0 END) AS price_datatype_check,

SUM( CASE WHEN freight_value is null OR freight_value = 0 THEN 1 ELSE 0 END) AS missing_freight_value,
SUM( CASE WHEN ISNUMERIC(freight_value) = 0 THEN 1 ELSE 0 END) AS freight_datatype_check


FROM bronze.order_items
