{{ config(materialized='table') }}

SELECT
    DATE_TRUNC('month', transaction_date)::DATE
        AS reporting_month,

    COUNT(*) AS transaction_count,

    ROUND(SUM(transaction_amount), 2)
        AS total_purchase_volume,

    COUNT(DISTINCT account_id)
        AS active_accounts,

    ROUND(AVG(transaction_amount), 2)
        AS avg_transaction_amount

FROM {{ ref('stg_credit_card_transactions') }}

GROUP BY 1
ORDER BY 1
