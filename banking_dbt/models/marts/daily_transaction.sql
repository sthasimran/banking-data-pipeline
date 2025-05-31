{{ config(materialized='incremental', unique_key='transaction_date') }}

select
    transaction_date,
    count(*) as total_transactions,
    sum(case when transaction_type = 'C' then transaction_amount else 0 end) as total_credits,
    sum(case when transaction_type = 'D' then transaction_amount else 0 end) as total_debits
from {{ ref('stg_transactions') }}
group by transaction_date
