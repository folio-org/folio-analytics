DROP TABLE IF EXISTS configuration_entries;

CREATE TABLE configuration_entries AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'code')::varchar(65535) AS code,
    jsonb_extract_path_text(jsonb, 'configName')::varchar(65535) AS config_name,
    jsonb_extract_path_text(jsonb, 'default')::boolean AS default,
    jsonb_extract_path_text(jsonb, 'description')::varchar(65535) AS description,
    jsonb_extract_path_text(jsonb, 'enabled')::boolean AS enabled,
    jsonb_extract_path_text(jsonb, 'module')::varchar(65535) AS module,
    jsonb_extract_path_text(jsonb, 'userId')::varchar(36) AS user_id,
    jsonb_extract_path_text(jsonb, 'value')::varchar(65535) AS value,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_configuration.config_data;

ALTER TABLE configuration_entries ADD PRIMARY KEY (id);

CREATE INDEX ON configuration_entries (code);

CREATE INDEX ON configuration_entries (config_name);

CREATE INDEX ON configuration_entries ("default");

CREATE INDEX ON configuration_entries (description);

CREATE INDEX ON configuration_entries (enabled);

CREATE INDEX ON configuration_entries (module);

CREATE INDEX ON configuration_entries (user_id);

CREATE INDEX ON configuration_entries (value);

