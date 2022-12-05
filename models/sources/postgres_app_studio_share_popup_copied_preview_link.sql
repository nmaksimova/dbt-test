WITH studio_share_popup_copied_preview_link AS (
    select 
       id,
       received_at,
       anonymous_id,
       context_user_agent,
       context_library_name,
       context_library_version,
       context_locale,
       context_page_path,
       context_page_referrer,
       original_timestamp,
       context_ip,
       context_page_search,
       context_page_title,
       context_page_url,
       event,
       sent_at,
       timestamp,
       user_id,
       context_traits_email,
       event_text,
       project_id,
       uuid_ts,
       context_campaign_medium,
       context_campaign_source,
       context_campaign_name,
       context_campaign_content,
       _user,
       context_traits_branch,
       subdomain,
       branch,
       context_traits_subdomain,
       organization_id,
       context_amplitude_session_id
    from {{ source('app_stackbit_com_production', 'studio_share_popup_copied_preview_link') }}
),

final as (
    select *
    from studio_share_popup_copied_preview_link
)

select *
from final