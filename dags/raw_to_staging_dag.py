
from airflow import DAG
from airflow.providers.postgres.operators.postgres import PostgresOperator
from datetime import datetime, timedelta


default_args = {
    'owner': 'simran',
    'start_date': datetime(2025, 1, 1),
    'retries': 3,  
    'retry_delay': timedelta(minutes=5), 
    'log_level': 'INFO',  
    'catchup': False,
    'on_failure_callback': None,  
    'on_retry_callback': None,  
}

with DAG(
    dag_id='raw_to_staging_dag',
    default_args=default_args,
    schedule_interval='0 0 * * *',  
    description='Load raw data into staging tables',
    tags=['data-pipeline'],
) as dag:

    # -- Customers --
    create_staging_customers = PostgresOperator(
        task_id='create_staging_customers',
        postgres_conn_id='airflow_db',
        sql='sql/create_staging_customers.sql',
        retries=3, 
        retry_delay=timedelta(minutes=5),
        task_concurrency=1,
        on_failure_callback=None,
    )

    load_staging_customers = PostgresOperator(
        task_id='load_staging_customers',
        postgres_conn_id='airflow_db',
        sql='sql/load_staging_customers.sql',
        retries=3,
        retry_delay=timedelta(minutes=5),
        task_concurrency=1,
        on_failure_callback=None,
    )

    # -- Accounts --
    create_staging_accounts = PostgresOperator(
        task_id='create_staging_accounts',
        postgres_conn_id='airflow_db',
        sql='sql/create_staging_accounts.sql',
        retries=3,
        retry_delay=timedelta(minutes=5),
    )

    load_staging_accounts = PostgresOperator(
        task_id='load_staging_accounts',
        postgres_conn_id='airflow_db',
        sql='sql/load_staging_accounts.sql',
        retries=3,
        retry_delay=timedelta(minutes=5),
    )

    # -- Cards --
    create_staging_cards = PostgresOperator(
        task_id='create_staging_cards',
        postgres_conn_id='airflow_db',
        sql='sql/create_staging_cards.sql',
        retries=3,
        retry_delay=timedelta(minutes=5),
    )

    load_staging_cards = PostgresOperator(
        task_id='load_staging_cards',
        postgres_conn_id='airflow_db',
        sql='sql/load_staging_cards.sql',
        retries=3,
        retry_delay=timedelta(minutes=5),
    )

    # -- Transactions --
    create_staging_transactions = PostgresOperator(
        task_id='create_staging_transactions',
        postgres_conn_id='airflow_db',
        sql='sql/create_staging_transactions.sql',
        retries=3,
        retry_delay=timedelta(minutes=5),
    )

    load_staging_transactions = PostgresOperator(
        task_id='load_staging_transactions',
        postgres_conn_id='airflow_db',
        sql='sql/load_staging_transactions.sql',
        retries=3,
        retry_delay=timedelta(minutes=5),
    )

    # -- Products --
    create_staging_products = PostgresOperator(
        task_id='create_staging_products',
        postgres_conn_id='airflow_db',
        sql='sql/create_staging_products.sql',
        retries=3,
        retry_delay=timedelta(minutes=5),
    )

    load_staging_products = PostgresOperator(
        task_id='load_staging_products',
        postgres_conn_id='airflow_db',
        sql='sql/load_staging_products.sql',
        retries=3,
        retry_delay=timedelta(minutes=5),
    )

    # Define task dependencies
    create_staging_customers >> load_staging_customers
    create_staging_accounts >> load_staging_accounts
    create_staging_cards >> load_staging_cards
    create_staging_transactions >> load_staging_transactions
    create_staging_products >> load_staging_products
