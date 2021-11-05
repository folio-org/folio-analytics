# Fund Expenditures by Purchase Order line


## Purpose

This report shows fund expenditures by purchase order line. 
For each purchase order line number, the fund data attributes are  
shown alongside the purchase order line transaction amount. Fund expenditures 
can be viewed by fund group, fund name, fund type, fund code, 
purchase order line format, transaction type, expense class, and fiscal year.
There can be more than one fund distribution for each purchase order line.

The transaction_fund_code is the fund code associated with each 
purchase order line transaction. This column captures "Payment" and
"Credit" transactions that are either to the fund or from the fund.

The fund_transaction_source shows whether the transaction was posted 
"to a fund" or "from a fund."

When the transaction_type parameter is "Payment," the transaction_amount 
is shown as a positive value. When the transaction_type
parameter is "Credit," the transaction_amount has been altered to show a
negative value. The system does not show a negative value for credits by default.
Showing credits as a negative value is a preference for some institutions.

## Main Tables Included

finance_funds\
finance_fiscal_years\
finance_transaction_invoices (derived)\
finance_group_fund_fiscal_years\
finance_groups\
po_lines\

## Aggregation

po_line_number, fund_group, fund_name, fund_type, fund_code, fund_description, transaction_type, expense_class, fiscal_year_code 

## Filters for Users to Select

invoice_payment_start and invoice_payment_end, fund_group, fund_code, fund_type, purchase_order_line_format, 
expense_class, transaction_type, transaction_fund_code, fiscal_year
