-- Create a derived table for Purchase Order Line Locations/holdings including
-- location quantity and type. Purchase order line location can be represented either by location or holding id or it could not have one at all, 
-- it depends on how PO is created, and it is specified in pol_location_source.

DROP TABLE IF EXISTS po_lines_locations;

CREATE TABLE po_lines_locations AS
WITH ploc AS (
    SELECT
        p.id::uuid AS pol_id,
        jsonb_extract_path_text(locations.data, 'locationId')::uuid AS pol_location_id,
        jsonb_extract_path_text(locations.data, 'holdingId')::uuid AS pol_holding_id,
        jsonb_extract_path_text(locations.data, 'quantity')::int AS pol_loc_qty,
        jsonb_extract_path_text(locations.data, 'quantityElectronic')::int AS pol_loc_qty_elec,
        jsonb_extract_path_text(locations.data, 'quantityPhysical')::int AS pol_loc_qty_phys
    FROM
        folio_orders.po_line AS p
        CROSS JOIN jsonb_array_elements(jsonb_extract_path(jsonb, 'locations')) AS locations (data)
)
SELECT
    ploc.pol_id,
    ploc.pol_loc_qty,
    ploc.pol_loc_qty_elec,
    ploc.pol_loc_qty_phys,
CASE WHEN ploc.pol_location_id IS NOT NULL THEN ploc.pol_location_id  
          ELSE hr.permanent_location_id
END AS pol_location_id, 
CASE WHEN pol_location.name IS NOT NULL THEN pol_location.name
         ELSE holdings_location.name
END AS pol_location_name,
CASE WHEN pol_location.name IS NOT NULL THEN 'pol_location'
         WHEN holdings_location.name IS NOT NULL THEN 'pol_holding'
         ELSE 'no_source'
END AS pol_location_source
FROM
    ploc
    LEFT JOIN folio_inventory.holdings_record__t AS hr ON ploc.pol_holding_id::uuid = hr.id
    LEFT JOIN folio_inventory.location__t AS pol_location ON pol_location.id = ploc.pol_location_id
    LEFT JOIN folio_inventory.location__t AS holdings_location ON holdings_location.id::uuid = hr.permanent_location_id ;

CREATE INDEX ON po_lines_locations (pol_id);

CREATE INDEX ON po_lines_locations (pol_loc_qty);

CREATE INDEX ON po_lines_locations (pol_loc_qty_elec);

CREATE INDEX ON po_lines_locations (pol_loc_qty_phys);

CREATE INDEX ON po_lines_locations (pol_location_id);

CREATE INDEX ON po_lines_locations (pol_location_name);

CREATE INDEX ON po_lines_locations (pol_location_source);

COMMENT ON COLUMN po_lines_locations.pol_id IS 'UUID identifying this purchase order line';

COMMENT ON COLUMN po_lines_locations.pol_loc_qty IS 'Combined/total quantity of physical and electronic items';

COMMENT ON COLUMN po_lines_locations.pol_loc_qty_elec IS 'Quantity of electronic items in this purchase order line';

COMMENT ON COLUMN po_lines_locations.pol_loc_qty_phys IS 'Quantity of physical items or resources of "Other" order format in this purchase order line';

COMMENT ON COLUMN po_lines_locations.pol_location_id IS 'UUID of the (inventory) location record or Holding UUID associated with order line';

COMMENT ON COLUMN po_lines_locations.pol_location_name IS 'Name of the location associated with pol_location_id';

COMMENT ON COLUMN po_lines_locations.pol_location_source IS 'Source of the location associated with pol_location_id';

VACUUM ANALYZE po_lines_locations;
