DROP TABLE IF EXISTS local.users_departments_unpacked;

-- Create a derived table that takes the user_users table and joins
-- in the group information
CREATE TABLE local.users_departments_unpacked AS
WITH departments_array AS (
    SELECT
        uu.id AS user_id,
        json_array_elements_text(json_extract_path(uu.data, 'departments')) AS department_id
    FROM
        user_users AS uu
)
SELECT
    departments_array.user_id,
    departments_array.department_id --,
    --	ud.name AS department_name,
    --	ud.code AS department_code,
    --	ud.usage_number AS department_usage_number
FROM
    departments_array
    --LEFT JOIN user_departments AS ud
    --    ON departments_array.department_id = ud.id
;

CREATE INDEX ON local.users_departments_unpacked (user_id);

CREATE INDEX ON local.users_departments_unpacked (department_id);

--CREATE INDEX ON local.users_departments_unpacked (department_name);

--CREATE INDEX ON local.users_departments_unpacked (department_code);

--CREATE INDEX ON local.users_departments_unpacked (department_usage_number);

