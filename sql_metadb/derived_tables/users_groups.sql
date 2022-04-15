DROP TABLE IF EXISTS users_groups;

-- Create a derived table that takes the users table and joins in
-- the group information.  Does not include addresses - see additional
-- derived tables for addresses in different arrangements.  Query also
-- depends on separate derived table users_departments_unpacked 
CREATE TABLE users_groups AS
WITH user_departments AS (
    SELECT
        user_id,
        string_agg(DISTINCT department_id::varchar(36), '|'::text) AS departments
    FROM
        users_departments_unpacked
    GROUP BY
        user_id
)
SELECT
    uu.id AS user_id,
    ut.active,
    ut.barcode,
    -- Top-level created_date field is marked deprecated, extracting from metadata object in case top-level field is removed
    jsonb_extract_path_text(uu.jsonb, 'metadata', 'createdDate')::timestamptz AS created_date,
    ut.enrollment_date,
    ut.expiration_date,
    ut.external_system_id,
    ut.patron_group,
    ug.desc AS group_description,
    ug.group AS group_name,
    ud.departments AS departments,
    jsonb_extract_path_text(uu.jsonb, 'personal', 'lastName') AS user_last_name,
    jsonb_extract_path_text(uu.jsonb, 'personal', 'firstName') AS user_first_name,
    jsonb_extract_path_text(uu.jsonb, 'personal', 'middleName') AS user_middle_name,
    jsonb_extract_path_text(uu.jsonb, 'personal', 'preferredFirstName') AS user_preferred_first_name,
    jsonb_extract_path_text(uu.jsonb, 'personal', 'email') AS user_email,
    jsonb_extract_path_text(uu.jsonb, 'personal', 'phone') AS user_phone,
    jsonb_extract_path_text(uu.jsonb, 'personal', 'mobilePhone') AS user_mobile_phone,
    jsonb_extract_path_text(uu.jsonb, 'personal', 'dateOfBirth')::date AS user_date_of_birth,
    jsonb_extract_path_text(uu.jsonb, 'personal', 'preferredContactTypeId') AS user_preferred_contact_type_id,
    ut.type AS user_type,
    -- Top-level updated_date field is marked deprecated, extracting from metadata object in case top-level field is removed
    jsonb_extract_path_text(uu.jsonb, 'metadata', 'updatedDate')::timestamptz AS updated_date,
    ut.username,
    jsonb_extract_path_text(uu.jsonb, 'tags') AS user_tags,
    jsonb_extract_path_text(uu.jsonb, 'customFields') AS user_custom_fields
FROM
    folio_users.users AS uu
    LEFT JOIN folio_users.users__t AS ut ON uu.id = ut.id  
    LEFT JOIN folio_users.groups__t AS ug ON ut.patron_group = ug.id
    LEFT JOIN user_departments AS ud ON uu.id = ud.user_id;

CREATE INDEX ON users_groups (user_id);

CREATE INDEX ON users_groups (active);

CREATE INDEX ON users_groups (barcode);

CREATE INDEX ON users_groups (created_date);

CREATE INDEX ON users_groups (enrollment_date);

CREATE INDEX ON users_groups (expiration_date);

CREATE INDEX ON users_groups (external_system_id);

CREATE INDEX ON users_groups (patron_group);

CREATE INDEX ON users_groups (group_description);

CREATE INDEX ON users_groups (group_name);

CREATE INDEX ON users_groups (departments);

CREATE INDEX ON users_groups (user_last_name);

CREATE INDEX ON users_groups (user_first_name);

CREATE INDEX ON users_groups (user_middle_name);

CREATE INDEX ON users_groups (user_preferred_first_name);

CREATE INDEX ON users_groups (user_email);

CREATE INDEX ON users_groups (user_phone);

CREATE INDEX ON users_groups (user_mobile_phone);

CREATE INDEX ON users_groups (user_date_of_birth);

CREATE INDEX ON users_groups (user_preferred_contact_type_id);

CREATE INDEX ON users_groups (user_type);

CREATE INDEX ON users_groups (updated_date);

CREATE INDEX ON users_groups (username);

CREATE INDEX ON users_groups (user_tags);

CREATE INDEX ON users_groups (user_custom_fields);

COMMENT ON COLUMN users_groups.user_id IS 'A globally unique (UUID) identifier for the user';

COMMENT ON COLUMN users_groups.active IS 'A flag to determine if the users account is effective and not expired. The tenant configuration can require the user to be active for login. Active is different from the loan patron block';

COMMENT ON COLUMN users_groups.barcode IS 'The unique library barcode for this user';

COMMENT ON COLUMN users_groups.created_date IS 'Date and time when the user record was created';

COMMENT ON COLUMN users_groups.enrollment_date IS 'The date when the user joined the organization';

COMMENT ON COLUMN users_groups.expiration_date IS 'The date when the user will become inactive';

COMMENT ON COLUMN users_groups.external_system_id IS 'A unique ID that corresponds to an external authority';

COMMENT ON COLUMN users_groups.patron_group IS 'A UUID corresponding to the group the user belongs to, example groups are undergraduate and faculty; loan rules, patron blocks, fees/fines and expiration days can use the patron group';

COMMENT ON COLUMN users_groups.group_description IS 'A description for the user group';

COMMENT ON COLUMN users_groups.group_name IS 'The unique name of the user group';

COMMENT ON COLUMN users_groups.departments IS 'A list of UUIDs corresponding to the departments the user belongs to';

COMMENT ON COLUMN users_groups.user_last_name IS 'The users surname';

COMMENT ON COLUMN users_groups.user_first_name IS 'The users given name';

COMMENT ON COLUMN users_groups.user_middle_name IS 'The users middle name (if any)';

COMMENT ON COLUMN users_groups.user_preferred_first_name IS 'The users preferred name';

COMMENT ON COLUMN users_groups.user_email IS 'The users email address';

COMMENT ON COLUMN users_groups.user_phone IS 'The users primary phone number';

COMMENT ON COLUMN users_groups.user_mobile_phone IS 'The users mobile phone number';

COMMENT ON COLUMN users_groups.user_date_of_birth IS 'The users birth date';

COMMENT ON COLUMN users_groups.user_preferred_contact_type_id IS 'ID of users preferred contact type like Email, Mail or Text Message';

COMMENT ON COLUMN users_groups.user_type IS 'The class of the user, like staff or patron; this is different from patronGroup';

COMMENT ON COLUMN users_groups.updated_date IS 'Date and time when the user record was last updated';

COMMENT ON COLUMN users_groups.username IS 'A unique name belonging to a user. Typically used for login';

COMMENT ON COLUMN users_groups.user_tags IS 'Tags associated with the user record';

COMMENT ON COLUMN users_groups.user_custom_fields IS 'Custom fields associated with the user record';

VACUUM ANALYZE  users_groups;
