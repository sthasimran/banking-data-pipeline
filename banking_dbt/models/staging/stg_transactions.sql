{{ config(materialized = 'view') }}

with source as (
    select * from {{ source('bank_data', 'transactions') }}
),

cleaned as (
    select
        cast(transaction_id as text) as transaction_id,
        cast(transaction_key as text) as transaction_key,
        cast(foracid as text) as account_id,

        upper(trim(p_tran_type)) as transaction_type,
        case 
            when upper(trim(p_tran_type)) = 'C' then 'Credit'
            when upper(trim(p_tran_type)) = 'D' then 'Debit'
            else 'Unknown'
        end as transaction_type_desc,

        cast(transaction_amount as numeric) as transaction_amount,

        cast(nullif(trim(amount_left::text), '') as numeric) as amount_left,

        case 
            when upper(trim(digital_flag)) = 'Y' then true
            when upper(trim(digital_flag)) = 'N' then false
            else null
        end as is_digital,

        initcap(trim(transaction_channel_type)) as channel_type,

        to_timestamp(nullif(trim(timestamp), ''), 'YYYY-MM-DD"T"HH24:MI:SS') as transaction_timestamp,
        to_timestamp(nullif(trim(timestamp), ''), 'YYYY-MM-DD"T"HH24:MI:SS')::date as transaction_date,
        to_timestamp(nullif(trim(timestamp), ''), 'YYYY-MM-DD"T"HH24:MI:SS')::time as transaction_time,

        substr(transaction_id, 1, 2) as transaction_source_code,

        current_timestamp as dbt_loaded_at
    from source
)

select * from cleaned
