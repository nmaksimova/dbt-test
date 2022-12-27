WITH studio_editor_field_changed_src AS (

    SELECT *
    FROM {{ ref('postgres_app_studio_editor_field_changed')}}

),

analytics_eval_accounts_src AS (

    SELECT *
    FROM {{ ref('analytics_eval_accounts') }}

),

final AS (

    SELECT 
        project_id, 
        organization_id, 
        timestamp::date as edit_made_at, 
        count(*) num_edits_per_day,
        current_date as updated_at
    FROM studio_editor_field_changed_src
    WHERE project_id in (select analytics_eval_accounts_src.project_id from analytics_eval_accounts_src)
    GROUP BY 1, 2, 3

)

SELECT *
FROM final