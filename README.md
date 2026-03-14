# End-to-End E-Commerce Data Warehouse & Analytics Architecture

> Engineered a 3-tier Data Warehouse (Bronze/Silver/Gold) using T-SQL for an e-commerce marketplace. Transformed raw data into highly optimized models to analyze Customers, Products, and Sellers, culminating in Market Basket Analysis.

https://github.com/zulfqara/End-to-End-E-Commerce-Data-Warehouse-Analytics-Architecture/blob/main/Report.png.png

## Tech Stack & Methodologies
* **Database & Language:** SQL Server (T-SQL)
* **Data Engineering:** BULK INSERT, Medallion Architecture, Data Quality Assurance (DQA)
* **Data Modeling:** Dimensional Modeling (Star Schema), Fact/Dimension Views
* **Advanced SQL:** CTEs, Window Functions (DENSE_RANK(), LAG()), Complex Self-Joins
* **Visualization:** Power BI (Custom DAX, Card UI Design)

---

## Pipeline Architecture (Medallion Approach)

* **Bronze Layer (Raw):** Ingested millions of rows via BULK INSERT and conducted rigorous Data Quality Assurance (DQA) to flag nulls, duplicates, and chronological date impossibilities.
* **Silver Layer (Cleansed):** Transformed data by enforcing business logic, resolving datatype collisions, and cleansing financial anomalies.
* **Gold Layer (Analytics-Ready):** Built an optimized presentation layer using SQL VIEWs (dim_customers, dim_products, dim_sellers, fact_sales) to enable live BI reporting without duplicating storage.

---

## Core Data Marts & Analytics

* **The Customer Report:** Analyzed Lifetime Spend (LTV) and Average Order Value (AOV), segmenting users into tiers and tracking churn risk via dynamic recency logic.
* **The Product Report:** Evaluated Gross Merchandise Value (GMV) and item velocity, classifying inventory into High/Mid/Low ticket tiers and performance stages.
* **The Seller Report:** Audited vendor reliability by aggregating GMV, catalog size, and creating a Reputation Tier based on average review scores.
* **Market Basket Analysis:** Executed advanced SQL Self-Joins (< operator logic) to discover frequently co-purchased items, providing Marketing with targets for bundle discounts.

---

## Key Business Discoveries
* **Customer Churn:** Identified a critical 52% churn rate, driven heavily by an influx of 91K one-time buyers.
* **Seller Retention:** Revealed that 17.25% of sellers are currently 'Slipping' (1-2 months of inactivity), providing a targeted list for account recovery.
* **Product Bottleneck:** Discovered that despite high Health & Beauty GMV, the vast majority of catalog inventory sits stagnant in the 'One-Timer' lifecycle stage.
