WITH stripe_subscriptions_src AS (

    SELECT *
    FROM {{ ref('postgres_stripe_subscriptions')}}

),

stripe_customers_src AS (

    SELECT *
    FROM {{ ref('postgres_stripe_customers')}}

),

stripe_plans_src AS (

    SELECT *
    FROM {{ ref('postgres_stripe_plans')}}

),

stripe_charges_src AS (

    SELECT *
    FROM {{ ref('postgres_stripe_charges')}}

),

analytics_projects_all_not_deleted_src AS (

    SELECT *
    FROM {{ ref('analytics_projects_all_not_deleted')}}

),

cte_active_paid AS (

    SELECT
        subs.id as subscription_id,
        customers.email,
        subs.status,
        subs.created,
        plans.name                 as product_plan,
        subs.metadata_project_id   as project_id,
        subs.customer_id,
        customers.metadata_user_id as user_id,
        coalesce(plans.amount::int, 0) / 100 as amount,
        plans.interval
    from stripe_subscriptions_src subs
        left join stripe_customers_src customers on subs.customer_id = customers.id
        left join stripe_plans_src plans on subs.plan_id = plans.id
    where status <> 'canceled'
          and customers.email not in ('youval.vaknin@gmail.com', 'dan.barak@gmail.com', 'ramon@stackbit.com', 'kristin@stackbit.com')

),

latest_charge AS (

    SELECT customer_id, MAX(received_at::date) as last_charged_at
    FROM stripe_charges_SRC
    GROUP BY customer_id

),

charges_latest_charge AS (

    SELECT 
        charges.customer_id,
        coalesce (charges.amount::int, 0) / 100 as recent_charge,
        charges.received_at::date as recent_charge_date
    FROM stripe_charges_src charges
        left join latest_charge on charges.customer_id = latest_charge.customer_id
    WHERE 
        charges.received_at::date = latest_charge.last_charged_at

),

paid_with_latest_charge AS (

    SELECT
        charges_latest_charge.recent_charge,
        charges_latest_charge.recent_charge_date,
        cte_active_paid.*
    FROM cte_active_paid
        LEFT JOIN charges_latest_charge on cte_active_paid.customer_id = charges_latest_charge.customer_id

),

final_step AS (

    select 
        paid_with_latest_charge.subscription_id,
        paid_with_latest_charge.email as email_from_stripe,
        paid_with_latest_charge.amount,
        CASE
            WHEN paid_with_latest_charge.amount = 0 THEN paid_with_latest_charge.recent_charge
            ELSE paid_with_latest_charge.amount
        END as amt_charge_aggregated,
        paid_with_latest_charge.interval,
        paid_with_latest_charge.created as subscription_purchased,
        paid_with_latest_charge.product_plan,
        paid_with_latest_charge.status,
        paid_with_latest_charge.recent_charge,
        paid_with_latest_charge.recent_charge_date,

        core_projects.*,
        current_date as paid_table_updated_at
    from paid_with_latest_charge
            left join analytics_projects_all_not_deleted_src core_projects
            on paid_with_latest_charge.project_id = core_projects.project_id

)

SELECT *
FROM final_step