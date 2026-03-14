--Finding data range

SELECT
	'(' + CAST(MIN(purchased_date) AS VARCHAR(50)) +  ')' +  
	' - ' + 
	'(' + CAST(MAX(purchased_date) AS VARCHAR(50)) + ')'  AS Duration,

	DATEDIFF(MONTH, MIN(purchased_date), MAX(purchased_date))  AS total_months
	
	
FROM gold.fact_sales


/* EDA: Analyze Delivery Performance vs. Estimate */
SELECT 

	(SELECT COUNT(DISTINCT order_id) FROM gold.fact_sales) AS total_orders ,
    COUNT(delivery_flag)  AS late_deliveries

FROM (
    SELECT   
		order_id,
        CASE 
            WHEN DATEDIFF(day, estimated_delivery_date, customer_delivered_date) >=0 THEN 'Timely Delivered'
			ELSE 'Late'
        END AS delivery_flag
    FROM gold.fact_sales 
) AS subquery
WHERE delivery_flag != 'Late'


--Retreiving Top 10 Sellers with the most late_shippings
SELECT TOP 10
    seller_id,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(CASE 
            WHEN carrier_delivered_date > shipping_limit_date 
            THEN 1 
            ELSE 0 
        END) AS late_shippings
FROM gold.fact_sales
GROUP BY seller_id
ORDER BY late_shippings DESC;
