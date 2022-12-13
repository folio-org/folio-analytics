DROP TABLE IF EXISTS inventory_items;

CREATE TABLE inventory_items AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, '_version')::bigint AS _version,
    jsonb_extract_path_text(jsonb, 'barcode')::varchar(65535) AS barcode,
    jsonb_extract_path_text(jsonb, 'chronology')::varchar(65535) AS chronology,
    jsonb_extract_path_text(jsonb, 'copyNumber')::varchar(65535) AS copy_number,
    jsonb_extract_path_text(jsonb, 'descriptionOfPieces')::varchar(65535) AS description_of_pieces,
    jsonb_extract_path_text(jsonb, 'discoverySuppress')::boolean AS discovery_suppress,
    jsonb_extract_path_text(jsonb, 'effectiveLocationId')::varchar(36) AS effective_location_id,
    jsonb_extract_path_text(jsonb, 'effectiveShelvingOrder')::varchar(65535) AS effective_shelving_order,
    jsonb_extract_path_text(jsonb, 'enumeration')::varchar(65535) AS enumeration,
    jsonb_extract_path_text(jsonb, 'holdingsRecordId')::varchar(36) AS holdings_record_id,
    jsonb_extract_path_text(jsonb, 'hrid')::varchar(65535) AS hrid,
    jsonb_extract_path_text(jsonb, 'inTransitDestinationServicePointId')::varchar(36) AS in_transit_destination_service_point_id,
    jsonb_extract_path_text(jsonb, 'itemLevelCallNumber')::varchar(65535) AS item_level_call_number,
    jsonb_extract_path_text(jsonb, 'itemLevelCallNumberPrefix')::varchar(65535) AS item_level_call_number_prefix,
    jsonb_extract_path_text(jsonb, 'itemLevelCallNumberTypeId')::varchar(36) AS item_level_call_number_type_id,
    jsonb_extract_path_text(jsonb, 'materialTypeId')::varchar(36) AS material_type_id,
    jsonb_extract_path_text(jsonb, 'numberOfPieces')::varchar(65535) AS number_of_pieces,
    jsonb_extract_path_text(jsonb, 'permanentLoanTypeId')::varchar(36) AS permanent_loan_type_id,
    jsonb_extract_path_text(jsonb, 'permanentLocationId')::varchar(36) AS permanent_location_id,
    jsonb_extract_path_text(jsonb, 'purchaseOrderLineIdentifier')::varchar(36) AS purchase_order_line_identifier,
    jsonb_extract_path_text(jsonb, 'temporaryLoanTypeId')::varchar(36) AS temporary_loan_type_id,
    jsonb_extract_path_text(jsonb, 'temporaryLocationId')::varchar(36) AS temporary_location_id,
    jsonb_extract_path_text(jsonb, 'volume')::varchar(65535) AS volume,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_inventory.item;

ALTER TABLE inventory_items ADD PRIMARY KEY (id);

CREATE INDEX ON inventory_items (_version);

CREATE INDEX ON inventory_items (barcode);

CREATE INDEX ON inventory_items (chronology);

CREATE INDEX ON inventory_items (copy_number);

CREATE INDEX ON inventory_items (discovery_suppress);

CREATE INDEX ON inventory_items (effective_location_id);

CREATE INDEX ON inventory_items (effective_shelving_order);

CREATE INDEX ON inventory_items (enumeration);

CREATE INDEX ON inventory_items (holdings_record_id);

CREATE INDEX ON inventory_items (hrid);

CREATE INDEX ON inventory_items (in_transit_destination_service_point_id);

CREATE INDEX ON inventory_items (item_level_call_number);

CREATE INDEX ON inventory_items (item_level_call_number_prefix);

CREATE INDEX ON inventory_items (item_level_call_number_type_id);

CREATE INDEX ON inventory_items (material_type_id);

CREATE INDEX ON inventory_items (number_of_pieces);

CREATE INDEX ON inventory_items (permanent_loan_type_id);

CREATE INDEX ON inventory_items (permanent_location_id);

CREATE INDEX ON inventory_items (purchase_order_line_identifier);

CREATE INDEX ON inventory_items (temporary_loan_type_id);

CREATE INDEX ON inventory_items (temporary_location_id);

CREATE INDEX ON inventory_items (volume);

VACUUM ANALYZE inventory_items;
