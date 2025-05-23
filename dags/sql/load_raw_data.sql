COPY raw.transactions FROM '/opt/airflow/data/raw/transaction.csv' DELIMITER ',' CSV HEADER;
COPY raw.product FROM '/opt/airflow/data/raw/products.csv' DELIMITER ',' CSV HEADER;
COPY raw.account FROM '/opt/airflow/data/raw/account.csv' DELIMITER ',' CSV HEADER;
COPY raw.cards FROM '/opt/airflow/data/raw/cards.csv' DELIMITER ',' CSV HEADER;
COPY raw.customers FROM '/opt/airflow/data/raw/customer.csv' DELIMITER ',' CSV HEADER;
