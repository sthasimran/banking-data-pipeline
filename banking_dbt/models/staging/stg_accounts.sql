
{{ config(materialized = 'view') }}

with source_accounts as (
    select * from {{ source('bank_data', 'account') }}
),

cleaned_accounts as (
    select
        acid as account_id,
        foracid as account_number,
        cif_id as customer_id,
        cast(acct_opn_date as timestamp) as account_open_date,
        account_status,
        case 
            when account_status = 'A' then 'Active'
            when account_status = 'D' then 'Dormant'
            when account_status is null then 'Unknown'
            else account_status
        end as account_status_desc,
        cast(lien_amt as numeric) as lien_amount,
        cast(sanct_lim as numeric) as sanctioned_limit,
        cast(drwng_power as numeric) as drawing_power,
        cast(clr_bal_amt as numeric) as clear_balance_amount,
        product_schm_code as product_scheme_code,
        schm_type as scheme_type,
        case
            when schm_type = 'LAA' then 'Loan Account'
            when schm_type = 'TDA' then 'Term Deposit Account'
            when schm_type = 'ODA' then 'Overdraft Account'
            when schm_type = 'SBA' then 'Savings Bank Account'
            when schm_type = 'CAA' then 'Current Account'
            else schm_type
        end as scheme_type_desc,
        cast(interest_rate as numeric) as interest_rate,
        cast(accrued_interest as numeric) as accrued_interest,
        acct_crncy_code as account_currency_code,
        del_flg as delete_flag,
        case when del_flg = 'Y' then true when del_flg = 'N' then false else null end as is_deleted,
        acct_cls_flg as account_close_flag,
        case when acct_cls_flg = 'Y' then true when acct_cls_flg = 'N' then false else null end as is_closed,
        limit_b2kid as limit_id,
        current_timestamp as dbt_updated_at
    from source_accounts
)

select
    account_id,
    account_number,
    customer_id,
    account_open_date,
    account_status,
    account_status_desc,
    lien_amount,
    sanctioned_limit,
    drawing_power,
    clear_balance_amount,
    product_scheme_code,
    scheme_type,
    scheme_type_desc,
    interest_rate,
    accrued_interest,
    account_currency_code,
    delete_flag,
    is_deleted,
    account_close_flag,
    is_closed,
    limit_id,
    dbt_updated_at
from cleaned_accounts