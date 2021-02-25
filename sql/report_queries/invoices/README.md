# Invoices Report

## Purpose

This purpose of this report is to provide a summary of what was spent by purchase order line

on an invoice line across all the invoices within a particular time period. Invoice line adjustments are included in the invoice line total. The &quot;invoice\_line\_total\_sum&quot; column shows the sum of invoice line totals associated with each purchase order line number. This query only shows invoice line data that is linked to a purchase order. The output is aggregated by purchase order line id, purchase order line number, and invoice status.

## Parameters

The parameters in the table below can be set in the WITH clause to filter the report output.

| parameter | description | options |
| --- | --- | --- |
| invoice\_approval\_date | date invoice was approved | Set start\_date and end\_date in YYYY-MM-DD format. |
| invoice\_status | status of the invoices to show, which can be open, reviewed, approved, paid, or cancelled | Set &quot;invoice\_status&quot; to &quot;Open,&quot; &quot;Reviewed,&quot; &quot;Approved,&quot; &quot;Paid&quot; or &quot;Cancelled.&quot; |


## Sample Output

| **po\_line\_id** | **po\_line\_number** | **invoice\_line\_total\_sum** | **invoice\_status** |
| --- | --- | --- | --- |
| 5df56e2f-9bd4-49b5-9e89-97737cadd2fe | 10003-1 | 25 | Paid |
| 662b2b4f-6d62-43f4-9f7c-39e6a0152614 | 10002-1 | 25 | Paid |

## Future Updates

The &quot;paymentDate&quot; field, which captures the date an invoice was paid, is currently in development. This element should be added to the query as soon as it becomes available.
