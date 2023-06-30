DROP TABLE IF EXISTS finance_funds;

CREATE TABLE finance_funds AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'code')::varchar(65535) AS code,
    jsonb_extract_path_text(jsonb, 'description')::varchar(65535) AS description,
    jsonb_extract_path_text(jsonb, 'external_account_no')::varchar(65535) AS external_account_no,
    jsonb_extract_path_text(jsonb, 'fund_status')::varchar(65535) AS fund_status,
    jsonb_extract_path_text(jsonb, 'fund_type_id')::varchar(36) AS fund_type_id,
    jsonb_extract_path_text(jsonb, 'ledger_id')::varchar(36) AS ledger_id,
    jsonb_extract_path_text(jsonb, 'name')::varchar(65535) AS name,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_finance.fund;

