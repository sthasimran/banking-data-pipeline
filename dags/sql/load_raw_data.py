#  COPY raw.transactions FROM '/opt/airflow/data/raw/transaction.csv' DELIMITER ',' CSV HEADER;
# COPY raw.product FROM '/opt/airflow/data/raw/products.csv' DELIMITER ',' CSV HEADER;
#  COPY raw.account FROM '/opt/airflow/data/raw/account.csv' DELIMITER ',' CSV HEADER;
# COPY raw.cards FROM '/opt/airflow/data/raw/cards.csv' DELIMITER ',' CSV HEADER;
#  COPY raw.customers FROM '/opt/airflow/data/raw/customer.csv' DELIMITER ',' CSV HEADER;



import os
from airflow.providers.postgres.hooks.postgres import PostgresHook

def load_csv_to_postgres():
    hook = PostgresHook(postgres_conn_id='airflow_db')
    conn = hook.get_conn()
    cursor = conn.cursor()

    file_table_map = {
        "/opt/airflow/data/raw/transaction.csv": "raw.transactions",
        "/opt/airflow/data/raw/products.csv": "raw.product",
        "/opt/airflow/data/raw/account.csv": "raw.account",
        "/opt/airflow/data/raw/cards.csv": "raw.cards",
        "/opt/airflow/data/raw/customer.csv": "raw.customers"
    }

    for file_path, table_name in file_table_map.items():
        if not os.path.exists(file_path):
            raise FileNotFoundError(f"File not found: {file_path}")

        with open(file_path, 'r') as f:
            cursor.copy_expert(f"COPY {table_name} FROM STDIN WITH CSV HEADER DELIMITER ','", f)

    conn.commit()
    cursor.close()
    conn.close()

