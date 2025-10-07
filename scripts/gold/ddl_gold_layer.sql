/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/

-- =============================================================================
-- Create Dimension: gold.dim_customers
-- =============================================================================


create view gold.dim_cst_info as
Select 
	row_number() over(order by cst_id) as customer_key,
	cst_id as customer_id,
    cst_key as customer_number,
    cst_firstname as first_name,
    cst_lastname as last_name,
    cst_gndr as gender,
    cst_marital_status as marital_status ,
    cst_create_date as create_date,
    bdate as DOB,
    cntry as country
from silver.crm_cust_info ci
left join silver.erp_cust_az12  ca
on ci.cst_key=ca.cid
left join silver.erp_loc_a101 la
on ci.cst_key=la.cid;


-- =============================================================================
-- Create Dimension: gold.dim_products
-- =============================================================================

create view gold.dim_prd_info as
SELECT 
row_number()over(order by prd_start_dt,prd_key) as product_key,
 prd_id as product_id,
 prd_key as product_number,
 cat_id as category_id,
 prd_line as product_line,
 cat as category,
 subcat as sub_category,
 prd_nm as product_name,
 prd_cost as product_cost,
 prd_start_dt as product_start_date,
 maintenance
FROM silver.crm_prd_info cp
LEFT JOIN silver.erp_px_cat_g1v2 epc
    ON cp.cat_id = epc.id
     where prd_end_dt is null;

-- =============================================================================
-- Create Fact Table: gold.fact_sales
-- =============================================================================


create view gold.fact_sales_info as
SELECT
    sd.sls_ord_num  AS order_number,
    pi.product_key  AS product_key,
    ci.customer_key AS customer_key,
    sd.sls_order_dt AS order_date,
    sd.sls_ship_dt  AS shipping_date,
    sd.sls_due_dt   AS due_date,
    sd.sls_sales    AS sales_amount,
    sd.sls_quantity AS quantity,
    sd.sls_price    AS price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_prd_info pi
    ON sd.sls_prd_key = pi.product_number
LEFT JOIN gold.dim_cst_info ci
    ON sd.sls_cust_id = ci.customer_id
    
