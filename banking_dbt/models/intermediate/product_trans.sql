{{ config(materialized = 'table') }}

with accounts as (
    select account_id, product_scheme_code from {{ ref('stg_accounts') }}
),

products as (
    select product_code, product_category from {{ ref('stg_products') }}
),

transactions as (
    select account_id, transaction_amount from {{ ref('stg_transactions') }}
)

select
    p.product_category,
    count(t.transaction_amount) as transaction_count,
    sum(t.transaction_amount) as total_transaction_amount
from transactions t
left join accounts a on t.account_id = a.account_id
left join products p on a.product_scheme_code = p.product_code
group by p.product_category