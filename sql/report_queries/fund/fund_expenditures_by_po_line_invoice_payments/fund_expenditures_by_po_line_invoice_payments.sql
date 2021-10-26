/* fund_expenditures_by_po_line_invoice_payments
 
PURPOSE
This report shows fund expenditures by purchase order line within 
a given invoice payment date range. For each purchase order line number, 
the fund data attributes are shown alongside the purchase order line transaction amount. 
Fund expenditures can be viewed by fund group, fund name, fund type, fund code, 
purchase order line format, transaction type, and expense class. There can be 
more than one fund distribution for each purchase order line.

The transaction_fund_code is the fund code associated with each 
purchase order line transaction. This column captures "Payment" and
"Credit" transactions that are either to the fund or from the fund.

The fund_transaction_source shows whether the transaction was posted 
"to a fund" or "from a fund."

Transaction types are limited to just "Payments" and "Credits."
When the transaction_type parameter is "Payment," the transaction_amount 
is shown as a positive value. When the transaction_type
parameter is "Credit," the transaction_amount has been altered to show a
negative value. The system does not show a negative value for credits by default.
Showing credits as a negative value is a preference for some institutions.
The "transaction amount source" has been added for those institutions who would 
prefer to see the unmodified original transaction amount.

MAIN TABLES INCLUDED
finance_funds
folio_reporting.finance_transaction_invoices
finance_groups
po_lines

AGGREGATION
po_line_number, fund_group, fund_name, fund_type, fund_code, fund_description, transaction_type, expense_class

FILTERS FOR USERS TO SELECT 
invoice_payment_start and invoice_payment_end, fund_group, fund_code, fund_type, purchase_order_line_format, 
expense_class, transaction_type, transaction_fund_code, fiscal_year

/* */Enter parameters or leave blank to include all for each filter below. For dates, you may use the invoice payment start and end dates, fiscal year, or both. */
WITH parameters AS (
    SELECT
        /* enter invoice payment start date and end date in YYYY-MM-DD format */
    	'2021-07-01' :: DATE AS start_date,
        '2022-06-30' :: DATE AS end_date,
        /* enter fund group name as 'Central, Humanities, Area Studies, Rare & Distinctive, Law, Sciences, or Social Sciences' */
        ''::VARCHAR AS fund_group_filter,
        /* enter one or more fund codes separated by commas, as in 'math, music' */
        ''::VARCHAR AS fund_code_filter,
        /* enter one or more fund types separated by commas, as in 'restricted, unrestricted' */
        ''::VARCHAR AS fund_type_filter,
        /* enter purchase order line order format as 'Physical Resource, Electronic Resource, P/E Mix, or Other' */
        ''::VARCHAR AS order_format_filter,
         /* enter one or more expense class names separated by commas, as in 'Electronic, Print'*/
        ''::VARCHAR AS expense_class_filter,
        /* enter transaction type format as 'payment','pending payment', or 'payment,pending payment' */
        ''::VARCHAR AS  transaction_type_filter,
         /* enter transaction fund code as XXXX */
        ''::VARCHAR AS transaction_fund_code_filter
),
fitrin_wrap AS (
    -- wrapping transactions to_fund and from_fund to one fund_id
    	SELECT
    		fitrin.transaction_id,
	    	fitrin.invoice_payment_date,
	    	fitrin.transaction_type,
	    	fitrin.transaction_expense_class_id,
	    	fitrin.transaction_fiscal_year_id,
	    	fitrin.po_line_id,
	      	CASE 
	      		WHEN fitrin.transaction_from_fund_id  IS NOT NULL AND fitrin.transaction_to_fund_id IS NULL THEN 'TRANSACTION FROM FUND'
	      		WHEN fitrin.transaction_from_fund_id IS NULL AND fitrin.transaction_to_fund_id IS NOT NULL THEN 'TRANSACTION TO FUND'
	      		ELSE 'TRANSACTION WITH FROM AND TO FUND' END AS transaction_fund_from_to,
	      	CASE 
	      		WHEN fitrin.transaction_from_fund_id IS NOT NULL AND fitrin.transaction_to_fund_id IS NULL THEN fitrin.transaction_from_fund_id
	      		WHEN fitrin.transaction_from_fund_id IS NULL AND fitrin.transaction_to_fund_id IS NOT NULL THEN fitrin.transaction_to_fund_id
	      		ELSE 'has from and to fund' END AS fund_id,
	      	CASE 
	      		WHEN fitrin.transaction_from_fund_code IS NOT NULL AND fitrin.transaction_to_fund_code IS NULL THEN fitrin.transaction_from_fund_code
	      		WHEN fitrin.transaction_from_fund_code IS NULL AND fitrin.transaction_to_fund_code IS NOT NULL THEN fitrin.transaction_to_fund_code
	      		ELSE 'has from and to fund' END AS fund_code,   	
	      	CASE WHEN fitrin.transaction_type = 'Credit' AND fitrin.transaction_amount >.0001 THEN fitrin.transaction_amount *-1 
		    	ELSE fitrin.transaction_amount END AS transaction_amount,    
			fitrin.transaction_amount AS transaction_amount_source	    	
 FROM
        	folio_reporting.finance_transaction_invoices AS fitrin
)

SELECT
	CURRENT_DATE,	
	pol.po_line_number AS po_line_number,
	finfun.id AS finance_fund_id,
	fingrp.name AS fund_group,
	finfun.name AS fund_name,
	finfuntyp.name AS fund_type,
	finfun.code AS fund_code,
	finfun.description AS fund_description,
	fitrin.transaction_type AS transaction_type,
	finexpclass.name AS expense_class,
	fitrin.fund_code AS transaction_fund_code,
	fitrin.transaction_fund_from_to AS fund_transaction_source,
	fitrin.transaction_amount AS po_line_transaction_amount,
	fitrin.transaction_amount_source AS transaction_amount_source

FROM finance_funds AS finfun
LEFT JOIN fitrin_wrap AS fitrin ON finfun.id = fitrin.fund_id
LEFT JOIN finance_fund_types AS finfuntyp ON finfuntyp.id = finfun.fund_type_id
LEFT JOIN finance_expense_classes AS finexpclass ON finexpclass.id = fitrin.transaction_expense_class_id
LEFT JOIN po_lines AS pol ON pol.id = fitrin.po_line_id
LEFT JOIN finance_group_fund_fiscal_years AS fingrpfund ON fingrpfund.fund_id = finfun.id
LEFT JOIN finance_groups AS fingrp ON fingrp.id = fingrpfund.group_id

WHERE	
	(fitrin.transaction_type = 'Credit') 
	OR (fitrin.transaction_type = 'Payment')	
	AND	(fitrin.invoice_payment_date::date >= (SELECT start_date FROM parameters)) 
	AND (fitrin.invoice_payment_date::date < (SELECT end_date FROM parameters))

	AND ((finfuntyp.name = (SELECT fund_type_filter FROM parameters)) OR 
		((SELECT fund_type_filter FROM parameters) = ''))		
	AND ((fingrp.name = (SELECT fund_group_filter FROM parameters)) OR 
		((SELECT fund_group_filter FROM parameters) = ''))				
	AND ((finexpclass.name = (SELECT expense_class_filter FROM parameters)) OR 
		((SELECT expense_class_filter FROM parameters) = ''))
	AND ((fitrin.transaction_type = (SELECT transaction_type_filter FROM parameters)) OR 
		((SELECT transaction_type_filter FROM parameters) = ''))
	AND ((fitrin.fund_code = (SELECT transaction_fund_code_filter FROM parameters)) OR 
		((SELECT transaction_fund_code_filter FROM parameters) = '')) 
     
GROUP BY
	pol.po_line_number,
	finance_fund_id,
	fund_group,
	fund_name,
	fund_type,
	fund_code,
	fund_description,
	fitrin.transaction_type,
	expense_class,
	fitrin.transaction_id,
	fitrin.fund_code,
	fitrin.transaction_fund_from_to,
	fitrin.transaction_amount,
	fitrin.transaction_amount_source
	;
	
