/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/
DROP TABLE IF EXISTS bronze.crm_cust_info;
CREATE TABLE `bronze.crm_cust_info` (
  `cst_id` text,
  `cst_key` text,
  `cst_firstname` text,
  `cst_lastname` text,
  `cst_marital_status` text,
  `cst_gndr` text,
  `cst_create_date` text
);

DROP TABLE IF EXISTS bronze.crm_prd_info;

CREATE TABLE `bronze.crm_prd_info` (
  `prd_id` int DEFAULT NULL,
  `prd_key` text,
  `prd_nm` text,
  `prd_cost` text,
  `prd_line` text,
  `prd_start_dt` text,
  `prd_end_dt` text
);

DROP TABLE IF EXISTS bronze.crm_sales_details;

CREATE TABLE `bronze.crm_sales_details` (
  `sls_ord_num` text,
  `sls_prd_key` text,
  `sls_cust_id` text,
  `sls_order_dt` text,
  `sls_ship_dt` text,
  `sls_due_dt` text,
  `sls_sales` text,
  `sls_quantity` text,
  `sls_price` text
) ;

DROP TABLE IF EXISTS bronze.erp_cust_az12;

CREATE TABLE `bronze.erp_cust_az12` (
  `cid` text,
  `bdate` text,
  `gen` text
) ;

DROP TABLE IF EXISTS bronze.erp_loc_a101;

CREATE TABLE `bronze.erp_loc_a101` (
  `cid` text,
  `cntry` text
) ;


DROP TABLE IF EXISTS bronze.erp_px_cat_g1v2;

CREATE TABLE `bronze.erp_px_cat_g1v2` (
  `id` text,
  `cat` text,
  `subcat` text,
  `maintenance` text
) ;


