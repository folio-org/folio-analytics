--metadb:table users_groups
--metadb:require folio_users.users__t.enrollment_date timestamptz
--metadb:require folio_users.users__t.external_system_id text
--metadb:require folio_users.users__t.type text

-- Create a derived table that takes the users table and joins in the
-- group information.  Does not include addresses - see additional
-- derived tables for addresses in different arrangements.  Query also
-- depends on separate derived table users_departments_unpacked.

DROP TABLE IF EXISTS users_groups;

CREATE TABLE users_groups AS
WITH user_departments AS (
    SELECT
        user_id,
        string_agg(DISTINCT department_id::text, '|') AS departments
    FROM
        users_departments_unpacked
    GROUP BY
        user_id
)
SELECT
    users.id AS user_id,
    u.active,
    u.barcode,
    -- Top-level created_date field is marked deprecated, extracting from metadata object in case top-level field is removed
    jsonb_extract_path_text(users.jsonb, 'metadata', 'createdDate')::timestamptz AS created_date,
    u.enrollment_date,
    u.expiration_date,
    u.external_system_id,
    u.patron_group,
    g.desc AS group_description,
    g.group AS group_name,
    user_departments.departments AS departments,
    jsonb_extract_path_text(users.jsonb, 'personal', 'lastName') AS user_last_name,
    jsonb_extract_path_text(users.jsonb, 'personal', 'firstName') AS user_first_name,
    jsonb_extract_path_text(users.jsonb, 'personal', 'middleName') AS user_middle_name,
    jsonb_extract_path_text(users.jsonb, 'personal', 'preferredFirstName') AS user_preferred_first_name,
    jsonb_extract_path_text(users.jsonb, 'personal', 'email') AS user_email,
    jsonb_extract_path_text(users.jsonb, 'personal', 'phone') AS user_phone,
    jsonb_extract_path_text(users.jsonb, 'personal', 'mobilePhone') AS user_mobile_phone,
    jsonb_extract_path_text(users.jsonb, 'personal', 'dateOfBirth')::date AS user_date_of_birth,
    jsonb_extract_path_text(users.jsonb, 'personal', 'preferredContactTypeId') AS user_preferred_contact_type_id,
    u.type AS user_type,
    -- Top-level updated_date field is marked deprecated, extracting from metadata object in case top-level field is removed
    jsonb_extract_path_text(users.jsonb, 'metadata', 'updatedDate')::timestamptz AS updated_date,
    u.username
FROM
    folio_users.users
    LEFT JOIN folio_users.users__t AS u ON users.id = u.id  
    LEFT JOIN folio_users.groups__t AS g ON u.patron_group = g.id
    LEFT JOIN user_departments ON users.id = user_departments.user_id;

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

