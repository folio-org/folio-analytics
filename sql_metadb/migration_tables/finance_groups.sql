DROP TABLE IF EXISTS finance_groups;

CREATE TABLE finance_groups AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'code')::varchar(65535) AS code,
    jsonb_extract_path_text(jsonb, 'description')::varchar(65535) AS description,
    jsonb_extract_path_text(jsonb, 'name')::varchar(65535) AS name,
    jsonb_extract_path_text(jsonb, 'status')::varchar(65535) AS status,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_finance.groups;

