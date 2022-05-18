DROP TABLE IF EXISTS items_holdings_instances;

-- Create an extended items table that includes holdings and instances
-- information such as call number, material type, title, etc.

CREATE TABLE items_holdings_instances AS
SELECT
    ii.id AS item_id,
    ii.barcode,
    ii.copy_number AS item_copy_number,
    ii.chronology,
    ii.enumeration,
    ii.volume,
    ii.hrid AS item_hrid,
    ii.item_identifier,
    ii.item_level_call_number,
    ih.call_number_type_id,
    icnt.name AS call_number_type_name,
    ii.material_type_id,
    imt.name AS material_type_name,
    ii.number_of_pieces,
    ih.id AS holdings_id,
    ih.call_number,
    ih.acquisition_method,
    ih.copy_number AS holdings_copy_number,
    ih.holdings_type_id,
    iht.name AS holdings_type_name,
    ih.instance_id,
    ih.shelving_title,
    ii2.cataloged_date,
    ii2.index_title,
    ii2.title,
    ilt.id AS loan_type_id,
    ilt.name AS loan_type_name
FROM
    folio_inventory.item__t AS ii
    LEFT JOIN folio_inventory.holdings_record__t AS ih ON ii.holdings_record_id = ih.id
    LEFT JOIN folio_inventory.instance__t AS ii2 ON ih.instance_id = ii2.id
    LEFT JOIN folio_inventory.loan_type__t AS ilt ON ii.permanent_loan_type_id = ilt.id
    LEFT JOIN folio_inventory.material_type__t AS imt ON ii.material_type_id = imt.id
    LEFT JOIN folio_inventory.holdings_type__t AS iht ON ih.holdings_type_id = iht.id
    LEFT JOIN folio_inventory.call_number_type__t AS icnt ON ih.call_number_type_id = icnt.id;

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
