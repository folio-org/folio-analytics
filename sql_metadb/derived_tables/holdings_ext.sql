DROP TABLE IF EXISTS folio_derived.holdings_ext;

-- Create an extended holdings table which includes the name for call number type, holdings type, interlibrary loan policy, 
-- permanent location, and temporary location.
-- Holdings notes are in a separate derived table.
CREATE TABLE folio_derived.holdings_ext AS
WITH holdings AS (
    SELECT
        h.id,
        json_extract_path_text(h.jsonb, 'hrid') AS hrid,
        json_extract_path_text(h.jsonb, 'acquisitionMethod') AS acquisition_method,
        json_extract_path_text(h.jsonb, 'callNumber') AS call_number,
        json_extract_path_text(h.jsonb, 'callNumberPrefix') AS call_number_prefix,
        json_extract_path_text(h.jsonb, 'callNumberSuffix') AS call_number_suffix,
        json_extract_path_text(h.jsonb, 'callNumberTypeId') AS call_number_type_id,
        json_extract_path_text(h.jsonb, 'copyNumber') AS copy_number,
        json_extract_path_text(h.jsonb, 'holdingsTypeId') AS holdings_type_id,
        json_extract_path_text(h.jsonb, 'illPolicyId') AS ill_policy_id,
        json_extract_path_text(h.jsonb, 'instanceId') AS instance_id,
        json_extract_path_text(h.jsonb, 'permanentLocationId') AS permanent_location_id,
        json_extract_path_text(h.jsonb, 'receiptStatus') AS receipt_status,
        json_extract_path_text(h.jsonb, 'retentionPolicy') AS retention_policy,
        json_extract_path_text(h.jsonb, 'shelvingTitle') AS shelving_title,
        json_extract_path_text(h.jsonb, 'discoverySuppress') AS discovery_suppress,
        json_extract_path_text(h.jsonb, 'metadata', 'createdDate') AS created_date,
        json_extract_path_text(h.jsonb, 'metadata', 'createdByUserId') AS updated_by_user_id,
        json_extract_path_text(h.jsonb, 'metadata', 'updatedDate') AS updated_date,
        json_extract_path_text(h.jsonb, 'temporaryLocationId') AS temporary_location_id
    FROM
        folio_inventory.holdings_record AS h
)
SELECT
    holdings.id AS holdings_id,
    holdings.hrid AS holdings_hrid,
    holdings.acquisition_method,
    holdings.call_number,
    holdings.call_number_prefix,
    holdings.call_number_suffix,
    holdings.call_number_type_id,
    json_extract_path_text(holdings_call_number_type.jsonb, 'name') AS call_number_type_name,
    holdings.copy_number,
    holdings.holdings_type_id AS type_id,
    json_extract_path_text(holdings_type.jsonb, 'name') AS type_name,
    holdings.ill_policy_id,
    json_extract_path_text(holdings_ill_policy.jsonb, 'name') AS ill_policy_name,
    holdings.instance_id,
    holdings.permanent_location_id,
    json_extract_path_text(holdings_permanent_location.jsonb, 'name') AS permanent_location_name,
    holdings.temporary_location_id,
    json_extract_path_text(holdings_temporary_location.jsonb, 'name') AS temporary_location_name,
    holdings.receipt_status,
    holdings.retention_policy,
    holdings.shelving_title,
    holdings.discovery_suppress,
    holdings.created_date,
    holdings.updated_by_user_id,
    holdings.updated_date
FROM
    holdings
    LEFT JOIN folio_inventory.holdings_type AS holdings_type ON holdings.holdings_type_id = holdings_type.id
    LEFT JOIN folio_inventory.ill_policy AS holdings_ill_policy ON holdings.ill_policy_id = holdings_ill_policy.id
    LEFT JOIN folio_inventory.call_number_type AS holdings_call_number_type ON holdings.call_number_type_id = holdings_call_number_type.id
    LEFT JOIN folio_inventory.location AS holdings_permanent_location ON holdings.permanent_location_id = holdings_permanent_location.id
    LEFT JOIN folio_inventory.location AS holdings_temporary_location ON holdings.temporary_location_id = holdings_temporary_location.id;

CREATE INDEX ON folio_derived.holdings_ext (holdings_id);

CREATE INDEX ON folio_derived.holdings_ext (holdings_hrid);

CREATE INDEX ON folio_derived.holdings_ext (acquisition_method);

CREATE INDEX ON folio_derived.holdings_ext (call_number);

CREATE INDEX ON folio_derived.holdings_ext (call_number_prefix);

CREATE INDEX ON folio_derived.holdings_ext (call_number_suffix);

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

CREATE INDEX ON folio_derived.holdings_ext (discovery_suppress);

CREATE INDEX ON folio_derived.holdings_ext (created_date);

CREATE INDEX ON folio_derived.holdings_ext (updated_by_user_id);

CREATE INDEX ON folio_derived.holdings_ext (updated_date);

