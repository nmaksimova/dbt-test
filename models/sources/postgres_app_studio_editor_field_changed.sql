WITH studio_editor_field_changed AS (
    select 
       id,
       received_at,
       context_library_name,
       context_library_version,
       context_page_path,
       context_page_title,
       event_text,
       sent_at,
       timestamp,
       user_id,
       context_ip,
       context_page_search,
       context_user_agent,
       event,
       uuid_ts,
       context_page_referrer,
       context_page_url,
       original_timestamp,
       project_id,
       anonymous_id,
       context_locale,
       context_traits_email,
       context_campaign_medium,
       context_campaign_name,
       context_campaign_source,
       context_campaign_content,
       environment,
       context_traits_branch,
       initiator,
       context_traits_subdomain,
       branch,
       changed_fields,
       subdomain,
       is_local,
       organization_id,
       context_amplitude_session_id
    from {{ source('app_stackbit_com_production', 'studio_editor_field_changed') }}
),

final as (
    select *
    from studio_editor_field_changed
)

select *
from final