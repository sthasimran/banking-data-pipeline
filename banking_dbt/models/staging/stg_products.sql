
{{ config(materialized = 'view') }}

with source as (
    select * from {{ source('bank_data', 'product') }}
),

cleaned as (
    select
        upper(trim(product_scheme_code)) as product_code,
        upper(trim(product_scheme_type)) as product_type,
        initcap(trim(product_scheme_category)) as product_category,
        initcap(trim(product_scheme_sub_category)) as product_subcategory,

        case
            when lower(trim(product_scheme_category)) = 'deposit' then 'Liability'
            when lower(trim(product_scheme_category)) = 'loan' then 'Asset'
            when lower(trim(product_scheme_category)) in ('debit card', 'credit card', 'digital') then 'Service'
            else 'Other'
        end as product_class,

        lower(trim(product_scheme_category)) = 'deposit' as is_deposit_product,
        lower(trim(product_scheme_category)) = 'loan' as is_loan_product,
        lower(trim(product_scheme_category)) in ('debit card', 'credit card') as is_card_product,
        lower(trim(product_scheme_category)) = 'digital' as is_digital_product

    from source
)

select * from cleaned
