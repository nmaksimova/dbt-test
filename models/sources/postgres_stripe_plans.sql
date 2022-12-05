WITH plans AS (
    select 
       id,
       received_at,
       amount,
       interval_count,
       name,
       statement_descriptor,
       created,
       currency,
       interval,
       uuid_ts,
       is_deleted
    from {{ source('stripe', 'plans') }}
),

final as (
    select *
    from plans
)

select *
from final