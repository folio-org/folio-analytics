--This query provides invoice transation amount that was not automatically distributed to the Invoice Lines (e.g. not prorated adjustment)
--This query may be used in conjunction with the ACRL Collection Expenditures B to provide a total amount of expenditures but keeping the transactions not distributed in the Invoice Lines separate. 

/* FIELDS TO INCLUDE:
 	Derived Table folio_reporting.finance_transactions_invoices:
 		Transaction ID
 		Transaction invoice ID
 		Transaction invoice line ID
 		Transaction amount
 		Transaction Currency
 		Transaction Type
 		
 	Invoice Invoices table:
  		Invoice ID
  		Approval date
  		Payment date	 
  		                
    	Finance Fiscal Years table
     		Fiscal year ID
     		Fiscal year code
 */
WITH parameters AS (
    SELECT
    ''::VARCHAR AS fiscal_year_code, --ex: FY20201, FY2022 etc. 
    '2000-01-01'::DATE AS payment_date_start_date, --ex:2000-01-01 - Change date as needed
    '2021-12-01'::DATE AS payment_date_end_date -- ex:2020-12-31 - Change date as needed
)
SELECT 
	fti.transaction_id AS transaction_id,
	CAST(inv.approval_date AS date) AS inv_approval_date,
	CAST(inv.payment_date AS date) AS inv_payment_date,
	fti.invoice_id AS transaction_invoice_id,
	fy.code AS fiscal_year_code,
	fti.transaction_expense_class_id,
	fti.invoice_line_id AS transaction_invoice_line_id,
	fti.transaction_amount AS transaction_amount,
	fti.transaction_currency AS transaction_currency,
	fti.transaction_type AS transaction_type		
FROM 
	folio_reporting.finance_transaction_invoices AS fti
	LEFT JOIN invoice_invoices AS inv ON fti.invoice_id = inv.id
	LEFT JOIN finance_fiscal_years AS fy ON fy.id = fti.transaction_fiscal_year_id
WHERE 
	fti.invoice_line_id IS NULL 
	AND fti.invoice_id IS NOT NULL
	AND fti.transaction_type LIKE 'Payment'
	AND (fy.code = (SELECT fiscal_year_code FROM parameters) OR (SELECT fiscal_year_code FROM parameters) = '')
	AND (inv.payment_date::date >= (SELECT payment_date_start_date FROM parameters))
	AND (inv.payment_date::date < (SELECT payment_date_end_date FROM parameters));



