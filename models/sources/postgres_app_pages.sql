WITH pages AS (
    select 
       id,
       received_at,
       context_campaign_content,
       context_campaign_medium,
       context_library_version,
       context_locale,
       context_project_id,
       search,
       timestamp,
       context_campaign_source,
       context_ip,
       context_traits_email,
       sent_at,
       context_campaign_name,
       original_timestamp,
       path,
       referrer,
       title,
       context_campaign_term,
       context_library_name,
       context_page_path,
       context_page_url,
       prev_path,
       context_page_title,
       user_id,
       context_page_search,
       context_screen_height,
       context_screen_width,
       context_user_agent,
       anonymous_id,
       context_page_referrer,
       url,
       uuid_ts,
       context_campaign_campa,
       name,
       context_campaign_campaing,
       height,
       width,
       context_campaign_utm_source,
       context_campaign_utm_medium,
       context_campaign_utm_campaign,
       context_campaign_id,
       context_amplitude_session_id
    from {{ source('app_stackbit_com_production', 'pages') }}
),

final as (
    select *
    from pages
)

select *
from final