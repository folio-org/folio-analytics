DROP TABLE IF EXISTS users_departments_unpacked;

-- Create a derived table that takes the user_users table and joins
-- in the group information
CREATE TABLE users_departments_unpacked AS
WITH departments_array AS (
    SELECT
        uu.id AS user_id,
        departments.data #>> '{}' AS department_id,
        departments.ordinality AS department_ordinality
    FROM
        user_users AS uu
        CROSS JOIN LATERAL json_array_elements(json_extract_path(data, 'departments'))
        WITH ORDINALITY AS departments (data)
)
SELECT
    departments_array.user_id,
    departments_array.department_id,
    departments_array.department_ordinality,
    json_extract_path_text(data, 'name') AS department_name,
    json_extract_path_text(data, 'code') AS department_code,
    json_extract_path_text(data, 'usageNumber') AS department_usage_number
FROM
    departments_array
LEFT JOIN user_departments AS ud
    ON departments_array.department_id = ud.id
;

