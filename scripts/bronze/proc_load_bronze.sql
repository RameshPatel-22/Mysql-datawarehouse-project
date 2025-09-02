/*
===============================================================================
Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `LOAD DATA INFILE` command to load data from csv Files to bronze tables.
===============================================================================
*/
TRUNCATE TABLE bronze.crm_cust_info;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cust_info.csv'
INTO TABLE bronze.crm_cust_info
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
IGNORE 1 ROWS;

TRUNCATE TABLE bronze.crm_prd_info;   
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/prd_info.csv'
INTO TABLE bronze.crm_prd_info
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
IGNORE 1 ROWS;

TRUNCATE TABLE bronze.crm_sales_details;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sales_details.csv'
INTO TABLE bronze.crm_sales_details
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

TRUNCATE TABLE bronze.erp_cust_az12;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/loc_a101.csv'
INTO TABLE bronze.erp_loc_a101
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

TRUNCATE TABLE bronze.erp_loc_a101;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/px_cat_g1v2.csv'
INTO TABLE bronze.erp_px_cat_g1v2
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

TRUNCATE TABLE bronze.erp_px_cat_g1v2;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cust_az12.csv'
INTO TABLE bronze.erp_cust_az12
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;
