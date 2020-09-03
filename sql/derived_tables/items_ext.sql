-- Create an extended items table that includes the name for in
-- transit destination service point, item damaged status, material
-- type call number type, permanent loan type, permanent location,
-- temporary loan type, temporary location.

CREATE TABLE local.items_ext AS
WITH items AS (
SELECT id,
       json_extract_path_text(data, 'accessionNumber') AS accession_number,
       barcode,
       chronology,
       copy_number,
       enumeration,
       in_transit_destination_service_point_id,
       json_extract_path_text(data, 'itemIdentifier') AS item_identifier,
       item_level_call_number,
       json_extract_path_text(data, 'itemLevelCallNumberTypeId')
               AS item_level_call_number_type_id,
       json_extract_path_text(data, 'itemDamagedStatusId')
               AS item_damaged_status_id,
       material_type_id,
       number_of_pieces,
       permanent_loan_type_id,
       temporary_loan_type_id,
       permanent_location_id,
       temporary_location_id
    FROM inventory_items
)
SELECT items.id AS items_id,
       items.accession_number,
       items.barcode,
       items.chronology,
       items.copy_number,
       items.enumeration,
       items.in_transit_destination_service_point_id,
       item_in_transit_destination_service_point.name
               AS in_transit_destination_service_point_name,
       items.item_identifier,
       items.item_level_call_number,
       items.item_level_call_number_type_id,
       item_call_number_type.name AS item_call_number_type_name,
       items.item_damaged_status_id,
       item_damaged_status.name AS item_damaged_status_name,
       items.material_type_id,
       item_material_type.name AS item_material_type_name,
       items.number_of_pieces,
       items.permanent_loan_type_id,
       -- item_permanent_loan_type AS item_permanent_loan_type_name,
       items.temporary_loan_type_id,
       -- item_temporary_loan_type.name AS item_temporary_loan_type_name,
       items.permanent_location_id,
       item_permanent_location.name AS item_permanent_location_name,
       items.temporary_location_id,
       item_temporary_location.name AS item_temporary_location_name
    FROM items
        LEFT JOIN inventory_service_points
                AS item_in_transit_destination_service_point
            ON items.in_transit_destination_service_point_id =
               item_in_transit_destination_service_point.id
        LEFT JOIN inventory_material_types AS item_material_type
            ON items.material_type_id = item_material_type.id
        LEFT JOIN inventory_loan_types AS item_permanent_loan_type
            ON items.permanent_loan_type_id = item_permanent_loan_type.id
        LEFT JOIN inventory_loan_types AS item_temporary_loan_type
            ON items.temporary_loan_type_id = item_temporary_loan_type.id
        LEFT JOIN inventory_locations AS item_permanent_location
            ON items.permanent_location_id = item_permanent_location.id
        LEFT JOIN inventory_locations AS item_temporary_location
            ON items.temporary_location_id = item_temporary_location.id
        LEFT JOIN inventory_item_damaged_statuses AS item_damaged_status
            ON items.item_damaged_status_id = item_damaged_status.id
        LEFT JOIN inventory_call_number_types AS item_call_number_type
            ON items.item_level_call_number_type_id = item_call_number_type.id;

CREATE INDEX ON local.items_ext (items_id);
CREATE INDEX ON local.items_ext (accession_number);
CREATE INDEX ON local.items_ext (barcode);
CREATE INDEX ON local.items_ext (chronology);
CREATE INDEX ON local.items_ext (copy_number);
CREATE INDEX ON local.items_ext (enumeration);
CREATE INDEX ON local.items_ext (in_transit_destination_service_point_id);
CREATE INDEX ON local.items_ext (in_transit_destination_service_point_name);
CREATE INDEX ON local.items_ext (item_identifier);
CREATE INDEX ON local.items_ext (item_level_call_number);
CREATE INDEX ON local.items_ext (item_level_call_number_type_id);
CREATE INDEX ON local.items_ext (item_damaged_status_id);
CREATE INDEX ON local.items_ext (material_type_id);
CREATE INDEX ON local.items_ext (item_material_type_name);
CREATE INDEX ON local.items_ext (number_of_pieces);
CREATE INDEX ON local.items_ext (permanent_loan_type_id);
CREATE INDEX ON local.items_ext (temporary_loan_type_id);
CREATE INDEX ON local.items_ext (permanent_location_id);
CREATE INDEX ON local.items_ext (item_permanent_location_name);
CREATE INDEX ON local.items_ext (temporary_location_id);
CREATE INDEX ON local.items_ext (item_temporary_location_name);

VACUUM local.items_ext;
ANALYZE local.items_ext;
