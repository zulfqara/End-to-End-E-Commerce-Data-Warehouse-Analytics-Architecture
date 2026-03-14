

SELECT
'bronze.order_review_ratings' as table_name,
COUNT(*) AS total_rows,

SUM( CASE WHEN review_id is null or TRIM(review_id )  = '' THEN 1 ELSE 0 END) AS missing_review_id,
SUM( CASE WHEN review_id  != TRIM(review_id ) THEN 1 ELSE 0 END) AS whitespace_review_id,

SUM( CASE WHEN order_id is null or TRIM(order_id)  = '' THEN 1 ELSE 0 END) AS missing_ord_id,
SUM( CASE WHEN order_id != TRIM(order_id) THEN 1 ELSE 0 END) AS whitespace_ord_id,



SUM(CASE WHEN review_creation_date IS NULL OR TRIM(CAST(review_creation_date AS VARCHAR)) = '' THEN 1 ELSE 0 END) AS missing_review_creation_date,
SUM(CASE WHEN review_creation_date != TRIM(CAST(review_creation_date AS VARCHAR)) THEN 1 ELSE 0 END) AS whitespaces_review_creation_date,

SUM(CASE WHEN review_answer_timestamp IS NULL OR TRIM(CAST(review_answer_timestamp AS VARCHAR)) = '' THEN 1 ELSE 0 END) AS missing_review_answer_timestamp,
SUM(CASE WHEN review_answer_timestamp != TRIM(CAST(review_answer_timestamp AS VARCHAR)) THEN 1 ELSE 0 END) AS whitespaces_review_answer_timestamp



FROM bronze.order_review_ratings




