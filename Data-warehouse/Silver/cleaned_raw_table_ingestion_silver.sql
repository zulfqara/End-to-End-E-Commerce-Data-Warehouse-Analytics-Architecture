
INSERT INTO silver.customers (
customer_unique_id,
customer_id,
customer_zip_code_prefix ,
customer_city,
customer_state 

)


SELECT 
customer_unique_id,
customer_id,
customer_zip_code_prefix ,
customer_city,
customer_state 

FROM bronze.customers




INSERT INTO silver.orders(
	order_id,
	customer_id,
	order_status,
	order_purchase_timestamp,
	order_approved_at,
	order_delivered_carrier_date,
	order_delivered_customer_date,
	order_estimated_delivery_date
)
SELECT 
	order_id,
	customer_id,
	order_status,
	order_purchase_timestamp,
	order_approved_at,

	CASE
		WHEN order_delivered_carrier_date>order_delivered_customer_date THEN NULL ELSE order_delivered_carrier_date
	END order_delivered_carrier_date,

	order_delivered_customer_date,
	order_estimated_delivery_date

FROM bronze.orders



INSERT INTO silver.order_payments(
	order_id,
	payment_sequential,
	payment_type,
	payment_installments,
	payment_value
)

SELECT 
	order_id,
	payment_sequential,
	payment_type,

	CASE 
	 WHEN payment_installments <= 0 THEN 1 ELSE payment_installments
	END payment_installments,

	payment_value

from bronze.order_payments
WHERE payment_value > 0


INSERT INTO silver.products(
product_id,
product_category,
product_weight_g,
product_length_cm,
product_height_cm,
product_width_cm
)


SELECT 
product_id,
product_category,
product_weight_g,
product_length_cm,
product_height_cm,
product_width_cm
FROM bronze.products


INSERT INTO silver.order_items(
order_id,
order_item_id,
product_id ,
seller_id,
shipping_limit_date ,
price ,
freight_value
)

SELECT
order_id,
order_item_id,
product_id ,
seller_id,
shipping_limit_date ,
price ,
CASE 
WHEN freight_value = 0 or freight_value is NULL THEN 0 ELSE freight_value
END freight_value

FROM bronze.order_items

INSERT INTO silver.sellers(
seller_id,
seller_zip_code_prefix ,
seller_city,
seller_state 
)

SELECT 
seller_id,
seller_zip_code_prefix ,
seller_city,
seller_state 
FROM bronze.sellers

INSERT INTO silver.order_review_ratings(
review_id,
order_id ,
review_score,
review_creation_date,
review_answer_timestamp
)

SELECT 
review_id,
order_id ,
review_score,
review_creation_date,
review_answer_timestamp
FROM bronze.order_review_ratings



