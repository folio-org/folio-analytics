DROP TABLE IF EXISTS po_pieces;

CREATE TABLE po_pieces AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'displayOnHolding')::boolean AS display_on_holding,
    jsonb_extract_path_text(jsonb, 'format')::varchar(65535) AS format,
    jsonb_extract_path_text(jsonb, 'itemId')::varchar(36) AS item_id,
    jsonb_extract_path_text(jsonb, 'locationId')::varchar(36) AS location_id,
    jsonb_extract_path_text(jsonb, 'poLineId')::varchar(36) AS po_line_id,
    jsonb_extract_path_text(jsonb, 'receivedDate')::timestamptz AS received_date,
    jsonb_extract_path_text(jsonb, 'receivingStatus')::varchar(65535) AS receiving_status,
    jsonb_extract_path_text(jsonb, 'titleId')::varchar(36) AS title_id,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_orders.pieces;

