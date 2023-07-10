DROP TABLE IF EXISTS inventory_holdings;

CREATE TABLE inventory_holdings AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, '_version')::bigint AS _version,
    jsonb_extract_path_text(jsonb, 'acquisitionMethod')::varchar(65535) AS acquisition_method,
    jsonb_extract_path_text(jsonb, 'callNumber')::varchar(65535) AS call_number,
    jsonb_extract_path_text(jsonb, 'callNumberPrefix')::varchar(65535) AS call_number_prefix,
    jsonb_extract_path_text(jsonb, 'callNumberTypeId')::varchar(36) AS call_number_type_id,
    jsonb_extract_path_text(jsonb, 'copyNumber')::varchar(65535) AS copy_number,
    jsonb_extract_path_text(jsonb, 'effectiveLocationId')::varchar(36) AS effective_location_id,
    jsonb_extract_path_text(jsonb, 'holdingsTypeId')::varchar(36) AS holdings_type_id,
    jsonb_extract_path_text(jsonb, 'hrid')::varchar(65535) AS hrid,
    jsonb_extract_path_text(jsonb, 'illPolicyId')::varchar(36) AS ill_policy_id,
    jsonb_extract_path_text(jsonb, 'instanceId')::varchar(36) AS instance_id,
    jsonb_extract_path_text(jsonb, 'permanentLocationId')::varchar(36) AS permanent_location_id,
    jsonb_extract_path_text(jsonb, 'receiptStatus')::varchar(65535) AS receipt_status,
    jsonb_extract_path_text(jsonb, 'retentionPolicy')::varchar(65535) AS retention_policy,
    jsonb_extract_path_text(jsonb, 'shelvingTitle')::varchar(65535) AS shelving_title,
    jsonb_extract_path_text(jsonb, 'sourceId')::varchar(36) AS source_id,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_inventory.holdings_record;

