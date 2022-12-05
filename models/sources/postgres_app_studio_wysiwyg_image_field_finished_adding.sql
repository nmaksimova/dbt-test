WITH studio_wysiwyg_image_field_finished_adding AS (
    select 
       id,
       received_at,
       context_ip,
       event,
       user_id,
       context_locale,
       context_traits_email,
       context_user_agent,
       event_text,
       original_timestamp,
       timestamp,
       anonymous_id,
       context_library_name,
       context_page_referrer,
       context_page_title,
       context_page_url,
       context_traits_branch,
       sent_at,
       action_type,
       context_library_version,
       context_page_path,
       file_size,
       project_id,
       uuid_ts,
       file_type,
       context_page_search,
       environment,
       context_campaign_medium,
       context_campaign_name,
       context_campaign_source,
       context_campaign_content,
       branch,
       subdomain,
       context_traits_subdomain,
       is_local,
       organization_id,
       context_amplitude_session_id
    from {{ source('app_stackbit_com_production', 'studio_wysiwyg_image_field_finished_adding') }}
),

final as (
    select *
    from studio_wysiwyg_image_field_finished_adding
)

select *
from final