DROP TABLE IF EXISTS po_lines_locations;

-- Create a local table for Purchase Order Line Locations including location quantity and type.

CREATE TABLE po_lines_locations AS
WITH pol_location AS (
    SELECT
        pol.id::uuid AS pol_id,
        jsonb_extract_path_text(locations.data, 'locationId')::uuid AS pol_loc_id,
        jsonb_extract_path_text(locations.data, 'quantity')::int AS pol_loc_qty,
        jsonb_extract_path_text(locations.data, 'quantityElectronic')::int AS pol_loc_qty_elec,
        jsonb_extract_path_text(locations.data, 'quantityPhysical')::int AS pol_loc_qty_phys
    FROM
        folio_orders.po_line AS pol
        CROSS JOIN jsonb_array_elements(jsonb_extract_path(jsonb, 'locations')) AS locations (data)
)
SELECT
    pol_location.pol_id,
    pol_location.pol_loc_id,
    pol_location.pol_loc_qty,
    pol_location.pol_loc_qty_elec,
    pol_location.pol_loc_qty_phys,
    folio_inventory.location__t.name AS location_name
FROM
    pol_location
    LEFT JOIN folio_inventory.location__t ON folio_inventory.location__t.id = pol_location.pol_loc_id;
 
CREATE INDEX ON po_lines_locations (pol_id);

CREATE INDEX ON po_lines_locations (pol_loc_id);

CREATE INDEX ON po_lines_locations (pol_loc_qty);

CREATE INDEX ON po_lines_locations (pol_loc_qty_elec);

CREATE INDEX ON po_lines_locations (pol_loc_qty_phys);

CREATE INDEX ON po_lines_locations (location_name);

VACUUM ANALYZE  po_lines_locations;
