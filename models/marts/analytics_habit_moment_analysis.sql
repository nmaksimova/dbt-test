WITH webhook_github_push_src AS (

    SELECT *
    FROM {{ ref('postgres_api_webhook_github_push')}}

),

analytics_projects_all_not_deleted_src AS (

    SELECT *
    FROM {{ ref('analytics_projects_all_not_deleted')}}

),

edits AS (

    SELECT 
        project_id,
        timestamp::date               as date_edit,
        to_char(timestamp, 'IYYY-IW') as week_edit,
        count(*)                      as num_edits
    FROM webhook_github_push_src
    WHERE commit_source_type in ('code-editor', 'studio', 'schema-editor')
          and timestamp::date >= '2021-01-01'::date --and project_id = '608d1c0df1f06a0017b6b785'
        and project_id is not null
    GROUP BY 1, 2, 3

),

projects_edits AS (
    SELECT
        projects.*,
        edits.date_edit,
        edits.week_edit,
        coalesce(edits.num_edits, 0) as num_edits,
        coalesce(TRUNC(DATE_PART('day', date_edit::timestamp - project_createdat::timestamp) + 1), 0) as num_days_since_first_edit,
        coalesce(CASE
                    WHEN cast(TRUNC((DATE_PART('day', date_edit::timestamp - project_createdat::timestamp) + 1)) /7 as dec) % 1 <> 0 THEN
                     TRUNC((TRUNC((DATE_PART('day', date_edit::timestamp - project_createdat::timestamp) + 1)) /7) + 1)
                    ELSE TRUNC((DATE_PART('day', date_edit::timestamp - project_createdat::timestamp) + 1) / 7) END, 0)  as week_edit_made
    FROM analytics_projects_all_not_deleted_src projects
        left join edits on projects.project_id = edits.project_id

)

SELECT *
FROM projects_edits