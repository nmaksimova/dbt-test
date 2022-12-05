WITH mongo_users AS (
    select 
       _id,
       initialtrafficsource,
       initialreferrer,
       initialreferrerlanding,
       createdat,
       displayname,
       email,
       roles,
       surveypersona,
       surveyarchetype,
       surveyskills,
       temporary,
       emailverification
    from {{ source('analyst', 'mongo_users') }}
),

final as (
    select *
    from mongo_users
)

select *
from final