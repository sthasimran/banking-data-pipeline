{{ config(materialized = 'table') }}

with accounts as (
    select * from {{ ref('stg_accounts') }}
),

transactions as (
    select account_id, transaction_amount from {{ ref('stg_transactions') }}
)

select
    a.account_id,
    a.account_number,
    a.customer_id,
    a.account_open_date,
    a.account_status_desc,
    a.scheme_type_desc,
    a.clear_balance_amount,
    a.sanctioned_limit,
    sum(t.transaction_amount) as total_transaction_amount,
    count(t.transaction_amount) as transaction_count,
    (sum(t.transaction_amount) / nullif(count(t.transaction_amount), 0)) as avg_transaction_amount
from accounts a
left join transactions t on a.account_id = t.account_id
group by a.account_id, a.account_number, a.customer_id, a.account_open_date, a.account_status_desc, a.scheme_type_desc, a.clear_balance_amount, a.sanctioned_limit
