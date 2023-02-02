--metadb:table items_holdings_instances

-- Create an extended items table that includes holdings and instances
-- information such as call number, material type, title, etc.

DROP TABLE IF EXISTS items_holdings_instances;

CREATE TABLE items_holdings_instances AS
SELECT
    i.id AS item_id,
    i.barcode,
    jsonb_extract_path_text(item.jsonb, 'copyNumber') AS item_copy_number,
    jsonb_extract_path_text(item.jsonb, 'chronology') AS chronology,
    i.enumeration,
    jsonb_extract_path_text(item.jsonb, 'volume') AS volume,
    i.hrid AS item_hrid,
    jsonb_extract_path_text(item.jsonb, 'itemIdentifier') AS item_identifier,
    jsonb_extract_path_text(item.jsonb, 'itemLevelCallNumber') AS item_level_call_number,
    holdings.call_number_type_id,
    calltype.name AS call_number_type_name,
    i.material_type_id,
    mattype.name AS material_type_name,
    jsonb_extract_path_text(item.jsonb, 'numberOfPieces') AS number_of_pieces,
    holdings.id AS holdings_id,
    holdings.call_number,
    jsonb_extract_path_text(holdings_record.jsonb, 'acquisitionMethod') AS acquisition_method,
    jsonb_extract_path_text(holdings_record.jsonb, 'copyNumber') AS holdings_copy_number,
    jsonb_extract_path_text(holdings_record.jsonb, 'holdingsTypeId')::uuid AS holdings_type_id,
    holdtype.name AS holdings_type_name,
    holdings.instance_id,
    jsonb_extract_path_text(holdings_record.jsonb, 'shelvingTitle') AS shelving_title,
    instance.cataloged_date,
    instance.index_title,
    instance.title,
    loantype.id AS loan_type_id,
    loantype.name AS loan_type_name
FROM
    folio_inventory.item__t AS i
    LEFT JOIN folio_inventory.item ON i.id = item.id
    LEFT JOIN folio_inventory.holdings_record__t AS holdings ON i.holdings_record_id = holdings.id
    LEFT JOIN folio_inventory.holdings_record ON holdings.id = holdings_record.id
    LEFT JOIN folio_inventory.instance__t AS instance ON holdings.instance_id = instance.id
    LEFT JOIN folio_inventory.loan_type__t AS loantype ON i.permanent_loan_type_id = loantype.id
    LEFT JOIN folio_inventory.material_type__t AS mattype ON i.material_type_id = mattype.id
    LEFT JOIN folio_inventory.holdings_type__t AS holdtype ON jsonb_extract_path_text(holdings_record.jsonb, 'holdingsTypeId')::uuid = holdtype.id
    LEFT JOIN folio_inventory.call_number_type__t AS calltype ON holdings.call_number_type_id = calltype.id;

CREATE INDEX ON items_holdings_instances (item_id);

CREATE INDEX ON items_holdings_instances (barcode);

CREATE INDEX ON items_holdings_instances (item_copy_number);

CREATE INDEX ON items_holdings_instances (chronology);

CREATE INDEX ON items_holdings_instances (volume);

CREATE INDEX ON items_holdings_instances (enumeration);

CREATE INDEX ON items_holdings_instances (item_hrid);

CREATE INDEX ON items_holdings_instances (item_identifier);

CREATE INDEX ON items_holdings_instances (item_level_call_number);

CREATE INDEX ON items_holdings_instances (call_number_type_id);

CREATE INDEX ON items_holdings_instances (call_number_type_name);

CREATE INDEX ON items_holdings_instances (material_type_id);

CREATE INDEX ON items_holdings_instances (material_type_name);

CREATE INDEX ON items_holdings_instances (number_of_pieces);

CREATE INDEX ON items_holdings_instances (holdings_id);

CREATE INDEX ON items_holdings_instances (call_number);

CREATE INDEX ON items_holdings_instances (acquisition_method);

CREATE INDEX ON items_holdings_instances (holdings_copy_number);

CREATE INDEX ON items_holdings_instances (holdings_type_id);

CREATE INDEX ON items_holdings_instances (holdings_type_name);

CREATE INDEX ON items_holdings_instances (instance_id);

CREATE INDEX ON items_holdings_instances (shelving_title);

CREATE INDEX ON items_holdings_instances (cataloged_date);

CREATE INDEX ON items_holdings_instances (loan_type_id);

CREATE INDEX ON items_holdings_instances (loan_type_name);

VACUUM ANALYZE items_holdings_instances;
