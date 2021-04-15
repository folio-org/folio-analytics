/*
PURPOSE
This report shows fund expenditures as the sum of the transaction amount by purchase order line grouped by fund and expense class. 
Fund expenditures can be viewed by fund name, fund type, fund code, purchase order line format, transaction type, expense class, and fiscal year.

MAIN TABLES INCLUDED
finance_funds
finance_fiscal_years
finance_transaction_invoices (derived)
finance_group_fund_fiscal_years
po_lines

AGGREGATION
fund_id, fund_name, fund_type_name, fund_code, fund_description, transaction_type, expense_class, fiscal_year_code 

FILTERS FOR USERS TO SELECT 
invoice_payment_start and invoice_payment_end, fiscal_year, fund_code, fund_type, purchase_order_line_format, transaction_type
 
*/

/* Enter parameters or leave blank to include all for each filter below. For dates, you may use the invoice payment start and end dates, fiscal year, or both. */
WITH parameters AS (
    SELECT
        /* enter invoice payment start date and end date in YYYY-MM-DD format */
    	--'2000-01-01' :: DATE AS start_date,
        --'2021-01-01' :: DATE AS end_date,
        /* enter FY## where #### is the 4 digits of the fiscal year code */
        ''::VARCHAR AS fiscal_year_filter,
        /* enter one or more fund codes separated by commas, as in 'math, music' */
        ''::VARCHAR AS fund_code_filter,
        /* enter one or more fund types separated by commas, as in 'restricted, unrestricted' */
        ''::VARCHAR AS fund_type_filter,
        /* enter purchase order line order format as 'Physical Resource, Electronic Resource, P/E Mix, or Other' */
        ''::VARCHAR AS order_format_filter,
        /* enter one or more expense class names separated by commas, as in 'Electronic, Print'*/
        ''::VARCHAR AS expense_class_filter,
        /* enter transaction type format as 'payment','pending payment', or 'payment,pending payment' */
        ''::VARCHAR AS transaction_type_filter
)

SELECT
	fitrin.transaction_from_fund_id AS fund_id,
	fitrin.transaction_from_fund_name AS fund_name,
	finfuntyp.name AS fund_type_name,
	fitrin.transaction_from_fund_code AS fund_code,
	finfun.description AS fund_description,
	fitrin.transaction_type AS transaction_type,
	finexpclass.name AS expense_class,
	finyear.code AS fiscal_year_code,
	SUM(fitrin.transaction_amount) AS transaction_amount

FROM finance_funds AS finfun
LEFT JOIN folio_reporting.finance_transaction_invoices AS fitrin ON finfun.id = fitrin.transaction_from_fund_id
LEFT JOIN finance_fund_types AS finfuntyp ON finfuntyp.id = finfun.fund_type_id
LEFT JOIN finance_expense_classes AS finexpclass ON finexpclass.id = fitrin.transaction_expense_class_id
LEFT JOIN finance_fiscal_years AS finyear ON finyear.id = fitrin.transaction_fiscal_year_id
LEFT JOIN po_lines AS pol ON pol.id = fitrin.po_line_id

WHERE
	
	--(fitrin.invoice_payment_date::date >= (SELECT start_date FROM parameters)) 
	--AND (fitrin.invoice_payment_date::date < (SELECT end_date FROM parameters))

--AND 	
	((finyear.code = (SELECT fiscal_year_filter FROM parameters)) OR 
		((SELECT fiscal_year_filter FROM parameters) = ''))
AND 	
	((fitrin.transaction_from_fund_code = (SELECT fund_code_filter FROM parameters)) OR 
		((SELECT fund_code_filter FROM parameters) = ''))
AND 	
	((finfuntyp.name = (SELECT fund_type_filter FROM parameters)) OR 
		((SELECT fund_type_filter FROM parameters) = ''))		
AND 	
	((pol.order_format = (SELECT order_format_filter FROM parameters)) OR 
		((SELECT order_format_filter FROM parameters) = ''))
AND 	
	((finexpclass.name = (SELECT expense_class_filter FROM parameters)) OR 
		((SELECT expense_class_filter FROM parameters) = ''))
AND 	
	((fitrin.transaction_type = (SELECT transaction_type_filter FROM parameters)) OR 
		((SELECT transaction_type_filter FROM parameters) = ''))
     
GROUP BY
	fund_id,
	fund_name,
	fund_type_name,
	fund_code,
	fund_description,
	transaction_type,
	expense_class,
	fiscal_year_code
	;

