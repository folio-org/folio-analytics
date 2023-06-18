DROP TABLE IF EXISTS users_groups;

-- Create a derived table that takes the user_users table and joins in
-- the group information.  Does not include addresses - see additional
-- derived tables for addresses in different arrangements.  Query also
-- depends on separate derived table for user departments
CREATE TABLE users_groups AS
WITH user_departments AS (
    SELECT
        user_id,
        --string_agg(DISTINCT department_name, '|'::text) AS departments
        string_agg(DISTINCT department_id, '|'::text) AS departments
    FROM
        users_departments_unpacked
    GROUP BY
        user_id
)
SELECT
    uu.id AS user_id,
    uu.active,
    uu.barcode,
    (uu.data #>> '{metadata,createdDate}')::timestamptz AS created_date,
    uu.enrollment_date,
    uu.expiration_date,
    (uu.data #>> '{externalSystemId}')::uuid AS external_system_id,
    uu.patron_group,
    ug.desc AS group_description,
    ug.group AS group_name,
    ud.departments,
    uu.data #>> '{personal,lastName}' AS user_last_name,
    uu.data #>> '{personal,firstName}' AS user_first_name,
    uu.data #>> '{personal,middleName}' AS user_middle_name,
    uu.data #>> '{personal,preferredFirstName}' AS user_preferred_first_name,
    uu.data #>> '{personal,email}' AS user_email,
    uu.data #>> '{personal,phone}' AS user_phone,
    uu.data #>> '{personal,mobilePhone}' AS user_mobile_phone,
    (uu.data #>> '{personal,dateOfBirth}')::timestamptz AS user_date_of_birth,
    (uu.data #>> '{personal,preferredContactTypeId}')::uuid AS user_preferred_contact_type_id,
    uu.data #>> '{type}' AS user_type,
    (uu.data #>> '{metadata,updatedDate}')::timestamptz AS updated_date,
    uu.username,
    uu.data #>> '{tags}' AS user_tags,
    uu.data #>> '{customFields}' AS user_custom_fields
FROM
    user_users AS uu
    LEFT JOIN user_groups AS ug ON uu.patron_group = ug.id
    LEFT JOIN user_departments AS ud ON uu.id = ud.user_id;

