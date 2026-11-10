
{{ config(materialized='table') }}

WITH mcc_spending AS (

    SELECT
        transaction_month AS reporting_month,
        merchant_category_code,
        COUNT(*) AS transaction_count,
        ROUND(SUM(transaction_amount), 2)
            AS purchase_volume,
        ROUND(AVG(transaction_amount), 2)
            AS avg_transaction_amount

    FROM {{ ref('stg_credit_card_transactions') }}

    GROUP BY 1, 2

)

SELECT
    reporting_month,
    merchant_category_code,
    transaction_count,
    purchase_volume,
    avg_transaction_amount,

    ROUND(
        100.0 * purchase_volume
        / NULLIF(
            SUM(purchase_volume) OVER (
                PARTITION BY reporting_month
            ), 0
        ),
        2
    ) AS percent_of_monthly_spend

FROM mcc_spending

ORDER BY reporting_month, purchase_volume DESC
