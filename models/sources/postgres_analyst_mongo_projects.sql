WITH mongo_projects AS (
    select
       _id,
       name,
       ownerid,
       organizationid,
       siteurl,
       tier,
       studioscore,
       developercommits,
       realscoreauto,
       monthlyvisits,
       realsites1_1,
       realsites1_2,
       collaboratorstotal,
       collaboratorsactive,
       didchangenetlifyname,
       theme,
       ssg,
       cms,
       subdomain,
       createdat,
       deployedat,
       deleted,
       buildstatus,
       imported,
       frompool,
       local,
       themesource
    from {{ source('analyst', 'mongo_projects') }}
),

final as (
    select *
    from mongo_projects
)

select *
from final