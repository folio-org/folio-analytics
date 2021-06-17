/* Test with database: folio_snapshot_20210602_users
 * 
 * Fields needed:
 * Y patron barcode -> users_groups:barcode
 * Y patron name -> users_groups: user_last_name, user_first_name, user_middle_name, user_preferred_first_name
 * Y e-mail -> users_groups:user_email
 * Y patron type (group) -> users_groups:group_name
 * Y patron notes -> notes (data/links) 
 * Y expiry date of library card/patron -> users_groups:expiration_date
 * Y date of last activity -> users_groups:updated_date
 * Y patron status (blocked/expired) -> users_groups:active?
 * Y patron block -> feesfines_manualblocks (need to add)
 * Y block reason -> we can get patron message and description from manual blocks, 
 *     but additional info from block template probably needs to wait until metadb
 * Y date/time of block -> have feesfines_manualblocks:expirationDate, but not createdDate? get from metadata?
 * Y netid -> users_groups:external_system_id and/or users_groups:username
 * Y custom fields (need to add) -> users_groups:user_custom_fields (or start again with user_users and unpack data/customFields)
 *      try to template somehow
 * Y patron address [REP-216] - which one? -> users_addresses, or pull entire user_users:data/personal/addresses object 
 *      maybe have a parameter that filters to a certain address type
 * Y patron department [REP-216] (need to add)  - which one? -> users_departments, but group by and collapse names?
 * Y created date -> users_groups:created_date
 * Y GuestID (located in address field) [REP-225] -- maybe just a Voyager thing
 * Y address type [REP-225] -- maybe just a Voyager thing
 * 
 * 
 * Filters needed:
 * patron type (group)
 * activity date
 * email is blank [REP-218]
 * mailing address is blank [REP-218]
 * patron status (e.g., Active)
 * status date (e.g., created >= x) [REP-222]
 * 
 * Not yet available:
 * - blocking library -> not sure this is stored in FOLIO
 * - home library -> not sure this is stored in FOLIO
 * - patron status date --> have date block was added, but not sure how to get date when user 
 *    became active (or inactive); use history to find exactly when status changed?
 * - various filters
 * 
 * 
 * */

WITH parameters AS (
    SELECT
        /* Choose a start and end date for the request period */
        '2000-01-01'::date AS start_date,
        '2022-01-01'::date AS end_date,
        /* Fill in an address type */
        'Home'::varchar AS address_type_name_filter,
        /* Fill in a custom field */
        'college'::varchar AS custom_field_filter,
        ''::varchar AS patron_group_filter--, --Example: graduate
        --''::date AS created_after_filter,
        --'TRUE'::boolean AS active_status_filter
),
user_notes AS (
    SELECT
        json_extract_path_text(links.data, 'id') AS user_id,
        string_agg(DISTINCT nt."content", '|') AS notes_list
    FROM
        notes AS nt
        CROSS JOIN json_array_elements(json_extract_path(data, 'links')) AS links (data)
    WHERE json_extract_path_text(links.data, 'type') = 'user'
    GROUP BY
        json_extract_path_text(links.data, 'id')
),
user_custom_fields AS (
    SELECT
        id AS user_id,
        (SELECT custom_field_filter FROM parameters) AS custom_field_name,
        json_extract_path_text(data, 'customFields', (SELECT custom_field_filter FROM parameters)) AS 
          custom_field_value
    FROM
        user_users AS uu
    WHERE
        json_extract_path_text(data, 'customFields', (SELECT custom_field_filter FROM parameters)) IS NOT NULL
),
user_depts AS (
    SELECT
        user_id,
        string_agg(DISTINCT department_name, '|') AS depts_list
    FROM
        folio_reporting.users_departments_unpacked 
    GROUP BY
        user_id
),
user_addresses AS (
    SELECT
        user_id,
        --address_id,
        address_line_1,
        address_line_2,
        address_city,
        address_region,
        address_country_id,
        address_postal_code,
        --address_type_id,
        address_type_name,
        address_type_description,
        is_primary_address
    FROM
        folio_reporting.users_addresses
    WHERE address_type_name = (SELECT address_type_name_filter FROM parameters)
        OR '' = (SELECT address_type_name_filter FROM parameters)        
)
SELECT
    ug.user_id,
    ug.barcode,
    ug.username,
    ug.external_system_id,
    ug.user_last_name, 
    ug.user_first_name, 
    ug.user_middle_name, 
    ug.user_preferred_first_name,
    ug.user_email,
    ug.group_name,
    ug.created_date,
    ug.expiration_date,
    ug.updated_date,
    ug.active,
    un.notes_list AS user_notes,
    ud.depts_list,
    --json_extract_path_text(uu.data, 'customFields') AS user_all_custom_fields,
    ucf.custom_field_name,
    ucf.custom_field_value,
    mb.code IS NOT NULL AS blocked,
    mb.code AS block_code,
    mb.desc AS block_description,
    mb.patron_message AS block_patron_message,
    mb.type AS block_type,
    mb.expiration_date AS block_expiration_date,
    mb.borrowing AS block_borrowing_yn,
    mb.renewals AS block_renewals_yn,
    mb.requests AS block_requests_yn,
    json_extract_path_text(mb.data, 'metadata', 'createdDate') AS block_created_date,
    --json_extract_path_text(uu.data, 'personal', 'addresses') AS user_all_addresses,
    address_line_1,
    address_line_2,
    address_city,
    address_region,
    address_country_id,
    address_postal_code,
    address_type_name,
    address_type_description,
    is_primary_address
 FROM
    folio_reporting.users_groups AS ug
    LEFT JOIN user_notes AS un ON ug.user_id = un.user_id
    LEFT JOIN public.user_users AS uu ON ug.user_id = uu.id
    LEFT JOIN user_depts AS ud ON ug.user_id = ud.user_id
    LEFT JOIN public.feesfines_manualblocks AS mb ON ug.user_id = mb.user_id
    LEFT JOIN user_addresses AS ua ON ug.user_id = ua.user_id
    LEFT JOIN user_custom_fields AS ucf ON ug.user_id = ucf.user_id
 WHERE 
    (group_name = (SELECT patron_group_filter FROM parameters)
        OR '' = (SELECT patron_group_filter FROM parameters))
    --AND (ug.active = (SELECT active_status_filter FROM parameters)
    --    OR '' = (SELECT active_status_filter FROM parameters))
    --AND (ug.created_date >= (SELECT created_after_filter FROM parameters)
    --    OR '' = (SELECT created_after_filter FROM parameters))

;
