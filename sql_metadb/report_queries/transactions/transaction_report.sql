/* The report offers the possibility to filter within the transactions according to certain parameters.
 * Therefore the report contains several attributes from the FOLIO finance app.
 * Attention: There can be many transactions in the database. Please make sure you set parameters.
 */

WITH parameters AS (
    SELECT
        -- filters for date ranges
        NULL :: DATE AS start_date_transaction_created,
        NULL :: DATE AS end_date_transaction_created,
        NULL :: DATE AS start_date_transaction_updated,
        NULL :: DATE AS end_date_transaction_updated,
        NULL :: DATE AS start_date_fiscal_year_start,
        NULL :: DATE AS end_date_fiscal_year_start,
        NULL :: DATE AS start_date_fiscal_year_end,
        NULL :: DATE AS end_date_fiscal_year_end,
        --'2023-01-01' :: DATE AS start_date_transaction_created, -- start date day is included in interval
        --'2024-01-01' :: DATE AS end_date_transaction_created, -- end date day is NOT included in interval -> enter next day
        --'2023-01-01' :: DATE AS start_date_transaction_updated, -- start date day is included in interval
        --'2024-01-01' :: DATE AS end_date_transaction_updated, -- end date day is NOT included in interval -> enter next day
        --'2023-01-01' :: DATE AS start_date_fiscal_year_start, -- start date day is included in interval
        --'2024-01-01' :: DATE AS end_date_fiscal_year_start, -- end date day is NOT included in interval -> enter next day
        --'2023-01-01' :: DATE AS start_date_fiscal_year_end, -- start date day is included in interval
        --'2024-01-01' :: DATE AS end_date_fiscal_year_end, -- end date day is NOT included in interval -> enter next day
        --
        -- filters for expense classes
        '' :: VARCHAR AS expense_class_code, -- Enter your expense class code
        '' :: VARCHAR AS expense_class_name, -- Enter your expense class name 
        --
        -- filters for encumbrances
        '' :: VARCHAR AS encumbrance_order_status, -- Enter the status of the order, e.g. Open, Pending, Closed
        '' :: VARCHAR AS encumbrance_order_type, -- Enter the order type, e.g. One-Time, Ongoing
        NULL :: BOOLEAN AS encumbrance_re_encumber, 
        --true :: BOOLEAN AS encumbrance_re_encumber, -- true or false
        '' :: VARCHAR AS encumbrance_status, -- Enter the status of the encumbrance, e.g. Released, Unreleased, Pending
        NULL :: BOOLEAN AS encumbrance_subscription,
        --true :: BOOLEAN AS encumbrance_subscription, -- true or false
        --
        -- filters for finance data
        '' :: VARCHAR AS budget_name, -- Enter your budget name
        '' :: VARCHAR AS budget_status, -- Enter your budget status
        '' :: VARCHAR AS fund_code, -- Enter your fund code
        '' :: VARCHAR AS fund_name, -- Enter your fund name
        '' :: VARCHAR AS fund_status, -- Enter your fund status
        '' :: VARCHAR AS ledger_code, -- Enter your ledger code
        '' :: VARCHAR AS ledger_name, -- Enter your ledger name
        '' :: VARCHAR AS ledger_status, -- Enter your ledger status
        '' :: VARCHAR AS fiscal_year_code, -- Enter your fiscal year code
        '' :: VARCHAR AS fiscal_year_name, -- Enter your fiscal year name
        --
        -- filters on transaction level
        '' :: VARCHAR AS transaction_source, -- Enter the source of the transaction, e.g. User, PoLine, Invoice
        '' :: VARCHAR AS transaction_type -- Enter the type of the transaction, e.g. Credit, Encumbrance, Payment, Pending payment
)
SELECT 
    transaction__t.id AS transaction_id,
    jsonb_extract_path_text(transaction.jsonb, 'metadata', 'createdDate') :: timestamptz AS transaction_created_date,
    jsonb_extract_path_text(transaction.jsonb, 'metadata', 'updatedDate') :: timestamptz AS transaction_updated_date,
    transaction__t.source,  
    transaction__t.transaction_type,
    expense_class__t.code AS expense_class_code,
    expense_class__t.name AS expense_class_name,
    transaction__t.currency,
    transaction__t.amount :: NUMERIC(19,2),
    jsonb_extract_path_text(transaction.jsonb, 'encumbrance', 'amountAwaitingPayment') :: NUMERIC(19,2) AS encumbrance__amount_awaiting_payment,
    jsonb_extract_path_text(transaction.jsonb, 'encumbrance', 'amountExpended') :: NUMERIC(19,2) AS encumbrance__amount_expended,
    jsonb_extract_path_text(transaction.jsonb, 'encumbrance', 'initialAmountEncumbered') :: NUMERIC(19,2) AS encumbrance__initial_amount_encumbered,
    jsonb_extract_path_text(transaction.jsonb, 'encumbrance', 'orderStatus') AS encumbrance__order_status,
    jsonb_extract_path_text(transaction.jsonb, 'encumbrance', 'orderType') AS encumbrance__order_type,
    COALESCE(jsonb_extract_path_text(transaction.jsonb, 'encumbrance', 'reEncumber'), 'false') :: BOOLEAN AS encumbrance__re_encumber,
    jsonb_extract_path_text(transaction.jsonb, 'encumbrance', 'status') AS encumbrance__status,
    COALESCE(jsonb_extract_path_text(transaction.jsonb, 'encumbrance', 'subscription'), 'false') :: BOOLEAN AS encumbrance__subscription,
    finance_funds.fiscal_year_code,
    finance_funds.fiscal_year_name,
    finance_funds.fiscal_year_period_start :: timestamptz,
    finance_funds.fiscal_year_period_end :: timestamptz,
    finance_funds.budget_name,
    finance_funds.budget_status,
    finance_funds.fund_code,
    finance_funds.fund_name,
    finance_funds.fund_status,
    finance_funds.fund_type_name,
    finance_funds.ledger_code,
    finance_funds.ledger_name,
    finance_funds.ledger_status
FROM 
    folio_finance.transaction__t
    LEFT JOIN folio_finance.transaction ON transaction.id = transaction__t.id
    LEFT JOIN folio_finance.expense_class__t ON expense_class__t.id = transaction__t.expense_class_id
    LEFT JOIN folio_derived.finance_funds ON finance_funds.fund_id = transaction__t.from_fund_id
        AND finance_funds.fiscal_year_id = transaction__t.fiscal_year_id
WHERE    
    ((expense_class__t.code = (SELECT expense_class_code FROM parameters)) OR 
        ((SELECT expense_class_code FROM parameters) = ''))
    AND 
    ((expense_class__t.name = (SELECT expense_class_name FROM parameters)) OR 
        ((SELECT expense_class_name FROM parameters) = ''))
    AND 
    ((jsonb_extract_path_text(transaction.jsonb, 'encumbrance', 'orderStatus') = (SELECT encumbrance_order_status FROM parameters)) OR 
        ((SELECT encumbrance_order_status FROM parameters) = ''))
    AND 
    ((jsonb_extract_path_text(transaction.jsonb, 'encumbrance', 'orderType') = (SELECT encumbrance_order_type FROM parameters)) OR 
        ((SELECT encumbrance_order_type FROM parameters) = ''))
    AND 
    ((COALESCE(jsonb_extract_path_text(transaction.jsonb, 'encumbrance', 'reEncumber'), 'false') :: BOOLEAN = (SELECT encumbrance_re_encumber FROM parameters)) OR 
        ((SELECT encumbrance_re_encumber FROM parameters) IS NULL))
    AND 
    ((jsonb_extract_path_text(transaction.jsonb, 'encumbrance', 'status') = (SELECT encumbrance_status FROM parameters)) OR 
        ((SELECT encumbrance_status FROM parameters) = ''))
    AND 
    ((COALESCE(jsonb_extract_path_text(transaction.jsonb, 'encumbrance', 'subscription'), 'false') :: BOOLEAN = (SELECT encumbrance_subscription FROM parameters)) OR 
        ((SELECT encumbrance_subscription FROM parameters) IS NULL))
    AND 
    ((finance_funds.budget_name = (SELECT budget_name FROM parameters)) OR 
        ((SELECT budget_name FROM parameters) = ''))
    AND 
    ((finance_funds.budget_status = (SELECT budget_status FROM parameters)) OR 
        ((SELECT budget_status FROM parameters) = ''))
    AND 
    ((finance_funds.fund_code = (SELECT fund_code FROM parameters)) OR 
        ((SELECT fund_code FROM parameters) = ''))
    AND 
    ((finance_funds.fund_name = (SELECT fund_name FROM parameters)) OR 
        ((SELECT fund_name FROM parameters) = ''))
    AND 
    ((finance_funds.fund_status = (SELECT fund_status FROM parameters)) OR 
        ((SELECT fund_status FROM parameters) = ''))
    AND 
    ((finance_funds.ledger_code = (SELECT ledger_code FROM parameters)) OR 
        ((SELECT ledger_code FROM parameters) = ''))
    AND 
    ((finance_funds.ledger_name = (SELECT ledger_name FROM parameters)) OR 
        ((SELECT ledger_name FROM parameters) = ''))
    AND 
    ((finance_funds.ledger_status = (SELECT ledger_status FROM parameters)) OR 
        ((SELECT ledger_status FROM parameters) = ''))
    AND 
    ((finance_funds.fiscal_year_code = (SELECT fiscal_year_code FROM parameters)) OR 
        ((SELECT fiscal_year_code FROM parameters) = ''))
    AND
    ((finance_funds.fiscal_year_name = (SELECT fiscal_year_name FROM parameters)) OR 
        ((SELECT fiscal_year_name FROM parameters) = ''))
    AND 
    ((transaction__t.source = (SELECT transaction_source FROM parameters)) OR 
        ((SELECT transaction_source FROM parameters) = ''))
    AND 
    ((transaction__t.transaction_type = (SELECT transaction_type FROM parameters)) OR 
        ((SELECT transaction_type FROM parameters) = ''))
    AND 
    ((jsonb_extract_path_text(transaction.jsonb, 'metadata', 'createdDate') :: DATE >= (SELECT start_date_transaction_created FROM parameters) AND
        jsonb_extract_path_text(transaction.jsonb, 'metadata', 'createdDate') :: DATE < (SELECT end_date_transaction_created FROM parameters))
        OR 
        (((SELECT start_date_transaction_created FROM parameters) IS NULL) 
            OR ((SELECT end_date_transaction_created FROM parameters) IS NULL)))
    AND 
    ((jsonb_extract_path_text(transaction.jsonb, 'metadata', 'updatedDate') :: DATE >= (SELECT start_date_transaction_updated FROM parameters) AND
        jsonb_extract_path_text(transaction.jsonb, 'metadata', 'updatedDate') :: DATE < (SELECT end_date_transaction_updated FROM parameters))
        OR 
        (((SELECT start_date_transaction_updated FROM parameters) IS NULL) 
            OR ((SELECT end_date_transaction_updated FROM parameters) IS NULL)))
    AND 
    ((finance_funds.fiscal_year_period_start :: DATE >= (SELECT start_date_fiscal_year_start FROM parameters) AND
        finance_funds.fiscal_year_period_start :: DATE < (SELECT end_date_fiscal_year_start FROM parameters))
        OR 
        (((SELECT start_date_fiscal_year_start FROM parameters) IS NULL) 
            OR ((SELECT end_date_fiscal_year_start FROM parameters) IS NULL)))
    AND 
    ((finance_funds.fiscal_year_period_end :: DATE >= (SELECT start_date_fiscal_year_end FROM parameters) AND
        finance_funds.fiscal_year_period_end :: DATE < (SELECT end_date_fiscal_year_end FROM parameters))
        OR 
        (((SELECT start_date_fiscal_year_end FROM parameters) IS NULL) 
            OR ((SELECT end_date_fiscal_year_end FROM parameters) IS NULL)))
ORDER BY 
    jsonb_extract_path_text(transaction.jsonb, 'metadata', 'updatedDate') DESC
