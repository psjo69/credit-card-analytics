WITH transaction_totals AS (

    SELECT
        DATE_TRUNC('month', transaction_date)::DATE
            AS reporting_month,

        COUNT(*) AS transaction_count,

        ROUND(SUM(transaction_amount), 2)
            AS total_purchase_volume

    FROM {{ ref('credit_card_transactions') }}

    GROUP BY 1

),

reporting_totals AS (

    SELECT
        reporting_month,
        transaction_count,
        total_purchase_volume

    FROM {{ ref('monthly_portfolio_performance') }}

)

SELECT
    COALESCE(t.reporting_month, r.reporting_month)
        AS reporting_month,

    t.transaction_count AS source_transaction_count,
    r.transaction_count AS reporting_transaction_count,

    t.total_purchase_volume AS source_purchase_volume,
    r.total_purchase_volume AS reporting_purchase_volume

FROM transaction_totals t

FULL OUTER JOIN reporting_totals r
    ON t.reporting_month = r.reporting_month

WHERE
    t.reporting_month IS NULL
    OR r.reporting_month IS NULL
    OR t.transaction_count IS DISTINCT FROM r.transaction_count
    OR t.total_purchase_volume IS DISTINCT FROM r.total_purchase_volume
