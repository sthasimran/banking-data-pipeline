
{{ config(materialized = 'view') }}

with source_products as (
    select * from {{ source('bank_data', 'product') }}
),

cleaned_products as (
    select
        product_scheme_code as product_code,
        product_scheme_type as product_type,
        product_scheme_category as product_category,
        product_scheme_sub_category as product_subcategory,
        case
            when product_scheme_category = 'Deposit' then 'Liability'
            when product_scheme_category = 'Loan' then 'Asset'
            when product_scheme_category in ('Debit Card', 'Credit Card', 'Digital') then 'Service'
            else 'Other'
        end as product_class,
        case when product_scheme_category = 'Deposit' then true else false end as is_deposit_product,
        case when product_scheme_category = 'Loan' then true else false end as is_loan_product,
        case when product_scheme_category in ('Debit Card', 'Credit Card') then true else false end as is_card_product,
        case when product_scheme_category = 'Digital' then true else false end as is_digital_product
    from source_products
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
    is_digital_product
from cleaned_products
