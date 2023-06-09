DROP TABLE IF EXISTS holdings_ext;

-- Create an extended holdings table which includes the name for call number type, holdings type, interlibrary loan policy, 
-- permanent location, and temporary location.
-- Holdings notes are in a separate derived table.
CREATE TABLE holdings_ext AS
SELECT
    holdings.id AS holdings_id,
    holdings.hrid AS holdings_hrid,
    holdings.acquisition_method,
    holdings.call_number,
    holdings.call_number_prefix,
    holdings.call_number_suffix,
    holdings.call_number_type_id,
    holdings_call_number_type.name AS call_number_type_name,
    holdings.copy_number,
    holdings.holdings_type_id AS type_id,
    holdings_type.name AS type_name,
    holdings.ill_policy_id,
    holdings_ill_policy.name AS ill_policy_name,
    holdings.instance_id,
    holdings.permanent_location_id,
    holdings_permanent_location.name AS permanent_location_name,
    holdings.temporary_location_id,
    holdings_temporary_location.name AS temporary_location_name,
    holdings.receipt_status,
    holdings.retention_policy,
    holdings.shelving_title,
    holdings.discovery_suppress,
    holdings.data->'metadata'->>'createdDate' AS created_date,
    holdings.data->'metadata'->>'updatedByUserId' AS updated_by_user_id,
    holdings.data->'metadata'->>'updatedDate' AS updated_date
FROM
    inventory_holdings AS holdings
    LEFT JOIN inventory_holdings_types AS holdings_type ON holdings.holdings_type_id = holdings_type.id
    LEFT JOIN inventory_ill_policies AS holdings_ill_policy ON holdings.ill_policy_id = holdings_ill_policy.id
    LEFT JOIN inventory_call_number_types AS holdings_call_number_type ON holdings.call_number_type_id = holdings_call_number_type.id
    LEFT JOIN inventory_locations AS holdings_permanent_location ON holdings.permanent_location_id = holdings_permanent_location.id
    LEFT JOIN inventory_locations AS holdings_temporary_location ON holdings.temporary_location_id = holdings_temporary_location.id;

