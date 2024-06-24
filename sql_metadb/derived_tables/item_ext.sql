--metadb:table item_ext
--metadb:require folio_inventory.item__t.enumeration text

DROP TABLE IF EXISTS item_ext;

/*
 * Create an extended items table that includes the name for in
 * transit destination service point, item damaged status, material
 * type call number type, permanent loan type, permanent location,
 * temporary loan type, temporary location, created_date,
 * description_of_pieces, status_date, status_name, holdings_id.
 * There is a separate table for effective call number.
 * However, it is also included here.
 *
 * Item notes, tags, and electronic access are in separate derived
 * tables.
 *
 * Tables inlcuded:
 *    folio_inventory.item
 *    folio_inventory.item__t
 *    folio_inventory.service_point__t
 *    folio_inventory.material_type__t
 *    folio_inventory.loan_type__t
 *    folio_inventory.location__t
 *    folio_inventory.item_damaged_status__t
 *    folio_inventory.call_number_type__t
 */
CREATE TABLE item_ext AS
WITH items AS (
    SELECT
        i.id,
        it.hrid,
        jsonb_extract_path_text(i.jsonb, 'accessionNumber') AS accession_number,
        it.barcode,
        jsonb_extract_path_text(i.jsonb, 'chronology') AS chronology,
        jsonb_extract_path_text(i.jsonb, 'copyNumber') AS copy_number,
        it.enumeration,
        jsonb_extract_path_text(i.jsonb, 'volume') AS volume,
        jsonb_extract_path_text(i.jsonb, 'inTransitDestinationServicePointId')::uuid AS in_transit_destination_service_point_id,
        jsonb_extract_path_text(i.jsonb, 'itemIdentifier') AS item_identifier,
        jsonb_extract_path_text(i.jsonb, 'itemLevelCallNumber') AS item_level_call_number,
        jsonb_extract_path_text(i.jsonb, 'itemLevelCallNumberTypeId')::uuid AS item_level_call_number_type_id,
        jsonb_extract_path_text(i.jsonb, 'effectiveCallNumberComponents', 'prefix') AS effective_call_number_prefix,
        jsonb_extract_path_text(i.jsonb, 'effectiveCallNumberComponents', 'callNumber') AS effective_call_number,
        jsonb_extract_path_text(i.jsonb, 'effectiveCallNumberComponents', 'suffix') AS effective_call_number_suffix,
        jsonb_extract_path_text(i.jsonb, 'effectiveCallNumberComponents', 'typeId')::uuid AS effective_call_number_type_id,
        jsonb_extract_path_text(i.jsonb, 'itemDamagedStatusId')::uuid AS item_damaged_status_id,
        i.materialtypeid AS material_type_id,
        jsonb_extract_path_text(i.jsonb, 'numberOfPieces') AS number_of_pieces,
        jsonb_extract_path_text(i.jsonb, 'numberOfMissingPieces') AS number_of_missing_pieces,
        i.permanentloantypeid AS permanent_loan_type_id,
        i.temporaryloantypeid AS temporary_loan_type_id,
        i.permanentlocationid AS permanent_location_id,
        i.temporarylocationid AS temporary_location_id,
        i.effectivelocationid AS effective_location_id,
        i.creation_date AS created_date,
        jsonb_extract_path_text(i.jsonb, 'metadata', 'updatedByUserId')::uuid AS updated_by_user_id,
        jsonb_extract_path_text(i.jsonb, 'metadata', 'updatedDate') AS updated_date,
        jsonb_extract_path_text(i.jsonb, 'descriptionOfPieces') AS description_of_pieces,
        jsonb_extract_path_text(i.jsonb, 'status', 'date') AS status_date,
        jsonb_extract_path_text(i.jsonb, 'status', 'name') AS status_name,
        i.holdingsrecordid AS holdings_record_id,
        jsonb_extract_path_text(i.jsonb, 'discoverySuppress')::boolean AS discovery_suppress
    FROM
        folio_inventory.item AS i
        LEFT JOIN folio_inventory.item__t AS it ON i.id = it.id
)
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
    items.effective_call_number_prefix,
    items.effective_call_number,
    items.effective_call_number_suffix,
    items.effective_call_number_type_id,
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
    items.description_of_pieces,
    items.status_date,
    items.status_name,
    items.holdings_record_id,
    items.discovery_suppress,
    items.created_date,
    items.updated_by_user_id,
    items.updated_date
FROM
    items
    LEFT JOIN folio_inventory.service_point__t AS item_in_transit_destination_service_point ON items.in_transit_destination_service_point_id = item_in_transit_destination_service_point.id
    LEFT JOIN folio_inventory.material_type__t AS item_material_type ON items.material_type_id = item_material_type.id
    LEFT JOIN folio_inventory.loan_type__t AS item_permanent_loan_type ON items.permanent_loan_type_id = item_permanent_loan_type.id
    LEFT JOIN folio_inventory.loan_type__t AS item_temporary_loan_type ON items.temporary_loan_type_id = item_temporary_loan_type.id
    LEFT JOIN folio_inventory.location__t AS item_permanent_location ON items.permanent_location_id = item_permanent_location.id
    LEFT JOIN folio_inventory.location__t AS item_temporary_location ON items.temporary_location_id = item_temporary_location.id
    LEFT JOIN folio_inventory.location__t AS item_effective_location ON items.effective_location_id = item_effective_location.id
    LEFT JOIN folio_inventory.item_damaged_status__t AS item_damaged_status ON items.item_damaged_status_id = item_damaged_status.id
    LEFT JOIN folio_inventory.call_number_type__t AS item_call_number_type ON items.item_level_call_number_type_id = item_call_number_type.id
    LEFT JOIN folio_inventory.call_number_type__t AS effective_call_number_type ON items.effective_call_number_type_id = effective_call_number_type.id;
