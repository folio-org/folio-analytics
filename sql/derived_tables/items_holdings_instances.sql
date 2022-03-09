DROP TABLE IF EXISTS items_holdings_instances;

-- Create an extended items table that includes holdings and instances
-- information such as call number, material type, title, etc.
--
-- Tables included:
--     inventory_items
--     inventory_holdings
--     inventory_instances
--     inventory_loan_types
--     inventory_material_types
--     inventory_holdings_types
--     inventory_call_number_types
--
CREATE TABLE items_holdings_instances AS
SELECT
    ii.id AS item_id,
    ii.barcode,
    ii.chronology,
    ii.copy_number AS item_copy_number,
    ii.enumeration,
    ii.holdings_record_id,
    ii.hrid,
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
    inventory_items AS ii
    LEFT JOIN inventory_holdings AS ih ON ii.holdings_record_id = ih.id
    LEFT JOIN inventory_instances AS ii2 ON ih.instance_id = ii2.id
    LEFT JOIN inventory_loan_types AS ilt ON ii.permanent_loan_type_id = ilt.id
    LEFT JOIN inventory_material_types AS imt ON ii.material_type_id = imt.id
    LEFT JOIN inventory_holdings_types AS iht ON json_extract_path_text(ih.data, 'holdingsTypeId') = iht.id
    LEFT JOIN inventory_call_number_types AS icnt ON ih.call_number_type_id = icnt.id;

CREATE INDEX ON items_holdings_instances (item_id);

CREATE INDEX ON items_holdings_instances (barcode);

CREATE INDEX ON items_holdings_instances (chronology);

CREATE INDEX ON items_holdings_instances (item_copy_number);

CREATE INDEX ON items_holdings_instances (enumeration);

CREATE INDEX ON items_holdings_instances (holdings_record_id);

CREATE INDEX ON items_holdings_instances (hrid);

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

