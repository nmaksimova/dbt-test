WITH subscription_page_loaded AS (
    select 
       id,
       received_at,
       context_library_version,
       original_timestamp,
       anonymous_id,
       context_library_name,
       context_user_agent,
       project_id,
       context_page_title,
       context_traits_branch,
       context_page_referrer,
       context_traits_email,
       timestamp,
       user_id,
       context_ip,
       context_locale,
       uuid_ts,
       event,
       event_text,
       sent_at,
       context_page_path,
       context_page_url,
       context_campaign_name,
       context_campaign_source,
       context_campaign_medium,
       context_page_search,
       context_campaign_content,
       context_traits_subdomain,
       organization_id,
       context_amplitude_session_id
    from {{ source('app_stackbit_com_production', 'subscription_page_loaded') }}
),

final as (
    select *
    from subscription_page_loaded
)

select *
from final