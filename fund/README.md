# Fund Expenditure Summary

## Purpose

This report shows fund expenditures as the sum of the transaction amount by purchase order line grouped by fund and expense class. Fund expenditures can be viewed by fund name, fund type, fund code, purchase order line format, transaction type, expense class, and fiscal year. 

## Parameters
The "is_package" field from the purchase order lines table uses NOT to exclude packages. Users can uncomment the "is_package" field in the WHERE clause when there is package data to exclude. The WITH clause provides filters for invoice_payment_date, fiscal_year, fund_code, fund_type, purchase_order_line_format, and transaction_type.

## Aggregation
Data are aggregated by fund_id, fund_name, fund_type_name, fund_code, fund_description, transaction_type, expense_class, and fiscal_year_code.

