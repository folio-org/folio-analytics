-- This query creates a derived table for purchase order line
-- locations including location quantity and type.  It uses
-- conditional statements to search for location ID and location name
-- in the purchase order line location and holdings location fields,
-- displays whichever is not null, and indicates the source of the
-- resulting location data (purchase order location or purchase order
-- holding location) in the pol_location_source column.

DROP TABLE IF EXISTS po_lines_locations;

CREATE TABLE po_lines_locations AS
SELECT
    pol.id AS pol_id,
    json_extract_path_text(locations.data, 'quantity') AS pol_location_qty,
    json_extract_path_text(locations.data, 'quantityElectronic') AS pol_loc_qty_elec,
    json_extract_path_text(locations.data, 'quantityPhysical') AS pol_loc_qty_phys,      
    CASE WHEN json_extract_path_text(locations.data, 'locationId') IS NOT NULL THEN json_extract_path_text(locations.data, 'locationId') 
         ELSE ih.permanent_location_id
    END AS pol_location_id,	
    CASE WHEN il.name IS NOT NULL THEN il.name
         ELSE il2.name
    END AS pol_location_name,
    CASE WHEN il.name IS NOT NULL THEN 'pol_location'
         WHEN il2.name IS NOT NULL THEN 'pol_holding'
         ELSE 'no_source'
    END AS pol_location_source
FROM
    po_lines AS pol
    CROSS JOIN json_array_elements(json_extract_path(data, 'locations')) AS locations (data)
    LEFT JOIN inventory_holdings AS ih ON json_extract_path_text(locations.data, 'holdingId') = ih.id
    LEFT JOIN inventory_locations AS il ON json_extract_path_text(locations.data, 'locationId') = il.id
    LEFT JOIN inventory_locations AS il2 ON ih.permanent_location_id = il2.id;

