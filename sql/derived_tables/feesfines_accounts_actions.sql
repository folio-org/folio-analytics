DROP TABLE IF EXISTS feesfines_accounts_actions;

-- Create a derived table that takes feesfines_accounts as the main table
-- join all transaction data from the feesfines_actions table
-- add patron group information from user_group table
CREATE TABLE feesfines_accounts_actions AS
SELECT
    fa.id AS fine_account_id,
    (fa.data->>'amount')::numeric(12,2) AS fine_account_amount,
    fa.data->>'dateCreated' AS fine_date,
    fa.data->>'dateUpdated' AS fine_updated_date,
    fa.data->>'feeFineId' AS fee_fine_id,
    fa.data->>'ownerId' AS owner_id,
    fa.data->>'feeFineOwner' AS fee_fine_owner,
    fa.data->>'feeFineType' AS fee_fine_type,
    fa.data->>'materialTypeId' AS material_type_id,
    fa.data->>'materialType' AS material_type,
    fa.data->>'payment_status' AS payment_status,
    fa.data->'status'->>'name' AS fine_status, -- open or closed
    fa.data->>'userId' AS account_user_id,
    ff.id AS transaction_id,
    ff.data->>'accountId' AS account_id,
    (ff.data->>'amountAction')::numeric(12,2) AS transaction_amount,
    (ff.data->>'balance')::numeric(12,2) AS account_balance,
    ff.data->>'typeAction' AS type_action,
    ff.data->>'dateAction' AS transaction_date,
    ff.data->>'createdAt' AS transaction_location,
    ff.data->>'transactionInformation' AS transaction_information,
    ff.data->>'source' AS operator_id,
    ff.data->>'paymentMethod' AS payment_method,
    uu.id AS user_id,
    uu.patron_group AS user_patron_group_id,
    ug.id AS patron_group_id,
    ug.group AS patron_group_name
FROM
    feesfines_accounts AS fa
    LEFT JOIN feesfines_feefineactions AS ff ON fa.id = ff.data->>'accountId'
    LEFT JOIN user_users AS uu ON fa.data->>'userId' = uu.id
    LEFT JOIN user_groups AS ug ON uu.patron_group = ug.id;

