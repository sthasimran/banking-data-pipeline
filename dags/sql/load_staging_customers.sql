TRUNCATE TABLE staging.customers;

INSERT INTO staging.customers
SELECT * FROM raw.customers;
