
{{ config(materialized = 'table') }}

with customer_dimension as (
    select * from {{ ref('stg_customers') }}
)

select
    customer_id,
    full_name,
    first_name,
    last_name,
    gender,
    marital_status,
    date_of_birth,
    address,
    email,
    mobile_number,
    customer_type,
    customer_type_desc,
    employment_status,
    occupation,
    risk_rating,
    is_blacklisted,
    pan_number,
    community,
    rating,
    constitution_code,
    constitution_description,
    relationship_date,
    current_timestamp as dbt_valid_from
from customer_dimension