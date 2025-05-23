TRUNCATE TABLE staging.products;

INSERT INTO staging.products
SELECT * FROM raw.product;
