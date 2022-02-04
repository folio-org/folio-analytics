DROP TABLE IF EXISTS audit_circulation_logs;

CREATE TABLE audit_circulation_logs AS
SELECT
    id::varchar(36),
    (jsonb->>'action')::varchar AS action,
    (jsonb->>'date')::timestamptz AS date,
    (jsonb->>'description')::varchar AS description,
    (jsonb->>'object')::varchar AS object,
    (jsonb->>'servicePointId')::varchar(36) AS service_point_id,
    (jsonb->>'source')::varchar AS source,
    (jsonb->>'userBarcode')::varchar AS user_barcode,
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

VACUUM ANALYZE audit_circulation_logs;
