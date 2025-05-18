
{{ config(materialized = 'view') }}

with source_customers as (
    select * from {{ source('bank_data', 'customers') }}
),

cleaned_customers as (
    select
        cif_id as customer_id,
        cust_first_name as first_name,
        cust_middle_name as middle_name,
        cust_last_name as last_name,
        full_name,
        cust_type as customer_type,
        case 
            when cust_type = 'INDIVIDUAL' then 'Individual'
            when cust_type = 'LEGAL' then 'Legal Entity'
            else cust_type
        end as customer_type_desc,
        case
            when trim(cust_dob) = '' then null
            else cust_dob::date
        end as date_of_birth,
        case
            when trim(account_relationship_date) = '' then null
            else account_relationship_date::date
        end as relationship_date,
        gender,
        case
            when lower(marital_status) = 'married' then 'Married'
            when lower(marital_status) = 'unmarried' then 'Single'
            when lower(marital_status) = 'others' then 'Other'
            else marital_status
        end as marital_status,
        address_line as address,
        email,
        case 
            when length(cast(mobile_number as varchar)) > 10 then right(cast(mobile_number as varchar), 10)
            else cast(mobile_number as varchar)
        end as mobile_number,
        case
            when trim(salary_per_month::text) = '' then null
            else salary_per_month::numeric(18,2)
        end as monthly_salary,
        employment_status,
        occupation,
        riskrating as risk_rating,
        case when blacklisted = 'Y' then true when blacklisted = 'N' then false else null end as is_blacklisted,
        pan as pan_number,
        cust_community as community,
        rating,
        constitution_code,
        constitution_code_desc as constitution_description
    from source_customers
)

select
    customer_id,
    first_name,
    middle_name,
    last_name,
    full_name,
    customer_type,
    customer_type_desc,
    date_of_birth,
    relationship_date,
    gender,
    marital_status,
    address,
    email,
    mobile_number,
    monthly_salary,
    employment_status,
    occupation,
    risk_rating,
    is_blacklisted,
    pan_number,
    community,
    rating,
    constitution_code,
    constitution_description
from cleaned_customers
