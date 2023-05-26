DROP TABLE IF EXISTS po_alerts;

CREATE TABLE po_alerts AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'alert')::varchar(65535) AS alert,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_orders.alert;

