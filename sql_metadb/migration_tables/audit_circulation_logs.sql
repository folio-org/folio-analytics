DROP TABLE IF EXISTS audit_circulation_logs;

CREATE TABLE audit_circulation_logs AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'action')::varchar(65535) AS action,
    jsonb_extract_path_text(jsonb, 'date')::timestamptz AS date,
    jsonb_extract_path_text(jsonb, 'description')::varchar(65535) AS description,
    jsonb_extract_path_text(jsonb, 'object')::varchar(65535) AS object,
    jsonb_extract_path_text(jsonb, 'servicePointId')::varchar(36) AS service_point_id,
    jsonb_extract_path_text(jsonb, 'source')::varchar(65535) AS source,
    jsonb_extract_path_text(jsonb, 'userBarcode')::varchar(65535) AS user_barcode,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_audit.circulation_logs;

ALTER TABLE audit_circulation_logs ADD PRIMARY KEY (id);

CREATE INDEX ON audit_circulation_logs (action);

CREATE INDEX ON audit_circulation_logs (date);

CREATE INDEX ON audit_circulation_logs (description);

CREATE INDEX ON audit_circulation_logs (object);

CREATE INDEX ON audit_circulation_logs (service_point_id);

CREATE INDEX ON audit_circulation_logs (source);

CREATE INDEX ON audit_circulation_logs (user_barcode);

