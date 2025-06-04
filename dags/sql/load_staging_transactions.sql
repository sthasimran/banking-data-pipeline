TRUNCATE TABLE staging.transactions;

INSERT INTO staging.transactions
SELECT * FROM raw.transactions;
