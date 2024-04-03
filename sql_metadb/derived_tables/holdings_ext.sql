--metadb:table holdings_ext
--metadb:require folio_inventory.ill_policy__t.id uuid
--metadb:require folio_inventory.ill_policy__t.name text
--metadb:require folio_inventory.holdings_record__t.call_number_prefix text
--metadb:require folio_inventory.holdings_record__t.call_number_suffix text

DROP TABLE IF EXISTS holdings_ext;

-- Create an extended holdings table which includes the name for call number type, holdings type, interlibrary loan policy,
-- permanent location, and temporary location.
-- Holdings notes are in a separate derived table.
CREATE TABLE holdings_ext AS
WITH holdings AS (
    SELECT
        h__t.id,
        h__t.hrid,
        jsonb_extract_path_text(h.jsonb, 'acquisitionMethod') AS acquisition_method,
        h__t.call_number,
        h__t.call_number_prefix,
        h__t.call_number_suffix,
        h__t.call_number_type_id,
        jsonb_extract_path_text(h.jsonb, 'copyNumber') AS copy_number,
        jsonb_extract_path_text(h.jsonb, 'holdingsTypeId')::uuid AS holdings_type_id,
        jsonb_extract_path_text(h.jsonb, 'illPolicyId') AS ill_policy_id,
        h__t.instance_id,
        h__t.permanent_location_id,
        jsonb_extract_path_text(h.jsonb, 'receiptStatus') AS receipt_status,
        jsonb_extract_path_text(h.jsonb, 'retentionPolicy') AS retention_policy,
        jsonb_extract_path_text(h.jsonb, 'shelvingTitle') AS shelving_title,
        jsonb_extract_path_text(h.jsonb, 'discoverySuppress') AS discovery_suppress,
        jsonb_extract_path_text(h.jsonb, 'metadata', 'createdDate') AS created_date,
        jsonb_extract_path_text(h.jsonb, 'metadata', 'createdByUserId') AS updated_by_user_id,
        jsonb_extract_path_text(h.jsonb, 'metadata', 'updatedDate') AS updated_date,
        jsonb_extract_path_text(h.jsonb, 'temporaryLocationId') AS temporary_location_id
    FROM
        folio_inventory.holdings_record AS h
        LEFT JOIN folio_inventory.holdings_record__t AS h__t ON h.id = h__t.id
)
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
    holdings.created_date,
    holdings.updated_by_user_id,
    holdings.updated_date
FROM
    holdings
    LEFT JOIN folio_inventory.holdings_type__t AS holdings_type ON holdings.holdings_type_id::uuid = holdings_type.id
    LEFT JOIN folio_inventory.ill_policy__t AS holdings_ill_policy ON holdings.ill_policy_id::uuid = holdings_ill_policy.id
    LEFT JOIN folio_inventory.call_number_type__t AS holdings_call_number_type ON holdings.call_number_type_id::uuid = holdings_call_number_type.id
    LEFT JOIN folio_inventory.location__t AS holdings_permanent_location ON holdings.permanent_location_id::uuid = holdings_permanent_location.id
    LEFT JOIN folio_inventory.location__t AS holdings_temporary_location ON holdings.temporary_location_id::uuid = holdings_temporary_location.id;
