WITH name_and_rows as (
SELECT 
'bronze.order_payments' as table_name,
count(*) as total_rows
FROM bronze.order_payments
)

,
quality_summary_check as
(
SELECT 
	
--1. ORDER_ID:

--Duplicate Check:
	COUNT(order_id) - COUNT(DISTINCT order_id) AS duplicate_ord_ids,

	SUM(case WHEN order_id is null or trim(order_id) = '' then 1 else 0 END) as missing_ord_ids,
	SUM(case when order_id!= trim(order_id) then 1 else 0 END) as whitespaces_ord_ids,

--2. 
SUM( CASE WHEN payment_sequential is null OR TRIM(CAST(payment_sequential as VARCHAR)) = '' THEN 1 ELSE 0 END) AS missing_payment_sequential,
SUM( CASE WHEN payment_sequential <= 0 THEN 1 ELSE 0 END) AS neg_payment_seq,

--3.
SUM(case WHEN payment_type is null or trim(payment_type) = '' then 1 else 0 END) as missing_payment_type,
SUM(case when payment_type!= trim(payment_type) then 1 else 0 END) as whitespaces_payment_type,
 
--4. PAYMENT_INSTALLMENTS
SUM( CASE WHEN payment_installments is NULL OR TRIM(CAST(payment_installments AS VARCHAR)) = '' THEN 1 ELSE 0 END) AS missing_payment_instal,
SUM( CASE WHEN payment_installments <= 0 THEN 1 ELSE 0 END) AS neg_payment_instal,
--5. PAYMENT_VALUE
SUM( CASE WHEN payment_value is NULL OR TRIM(CAST(payment_value AS VARCHAR)) = '' THEN 1 ELSE 0 END) AS missing_payment_value,
SUM( CASE WHEN payment_value <= 0 THEN 1 ELSE 0 END) AS neg_payment_value

 
FROM bronze.order_payments
)
,

Duplicate_Rank_Check AS (
    SELECT COUNT(*) AS rank_duplicate_order_id
    FROM (
        SELECT 
            order_id,
            ROW_NUMBER() OVER(PARTITION BY order_id ORDER BY order_purchase_timestamp) as row_num
        FROM bronze.orders
    ) t
    WHERE row_num > 1
)


SELECT 
n.*,
r.*,
q.*


FROM name_and_rows as n

CROSS JOIN quality_summary_check as q
CROSS JOIN Duplicate_Rank_Check as r


