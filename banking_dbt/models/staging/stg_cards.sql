
{{ config(materialized = 'view') }}

with source_cards as (
    select * from {{ source('bank_data', 'cards') }}
),

cleaned_cards as (
    select
        account_number,
        card_number,
        aty_code as card_type_code,
        case when aty_code = 1 then 'Debit' when aty_code = 2 then 'Credit' else 'Unknown' end as card_type,
        card_status,
        case when card_status = 'Y' then 'Active' when card_status = 'N' then 'Inactive' else card_status end as card_status_desc,
        foracid as foreign_account_id,
        car_code as card_reference_code,
        product_code,
        case
            when trim(acc_paym_mode::text) = '' then null
            else acc_paym_mode::numeric
        end as account_payment_mode,
        case
            when trim(credit_limit::text) = '' then null
            else credit_limit::numeric
        end as credit_limit,
        car_create_date::date as card_creation_date,
        case
            when left(card_number, 2) = 'CN' then 'Bank Card'
            when left(card_number, 2) = 'CR' then 'Credit Card'
            else 'Other'
        end as card_provider,
        current_timestamp as dbt_loaded_at
    from source_cards
)

select
    account_number,
    card_number,
    card_type_code,
    card_type,
    card_status,
    card_status_desc,
    foreign_account_id,
    card_reference_code,
    product_code,
    account_payment_mode,
    credit_limit,
    card_creation_date,
    card_provider,
    dbt_loaded_at
from cleaned_cards