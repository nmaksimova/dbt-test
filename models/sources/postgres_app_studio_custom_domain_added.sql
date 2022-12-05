WITH studio_custom_domain_added AS (
    select 
       id,
       received_at,
       event_text,
       original_timestamp,
       context_library_version,
       context_traits_subdomain,
       event,
       context_page_url,
       context_traits_branch,
       context_traits_email,
       project_id,
       anonymous_id,
       branch,
       context_page_title,
       user_id,
       context_user_agent,
       domain,
       sent_at,
       subdomain,
       timestamp,
       context_library_name,
       context_locale,
       context_page_path,
       uuid_ts,
       context_ip,
       context_page_referrer,
       context_campaign_content,
       context_campaign_source,
       context_page_search,
       context_campaign_medium,
       context_campaign_name,
       context_amplitude_session_id
    from {{ source('app_stackbit_com_production', 'studio_custom_domain_added') }}
),

final as (
    select *
    from studio_custom_domain_added
)

select *
from final