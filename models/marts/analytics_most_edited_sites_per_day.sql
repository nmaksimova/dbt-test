WITH webhook_github_push_src AS (

    SELECT *
    FROM {{ ref('postgres_api_webhook_github_push')}}

),

contentful_webhook_details_src AS (

    SELECT *
    FROM {{ ref('postgres_api_contentful_webhook_details')}}

),

webhook_sanity_src AS (

    SELECT *
    FROM {{ ref('postgres_api_webhook_sanity')}}

),

analytics_projects_all_not_deleted_src AS (

    SELECT *
    FROM {{ ref('analytics_projects_all_not_deleted')}}

),

github_edits AS (
            
    SELECT 
        project_id, timestamp::date as edit_made_at, count(*) as num_edits, 'github' as edit_type
    FROM webhook_github_push_src
    WHERE commit_source_type in ('studio', 'schema-editor', 'code-editor')
        AND timestamp::date >= '2022-01-01'
        AND commit_author_name <> 'Stackbit'
    GROUP BY 1, 2
),

contentful_edits AS (

    SELECT 
        project_id, timestamp::date as edit_made_at, 
        count(*) as num_edits, 
        'contentful' as edit_type
    FROM contentful_webhook_details_src
    WHERE timestamp::date >= '2022-01-01'
    GROUP BY 1, 2

),

sanity_edits AS (
                 
    SELECT 
        project_id, 
        timestamp::date as edit_made_at, 
        count(*) as num_edits, 
        'sanity' as edit_type
    FROM webhook_sanity_src
    WHERE timestamp::date >= '2022-01-01'
    GROUP BY 1, 2
),

all_edits AS (
                 
    SELECT *
    FROM github_edits

    UNION ALL

    SELECT *
    FROM contentful_edits

    UNION ALL

    SELECT *
    FROM sanity_edits

),

final AS (

    SELECT 
        all_edits.*, 
        core_projects.project_name
    FROM analytics_projects_all_not_deleted_src core_projects
        LEFT JOIN all_edits on core_projects.project_id = all_edits.project_id
    WHERE core_projects.project_id is not null
    ORDER BY edit_made_at desc, num_edits desc
)

SELECT *
FROM final

