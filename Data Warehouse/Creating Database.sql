--To create a new database, master database is the primary source to be used

USE master;
GO

CREATE DATABASE EcommmerceDataset;
GO

USE EcommmerceDataset;
GO

-- Creating Schemas

-- Bronze schema: raw/extracted data
CREATE SCHEMA bronze;
GO

-- Silver schema: cleaned/transformed data
CREATE SCHEMA silver;
GO

-- Gold schema: analytics-ready (facts & dimensions)
CREATE SCHEMA gold;
GO
