TRUNCATE TABLE staging.accounts;

INSERT INTO staging.accounts
SELECT * FROM raw.account;
