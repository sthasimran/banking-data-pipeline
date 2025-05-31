from airflow import DAG
from airflow.operators.email import EmailOperator
from datetime import datetime

with DAG(
    dag_id='test_email',
    start_date=datetime(2025, 5, 1),
    schedule_interval=None,
    catchup=False
) as dag:

    notify = EmailOperator(
        task_id='send_test_email',
        to='sthasimran2000@gmail.com',
        subject='Test Email from Airflow',
        html_content='<p>This is a test email sent from your Airflow setup.</p>',
    )
