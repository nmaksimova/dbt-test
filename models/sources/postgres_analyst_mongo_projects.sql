WITH mongo_projects AS (
    select * from {{ source('analyst', 'mongo_projects') }}
),

final as (
    select *
    from mongo_projects
)

select *
from final