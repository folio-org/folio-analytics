DROP TABLE IF EXISTS users_custom_fields;

-- Create a derived table that takes the user_users table and unpacks
-- the custom fields object into a table with one custom field per row
-- and potentially multiple rows per user
CREATE TABLE users_custom_fields AS
	WITH objects AS (
		SELECT 
			uu.id AS user_id,
			jsonb_extract_path(uu.jsonb, 'customFields') AS custom_fields_object
		FROM folio_users.users AS uu
		WHERE jsonb_extract_path(uu.jsonb, 'customFields') IS NOT NULL
	)
	SELECT 
		user_id, 
		key AS field_name, 
		value::varchar AS field_value
	FROM objects, jsonb_each(objects.custom_fields_object);

CREATE INDEX ON users_custom_fields (user_id);

CREATE INDEX ON users_custom_fields (field_name);

CREATE INDEX ON users_custom_fields (field_value);


VACUUM ANALYZE  users_custom_fields;
