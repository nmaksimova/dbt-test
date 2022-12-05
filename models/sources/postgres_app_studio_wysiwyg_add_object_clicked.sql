WITH studio_wysiwyg_add_object_clicked AS (
    select 
       id,
       received_at,
       original_timestamp,
       project_id,
       timestamp,
       anonymous_id,
       context_page_title,
       context_traits_email,
       context_traits_subdomain,
       model_name,
       context_locale,
       context_page_path,
       context_page_url,
       context_user_agent,
       event,
       user_id,
       context_ip,
       context_library_version,
       context_traits_branch,
       event_text,
       sent_at,
       subdomain,
       branch,
       context_library_name,
       uuid_ts,
       context_page_referrer,
       is_local,
       organization_id,
       context_campaign_source,
       context_campaign_content,
       context_campaign_name,
       context_page_search,
       context_campaign_medium,
       context_amplitude_session_id
    from {{ source('app_stackbit_com_production', 'studio_wysiwyg_add_object_clicked') }}
),

final as (
    select *
    from studio_wysiwyg_add_object_clicked
)

select *
from final