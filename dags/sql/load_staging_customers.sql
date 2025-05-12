TRUNCATE TABLE staging.customers;I

NSERT INTO staging.customers
SELECT * FROM raw.customers;
