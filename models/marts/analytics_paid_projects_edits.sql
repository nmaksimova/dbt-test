WITH webhook_github_push_src AS (

    SELECT *
    FROM {{ ref('postgres_api_webhook_github_push')}}

),

analytics_active_paid_projects_src AS (

    SELECT *
    FROM {{ ref('analytics_active_paid_projects')}}

),

analytics_paid_projects_edits AS (

    SELECT edits.id              as edit_id,
           edits.project_id,
           edits.user_id,
           edits.timestamp::date as edited_at,
           edits.commit_source_type
    FROM webhook_github_push_src edits
             left join analytics_active_paid_projects_src paid on edits.project_id = paid.project_id
    WHERE paid.project_id is not null

)

SELECT *
FROM analytics_paid_projects_edits