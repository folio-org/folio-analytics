-- this query depends on locations_libraries, so that
-- should be run before this one
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

DROP TABLE IF EXISTS loans_items;

CREATE TABLE loans_items AS
SELECT
    cl.id AS loan_id,
    cl.item_id,
    cl.item_status,
    json_extract_path_text(cl.data, 'status', 'name') AS loan_status,
    cl.loan_date,
    cl.due_date AS loan_due_date,
    cl.return_date AS loan_return_date,
    json_extract_path_text(cl.data, 'systemReturnDate')::timestamptz AS system_return_date,
    json_extract_path_text(cl.data, 'checkinServicePointId') AS checkin_service_point_id,
    ispi.discovery_display_name AS checkin_service_point_name,
    json_extract_path_text(cl.data, 'checkoutServicePointId') AS checkout_service_point_id,
    ispo.discovery_display_name AS checkout_service_point_name,
    json_extract_path_text(cl.data, 'itemEffectiveLocationIdAtCheckOut') AS item_effective_location_id_at_check_out,
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
    json_extract_path_text(cl.data, 'loanPolicyId') AS loan_policy_id,
    clp.name AS loan_policy_name,
    json_extract_path_text(cl.data, 'lostItemPolicyId') AS lost_item_policy_id,
    ffl.name AS lost_item_policy_name,
    json_extract_path_text(cl.data, 'overdueFinePolicyId') AS overdue_fine_policy_id,
    ffo.name AS overdue_fine_policy_name,
    json_extract_path_text(cl.data, 'patronGroupIdAtCheckout') AS patron_group_id_at_checkout,
    ug.group AS patron_group_name,
    json_extract_path_text(cl.data, 'userId') AS user_id,
    json_extract_path_text(cl.data, 'proxyUserId') AS proxy_user_id,
    ii.barcode,
    json_extract_path_text(ii.data, 'chronology') AS chronology,
    json_extract_path_text(ii.data, 'copyNumber') AS copy_number,
    json_extract_path_text(ii.data, 'enumeration') AS enumeration,
    ii.holdings_record_id,
    ii.hrid,
    ii.item_level_call_number AS item_level_call_number,
    ii.effective_call_number_components__call_number AS item_effective_call_number,
    ii.effective_call_number_components__prefix AS item_effective_call_number_prefix,
    json_extract_path_text(ii.data, 'effectiveCallNumberComponents', 'suffix') AS item_effective_call_number_suffix,
    ii.material_type_id,
    imt.name AS material_type_name,
    json_extract_path_text(ii.data, 'numberOfPieces') AS number_of_pieces,
    ii.permanent_loan_type_id,
    iltp.name AS permanent_loan_type_name,
    json_extract_path_text(ii.data, 'temporaryLoanTypeId') AS temporary_loan_type_id,
    iltt.name AS temporary_loan_type_name,
    json_extract_path_text(cl.data, 'renewalCount')::bigint AS renewal_count
FROM
    circulation_loans AS cl
    LEFT JOIN inventory_items AS ii ON cl.item_id = ii.id
    LEFT JOIN inventory_material_types AS imt ON ii.material_type_id = imt.id
    LEFT JOIN circulation_loan_policies AS clp ON json_extract_path_text(cl.data, 'loanPolicyId') = clp.id
    LEFT JOIN user_groups AS ug ON json_extract_path_text(cl.data, 'patronGroupIdAtCheckout') = ug.id
    LEFT JOIN inventory_locations AS iel ON ii.effective_location_id = iel.id
    LEFT JOIN inventory_locations AS ipl ON json_extract_path_text(ii.data, 'permanentLocationId') = ipl.id
    LEFT JOIN locations_libraries AS ll ON ipl.id = ll.location_id
    LEFT JOIN inventory_locations AS itl ON json_extract_path_text(ii.data, 'temporaryLocationId') = itl.id
    LEFT JOIN inventory_locations AS icl ON json_extract_path_text(cl.data, 'itemEffectiveLocationIdAtCheckOut') = icl.id
    LEFT JOIN inventory_service_points AS ispi ON json_extract_path_text(cl.data, 'checkinServicePointId') = ispi.id
    LEFT JOIN inventory_service_points AS ispo ON json_extract_path_text(cl.data, 'checkoutServicePointId') = ispo.id
    LEFT JOIN inventory_service_points AS ispt ON json_extract_path_text(ii.data, 'inTransitDestinationServicePointId') = ispt.id
    LEFT JOIN inventory_loan_types AS iltp ON json_extract_path_text(ii.data, 'temporaryLoanTypeId') = iltp.id
    LEFT JOIN inventory_loan_types AS iltt ON ii.permanent_loan_type_id = iltt.id
    LEFT JOIN feesfines_overdue_fines_policies AS ffo ON json_extract_path_text(cl.data, 'overdueFinePolicyId') = ffo.id
    LEFT JOIN feesfines_lost_item_fees_policies AS ffl ON json_extract_path_text(cl.data, 'lostItemPolicyId') = ffl.id;

COMMENT ON COLUMN loans_items.loan_id IS 'UUID of the loan';

COMMENT ON COLUMN loans_items.item_id IS 'UUID of the item lent to the patron';

COMMENT ON COLUMN loans_items.item_status IS 'Name of the status e.g. Available, Checked out, In transit';

COMMENT ON COLUMN loans_items.loan_status IS 'Name of the status (currently can be any value, values commonly used are Open and Closed)';

COMMENT ON COLUMN loans_items.loan_date IS 'Date time when the loan began (typically represented according to rfc3339 section-5.6. Has not had the date-time format validation applied as was not supported at point of introduction and would now be a breaking ''CHANGE'')';

COMMENT ON COLUMN loans_items.loan_due_date IS 'Date time when the item is due to be returned';

COMMENT ON COLUMN loans_items.loan_return_date IS 'Date time when the item is returned and the loan ends.';

COMMENT ON COLUMN loans_items.system_return_date IS 'Date time when the returned item is actually processed';

COMMENT ON COLUMN loans_items.checkin_service_point_id IS 'UUIID of the Service Point where the last checkout occured';;

COMMENT ON COLUMN loans_items.checkin_service_point_name IS 'Name of the Service Point where the last checkin occured';

COMMENT ON COLUMN loans_items.checkout_service_point_id IS 'UUID of the Service Point where the last checkin occured';

COMMENT ON COLUMN loans_items.checkout_service_point_name IS 'Name of the Service Point where the last checkout occured';

COMMENT ON COLUMN loans_items.item_effective_location_id_at_check_out IS 'UUID of the effective location, at the time of checkout, of the item loaned to the patron.';

COMMENT ON COLUMN loans_items.item_effective_location_name_at_check_out IS 'Name of the effective location, at the time of checkout, of the item loaned to the patron.';

COMMENT ON COLUMN loans_items.in_transit_destination_service_point_id IS 'UUID of the ervice point an item is intended to be transited to (should only be present when in transit)';

COMMENT ON COLUMN loans_items.in_transit_destination_service_point_name IS 'Name of the ervice point an item is intended to be transited to (should only be present when in transit)';

COMMENT ON COLUMN loans_items.current_item_effective_location_id IS 'UUID of the effective shelving location in which an item resides';

COMMENT ON COLUMN loans_items.current_item_effective_location_name IS 'Name of the effective shelving location in which an item resides';

COMMENT ON COLUMN loans_items.current_item_temporary_location_id IS 'UUID of the temporary shelving location in which an item resides';

COMMENT ON COLUMN loans_items.current_item_temporary_location_name IS 'Temporary location, shelving location, or holding which is a physical place where items are stored, or an Online location';

COMMENT ON COLUMN loans_items.current_item_permanent_location_id IS 'UUID permanent shelving location in which an item resides';

COMMENT ON COLUMN loans_items.current_item_permanent_location_name IS 'Name of the permanent shelving location in which an item resides';

COMMENT ON COLUMN loans_items.current_item_permanent_location_library_id IS 'UUID of the permanent library name in which permanent location resides.';

COMMENT ON COLUMN loans_items.current_item_permanent_location_library_name IS 'Name of the permanent library name in which permanent location resides.';

COMMENT ON COLUMN loans_items.current_item_permanent_location_campus_id IS 'UUID of the permanent campus name in which library resides';

COMMENT ON COLUMN loans_items.current_item_permanent_location_campus_name IS 'Permanent campus name in which library resides';

COMMENT ON COLUMN loans_items.current_item_permanent_location_institution_id IS 'UUID of the permanent institution name in which campus resides';

COMMENT ON COLUMN loans_items.current_item_permanent_location_institution_name IS 'Permanent institution name in which campus resides';

COMMENT ON COLUMN loans_items.loan_policy_id IS 'UUID of last policy used in relation to this loan';

COMMENT ON COLUMN loans_items.loan_policy_name IS 'Name of last policy used in relation to this loan';

COMMENT ON COLUMN loans_items.lost_item_policy_id IS 'UUID of lost item policy which determines when the item ages to lost and the associated fees or the associated fees if the patron declares the item lost.';

COMMENT ON COLUMN loans_items.lost_item_policy_name IS 'Name of lost item policy which determines when the item ages to lost and the associated fees or the associated fees if the patron declares the item lost.';

COMMENT ON COLUMN loans_items.overdue_fine_policy_id IS 'UUID of overdue fines policy at the time the item is check-in or renewed';

COMMENT ON COLUMN loans_items.overdue_fine_policy_name IS 'Name of overdue fines policy at the time the item is check-in or renewed';

COMMENT ON COLUMN loans_items.patron_group_id_at_checkout IS 'Patron Group Id at checkout';

COMMENT ON COLUMN loans_items.patron_group_name IS 'Name of patron Group Id at checkout';

COMMENT ON COLUMN loans_items.user_id IS 'A globally unique (UUID) identifier for the user';

COMMENT ON COLUMN loans_items.proxy_user_id IS 'UUID of the user representing a proxy for the patron';

COMMENT ON COLUMN loans_items.barcode IS 'Unique inventory control number for physical resources';

COMMENT ON COLUMN loans_items.chronology IS 'Chronology is the descriptive information for the dating scheme of a serial';

COMMENT ON COLUMN loans_items.copy_number IS 'Piece identifier. The copy number reflects if the library has a copy of a single-volume monograph';

COMMENT ON COLUMN loans_items.enumeration IS 'Descriptive information for the numbering scheme of a serial';

COMMENT ON COLUMN loans_items.holdings_record_id IS 'UUID of the holdings record the item is a member of.';

COMMENT ON COLUMN loans_items.hrid IS 'Human readable id of the item record';

COMMENT ON COLUMN loans_items.item_level_call_number IS 'The Item level call number';

COMMENT ON COLUMN loans_items.item_effective_call_number IS 'Effective Call Number is an identifier assigned to an item or its holding and associated with the item';

COMMENT ON COLUMN loans_items.item_effective_call_number_prefix IS 'Effective Call Number Prefix is the prefix of the identifier assigned to an item or its holding and associated with the item';

COMMENT ON COLUMN loans_items.item_effective_call_number_suffix IS 'Effective Call Number Suffix is the suffix of the identifier assigned to an item or its holding and associated with the item';

COMMENT ON COLUMN loans_items.material_type_id IS 'UUID of the Item''s material type';

COMMENT ON COLUMN loans_items.material_type_name IS 'Item''s material type name';

COMMENT ON COLUMN loans_items.number_of_pieces IS 'Number of pieces on the item record';

COMMENT ON COLUMN loans_items.permanent_loan_type_id IS 'UUID of the permanent loan type, is the default loan type for a given item. Loan types are tenant-defined.';

COMMENT ON COLUMN loans_items.permanent_loan_type_name IS 'Name of the permanent loan type, is the default loan type for a given item.';

COMMENT ON COLUMN loans_items.temporary_loan_type_id IS 'Temporary loan type, is the temporary loan type for a given item.';

COMMENT ON COLUMN loans_items.temporary_loan_type_name IS 'Name of the temporary loan type, is the temporary loan type for a given item.';

COMMENT ON COLUMN loans_items.renewal_count IS 'Count of how many times a loan has been renewed (incremented by the client)';
