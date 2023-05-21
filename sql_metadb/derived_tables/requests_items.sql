--metadb:table requests_items

-- Create a derived table that contains all items from requests and adds
-- item and patron-related information

DROP TABLE IF EXISTS requests_items;

CREATE TABLE requests_items AS
SELECT
    crt.id AS request_id,
    crt.item_id,
    crt.request_date::DATE as request_date,
    crt.request_type,
    crt.status AS request_status,
    crt.pickup_service_point_id,   
    psp.name AS pickup_service_point_name,
    psp.discovery_display_name AS pickup_service_point_disc_disp_name,
    jsonb_extract_path_text(iij.jsonb, 'inTransitDestinationServicePointId')::uuid AS in_transit_dest_serv_point_id,
    isp.name AS in_transit_dest_serv_point_name,
    isp.discovery_display_name AS in_transit_dest_serv_point_disc_disp_name,
    crt.requester_id, 
    jsonb_extract_path_text(crj.jsonb, 'fulfilmentPreference') AS fulfillment_preference,
    uut.patron_group AS patron_group_id,
    ugt.desc AS patron_group_name,
    iit.item_level_call_number,
    iit.barcode,
    --iit.chronology,
    jsonb_extract_path_text(iij.jsonb, 'chronology') AS chronology,
    --iit.copy_number AS item_copy_number,
    jsonb_extract_path_text(iij.jsonb, 'copyNumber') AS item_copy_number,
    iit.permanent_location_id AS item_permanent_location_id,
    --iit.temporary_location_id AS item_temporary_location_id,
    jsonb_extract_path_text(iij.jsonb, 'temporaryLocationId')::uuid AS item_temporary_location_id,
    iit.enumeration,
    iit.effective_location_id AS item_effective_location_id,
    iel.name AS item_effective_location_name,
    ipl.name AS item_permanent_location_name,
    itl.name AS item_temporary_location_name,
    iit.holdings_record_id,
    iit.hrid,
    jsonb_extract_path_text(iij.jsonb, 'itemIdentifier') AS item_identifier,
    iit.material_type_id,
    imt.name AS material_type_name,
    --iit.number_of_pieces,
    jsonb_extract_path_text(iij.jsonb, 'numberOfPieces') AS number_of_pieces,
    iit.permanent_loan_type_id AS item_permanent_loan_type_id,
    iplt.name AS item_permanent_loan_type_name,
    --iit.temporary_loan_type_id AS item_temporary_loan_type_id,
    jsonb_extract_path_text(iij.jsonb, 'temporaryLoanTypeId')::uuid AS item_temporary_loan_type_id,
    itlt.name AS item_temporary_loan_type_name
FROM
    folio_circulation.request__t AS crt
    LEFT JOIN folio_circulation.request AS crj ON crt.id = crj.id
    LEFT JOIN folio_inventory.item__t AS iit ON crt.item_id = iit.id
    LEFT JOIN folio_inventory.item AS iij ON iit.id = iij.id
    --LEFT JOIN folio_inventory.service_point__t AS isp ON iit.in_transit_destination_service_point_id = isp.id
    LEFT JOIN folio_inventory.service_point__t AS isp ON jsonb_extract_path_text(iij.jsonb, 'inTransitDestinationServicePointId')::uuid = isp.id
    LEFT JOIN folio_inventory.service_point__t AS psp ON crt.pickup_service_point_id = psp.id
    LEFT JOIN folio_users.users__t AS uut ON crt.requester_id = uut.id
    LEFT JOIN folio_users.groups__t AS ugt ON uut.patron_group = ugt.id
    LEFT JOIN folio_inventory.location__t AS iel ON iit.effective_location_id = iel.id
    LEFT JOIN folio_inventory.location__t AS ipl ON iit.permanent_location_id = ipl.id
    LEFT JOIN folio_inventory.location__t AS itl ON jsonb_extract_path_text(iij.jsonb, 'temporaryLocationId')::uuid = itl.id
    LEFT JOIN folio_inventory.loan_type__t AS iplt ON iit.permanent_loan_type_id = iplt.id
    --LEFT JOIN folio_inventory.loan_type__t AS itlt ON iit.temporary_loan_type_id = itlt.id
    LEFT JOIN folio_inventory.loan_type__t AS itlt ON jsonb_extract_path_text(iij.jsonb, 'temporaryLoanTypeId')::uuid = itlt.id
    LEFT JOIN folio_inventory.material_type__t AS imt ON iit.material_type_id = imt.id;

CREATE INDEX ON requests_items (request_id);

CREATE INDEX ON requests_items (item_id);

CREATE INDEX ON requests_items (request_date);

CREATE INDEX ON requests_items (request_type);

CREATE INDEX ON requests_items (request_status);

CREATE INDEX ON requests_items (pickup_service_point_id);

CREATE INDEX ON requests_items (pickup_service_point_name);

CREATE INDEX ON requests_items (pickup_service_point_disc_disp_name);

CREATE INDEX ON requests_items (in_transit_dest_serv_point_id);

CREATE INDEX ON requests_items (in_transit_dest_serv_point_name);

CREATE INDEX ON requests_items (in_transit_dest_serv_point_disc_disp_name);

CREATE INDEX ON requests_items (fulfillment_preference);

CREATE INDEX ON requests_items (requester_id);

CREATE INDEX ON requests_items (patron_group_id);

CREATE INDEX ON requests_items (patron_group_name);

CREATE INDEX ON requests_items (item_level_call_number);

CREATE INDEX ON requests_items (barcode);

CREATE INDEX ON requests_items (chronology);

CREATE INDEX ON requests_items (item_copy_number);

CREATE INDEX ON requests_items (item_effective_location_id);

CREATE INDEX ON requests_items (item_effective_location_name);

CREATE INDEX ON requests_items (item_permanent_location_id);

CREATE INDEX ON requests_items (item_permanent_location_name);

CREATE INDEX ON requests_items (item_temporary_location_id);

CREATE INDEX ON requests_items (item_temporary_location_name);

CREATE INDEX ON requests_items (enumeration);

CREATE INDEX ON requests_items (holdings_record_id);

CREATE INDEX ON requests_items (hrid);

CREATE INDEX ON requests_items (item_identifier);

CREATE INDEX ON requests_items (material_type_id);

CREATE INDEX ON requests_items (material_type_name);

CREATE INDEX ON requests_items (number_of_pieces);

CREATE INDEX ON requests_items (item_permanent_loan_type_id);

CREATE INDEX ON requests_items (item_permanent_loan_type_name);

CREATE INDEX ON requests_items (item_temporary_loan_type_id);

CREATE INDEX ON requests_items (item_temporary_loan_type_name);

