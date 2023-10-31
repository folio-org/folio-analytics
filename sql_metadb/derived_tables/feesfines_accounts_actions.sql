--metadb:table feesfines_accounts_actions	

DROP TABLE IF EXISTS feesfines_accounts_actions;

CREATE TABLE feesfines_accounts_actions AS

SELECT
    fa.id AS fine_account_id,
    jsonb_extract_path_text(fa.jsonb, 'amount')::numeric(12,2) AS fine_account_amount,
    fa.creation_date::timestamptz AS fine_date, 
    jsonb_extract_path_text(fa.jsonb, 'metadata','updatedDate')::timestamptz AS fine_updated_date,
    jsonb_extract_path_text(fa.jsonb, 'feeFineId')::uuid AS fee_fine_id,
    jsonb_extract_path_text(fa.jsonb, 'ownerId')::uuid AS owner_id,
    jsonb_extract_path_text(fa.jsonb, 'feeFineOwner') AS fee_fine_owner,
    jsonb_extract_path_text(fa.jsonb, 'feeFineType') AS fee_fine_type,
    jsonb_extract_path_text(fa.jsonb, 'materialTypeId')::uuid AS material_type_id,
    jsonb_extract_path_text(fa.jsonb, 'materialType') AS material_type,
    jsonb_extract_path_text(fa.jsonb, 'paymentStatus', 'name') AS payment_status_name,
    jsonb_extract_path_text(fa.jsonb, 'status', 'name') AS fine_status, -- open or closed
    jsonb_extract_path_text(fa.jsonb, 'userId')::uuid AS account_user_id,
    ff.id AS transaction_id,
    jsonb_extract_path_text(ff.jsonb, 'amountAction')::numeric(12,2) AS transaction_amount,
    jsonb_extract_path_text(ff.jsonb, 'balance')::numeric(12,2) AS account_balance,
    jsonb_extract_path_text(ff.jsonb, 'typeAction') AS type_action,
    jsonb_extract_path_text(ff.jsonb, 'dateAction')::timestamptz AS transaction_date,
    jsonb_extract_path_text(ff.jsonb, 'createdAt') AS transaction_location,
    jsonb_extract_path_text(ff.jsonb, 'transactionInformation') AS transaction_information,
    jsonb_extract_path_text(ff.jsonb, 'source') AS action_created_by,
    jsonb_extract_path_text(ff.jsonb, 'paymentMethod') AS payment_method,
    uu.id AS user_id,
    uu.patron_group AS user_patron_group_id,
    ug.group AS patron_group_name,
CASE WHEN
    jsonb_extract_path_text(ff.jsonb, 'typeAction') IN
    ('Paid partially','Paid fully','Waived partially','Waived fully','Credited partially','Credited fully')
    THEN jsonb_extract_path_text(ff.jsonb, 'amountAction')::numeric(12,2) * -1
    ELSE jsonb_extract_path_text(ff.jsonb, 'amountAction')::numeric(12,2)
    END AS signed_transaction_amount
FROM
    folio_feesfines.accounts AS fa
    LEFT JOIN folio_feesfines.feefineactions AS ff ON fa.id = jsonb_extract_path_text(ff.jsonb, 'accountId')::uuid
    LEFT JOIN folio_users.users__t AS uu ON jsonb_extract_path_text(fa.jsonb, 'userId')::uuid = uu.id
    LEFT JOIN folio_users.groups__t AS ug ON uu.patron_group = ug.id
ORDER BY fine_account_id, transaction_date;

COMMENT ON COLUMN feesfines_accounts_actions.fine_account_id IS 'User fine/fee account id, UUID'

COMMENT ON COLUMN feesfines_accounts_actions.fine_account_amount IS 'Amount of the fine/fee'

COMMENT ON COLUMN feesfines_accounts_actions.fine_date IS 'Date and time the account of the fine/fee was created'

COMMENT ON COLUMN feesfines_accounts_actions.fine_updated_date IS 'Date and time the account of the fine/fee was updated'

COMMENT ON COLUMN feesfines_accounts_actions.fee_fine_id IS 'ID of the fee/fine'

COMMENT ON COLUMN feesfines_accounts_actions.owner_id IS 'ID of the account owner'

COMMENT ON COLUMN feesfines_accounts_actions.fee_fine_owner IS 'Owner of the account'

COMMENT ON COLUMN feesfines_accounts_actions.fee_fine_type IS 'Fee/fine that is up to the desecration of the user'

COMMENT ON COLUMN feesfines_accounts_actions.material_type_id IS 'ID of the material type of the item'

COMMENT ON COLUMN feesfines_accounts_actions.material_type IS 'Material type of the item'

COMMENT ON COLUMN feesfines_accounts_actions.payment_status IS 'Overall status of the payment/waive/transfer/refund/cancel'

COMMENT ON COLUMN feesfines_accounts_actions.fine_status IS 'Overall status of the fee/fine'

COMMENT ON COLUMN feesfines_accounts_actions.account_user_id IS 'ID of the user'

COMMENT ON COLUMN feesfines_accounts_actions.transaction_id IS 'Fine/fee action id, UUID'

COMMENT ON COLUMN feesfines_accounts_actions.transaction_amount IS 'Amount of activity'

COMMENT ON COLUMN feesfines_accounts_actions.account_balance IS 'Calculated amount of remaining balance based on original fee/fine and what has been paid/waived/transferred/refunded'

COMMENT ON COLUMN feesfines_accounts_actions.type_action IS 'Type of activity including the type of transaction'

COMMENT ON COLUMN feesfines_accounts_actions.transaction_date IS 'Date and time the transaction of the fine/fee was created'

COMMENT ON COLUMN feesfines_accounts_actions.transaction_location IS 'The service point where the action was created'

COMMENT ON COLUMN feesfines_accounts_actions.transaction_information IS 'Number or other transaction id related to payment'

COMMENT ON COLUMN feesfines_accounts_actions.operator_id IS 'Person who processed activity (from login information)'

COMMENT ON COLUMN feesfines_accounts_actions.payment_method IS 'Overall status of the action-setting'

COMMENT ON COLUMN feesfines_accounts_actions.user_id IS 'User UUID'

COMMENT ON COLUMN feesfines_accounts_actions.user_patron_group_id IS 'UUID for user patron group'

COMMENT ON COLUMN feesfines_accounts_actions.patron_group_name IS 'User patron group'

COMMENT ON COLUMN feesfines_accounts_actions.signed_transaction_amount IS 'Identifies the type_action value that decreases the balance of the account and adds a - to those values'
