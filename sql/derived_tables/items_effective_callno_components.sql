DROP TABLE IF EXISTS local.items_effective_callno_components;

-- Create table for item effective call number components
CREATE TABLE local.items_effective_callno_components AS
WITH items AS (
    SELECT
        item.id AS itm_id,
        item.hrid AS itm_hrid,
        json_extract_path_text(data, 'effectiveCallNumberComponents', 'prefix') AS itm_effective_call_number_prefix,
        json_extract_path_text(data, 'effectiveCallNumberComponents', 'callNumber') AS itm_effective_call_number,
        json_extract_path_text(data, 'effectiveCallNumberComponents', 'suffix') AS itm_effective_call_number_suffix,
        json_extract_path_text(data, 'effectiveCallNumberComponents', 'typeId') AS itm_effective_call_number_type_id
    FROM
        inventory_items AS item
)
SELECT
    items.itm_id,
    items.itm_hrid,
    items.itm_effective_call_number_prefix,
    items.itm_effective_call_number,
    items.itm_effective_call_number_suffix,
    items.itm_effective_call_number_type_id,
    inventory_call_number_types.name AS itm_effective_call_number_name
FROM
    items
    LEFT JOIN inventory_call_number_types ON items.itm_effective_call_number_type_id = inventory_call_number_types.id;

CREATE INDEX ON local.items_effective_callno_components (itm_id);

CREATE INDEX ON local.items_effective_callno_components (itm_hrid);

CREATE INDEX ON local.items_effective_callno_components (itm_effective_call_number_prefix);

CREATE INDEX ON local.items_effective_callno_components (itm_effective_call_number);

CREATE INDEX ON local.items_effective_callno_components (itm_effective_call_number_suffix);

CREATE INDEX ON local.items_effective_callno_components (itm_effective_call_number_type_id);

CREATE INDEX ON local.items_effective_callno_components (itm_effective_call_number_name);

