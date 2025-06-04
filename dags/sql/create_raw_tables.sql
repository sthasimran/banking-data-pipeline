CREATE TABLE IF NOT EXISTS raw.customers (
    cif_id TEXT,
    cust_first_name TEXT,
    cust_middle_name TEXT,
    cust_last_name TEXT,
    full_name TEXT,
    cust_type TEXT,
    cust_dob TEXT,  
    gender TEXT,
    address_line TEXT,
    employment_status TEXT,
    salary_per_month DOUBLE PRECISION,
    riskrating TEXT,
    marital_status TEXT,
    occupation TEXT,
    blacklisted TEXT,
    PAN TEXT,
    email TEXT,
    cust_community TEXT,
    rating TEXT,
    constitution_code TEXT,
    constitution_code_desc TEXT,
    mobile_number DOUBLE PRECISION,
    account_relationship_date TEXT  
);


CREATE TABLE IF NOT EXISTS raw.transactions (
    transaction_id TEXT,
    transaction_key TEXT,
    foracid TEXT,
    transaction_amount DOUBLE PRECISION,
    amount_left DOUBLE PRECISION,
    p_tran_type TEXT,
    digital_flag TEXT,
    transaction_channel_type TEXT,
    timestamp TEXT  
);

CREATE TABLE IF NOT EXISTS raw.product (
    product_scheme_code TEXT,
    product_scheme_type TEXT,
    product_scheme_category TEXT,
    product_scheme_sub_category TEXT
);



CREATE TABLE IF NOT EXISTS raw.account (
    acid TEXT,
    foracid TEXT,
    cif_id TEXT,
    acct_opn_date TEXT,  
    account_status TEXT,
    lien_amt DOUBLE PRECISION,
    product_schm_code TEXT,
    schm_type TEXT,
    sanct_lim DOUBLE PRECISION,
    acct_crncy_code TEXT,
    del_flg TEXT,
    acct_cls_flg TEXT,
    drwng_power DOUBLE PRECISION,
    interest_rate DOUBLE PRECISION,
    accrued_interest DOUBLE PRECISION,
    limit_b2kid TEXT,
    clr_bal_amt DOUBLE PRECISION
);


CREATE TABLE IF NOT EXISTS raw.cards (
    account_number TEXT,
    card_number TEXT,
    aty_code BIGINT,
    card_status TEXT,
    foracid TEXT,
    car_code BIGINT,
    product_code TEXT,
    acc_paym_mode DOUBLE PRECISION,
    credit_limit DOUBLE PRECISION,
    car_create_date TEXT  
);
