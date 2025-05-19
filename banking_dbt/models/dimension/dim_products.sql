{{ config(materialized = 'table') }}

with product_dimension as (
    select * from {{ ref('stg_products') }}
)

select
    product_code,
    product_type,
    product_category,
    product_subcategory,
    product_class,
    is_deposit_product,
    is_loan_product,
    is_card_product,
    is_digital_product,
    current_timestamp as dbt_valid_from
from product_dimension
