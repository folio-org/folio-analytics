-- Create table for item effective call number components

DROP TABLE IF EXISTS item_effective_callno_components;

CREATE TABLE item_effective_callno_components AS
SELECT
    items.id AS item_id,
    items.hrid AS item_hrid,
    items.data #>> '{effectiveCallNumberComponents,prefix}' AS effective_call_number_prefix,
    items.data #>> '{effectiveCallNumberComponents,callNumber}' AS effective_call_number,
    items.data #>> '{effectiveCallNumberComponents,suffix}' AS effective_call_number_suffix,
    items.data #>> '{effectiveCallNumberComponents,typeID}' AS effective_call_number_type_id,
    inventory_call_number_types.name AS effective_call_number_type_name
FROM
    inventory_items AS items
    LEFT JOIN inventory_call_number_types
        ON (items.data #>> '{effectiveCallNumberComponents,typeID}')::uuid = inventory_call_number_types.id::uuid;
      
