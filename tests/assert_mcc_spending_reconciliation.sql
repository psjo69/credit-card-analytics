
WITH mcc_totals AS (

    SELECT
        reporting_month,
        SUM(transaction_count) AS transaction_count,
        SUM(purchase_volume) AS purchase_volume,
        SUM(percent_of_monthly_spend) AS spending_percentage

    FROM {{ ref('monthly_mcc_spending') }}

    GROUP BY reporting_month

),

portfolio_totals AS (

    SELECT
        reporting_month,
        transaction_count,
        total_purchase_volume

    FROM {{ ref('monthly_portfolio_performance') }}

)

SELECT
    COALESCE(m.reporting_month, p.reporting_month) AS reporting_month,
    m.transaction_count AS mcc_transaction_count,
    p.transaction_count AS portfolio_transaction_count,
    m.purchase_volume AS mcc_purchase_volume,
    p.total_purchase_volume AS portfolio_purchase_volume,
    m.spending_percentage

FROM mcc_totals m

FULL OUTER JOIN portfolio_totals p
    ON m.reporting_month = p.reporting_month

WHERE
    m.reporting_month IS NULL
    OR p.reporting_month IS NULL
    OR m.transaction_count IS DISTINCT FROM p.transaction_count
    OR ABS(m.purchase_volume - p.total_purchase_volume) > 0.01
    OR ABS(m.spending_percentage - 100.00) > 0.05
    OR m.spending_percentage IS NULL
