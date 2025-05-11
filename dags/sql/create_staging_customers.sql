CREATE TABLE IF NOT EXISTS staging.customers AS
SELECT * FROM raw.customers WHERE 1=0;
