\COPY raw.transactions FROM 'data/raw/transaction.csv' DELIMITER ',' CSV HEADER;
\COPY raw.product FROM 'data/raw/products.csv' DELIMITER ',' CSV HEADER;
\COPY raw.account FROM 'data/raw/account.csv' DELIMITER ',' CSV HEADER;
\COPY raw.cards FROM 'data/raw/cards.csv' DELIMITER ',' CSV HEADER;
\COPY raw.customers FROM 'data/raw/customer.csv' DELIMITER ',' CSV HEADER;
