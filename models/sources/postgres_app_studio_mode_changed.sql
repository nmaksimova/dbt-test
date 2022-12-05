WITH studio_mode_changed AS (
    select 
       id,
       received_at,
       context_page_title,
       context_traits_branch,
       original_timestamp,
       user_id,
       uuid_ts,
       context_library_name,
       context_library_version,
       event_text,
       timestamp,
       context_ip,
       context_page_path,
       context_page_referrer,
       context_page_url,
       context_traits_email,
       context_user_agent,
       event,
       anonymous_id,
       context_locale,
       mode,
       project_id,
       sent_at,
       context_campaign_medium,
       context_page_search,
       context_campaign_content,
       context_campaign_name,
       context_campaign_source,
       branch,
       subdomain,
       context_traits_subdomain,
       is_local,
       organization_id,
       context_amplitude_session_id
    from {{ source('app_stackbit_com_production', 'studio_mode_changed') }}
),

final as (
    select *
    from studio_mode_changed
)

select *
from final