WITH user_reg AS (

    SELECT user_id, max(type) as registered_with
    from {{ ref('postgres_api_user_registered')}}
    GROUP BY user_id

),

projects_src AS (

    SELECT *
    FROM {{ ref('postgres_analyst_mongo_projects') }}

),

users_src AS (

    SELECT *
    FROM {{ ref('postgres_analyst_mongo_users') }}

),

subscription_page_loaded_src AS (

    SELECT *
    FROM {{ ref ('postgres_app_subscription_page_loaded') }}

),

webhook_github_push_src AS (

    SELECT *
    FROM {{ ref ('postgres_api_webhook_github_push') }}

),

studio_loaded_src AS (

    SELECT *
    FROM {{ ref ('postgres_app_studio_loaded') }}

),

studio_editor_field_changed_src AS (

    SELECT *
    FROM {{ ref ('postgres_app_studio_editor_field_changed') }}

),

studio_publish_site_clicked_src AS (

    SELECT *
    FROM {{ ref ('postgres_app_studio_publish_site_clicked') }}

),

analytics_projects_features_core_src AS (

    SELECT *
    FROM {{ ref ('analytics_projects_features_core')}}
),

users_email AS (

    SELECT 
        position('@' in users.email) as pos, 
        users.*,
        user_reg.registered_with
    FROM users_src users
        left join user_reg ON
            users._id = user_reg.user_id

),

email_provider AS (

    SELECT 
        substr(email, pos + 1) AS email_provider, *
    FROM users_email

),

price_page_checked AS (

    SELECT 
        user_id, 
        MAX(timestamp::date) as price_checked_at, 
        count(*) times_checked_price
    FROM subscription_page_loaded_src
    GROUP BY user_id

),

users_all AS (

    SELECT 
        users.*,
        CASE WHEN price_page_checked.user_id is NULL then 'did not check price page' else 'checked price page' END price_page_check,
        price_checked_at, times_checked_price
    FROM email_provider users
        left join price_page_checked ON users._id = price_page_checked.user_id

),

projects_all AS (

    SELECT
            projects.organizationid,
            projects._id          as project_id,
            projects.name         as project_name,
            projects.ownerid      as user_id,
            projects.siteurl,
            projects.tier,
            projects.studioscore,
            projects.developercommits,
            projects.realscoreauto,
            projects.monthlyvisits,
            projects.realsites1_2 as real_site,
            projects.collaboratorstotal,
            projects.collaboratorsactive,
            projects.didchangenetlifyname,
            projects.theme,
            projects.ssg,
            projects.cms,
            coalesce(projects.subdomain, 'NA') as subdomain,
            projects.createdat::date    as project_createdat,
            projects.deployedat,
            projects.deleted,
            projects.buildstatus,
            projects.imported,
            projects.fromPool,
            projects.themesource,
            CASE
                WHEN coalesce(siteurl, 'NA') like '%stackbit.app%' or coalesce(siteurl, 'NA') like '%netlify.app%'
                    or coalesce(siteurl, 'NA') = 'NA' or coalesce(siteurl, 'NA') like '%stackbit.dev%' THEN 'not a custom domain'
                ELSE 'custom domain'
            END as custom_domain,
            projects.local,
            CASE WHEN projects.local THEN 1 ELSE 0 END AS local_count,
            users.createdat             as user_createdat,
            users.displayname           as user_name,
            users.email                 as user_email,
            users.roles,
            users.surveypersona,
            users.surveyarchetype,
            users.email_provider,
            users.registered_with,
            users.initialtrafficsource,
            users.initialreferrer,
            users.initialreferrerlanding,
            users.price_page_check,
            users.price_checked_at,
            users.times_checked_price
     FROM projects_src projects
             left join users_all users on projects.ownerId = users._id
     WHERE projects.deleted is not true and buildstatus <> 'draft'
       and (users.email not in
            ('dan.barak@gmail.com', 'dan.barak+sb3@gmail.com', 'ohadprs@gmail.com', 'semenh@gmail.com',
             'semn', 'rodikh@gmail.com', 'vitaliyrtest2@gmail.com', 'vitaliyrtest1@gmail.com',
             'hello@benedfit.com', 'denysov.artem@gmail.com', 'dmarten@gmail.com', 'fade@fade.cc',
             'fade@faderud.com', 'fade@faderud.com', 'brian.rinaldi@gmail.com', 'dberlin@gmail.com',
             'hello@newhighsco.re', 'youval.vaknin@gmail.com', 'mail@eduardoboucas.com',
             'dan.barak+controlcenter@gmail.com',
             'ohad@visual-i.com', 'roman.stackbit@gmail.com', 'romanlyga@gmail.com', 'romanlyga@gmail.com',
             'romanrandom@gmail.com',
             'stackbit.roman@gmail.com', 'romanlyga', '1dwayne.mcdaniel@gmail.com', 'ndumai@gmail.com', 'r@mon.dev',
             'stackbittest@gmail.com',
             'romanlyga+medium@gmail.com', 'nataliia.maksimova@gmail.com', 'vanessa@tesletter.com',
             'assafslv@gmail.com', 'test.denysov.artem@gmail.com','vanessaramosp@gmail.com', 'schickling.j@gmail.com',
             'elad.rosenheim+mosh@gmail.com', 'sean@stackbit.com',
             'scdavis41@gmail.com', 'stackbit@kumarbots.com', 'scdavis41+211103@gmail.com', 'tbdizainas@gmail.com') OR users.email IS NULL)
       AND (users.email not like ('%stackbit.com%') OR users.email IS NULL)
       and projects.createdat::date >= '2021-01-01'::date

),

projects_per_user AS (

    SELECT user_id, count(*) as num_projects_per_user
    FROM projects_all
    GROUP BY user_id

),

edits_by_day AS (

    SELECT project_id, timestamp::date as edited_at, count(*) as num_edits
    FROM webhook_github_push_src
    WHERE commit_source_type in ('studio', 'schema-editor', 'code-editor') AND
        timestamp::date >= '2021-01-01'::date AND commit_author_name <> 'Stackbit'
    GROUP BY 1, 2

),

edits_all AS (

    SELECT project_id, max(timestamp::date) as latest_edit, count(*) as num_total_edits
    FROM webhook_github_push_src
    WHERE commit_source_type in ('studio', 'schema-editor', 'code-editor') AND
        timestamp::date >= '2021-01-01'::date AND commit_author_name <> 'Stackbit'
    GROUP BY 1

),

edits_last_30_days AS (

    SELECT project_id, count(*) as last_30_days_edits
    FROM webhook_github_push_src
    WHERE commit_source_type in ('studio', 'schema-editor', 'code-editor') AND
        timestamp::date >= (CURRENT_DATE + '- 30 days'::interval)::date
        AND commit_author_name <> 'Stackbit'
    GROUP BY project_id

),

studio_opened_7_days AS (

    select project_id, count(*) studio_loaded_7_days
    from studio_loaded_src
    where timestamp::date >= (CURRENT_DATE + '- 7 days'::interval)::date
    group by project_id

),

studio_edits_7_days AS (

    SELECT project_id, count(*) studio_edits_7_days
    FROM studio_editor_field_changed_src
    WHERE timestamp::date >= (CURRENT_DATE + '- 7 days'::interval)::date
    GROUP BY project_id

),

studio_publishes_7_days AS (

    SELECT project_id, count(*) studio_publishes_7_days
    FROM studio_publish_site_clicked_src
    WHERE timestamp::date >= (CURRENT_DATE + '- 7 days'::interval)::date
    GROUP BY project_id

),

core_projects_all AS (

           SELECT projects_all.*,
                coalesce(edits_by_day.num_edits, 0) as first_day_edits,
                CASE
                    WHEN coalesce(edits_by_day.num_edits, 0) = 0 THEN '0 edits'
                    WHEN coalesce(edits_by_day.num_edits, 0) >0 AND coalesce(edits_by_day.num_edits, 0) <= 10 THEN '[1-10] edits'
                    WHEN coalesce(edits_by_day.num_edits, 0) > 10 AND coalesce(edits_by_day.num_edits, 0) <= 20 THEN '[11-20] edits'
                    WHEN coalesce(edits_by_day.num_edits, 0) > 20 AND coalesce(edits_by_day.num_edits, 0) <= 30 THEN '[21-30] edits'
                    WHEN coalesce(edits_by_day.num_edits, 0) > 30 AND coalesce(edits_by_day.num_edits, 0) <= 40 THEN '[31-40] edits'
                    WHEN coalesce(edits_by_day.num_edits, 0) > 40 AND coalesce(edits_by_day.num_edits, 0) <= 50 THEN '[41-50] edits'
                    WHEN coalesce(edits_by_day.num_edits, 0) > 50 AND coalesce(edits_by_day.num_edits, 0) <= 60 THEN '[51-60] edits'
                    WHEN coalesce(edits_by_day.num_edits, 0) > 60 AND coalesce(edits_by_day.num_edits, 0) <= 70 THEN '[61-70] edits'
                    WHEN coalesce(edits_by_day.num_edits, 0) > 70 AND coalesce(edits_by_day.num_edits, 0) <= 80 THEN '[71-80] edits'
                    WHEN coalesce(edits_by_day.num_edits, 0) > 80 AND coalesce(edits_by_day.num_edits, 0) <= 90 THEN '[81-90] edits'
                    WHEN coalesce(edits_by_day.num_edits, 0) > 90 AND coalesce(edits_by_day.num_edits, 0) <= 100 THEN '[91-100] edits'
                    WHEN coalesce(edits_by_day.num_edits, 0) > 100 THEN '> 100 edits'
                END AS first_day_edits_buckets,
                coalesce(edits_all.num_total_edits, 0) as total_edits,
                coalesce(edits_last_30_days.last_30_days_edits, 0) as last_30_days_edits,
                projects_per_user.num_projects_per_user,
                CASE
                    WHEN num_projects_per_user = 1 THEN '1 project'
                    WHEN num_projects_per_user = 2 THEN '2 projects'
                    WHEN num_projects_per_user >= 3 and num_projects_per_user <= 5 THEN '3-5 projects'
                    WHEN num_projects_per_user >= 6 and num_projects_per_user <= 10 THEN '6-10 projects'
                    WHEN num_projects_per_user >= 11 and num_projects_per_user <= 20 THEN '11-20 projects'
                    WHEN num_projects_per_user >= 21 and num_projects_per_user <= 40 THEN '21-40 projects'
                    WHEN num_projects_per_user > 40 THEN '> 40 projects'
                END as projects_per_user_buckets,
                coalesce(features_publish.event_count, 0) as publish_count,
                coalesce(features_custom_components.event_count, 0) as custom_component_count,
                coalesce(features_pages_added.event_count, 0) as pages_added,

                coalesce(features_model_added.event_count, 0) as models_added,
                coalesce(features_preset_added.event_count, 0) as presets_added,
                coalesce(features_repo_transferred.event_count, 0) as repo_transferred,
                coalesce(features_copyright_text.event_count, 0) as changed_copyright_text,

                coalesce(studio_opened_7_days.studio_loaded_7_days, 0) as studio_loaded_7_days,
                coalesce(studio_edits_7_days.studio_edits_7_days, 0) as studio_edits_7_days,
                coalesce(studio_publishes_7_days.studio_publishes_7_days, 0) as studio_publishes_7_days,

                latest_edit,
                current_date as updated_at

       FROM projects_all
            left join projects_per_user on projects_all.user_id = projects_per_user.user_id
            left join edits_by_day on projects_all.project_id = edits_by_day.project_id and
                                      projects_all.project_createdat = edits_by_day.edited_at
            left join edits_all on projects_all.project_id = edits_all.project_id
            left join edits_last_30_days on projects_all.project_id = edits_last_30_days.project_id
            left join analytics_projects_features_core_src features_publish on projects_all.project_id = features_publish.project_id and
                                                                           features_publish.event_type = 'Publish'
            left join analytics_projects_features_core_src features_custom_components on projects_all.project_id = features_custom_components.project_id and
                                                                           features_custom_components.event_type = 'Custom Components Added'
            left join analytics_projects_features_core_src features_pages_added on projects_all.project_id = features_pages_added.project_id and
                                                                           features_pages_added.event_type = 'Page Created'
            left join analytics_projects_features_core_src features_model_added on projects_all.project_id = features_model_added.project_id and
                                                                           features_model_added.event_type = 'Model Added'
            left join analytics_projects_features_core_src features_preset_added on projects_all.project_id = features_preset_added.project_id and
                                                                           features_preset_added.event_type = 'Preset Added'
            left join analytics_projects_features_core_src features_repo_transferred on projects_all.project_id = features_repo_transferred.project_id and
                                                                           features_repo_transferred.event_type = 'Repo Transferred'
            left join analytics_projects_features_core_src features_copyright_text on projects_all.project_id = features_copyright_text.project_id and
                                                                           features_copyright_text.event_type = 'Changed Copyright Text'
            left join studio_opened_7_days on projects_all.project_id = studio_opened_7_days.project_id
            left join studio_edits_7_days on projects_all.project_id = studio_edits_7_days.project_id
            left join studio_publishes_7_days on projects_all.project_id = studio_publishes_7_days.project_id

),

users_segments AS (

    SELECT
        user_id,
        SUM(models_added)           as models_added,
        SUM(presets_added)          as presets_added,
        SUM(custom_component_count) as custom_components_added,
        SUM(repo_transferred)       as num_repo_transfers,
        SUM(local_count) as local_per_user,
        SUM(developercommits) as developer_commits_per_user
    FROM core_projects_all
    GROUP BY 1

),

projects_core AS (

    SELECT core_projects_all.*,
       date_trunc('week', project_createdat::date)::date as project_created_start_week,
       (date_trunc('week', project_createdat::date)::date + '6 days'::interval)::date as project_created_end_week,
       users_segments.models_added as models_added_per_user,
       users_segments.developer_commits_per_user,
       users_segments.custom_components_added as custom_components_added_per_user,
       users_segments.num_repo_transfers as repo_transfers_per_user,
       CASE
           WHEN users_segments.local_per_user > 0 OR
                users_segments.num_repo_transfers > 0 OR
                users_segments.custom_components_added > 0 OR
                users_segments.models_added >0 OR
                users_segments.developer_commits_per_user > 0
           THEN 'developer' ELSE 'not a developer'
       END as user_type
    FROM core_projects_all
        LEFT JOIN users_segments on core_projects_all.user_id = users_segments.user_id

),

final_step AS (

    SELECT *,
                CASE
                    --WHEN latest_edit is NULL OR CURRENT_DATE::date - latest_edit::date > 30 THEN 'Not Active'
                    WHEN last_30_days_edits < 3 THEN 'Not Active'
                    --WHEN latest_edit is not NULL AND CURRENT_DATE::date - latest_edit::date <= 30
                    WHEN last_30_days_edits >= 3
                        AND CURRENT_DATE::date - project_createdat::date <= 30 THEN 'Active'
                    WHEN last_30_days_edits >= 3
                    --WHEN latest_edit is not NULL AND CURRENT_DATE::date - latest_edit::date <= 30
                        AND CURRENT_DATE::date - project_createdat::date > 30
                        THEN 'Retained'
                 END as project_active_bucket
    FROM projects_core

)

SELECT *
FROM final_step
