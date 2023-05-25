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
DROP TABLE IF EXISTS items_holdings_instances;

CREATE TABLE items_holdings_instances AS 
SELECT
    ii.id AS item_id,
    ii.barcode,
    ii.chronology,
    ii.copy_number AS item_copy_number,
    ii.enumeration,
    ii.hrid AS item_hrid,
    ii.item_identifier,
    ii.item_level_call_number,
    ih.call_number_type_id,
    icnt.name AS call_number_type_name,
    ii.material_type_id,
    imt.name AS material_type_name,
    ii.number_of_pieces,
    ih.id AS holdings_id,
    ih.hrid AS holdings_hrid,
    ih.call_number as holdings_call_number,
    ii.effective_call_number_components__call_number AS item_effective_call_number,
    ii.effective_call_number_components__prefix AS item_effective_call_number_prefix,
    ii.effective_call_number_components__suffix AS item_effective_call_number_suffix,
    ih.acquisition_method,
    ih.copy_number AS holdings_copy_number,
    ih.holdings_type_id,
    iht.name AS holdings_type_name,
    ih.instance_id,
    ih.hrid AS instance_hrid,
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
    LEFT JOIN inventory_holdings_types AS iht ON ih.holdings_type_id = iht.id
    LEFT JOIN inventory_call_number_types AS icnt ON ih.call_number_type_id = icnt.id;

CREATE INDEX ON items_holdings_instances (item_id);

CREATE INDEX ON items_holdings_instances (barcode);

CREATE INDEX ON items_holdings_instances (chronology);

CREATE INDEX ON items_holdings_instances (item_copy_number);

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

CREATE INDEX ON items_holdings_instances (holdings_hrid);

CREATE INDEX ON items_holdings_instances (holdings_call_number);

CREATE INDEX ON items_holdings_instances (item_effective_call_number);

CREATE INDEX ON items_holdings_instances (item_effective_call_number_prefix);

CREATE INDEX ON items_holdings_instances (item_effective_call_number_suffix);

CREATE INDEX ON items_holdings_instances (acquisition_method);

CREATE INDEX ON items_holdings_instances (holdings_copy_number);

CREATE INDEX ON items_holdings_instances (holdings_type_id);

CREATE INDEX ON items_holdings_instances (holdings_type_name);

CREATE INDEX ON items_holdings_instances (instance_id);

CREATE INDEX ON items_holdings_instances (instance_hrid);

CREATE INDEX ON items_holdings_instances (shelving_title);

CREATE INDEX ON items_holdings_instances (cataloged_date);

CREATE INDEX ON items_holdings_instances (index_title);

CREATE INDEX ON items_holdings_instances (title);

CREATE INDEX ON items_holdings_instances (loan_type_id);

CREATE INDEX ON items_holdings_instances (loan_type_name);


VACUUM ANALYZE items_holdings_instances;

COMMENT ON COLUMN items_holdings_instances.item_id IS 'UUID of the item record';

COMMENT ON COLUMN items_holdings_instances.barcode IS 'Unique inventory control number for physical resources';

COMMENT ON COLUMN items_holdings_instances.chronology IS 'Chronology is the descriptive information for the dating scheme of a serial';

COMMENT ON COLUMN items_holdings_instances.item_copy_number IS 'Piece identifier. The copy number reflects if the library has a copy of a single-volume monograph';

COMMENT ON COLUMN items_holdings_instances.enumeration IS 'Descriptive information for the numbering scheme of a serial';

COMMENT ON COLUMN items_holdings_instances.item_hrid IS 'Human readable ID of the item record';

COMMENT ON COLUMN items_holdings_instances.item_identifier IS 'Item identifier number';

COMMENT ON COLUMN items_holdings_instances.item_level_call_number IS 'The Item level call number';

COMMENT ON COLUMN items_holdings_instances.call_number_type_id IS 'UUID of the source of the call number';

COMMENT ON COLUMN items_holdings_instances.call_number_type_name IS 'Name of the source of the call number, e.g., LCC, Dewey, NLM, etc.';

COMMENT ON COLUMN items_holdings_instances.material_type_id IS 'UUID of the Item''s material type';

COMMENT ON COLUMN items_holdings_instances.material_type_name IS 'Item''s material type name';

COMMENT ON COLUMN items_holdings_instances.number_of_pieces IS 'Number of pieces on the item record';

COMMENT ON COLUMN items_holdings_instances.holdings_id IS 'UUID of the holdings record associated with the item record';

COMMENT ON COLUMN items_holdings_instances.holdings_hrid IS 'Human readable ID of the holdings record associated with the item record';

COMMENT ON COLUMN items_holdings_instances.holdings_call_number IS 'Call Number on the holding record, is an identifier assigned to an item, usually printed on a label attached to the item';

COMMENT ON COLUMN items_holdings_instances.item_effective_call_number IS 'Effective Call Number of the item record, is an identifier assigned to the item record';

COMMENT ON COLUMN items_holdings_instances.item_effective_call_number_prefix IS 'Effective Call Number Prefix is the prefix of the identifier assigned to an item or its holding and associated with the item';

COMMENT ON COLUMN items_holdings_instances.item_effective_call_number_suffix IS 'Effective Call Number Suffix is the suffix of the identifier assigned to an item or its holding and associated with the item';

COMMENT ON COLUMN items_holdings_instances.acquisition_method IS 'Method of holdings record acquisition';

COMMENT ON COLUMN items_holdings_instances.holdings_copy_number IS 'Item/Piece ID (usually barcode) for systems that do not use item records. Ability to designate the copy number if institution chooses to use copy numbers';

COMMENT ON COLUMN items_holdings_instances.holdings_type_id IS 'UUID of the type of this holdings record';

COMMENT ON COLUMN items_holdings_instances.holdings_type_name IS 'Name of the holdings type';

COMMENT ON COLUMN items_holdings_instances.instance_id IS 'UUID of the instance record';

COMMENT ON COLUMN items_holdings_instances.instance_hrid IS 'Inventory instances identifier';

COMMENT ON COLUMN items_holdings_instances.shelving_title IS 'Indicates the shelving form of title';

COMMENT ON COLUMN items_holdings_instances.cataloged_date IS 'Date or timestamp on an instance for when it was considered cataloged';

COMMENT ON COLUMN items_holdings_instances.index_title IS 'Title normalized for browsing and searching; based on the title with articles removed';

COMMENT ON COLUMN items_holdings_instances.title IS 'The primary title (or label) associated with the resource';

COMMENT ON COLUMN items_holdings_instances.loan_type_id IS 'UUID of the loan type';

COMMENT ON COLUMN items_holdings_instances.loan_type_name IS 'Name of the loan type';
