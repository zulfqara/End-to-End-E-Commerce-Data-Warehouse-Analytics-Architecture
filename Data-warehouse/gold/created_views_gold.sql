CREATE VIEW gold.dim_customers AS 
SELECT 
	customer_unique_id as customer_id,
	customer_id as customer_session_id,
	customer_city as city,
	customer_zip_code_prefix as zipcode,
	customer_state as [state]

From silver.customers 

GO

CREATE VIEW gold.dim_products AS
SELECT

	p.product_id,
	p.product_category,
	p.product_weight_g,
	p.product_length_cm,
	p.product_height_cm,
	p.product_width_cm

FROM silver.products as p

GO


CREATE VIEW gold.dim_sellers AS
SELECT 
	seller_id,
	seller_zip_code_prefix as seller_zipcode,
	seller_city,
	seller_state
FROM silver.sellers


GO

CREATE gold.fact_sales AS 
SELECT
	o.order_id,
	o.customer_id as customer_session_id,
	oi.product_id,
	s.seller_id,
	o.order_purchase_timestamp as purchased_date,
	o.order_approved_at as approved_date,
	o.order_delivered_carrier_date as carrier_delivered_date,
	o.order_delivered_customer_date as customer_delivered_date,
	order_estimated_delivery_date as estimated_delivery_date,
	oi.order_item_id,
	oi.price,
	oi.freight_value as shipping_charges,
	oi.shipping_limit_date,
	op.payment_sequential,
	op.payment_type,
	op.payment_installments,
	op.payment_value,
	r.review_score

FROM silver.orders as o
LEFT JOIN silver.order_items as oi
	ON	o.order_id = oi.order_id  
LEFT JOIN silver.sellers as s
	ON	oi.seller_id = s.seller_id
LEFT JOIN silver.order_payments as op
	ON	o.order_id = op.order_id
LEFT JOIN silver.order_review_ratings as r
	ON o.order_id = r.order_id
WHERE o.order_purchase_timestamp  >= '2017-1-1'


