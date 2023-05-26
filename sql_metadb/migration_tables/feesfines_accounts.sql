DROP TABLE IF EXISTS feesfines_accounts;

CREATE TABLE feesfines_accounts AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'amount')::numeric(12,2) AS amount,
    jsonb_extract_path_text(jsonb, 'barcode')::varchar(65535) AS barcode,
    jsonb_extract_path_text(jsonb, 'callNumber')::varchar(65535) AS call_number,
    jsonb_extract_path_text(jsonb, 'dateCreated')::timestamptz AS date_created,
    jsonb_extract_path_text(jsonb, 'dateUpdated')::timestamptz AS date_updated,
    jsonb_extract_path_text(jsonb, 'dueDate')::timestamptz AS due_date,
    jsonb_extract_path_text(jsonb, 'feeFineId')::varchar(36) AS fee_fine_id,
    jsonb_extract_path_text(jsonb, 'feeFineOwner')::varchar(65535) AS fee_fine_owner,
    jsonb_extract_path_text(jsonb, 'feeFineType')::varchar(65535) AS fee_fine_type,
    jsonb_extract_path_text(jsonb, 'holdingsRecordId')::varchar(36) AS holdings_record_id,
    jsonb_extract_path_text(jsonb, 'instanceId')::varchar(36) AS instance_id,
    jsonb_extract_path_text(jsonb, 'itemId')::varchar(36) AS item_id,
    jsonb_extract_path_text(jsonb, 'loanId')::varchar(36) AS loan_id,
    jsonb_extract_path_text(jsonb, 'location')::varchar(65535) AS location,
    jsonb_extract_path_text(jsonb, 'materialType')::varchar(65535) AS material_type,
    jsonb_extract_path_text(jsonb, 'materialTypeId')::varchar(36) AS material_type_id,
    jsonb_extract_path_text(jsonb, 'ownerId')::varchar(36) AS owner_id,
    jsonb_extract_path_text(jsonb, 'remaining')::numeric(12,2) AS remaining,
    jsonb_extract_path_text(jsonb, 'title')::varchar(65535) AS title,
    jsonb_extract_path_text(jsonb, 'userId')::varchar(36) AS user_id,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_feesfines.accounts;

