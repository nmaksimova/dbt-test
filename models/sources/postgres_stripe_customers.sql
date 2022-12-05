WITH customers AS (
    select 
       id,
       received_at,
       currency,
       email,
       delinquent,
       metadata_user_id,
       uuid_ts,
       account_balance,
       created,
       description,
       default_source
    from {{ source('stripe', 'customers') }}
),

final as (
    select *
    from customers
)

select *
from final