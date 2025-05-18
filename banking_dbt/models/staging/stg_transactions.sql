
{{ config(materialized='view') }}

with source_transactions as (
    select * from {{ source('bank_data', 'transactions') }}
),

cleaned_transactions as (
    select
        transaction_id,
        transaction_key,
        foracid as account_id,
        p_tran_type as transaction_type,
        case when p_tran_type = 'C' then 'Credit' when p_tran_type = 'D' then 'Debit' else 'Unknown' end as transaction_type_desc,
        cast(transaction_amount as numeric) as transaction_amount,
        case
            when trim(amount_left::text) = '' then null
            else amount_left::numeric
        end as amount_left,
        case when digital_flag = 'Y' then true when digital_flag = 'N' then false else null end as is_digital,
        transaction_channel_type as channel_type,
        to_timestamp(timestamp, 'YYYY-MM-DD"T"HH24:MI:SS') as transaction_timestamp,
        to_timestamp(timestamp, 'YYYY-MM-DD"T"HH24:MI:SS')::date as transaction_date,
        to_timestamp(timestamp, 'YYYY-MM-DD"T"HH24:MI:SS')::time as transaction_time,
        substr(transaction_id, 1, 2) as transaction_source_code,
        current_timestamp as dbt_loaded_at
    from source_transactions
)

select
    transaction_id,
    transaction_key,
    account_id,
    transaction_type,
    transaction_type_desc,
    transaction_amount,
    amount_left,
    is_digital,
    channel_type,
    transaction_timestamp,
    transaction_date,
    transaction_time,
    transaction_source_code,
    dbt_loaded_at
from cleaned_transactions
