-- Check for Nulls or Duplicates in Primary Key
-- Expectation: No Result
SELECT 
	cst_id,
	count(*)
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Actual Result : cst_id (29449, 29473, 29433, Null, 29483, 29466) are repeated
-- Investigating for the reson
SELECT *
FROM bronze.crm_cust_info
WHERE cst_id = 29466;

/*
Observation: The customer made three trials to update their info, and if we check for the rest of the repeated
IDs, We gonna find the same reason
*/

-- Check for unwanted spaces for the 'cst_firstname'
-- Expectation: No Results 
SELECT cst_firstname
From bronze.crm_cust_info
WHERE  cst_firstname != TRIM(cst_firstname);
-- Actual Result: unwanted spaces is detected

-- Check for unwanted spaces for the 'cst_lastname'
-- Expectation: No Results 
SELECT cst_lastname
From bronze.crm_cust_info
WHERE  cst_lastname != TRIM(cst_lastname);
-- Actual Result: unwanted spaces is detected

-- Check for data standardization & consistency
-- Expectation: Only two distict values for the gender (M, F)
SELECT DISTINCT cst_gender
FROM bronze.crm_cust_info;
-- Acutal result: as expected with addition to 'NULL' value

-- Expectation: Only two distict values for the gender (M, F)
SELECT DISTINCT cst_material_status
FROM bronze.crm_cust_info;
-- Acutal result: as expected with addition to 'NULL' value
