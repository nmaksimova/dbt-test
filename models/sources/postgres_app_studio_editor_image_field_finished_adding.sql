WITH studio_editor_image_field_finished_adding AS (
    select 
       id,
       received_at,
       context_page_path,
       context_user_agent,
       original_timestamp,
       anonymous_id,
       context_library_name,
       context_library_version,
       context_locale,
       context_page_referrer,
       context_page_search,
       context_page_title,
       context_traits_email,
       uuid_ts,
       action_type,
       context_page_url,
       event,
       event_text,
       file_size,
       file_type,
       user_id,
       context_ip,
       project_id,
       sent_at,
       timestamp,
       context_campaign_source,
       context_campaign_medium,
       context_campaign_name,
       context_campaign_content,
       environment,
       context_traits_branch,
       branch,
       context_traits_subdomain,
       subdomain
    from {{ source('app_stackbit_com_production', 'studio_editor_image_field_finished_adding') }}
),

final as (
    select *
    from studio_editor_image_field_finished_adding
)

select *
from final