

WITH 
-- 1. LOGIC CHECK (Date Errors)
Date_Logic_Errors AS (
    SELECT COUNT(*) AS logic_error_count
    FROM bronze.orders
    WHERE order_purchase_timestamp > order_approved_at
       OR order_delivered_carrier_date > order_delivered_customer_date
),


Date_Outliers AS(

SELECT 

	SUM(purchase_dt_outliers) as purchase_dt_outliers,
	SUM(approved_dt_outliers) as approved_dt_outliers,
	SUM(carrier_delivered_dt_outliers) as carrier_delivered_dt_outliers,
	SUM(customer_delivered_dt_outliers) as customer_delivered_dt_outliers,
	SUM(estimated_dt_outliers) as estimated_delivery_dt_outliers


FROM (
  SELECT
    CASE
      WHEN order_purchase_timestamp NOT BETWEEN CAST( '2016-09-01' AS DATE) AND CAST( '2018-10-01' AS DATE) 
      THEN 1 ELSE 0
    END AS purchase_dt_outliers,
	 CASE
      WHEN order_approved_at NOT BETWEEN CAST( '2016-09-01' AS DATE) AND CAST( '2018-10-01' AS DATE) 
      THEN 1 ELSE 0
    END AS approved_dt_outliers,
	 CASE
      WHEN order_delivered_carrier_date NOT BETWEEN CAST( '2016-09-01' AS DATE) AND CAST( '2018-10-01' AS DATE) 
      THEN 1 ELSE 0
    END AS carrier_delivered_dt_outliers,
	 CASE
      WHEN order_delivered_customer_date NOT BETWEEN CAST( '2016-09-01' AS DATE) AND CAST( '2018-10-01' AS DATE) 
      THEN 1 ELSE 0
    END AS customer_delivered_dt_outliers,
	CASE
      WHEN order_estimated_delivery_date NOT BETWEEN CAST( '2016-09-01' AS DATE) AND CAST( '2018-10-01' AS DATE) 
      THEN 1 ELSE 0
    END AS estimated_dt_outliers
  FROM bronze.orders
)t

)


,
-- 2. MAIN SUMMARY (Nulls & Whitespaces)
Quality_Check_Summary AS (
    SELECT 
        'bronze.orders' AS table_name,
        COUNT(*) AS total_rows,

        -- Order IDs
        COUNT(order_id) - COUNT(DISTINCT order_id) AS duplicate_ord_ids,
        SUM(CASE WHEN order_id IS NULL OR TRIM(order_id) = '' THEN 1 ELSE 0 END) AS missing_ord_ids,
        SUM(CASE WHEN order_id != TRIM(order_id) THEN 1 ELSE 0 END) AS whitespaces_ord_ids,

        -- Customer IDs
        COUNT(customer_id) - COUNT(DISTINCT customer_id) AS duplicate_cust_ids,
        SUM(CASE WHEN customer_id IS NULL OR TRIM(customer_id) = '' THEN 1 ELSE 0 END) AS missing_cust_ids,
        SUM(CASE WHEN customer_id != TRIM(customer_id) THEN 1 ELSE 0 END) AS whitespaces_cust_ids,

        -- Order Status
        SUM(CASE WHEN order_status IS NULL OR TRIM(order_status) = '' THEN 1 ELSE 0 END) AS missing_ord_sts,
        SUM(CASE WHEN order_status != TRIM(order_status) THEN 1 ELSE 0 END) AS whitespaces_ord_sts,

        -- Date Columns (Missing & Whitespace)
        SUM(CASE WHEN order_purchase_timestamp IS NULL OR TRIM(CAST(order_purchase_timestamp AS VARCHAR)) = '' THEN 1 ELSE 0 END) AS missing_purchase_date,
        SUM(CASE WHEN order_purchase_timestamp != TRIM(CAST(order_purchase_timestamp AS VARCHAR)) THEN 1 ELSE 0 END) AS whitespaces_purchase_date,

        
        SUM(CASE WHEN order_delivered_carrier_date IS NULL OR TRIM(CAST(order_delivered_carrier_date AS VARCHAR)) = '' THEN 1 ELSE 0 END) AS missing_carrier_date,
        SUM(CASE WHEN order_delivered_carrier_date != TRIM(CAST(order_delivered_carrier_date AS VARCHAR)) THEN 1 ELSE 0 END) AS whitespaces_carrier_date,

        SUM(CASE WHEN order_delivered_customer_date IS NULL OR TRIM(CAST(order_delivered_customer_date AS VARCHAR)) = '' THEN 1 ELSE 0 END) AS missing_cust_del_date,
        SUM(CASE WHEN order_delivered_customer_date != TRIM(CAST(order_delivered_customer_date AS VARCHAR)) THEN 1 ELSE 0 END) AS whitespaces_cust_del_date

    FROM bronze.orders
),

-- 3. RANKING CHECK (Double-checking duplicates for order_id using row_number() )
Duplicate_Rank_Check AS (
    SELECT COUNT(*) AS rank_duplicate_count
    FROM (
        SELECT 
            order_id,
            ROW_NUMBER() OVER(PARTITION BY order_id ORDER BY order_purchase_timestamp) as row_num
        FROM bronze.orders
    ) t
    WHERE row_num > 1
) 

-- 4. FINAL OUTPUT (Combine all 3 CTEs)
SELECT 
    q.*, 
    d.logic_error_count,
    r.rank_duplicate_count,
	do.*

FROM Quality_Check_Summary q
CROSS JOIN Date_Logic_Errors d
CROSS JOIN Duplicate_Rank_Check r
CROSS JOIN Date_Outliers do



