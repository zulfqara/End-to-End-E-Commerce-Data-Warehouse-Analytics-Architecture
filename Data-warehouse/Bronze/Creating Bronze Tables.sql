Create table bronze.customers(
customer_id NVARCHAR(50),
customer_unique_id NVARCHAR(50),
customer_zip_code_prefix INT,
customer_city NVARCHAR(50),
customer_state NVARCHAR(50)
)

GO


CREATE TABLE bronze.geo_location(
geolocation_zip_code_prefix INT,
geolocation_lat DECIMAL(10,2),
geolocation_lng DECIMAL(10,2),
geolocation_city NVARCHAR(50),
geolocation_state NVARCHAR(50)
)

GO

CREATE TABLE bronze.order_items(
order_id NVARCHAR(50),
order_item_id NVARCHAR(50),
product_id NVARCHAR(50),
seller_id NVARCHAR(50),
shipping_limit_date DATE,
price DECIMAL(10, 2),
freight_value DECIMAL(10,2)
)

GO

CREATE TABLE bronze.order_payments(
order_id NVARCHAR(50),
payment_sequential INT,
payment_type NVARCHAR(50),
payment_installments INT,
payment_value DECIMAL(10,2)
)

GO

CREATE TABLE bronze.order_review_ratings(
review_id NVARCHAR(50),
order_id NVARCHAR(50),
review_score INT,
review_creation_date DATE,
review_answer_timestamp DATE
)

GO

CREATE TABLE bronze.orders(
order_id NVARCHAR(50),
customer_id NVARCHAR(50),
order_status NVARCHAR(50),
order_purchase_timestamp DATE,
order_approved_at DATE,
order_delivered_carrier_date DATE,
order_delivered_customer_date DATE,
order_estimated_delivery_date DATE
)

GO

CREATE TABLE bronze.products (
product_id NVARCHAR(50),
product_category NVARCHAR(50),
product_name_lenght INT,
product_description_lenght INT,
product_photos_qty INT,
product_weight_g INT,
product_length_cm INT,
product_height_cm INT, 
product_width_cm INT
)

GO

CREATE TABLE bronze.sellers(
seller_id NVARCHAR(50),
seller_zip_code_prefix INT,
seller_city NVARCHAR(50),
seller_state NVARCHAR(50)
)





