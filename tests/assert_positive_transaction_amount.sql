SELECT
    transaction_id,
    transaction_amount

FROM {{ ref('credit_card_transactions') }}

WHERE transaction_amount <= 0
