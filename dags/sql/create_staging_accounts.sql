CREATE TABLE IF NOT EXISTS staging.accounts AS
SELECT * FROM raw.account WHERE 1=0;
