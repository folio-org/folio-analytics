--metadb:table items_holdings_instances
--metadb:require folio_inventory.holdings_record__t.acquisition_method text
--metadb:require folio_inventory.holdings_record__t.copy_number text
--metadb:require folio_inventory.holdings_record__t.holdings_type_id uuid
--metadb:require folio_inventory.holdings_record__t.shelving_title text
--metadb:require folio_inventory.item__t.chronology text
--metadb:require folio_inventory.item__t.copy_number text
--metadb:require folio_inventory.item__t.enumeration text
--metadb:require folio_inventory.item__t.item_identifier text
--metadb:require folio_inventory.item__t.number_of_pieces text
--metadb:require folio_inventory.item__t.volume text

-- Create an extended items table that includes holdings and instances
-- information such as call number, material type, title, etc.

DROP TABLE IF EXISTS items_holdings_instances;

CREATE TABLE items_holdings_instances AS
SELECT
    i.id AS item_id,
    i.barcode,
    i.copy_number AS item_copy_number,
    i.chronology,
    i.enumeration,
    i.volume,
    i.hrid AS item_hrid,
    i.item_identifier,
    i.item_level_call_number,
    holdings.call_number_type_id,
    calltype.name AS call_number_type_name,
    i.material_type_id,
    mattype.name AS material_type_name,
    i.number_of_pieces,
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
    folio_inventory.item__t AS i
    LEFT JOIN folio_inventory.holdings_record__t AS holdings ON i.holdings_record_id = holdings.id
    LEFT JOIN folio_inventory.instance__t AS instance ON holdings.instance_id = instance.id
    LEFT JOIN folio_inventory.loan_type__t AS loantype ON i.permanent_loan_type_id = loantype.id
    LEFT JOIN folio_inventory.material_type__t AS mattype ON i.material_type_id = mattype.id
    LEFT JOIN folio_inventory.holdings_type__t AS holdtype ON holdings.holdings_type_id = holdtype.id
    LEFT JOIN folio_inventory.call_number_type__t AS calltype ON holdings.call_number_type_id = calltype.id;
