{{ config(materialized = 'table') }}

with customers as (
    select customer_id, full_name from {{ ref('stg_customers') }}
),

accounts as (
    select account_id, customer_id from {{ ref('stg_accounts') }}
),

transactions as (
    select account_id, transaction_amount, transaction_date from {{ ref('stg_transactions') }}
)

select
    c.customer_id,
    c.full_name,
    count(t.transaction_amount) as total_transactions,
    sum(t.transaction_amount) as total_transaction_amount,
    min(t.transaction_date) as first_transaction_date,
    max(t.transaction_date) as last_transaction_date
from customers c
left join accounts a on c.customer_id = a.customer_id
left join transactions t on a.account_id = t.account_id
group by c.customer_id, c.full_name