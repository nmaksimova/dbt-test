SELECT *
FROM {{ ref('postgres_api_webhook_github_push')}}