WITH studio_cms_panel_add_item_to_list AS (
    select 
       id,
       received_at,
       subdomain,
       context_ip,
       context_library_name,
       context_locale,
       context_page_title,
       context_traits_subdomain,
       context_user_agent,
       original_timestamp,
       branch,
       anonymous_id,
       context_page_path,
       context_page_url,
       context_traits_branch,
       context_traits_email,
       event,
       event_text,
       action,
       sent_at,
       timestamp,
       uuid_ts,
       model_name,
       project_id,
       user_id,
       context_library_version,
       context_page_referrer,
       is_user_preset,
       is_local,
       context_page_search,
       organization_id,
       context_amplitude_session_id
    from {{ source('app_stackbit_com_production', 'studio_cms_panel_add_item_to_list') }}
),

final as (
    select *
    from studio_cms_panel_add_item_to_list
)

select *
from final