{{ config(materialized='table') }}

with cards as (
    select * from {{ ref('stg_cards') }}
),

card_stats as (
    select
        card_type,
        card_status_desc,
        card_number,
        count(*) as total_cards,
        sum(credit_limit) as total_credit_limit
    from cards
    group by card_type, card_status_desc, card_number

)

select * from card_stats
