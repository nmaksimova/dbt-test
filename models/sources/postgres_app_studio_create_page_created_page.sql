WITH studio_create_page_created_page AS (
    select 
       id,
       received_at,
       context_ip,
       context_library_version,
       context_locale,
       context_page_path,
       context_page_search,
       context_user_agent,
       sent_at,
       anonymous_id,
       context_page_referrer,
       project_id,
       timestamp,
       context_library_name,
       context_page_title,
       context_page_url,
       context_traits_email,
       event,
       event_text,
       original_timestamp,
       user_id,
       uuid_ts,
       context_campaign_name,
       context_campaign_medium,
       context_campaign_source,
       context_campaign_content,
       context_traits_branch,
       preset,
       page_type,
       subdomain,
       context_traits_subdomain,
       branch,
       path,
       is_local,
       initiator,
       organization_id,
       context_amplitude_session_id
    from {{ source('app_stackbit_com_production', 'studio_create_page_created_page') }}
),

final as (
    select *
    from studio_create_page_created_page
)

select *
from final