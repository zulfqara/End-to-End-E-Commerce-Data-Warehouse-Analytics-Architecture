/* ===============================================================================
FINAL DQA REPORT: CUSTOMERS TABLE (COMPREHENSIVE)
===============================================================================
Checklist:
1. Missing Values (Nulls OR Empty Strings) -> All Columns
2. Whitespace Issues (Leading/Trailing spaces) -> All String Columns
3. Data Validity (Zip Codes, State Codes)
*/

SELECT 
    'bronze.customers' AS table_name,
    COUNT(*) AS total_rows,

    -- 1. PRIMARY KEYS (ID)

	--Duplicate Check:
	COUNT(customer_id) - COUNT(DISTINCT customer_id) AS duplicate_ids,
    -- -- Check for Null and Missing
    SUM(CASE WHEN customer_id IS NULL OR customer_id = '' THEN 1 ELSE 0 END) AS missing_ids,
	--Check for Extra Spaces
    SUM(CASE WHEN customer_id != TRIM(customer_id) THEN 1 ELSE 0 END) AS whitespace_ids,
    

    -- 2. USER KEYS (Unique ID)
    -- Check for Null and Missing
    SUM(CASE WHEN customer_unique_id IS NULL OR customer_unique_id = '' THEN 1 ELSE 0 END) AS missing_unique_ids,
	--Check for Extra Spaces
    SUM(CASE WHEN customer_unique_id != TRIM(customer_unique_id) THEN 1 ELSE 0 END) AS whitespace_unique_ids,

    -- 3. ZIP CODE
    -- Check for Null and Missing
    SUM(CASE WHEN customer_zip_code_prefix IS NULL OR TRIM(CAST(customer_zip_code_prefix AS  VARCHAR)) = '' THEN 1 ELSE 0 END) AS missing_zip_codes,
    -- Negative and Invalid Zip Code Check
    SUM(CASE WHEN customer_zip_code_prefix <= 0 OR  LEN(customer_zip_code_prefix) >5 THEN 1 ELSE 0 END) AS invalid_zip_codes,

    -- 4. CITY
   
    SUM(CASE WHEN customer_city IS NULL OR customer_city = '' THEN 1 ELSE 0 END) AS missing_cities,
    SUM(CASE WHEN customer_city != TRIM(customer_city) THEN 1 ELSE 0 END) AS whitespace_cities,

    -- 5. STATE
    
    SUM(CASE WHEN customer_state IS NULL OR customer_state = '' THEN 1 ELSE 0 END) AS missing_states,
    SUM(CASE WHEN customer_state != TRIM(customer_state) THEN 1 ELSE 0 END) AS whitespace_states
   

FROM bronze.customers;

