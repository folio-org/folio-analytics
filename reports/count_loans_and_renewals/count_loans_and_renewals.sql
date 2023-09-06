-- Report produces a list of individual loans which can then be
-- grouped and summed to create loans and renewals counts.

DROP FUNCTION IF EXISTS count_loans_and_renewals;

CREATE FUNCTION count_loans_and_renewals(
    /* Choose a start and end date for the loans period */
    start_date date DEFAULT '2000-01-01',
    end_date date DEFAULT '2050-01-01',
    /* Specify one of the following to filter by location */
    items_permanent_location_filter text DEFAULT 'Main Library', -- 'Online', 'Annex', 'Main Library'
    items_temporary_location_filter text DEFAULT '', -- 'Online', 'Annex', 'Main Library'
    items_effective_location_filter text DEFAULT '', -- 'Online', 'Annex', 'Main Library'
    /* The following connect to the item's permanent location */
    institution_filter text DEFAULT '', -- 'KÃ¸benhavns Universitet', 'Montoya College'
    campus_filter text DEFAULT '', -- 'Main Campus', 'City Campus', 'Online'
    library_filter text DEFAULT '') -- 'Datalogisk Institut', 'Adelaide Library'
RETURNS TABLE(
    date_range text,
    loan_date date,
    loan_due_date timestamptz,
    loan_return_date timestamptz,
    loan_status text,
    num_loans integer,
    num_renewals bigint,
    patron_group_name text,
    material_type_name text,
    loan_policy_name text,
    permanent_loan_type_name text,
    temporary_loan_type_name text,
    permanent_location_name text,
    temporary_location_name text,
    effective_location_name text,
    permanent_location_library_name text,
    permanent_location_campus_name text,
    permanent_location_institution_name text) AS
$$
SELECT start_date || ' to ' || end_date AS date_range,
       loan_date::date,
       loan_due_date AS loan_due_date,
       loan_return_date AS loan_return_date,
       loan_status AS loan_status,
       1 AS num_loans, -- Each row is a single loan.
       renewal_count AS num_renewals,
       patron_group_name AS patron_group_name,
       material_type_name AS material_type_name,
       loan_policy_name AS loan_policy_name,
       permanent_loan_type_name AS permanent_loan_type_name,
       temporary_loan_type_name AS temporary_loan_type_name,
       current_item_permanent_location_name AS permanent_location_name,
       current_item_temporary_location_name AS temporary_location_name,
       current_item_effective_location_name AS effective_location_name,
       current_item_permanent_location_library_name AS permanent_location_library_name,
       current_item_permanent_location_campus_name AS permanent_location_campus_name,
       current_item_permanent_location_institution_name AS permanent_location_institution_name
    FROM folio_derived.loans_items
    WHERE start_date <= loan_date AND loan_date < end_date AND
          items_permanent_location_filter IN (current_item_permanent_location_name, '') AND
          items_temporary_location_filter IN (current_item_temporary_location_name, '') AND
          items_effective_location_filter IN (current_item_effective_location_name, '') AND
          library_filter IN (current_item_permanent_location_library_name, '') AND
          campus_filter IN (current_item_permanent_location_campus_name, '') AND
          institution_filter IN (current_item_permanent_location_institution_name, '')
$$
LANGUAGE SQL
STABLE
PARALLEL SAFE;
