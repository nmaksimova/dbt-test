WITH webhook_github_push_src AS (

    SELECT *
    FROM {{ ref('postgres_api_webhook_github_push')}}

),

analytics_projects_all_not_deleted_src AS (

    SELECT *
    FROM {{ ref('analytics_projects_all_not_deleted')}}

),

final AS (

    SELECT 
        edits.id as edit_id,
        edits.project_id,
        edits.user_id,
        edits.timestamp::date as edited_at,
        edits.commit_source_type,
        all_projects.user_email,
        all_projects.email_provider
    FROM analytics_projects_all_not_deleted_src all_projects
         left join webhook_github_push_src edits
             on all_projects.project_id = edits.project_id
    WHERE all_projects.buildstatus <> 'draft'

)

SELECT *
FROM final