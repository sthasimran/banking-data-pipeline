from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.providers.postgres.operators.postgres import PostgresOperator
from airflow.operators.python import PythonOperator  
from sql.load_raw_data import load_csv_to_postgres       
from airflow.utils.task_group import TaskGroup
from datetime import datetime, timedelta
from airflow.operators.email import EmailOperator

default_args = {
    'owner': 'simran',
    'start_date': datetime(2025, 5, 1),
    'retries': 2,
    'retry_delay': timedelta(minutes=5),
    'email': ['sthasimran2000@gmail.com'], 
    'email_on_failure': True,
    'email_on_retry': False,
}

with DAG(
    dag_id='banking_data_pipeline',
    default_args=default_args,
    description='Unified DAG for raw load, staging, and dbt transformations',
    schedule_interval=None,
    catchup=False,
    tags=['data-pipeline'],
) as dag:


    with TaskGroup('init_raw_data', tooltip='Create schemas, tables and load raw data') as init_raw:
        create_schemas = PostgresOperator(
            task_id='create_schemas',
            postgres_conn_id='airflow_db',
            sql='sql/create_schemas.sql',
            execution_timeout=timedelta(minutes=3),
        )

        create_raw_tables = PostgresOperator(
            task_id='create_raw_tables',
            postgres_conn_id='airflow_db',
            sql='sql/create_raw_tables.sql',
            execution_timeout=timedelta(minutes=5),
        )

        load_raw_data = PythonOperator(
            task_id="load_raw_data",
            python_callable=load_csv_to_postgres,
            execution_timeout=timedelta(minutes=10),
        )


        create_schemas >> create_raw_tables >> load_raw_data

   
    with TaskGroup('load_staging_data', tooltip='Load raw data into staging tables') as staging_group:

        entities = ['customers', 'accounts', 'cards', 'transactions', 'products']
        for entity in entities:
            create = PostgresOperator(
                task_id=f'create_staging_{entity}',
                postgres_conn_id='airflow_db',
                sql=f'sql/create_staging_{entity}.sql',
                execution_timeout=timedelta(minutes=5),
            )
            load = PostgresOperator(
                task_id=f'load_staging_{entity}',
                postgres_conn_id='airflow_db',
                sql=f'sql/load_staging_{entity}.sql',
                execution_timeout=timedelta(minutes=10),
            )
            create >> load

    
    with TaskGroup('run_dbt_models', tooltip='Run and test dbt models') as dbt_group:
        run_dbt = BashOperator(
            task_id='run_dbt',
            # bash_command='cd /opt/airflow/dbt && dbt run --profiles-dir .',
            bash_command='cd /opt/airflow/dbt && dbt run --profiles-dir . --log-level DEBUG',
            execution_timeout=timedelta(minutes=15),
        )

        test_dbt = BashOperator(
            task_id='test_dbt',
            bash_command='cd /opt/airflow/dbt && dbt test --profiles-dir .',
            execution_timeout=timedelta(minutes=5),
        )

        run_dbt >> test_dbt

  
    notify_success = EmailOperator(
        task_id='notify_success',
        to='sthasimran2000@gmail.com',  
        subject='Airflow Success: end_to_end_data_pipeline',
        html_content='<p>The end-to-end data pipeline completed successfully.</p>',
        trigger_rule='all_success'
    )

    init_raw >> staging_group >> dbt_group >> notify_success
