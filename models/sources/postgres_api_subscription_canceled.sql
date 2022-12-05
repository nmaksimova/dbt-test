WITH subscription_canceled AS (
    select 
       id,
       received_at,
       context_traits_auth_providers_google_email,
       context_traits_tos_version_1_0,
       context_traits_analytics_initial_traffic_source,
       context_traits_auth_providers_netlify_display_name,
       context_traits_temporary,
       timestamp,
       context_traits_auth_providers_github_email,
       context_traits_auth_providers_google_provider_user_id,
       event,
       context_traits_auth_providers_forestry_provider_user_id,
       context_traits_analytics_initial_referrer_landing,
       context_traits_auth_providers_forestry_email,
       context_traits_connections,
       event_text,
       sent_at,
       user_id,
       uuid_ts,
       context_library_version,
       context_traits_updated_at,
       project_id,
       context_traits_auth_providers_netlify_email,
       context_traits_auth_providers_github_display_name,
       context_traits_auth_providers_netlify_username,
       context_traits_created_at,
       context_traits_preferences_exclusive_platforms,
       context_traits_stripe_customer_id,
       context_traits_surveys,
       tier_id,
       context_library_name,
       context_traits_auth_providers_google_display_name,
       context_traits_auth_providers_netlify_provider_user_id,
       context_traits_display_name,
       context_traits_email,
       context_traits_id,
       context_traits_nux,
       context_traits_v,
       context_traits_auth_providers_github_username,
       original_timestamp,
       context_traits_widget_auth_token,
       context_traits_auth_providers_forestry_display_name,
       context_traits_auth_providers_github_provider_user_id,
       context_traits_preferences_dashboard_links_hint_dismissed,
       context_user_agent,
       context_traits_analytics_initial_referrer,
       context_traits_auth_providers_contentful_display_name,
       context_traits_auth_providers_contentful_email,
       context_traits_auth_providers_contentful_provider_user_id,
       context_traits_auth_providers_email_provider_user_id,
       context_traits_auth_providers_email_email,
       context_traits_email_verification,
       context_traits_auth_providers_sanity_display_name,
       context_traits_auth_providers_sanity_provider_user_id,
       context_traits_auth_providers_sanity_email,
       context_traits_unverified_email,
       context_traits_organization_memberships,
       project_url,
       user_email,
       context_traits_analytics_initial_utm_source,
       context_traits_analytics_initial_utm_medium,
       context_traits_analytics_initial_utm_campaign,
       context_traits_favorite_projects,
       organization_id,
       context_traits_auth_providers_workos_provider_user_id,
       context_traits_auth_providers_workos_username,
       context_traits_auth_providers_workos_email,
       context_traits_auth_providers_workos_display_name
    from {{ source('api_stackbit_com_production', 'subscription_canceled') }}
),

final as (
    select *
    from subscription_canceled
)

select *
from final