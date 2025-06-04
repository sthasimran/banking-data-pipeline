{{ config(materialized = 'view') }}

with source as (
    select * from {{ source('bank_data', 'cards') }}
),

cleaned as (
    select
        account_number,
        card_number,

        cast(aty_code as bigint) as card_type_code,
        case 
            when aty_code = 1 then 'Debit'
            when aty_code = 2 then 'Credit'
            else 'Unknown'
        end as card_type,

        upper(trim(card_status)) as card_status,
        case 
            when upper(trim(card_status)) = 'Y' then 'Active'
            when upper(trim(card_status)) = 'N' then 'Inactive'
            else 'Unknown'
        end as card_status_desc,

        foracid as foreign_account_id,
        car_code as card_reference_code,
        product_code,

        cast(nullif(acc_paym_mode::text, '') as numeric) as account_payment_mode,
        cast(nullif(credit_limit::text, '') as numeric) as credit_limit,
        cast(nullif(trim(car_create_date), '') as date) as card_creation_date,

        case 
            when left(card_number, 2) = 'CN' then 'Bank Card'
            when left(card_number, 2) = 'CR' then 'Credit Card'
            else 'Other'
        end as card_provider,

        current_timestamp as dbt_loaded_at
    from source
)

select * from cleaned
