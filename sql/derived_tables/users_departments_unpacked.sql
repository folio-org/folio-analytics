DROP TABLE IF EXISTS users_departments_unpacked;

-- Create a derived table that takes the user_users table and joins
-- in the group information
CREATE TABLE users_departments_unpacked AS
WITH departments_array AS (
    SELECT
        uu.id AS user_id,
        (departments.data #>> '{}')::uuid AS department_id,
        departments.ordinality AS department_ordinality
    FROM
        user_users AS uu
        CROSS JOIN LATERAL jsonb_array_elements((data #> '{departments}')::jsonb)
        WITH ORDINALITY AS departments (data)
)
SELECT
    departments_array.user_id,
    departments_array.department_id,
    departments_array.department_ordinality,
    data #>> '{name}' AS department_name,
    data #>> '{code}' AS department_code,
    data #>> '{usageNumber}' AS department_usage_number
FROM
    departments_array
    LEFT JOIN user_departments AS ud ON departments_array.department_id = ud.id::uuid;

