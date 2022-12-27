WITH pageviews AS (

    SELECT 
        id,
        context_campaign_content,
        context_campaign_medium,
        context_campaign_source,
        timestamp::date as viewed_at,
        context_project_id,
        search,
        context_traits_email,
        context_campaign_name,
        path,
        url,
        referrer,
        title,
        context_page_path,
        context_page_url,
        prev_path,
        context_page_title,
        user_id,
        anonymous_id,
        context_page_referrer,
        name
    FROM {{ ref('postgres_app_pages')}}
    WHERE timestamp::date >= '2022-01-01'::date
          and user_id is not null

),

analytics_projects_all_not_deleted_src AS (

    SELECT *
    FROM {{ ref('analytics_projects_all_not_deleted')}}

),

final AS (

    SELECT 
        pageviews.*,
        projects.user_email,
        projects.user_name,
        projects.user_type,
        projects.user_createdat::date as user_createdat,
        projects.initialreferrer,
        projects.num_projects_per_user,
        projects.custom_domain,
        projects.tier,
        CASE WHEN projects.changed_copyright_text > 0 THEN 'Changed copyright text' ELSE 'Did not change copyright text'
        END as copyright_text,
        CASE
            WHEN url like '%app.stackbit.com%' then 'studio'
            WHEN url like '%docs.stackbit.com%' then 'docs'
            WHEN url like '%v1.stackbit.com/studio%' then 'v1 studio'
            ELSE 'stackbit'
        END as page_type
    FROM pageviews
             left join analytics_projects_all_not_deleted_src projects ON pageviews.user_id = projects.user_id
    WHERE projects.user_id is not null

)

SELECT *
FROM final