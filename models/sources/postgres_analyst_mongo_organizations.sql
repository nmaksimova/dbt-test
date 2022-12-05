WITH mongo_organizations AS (
    select 
       _id,
       name,
       tier,
       createdat,
       members,
       projects,
       teams,
       projectgroups,
       deleted,
       usesso
    from {{ source('analyst', 'mongo_organizations') }}
),

final as (
    select *
    from mongo_organizations
)

select *
from final