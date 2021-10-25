DROP TABLE IF EXISTS folio_derived.holdings_ext;

-- Create an extended holdings table which includes the name for call number type, holdings type, interlibrary loan policy, 
-- permanent location, and temporary location.
-- Holdings notes are in a separate derived table.
CREATE TABLE folio_derived.holdings_ext AS
WITH holdings AS (
    SELECT
        h.id,
        h.hrid,
        h.acquisition_method,
        h.call_number,
        -- call_number_prefix,
        -- call_number_suffix,
        h.call_number_type_id,
        h.copy_number,
        h.holdings_type_id,
        h.ill_policy_id,
        h.instance_id,
        h.permanent_location_id,
        h.receipt_status,
        h.retention_policy,
        h.shelving_title,
        -- discovery_suppress,
	md.created_date,
	md.updated_by_user_id,
	md.updated_date,
        -- temporary_location_id
	'' AS temporary_location_id  -- temporary
    FROM
        folio_inventory.holdings_record_j AS h
	JOIN folio_inventory.holdings_record_j_metadata AS md ON h.id = md.id
)
SELECT
    holdings.id AS holdings_id,
    holdings.hrid AS holdings_hrid,
    holdings.acquisition_method,
    holdings.call_number,
    -- holdings.call_number_prefix,
    -- holdings.call_number_suffix,
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
    -- holdings.discovery_suppress,
    holdings.created_date,
    holdings.updated_by_user_id,
    holdings.updated_date
FROM
    holdings
    LEFT JOIN folio_inventory.holdings_type_j AS holdings_type ON holdings.holdings_type_id = holdings_type.id
    LEFT JOIN folio_inventory.ill_policy_j AS holdings_ill_policy ON holdings.ill_policy_id = holdings_ill_policy.id
    LEFT JOIN folio_inventory.call_number_type_j AS holdings_call_number_type ON holdings.call_number_type_id = holdings_call_number_type.id
    LEFT JOIN folio_inventory.location_j AS holdings_permanent_location ON holdings.permanent_location_id = holdings_permanent_location.id
    LEFT JOIN folio_inventory.location_j AS holdings_temporary_location ON holdings.temporary_location_id = holdings_temporary_location.id;

CREATE INDEX ON folio_derived.holdings_ext (holdings_id);

CREATE INDEX ON folio_derived.holdings_ext (holdings_hrid);

CREATE INDEX ON folio_derived.holdings_ext (acquisition_method);

CREATE INDEX ON folio_derived.holdings_ext (call_number);

-- CREATE INDEX ON folio_derived.holdings_ext (call_number_prefix);

-- CREATE INDEX ON folio_derived.holdings_ext (call_number_suffix);

CREATE INDEX ON folio_derived.holdings_ext (call_number_type_id);

CREATE INDEX ON folio_derived.holdings_ext (call_number_type_name);

CREATE INDEX ON folio_derived.holdings_ext (copy_number);

CREATE INDEX ON folio_derived.holdings_ext (type_id);

CREATE INDEX ON folio_derived.holdings_ext (type_name);

CREATE INDEX ON folio_derived.holdings_ext (ill_policy_id);

CREATE INDEX ON folio_derived.holdings_ext (ill_policy_name);

CREATE INDEX ON folio_derived.holdings_ext (instance_id);

CREATE INDEX ON folio_derived.holdings_ext (permanent_location_id);

CREATE INDEX ON folio_derived.holdings_ext (permanent_location_name);

CREATE INDEX ON folio_derived.holdings_ext (temporary_location_id);

CREATE INDEX ON folio_derived.holdings_ext (temporary_location_name);

CREATE INDEX ON folio_derived.holdings_ext (receipt_status);

CREATE INDEX ON folio_derived.holdings_ext (retention_policy);

CREATE INDEX ON folio_derived.holdings_ext (shelving_title);

-- CREATE INDEX ON folio_derived.holdings_ext (discovery_suppress);

CREATE INDEX ON folio_derived.holdings_ext (created_date);

CREATE INDEX ON folio_derived.holdings_ext (updated_by_user_id);

CREATE INDEX ON folio_derived.holdings_ext (updated_date);

