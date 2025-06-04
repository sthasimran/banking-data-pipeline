{{ config(materialized = 'view') }}

with source_accounts as (
    select * from {{ source('bank_data', 'account') }}
),

cleaned_accounts as (
    select
        cast(acid as text) as account_id,
        cast(foracid as text) as account_number,
        cast(cif_id as text) as customer_id,
        cast(nullif(acct_opn_date, '') as date) as account_open_date,

        trim(account_status) as account_status,
        case 
            when trim(account_status) = 'A' then 'Active'
            when trim(account_status) = 'D' then 'Dormant'
            when account_status is null or trim(account_status) = '' then 'Unknown'
            else 'Other'
        end as account_status_desc,

        cast(lien_amt as numeric) as lien_amount,
        cast(sanct_lim as numeric) as sanctioned_limit,
        cast(drwng_power as numeric) as drawing_power,
        cast(clr_bal_amt as numeric) as clear_balance_amount,

        lower(trim(product_schm_code)) as product_scheme_code,

        trim(schm_type) as scheme_type,
        case
            when trim(schm_type) = 'LAA' then 'Loan Account'
            when trim(schm_type) = 'TDA' then 'Term Deposit Account'
            when trim(schm_type) = 'ODA' then 'Overdraft Account'
            when trim(schm_type) = 'SBA' then 'Savings Bank Account'
            when trim(schm_type) = 'CAA' then 'Current Account'
            else 'Other'
        end as scheme_type_desc,

        cast(interest_rate as numeric) as interest_rate,
        cast(accrued_interest as numeric) as accrued_interest,

        upper(trim(acct_crncy_code)) as account_currency_code,

        upper(trim(del_flg)) as delete_flag,
        case 
            when upper(trim(del_flg)) = 'Y' then true 
            when upper(trim(del_flg)) = 'N' then false 
            else null 
        end as is_deleted,

        upper(trim(acct_cls_flg)) as account_close_flag,
        case 
            when upper(trim(acct_cls_flg)) = 'Y' then true 
            when upper(trim(acct_cls_flg)) = 'N' then false 
            else null 
        end as is_closed,

        trim(limit_b2kid) as limit_id,

        current_timestamp as dbt_updated_at
    from source_accounts
)

select * from cleaned_accounts
