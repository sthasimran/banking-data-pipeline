TRUNCATE TABLE staging.products;I

NSERT INTO staging.products
SELECT * FROM raw.product;
