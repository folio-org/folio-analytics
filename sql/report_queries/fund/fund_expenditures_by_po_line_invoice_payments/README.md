# Fund Expenditures by Purchase Order Line Invoice Payments

fund_expenditures_by_po_line_invoice_payments
 
## PURPOSE
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

## MAIN TABLES INCLUDED
finance_funds\
folio_reporting.finance_transaction_invoices\
finance_groups\
po_lines\

## AGGREGATION
po_line_number, fund_group, fund_name, fund_type, fund_code, fund_description, transaction_type, expense_class

## FILTERS FOR USERS TO SELECT 
invoice_payment_start and invoice_payment_end, fund_group, fund_code, fund_type, purchase_order_line_format, 
expense_class, transaction_type, transaction_fund_code, fiscal_year

