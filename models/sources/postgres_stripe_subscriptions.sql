WITH subscriptions AS (
    select 
       id,
       received_at,
       current_period_end,
       plan_id,
       quantity,
       start,
       trial_end,
       cancel_at_period_end,
       canceled_at,
       created,
       current_period_start,
       ended_at,
       discount_id,
       status,
       customer_id,
       metadata_project_id,
       trial_start,
       uuid_ts,
       is_deleted,
       metadata_ignored_subscription,
       metadata_organization_id
    from {{ source('stripe', 'subscriptions') }}
),

final as (
    select *
    from subscriptions
)

select *
from final