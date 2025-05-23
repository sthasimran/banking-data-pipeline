from airflow import DAG
from airflow.providers.postgres.operators.postgres import PostgresOperator
from datetime import datetime

default_args = {
    'owner': 'simran',
    'start_date': datetime(2025, 5, 1),
    'retries': 1,
}

with DAG(
    dag_id='init_raw_schema_dag',
    default_args=default_args,
    description="Create schemas, tables and load raw data",
    schedule_interval=None,
    catchup=False,
) as dag:

    create_schemas = PostgresOperator(
        task_id='create_schemas',
        postgres_conn_id='airflow_db',
        sql='sql/create_schemas.sql',
    )

    create_raw_tables = PostgresOperator(
        task_id='create_raw_tables',
        postgres_conn_id='airflow_db',
        sql='sql/create_raw_tables.sql',
    )

    load_raw_data = PostgresOperator(
        task_id="load_raw_data",
        postgres_conn_id="airflow_db",
        sql="sql/load_raw_data.sql"

    )

    create_schemas >> create_raw_tables >> load_raw_data
