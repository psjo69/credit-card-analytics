{{ config(materialized='view') }}

SELECT
    CAST(transaction_id AS INTEGER)
        AS transaction_id,

    CAST(account_id AS VARCHAR)
        AS account_id,

    CAST(transaction_date AS DATE)
        AS transaction_date,

    TRIM(merchant_name)
        AS merchant_name,

    CAST(mcc AS VARCHAR)
        AS merchant_category_code,

    CAST(transaction_amount AS DECIMAL(18,2))
        AS transaction_amount,

    DATE_TRUNC(
        'month',
        CAST(transaction_date AS DATE)
    )::DATE AS transaction_month

FROM {{ ref('credit_card_transactions') }}
