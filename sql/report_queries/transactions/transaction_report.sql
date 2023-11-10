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
    finance_transactions.id AS transaction_id,
    finance_transactions.metadata__created_date AS transaction_created_date,
    finance_transactions.metadata__updated_date AS transaction_updated_date,
    finance_transactions.source,  
    finance_transactions.transaction_type,    
    finance_expense_classes.code AS expense_class_code,
    finance_expense_classes.name AS expense_class_name,
    finance_transactions.currency,
    finance_transactions.amount,
    finance_transactions.encumbrance__amount_awaiting_payment,
    finance_transactions.encumbrance__amount_expended,
    finance_transactions.encumbrance__initial_amount_encumbered, 
    finance_transactions.encumbrance__order_status,
    finance_transactions.encumbrance__order_type,
    COALESCE(finance_transactions.encumbrance__re_encumber, 'false') :: BOOLEAN AS encumbrance__re_encumber,  
    finance_transactions.encumbrance__status,
    COALESCE(finance_transactions.encumbrance__subscription, 'false') :: BOOLEAN AS encumbrance__subscription, 
    finance_funds.fiscal_year_code,
    finance_funds.fiscal_year_name,
    finance_funds.fiscal_year_period_start,
    finance_funds.fiscal_year_period_end,
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
    public.finance_transactions 
    LEFT JOIN public.finance_expense_classes ON finance_expense_classes.id = json_extract_path_text(finance_transactions.data, 'expenseClassId')
    LEFT JOIN folio_reporting.finance_funds_ext AS finance_funds ON finance_funds.fund_id = finance_transactions.from_fund_id
        AND finance_funds.fiscal_year_id = finance_transactions.fiscal_year_id
WHERE    
    ((finance_expense_classes.code = (SELECT expense_class_code FROM parameters)) OR 
        ((SELECT expense_class_code FROM parameters) = ''))
    AND 
    ((finance_expense_classes.name = (SELECT expense_class_name FROM parameters)) OR 
        ((SELECT expense_class_name FROM parameters) = ''))
    AND 
    ((finance_transactions.encumbrance__order_status = (SELECT encumbrance_order_status FROM parameters)) OR 
        ((SELECT encumbrance_order_status FROM parameters) = ''))
    AND 
    ((finance_transactions.encumbrance__order_type = (SELECT encumbrance_order_type FROM parameters)) OR 
        ((SELECT encumbrance_order_type FROM parameters) = ''))
    AND 
    ((COALESCE(finance_transactions.encumbrance__re_encumber, 'false') :: BOOLEAN = (SELECT encumbrance_re_encumber FROM parameters)) OR 
        ((SELECT encumbrance_re_encumber FROM parameters) IS NULL))
    AND 
    ((finance_transactions.encumbrance__status = (SELECT encumbrance_status FROM parameters)) OR 
        ((SELECT encumbrance_status FROM parameters) = ''))
    AND 
    ((COALESCE(finance_transactions.encumbrance__subscription, 'false') :: BOOLEAN = (SELECT encumbrance_subscription FROM parameters)) OR 
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
    ((finance_transactions.source = (SELECT transaction_source FROM parameters)) OR 
        ((SELECT transaction_source FROM parameters) = ''))
    AND 
    ((finance_transactions.transaction_type = (SELECT transaction_type FROM parameters)) OR 
        ((SELECT transaction_type FROM parameters) = ''))
    AND 
    ((finance_transactions.metadata__created_date :: DATE >= (SELECT start_date_transaction_created FROM parameters) AND
        finance_transactions.metadata__created_date :: DATE < (SELECT end_date_transaction_created FROM parameters))
        OR 
        (((SELECT start_date_transaction_created FROM parameters) IS NULL) 
            OR ((SELECT end_date_transaction_created FROM parameters) IS NULL)))
    AND 
    ((finance_transactions.metadata__updated_date :: DATE >= (SELECT start_date_transaction_updated FROM parameters) AND
        finance_transactions.metadata__updated_date :: DATE < (SELECT end_date_transaction_updated FROM parameters))
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
    finance_transactions.metadata__updated_date DESC
