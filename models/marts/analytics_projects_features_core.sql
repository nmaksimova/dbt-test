WITH projects_src AS (

    SELECT *
    FROM {{ ref('postgres_analyst_mongo_projects') }}

),

users_src AS (

    SELECT *
    FROM {{ ref('postgres_analyst_mongo_users') }}
),

publish_src AS (

    SELECT *
    FROM {{ ref('postgres_app_studio_publish_site_clicked')}}

),

collaborators_src AS (

    SELECT *
    FROM {{ ref('postgres_api_collaborators_invite_collaborator')}}

),

copied_preview_link_src AS (

    SELECT *
    FROM {{ ref('postgres_app_studio_share_popup_copied_preview_link')}}

),

preview_click_src AS (

    SELECT *
    FROM {{ ref('postgres_app_studio_mode_changed')}}

),

subscription_purchased_src AS (

    SELECT *
    FROM {{ ref('postgres_api_subscription_purchased')}}

),

publish_scheduled_src AS (

    SELECT *
    FROM {{ ref('postgres_api_project_schedule_publishing_scheduled')}}

),

webhook_github_push_src AS (

    SELECT *
    FROM {{ ref('postgres_api_webhook_github_push')}}
),

page_created_src AS (

    SELECT *
    FROM {{ ref('postgres_app_studio_create_page_created_page')}}

),

page_dupicated_src AS (

    SELECT *
    FROM {{ ref('postgres_app_studio_duplicate_page_duplicated_page')}}
),

image_added_src AS (

    SELECT *
    FROM {{ ref('postgres_app_studio_editor_image_field_finished_adding')}}
),

wysiwyg_image_added_src AS (

    SELECT *
    FROM {{ ref('postgres_app_studio_wysiwyg_image_field_finished_adding')}}

),

subscription_cancelled_src AS (

    SELECT *
    FROM {{ ref('postgres_api_subscription_canceled')}}

),

section_added_wysiwyg_src AS (

    SELECT *
    FROM {{ ref('postgres_app_studio_wysiwyg_add_object_clicked')}}
),

section_added_page_src AS (

    SELECT *
    FROM {{ ref('postgres_app_studio_field_detail_add_item_to_list')}}
),

section_added_cms_src AS (

    SELECT *
    FROM {{ ref('postgres_app_studio_cms_panel_add_item_to_list')}}
),

custom_domain_added_src AS (

    SELECT *
    FROM {{ ref('postgres_app_studio_custom_domain_added')}}

),

repo_transferred_src AS (

    SELECT *
    FROM {{ ref('postgres_api_transfer_repo_success')}}

),

changedCopyrightText_src AS (

    SELECT *
    FROM {{ ref('postgres_app_studio_editor_field_changed')}}

),


projects AS (
    select projects._id       as project_id,
           projects.name      as project_name,
           projects.ownerid   as user_id,
           projects.siteurl,
           projects.tier,
           projects.monthlyvisits,
           projects.realsites1_2,
           projects.collaboratorstotal,
           projects.createdat as project_created_at
    from projects_src projects
    left join users_src users on projects.ownerId = users._id
    where deleted is false and buildstatus <> 'draft' AND
          projects.createdat::date >= '2021-01-01'::date and

    (users.email not in
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
            'romanlyga+medium@gmail.com', 'nataliia.maksimova@gmail.com',
            'vanessa@tesletter.com', 'assafslv@gmail.com', 'elad.rosenheim+mosh@gmail.com', 'sean@stackbit.com',
           'scdavis41@gmail.com', 'stackbit@kumarbots.com') OR users.email IS NULL)
      AND (users.email not like ('%stackbit.com%') OR users.email IS NULL)

),

publish AS (

    select 
        project_id,
        event_text as event_type,
        count(*) as event_count,
        MIN(timestamp::date) as first_event_at,
        MAX(timestamp::date) as latest_event_at
    from publish_src
    group by 1,2
),

collaborators AS (
    select 
        project_id,
        event_text as event_type,
        count(*) as event_count,
        MIN(timestamp::date) as first_event_at,
        MAX(timestamp::date) as latest_event_at
    from collaborators_src
    group by 1,2

),

copied_preview_link AS (
    select 
        project_id,
        event_text as event_type,
        count(*) as event_count,
        MIN(timestamp::date) as first_event_at,
        MAX(timestamp::date) as latest_event_at
    from copied_preview_link_src
    group by 1,2

),

preview_click AS (
    select 
        project_id,
        event_text as event_type,
        count(*) as event_count,
        MIN(timestamp::date) as first_event_at,
        MAX(timestamp::date) as latest_event_at
    from preview_click_src
    where mode = 'preview'
    group by 1,2

),

subscription_purchased AS (
    select 
        project_id,
        event_text as event_type,
        count(*) as event_count,
        MIN(timestamp::date) as first_event_at,
        MAX(timestamp::date) as latest_event_at
    from subscription_purchased_src
    group by 1,2

),

publish_scheduled AS (
    select 
        project_id,
        event_text as event_type,
        count(*) as event_count,
        MIN(timestamp::date) as first_event_at,
        MAX(timestamp::date) as latest_event_at
    from publish_scheduled_src
    group by 1,2

),

edits AS (
    select 
        project_id,
        event_text as event_type,
        commit_source_type,
        count(*) as event_count,
        MIN(timestamp::date) as first_event_at,
        MAX(timestamp::date) as latest_event_at
    from webhook_github_push_src
    group by 1,2,3

),

page_created AS (
    select 
        project_id,
        event_text as event_type,
        count(*) as event_count,
        MIN(timestamp::date) as first_event_at,
        MAX(timestamp::date) as latest_event_at
    from page_created_src
    group by 1,2

),

page_duplicated AS (
    select 
        project_id,
        event_text as event_type,
        count(*) as event_count,
        MIN(timestamp::date) as first_event_at,
        MAX(timestamp::date) as latest_event_at
    from page_duplicated_src
    group by 1,2

),

image_added AS (
    select 
        project_id,
        event_text as event_type,
        count(*) as event_count,
        MIN(timestamp::date) as first_event_at,
        MAX(timestamp::date) as latest_event_at
    from image_added_src
    group by 1,2

),

wysiwyg_image_added AS (
    select 
        project_id,
        event_text as event_type,
        action_type,
        count(*) as event_count,
        MIN(timestamp::date) as first_event_at,
        MAX(timestamp::date) as latest_event_at
    from wysiwyg_image_added_src
    group by 1,2,3

),

subscription_cancelled AS (
    select 
        project_id,
        event_text as event_type,
        count(*) as event_count,
        MIN(timestamp::date) as first_event_at,
        MAX(timestamp::date) as latest_event_at
    from subscription_cancelled_src
    group by 1,2
),

section_added_wysiwyg AS (
    select 
        project_id,
        event_text as event_type,
        count(*) as event_count,
        MIN(timestamp::date) as first_event_at,
        MAX(timestamp::date) as latest_event_at
    from section_added_wysiwyg_src
    group by 1,2
),

section_added_page AS (
    select 
        project_id,
        event_text as event_type,
        count(*) as event_count,
        MIN(timestamp::date) as first_event_at,
        MAX(timestamp::date) as latest_event_at
    from section_added_page_src
    group by 1,2
),

section_added_cms AS (
    select 
        project_id,
        event_text as event_type,
        count(*) as event_count,
        MIN(timestamp::date) as first_event_at,
        MAX(timestamp::date) as latest_event_at
    from section_added_cms_src
    group by 1,2
),

custom_domain_added AS (
    select 
        project_id,
        event_text as event_type,
        count(*) as event_count,
        MIN(timestamp::date) as first_event_at,
        MAX(timestamp::date) as latest_event_at
    from custom_domain_added_src
    group by 1,2
),

custom_components_added AS (
    select 
        project_id,
        event_text as event_type,
        count(*) as event_count,
        MIN(timestamp::date) as first_event_at,
        MAX(timestamp::date) as latest_event_at
    from webhook_github_push_src
    where commit_files_added like '%src/components%' 

),

model_added AS (
    select 
        project_id,
        event_text as event_type,
        count(*) as event_count,
        MIN(timestamp::date) as first_event_at,
        MAX(timestamp::date) as latest_event_at
    from webhook_github_push_src
    where commit_files_added like '%.stackbit/models%'
    group by 1,2

),

preset_added AS (
    select 
        project_id,
        event_text as event_type,
        count(*) as event_count,
        MIN(timestamp::date) as first_event_at,
        MAX(timestamp::date) as latest_event_at
    from webhook_github_push_src
    where commit_files_added like '%.stackbit/presets%'
    group by 1,2
),

repo_transferred AS (
    select
        project_id,
        event_text as event_type,
        count(*) as event_count,
        MIN(timestamp::date) as first_event_at,
        MAX(timestamp::date) as latest_event_at
    from repo_transferred_src
    group by 1,2
),

changedCopyrightText as (
    select
        project_id,
        'Changed Copyright Text' as event_type,
        count(*) as event_count,
        MIN(timestamp::date) as first_event_at,
        MAX(timestamp::date) as latest_event_at
    from changedCopyrightText_src
    where changed_fields like '%fields.footer.fields.copyrightText%'
    group by 1,2

),

-- **************************
-- CORE tables
-- **************************

publish_core AS (
    select 
        projects.project_id,
        siteurl,
--case when event_type is NULL then 'Publish Site' else event_type end as event_type,
        'Publish' as event_type,
        case when event_type is NULL then 0 else event_count end as event_count,
        first_event_at,
        latest_event_at
    from projects
        left join publish on projects.project_id = publish.project_id
        
),

collaborators_core AS (
    select 
        projects.project_id,
        siteurl,
        'Collaborators' as event_type,
        case when event_type is NULL then 0 else event_count end              as event_count,
        first_event_at,
        latest_event_at
    from projects
        left join collaborators on projects.project_id = collaborators.project_id
),

copied_preview_link_core AS (
    select 
        projects.project_id,
        siteurl,
        'Copied Preview Link' as event_type,
        case when event_type is NULL then 0 else event_count end as event_count,
        first_event_at,
        latest_event_at
    from projects
        left join copied_preview_link on projects.project_id = copied_preview_link.project_id
),

preview_click_core AS (
    select 
        projects.project_id,
        siteurl,
        'Preview Click' as event_type,
        case when event_type is NULL then 0 else event_count end as event_count,
        first_event_at,
        latest_event_at
    from projects
        left join preview_click on projects.project_id = preview_click.project_id
),

subscription_purchased_core AS (
    select 
        projects.project_id,
        siteurl,
        'Subscription Purchased' as event_type,
        case when event_type is NULL then 0 else event_count end as event_count,
        first_event_at,
        latest_event_at
    from projects
        left join subscription_purchased on projects.project_id = subscription_purchased.project_id
),

publish_scheduled_core AS (
    select 
        projects.project_id,
        siteurl,
        'Publish Scheduled' as event_type,
        case when event_type is NULL then 0 else event_count end as event_count,
        first_event_at,
        latest_event_at
    from projects
        left join publish_scheduled on projects.project_id = publish_scheduled.project_id
),

studio_edits_core AS (
    select 
        projects.project_id,
        siteurl,
        'Studio Edits' as event_type,
        SUM(case when event_type is NULL then 0 else event_count end) as event_count,
        MIN(first_event_at) as first_event_at,
        MAX(latest_event_at) as latest_event_at
    from projects
        left join edits on projects.project_id = edits.project_id
    WHERE commit_source_type in ('studio', 'schema-editor')
    GROUP BY 1,2,3
),

developer_edits_core AS (
    select 
        projects.project_id,
        siteurl,
        'Developer Edits' as event_type,
        SUM(case when event_type is NULL then 0 else event_count end) as event_count,
        MIN(first_event_at) as first_event_at,
        MAX(latest_event_at) as latest_event_at
    from projects
        left join edits on projects.project_id = edits.project_id
    WHERE commit_source_type in ('developer', 'github-web-flow')
    GROUP BY 1,2,3
),

code_editor_edits_core AS (
    select 
        projects.project_id,
        siteurl,
        'Code Editor Edits' as event_type,
        case when event_type is NULL then 0 else event_count end as event_count,
        first_event_at,
        latest_event_at
    from projects
        left join edits on projects.project_id = edits.project_id
    WHERE commit_source_type = 'code-editor'
),

page_created_core AS (
    select 
        projects.project_id,
        siteurl,
        'Page Created' as event_type,
        case when event_type is NULL then 0 else event_count end as event_count,
        first_event_at,
        latest_event_at
    from projects
        left join page_created on projects.project_id = page_created.project_id
),

page_duplicated_core AS (
    select 
        projects.project_id,
        siteurl,
        'Page Duplicated' as event_type,
        case when event_type is NULL then 0 else event_count end as event_count,
        first_event_at,
        latest_event_at
    from projects
        left join page_duplicated on projects.project_id = page_duplicated.project_id
),

image_added_core AS (
    select 
        projects.project_id,
        siteurl,
        'Image Added' as event_type,
        case when event_type is NULL then 0 else event_count end as event_count,
        first_event_at,
        latest_event_at
    from projects
        left join image_added on projects.project_id = image_added.project_id
),

wysiwyg_image_added_upload_core AS (
    select 
        projects.project_id,
        siteurl,
        'WYSIWYG Image Added Upload' as event_type,
        case when event_type is NULL then 0 else event_count end as event_count,
        first_event_at,
        latest_event_at
    from projects
        left join wysiwyg_image_added on projects.project_id = wysiwyg_image_added.project_id
    where action_type = 'upload'
),

wysiwyg_image_added_gallery_core AS (
    select 
        projects.project_id,
        siteurl,
        'WYSIWYG Image Added Gallery' as event_type,
        case when event_type is NULL then 0 else event_count end as event_count,
        first_event_at,
        latest_event_at
    from projects
        left join wysiwyg_image_added on projects.project_id = wysiwyg_image_added.project_id
    where action_type = 'gallery'
),

subscription_cancelled_core AS (
    select 
        projects.project_id,
        siteurl,
        'Subscription Cancelled' as event_type,
        case when event_type is NULL then 0 else event_count end as event_count,
        first_event_at,
        latest_event_at
    from projects
        left join subscription_cancelled on projects.project_id = subscription_cancelled.project_id
),

section_added_wysiwyg_core AS (
    select 
        projects.project_id,
        siteurl,
        'Section Added WYSIWYG' as event_type,
        case when event_type is NULL then 0 else event_count end as event_count,
        first_event_at,
        latest_event_at
    from projects
        left join section_added_wysiwyg on projects.project_id = section_added_wysiwyg.project_id

),

section_added_page_core AS (
    select 
        projects.project_id,
        siteurl,
        'Section Added Page' as event_type,
        case when event_type is NULL then 0 else event_count end as event_count,
        first_event_at,
        latest_event_at
    from projects
        left join section_added_page on projects.project_id = section_added_page.project_id

),

section_added_cms_core AS (
    select 
        projects.project_id,
        siteurl,
        'Section Added CMS' as event_type,
        case when event_type is NULL then 0 else event_count end as event_count,
        first_event_at,
        latest_event_at
    from projects
        left join section_added_cms on projects.project_id = section_added_cms.project_id

),

custom_domain_added_core AS (
    select 
        projects.project_id,
        siteurl,
        'Custom Domain Added' as event_type,
        case when event_type is NULL then 0 else event_count end as event_count,
        first_event_at,
        latest_event_at
    from projects
        left join custom_domain_added on projects.project_id = custom_domain_added.project_id
),

custom_components_added_core AS (
    select 
        projects.project_id,
        siteurl,
        'Custom Components Added' as event_type,
        case when event_type is NULL then 0 else event_count end as event_count,
        first_event_at,
        latest_event_at
    from projects
        left join custom_components_added on projects.project_id = custom_components_added.project_id
),

model_added_core AS (
    select 
        projects.project_id,
        siteurl,
        'Model Added' as event_type,
        case when event_type is NULL then 0 else event_count end as event_count,
        first_event_at,
        latest_event_at
    from projects
        left join model_added on projects.project_id = model_added.project_id
),

preset_added_core AS (
    select 
        projects.project_id,
        siteurl,
        'Preset Added' as event_type,
        case when event_type is NULL then 0 else event_count end as event_count,
        first_event_at,
        latest_event_at
    from projects
        left join preset_added on projects.project_id = preset_added.project_id
),

repo_transferred_core AS (
    select 
        projects.project_id,
        siteurl,
        'Repo Transferred' as event_type,
        case when event_type is NULL then 0 else event_count end as event_count,
        first_event_at,
        latest_event_at
    from projects
        left join repo_transferred on projects.project_id = repo_transferred.project_id
),

changedCopyrightText_core AS (
    select 
        projects.project_id,
        siteurl,
        changedCopyrightText.event_type,
        case when event_type is NULL then 0 else event_count end as event_count,
        first_event_at,
        latest_event_at
    from projects
        left join changedCopyrightText on projects.project_id = changedCopyrightText.project_id
),

-- *************************
-- ALL PROJECTS
-- *************************

projects_all AS (


         SELECT *
         FROM publish_core

         UNION ALL

         SELECT *
         FROM collaborators_core

         UNION ALL

         SELECT *
         FROM copied_preview_link_core

         UNION ALL

         SELECT *
         FROM preview_click_core

         UNION ALL

         SELECT *
         FROM subscription_purchased_core

         UNION ALL

         SELECT *
         FROM publish_scheduled_core

         UNION ALL

         SELECT *
         FROM studio_edits_core

         UNION ALL

         SELECT *
         FROM developer_edits_core

         UNION ALL

         SELECT *
         FROM code_editor_edits_core

         UNION ALL

         SELECT *
         FROM page_created_core

         UNION ALL

         SELECT *
         FROM page_duplicated_core

         UNION ALL

         SELECT *
         FROM image_added_core

         UNION ALL

         SELECT *
         FROM wysiwyg_image_added_upload_core

         UNION ALL

         SELECT *
         FROM wysiwyg_image_added_gallery_core

         UNION ALL

         SELECT *
         FROM subscription_cancelled_core

         UNION ALL

         SELECT *
         FROM section_added_wysiwyg_core

         UNION ALL

         SELECT *
         FROM section_added_page_core

         UNION ALL

         SELECT *
         FROM section_added_cms_core

         UNION ALL

         SELECT *
         FROM custom_domain_added_core

         UNION ALL

         SELECT *
         FROM custom_components_added_core

         UNION ALL

         SELECT *
         FROM model_added_core

         UNION ALL

         SELECT *
         FROM preset_added_core

         UNION ALL

         SELECT *
         FROM repo_transferred_core

         UNION ALL

         SELECT *
         FROM changedCopyrightText_core
)

select *
from projects_all