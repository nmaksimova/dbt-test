WITH users_src AS (

    SELECT *
    FROM {{ ref('postgres_analyst_mongo_users') }}
),

users_email AS (

    SELECT position('@' in email) as pos, *
    FROM users_src
),

email_provider AS (

    SELECT substr(email, pos + 1) AS email_provider, *
    FROM users_email
),

provider_users AS (

    SELECT email_provider, count(*) as num_users
    FROM email_provider
    GROUP BY email_provider
    ORDER by num_users DESC

),

provider_users_emails AS (

    SELECT email_provider, email, _id as user_id
    FROM email_provider

),

providers_clean AS (

    select *
    from provider_users
    where (num_users > 1 and num_users < 7 and
        email_provider not in ('github.com', 'libero.it', 'live.ca', 'live.cn', 'mail.gvsu.edu',
                                'nnn.ed.jp', 'seznam.cz', 'criptext.com', 'disroot.org', 'gatech.edu',
                                'snipcart.com', 'yopmail.com', 'zohomail.com', 'gmx.at', 'opayq.com',
                                'relay.firefox.com', 'att.net', 'fastmail.com', 'google.com', 'hotmail.es',
                                'live.in', 'mailinator.com', 'microsoft.com', 'outlook.de', 'outlook.jp',
                                'rediffmail.com', 'tiscali.it', 'wp.pl', 'yahoo.de', 'aleeas.com',
                                'aircrft.com', 'anonaddy.me', 'athon.io', 'bluewin.ch', 'ciencias.unam.mx',
                                'comcast.net', 'ctemplar.com', 'ionos.com', 'live.nl', 'live.nmit.ac.nz',
                                'logary.tech', 'mail.de', 'outlook.com.br', 'outlook.in', 'outlook.kr',
                                'yahoo.com.au', 'yahoo.com.mx', 'yahoo.es', 'yahoo.gr', 'yeah.net',
                                'abv.bg', 'email.sc.edu', 'firemail.cc', 'firemailbox.club',
                                'gmx.ch', 'gmx.co.uk', 'hanmail.net', 'hotmail.co.jp', 'hotmail.nl',
                                'inbox.lv', 'inbox.ru', 'live.de', 'live.co.za', 'live.dk', 'mail.mcgill.ca',
                                'mynetlify.me', 'outlook.com.vn', 'outlook.cz', 'students.amikom.ac.id',
                                'studenti.uniba.it', 'studenti.polito.it', 'student.liu.se',
                                'student.hpi.de',
                                'student.dist113.org', 'stud.uniroma3.it', 'sent.com', 'post.com',
                                'yahoo.in', 'yahoo.co.id', 'tutamail.com'
                        )
                 )
        OR email_provider in ('zoho.com,', 'talacha.dev', 'vise.com', 'jobox.ai', 'bejamas.io')
),

providers_2_6_users AS (

    SELECT 
        providers_clean.email_provider,
        provider_users_emails.email,
        provider_users_emails.user_id
    FROM providers_clean
        LEFT JOIN provider_users_emails
            on providers_clean.email_provider = provider_users_emails.email_provider

),

final AS (

    SELECT leads.*,
           projects.project_id,
           projects.siteurl,
           projects.tier,
           projects.developercommits,
           projects.monthlyvisits,
           projects.real_site,
           projects.collaboratorsactive,
           projects.theme,
           projects.project_createdat,
           projects.total_edits,
           projects.latest_edit
    FROM providers_2_6_users leads
             LEFT JOIN analyst.analytics_projects_all_not_deleted projects ON leads.user_id = projects.user_id
)

SELECT *
FROM final