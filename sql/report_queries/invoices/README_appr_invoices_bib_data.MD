# Approved invoices with bib data  
<p>
  
## Brief description:
This query provides the list of approved invoices within a date range along with vendor name, finance group name, vendor invoice number, fund details, purchase order details, language, instance subject, and bibliographic format
<p>
  
## Main tables used:
finance_transaction_invoices
  <br>
finance_funds 
  <br>
finance_ledgers
  <br>
finance_group_fund_fiscal_years
  <br>
finance_fiscal_years 
  <br>
finance_groups
  <br>
inventory_instances
  <br>
invoice_invoices
  <br>
invoice_lines
  <br>
po_purchase_orders
  <br>
po_lines
  <br>
srs_marctab
  <br>
srs_records	
<p>
  
## Derived tables used:
  
folio_reporting.finance_transaction_invoices
  <br>
folio_reporting.instance_ext
  <br>
folio_reporting.po_lines_locations 

## Filters/parameters:

payment_date_start_date
  <br>
payment_date_end_date
  <br>
transaction_fund_code
  <br>
transaction_finance_group_name
  <br>
transaction_ledger_name
  <br>
fiscal_year_code
  <br>
po_number
  
