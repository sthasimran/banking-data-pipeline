CREATE TABLE IF NOT EXISTS staging.transactions AS
SELECT * FROM raw.transactions WHERE 1=0;
