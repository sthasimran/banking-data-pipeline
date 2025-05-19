{{ config(materialized = 'table') }}

with cards as (
    select card_number, foreign_account_id, card_type, credit_limit from {{ ref('stg_cards') }}
),

transactions as (
    select account_id, transaction_amount from {{ ref('stg_transactions') }}
)

select
    c.card_type,
    count(distinct c.card_number) as card_count,
    sum(c.credit_limit) as total_credit_limit,
    sum(t.transaction_amount) as total_card_transaction_amount
from cards c
left join transactions t on c.foreign_account_id = t.account_id
group by c.card_type
