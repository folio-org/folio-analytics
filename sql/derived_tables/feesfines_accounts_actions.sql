DROP TABLE IF EXISTS LOCAL.feesfines_accounts_actions;

--Create a derived table that takes feesfines_accounts as the main table
--join all transaction data from the feesfines_actions table
--add patron group information from user_group table

CREATE TABLE LOCAL.feesfines_accounts_actions AS
SELECT
    fa.id AS fine_account_id,
    fa.amount AS fine_account_amount,
    --date_created AS fine_date, (not yet in snapshot)
    --date_updated AS fine_updated_date (not yet in snapshot)
    fa.fee_fine_id,
    fa.owner_id, 
    fa.fee_fine_owner,
    fa.fee_fine_type,
    fa.material_type_id, 
    fa.material_type,
    json_extract_path_text(fa.data, 'payment_status') AS payment_status,
    json_extract_path_text(fa.data, 'status') AS fine_status, --open or closed
    fa.user_id,
    ff.id AS transaction_id,
    ff.account_id, 
    ff.amount_action AS transaction_amount,
    ff.balance AS account_balance,
    ff.type_action,
    ff.date_action AS transaction_date,
    ff.created_at AS transaction_location,
    ff.transaction_information,
    ff.source AS operator_id,
    --ff.payment_method (not yet in snapshot)
    uu.id AS user_id, 
    uu.patron_group AS patron_group_id,
    ug.id AS patron_group_id, 
    ug.group AS patron_group_name
FROM
    public.feesfines_accounts AS fa
    LEFT JOIN public.feesfines_feefineactions AS ff ON fa.id = ff.account_id
    LEFT JOIN public.user_users AS uu ON fa.user_id = uu.id
    LEFT JOIN user_groups AS ug ON uu.patron_group = ug.id
   ;

CREATE INDEX ON local.feesfines_accounts_actions (fine_Account_id);

CREATE INDEX ON LOCAL.feesfines_accounts_actions (fee_fine_id);

CREATE INDEX ON LOCAL.feesfines_accounts_actions (owner_id);

CREATE INDEX ON LOCAL.feesfines_accounts_actions (fee_fine_owner);

CREATE INDEX ON LOCAL.feesfines_accounts_actions (fee_fine_type);

CREATE INDEX ON LOCAL.feesfines_accounts_actions (material_type_id);

CREATE INDEX ON LOCAL.feesfines_accounts_actions (material_type);

CREATE INDEX ON LOCAL.feesfines_accounts_actions (payment_status);

CREATE INDEX ON LOCAL.feesfines_accounts_actions (fine_status);

CREATE INDEX ON LOCAL.feesfines_accounts_actions (user_id);

CREATE INDEX ON LOCAL.feesfines_accounts_actions (transaction_id);

CREATE INDEX ON LOCAL.feesfines_accounts_actions (account_balance);

CREATE INDEX ON LOCAL.feesfines_accounts_actions (type_action);

CREATE INDEX ON LOCAL.feesfines_accounts_actions (transaction_date);

CREATE INDEX ON LOCAL.feesfines_accounts_actions (transaction_information);

CREATE INDEX ON LOCAL.feesfines_accounts_actions (operator_id);

CREATE INDEX ON LOCAL.feesfines_accounts_actions (patron_group_id);

CREATE INDEX ON LOCAL.feesfines_accounts_actions (patron_group_name);

--CREATE INDEX ON LOCAL.feesfines_accounts_actions (fine_date);
--CREATE INDEX ON LOCAL.feesfines_accounts_actions (fine_updated_date);
--CREATE INDEX ON LOCAL.feesfines_accounts_actions (payment_method);