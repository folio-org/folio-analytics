# Invoices Prorated Adjustments Report

## Purpose

This purpose of this report is to provide a summary of what was spent by purchase order line on an invoice line across all the invoices within a particular time period. Prorated invoice line adjustments are included in the invoice line total. The "invoice_line_total_sum" column shows the sum of invoice line totals associated with each purchase order line number. This query only shows invoice line data that is linked to a purchase order. Note that there must be a po line for every invoice line. The results are aggregated by purchase order line id, purchase order line number, invoice_line_total_sum, invoice status, and invoice payment date, and vendor invoice number. Results may be filtered by invoice payment date and invoice status. The invoice line total calculations include everything except non-prorated adjustments to invoices at the invoice level.For a version of this query that provides nonprorated adjustments, see Option C of the ACRL Collection Expenditures reports.

## Parameters

The parameters in the table below can be set in the WITH clause to filter the report output.

| parameter | description | options |
| --- | --- | --- |
| invoice\_payment\_date | date invoice was paid | Set start\_date and end\_date in YYYY-MM-DD format. |
| invoice\_status | status of the invoices to show, which can be open, reviewed, approved, paid, or cancelled | Set &quot;invoice\_status&quot; to &quot;Open,&quot; &quot;Reviewed,&quot; &quot;Approved,&quot; &quot;Paid&quot; or &quot;Cancelled.&quot; |


## Sample Output

| po\_line\_id                         | po\_line\_number | invoice\_line\_total\_sum | invoice\_status | invoice\_payment\_date | vendor\_invoice\_number |
| ------------------------------------ | ---------------- | ------------------------- | --------------- | ---------------------- | ----------------------- |
| 01d8a061-0865-4660-9e5c-7b837544748a | 10004-1          | 15.76                     | Approved        |                        | test1                   |
| 1e4196bb-7856-4b33-aef5-2b2bd0eb70cf | 10000-1          | 12060                     | Paid            | 2/18/2021              | BMJ 2018                |
| 1e4196bb-7856-4b33-aef5-2b2bd0eb70cf | 10000-1          |                           | Reviewed        |                        | BMJ 2019                |

