select 
SUM( CASE WHEN seller_id is null or TRIM(seller_id )  = '' THEN 1 ELSE 0 END) AS missing_review_id,
SUM( CASE WHEN seller_id  != TRIM(seller_id ) THEN 1 ELSE 0 END) AS whitespace_review_id,

SUM( CASE WHEN seller_zip_code_prefix is null or TRIM(CAST(seller_zip_code_prefix AS VARCHAR))  = '' THEN 1 ELSE 0 END) AS missing_seller_city,
SUM( CASE WHEN seller_zip_code_prefix != TRIM(CAST(seller_zip_code_prefix AS VARCHAR)) THEN 1 ELSE 0 END) AS whitespace_seller_zip_code,
SUM( CASE WHEN LEN(seller_zip_code_prefix)  >5 THEN 1 ELSE 0 END) AS invalid_seller_zip_code,

SUM( CASE WHEN seller_city is null or TRIM(seller_city)  = '' THEN 1 ELSE 0 END) AS missing_seller_city,
SUM( CASE WHEN seller_city != TRIM(seller_city) THEN 1 ELSE 0 END) AS whitespace_seller_city,

SUM( CASE WHEN seller_state is null or TRIM(seller_state)  = '' THEN 1 ELSE 0 END) AS missing_seller_state,
SUM( CASE WHEN seller_state != TRIM(seller_state) THEN 1 ELSE 0 END) AS whitespace_seller_state

from bronze.sellers