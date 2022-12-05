WITH studio_duplicate_page_duplicated_page AS (
    select 
       id,
       received_at,
       sent_at,
       uuid_ts,
       context_page_title,
       context_traits_email,
       context_locale,
       context_page_referrer,
       context_page_search,
       context_page_url,
       original_timestamp,
       context_library_name,
       context_library_version,
       event,
       timestamp,
       anonymous_id,
       context_page_path,
       event_text,
       project_id,
       user_id,
       context_ip,
       context_user_agent,
       context_traits_branch,
       context_traits_subdomain,
       branch,
       subdomain,
       is_local,
       context_amplitude_session_id,
       organization_id
    from {{ source('app_stackbit_com_production', 'studio_duplicate_page_duplicated_page') }}
),

final as (
    select *
    from studio_duplicate_page_duplicated_page
)

select *
from final