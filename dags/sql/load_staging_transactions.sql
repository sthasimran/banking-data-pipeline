INSERT INTO staging.transactions
SELECT * FROM raw.transactions;
