WITH studio_publish_site_clicked AS (
    select 
       id,
       received_at,
       original_timestamp,
       sent_at,
       timestamp,
       anonymous_id,
       context_library_name,
       context_locale,
       context_page_url,
       context_library_version,
       context_page_path,
       event,
       uuid_ts,
       event_text,
       project_id,
       user_id,
       context_ip,
       context_page_referrer,
       context_page_search,
       context_page_title,
       context_traits_email,
       context_user_agent,
       scope,
       context_campaign_name,
       context_campaign_source,
       context_campaign_medium,
       context_campaign_content,
       context_traits_branch,
       environment,
       branch,
       subdomain,
       context_traits_subdomain,
       publish_project_scope,
       organization_id,
       context_amplitude_session_id
    from {{ source('app_stackbit_com_production', 'studio_publish_site_clicked') }}
),

final as (
    select *
    from studio_publish_site_clicked
)

select *
from final