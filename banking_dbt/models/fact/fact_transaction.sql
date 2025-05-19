{{ config(materialized = 'table') }}

with transactions as (
    select * from {{ ref('stg_transactions') }}
),

accounts as (
    select account_id, customer_id, product_scheme_code from {{ ref('stg_accounts') }}
),

customers as (
    select customer_id, full_name from {{ ref('dim_customers') }}
),

products as (
    select product_code, product_category from {{ ref('dim_products') }}
)

select
    t.transaction_id,
    t.transaction_key,
    t.account_id,
    a.customer_id,
    c.full_name as customer_name,
    a.product_scheme_code as product_code,
    p.product_category,
    t.transaction_type,
    t.transaction_type_desc,
    t.transaction_amount,
    t.amount_left,
    t.channel_type,
    t.transaction_timestamp,
    t.transaction_date,
    t.transaction_time,
    t.is_digital,
    t.transaction_source_code,
    t.dbt_loaded_at as dbt_transaction_loaded_at,
    current_timestamp as dbt_fact_loaded_at
from transactions t
left join accounts a on t.account_id = a.account_id
left join customers c on a.customer_id = c.customer_id
left join products p on a.product_scheme_code = p.product_code