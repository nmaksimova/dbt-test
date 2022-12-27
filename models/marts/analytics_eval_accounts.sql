WITH analytics_projects_all_not_deleted_src AS (

    SELECT *
    FROM {{ ref('analytics_projects_all_not_deleted')}}

),

organizations_src AS (

    SELECT *
    FROM {{ ref('postgres_analyst_mongo_organizations') }}

),

final AS (

    SELECT
        orgs.name as org_name,
        projects.*
    FROM analytics_projects_all_not_deleted_src projects
        left join organizations_src orgs ON projects.organizationid = orgs._id
    WHERE organizationid in ('6307b4fa00a2a400bdb13242', '62fe3d8b2ecd7400bd97a00b',
                             '62e131e155775500bdd5400c', '62db1247884a6400bf5b7dd9',
                             '62a9caabd61a0f00bd3fc8fa', '62a0b2631d163f00bfe1c795', '62994bb7fc631a00bfa1014c',
                            '631f29caa1870800bf4b842d',
                            '6329d02e8f671c00bd92dea5', '633b12a3b22fa700bd481c07', '633722a8b22fa700bd4589b8')

)

SELECT *
FROM final