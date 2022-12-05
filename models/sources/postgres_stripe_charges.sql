WITH charges AS (
    select 
       id,
       received_at,
       amount,
       balance_transaction_id,
       description,
       payment_intent_id,
       receipt_number,
       uuid_ts,
       currency,
       payment_method_id,
       receipt_email,
       refunded,
       amount_refunded,
       customer_id,
       paid,
       status,
       captured,
       created,
       invoice_id,
       statement_descriptor,
       failure_message,
       failure_code
    from {{ source('stripe', 'charges') }}
),

final as (
    select *
    from charges
)

select *
from final