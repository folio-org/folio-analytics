DROP TABLE IF EXISTS local.vandanashah_requests_items;

-- Create a derived table that contains all items from requests and adds
-- item and patron-related information
--
-- Tables included:
--     circulation_requests
--     inventory_items
--		user_users
--		user_groups 


--inventory_material_types
--     circulation_loan_policies
--     
--     inventory_locations
--     inventory_service_points
--     inventory_loan_types
--     feesfines_overdue_fines_policies
--     feesfines_lost_item_fees_policies
--
-- 	fulfillment preference specifies where to hold or deliver item 
--
CREATE TABLE local.vandanashah_requests_items AS

SELECT
	cr.id AS request_id,
	cr.item_id,
	cr.request_date,
	cr.request_type,
	cr.status AS request_status,
	cr.pickup_service_point_id,
	psp.name AS pickup_service_point_name,
	cr.fulfilment_preference,
	cr.requester_id,
	uu.id AS user_id,
	uu.patron_group AS patron_group_id,
	ug.desc AS patron_group_name,
	ii.item_level_call_number,
	ii.barcode,
	ii.chronology,
	ii.copy_number,
	ii.effective_location_id,
    --insert all location names
    ii.permanent_location_id,
    
    ii.temporary_location_id,
    
    ii.enumeration,
    ii.holdings_record_id,
    ii.hrid,
    ii.in_transit_destination_service_point_id,
    isp."name" AS in_transit_destination_service_point_name,
    ii.item_identifier,
    ii.material_type_id,
    ii.number_of_pieces,
    ii.permanent_loan_type_id,
    --permanent_loan_type_name
    
    ii.temporary_loan_type_id,
    --temp_loan_type_name
    isp.discovery_display_name,
	FROM
    public.circulation_requests cr
LEFT JOIN public.inventory_items AS ii
	ON cr.item_id=ii.id
LEFT JOIN public.inventory_service_points AS isp
	ON ii.in_transit_destination_service_point_id=isp.id
LEFT JOIN public.inventory_service_points AS psp
	ON cr.pickup_service_point_id = psp.id
