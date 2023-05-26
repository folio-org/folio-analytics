DROP TABLE IF EXISTS finance_ledgers;

CREATE TABLE finance_ledgers AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'code')::varchar(65535) AS code,
    jsonb_extract_path_text(jsonb, 'currency')::varchar(65535) AS currency,
    jsonb_extract_path_text(jsonb, 'description')::varchar(65535) AS description,
    jsonb_extract_path_text(jsonb, 'fiscalYearOneId')::varchar(36) AS fiscal_year_one_id,
    jsonb_extract_path_text(jsonb, 'ledgerStatus')::varchar(65535) AS ledger_status,
    jsonb_extract_path_text(jsonb, 'name')::varchar(65535) AS name,
    jsonb_extract_path_text(jsonb, 'restrictEncumbrance')::boolean AS restrict_encumbrance,
    jsonb_extract_path_text(jsonb, 'restrictExpenditures')::boolean AS restrict_expenditures,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_finance.ledger;

