-- Create a derived table that contains all items from requests and adds
-- item and patron-related information

DROP TABLE IF EXISTS requests_items;

CREATE TABLE requests_items AS
SELECT
    cr.id AS request_id,
    cr.item_id,
    cr.request_date::date as request_date,
    cr.request_type,
    cr.status AS request_status,
    cr.pickup_service_point_id,   
    psp.name AS pickup_service_point_name,
    psp.discovery_display_name AS pickup_service_point_disc_disp_name,
    ii.data->>'inTransitDestinationServicePointId' AS in_transit_dest_serv_point_id,
    isp.name AS in_transit_dest_serv_point_name,
    isp.discovery_display_name AS in_transit_dest_serv_point_disc_disp_name,
    cr.requester_id, 
    cr.data->>'fulfilmentPreference' AS fulfillment_preference,
    uu.patron_group AS patron_group_id,
    ug.desc AS patron_group_name,
    ii.item_level_call_number,
    ii.barcode,
    ii.chronology,
    ii.copy_number AS item_copy_number,
    ii.permanent_location_id AS item_permanent_location_id,
    ii.temporary_location_id AS item_temporary_location_id,
    ii.enumeration,
    ii.effective_location_id AS item_effective_location_id,
    iel.name AS item_effective_location_name,
    ipl.name AS item_permanent_location_name,
    itl.name AS item_temporary_location_name,
    ii.holdings_record_id,
    ii.hrid,
    ii.data->>'itemIdentifier' AS item_identifier,
    ii.material_type_id,
    imt.name AS material_type_name,
    ii.number_of_pieces,
    ii.permanent_loan_type_id AS item_permanent_loan_type_id,
    iplt.name AS item_permanent_loan_type_name,
    ii.temporary_loan_type_id AS item_temporary_loan_type_id,
    itlt.name AS item_temporary_loan_type_name
FROM
    public.circulation_requests AS cr
    LEFT JOIN public.inventory_items AS ii ON cr.item_id = ii.id
    LEFT JOIN public.inventory_service_points AS isp ON ii.in_transit_destination_service_point_id = isp.id
    LEFT JOIN public.inventory_service_points AS psp ON  cr.pickup_service_point_id = psp.id
    LEFT JOIN user_users AS uu ON cr.requester_id = uu.id
    LEFT JOIN user_groups AS ug ON uu.patron_group = ug.id
    LEFT JOIN inventory_locations AS iel ON ii.effective_location_id = iel.id
    LEFT JOIN inventory_locations AS ipl ON ii.permanent_location_id = ipl.id
    LEFT JOIN inventory_locations AS itl ON ii.temporary_location_id = itl.id
    LEFT JOIN inventory_loan_types AS iplt ON ii.permanent_loan_type_id = iplt.id
    LEFT JOIN inventory_loan_types AS itlt ON ii.temporary_loan_type_id = itlt.id
    LEFT JOIN inventory_material_types AS imt ON ii.material_type_id = imt.id;

