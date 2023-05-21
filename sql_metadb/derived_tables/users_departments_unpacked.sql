--metadb:table users_departments_unpacked
--metadb:require folio_users.departments__t.id uuid
--metadb:require folio_users.departments__t.code text
--metadb:require folio_users.departments__t.name text

DROP TABLE IF EXISTS users_departments_unpacked;

-- Create a derived table that takes the users table and joins
-- in the department information
CREATE TABLE users_departments_unpacked AS
WITH departments_array AS (
    SELECT
        uu.id AS user_id,
        departments.jsonb #>> '{}' AS department_id,
        departments.ordinality AS department_ordinality
    FROM
        folio_users.users AS uu
        CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(jsonb, 'departments'))
            WITH ORDINALITY AS departments (jsonb)
)
SELECT
    departments_array.user_id,
    departments_array.department_id::uuid,
    departments_array.department_ordinality,
    ud.name AS department_name,
    ud.code AS department_code
FROM
    departments_array
    LEFT JOIN folio_users.departments__t AS ud
        ON departments_array.department_id::uuid = ud.id;

CREATE INDEX ON users_departments_unpacked (user_id);

CREATE INDEX ON users_departments_unpacked (department_id);

-- If a user has more than one department, ordinality should show a
-- sequence of numbers indicating the order of the departments in the
-- original list
CREATE INDEX ON users_departments_unpacked (department_ordinality);

CREATE INDEX ON users_departments_unpacked (department_name);

CREATE INDEX ON users_departments_unpacked (department_code);

COMMENT ON COLUMN users_departments_unpacked.user_id IS 'User ID (Generated UUID) of the user associated with the department(s)';

COMMENT ON COLUMN users_departments_unpacked.department_id IS 'Department ID (Generated UUID) of the department';

COMMENT ON COLUMN users_departments_unpacked.department_ordinality IS 'The ordinality of the department(s) associated with a user';

COMMENT ON COLUMN users_departments_unpacked.department_name IS 'The display name of the department';

COMMENT ON COLUMN users_departments_unpacked.department_code IS 'The (user-supplied) code for the department';

