DROP TABLE IF EXISTS feesfines_lost_item_fees_policies;

CREATE TABLE feesfines_lost_item_fees_policies AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'chargeAmountItemPatron')::boolean AS charge_amount_item_patron,
    jsonb_extract_path_text(jsonb, 'chargeAmountItemSystem')::boolean AS charge_amount_item_system,
    jsonb_extract_path_text(jsonb, 'description')::varchar(65535) AS description,
    jsonb_extract_path_text(jsonb, 'lostItemProcessingFee')::numeric(12,2) AS lost_item_processing_fee,
    jsonb_extract_path_text(jsonb, 'lostItemReturned')::varchar(65535) AS lost_item_returned,
    jsonb_extract_path_text(jsonb, 'name')::varchar(65535) AS name,
    jsonb_extract_path_text(jsonb, 'replacedLostItemProcessingFee')::boolean AS replaced_lost_item_processing_fee,
    jsonb_extract_path_text(jsonb, 'replacementAllowed')::boolean AS replacement_allowed,
    jsonb_extract_path_text(jsonb, 'replacementProcessingFee')::numeric(12,2) AS replacement_processing_fee,
    jsonb_extract_path_text(jsonb, 'returnedLostItemProcessingFee')::boolean AS returned_lost_item_processing_fee,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_feesfines.lost_item_fee_policy;

