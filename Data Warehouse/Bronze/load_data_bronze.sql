BULK INSERT bronze.customers
FROM'C:\Users\zulfy\Downloads\Marketing Data\CUSTOMERS.csv'
WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ','
		ROWTERMINATOR = '\n'
		);

GO

BULK INSERT bronze.geo_location
FROM'C:\Users\zulfy\Downloads\Marketing Data\GEO_LOCATION.csv'
WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ','
		ROWTERMINATOR = '\n'
		);
		
GO

BULK INSERT bronze.order_items
FROM'C:\Users\zulfy\Downloads\Marketing Data\ORDER_ITEMS.csv'
WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ','
		ROWTERMINATOR = '\n'
		);

GO

BULK INSERT bronze.order_payments
FROM'C:\Users\zulfy\Downloads\Marketing Data\ORDER_PAYMENTS.csv'
WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ','
		ROWTERMINATOR = '\n'
		);
		
GO

BULK INSERT bronze.order_review_ratings
FROM'C:\Users\zulfy\Downloads\Marketing Data\ORDER_REVIEW_RATINGS.csv'
WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ','
		ROWTERMINATOR = '\n'
		);

GO

BULK INSERT bronze.orders
FROM'C:\Users\zulfy\Downloads\Marketing Data\ORDERS.csv'
WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ','
		ROWTERMINATOR = '\n'
		);

BULK INSERT bronze.products
FROM'C:\Users\zulfy\Downloads\Marketing Data\PRODUCTS.csv'
WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ','
		ROWTERMINATOR = '\n'
		);

GO

BULK INSERT bronze.sellers
FROM'C:\Users\zulfy\Downloads\Marketing Data\SELLERS.csv'
WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ','
		ROWTERMINATOR = '\n'
		);
