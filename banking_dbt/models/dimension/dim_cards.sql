{{ config(materialized = 'table') }}

with cards_dimension as (
    select * from {{ ref('stg_cards') }}
)

select
    card_number,
    card_type,
    card_type_code,
    card_status,
    card_status_desc,
    card_creation_date,
    card_provider,
    credit_limit,
    account_payment_mode,
    foreign_account_id,
    product_code,
    current_timestamp as dbt_valid_from
from cards_dimension