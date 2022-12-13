WITH webhook_github_push AS (
    select 
       id,
       received_at,
       context_traits_auth_providers_netlify_email,
       context_traits_auth_providers_sanity_email,
       original_timestamp,
       context_traits_auth_providers_contentful_email,
       context_traits_auth_providers_github_username,
       event,
       ssg,
       committer_username,
       context_library_version,
       context_traits_auth_providers_github_display_name,
       context_traits_auth_providers_netlify_provider_user_id,
       context_traits_auth_providers_forestry_display_name,
       sent_at,
       context_traits_display_name,
       context_traits_preferences_dashboard_links_hint_dismissed,
       context_traits_auth_providers_google_email,
       context_traits_connections,
       context_traits_auth_providers_email_reset_password_token,
       context_traits_auth_providers_google_display_name,
       context_traits_temporary,
       context_traits_auth_providers_email_email,
       user_id,
       context_traits_auth_providers_contentful_provider_user_id,
       context_traits_auth_providers_netlify_display_name,
       context_traits_auth_providers_netlify_username,
       context_traits_auth_providers_google_provider_user_id,
       project_id,
       context_traits_auth_providers_contentful_display_name,
       context_traits_auth_providers_github_email,
       context_traits_auth_providers_github_provider_user_id,
       context_traits_auth_providers_sanity_display_name,
       event_text,
       uuid_ts,
       context_traits_tos_version_1_0,
       context_traits_auth_providers_forestry_provider_user_id,
       context_traits_email,
       context_traits_updated_at,
       context_traits_auth_providers_email_provider_user_id,
       context_traits_auth_providers_forestry_email,
       context_traits_widget_auth_token,
       timestamp,
       context_user_agent,
       context_traits_created_at,
       context_traits_email_verification,
       context_traits_id,
       context_traits_auth_providers_email_reset_password_expires,
       theme,
       context_traits_auth_providers_sanity_provider_user_id,
       context_traits_v,
       commit_source_type,
       context_library_name,
       commit_author_email,
       commit_committer_email,
       commit_committer_username,
       commit_committer_name,
       commit_author_name,
       commit_author_username,
       context_traits_nux,
       context_traits_stripe_customer_id,
       context_traits_surveys,
       context_traits_group_group_id,
       context_traits_group_group_overrides_trial_days_from_creation,
       context_traits_analytics_initial_referrer_landing,
       context_traits_analytics_initial_referrer,
       context_traits_analytics_initial_traffic_source,
       context_traits_auth_providers_azure_provider_user_id,
       context_traits_auth_providers_azure_email,
       commit_files_added,
       commit_files_modified,
       commit_files_removed,
       context_traits_unverified_email,
       context_traits_preferences_exclusive_platforms,
       context_traits_organization_memberships,
       context_traits_analytics_initial_utm_source,
       context_traits_analytics_initial_utm_medium,
       context_traits_analytics_initial_utm_campaign,
       context_traits_auth_providers_workos_username,
       context_traits_auth_providers_workos_display_name,
       context_traits_auth_providers_workos_provider_user_id,
       context_traits_auth_providers_workos_email,
       organization_id,
       context_traits_favorite_projects,
       anonymous_id
    from {{ source('api_stackbit_com_production', 'webhook_github_push') }}
),

final as (
    select *
    from webhook_github_push
)

select *
from final