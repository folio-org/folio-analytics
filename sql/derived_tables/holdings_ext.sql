-- Create an extended holdings table which includes the name for call
-- number type, holdings type, interlibrary loan policy, permanent
-- location, and tempoary location.

CREATE TABLE local.holdings_ext AS
WITH holdings AS (
SELECT h.id,
       json_extract_path_text(h.data, 'acquisitionMethod')
               AS acquisition_method,
       h.call_number,
       json_extract_path_text(h.data, 'callNumberPrefix')
               AS call_number_prefix,
       json_extract_path_text(h.data, 'callNumberSuffix')
               AS call_number_suffix,
       h.call_number_type_id,
       h.copy_number,
       h.holdings_type_id,
       h.ill_policy_id,
       h.instance_id,
       h.permanent_location_id,
       json_extract_path_text(h.data, 'receiptStatus')
               AS receipt_status,
       json_extract_path_text(h.data, 'retentionPolicy')
               AS retention_policy,
       json_extract_path_text(h.data, 'shelvingTitle')
               AS shelving_title,
       json_extract_path_text(h.data, 'temporaryLocationId')
               AS temporary_location_id
    FROM inventory_holdings AS h
)
SELECT holdings.id AS holdings_id,
       holdings.acquisition_method,
       holdings.call_number,
       holdings.call_number_prefix,
       holdings.call_number_suffix,
       holdings.call_number_type_id,
       holdings_call_number_type.name AS holdings_call_number_type_name,
       holdings.copy_number,
       holdings.holdings_type_id,
       holdings_type.name AS holdings_type_name,
       holdings.ill_policy_id,
       holdings_ill_policy.name AS holdings_ill_policy_name,
       holdings.instance_id,
       holdings.permanent_location_id,
       holdings_permanent_location.name AS holdings_permanent_location_name,
       holdings.receipt_status,
       holdings.retention_policy,
       holdings.shelving_title,
       holdings.temporary_location_id,
       holdings_temporary_location.name AS holdings_temporary_location_name
    FROM holdings
        LEFT JOIN inventory_holdings_types AS holdings_type
	    ON holdings.holdings_type_id = holdings_type.id
        LEFT JOIN inventory_ill_policies AS holdings_ill_policy
	    ON holdings.ill_policy_id = holdings_ill_policy.id
        LEFT JOIN inventory_call_number_types AS holdings_call_number_type
	    ON holdings.call_number_type_id = holdings_call_number_type.id
        LEFT JOIN inventory_locations AS holdings_permanent_location
	    ON holdings.permanent_location_id = holdings_permanent_location.id
	LEFT JOIN inventory_locations AS holdings_temporary_location
	    ON holdings.temporary_location_id = holdings_temporary_location.id;

CREATE INDEX ON local.holdings_ext (holdings_id);
CREATE INDEX ON local.holdings_ext (acquisition_method);
CREATE INDEX ON local.holdings_ext (call_number);
CREATE INDEX ON local.holdings_ext (call_number_prefix);
CREATE INDEX ON local.holdings_ext (call_number_suffix);
CREATE INDEX ON local.holdings_ext (call_number_type_id);
CREATE INDEX ON local.holdings_ext (holdings_call_number_type_name);
CREATE INDEX ON local.holdings_ext (copy_number);
CREATE INDEX ON local.holdings_ext (holdings_type_id);
CREATE INDEX ON local.holdings_ext (holdings_type_name);
CREATE INDEX ON local.holdings_ext (ill_policy_id);
CREATE INDEX ON local.holdings_ext (holdings_ill_policy_name);
CREATE INDEX ON local.holdings_ext (instance_id);
CREATE INDEX ON local.holdings_ext (permanent_location_id);
CREATE INDEX ON local.holdings_ext (holdings_permanent_location_name);
CREATE INDEX ON local.holdings_ext (receipt_status);
CREATE INDEX ON local.holdings_ext (retention_policy);
CREATE INDEX ON local.holdings_ext (shelving_title);
CREATE INDEX ON local.holdings_ext (temporary_location_id);
CREATE INDEX ON local.holdings_ext (holdings_temporary_location_name);

VACUUM local.holdings_ext;
ANALYZE local.holdings_ext;
