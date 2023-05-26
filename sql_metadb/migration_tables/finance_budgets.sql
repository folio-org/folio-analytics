DROP TABLE IF EXISTS finance_budgets;

CREATE TABLE finance_budgets AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'allocated')::numeric(12,2) AS allocated,
    jsonb_extract_path_text(jsonb, 'allocationFrom')::numeric(12,2) AS allocation_from,
    jsonb_extract_path_text(jsonb, 'allocationTo')::numeric(12,2) AS allocation_to,
    jsonb_extract_path_text(jsonb, 'allowableEncumbrance')::numeric(12,2) AS allowable_encumbrance,
    jsonb_extract_path_text(jsonb, 'allowableExpenditure')::numeric(12,2) AS allowable_expenditure,
    jsonb_extract_path_text(jsonb, 'available')::numeric(12,2) AS available,
    jsonb_extract_path_text(jsonb, 'awaitingPayment')::numeric(12,2) AS awaiting_payment,
    jsonb_extract_path_text(jsonb, 'budgetStatus')::varchar(65535) AS budget_status,
    jsonb_extract_path_text(jsonb, 'cashBalance')::numeric(12,2) AS cash_balance,
    jsonb_extract_path_text(jsonb, 'encumbered')::numeric(12,2) AS encumbered,
    jsonb_extract_path_text(jsonb, 'expenditures')::numeric(12,2) AS expenditures,
    jsonb_extract_path_text(jsonb, 'fiscalYearId')::varchar(36) AS fiscal_year_id,
    jsonb_extract_path_text(jsonb, 'fundId')::varchar(36) AS fund_id,
    jsonb_extract_path_text(jsonb, 'initialAllocation')::numeric(12,2) AS initial_allocation,
    jsonb_extract_path_text(jsonb, 'name')::varchar(65535) AS name,
    jsonb_extract_path_text(jsonb, 'netTransfers')::numeric(12,2) AS net_transfers,
    jsonb_extract_path_text(jsonb, 'overEncumbrance')::numeric(12,2) AS over_encumbrance,
    jsonb_extract_path_text(jsonb, 'overExpended')::numeric(12,2) AS over_expended,
    jsonb_extract_path_text(jsonb, 'totalFunding')::numeric(12,2) AS total_funding,
    jsonb_extract_path_text(jsonb, 'unavailable')::numeric(12,2) AS unavailable,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_finance.budget;

