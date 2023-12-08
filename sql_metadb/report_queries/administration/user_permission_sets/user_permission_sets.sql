WITH permissions_users AS (
    SELECT
        jsonb_array_elements_text(jsonb->'permissions') AS user_permissions,
        jsonb_extract_path_text(jsonb, 'userId')::uuid AS user_id
    FROM
        folio_permissions.permissions_users
)
SELECT
    permissions.id AS permission_id,
    jsonb_extract_path_text(permissions.jsonb, 'displayName') AS permission_name,
    jsonb_extract_path_text(permissions.jsonb, 'description') AS permission_description,
    users.id AS user_id,
    jsonb_extract_path_text(users.jsonb, 'personal', 'lastName') AS user_lastname,
    jsonb_extract_path_text(users.jsonb, 'personal', 'firstName') AS user_firstname,
    jsonb_extract_path_text(users.jsonb, 'barcode') AS user_barcode,
    jsonb_extract_path_text(users.jsonb, 'username') AS user_username,
    CASE WHEN jsonb_extract_path_text(users.jsonb, 'active')::boolean THEN 'active'
        ELSE 'inactive'
    END AS user_status,
    jsonb_extract_path_text(user_groups.jsonb, 'group') AS user_patron_group,
    jsonb_extract_path_text(users.jsonb, 'expirationDate') AS user_expiration_date
FROM
    folio_permissions.permissions AS permissions
    JOIN permissions_users ON permissions_users.user_permissions = permissions.id::varchar
    LEFT JOIN folio_users.users AS users ON users.id = permissions_users.user_id
    LEFT JOIN folio_users.groups AS user_groups ON user_groups.id = jsonb_extract_path_text(users.jsonb, 'patronGroup')::uuid
ORDER BY
    permission_name,
    permission_description,
    user_lastname;
