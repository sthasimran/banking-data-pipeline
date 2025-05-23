from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime, timedelta

default_args = {
    'owner': 'simran',
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

with DAG(
    dag_id='run_dbt_models_after_ingestion',
    default_args=default_args,
    description='Run DBT transformations after raw data ingestion',
    schedule_interval=None,
    start_date=datetime(2025, 5, 1),
    catchup=False,
    tags=['dbt', 'transformation'],
) as dag:

    run_dbt = BashOperator(
        task_id='run_dbt_models',
        bash_command='cd /opt/airflow/dbt && dbt run --profiles-dir .',
    )

    test_dbt = BashOperator(
        task_id='test_dbt_models',
        bash_command='cd /opt/airflow/dbt && dbt test --profiles-dir .',
    )

    run_dbt >> test_dbt
