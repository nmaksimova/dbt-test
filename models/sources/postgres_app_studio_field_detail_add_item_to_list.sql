WITH studio_field_detail_add_item_to_list AS (
    select 
       id,
       received_at,
       event,
       event_text,
       model_name,
       original_timestamp,
       context_ip,
       context_traits_branch,
       context_traits_email,
       timestamp,
       context_page_title,
       context_user_agent,
       project_id,
       user_id,
       action,
       branch,
       context_locale,
       context_page_url,
       context_traits_subdomain,
       subdomain,
       anonymous_id,
       context_library_version,
       context_page_path,
       uuid_ts,
       context_library_name,
       sent_at,
       context_page_referrer,
       is_local,
       is_user_preset,
       model_name_name,
       model_name_label,
       model_name_label_field,
       model_name_type,
       organization_id,
       context_page_search,
       context_amplitude_session_id
    from {{ source('app_stackbit_com_production', 'studio_field_detail_add_item_to_list') }}
),

final as (
    select *
    from studio_field_detail_add_item_to_list
)

select *
from final