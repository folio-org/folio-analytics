-- Create an extended items table that includes holdings and instances
-- information such as call number, material type, title, etc.

DROP TABLE IF EXISTS items_holdings_instances;

CREATE TABLE items_holdings_instances AS
SELECT
    item.id AS item_id,
    item.barcode,
    item.copy_number AS item_copy_number,
    item.chronology,
    item.enumeration,
    item.volume,
    item.hrid AS item_hrid,
    item.item_identifier,
    item.item_level_call_number,
    holdings.call_number_type_id,
    calltype.name AS call_number_type_name,
    item.material_type_id,
    mattype.name AS material_type_name,
    item.number_of_pieces,
    holdings.id AS holdings_id,
    holdings.call_number,
    holdings.acquisition_method,
    holdings.copy_number AS holdings_copy_number,
    holdings.holdings_type_id,
    holdtype.name AS holdings_type_name,
    holdings.instance_id,
    holdings.shelving_title,
    instance.cataloged_date,
    instance.index_title,
    instance.title,
    loantype.id AS loan_type_id,
    loantype.name AS loan_type_name
FROM
    folio_inventory.item__t AS item
    LEFT JOIN folio_inventory.holdings_record__t AS holdings ON item.holdings_record_id = holdings.id
    LEFT JOIN folio_inventory.instance__t AS instance ON holdings.instance_id = instance.id
    LEFT JOIN folio_inventory.loan_type__t AS loantype ON item.permanent_loan_type_id = loantype.id
    LEFT JOIN folio_inventory.material_type__t AS mattype ON item.material_type_id = mattype.id
    LEFT JOIN folio_inventory.holdings_type__t AS holdtype ON holdings.holdings_type_id = holdtype.id
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

CREATE INDEX ON items_holdings_instances (index_title);

CREATE INDEX ON items_holdings_instances (title);

CREATE INDEX ON items_holdings_instances (loan_type_id);

CREATE INDEX ON items_holdings_instances (loan_type_name);

VACUUM ANALYZE items_holdings_instances;
