CREATE TABLE IF NOT EXISTS staging.products AS
SELECT * FROM raw.product WHERE 1=0;
