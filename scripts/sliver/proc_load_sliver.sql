/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to 
    populate the 'silver' schema tables from the 'bronze' schema.
	Actions Performed:
		- Truncates Silver tables.
		- Inserts transformed and cleansed data from Bronze into Silver tables.
		
Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC Silver.load_silver;
===============================================================================
*/
DELIMITER $$

CREATE PROCEDURE silver.load_silver()
BEGIN

TRUNCATE TABLE silver.crm_cust_info;
INSERT INTO silver.crm_cust_info 
(cst_id, cst_key, cst_firstname, cst_lastname, cst_marital_status, cst_gndr, cst_create_date)
SELECT 
    CAST(NULLIF(cst_id, '') AS UNSIGNED) AS cst_id,
    TRIM(cst_key) AS cst_key,
    TRIM(cst_firstname) AS cst_firstname,
    TRIM(cst_lastname) AS cst_lastname,
    
    CASE 
        WHEN LOWER(TRIM(cst_marital_status)) = 's' THEN 'Single'
        WHEN LOWER(TRIM(cst_marital_status)) = 'm' THEN 'Married'
        ELSE 'Unknown'
    END AS cst_marital_status,
    
    CASE 
        WHEN LOWER(TRIM(cst_gndr)) = 'm' THEN 'Male'
        WHEN LOWER(TRIM(cst_gndr)) = 'f' THEN 'Female'
        ELSE 'Other'
    END AS cst_gndr,
    
    STR_TO_DATE(NULLIF(cst_create_date, ''), '%Y-%m-%d') AS cst_create_date
FROM bronze.crm_cust_info;

TRUNCATE TABLE silver.crm_prd_info;
insert into silver.crm_prd_info
(prd_id	,Cat_id,prd_key,	prd_nm	,prd_cost	,prd_line	,prd_start_dt	,prd_end_dt)
Select 
    CAST(NULLIF(prd_id, '') AS UNSIGNED) AS prd_id,
    replace(substring(prd_key,1,5),'-','_') as cat_id,
    substring(prd_key,7,length(prd_key)) as prd_key,
    TRIM(prd_nm) as prd_nm,
    CAST(IFNULL(NULLIF(prd_cost, ''), 0) AS UNSIGNED) AS prd_cost,
    case
				WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
				WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
				WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
				WHEN UPPER(TRIM(prd_line))='M' THEN 'Mountain'
                ELSE 'N\A'
    END AS prd_line,
    STR_TO_DATE(NULLIF(prd_start_dt, ''), '%Y-%m-%d') AS prd_start_dt,
    subdate(lead(prd_start_dt)over(partition by prd_key order by prd_start_dt), interval 1 day) as prd_end_dt
FROM bronze.crm_prd_info;

Truncate table silver.crm_sales_details;
insert into silver.crm_sales_details
(sls_ord_num,	sls_prd_key,	sls_cust_id,	sls_order_dt,	sls_ship_dt,	sls_due_dt,	sls_sales,	sls_quantity,	sls_price)
select
trim(sls_ord_num) as sls_ord_num,
trim(sls_prd_key) as sls_prd_key,
sls_cust_id,
case
when sls_order_dt =0 or length(sls_order_dt) !=8 then null 
 else cast(cast(sls_order_dt as char) as date)
end as sls_order_dt,
case
when sls_ship_dt =0 or length(sls_ship_dt) !=8 then null 
 else cast(cast(sls_ship_dt as char) as date)
end as sls_ship_dt,
case
when sls_due_dt =0 or length(sls_due_dt) !=8 then null 
 else cast(cast(sls_due_dt as char) as date)
end as sls_due_dt,
case when sls_sales is NULL or sls_sales <=0 or sls_sales!= sls_quantity *abs(sls_price)
	 then sls_quantity *abs(sls_price)
     else sls_sales
end as sls_sales,
sls_quantity,
case when sls_price is NULl or sls_price<=0
	 then sls_sales / NULLIF(sls_quantity, 0)
	else sls_price
end as sls_price
from bronze.crm_sales_details;


Truncate table silver.erp_loc_a101;
insert into silver.erp_loc_a101
(cid,cntry)
SELECT 
replace(cid,'-','') as cid,
    cntry,
    CASE
        WHEN TRIM(cntry) = 'DE' THEN 'Germany'
        WHEN TRIM(cntry) IN ('US','USA') THEN 'United States'
        WHEN TRIM(cntry) = 'UK' THEN 'United Kingdom'
        ELSE TRIM(cntry)
    END AS cntry
FROM bronze.erp_loc_a101;

Truncate table ilver.erp_cust_az12;
insert into silver.erp_cust_az12
(cid,bdate,gen)
Select
substring(cid,4,length(cid)) as cid, 
    CASE 
        WHEN bdate IS NULL OR bdate = '' THEN NULL
        WHEN STR_TO_DATE(bdate, '%d-%m-%Y') > CURDATE() THEN NULL
        ELSE STR_TO_DATE(bdate, '%d-%m-%Y')
        END AS bdate,
        CASE 
        WHEN gen = 'M' THEN 'Male'
        WHEN gen = 'F' THEN 'Female'
        WHEN gen IS NULL OR TRIM(gen) = '' THEN 'N/A'
        ELSE gen
    END AS gen
FROM bronze.erp_cust_az12;

Truncate table silver.erp_px_cat_g1v2;
Insert into silver.erp_px_cat_g1v2
(id,cat,subcat,maintenance)
select id,
		cat,
        subcat,
        maintenance
from bronze.erp_px_cat_g1v2;

END$$
DELIMITER ;






