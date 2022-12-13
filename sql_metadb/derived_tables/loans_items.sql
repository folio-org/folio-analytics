-- this query depends on locations_libraries, so that
-- should be run before this one
DROP TABLE IF EXISTS loans_items;

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
CREATE TABLE loans_items AS
SELECT
    clt.id AS loan_id,
    clt.item_id::uuid,
    clt.item_status,
    jsonb_extract_path_text(clj.jsonb, 'status', 'name') AS loan_status,
    clt.loan_date::timestamptz,
    clt.due_date::timestamptz AS loan_due_date,
    jsonb_extract_path_text(clj.jsonb, 'returnDate')::timestamptz AS loan_return_date,
    jsonb_extract_path_text(clj.jsonb, 'systemReturnDate')::timestamptz AS system_return_date,
    jsonb_extract_path_text(clj.jsonb, 'checkinServicePointId')::uuid AS checkin_service_point_id,
    ispi.discovery_display_name AS checkin_service_point_name,
    jsonb_extract_path_text(clj.jsonb, 'checkoutServicePointId')::uuid AS checkout_service_point_id,
    ispo.discovery_display_name AS checkout_service_point_name,
    jsonb_extract_path_text(clj.jsonb, 'itemEffectiveLocationIdAtCheckOut')::uuid AS item_effective_location_id_at_check_out,
    icl.name AS item_effective_location_name_at_check_out,
    jsonb_extract_path_text(iij.jsonb, 'inTransitDestinationServicePointId')::uuid AS in_transit_destination_service_point_id,
    ispt.discovery_display_name AS in_transit_destination_service_point_name,
    iit.effective_location_id::uuid AS current_item_effective_location_id,
    iel.name AS current_item_effective_location_name,
    jsonb_extract_path_text(iij.jsonb, 'temporaryLocationId')::uuid AS current_item_temporary_location_id,
    itl.name AS current_item_temporary_location_name,
    jsonb_extract_path_text(iij.jsonb, 'permanentLocationId')::uuid AS current_item_permanent_location_id,
    ipl.name AS current_item_permanent_location_name,
    ll.library_id AS current_item_permanent_location_library_id,
    ll.library_name AS current_item_permanent_location_library_name,
    ll.campus_id AS current_item_permanent_location_campus_id,
    ll.campus_name AS current_item_permanent_location_campus_name,
    ll.institution_id AS current_item_permanent_location_institution_id,
    ll.institution_name AS current_item_permanent_location_institution_name,
    jsonb_extract_path_text(clj.jsonb, 'loanPolicyId')::uuid AS loan_policy_id,
    clp.name AS loan_policy_name,
    jsonb_extract_path_text(clj.jsonb, 'lostItemPolicyId')::uuid AS lost_item_policy_id,
    ffl.name AS lost_item_policy_name,
    jsonb_extract_path_text(clj.jsonb, 'overdueFinePolicyId')::uuid AS overdue_fine_policy_id,
    ffo.name AS overdue_fine_policy_name,
    jsonb_extract_path_text(clj.jsonb, 'patronGroupIdAtCheckout')::uuid AS patron_group_id_at_checkout,
    ug.group AS patron_group_name,
    jsonb_extract_path_text(clj.jsonb, 'userId')::uuid AS user_id,
    jsonb_extract_path_text(clj.jsonb, 'proxyUserId')::uuid AS proxy_user_id,
    iit.barcode,
    jsonb_extract_path_text(iij.jsonb, 'chronology') AS chronology,
    jsonb_extract_path_text(iij.jsonb, 'copyNumber') AS copy_number,
    jsonb_extract_path_text(iij.jsonb, 'enumeration') AS enumeration,
    iit.holdings_record_id::uuid,
    iit.hrid,
    jsonb_extract_path_text(iij.jsonb, 'itemLevelCallNumber') AS item_level_call_number,
    iit.material_type_id::uuid,
    imt.name AS material_type_name,
    jsonb_extract_path_text(iij.jsonb, 'numberOfPieces') AS number_of_pieces,
    iit.permanent_loan_type_id::uuid,
    iltp.name AS permanent_loan_type_name,
    jsonb_extract_path_text(iij.jsonb, 'temporaryLoanTypeId')::uuid AS temporary_loan_type_id,
    iltt.name AS temporary_loan_type_name,
    jsonb_extract_path_text(clj.jsonb, 'renewalCount')::bigint AS renewal_count
FROM
    folio_circulation.loan__t AS clt
    LEFT JOIN folio_circulation.loan AS clj ON clt.id = clj.id 
    LEFT JOIN folio_inventory.service_point__t AS ispi ON jsonb_extract_path_text(clj.jsonb, 'checkinServicePointId')::uuid = ispi.id
    LEFT JOIN folio_inventory.service_point__t AS ispo ON jsonb_extract_path_text(clj.jsonb, 'checkoutServicePointId')::uuid = ispo.id
    LEFT JOIN folio_inventory.item AS iij ON clt.item_id::uuid = iij.id
    LEFT JOIN folio_inventory.item__t AS iit ON clt.item_id::uuid = iit.id
    LEFT JOIN folio_inventory.location__t AS ipl ON jsonb_extract_path_text(iij.jsonb, 'permanentLocationId')::uuid = ipl.id
    LEFT JOIN locations_libraries AS ll ON ipl.id = ll.location_id
    LEFT JOIN folio_inventory.location__t AS icl ON jsonb_extract_path_text(clj.jsonb, 'itemEffectiveLocationIdAtCheckOut')::uuid = icl.id
    LEFT JOIN folio_inventory.service_point__t AS ispt ON jsonb_extract_path_text(iij.jsonb, 'inTransitDestinationServicePointId')::uuid = ispt.id
    LEFT JOIN folio_inventory.location__t AS iel ON iit.effective_location_id::uuid = iel.id
    LEFT JOIN folio_inventory.location__t AS itl ON jsonb_extract_path_text(iij.jsonb, 'temporaryLocationId')::uuid = itl.id
    LEFT JOIN folio_circulation.loan_policy__t AS clp ON jsonb_extract_path_text(clj.jsonb, 'loanPolicyId')::uuid = clp.id
    LEFT JOIN folio_feesfines.lost_item_fee_policy__t AS ffl ON jsonb_extract_path_text(clj.jsonb, 'lostItemPolicyId')::uuid = ffl.id
    LEFT JOIN folio_feesfines.overdue_fine_policy__t AS ffo ON jsonb_extract_path_text(clj.jsonb, 'overdueFinePolicyId')::uuid = ffo.id
    LEFT JOIN folio_users.groups__t AS ug ON jsonb_extract_path_text(clj.jsonb, 'patronGroupIdAtCheckout')::uuid = ug.id
    LEFT JOIN folio_inventory.material_type__t AS imt ON iit.material_type_id::uuid = imt.id
    LEFT JOIN folio_inventory.loan_type__t AS iltp ON iit.permanent_loan_type_id::uuid = iltp.id
    LEFT JOIN folio_inventory.loan_type__t AS iltt ON jsonb_extract_path_text(iij.jsonb, 'temporaryLoanTypeId')::uuid = iltt.id
    ;

CREATE INDEX ON loans_items (item_status);

CREATE INDEX ON loans_items (loan_status);

CREATE INDEX ON loans_items (loan_date);

CREATE INDEX ON loans_items (loan_due_date);

CREATE INDEX ON loans_items (current_item_effective_location_name);

CREATE INDEX ON loans_items (current_item_permanent_location_name);

CREATE INDEX ON loans_items (current_item_temporary_location_name);

CREATE INDEX ON loans_items (current_item_permanent_location_library_name);

CREATE INDEX ON loans_items (current_item_permanent_location_campus_name);

CREATE INDEX ON loans_items (current_item_permanent_location_institution_name);

CREATE INDEX ON loans_items (checkin_service_point_name);

CREATE INDEX ON loans_items (checkout_service_point_name);

CREATE INDEX ON loans_items (in_transit_destination_service_point_name);

CREATE INDEX ON loans_items (patron_group_name);

CREATE INDEX ON loans_items (material_type_name);

CREATE INDEX ON loans_items (permanent_loan_type_name);

CREATE INDEX ON loans_items (temporary_loan_type_name);

CREATE INDEX ON loans_items (loan_id);

CREATE INDEX ON loans_items (item_id);

CREATE INDEX ON loans_items (loan_return_date);

CREATE INDEX ON loans_items (system_return_date);

CREATE INDEX ON loans_items (checkin_service_point_id);

CREATE INDEX ON loans_items (checkout_service_point_id);

CREATE INDEX ON loans_items (item_effective_location_id_at_check_out);

CREATE INDEX ON loans_items (item_effective_location_name_at_check_out);

CREATE INDEX ON loans_items (in_transit_destination_service_point_id);

CREATE INDEX ON loans_items (current_item_effective_location_id);

CREATE INDEX ON loans_items (current_item_temporary_location_id);

CREATE INDEX ON loans_items (current_item_permanent_location_id);

CREATE INDEX ON loans_items (current_item_permanent_location_library_id);

CREATE INDEX ON loans_items (current_item_permanent_location_campus_id);

CREATE INDEX ON loans_items (current_item_permanent_location_institution_id);

CREATE INDEX ON loans_items (loan_policy_id);

CREATE INDEX ON loans_items (loan_policy_name);

CREATE INDEX ON loans_items (lost_item_policy_id);

CREATE INDEX ON loans_items (lost_item_policy_name);

CREATE INDEX ON loans_items (overdue_fine_policy_id);

CREATE INDEX ON loans_items (overdue_fine_policy_name);

CREATE INDEX ON loans_items (patron_group_id_at_checkout);

CREATE INDEX ON loans_items (user_id);

CREATE INDEX ON loans_items (proxy_user_id);

CREATE INDEX ON loans_items (barcode);

CREATE INDEX ON loans_items (chronology);

CREATE INDEX ON loans_items (copy_number);

CREATE INDEX ON loans_items (enumeration);

CREATE INDEX ON loans_items (holdings_record_id);

CREATE INDEX ON loans_items (hrid);

CREATE INDEX ON loans_items (item_level_call_number);

CREATE INDEX ON loans_items (material_type_id);

CREATE INDEX ON loans_items (number_of_pieces);

CREATE INDEX ON loans_items (permanent_loan_type_id);

CREATE INDEX ON loans_items (temporary_loan_type_id);

CREATE INDEX ON loans_items (renewal_count);

VACUUM ANALYZE loans_items;

