--metadb:table feesfines_accounts_actions	

-- Create a derived table that takes feesfines_accounts as the main table
-- join all transaction data from the feesfines_actions table
-- add patron group information from user_group table

DROP TABLE IF EXISTS feesfines_accounts_actions;

CREATE TABLE feesfines_accounts_actions AS
SELECT
    fa.id AS fine_account_id,
    jsonb_extract_path_text(fa.jsonb, 'amount')::numeric(12,2) AS fine_account_amount,
    jsonb_extract_path_text(fa.jsonb, 'dateCreated')::timestamptz AS fine_date, 
    jsonb_extract_path_text(fa.jsonb, 'dateUpdated')::timestamptz AS fine_updated_date,
    jsonb_extract_path_text(fa.jsonb, 'feeFineId')::uuid AS fee_fine_id,
    jsonb_extract_path_text(fa.jsonb, 'ownerId')::uuid AS owner_id,
    jsonb_extract_path_text(fa.jsonb, 'feeFineOwner') AS fee_fine_owner,
    jsonb_extract_path_text(fa.jsonb, 'feeFineType') AS fee_fine_type,
    jsonb_extract_path_text(fa.jsonb, 'materialTypeId')::uuid AS material_type_id,
    jsonb_extract_path_text(fa.jsonb, 'materialType') AS material_type,
    jsonb_extract_path_text(fa.jsonb, 'payment_status') AS payment_status,
    jsonb_extract_path_text(fa.jsonb, 'status', 'name') AS fine_status, -- open or closed
    jsonb_extract_path_text(fa.jsonb, 'userId')::uuid AS account_user_id,
    ff.id AS transaction_id,
    jsonb_extract_path_text(ff.jsonb, 'accountId')::uuid AS account_id,
    jsonb_extract_path_text(ff.jsonb, 'amountAction')::numeric(12,2) AS transaction_amount,
    jsonb_extract_path_text(ff.jsonb, 'balance')::numeric(12,2) AS account_balance,
    jsonb_extract_path_text(ff.jsonb, 'typeAction') AS type_action,
    jsonb_extract_path_text(ff.jsonb, 'dateAction')::timestamptz AS transaction_date,
    jsonb_extract_path_text(ff.jsonb, 'createdAt') AS transaction_location,
    jsonb_extract_path_text(ff.jsonb, 'transactionInformation') AS transaction_information,
    jsonb_extract_path_text(ff.jsonb, 'source') AS operator_id,
    jsonb_extract_path_text(ff.jsonb, 'paymentMethod') AS payment_method,
    uu.id AS user_id,
    uu.patron_group AS user_patron_group_id,
    ug.id AS patron_group_id,
    ug.group AS patron_group_name
FROM
    folio_feesfines.accounts AS fa
    LEFT JOIN folio_feesfines.feefineactions AS ff ON fa.id = jsonb_extract_path_text(ff.jsonb, 'accountId')::uuid
    LEFT JOIN folio_users.users__t AS uu ON jsonb_extract_path_text(fa.jsonb, 'userId')::uuid = uu.id
    LEFT JOIN folio_users.groups__t AS ug ON uu.patron_group::uuid = ug.id
ORDER BY fine_account_id, transaction_date;

