DROP TABLE IF EXISTS item_ext;

-- Create an extended items table that includes the name for in
-- transit destination service point, item damaged status, material
-- type call number type, permanent loan type, permanent location,
-- temporary loan type, temporary location, created_date,
-- description_of_pieces, status_date, status_name, holdings_id
-- Item notes are in a separate derived table.
-- There is a separate table for effective call number. However, it is also included here.
CREATE TABLE item_ext AS
SELECT
    items.id AS item_id,
    items.hrid AS item_hrid,
    items.accession_number,
    items.barcode,
    items.chronology,
    items.copy_number,
    items.enumeration,
    items.volume,
    items.in_transit_destination_service_point_id,
    item_in_transit_destination_service_point.name AS in_transit_destination_service_point_name,
    items.item_identifier AS identifier,
    items.item_level_call_number AS call_number,
    items.item_level_call_number_type_id AS call_number_type_id,
    item_call_number_type.name AS call_number_type_name,
    json_extract_path_text(items.data, 'effectiveCallNumberComponents', 'prefix') AS effective_call_number_prefix,
    json_extract_path_text(items.data, 'effectiveCallNumberComponents', 'callNumber') AS effective_call_number,
    json_extract_path_text(items.data, 'effectiveCallNumberComponents', 'suffix') AS effective_call_number_suffix,
    json_extract_path_text(items.data, 'effectiveCallNumberComponents', 'typeID') AS effective_call_number_type_id,
    effective_call_number_type.name AS effective_call_number_type_name,
    items.item_damaged_status_id AS damaged_status_id,
    item_damaged_status.name AS damaged_status_name,
    items.material_type_id,
    item_material_type.name AS material_type_name,
    items.number_of_pieces,
    items.number_of_missing_pieces,
    items.permanent_loan_type_id,
    item_permanent_loan_type.name AS permanent_loan_type_name,
    items.temporary_loan_type_id,
    item_temporary_loan_type.name AS temporary_loan_type_name,
    items.permanent_location_id,
    item_permanent_location.name AS permanent_location_name,
    items.temporary_location_id,
    item_temporary_location.name AS temporary_location_name,
    items.effective_location_id,
    item_effective_location.name AS effective_location_name,
    json_extract_path_text(items.data, 'circulationNotes', 'descriptionOfPieces') AS description_of_pieces,
    json_extract_path_text(items.data, 'status', 'date')::timestamptz AS status_date,
    json_extract_path_text(items.data, 'status', 'name') AS status_name,
    items.holdings_record_id,
    items.discovery_suppress,
    json_extract_path_text(items.data, 'metadata', 'createdDate')::timestamptz AS created_date,
    json_extract_path_text(items.data, 'metadata', 'updatedByUserId') AS updated_by_user_id,
    json_extract_path_text(items.data, 'metadata', 'updatedDate')::timestamptz AS updated_date
FROM
    inventory_items AS items
    LEFT JOIN inventory_service_points AS item_in_transit_destination_service_point ON items.in_transit_destination_service_point_id = item_in_transit_destination_service_point.id
    LEFT JOIN inventory_material_types AS item_material_type ON items.material_type_id = item_material_type.id
    LEFT JOIN inventory_loan_types AS item_permanent_loan_type ON items.permanent_loan_type_id = item_permanent_loan_type.id
    LEFT JOIN inventory_loan_types AS item_temporary_loan_type ON items.temporary_loan_type_id = item_temporary_loan_type.id
    LEFT JOIN inventory_locations AS item_permanent_location ON items.permanent_location_id = item_permanent_location.id
    LEFT JOIN inventory_locations AS item_temporary_location ON items.temporary_location_id = item_temporary_location.id
    LEFT JOIN inventory_locations AS item_effective_location ON items.effective_location_id = item_effective_location.id
    LEFT JOIN inventory_item_damaged_statuses AS item_damaged_status ON items.item_damaged_status_id = item_damaged_status.id
    LEFT JOIN inventory_call_number_types AS item_call_number_type ON items.item_level_call_number_type_id = item_call_number_type.id
    LEFT JOIN inventory_call_number_types AS effective_call_number_type ON json_extract_path_text(items.data, 'effectiveCallNumberComponents', 'typeID') = effective_call_number_type.id;

