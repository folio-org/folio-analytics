-- Create table for item effective call number components

DROP TABLE IF EXISTS item_effective_callno_components;

CREATE TABLE item_effective_callno_components AS
SELECT
    items.id AS item_id,
    items.hrid AS item_hrid,
    json_extract_path_text(items.data, 'effectiveCallNumberComponents', 'prefix') AS effective_call_number_prefix,
    json_extract_path_text(items.data, 'effectiveCallNumberComponents','callNumber') AS effective_call_number,
    json_extract_path_text(items.data, 'effectiveCallNumberComponents', 'suffix') AS effective_call_number_suffix,
    json_extract_path_text(items.data, 'effectiveCallNumberComponents', 'typeID') AS effective_call_number_type_id,
    inventory_call_number_types.name AS effective_call_number_type_name
FROM
    inventory_items AS items
    LEFT JOIN inventory_call_number_types ON json_extract_path_text(items.data, 'effectiveCallNumberComponents', 'typeID') = inventory_call_number_types.id;
      
CREATE INDEX ON item_effective_callno_components (item_id);

CREATE INDEX ON item_effective_callno_components (item_hrid);

CREATE INDEX ON item_effective_callno_components (effective_call_number_prefix);

CREATE INDEX ON item_effective_callno_components (effective_call_number);

CREATE INDEX ON item_effective_callno_components (effective_call_number_suffix);

CREATE INDEX ON item_effective_callno_components (effective_call_number_type_id);

CREATE INDEX ON item_effective_callno_components (effective_call_number_type_name);

VACUUM ANALYZE item_effective_callno_components;

