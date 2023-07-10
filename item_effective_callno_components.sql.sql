--metadb:table item_effective_callno_components.sql
-- Create derived table for item_effective_callno_components
DROP TABLE IF EXISTS item_effective_callno_components;

CREATE TABLE item_effective_callno_components AS
SELECT
    items.id AS item_id,
    jsonb_extract_path_text(items.jsonb, 'hrid') AS item_hrid,
    jsonb_extract_path_text(items.jsonb,'effectiveCallNumberComponents','prefix') AS item_effective_call_number_prefix,
    jsonb_extract_path_text(items.jsonb,'effectiveCallNumberComponents','callNumber') AS item_effective_call_number,
    jsonb_extract_path_text(items.jsonb,'effectiveCallNumberComponents','suffix') AS item_effective_call_number_suffix,
    jsonb_extract_path_text(items.jsonb,'effectiveCallNumberComponents','typeId')::uuid AS item_effective_call_number_type_id,
    jsonb_extract_path_text(cnt.jsonb, 'name') AS item_effective_call_number_type_name
FROM
    folio_inventory.item__ AS items
    LEFT JOIN folio_inventory.call_number_type__ AS cnt ON 
    (jsonb_extract_path_text(items.jsonb, 'effectiveCallNumberComponents', 'typeId'))::uuid 
            = cnt.id;
      
COMMENT ON COLUMN item_effective_callno_components.item_id IS 'UUID of the item record';

COMMENT ON COLUMN item_effective_callno_components.item_hrid IS 'Human readable ID of the item record';

COMMENT ON COLUMN item_effective_callno_components.item_effective_call_number_prefix IS 'Effective Call Number Prefix is the prefix of the identifier assigned to an item or its holding and associated with the item';

COMMENT ON COLUMN item_effective_callno_components.item_effective_call_number IS 'Effective Call Number of the item record, is an identifier assigned to the item record';

COMMENT ON COLUMN item_effective_callno_components.item_effective_call_number_suffix IS 'Effective Call Number Suffix is the suffix of the identifier assigned to an item or its holding and associated with the item';

COMMENT ON COLUMN item_effective_callno_components.item_effective_call_number_type_id IS 'UUID of the source of the call number';

COMMENT ON COLUMN item_effective_callno_components.item_effective_call_number_type_name IS 'Name of the source of the call number, e.g., LCC, Dewey, NLM, etc.';
