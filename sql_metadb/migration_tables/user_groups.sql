DROP TABLE IF EXISTS user_groups;

CREATE TABLE user_groups AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'desc')::varchar(65535) AS desc,
    jsonb_extract_path_text(jsonb, 'expirationOffsetInDays')::bigint AS expiration_offset_in_days,
    jsonb_extract_path_text(jsonb, 'group')::varchar(65535) AS group,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_users.groups;

ALTER TABLE user_groups ADD PRIMARY KEY (id);

CREATE INDEX ON user_groups ("desc");

CREATE INDEX ON user_groups (expiration_offset_in_days);

CREATE INDEX ON user_groups ("group");

VACUUM ANALYZE user_groups;
