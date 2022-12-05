WITH subscription_purchased AS (
    select 
       id,
       received_at,
       context_traits_widget_auth_token,
       context_library_version,
       context_traits_analytics_initial_referrer_landing,
       context_traits_auth_providers_github_username,
       context_traits_auth_providers_google_email,
       context_traits_created_at,
       context_traits_surveys,
       context_traits_temporary,
       project_url,
       tier_id,
       timestamp,
       context_library_name,
       context_traits_auth_providers_netlify_email,
       context_traits_id,
       original_timestamp,
       context_traits_auth_providers_google_display_name,
       context_traits_auth_providers_google_provider_user_id,
       context_traits_nux,
       event,
       user_email,
       uuid_ts,
       context_traits_display_name,
       context_traits_tos_version_1_0,
       context_traits_updated_at,
       context_traits_auth_providers_github_email,
       context_traits_auth_providers_netlify_provider_user_id,
       context_traits_auth_providers_netlify_username,
       context_traits_email,
       context_traits_preferences_dashboard_links_hint_dismissed,
       sent_at,
       context_traits_connections,
       project_id,
       context_traits_analytics_initial_referrer,
       context_traits_auth_providers_github_provider_user_id,
       context_traits_v,
       context_user_agent,
       user_id,
       context_traits_analytics_initial_traffic_source,
       context_traits_auth_providers_github_display_name,
       context_traits_auth_providers_netlify_display_name,
       event_text,
       context_traits_stripe_customer_id,
       context_traits_auth_providers_forestry_display_name,
       context_traits_auth_providers_contentful_provider_user_id,
       context_traits_auth_providers_forestry_email,
       context_traits_auth_providers_contentful_email,
       context_traits_auth_providers_contentful_display_name,
       context_traits_auth_providers_forestry_provider_user_id,
       context_traits_auth_providers_email_provider_user_id,
       context_traits_auth_providers_email_email,
       context_traits_email_verification,
       context_traits_preferences_exclusive_platforms,
       context_traits_unverified_email,
       context_traits_auth_providers_sanity_display_name,
       context_traits_auth_providers_sanity_provider_user_id,
       context_traits_auth_providers_sanity_email,
       context_traits_organization_memberships
    from {{ source('api_stackbit_com_production', 'subscription_purchased') }}
),

final as (
    select *
    from subscription_purchased
)

select *
from final