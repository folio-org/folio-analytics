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
 * ? patron block -> feesfines_manualblocks (need to add)
 *  blocking library -> feesfines_manualblocks??
 * home library -> ?? default service point?
 * ? block reason -> feesfines_manualblocks?? looking for block type? or description? 
 * Y date/time of block -> have feesfines_manualblocks:expirationDate, but not createdDate? get from metadata?
 * Y netid -> users_groups:external_system_id and/or users_groups:username
 * "privilege type" [REP-200] --> can't do permissions until metadb?
 * "privilege location?" [REP-200] --> can't do permissions until metadb?
 * "date range filter" [REP-200] -- not sure what this means for a patron/privilege report; 
 *      is it making sure patron was active during this date range?  --> can't do permissions until metadb?
 * ? custom fields (need to add) -> users_groups:user_custom_fields (or start again with user_users and unpack data/customFields)
 * ? patron address [REP-216] - which one? -> users_addresses, or pull entire user_users:data/personal/addresses object 
 * ? patron department [REP-216] (need to add)  - which one? -> users_departments, but group by and collapse names?
 * patron status date ??  --> use history to find exactly when status changed? is this just active status? when block is added?
 * created date -> users_groups:created_date
 * GuestID (located in address field) [REP-225]
 * address type [REP-225]
 * 
 * 
 * Filters needed:
 * patron type (group)
 * activity date
 * email is blank [REP-218]
 * mailing address is blank [REP-218]
 * patron status (e.g., Active)
 * status date (e.g., created >= x) [REP-222]
 * "permission set" [REP-223]
 * */

WITH user_notes AS (
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
user_depts AS (
    SELECT
        user_id,
        string_agg(DISTINCT department_name, '|') AS depts_list
    FROM
        folio_reporting.users_departments_unpacked 
    GROUP BY
        user_id
)
SELECT
    ug.user_id,
    ug.barcode,
    ug.user_last_name, 
    ug.user_first_name, 
    ug.user_middle_name, 
    ug.user_preferred_first_name,
    ug.user_email,
    ug.group_name,
    un.notes_list AS user_notes,
    ug.expiration_date,
    ug.updated_date,
    ug.active,
    mb.code AS block_code,
    mb.expiration_date AS block_expiration_date,
    mb.borrowing AS block_borrowing_yn,
    mb.renewals AS block_renewals_yn,
    mb.requests AS block_requests_yn,
    json_extract_path_text(mb.data, 'metadata', 'createdDate') AS block_created_date,
    ug.external_system_id,
    ug.username,
    json_extract_path_text(uu.data, 'customFields') AS user_custom_fields,
    json_extract_path_text(uu.data, 'personal', 'addresses') AS user_addresses,
    ud.depts_list
 FROM
    folio_reporting.users_groups AS ug
    LEFT JOIN user_notes AS un ON ug.user_id = un.user_id
    LEFT JOIN public.user_users AS uu ON ug.user_id = uu.id
    LEFT JOIN user_depts AS ud ON ug.user_id = ud.user_id
    LEFT JOIN public.feesfines_manualblocks AS mb ON ug.user_id = mb.user_id
;
