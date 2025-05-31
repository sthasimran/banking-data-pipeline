{{ config(materialized='table') }}

with customers as (
    select * from {{ ref('stg_customers') }}
),

accounts as (
    select * from {{ ref('stg_accounts') }}
),

cards as (
    select 
        a.customer_id, 
        count(*) as total_cards
    from {{ ref('stg_cards') }} c
    left join {{ ref('stg_accounts') }} a 
        on c.foreign_account_id = a.account_id
    group by a.customer_id
),

transactions as (
    select 
        account_id, 
        sum(transaction_amount) as total_transaction_amount
    from {{ ref('stg_transactions') }}
    group by account_id
),

account_summary as (
    select
        a.customer_id,
        count(*) as total_accounts,
        sum(a.clear_balance_amount) as total_balance,
        sum(t.total_transaction_amount) as total_transactions
    from accounts a
    left join transactions t 
        on a.account_id = t.account_id
    group by a.customer_id
)

select
    c.*,
    a.total_accounts,
    a.total_balance,
    a.total_transactions,
    coalesce(cd.total_cards, 0) as total_cards,
    current_date as created_at
from customers c
left join account_summary a 
    on c.customer_id = a.customer_id
left join cards cd 
    on c.customer_id = cd.customer_id
