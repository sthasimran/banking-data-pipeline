TRUNCATE TABLE staging.cards;

INSERT INTO staging.cards
SELECT * FROM raw.cards;
