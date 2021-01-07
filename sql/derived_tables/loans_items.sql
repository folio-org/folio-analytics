-- this query depends on locations_libraries, so that
-- should be run before this one
DROP TABLE IF EXISTS folio_reporting.loans_items;

-- Create a derived table that contains all items from loans and adds
-- item, location, and other loan-related information
--
-- Tables included:
--     circulation_loans
--     inventory_items
--     inventory_material_types
--     circulation_loan_policies
--     user_groups
--     inventory_locations
--     inventory_service_points
--     inventory_loan_types
--     feesfines_overdue_fines_policies
--     feesfines_lost_item_fees_policies
--
-- Location names are from the items table.  They show location of the
-- item right now vs. when item was checked out.
--
CREATE TABLE folio_reporting.loans_items AS
SELECT
    cl.id AS loan_id,
    cl.item_id,
    cl.item_status,
    cl.loan_date,
    cl.due_date AS loan_due_date,
    cl.return_date AS loan_return_date,
    cl.system_return_date,
    cl.checkin_service_point_id,
    ispi.discovery_display_name AS checkin_service_point_name,
    cl.checkout_service_point_id,
    ispo.discovery_display_name AS checkout_service_point_name,
    cl.item_effective_location_id_at_check_out,
    icl.name AS item_effective_location_name_at_check_out,
    json_extract_path_text(ii.data, 'inTransitDestinationServicePointId') AS in_transit_destination_service_point_id,
    ispt.discovery_display_name AS in_transit_destination_service_point_name,
    ii.effective_location_id AS current_item_effective_location_id,
    iel.name AS current_item_effective_location_name,
    json_extract_path_text(ii.data, 'temporaryLocationId') AS current_item_temporary_location_id,
    itl.name AS current_item_temporary_location_name,
    json_extract_path_text(ii.data, 'permanentLocationId') AS current_item_permanent_location_id,
    ipl.name AS current_item_permanent_location_name,
    ll.library_id AS current_item_permanent_location_library_id,
    ll.library_name AS current_item_permanent_location_library_name,
    ll.campus_id AS current_item_permanent_location_campus_id,
    ll.campus_name AS current_item_permanent_location_campus_name,
    ll.institution_id AS current_item_permanent_location_institution_id,
    ll.institution_name AS current_item_permanent_location_institution_name,
    cl.loan_policy_id,
    clp.name AS loan_policy_name,
    cl.lost_item_policy_id,
    ffl.name AS lost_item_policy_name,
    cl.overdue_fine_policy_id,
    ffo.name AS overdue_fine_policy_name,
    cl.patron_group_id_at_checkout,
    ug.group AS patron_group_name,
    json_extract_path_text(cl.data, 'userId') AS user_id,
    json_extract_path_text(cl.data, 'proxyUserId') AS proxy_user_id,
    ii.barcode,
    json_extract_path_text(ii.data, 'chronology') AS chronology,
    json_extract_path_text(ii.data, 'copyNumber') AS copy_number,
    json_extract_path_text(ii.data, 'enumeration') AS enumeration,
    ii.holdings_record_id,
    ii.hrid,
    json_extract_path_text(ii.data, 'itemLevelCallNumber') AS item_level_call_number,
    ii.material_type_id,
    imt.name AS material_type_name,
    json_extract_path_text(ii.data, 'numberOfPieces') AS number_of_pieces,
    ii.permanent_loan_type_id,
    iltp.name AS permanent_loan_type_name,
    json_extract_path_text(ii.data, 'temporaryLoanTypeId') AS temporary_loan_type_id,
    iltt.name AS temporary_loan_type_name
FROM
    public.circulation_loans AS cl
    LEFT JOIN public.inventory_items AS ii ON cl.item_id = ii.id
    LEFT JOIN public.inventory_material_types AS imt ON ii.material_type_id = imt.id
    LEFT JOIN public.circulation_loan_policies AS clp ON cl.loan_policy_id = clp.id
    LEFT JOIN public.user_groups AS ug ON cl.patron_group_id_at_checkout = ug.id
    LEFT JOIN public.inventory_locations AS iel ON ii.effective_location_id = iel.id
    LEFT JOIN public.inventory_locations AS ipl ON json_extract_path_text(ii.data, 'permanentLocationId') = ipl.id
    LEFT JOIN folio_reporting.locations_libraries AS ll ON ipl.id = ll.location_id
    LEFT JOIN public.inventory_locations AS itl ON json_extract_path_text(ii.data, 'temporaryLocationId') = itl.id
    LEFT JOIN public.inventory_locations AS icl ON cl.item_effective_location_id_at_check_out = icl.id
    LEFT JOIN public.inventory_service_points AS ispi ON cl.checkin_service_point_id = ispi.id
    LEFT JOIN public.inventory_service_points AS ispo ON cl.checkout_service_point_id = ispo.id
    LEFT JOIN public.inventory_service_points AS ispt ON json_extract_path_text(ii.data, 'inTransitDestinationServicePointId') = ispt.id
    LEFT JOIN public.inventory_loan_types AS iltp ON json_extract_path_text(ii.data, 'temporaryLoanTypeId') = iltp.id
    LEFT JOIN public.inventory_loan_types AS iltt ON ii.permanent_loan_type_id = iltt.id
    LEFT JOIN public.feesfines_overdue_fines_policies AS ffo ON cl.overdue_fine_policy_id = ffo.id
    LEFT JOIN public.feesfines_lost_item_fees_policies AS ffl ON cl.lost_item_policy_id = ffl.id;

CREATE INDEX ON folio_reporting.loans_items (item_status);

CREATE INDEX ON folio_reporting.loans_items (loan_date);

CREATE INDEX ON folio_reporting.loans_items (loan_due_date);

CREATE INDEX ON folio_reporting.loans_items (current_item_effective_location_name);

CREATE INDEX ON folio_reporting.loans_items (current_item_permanent_location_name);

CREATE INDEX ON folio_reporting.loans_items (current_item_temporary_location_name);

CREATE INDEX ON folio_reporting.loans_items (current_item_permanent_location_library_name);

CREATE INDEX ON folio_reporting.loans_items (current_item_permanent_location_campus_name);

CREATE INDEX ON folio_reporting.loans_items (current_item_permanent_location_institution_name);

CREATE INDEX ON folio_reporting.loans_items (checkin_service_point_name);

CREATE INDEX ON folio_reporting.loans_items (checkout_service_point_name);

CREATE INDEX ON folio_reporting.loans_items (in_transit_destination_service_point_name);

CREATE INDEX ON folio_reporting.loans_items (patron_group_name);

CREATE INDEX ON folio_reporting.loans_items (material_type_name);

CREATE INDEX ON folio_reporting.loans_items (permanent_loan_type_name);

CREATE INDEX ON folio_reporting.loans_items (temporary_loan_type_name);

