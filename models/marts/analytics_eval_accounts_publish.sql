WITH studio_publish_site_clicked_src AS (

    SELECT *
    FROM {{ ref('postgres_app_studio_publish_site_clicked')}}

),

analytics_eval_accounts_src AS (

    SELECT *
    FROM {{ ref('analytics_eval_accounts') }}

),

final AS (

    SELECT 
        project_id, 
        organization_id, 
        timestamp::date as published_at, 
        count(*) num_publishes_per_day,
        current_date as updated_at
    FROM studio_publish_site_clicked_src
    WHERE project_id in (select analytics_eval_accounts_src.project_id from analytics_eval_accounts_src)
    GROUP BY 1, 2, 3

)

SELECT *
FROM final