{{ config(materialized='table') }}

with products as (
    select * from {{ ref('stg_products') }}
),

accounts as (
    select product_scheme_code from {{ ref('stg_accounts') }}
),

usage as (
    select
        a.product_scheme_code,
        count(*) as account_count
    from accounts a
    group by a.product_scheme_code
)

select
    p.product_code,
    p.product_type,
    p.product_category,
    p.product_class,
    u.account_count
from products p
left join usage u on p.product_code = u.product_scheme_code
