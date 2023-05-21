DROP TABLE IF EXISTS po_reporting_codes;

CREATE TABLE po_reporting_codes AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'code')::varchar(65535) AS code,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_orders.reporting_code;

ALTER TABLE po_reporting_codes ADD PRIMARY KEY (id);

CREATE INDEX ON po_reporting_codes (code);

