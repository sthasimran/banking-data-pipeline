
{{ config(materialized = 'view') }}

with source as (
    select * from {{ source('bank_data', 'customers') }}
),

cleaned as (
    select
        cif_id as customer_id,

        nullif(trim(cust_first_name), '') as first_name,
        nullif(trim(cust_middle_name), '') as middle_name,
        nullif(trim(cust_last_name), '') as last_name,
        nullif(trim(full_name), '') as full_name,

        upper(trim(cust_type)) as customer_type,
        case 
            when upper(trim(cust_type)) = 'INDIVIDUAL' then 'Individual'
            when upper(trim(cust_type)) = 'LEGAL' then 'Legal Entity'
            else 'Other'
        end as customer_type_desc,

        cast(nullif(trim(cust_dob), '') as date) as date_of_birth,
        cast(nullif(trim(account_relationship_date), '') as date) as relationship_date,

        lower(trim(gender)) as gender,

        case 
            when lower(trim(marital_status)) = 'married' then 'Married'
            when lower(trim(marital_status)) = 'unmarried' then 'Single'
            when lower(trim(marital_status)) = 'others' then 'Other'
            else 'Unknown'
        end as marital_status,

        nullif(trim(address_line), '') as address,
        lower(trim(email)) as email,

        case
            when length(cast(mobile_number as text)) > 10 
                then right(cast(mobile_number as text), 10)
            else cast(mobile_number as text)
        end as mobile_number,

        cast(nullif(trim(salary_per_month::text), '') as numeric(18,2)) as monthly_salary,

        lower(trim(employment_status)) as employment_status,
        lower(trim(occupation)) as occupation,
        trim(riskrating) as risk_rating,

        case 
            when upper(trim(blacklisted)) = 'Y' then true
            when upper(trim(blacklisted)) = 'N' then false
            else null
        end as is_blacklisted,

        upper(trim(pan)) as pan_number,
        lower(trim(cust_community)) as community,
        lower(trim(rating)) as rating,

        trim(constitution_code) as constitution_code,
        trim(constitution_code_desc) as constitution_description

    from source
)

select * from cleaned
